
/*
 * Project: NEXURA
 * Module 1: Customer Verification
 * Purpose: Verify whether a customer is eligible
 *          to proceed with order processing.
 */
public with sharing class NexuraCustomerVerificationService {

    /*
     * Stores the result of customer verification.
     * The caller receives eligibility, a message,
     * and the customer's basic identifying details.
     */
    public class VerificationResult {

        // Indicates whether the customer can proceed.
        public Boolean eligible { get; set; }

        // Explains why verification passed or failed.
        public String message { get; set; }

        // Salesforce Account record ID.
        public Id customerId { get; set; }

        // Name of the verified customer.
        public String customerName { get; set; }

        /*
         * Constructor: initializes the verification result
         * whenever a new VerificationResult is created.
         */
        public VerificationResult(
            Boolean eligible,
            String message,
            Id customerId,
            String customerName
        ) {
            this.eligible = eligible;
            this.message = message;
            this.customerId = customerId;
            this.customerName = customerName;
        }
    }

    /*
     * Main business method:
     * checks whether the supplied Account is eligible.
     */
    public static VerificationResult verifyCustomer(Id customerId) {

        // Rule 1: A customer Account ID must be provided.
        if (customerId == null) {
            return new VerificationResult(
                false,
                'Customer Account ID is required.',
                null,
                null
            );
        }

        // Retrieve the Account fields needed for verification.
        List<Account> customers = [
            SELECT Id, Name, Customer_Type__c, Customer_Status__c
            FROM Account
            WHERE Id = :customerId
            LIMIT 1
        ];

        // Rule 2: Reject a customer that cannot be found
        // or is not accessible to the running user.
        if (customers.isEmpty()) {
            return new VerificationResult(
                false,
                'Customer was not found or is not accessible.',
                customerId,
                null
            );
        }

        // Extract the single matching Account record.
        Account customer = customers[0];

        // Rule 3: Customer type must be populated.
        if (String.isBlank(customer.Customer_Type__c)) {
            return new VerificationResult(
                false,
                'Customer type is required.',
                customer.Id,
                customer.Name
            );
        }

        // Rule 4: Only Active customers may proceed.
        if (customer.Customer_Status__c != 'Active') {
            return new VerificationResult(
                false,
                'Customer is not active. Order processing is not allowed.',
                customer.Id,
                customer.Name
            );
        }

        // All implemented verification rules passed.
        return new VerificationResult(
            true,
            'Customer verification successful. Order processing may proceed.',
            customer.Id,
            customer.Name
        );
    }
}
