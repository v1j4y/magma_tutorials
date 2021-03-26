#include <stdio.h>
#include <stdlib.h>
#include "/p/software/juwelsbooster/stages/2020/software/magma/2.5.4-gcccoremkl-9.3.0-2020.2.254/include/magma_v2.h"

int run_magma_dgemm_gpu()
{
 magma_init();
 // ... setup matrices on GPU:
 // m-by-k matrix dA,
 // k-by-n matrix dB,
 // m-by-n matrix dC.
 int n = 100, m = 100, k = 100;
 int lda = n, ldb = n, ldc = n;
 int ldda = magma_roundup( n, 32 );
 int lddb = magma_roundup( n, 32 ); 
 int lddc = magma_roundup( n, 32 ); 
 int* ipiv = new int[ n ];

 double *dA, *dB, *dC;
 magma_dmalloc( &dA, ldda*n ); 
 magma_dmalloc( &dB, lddb*n); 
 magma_dmalloc( &dC, lddc*n); 
 assert( dA != nullptr );
 assert( dB != nullptr );
 assert( dC != nullptr );

 int device;
 magma_queue_t queue;
 magma_getdevice( &device );
 magma_queue_create( device, &queue );
 // C = -A B + C
 magma_dgemm( MagmaNoTrans,
 MagmaNoTrans, m, n, k,
 -1.0, dA, ldda,
 dB, lddb,
 1.0, dC, lddc, queue );
 // ... do concurrent work on CPU
 // wait for gemm to finish
 magma_queue_sync( queue );

 // ... use result in dC
 magma_queue_destroy( queue );
 // ... cleanup
 magma_free( dA ); 
 magma_free( dB );
 magma_free( dC );
 delete[] ipiv;

 magma_finalize();
 printf("TEST4: Success DGEMM CPU !\n");
 return 0;
}
