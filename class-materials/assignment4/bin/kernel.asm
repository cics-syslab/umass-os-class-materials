
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
	/*
	We have a referrence to the bottom of the stack,
	but the stack grows down! So add 4096 to get the
	top of the stack (we know how big it is bc we just made it).
	*/
	la sp, stack0
    80000000:	00002117          	auipc	sp,0x2
    80000004:	15010113          	add	sp,sp,336 # 80002150 <stack0>
	Reserve space on the stack for the most recent (printable)
	character read in. Riscv calling convention says the stack
	must be 16 byte aligned. stack0 is aligned by the linker,
	we are responsible for aligning it during runtime.
	*/
	addi sp, sp, -16
    80000008:	ff010113          	add	sp,sp,-16
	/*
	Always initialize variables!
	*/
	sb zero, 0(sp)
    8000000c:	00010023          	sb	zero,0(sp)
	Once the C stack is set up, we jump to a C routine to handle the
	rest of the OS operation. You can still call the assembly functions
	you already wrote, but the rest of this course you will mostly
	be writing in C.
	*/
	call start
    80000010:	00000097          	auipc	ra,0x0
    80000014:	2ac080e7          	jalr	684(ra) # 800002bc <start>

0000000080000018 <spin>:
input loop above, it will hit this and hang here, letting 
the programmer see there is an erorr without writing
all over any variables that might help you debug what happened.
*/
spin:
        j spin
    80000018:	0000006f          	j	80000018 <spin>

000000008000001c <print_prompt>:
// This keeps things encapsulated which is a key part of good
// software design.
char cmd_buf[MAIN_MAX_CMD_LEN] = {0};
unsigned char idx = 0;

void print_prompt() {
    8000001c:	ff010113          	add	sp,sp,-16
    80000020:	00113423          	sd	ra,8(sp)
    80000024:	00813023          	sd	s0,0(sp)
    80000028:	01010413          	add	s0,sp,16
  uart_write('>');
    8000002c:	03e00513          	li	a0,62
    80000030:	00000097          	auipc	ra,0x0
    80000034:	724080e7          	jalr	1828(ra) # 80000754 <uart_write>
  uart_write(' ');
    80000038:	02000513          	li	a0,32
    8000003c:	00000097          	auipc	ra,0x0
    80000040:	718080e7          	jalr	1816(ra) # 80000754 <uart_write>
}
    80000044:	00813083          	ld	ra,8(sp)
    80000048:	00013403          	ld	s0,0(sp)
    8000004c:	01010113          	add	sp,sp,16
    80000050:	00008067          	ret

