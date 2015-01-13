#ifndef __AES_CORE_H__
#define __AES_CORE_H__

uint8x16_t fmult(uint8x16_t a, uint8x16_t b);
uint8x16_t fsqur(uint8x16_t a);
uint8x16_t fpow4(uint8x16_t a);
uint8x16_t affine_trans(uint8x16_t x);
uint8x16_t shiftrows(uint8x16_t x);
void sec_fpow16(uint8x16_t a[], int n);

// affine transform, shiftrows, mixcolumns and addroundkey
uint8x16_t at_sr_mc_ark(uint8x16_t x, uint8x16_t rk);
// the same as at_sr_mc_ark, except that affine transformation is not exored with 0x63
uint8x16_t at_sr_mc_ark0(uint8x16_t x, uint8x16_t rk);  

#endif /* __AES_CORE_H__ */