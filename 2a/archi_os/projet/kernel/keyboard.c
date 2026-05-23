#include <n7OS/keyboard.h>

uint16_t key_buffer[256];
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