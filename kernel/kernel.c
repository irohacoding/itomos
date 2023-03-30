/* kernel.c */
#include "../cpu/idt.h"
#include "../cpu/isr.h"
#include "../cpu/timer.h"
#include "../drivers/screen.h"
#include "../drivers/keyboard.h"

#include "util.h"

void main() {
  clear_screen();
  kprint("hello, this is itomos!\n");

  isr_install();

  kprint("enabling external interrupts.\n");
  asm volatile("sti");

  kprint("initializing keyboard (IRQ 1).\n");
  init_keyboard();
}
