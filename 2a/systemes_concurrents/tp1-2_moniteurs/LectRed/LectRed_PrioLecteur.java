// Time-stamp: <11 oct 2024 08:19 Philippe Queinnec>

import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;
import Synchro.Assert;

/** Lecteurs/rédacteurs
 * stratégie d'ordonnancement: priorité aux lecteurs,
 * implantation: avec un moniteur. */
public class LectRed_PrioLecteur implements LectRed
{
    /* Verrou */
    private Lock moniteur;

    /* Variables conditions */
    private Condition AccesLect;
    private Condition AccesRed;

    /* Variables d'etat */
    private int nRed = 0;
    private int nLect = 0;
    private int nLectAtt = 0;
    
    
    public LectRed_PrioLecteur() {
        this.moniteur = new ReentrantLock();
        this.AccesLect = moniteur.newCondition();
        this.AccesRed = moniteur.newCondition();
    }

    public void demanderLecture() throws InterruptedException {
        moniteur.lock();
	nLectAtt++;
        while (nRed>0) {
            AccesLect.await();
        }
        nLectAtt--;
        nLect++;
        moniteur.unlock();
    }

    public void terminerLecture() throws InterruptedException {
        moniteur.lock();
        nLect--;
        if (nLect==0 && nLectAtt==0) {
            AccesRed.signal();
        }
        moniteur.unlock();
    }

    public void demanderEcriture() throws InterruptedException {
        moniteur.lock();
        while (!(nRed==0 && nLect==0)) {
            AccesRed.await();
        }
        nRed++;
        moniteur.unlock();
    }

    public void terminerEcriture() throws InterruptedException {
        moniteur.lock();
        nRed--;
        if (nLectAtt > 0) {
            AccesLect.signalAll();
        } else {
            AccesRed.signal();
        }
        moniteur.unlock();
    }

    public String nomStrategie() {
        return "Stratégie: Priorité Lecteurs.";
    }
}
