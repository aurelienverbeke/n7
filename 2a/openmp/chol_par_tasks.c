#include "trace.h"
#include "common.h"

/* This is a sequential routine for the LU factorization of a square
   matrix in block-columns */
void chol_par_tasks(matrix_t A){


  int i, j, k;

  #pragma omp parallel private(i,j,k)
  {
    #pragma omp master
    {
      for(k=0; k<A.NB; k++){
        #pragma omp task depend(inout:A.blocks[k][k]) priority(3)
        /* reduce the diagonal block */
        potrf(A.blocks[k][k]);
        
        for(i=k+1; i<A.NB; i++){
          #pragma omp task depend(in:A.blocks[k][k]) depend(inout:A.blocks[i][k]) priority(2)
          /* compute the A[i][k] sub-diagonal block */
          trsm(A.blocks[k][k], A.blocks[i][k]);
          
          for(j=k+1; j<=i; j++){
            #pragma omp task depend(in:A.blocks[i][k],A.blocks[j][k]) depend(inout:A.blocks[i][j]) priority(1)
            /* update the A[i][j] block in the trailing submatrix */
            gemm(A.blocks[i][k], A.blocks[j][k], A.blocks[i][j]);
          }
        }
      }
    }
  }

  return;

}