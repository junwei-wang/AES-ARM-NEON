#include "aes.h"
#include "core.h"

uint8_t rcon[10] = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x1b, 0x36};

void sec_keyexpansion(uint8x16_t k[], uint8x16_t *w[11])
{
  int i;
  uint8x16_t x[3], y[3], z[3], ww[3];
  uint8x16_t tmp = vdupq_n_u8(0x63);
  
  w[0][0] = k[0];
  w[0][1] = k[1];
  w[0][2] = k[2];
  
  for (i = 1; i < 11; i++) {
    x[0] = w[i-1][0];
    x[1] = w[i-1][1];
    x[2] = w[i-1][2];
    
    sec_exp254(x, y, z, ww);
    x[0] =  affine_trans(x[0]);
    x[1] =  affine_trans(x[1]);
    x[2] =  affine_trans(x[2]);
  
    w[i][0] = xor_rcon(w[i-1][0], rcon[i-1]);
    w[i][0] = keyexp_core(x[0], w[i][0]);
    w[i][1] = keyexp_core(x[1], w[i-1][1]);
    w[i][2] = keyexp_core(x[2], w[i-1][2]);
  }
}
