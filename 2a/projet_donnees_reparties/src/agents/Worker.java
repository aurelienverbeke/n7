package agents;

import java.io.ByteArrayInputStream;
import java.io.DataInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.ObjectInputStream;
import java.io.ObjectStreamClass;
import java.net.Socket;

public class Worker extends Thread {
    private Socket socket;
    private Agent agent;
    private Server server;

    private void loadClass() throws IOException, ClassNotFoundException {
        InputStream mainInputStream = socket.getInputStream();
        DataInputStream dataInputStream = new DataInputStream(mainInputStream);

        String className = dataInputStream.readUTF();
        int classLength = dataInputStream.readInt();
        byte[] classBytes = dataInputStream.readNBytes(classLength);

        int instanceLength = dataInputStream.readInt();
        byte[] instanceBytes = dataInputStream.readNBytes(instanceLength);

        Loader loader = new Loader();
        loader.addClass(className, classBytes);

        // Custom ObjectInputStream to use our Loader
        ObjectInputStream objectInputStream = new ObjectInputStream(new ByteArrayInputStream(instanceBytes)) {
            @Override
            protected Class<?> resolveClass(ObjectStreamClass desc)
                    throws IOException, ClassNotFoundException {
                return loader.loadClass(desc.getName());
            }
        };

        agent = (Agent) objectInputStream.readObject();
        agent.classBytes = classBytes;

        socket.close();
    }

    public Worker(Socket socket, Server server) {
        this.socket = socket;
        this.server = server;
    }

    @Override
    public void run() {
        try {
            loadClass();
            agent.setServer(server);
            agent.run();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}