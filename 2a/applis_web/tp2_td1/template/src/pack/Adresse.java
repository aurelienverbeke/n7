package pack;

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
    public Adresse (int id, String adresse) {
        this.id = id;
        this.adresse = adresse;
    }
}