package agents;

import java.net.InetAddress;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class AgentSlow extends Agent {

    private List<String> strings;
    private List<Integer> lengths;

    private int currentIndex = 0;
    private static final int NUM_STRINGS = 10000;

    public AgentSlow() {
        super();
        this.strings = new ArrayList<>(NUM_STRINGS);
        this.lengths = new ArrayList<>(NUM_STRINGS);
    }

    public void run() {

        try {
            // Final server: print result
            if (this.server.getPort() == 8081) {
                long totalLength = 0;
                for (int length : lengths) {
                    totalLength += length;
                }
                System.out.println("Total length of strings: " + totalLength);
            }

            // String generator
            else if (this.server.getPort() == 8082) {
                String s = ((ServiceStringGenerator) this.server.getServices().get("stringgenerator"))
                        .getString();

                strings.add(s);

                // Move to length calculator
                this.move(InetAddress.getByName("localhost"), 8083);
            }

            // Length calculator
            else if (this.server.getPort() == 8083) {
                String s = strings.get(currentIndex);

                int length = ((ServiceLengthCalculator) this.server.getServices().get("lengthcalculator"))
                        .getLength(s);

                lengths.add(length);
                currentIndex++;

                // Move to final server
                if (currentIndex >= NUM_STRINGS) {
                    this.move(InetAddress.getByName("localhost"), 8081);
                } else {
                    // Go back to generator for next string
                    this.move(InetAddress.getByName("localhost"), 8082);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        try {
            // Start initial server to receive the agent at the end
            new Server(new HashMap<>(), Server.AcceptMode.SINGLE, 8081).start();

            Agent agent = new AgentSlow();
            agent.move(InetAddress.getByName("localhost"), 8082);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
