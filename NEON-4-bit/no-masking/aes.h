#ifndef __AES_H__
#define __AES_H__

#include <arm_neon.h>

uint8x16_t aes(uint8x16_t x, uint8x16_t w[]);
void keyexpansion(uint8x16_t k, uint8x16_t w[11]);

uint8x16_t sbox(uint8x16_t x);
uint8x16_t keyexp_core(uint8x16_t x, uint8x16_t y);
uint8x16_t xor_rcon(uint8x16_t x, uint8_t rcon);

#endif