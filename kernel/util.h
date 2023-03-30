/* util.h */
#pragma once

#include <stdint.h>

#define low_16(address) (uint16_t)((address) & 0xFFFF)
#define high_16(address) (uint16_t)(((address) >> 16) & 0xFFFF)

void memory_copy(char *source, char *dest, int nbytes);
void memory_set(uint8_t *dest, uint8_t val, uint32_t len);
void reverse(char s[]);
int strlen(char s[]);
void int_to_ascii(int n, char str[]);
