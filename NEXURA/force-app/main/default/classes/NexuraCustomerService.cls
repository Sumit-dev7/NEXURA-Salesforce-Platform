
public with sharing class NexuraCustomerService {

    // Method 1: Get up to 50 customers
    public static List<Account> getCustomers() {

        List<Account> customers = [
            SELECT Id, Name, Customer_Number__c,
                   Customer_Type__c, Customer_Status__c
            FROM Account
            ORDER BY Name
            LIMIT 50
        ];

        return customers;
    }

    // Method 2: Get customers by type
    public static List<Account> getCustomersByType(
        String customerType
    ) {

        List<Account> customers = [
            SELECT Id, Name, Customer_Number__c,
                   Customer_Type__c, Customer_Status__c
            FROM Account
            WHERE Customer_Type__c = :customerType
            ORDER BY Name
            LIMIT 50
        ];

        return customers;
    }

    // Method 3: Get customers by type and status
    public static List<Account> getCustomersByTypeAndStatus(
        String customerType,
        String customerStatus
    ) {

        List<Account> customers = [
            SELECT Id, Name, Customer_Number__c,
                   Customer_Type__c, Customer_Status__c
            FROM Account
            WHERE Customer_Type__c = :customerType
            AND Customer_Status__c = :customerStatus
            ORDER BY Name
            LIMIT 50
        ];

        return customers;
    }
}
