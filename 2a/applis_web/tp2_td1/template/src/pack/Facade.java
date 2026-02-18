package pack;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.Statement;
import java.sql.ResultSet;
import java.util.Arrays;
import java.util.Collection;
import java.util.Hashtable;
import java.sql.Array;

public class Facade {
    //Hashtable<Integer, Personne> personnes = new Hashtable<>();
    //Hashtable<Integer, Adresse> adresses = new Hashtable<>();

    Connection c;

    public Facade() {
        try {
            Class.forName("org.hsqldb.jdbcDriver");
            c = DriverManager.getConnection("jdbc:hsqldb:hsql://localhost/xdb", "sa", null);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    //int idP = 0;
    //int idA = 0;

    void ajoutPersonne(String nom, String prenom) {
        //int id = idP++;
        //personnes.put(id, new Personne(id, nom, prenom));
        try {
            PreparedStatement statement = c.prepareStatement("INSERT INTO Personne (nom, prenom, adresses) VALUES (?, ?, ARRAY[])");
            statement.setString(1, nom);
            statement.setString(2, prenom);
            statement.executeUpdate();
            c.commit();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    void ajoutAdresse(String adresse) {
        //int id = idA++;
        //adresses.put(id, new Adresse(id, adresse));
        try {
            PreparedStatement statement = c.prepareStatement("INSERT INTO Adresse (adresse) VALUES (?)");
            statement.setString(1, adresse);
            statement.executeUpdate();
            c.commit();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    Collection<Personne> listePersonnes() {
        Hashtable<Integer, Personne> personnes = new Hashtable<>();

        try {
            ResultSet rs = c.createStatement().executeQuery("SELECT p.id, p.nom, p.prenom, GROUP_CONCAT(a.adresse) AS adresses FROM Personne p LEFT JOIN UNNEST(p.adresses) AS t(adr_id) ON TRUE LEFT JOIN Adresse a ON a.id = t.adr_id GROUP BY p.id");

            while(rs.next()) {
                Personne personne = new Personne(rs.getInt("id"), rs.getString("nom"), rs.getString("prenom"));
                String adresses = rs.getString("adresses");
                if (adresses != null) {
                    for (String adresse : adresses.split(",")) {
                        personne.getAdresses().add(new Adresse(0, adresse));
                    }
                }
                personnes.put(rs.getInt("id"), personne);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return personnes.values();
    }

    Collection<Adresse> listeAdresses() {
        Hashtable<Integer, Adresse> adresses = new Hashtable<>();
        
        try {
            ResultSet rs = c.createStatement().executeQuery("SELECT * FROM Adresse");

            while(rs.next()) {
                adresses.put(rs.getInt("id"), new Adresse(rs.getInt("id"), rs.getString("adresse")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return adresses.values();
    }

    void associer(int idP, int idA) {
        //Personne p = personnes.get(idP);
        //Adresse a = adresses.get(idA);
        //p.getAdresses().add(a);

        try {
            PreparedStatement statement = c.prepareStatement("UPDATE Personne SET adresses=adresses||ARRAY[?] WHERE id=?");
            statement.setInt(1, idA);
            statement.setInt(2, idP);
            c.commit();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}