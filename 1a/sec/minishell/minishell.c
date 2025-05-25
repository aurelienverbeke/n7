#include <stdio.h>
#include <stdlib.h>
#include "readcmd.h"
#include <stdbool.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <dirent.h>



#define LECTURE 0
#define ECRITURE 1



void handlerFilsTermine() {
	int status;
	pid_t pid = waitpid(-1, &status, WNOHANG|WUNTRACED|WCONTINUED);

	if (WIFEXITED(status)) {
		fprintf(stderr, "Handler : Fils %d termine avec le code %d\n", pid, WEXITSTATUS(status));
	} else if (WIFSTOPPED(status)) {
		fprintf(stderr, "Handler : Fils %d suspendu\n", pid);
	} else if (WIFCONTINUED(status)) {
		fprintf(stderr, "Handler : Fils %d repris\n", pid);
	} else if (WIFSIGNALED(status)) {
		fprintf(stderr, "Handler : Fils %d tue\n", pid);
	}
}



void handlerCtrlCZ() {
	fprintf(stderr, "Signal ignore par le pere.");
}



void changerRepertoireCourant(const char* _nouveauRepertoire) {
	char erreur[512];
	char* nouveauRepertoire;

	// pas de repertoire fourni, on va dans le HOME
	if (_nouveauRepertoire == NULL) {
		nouveauRepertoire = getenv("HOME");
		sprintf(erreur, "Erreur changement repertoire vers home\n");
	}

	// on va dans le repertoire fourni
	else {
		nouveauRepertoire = malloc(256*sizeof(char));
		strcpy(nouveauRepertoire, _nouveauRepertoire);
		sprintf(erreur, "Erreur changement repertoire vers %s\n", nouveauRepertoire);
	}
	
	// execution du changement de repertoire
	if (chdir(nouveauRepertoire) == -1) {
		fprintf(stderr, erreur);
		exit(EXIT_FAILURE);
	}
}



void afficherRepertoire(const char* _repertoire) {
	char erreur[512];
	char* repertoire;
	DIR* entreesRepertoire;
	struct dirent* entreeRepertoire;

	// pas de repertoire fourni, on affiche le repertoire courant
	if (_repertoire == NULL) {
		repertoire = getcwd(NULL, 0);
		sprintf(erreur, "Erreur ouverture repertoire courant\n");
	}

	// on affiche le repertoire fourni
	else {
		repertoire = malloc(256*sizeof(char));
		strcpy(repertoire, _repertoire);
		sprintf(erreur, "Erreur ouverture repertoire %s\n", repertoire);
	}

	// ouverture du repertoire
	if ((entreesRepertoire = opendir(repertoire)) == NULL) {
		fprintf(stderr, erreur);
		exit(EXIT_FAILURE);
	}

	// affichage du contenu
	while ((entreeRepertoire = readdir(entreesRepertoire)) != NULL) {
		printf("%s\n", entreeRepertoire->d_name);
	}

	// fermeture du repertoire
	if (closedir(entreesRepertoire) == -1) {
		fprintf(stderr, "Erreur fermeture repertoire\n");
		exit(EXIT_FAILURE);
	};
}



