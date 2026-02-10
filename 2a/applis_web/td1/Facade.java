package td1;

import java.util.Collection;
import java.util.Hashtable;

public class Facade {
    Hashtable<Integer, Personne> personnes = new Hashtable<>();
    Hashtable<Integer, Adresse> adresses = new Hashtable<>();

    int idP = 0;
    int idA = 0;

    void ajoutPersonne(String nom, String prenom) {
        int id = idP++;
        personnes.put(id, new Personne(id, nom, prenom));
    }

    void ajoutAdresse(String adresse) {
        int id = idA++;
        adresses.put(id, new Adresse(id, adresse));
    }

    Collection<Personne> listePersonnes() {
        return personnes.values();
    }

    Collection<Adresse> listeAdresses() {
        return adresses.values();
    }

    void associer(int idP, int idA) {
        Personne p = personnes.get(idP);
        Adresse a = adresses.get(idA);
        p.getAdresses().add(a);
    }
}