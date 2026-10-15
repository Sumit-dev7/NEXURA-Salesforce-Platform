
public with sharing class NexuraCustomerCollectionService {

    // LIST: Return customer names in a list
    public static List<String> getCustomerNames(
        List<Account> customers
    ) {
        List<String> names = new List<String>();

        if (customers == null) {
            return names;
        }

        for (Account customer : customers) {
            if (customer != null && customer.Name != null) {
                names.add(customer.Name);
            }
        }

        return names;
    }

    // SET: Return unique customer types
    public static Set<String> getUniqueCustomerTypes(
        List<Account> customers
    ) {
        Set<String> customerTypes = new Set<String>();

        if (customers == null) {
            return customerTypes;
        }

        for (Account customer : customers) {
            if (customer != null &&
                String.isNotBlank(customer.Customer_Type__c)) {
                customerTypes.add(customer.Customer_Type__c);
            }
        }

        return customerTypes;
    }

    // MAP: Map each Account ID to its Account record
    public static Map<Id, Account> getCustomersById(
        List<Account> customers
    ) {
        Map<Id, Account> customersById =
            new Map<Id, Account>();

        if (customers == null) {
            return customersById;
        }

        for (Account customer : customers) {
            if (customer != null && customer.Id != null) {
                customersById.put(customer.Id, customer);
            }
        }

        return customersById;
    }
}
