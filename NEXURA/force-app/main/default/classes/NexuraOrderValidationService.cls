
public with sharing class NexuraOrderValidationService {

    // Stores the order validation result
    public class ValidationResult {
        public Boolean valid { get; set; }
        public String message { get; set; }
        public Id orderId { get; set; }

        public ValidationResult(
            Boolean valid,
            String message,
            Id orderId
        ) {
            this.valid = valid;
            this.message = message;
            this.orderId = orderId;
        }
    }

    // Validates an order before processing
    public static ValidationResult validateOrder(Id orderId) {

        if (orderId == null) {
            return new ValidationResult(
                false, 'Order ID is required.', null
            );
        }

        List<Order> orders = [
            SELECT Id, AccountId, Status
            FROM Order
            WHERE Id = :orderId
            LIMIT 1
        ];

        if (orders.isEmpty()) {
            return new ValidationResult(
                false, 'Order was not found or is not accessible.',
                orderId
            );
        }

        Order currentOrder = orders[0];

        if (currentOrder.Status != 'Draft') {
            return new ValidationResult(
                false, 'Only Draft orders can be processed.',
                currentOrder.Id
            );
        }

        NexuraCustomerVerificationService.VerificationResult
            customerResult =
            NexuraCustomerVerificationService.verifyCustomer(
                currentOrder.AccountId
            );

        if (!customerResult.eligible) {
            return new ValidationResult(
                false,
                'Customer validation failed: ' + customerResult.message,
                currentOrder.Id
            );
        }

        List<OrderItem> orderItems = [
            SELECT Id, Quantity, UnitPrice,
                   PricebookEntry.Product2.Name,
                   PricebookEntry.Product2.IsActive
            FROM OrderItem
            WHERE OrderId = :currentOrder.Id
        ];

        if (orderItems.isEmpty()) {
            return new ValidationResult(
                false, 'Order must contain at least one product.',
                currentOrder.Id
            );
        }

        for (OrderItem item : orderItems) {

            if (item.Quantity == null || item.Quantity <= 0) {
                return new ValidationResult(
                    false, 'Product quantity must be greater than zero.',
                    currentOrder.Id
                );
            }

            if (item.UnitPrice == null || item.UnitPrice < 0) {
                return new ValidationResult(
                    false, 'Product unit price cannot be negative.',
                    currentOrder.Id
                );
            }

            if (!item.PricebookEntry.Product2.IsActive) {
                return new ValidationResult(
                    false,
                    'Inactive product: ' +
                    item.PricebookEntry.Product2.Name,
                    currentOrder.Id
                );
            }
        }

        return new ValidationResult(
            true,
            'Order validation successful. The order is ready for processing.',
            currentOrder.Id
        );
    }
}
