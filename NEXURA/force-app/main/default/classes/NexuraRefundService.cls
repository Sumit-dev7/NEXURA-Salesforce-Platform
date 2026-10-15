public with sharing class NexuraRefundService {

    public class RefundResult {
        public Boolean success { get; set; }
        public String message { get; set; }

        public RefundResult(Boolean success, String message) {
            this.success = success;
            this.message = message;
        }
    }

    // Prepares a simulated refund decision
    public static RefundResult prepareRefund(Id returnId) {
        NexuraReturnService.ReturnResult result =
            NexuraReturnService.validateReturn(returnId);

        if (!result.valid) {
            return new RefundResult(false, result.message);
        }

        return new RefundResult(
            true,
            'Return is approved and eligible for refund processing.'
        );
    }
}
