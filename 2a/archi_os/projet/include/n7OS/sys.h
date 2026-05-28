#ifndef __SYS_H__
#define __SYS_H__

#include <n7OS/processus.h>

void init_syscall();

/**
 * @brief Appel système d'exemple
 * @return Toujours 1
 */
int sys_example();

/**
 * @brief Appel système pour éteindre la machine
 * @param n Si n == 1, éteint la machine, sinon retourne n
 * @return -1 si la machine est éteinte, sinon n
 */
int sys_shutdown (int n);

/**
 * @brief Appel système pour écrire sur la console
 * @param buf Le buffer contenant les caractères à écrire
 * @param count Le nombre de caractères à écrire
 * @return Le nombre de caractères écrits
 */
int sys_write(const char* buf, int count);

/**
 * @brief Appel système pour créer un processus
 * @return L'identifiant du processus fils, ou -1 en cas d'erreur
 */
pid_t sys_fork();

/**
 * @brief Appel système pour terminer un processus
 * @return 0 en cas de succès, -1 en cas d'erreur
 */
int sys_exit();

/**
 * @brief Appel système pour obtenir l'identifiant du processus courant
 * @return L'identifiant du processus courant
 */
pid_t sys_getpid();

/**
 * @brief Appel système pour mettre le processus en sommeil
 * @param seconds Nombre de secondes pendant lesquelles le processus doit être en sommeil
 * @return 0 en cas de succès, -1 en cas d'erreur
 */
int sys_sleep(int seconds);

#endif
