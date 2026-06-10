#import <unistd.h>
#import <n7OS/processus.h>

syscall2(pid_t, fork, char*, nom, fnptr, fonction);
syscall0(int, exit);
syscall0(pid_t, getpid);
syscall1(int, sleep, int, seconds);