module fortgpumod
  contains
subroutine magma_gpu_f()
  use magma
  implicit none
  integer :: n, nrhs
  integer :: lda, ldx
  integer :: info
  real*8,dimension(:,:),allocatable::A
  real*8,dimension(:,:),allocatable::X
  integer(kind=8)::dA
  integer(kind=8)::dX
  integer,dimension(:),allocatable::ipiv
  integer, parameter :: sizeof_doubel = 8

  call magmaf_init();
  n = 100
  nrhs = 10
  lda = n
  ldx = n
  allocate(A(lda,n))
  allocate(X(lda,n))
  allocate(ipiv(n))
  call cublas_alloc( lda*n,    sizeof_double, dA )
  call cublas_alloc( lda*n,    sizeof_double, dA )

  call magmaf_dgesv_gpu( n, nrhs,  &
  dA, lda, ipiv,                   &
  dX, ldx, info );

  deallocate(A);
  deallocate(X);
  deallocate(ipiv);
  call cublas_free(dA)
  call cublas_free(dX)

  call magmaf_finalize
  print *,"TEST2(F): Success GPU !\n"
end subroutine magma_gpu_f
end module
