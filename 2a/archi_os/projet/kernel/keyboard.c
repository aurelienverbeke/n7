#include <n7OS/keyboard.h>

uint16_t key_buffer[KEY_BUFFER_SIZE];
uint8_t key_buffer_begin = 0;
uint8_t key_buffer_size = 0;
uint8_t shift_pressed = 0;
uint8_t ctrl_pressed = 0;
uint8_t alt_pressed = 0;


void init_keyboard() {
    // Aucune initialisation nécessaire pour le clavier dans ce cas,
    // mais on pourrait envoyer des commandes au contrôleur de clavier ici si besoin
}

uint16_t kgetch() {
    if(key_buffer_size == 0) {
        return 0; // No key in buffer
    }

    uint16_t c = key_buffer[key_buffer_begin];
    key_buffer_begin = (key_buffer_begin + 1) % 256;
    key_buffer_size--;

    return c;
}

int kgetline(uint8_t* dst, uint16_t max_len) {
    uint16_t return_pos = key_buffer_begin;
    uint16_t count = 0;

    // On cherche le premier saut de ligne dans le buffer
    while (key_buffer[return_pos] != KEY_RETURN && ((return_pos + KEY_BUFFER_SIZE - key_buffer_begin) % KEY_BUFFER_SIZE < key_buffer_size)) {
        return_pos = (return_pos+1) % KEY_BUFFER_SIZE;
    }

    if (key_buffer[return_pos] == KEY_RETURN) {
        // On a trouvé un saut de ligne à la position return_pos
        // On copie dans le buffer de sortie
        // Sans dépasser la taille max du buffer
        uint16_t pos = key_buffer_begin;
        while (pos != return_pos && count < max_len-1) {
            // On ajoute tant qu'on est pas sur le caractère de fin de ligne
            // et qu'on n'a pas rempli le buffer de destination
            // il faut penser à laisser la place pour le '\0'
            
            // On remplace les retours en arrière par un effacement de caractère
            if (key_buffer[pos] > 127) {
                // caractère non ascii, on oublie
                goto retour_vide;
            } else if (key_buffer[pos] == KEY_BACKSPACE) {
                // retour arrière, on efface le caractère en retournant en arrière dans le buffer de sortie
                if (count > 0) {
                    count--;
                }
            } else {
                dst[count++] = key_buffer[pos];
            }

            // Retrait du buffer
            key_buffer_begin = (key_buffer_begin + 1) % 256;
            key_buffer_size--;

            // Passage au caractère suivant
            pos = (pos + 1) % KEY_BUFFER_SIZE;
        }

        // On ignore le saut de ligne
        key_buffer_begin = (key_buffer_begin + 1) % 256;
        key_buffer_size--;

        // On remplace le caractère de fin de ligne par le marqueur de fin de chaîne de caractère
        dst[count] = '\0';

        return count;
    }
    
    retour_vide:
        // On n'a pas trouvé de saut de ligne, donc on retroune une ligne de 0 caractères
        return 0;
}