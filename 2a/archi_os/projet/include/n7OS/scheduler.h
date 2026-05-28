#ifndef SCHEDULER_H
#define SCHEDULER_H

#include <n7OS/processus.h>

/**
 * @brief Planificateur de processus simple (round-robin)
 * Pas de prise en compte de la priorité pour l'instant, on parcourt simplement la table des processus à la recherche du prochain processus prêt à s'exécuter
 */
void schedule();

/**
 * @brief Fonction d'attente active (idle) qui est exécutée lorsque aucun processus n'est prêt à s'exécuter
 */
//void idle();

#endif