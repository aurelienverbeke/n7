#include <inttypes.h>
#include <unistd.h>
#include <string.h>
#include <stdio.h>

#define BUFFER_SIZE 256

extern uint16_t key_buffer_size;

/**
* @brief Un petit terminal tout simple mais tout mignon
*/
void terminal() {
    uint8_t buffer[BUFFER_SIZE];
    int nb_char = 0;

    printf("       ______ ____   _____ \n"
        "      |____  / __ \\ / ____|\n"
        "  _ __    / / |  | | (___\n"
        " | '_ \\  / /| |  | |\\___ \\\n"
        " | | | |/ / | |__| |____) |\n"
        " |_| |_/_/   \\____/|_____/\n\n");

    while(1) {
        // Un tour de boucle par commande
        printf("> ");
        nb_char = 0;

        // Attendre qu'une ligne soit écrite
        do {
            nb_char = getline(buffer, BUFFER_SIZE);
        } while (nb_char == 0);

        if (strcmp(buffer, "help") == 0) {
            printf("Coucouuuuu\nTu peux utiliser shutdown, echo, pid et sleep :)\n");
        } else if (strcmp(buffer, "shutdown") == 0) {
            shutdown(1);
        } else if (strncmp(buffer, "echo", 4) == 0) {
            printf("%s\n", buffer+5);
        } else if (strcmp(buffer, "pid") == 0) {
            printf("%d\n", getpid());
        } else if (strncmp(buffer, "sleep", 5) == 0) {
            sleep(atoi(buffer+6));
        } else {
            printf("%s", buffer);
            printf("Commande non reconnue\n");
        }
    }
}