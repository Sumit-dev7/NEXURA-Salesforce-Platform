
public with sharing class NexuraCollectionUtils {

    public static List<String> addCustomerName(
        List<String> names,
        String customerName
    ) {
        if (names == null) {
            names = new List<String>();
        }

        if (String.isNotBlank(customerName)) {
            names.add(customerName);
        }

        return names;
    }

    public static Set<String> addCustomerType(
        Set<String> types,
        String customerType
    ) {
        if (types == null) {
            types = new Set<String>();
        }

        if (String.isNotBlank(customerType)) {
            types.add(customerType);
        }

        return types;
    }

    public static Account findCustomer(
        Map<Id, Account> customersById,
        Id customerId
    ) {
        if (customersById == null || customerId == null) {
            return null;
        }

        return customersById.get(customerId);
    }
}
