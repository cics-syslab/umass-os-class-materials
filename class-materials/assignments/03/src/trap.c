#include "types.h"
#include "memlayout.h"
#include "riscv.h"
#include "machinevec.h"
#include "plic.h"
#include "util.h"
#include "uart.h"

// set up to take exceptions and traps while in the kernel.
void trap_inithart() {
  riscv_w_mtvec((uint64) machinevec);
  riscv_w_mstatus(riscv_r_mstatus() | RISCV_MSTATUS_MIE);
  riscv_w_mie(riscv_r_mie() | RISCV_MIE_MEIE);
}

// check if it's an external interrupt or software interrupt,
// and handle it.
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int trap_devintr() {
  uint64 mcause = riscv_r_mcause();

  if(RISCV_MCAUSE_IS_INTERRUPT(mcause)){
    uint64 interrupt_cause = RISCV_MCAUSE_INTERRUPT_CAUSE(mcause);
    if (interrupt_cause == RISCV_MCAUSE_MACHINE_EXTERNAL_INTERRUPT) {
      // this is a machine external interrupt, via PLIC.
      // via https://github.com/qemu/qemu/blob/master/target/riscv/cpu_bits.h#L700

      // irq indicates which device interrupted.
      int irq = plic_claim();

      if(irq == MEMLAYOUT_UART0_IRQ){
        uart_handle_interrupt();
      }
      // the PLIC allows each device to raise at most one
      // interrupt at a time; tell the PLIC the device is
      // now allowed to interrupt again.
      if(irq)
        plic_complete(irq);

      return 1;
    }
    // Unknown interrupt type
    return 0;
  } 
  // We won't handle exceptions at this time
  return 0;
}