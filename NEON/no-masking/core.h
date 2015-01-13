#ifndef __CORE_H__
#define __CORE_H__

uint8x16_t fmult(uint8x16_t a, uint8x16_t b);
uint8x16_t fsqur(uint8x16_t a);
uint8x16_t affine_trans(uint8x16_t x);
uint8x16_t exp254(uint8x16_t x);
uint8x16_t at_sr_mc_ark(uint8x16_t x, uint8x16_t rk);
uint8x16_t at_sr_ark(uint8x16_t x, uint8x16_t rk);

uint8x16_t keyexp_core(uint8x16_t x, uint8x16_t y);
uint8x16_t xor_rcon(uint8x16_t x, uint8_t rcon);

extern uint8x16_t tbl_shiftrows;

#endif