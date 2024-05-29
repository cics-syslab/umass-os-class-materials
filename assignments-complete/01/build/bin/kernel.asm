
build/bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <entry>:
.global entry
entry:
	/*
	Load the stack pointer into $sp
	*/
	la sp, stack0
    80000000:	00001117          	auipc	sp,0x1
    80000004:	22010113          	addi	sp,sp,544 # 80001220 <stack0>
	character read in. Riscv calling convention says the stack
	must be 16 byte aligned. stack0 is aligned by the linker,
	we are responsible for aligning it during runtime.
	Remember the stack grows downward!
	*/
	addi sp, sp, -16
    80000008:	ff010113          	addi	sp,sp,-16
	/*
	Always initialize variables!
	*/
	sb zero, 0(sp)
    8000000c:	00010023          	sb	zero,0(sp)
	/*
	Jump to subroutine to initialize UART.
	Pay attetion to the function prologue and epilogue!
	*/
	call uart_init
    80000010:	00000097          	auipc	ra,0x0
    80000014:	06c080e7          	jalr	108(ra) # 8000007c <uart_init>

0000000080000018 <_prompt>:
/*
This is the top of the input loop.
*/
_prompt:
	call uart_print_prompt
    80000018:	00000097          	auipc	ra,0x0
    8000001c:	1c8080e7          	jalr	456(ra) # 800001e0 <uart_print_prompt>

0000000080000020 <_wait_for_input>:
*/
_wait_for_input:
	/*
	Returns the character in $a0
	*/
	call uart_read
    80000020:	00000097          	auipc	ra,0x0
    80000024:	140080e7          	jalr	320(ra) # 80000160 <uart_read>
	/*
	These next four lines compare the byte to see if it is
	line end character, if so jump to _got_new_line to
	process it. 
	*/
	li t0, '\r'
    80000028:	00d00293          	li	t0,13
	beq a0, t0, _got_new_line
    8000002c:	00550e63          	beq	a0,t0,80000048 <_got_new_line>
	li t0, '\n'
    80000030:	00a00293          	li	t0,10
	beq a0, t0, _got_new_line
    80000034:	00550a63          	beq	a0,t0,80000048 <_got_new_line>
	because we never changed the value of $a0.
	Note: $a0 is caller saved, so this only works because
	we haven't called any functions.
	This is where the character is echoed back to the user.
	*/
	call uart_write
    80000038:	00000097          	auipc	ra,0x0
    8000003c:	0f8080e7          	jalr	248(ra) # 80000130 <uart_write>
	/*
	Store it for use later.
	*/
	sb a0, 0(sp)
    80000040:	00a10023          	sb	a0,0(sp)
	/*
	Jump back to waiting for input.
	*/
	j _wait_for_input
    80000044:	fddff06f          	j	80000020 <_wait_for_input>

0000000080000048 <_got_new_line>:
_got_new_line:
	/*
	Print a new line to display the output on.
	*/
	li a0, '\n'
    80000048:	00a00513          	li	a0,10
	call uart_write
    8000004c:	00000097          	auipc	ra,0x0
    80000050:	0e4080e7          	jalr	228(ra) # 80000130 <uart_write>
	/*
	Fetch the most recently tpyed character.
	*/
	lb a0, 0(sp)
    80000054:	00010503          	lb	a0,0(sp)
	/*
	If there is no most recently typed character then reprint the
	prompt. Otherwise print the character.
	*/
	beqz a0, _prompt
    80000058:	fc0500e3          	beqz	a0,80000018 <_prompt>
	call uart_write
    8000005c:	00000097          	auipc	ra,0x0
    80000060:	0d4080e7          	jalr	212(ra) # 80000130 <uart_write>
	/*
	Clear the character we just printed.
	*/
	sb zero, 0(sp)
    80000064:	00010023          	sb	zero,0(sp)
	/*
	Write a new line for the prompt and then reprint
	the prompt.
	*/
	li a0, '\n'
    80000068:	00a00513          	li	a0,10
	call uart_write
    8000006c:	00000097          	auipc	ra,0x0
    80000070:	0c4080e7          	jalr	196(ra) # 80000130 <uart_write>
	j _prompt
    80000074:	fa5ff06f          	j	80000018 <_prompt>

