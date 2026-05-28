#include <stdio.h>
#include <inttypes.h>

void processus1() {
  printf("Hello, world from P1\n");
  for (uint32_t i=0 ; i<500000000 ; i++);
}
