#include "types.h"
#include "memlayout.h"
#include "riscv.h"

void trap_inithart();
void trap_kernel();
void trap_usertrap();
void trap_usertrap_return();
