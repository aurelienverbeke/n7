#include <n7OS/cpu.h>
#include <inttypes.h>
#include <n7OS/processor_structs.h>
#include <n7OS/console.h>
#include <n7OS/fibonacci.h>
#include <stdio.h>

void kernel_start(void)
{
    //int a = fibonacci();
    
    init_console();
    setup_base(0 /* la memoire virtuelle n'est pas encore definie */);

    // lancement des interruptions
    sti();

    printf("\fHello World!\nHello World!\nHello World!\nHello World!\nHello World!\nHello World!\nHello World!\nHello World!\nHello World!\nHello World!\nHello World!\nHello World!\nHello World!\nHello World!\nHello World!\nHello World!\nHello World!\nHello World!\nHello World!\nHello World!\nHello World!\nHello le monde!\nHello le monde!\nHello le monde!\nHello le monde!\nHello le monde!\nHello le monde!\nHello le monde!\nHello le monde!");

    // on ne doit jamais sortir de kernel_start
    while (1) {
        // cette fonction arrete le processeur
        hlt();
    }
}
