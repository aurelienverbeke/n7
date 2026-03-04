package n7.facade;

public class Adresse {
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

    public Adresse (int id, String adresse) {
        this.id = id;
        this.adresse = adresse;
    }
}