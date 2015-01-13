#include "aes_arm_neon.h"

uint8_t rcon[10] = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x1b, 0x36};

void sec_keyexpansion(uint8x16_t k[], uint8x16_t * w[11], int n)
{
  int i, j;
  uint8x16_t * x = (uint8x16_t *)malloc(sizeof(uint8x16_t) * n);
  
  for (i = 0; i < n; i++)
    w[0][i] = k[i];
  
  for (i = 1; i < 11; i++) {
    copy_shares(x, w[i-1], n);
    sec_sbox(x, n);
  
    w[i][0] = xor_rcon(w[i-1][0], rcon[i-1]);
    w[i][0] = keyexp_core(x[0], w[i][0]);
    for (j = 1; j < n; j++)
      w[i][j] = keyexp_core(x[j], w[i-1][j]);
  }

  free(x);
}
