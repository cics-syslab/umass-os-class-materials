#include "types.h"
#include "memlayout.h"
#include "riscv.h"
#include "machinevec.h"
#include "plic.h"
#include "util.h"
#include "uart.h"

// set up to take exceptions and traps while in the kernel.
void trapinithart(void) {
  w_mtvec((uint64) machinevec);
  w_mstatus(r_mstatus() | MSTATUS_MIE);
  w_mie(r_mie() | MIE_MEIE);
}

// check if it's an external interrupt or software interrupt,
// and handle it.
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int devintr() {
  uint64 mcause = r_mcause();

  if(((mcause >> 63) & 1) &&
     (mcause & 0xff) == 11){
    // this is a machine external interrupt, via PLIC.
    // via https://github.com/qemu/qemu/blob/master/target/riscv/cpu_bits.h#L700

    // irq indicates which device interrupted.
    int irq = plic_claim();

    if(irq == UART0_IRQ){
      uart_handle_interrupt();
    }
    // the PLIC allows each device to raise at most one
    // interrupt at a time; tell the PLIC the device is
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } 
  return 0;
}