#include "aes_arm_neon.h"

void sec_fmult(uint8x16_t c[], uint8x16_t a[], uint8x16_t b[], int n)
{
  int i, j;
  uint8x16_t s, t;

  for (i = 0; i < n; i++)
    c[i] = fmult(a[i], b[i]);
  
  for (i = 0; i < n; i++)
    for (j = i+1; j < n; j++) {
      s = rand_uint8x16();
      c[i] = veorq_u8(c[i], s);
      t = fmult(a[i], b[j]);
      s = veorq_u8(s, t);
      t = fmult(a[j], b[i]);
      s = veorq_u8(s, t);
      c[j] = veorq_u8(c[j], s);
    }
}

void sec_h(uint8x16_t y[], uint8x16_t x[], uint8x16_t gx[],
           uint8x16_t (*g_call)(uint8x16_t), int n)
{
  int i, j;
  uint8x16_t r00, r01, r1, s, t;

  for (i = 0; i < n; i++) {
    gx[i] = g_call(x[i]);
    y[i] = fmult(x[i], gx[i]);
  }

  for (i = 0; i < n; i++)
    for (j = i+1; j < n; j++) {
      r00 = rand_uint8x16();
      r01 = rand_uint8x16();
      y[i] = veorq_u8(y[i], r00);

      t = g_call(r01); 
      t = fmult(x[i], t);         // t = x[i] * g(r01)
      r1 = veorq_u8(r00, t);
      t = fmult(r01, gx[i]);      // t = r0' * g(x[i])
      r1 = veorq_u8(r1, t); 
      s = veorq_u8(x[j], r01);    // s = x[j] * r01
      t = g_call(s);            
      t = fmult(x[i], t);          // t = x[i] * g(x[j]^r01)
      r1 = veorq_u8(t, r1);
      t = fmult(gx[i], s);        // t = (x[j]^r01) * g(x[i])
      r1 = veorq_u8(t, r1);

      y[j] = veorq_u8(y[j], r1);
    }
}

