#include "machinevec.h"
#include "memlayout.h"
#include "plic.h"
#include "proc.h"
#include "riscv.h"
#include "types.h"
#include "uart.h"
#include "util.h"
#include "parameters.h"
#include "uservec.h"
#include "trap.h"

// set up to take exceptions and traps while in the kernel.
void trap_inithart() {
  riscv_w_mtvec((uint64) machinevec);
}

void trap_handle_plic_interrupt() {
  // irq indicates which device interrupted.
  int irq = plic_claim();

  if(irq == MEMLAYOUT_UART0_IRQ) {
    uart_handle_interrupt();
  }
  // the PLIC allows each device to raise at most one
  // interrupt at a time; tell the PLIC the device is
  // now allowed to interrupt again.
  if(irq) plic_complete(irq);
}

void trap_handle_timer_interrupt() {
  // adjust the mtimecmp value to clear the interrupt and schedule the next one
  int id = riscv_r_mhartid();
  *(uint64 *)MEMLAYOUT_CLINT_MTIMECMP(id) = *(uint64 *)MEMLAYOUT_CLINT_MTIME + PARAMETERS_INTERRUPT_INTERVAL;
  proc_schedule();
}

// What caused the trap
// Returns:
//  0 for unknown interrupt or exception
//  1 for machine external interrupt (PLIC)
//  2 for machine timer interrupt
int trap_get_reason() {
  uint64 mcause = riscv_r_mcause();

  if(RISCV_MCAUSE_IS_INTERRUPT(mcause)) {
    uint64 interrupt_cause = RISCV_MCAUSE_INTERRUPT_CAUSE(mcause);
    if (interrupt_cause == RISCV_MCAUSE_MACHINE_EXTERNAL_INTERRUPT) {
      return 1;
    } else if (interrupt_cause == RISCV_MCAUSE_MACHINE_TIMER_INTERRUPT) {
      return 2;
    }
  }
  // Unknown interrupt or an exception
  return 0;
}

void trap_handle_trap(int reason) {
  switch (reason) {
    case 1:
      trap_handle_plic_interrupt();
      break;
    case 2:
      trap_handle_timer_interrupt();
      break;
    default:
      // Exception in kernel?! PANIC
      util_panic("panic: trap_handle_trap");
  }
}

void trap_kerneltrap() {
  int reason = trap_get_reason();
  trap_handle_trap(reason);
}

void trap_usertrap() {
  int reason = trap_get_reason();

  if((riscv_r_mstatus() & RISCV_MSTATUS_MPP_MASK) != 0) util_panic("panic: trap_usertrap");

  // send interrupts and exceptions to trap_kerneltrap() (via machinevec),
  // since we're now in the kernel.
  riscv_w_mtvec((uint64) machinevec);

  struct proc *p = &proc_processes[proc_curr_proc_id];
  
  // save user program counter.
  p->user_context.pc = riscv_r_mepc();
  
  trap_handle_trap(reason);

  trap_usertrap_return();
}

void trap_usertrap_return() {
  struct proc *p = &proc_processes[proc_curr_proc_id];
  // we're about to switch the destination of traps from
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  riscv_intr_off();

  // send syscalls, interrupts, and exceptions to uservec in uservec.S
  riscv_w_mtvec((uint64) uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->user_context.kernel_sp = p->kernel_stack; // process's kernel stack

  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = riscv_r_mstatus();
  x &= ~RISCV_MSTATUS_MPP_MASK; // clear MPP
  x |= RISCV_MSTATUS_MPP_U;     // set MPP to user mode
  x |= RISCV_MSTATUS_MPIE;      // Renable machine interrupts when we return 
  riscv_w_mstatus(x);

  // set S Exception Program Counter to the saved user pc.
  riscv_w_mepc(p->user_context.pc);

  // Does not return
  uservec_ret();
}