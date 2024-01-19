/*
qemu -kernel loads the kernel at 0x80000000
and causes each hart (i.e. CPU) to jump there.
kernel.ld causes the following code to
be placed at 0x80000000.
*/
.section .text
/*
Make the entry label (memory location) visible to ld.
This is necessary so it can put entry at 0x80000000.
*/
.global entry
/*
This reserves 4096 bytes in the .bss section, with the label stack0.
The .bss section will be filled with zeros on program load
*/
entry:
	/*
	We have a referrence to the bottom of the stack,
	but the stack grows down! So add 4096 to get the
	top of the stack (we know how big it is bc we just made it).
	*/
	la sp, stack0
	/*
	Reserve space on the stack for the most recent (printable)
	character read in. Riscv calling convention says the stack
	must be 16 byte aligned. stack0 is aligned by the linker,
	we are responsible for aligning it during runtime.
	*/
	addi sp, sp, -16
	/*
	Always initialize variables!
	*/
	sb zero, 0(sp)
	/*
	Once the C stack is set up, we jump to a C routine to handle the
	rest of the OS operation. You can still call the assembly functions
	you already wrote, but the rest of this course you will mostly
	be writing in C.
	*/
	call start

/*
This is an endless spin 🤔? What's the point of that. Remember
that a computer has no idea what it's executing, even though
our program ends here, the CPU will happily keep executing
whatever random instructions it finds after this, possibly
damaging itself in the process. If something goes wrong and 
the code leaves the input loop above, it will hit this and 
hang here, preventing the CPU from doing anything dangerous.
*/
spin:
        j spin