0000000080000078 <spin>:
input loop above, it will hit this and hang here, letting 
the programmer see there is an erorr without writing
all over any variables that might help you debug what happened.
*/
spin:
        j spin
    80000078:	0000006f          	j	80000078 <spin>

000000008000007c <uart_init>:
	now, you have to manage your own stack. The following
	prologue is the calling convention. You can see examples
	by using objdump on riscv executables like the xv6 kernel.
	Note the the epilogue undoes the exact same operations.
	*/
	addi sp, sp, -16	# Prologue: make room on the stack for local vars
    8000007c:	ff010113          	addi	sp,sp,-16
	sd ra, 8(sp)		# Prologue: store the return address (necessary if you call subroutines)
    80000080:	00113423          	sd	ra,8(sp)
	sd fp, 0(sp)		# Prologue: store the previous frame pointer
    80000084:	00813023          	sd	s0,0(sp)
	add fp, sp, 16		# Prologue: move the frame pointer to the bottom of the new stack
    80000088:	01010413          	addi	s0,sp,16
	/*
	Location of uart memory mapped registers.
	*/
	li t0, 0x10000000
    8000008c:	100002b7          	lui	t0,0x10000
	but you can confirm them and get more information at
	http://byterunner.com/16550.html
	This page has a longer but more thorough explanation
	https://www.lammertbies.nl/comm/info/serial-uart
	*/
	sb zero, 1(t0)		# disable interrupts
    80000090:	000280a3          	sb	zero,1(t0) # 10000001 <entry-0x6fffffff>
	li t1, 1<<7
    80000094:	08000313          	li	t1,128
	sb t1, 3(t0)		# special mode to set baud rate
    80000098:	006281a3          	sb	t1,3(t0)
	li t1, 0x3
    8000009c:	00300313          	li	t1,3
	sb t1, 0(t0)		# LSB for baud rate of 38.4K
    800000a0:	00628023          	sb	t1,0(t0)
	sb zero, 1(t0)		# MSB for baud rate of 38.4K
    800000a4:	000280a3          	sb	zero,1(t0)
	li t1, 0x3
    800000a8:	00300313          	li	t1,3
	sb t1, 3(t0)		# leave set-baud mode, and set word length to 8 bits, no parity
    800000ac:	006281a3          	sb	t1,3(t0)
	li t1, 0x7
    800000b0:	00700313          	li	t1,7
	sb t1, 2(t0)		# reset and enable FIFOs
    800000b4:	00628123          	sb	t1,2(t0)
	li t1, 0x3
    800000b8:	00300313          	li	t1,3
	sb t1, 1(t0)		# enable transmit and receive interrupts
    800000bc:	006280a3          	sb	t1,1(t0)
	ld ra, 8(sp)		# Epilogue: restore the return address
    800000c0:	00813083          	ld	ra,8(sp)
	ld s0, 0(sp)		# Epilogue: restore the previous frame
    800000c4:	00013403          	ld	s0,0(sp)
	addi sp, sp, 16		# Epilogue: restore the previous frame
    800000c8:	01010113          	addi	sp,sp,16
	ret					# Epilogue: return to caller
    800000cc:	00008067          	ret

00000000800000d0 <uart_wait_for_write>:
paramters:
return: 
*/
uart_wait_for_write:
/* BEGIN DELETE BLOCK */
	addi sp, sp, -16					# Begin prologue
    800000d0:	ff010113          	addi	sp,sp,-16
	sd ra, 8(sp)
    800000d4:	00113423          	sd	ra,8(sp)
	sd fp, 0(sp)
    800000d8:	00813023          	sd	s0,0(sp)
	add fp, sp, 16						# End prologue
    800000dc:	01010413          	addi	s0,sp,16
	li t0, 0x10000000					# Address of UART base
    800000e0:	100002b7          	lui	t0,0x10000
	lb t1, 5(t0)						# Tight loop reading in LSR
    800000e4:	00528303          	lb	t1,5(t0) # 10000005 <entry-0x6ffffffb>
	andi t1, t1, 0x20					# Check LSR transmit holding empty bit 
    800000e8:	02037313          	andi	t1,t1,32
	beqz t1, uart_wait_for_write+20		# End of loop
    800000ec:	fe030ce3          	beqz	t1,800000e4 <uart_wait_for_write+0x14>
	ld ra, 8(sp)						# Begin epilogue
    800000f0:	00813083          	ld	ra,8(sp)
	ld s0, 0(sp)
    800000f4:	00013403          	ld	s0,0(sp)
	addi sp, sp, 16
    800000f8:	01010113          	addi	sp,sp,16
	ret									# End epilogue
    800000fc:	00008067          	ret

