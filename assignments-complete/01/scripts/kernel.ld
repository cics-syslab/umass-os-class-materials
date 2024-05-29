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
/* 
TODO:
Make a section called `.stack`. PROVIDE a symbol called `stack0` to the compiler.
`stack0` should point to the top (high address) of a 4096 byte region. Remember
the RISC-V stack must be 16 byte ALIGNed.
/*
/* BEGIN DELETE BLOCK */
  .stack : {
    . = ALIGN(16);
    . += 0x1000;
    PROVIDE(stack0 = .);
  }
/* END DELETE BLOCK */
}
