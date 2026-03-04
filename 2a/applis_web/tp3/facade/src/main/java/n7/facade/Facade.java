package n7.facade;

import java.util.Collection;
import java.util.Hashtable;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class Facade {
    Hashtable<Integer, Personne> personnes = new Hashtable<>();
    Hashtable<Integer, Adresse> adresses = new Hashtable<>();

    int idP = 0;
    int idA = 0;

    @PostMapping("/ajouterpersonne")
    void ajoutPersonne(@RequestParam("nom") String nom, @RequestParam("prenom") String prenom) {
        int id = idP++;
        personnes.put(id, new Personne(id, nom, prenom));
    }

    @PostMapping("/ajouteradresse")
    void ajoutAdresse(@RequestParam("adresse") String adresse) {
        int id = idA++;
        adresses.put(id, new Adresse(id, adresse));
    }

    @GetMapping("/listerpersonnes")
    Collection<Personne> listePersonnes() {
        return personnes.values();
    }

    @GetMapping("/listeradresses")
    Collection<Adresse> listeAdresses() {
        return adresses.values();
    }

    @PostMapping("/associer")
    void associer(@RequestParam("idp") int idP, @RequestParam("ida") int idA) {
        Personne p = personnes.get(idP);
        Adresse a = adresses.get(idA);
        p.getAdresses().add(a);
    }
}