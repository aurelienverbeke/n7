#import <unistd.h>

syscall0(pid_t, fork);
syscall0(int, exit);
syscall0(pid_t, getpid);
syscall1(int, sleep, int, seconds);