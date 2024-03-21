#include "main.h"
#include "uart.h"
#include "plic.h"
#include "trap.h"


void start() {
    uart_init();
    plic_init();
    plic_inithart();
    trap_inithart();
    // enable machine-mode interrupts.
    riscv_w_mstatus(riscv_r_mstatus() | RISCV_MSTATUS_MIE);     // globally enable machine mode interrupts

    main();
}