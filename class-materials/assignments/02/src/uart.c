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

void _wait_for_uart_write() {
  while (!(uart_read_reg(UART_LSR) & UART_LSR_TX_IDLE))
    ;
}

void _wait_for_uart_read() {
  while (!(uart_read_reg(UART_LSR) & UART_LSR_RX_READY))
    ;
}

void _uart_put_c(char c) { uart_write_reg(UART_THR, c); }

char _uart_get_c() { return uart_read_reg(UART_RHR); }

void uart_write(char c) {
  _wait_for_uart_write();
  _uart_put_c(c);
}

char uart_read() {
  _wait_for_uart_read();
  return _uart_get_c();
}
