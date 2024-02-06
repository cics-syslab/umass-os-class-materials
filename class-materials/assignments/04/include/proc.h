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
  uint64 ra;

  // callee-saved
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

// This is the struct that umass-os uses to keep track of processes. It is sometimes
// called a process control block (PCB). For now it is relatively small but we will
// add more to this as we build up the kernel
struct proc {
  struct proc_kernel_context kernel_context;
  // Note: this weird syntax is a c style function pointer. It looks like
  // <return type> (*<name>)(<parameter types>)
  // The parentheses around the name and asterisk are necessary to distginuish a
  // function that returns a void* and a function pointer. The (void) here is not the 
  // same as during a function definition. It means that the function pointed too takes
  // no paramters. If you replaced it with () that would mean the function takes an
  // unknown number of parameters with an unknown type.
  void (*entry)(void);
};

// This is the array we will use to store all of our processes.
extern struct proc proc_processes[];

void proc_init();
void proc_schedule();
void proc_first_schedule();
#endif // _PROC_H