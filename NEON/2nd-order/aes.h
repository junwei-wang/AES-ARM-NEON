#ifndef __AES_H__
#define __AES_H__

#include <arm_neon.h>
#include "core.h"
#include <stdlib.h>

void init();
void sec_aes(uint8x16_t x[], uint8x16_t *rk[]);
void sec_keyexpansion(uint8x16_t k[], uint8x16_t *w[11]);

#endif