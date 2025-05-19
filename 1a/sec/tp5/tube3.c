#include <sys/types.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>

#define LONGUEUR_SERIE 15
#define N 10

int main(int argc, char** argv) {
	pid_t pid;
	int t[2];
	int entierAEcrire = 12;

	if (pipe(t) == -1) {
		perror("Erreur au pipe.\n");
		exit(EXIT_FAILURE);
	}

	pid = fork();

	if (pid == -1) {
		perror("Erreur au fork.\n");
		exit(EXIT_FAILURE);
	}

	else if (pid == 0) { /* fils */
		int entierLu;
		ssize_t longueur;

		close(t[1]);

		do {
			if ((longueur=read(t[0], &entierLu, sizeof(int))) == -1) {
				perror("Erreur a la lecture.\n");
				exit(EXIT_FAILURE);
			}

			printf("Nombre lu : %d, longueur : %d\n", entierLu, longueur);
		} while (entierLu > 0);

		printf("Sortie boucle.\n");
		
		close(t[0]);
	}

	else { /* pere */
		close(t[0]);
		
		for (int i=0 ; i<L$ONGUEUR_SERIE ; i++) {
			if (write(t[1], &entierAEcrire, sizeof(int)) != sizeof(int)) {
				fprintf(stderr, "Erreur a l'ecriture %d.\n", i);
				exit(EXIT_FAILURE);
			}
			printf("Nombre ecrit : %d\n", i);
			entierAEcrire--;
		}
		
		close(t[1]);

		pause();
	}
}
