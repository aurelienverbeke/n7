import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;
import java.util.concurrent.locks.Condition;

/* Squelette d'une solution avec un moniteur.
 * Il manque le moniteur (verrou + variables conditions).
 */
public class PhiloMon implements StrategiePhilo {

    /* Verrou */
    private Lock moniteur;

    /* Variables conditions */
    private Condition Acces;

    /* Variables d'etat */
    // État d'un philosophe : pense, mange, demande ?
    private EtatPhilosophe[] etat;

    /****************************************************************/

    public PhiloMon (int nbPhilosophes) {
        this.etat = new EtatPhilosophe[nbPhilosophes];
        for (int i = 0; i < nbPhilosophes; i++) {
            etat[i] = EtatPhilosophe.Pense;
        }
        this.moniteur = new ReentrantLock();
        this.Acces = moniteur.newCondition();
    }

    public void demanderFourchettes (int no) throws InterruptedException
    {
        moniteur.lock();

        etat[no] = EtatPhilosophe.Demande;
        while (etat[Main.PhiloGauche(no)]==EtatPhilosophe.Mange || etat[Main.PhiloDroite(no)]==EtatPhilosophe.Mange) {
            Acces.await();
        }
        etat[no] = EtatPhilosophe.Mange;

        // j'ai les fourchette G et D
        IHMPhilo.poser (Main.FourchetteGauche(no), EtatFourchette.AssietteDroite);
        IHMPhilo.poser (Main.FourchetteDroite(no), EtatFourchette.AssietteGauche);

        moniteur.unlock();
    }

    public void libererFourchettes (int no)
    {
        moniteur.lock();

        IHMPhilo.poser (Main.FourchetteGauche(no), EtatFourchette.Table);
        IHMPhilo.poser (Main.FourchetteDroite(no), EtatFourchette.Table);

        etat[no] = EtatPhilosophe.Pense;
        Acces.signalAll();

        moniteur.unlock();
    }

    public String nom() {
        return "Moniteur";
    }
}

