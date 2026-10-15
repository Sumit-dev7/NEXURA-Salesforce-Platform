public with sharing class NexuraOrderLifecycleHandler {

    // Checks Draft-to-Activated transitions
    public static void validateActivation(
        List<Order> newOrders,
        Map<Id, Order> oldMap
    ) {
        Set<Id> candidateOrderIds = new Set<Id>();

        for (Order currentOrder : newOrders) {
            Order oldOrder = oldMap.get(currentOrder.Id);

            if (oldOrder.Status == 'Draft' &&
                currentOrder.Status == 'Activated') {
                candidateOrderIds.add(currentOrder.Id);
            }
        }

        if (candidateOrderIds.isEmpty()) {
            return;
        }

        Set<Id> ordersWithItems = new Set<Id>();

        for (OrderItem item : [
            SELECT OrderId
            FROM OrderItem
            WHERE OrderId IN :candidateOrderIds
        ]) {
            ordersWithItems.add(item.OrderId);
        }

        for (Order currentOrder : newOrders) {
            if (candidateOrderIds.contains(currentOrder.Id) &&
                !ordersWithItems.contains(currentOrder.Id)) {
                currentOrder.addError(
                    'An Order must contain at least one product before activation.'
                );
            }
        }
    }
}