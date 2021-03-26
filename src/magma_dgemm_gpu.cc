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
 double *A = new double[ lda*n ];
 double *B = new double[ ldb*n ];
 double *C = new double[ ldc*n ];
 
 magma_dmalloc( &dA, lda*n ); 
 magma_dmalloc( &dB, ldb*n); 
 magma_dmalloc( &dC, ldc*n); 
 assert( dA != nullptr );
 assert( dB != nullptr );
 assert( dC != nullptr );

 // Fill A and B
 for(int i=0;i<lda*n;++i)
 {
   A[i] = (float) rand()/RAND_MAX;
 }
 for(int i=0;i<ldb*n;++i)
 {
   B[i] = (float) rand()/RAND_MAX;
 }

 int device;
 magma_queue_t queue;
 magma_getdevice( &device );
 magma_queue_create( device, &queue );

 // copy A, B to dA, dB
 magma_dsetmatrix( n, n,
 A, lda,
 dA, lda, queue );

 magma_dsetmatrix( n, n,
 B, ldb,
 dB, ldb, queue );

 // C = -A B + C
 magma_dgemm( MagmaNoTrans,
 MagmaNoTrans, m, n, k,
 -1.0, dA, lda,
 dB, ldb,
 1.0, dC, ldc, queue );

 // ... do concurrent work on CPU
 // wait for gemm to finish
 magma_queue_sync( queue );

 // ... use result in dC
 // copy result dC to C
 magma_dgetmatrix( n, n,
 dC, ldc,
 C, ldc, queue );

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
