import java.awt.*;
import java.awt.event.*;
import java.net.MalformedURLException;
import java.nio.charset.MalformedInputException;
import java.rmi.*;
import java.rmi.server.RemoteObject;

import javax.swing.*;

public class GUI extends JFrame {
    TextField name, email;
    Choice pads;
    Label message;

    public GUI() {
        setSize(300, 200);
        setLayout(new GridLayout(6, 2));
        add(new Label("  Name : "));
        name = new TextField(30);
        add(name);
        add(new Label("  Email : "));
        email = new TextField(30);
        add(email);
        add(new Label("  Pad : "));
        pads = new Choice();
        pads.addItem("Pad1");
        pads.addItem("Pad2");
        add(pads);
        add(new Label(""));
        add(new Label(""));
        Button Abutton = new Button("add");
        Abutton.addActionListener(new AButtonAction());
        add(Abutton);
        Button Cbutton = new Button("consult");
        Cbutton.addActionListener(new CButtonAction());
        add(Cbutton);
        message = new Label();
        add(message);
    }

    class CButtonAction implements ActionListener {
        public void actionPerformed(ActionEvent ae) {
            String n, c;
            n = name.getText();
            c = pads.getSelectedItem();
            message.setText("consult(" + n + "," + c + ")        ");
            
            try {
                Pad pad = (Pad)Naming.lookup("//localhost:8080/"+c);
                RRecord record = pad.consult(n, true);
                message.setText("Nom : "
                    + record.getName()
                    + " | Email : "
                    + record.getEmail());
            } catch (NotBoundException | MalformedURLException exc) {
                exc.printStackTrace();
            } catch (RemoteException exc) {
                message.setText("Nom non trouvé !");
            }
        }
    }

    class AButtonAction implements ActionListener {
        public void actionPerformed(ActionEvent ae) {
            String n, e, c;
            n = name.getText();
            e = email.getText();
            c = pads.getSelectedItem();
            message.setText("add(" + n + "," + e + "," + c + ")");
            
            try {
                Pad pad = (Pad)Naming.lookup("//localhost:8080/"+c);
                pad.add(new SRecordImpl(n, e));
            } catch (RemoteException | NotBoundException | MalformedURLException exc) {
                exc.printStackTrace();
            }
        }
    }

    public static void main(String args[]) {
        GUI s = new GUI();
        s.setSize(400, 200);
        s.setVisible(true);
    }
}

import java.rmi.*;

public interface Pad extends Remote {
    public void add(SRecord sr) throws RemoteException;

    public RRecord consult(String n, boolean forward) throws RemoteException;
}

import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;
import java.util.HashMap;

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

import java.rmi.*;

public interface RRecord extends Remote {
    public String getName() throws RemoteException;
    public String getEmail() throws RemoteException;
}

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

import java.rmi.Naming;
import java.rmi.registry.LocateRegistry;

public final class Server {

    public static final String serverURI = "//localhost:8080";

    public static void main(String args[]) {
        try {
            LocateRegistry.createRegistry(8080);
            PadImpl pad1 = new PadImpl();
            PadImpl pad2 = new PadImpl();
            Naming.bind(serverURI+"/Pad1", pad1);
            Naming.bind(serverURI+"/Pad2", pad2);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

import java.io.*;

public interface SRecord extends Serializable {
    public String getName();
    public String getEmail();
}

public class SRecordImpl implements SRecord {
    private String name;
    private String email;

    public SRecordImpl(String name, String email) {
        this.name = name;
        this.email = email;
    }
    
    public String getName() {
        return name;
    }

    public String getEmail() {
        return email;
    }
}