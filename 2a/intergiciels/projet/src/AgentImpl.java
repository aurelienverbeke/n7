import java.io.ByteArrayOutputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.ObjectOutputStream;
import java.io.OutputStream;
import java.net.InetAddress;
import java.net.Socket;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

public class AgentImpl implements Agent {
    private InetAddress previousSite;
    private int previousPort;
    private int actionId;

    public AgentImpl (int serverIndex, InetAddress previousSite, int previousPort) {
        this.previousSite = previousSite;
        this.previousPort = previousPort;
    }

    public void move(InetAddress site, int port) throws IOException {
        // Open a socket to the destination site and port
        Socket socket = new Socket(site, port);
        OutputStream socketOutputStream = socket.getOutputStream();
        DataOutputStream mainOutputStream = new DataOutputStream(socketOutputStream);

        // Open class file and read bytes
        Path classFile = Paths.get("AgentImpl.class");
        byte[] classBytes = Files.readAllBytes(classFile);

        // Serialize class instance
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
        ObjectOutputStream objectOutputStream = new ObjectOutputStream(byteArrayOutputStream);
        objectOutputStream.writeObject(this);
        objectOutputStream.flush();
        byte[] instanceBytes = byteArrayOutputStream.toByteArray();

        // Send class name and code bytes
        mainOutputStream.writeUTF("AgentImpl");
        mainOutputStream.writeInt(classBytes.length);
        mainOutputStream.write(classBytes);

        // Send serialized instance bytes
        mainOutputStream.writeInt(instanceBytes.length);
        mainOutputStream.write(instanceBytes);

        socket.close();
    }

    public void back() throws IOException {
        move(previousSite, previousPort);
    }

    public void setActionId(int id) {
        this.actionId = id;
    }
     
    public static void main(String args[]) {
        try {
            Agent agent = new AgentImpl(0, null, 0);

            agent.move(InetAddress.getByName("localhost"), 17000);
            agent.move(InetAddress.getByName("localhost"), 17001);
            agent.back();
            agent.back();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}