package rmi;

import java.rmi.Remote;

public interface RmiService extends Remote {
    public String getString() throws java.rmi.RemoteException;

    public int getLength(String str) throws java.rmi.RemoteException;
}