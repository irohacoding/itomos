/* keyboard.c */
#include "keyboard.h"
#include "ports.h"
#include "../cpu/isr.h"
#include "screen.h"
#include "../kernel/kernel.h"
#include "../kernel/util.h"

#define BACKSPACE 0x0E
#define ENTER 0x1C

static char key_buffer[256];

#define SC_MAX 57

const char *sc_name[] = { "ERROR", "ESC", "1", "2", "3", "4",
  "5", "6", "7", "8", "9", "0", "-", "=", "Backspace", "Tab",
  "Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P", "[", "]",
  "Enter", "LCtrl", "A", "S", "D", "F", "G", "H", "J", "K",
  "L", ";", "'", "`", "LShift", "\\", "Z", "X", "C", "V",
  "B", "N", "M", ",", ".", "/", "RShift", "Keypad *", "LAlt", "SPC" };

const char sc_ascii[] = { '?', '?', '1', '2', '3', '4', '5', '6',
  '7', '8', '9', '0', '-', '=', '?', '?', 'Q', 'W', 'E', 'R', 'T',
  'Y', 'U', 'I', 'O', 'P', '[', ']', '?', '?', 'A', 'S', 'D', 'F',
  'G', 'H', 'J', 'K', 'L', ';', '\'', '`', '?', '\\', 'Z', 'X', 'C',
  'V', 'B', 'N', 'M', ',', '.', '/', '?', '?', '?', ' ' };

static void keyboard_callback(registers_t *regs) {
  uint8_t scancode = port_byte_in(0x60);

  if (scancode > SC_MAX) return;

  if (scancode == BACKSPACE) {
    backspace(key_buffer);
    kprint_backspace();
  } else if (scancode == ENTER) {
    kprint("\n");
    user_input(key_buffer);
    key_buffer[0] = '\0';
  } else {
    char letter = sc_ascii[(int) scancode];
    append(key_buffer, letter);
    char str[2] = {letter, '\0'};
    kprint(str);
  }
  UNUSED(regs);
}

void init_keyboard() {
  register_interrupt_handler(IRQ1, keyboard_callback);
}
