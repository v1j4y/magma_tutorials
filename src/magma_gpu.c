#include <stdio.h>
#include <stdlib.h>
#include "/p/software/juwelsbooster/stages/2020/software/magma/2.5.4-gcccoremkl-9.3.0-2020.2.254/include/magma_v2.h"

// tutorial2_gpu_interface.cc
int main(  )
{
 magma_init();
 int n = 100, nrhs = 10;
 int ldda = magma_roundup( n, 32 );
 int lddx = magma_roundup( n, 32 ); 
 int* ipiv = new int[ n ];

 double *dA, *dX;
 magma_dmalloc( &dA, ldda*n ); 
 magma_dmalloc( &dX, lddx*nrhs ); 
 assert( dA != nullptr );
 assert( dX != nullptr );
 // ... fill in dA and dX (on GPU)
 // solve AX = B where B is in X
 int info;
 magma_dgesv_gpu( n, nrhs,
 dA, ldda, ipiv,
 dX, lddx, &info );
 //if (info != 0) {
 //throw std::exception();
 //}

 // ... use result in dX
 magma_free( dA ); magma_free( dX );
 delete[] ipiv;

 magma_finalize(); 
 printf("Success GPU !\n");
}
