OUTPUT_ARCH( "riscv" )
ENTRY( _entry )

SECTIONS
{
  /*
   * ensure that entry.S / _entry is at 0x80000000,
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
  }
}
