package agents;

import java.net.ServerSocket;
import java.net.Socket;
import java.io.IOException;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.HashMap;

public class Server extends Thread {
    public enum AcceptMode {
        SINGLE,
        MULTIPLE
    }

    private HashMap<String, Service> services;
    private int port;
    private InetAddress host;
    private AcceptMode acceptMode;

    public Server(HashMap<String, Service> services, AcceptMode acceptMode, int port) throws UnknownHostException {
        this.services = services;
        this.host = InetAddress.getLocalHost();
        this.acceptMode = acceptMode;
        this.port = port;
    }

    public HashMap<String, Service> getServices() {
        return services;
    }

    public InetAddress getHost() {
        return host;
    }

    public int getPort() {
        return port;
    }

    @Override
    public void run() {
        try {
            ServerSocket serverSocket = new ServerSocket(port);
            System.out.println("Server running on " + host.getHostAddress() + ":" + port);

            if (!services.isEmpty()) {
                System.out.println("Available services:");
                for (String serviceName : services.keySet()) {
                    System.out.println(" - " + serviceName);
                }
            }

            // Accept connections
            // Only one if SINGLE mode, multiple if MULTIPLE mode
            do {
                Socket socket = serverSocket.accept();
                new Worker(socket, this).start();
            } while (acceptMode == AcceptMode.MULTIPLE);

            serverSocket.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    // Print usage instructions for command line
    public static void printUsage() {
        System.out.println("Usage: java Server [services | help] [port]");
    }

    // Example of Server usage with ExempleService
    // On port 8081 by default
    // To specify a different port, provide it as a command line argument
    public static void main(String[] args) {
        try {
            int port = 8081;

            // Parse arguments
            // First one is either "help" or the services name
            // Second one is the port (optional)
            if (args.length == 0 || args.length > 2) {
                // Too few or too many arguments
                printUsage();
                return;
            } else if (args.length == 1) {
                // No port specified
                if (args[0].equals("help")) {
                    printUsage();
                    return;
                }
            } else if (args.length == 2) {
                // Port specified
                port = Integer.parseInt(args[1]);
            }

            // Initialize services
            HashMap<String, Service> services = new HashMap<>();

            String serviceName = args[0];
            switch (serviceName) {
                case "stringgenerator":
                    services.put(args[0], new ServiceStringGenerator());
                    break;
                case "lengthcalculator":
                    services.put(args[0], new ServiceLengthCalculator());
                    break;
                case "none":
                    // No services
                    break;
                default:
                    System.out.println("Unknown service: " + args[0]);
                    printUsage();
                    return;
            }
            // Start server
            new Server(services, AcceptMode.MULTIPLE, port).start();
        } catch (UnknownHostException e) {
            e.printStackTrace();
        }
    }
}