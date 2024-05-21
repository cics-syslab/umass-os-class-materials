#ifndef _PROC_H
#define _PROC_H
#include "types.h"

// Saved registers for kernel context switches. In particular we use this struct
// with switch_to_process. Note that we don't save all of them.  CSRs are never 
// stored for a variety of reasons and we only need to store the CALLEE saved 
// registers. All caller saved registers will be saved on the stack before calling
// switch_to_process. In particular we save sp. This is because the stack is the
// singular most important data structure for defining a context. It is where
// the majority of all variables are saved in the umass-os kernel. We also save 
// ra so that we can control where a process returns to. This is useful to make 
// a special return path for functions the first time they are run.
struct proc_kernel_context {
  // Not strictly necessary to save this as it is caller
  // saved, but it is useful to be able to control the 
  // function that a process will enter when it is
  // switched to.
  uint64 ra;

  // callee-saved, these must be saved because the C code
  // won't save them before calling switch_to_process
  uint64 sp;
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

struct proc_user_context {
  uint64 kernel_sp;    // top of process's kernel stack
  uint64 pc;           // saved user program counter
  uint64 ra;
  uint64 sp;
  uint64 gp;
  uint64 tp;
  uint64 t0;
  uint64 t1;
  uint64 t2;
  uint64 s0;
  uint64 s1;
  uint64 a0;
  uint64 a1;
  uint64 a2;
  uint64 a3;
  uint64 a4;
  uint64 a5;
  uint64 a6;
  uint64 a7;
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
  uint64 t3;
  uint64 t4;
  uint64 t5;
  uint64 t6;
};

// This is the struct that umass-os uses to keep track of processes. It is sometimes
// called a process control block (PCB). For now it is relatively small but we will
// add more to this as we build up the kernel
struct proc {
  struct proc_user_context user_context;
  struct proc_kernel_context kernel_context;
  uint64 kernel_stack;
};

// This is the array we will use to store all of our processes.
extern struct proc proc_processes[];
extern int proc_curr_proc_id;

void proc_init();
void proc_schedule();
void proc_first_schedule();
#endif // _PROC_H