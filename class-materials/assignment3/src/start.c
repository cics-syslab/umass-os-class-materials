#include "main.h"
#include "uart.h"
#include "plic.h"
#include "trap.h"


void start() {
    uart_init();
    plicinit();
    plicinithart();
    trapinithart();
    main();
}