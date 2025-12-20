import java.io.ByteArrayInputStream;
import java.io.DataInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.ObjectInputStream;
import java.io.ObjectStreamClass;
import java.net.ServerSocket;
import java.net.Socket;

public class Server {
        public static void main(String[] args) {
                try {
                        ServerSocket serverSocket = new ServerSocket(8081);
                        System.out.println("Server running...");

                        while (true) {
                                Socket socket = serverSocket.accept();
                                new Worker(socket).start();
                                // TODO
                                // modify with different workers, implies imagining a scenario
                        }
                } catch (Exception e) {
                        e.printStackTrace();
                }
        }
}