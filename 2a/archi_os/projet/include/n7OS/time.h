#ifndef TIME_H
#define TIME_H

#include <inttypes.h>

#define FREQUENCE_CIBLE 1000 // 1 kHz
#define FREQUENCE_PIT 0x1234BD // 1,19 MHz

#define PORT_CHANNEL_0_PIT 0x40
#define PORT_COMMANDE_PIT 0x43

extern uint32_t timer;

typedef struct {
        uint8_t seconds;
        uint8_t minutes;
        uint8_t hours;
} time_t;
 
void init_timer();
time_t timer_to_time(uint32_t timer);

#endif /* TIME_H */