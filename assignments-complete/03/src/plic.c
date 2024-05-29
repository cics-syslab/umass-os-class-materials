#include "memlayout.h"
#include "types.h"
#include "riscv.h"

/*
Functions to work with the PLIC.
*/

/*
TODO: Perform one time initialization by setting the interrupt priority for 
the UART interrupt source to 1. Remember, good code avoids using magic 
numbers, where could you find a macro for the *UART* IRQ number.

If you don't remember how to do this, go over the RISC-V PLIC documentation.
*/
void plic_init() {
/* BEGIN DELETE BLOCK */
  // set desired IRQ priorities non-zero (zero = disabled).
  // UART0_IRQ is the interrupt source number for the uart, each source gets 4 bytes
  *(uint32*)(MEMLAYOUT_PLIC + MEMLAYOUT_UART0_IRQ*4) = 1;
/* BEGIN DELETE BLOCK */   
}

/*
TODO: Perform per hart initialization by enabling M mode interrupts on
this hart, which is guaranteed to have hartid 0 because it is the only
one, for the UART interrupt source. The macros in memlayout.h might
be helpful here.

After that set the M mode priority threshold for this hart to 0 so we
can receive all interrupts. The macros in memlayout.h might
be helpful here.

After that enable machine mode external interrupts in the mie register.
The macros and helper functions in riscv.h might be helpful here.
*/
void plic_inithart() {
/* BEGIN DELETE BLOCK */
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
/* BEGIN DELETE BLOCK */
}

/*
TODO: Write a function that claims an M mode interrupt for the current
hart, which is always hart 0, by reading the relevant PLIC register. The
macros in memlayout.h may be helpful here. Return the IRQ number.
*/
int plic_claim() {
/* BEGIN DELETE BLOCK */
  int hart = 0;
  int irq = *(uint32*)MEMLAYOUT_PLIC_MCLAIM(hart);
  return irq;
/* BEGIN DELETE BLOCK */
}

/*
TODO: Write a function that completes an M mode interrupt for the current
hart, which is always 0, by writing the IRQ in the first parameter to the
relevant PLIC register. The macros in memlayout.h may be helpful here.
*/
void plic_complete(int irq) {
/* BEGIN DELETE BLOCK */
  int hart = 0;
  *(uint32*)MEMLAYOUT_PLIC_MCLAIM(hart) = irq;
/* BEGIN DELETE BLOCK */
}
