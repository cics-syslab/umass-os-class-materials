#define UART_ADDRESS 0x10000000

// the UART control registers are memory-mapped
// at address UART_ADDRESS. this macro returns the
// address of one of the registers.
#define uart_reg(reg) ((volatile unsigned char *)(UART_ADDRESS + reg))
#define uart_read_reg(reg) (*(uart_reg(reg)))
#define uart_write_reg(reg, v) (*(uart_reg(reg)) = (v))

// the UART control registers.
// some have different meanings for
// read vs write.
// see http://byterunner.com/16550.html
// This page has a longer but more thorough explanation
// https://www.lammertbies.nl/comm/info/serial-uart
#define UART_RHR 0                 // receive holding register (for input bytes)
#define UART_THR UART_RHR          // transmit holding register (for output bytes)
#define UART_BAUD_RATE_LSB_REG UART_RHR
#define UART_IER 1                 // interrupt enable register
#define UART_BAUD_RATE_MSB_REG UART_IER
#define UART_FCR 2                 // FIFO control register
#define UART_ISR UART_ISR          // interrupt status register
#define UART_LCR 3                 // line control register
#define UART_LSR 5                 // line status registers


#define UART_LSR_RX_READY (1<<0)   // input is waiting to be read from RHR
#define UART_LSR_TX_IDLE (1<<5)    // THR can accept another character to send
#define UART_IER_RX_ENABLE (1<<0)
#define UART_IER_TX_ENABLE (1<<1)
#define UART_IER_GLOBAL_DISABLE 0
#define UART_FCR_FIFO_ENABLE (1<<0)
#define UART_FCR_FIFO_CLEAR (3<<1) // clear the content of the two FIFOs
#define UART_LCR_EIGHT_BITS (3<<0)
#define UART_LCR_BAUD_LATCH (1<<7) // special mode to set baud rate
#define UART_BAUD_RATE_LSB 0x03
#define UART_BAUD_RATE_MSB 0x00


#define UART_MAX_CMD_LEN 32


void uart_init();
void uart_write(char c);
char uart_read();
void uart_handle_interrupt();