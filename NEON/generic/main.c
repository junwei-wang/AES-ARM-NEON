#include <stdio.h>

#include "aes_arm_neon.h"

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

void test()
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
  
  print_uint8x16_t(sec_whole_aes(x, key));
}

uint8x16_t change_rows_columns(uint8x16_t a)
{
  uint8x16_t y;
  uint8x8x2_t t0, t1;
  
  uint8_t x[16] = {0, 4, 8, 12, 1, 5, 9, 13, 2, 6, 10, 14, 3, 7, 11, 15};
  y = vld1q_u8(x);
  
  t0.val[1] = vget_high_u8(a);
  t0.val[0] = vget_low_u8(a);
  t1.val[1] = vtbl2_u8(t0, vget_high_u8(y));
  t1.val[0] = vtbl2_u8(t0, vget_low_u8(y));
  return vcombine_u8(t1.val[0], t1.val[1]);
}

void test0()
{
  uint8_t a[16]={0x2b,0x7e,0x15,0x16,0x28,0xae,0xd2,0xa6,0xab,0xf7,
        0x15,0x88,0x09,0xcf,0x4f,0x3c};
  uint8_t key[16]={0x32,0x43,0xf6,0xa8,0x88,0x5a,0x30,0x8d,0x31,0x31,
        0x98,0xa2,0xe0,0x37,0x07,0x34};


  uint8x16_t b = vld1q_u8(a);
  uint8x16_t key0 = vld1q_u8(key);
  print_uint8x16_t(b);
  b = change_rows_columns(b);
  print_uint8x16_t(b);
  key0 = change_rows_columns(key0);
  b = at_sr_mc_ark(b, key0);
  print_uint8x16_t(change_rows_columns(b));
}

int main()
{ 
  init();
  //test_keyexpansion();
  test();
  //test0();
  return 0;
}