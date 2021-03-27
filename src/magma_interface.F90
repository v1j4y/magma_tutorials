module fortinterface
  use iso_c_binding
  use fortmod
  use fortgpumod
  use fortdgemmgpumod
  contains
integer(C_INT) function run_magma_cpu_for() bind ( C , name='run_magma_cpu_for')
   use iso_c_binding
   use fortmod
   implicit none
   call magma_cpu_f()
   run_magma_cpu_for = 0
end function run_magma_cpu_for
integer(C_INT) function run_magma_gpu_for() bind ( C , name='run_magma_gpu_for')
   use iso_c_binding
   use fortgpumod
   implicit none
   call magma_gpu_f()
   run_magma_gpu_for = 0
end function run_magma_gpu_for
integer(C_INT) function run_magma_dgemm_gpu_for() bind ( C , name='run_magma_dgemm_gpu_for')
   use iso_c_binding
   use fortdgemmgpumod
   implicit none
   call magma_dgemm_gpu_f()
   run_magma_dgemm_gpu_for = 0
end function run_magma_dgemm_gpu_for
end module
