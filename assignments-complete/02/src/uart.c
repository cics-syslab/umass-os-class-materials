#include "uart.h"
void uart_init() {
  // disable interrupts.
  uart_write_reg(UART_IER, UART_IER_GLOBAL_DISABLE);
  // special mode to set baud rate.
  uart_write_reg(UART_LCR, UART_LCR_BAUD_LATCH);
  // LSB for baud rate of 38.4K.
  uart_write_reg(0, 0x03);
  // MSB for baud rate of 38.4K.
  uart_write_reg(1, 0x00);
  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  uart_write_reg(UART_LCR, UART_LCR_EIGHT_BITS);
  // reset and enable FIFOs.
  uart_write_reg(UART_FCR, UART_FCR_FIFO_ENABLE | UART_FCR_FIFO_CLEAR);
  // enable transmit and receive interrupts.
  uart_write_reg(UART_IER, UART_IER_TX_ENABLE | UART_IER_RX_ENABLE);
}

/*
TODO:
Rewrite uart_wait_for_write in C.
*/
/* BEGIN DELETE BLOCK */
void uart_wait_for_write() {
  while (!(uart_read_reg(UART_LSR) & UART_LSR_TX_IDLE));
}
/* END DELETE BLOCK */

void uart_wait_for_read() {
  while (!(uart_read_reg(UART_LSR) & UART_LSR_RX_READY));
}

/*
TODO:
Rewrite uart_put_c in C.
*/
/* BEGIN DELETE BLOCK */
void uart_put_c(char c) { uart_write_reg(UART_THR, c); }
/* END DELETE BLOCK */

char uart_get_c() { return uart_read_reg(UART_RHR); }

/*
TODO:
Rewrite uart_write in C.
*/
/* BEGIN DELETE BLOCK */
void uart_write(char c) {
  uart_wait_for_write();
  uart_put_c(c);
}
/* END DELETE BLOCK */

char uart_read() {
  uart_wait_for_read();
  return uart_get_c();
}