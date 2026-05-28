#ifndef PROCESSUS_H
#define PROCESSUS_H

#include <inttypes.h>
#include <n7OS/mem.h>

// Nombre maximum de processus que le système peut gérer
#define NB_PROC 256

// Nombre de cases dans la stack
// Avec (PAGE_SIZE/sizeof(uint32_t)), ça crash
#define TAILLE_STACK PAGE_SIZE

// Taille max du nom du processus
#define TAILLE_MAX_NOM_PROC 255

// Type PID pour ne pas se tromper
typedef int32_t pid_t;

// Fonction pour créer un processus
typedef void (*fnptr)();

// États possibles d'un processus
typedef enum {
        ELU,
        PRET,
        BLOQUE,
        TERMINE
} etat_processus;

// Descripteur de processus
typedef struct {
        pid_t pid;
        etat_processus etat;
        char nom[TAILLE_MAX_NOM_PROC+1];
        uint8_t priorite; // Priorité du processus (0 = plus prioritaire)
        uint32_t* stack; // Pile du processus
        uint32_t registres[5]; // Registres ebx, esp, ebp, esi et edi pour le contexte de commutation
        fnptr fonction; // Fonction à exécuter par le processus
} processus_t;

// Table des processus
extern processus_t* table_processus[NB_PROC];
// PID du processus actuellement en cours d'exécution
extern pid_t processus_courant;

/**
 * @brief Initialise la table des processus
 */
void init_processus();

/**
 * @brief Crée un processus
 * @param nom Nom du processus
 * @param priorite Priorité du processus (0 = plus prioritaire)
 * @param fonction Fonction à exécuter par le processus
 * @return PID du processus créé, ou -1 en cas d'erreur
 */
pid_t creer_processus(char* nom, uint8_t priorite, fnptr fonction);

/**
 * @brief Supprime un processus
 * @param pid PID du processus à supprimer
 * @return 0 en cas de succès, -1 en cas d'erreur (PID invalide ou processus non existant)
 */
int supprimer_processus(pid_t pid);

/**
 * @brief Appel système pour créer un processus
 * @return L'identifiant du processus fils, ou -1 en cas d'erreur
 */
pid_t processus_fork();

/**
 * @brief Appel système pour terminer un processus
 * @return 0 en cas de succès, -1 en cas d'erreur
 */
int processus_exit();

/**
 * @brief Appel système pour obtenir l'identifiant du processus courant
 * @return L'identifiant du processus courant
 */
pid_t processus_getpid();

/**
 * @brief Appel système pour mettre le processus en sommeil
 * @param seconds Nombre de secondes pendant lesquelles le processus doit être en sommeil
 * @return 0 en cas de succès, -1 en cas d'erreur
 */
int processus_sleep(int seconds);

#endif