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

#endif
