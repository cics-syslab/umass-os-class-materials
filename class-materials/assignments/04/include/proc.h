#ifndef _PROC_H
#define _PROC_H
#include "types.h"

// Saved registers for kernel context switches.
struct proc_kernel_context {
  uint64 ra;
  uint64 sp;

  // callee-saved
  uint64 s0;
  uint64 s1;
  uint64 s2;
  uint64 s3;
  uint64 s4;
  uint64 s5;
  uint64 s6;
  uint64 s7;
  uint64 s8;
  uint64 s9;
  uint64 s10;
  uint64 s11;
};

struct proc {
  struct proc_kernel_context kernel_context;
  void (*entry)(void);
};

extern struct proc proc_processes[];

void proc_init();
void proc_schedule();
void proc_first_schedule();
#endif // _PROC_H