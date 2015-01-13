#ifndef __CORE_H__
#define __CORE_H__

uint8x16_t fmult(uint8x16_t a, uint8x16_t b);
uint8x16_t fsqur(uint8x16_t a);
uint8x16_t fpow4(uint8x16_t a);
void sec_mult(uint8x16_t c[], uint8x16_t a[], uint8x16_t b[]);
void sec_squr(uint8x16_t dest[], uint8x16_t src[]);
void sec_exp254(uint8x16_t x[], uint8x16_t y[], uint8x16_t z[], uint8x16_t w[]);
uint8x16_t at_sr_mc_ark(uint8x16_t x, uint8x16_t rk);
uint8x16_t at_sr_ark(uint8x16_t x, uint8x16_t rk);
uint8x16_t affine_trans(uint8x16_t x);
uint8x16_t vxorshf96();

void sec_h(uint8x16_t y[], uint8x16_t x[], uint8x16_t gx[], uint8x16_t (*g_call)(uint8x16_t));

uint8x16_t keyexp_core(uint8x16_t x, uint8x16_t y);
uint8x16_t xor_rcon(uint8x16_t x, uint8_t rcon);

extern uint32x4_t x[3];

#endif