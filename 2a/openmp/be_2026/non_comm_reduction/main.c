#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "omp.h"
#include "aux.h"

long sequential_reduce(long *x, int n);
long parallel_reduce(long *x, int n);


int main(int argc, char **argv){
  int  n, i, s;
  long t_start, t_end;
  long  *x;
  long result;
  
  // Command line argument: array length
  if ( argc == 3 ) {
    n = atoi(argv[1]);    /* the length of the array */
    s = atoi(argv[2]);    /* random generator seed */
  } else {
    printf("Usage:\n\n ./main n s\n\nwhere n is the length of the array to be used and s the seed for the random number generator.\n");
    return 1;
  }


  x=(long *)malloc(sizeof(long)*n);

  
  /* Fill the array with random numbers */
  srand(s);
  init_data(x, n);

  for(i=1; i<n; i++)
    printf("%2ld ",x[i]);
  printf("\n");
  
  /* Sequential reduction */
  t_start = usecs();
  result = sequential_reduce(x, n);
  t_end = usecs();
  printf("Sequential time : %8.2f msec.  ---  Result: %ld\n",((double)t_end-t_start)/1000.0, result);
  



  /* Fill the array with random numbers (same as above)*/
  srand(s);
  init_data(x, n);

  /* Parallel reduction */
  t_start = usecs();
  result = parallel_reduce(x, n);
  t_end = usecs();
  printf("Parallel   time : %8.2f msec.  ---  Result: %ld\n",((double)t_end-t_start)/1000.0, result);

  
  return 0;
}



long sequential_reduce(long *x, int n){
  int i;
  long res;

  res  = init_result();
  
  for(i=1; i<n; i++){
    operator(&res, x+i);
  }
  
  return res;
}



long parallel_reduce(long *x, int n){
  int i;
  long res;
  long* temp_res;
  long n_res;

  res  = init_result();
  
  #pragma omp parallel
  {
    #pragma omp single
    {
      n_res = omp_get_num_threads();
      temp_res = (long*)malloc(n_res*sizeof(long));
      for(i=0; i<n_res; i++) temp_res[i] = init_result();
    }
    
    #pragma omp for
    for(i=1; i<n; i++){
      operator(temp_res+omp_get_thread_num(), x+i);
    }

    #pragma omp master
    for(i=0; i<n_res; i++) operator(&res, temp_res+i);
  }
  
  return res;
}


