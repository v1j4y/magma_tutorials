#include <stdio.h>
#include <stdlib.h>
#include "/p/software/juwelsbooster/stages/2020/software/magma/2.5.4-gcccoremkl-9.3.0-2020.2.254/include/magma_v2.h"


// tutorial1_cpu_interface.cc
#include "magma_v2.h"
int main()
{
 magma_init();
 int n = 100, nrhs = 10;
 int lda = n, ldx = n;
 double *A = new double[ lda*n ];
 double *X = new double[ ldx*nrhs ];
 int* ipiv = new int[ n ];

 // ... fill in A and X with your data
 // A[ i + j*lda ] = A_ij
 // X[ i + j*ldx ] = X_ij

 // solve AX = B where B is in X
 int info;
 magma_dgesv( n, nrhs,
 A, lda, ipiv,
 X, ldx, &info );
 //if (info != 0) {
 //throw std::exception();
 //}

 // ... use result in X
 delete[] A;
 delete[] X;
 delete[] ipiv;

 magma_finalize();
 printf("Success CPU !\n");
}
