public with sharing class NexuraOrderProcessingService {

    public class ProcessingResult {
        public Boolean success { get; set; }
        public String message { get; set; }
        public Id orderId { get; set; }

        public ProcessingResult(Boolean success, String message, Id orderId) {
            this.success = success;
            this.message = message;
            this.orderId = orderId;
        }
    }

    // Validates an order before processing
    public static ProcessingResult processOrder(Id orderId) {
        NexuraOrderValidationService.ValidationResult result =
            NexuraOrderValidationService.validateOrder(orderId);

        if (!result.valid) {
            return new ProcessingResult(
                false, result.message, orderId
            );
        }

        return new ProcessingResult(
            true,
            'Order passed validation and is ready for the processing workflow.',
            orderId
        );
    }
}