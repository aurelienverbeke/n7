package agents;

public class ServiceLengthCalculator implements Service {
    // Calculates the length of a given string
    public int getLength(String str) {
        // System.out.println("Calculating length of string: " + str + " (length: " +
        // str.length() + ")");
        return str.length();
    }

    // Tests the service
    public static void main(String[] args) {
        ServiceLengthCalculator service = new ServiceLengthCalculator();
        System.out.println(service.getLength("Hello World"));
    }
}