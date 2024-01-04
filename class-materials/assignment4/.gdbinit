set confirm off
set architecture riscv:rv64
target remote 127.0.0.1:25501
symbol-file bin/kernel
set disassemble-next-line auto
set riscv use-compressed-breakpoints yes
set show-compact-regs on
b _entry
c
