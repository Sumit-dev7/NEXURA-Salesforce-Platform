
@IsTest
private class NexuraCustomerVerificationServiceTest {

    // Creates test customer records
    @TestSetup
    static void createTestData() {
        List<Account> customers = new List<Account>{
            new Account(
                Name = 'NEXURA Active Test Customer',
                Customer_Type__c = 'Individual',
                Customer_Status__c = 'Active'
            ),
            new Account(
                Name = 'NEXURA Inactive Test Customer',
                Customer_Type__c = 'Business',
                Customer_Status__c = 'Inactive'
            )
        };

        insert customers;
    }

    // Tests an active customer
    @IsTest
    static void testActiveCustomer() {
        Account customer = [
            SELECT Id, Name
            FROM Account
            WHERE Name = 'NEXURA Active Test Customer'
            LIMIT 1
        ];

        Test.startTest();
        NexuraCustomerVerificationService.VerificationResult result =
            NexuraCustomerVerificationService.verifyCustomer(customer.Id);
        Test.stopTest();

        System.assertEquals(true, result.eligible);
        System.assertEquals(customer.Id, result.customerId);
        System.assertEquals(customer.Name, result.customerName);
    }

    // Tests an inactive customer
    @IsTest
    static void testInactiveCustomer() {
        Account customer = [
            SELECT Id
            FROM Account
            WHERE Name = 'NEXURA Inactive Test Customer'
            LIMIT 1
        ];

        NexuraCustomerVerificationService.VerificationResult result =
            NexuraCustomerVerificationService.verifyCustomer(customer.Id);

        System.assertEquals(false, result.eligible);
        System.assertEquals(
            'Customer is not active. Order processing is not allowed.',
            result.message
        );
    }

    // Tests a null Account ID
    @IsTest
    static void testNullCustomerId() {
        NexuraCustomerVerificationService.VerificationResult result =
            NexuraCustomerVerificationService.verifyCustomer(null);

        System.assertEquals(false, result.eligible);
        System.assertEquals('Customer Account ID is required.', result.message);
    }

    // Tests a deleted customer
    @IsTest
    static void testCustomerNotFound() {
        Account customer = new Account(
            Name = 'NEXURA Deleted Test Customer',
            Customer_Type__c = 'Individual',
            Customer_Status__c = 'Active'
        );
        insert customer;

        Id deletedCustomerId = customer.Id;
        delete customer;

        NexuraCustomerVerificationService.VerificationResult result =
            NexuraCustomerVerificationService.verifyCustomer(deletedCustomerId);

        System.assertEquals(false, result.eligible);
        System.assertEquals(
            'Customer was not found or is not accessible.',
            result.message
        );
    }
}
