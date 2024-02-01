#ifndef _RISCV_H
#define _RISCV_H
#include "types.h"

// which hart (core) is this?
static inline uint64 riscv_r_mhartid() {
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
  return x;
}

// Machine Status Register, mstatus

#define RISCV_MSTATUS_MPP_MASK (3L << 11) // previous mode.
#define RISCV_MSTATUS_MPP_M (3L << 11)
#define RISCV_MSTATUS_MPP_S (1L << 11)
#define RISCV_MSTATUS_MPP_U (0L << 11)
#define RISCV_MSTATUS_MIE (1L << 3)    // machine-mode interrupt enable.

static inline uint64 riscv_r_mstatus() {
  uint64 x;
  asm volatile("csrr %0, mstatus" : "=r" (x));
  return x;
}

static inline void riscv_w_mstatus(uint64 x) {
  asm volatile("csrw mstatus, %0" : : "r" (x));
}

// machine exception program counter, holds the
// instruction address to which a return from
// exception will go.
static inline uint64 riscv_r_mepc() {
  uint64 x;
  asm volatile("csrr %0, mepc" : "=r" (x));
  return x;
}

static inline void riscv_w_mepc(uint64 x) {
  asm volatile("csrw mepc, %0" : : "r" (x));
}

// Machine-mode Interrupt Enable
#define RISCV_MIE_MEIE (1L << 11) // external
#define RISCV_MIE_MTIE (1L << 7)  // timer
#define RISCV_MIE_MSIE (1L << 3)  // software
static inline uint64 riscv_r_mie() {
  uint64 x;
  asm volatile("csrr %0, mie" : "=r" (x) );
  return x;
}

static inline void riscv_w_mie(uint64 x) {
  asm volatile("csrw mie, %0" : : "r" (x));
}

// Machine Exception Delegation
static inline uint64 riscv_r_medeleg() {
  uint64 x;
  asm volatile("csrr %0, medeleg" : "=r" (x) );
  return x;
}

static inline void riscv_w_medeleg(uint64 x) {
  asm volatile("csrw medeleg, %0" : : "r" (x));
}

// Machine Interrupt Delegation
static inline uint64 riscv_r_mideleg() {
  uint64 x;
  asm volatile("csrr %0, mideleg" : "=r" (x) );
  return x;
}

static inline void riscv_w_mideleg(uint64 x) {
  asm volatile("csrw mideleg, %0" : : "r" (x));
}

// Machine-mode interrupt vector
static inline void riscv_w_mtvec(uint64 x) {
  asm volatile("csrw mtvec, %0" : : "r" (x));
}

// Physical Memory Protection
static inline void riscv_w_pmpcfg0(uint64 x) {
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
}

static inline void riscv_w_pmpaddr0(uint64 x) {
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
}

// use riscv's sv39 page table scheme.
#define RISCV_SATP_SV39 (8L << 60)

#define RISCV_MAKE_SATP(pagetable) (RISCV_SATP_SV39 | (((uint64)pagetable) >> 12))

// supervisor address translation and protection;
// holds the address of the page table.
static inline void riscv_w_satp(uint64 x) {
  asm volatile("csrw satp, %0" : : "r" (x));
}

static inline uint64 riscv_r_satp() {
  uint64 x;
  asm volatile("csrr %0, satp" : "=r" (x) );
  return x;
}

static inline void riscv_w_mscratch(uint64 x) {
  asm volatile("csrw mscratch, %0" : : "r" (x));
}

#define RISCV_MCAUSE_IS_INTERRUPT(mcause) ((mcause >> 63) & 1)
#define RISCV_MCAUSE_INTERRUPT_CAUSE(mcause) (mcause & 0x7FFFFFFFFFFFFFFF)
#define RISCV_MCAUSE_MACHINE_EXTERNAL_INTERRUPT 11
#define RISCV_MCAUSE_MACHINE_TIMER_INTERRUPT 7

// Machine Trap Cause
static inline uint64 riscv_r_mcause() {
  uint64 x;
  asm volatile("csrr %0, mcause" : "=r" (x) );
  return x;
}

// Machine-mode Counter-Enable
static inline void riscv_w_mcounteren(uint64 x) {
  asm volatile("csrw mcounteren, %0" : : "r" (x));
}

static inline uint64 riscv_r_mcounteren() {
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
  return x;
}

// machine-mode cycle counter
static inline uint64 riscv_r_time() {
  uint64 x;
  asm volatile("csrr %0, time" : "=r" (x) );
  return x;
}

// enable device interrupts
static inline void riscv_intr_on() {
  riscv_w_mstatus(riscv_r_mstatus() | RISCV_MSTATUS_MIE);
}

// disable device interrupts
static inline void riscv_intr_off() {
  riscv_w_mstatus(riscv_r_mstatus() & ~RISCV_MSTATUS_MIE);
}

// are device interrupts enabled?
static inline int riscv_intr_get() {
  uint64 x = riscv_r_mstatus();
  return (x & RISCV_MSTATUS_MIE) != 0;
}

static inline uint64 riscv_r_sp() {
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
  return x;
}

static inline void riscv_w_sp(uint64 x) {
  asm volatile("mv sp, %0" : : "r" (x));
}

// read and write tp, the thread pointer, which xv6 uses to hold
// this core's hartid (core number), the index into cpus[].
static inline uint64 riscv_r_tp() {
  uint64 x;
  asm volatile("mv %0, tp" : "=r" (x) );
  return x;
}

static inline void riscv_w_tp(uint64 x) {
  asm volatile("mv tp, %0" : : "r" (x));
}

static inline uint64 riscv_r_ra() {
  uint64 x;
  asm volatile("mv %0, ra" : "=r" (x) );
  return x;
}

// flush the TLB.
static inline void riscv_sfence_vma() {
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
}

typedef uint64 riscv_pte_t;
typedef uint64 *riscv_pagetable_t; // 512 PTEs

#define RISCV_PGSIZE 4096 // bytes per page
#define RISCV_PGSHIFT 12  // bits of offset within a page

#define RISCV_PGROUNDUP(sz)  (((sz)+PGSIZE-1) & ~(PGSIZE-1))
#define RISCV_PGROUNDDOWN(a) (((a)) & ~(PGSIZE-1))

#define RISCV_PTE_V (1L << 0) // valid
#define RISCV_PTE_R (1L << 1)
#define RISCV_PTE_W (1L << 2)
#define RISCV_PTE_X (1L << 3)
#define RISCV_PTE_U (1L << 4) // user can access

// shift a physical address to the right place for a PTE.
#define RISCV_PA2PTE(pa) ((((uint64)pa) >> 12) << 10)

#define RISCV_PTE2PA(pte) (((pte) >> 10) << 12)

#define RISCV_PTE_FLAGS(pte) ((pte) & 0x3FF)

// extract the three 9-bit page table indices from a virtual address.
#define RISCV_PXMASK          0x1FF // 9 bits
#define RISCV_PXSHIFT(level)  (PGSHIFT+(9*(level)))
#define RISCV_PX(level, va) ((((uint64) (va)) >> PXSHIFT(level)) & PXMASK)

// one beyond the highest possible virtual address.
// MAXVA is actually one bit less than the max allowed by
// Sv39, to avoid having to sign-extend virtual addresses
// that have the high bit set.
#define RISCV_MAXVA (1L << (9 + 9 + 9 + 12 - 1))

#endif // _RISCV_H
