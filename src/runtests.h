#include <stdio.h>

// C
int run_magma_cpu();
int run_magma_gpu();
int run_magma_dgemm_gpu();
int run_magma_dgemm_async_gpu();

// Fortran
extern "C"{
  int run_magma_cpu_for();
  int run_magma_gpu_for();
  int run_magma_dgemm_gpu_for();
  int run_magma_dgemm_async_gpu_for();
}
