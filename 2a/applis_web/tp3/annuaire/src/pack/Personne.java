package pack;

import java.util.ArrayList;
import java.util.Collection;

public class Personne {
    int id;
    String nom, prenom;
    Collection<Adresse> adresses = new ArrayList<Adresse>();

    // Getters
    public int getId() {
        return id;
    }
    public String getNom() {
        return nom;
    }
    public String getPrenom() {
        return prenom;
    }
    public Collection<Adresse> getAdresses() {
        return adresses;
    }

    public Personne () {}

    // Constructeur
    public Personne (int id, String nom, String prenom) {
        this.id = id;
        this.nom = nom;
        this.prenom = prenom;
    }
}