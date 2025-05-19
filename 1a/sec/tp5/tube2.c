#include <sys/types.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>

int main(int argc, char** argv) {
	pid_t pid;
	int t[2];
	int entierAEcrire = 12;

	if (pipe(t) == -1) {
		perror("Erreur au pipe.\n");
		exit(EXIT_FAILURE);
	}

	if (write(t[1], &entierAEcrire, sizeof(int)) != sizeof(int)) {
		perror("Erreur a l'ecriture.\n");
		exit(EXIT_FAILURE);
	}
	
	pid = fork();

	if (pid == -1) {
		perror("Erreur au fork.\n");
		exit(EXIT_FAILURE);
	}

	else if (pid == 0) { /* fils */
		int entierLu;

		close(t[1]);

		if (read(t[0], &entierLu, sizeof(int)) != sizeof(int)) {
			perror("Erreur a la lecture.\n");
			exit(EXIT_FAILURE);
		}
		
		close(t[0]);

		printf("Nombre lu : %d\n", entierLu);
	}

	else { /* pere */
		close(t[0]);
		close(t[1]);
	}
}
