#include "main.h"
#include "uart.h"
#include "plic.h"
#include "trap.h"


void start() {
    uart_init();
    plic_init();
    plic_inithart();
    trap_inithart();
    /* 
    TODO: 
    Globally enable machine mode interrupts in mstatus. The macros in riscv.h may be helpful here.
    If you don't know how to do this, review the RISC-V privileged architecture, particularly the 
    machine mode CSRs.
    */
/* BEGIN DELETE BLOCK */
    riscv_w_mstatus(riscv_r_mstatus() | RISCV_MSTATUS_MIE);     // globally enable machine mode interrupts
/* BEGIN DELETE BLOCK */
    main();
}