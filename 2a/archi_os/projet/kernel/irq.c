#include <inttypes.h>
#include <n7OS/irq.h>
#include <n7OS/time.h>
#include <n7OS/cpu.h>

extern void handler_IT_timer();

void handler_timer() {
        // Acquitter le PIC
        outb(0x20, PORT_COMMANDE_PIC);
        timer++;
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

        // Activer les interruptions du PIC
        outb(inb(PORT_DONNEES_PIC)&~(1<<NUMERO_PORT_IRQ_TIMER), PORT_DONNEES_PIC);
}