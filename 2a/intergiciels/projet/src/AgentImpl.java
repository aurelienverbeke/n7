import java.io.ObjectOutputStream;
import java.net.InetAddress;
import java.net.Socket;
import java.util.List;

public class AgentImpl implements Agent {
    private InetAddress previousSite;
    private int previousPort;

    public AgentImpl (int serverIndex, InetAddress previousSite, int previousPort) {
        this.previousSite = previousSite;
        this.previousPort = previousPort;
    }

    public void move(InetAddress site, int port) {
        Socket socket = new Socket(site, port);
        ObjectOutputStream outputStream = new ObjectOutputStream(socket.getOutputStream());

        outputStream.writeObject(this);

        outputStream.close();
        socket.close();
    }

    public void back() {
        move(previousSite, previousPort);
    }
     
    public static void main(String args[]) {
        try {
            InetAddress originSite = InetAddress.getByName("localhost");
            int originPort = 1099;

            Agent agent = new AgentImpl(0, InetAddress(), 0);

            agent.move(InetAddress.getByName("localhost"), 17000);
            agent.move(InetAddress.getByName("localhost"), 17001);
            agent.back();
            agent.back();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}