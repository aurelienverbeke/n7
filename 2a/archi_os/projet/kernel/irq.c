#include <inttypes.h>
#include <n7OS/irq.h>
#include <n7OS/time.h>
#include <n7OS/cpu.h>
#include <n7OS/keyboard.h>

extern void handler_IT_timer();
extern void handler_IT_keyboard();

void handler_timer() {
        // Acquitter le PIC
        outb(0x20, PORT_COMMANDE_PIC);
        timer++;
}

void handler_keyboard() {
        uint16_t character;

        // Acquitter le PIC
        outb(0x20, PORT_COMMANDE_PIC);

        // Lire la touche pressée
        uint8_t scancode = inb(KEYB_ENCODER);
        printf("Scancode: 0x%x\n", scancode); // Affiche le scancode pour le débogage

        // Gérer les touches spéciales (Shift, Ctrl, Alt)
        if (scancode == SHIFT_PRESSED) {
                shift_pressed = 1;
        } else if (scancode == SHIFT_RELEASED) {
                shift_pressed = 0;
        } else if (scancode == CTRL_PRESSED) {
                ctrl_pressed = 1;
        } else if (scancode == CTRL_RELEASED) {
                ctrl_pressed = 0;
        } else if (scancode == ALT_PRESSED) {
                alt_pressed = 1;
        } else if (scancode == ALT_RELEASED) {
                alt_pressed = 0;
        // Si la touche est pressée (pas relâchée), on l'ajoute au buffer puisque c'est une touche normale
        } else if (!IS_KEY_RELEASED(scancode) && scancode < 0x58) { // On vérifie que le scancode est dans la plage des touches reconnues
                // Ajouter la touche au buffer
                if(key_buffer_size < 256) {
                        // Convertir le code de scancode en caractère en prenant en compte les touches spéciales
                        if (shift_pressed & !alt_pressed) {
                                character = scancode_map_shift[scancode];
                        } else if (alt_pressed & !shift_pressed) {
                                character = scancode_map_alt[scancode];
                        } else {
                                character = scancode_map[scancode];
                        }

                        // Si la touche est reconnue, l'ajouter au buffer
                        if(character != 0) {
                                key_buffer[(key_buffer_begin + key_buffer_size) % 256] = character;
                                key_buffer_size++;
                        }
                }
        }
}

void init_irq_entry(int irq_num, uint32_t addr) {
        idt_entry_t *entry = (idt_entry_t *)&idt[irq_num];
        entry->offset_inf = addr & 0xFFFF;
        entry->sel_segment = KERNEL_CS;
        entry->zero = 0;
        entry->type_attr = 0x8E; // P=1, DPL=00, S=0, GateType=1110 (32-bit interrupt gate)
        entry->offset_sup = (addr >> 16) & 0xFFFF;
}

void init_irq() {
        // Initialiser les entrées de l'IDT pour les interruptions
        init_irq_entry(ID_INT_TIMER, (uint32_t)handler_IT_timer);
        init_irq_entry(KEYB_IRQ, (uint32_t)handler_IT_keyboard);

        // Activer les interruptions du PIC
        outb(inb(PORT_DONNEES_PIC)&~(1<<NUMERO_PORT_IRQ_TIMER), PORT_DONNEES_PIC);
        outb(inb(PORT_DONNEES_PIC)&~(1<<KEYB_PIC_IRQ), PORT_DONNEES_PIC);
}