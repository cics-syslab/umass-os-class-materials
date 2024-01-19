#include "main.h"
#include "plic.h"
#include "timer.h"
#include "trap.h"
#include "uart.h"
#include "proc.h"

void start() {
  uart_init();
  plic_init();
  plic_inithart();
  trap_inithart();
  timer_init();

  proc_init();

  // enable machine-mode interrupts.
  riscv_w_mstatus(riscv_r_mstatus() | RISCV_MSTATUS_MIE);     // globally enable machine mode interrupts
  riscv_w_mie(riscv_r_mie() | RISCV_MIE_MEIE);                // enable machine mode external interrupts
  riscv_w_mie(riscv_r_mie() | RISCV_MIE_MTIE);                // enable machine mode timer interrupts

  proc_schedule();
}