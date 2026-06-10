#include <unistd.h>
#include <inttypes.h>

syscall2(int, getline, uint8_t*, dst, uint16_t, max_len)