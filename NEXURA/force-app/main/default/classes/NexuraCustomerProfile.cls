
public class NexuraCustomerProfile {

    public String customerName;
    public String customerType;

    // Constructor 1: Name only
    public NexuraCustomerProfile(String customerName) {
        this.customerName = customerName;
        this.customerType = 'Individual';
    }

    // Constructor 2: Name and type
    public NexuraCustomerProfile(
        String customerName,
        String customerType
    ) {
        this.customerName = customerName;
        this.customerType = customerType;
    }

    // Return profile details
    public String getProfileDetails() {
        return 'Customer Name: ' + this.customerName
            + ', Customer Type: ' + this.customerType;
    }
}
