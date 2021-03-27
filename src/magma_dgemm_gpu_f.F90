module fortdgemmgpumod
  contains
subroutine magma_dgemm_gpu_f()
  use magma
  implicit none
  integer :: n, m, k
  integer :: lda, ldb, ldc
  integer :: info
  real*8,dimension(:,:),allocatable::A
  real*8,dimension(:,:),allocatable::C
  real*8,dimension(:,:),allocatable::B
  integer(kind=8)::dA
  integer(kind=8)::dB
  integer(kind=8)::dC
  integer,dimension(:),allocatable::ipiv
  integer(KIND=8):: que
  integer :: dev

  call magmaf_init();
  n = 100
  m = 100
  k = 100
  lda = n
  ldb = n
  ldc = n
  allocate(A(lda,n))
  allocate(B(lda,n))
  allocate(C(lda,n))
  allocate(ipiv(n))
  call cublas_alloc( lda*n,    sizeof_double, dA )
  call cublas_alloc( lda*n,    sizeof_double, dB )
  call cublas_alloc( lda*n,    sizeof_double, dC )

  call RANDOM_NUMBER(A)
  call RANDOM_NUMBER(B)

  call magmaf_getdevice(dev)
  call magmaf_queue_create(dev, que)

  ! copy A, B to dA, dB
  call magmaf_dsetmatrix( n, n,    &
  A, lda,                          &
  dA, lda, que );

  call magmaf_dsetmatrix( n, n,    &
  B, ldb,                          &
  dB, ldb, que );

  ! C = -A B + C
  call magmaf_dgemm( MagmaNoTrans,  &
  MagmaNoTrans, m, n, k,           &
  -1.d0, dA, lda,                   &
  dB, ldb,                         &
  1.d0, dC, ldc, que );

  ! ... do concurrent work on CPU
  ! wait for gemm to finish
  call magmaf_queue_sync( que );

  ! ... use result in dC
  ! copy result dC to C
  call magmaf_dgetmatrix( n, n,   &
  dC, ldc,                        &
  C, ldc, que );

  call magmaf_queue_destroy( que );

  call cublas_free(dA)
  call cublas_free(dB)
  call cublas_free(dC)
  deallocate(A);
  deallocate(B);
  deallocate(C);
  deallocate(ipiv);

  call magmaf_finalize()
  print *,"TEST3(F): Success DGEMM GPU !\n"
end subroutine magma_dgemm_gpu_f
end module