0000000080000054 <main_handle_input>:
// use this strategy creating a bottom-half and top-half of the
// driver. The bottom half is small and fast to handle interrupts,
// while the top half is larger and more complex. Later when we
// implement threads and multiprocessing this separation will make
// our lives much easier.
void main_handle_input(char c) {
    80000054:	fe010113          	add	sp,sp,-32
    80000058:	00113c23          	sd	ra,24(sp)
    8000005c:	00813823          	sd	s0,16(sp)
    80000060:	00913423          	sd	s1,8(sp)
    80000064:	02010413          	add	s0,sp,32
  if (c == MAIN_ASCII_NEW_LINE || c == MAIN_ASCII_CARRIAGE_RETURN) {
    80000068:	00a00793          	li	a5,10
    8000006c:	04f50663          	beq	a0,a5,800000b8 <main_handle_input+0x64>
    80000070:	00d00793          	li	a5,13
    80000074:	04f50263          	beq	a0,a5,800000b8 <main_handle_input+0x64>
      // Make a newline after the output
      print_buf("\n");
    }
    print_prompt();
    idx = 0;
  } else if (c == MAIN_ASCII_DELETE) {
    80000078:	07f00793          	li	a5,127
    8000007c:	1cf50263          	beq	a0,a5,80000240 <main_handle_input+0x1ec>
      idx--;
    }
  } else {
    // Make sure to always leave a null terminator, otherwise
    // *bad things* will happen. Don't save \n or \r
    if (idx < MAIN_MAX_CMD_LEN - 1) {
    80000080:	00001797          	auipc	a5,0x1
    80000084:	0c07c783          	lbu	a5,192(a5) # 80001140 <idx>
    80000088:	01e00713          	li	a4,30
    8000008c:	02f76063          	bltu	a4,a5,800000ac <main_handle_input+0x58>
      cmd_buf[idx] = c;
    80000090:	00001717          	auipc	a4,0x1
    80000094:	ea070713          	add	a4,a4,-352 # 80000f30 <cmd_buf>
    80000098:	00f70733          	add	a4,a4,a5
    8000009c:	00a70023          	sb	a0,0(a4)
      idx++;
    800000a0:	0017879b          	addw	a5,a5,1
    800000a4:	00001717          	auipc	a4,0x1
    800000a8:	08f70e23          	sb	a5,156(a4) # 80001140 <idx>
    }
    // Echo the character back to the console
    uart_write(c);
    800000ac:	00000097          	auipc	ra,0x0
    800000b0:	6a8080e7          	jalr	1704(ra) # 80000754 <uart_write>
  }
}
    800000b4:	0540006f          	j	80000108 <main_handle_input+0xb4>
    cmd_buf[idx] = 0;
    800000b8:	00001497          	auipc	s1,0x1
    800000bc:	08848493          	add	s1,s1,136 # 80001140 <idx>
    800000c0:	0004c783          	lbu	a5,0(s1)
    800000c4:	00001717          	auipc	a4,0x1
    800000c8:	e6c70713          	add	a4,a4,-404 # 80000f30 <cmd_buf>
    800000cc:	00f70733          	add	a4,a4,a5
    800000d0:	00070023          	sb	zero,0(a4)
    idx++;
    800000d4:	0017879b          	addw	a5,a5,1
    800000d8:	00f48023          	sb	a5,0(s1)
    print_buf("\n");
    800000dc:	00001517          	auipc	a0,0x1
    800000e0:	cdc50513          	add	a0,a0,-804 # 80000db8 <sfence_vma+0x90>
    800000e4:	00000097          	auipc	ra,0x0
    800000e8:	228080e7          	jalr	552(ra) # 8000030c <print_buf>
    if (idx > 1) {
    800000ec:	0004c703          	lbu	a4,0(s1)
    800000f0:	00100793          	li	a5,1
    800000f4:	02e7e463          	bltu	a5,a4,8000011c <main_handle_input+0xc8>
    print_prompt();
    800000f8:	00000097          	auipc	ra,0x0
    800000fc:	f24080e7          	jalr	-220(ra) # 8000001c <print_prompt>
    idx = 0;
    80000100:	00001797          	auipc	a5,0x1
    80000104:	04078023          	sb	zero,64(a5) # 80001140 <idx>
}
    80000108:	01813083          	ld	ra,24(sp)
    8000010c:	01013403          	ld	s0,16(sp)
    80000110:	00813483          	ld	s1,8(sp)
    80000114:	02010113          	add	sp,sp,32
    80000118:	00008067          	ret
      if (strcmp(cmd_buf, "hello") == 0) {
    8000011c:	00001597          	auipc	a1,0x1
    80000120:	c2c58593          	add	a1,a1,-980 # 80000d48 <sfence_vma+0x20>
    80000124:	00001517          	auipc	a0,0x1
    80000128:	e0c50513          	add	a0,a0,-500 # 80000f30 <cmd_buf>
    8000012c:	00000097          	auipc	ra,0x0
    80000130:	23c080e7          	jalr	572(ra) # 80000368 <strcmp>
    80000134:	02051463          	bnez	a0,8000015c <main_handle_input+0x108>
        print_buf("world");
    80000138:	00001517          	auipc	a0,0x1
    8000013c:	c1850513          	add	a0,a0,-1000 # 80000d50 <sfence_vma+0x28>
    80000140:	00000097          	auipc	ra,0x0
    80000144:	1cc080e7          	jalr	460(ra) # 8000030c <print_buf>
      print_buf("\n");
    80000148:	00001517          	auipc	a0,0x1
    8000014c:	c7050513          	add	a0,a0,-912 # 80000db8 <sfence_vma+0x90>
    80000150:	00000097          	auipc	ra,0x0
    80000154:	1bc080e7          	jalr	444(ra) # 8000030c <print_buf>
    80000158:	fa1ff06f          	j	800000f8 <main_handle_input+0xa4>
      } else if (strcmp(cmd_buf, "charlie") == 0) {
    8000015c:	00001597          	auipc	a1,0x1
    80000160:	bfc58593          	add	a1,a1,-1028 # 80000d58 <sfence_vma+0x30>
    80000164:	00001517          	auipc	a0,0x1
    80000168:	dcc50513          	add	a0,a0,-564 # 80000f30 <cmd_buf>
    8000016c:	00000097          	auipc	ra,0x0
    80000170:	1fc080e7          	jalr	508(ra) # 80000368 <strcmp>
    80000174:	00051c63          	bnez	a0,8000018c <main_handle_input+0x138>
        print_buf("weinstock");
    80000178:	00001517          	auipc	a0,0x1
    8000017c:	be850513          	add	a0,a0,-1048 # 80000d60 <sfence_vma+0x38>
    80000180:	00000097          	auipc	ra,0x0
    80000184:	18c080e7          	jalr	396(ra) # 8000030c <print_buf>
    80000188:	fc1ff06f          	j	80000148 <main_handle_input+0xf4>
      } else if (strcmp(cmd_buf, "elizabeth") == 0) {
    8000018c:	00001597          	auipc	a1,0x1
    80000190:	be458593          	add	a1,a1,-1052 # 80000d70 <sfence_vma+0x48>
    80000194:	00001517          	auipc	a0,0x1
    80000198:	d9c50513          	add	a0,a0,-612 # 80000f30 <cmd_buf>
    8000019c:	00000097          	auipc	ra,0x0
    800001a0:	1cc080e7          	jalr	460(ra) # 80000368 <strcmp>
    800001a4:	06051c63          	bnez	a0,8000021c <main_handle_input+0x1c8>
        print_buf("\n");
    800001a8:	00001517          	auipc	a0,0x1
    800001ac:	c1050513          	add	a0,a0,-1008 # 80000db8 <sfence_vma+0x90>
    800001b0:	00000097          	auipc	ra,0x0
    800001b4:	15c080e7          	jalr	348(ra) # 8000030c <print_buf>
        print_buf("  _________.__                 .__    .___              \n");
    800001b8:	00001517          	auipc	a0,0x1
    800001bc:	bc850513          	add	a0,a0,-1080 # 80000d80 <sfence_vma+0x58>
    800001c0:	00000097          	auipc	ra,0x0
    800001c4:	14c080e7          	jalr	332(ra) # 8000030c <print_buf>
        print_buf(" /   _____/|  |__   ___________|__| __| _/____    ____  \n");
    800001c8:	00001517          	auipc	a0,0x1
    800001cc:	bf850513          	add	a0,a0,-1032 # 80000dc0 <sfence_vma+0x98>
    800001d0:	00000097          	auipc	ra,0x0
    800001d4:	13c080e7          	jalr	316(ra) # 8000030c <print_buf>
        print_buf(
    800001d8:	00001517          	auipc	a0,0x1
    800001dc:	c2850513          	add	a0,a0,-984 # 80000e00 <sfence_vma+0xd8>
    800001e0:	00000097          	auipc	ra,0x0
    800001e4:	12c080e7          	jalr	300(ra) # 8000030c <print_buf>
        print_buf(
    800001e8:	00001517          	auipc	a0,0x1
    800001ec:	c5850513          	add	a0,a0,-936 # 80000e40 <sfence_vma+0x118>
    800001f0:	00000097          	auipc	ra,0x0
    800001f4:	11c080e7          	jalr	284(ra) # 8000030c <print_buf>
        print_buf(
    800001f8:	00001517          	auipc	a0,0x1
    800001fc:	c8850513          	add	a0,a0,-888 # 80000e80 <sfence_vma+0x158>
    80000200:	00000097          	auipc	ra,0x0
    80000204:	10c080e7          	jalr	268(ra) # 8000030c <print_buf>
        print_buf(
    80000208:	00001517          	auipc	a0,0x1
    8000020c:	cb850513          	add	a0,a0,-840 # 80000ec0 <sfence_vma+0x198>
    80000210:	00000097          	auipc	ra,0x0
    80000214:	0fc080e7          	jalr	252(ra) # 8000030c <print_buf>
    80000218:	f31ff06f          	j	80000148 <main_handle_input+0xf4>
        print_buf("command not recognized: ");
    8000021c:	00001517          	auipc	a0,0x1
    80000220:	ce450513          	add	a0,a0,-796 # 80000f00 <sfence_vma+0x1d8>
    80000224:	00000097          	auipc	ra,0x0
    80000228:	0e8080e7          	jalr	232(ra) # 8000030c <print_buf>
        print_buf(cmd_buf);
    8000022c:	00001517          	auipc	a0,0x1
    80000230:	d0450513          	add	a0,a0,-764 # 80000f30 <cmd_buf>
    80000234:	00000097          	auipc	ra,0x0
    80000238:	0d8080e7          	jalr	216(ra) # 8000030c <print_buf>
    8000023c:	f0dff06f          	j	80000148 <main_handle_input+0xf4>
    if (idx > 0) {
    80000240:	00001797          	auipc	a5,0x1
    80000244:	f007c783          	lbu	a5,-256(a5) # 80001140 <idx>
    80000248:	ec0780e3          	beqz	a5,80000108 <main_handle_input+0xb4>
      print_buf("\b \b");
    8000024c:	00001517          	auipc	a0,0x1
    80000250:	cd450513          	add	a0,a0,-812 # 80000f20 <sfence_vma+0x1f8>
    80000254:	00000097          	auipc	ra,0x0
    80000258:	0b8080e7          	jalr	184(ra) # 8000030c <print_buf>
      idx--;
    8000025c:	00001717          	auipc	a4,0x1
    80000260:	ee470713          	add	a4,a4,-284 # 80001140 <idx>
    80000264:	00074783          	lbu	a5,0(a4)
    80000268:	fff7879b          	addw	a5,a5,-1
    8000026c:	00f70023          	sb	a5,0(a4)
    80000270:	e99ff06f          	j	80000108 <main_handle_input+0xb4>

0000000080000274 <main>:
// a bit of power. What we really want to do is to tell the CPU to do
// nothing until an interrupt arrives. Conveniently riscv has a
// "Wait For Interrupt (wfi)" command that does just that. So our new
// loop will just continuously sleep the CPU while waiting for a
// keyboard interrupt.
void main() {
    80000274:	ff010113          	add	sp,sp,-16
    80000278:	00113423          	sd	ra,8(sp)
    8000027c:	00813023          	sd	s0,0(sp)
    80000280:	01010413          	add	s0,sp,16
  // main_handle_input is only called when a key is typed, so we
  // need to print it here the first time before the user has typed
  // anything.
  print_prompt();
    80000284:	00000097          	auipc	ra,0x0
    80000288:	d98080e7          	jalr	-616(ra) # 8000001c <print_prompt>
  while (1) {
    asm("wfi");
    8000028c:	10500073          	wfi
  while (1) {
    80000290:	ffdff06f          	j	8000028c <main+0x18>

0000000080000294 <main2>:
  }
}

static int count = 0;
void main2() {
    80000294:	ff010113          	add	sp,sp,-16
    80000298:	00813423          	sd	s0,8(sp)
    8000029c:	01010413          	add	s0,sp,16
  while (1) {
    count = 0;
    while (count++ < 10000000)
    800002a0:	00000693          	li	a3,0
    800002a4:	00989737          	lui	a4,0x989
    800002a8:	68170713          	add	a4,a4,1665 # 989681 <_entry-0x7f67697f>
    800002ac:	00068793          	mv	a5,a3
    800002b0:	0017879b          	addw	a5,a5,1
    800002b4:	fee79ee3          	bne	a5,a4,800002b0 <main2+0x1c>
    800002b8:	ff5ff06f          	j	800002ac <main2+0x18>

00000000800002bc <start>:
#include "plic.h"
#include "timer.h"
#include "trap.h"
#include "uart.h"

void start() {
    800002bc:	ff010113          	add	sp,sp,-16
    800002c0:	00113423          	sd	ra,8(sp)
    800002c4:	00813023          	sd	s0,0(sp)
    800002c8:	01010413          	add	s0,sp,16
  uart_init();
    800002cc:	00000097          	auipc	ra,0x0
    800002d0:	3b4080e7          	jalr	948(ra) # 80000680 <uart_init>
  plicinit();
    800002d4:	00000097          	auipc	ra,0x0
    800002d8:	0d0080e7          	jalr	208(ra) # 800003a4 <plicinit>
  plicinithart();
    800002dc:	00000097          	auipc	ra,0x0
    800002e0:	0ec080e7          	jalr	236(ra) # 800003c8 <plicinithart>
  trapinithart();
    800002e4:	00000097          	auipc	ra,0x0
    800002e8:	150080e7          	jalr	336(ra) # 80000434 <trapinithart>
  timerinit();
    800002ec:	00000097          	auipc	ra,0x0
    800002f0:	52c080e7          	jalr	1324(ra) # 80000818 <timerinit>
  main();
    800002f4:	00000097          	auipc	ra,0x0
    800002f8:	f80080e7          	jalr	-128(ra) # 80000274 <main>
    800002fc:	00813083          	ld	ra,8(sp)
    80000300:	00013403          	ld	s0,0(sp)
    80000304:	01010113          	add	sp,sp,16
    80000308:	00008067          	ret

000000008000030c <print_buf>:
#include "uart.h"


void print_buf(char *buf) {
    8000030c:	fe010113          	add	sp,sp,-32
    80000310:	00113c23          	sd	ra,24(sp)
    80000314:	00813823          	sd	s0,16(sp)
    80000318:	00913423          	sd	s1,8(sp)
    8000031c:	01213023          	sd	s2,0(sp)
    80000320:	02010413          	add	s0,sp,32
    80000324:	00050913          	mv	s2,a0
    unsigned char print_idx = 0;
    while (buf[print_idx] != 0) {
    80000328:	00054503          	lbu	a0,0(a0)
    8000032c:	02050263          	beqz	a0,80000350 <print_buf+0x44>
    unsigned char print_idx = 0;
    80000330:	00000493          	li	s1,0
        uart_write(buf[print_idx]);
    80000334:	00000097          	auipc	ra,0x0
    80000338:	420080e7          	jalr	1056(ra) # 80000754 <uart_write>
        print_idx++;
    8000033c:	0014849b          	addw	s1,s1,1
    80000340:	0ff4f493          	zext.b	s1,s1
    while (buf[print_idx] != 0) {
    80000344:	009907b3          	add	a5,s2,s1
    80000348:	0007c503          	lbu	a0,0(a5)
    8000034c:	fe0514e3          	bnez	a0,80000334 <print_buf+0x28>
    }
}
    80000350:	01813083          	ld	ra,24(sp)
    80000354:	01013403          	ld	s0,16(sp)
    80000358:	00813483          	ld	s1,8(sp)
    8000035c:	00013903          	ld	s2,0(sp)
    80000360:	02010113          	add	sp,sp,32
    80000364:	00008067          	ret

0000000080000368 <strcmp>:

int strcmp(char *str1, char *str2) {
    80000368:	ff010113          	add	sp,sp,-16
    8000036c:	00813423          	sd	s0,8(sp)
    80000370:	01010413          	add	s0,sp,16
    const unsigned char *s1 = (const unsigned char *) str1;
    const unsigned char *s2 = (const unsigned char *) str2;
    unsigned char c1, c2;
    do {
        c1 = (unsigned char) *s1++;
    80000374:	00150513          	add	a0,a0,1
    80000378:	fff54783          	lbu	a5,-1(a0)
        c2 = (unsigned char) *s2++;
    8000037c:	00158593          	add	a1,a1,1
    80000380:	fff5c703          	lbu	a4,-1(a1)
        if (c1 == '\0') { return c1 - c2; }
    80000384:	00078863          	beqz	a5,80000394 <strcmp+0x2c>
    } while (c1 == c2);
    80000388:	fee786e3          	beq	a5,a4,80000374 <strcmp+0xc>
    
    return c1 - c2;
    8000038c:	40e7853b          	subw	a0,a5,a4
    80000390:	0080006f          	j	80000398 <strcmp+0x30>
        if (c1 == '\0') { return c1 - c2; }
    80000394:	40e0053b          	negw	a0,a4
    80000398:	00813403          	ld	s0,8(sp)
    8000039c:	01010113          	add	sp,sp,16
    800003a0:	00008067          	ret

00000000800003a4 <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800003a4:	ff010113          	add	sp,sp,-16
    800003a8:	00813423          	sd	s0,8(sp)
    800003ac:	01010413          	add	s0,sp,16
  // set desired IRQ priorities non-zero (zero = disabled).
  // UARTx_IRQ are the interrupt source numbers, each source gets 4 bytes
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800003b0:	0c0007b7          	lui	a5,0xc000
    800003b4:	00100713          	li	a4,1
    800003b8:	02e7a423          	sw	a4,40(a5) # c000028 <_entry-0x73ffffd8>
}
    800003bc:	00813403          	ld	s0,8(sp)
    800003c0:	01010113          	add	sp,sp,16
    800003c4:	00008067          	ret

00000000800003c8 <plicinithart>:

void
plicinithart(void)
{
    800003c8:	ff010113          	add	sp,sp,-16
    800003cc:	00813423          	sd	s0,8(sp)
    800003d0:	01010413          	add	s0,sp,16
  // and one hart must always have id 0
  int hart = 0;
  
  // set enable bits for this hart's M-mode
  // for the uart.
  *(uint32*)PLIC_MENABLE(hart) = (1 << UART0_IRQ);
    800003d4:	0c0027b7          	lui	a5,0xc002
    800003d8:	40000713          	li	a4,1024
    800003dc:	00e7a023          	sw	a4,0(a5) # c002000 <_entry-0x73ffe000>

  // set this hart's M-mode priority threshold to 0.
  *(uint32*)PLIC_MPRIORITY(hart) = 0;
    800003e0:	0c2007b7          	lui	a5,0xc200
    800003e4:	0007a023          	sw	zero,0(a5) # c200000 <_entry-0x73e00000>
}
    800003e8:	00813403          	ld	s0,8(sp)
    800003ec:	01010113          	add	sp,sp,16
    800003f0:	00008067          	ret

00000000800003f4 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800003f4:	ff010113          	add	sp,sp,-16
    800003f8:	00813423          	sd	s0,8(sp)
    800003fc:	01010413          	add	s0,sp,16
  int hart = 0;
  int irq = *(uint32*)PLIC_MCLAIM(hart);
  return irq;
}
    80000400:	0c2007b7          	lui	a5,0xc200
    80000404:	0047a503          	lw	a0,4(a5) # c200004 <_entry-0x73dffffc>
    80000408:	00813403          	ld	s0,8(sp)
    8000040c:	01010113          	add	sp,sp,16
    80000410:	00008067          	ret

0000000080000414 <plic_complete>:

// tell the PLIC we've served this IRQ. 
void
plic_complete(int irq)
{
    80000414:	ff010113          	add	sp,sp,-16
    80000418:	00813423          	sd	s0,8(sp)
    8000041c:	01010413          	add	s0,sp,16
  int hart = 0;
  *(uint32*)PLIC_MCLAIM(hart) = irq;
    80000420:	0c2007b7          	lui	a5,0xc200
    80000424:	00a7a223          	sw	a0,4(a5) # c200004 <_entry-0x73dffffc>
}
    80000428:	00813403          	ld	s0,8(sp)
    8000042c:	01010113          	add	sp,sp,16
    80000430:	00008067          	ret

0000000080000434 <trapinithart>:
#include "types.h"
#include "uart.h"
#include "util.h"

// set up to take exceptions and traps while in the kernel.
void trapinithart(void) {
    80000434:	ff010113          	add	sp,sp,-16
    80000438:	00113423          	sd	ra,8(sp)
    8000043c:	00813023          	sd	s0,0(sp)
    80000440:	01010413          	add	s0,sp,16
  w_mtvec((uint64)machinevec);
    80000444:	00000517          	auipc	a0,0x0
    80000448:	12c50513          	add	a0,a0,300 # 80000570 <machinevec>
    8000044c:	00000097          	auipc	ra,0x0
    80000450:	6b0080e7          	jalr	1712(ra) # 80000afc <w_mtvec>
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80000454:	00000097          	auipc	ra,0x0
    80000458:	494080e7          	jalr	1172(ra) # 800008e8 <r_mstatus>
    8000045c:	00856513          	or	a0,a0,8
    80000460:	00000097          	auipc	ra,0x0
    80000464:	4a4080e7          	jalr	1188(ra) # 80000904 <w_mstatus>
  w_mie(r_mie() | MIE_MEIE);
    80000468:	00000097          	auipc	ra,0x0
    8000046c:	57c080e7          	jalr	1404(ra) # 800009e4 <r_mie>
    80000470:	000017b7          	lui	a5,0x1
    80000474:	80078793          	add	a5,a5,-2048 # 800 <_entry-0x7ffff800>
    80000478:	00f56533          	or	a0,a0,a5
    8000047c:	00000097          	auipc	ra,0x0
    80000480:	584080e7          	jalr	1412(ra) # 80000a00 <w_mie>
}
    80000484:	00813083          	ld	ra,8(sp)
    80000488:	00013403          	ld	s0,0(sp)
    8000048c:	01010113          	add	sp,sp,16
    80000490:	00008067          	ret

0000000080000494 <devintr>:
// check if it's an external interrupt or software interrupt,
// and handle it.
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int devintr() {
    80000494:	fe010113          	add	sp,sp,-32
    80000498:	00113c23          	sd	ra,24(sp)
    8000049c:	00813823          	sd	s0,16(sp)
    800004a0:	00913423          	sd	s1,8(sp)
    800004a4:	02010413          	add	s0,sp,32
  uint64 mcause = r_mcause();
    800004a8:	00000097          	auipc	ra,0x0
    800004ac:	718080e7          	jalr	1816(ra) # 80000bc0 <r_mcause>
    800004b0:	00050793          	mv	a5,a0
      int interval = 1000000; // cycles; about 1/10th second in qemu.
      *(uint64 *)CLINT_MTIMECMP(id) = *(uint64 *)CLINT_MTIME + interval;
      schedule();
    }
  }
  return 0;
    800004b4:	00000513          	li	a0,0
  if ((mcause >> 63) & 1) {
    800004b8:	0007cc63          	bltz	a5,800004d0 <devintr+0x3c>
    800004bc:	01813083          	ld	ra,24(sp)
    800004c0:	01013403          	ld	s0,16(sp)
    800004c4:	00813483          	ld	s1,8(sp)
    800004c8:	02010113          	add	sp,sp,32
    800004cc:	00008067          	ret
    if ((mcause & 0xff) == 11) {
    800004d0:	0ff7f713          	zext.b	a4,a5
    800004d4:	00b00693          	li	a3,11
    800004d8:	04d70863          	beq	a4,a3,80000528 <devintr+0x94>
    } else if ((mcause & 0xf) == 7) {
    800004dc:	00f7f793          	and	a5,a5,15
    800004e0:	00700713          	li	a4,7
  return 0;
    800004e4:	00000513          	li	a0,0
    } else if ((mcause & 0xf) == 7) {
    800004e8:	fce79ae3          	bne	a5,a4,800004bc <devintr+0x28>
      int id = r_mhartid();
    800004ec:	00000097          	auipc	ra,0x0
    800004f0:	3e0080e7          	jalr	992(ra) # 800008cc <r_mhartid>
      *(uint64 *)CLINT_MTIMECMP(id) = *(uint64 *)CLINT_MTIME + interval;
    800004f4:	0035151b          	sllw	a0,a0,0x3
    800004f8:	020047b7          	lui	a5,0x2004
    800004fc:	00a787b3          	add	a5,a5,a0
    80000500:	0200c737          	lui	a4,0x200c
    80000504:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80000508:	000f46b7          	lui	a3,0xf4
    8000050c:	24068693          	add	a3,a3,576 # f4240 <_entry-0x7ff0bdc0>
    80000510:	00d70733          	add	a4,a4,a3
    80000514:	00e7b023          	sd	a4,0(a5) # 2004000 <_entry-0x7dffc000>
      schedule();
    80000518:	00000097          	auipc	ra,0x0
    8000051c:	384080e7          	jalr	900(ra) # 8000089c <schedule>
  return 0;
    80000520:	00000513          	li	a0,0
    80000524:	f99ff06f          	j	800004bc <devintr+0x28>
      int irq = plic_claim();
    80000528:	00000097          	auipc	ra,0x0
    8000052c:	ecc080e7          	jalr	-308(ra) # 800003f4 <plic_claim>
    80000530:	00050493          	mv	s1,a0
      if (irq == UART0_IRQ) {
    80000534:	00a00793          	li	a5,10
    80000538:	02f50063          	beq	a0,a5,80000558 <devintr+0xc4>
      return 1;
    8000053c:	00100513          	li	a0,1
      if (irq) {
    80000540:	f6048ee3          	beqz	s1,800004bc <devintr+0x28>
        plic_complete(irq);
    80000544:	00048513          	mv	a0,s1
    80000548:	00000097          	auipc	ra,0x0
    8000054c:	ecc080e7          	jalr	-308(ra) # 80000414 <plic_complete>
      return 1;
    80000550:	00100513          	li	a0,1
    80000554:	f69ff06f          	j	800004bc <devintr+0x28>
        uart_handle_interrupt();
    80000558:	00000097          	auipc	ra,0x0
    8000055c:	268080e7          	jalr	616(ra) # 800007c0 <uart_handle_interrupt>
      if (irq) {
    80000560:	fe5ff06f          	j	80000544 <devintr+0xb0>
	...

0000000080000570 <machinevec>:
#
.global machinevec
.align 4
machinevec:
        # make room to save registers.
        addi sp, sp, -256
    80000570:	f0010113          	add	sp,sp,-256

        # save the registers.
        sd ra, 0(sp)
    80000574:	00113023          	sd	ra,0(sp)
        sd sp, 8(sp)
    80000578:	00213423          	sd	sp,8(sp)
        sd gp, 16(sp)
    8000057c:	00313823          	sd	gp,16(sp)
        sd tp, 24(sp)
    80000580:	00413c23          	sd	tp,24(sp)
        sd t0, 32(sp)
    80000584:	02513023          	sd	t0,32(sp)
        sd t1, 40(sp)
    80000588:	02613423          	sd	t1,40(sp)
        sd t2, 48(sp)
    8000058c:	02713823          	sd	t2,48(sp)
        sd s0, 56(sp)
    80000590:	02813c23          	sd	s0,56(sp)
        sd s1, 64(sp)
    80000594:	04913023          	sd	s1,64(sp)
        sd a0, 72(sp)
    80000598:	04a13423          	sd	a0,72(sp)
        sd a1, 80(sp)
    8000059c:	04b13823          	sd	a1,80(sp)
        sd a2, 88(sp)
    800005a0:	04c13c23          	sd	a2,88(sp)
        sd a3, 96(sp)
    800005a4:	06d13023          	sd	a3,96(sp)
        sd a4, 104(sp)
    800005a8:	06e13423          	sd	a4,104(sp)
        sd a5, 112(sp)
    800005ac:	06f13823          	sd	a5,112(sp)
        sd a6, 120(sp)
    800005b0:	07013c23          	sd	a6,120(sp)
        sd a7, 128(sp)
    800005b4:	09113023          	sd	a7,128(sp)
        sd s2, 136(sp)
    800005b8:	09213423          	sd	s2,136(sp)
        sd s3, 144(sp)
    800005bc:	09313823          	sd	s3,144(sp)
        sd s4, 152(sp)
    800005c0:	09413c23          	sd	s4,152(sp)
        sd s5, 160(sp)
    800005c4:	0b513023          	sd	s5,160(sp)
        sd s6, 168(sp)
    800005c8:	0b613423          	sd	s6,168(sp)
        sd s7, 176(sp)
    800005cc:	0b713823          	sd	s7,176(sp)
        sd s8, 184(sp)
    800005d0:	0b813c23          	sd	s8,184(sp)
        sd s9, 192(sp)
    800005d4:	0d913023          	sd	s9,192(sp)
        sd s10, 200(sp)
    800005d8:	0da13423          	sd	s10,200(sp)
        sd s11, 208(sp)
    800005dc:	0db13823          	sd	s11,208(sp)
        sd t3, 216(sp)
    800005e0:	0dc13c23          	sd	t3,216(sp)
        sd t4, 224(sp)
    800005e4:	0fd13023          	sd	t4,224(sp)
        sd t5, 232(sp)
    800005e8:	0fe13423          	sd	t5,232(sp)
        sd t6, 240(sp)
    800005ec:	0ff13823          	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call devintr
    800005f0:	00000097          	auipc	ra,0x0
    800005f4:	ea4080e7          	jalr	-348(ra) # 80000494 <devintr>

        # restore registers.
        ld ra, 0(sp)
    800005f8:	00013083          	ld	ra,0(sp)
        ld sp, 8(sp)
    800005fc:	00813103          	ld	sp,8(sp)
        ld gp, 16(sp)
    80000600:	01013183          	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    80000604:	02013283          	ld	t0,32(sp)
        ld t1, 40(sp)
    80000608:	02813303          	ld	t1,40(sp)
        ld t2, 48(sp)
    8000060c:	03013383          	ld	t2,48(sp)
        ld s0, 56(sp)
    80000610:	03813403          	ld	s0,56(sp)
        ld s1, 64(sp)
    80000614:	04013483          	ld	s1,64(sp)
        ld a0, 72(sp)
    80000618:	04813503          	ld	a0,72(sp)
        ld a1, 80(sp)
    8000061c:	05013583          	ld	a1,80(sp)
        ld a2, 88(sp)
    80000620:	05813603          	ld	a2,88(sp)
        ld a3, 96(sp)
    80000624:	06013683          	ld	a3,96(sp)
        ld a4, 104(sp)
    80000628:	06813703          	ld	a4,104(sp)
        ld a5, 112(sp)
    8000062c:	07013783          	ld	a5,112(sp)
        ld a6, 120(sp)
    80000630:	07813803          	ld	a6,120(sp)
        ld a7, 128(sp)
    80000634:	08013883          	ld	a7,128(sp)
        ld s2, 136(sp)
    80000638:	08813903          	ld	s2,136(sp)
        ld s3, 144(sp)
    8000063c:	09013983          	ld	s3,144(sp)
        ld s4, 152(sp)
    80000640:	09813a03          	ld	s4,152(sp)
        ld s5, 160(sp)
    80000644:	0a013a83          	ld	s5,160(sp)
        ld s6, 168(sp)
    80000648:	0a813b03          	ld	s6,168(sp)
        ld s7, 176(sp)
    8000064c:	0b013b83          	ld	s7,176(sp)
        ld s8, 184(sp)
    80000650:	0b813c03          	ld	s8,184(sp)
        ld s9, 192(sp)
    80000654:	0c013c83          	ld	s9,192(sp)
        ld s10, 200(sp)
    80000658:	0c813d03          	ld	s10,200(sp)
        ld s11, 208(sp)
    8000065c:	0d013d83          	ld	s11,208(sp)
        ld t3, 216(sp)
    80000660:	0d813e03          	ld	t3,216(sp)
        ld t4, 224(sp)
    80000664:	0e013e83          	ld	t4,224(sp)
        ld t5, 232(sp)
    80000668:	0e813f03          	ld	t5,232(sp)
        ld t6, 240(sp)
    8000066c:	0f013f83          	ld	t6,240(sp)

        addi sp, sp, 256
    80000670:	10010113          	add	sp,sp,256

        # return to whatever we were doing
        mret
    80000674:	30200073          	mret
    80000678:	00000013          	nop
    8000067c:	00000013          	nop

0000000080000680 <uart_init>:
#include "uart.h"
#include "main.h"

void uart_init() {
    80000680:	ff010113          	add	sp,sp,-16
    80000684:	00813423          	sd	s0,8(sp)
    80000688:	01010413          	add	s0,sp,16
    // disable interrupts.
    uart_write_reg(UART_IER, UART_IER_GLOBAL_DISABLE);
    8000068c:	100007b7          	lui	a5,0x10000
    80000690:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>
    // special mode to set baud rate.
    uart_write_reg(UART_LCR, UART_LCR_BAUD_LATCH);
    80000694:	f8000713          	li	a4,-128
    80000698:	00e781a3          	sb	a4,3(a5)
    // LSB for baud rate of 38.4K.
    uart_write_reg(UART_BAUD_RATE_LSB_REG, UART_BAUD_RATE_LSB);
    8000069c:	00300713          	li	a4,3
    800006a0:	00e78023          	sb	a4,0(a5)
    // MSB for baud rate of 38.4K.
    uart_write_reg(UART_BAUD_RATE_MSB_REG, UART_BAUD_RATE_MSB);
    800006a4:	000780a3          	sb	zero,1(a5)
    // leave set-baud mode,
    // and set word length to 8 bits, no parity.
    uart_write_reg(UART_LCR, UART_LCR_EIGHT_BITS);
    800006a8:	00e781a3          	sb	a4,3(a5)
    // reset and enable FIFOs.
    uart_write_reg(UART_FCR, UART_FCR_FIFO_ENABLE | UART_FCR_FIFO_CLEAR);
    800006ac:	00700693          	li	a3,7
    800006b0:	00d78123          	sb	a3,2(a5)
    // enable transmit and receive interrupts.
    uart_write_reg(UART_IER, UART_IER_TX_ENABLE | UART_IER_RX_ENABLE);
    800006b4:	00e780a3          	sb	a4,1(a5)
}
    800006b8:	00813403          	ld	s0,8(sp)
    800006bc:	01010113          	add	sp,sp,16
    800006c0:	00008067          	ret

00000000800006c4 <_wait_for_uart_write>:
	
void _wait_for_uart_write() {
    800006c4:	ff010113          	add	sp,sp,-16
    800006c8:	00813423          	sd	s0,8(sp)
    800006cc:	01010413          	add	s0,sp,16
    while (!(uart_read_reg(UART_LSR) & UART_LSR_TX_IDLE));
    800006d0:	10000737          	lui	a4,0x10000
    800006d4:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    800006d8:	0207f793          	and	a5,a5,32
    800006dc:	fe078ce3          	beqz	a5,800006d4 <_wait_for_uart_write+0x10>
}
    800006e0:	00813403          	ld	s0,8(sp)
    800006e4:	01010113          	add	sp,sp,16
    800006e8:	00008067          	ret

00000000800006ec <_wait_for_uart_read>:

void _wait_for_uart_read() {
    800006ec:	ff010113          	add	sp,sp,-16
    800006f0:	00813423          	sd	s0,8(sp)
    800006f4:	01010413          	add	s0,sp,16
    while (!(uart_read_reg(UART_LSR) & UART_LSR_RX_READY));
    800006f8:	10000737          	lui	a4,0x10000
    800006fc:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80000700:	0017f793          	and	a5,a5,1
    80000704:	fe078ce3          	beqz	a5,800006fc <_wait_for_uart_read+0x10>
}
    80000708:	00813403          	ld	s0,8(sp)
    8000070c:	01010113          	add	sp,sp,16
    80000710:	00008067          	ret

0000000080000714 <_uart_put_c>:

void _uart_put_c(char c) {
    80000714:	ff010113          	add	sp,sp,-16
    80000718:	00813423          	sd	s0,8(sp)
    8000071c:	01010413          	add	s0,sp,16
    uart_write_reg(UART_THR, c);
    80000720:	100007b7          	lui	a5,0x10000
    80000724:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>
}
    80000728:	00813403          	ld	s0,8(sp)
    8000072c:	01010113          	add	sp,sp,16
    80000730:	00008067          	ret

0000000080000734 <_uart_get_c>:

char _uart_get_c() {
    80000734:	ff010113          	add	sp,sp,-16
    80000738:	00813423          	sd	s0,8(sp)
    8000073c:	01010413          	add	s0,sp,16
    return uart_read_reg(UART_RHR);
    80000740:	100007b7          	lui	a5,0x10000
    80000744:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
}
    80000748:	00813403          	ld	s0,8(sp)
    8000074c:	01010113          	add	sp,sp,16
    80000750:	00008067          	ret

0000000080000754 <uart_write>:

void uart_write(char c) {
    80000754:	fe010113          	add	sp,sp,-32
    80000758:	00113c23          	sd	ra,24(sp)
    8000075c:	00813823          	sd	s0,16(sp)
    80000760:	00913423          	sd	s1,8(sp)
    80000764:	02010413          	add	s0,sp,32
    80000768:	00050493          	mv	s1,a0
    _wait_for_uart_write();
    8000076c:	00000097          	auipc	ra,0x0
    80000770:	f58080e7          	jalr	-168(ra) # 800006c4 <_wait_for_uart_write>
    uart_write_reg(UART_THR, c);
    80000774:	100007b7          	lui	a5,0x10000
    80000778:	00978023          	sb	s1,0(a5) # 10000000 <_entry-0x70000000>
    _uart_put_c(c);
}
    8000077c:	01813083          	ld	ra,24(sp)
    80000780:	01013403          	ld	s0,16(sp)
    80000784:	00813483          	ld	s1,8(sp)
    80000788:	02010113          	add	sp,sp,32
    8000078c:	00008067          	ret

0000000080000790 <uart_read>:

char uart_read() {
    80000790:	ff010113          	add	sp,sp,-16
    80000794:	00113423          	sd	ra,8(sp)
    80000798:	00813023          	sd	s0,0(sp)
    8000079c:	01010413          	add	s0,sp,16
    _wait_for_uart_read();
    800007a0:	00000097          	auipc	ra,0x0
    800007a4:	f4c080e7          	jalr	-180(ra) # 800006ec <_wait_for_uart_read>
    return uart_read_reg(UART_RHR);
    800007a8:	100007b7          	lui	a5,0x10000
    800007ac:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    return _uart_get_c();
}
    800007b0:	00813083          	ld	ra,8(sp)
    800007b4:	00013403          	ld	s0,0(sp)
    800007b8:	01010113          	add	sp,sp,16
    800007bc:	00008067          	ret

00000000800007c0 <uart_handle_interrupt>:

void uart_handle_interrupt() {
    // We got an interrupt! Collect the character(s) the user
    // typed and pass them to the console code in main.c.
    while (uart_read_reg(UART_LSR) & UART_LSR_RX_READY) {
    800007c0:	100007b7          	lui	a5,0x10000
    800007c4:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800007c8:	0017f793          	and	a5,a5,1
    800007cc:	04078463          	beqz	a5,80000814 <uart_handle_interrupt+0x54>
void uart_handle_interrupt() {
    800007d0:	fe010113          	add	sp,sp,-32
    800007d4:	00113c23          	sd	ra,24(sp)
    800007d8:	00813823          	sd	s0,16(sp)
    800007dc:	00913423          	sd	s1,8(sp)
    800007e0:	02010413          	add	s0,sp,32
    return uart_read_reg(UART_RHR);
    800007e4:	100004b7          	lui	s1,0x10000
    800007e8:	0004c503          	lbu	a0,0(s1) # 10000000 <_entry-0x70000000>
        main_handle_input(_uart_get_c());
    800007ec:	00000097          	auipc	ra,0x0
    800007f0:	868080e7          	jalr	-1944(ra) # 80000054 <main_handle_input>
    while (uart_read_reg(UART_LSR) & UART_LSR_RX_READY) {
    800007f4:	0054c783          	lbu	a5,5(s1)
    800007f8:	0017f793          	and	a5,a5,1
    800007fc:	fe0796e3          	bnez	a5,800007e8 <uart_handle_interrupt+0x28>
    }
    80000800:	01813083          	ld	ra,24(sp)
    80000804:	01013403          	ld	s0,16(sp)
    80000808:	00813483          	ld	s1,8(sp)
    8000080c:	02010113          	add	sp,sp,32
    80000810:	00008067          	ret
    80000814:	00008067          	ret

0000000080000818 <timerinit>:
#include "machinevec.h"

// arrange to receive timer interrupts.
// they will arrive in machine mode at
// machinevec
void timerinit() {
    80000818:	ff010113          	add	sp,sp,-16
    8000081c:	00113423          	sd	ra,8(sp)
    80000820:	00813023          	sd	s0,0(sp)
    80000824:	01010413          	add	s0,sp,16
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80000828:	00000097          	auipc	ra,0x0
    8000082c:	0a4080e7          	jalr	164(ra) # 800008cc <r_mhartid>

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64 *)CLINT_MTIMECMP(id) = *(uint64 *)CLINT_MTIME + interval;
    80000830:	0035151b          	sllw	a0,a0,0x3
    80000834:	020047b7          	lui	a5,0x2004
    80000838:	00a787b3          	add	a5,a5,a0
    8000083c:	0200c737          	lui	a4,0x200c
    80000840:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80000844:	000f46b7          	lui	a3,0xf4
    80000848:	24068693          	add	a3,a3,576 # f4240 <_entry-0x7ff0bdc0>
    8000084c:	00d70733          	add	a4,a4,a3
    80000850:	00e7b023          	sd	a4,0(a5) # 2004000 <_entry-0x7dffc000>

  // set the machine-mode trap handler.
  w_mtvec((uint64)machinevec);
    80000854:	00000517          	auipc	a0,0x0
    80000858:	d1c50513          	add	a0,a0,-740 # 80000570 <machinevec>
    8000085c:	00000097          	auipc	ra,0x0
    80000860:	2a0080e7          	jalr	672(ra) # 80000afc <w_mtvec>

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80000864:	00000097          	auipc	ra,0x0
    80000868:	084080e7          	jalr	132(ra) # 800008e8 <r_mstatus>
    8000086c:	00856513          	or	a0,a0,8
    80000870:	00000097          	auipc	ra,0x0
    80000874:	094080e7          	jalr	148(ra) # 80000904 <w_mstatus>

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80000878:	00000097          	auipc	ra,0x0
    8000087c:	16c080e7          	jalr	364(ra) # 800009e4 <r_mie>
    80000880:	08056513          	or	a0,a0,128
    80000884:	00000097          	auipc	ra,0x0
    80000888:	17c080e7          	jalr	380(ra) # 80000a00 <w_mie>
    8000088c:	00813083          	ld	ra,8(sp)
    80000890:	00013403          	ld	s0,0(sp)
    80000894:	01010113          	add	sp,sp,16
    80000898:	00008067          	ret

000000008000089c <schedule>:
#include "proc.h"
#include "util.h"

struct proc processes[2];

void schedule() {
    8000089c:	ff010113          	add	sp,sp,-16
    800008a0:	00113423          	sd	ra,8(sp)
    800008a4:	00813023          	sd	s0,0(sp)
    800008a8:	01010413          	add	s0,sp,16
  print_buf("A");
    800008ac:	00000517          	auipc	a0,0x0
    800008b0:	67c50513          	add	a0,a0,1660 # 80000f28 <sfence_vma+0x200>
    800008b4:	00000097          	auipc	ra,0x0
    800008b8:	a58080e7          	jalr	-1448(ra) # 8000030c <print_buf>
    800008bc:	00813083          	ld	ra,8(sp)
    800008c0:	00013403          	ld	s0,0(sp)
    800008c4:	01010113          	add	sp,sp,16
    800008c8:	00008067          	ret

00000000800008cc <r_mhartid>:
#include "riscv.h"

// which hart (core) is this?
uint64 r_mhartid() {
    800008cc:	ff010113          	add	sp,sp,-16
    800008d0:	00813423          	sd	s0,8(sp)
    800008d4:	01010413          	add	s0,sp,16
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r"(x));
    800008d8:	f1402573          	csrr	a0,mhartid
  return x;
}
    800008dc:	00813403          	ld	s0,8(sp)
    800008e0:	01010113          	add	sp,sp,16
    800008e4:	00008067          	ret

00000000800008e8 <r_mstatus>:

// Machine Status Register, mstatus

uint64 r_mstatus() {
    800008e8:	ff010113          	add	sp,sp,-16
    800008ec:	00813423          	sd	s0,8(sp)
    800008f0:	01010413          	add	s0,sp,16
  uint64 x;
  asm volatile("csrr %0, mstatus" : "=r"(x));
    800008f4:	30002573          	csrr	a0,mstatus
  return x;
}
    800008f8:	00813403          	ld	s0,8(sp)
    800008fc:	01010113          	add	sp,sp,16
    80000900:	00008067          	ret

0000000080000904 <w_mstatus>:

void w_mstatus(uint64 x) {
    80000904:	ff010113          	add	sp,sp,-16
    80000908:	00813423          	sd	s0,8(sp)
    8000090c:	01010413          	add	s0,sp,16
  asm volatile("csrw mstatus, %0" : : "r"(x));
    80000910:	30051073          	csrw	mstatus,a0
}
    80000914:	00813403          	ld	s0,8(sp)
    80000918:	01010113          	add	sp,sp,16
    8000091c:	00008067          	ret

0000000080000920 <w_mepc>:

// machine exception program counter, holds the
// instruction address to which a return from
// exception will go.
void w_mepc(uint64 x) {
    80000920:	ff010113          	add	sp,sp,-16
    80000924:	00813423          	sd	s0,8(sp)
    80000928:	01010413          	add	s0,sp,16
  asm volatile("csrw mepc, %0" : : "r"(x));
    8000092c:	34151073          	csrw	mepc,a0
}
    80000930:	00813403          	ld	s0,8(sp)
    80000934:	01010113          	add	sp,sp,16
    80000938:	00008067          	ret

000000008000093c <r_sstatus>:

// Supervisor Status Register, sstatus

uint64 r_sstatus() {
    8000093c:	ff010113          	add	sp,sp,-16
    80000940:	00813423          	sd	s0,8(sp)
    80000944:	01010413          	add	s0,sp,16
  uint64 x;
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80000948:	10002573          	csrr	a0,sstatus
  return x;
}
    8000094c:	00813403          	ld	s0,8(sp)
    80000950:	01010113          	add	sp,sp,16
    80000954:	00008067          	ret

0000000080000958 <w_sstatus>:

void w_sstatus(uint64 x) {
    80000958:	ff010113          	add	sp,sp,-16
    8000095c:	00813423          	sd	s0,8(sp)
    80000960:	01010413          	add	s0,sp,16
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80000964:	10051073          	csrw	sstatus,a0
}
    80000968:	00813403          	ld	s0,8(sp)
    8000096c:	01010113          	add	sp,sp,16
    80000970:	00008067          	ret

0000000080000974 <r_sip>:

// Supervisor Interrupt Pending
uint64 r_sip() {
    80000974:	ff010113          	add	sp,sp,-16
    80000978:	00813423          	sd	s0,8(sp)
    8000097c:	01010413          	add	s0,sp,16
  uint64 x;
  asm volatile("csrr %0, sip" : "=r"(x));
    80000980:	14402573          	csrr	a0,sip
  return x;
}
    80000984:	00813403          	ld	s0,8(sp)
    80000988:	01010113          	add	sp,sp,16
    8000098c:	00008067          	ret

0000000080000990 <w_sip>:

void w_sip(uint64 x) {
    80000990:	ff010113          	add	sp,sp,-16
    80000994:	00813423          	sd	s0,8(sp)
    80000998:	01010413          	add	s0,sp,16
  asm volatile("csrw sip, %0" : : "r"(x));
    8000099c:	14451073          	csrw	sip,a0
}
    800009a0:	00813403          	ld	s0,8(sp)
    800009a4:	01010113          	add	sp,sp,16
    800009a8:	00008067          	ret

00000000800009ac <r_sie>:

// Supervisor Interrupt Enable

uint64 r_sie() {
    800009ac:	ff010113          	add	sp,sp,-16
    800009b0:	00813423          	sd	s0,8(sp)
    800009b4:	01010413          	add	s0,sp,16
  uint64 x;
  asm volatile("csrr %0, sie" : "=r"(x));
    800009b8:	10402573          	csrr	a0,sie
  return x;
}
    800009bc:	00813403          	ld	s0,8(sp)
    800009c0:	01010113          	add	sp,sp,16
    800009c4:	00008067          	ret

00000000800009c8 <w_sie>:

void w_sie(uint64 x) {
    800009c8:	ff010113          	add	sp,sp,-16
    800009cc:	00813423          	sd	s0,8(sp)
    800009d0:	01010413          	add	s0,sp,16
  asm volatile("csrw sie, %0" : : "r"(x));
    800009d4:	10451073          	csrw	sie,a0
}
    800009d8:	00813403          	ld	s0,8(sp)
    800009dc:	01010113          	add	sp,sp,16
    800009e0:	00008067          	ret

00000000800009e4 <r_mie>:

// Machine-mode Interrupt Enable

uint64 r_mie() {
    800009e4:	ff010113          	add	sp,sp,-16
    800009e8:	00813423          	sd	s0,8(sp)
    800009ec:	01010413          	add	s0,sp,16
  uint64 x;
  asm volatile("csrr %0, mie" : "=r"(x));
    800009f0:	30402573          	csrr	a0,mie
  return x;
}
    800009f4:	00813403          	ld	s0,8(sp)
    800009f8:	01010113          	add	sp,sp,16
    800009fc:	00008067          	ret

0000000080000a00 <w_mie>:

void w_mie(uint64 x) {
    80000a00:	ff010113          	add	sp,sp,-16
    80000a04:	00813423          	sd	s0,8(sp)
    80000a08:	01010413          	add	s0,sp,16
  asm volatile("csrw mie, %0" : : "r"(x));
    80000a0c:	30451073          	csrw	mie,a0
}
    80000a10:	00813403          	ld	s0,8(sp)
    80000a14:	01010113          	add	sp,sp,16
    80000a18:	00008067          	ret

0000000080000a1c <w_sepc>:

// supervisor exception program counter, holds the
// instruction address to which a return from
// exception will go.
void w_sepc(uint64 x) {
    80000a1c:	ff010113          	add	sp,sp,-16
    80000a20:	00813423          	sd	s0,8(sp)
    80000a24:	01010413          	add	s0,sp,16
  asm volatile("csrw sepc, %0" : : "r"(x));
    80000a28:	14151073          	csrw	sepc,a0
}
    80000a2c:	00813403          	ld	s0,8(sp)
    80000a30:	01010113          	add	sp,sp,16
    80000a34:	00008067          	ret

0000000080000a38 <r_sepc>:

uint64 r_sepc() {
    80000a38:	ff010113          	add	sp,sp,-16
    80000a3c:	00813423          	sd	s0,8(sp)
    80000a40:	01010413          	add	s0,sp,16
  uint64 x;
  asm volatile("csrr %0, sepc" : "=r"(x));
    80000a44:	14102573          	csrr	a0,sepc
  return x;
}
    80000a48:	00813403          	ld	s0,8(sp)
    80000a4c:	01010113          	add	sp,sp,16
    80000a50:	00008067          	ret

0000000080000a54 <r_medeleg>:

// Machine Exception Delegation
uint64 r_medeleg() {
    80000a54:	ff010113          	add	sp,sp,-16
    80000a58:	00813423          	sd	s0,8(sp)
    80000a5c:	01010413          	add	s0,sp,16
  uint64 x;
  asm volatile("csrr %0, medeleg" : "=r"(x));
    80000a60:	30202573          	csrr	a0,medeleg
  return x;
}
    80000a64:	00813403          	ld	s0,8(sp)
    80000a68:	01010113          	add	sp,sp,16
    80000a6c:	00008067          	ret

0000000080000a70 <w_medeleg>:

void w_medeleg(uint64 x) {
    80000a70:	ff010113          	add	sp,sp,-16
    80000a74:	00813423          	sd	s0,8(sp)
    80000a78:	01010413          	add	s0,sp,16
  asm volatile("csrw medeleg, %0" : : "r"(x));
    80000a7c:	30251073          	csrw	medeleg,a0
}
    80000a80:	00813403          	ld	s0,8(sp)
    80000a84:	01010113          	add	sp,sp,16
    80000a88:	00008067          	ret

0000000080000a8c <r_mideleg>:

// Machine Interrupt Delegation
uint64 r_mideleg() {
    80000a8c:	ff010113          	add	sp,sp,-16
    80000a90:	00813423          	sd	s0,8(sp)
    80000a94:	01010413          	add	s0,sp,16
  uint64 x;
  asm volatile("csrr %0, mideleg" : "=r"(x));
    80000a98:	30302573          	csrr	a0,mideleg
  return x;
}
    80000a9c:	00813403          	ld	s0,8(sp)
    80000aa0:	01010113          	add	sp,sp,16
    80000aa4:	00008067          	ret

0000000080000aa8 <w_mideleg>:

void w_mideleg(uint64 x) {
    80000aa8:	ff010113          	add	sp,sp,-16
    80000aac:	00813423          	sd	s0,8(sp)
    80000ab0:	01010413          	add	s0,sp,16
  asm volatile("csrw mideleg, %0" : : "r"(x));
    80000ab4:	30351073          	csrw	mideleg,a0
}
    80000ab8:	00813403          	ld	s0,8(sp)
    80000abc:	01010113          	add	sp,sp,16
    80000ac0:	00008067          	ret

0000000080000ac4 <w_stvec>:

// Supervisor Trap-Vector Base Address
// low two bits are mode.
void w_stvec(uint64 x) {
    80000ac4:	ff010113          	add	sp,sp,-16
    80000ac8:	00813423          	sd	s0,8(sp)
    80000acc:	01010413          	add	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r"(x));
    80000ad0:	10551073          	csrw	stvec,a0
}
    80000ad4:	00813403          	ld	s0,8(sp)
    80000ad8:	01010113          	add	sp,sp,16
    80000adc:	00008067          	ret

0000000080000ae0 <r_stvec>:

uint64 r_stvec() {
    80000ae0:	ff010113          	add	sp,sp,-16
    80000ae4:	00813423          	sd	s0,8(sp)
    80000ae8:	01010413          	add	s0,sp,16
  uint64 x;
  asm volatile("csrr %0, stvec" : "=r"(x));
    80000aec:	10502573          	csrr	a0,stvec
  return x;
}
    80000af0:	00813403          	ld	s0,8(sp)
    80000af4:	01010113          	add	sp,sp,16
    80000af8:	00008067          	ret

0000000080000afc <w_mtvec>:

// Machine-mode interrupt vector
void w_mtvec(uint64 x) {
    80000afc:	ff010113          	add	sp,sp,-16
    80000b00:	00813423          	sd	s0,8(sp)
    80000b04:	01010413          	add	s0,sp,16
  asm volatile("csrw mtvec, %0" : : "r"(x));
    80000b08:	30551073          	csrw	mtvec,a0
}
    80000b0c:	00813403          	ld	s0,8(sp)
    80000b10:	01010113          	add	sp,sp,16
    80000b14:	00008067          	ret

0000000080000b18 <w_pmpcfg0>:

// Physical Memory Protection
void w_pmpcfg0(uint64 x) {
    80000b18:	ff010113          	add	sp,sp,-16
    80000b1c:	00813423          	sd	s0,8(sp)
    80000b20:	01010413          	add	s0,sp,16
  asm volatile("csrw pmpcfg0, %0" : : "r"(x));
    80000b24:	3a051073          	csrw	pmpcfg0,a0
}
    80000b28:	00813403          	ld	s0,8(sp)
    80000b2c:	01010113          	add	sp,sp,16
    80000b30:	00008067          	ret

0000000080000b34 <w_pmpaddr0>:

void w_pmpaddr0(uint64 x) {
    80000b34:	ff010113          	add	sp,sp,-16
    80000b38:	00813423          	sd	s0,8(sp)
    80000b3c:	01010413          	add	s0,sp,16
  asm volatile("csrw pmpaddr0, %0" : : "r"(x));
    80000b40:	3b051073          	csrw	pmpaddr0,a0
}
    80000b44:	00813403          	ld	s0,8(sp)
    80000b48:	01010113          	add	sp,sp,16
    80000b4c:	00008067          	ret

0000000080000b50 <w_satp>:

// supervisor address translation and protection;
// holds the address of the page table.
void w_satp(uint64 x) {
    80000b50:	ff010113          	add	sp,sp,-16
    80000b54:	00813423          	sd	s0,8(sp)
    80000b58:	01010413          	add	s0,sp,16
  asm volatile("csrw satp, %0" : : "r"(x));
    80000b5c:	18051073          	csrw	satp,a0
}
    80000b60:	00813403          	ld	s0,8(sp)
    80000b64:	01010113          	add	sp,sp,16
    80000b68:	00008067          	ret

0000000080000b6c <r_satp>:

uint64 r_satp() {
    80000b6c:	ff010113          	add	sp,sp,-16
    80000b70:	00813423          	sd	s0,8(sp)
    80000b74:	01010413          	add	s0,sp,16
  uint64 x;
  asm volatile("csrr %0, satp" : "=r"(x));
    80000b78:	18002573          	csrr	a0,satp
  return x;
}
    80000b7c:	00813403          	ld	s0,8(sp)
    80000b80:	01010113          	add	sp,sp,16
    80000b84:	00008067          	ret

0000000080000b88 <w_mscratch>:

void w_mscratch(uint64 x) {
    80000b88:	ff010113          	add	sp,sp,-16
    80000b8c:	00813423          	sd	s0,8(sp)
    80000b90:	01010413          	add	s0,sp,16
  asm volatile("csrw mscratch, %0" : : "r"(x));
    80000b94:	34051073          	csrw	mscratch,a0
}
    80000b98:	00813403          	ld	s0,8(sp)
    80000b9c:	01010113          	add	sp,sp,16
    80000ba0:	00008067          	ret

0000000080000ba4 <r_scause>:

// Supervisor Trap Cause
uint64 r_scause() {
    80000ba4:	ff010113          	add	sp,sp,-16
    80000ba8:	00813423          	sd	s0,8(sp)
    80000bac:	01010413          	add	s0,sp,16
  uint64 x;
  asm volatile("csrr %0, scause" : "=r"(x));
    80000bb0:	14202573          	csrr	a0,scause
  return x;
}
    80000bb4:	00813403          	ld	s0,8(sp)
    80000bb8:	01010113          	add	sp,sp,16
    80000bbc:	00008067          	ret

0000000080000bc0 <r_mcause>:

// Machine Trap Cause
uint64 r_mcause() {
    80000bc0:	ff010113          	add	sp,sp,-16
    80000bc4:	00813423          	sd	s0,8(sp)
    80000bc8:	01010413          	add	s0,sp,16
  uint64 x;
  asm volatile("csrr %0, mcause" : "=r"(x));
    80000bcc:	34202573          	csrr	a0,mcause
  return x;
}
    80000bd0:	00813403          	ld	s0,8(sp)
    80000bd4:	01010113          	add	sp,sp,16
    80000bd8:	00008067          	ret

0000000080000bdc <r_stval>:

// Supervisor Trap Value
uint64 r_stval() {
    80000bdc:	ff010113          	add	sp,sp,-16
    80000be0:	00813423          	sd	s0,8(sp)
    80000be4:	01010413          	add	s0,sp,16
  uint64 x;
  asm volatile("csrr %0, stval" : "=r"(x));
    80000be8:	14302573          	csrr	a0,stval
  return x;
}
    80000bec:	00813403          	ld	s0,8(sp)
    80000bf0:	01010113          	add	sp,sp,16
    80000bf4:	00008067          	ret

0000000080000bf8 <w_mcounteren>:

// Machine-mode Counter-Enable
void w_mcounteren(uint64 x) {
    80000bf8:	ff010113          	add	sp,sp,-16
    80000bfc:	00813423          	sd	s0,8(sp)
    80000c00:	01010413          	add	s0,sp,16
  asm volatile("csrw mcounteren, %0" : : "r"(x));
    80000c04:	30651073          	csrw	mcounteren,a0
}
    80000c08:	00813403          	ld	s0,8(sp)
    80000c0c:	01010113          	add	sp,sp,16
    80000c10:	00008067          	ret

0000000080000c14 <r_mcounteren>:

uint64 r_mcounteren() {
    80000c14:	ff010113          	add	sp,sp,-16
    80000c18:	00813423          	sd	s0,8(sp)
    80000c1c:	01010413          	add	s0,sp,16
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r"(x));
    80000c20:	30602573          	csrr	a0,mcounteren
  return x;
}
    80000c24:	00813403          	ld	s0,8(sp)
    80000c28:	01010113          	add	sp,sp,16
    80000c2c:	00008067          	ret

0000000080000c30 <r_time>:

// machine-mode cycle counter
uint64 r_time() {
    80000c30:	ff010113          	add	sp,sp,-16
    80000c34:	00813423          	sd	s0,8(sp)
    80000c38:	01010413          	add	s0,sp,16
  uint64 x;
  asm volatile("csrr %0, time" : "=r"(x));
    80000c3c:	c0102573          	rdtime	a0
  return x;
}
    80000c40:	00813403          	ld	s0,8(sp)
    80000c44:	01010113          	add	sp,sp,16
    80000c48:	00008067          	ret

0000000080000c4c <intr_on>:

// enable device interrupts
void intr_on() {
    80000c4c:	ff010113          	add	sp,sp,-16
    80000c50:	00813423          	sd	s0,8(sp)
    80000c54:	01010413          	add	s0,sp,16
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80000c58:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c5c:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80000c60:	10079073          	csrw	sstatus,a5
}
    80000c64:	00813403          	ld	s0,8(sp)
    80000c68:	01010113          	add	sp,sp,16
    80000c6c:	00008067          	ret

0000000080000c70 <intr_off>:

// disable device interrupts
void intr_off() {
    80000c70:	ff010113          	add	sp,sp,-16
    80000c74:	00813423          	sd	s0,8(sp)
    80000c78:	01010413          	add	s0,sp,16
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80000c7c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000c80:	ffd7f793          	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80000c84:	10079073          	csrw	sstatus,a5
}
    80000c88:	00813403          	ld	s0,8(sp)
    80000c8c:	01010113          	add	sp,sp,16
    80000c90:	00008067          	ret

0000000080000c94 <intr_get>:

// are device interrupts enabled?
int intr_get() {
    80000c94:	ff010113          	add	sp,sp,-16
    80000c98:	00813423          	sd	s0,8(sp)
    80000c9c:	01010413          	add	s0,sp,16
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80000ca0:	10002573          	csrr	a0,sstatus
  uint64 x = r_sstatus();
  return (x & SSTATUS_SIE) != 0;
    80000ca4:	00155513          	srl	a0,a0,0x1
}
    80000ca8:	00157513          	and	a0,a0,1
    80000cac:	00813403          	ld	s0,8(sp)
    80000cb0:	01010113          	add	sp,sp,16
    80000cb4:	00008067          	ret

0000000080000cb8 <r_sp>:

uint64 r_sp() {
    80000cb8:	ff010113          	add	sp,sp,-16
    80000cbc:	00813423          	sd	s0,8(sp)
    80000cc0:	01010413          	add	s0,sp,16
  uint64 x;
  asm volatile("mv %0, sp" : "=r"(x));
    80000cc4:	00010513          	mv	a0,sp
  return x;
}
    80000cc8:	00813403          	ld	s0,8(sp)
    80000ccc:	01010113          	add	sp,sp,16
    80000cd0:	00008067          	ret

0000000080000cd4 <r_tp>:

// read and write tp, the thread pointer, which xv6 uses to hold
// this core's hartid (core number), the index into cpus[].
uint64 r_tp() {
    80000cd4:	ff010113          	add	sp,sp,-16
    80000cd8:	00813423          	sd	s0,8(sp)
    80000cdc:	01010413          	add	s0,sp,16
  uint64 x;
  asm volatile("mv %0, tp" : "=r"(x));
    80000ce0:	00020513          	mv	a0,tp
  return x;
}
    80000ce4:	00813403          	ld	s0,8(sp)
    80000ce8:	01010113          	add	sp,sp,16
    80000cec:	00008067          	ret

0000000080000cf0 <w_tp>:

void w_tp(uint64 x) {
    80000cf0:	ff010113          	add	sp,sp,-16
    80000cf4:	00813423          	sd	s0,8(sp)
    80000cf8:	01010413          	add	s0,sp,16
  asm volatile("mv tp, %0" : : "r"(x));
    80000cfc:	00050213          	mv	tp,a0
}
    80000d00:	00813403          	ld	s0,8(sp)
    80000d04:	01010113          	add	sp,sp,16
    80000d08:	00008067          	ret

0000000080000d0c <r_ra>:

uint64 r_ra() {
    80000d0c:	ff010113          	add	sp,sp,-16
    80000d10:	00813423          	sd	s0,8(sp)
    80000d14:	01010413          	add	s0,sp,16
  uint64 x;
  asm volatile("mv %0, ra" : "=r"(x));
    80000d18:	00008513          	mv	a0,ra
  return x;
}
    80000d1c:	00813403          	ld	s0,8(sp)
    80000d20:	01010113          	add	sp,sp,16
    80000d24:	00008067          	ret

0000000080000d28 <sfence_vma>:

// flush the TLB.
void sfence_vma() {
    80000d28:	ff010113          	add	sp,sp,-16
    80000d2c:	00813423          	sd	s0,8(sp)
    80000d30:	01010413          	add	s0,sp,16
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000d34:	12000073          	sfence.vma
}
    80000d38:	00813403          	ld	s0,8(sp)
    80000d3c:	01010113          	add	sp,sp,16
    80000d40:	00008067          	ret
