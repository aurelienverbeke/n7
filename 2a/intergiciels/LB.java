import java.util.Random;
import java.net.Socket;
import java.net.ServerSocket;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

public class LB extends Thread {
        static String hosts[] = {"host1", "host2"};
        static int ports[] = {8081, 8082};
        static int nbHosts = 2;
        static Random rand = new Random();
        Socket cli;

        public LB (Socket s) {
                cli = s;
        }

        public static void main (String args[]) throws IOException {
                ServerSocket ss = new ServerSocket(8080);
                while (true) {
                        Socket s = ss.accept();
                        new LB(s).start();
                }
        }

        public void run() {
                try {
                        int nServ = rand.nextInt(nbHosts);
                        Socket serv = new Socket(hosts[nServ], ports[nServ]);
                        InputStream cliIS = cli.getInputStream();
                        OutputStream cliOS = cli.getOutputStream();
                        InputStream servIS = serv.getInputStream();
                        OutputStream servOS = serv.getOutputStream();
                        byte buff[] = new byte[1024];

                        int nb = cliIS.read(buff, 0, 1024);
                        servOS.write(buff, 0, nb);
                        nb = servIS.read(buff, 0, 1024);
                        cliOS.write(buff, 0, nb);
                        cli.close();
                        serv.close();
                } catch (IOException e) {
                        e.printStackTrace();
                }
        }
}