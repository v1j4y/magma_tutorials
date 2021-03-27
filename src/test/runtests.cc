#include "../runtests.h"

int main()
{

  int res1 = 0;
  int res2 = 0;
  int res4 = 0;
  int res5 = 0;
  int res6 = 0;
  int res7 = 0;
  int res8 = 0;

  // Run tests
  res1 = run_magma_cpu(); 
  res2 = run_magma_gpu(); 
  res4 = run_magma_dgemm_gpu(); 
  res5 = run_magma_dgemm_async_gpu(); 
  res6 = run_magma_cpu_for(); 
  res7 = run_magma_gpu_for(); 
  res8 = run_magma_dgemm_gpu_for(); 
  if(res1==0 && res2==0 && res4==0 && res5==0 && res6==0 && res7==0 && res8==0)
  {
    printf("ALL TEST Passed\n");
  }
  return 0;

}
