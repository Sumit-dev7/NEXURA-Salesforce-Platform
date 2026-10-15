
public with sharing class NexuraCustomerService {

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
}
