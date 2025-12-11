import java.net.InetAddress;

public interface Agent {
    public void move(InetAddress site, int port);
    public void back();
}