public with sharing class NexuraInventoryReservationService {

    public class ReservationResult {
        public Boolean success { get; set; }
        public String message { get; set; }

        public ReservationResult(Boolean success, String message) {
            this.success = success;
            this.message = message;
        }
    }

    // Reserves stock for an order
    public static ReservationResult reserveOrder(Id orderId) {
        if (orderId == null) {
            return new ReservationResult(false, 'Order ID is required.');
        }

        List<OrderItem> items = [
            SELECT Id, Quantity, PricebookEntry.Product2Id
            FROM OrderItem
            WHERE OrderId = :orderId
        ];

        if (items.isEmpty()) {
            return new ReservationResult(false, 'Order has no products.');
        }

        Map<Id, Decimal> requiredByProduct = new Map<Id, Decimal>();

        for (OrderItem item : items) {
            Id productId = item.PricebookEntry.Product2Id;

            if (productId == null || item.Quantity == null ||
                item.Quantity <= 0) {
                return new ReservationResult(
                    false, 'Invalid product or quantity.'
                );
            }

            Decimal required = requiredByProduct.containsKey(productId)
                ? requiredByProduct.get(productId) : 0;

            requiredByProduct.put(productId, required + item.Quantity);
        }

        // Lock inventory records to reduce concurrent over-reservation
        List<NEXURA_Inventory__c> inventoryRows = [
            SELECT Id, Product__c, Quantity_on_Hand__c,
                   Reserved_Quantity__c
            FROM NEXURA_Inventory__c
            WHERE Product__c IN :requiredByProduct.keySet()
            ORDER BY Id
            FOR UPDATE
        ];

        Map<Id, NEXURA_Inventory__c> inventoryByProduct =
            new Map<Id, NEXURA_Inventory__c>();

        for (NEXURA_Inventory__c row : inventoryRows) {
            if (!inventoryByProduct.containsKey(row.Product__c)) {
                inventoryByProduct.put(row.Product__c, row);
            }
        }

        for (Id productId : requiredByProduct.keySet()) {
            if (!inventoryByProduct.containsKey(productId)) {
                return new ReservationResult(
                    false, 'Inventory record not found for product ' + productId
                );
            }

            NEXURA_Inventory__c row = inventoryByProduct.get(productId);
            Decimal onHand = row.Quantity_on_Hand__c == null
                ? 0 : row.Quantity_on_Hand__c;
            Decimal reserved = row.Reserved_Quantity__c == null
                ? 0 : row.Reserved_Quantity__c;

            if (onHand - reserved < requiredByProduct.get(productId)) {
                return new ReservationResult(
                    false, 'Insufficient available inventory.'
                );
            }
        }

        // Update only after every product passes validation
        for (Id productId : requiredByProduct.keySet()) {
            NEXURA_Inventory__c row = inventoryByProduct.get(productId);
            Decimal reserved = row.Reserved_Quantity__c == null
                ? 0 : row.Reserved_Quantity__c;

            row.Reserved_Quantity__c =
                reserved + requiredByProduct.get(productId);
        }

        update inventoryRows;

        return new ReservationResult(true, 'Inventory reserved successfully.');
    }
}