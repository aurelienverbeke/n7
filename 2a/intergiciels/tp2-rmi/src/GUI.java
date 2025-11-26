/* -------------------------------------------------------
		Les packages Java qui doivent etre importes.
*/
import java.awt.*;
import java.awt.event.*;
import java.net.MalformedURLException;
import java.nio.charset.MalformedInputException;
import java.rmi.*;
import java.rmi.server.RemoteObject;

import javax.swing.*;

/* -------------------------------------------------------
		Implementation de l'application
*/

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
        message.setText("Nom : " + record.getName() + " | Email : " + record.getEmail());
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
