#include "aes_arm_neon.h"

uint8x16_t y[SHARE_NUM], z[SHARE_NUM], w[SHARE_NUM];

uint8x16_t rand_uint8x16()
{
  uint32_t r[4];
  int i;
  for (i = 0; i < 4; i++)
    r[i] = rand();
  return vreinterpretq_u8_u32(vld1q_u32(r));
  //return vxorshf96();
  //return vdupq_n_u8(0xa5);  
}

void sec_exp254(uint8x16_t x[], uint8x16_t y[], uint8x16_t z[], uint8x16_t w[], int n)
{
  sec_h(y, x, z, fsqur, n);  // z = x^2,  y = x^3
  sec_h(x, y, w, fpow4, n);  // w = x^12, x = x^15
  sec_fpow16(x, n);          // x = x^240
  sec_fmult(y, x, w, n);     // x = x^252
  sec_fmult(x, y, z, n);     // x = x^254
}

void refresh_masks(uint8x16_t x[], int n)
{
  int i;
  uint8x16_t r;
  
  for (i = 1; i < n; i++) {
    r = rand_uint8x16();
    x[0] = veorq_u8(x[0], r);
    x[i] = veorq_u8(x[i], r);
  }  
}

void sec_sbox(uint8x16_t x[], int n)
{
  sec_exp254(x, y, z, w, n);
  
  int i;
  for (i = 0; i < n; i++)
    x[i] = affine_trans(x[i]);
  
  if (n % 2 == 0) {
    uint8x16_t t = vdupq_n_u8(0x63);
    x[0] = veorq_u8(t, x[0]);
  } 
}

void sec_asma(uint8x16_t x[], uint8x16_t rk[], int n)
{
  int i;
  
  if ((n % 2) == 0)
    x[0] = at_sr_mc_ark0(x[0], rk[0]);
  else
    x[0] = at_sr_mc_ark(x[0], rk[0]);
  
  for (i = 1; i < n; i++)
    x[i] = at_sr_mc_ark(x[i], rk[i]);
}
