#include <sys/types.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <signal.h>

#define LONGUEUR_SERIE 15
#define N 10000

void handlerVide(int signal) {
}

int main(int argc, char** argv) {
	pid_t pid;
	int t[2];
	char octets[N];
	struct sigaction actionIgnorer;

	actionIgnorer.sa_handler = handlerVide;
	sigemptyset(&actionIgnorer.sa_mask);
	actionIgnorer.sa_flags = SA_RESTART;
		
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
		ssize_t longueur;
		char octetsLus[10*N];

		close(t[1]);

		sigaction(SIGUSR1, &actionIgnorer, NULL);
		pause();

		for (int i=0 ; i<N ; i++) {
			if ((longueur=read(t[0], octetsLus, sizeof(char)*10*N)) == -1) {
				perror("Erreur a la lecture.\n");
				exit(EXIT_FAILURE);
			}

			printf("Longueur lue : %d\n", longueur);
		}

		printf("Sortie boucle.\n");
		
		close(t[0]);
	}

	else { /* pere */
		ssize_t longueur;
		
		close(t[0]);
		
		while (1) {
			longueur = write(t[1], octets, sizeof(char)*N);
			sleep(1);
			printf("Longueur ecrite : %d\n", longueur);
		}
	}
}
