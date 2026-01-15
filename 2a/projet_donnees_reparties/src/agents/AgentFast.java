package agents;

import java.net.InetAddress;
import java.util.HashMap;
import java.util.List;

public class AgentFast extends Agent {
    private List<String> strings;
    private List<Integer> lengths;

    private final int NUM_STRINGS = 10000;

    public AgentFast() {
        super();
        this.strings = new java.util.ArrayList<>(NUM_STRINGS);
        this.lengths = new java.util.ArrayList<>(NUM_STRINGS);
    }

    public void run() {
        if (this.server.getPort() == 8081) {
            // Local server, final destination : print lengths sum

            // Print length sum
            long totalLength = 0;
            for (int length : lengths) {
                totalLength += length;
            }
            System.out.println("Total length of strings: " + totalLength);

        } else if (this.server.getPort() == 8082) {
            // First hop : generate strings

            for (int i = 0; i < NUM_STRINGS; i++) {
                strings.add(
                        ((ServiceStringGenerator) this.server.getServices().get("stringgenerator")).getString());
            }

            // Move to next server
            try {
                this.move(InetAddress.getByName("localhost"), 8083);
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else if (this.server.getPort() == 8083) {
            // Second hop : calculate corresponding lengths

            for (int i = 0; i < NUM_STRINGS; i++) {
                lengths.add(((ServiceLengthCalculator) this.server.getServices().get("lengthcalculator"))
                        .getLength(strings.get(i)));
            }

            // Move to final server
            try {
                this.move(InetAddress.getByName("localhost"), 8081);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    public static void main(String[] args) {
        try {
            // Start initial server to receive the agent at the end
            new Server(new HashMap<>(), Server.AcceptMode.SINGLE, 8081).start();

            Agent agent = new AgentFast();
            agent.move(InetAddress.getByName("localhost"), 8082);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
