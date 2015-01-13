#include "aes.h"

#define vmulq_u8(a, b) vreinterpretq_u8_p8(vmulq_p8(vreinterpretq_p8_u8(a), vreinterpretq_p8_u8(b)))
#define fmod4(a) veorq_u8((vmulq_u8((vshrq_n_u8(a, 4)), nx)), a)

void sec_fmult4(uint8x16_t z[], uint8x16_t x[], uint8x16_t y[], int n)
{
  int i, j, c = 0;
  uint8x16_t s, t, r, mask, ux, nx, accu;
  
  mask = vdupq_n_u8(0x0f);
  nx = vdupq_n_u8(0x13);
  
  for (i = 0; i < n; i++) {
    // z[i] = x[i] * y[i];
    ux = vmulq_u8(x[i], y[i]);
    z[i] = fmod4(ux);
  }
    
  for (i = 0; i < n; i++) {
    accu = veorq_u8(accu, accu);
    for (j = i+1; j < n; j++) {
      if (c == 0) {
        r = vxorshf96();
        s = vshrq_n_u8(r, 4); 
      } else 
        s = vandq_u8(r, mask);
      c^=1;      
      
      accu = veorq_u8(accu, s);
      // t = x[i] * y[j];
      ux = vmulq_u8(x[i], y[j]);
      t = fmod4(ux);
      // s = s^t
      s = veorq_u8(s, t);
      // t = x[j] * y[i];
      ux = vmulq_u8(x[j], y[i]);
      t = fmod4(ux);
      // s = s^t
      s = veorq_u8(s, t);
      z[j] = veorq_u8(z[j], s);
    }
    z[i] = veorq_u8(z[i], accu);
  }
}

void sec_fcubic4(uint8x16_t y[], uint8x16_t x[], int n)
{
  int i, j;
  uint8x16x2_t t;
  uint8x16_t yi;

  for (i = 0; i < n; i++)
    y[i] = fcubic4(x[i]);

  for (i = 0; i < n; i++) {
    for (j = i+1; j < n; j++) {
      t = sec_fcubic4_loop(x[i], x[j], y[i], y[j]);
      y[i] = t.val[0];
      y[j] = t.val[1];    
    }
  }
}
