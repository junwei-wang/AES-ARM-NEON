#include "aes.h"

uint8x16_t *h, *l, *w, *t;

void init(int n)
{
  // initialize 
  srand(time(NULL));
  
  int i, j;
  uint32_t s[4];
  for (i = 0; i < 3; i++) {
    for (j = 0; j < 4; j++)
      s[j] = rand();
    seeds[i] = vld1q_u32(s);
  }
  
  h = (uint8x16_t *)malloc(n*sizeof(uint8x16_t));
  l = (uint8x16_t *)malloc(n*sizeof(uint8x16_t));
  w = (uint8x16_t *)malloc(n*sizeof(uint8x16_t));
  t = (uint8x16_t *)malloc(n*sizeof(uint8x16_t));
}

void uninit()
{
  free(h);
  free(l);
  free(w);
  free(t);
}

void copy_shares(uint8x16_t to[], uint8x16_t from[], int n)
{
  int i;
  for (i = 0; i < n; i++)
    to[i] = from[i];
}

void gen_shares(uint8x16_t x, uint8x16_t x_shares[], int n)
{
  int i;
  
  x_shares[0] = x;
  for (i = 1; i < n; i++) {
    x_shares[i] = vxorshf96();
    x_shares[0] = veorq_u8(x_shares[0], x_shares[i]);
  }
}

void sec_sbox(uint8x16_t x[], int n)
{
  int i;
  
  uint8x16x4_t s;
  uint8x16_t m;
 
  for (i = 0; i < n; i++) {
    s = delta(x[i]);
    l[i] = s.val[0];
    h[i] = s.val[1];
    w[i] = s.val[2];
    t[i] = s.val[3];
  }
  sec_fmult4(x, t, l, n);
  for (i = 0; i < n; i++)
    w[i] = veorq_u8(w[i], x[i]);

  // secure inversion
  sec_fcubic4(x, w, n);
  for (i = 0; i < n; i++) {
    x[i] = fquar4(x[i]);
    l[i] = fsqur4(w[i]);
  }
  sec_fmult4(w, x, l, n);
  
  sec_fmult4(x, w, h, n); // x: the high part
  sec_fmult4(l, w, t, n); // l: the low part
  
  for (i = 0; i < n; i++)
    x[i] = delta_inv(l[i], x[i]);
  m = vdupq_n_u8(0x63);
  if ((n & 0x1) == 0)
    x[0] = veorq_u8(x[0], m);
}

void sec_addroundkey(uint8x16_t x[], uint8x16_t rk[], int n)
{
  int i;
  for (i = 0; i < n; i++)
    x[i] = veorq_u8(x[i], rk[i]);
}

void sec_sma(uint8x16_t x[], uint8x16_t rk[], int n)
{
  int i;
  for (i = 0; i < n; i++)
    x[i] = sr_mc_ark(x[i], rk[i]);
}

void sec_sa(uint8x16_t x[], uint8x16_t rk[], int n)
{
  int i;
  for (i = 0; i < n; i++)
    x[i] = sr_ark(x[i], rk[i]);
}

void sec_aes(uint8x16_t x[], uint8x16_t *key[], int n)
{ 
  sec_addroundkey(x, key[0], n);
  
  // round 1
  sec_sbox(x, n);
  sec_sma(x, key[1], n);
  
  // round 2
  sec_sbox(x, n);
  sec_sma(x, key[2], n);
  
  // round 3
  sec_sbox(x, n);
  sec_sma(x, key[3], n);
  
  // round 4
  sec_sbox(x, n);
  sec_sma(x, key[4], n);
  
  // round 5
  sec_sbox(x, n);
  sec_sma(x, key[5], n);
  
  // round 6
  sec_sbox(x, n);
  sec_sma(x, key[6], n);
  
  // round 7
  sec_sbox(x, n);
  sec_sma(x, key[7], n);
  
  // round 8
  sec_sbox(x, n);
  sec_sma(x, key[8], n);
  
  // round 9
  sec_sbox(x, n);
  sec_sma(x, key[9], n);;
  

  // round 10
  sec_sbox(x, n);
  sec_sa(x, key[10], n);
}