import java.io.Serializable;
import java.net.InetAddress;

public interface Agent extends Serializable {
    public void move(InetAddress site, int port);
    public void back();
}