#include "proc.h"
#include "main.h"
#include "switch.h"
#include "riscv.h"
#include "util.h"
#include "uart.h"

extern char stack1;
extern char stack2;
extern char stack3;

struct proc proc_processes[3];

int proc_curr_proc_id = -1;

void proc_init() {
    proc_processes[0].kernel_context.sp = (uint64) &stack1;
    proc_processes[0].kernel_context.ra = (uint64) proc_first_schedule;
    proc_processes[0].entry = main;
    proc_processes[1].kernel_context.sp = (uint64) &stack2;
    proc_processes[1].kernel_context.ra = (uint64) proc_first_schedule;
    proc_processes[1].entry = main2;
    proc_processes[2].kernel_context.sp = (uint64) &stack3;
    proc_processes[2].kernel_context.ra = (uint64) proc_first_schedule;
    proc_processes[2].entry = main3;
}

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
    switch_to_process(&proc_processes[proc_curr_proc_id].kernel_context, &proc_processes[next_pid].kernel_context);
    proc_curr_proc_id = (proc_curr_proc_id + 1) % 3;;
    riscv_w_mepc(mepc);
    riscv_w_mstatus(mstatus);
}

void proc_first_schedule() {
    proc_curr_proc_id = (proc_curr_proc_id + 1) % 3;
    riscv_w_mepc((uint64) proc_processes[proc_curr_proc_id].entry);
    uint64 mstatus = riscv_r_mstatus();
    mstatus &= ~RISCV_MSTATUS_MPP_MASK;
    mstatus |= RISCV_MSTATUS_MPP_M;
    riscv_w_mstatus(mstatus);
    asm("mret");
}