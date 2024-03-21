#include "main.h"
#include "plic.h"
#include "timer.h"
#include "trap.h"
#include "uart.h"
#include "proc.h"
#include "util.h"

void start() {
    uart_init();
    plic_init();
    plic_inithart();
    trap_inithart();
    timer_inithart();
    proc_init();

    // enable machine-mode interrupts.
    riscv_w_mstatus(riscv_r_mstatus() | RISCV_MSTATUS_MIE);     // globally enable machine mode interrupts
    // Enable RWX on all S/U mode accesses
    riscv_w_pmpcfg0(0xf);
    // For the range 0...2^55 (which covers the entire range of memory available to us in SV39)
    riscv_w_pmpaddr0(0x3fffffffffffffull);

    util_print_buf("Switching to proc A\n");
    // proc_first_schedule expects to enter on the new processes stack
    riscv_w_sp(proc_processes[0].kernel_context.sp);
    proc_first_schedule();
}