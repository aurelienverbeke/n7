package rmi;

import java.rmi.Naming;

public class ClientSlow {
    public final static int NUM_STRINGS = 10000;

    public static void main(String[] args) {
        try {
            long totalLength = 0;

            for (int i = 0; i < ClientSlow.NUM_STRINGS; i++) {
                String s = ((RmiService) Naming.lookup("//localhost:8082/service")).getString();
                totalLength += ((RmiService) Naming.lookup("//localhost:8083/service")).getLength(s);
            }
            System.out.println("Total length of strings: " + totalLength);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
