import java.io.ByteArrayInputStream;
import java.io.DataInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.ObjectInputStream;
import java.io.ObjectStreamClass;
import java.net.Socket;

public abstract class Worker extends Thread {
        private Socket socket;
        private Agent agent;

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

                ObjectInputStream objectInputStream = new ObjectInputStream(
                        new ByteArrayInputStream(instanceBytes)) {

                        @Override
                        protected Class<?> resolveClass(ObjectStreamClass desc)
                                throws IOException, ClassNotFoundException {
                                return loader.loadClass(desc.getName());
                        }
                };

                agent = (Agent)objectInputStream.readObject();

                socket.close();
        }

        abstract void executeAgent(Agent agent);

        public Worker(Socket socket) {
                this.socket = socket;
        }

        @Override
        public void run() {
                try {
                        loadClass();
                        executeAgent(agent);
                } catch (Exception e) {
                        e.printStackTrace();
                }
        }
}