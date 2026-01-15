package rmi;

import java.rmi.registry.LocateRegistry;
import java.rmi.Naming;

public class Server {
    // Print usage instructions for command line
    public static void printUsage() {
        System.out.println("Usage: java Server [port]");
    }

    // Example of Server usage with ExempleService
    // On port 8081 by default
    // To specify a different port, provide it as a command line argument
    public static void main(String[] args) {
        try {
            int port = 8081;

            // Parse arguments
            // Port (optional)
            if (args.length > 1) {
                // Too few or too many arguments
                printUsage();
                return;
            } else if (args.length == 1) {
                // Port specified
                port = Integer.parseInt(args[0]);
            }

            LocateRegistry.createRegistry(port);

            Naming.bind("//localhost:" + port + "/service", new RmiServiceImpl());

            System.out.println("Server running on localhost:" + port);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}