#include <stdio.h>
#include <stdlib.h>
#include "aux.h"
#include "omp.h"


void parallel_ops(int n, int nops, int **board, operation_t *operations);
void sequential_ops(int n, int nops, int **board, operation_t *operations);


int main(int argc, char **argv){
  long   t_start, t_end;
  int    n, nops, op, i, j;
  int  **board;
  operation_t *operations;
  operation_t operation;
  
  if ( argc == 3 ) {
    n    = atoi(argv[1]);
    if(n>10){
      printf("Choose a value of n that is smaller or equal to 10\n");
      return 1;
    }
    nops = atoi(argv[2]);
  } else {
    printf("Usage:\n\n ./main n nops\n\nwhere n is the size of the board and\n");
    printf("nops is the number of operations to execute.\n");
    return 1;
  }

  board      = init_board(n);
  operations = init_operations(nops, n);
  
  print_board(board, n);

  t_start = usecs();
  sequential_ops(n, nops, board, operations);
  t_end = usecs();
  printf("Execution time: %.4f\n",((double)t_end-t_start)/1000.0);

  print_board(board, n);
  reinit_board(n, board);
  
  t_start = usecs();
  parallel_ops(n, nops, board, operations);
  t_end = usecs();
  printf("Execution time: %.4f\n",((double)t_end-t_start)/1000.0);

  print_board(board, n);

}


void sequential_ops(int n, int nops, int **board, operation_t *operations){

  int    op, i, j;
  operation_t operation;

#pragma omp parallel
{
  #pragma omp master  /* éviter que la même tache soit exécuté plusieurs fois */
  {
  for(op=0; op<nops; op++){
    operation = operations[op];
    i = operation.i;
    j = operation.j;
    switch (operation.optype) {
    case LEFT:
    #pragma omp task depend(in : board[i][j-1]) depend(inout : board[i][j]) firstprivate(i, j) /*figer la valeur de i et j pendant la tache*/
      /* printf("%2d  -- LEFT    on %2d %2d   \n",omp_get_thread_num(), i, j); */
      update(&(board[i][j]), board[i][j-1]);
      break;
    case RIGHT:
    #pragma omp task depend(in : board[i][j+1]) depend(inout : board[i][j]) firstprivate(i, j) 
      /* printf("%2d  -- RIGHT   on %2d %2d   \n",omp_get_thread_num(), i, j); */
      update(&(board[i][j]), board[i][j+1]);
      break;
    case UP:
    #pragma omp task depend(in : board[i-1][j]) depend(inout : board[i][j]) firstprivate(i, j)
      /* printf("%2d  -- UP      on %2d %2d   \n",omp_get_thread_num(), i, j); */
      update(&(board[i][j]), board[i-1][j]);
      break;
    case DOWN:
    #pragma omp task depend(in : board[i+1][j]) depend(inout : board[i][j]) firstprivate(i, j)
      /* printf("%2d  -- DOWN    on %2d %2d   \n",omp_get_thread_num(), i, j); */
      update(&(board[i][j]), board[i+1][j]);
      break;
    case GATHER:
    #pragma omp task depend(in : board[i][j-1], board[i][j+1], board[i+1][j], board[i-1][j]) depend(inout : board[i][j]) firstprivate(i, j)
      /* printf("%2d  -- GATHER  on %2d %2d   \n",omp_get_thread_num(), i, j); */
      gather(&(board[i][j]), board[i][j-1], board[i][j+1], board[i+1][j], board[i-1][j]);
      break;
    case SCATTER:
    #pragma omp task depend(in : board[i][j]) depend(inout : board[i][j-1], board[i][j+1], board[i+1][j], board[i-1][j]) firstprivate(i, j)
      /* printf("%2d  -- SCATTER on %2d %2d   \n",omp_get_thread_num(), i, j); */
      scatter((board[i][j]), &board[i][j-1], &board[i][j+1], &board[i+1][j], &board[i-1][j]);
      break;
    default:
      break;// nothing
    }
  }
}
}
}



void parallel_ops(int n, int nops, int **board, operation_t *operations){

  int    op, i, j;
  operation_t operation;

  for(op=0; op<nops; op++){
    operation = operations[op];
    i = operation.i;
    j = operation.j;
    switch (operation.optype) {
    case LEFT:
      /* printf("%2d  -- LEFT    on %2d %2d   \n",omp_get_thread_num(), i, j); */
      update(&(board[i][j]), board[i][j-1]);
      break;
    case RIGHT:
      /* printf("%2d  -- RIGHT   on %2d %2d   \n",omp_get_thread_num(), i, j); */
      update(&(board[i][j]), board[i][j+1]);
      break;
    case UP:
      /* printf("%2d  -- UP      on %2d %2d   \n",omp_get_thread_num(), i, j); */
      update(&(board[i][j]), board[i-1][j]);
      break;
    case DOWN:
      /* printf("%2d  -- DOWN    on %2d %2d   \n",omp_get_thread_num(), i, j); */
      update(&(board[i][j]), board[i+1][j]);
      break;
    case GATHER:
      /* printf("%2d  -- GATHER  on %2d %2d   \n",omp_get_thread_num(), i, j); */
      gather(&(board[i][j]), board[i][j-1], board[i][j+1], board[i+1][j], board[i-1][j]);
      break;
    case SCATTER:
      /* printf("%2d  -- SCATTER on %2d %2d   \n",omp_get_thread_num(), i, j); */
      scatter((board[i][j]), &board[i][j-1], &board[i][j+1], &board[i+1][j], &board[i-1][j]);
      break;
    default:
      break;// nothing
    }
  }
}
