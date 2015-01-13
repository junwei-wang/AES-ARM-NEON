#ifndef __AES_H__
#define __AES_H__

#include <arm_neon.h>
#include <time.h>
#include <stdlib.h>
#include "test.h"

void init(int);
void uninit();

// transformation between represnetation in GF(256) and GF(16)
uint8x16x4_t delta(uint8x16_t a);
uint8x16_t delta_inv(uint8x16_t low, uint8x16_t high);

extern uint8x16_t tb_cubic;
uint8x16_t fmult4(uint8x16_t a, uint8x16_t b);
uint8x16_t fsqur4(uint8x16_t a);
uint8x16_t fcubic4(uint8x16_t a);
uint8x16_t fquar4(uint8x16_t a);

extern uint32x4_t seeds[3];
uint8x16_t vxorshf96();
uint8x16_t vxorshf96_4();

uint8x16x2_t sec_fcubic4_loop(uint8x16_t xi, uint8x16_t xj,
                            uint8x16_t yi, uint8x16_t yj);
void sec_fcubic4(uint8x16_t y[], uint8x16_t x[], int n);
void sec_fmult4(uint8x16_t c[], uint8x16_t a[], uint8x16_t b[], int n);
void sec_sbox(uint8x16_t x[], int n);

uint8x16_t keyexp_core(uint8x16_t x, uint8x16_t y);
uint8x16_t xor_rcon(uint8x16_t x, uint8_t rcon);
void sec_keyexpansion(uint8x16_t k[], uint8x16_t * w[11], int n);

void sec_addroundkey(uint8x16_t x[], uint8x16_t rk[], int n);
uint8x16_t sr_mc_ark(uint8x16_t x, uint8x16_t rk);
uint8x16_t sr_ark(uint8x16_t x, uint8x16_t rk);

void copy_shares(uint8x16_t to[], uint8x16_t from[], int n);
void gen_shares(uint8x16_t x, uint8x16_t x_shares[], int n);
void sec_aes(uint8x16_t x[], uint8x16_t *key[], int n);

#endif