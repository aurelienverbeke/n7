package n7.facade;

import java.util.ArrayList;
import java.util.Collection;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.ManyToMany;

@Entity
public class Personne {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    int id;
    String nom, prenom;

    @ManyToMany
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

    
    // Constructeur
    public Personne () {}

    /*
    public Personne (int id, String nom, String prenom) {
        this.id = id;
        this.nom = nom;
        this.prenom = prenom;
    }
    */

    public Personne (String nom, String prenom) {
        this.nom = nom;
        this.prenom = prenom;
    }
}