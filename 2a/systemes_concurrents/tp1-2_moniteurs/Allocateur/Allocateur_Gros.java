// Time-stamp: <28 oct 2022 10:31 queinnec@enseeiht.fr>

import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;
import java.util.concurrent.locks.Condition;

/** Allocateur de ressources,
 * stratégie d'ordonnancement: priorité aux petits demandeurs,
 *
 * Implantation: moniteur (java 5), une var condition par taille de demande.
 */
public class Allocateur_Gros implements Allocateur {

    // Nombre total de ressources.
    private final int nbRessources;

    // Nombre de ressources actuellement disponibles
    // invariant 0 <= nbLibres <= nbRessources
    private int nbLibres;

    // Protection des variables partagées
    private Lock moniteur;

    // Une condition de blocage par taille de demande
    // tableau [nbRessources+1] dont on n'utilise pas la case 0
    private Condition[] classe; 

    // Le nombre de processus en attente à chaque étage
    // tableau [nbRessources+1] dont on n'utilise pas la case 0
    private int[] tailleClasse;

    /** Initilialise un nouveau gestionnaire de ressources pour nbRessources. */
    public Allocateur_Gros(int nbRessources) {
        this.nbRessources = nbRessources;
        this.nbLibres = nbRessources;
        this.moniteur = new ReentrantLock();
        this.classe = new Condition[nbRessources+1];
        this.tailleClasse = new int[nbRessources+1];
        for (int i=0 ; i<=nbRessources ; i++) {
            this.classe[i] = moniteur.newCondition();
            this.tailleClasse[i] = 0;
        }
    }

    /*private boolean aucuneDemandePlusPetite(int demande) {
        boolean demandeOk = true;

        for (int i=1 ; i<demande ; i++) {
            demandeOk = demandeOk && tailleClasse[i]<1;
        }

        return demandeOk;
    }*/

    private void reveillerPlusGros() {
        for (int etageReveil = nbLibres ; etageReveil>0 ; etageReveil--) {
            if (tailleClasse[etageReveil] > 0) {
                classe[etageReveil].signal();
                break;
            }
        }
    }

    /** Demande à obtenir `demande' ressources. */
    public void allouer(int demande) throws InterruptedException {
        moniteur.lock();
        tailleClasse[demande]++;
        while (demande > nbLibres) {
            classe[demande].await();
        }
        tailleClasse[demande]--;
        nbLibres -= demande;
        reveillerPlusGros();
        moniteur.unlock();
    }

    /** Libère `rendu' ressources. */
    public void liberer(int rendu) throws InterruptedException {
        moniteur.lock();
        nbLibres += rendu;
        reveillerPlusGros();
        moniteur.unlock();
    }

    /** Chaîne décrivant la stratégie d'allocation. */
    public String nomStrategie()
    {
        return "Priorité aux gros demandeurs";
    }

}
