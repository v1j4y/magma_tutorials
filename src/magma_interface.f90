module fortinterface
  use iso_c_binding
  use fortmodule
  contains
integer(C_INT) function run_magma_cpu_for() bind ( C , name='run_magma_cpu_for')
   use iso_c_binding
   use fortmodule
   implicit none
   call magma_cpu_f()
   run_magma_cpu_for = 0
end function run_magma_cpu_for
end module
