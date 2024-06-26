#include "memlayout.h"
#include "types.h"
#include "riscv.h"

//
// the riscv Platform Level Interrupt Controller (PLIC).
//

void plic_init() {
  // set desired IRQ priorities non-zero (zero = disabled).
  // UARTx_IRQ are the interrupt source numbers, each source gets 4 bytes
  *(uint32*)(MEMLAYOUT_PLIC + MEMLAYOUT_UART0_IRQ*4) = 1;
}

void plic_inithart() {
  // We hardcode this for now, we only have one hart
  // and one hart must always have id 0
  int hart = 0;
  
  // set enable bits for this hart's M-mode
  // for the uart.
  *(uint32*)MEMLAYOUT_PLIC_MENABLE(hart) = (1 << MEMLAYOUT_UART0_IRQ);

  // set this hart's M-mode priority threshold to 0.
  *(uint32*)MEMLAYOUT_PLIC_MPRIORITY(hart) = 0;

  // Enable machine external interrupts
  riscv_w_mie(riscv_r_mie() | RISCV_MIE_MEIE);
}

// ask the PLIC what interrupt we should serve.
int plic_claim() {
  int hart = 0;
  int irq = *(uint32*)MEMLAYOUT_PLIC_MCLAIM(hart);
  return irq;
}

// tell the PLIC we've served this IRQ. 
void plic_complete(int irq) {
  int hart = 0;
  *(uint32*)MEMLAYOUT_PLIC_MCLAIM(hart) = irq;
}
