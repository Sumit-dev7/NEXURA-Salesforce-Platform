global class NexuraInventoryReconciliationBatch
    implements Database.Batchable<SObject> {

    // Selects inventory records for reconciliation
    global Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator([
            SELECT Id, Product__c, Quantity_on_Hand__c,
                   Reserved_Quantity__c, Available_Quantity__c,
                   Low_Stock__c
            FROM NEXURA_Inventory__c
        ]);
    }

    // Examines each batch of inventory records
    global void execute(
        Database.BatchableContext context,
        List<NEXURA_Inventory__c> scope
    ) {
        for (NEXURA_Inventory__c row : scope) {
            Decimal onHand = row.Quantity_on_Hand__c == null
                ? 0 : row.Quantity_on_Hand__c;
            Decimal reserved = row.Reserved_Quantity__c == null
                ? 0 : row.Reserved_Quantity__c;
            Decimal available = onHand - reserved;

            System.debug(
                'Inventory ' + row.Id +
                ', calculated available: ' + available +
                ', formula available: ' + row.Available_Quantity__c +
                ', low stock: ' + row.Low_Stock__c
            );
        }
    }

    global void finish(Database.BatchableContext context) {
        System.debug('Inventory reconciliation scan completed.');
    }
}