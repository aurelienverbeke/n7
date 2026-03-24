#include "aux.h"


int main(int argc, char **argv){
  int    i, j, n, nthreads;
  int *x;
  long ts, te;
  int thread;

   /* Command line argument */
  if ( argc == 3 ) {
    n = atoi(argv[1]);    /* the size of x */
    nthreads = atoi(argv[2]);    /* the number of threads */
  } else {
    printf("Usage:\n\n ./main n nthreads\n\nwhere n is the size of the x array\n");
    printf("and nthreads the number of threads to be used\n");
    return 1;
  }

  x = (int*)calloc(n, sizeof(int));
  init(x, n, nthreads);
  printf("==================================================\n");
  printf("Starting loop\n\n");
  
  ts = usecs();

  #pragma omp parallel num_threads(nthreads) private(i, thread)
  {
    thread = omp_get_thread_num();
    i = thread;
    while(i<n) {
      #pragma omp task firstprivate(i)
      x[i] = update(i, nthreads);
      i += nthreads;
    }

    #pragma omp taskwait
  }
  te = usecs()-ts;
  printf("Execution time: %6ld  msec.\n",te/1000);
  
  return 0;
}
