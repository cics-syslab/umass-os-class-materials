#include "main.h"
#include "uart.h"

void start() {
/* BEGIN DELETE BLOCK */
    uart_init();
    main();
/* BEGIN DELETE BLOCK */
}