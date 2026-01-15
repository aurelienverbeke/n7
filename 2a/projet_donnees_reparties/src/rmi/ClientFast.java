package rmi;

import java.rmi.Naming;
import java.util.ArrayList;
import java.util.List;

public class ClientFast {
    public final static int NUM_STRINGS = 10000;

    public static void main(String[] args) {
        try {
            List<String> strings = new ArrayList<>(ClientFast.NUM_STRINGS);
            List<Integer> lengths = new ArrayList<>(ClientFast.NUM_STRINGS);

            for (int i = 0; i < ClientFast.NUM_STRINGS; i++) {
                strings.add(((RmiService) Naming.lookup("//localhost:8082/service")).getString());
            }

            for (int i = 0; i < ClientFast.NUM_STRINGS; i++) {
                lengths.add(((RmiService) Naming.lookup("//localhost:8083/service")).getLength(strings.get(i)));
            }

            long totalLength = 0;
            for (int length : lengths) {
                totalLength += length;
            }
            System.out.println("Total length of strings: " + totalLength);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
