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
  x[0] = vld1q_u32(t[0]);
  x[1] = vld1q_u32(t[1]);
  x[2] = vld1q_u32(t[2]); 
}