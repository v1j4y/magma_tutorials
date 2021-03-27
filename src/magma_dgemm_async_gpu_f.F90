module fortdgemmasyncgpumod
  contains
subroutine magma_dgemm_async_gpu_f()
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
  integer :: dev, res

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
  res = magmaf_dmalloc_pinned( dA, lda*n )
  res = magmaf_dmalloc_pinned( dB, ldb*n )
  res = magmaf_dmalloc_pinned( dC, ldc*n )

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
  call magmaf_queue_sync(que);

  ! C = -A B + C
  call magmaf_dgemm( MagmaNoTrans,  &
  MagmaNoTrans, m, n, k,           &
  -1.d0, dA, lda,                   &
  dB, ldb,                         &
  1.d0, dC, ldc, que );

  ! ... use result in dC
  ! copy result dC to C
  call magmaf_dgetmatrix( n, n,   &
  dC, ldc,                        &
  C, ldc, que );

  ! ... do concurrent work on CPU
  ! wait for gemm to finish
  call magmaf_queue_sync( que );

  call magmaf_queue_destroy( que );

  res = magmaf_free_pinned(dA)
  res = magmaf_free_pinned(dB)
  res = magmaf_free_pinned(dC)
  deallocate(A);
  deallocate(B);
  deallocate(C);
  deallocate(ipiv);

  call magmaf_finalize()
  print *,"TEST4(F): Success DGEMM ASYNC GPU !\n"
end subroutine magma_dgemm_async_gpu_f
end module
