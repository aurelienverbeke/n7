import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;
import java.util.HashMap;

/**
 * Class that implements the Pad server (see subject)
 */
public class PadImpl extends UnicastRemoteObject implements Pad {

  private HashMap<String, String> pad;

  public PadImpl() throws RemoteException {
    this.pad = new HashMap<String, String>();
  }

  public void add(SRecord sr) throws RemoteException {
    this.pad.put(sr.getName(), sr.getEmail());
  }

  public RRecord consult(String n, boolean forward) throws RemoteException {
    if (this.pad.containsKey(n)) {
      return new RRecordImpl(n, this.pad.get(n));
    } else {
      throw new RemoteException("L'email n'existe pas.");
    }
  }
}