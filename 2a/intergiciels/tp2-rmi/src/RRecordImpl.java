import java.io.Serializable;
import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;

public class RRecordImpl extends UnicastRemoteObject implements RRecord {

  private String name;
  private String email;

  public RRecordImpl(String name, String email) throws RemoteException {
    this.name = name;
    this.email = email;
  }
  
  public String getName() throws RemoteException {
    return name;
  }

  public String getEmail() throws RemoteException {
    return email;
  }
}