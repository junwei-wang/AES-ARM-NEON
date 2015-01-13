#include "aes_arm_neon.h"

void sec_shiftrows(uint8x16_t x[], int n)
{
  int i;
  for(i = 0; i < n; i++)
    x[i] = shiftrows(x[i]);
}