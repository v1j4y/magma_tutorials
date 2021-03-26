program magma_cpu_f
  use magma_dfortran
  implicit none
  integer :: n, nrhs
  integer :: lda, ldx
  integer :: info
  real*8,dimension(:,:),allocatable::A
  real*8,dimension(:,:),allocatable::X
  integer,dimension(:),allocatable::ipiv

  call magmaf_init;
  n = 100
  nrhs = 10
  lda = n
  ldx = n
  allocate(A(lda,n))
  allocate(X(lda,n))
  allocate(ipiv(n))

  call magmaf_dgesv( n, nrhs,  &
  A, lda, ipiv,                &
  X, ldx, info );

  deallocate(A);
  deallocate(X);
  deallocate(ipiv);

  call magmaf_finalize
  print *,"Success CPU !\n"
end program magma_cpu_f
