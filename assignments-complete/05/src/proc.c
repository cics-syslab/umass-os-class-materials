#include "proc.h"
#include "main.h"
#include "switch.h"
#include "riscv.h"
#include "util.h"
#include "uart.h"
#include "kernel.ld.h"
#include "trap.h"

struct proc proc_processes[3];

// This variable tracks the currently running process.
// We use -1 for the initalization code. It will never be
// -1 once our processes start running.
int proc_curr_proc_id = -1;

// Initialize the proc structure by setting up each proc to use its
// stack and to return to proc_first_schedule which will handle switching
// to that process for the first time. Additionally set up the "user land"
// proc to return to the first time we return from the kernel. I use quotes
// because for the time being our procs will run in machine mode instead
// of user mode, however they still do a good job of showing what is 
// required to switch between processes with timer interrupts. 
void proc_init() {
    proc_processes[0].kernel_context.sp = (uint64) &kernel_stack1;
    proc_processes[0].kernel_context.ra = (uint64) proc_first_schedule;
    proc_processes[0].user_context.pc = (uint64) main;
    proc_processes[0].user_context.sp = (uint64) &user_stack1;

    proc_processes[1].kernel_context.sp = (uint64) &kernel_stack2;
    proc_processes[1].kernel_context.ra = (uint64) proc_first_schedule;
    proc_processes[1].user_context.pc = (uint64) main2;
    proc_processes[1].user_context.sp = (uint64) &user_stack2;

    proc_processes[2].kernel_context.sp = (uint64) &kernel_stack3;
    proc_processes[2].kernel_context.ra = (uint64) proc_first_schedule;
    proc_processes[2].user_context.pc = (uint64) main3;
    proc_processes[2].user_context.sp = (uint64) &user_stack3;
}

// This is the function that gets called from trap_devintr and decides
// what proc to run next. In this case we simply run in a round robin
// loop. We acheive this by using a GLOBAL variable. It's important
// that it's global because any variable stored on the stack of a
// process will be local to that process and thus unreachable from 
// other processes. 
void proc_schedule() {
    uint64 next_pid = (proc_curr_proc_id + 1) % 3;
    util_print_buf("\nSwitching to proc ");
    switch (next_pid) {
    case 0:
        uart_write('A');
        break;

    case 1:
        uart_write('B');
        break;
    
    case 2:
        uart_write('C');
        break;
    
    default:
        util_print_buf("panic: bad pid");
    }
    uart_write('\n');
    uint64 mepc = riscv_r_mepc();
    uint64 mstatus = riscv_r_mstatus();
    uint64 mscratch = riscv_r_mscratch();
    switch_to_process(&proc_processes[proc_curr_proc_id].kernel_context, &proc_processes[next_pid].kernel_context);
    // A naive solution to this might use next_pid as calculated above, but remember
    // that by the time we reach this line, we have switched to a new stack so the
    // value in that variable won't be the same as before we switched. As a quick
    // example once proc 2 switches to proc 0, that proc 0 will hold 1 in next_pid
    // so adding one to it will actually put 2 in proc_curr_id instead of 0 as
    // intended. 
    proc_curr_proc_id = (proc_curr_proc_id + 1) % 3;
    riscv_w_mepc(mepc);
    riscv_w_mstatus(mstatus);
    riscv_w_mscratch(mscratch);
}

// Because machinevec pushes and then pops all registers on the stack,
// returning into machinevec on our brand new (empty) stacks from
// a new proc will cause undefined behavior when undefined values 
// are popped into the registers. So instead, we have all processes
// set up to return into user land through this function. It assumes that
// we're already on the new procs stack. 
void proc_first_schedule() {
    proc_curr_proc_id = (proc_curr_proc_id + 1) % 3;
    // set mscratch to hold pointer to proc struct
    riscv_w_mscratch((uint64) &proc_processes[proc_curr_proc_id].user_context);
/* BEGIN DELETE BLOCK */
    trap_usertrap_return();
/* END DELETE BLOCK */
}