// Problème 1

public class LoadBalancer extends Thread {
        static String hosts[] = {"host1", "host2"};
        static int ports[] = {8081, 8082};
        static int nbHosts = 2;
        static Random rand = new Random();
        Socket cli;

        public LoadBalancer (Socket s) {
                cli = s;
        }

        public static void main (String args[]) {
                ServerSocket ss = new ServerSocket(8080);
                while (true) {
                        Socket s = ss.accept();
                        // Important de ne pas faire .run() !!!
                        new LoadBalancer(s).start();
                }
        }

        public void run() {
                try {
                        int nServ = rand.nextInt(nbHosts);
                        Socket serv = new Socket(hosts[nServ], ports[nServ]);
                        InputStream cliIS = cli.getInputSstream();
                        InputStream serv_is = serv.getInputStream();
                        OutputStream serv_os = serv.getOutputStream();
                        byte buff[] = new byte[1024];

                        int nb = cli_is.read(buff,0,1024);
                        serv_os.write(buff,0,nb);
                        nb = serv_is.read(buff,0,1024);
                        cli_os.write(buff,0,nb);
                        cli.close();
                        serv.close();
                } catch (IOException e) {
			e.printStackTrace();
		}
        }
}



// Problème 2
public interface CallBack extends Remote {
        public void onMessage(Message m) throws RemoteException;
}

public class CallBackImpl extends UnicastRemoteObject implements CallBack {
        public CallBackImpl() throws RemoteException {}

        public void onMessage(Message m) throws RemoteException {
                System.out.println(m);
        }
}

public interface MOM extends Remote {
        public void publish(String topic, Message m) throws RemoteException;
        public void subscribe(String topic, CallBack callback) throws RemoteException;
}

public class MOMImpl extends UnicastRemoteObject implements MOM {
        Hashtable<String, ArrayList<CallBack>> table;

        public MOMImpl() throws RemoteException {
                table = new Hashtable<String, ArrayList<CallBack>>();
        }

        public void subscribe(String topic, CallBack callback) throws RemoteException {
                ArrayList<CallBack> l = table.get(topic);
                if (l == null) {
                        l = new ArrayList<CallBack>();
                        table.put(topic, l);
                }
                l.add(callback);
        }

        public void publish(String topic, Message m) throws RemoteException {
                ArrayList<CallBack> l = table.get(topic);
                for (CallBack callback : l) {
                        callback.onMessage(m);
                }
        }

        public static void main (String args[]) {
                LocalRegistry.createRegistry(8081);
                Naming.bind("//localhost:8081/mom", new MOMImpl());
        }
}

public class Client {
        public static void main (String args[]) {
                // Important de caster en MOM et pas MOMImpl
                MOM m = (MOM)Naming.lookup("//localhost:8081/mom");
                m.subscribe("sujet1", new CallBackImpl());
                m.publish("sujet1", "Un petit message :)");
        }
}
