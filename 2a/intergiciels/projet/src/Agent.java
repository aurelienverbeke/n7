import java.io.IOException;
import java.io.Serializable;
import java.net.InetAddress;

public interface Agent extends Serializable {
    public void move(InetAddress site, int port) throws IOException;
    public void back() throws IOException;
    public void setActionId(int id);
}