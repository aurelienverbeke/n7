package n7.facade;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;

@Entity
public class Adresse {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    int id;
    String adresse;

    // Getters
    public int getId() {
        return id;
    }
    public String getAdresse() {
        return adresse;
    }

    // Constructeur
    public Adresse () {}

    /*
    public Adresse (int id, String adresse) {
        this.id = id;
        this.adresse = adresse;
    }
    */

    public Adresse (String adresse) {
        this.adresse = adresse;
    }
}