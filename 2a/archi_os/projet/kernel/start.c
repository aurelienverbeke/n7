#include <n7OS/cpu.h>
#include <inttypes.h>
#include <n7OS/processor_structs.h>
#include <n7OS/console.h>
#include <n7OS/fibonacci.h>
#include <stdio.h>
#include <n7OS/paging.h>
#include <n7OS/mem.h>

void init_irq();

void kernel_start(void)
{
    //int a = fibonacci();
    
    init_console();
    
    initialise_paging();
    
    init_irq();
    
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

    // on ne doit jamais sortir de kernel_start
    while (1) {
        // cette fonction arrete le processeur
        hlt();
    }
}