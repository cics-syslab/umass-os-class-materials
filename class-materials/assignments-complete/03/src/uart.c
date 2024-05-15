#include "uart.h"
#include "main.h"

void uart_init() {
    // disable interrupts.
    uart_write_reg(UART_IER, UART_IER_GLOBAL_DISABLE);
    // special mode to set baud rate.
    uart_write_reg(UART_LCR, UART_LCR_BAUD_LATCH);
    // LSB for baud rate of 38.4K.
    uart_write_reg(UART_BAUD_RATE_LSB_REG, UART_BAUD_RATE_LSB);
    // MSB for baud rate of 38.4K.
    uart_write_reg(UART_BAUD_RATE_MSB_REG, UART_BAUD_RATE_MSB);
    // leave set-baud mode,
    // and set word length to 8 bits, no parity.
    uart_write_reg(UART_LCR, UART_LCR_EIGHT_BITS);
    // reset and enable FIFOs.
    uart_write_reg(UART_FCR, UART_FCR_FIFO_ENABLE | UART_FCR_FIFO_CLEAR);
    // enable transmit and receive interrupts.
    uart_write_reg(UART_IER, UART_IER_TX_ENABLE | UART_IER_RX_ENABLE);
}
	
void uart_wait_for_write() {
    while (!(uart_read_reg(UART_LSR) & UART_LSR_TX_IDLE));
}

void uart_wait_for_read() {
    while (!(uart_read_reg(UART_LSR) & UART_LSR_RX_READY));
}

void uart_put_c(char c) {
    uart_write_reg(UART_THR, c);
}

char uart_get_c() {
    return uart_read_reg(UART_RHR);
}

void uart_write(char c) {
    uart_wait_for_write();
    uart_put_c(c);
}

char uart_read() {
    uart_wait_for_read();
    return uart_get_c();
}

void uart_handle_interrupt() {
    // TODO: 
    // We got an interrupt! How do we handle it? Collect the character(s) the user
    // typed and pass them to the console code in main.c. Note the character*S*. The UART
    // only triggers an interrupt once per set of characters received. It is possible
    // that it could receive multiple characters at once, and only reading in one
    // would prevent it from interrupting again. This is especially common if you type
    // into the OS while it is paused in GDB. 
/* BEGIN DELETE BLOCK */
    while (uart_read_reg(UART_LSR) & UART_LSR_RX_READY) {
        main_handle_input(uart_get_c());
    }
/* END DELETE BLOCK */
}