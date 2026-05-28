#include <n7OS/sys.h>
#include <n7OS/sys.h>
#include <n7OS/syscall_defs.h>
#include <n7OS/console.h>
#include <n7OS/irq.h>
#include <unistd.h>
#include <n7OS/cpu.h>

extern void handler_syscall();
extern void console_putchar(const char c);

void init_syscall() {
    // ajout de la fonction de traitement de l'appel systeme
    add_syscall(NR_example, sys_example);
    add_syscall(NR_shutdown, sys_shutdown);
    add_syscall(NR_write, sys_write);
    add_syscall(NR_fork, sys_fork);
    add_syscall(NR_exit, sys_exit);
    add_syscall(NR_getpid, sys_getpid);
    add_syscall(NR_sleep, sys_sleep);
    // initialisation de l'IT soft qui gère les appels systeme
    init_irq_entry(0x80, (uint32_t) handler_syscall);
}

// code de la fonction de traitement de l'appel systeme example
int sys_example() {
    // on ne fait que retourner 1
    return 1;
}

int sys_shutdown (int n) {
    if (n == 1) {
        outw (0x2000, 0x604); // Poweroff qemu > 2.0
        return -1;
    } else
        return n;
}

int sys_write(const char* buf, int count) {
    for (size_t i = 0; i < (size_t)count; i++) {
        console_putchar(buf[i]);
    }
    return count;
}

pid_t sys_fork() {
    return processus_fork();
}

int sys_exit() {
    return processus_exit();
}

pid_t sys_getpid() {
    return processus_getpid();
}

int sys_sleep(int seconds) {
    return processus_sleep(seconds);
}