#include "riscv.h"

// which hart (core) is this?
uint64 r_mhartid() {
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r"(x));
  return x;
}

// Machine Status Register, mstatus

uint64 r_mstatus() {
  uint64 x;
  asm volatile("csrr %0, mstatus" : "=r"(x));
  return x;
}

void w_mstatus(uint64 x) {
  asm volatile("csrw mstatus, %0" : : "r"(x));
}

// machine exception program counter, holds the
// instruction address to which a return from
// exception will go.
void w_mepc(uint64 x) {
  asm volatile("csrw mepc, %0" : : "r"(x));
}

// Supervisor Status Register, sstatus

uint64 r_sstatus() {
  uint64 x;
  asm volatile("csrr %0, sstatus" : "=r"(x));
  return x;
}

void w_sstatus(uint64 x) {
  asm volatile("csrw sstatus, %0" : : "r"(x));
}

// Supervisor Interrupt Pending
uint64 r_sip() {
  uint64 x;
  asm volatile("csrr %0, sip" : "=r"(x));
  return x;
}

void w_sip(uint64 x) {
  asm volatile("csrw sip, %0" : : "r"(x));
}

// Supervisor Interrupt Enable

uint64 r_sie() {
  uint64 x;
  asm volatile("csrr %0, sie" : "=r"(x));
  return x;
}

void w_sie(uint64 x) {
  asm volatile("csrw sie, %0" : : "r"(x));
}

// Machine-mode Interrupt Enable

uint64 r_mie() {
  uint64 x;
  asm volatile("csrr %0, mie" : "=r"(x));
  return x;
}

void w_mie(uint64 x) {
  asm volatile("csrw mie, %0" : : "r"(x));
}

// supervisor exception program counter, holds the
// instruction address to which a return from
// exception will go.
void w_sepc(uint64 x) {
  asm volatile("csrw sepc, %0" : : "r"(x));
}

uint64 r_sepc() {
  uint64 x;
  asm volatile("csrr %0, sepc" : "=r"(x));
  return x;
}

// Machine Exception Delegation
uint64 r_medeleg() {
  uint64 x;
  asm volatile("csrr %0, medeleg" : "=r"(x));
  return x;
}

void w_medeleg(uint64 x) {
  asm volatile("csrw medeleg, %0" : : "r"(x));
}

// Machine Interrupt Delegation
uint64 r_mideleg() {
  uint64 x;
  asm volatile("csrr %0, mideleg" : "=r"(x));
  return x;
}

void w_mideleg(uint64 x) {
  asm volatile("csrw mideleg, %0" : : "r"(x));
}

// Supervisor Trap-Vector Base Address
// low two bits are mode.
void w_stvec(uint64 x) {
  asm volatile("csrw stvec, %0" : : "r"(x));
}

uint64 r_stvec() {
  uint64 x;
  asm volatile("csrr %0, stvec" : "=r"(x));
  return x;
}

// Machine-mode interrupt vector
void w_mtvec(uint64 x) {
  asm volatile("csrw mtvec, %0" : : "r"(x));
}

// Physical Memory Protection
void w_pmpcfg0(uint64 x) {
  asm volatile("csrw pmpcfg0, %0" : : "r"(x));
}

void w_pmpaddr0(uint64 x) {
  asm volatile("csrw pmpaddr0, %0" : : "r"(x));
}

// supervisor address translation and protection;
// holds the address of the page table.
void w_satp(uint64 x) {
  asm volatile("csrw satp, %0" : : "r"(x));
}

uint64 r_satp() {
  uint64 x;
  asm volatile("csrr %0, satp" : "=r"(x));
  return x;
}

void w_mscratch(uint64 x) {
  asm volatile("csrw mscratch, %0" : : "r"(x));
}

// Supervisor Trap Cause
uint64 r_scause() {
  uint64 x;
  asm volatile("csrr %0, scause" : "=r"(x));
  return x;
}

// Machine Trap Cause
uint64 r_mcause() {
  uint64 x;
  asm volatile("csrr %0, mcause" : "=r"(x));
  return x;
}

// Supervisor Trap Value
uint64 r_stval() {
  uint64 x;
  asm volatile("csrr %0, stval" : "=r"(x));
  return x;
}

// Machine-mode Counter-Enable
void w_mcounteren(uint64 x) {
  asm volatile("csrw mcounteren, %0" : : "r"(x));
}

uint64 r_mcounteren() {
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r"(x));
  return x;
}

// machine-mode cycle counter
uint64 r_time() {
  uint64 x;
  asm volatile("csrr %0, time" : "=r"(x));
  return x;
}

// enable device interrupts
void intr_on() {
  w_sstatus(r_sstatus() | SSTATUS_SIE);
}

// disable device interrupts
void intr_off() {
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
}

// are device interrupts enabled?
int intr_get() {
  uint64 x = r_sstatus();
  return (x & SSTATUS_SIE) != 0;
}

uint64 r_sp() {
  uint64 x;
  asm volatile("mv %0, sp" : "=r"(x));
  return x;
}

// read and write tp, the thread pointer, which xv6 uses to hold
// this core's hartid (core number), the index into cpus[].
uint64 r_tp() {
  uint64 x;
  asm volatile("mv %0, tp" : "=r"(x));
  return x;
}

void w_tp(uint64 x) {
  asm volatile("mv tp, %0" : : "r"(x));
}

uint64 r_ra() {
  uint64 x;
  asm volatile("mv %0, ra" : "=r"(x));
  return x;
}

// flush the TLB.
void sfence_vma() {
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
}
