OUTPUT_ARCH( "riscv" )
ENTRY( entry )

SECTIONS
{
  /*
   * ensure that entry.S / entry is at 0x80000000,
   * where qemu's -kernel jumps.
   */
  . = 0x80000000;

  .text : {
    *(.text)
  }

  .stack : {
    . = ALIGN(16);
    _stack_start = .;
    . += 0x1000;
    PROVIDE(stack0 = .);
    /*
     * Make new stacks for our processes
     */
    . += 0x1000;
    PROVIDE(kernel_stack1 = .);
    . += 0x1000;
    PROVIDE(kernel_stack2 = .);
    . += 0x1000;
    PROVIDE(kernel_stack3 = .);
    . += 0x1000;
    PROVIDE(user_stack1 = .);
    . += 0x1000;
    PROVIDE(user_stack2 = .);
    . += 0x1000;
    PROVIDE(user_stack3 = .);
  }
}
