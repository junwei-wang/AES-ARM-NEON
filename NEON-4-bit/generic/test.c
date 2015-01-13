#include "aes.h"
#include <stdio.h>
#

void print_uint8x16_t(uint8x16_t vec_dest)
{
  int res;
  
  res = vgetq_lane_u8(vec_dest, 0);
  printf("Lane %2d: %2x\n", 0, res);
    res = vgetq_lane_u8(vec_dest, 1);
  printf("Lane %2d: %2x\n", 1, res);
    res = vgetq_lane_u8(vec_dest, 2);
  printf("Lane %2d: %2x\n", 2, res);
    res = vgetq_lane_u8(vec_dest, 3);
  printf("Lane %2d: %2x\n", 3, res);
    res = vgetq_lane_u8(vec_dest, 4);
  printf("Lane %2d: %2x\n", 4, res);
    res = vgetq_lane_u8(vec_dest, 5);
  printf("Lane %2d: %2x\n", 5, res);
    res = vgetq_lane_u8(vec_dest, 6);
  printf("Lane %2d: %2x\n", 6, res);
    res = vgetq_lane_u8(vec_dest, 7);
  printf("Lane %2d: %2x\n", 7, res);
    res = vgetq_lane_u8(vec_dest, 8);
  printf("Lane %2d: %2x\n", 8, res);
    res = vgetq_lane_u8(vec_dest, 9);
  printf("Lane %2d: %2x\n", 9, res);
    res = vgetq_lane_u8(vec_dest, 10);
  printf("Lane %2d: %2x\n", 10, res);
    res = vgetq_lane_u8(vec_dest, 11);
  printf("Lane %2d: %2x\n", 11, res);
    res = vgetq_lane_u8(vec_dest, 12);
  printf("Lane %2d: %2x\n", 12, res);
    res = vgetq_lane_u8(vec_dest, 13);
  printf("Lane %2d: %2x\n", 13, res);
    res = vgetq_lane_u8(vec_dest, 14);
  printf("Lane %2d: %2x\n", 14, res);
    res = vgetq_lane_u8(vec_dest, 15);
  printf("Lane %2d: %2x\n", 15, res);
}

void print_shares(uint8x16_t vec_dest[], int n)
{
  int i;
  uint8x16_t s = vec_dest[0];
  for (i = 1; i < n; i++)
    s = veorq_u8(s, vec_dest[i]);
  print_uint8x16_t(s);
}

uint8x16_t sec_whole_aes(uint8x16_t plain, uint8x16_t key, int n)
{
  uint8x16_t *x, *k, * w[11], cipher;
  int i;
  
  init(n);
  x = (uint8x16_t *)malloc(sizeof(uint8x16_t) * n);
  k = (uint8x16_t *)malloc(sizeof(uint8x16_t) * n);
  for (i = 0; i < 11; i++)
    w[i] = (uint8x16_t *)malloc(sizeof(uint8x16_t) * n);
  
  gen_shares(plain, x, n);
  gen_shares(key,   k, n);
  
  sec_keyexpansion(k, w, n);
  sec_aes(x, w, n);
  
  cipher = x[0];
  for (i = 1; i < n; i++) {
    cipher = veorq_u8(cipher, x[i]);
  }
  
  print_uint8x16_t(cipher);
  uninit();
  
  return cipher;
}

void test(int n)
{
  uint8_t keyex[16]={
    0x2b, 0x28, 0xab, 0x09,
    0x7e, 0xae, 0xf7, 0xcf,
    0x15, 0xd2, 0x15, 0x4f,
    0x16, 0xa6, 0x88, 0x3c};
  
  uint8_t inex[16]={
    0x32, 0x88, 0x31, 0xe0,
    0x43, 0x5a, 0x31, 0x37,
    0xf6, 0x30, 0x98, 0x07,
    0xa8, 0x8d, 0xa2, 0x34};
    
 
  uint8x16_t x, key;
  key = vld1q_u8(keyex);
  x = vld1q_u8(inex);
  
  print_uint8x16_t(sec_whole_aes(x, key, n));
}


