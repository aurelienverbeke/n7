package agents;

import java.io.ByteArrayOutputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.ObjectOutputStream;
import java.io.OutputStream;
import java.io.Serializable;
import java.net.InetAddress;
import java.net.Socket;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

public abstract class Agent implements Serializable {
    private InetAddress previousHost;
    private int previousPort;
    public transient byte[] classBytes;

    // Transient to avoid serialization
    // Will be set by the server receiving the agent
    protected transient Server server = null;

    public Agent() {
        Path classFile = Paths.get("agents/" + this.getClass().getSimpleName() + ".class");

        byte[] classBytes = null;
        try {
            classBytes = Files.readAllBytes(classFile);
        } catch (Exception e) {
            e.printStackTrace();
        }

        this.classBytes = classBytes;
    }

    public void move(InetAddress host, int port) throws IOException {
        // Save actual server info
        if (server != null) {
            previousHost = this.server.getHost();
            previousPort = this.server.getPort();
        }

        // Open a socket to the destination host and port
        Socket socket = new Socket(host, port);
        OutputStream socketOutputStream = socket.getOutputStream();
        DataOutputStream mainOutputStream = new DataOutputStream(socketOutputStream);

        // Send class name and code bytes
        mainOutputStream.writeUTF(this.getClass().getName());
        mainOutputStream.writeInt(this.classBytes.length);
        mainOutputStream.write(this.classBytes);

        // Serialize class instance to byte array
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
        ObjectOutputStream objectOutputStream = new ObjectOutputStream(byteArrayOutputStream);
        objectOutputStream.writeObject(this);
        objectOutputStream.flush();
        byte[] instanceBytes = byteArrayOutputStream.toByteArray();

        // Send serialized instance bytes
        mainOutputStream.writeInt(instanceBytes.length);
        mainOutputStream.write(instanceBytes);

        socket.close();
    }

    public void back() throws IOException {
        move(previousHost, previousPort);
    }

    public void setServer(Server server) {
        this.server = server;
    }

    public abstract void run();
}