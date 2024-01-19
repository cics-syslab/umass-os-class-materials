#include "timer.h"
#include "machinevec.h"
#include "parameters.h"

// arrange to receive timer interrupts.
// they will arrive in machine mode at
// machinevec
void timer_init() {
  // each CPU has a separate source of timer interrupts.
  int id = riscv_r_mhartid();

  // ask the CLINT for a timer interrupt.
  *(uint64 *)MEMLAYOUT_CLINT_MTIMECMP(id) = *(uint64 *)MEMLAYOUT_CLINT_MTIME + PARAMETERS_INTERRUPT_INTERVAL;

  // set the machine-mode trap handler.
  riscv_w_mtvec((uint64)machinevec);

  // enable machine-mode interrupts.
  riscv_w_mstatus(riscv_r_mstatus() | RISCV_MSTATUS_MIE);

  // enable machine-mode timer interrupts.
  riscv_w_mie(riscv_r_mie() | RISCV_MIE_MTIE);
}