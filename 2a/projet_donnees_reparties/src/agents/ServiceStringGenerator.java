package agents;

import java.util.Random;

public class ServiceStringGenerator implements Service {
    // Generates random char string of length between 3 and 100 characters
    public String getString() {
        int length = new Random().nextInt(98) + 3;
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < length; i++) {
            sb.append((char) (new Random().nextInt(26) + 'a'));
        }
        // System.out.println("Generated string: " + sb.toString());
        return sb.toString();
    }

    // Tests the service
    public static void main(String[] args) {
        ServiceStringGenerator service = new ServiceStringGenerator();
        for (int i = 0; i < 10; i++) {
            System.out.println(service.getString());
        }
    }
}