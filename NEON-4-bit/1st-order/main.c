#include <stdio.h>
#include "aes.h"

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
  
  /*
  uint8_t outex[16] = {
    0x39,0x02,0xdc,0x19,
    0x25,0xdc,0x11,0x6a,
    0x84,0x09,0x85,0x97,
    0x19,0x6a,0x0b,0x32};    
 */
  
  uint8x16_t x[2], key[2], *w[11];
  
  int i;
  for (i = 0; i < 11; i++)
    w[i] = (uint8x16_t *)malloc(sizeof(uint8x16_t)*2);
  
  key[0] = vld1q_u8(keyex);
  x[0] = vld1q_u8(inex);
  key[1] = vxorshf96();
  key[0] = veorq_u8(key[0], key[1]); 
  x[1] = vxorshf96();
  x[0] = veorq_u8(x[0], x[1]); 
  

  sec_keyexpansion(key, w);
    
  sec_aes(x, w);
  
  x[0] = veorq_u8(x[0], x[1]); 
  print_uint8x16_t(x[0]);
}

int main()
{ 
  init();
  test();
  return 0;
}

/*
keyexpansion: correct
*/