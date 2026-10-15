public with sharing class NexuraPaymentService {

    public interface PaymentProvider {
        String charge(Decimal amount, String reference);
    }

    // Simulates a provider response for development
    public class SimulatedPaymentProvider implements PaymentProvider {
        public String charge(Decimal amount, String reference) {
            if (amount == null || amount <= 0) {
                return 'FAILED';
            }
            return 'SUCCESS';
        }
    }

    public class PaymentResult {
        public Boolean success { get; set; }
        public String status { get; set; }
        public String reference { get; set; }

        public PaymentResult(Boolean success, String status, String reference) {
            this.success = success;
            this.status = status;
            this.reference = reference;
        }
    }

    // Executes a simulated payment attempt
    public static PaymentResult attemptPayment(
        Decimal amount,
        String reference,
        PaymentProvider provider
    ) {
        if (amount == null || amount <= 0) {
            return new PaymentResult(false, 'FAILED', reference);
        }

        if (String.isBlank(reference)) {
            return new PaymentResult(false, 'FAILED', null);
        }

        if (provider == null) {
            return new PaymentResult(false, 'PENDING', reference);
        }

        String status = provider.charge(amount, reference);

        return new PaymentResult(
            status == 'SUCCESS',
            status,
            reference
        );
    }
}