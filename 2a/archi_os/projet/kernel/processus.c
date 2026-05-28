#include <n7OS/processus.h>
#include <stddef.h>
#include <n7OS/mem.h>
#include <n7OS/scheduler.h>
#include <string.h>
#include <malloc.h>

processus_t* table_processus[NB_PROC]; // Pour simplifier, on range le PID n à la case n
pid_t processus_courant = -1; // PID du processus actuellement en cours d'exécution
processus_t processus_noyau;

void init_processus() {
    for (int i = 0; i < NB_PROC; i++) {
        table_processus[i] = NULL;
    }

    processus_noyau.pid = 0;
    processus_noyau.etat = ELU;
    strncpy(processus_noyau.nom, "kernel", TAILLE_MAX_NOM_PROC);
    processus_noyau.priorite = 0;
    processus_noyau.stack = NULL; // Stack du boot

    table_processus[0] = &processus_noyau;
    processus_courant = 0; // On démarre officiellement au PID 0
}

pid_t creer_processus(char* nom, uint8_t priorite, fnptr fonction) {
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
    processus->priorite = priorite;
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

// TODO
pid_t processus_fork() {
    processus_t* processus_courant_ptr = table_processus[processus_courant];

    if (processus_courant_ptr == NULL) {
        // Aucun processus en cours d'exécution
        return -1;
    }

    pid_t pid_nouveau_processus = creer_processus(processus_courant_ptr->nom, processus_courant_ptr->priorite, processus_courant_ptr->fonction);
    processus_t* nouveau_processus = table_processus[pid_nouveau_processus];

    // Le processus n'est pas forcément en train de run
    nouveau_processus->etat = PRET;

    // Copier la stack
    memcpy(nouveau_processus->stack, processus_courant_ptr->stack, TAILLE_STACK*sizeof(uint32_t));

    // Se mettre au même point d'éxécution



    return pid_nouveau_processus;
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
    // TODO
    return 0;
}

