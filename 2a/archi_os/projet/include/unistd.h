#ifndef __UNISTD_H__
#define __UNISTD_H__

#include <n7OS/processus.h>

#define NR_example 0
#define NR_shutdown 1
#define NR_write 2
#define NR_fork 3
#define NR_exit 4
#define NR_getpid 5
#define NR_sleep 6
#define NR_getline 7

// Fonction d'enveloppe sans argument
#define syscall0(type,name) \
type name(void) \
{ \
type __res; \
__asm__ volatile ("int $0x80" \
	: "=a" (__res) \
	: "0" (NR_##name)); \
	return __res; \
}

// Fonction d'enveloppe 1 argument
#define syscall1(type,name,atype,a) \
type name(atype a) \
{ \
type __res; \
__asm__ volatile ("int $0x80" \
	: "=a" (__res) \
	: "0" (NR_##name),"b" (a)); \
	return __res; \
}

// Fonction d'enveloppe 2 arguments
#define syscall2(type,name,atype,a,btype,b) \
type name(atype a,btype b) \
{ \
type __res; \
__asm__ volatile ("int $0x80" \
	: "=a" (__res) \
	: "0" (NR_##name),"b" (a),"c" (b)); \
	return __res; \
}

// Fonction d'enveloppe 3 arguments
#define syscall3(type,name,atype,a,btype,b,ctype,c) \
type name(atype a,btype b,ctype c) \
{ \
type __res; \
__asm__ volatile ("int $0x80" \
	: "=a" (__res) \
	: "0" (NR_##name),"b" (a),"c" (b),"d" (c)); \
return __res;\
}

/**
 * @brief Appel système d'exemple
 * @return Toujours 1
 */
int example();

/**
 * @brief Appel système pour éteindre le système
 * @param n Doit valoir 1 pour éteindre le système, sinon ne fait rien
 * @return Ne retourne jamais car le système s'arrête
 */
int shutdown (int n);

/**
 * @brief Appel système pour écrire une chaîne de caractères sur la console
 * @param s Chaîne de caractères à écrire
 * @param len Longueur de la chaîne de caractères
 * @return Nombre de caractères écrits
 */
int write(const char *s, int len);

/**
 * @brief Crée un processus
 * @param nom Nom du processus
 * @param fonction Fonction à exécuter par le processus
 * @return PID du processus créé, ou -1 en cas d'erreur
 */
pid_t fork(char* nom, fnptr fonction);

/**
 * @brief Appel système pour terminer un processus
 * @return 0 en cas de succès, -1 en cas d'erreur
 */
int exit();

/**
 * @brief Appel système pour obtenir l'identifiant du processus courant
 * @return Identifiant du processus courant
 */
pid_t getpid();

/**
 * @brief Appel système pour mettre le processus en sommeil
 * @param seconds Nombre de secondes pendant lesquelles le processus doit être en sommeil
 * @return 0 en cas de succès, -1 en cas d'erreur
 */
int sleep(int seconds);

/**
 * @brief Appel système pour mettre lire une ligne dans le buffer du clavier
 * Ne copie pas le caractère de fin de ligne
 * @param dst Buffer de destination dans lequel la ligne sera copiée
 * @param max_len Taille du buffer de destination
 * @return Nombre de caractères copiés
 */
int getline(uint8_t* dst, uint16_t max_len);

#endif
