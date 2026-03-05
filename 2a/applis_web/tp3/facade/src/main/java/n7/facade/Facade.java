package n7.facade;

import java.util.Collection;
import java.util.Hashtable;
import java.util.Optional;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class Facade {
    @Autowired
    AdresseRepository ar;

    @Autowired
    PersonneRepository pr;
    
    /*
    Hashtable<Integer, Personne> personnes = new Hashtable<>();
    Hashtable<Integer, Adresse> adresses = new Hashtable<>();

    int idP = 0;
    int idA = 0;
    */

    @PostMapping("/ajouterpersonne")
    void ajoutPersonne(@RequestParam("nom") String nom, @RequestParam("prenom") String prenom) {
        /*
        int id = idP++;
        personnes.put(id, new Personne(id, nom, prenom));
        */
       pr.save(new Personne(nom, prenom));
    }

    @PostMapping("/ajouteradresse")
    void ajoutAdresse(@RequestParam("adresse") String adresse) {
        /*
        int id = idA++;
        adresses.put(id, new Adresse(id, adresse));
        */
        ar.save(new Adresse(adresse));
    }

    @GetMapping("/listerpersonnes")
    Collection<Personne> listePersonnes() {
        // return personnes.values();
        return pr.findAll();
    }

    @GetMapping("/listeradresses")
    Collection<Adresse> listeAdresses() {
        // return adresses.values();
        return ar.findAll();
    }

    @PostMapping("/associer")
    void associer(@RequestParam("idp") int idP, @RequestParam("ida") int idA) {
        /*
        Personne p = personnes.get(idP);
        Adresse a = adresses.get(idA);
        p.getAdresses().add(a);
        */

        Optional<Personne> personneOpt = pr.findById(Long.valueOf(idP));
        Optional<Adresse> adresseOpt = ar.findById(Long.valueOf(idA));
        
        if(!personneOpt.isPresent() || !adresseOpt.isPresent()) {
            throw new RuntimeException("Personne ou adresse introuvable");
        }

        Personne personne = personneOpt.get();
        Adresse adresse = adresseOpt.get();

        personne.getAdresses().add(adresse);

        pr.save(personne);
    }
}