int main(void) {
	bool fini = false;

	struct sigaction actionFilsTermine;
	//struct sigaction actionCtrlCZ;
	//struct sigaction actionIgnorer;
	//struct sigaction actionDefaut;

	sigset_t masquePere;
	sigset_t masqueFils;

	
	
	actionFilsTermine.sa_handler = handlerFilsTermine;
	actionFilsTermine.sa_flags = SA_RESTART;
	sigemptyset(&actionFilsTermine.sa_mask);

	/*
	actionCtrlCZ.sa_handler = handlerCtrlCZ;
	actionCtrlCZ.sa_flags = SA_RESTART;
	sigemptyset(&actionCtrlCZ.sa_mask);

	actionIgnorer.sa_handler = SIG_IGN;
	actionIgnorer.sa_flags = SA_RESTART;
	sigemptyset(&actionIgnorer.sa_mask);

	actionDefaut.sa_handler = SIG_DFL;
	actionDefaut.sa_flags = SA_RESTART;
	sigemptyset(&actionDefaut.sa_mask);
	*/



	sigemptyset(&masqueFils);
	
	sigemptyset(&masquePere);
	sigaddset(&masquePere, SIGINT);
	sigaddset(&masquePere, SIGTSTP);



	if (sigaction(SIGCHLD, &actionFilsTermine, NULL) == -1) {
		exit(EXIT_FAILURE);
	}

	/*
	if (sigaction(SIGTSTP, &actionIgnorer, NULL) == -1) {
		exit(EXIT_FAILURE);
	}
	
	if (sigaction(SIGINT, &actionIgnorer, NULL) == -1) {
		exit(EXIT_FAILURE);
	}
	*/

	sigprocmask(SIG_SETMASK, &masquePere, NULL);




	while (!fini) {
		printf("(%s) > ", getcwd(NULL, 0));
		struct cmdline *ligneCommande = readcmd();

		if (ligneCommande == NULL) {
			// ligneCommande == NULL -> erreur readcmd()
			perror("erreur lecture ligneCommande \n");
			exit(EXIT_FAILURE);
		}
	
		else {
			if (ligneCommande->err) {
				// ligneCommande->err != NULL -> ligneCommande->seq == NULL
				printf("erreur saisie de la ligneCommande : %s\n", ligneCommande->err);
			}
			
			else {
				int indexCommande = 0;
				char **commande;

				int ancienTube[2];
				int tube[2]; // pour pipeline

				while ((commande = ligneCommande->seq[indexCommande])) {
					int existeCommandeSuivante = (ligneCommande->seq[indexCommande+1] != NULL);

					if (commande[0]) {
						//fprintf(stderr, "%s\n", commande[0]);
						ancienTube[LECTURE] = tube[LECTURE];
						ancienTube[ECRITURE] = tube[ECRITURE];
						// il y a une commande qui suit la commande actuelle
						// preparation du tube pour la pipeline
						if (existeCommandeSuivante) {
							if (pipe(tube) == -1) {
								perror("Erreur a la creation du tube\n");
								exit(EXIT_FAILURE);
							}
							//fprintf(stderr, "Tube : %d %d\n", tube[LECTURE], tube[ECRITURE]);
						}	

						if (strcmp(commande[0], "exit") == 0) {
							fini = true;
							printf("Au revoir ...\n");
						}

						else if (strcmp(commande[0], "cd") == 0) {
							changerRepertoireCourant(commande[1]);
						}

						else if (strcmp(commande[0], "dir") == 0) {
							afficherRepertoire(commande[1]);
						}
						
						else {
							pid_t pidFils = fork();

							if (pidFils == -1) {
								/* erreur */
								exit(EXIT_FAILURE);
							}
							else if (pidFils == 0) {
								/* fils */
								/*
								if (sigaction(SIGTSTP, &actionDefaut, NULL) == -1) {
									exit(EXIT_FAILURE);
								}
								
								if (sigaction(SIGINT, &actionDefaut, NULL) == -1) {
									exit(EXIT_FAILURE);
								}
								*/

								// redirections
								if (ligneCommande->in != NULL) {
									int fdSource;

									if ((fdSource = open(ligneCommande->in, O_RDONLY)) == -1) {
										fprintf(stderr, "Erreur ouverture fichier source\n");
										exit(EXIT_FAILURE);
									}

									if (dup2(fdSource, 0) == -1) {
										fprintf(stderr, "Erreur duplication source\n");
										exit(EXIT_FAILURE);
									}

									close(fdSource);
								}
								if (ligneCommande->out != NULL) {
									int fdDest;

									if ((fdDest = open(ligneCommande->out, O_WRONLY|O_CREAT|O_TRUNC, 0644)) == -1) {
										fprintf(stderr, "Erreur ouverture fichier destination\n");
										exit(EXIT_FAILURE);
									}

									if (dup2(fdDest, 1) == -1) {
										fprintf(stderr, "Erreur duplication destination\n");
										exit(EXIT_FAILURE);
									}

									close(fdDest);
								}

								// pipelines
								// sortie
								if (existeCommandeSuivante) {
									//fprintf(stderr, "Stdout %d\n", tube[ECRITURE]);
									close(tube[LECTURE]);
									if (dup2(tube[ECRITURE], 1) == -1) {
										fprintf(stderr, "Erreur duplication tube dans stdout\n");
										exit(EXIT_FAILURE);
									}
									close(tube[ECRITURE]);
								}
								//entree
								if (indexCommande > 0) {
									//fprintf(stderr, "Stdin %d\n", ancienTube[LECTURE]);
									close(ancienTube[ECRITURE]);
									if (dup2(ancienTube[LECTURE], 0) == -1) {
										fprintf(stderr, "Erreur duplication tube dans stdin\n");
										exit(EXIT_FAILURE);
									}
									close(ancienTube[LECTURE]);
								}

								sigprocmask(SIG_SETMASK, &masqueFils, NULL);

								if (ligneCommande->backgrounded != NULL) {
									setpgrp();
								}

								execvp(commande[0], commande);
								exit(EXIT_FAILURE);
							}
							else {
								/* pere */
								
								// commande en avant-plan
								if (ligneCommande->backgrounded == NULL) {
									/*
									int status;
									if (waitpid(pidFils, &status, 0) == -1) {
										exit(EXIT_FAILURE);
									};
									*/
									pause();
									if (existeCommandeSuivante) {
										close(tube[ECRITURE]);
									}
									if (indexCommande > 0) {
										close(ancienTube[LECTURE]);
									}
								}
							}
						}

						indexCommande++;
					}
				}
			}
		}
	}
	return EXIT_SUCCESS;
}
