/* keyboard.c */
#include "keyboard.h"
#include "screen.h"
#include "ports.h"
#include "../cpu/isr.h"
#include "../kernel/kernel.h"
#include "../kernel/util.h"

#define BACKSPACE 0x0E
#define ENTER 0x1C
#define LSHIFT 0x2A
#define RSHIFT 0x36

static char key_buffer[256];

/* 0: released 1: pressed */
int shift_status;

#define SC_MAX 57

const char *sc_name[] = { "ERROR", "ESC", "1", "2", "3", "4",
  "5", "6", "7", "8", "9", "0", "-", "=", "Backspace", "Tab",
  "Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P", "[", "]",
  "Enter", "LCtrl", "A", "S", "D", "F", "G", "H", "J", "K",
  "L", ";", "'", "`", "LShift", "\\", "Z", "X", "C", "V", "B",
  "N", "M", ",", ".", "/", "RShift", "Keypad *", "LAlt", "SPC" };

const char sc_ascii[] = { '?', '?', '1', '2', '3', '4', '5', '6',
  '7', '8', '9', '0', '-', '=', '?', '?', 'q', 'w', 'e', 'r', 't',
  'y', 'u', 'i', 'o', 'p', '[', ']', '?', '?', 'a', 's', 'd', 'f',
  'g', 'h', 'j', 'k', 'l', ';', '\'', '`', '?', '\\', 'z', 'x',
  'c', 'v', 'b', 'n', 'm', ',', '.', '/', '?', '?', '?', ' ' };

const char sc_shift_ascii[] = { '?', '?', '!', '@', '#', '$', '%',
  '^', '&', '*', '(', ')', '_', '+', '?', '?', 'Q', 'W', 'E', 'R',
  'T', 'Y', 'U', 'I', 'O', 'P', '{', '}', '?', '?', 'A', 'S', 'D',
  'F', 'G', 'H', 'J', 'K', 'L', ':', '"', '~', '?', '|', 'Z', 'X',
  'C', 'V', 'B', 'N', 'M', '<', '>', '?', '?', '?', '?', ' ' };

static void keyboard_callback(registers_t *regs) {
  uint8_t scancode = port_byte_in(0x60);

  if (scancode > SC_MAX) {
    if (scancode - 0x80 == LSHIFT || scancode - 0x80 == RSHIFT) shift_status = 0;
    return;
  }

  if (scancode == BACKSPACE) {
    backspace(key_buffer);
    kprint_backspace();
  } else if (scancode == ENTER) {
    kprint("\n");
    user_input(key_buffer);
    key_buffer[0] = '\0';
  } else if (scancode == LSHIFT || scancode == RSHIFT) {
    shift_status = 1;
  } else {
    char letter;
    if (shift_status) {
      letter = sc_shift_ascii[(int) scancode];
    } else {
      letter = sc_ascii[(int) scancode];
    }
    append(key_buffer, letter);
    char str[2] = {letter, '\0'};
    kprint(str);
  }
  UNUSED(regs);
}

void init_keyboard() {
  register_interrupt_handler(IRQ1, keyboard_callback);
}
