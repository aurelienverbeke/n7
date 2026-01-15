import java.io.*;
import java.net.*;

public class Comanche implements Runnable {
    private Socket s;

    public Comanche(Socket s) {
        this.s = s;
    }

    public void run() {
        try {
            InputStreamReader in = new InputStreamReader(s.getInputStream());
            // Stream qu'on peut utiliser pour écrire comme avec System.out.println
            PrintStream out = new PrintStream(s.getOutputStream());
            // Reader capable de retenir les numéros de ligne
            String rq = new LineNumberReader(in).readLine();
            System.out.println(rq);
            if (rq.startsWith("GET ")) {
                File f = new File(rq.substring(5, rq.indexOf(' ', 4)));
                if (f.exists() && !f.isDirectory()) {
                    InputStream is = new FileInputStream(f);
                    byte[] data = new byte[is.available()];
                    is.read(data);
                    is.close();
                    String s = new String(data);
                    out.print("HTTP/1.0 200 OK\n\n" + s);
                } else {
                    out.print("HTTP/1.0 404 Not Found\n\n <html>Document not found.</html>");
                }
            }
            out.close();
            s.close();
        } catch (IOException ex) {
            ex.printStackTrace();
        }
    }

    public static void main(String[] args) throws IOException {
        ServerSocket s = new ServerSocket(Integer.parseInt(args[0]));
        System.out.println(
                "Comanche is running. Open http://localhost:"
                        + args[0]
                        + "/<any file in current directory> in your web browser.");
        System.out.println(
                "In the terminal, you can also run: curl localhost:"
                        + args[0]
                        + "/<any file in current directory>");
        while (true) {
            new Thread(new Comanche(s.accept())).start();
        }
    }
}

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Random;

public class LoadBalancer extends Thread {
    static String hosts[] = {"localhost", "localhost"};
    static int ports[] = {8081, 8082};
    static int nbHosts = 2;
    static Random rand = new Random();
    Socket cli;

    public LoadBalancer (Socket s) {
        cli = s;
    }
    
    public static void main(String args[]) {
        try {
            ServerSocket ss = new ServerSocket(8080);
            while (true) {
                Socket s = ss.accept();
                new LoadBalancer(s).start();
            }
        } catch (IOException e) {
            e.printStackTrace();
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