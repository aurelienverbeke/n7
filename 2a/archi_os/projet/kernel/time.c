#include <n7OS/time.h>
#include <n7OS/cpu.h>

uint32_t timer = 0;

void init_timer() {
        // Initialiser le timer
        outb(0x34, PORT_COMMANDE_PIT); // Commande pour le mode de fonctionnement du timer

        // Régler la fréquence du timer
        uint32_t diviseur = FREQUENCE_PIT / FREQUENCE_CIBLE;
        outb(diviseur & 0xFF, PORT_CHANNEL_0_PIT);
        outb((diviseur >> 8) & 0xFF, PORT_CHANNEL_0_PIT);
}

time_t timer_to_time(uint32_t timer) {
        time_t time;

        timer /= FREQUENCE_CIBLE; // Convertir les ticks en secondes

        time.seconds = timer % 60;
        time.minutes = (timer / 60) % 60;
        time.hours = (timer / 3600) % 24;
        return time;
}