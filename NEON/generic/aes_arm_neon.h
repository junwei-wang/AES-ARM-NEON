#ifndef __AES_ARM_NEON_H__
#define __AES_ARM_NEON_H__

#include <stdlib.h>
#include <time.h>
#include <arm_neon.h>
#include <stdio.h>
#include "aes_core.h"

#define SHARE_NUM  4

void init();
uint8x16_t vxorshf96();
uint8x16_t rand_uint8x16();
void copy_shares(uint8x16_t to[], uint8x16_t from[], int n);
void print_uint8x16_t(uint8x16_t a);

void sec_fmult(uint8x16_t c[], uint8x16_t a[], uint8x16_t b[], int n);
void sec_h(uint8x16_t y[], uint8x16_t x[], uint8x16_t gx[],
           uint8x16_t (*g_call)(uint8x16_t), int n);
void sec_exp254(uint8x16_t x[], uint8x16_t y[], uint8x16_t z[],
                uint8x16_t w[], int n);
void sec_sbox(uint8x16_t x[], int n);
void sec_asma(uint8x16_t x[], uint8x16_t rk[], int n);
void sec_shiftrows(uint8x16_t x[], int n);
void sec_addroundkey(uint8x16_t x[], uint8x16_t rk[], int n);
uint8x16_t sec_whole_aes(uint8x16_t plain, uint8x16_t key);

uint8x16_t keyexp_core(uint8x16_t x, uint8x16_t y);
uint8x16_t xor_rcon(uint8x16_t x, uint8_t rcon);
void sec_keyexpansion(uint8x16_t k[], uint8x16_t * w[11], int n);

extern uint32x4_t seeds[3];

#endif