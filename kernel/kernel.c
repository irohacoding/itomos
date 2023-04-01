/* kernel.c */
#include "../cpu/idt.h"
#include "../cpu/isr.h"
#include "../cpu/timer.h"
#include "../drivers/screen.h"
#include "../drivers/keyboard.h"

#include "util.h"

void main() {
  clear_screen();

  kprint("Installing interrupt service routines.\n");
  isr_install();

  kprint("Enabling external interrupts.\n");
  kprint("Initializing keyboard.\n");
  irq_install();

  kprint("\nHello, this is itomos!\n");
  kprint("Type BYE to exit.\n> ");
}

void user_input(char *input) {
  if (strcmp(input, "HELLO") == 0) {
    kprint("Hello!\n> ");
  } else if (strcmp(input, "BYE") == 0) {
    kprint("Thank you. Bye!\n");
    asm volatile("hlt");
  } else {
    kprint("Hm, you said ");
    kprint(input);
    kprint("\n");
    kprint("That's a nice word! keep going...");
    kprint("\n> ");
  }
}
