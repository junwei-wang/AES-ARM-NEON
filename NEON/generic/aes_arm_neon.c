#include "aes_arm_neon.h"

void init()
{
  // initialize 
  srand(time(NULL));
  
  int i, j;
  uint32_t t[4];
  for (i = 0; i < 3; i++) {
    for (j = 0; j < 4; j++)
      t[j] = rand();
    seeds[i] = vld1q_u32(t);
  }
}

void copy_shares(uint8x16_t to[], uint8x16_t from[], int n)
{
  int i;
  for (i = 0; i < n; i++)
    to[i] = from[i];
}

/*
 * x    stores the plaintext with shares
 * key  stores the expanded key with shares
 * n    is the number of shares
 */
void sec_aes(uint8x16_t x[], uint8x16_t *key[], int n)
{
  uint8x16_t *y, *z, *w;
  y = (uint8x16_t *)malloc(sizeof(uint8x16_t) * n);
  z = (uint8x16_t *)malloc(sizeof(uint8x16_t) * n);
  w = (uint8x16_t *)malloc(sizeof(uint8x16_t) * n);
  
  sec_addroundkey(x, key[0], n);
  // round 1
  sec_exp254(x, y, z, w, n);
  sec_asma(x, key[1], n);
  
  // round 2
  sec_exp254(x, y, z, w, n);
  sec_asma(x, key[2], n);
  
  // round 3
  sec_exp254(x, y, z, w, n);
  sec_asma(x, key[3], n);
  
  // round 4
  sec_exp254(x, y, z, w, n);
  sec_asma(x, key[4], n);
  
  // round 5
  sec_exp254(x, y, z, w, n);
  sec_asma(x, key[5], n);
  
  // round 6
  sec_exp254(x, y, z, w, n);
  sec_asma(x, key[6], n);
  
  // round 7
  sec_exp254(x, y, z, w, n);
  sec_asma(x, key[7], n);
  
  // round 8
  sec_exp254(x, y, z, w, n);
  sec_asma(x, key[8], n);
  
  // round 9
  sec_exp254(x, y, z, w, n);
  sec_asma(x, key[9], n);
  

  // round 10
  sec_sbox(x, n);
  sec_shiftrows(x, n);
  sec_addroundkey(x, key[10], n);
  
  free(y);
  free(z);
  free(w);
}

void gen_shares(uint8x16_t x, uint8x16_t x_shares[], int n)
{
  int i;
  
  x_shares[0] = x;
  for (i = 1; i < n; i++) {
    x_shares[i] = rand_uint8x16();
    x_shares[0] = veorq_u8(x_shares[0], x_shares[i]);
  }
}

uint8x16_t sec_whole_aes(uint8x16_t plain, uint8x16_t key)
{
  uint8x16_t x[SHARE_NUM], k[SHARE_NUM], * w[11], cipher;
  int i;
  
  for (i = 0; i < 11; i++)
    w[i] = (uint8x16_t *)malloc(sizeof(uint8x16_t) * SHARE_NUM);
  
  gen_shares(plain, x, SHARE_NUM);
  gen_shares(key,   k, SHARE_NUM);
  
  sec_keyexpansion(k, w, SHARE_NUM);
  sec_aes(x, w, SHARE_NUM);
  
  cipher = x[0];
  for (i = 1; i < SHARE_NUM; i++) {
    cipher = veorq_u8(cipher, x[i]);
  }  
  
  return cipher;
}