#ifndef __AES_H__
#define __AES_H__

#include <arm_neon.h>
#include "core.h"

uint8x16_t aes(uint8x16_t x, uint8x16_t w[]);
void keyexpansion(uint8x16_t k, uint8x16_t w[11]);

#endif