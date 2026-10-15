public with sharing class NexuraReturnService {

    public class ReturnResult {
        public Boolean valid { get; set; }
        public String message { get; set; }

        public ReturnResult(Boolean valid, String message) {
            this.valid = valid;
            this.message = message;
        }
    }

    // Validates a return request
    public static ReturnResult validateReturn(Id returnId) {
        if (returnId == null) {
            return new ReturnResult(false, 'Return request ID is required.');
        }

        List<NEXURA_Return_Request__c> requests = [
            SELECT Id, Order__c, Return_Amount__c, Approval_Status__c,
                   Return_Reason__c
            FROM NEXURA_Return_Request__c
            WHERE Id = :returnId
            LIMIT 1
        ];

        if (requests.isEmpty()) {
            return new ReturnResult(false, 'Return request not found.');
        }

        NEXURA_Return_Request__c request = requests[0];

        if (request.Order__c == null) {
            return new ReturnResult(false, 'An Order is required.');
        }

        if (request.Return_Amount__c == null ||
            request.Return_Amount__c <= 0) {
            return new ReturnResult(false, 'Return amount must be positive.');
        }

        if (request.Approval_Status__c != 'Approved') {
            return new ReturnResult(
                false, 'Return request must be approved first.'
            );
        }

        return new ReturnResult(true, 'Return request passed validation.');
    }
}