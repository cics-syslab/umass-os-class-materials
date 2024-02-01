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

  util_print_buf("Switching to proc A\n");
  riscv_w_sp(proc_processes[0].kernel_context.sp);
  proc_first_schedule();
}