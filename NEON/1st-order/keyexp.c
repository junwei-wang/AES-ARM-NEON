#include "aes.h"
#include "core.h"

uint8_t rcon[10] = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x1b, 0x36};

void sec_keyexpansion(uint8x16_t k[], uint8x16_t *w[11])
{
  int i;
  uint8x16_t x[2], y[2], z[2], ww[2];
  uint8x16_t tmp = vdupq_n_u8(0x63);
  
  w[0][0] = k[0];
  w[0][1] = k[1];
  
  for (i = 1; i < 11; i++) {
    x[0] = w[i-1][0];
    x[1] = w[i-1][1];
    
    sec_exp254(x, y, z, ww);
    x[0] =  rotatebytes(x[0]);
    x[1] =  rotatebytes(x[1]);
    x[1] = veorq_u8(x[1], tmp);
  
    w[i][0] = xor_rcon(w[i-1][0], rcon[i-1]);
    w[i][0] = keyexp_core(x[0], w[i][0]);
    w[i][1] = keyexp_core(x[1], w[i-1][1]);
  }
}