0000000080000100 <uart_wait_for_read>:

paramters:
return: 
*/
uart_wait_for_read:
	addi sp, sp, -16					# Begin prologue
    80000100:	ff010113          	addi	sp,sp,-16
	sd ra, 8(sp)
    80000104:	00113423          	sd	ra,8(sp)
	sd fp, 0(sp)
    80000108:	00813023          	sd	s0,0(sp)
	add fp, sp, 16						# End prologue
    8000010c:	01010413          	addi	s0,sp,16
	li t0, 0x10000000					# Address of UART base
    80000110:	100002b7          	lui	t0,0x10000
	lb t1, 5(t0)						# Tight loop reading in LSR
    80000114:	00528303          	lb	t1,5(t0) # 10000005 <entry-0x6ffffffb>
	andi t1, t1, 0x01					# Check LSR receive data ready
    80000118:	00137313          	andi	t1,t1,1
	beqz t1, uart_wait_for_read+20		# End of loop
    8000011c:	fe030ce3          	beqz	t1,80000114 <uart_wait_for_read+0x14>
	ld ra, 8(sp)						# Begin prologue
    80000120:	00813083          	ld	ra,8(sp)
	ld s0, 0(sp)
    80000124:	00013403          	ld	s0,0(sp)
	addi sp, sp, 16
    80000128:	01010113          	addi	sp,sp,16
	ret									# End prologue
    8000012c:	00008067          	ret

0000000080000130 <uart_write>:
	a0: the character to write
return: 
*/
uart_write:
/* BEGIN DELETE BLOCK */
	addi sp, sp, -16					# Begin prologue
    80000130:	ff010113          	addi	sp,sp,-16
	sd ra, 8(sp)
    80000134:	00113423          	sd	ra,8(sp)
	sd fp, 0(sp)
    80000138:	00813023          	sd	s0,0(sp)
	add fp, sp, 16						# End prologue
    8000013c:	01010413          	addi	s0,sp,16
	call uart_wait_for_write			# Wait until there is data to read
    80000140:	00000097          	auipc	ra,0x0
    80000144:	f90080e7          	jalr	-112(ra) # 800000d0 <uart_wait_for_write>
	call uart_put_c						# Write the paramter to the uart, it is already stored in a0
    80000148:	00000097          	auipc	ra,0x0
    8000014c:	048080e7          	jalr	72(ra) # 80000190 <uart_put_c>
	ld ra, 8(sp)						# Begin prologue
    80000150:	00813083          	ld	ra,8(sp)
	ld s0, 0(sp)
    80000154:	00013403          	ld	s0,0(sp)
	addi sp, sp, 16
    80000158:	01010113          	addi	sp,sp,16
	ret									# End prologue
    8000015c:	00008067          	ret

0000000080000160 <uart_read>:
paramters:
return: 
	a0: the character read
*/
uart_read:
	addi sp, sp, -16					# Begin prologue
    80000160:	ff010113          	addi	sp,sp,-16
	sd ra, 8(sp)
    80000164:	00113423          	sd	ra,8(sp)
	sd fp, 0(sp)
    80000168:	00813023          	sd	s0,0(sp)
	add fp, sp, 16						# End prologue
    8000016c:	01010413          	addi	s0,sp,16
	call uart_wait_for_read				# Wait for data to be available
    80000170:	00000097          	auipc	ra,0x0
    80000174:	f90080e7          	jalr	-112(ra) # 80000100 <uart_wait_for_read>
	call uart_get_c						# Read the data, implicitly stored in a0
    80000178:	00000097          	auipc	ra,0x0
    8000017c:	040080e7          	jalr	64(ra) # 800001b8 <uart_get_c>
	ld ra, 8(sp)						# Begin epilogue
    80000180:	00813083          	ld	ra,8(sp)
	ld s0, 0(sp)
    80000184:	00013403          	ld	s0,0(sp)
	addi sp, sp, 16
    80000188:	01010113          	addi	sp,sp,16
	ret									# End epilogue
    8000018c:	00008067          	ret

