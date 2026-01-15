package rmi;

import java.rmi.server.UnicastRemoteObject;
import java.util.Random;

public class RmiServiceImpl extends UnicastRemoteObject implements RmiService {
    public RmiServiceImpl() throws java.rmi.RemoteException {
        super();
    }

    // Generates random char string of length between 3 and 100 characters
    public String getString() {
        int length = new Random().nextInt(98) + 3;
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < length; i++) {
            sb.append((char) (new Random().nextInt(26) + 'a'));
        }
        return sb.toString();
    }

    // Calculates the length of a given string
    public int getLength(String str) {
        return str.length();
    }
}