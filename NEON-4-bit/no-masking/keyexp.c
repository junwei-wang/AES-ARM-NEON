#include "aes.h"

uint8_t rcon[10] = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x1b, 0x36};

void keyexpansion(uint8x16_t k, uint8x16_t w[11])
{
  int i;
  uint8x16_t x;
  
  w[0] = k;
  for (i = 1; i < 11; i++) {
    x = w[i-1];
    x = sbox(x);
    w[i] = xor_rcon(w[i-1], rcon[i-1]);
    w[i] = keyexp_core(x, w[i]);
  }
}