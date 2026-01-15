// Problème 1

// Question 1 :
// Il faut que tout les clients soient parallélisés :
//      on télécharge chacun des morceaux de code en même temps
// Pas de parallélisation pour un serveur :
//      il ne pourra dans tous les cas fournir qu'une seule ressource
//      puisqu'il expose un socket sur un seul port

public class UsagerServer {
        final static String hosts[] = {"host1", "host2", "host3"};
        final static int nb = 3;
        static String documents[] = new String[nb];

        public static void main(String args[]) {
                ServerSocket ss = new ServerSocket(8080);

                while (true) {
                        Socket s = ss.accept();
                        OutputStream os = s.getOutputStream();
                        InputStream is = s.getInputStream();
                        ObjectOutputStream oos = new ObjectOutputStream(os);
                        ObjectInputStream ois = new ObjectInputStream(is);
                        
                        int num = (int)ois.readObject();
                        oos.writeObject(documents[num]);
                }
        }
}

public class UsagerClient extends Thread {
        final static String hosts[] = {"host1", "host2", "host3"};
        final static int ports[] = {8081,8082,8083};
        final static int nb = 3;
        static String documents[] = new String[nb];

        int target;

        public UsagerClient(int i) {
                target = i;
        }

        public void run() {
                Socket s = new Socket(hosts[target], ports[target]);
                OutputStream os = s.getOutputStream();
                InputStream is = s.getInputStream();
                ObjectOutputStream oos = new ObjectOutputStream(os);
                ObjectInputStream ois = new ObjectInputStream(is);

                oos.writeObject(target);
                documents[target] = (String)ois.readObject();
                s.close();
        }

        public static void main(String args[]) {
                Thread th[] = new Thread[nb];

                for (int i=0 ; i<nb ; i++) {
                        th[i] = new UsagerClient(i);
                        th[i].start();
                }

                for (int i=0 ; i<nb ; i++) {
                        th[i].join();
                }
        }
}



// Problème 2

// Ajouts pour la console en commentaire
// Visiblement on appelle ça une "inversion de contrôle"

public interface Daemon extends Remote {
        public void exec(String cmd /* , Console console */) throws RemoteException;
}

public class DaemonImpl extends UnicastRemoteObject implements Daemon {
        public DaemonImpl() {}

        public void exec(String cmd /* , Console console */) throws RemoteException {
                localExec(cmd /*, console */);
        }

        public static void main(String args[]) {
                LocalRegistry.createRegistry(2000);
                Naming.bind("//localhost:2000/daemon", new DaemonImpl());
        }
}

public class RE {
        public static void main(String args[]) {
                // On met bien Daemon et pas DaemonImpl sinon on se prend -10pts
                Daemon d = (Daemon)Naming.lookup("//"+args[0]+":2000/daemon");
                d.exec(args[1] /*, new ConsoleImpl() */);
        }
}

public interface Console extends Remote {
        public void println(String s) throws RemoteException;
}

public class ConsoleImpl extends UnicastRemoteObject implements Console {
        public Console() throws RemoteException {}

        public void println(String s) throws RemoteException {
                System.out.println(s);
        }
}
