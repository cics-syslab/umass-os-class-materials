#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "defs.h"

volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
  if(cpuid() == 0){
    consoleinit();
    printfinit();
    printf("\n");
    printf("\n");
    kinit();         // physical page allocator
    kvminit();       // create kernel page table
    kvminithart();   // turn on paging
    procinit();      // process table
    trapinit();      // trap vectors
    trapinithart();  // install kernel trap vector
    plicinit();      // set up interrupt controller
    plicinithart();  // ask PLIC for device interrupts
    binit();         // buffer cache
    iinit();         // inode table
    fileinit();      // file table
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
      ;
    __sync_synchronize();
    kvminithart();    // turn on paging
    trapinithart();   // install kernel trap vector
    plicinithart();   // ask PLIC for device interrupts
  }

  if (cpuid() == 0) {
    printf("Welcome to\n");
    printf(
      "  _   _ __  __                ___  ____  \n"
      " | | | |  \\/  | __ _ ___ ___ / _ \\/ ___| \n"
      " | | | | |\\/| |/ _` / __/ __| | | \\___ \\ \n"
      " | |_| | |  | | (_| \\__ \\__ \\ |_| |___) |\n"
      "  \\___/|_|  |_|\\__,_|___/___/\\___/|____/ \n"
    );
  }

  scheduler();        
}
