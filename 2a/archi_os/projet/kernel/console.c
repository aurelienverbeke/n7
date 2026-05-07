#include <n7OS/console.h>
#include <n7OS/cpu.h>
#include <n7OS/time.h>
#include <stdio.h>

uint16_t *scr_tab;
uint16_t pos;

void init_console() {
    scr_tab= (uint16_t *) SCREEN_ADDR;
    pos = 0;
}

void scroll(uint16_t necessaryCharNumber) {
    int16_t char_diff = pos + necessaryCharNumber - VGA_WIDTH*VGA_HEIGHT;

    if (char_diff >= 0) {
        uint8_t number_of_lines_to_remove = char_diff / VGA_WIDTH + 1;
        uint8_t remaining_lines = VGA_HEIGHT - number_of_lines_to_remove;
        uint16_t* src = (scr_tab + number_of_lines_to_remove*VGA_WIDTH);
        
        // move up remaining lines
        memmove(scr_tab, src, remaining_lines*VGA_WIDTH*sizeof(uint16_t));

        // move cursor 
        pos = pos - number_of_lines_to_remove*VGA_WIDTH;

        // erase last lines for new characters
        memset(scr_tab+pos, 0, (VGA_WIDTH*VGA_HEIGHT - pos)*sizeof(uint16_t));
    }
}

void console_cursor(int32_t amount) {
    uint16_t new_pos = pos + amount;
    uint8_t low_byte = (uint8_t)(new_pos & 0xFF);
    uint8_t high_byte = (uint8_t)(new_pos >> 8);

    outb(CMD_LOW, PORT_CMD);
    outb(low_byte, PORT_DATA);
    outb(CMD_HIGH, PORT_CMD);
    outb(high_byte, PORT_DATA);

    pos = new_pos;
}

void console_cursor_lf() {
    uint16_t new_pos = pos / VGA_WIDTH * VGA_WIDTH + VGA_WIDTH;
    int32_t amount = new_pos - pos;
    scroll(amount);
    console_cursor(amount);
}

void console_cursor_cr() {
    uint16_t new_pos = pos / VGA_WIDTH;
    int32_t amount = new_pos - pos;
    console_cursor(amount);
}

void console_putchar(const char c) {
    if (c>31 && c<127) {
        scroll(1);
        scr_tab[pos] = (CHAR_COLOR<<8)|c;
        console_cursor(1);
    } else if (c == '\n') {
        scroll(VGA_WIDTH - pos%VGA_WIDTH);
        console_cursor_lf();
    } else if (c == '\r') {
        console_cursor_cr();
    } else if (c == '\b') {
        console_cursor(-1);
    } else if (c == '\t') {
        scroll(8);
        console_putbytes("        ", 8);
    } else if (c == '\f') {
        memset(scr_tab, 0, VGA_WIDTH*VGA_HEIGHT*sizeof(uint16_t));
        pos = 0;
    }
}

void console_putbytes(const char *s, int len) {
    for (int i= 0; i<len; i++) {
        console_putchar(s[i]);
    }
}

void console_print_time() {
    time_t time = timer_to_time(timer);
    uint32_t old_pos = pos;
    pos = VGA_WIDTH-8; // positionner le curseur à 8 caractères de la fin de la première ligne
    printf("%02u:%02u:%02u", time.hours, time.minutes, time.seconds);
    pos = old_pos;
}