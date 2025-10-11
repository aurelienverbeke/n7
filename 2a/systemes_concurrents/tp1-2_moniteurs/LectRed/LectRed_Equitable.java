// Time-stamp: <11 oct 2024 08:19 Philippe Queinnec>

import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;
import Synchro.Assert;

/** Lecteurs/rédacteurs
 * stratégie d'ordonnancement: équitable, absence de famine
 * implantation: avec un moniteur. */
public class LectRed_Equitable implements LectRed
{
    /* Verrou */
    private Lock moniteur;

    /* Variables conditions */
    private Condition Acces;
    private Condition Sas;

    /* Variables d'etat */
    private int nRed = 0;
    private int nLect = 0;
    private int nAttAcces = 0;
    private int nAttSas = 0;

    
    
    public LectRed_Equitable() {
        this.moniteur = new ReentrantLock();
        this.Acces = moniteur.newCondition();
        this.Sas = moniteur.newCondition();
    }

    public void demanderLecture() throws InterruptedException {
        moniteur.lock();
        while (!(nRed==0 && nAttAcces==0 && nAttSas==0)) {
            Acces.await();
        }
        nLect++;
	Acces.signal();
        moniteur.unlock();
    }

    public void terminerLecture() throws InterruptedException {
        moniteur.lock();
        nLect--;
        if (nLect==0) {
            if (nAttSas!=0) {
	        Sas.signal();
	    } else {
	        Acces.signal();
	    }
        }
        moniteur.unlock();
    }

    public void demanderEcriture() throws InterruptedException {
        moniteur.lock();
        while (!(nRed==0 && nLect==0)) {
            Acces.await();
        }
        while (nLect>0) {
            Sas.await();
        }
        nRed++;
        moniteur.unlock();
    }

    public void terminerEcriture() throws InterruptedException {
        moniteur.lock();
        nRed--;
        Acces.signal();
        moniteur.unlock();
    }

    public String nomStrategie() {
        return "Stratégie: Priorité Lecteurs.";
    }
}
