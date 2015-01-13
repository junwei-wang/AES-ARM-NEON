#include "aes.h"
#include <time.h>

void init()
{
  // initialize
  srand(time(NULL));
  
  int i, j;
  uint32_t t[3][4];
  for (i = 0; i < 3; i++)
    for (j = 0; j < 4; j++)
      t[i][j] = rand();
  seeds[0] = vld1q_u32(t[0]);
  seeds[1] = vld1q_u32(t[1]);
  seeds[2] = vld1q_u32(t[2]); 
}