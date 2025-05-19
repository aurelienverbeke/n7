#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>

#define BUFSIZE 256



int main (int argc, char** argv) {
	if (argc != 3) {
		fprintf(stderr, "Usage : %s source destination\n", argv[0]);
	}
	
	
	
	char buffer[BUFSIZE];
	int fd_source;
	int fd_dest;
	ssize_t nb_lus;



	if ((fd_source = open(argv[1], O_RDONLY)) == -1) {
		fprintf(stderr, "Erreur ouverture fichier source\n");
		exit(EXIT_FAILURE);
	}

	if ((fd_dest = open(argv[2], O_WRONLY|O_CREAT|O_TRUNC, 0644)) == -1) {
		fprintf(stderr, "Erreur ouverture fichier source\n");
		exit(EXIT_FAILURE);
	}

	while ((nb_lus = read(fd_source, buffer, BUFSIZE)) > 0) {
		if (write(fd_dest, buffer, nb_lus) != nb_lus) {
			fprintf(stderr, "Erreur ecriture\n");
			exit(EXIT_FAILURE);
		}
	}

	close(fd_source);
	close(fd_dest);


	return EXIT_SUCCESS;
}
