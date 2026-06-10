#include <n7OS/processus.h>
#include <stddef.h>
#include <n7OS/mem.h>
#include <string.h>
#include <malloc.h>
#include <n7OS/time.h>

processus_t* table_processus[NB_PROC]; // Pour simplifier, on range le PID n à la case n
pid_t processus_courant = -1; // PID du processus actuellement en cours d'exécution
processus_t processus_noyau;
extern uint8_t declencher_scheduler;

extern void ctx_sw(uint32_t* anciens_registres, uint32_t* nouveaux_registres); // Fonction assembleur pour la commutation de contexte

void init_processus() {
    for (int i = 0; i < NB_PROC; i++) {
        table_processus[i] = NULL;
    }

    processus_noyau.pid = 0;
    processus_noyau.etat = ELU;
    strncpy(processus_noyau.nom, "kernel", TAILLE_MAX_NOM_PROC);
    processus_noyau.stack = NULL; // Stack du boot

    table_processus[0] = &processus_noyau;
    processus_courant = 0; // On démarre officiellement au PID 0

    declencher_scheduler = 1;
}

pid_t processus_fork(char* nom, fnptr fonction) {
    pid_t pid = 0;
    processus_t* processus = NULL;

    // Trouver un PID disponible
    while (pid < NB_PROC && table_processus[pid] != NULL) {
        pid++;
    }

    if (pid == NB_PROC) {
            // Pas de PID disponible
            return -1;
    }

    processus = (processus_t*)malloc(sizeof(processus_t));
    if (processus == NULL) {
        // Échec de l'allocation mémoire
        return -1;
    }

    processus->pid = pid;
    processus->etat = PRET;
    strncpy(processus->nom, nom, TAILLE_MAX_NOM_PROC); // Copier le nom du processus
    processus->stack = (uint32_t*)malloc(TAILLE_STACK * sizeof(uint32_t)); // Allouer une page pour la pile du processus
    if (processus->stack == NULL) {
        // Échec de l'allocation mémoire pour la pile
        free(processus);
        return -1;
    }
    processus->registres[0] = 0; // ebx
    processus->registres[1] = (uint32_t)(processus->stack + TAILLE_STACK - 2); // esp (pointeur de pile initial)
    processus->registres[2] = 0; // ebp
    processus->registres[3] = 0; // esi
    processus->registres[4] = 0; // edi
    processus->fonction = fonction;

    // Préparer la pile du processus avec la fonction de retour appelée après return de la fonction éxécutée par le processus
    processus->stack[TAILLE_STACK - 1] = (uint32_t)processus_exit;

    // Préparer la pile du processus pour l'exécution de la fonction
    processus->stack[TAILLE_STACK - 2] = (uint32_t)fonction; // Adresse de la fonction à exécuter

    table_processus[pid] = processus;
    
    return pid;
}

int supprimer_processus(pid_t pid) {
    if (pid < 0 || pid >= NB_PROC || table_processus[pid] == NULL) {
        // PID invalide ou processus non existant
        return -1;
    }

    free(table_processus[pid]->stack); // Libérer la pile du processus
    free(table_processus[pid]); // Libérer le descripteur de processus
    table_processus[pid] = NULL; // Marquer le PID comme disponible
    return 0;
}

int processus_exit() {
    if (processus_courant < 0 || processus_courant >= NB_PROC || table_processus[processus_courant] == NULL) {
        // PID invalide ou processus non existant
        return -1;
    }

    table_processus[processus_courant]->etat = TERMINE;
    printf("exit %d\n", processus_courant);
    schedule(); // Planifier le prochain processus à exécuter
    return 0;
}

pid_t processus_getpid() {
    return processus_courant;
}

int processus_sleep(int seconds) {
    table_processus[processus_courant]->sleep_end_time = timer + seconds*FREQUENCE_CIBLE;
    table_processus[processus_courant]->etat = BLOQUE;
    schedule();
    return 0;
}

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
            if (table_processus[ancien_pid]->etat == ELU) {
                table_processus[ancien_pid]->etat = PRET;
            }
            processus_courant = nouveau_pid; // on le fait là sinon une fois ctw_sw lancé on est foutus
            ctx_sw(table_processus[ancien_pid]->registres, table_processus[nouveau_pid]->registres);
            break;
        }
        // Le processus n'est pas eligible ou n'existe pas, on passe au PID suivant
        nouveau_pid = (nouveau_pid + 1) % NB_PROC;
    }


    // On reste sur le processus courant s'il n'y a pas d'autre processus prêt à s'exécuter
}