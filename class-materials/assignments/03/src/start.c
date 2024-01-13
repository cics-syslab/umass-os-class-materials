#include "main.h"
#include "uart.h"
#include "plic.h"
#include "trap.h"


void start() {
    uart_init();
    plic_init();
    plic_inithart();
    trap_inithart();
    main();
}