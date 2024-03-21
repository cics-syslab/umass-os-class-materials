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
	Load the stack pointer into $sp
	*/
	la sp, stack0
	/*
	Reserve space on the stack for the most recent (printable)
	character read in. Riscv calling convention says the stack
	must be 16 byte aligned. stack0 is aligned by the linker,
	we are responsible for aligning it during runtime.
	Remember the stack grows downward!
	*/
	addi sp, sp, -16
	/*
	Always initialize variables!
	*/
	sb zero, 0(sp)
	/*
	Jump to subroutine to initialize UART.
	Pay attetion to the function prologue and epilogue!
	*/
	call uart_init
/*
This is the top of the input loop.
*/
_prompt:
	call uart_print_prompt
/*
Here we process input until we get a newline or carriage return.
Each new non-newline-cariiage-return character goes into
the variable we made on the stack above, overwriting each other.
It also gets printed back to the screen so the user can see
what they're typing. Who knew such a basic part of the computer
was so complex!. Nothing to do next, so back to reading input. Printing
the null byte does nothing so this is okay, but think about how you could
add more error handling to correct this?
Once we get a new line we jump to _got_new_line to handle
priting the most recently typed character. After that print
the prompt and wait for the ext character.
*/
_wait_for_input:
	/*
	Returns the character in $a0
	*/
	call uart_read
	/*
	These next four lines compare the byte to see if it is
	line end character, if so jump to _got_new_line to
	process it. 
	*/
	li t0, '\r'
	beq a0, t0, _got_new_line
	li t0, '\n'
	beq a0, t0, _got_new_line
	/*
	Implicitly takes the output of uart_read in as input
	because we never changed the value of $a0.
	Note: $a0 is caller saved, so this only works because
	we haven't called any functions.
	This is where the character is echoed back to the user.
	*/
	call uart_write
	/*
	Store it for use later.
	*/
	sb a0, 0(sp)
	/*
	Jump back to waiting for input.
	*/
	j _wait_for_input
_got_new_line:
	/*
	Print a new line to display the output on.
	*/
	li a0, '\n'
	call uart_write
	/*
	Fetch the most recently tpyed character.
	*/
	lb a0, 0(sp)
	/*
	If there is no most recently typed character then reprint the
	prompt. Otherwise print the character.
	*/
	beqz a0, _prompt
	call uart_write
	/*
	Clear the character we just printed.
	*/
	sb zero, 0(sp)
	/*
	Write a new line for the prompt and then reprint
	the prompt.
	*/
	li a0, '\n'
	call uart_write
	j _prompt
/*
This is an endless spin 🤔? What's the point of that.
Well if something goes wrong and the code leaves the 
input loop above, it will hit this and hang here, letting 
the programmer see there is an erorr without writing
all over any variables that might help you debug what happened.
*/
spin:
        j spin
