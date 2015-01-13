#include "aes_arm_neon.h"

void sec_addroundkey(uint8x16_t x[], uint8x16_t rk[], int n)
{
  int i;
  for (i = 0; i < n; i++)
    x[i] = veorq_u8(x[i], rk[i]);
}