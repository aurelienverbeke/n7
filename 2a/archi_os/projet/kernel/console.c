#include <n7OS/console.h>
#include <n7OS/cpu.h>
#include <n7OS/time.h>
#include <stdio.h>

uint16_t *scr_tab;
uint16_t pos;

void clear_cells(uint16_t *start, uint32_t count) {
    uint16_t value = (CHAR_COLOR << 8) | ' ';

    for (uint32_t i = 0; i < count; i++) {
        start[i] = value;
    }
}

void init_console() {
    scr_tab= (uint16_t *) SCREEN_ADDR;
    pos = 0;
    console_cursor(0);
    clear_cells(scr_tab, VGA_WIDTH*VGA_HEIGHT);
}

void scroll(uint16_t necessaryCharNumber) {
    int16_t char_diff = pos + necessaryCharNumber - VGA_WIDTH*VGA_HEIGHT;

    if (char_diff >= 0) {
        uint8_t number_of_lines_to_remove = char_diff / VGA_WIDTH + 1;
        uint8_t remaining_lines = VGA_HEIGHT - number_of_lines_to_remove;
        uint16_t* src = (scr_tab + number_of_lines_to_remove*VGA_WIDTH);
        
        // move up remaining lines
        memmove(scr_tab, src, remaining_lines*VGA_WIDTH*sizeof(uint16_t));

        // move writing point up 
        pos = pos - number_of_lines_to_remove*VGA_WIDTH;

        // erase last lines for new characters
        clear_cells(scr_tab+pos, VGA_WIDTH*VGA_HEIGHT - pos);
    }
}

void console_cursor(uint16_t position) {
    uint8_t low_byte = (uint8_t)(position & 0xFF);
    uint8_t high_byte = (uint8_t)(position >> 8);

    outb(CMD_LOW, PORT_CMD);
    outb(low_byte, PORT_DATA);
    outb(CMD_HIGH, PORT_CMD);
    outb(high_byte, PORT_DATA);
}

void console_putchar(const char c) {
    if (c>31 && c<127) {
        scroll(1);
        scr_tab[pos] = (CHAR_COLOR<<8)|c;
        pos++;
        console_cursor(pos);
    } else if (c == '\n') {
        uint16_t new_pos = pos / VGA_WIDTH * VGA_WIDTH + VGA_WIDTH;
        int32_t amount = new_pos - pos;
        scroll(amount);
        pos = new_pos;
        console_cursor(pos);
    } else if (c == '\r') {
        pos = pos - pos%VGA_WIDTH;
        console_cursor(pos);
    } else if (c == '\b') {
        if(pos > 0) {
            pos--;
            console_cursor(pos);
        }
    } else if (c == '\t') {
        scroll(8);
        console_putbytes("        ", 8);
    } else if (c == '\f') {
        clear_cells(scr_tab, VGA_WIDTH*VGA_HEIGHT);
        pos = 0;
        console_cursor(pos);
    }
}

void console_putbytes(const char *s, int len) {
    for (int i= 0; i<len; i++) {
        console_putchar(s[i]);
    }
}

void console_print_time() {
    uint8_t timeString[9];
    time_t time = timer_to_time(timer);
    sprintf(timeString, "%02u:%02u:%02u", time.hours, time.minutes, time.seconds);
    for(uint8_t i=0; i<8; i++) {
        scr_tab[VGA_WIDTH-8+i] = (CHAR_COLOR<<8)|timeString[i];
    }
}