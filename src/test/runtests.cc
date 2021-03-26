#include "../runtests.h"

int main()
{

  int res1 = 0;
  int res2 = 0;
  int res4 = 0;

  // Run tests
  res1 = run_magma_cpu(); 
  res2 = run_magma_gpu(); 
  res4 = run_magma_dgemm_gpu(); 
  if(res1==0 && res2==0 && res4==0)
  {
    printf("ALL TEST Passed\n");
  }
  return 0;

}
