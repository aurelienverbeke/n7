import java.rmi.Naming;
import java.rmi.registry.LocateRegistry;

/**
 * Class for the RMI server that starts the registry and create the pads
 *
 * @author you
 */
public final class Server {

  public static final String serverURI = "//localhost:8080";

  public static void main(String args[]) {
    try {
      /* Launching the naming service – rmiregistry – within the JVM */
      LocateRegistry.createRegistry(8080);

      /* Create the 2 pads and exposes them in the rmiregistry */
      PadImpl pad1 = new PadImpl();
      PadImpl pad2 = new PadImpl();

      Naming.bind(serverURI+"/Pad1", pad1);
      Naming.bind(serverURI+"/Pad2", pad2);
    } catch (Exception e) {
      e.printStackTrace();
    }
  }
}