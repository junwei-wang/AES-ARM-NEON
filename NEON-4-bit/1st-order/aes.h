#ifndef __AES_H__
#define __AES_H__

#include <arm_neon.h>
#include <time.h>
#include <stdlib.h>

void init();

uint8x16_t sec_aes(uint8x16_t x[], uint8x16_t *w[]);
void keyexpansion(uint8x16_t k, uint8x16_t w[11]);

uint8x16_t sec_sbox(uint8x16_t x[]);
void sec_fmult4(uint8x16_t c[], uint8x16_t a[], uint8x16_t b[]);
void sec_fcubic4(uint8x16_t y[], uint8x16_t x[]);

void sec_keyexpansion(uint8x16_t k[], uint8x16_t *w[11]);
uint8x16_t keyexp_core(uint8x16_t x, uint8x16_t y);
uint8x16_t xor_rcon(uint8x16_t x, uint8_t rcon);


uint8x16_t vxorshf96();
uint8x16x4_t delta(uint8x16_t a);
uint8x16_t delta_inv(uint8x16_t low, uint8x16_t high);

extern uint32x4_t seeds[3];
extern uint8x16_t l[2], h[2], w[2], t[2];


#endif