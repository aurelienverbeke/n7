// Time-stamp: <06 jui 2023 11:58 Philippe Queinnec>

import CSP.*;

/** Réalisation de la voie unique avec des canaux JCSP. */
/* Version par automate d'états */
public class VoieUniqueAutomate implements VoieUnique {

    enum ChannelId { EntrerNS, EntrerSN, Sortir };
    
    private Channel<ChannelId> entrerNS;
    private Channel<ChannelId> entrerSN;
    private Channel<ChannelId> sortir;
    
    public VoieUniqueAutomate() {
        this.entrerNS = new Channel<>(ChannelId.EntrerNS);
        this.entrerSN = new Channel<>(ChannelId.EntrerSN);
        this.sortir = new Channel<>(ChannelId.Sortir);
        (new Thread(new Scheduler())).start();
    }

    public void entrer(Sens sens) {
        System.out.println("In  entrer " + sens);
        switch (sens) {
          case NS:
            entrerNS.write(true);
            break;
          case SN:
            entrerSN.write(true);
            break;
        }
        System.out.println("Out entrer " + sens);
    }

    public void sortir(Sens sens) {
        System.out.println("In  sortir " + sens);
        sortir.write(true);
        System.out.println("Out sortir " + sens);
    }

    public String nomStrategie() {
        return "Automate";
    }

    /****************************************************************/

    enum Etat { Libre, OccupeNS, OccupeSN }
    class Scheduler implements Runnable {
        private Etat etat = Etat.Libre;
        private int nb = 0;

        public void run() {
            var altNS = new Alternative<>(entrerNS, sortir);
            var altSN = new Alternative<>(entrerSN, sortir);
            var altLibre = new Alternative<>(entrerNS, entrerSN);

            while(true) {
                if (etat == Etat.Libre) {
                    switch (altLibre.select()) {
                        case EntrerNS:
                            entrerNS.read();
                            nb++;
                            etat = Etat.OccupeNS;
                            break;
                        case EntrerSN:
                            entrerSN.read();
                            nb++;
                            etat = Etat.OccupeSN;
                            break;
                    }
                } else if (etat == Etat.OccupeNS) {
                    switch (altNS.select()) {
                        case EntrerNS:
                            entrerNS.read();
                            nb++;
                            break;
                        case Sortir:
                            sortir.read();
                            if (nb == 1) {
                                etat = Etat.Libre;
                            }
                            nb--;
                            break;
                    }
                } else if (etat == Etat.OccupeSN) {
                    switch (altSN.select()) {
                        case EntrerSN:
                            entrerSN.read();
                            nb++;
                            break;
                        case Sortir:
                            sortir.read();
                            if (nb == 1) {
                                etat = Etat.Libre;
                            }
                            nb--;
                            break;
                    }
                }
            }
        }
    } // class Scheduler
}

