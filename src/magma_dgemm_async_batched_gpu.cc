#include <stdio.h>
#include <stdlib.h>
#include "/p/software/juwelsbooster/stages/2020/software/magma/2.5.4-gcccoremkl-9.3.0-2020.2.254/include/magma_v2.h"

int run_magma_dgemm_async_batched_gpu()
{
 magma_init();
 printf("Im batched dgemm\n");
 // ... setup matrices on GPU:
 // m-by-k matrix dA,
 // k-by-n matrix dB,
 // m-by-n matrix dC.
 int n = 256, m = 256, k = 256;
 int lda = n, ldb = n, ldc = n;
 int ldda = magma_roundup( n, 32 );
 int lddb = magma_roundup( n, 32 ); 
 int lddc = magma_roundup( n, 32 ); 
 int tileSize = 16;
 int nTiled = 16;
 int mTiled = 16;
 int kTiled = 16;
 int n1 = 16;
 int* ipiv = new int[ n ];

 double *A = new double[ ldda*n ];
 double *B = new double[ lddb*n ];
 double *C = new double[ lddc*n ];
 
 // Fill A and B
 for(int i=0;i<lda*n;++i)
 {
   A[i] = (float) rand()/RAND_MAX;
 }
 for(int i=0;i<ldb*n;++i)
 {
   B[i] = (float) rand()/RAND_MAX;
 }

 printf("Initializing list of pointers\n");
 double *dA, *dB, *dC;
 magma_dmalloc_pinned( &dA, ldda*n ); 
 magma_dmalloc_pinned( &dB, lddb*n); 
 magma_dmalloc_pinned( &dC, lddc*n); 
 assert( dA != nullptr );
 assert( dB != nullptr );
 assert( dC != nullptr );

 int device;
 magma_queue_t queue;
 magma_getdevice( &device );
 magma_queue_create( device, &queue );

 // copy A, B to dA, dB
 magma_dsetmatrix( n, n,
 A, ldda,
 dA, ldda, queue );

 magma_dsetmatrix( n, n,
 B, lddb,
 dB, lddb, queue );
 magma_queue_sync(queue);

 int batchCount = n/n1;
 int n2 = n - (batchCount * n1);
 int strideA = 0;
 int strideB = lddb*n1;
 int strideC = lddc*n1;

 // C = -A B + C
 magmablas_dgemm_batched_strided(
   MagmaNoTrans, MagmaNoTrans, m, n1, k,
   -1.0, dA, ldda, strideA,
   dB, lddb, strideB,
   1.0,  dC, lddc, strideC,
   batchCount, queue);

 // ... use result in dC
 // copy result dC to C
 magma_dgetmatrix( n, n,
 dC, ldc,
 C, ldc, queue );

 // ... do concurrent work on CPU
 // wait for gemm to finish
 magma_queue_sync( queue );

 magma_queue_destroy( queue );
 // ... cleanup
 magma_free_pinned( dA ); 
 magma_free_pinned( dB );
 magma_free_pinned( dC );
 delete[] A;
 delete[] B;
 delete[] C;
 delete[] ipiv;

 magma_finalize();
 printf("TEST5: Success DGEMM ASYNC BATCHED GPU !\n");
 return 0;
}
