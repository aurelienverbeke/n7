#include <n7OS/cpu.h>
#include <inttypes.h>
#include <n7OS/processor_structs.h>
#include <n7OS/console.h>
#include <n7OS/fibonacci.h>
#include <stdio.h>
#include <n7OS/paging.h>
#include <n7OS/mem.h>
#include <n7OS/irq.h>
#include <n7OS/time.h>

void kernel_start(void)
{
    time_t time;
    uint8_t old_seconds = 0;
    
    //int a = fibonacci();
    
    init_console();
    
    initialise_paging();
    
    init_irq();
    
    init_timer();
    
    // lancement des interruptions
    sti();

    /** POUR DEBUG, doit crash si on enlève l'allocation avant pour pagefault
    alloc_page_entry(0xA0000000, 1, 1);
    uint32_t* pointeur_trop_loin = 0xA0000000;
    uint32_t valeur = *pointeur_trop_loin;
    valeur++;
    */

    /** POUR TESTER LES INTERRUPTIONS
    // lancer l'interruption 50
    __asm__ ("int $50" : : );
    */

    printf("\f");
    console_print_time();

    // on ne doit jamais sortir de kernel_start
    while (1) {
        /*
        // cette fonction arrete le processeur
        hlt();
        */

        time = timer_to_time(timer);
        if (time.seconds != old_seconds) {
            old_seconds = time.seconds;
            console_print_time();
        }
    }
}