0000000080000190 <uart_put_c>:
	a0: the character to write
return: 
*/
uart_put_c:
/* BEGIN DELETE BLOCK */
	addi sp, sp, -16					# Begin prologue
    80000190:	ff010113          	addi	sp,sp,-16
	sd ra, 8(sp)
    80000194:	00113423          	sd	ra,8(sp)
	sd fp, 0(sp)
    80000198:	00813023          	sd	s0,0(sp)
	add fp, sp, 16						# End prologue
    8000019c:	01010413          	addi	s0,sp,16
	li t0, 0x10000000					# Address of the THR (Transmit Holding Register)
    800001a0:	100002b7          	lui	t0,0x10000
	sb a0, 0(t0)						# Address of THR
    800001a4:	00a28023          	sb	a0,0(t0) # 10000000 <entry-0x70000000>
	ld ra, 8(sp)						# Begin epilogue
    800001a8:	00813083          	ld	ra,8(sp)
	ld s0, 0(sp)
    800001ac:	00013403          	ld	s0,0(sp)
	addi sp, sp, 16
    800001b0:	01010113          	addi	sp,sp,16
	ret									# End epilogue
    800001b4:	00008067          	ret

00000000800001b8 <uart_get_c>:
paramters:
return: 
	a0: the character read
*/
uart_get_c:
	addi sp, sp, -16					# Begin prologue
    800001b8:	ff010113          	addi	sp,sp,-16
	sd ra, 8(sp)
    800001bc:	00113423          	sd	ra,8(sp)
	sd fp, 0(sp)
    800001c0:	00813023          	sd	s0,0(sp)
	add fp, sp, 16						# End prologue
    800001c4:	01010413          	addi	s0,sp,16
	li t0, 0x10000000					# Address of the RHR (Receive Holding Register)
    800001c8:	100002b7          	lui	t0,0x10000
	lb a0, 0(t0)						# Address of RHR
    800001cc:	00028503          	lb	a0,0(t0) # 10000000 <entry-0x70000000>
	ld ra, 8(sp)						# Begin epilogue
    800001d0:	00813083          	ld	ra,8(sp)
	ld s0, 0(sp)
    800001d4:	00013403          	ld	s0,0(sp)
	addi sp, sp, 16
    800001d8:	01010113          	addi	sp,sp,16
	ret									# End epilogue
    800001dc:	00008067          	ret

00000000800001e0 <uart_print_prompt>:
paramters:
return: 
*/
uart_print_prompt:
/* BEGIN DELETE BLOCK */
	addi sp, sp, -16					# Begin prologue
    800001e0:	ff010113          	addi	sp,sp,-16
	sd ra, 8(sp)
    800001e4:	00113423          	sd	ra,8(sp)
	sd fp, 0(sp)
    800001e8:	00813023          	sd	s0,0(sp)
	add fp, sp, 16						# End prologue
    800001ec:	01010413          	addi	s0,sp,16
	li a0, '>'							# Put '>' into the first parameter
    800001f0:	03e00513          	li	a0,62
	call uart_write						# Print it
    800001f4:	00000097          	auipc	ra,0x0
    800001f8:	f3c080e7          	jalr	-196(ra) # 80000130 <uart_write>
	li a0, ' '							# Put ' ' into the first parameter
    800001fc:	02000513          	li	a0,32
	call uart_write						# Print it
    80000200:	00000097          	auipc	ra,0x0
    80000204:	f30080e7          	jalr	-208(ra) # 80000130 <uart_write>
	ld ra, 8(sp)						# Begin epilogue
    80000208:	00813083          	ld	ra,8(sp)
	ld s0, 0(sp)
    8000020c:	00013403          	ld	s0,0(sp)
	addi sp, sp, 16
    80000210:	01010113          	addi	sp,sp,16
	ret									# End epilogue
    80000214:	00008067          	ret
