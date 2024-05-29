#include "main.h"
#include "uart.h"

void start() {
    uart_init();
    main();
}