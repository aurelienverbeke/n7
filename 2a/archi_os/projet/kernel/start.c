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
#include <n7OS/sys.h>
#include <unistd.h>

void kernel_start(void)
{
    time_t time;
    uint8_t old_seconds = 0;
    
    //int a = fibonacci();
    
    init_console();
    
    initialise_paging();
    
    init_irq();
    
    init_timer();
    
    init_syscall();

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

    
    /*if(example() == 1) {
        printf("L'appel systeme example fonctionne !\n");
    } else {
        printf("L'appel systeme example ne fonctionne pas !\n");
    }

    printf("Test\n");*/

    // on ne doit jamais sortir de kernel_start
    while (1) {
        /*
        // cette fonction arrete le processeur
        hlt();
        */

        time = timer_to_time(timer);
        //printf("Time: %d seconds\n", time.seconds);
        if (time.seconds != old_seconds) {
            old_seconds = time.seconds;
            console_print_time();
        }
        
        /* POUR TESTER LES INTERRUPTIONS
        if(time.seconds == 10) {
            shutdown(1);
        }
        */
    }
}