#include "aux.h"
#include "omp.h"


int main(int argc, char **argv){
  long t_start, t_end;
  int  i, s, I, S;
  Token token;
  
  if ( argc == 3 ) {
    I = atoi(argv[1]);    /* number of iterations */
    S = atoi(argv[2]);    /* number of stages */
  } else {
    printf("Usage:\n\n ./main I S\n\nsuch that I is the number of iterations and S the number of stages.\n");
    return 1;
  }

  init(&token, I, S);

#pragma omp parallel private (i,s) num_threads(S)
{
  for(i=0; i<I; i++){
    #pragma omp single /* juste pour l'affichage*/
    printf("Iteration %2d\n",i);
    for(s=0; s<S; s++){
      if (s==omp_get_thread_num()) { /* si je suis à l'itération i et je suis le processus i je le mets à jour */
        process(&token, s);
      }
      #pragma omp barrier /* j'attends que tous les processus aient fini de mettre à jour le token pour passer à l'itération suivante
      du coup pas de pb de 2 processus pas sur la même itération essayent d'utiliser la fct° */
    }
  }
}
  check(&token, I, S);
  
  
  return 0;
}
