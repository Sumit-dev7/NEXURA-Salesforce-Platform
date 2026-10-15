public class NexuraOrderValidationQueueable
    implements Queueable {

    private Id orderId;

    public NexuraOrderValidationQueueable(Id orderId) {
        this.orderId = orderId;
    }

    // Runs order validation asynchronously
    public void execute(QueueableContext context) {
        NexuraOrderValidationService.ValidationResult result =
            NexuraOrderValidationService.validateOrder(orderId);

        System.debug(
            'Order validation result: ' + result.valid +
            ', message: ' + result.message
        );
    }
}