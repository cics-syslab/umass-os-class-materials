.section .text
/* TODO: Expose uart_init, uart_read, uart_write, and uart_print_prompt */
/* BEGIN DELETE BLOCK */
.global uart_init, uart_read, uart_write, uart_print_prompt
/* END DELETE BLOCK */
/*
Always add documentation (especially in assembly).
Initialize the UART, which is placed at 0x10000000 by qemu.

paramters:
	None
return:
	None
*/
uart_init:
	/*
	This is VERY important, you are an assembly programmer
	now, you have to manage your own stack. The following
	prologue is the calling convention. You can see examples
	by using objdump on riscv executables like the xv6 kernel.
	Note the the epilogue undoes the exact same operations.
	*/
	addi sp, sp, -16	# Prologue: make room on the stack for local vars
	sd ra, 8(sp)		# Prologue: store the return address (necessary if you call subroutines)
	sd fp, 0(sp)		# Prologue: store the previous frame pointer
	add fp, sp, 16		# Prologue: move the frame pointer to the bottom of the new stack
	/*
	Location of uart memory mapped registers.
	*/
	li t0, 0x10000000
	/* 
	These comments are taken from the xv6 documentation
	but you can confirm them and get more information at
	http://byterunner.com/16550.html
	This page has a longer but more thorough explanation
	https://www.lammertbies.nl/comm/info/serial-uart
	*/
	sb zero, 1(t0)		# disable interrupts
	li t1, 1<<7
	sb t1, 3(t0)		# special mode to set baud rate
	li t1, 0x3
	sb t1, 0(t0)		# LSB for baud rate of 38.4K
	sb zero, 1(t0)		# MSB for baud rate of 38.4K
	li t1, 0x3
	sb t1, 3(t0)		# leave set-baud mode, and set word length to 8 bits, no parity
	li t1, 0x7
	sb t1, 2(t0)		# reset and enable FIFOs
	li t1, 0x3
	sb t1, 1(t0)		# enable transmit and receive interrupts
	ld ra, 8(sp)		# Epilogue: restore the return address
	ld s0, 0(sp)		# Epilogue: restore the previous frame
	addi sp, sp, 16		# Epilogue: restore the previous frame
	ret					# Epilogue: return to caller

/*
TODO:
Loop until the uart is ready to send a byte.
Once it is, return. It should NOT consume
the byte in the receive holding register.
What register holds the status of the UART
line?

It should follow all RISC-V calling conventions.

paramters: 
	None
return: 
	None
*/
uart_wait_for_write:
/* BEGIN DELETE BLOCK */
	addi sp, sp, -16					# Begin prologue
	sd ra, 8(sp)
	sd fp, 0(sp)
	add fp, sp, 16						# End prologue
	li t0, 0x10000000					# Address of UART base
	lb t1, 5(t0)						# Tight loop reading in LSR
	andi t1, t1, 0x20					# Check LSR transmit holding empty bit 
	beqz t1, uart_wait_for_write+20		# End of loop
	ld ra, 8(sp)						# Begin epilogue
	ld s0, 0(sp)
	addi sp, sp, 16
	ret									# End epilogue
/* END DELETE BLOCK */

/*
Wait until the uart has a byte to read.
Once there is, return.

paramters:
	None
return: 
	None
*/
uart_wait_for_read:
	addi sp, sp, -16					# Begin prologue
	sd ra, 8(sp)
	sd fp, 0(sp)
	add fp, sp, 16						# End prologue
	li t0, 0x10000000					# Address of UART base
	lb t1, 5(t0)						# Tight loop reading in LSR
	andi t1, t1, 0x01					# Check LSR receive data ready
	beqz t1, uart_wait_for_read+20		# End of loop
	ld ra, 8(sp)						# Begin prologue
	ld s0, 0(sp)
	addi sp, sp, 16
	ret									# End prologue

/*
TODO:
Wait until the uart has room for a byte, using
uart_wait_for_write. Once there is room, write 
the first argument to the uart using uart_put_c. 

It should follow all RISC-V calling conventions.

paramters:
	a0: the character to write
return: 
	None
*/
uart_write:
/* BEGIN DELETE BLOCK */
	addi sp, sp, -16					# Begin prologue
	sd ra, 8(sp)
	sd fp, 0(sp)
	add fp, sp, 16						# End prologue
	call uart_wait_for_write			# Wait until there is data to read
	call uart_put_c						# Write the paramter to the uart, it is already stored in a0
	ld ra, 8(sp)						# Begin prologue
	ld s0, 0(sp)
	addi sp, sp, 16
	ret									# End prologue
/* END DELETE BLOCK */

/*
Wait until the uart has a byte to read.
Once there is, read it and return.

paramters:
	None
return: 
	a0: the character read
*/
uart_read:
	addi sp, sp, -16					# Begin prologue
	sd ra, 8(sp)
	sd fp, 0(sp)
	add fp, sp, 16						# End prologue
	call uart_wait_for_read				# Wait for data to be available
	call uart_get_c						# Read the data, implicitly stored in a0
	ld ra, 8(sp)						# Begin epilogue
	ld s0, 0(sp)
	addi sp, sp, 16
	ret									# End epilogue


/*
TODO:
Write the character in the first parameter to the uart.
What register can you use to transmit the byte and where
is it located (what memory address)? Remember the UART 
register layout and the memory layout of the virt board
we're running this on with QEMU.

It should follow all RISC-V calling conventions.

paramters:
	a0: the character to write
return: 
	None
*/
uart_put_c:
/* BEGIN DELETE BLOCK */
	addi sp, sp, -16					# Begin prologue
	sd ra, 8(sp)
	sd fp, 0(sp)
	add fp, sp, 16						# End prologue
	li t0, 0x10000000					# Address of the THR (Transmit Holding Register)
	sb a0, 0(t0)						# Address of THR
	ld ra, 8(sp)						# Begin epilogue
	ld s0, 0(sp)
	addi sp, sp, 16
	ret									# End epilogue
/* END DELETE BLOCK */

/*
Read a character from the uart.

It should follow all RISC-V calling conventions.

paramters:
	None
return: 
	a0: the character read
*/
uart_get_c:
	addi sp, sp, -16					# Begin prologue
	sd ra, 8(sp)
	sd fp, 0(sp)
	add fp, sp, 16						# End prologue
	li t0, 0x10000000					# Address of the RHR (Receive Holding Register)
	lb a0, 0(t0)						# Address of RHR
	ld ra, 8(sp)						# Begin epilogue
	ld s0, 0(sp)
	addi sp, sp, 16
	ret									# End epilogue


/*
TODO: 
Use uart_write to print your prompt. Your prompt
can be anything reasonable. Remember that each 
call to uart_write only writes one byte.

It should follow all RISC-V calling conventions.

paramters:
	None
return: 
	None
*/
uart_print_prompt:
/* BEGIN DELETE BLOCK */
	addi sp, sp, -16					# Begin prologue
	sd ra, 8(sp)
	sd fp, 0(sp)
	add fp, sp, 16						# End prologue
	li a0, '>'							# Put '>' into the first parameter
	call uart_write						# Print it
	li a0, ' '							# Put ' ' into the first parameter
	call uart_write						# Print it
	ld ra, 8(sp)						# Begin epilogue
	ld s0, 0(sp)
	addi sp, sp, 16
	ret									# End epilogue
/* END DELETE BLOCK */
