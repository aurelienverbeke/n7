#include <n7OS/scheduler.h>
#include <stddef.h>
#include <n7OS/cpu.h>

extern void ctx_sw(uint32_t* anciens_registres, uint32_t* nouveaux_registres); // Fonction assembleur pour la commutation de contexte

void schedule() {
    if (processus_courant < 0 || processus_courant >= NB_PROC || table_processus[processus_courant] == NULL) {
        return;
    }

    // Suppression des processus morts
    for (uint16_t pid=0 ; pid<NB_PROC ; pid++) {
        if (table_processus[pid] != NULL && table_processus[pid]->etat == TERMINE) {
            supprimer_processus(pid);
        }
    }

    pid_t ancien_pid = processus_courant;
    pid_t nouveau_pid = (processus_courant + 1) % NB_PROC;
    
    // On parcours tous les processus
    while (nouveau_pid != ancien_pid) {
        if (table_processus[nouveau_pid] != NULL && table_processus[nouveau_pid]->etat == PRET) {
            // On a trouvé un processus éligible
            // On inverse les états
            table_processus[nouveau_pid]->etat = ELU;
            table_processus[ancien_pid]->etat = PRET;
            processus_courant = nouveau_pid; // on le fait là sinon une fois ctw_sw lancé on est foutus
            ctx_sw(table_processus[ancien_pid]->registres, table_processus[nouveau_pid]->registres);
            break;
        }
        // Le processus n'est pas eligible ou n'existe pas, on passe au PID suivant
        nouveau_pid = (nouveau_pid + 1) % NB_PROC;
    }


    // On reste sur le processus courant s'il n'y a pas d'autre processus prêt à s'exécuter
}

/*
void idle() {
    printf("idle\n");
    schedule(); // Appelle le scheduler pour vérifier s'il y a un processus prêt à s'exécuter
    printf("idleapresched\n");
    while (1) {
        printf("idleapresche2\n");
        hlt(); // Fait attendre le processeur jusqu'à la prochaine interruption
        printf("idleapresche3\n");
    }
    printf("idleapresched4\n");
}*/