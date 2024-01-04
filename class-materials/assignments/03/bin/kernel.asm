
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
    80000004:	98010113          	addi	sp,sp,-1664 # 80001980 <stack0>
	Reserve space on the stack for the most recent (printable)
	character read in. Riscv calling convention says the stack
	must be 16 byte aligned. stack0 is aligned by the linker,
	we are responsible for aligning it during runtime.
	*/
	addi sp, sp, -16
    80000008:	ff010113          	addi	sp,sp,-16
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
    80000014:	284080e7          	jalr	644(ra) # 80000294 <start>

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
char cmd_buf[MAIN_MAX_CMD_LEN] = { 0 };
unsigned char idx = 0;

void print_prompt() {
    8000001c:	ff010113          	addi	sp,sp,-16
    80000020:	00113423          	sd	ra,8(sp)
    80000024:	00813023          	sd	s0,0(sp)
    80000028:	01010413          	addi	s0,sp,16
    uart_write('>');
    8000002c:	03e00513          	li	a0,62
    80000030:	00000097          	auipc	ra,0x0
    80000034:	684080e7          	jalr	1668(ra) # 800006b4 <uart_write>
    uart_write(' ');
    80000038:	02000513          	li	a0,32
    8000003c:	00000097          	auipc	ra,0x0
    80000040:	678080e7          	jalr	1656(ra) # 800006b4 <uart_write>
}
    80000044:	00813083          	ld	ra,8(sp)
    80000048:	00013403          	ld	s0,0(sp)
    8000004c:	01010113          	addi	sp,sp,16
    80000050:	00008067          	ret

0000000080000054 <main_handle_input>:
// use this strategy creating a bottom-half and top-half of the
// driver. The bottom half is small and fast to handle interrupts,
// while the top half is larger and more complex. Later when we
// implement threads and multiprocessing this separation will make
// our lives much easier.
void main_handle_input(char c) {
    80000054:	fe010113          	addi	sp,sp,-32
    80000058:	00113c23          	sd	ra,24(sp)
    8000005c:	00813823          	sd	s0,16(sp)
    80000060:	00913423          	sd	s1,8(sp)
    80000064:	02010413          	addi	s0,sp,32
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
        }

    } else {
        // Make sure to always leave a null terminator, otherwise
        // *bad things* will happen. Don't save \n or \r
        if (idx < MAIN_MAX_CMD_LEN - 1) {
    80000080:	00001797          	auipc	a5,0x1
    80000084:	8f87c783          	lbu	a5,-1800(a5) # 80000978 <idx>
    80000088:	01e00713          	li	a4,30
    8000008c:	02f76063          	bltu	a4,a5,800000ac <main_handle_input+0x58>
            cmd_buf[idx] = c;
    80000090:	00001717          	auipc	a4,0x1
    80000094:	8c870713          	addi	a4,a4,-1848 # 80000958 <cmd_buf>
    80000098:	00f70733          	add	a4,a4,a5
    8000009c:	00a70023          	sb	a0,0(a4)
            idx++;
    800000a0:	0017879b          	addiw	a5,a5,1
    800000a4:	00001717          	auipc	a4,0x1
    800000a8:	8cf70a23          	sb	a5,-1836(a4) # 80000978 <idx>
        }
        // Echo the character back to the console
        uart_write(c);
    800000ac:	00000097          	auipc	ra,0x0
    800000b0:	608080e7          	jalr	1544(ra) # 800006b4 <uart_write>
    }
}
    800000b4:	0540006f          	j	80000108 <main_handle_input+0xb4>
        cmd_buf[idx] = 0;
    800000b8:	00001497          	auipc	s1,0x1
    800000bc:	8c048493          	addi	s1,s1,-1856 # 80000978 <idx>
    800000c0:	0004c783          	lbu	a5,0(s1)
    800000c4:	00001717          	auipc	a4,0x1
    800000c8:	89470713          	addi	a4,a4,-1900 # 80000958 <cmd_buf>
    800000cc:	00f70733          	add	a4,a4,a5
    800000d0:	00070023          	sb	zero,0(a4)
        idx++;
    800000d4:	0017879b          	addiw	a5,a5,1
    800000d8:	00f48023          	sb	a5,0(s1)
        print_buf("\n");
    800000dc:	00000517          	auipc	a0,0x0
    800000e0:	70c50513          	addi	a0,a0,1804 # 800007e8 <uart_handle_interrupt+0xc8>
    800000e4:	00000097          	auipc	ra,0x0
    800000e8:	1f8080e7          	jalr	504(ra) # 800002dc <print_buf>
        if (idx > 1) {
    800000ec:	0004c703          	lbu	a4,0(s1)
    800000f0:	00100793          	li	a5,1
    800000f4:	02e7e463          	bltu	a5,a4,8000011c <main_handle_input+0xc8>
        print_prompt();
    800000f8:	00000097          	auipc	ra,0x0
    800000fc:	f24080e7          	jalr	-220(ra) # 8000001c <print_prompt>
        idx = 0;
    80000100:	00001797          	auipc	a5,0x1
    80000104:	86078c23          	sb	zero,-1928(a5) # 80000978 <idx>
}
    80000108:	01813083          	ld	ra,24(sp)
    8000010c:	01013403          	ld	s0,16(sp)
    80000110:	00813483          	ld	s1,8(sp)
    80000114:	02010113          	addi	sp,sp,32
    80000118:	00008067          	ret
            if (strcmp(cmd_buf, "hello") == 0) {
    8000011c:	00000597          	auipc	a1,0x0
    80000120:	65c58593          	addi	a1,a1,1628 # 80000778 <uart_handle_interrupt+0x58>
    80000124:	00001517          	auipc	a0,0x1
    80000128:	83450513          	addi	a0,a0,-1996 # 80000958 <cmd_buf>
    8000012c:	00000097          	auipc	ra,0x0
    80000130:	20c080e7          	jalr	524(ra) # 80000338 <strcmp>
    80000134:	02051463          	bnez	a0,8000015c <main_handle_input+0x108>
                print_buf("world");
    80000138:	00000517          	auipc	a0,0x0
    8000013c:	64850513          	addi	a0,a0,1608 # 80000780 <uart_handle_interrupt+0x60>
    80000140:	00000097          	auipc	ra,0x0
    80000144:	19c080e7          	jalr	412(ra) # 800002dc <print_buf>
            print_buf("\n");
    80000148:	00000517          	auipc	a0,0x0
    8000014c:	6a050513          	addi	a0,a0,1696 # 800007e8 <uart_handle_interrupt+0xc8>
    80000150:	00000097          	auipc	ra,0x0
    80000154:	18c080e7          	jalr	396(ra) # 800002dc <print_buf>
    80000158:	fa1ff06f          	j	800000f8 <main_handle_input+0xa4>
            } else if (strcmp(cmd_buf, "charlie") == 0) {
    8000015c:	00000597          	auipc	a1,0x0
    80000160:	62c58593          	addi	a1,a1,1580 # 80000788 <uart_handle_interrupt+0x68>
    80000164:	00000517          	auipc	a0,0x0
    80000168:	7f450513          	addi	a0,a0,2036 # 80000958 <cmd_buf>
    8000016c:	00000097          	auipc	ra,0x0
    80000170:	1cc080e7          	jalr	460(ra) # 80000338 <strcmp>
    80000174:	00051c63          	bnez	a0,8000018c <main_handle_input+0x138>
                print_buf("weinstock");
    80000178:	00000517          	auipc	a0,0x0
    8000017c:	61850513          	addi	a0,a0,1560 # 80000790 <uart_handle_interrupt+0x70>
    80000180:	00000097          	auipc	ra,0x0
    80000184:	15c080e7          	jalr	348(ra) # 800002dc <print_buf>
    80000188:	fc1ff06f          	j	80000148 <main_handle_input+0xf4>
            } else if (strcmp(cmd_buf, "elizabeth") == 0) {
    8000018c:	00000597          	auipc	a1,0x0
    80000190:	61458593          	addi	a1,a1,1556 # 800007a0 <uart_handle_interrupt+0x80>
    80000194:	00000517          	auipc	a0,0x0
    80000198:	7c450513          	addi	a0,a0,1988 # 80000958 <cmd_buf>
    8000019c:	00000097          	auipc	ra,0x0
    800001a0:	19c080e7          	jalr	412(ra) # 80000338 <strcmp>
    800001a4:	06051c63          	bnez	a0,8000021c <main_handle_input+0x1c8>
                print_buf("\n");
    800001a8:	00000517          	auipc	a0,0x0
    800001ac:	64050513          	addi	a0,a0,1600 # 800007e8 <uart_handle_interrupt+0xc8>
    800001b0:	00000097          	auipc	ra,0x0
    800001b4:	12c080e7          	jalr	300(ra) # 800002dc <print_buf>
                print_buf("  _________.__                 .__    .___              \n");
    800001b8:	00000517          	auipc	a0,0x0
    800001bc:	5f850513          	addi	a0,a0,1528 # 800007b0 <uart_handle_interrupt+0x90>
    800001c0:	00000097          	auipc	ra,0x0
    800001c4:	11c080e7          	jalr	284(ra) # 800002dc <print_buf>
                print_buf(" /   _____/|  |__   ___________|__| __| _/____    ____  \n");
    800001c8:	00000517          	auipc	a0,0x0
    800001cc:	62850513          	addi	a0,a0,1576 # 800007f0 <uart_handle_interrupt+0xd0>
    800001d0:	00000097          	auipc	ra,0x0
    800001d4:	10c080e7          	jalr	268(ra) # 800002dc <print_buf>
                print_buf(" \\_____  \\ |  |  \\_/ __ \\_  __ \\  |/ __ |\\__  \\  /    \\ \n");
    800001d8:	00000517          	auipc	a0,0x0
    800001dc:	65850513          	addi	a0,a0,1624 # 80000830 <uart_handle_interrupt+0x110>
    800001e0:	00000097          	auipc	ra,0x0
    800001e4:	0fc080e7          	jalr	252(ra) # 800002dc <print_buf>
                print_buf(" /        \\|   Y  \\  ___/|  | \\/  / /_/ | / __ \\|   |  \\\n");
    800001e8:	00000517          	auipc	a0,0x0
    800001ec:	68850513          	addi	a0,a0,1672 # 80000870 <uart_handle_interrupt+0x150>
    800001f0:	00000097          	auipc	ra,0x0
    800001f4:	0ec080e7          	jalr	236(ra) # 800002dc <print_buf>
                print_buf("/_______  /|___|  /\\___  >__|  |__\\____ |(____  /___|  /\n");
    800001f8:	00000517          	auipc	a0,0x0
    800001fc:	6b850513          	addi	a0,a0,1720 # 800008b0 <uart_handle_interrupt+0x190>
    80000200:	00000097          	auipc	ra,0x0
    80000204:	0dc080e7          	jalr	220(ra) # 800002dc <print_buf>
                print_buf("        \\/      \\/     \\/              \\/     \\/     \\/ \n");
    80000208:	00000517          	auipc	a0,0x0
    8000020c:	6e850513          	addi	a0,a0,1768 # 800008f0 <uart_handle_interrupt+0x1d0>
    80000210:	00000097          	auipc	ra,0x0
    80000214:	0cc080e7          	jalr	204(ra) # 800002dc <print_buf>
    80000218:	f31ff06f          	j	80000148 <main_handle_input+0xf4>
                print_buf("command not recognized: ");
    8000021c:	00000517          	auipc	a0,0x0
    80000220:	71450513          	addi	a0,a0,1812 # 80000930 <uart_handle_interrupt+0x210>
    80000224:	00000097          	auipc	ra,0x0
    80000228:	0b8080e7          	jalr	184(ra) # 800002dc <print_buf>
                print_buf(cmd_buf);
    8000022c:	00000517          	auipc	a0,0x0
    80000230:	72c50513          	addi	a0,a0,1836 # 80000958 <cmd_buf>
    80000234:	00000097          	auipc	ra,0x0
    80000238:	0a8080e7          	jalr	168(ra) # 800002dc <print_buf>
    8000023c:	f0dff06f          	j	80000148 <main_handle_input+0xf4>
        if (idx > 0) { 
    80000240:	00000797          	auipc	a5,0x0
    80000244:	7387c783          	lbu	a5,1848(a5) # 80000978 <idx>
    80000248:	ec0780e3          	beqz	a5,80000108 <main_handle_input+0xb4>
            print_buf("\b \b");
    8000024c:	00000517          	auipc	a0,0x0
    80000250:	70450513          	addi	a0,a0,1796 # 80000950 <uart_handle_interrupt+0x230>
    80000254:	00000097          	auipc	ra,0x0
    80000258:	088080e7          	jalr	136(ra) # 800002dc <print_buf>
            idx--; 
    8000025c:	00000717          	auipc	a4,0x0
    80000260:	71c70713          	addi	a4,a4,1820 # 80000978 <idx>
    80000264:	00074783          	lbu	a5,0(a4)
    80000268:	fff7879b          	addiw	a5,a5,-1
    8000026c:	00f70023          	sb	a5,0(a4)
    80000270:	e99ff06f          	j	80000108 <main_handle_input+0xb4>

0000000080000274 <main>:
// a bit of power. What we really want to do is to tell the CPU to do
// nothing until an interrupt arrives. Conveniently riscv has a 
// "Wait For Interrupt (wfi)" command that does just that. So our new
// loop will just continuously sleep the CPU while waiting for a
// keyboard interrupt.
void main() {
    80000274:	ff010113          	addi	sp,sp,-16
    80000278:	00113423          	sd	ra,8(sp)
    8000027c:	00813023          	sd	s0,0(sp)
    80000280:	01010413          	addi	s0,sp,16
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

0000000080000294 <start>:
#include "uart.h"
#include "plic.h"
#include "trap.h"


void start() {
    80000294:	ff010113          	addi	sp,sp,-16
    80000298:	00113423          	sd	ra,8(sp)
    8000029c:	00813023          	sd	s0,0(sp)
    800002a0:	01010413          	addi	s0,sp,16
    uart_init();
    800002a4:	00000097          	auipc	ra,0x0
    800002a8:	33c080e7          	jalr	828(ra) # 800005e0 <uart_init>
    plicinit();
    800002ac:	00000097          	auipc	ra,0x0
    800002b0:	0c8080e7          	jalr	200(ra) # 80000374 <plicinit>
    plicinithart();
    800002b4:	00000097          	auipc	ra,0x0
    800002b8:	0e4080e7          	jalr	228(ra) # 80000398 <plicinithart>
    trapinithart();
    800002bc:	00000097          	auipc	ra,0x0
    800002c0:	148080e7          	jalr	328(ra) # 80000404 <trapinithart>
    main();
    800002c4:	00000097          	auipc	ra,0x0
    800002c8:	fb0080e7          	jalr	-80(ra) # 80000274 <main>
    800002cc:	00813083          	ld	ra,8(sp)
    800002d0:	00013403          	ld	s0,0(sp)
    800002d4:	01010113          	addi	sp,sp,16
    800002d8:	00008067          	ret

00000000800002dc <print_buf>:
#include "uart.h"


void print_buf(char *buf) {
    800002dc:	fe010113          	addi	sp,sp,-32
    800002e0:	00113c23          	sd	ra,24(sp)
    800002e4:	00813823          	sd	s0,16(sp)
    800002e8:	00913423          	sd	s1,8(sp)
    800002ec:	01213023          	sd	s2,0(sp)
    800002f0:	02010413          	addi	s0,sp,32
    800002f4:	00050913          	mv	s2,a0
    unsigned char print_idx = 0;
    while (buf[print_idx] != 0) {
    800002f8:	00054503          	lbu	a0,0(a0)
    800002fc:	02050263          	beqz	a0,80000320 <print_buf+0x44>
    unsigned char print_idx = 0;
    80000300:	00000493          	li	s1,0
        uart_write(buf[print_idx]);
    80000304:	00000097          	auipc	ra,0x0
    80000308:	3b0080e7          	jalr	944(ra) # 800006b4 <uart_write>
        print_idx++;
    8000030c:	0014849b          	addiw	s1,s1,1
    80000310:	0ff4f493          	zext.b	s1,s1
    while (buf[print_idx] != 0) {
    80000314:	009907b3          	add	a5,s2,s1
    80000318:	0007c503          	lbu	a0,0(a5)
    8000031c:	fe0514e3          	bnez	a0,80000304 <print_buf+0x28>
    }
}
    80000320:	01813083          	ld	ra,24(sp)
    80000324:	01013403          	ld	s0,16(sp)
    80000328:	00813483          	ld	s1,8(sp)
    8000032c:	00013903          	ld	s2,0(sp)
    80000330:	02010113          	addi	sp,sp,32
    80000334:	00008067          	ret

0000000080000338 <strcmp>:

int strcmp(char *str1, char *str2) {
    80000338:	ff010113          	addi	sp,sp,-16
    8000033c:	00813423          	sd	s0,8(sp)
    80000340:	01010413          	addi	s0,sp,16
    const unsigned char *s1 = (const unsigned char *) str1;
    const unsigned char *s2 = (const unsigned char *) str2;
    unsigned char c1, c2;
    do {
        c1 = (unsigned char) *s1++;
    80000344:	00150513          	addi	a0,a0,1
    80000348:	fff54783          	lbu	a5,-1(a0)
        c2 = (unsigned char) *s2++;
    8000034c:	00158593          	addi	a1,a1,1
    80000350:	fff5c703          	lbu	a4,-1(a1)
        if (c1 == '\0') { return c1 - c2; }
    80000354:	00078863          	beqz	a5,80000364 <strcmp+0x2c>
    } while (c1 == c2);
    80000358:	fee786e3          	beq	a5,a4,80000344 <strcmp+0xc>
    
    return c1 - c2;
    8000035c:	40e7853b          	subw	a0,a5,a4
    80000360:	0080006f          	j	80000368 <strcmp+0x30>
        if (c1 == '\0') { return c1 - c2; }
    80000364:	40e0053b          	negw	a0,a4
    80000368:	00813403          	ld	s0,8(sp)
    8000036c:	01010113          	addi	sp,sp,16
    80000370:	00008067          	ret

0000000080000374 <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80000374:	ff010113          	addi	sp,sp,-16
    80000378:	00813423          	sd	s0,8(sp)
    8000037c:	01010413          	addi	s0,sp,16
  // set desired IRQ priorities non-zero (zero = disabled).
  // UARTx_IRQ are the interrupt source numbers, each source gets 4 bytes
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80000380:	0c0007b7          	lui	a5,0xc000
    80000384:	00100713          	li	a4,1
    80000388:	02e7a423          	sw	a4,40(a5) # c000028 <_entry-0x73ffffd8>
}
    8000038c:	00813403          	ld	s0,8(sp)
    80000390:	01010113          	addi	sp,sp,16
    80000394:	00008067          	ret

0000000080000398 <plicinithart>:

void
plicinithart(void)
{
    80000398:	ff010113          	addi	sp,sp,-16
    8000039c:	00813423          	sd	s0,8(sp)
    800003a0:	01010413          	addi	s0,sp,16
  // and one hart must always have id 0
  int hart = 0;
  
  // set enable bits for this hart's M-mode
  // for the uart.
  *(uint32*)PLIC_MENABLE(hart) = (1 << UART0_IRQ);
    800003a4:	0c0027b7          	lui	a5,0xc002
    800003a8:	40000713          	li	a4,1024
    800003ac:	00e7a023          	sw	a4,0(a5) # c002000 <_entry-0x73ffe000>

  // set this hart's M-mode priority threshold to 0.
  *(uint32*)PLIC_MPRIORITY(hart) = 0;
    800003b0:	0c2007b7          	lui	a5,0xc200
    800003b4:	0007a023          	sw	zero,0(a5) # c200000 <_entry-0x73e00000>
}
    800003b8:	00813403          	ld	s0,8(sp)
    800003bc:	01010113          	addi	sp,sp,16
    800003c0:	00008067          	ret

00000000800003c4 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800003c4:	ff010113          	addi	sp,sp,-16
    800003c8:	00813423          	sd	s0,8(sp)
    800003cc:	01010413          	addi	s0,sp,16
  int hart = 0;
  int irq = *(uint32*)PLIC_MCLAIM(hart);
  return irq;
}
    800003d0:	0c2007b7          	lui	a5,0xc200
    800003d4:	0047a503          	lw	a0,4(a5) # c200004 <_entry-0x73dffffc>
    800003d8:	00813403          	ld	s0,8(sp)
    800003dc:	01010113          	addi	sp,sp,16
    800003e0:	00008067          	ret

00000000800003e4 <plic_complete>:

// tell the PLIC we've served this IRQ. 
void
plic_complete(int irq)
{
    800003e4:	ff010113          	addi	sp,sp,-16
    800003e8:	00813423          	sd	s0,8(sp)
    800003ec:	01010413          	addi	s0,sp,16
  int hart = 0;
  *(uint32*)PLIC_MCLAIM(hart) = irq;
    800003f0:	0c2007b7          	lui	a5,0xc200
    800003f4:	00a7a223          	sw	a0,4(a5) # c200004 <_entry-0x73dffffc>
}
    800003f8:	00813403          	ld	s0,8(sp)
    800003fc:	01010113          	addi	sp,sp,16
    80000400:	00008067          	ret

0000000080000404 <trapinithart>:
#include "plic.h"
#include "util.h"
#include "uart.h"

// set up to take exceptions and traps while in the kernel.
void trapinithart(void) {
    80000404:	ff010113          	addi	sp,sp,-16
    80000408:	00813423          	sd	s0,8(sp)
    8000040c:	01010413          	addi	s0,sp,16

// Machine-mode interrupt vector
static inline void 
w_mtvec(uint64 x)
{
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80000410:	00000797          	auipc	a5,0x0
    80000414:	0c078793          	addi	a5,a5,192 # 800004d0 <machinevec>
    80000418:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000041c:	300027f3          	csrr	a5,mstatus
  w_mtvec((uint64) machinevec);
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80000420:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000424:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80000428:	304027f3          	csrr	a5,mie
  w_mie(r_mie() | MIE_MEIE);
    8000042c:	00001737          	lui	a4,0x1
    80000430:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80000434:	00e7e7b3          	or	a5,a5,a4
  asm volatile("csrw mie, %0" : : "r" (x));
    80000438:	30479073          	csrw	mie,a5
}
    8000043c:	00813403          	ld	s0,8(sp)
    80000440:	01010113          	addi	sp,sp,16
    80000444:	00008067          	ret

0000000080000448 <devintr>:
// Machine Trap Cause
static inline uint64
r_mcause()
{
  uint64 x;
  asm volatile("csrr %0, mcause" : "=r" (x) );
    80000448:	342027f3          	csrr	a5,mcause
    if(irq)
      plic_complete(irq);

    return 1;
  } 
  return 0;
    8000044c:	00000513          	li	a0,0
  if(((mcause >> 63) & 1) &&
    80000450:	0007c463          	bltz	a5,80000458 <devintr+0x10>
    80000454:	00008067          	ret
     (mcause & 0xff) == 11){
    80000458:	0ff7f793          	zext.b	a5,a5
  if(((mcause >> 63) & 1) &&
    8000045c:	00b00713          	li	a4,11
    80000460:	fee79ae3          	bne	a5,a4,80000454 <devintr+0xc>
int devintr() {
    80000464:	fe010113          	addi	sp,sp,-32
    80000468:	00113c23          	sd	ra,24(sp)
    8000046c:	00813823          	sd	s0,16(sp)
    80000470:	00913423          	sd	s1,8(sp)
    80000474:	02010413          	addi	s0,sp,32
    int irq = plic_claim();
    80000478:	00000097          	auipc	ra,0x0
    8000047c:	f4c080e7          	jalr	-180(ra) # 800003c4 <plic_claim>
    80000480:	00050493          	mv	s1,a0
    if(irq == UART0_IRQ){
    80000484:	00a00793          	li	a5,10
    80000488:	02f50863          	beq	a0,a5,800004b8 <devintr+0x70>
    return 1;
    8000048c:	00100513          	li	a0,1
    if(irq)
    80000490:	00048a63          	beqz	s1,800004a4 <devintr+0x5c>
      plic_complete(irq);
    80000494:	00048513          	mv	a0,s1
    80000498:	00000097          	auipc	ra,0x0
    8000049c:	f4c080e7          	jalr	-180(ra) # 800003e4 <plic_complete>
    return 1;
    800004a0:	00100513          	li	a0,1
    800004a4:	01813083          	ld	ra,24(sp)
    800004a8:	01013403          	ld	s0,16(sp)
    800004ac:	00813483          	ld	s1,8(sp)
    800004b0:	02010113          	addi	sp,sp,32
    800004b4:	00008067          	ret
      uart_handle_interrupt();
    800004b8:	00000097          	auipc	ra,0x0
    800004bc:	268080e7          	jalr	616(ra) # 80000720 <uart_handle_interrupt>
    if(irq)
    800004c0:	fd5ff06f          	j	80000494 <devintr+0x4c>
	...

00000000800004d0 <machinevec>:
.global machinevec
.align 4
machinevec:

        # make room to save registers.
        addi sp, sp, -256
    800004d0:	f0010113          	addi	sp,sp,-256

        # save the registers.
        sd ra, 0(sp)
    800004d4:	00113023          	sd	ra,0(sp)
        sd sp, 8(sp)
    800004d8:	00213423          	sd	sp,8(sp)
        sd gp, 16(sp)
    800004dc:	00313823          	sd	gp,16(sp)
        sd tp, 24(sp)
    800004e0:	00413c23          	sd	tp,24(sp)
        sd t0, 32(sp)
    800004e4:	02513023          	sd	t0,32(sp)
        sd t1, 40(sp)
    800004e8:	02613423          	sd	t1,40(sp)
        sd t2, 48(sp)
    800004ec:	02713823          	sd	t2,48(sp)
        sd s0, 56(sp)
    800004f0:	02813c23          	sd	s0,56(sp)
        sd s1, 64(sp)
    800004f4:	04913023          	sd	s1,64(sp)
        sd a0, 72(sp)
    800004f8:	04a13423          	sd	a0,72(sp)
        sd a1, 80(sp)
    800004fc:	04b13823          	sd	a1,80(sp)
        sd a2, 88(sp)
    80000500:	04c13c23          	sd	a2,88(sp)
        sd a3, 96(sp)
    80000504:	06d13023          	sd	a3,96(sp)
        sd a4, 104(sp)
    80000508:	06e13423          	sd	a4,104(sp)
        sd a5, 112(sp)
    8000050c:	06f13823          	sd	a5,112(sp)
        sd a6, 120(sp)
    80000510:	07013c23          	sd	a6,120(sp)
        sd a7, 128(sp)
    80000514:	09113023          	sd	a7,128(sp)
        sd s2, 136(sp)
    80000518:	09213423          	sd	s2,136(sp)
        sd s3, 144(sp)
    8000051c:	09313823          	sd	s3,144(sp)
        sd s4, 152(sp)
    80000520:	09413c23          	sd	s4,152(sp)
        sd s5, 160(sp)
    80000524:	0b513023          	sd	s5,160(sp)
        sd s6, 168(sp)
    80000528:	0b613423          	sd	s6,168(sp)
        sd s7, 176(sp)
    8000052c:	0b713823          	sd	s7,176(sp)
        sd s8, 184(sp)
    80000530:	0b813c23          	sd	s8,184(sp)
        sd s9, 192(sp)
    80000534:	0d913023          	sd	s9,192(sp)
        sd s10, 200(sp)
    80000538:	0da13423          	sd	s10,200(sp)
        sd s11, 208(sp)
    8000053c:	0db13823          	sd	s11,208(sp)
        sd t3, 216(sp)
    80000540:	0dc13c23          	sd	t3,216(sp)
        sd t4, 224(sp)
    80000544:	0fd13023          	sd	t4,224(sp)
        sd t5, 232(sp)
    80000548:	0fe13423          	sd	t5,232(sp)
        sd t6, 240(sp)
    8000054c:	0ff13823          	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call devintr
    80000550:	00000097          	auipc	ra,0x0
    80000554:	ef8080e7          	jalr	-264(ra) # 80000448 <devintr>

        # restore registers.
        ld ra, 0(sp)
    80000558:	00013083          	ld	ra,0(sp)
        ld sp, 8(sp)
    8000055c:	00813103          	ld	sp,8(sp)
        ld gp, 16(sp)
    80000560:	01013183          	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    80000564:	02013283          	ld	t0,32(sp)
        ld t1, 40(sp)
    80000568:	02813303          	ld	t1,40(sp)
        ld t2, 48(sp)
    8000056c:	03013383          	ld	t2,48(sp)
        ld s0, 56(sp)
    80000570:	03813403          	ld	s0,56(sp)
        ld s1, 64(sp)
    80000574:	04013483          	ld	s1,64(sp)
        ld a0, 72(sp)
    80000578:	04813503          	ld	a0,72(sp)
        ld a1, 80(sp)
    8000057c:	05013583          	ld	a1,80(sp)
        ld a2, 88(sp)
    80000580:	05813603          	ld	a2,88(sp)
        ld a3, 96(sp)
    80000584:	06013683          	ld	a3,96(sp)
        ld a4, 104(sp)
    80000588:	06813703          	ld	a4,104(sp)
        ld a5, 112(sp)
    8000058c:	07013783          	ld	a5,112(sp)
        ld a6, 120(sp)
    80000590:	07813803          	ld	a6,120(sp)
        ld a7, 128(sp)
    80000594:	08013883          	ld	a7,128(sp)
        ld s2, 136(sp)
    80000598:	08813903          	ld	s2,136(sp)
        ld s3, 144(sp)
    8000059c:	09013983          	ld	s3,144(sp)
        ld s4, 152(sp)
    800005a0:	09813a03          	ld	s4,152(sp)
        ld s5, 160(sp)
    800005a4:	0a013a83          	ld	s5,160(sp)
        ld s6, 168(sp)
    800005a8:	0a813b03          	ld	s6,168(sp)
        ld s7, 176(sp)
    800005ac:	0b013b83          	ld	s7,176(sp)
        ld s8, 184(sp)
    800005b0:	0b813c03          	ld	s8,184(sp)
        ld s9, 192(sp)
    800005b4:	0c013c83          	ld	s9,192(sp)
        ld s10, 200(sp)
    800005b8:	0c813d03          	ld	s10,200(sp)
        ld s11, 208(sp)
    800005bc:	0d013d83          	ld	s11,208(sp)
        ld t3, 216(sp)
    800005c0:	0d813e03          	ld	t3,216(sp)
        ld t4, 224(sp)
    800005c4:	0e013e83          	ld	t4,224(sp)
        ld t5, 232(sp)
    800005c8:	0e813f03          	ld	t5,232(sp)
        ld t6, 240(sp)
    800005cc:	0f013f83          	ld	t6,240(sp)

        addi sp, sp, 256
    800005d0:	10010113          	addi	sp,sp,256

        # return to whatever we were doing
        mret
    800005d4:	30200073          	mret
    800005d8:	00000013          	nop
    800005dc:	00000013          	nop

00000000800005e0 <uart_init>:
#include "uart.h"
#include "main.h"

void uart_init() {
    800005e0:	ff010113          	addi	sp,sp,-16
    800005e4:	00813423          	sd	s0,8(sp)
    800005e8:	01010413          	addi	s0,sp,16
    // disable interrupts.
    uart_write_reg(UART_IER, UART_IER_GLOBAL_DISABLE);
    800005ec:	100007b7          	lui	a5,0x10000
    800005f0:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>
    // special mode to set baud rate.
    uart_write_reg(UART_LCR, UART_LCR_BAUD_LATCH);
    800005f4:	f8000713          	li	a4,-128
    800005f8:	00e781a3          	sb	a4,3(a5)
    // LSB for baud rate of 38.4K.
    uart_write_reg(UART_BAUD_RATE_LSB_REG, UART_BAUD_RATE_LSB);
    800005fc:	00300713          	li	a4,3
    80000600:	00e78023          	sb	a4,0(a5)
    // MSB for baud rate of 38.4K.
    uart_write_reg(UART_BAUD_RATE_MSB_REG, UART_BAUD_RATE_MSB);
    80000604:	000780a3          	sb	zero,1(a5)
    // leave set-baud mode,
    // and set word length to 8 bits, no parity.
    uart_write_reg(UART_LCR, UART_LCR_EIGHT_BITS);
    80000608:	00e781a3          	sb	a4,3(a5)
    // reset and enable FIFOs.
    uart_write_reg(UART_FCR, UART_FCR_FIFO_ENABLE | UART_FCR_FIFO_CLEAR);
    8000060c:	00700693          	li	a3,7
    80000610:	00d78123          	sb	a3,2(a5)
    // enable transmit and receive interrupts.
    uart_write_reg(UART_IER, UART_IER_TX_ENABLE | UART_IER_RX_ENABLE);
    80000614:	00e780a3          	sb	a4,1(a5)
}
    80000618:	00813403          	ld	s0,8(sp)
    8000061c:	01010113          	addi	sp,sp,16
    80000620:	00008067          	ret

0000000080000624 <_wait_for_uart_write>:
	
void _wait_for_uart_write() {
    80000624:	ff010113          	addi	sp,sp,-16
    80000628:	00813423          	sd	s0,8(sp)
    8000062c:	01010413          	addi	s0,sp,16
    while (!(uart_read_reg(UART_LSR) & UART_LSR_TX_IDLE));
    80000630:	10000737          	lui	a4,0x10000
    80000634:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80000638:	0207f793          	andi	a5,a5,32
    8000063c:	fe078ce3          	beqz	a5,80000634 <_wait_for_uart_write+0x10>
}
    80000640:	00813403          	ld	s0,8(sp)
    80000644:	01010113          	addi	sp,sp,16
    80000648:	00008067          	ret

000000008000064c <_wait_for_uart_read>:

void _wait_for_uart_read() {
    8000064c:	ff010113          	addi	sp,sp,-16
    80000650:	00813423          	sd	s0,8(sp)
    80000654:	01010413          	addi	s0,sp,16
    while (!(uart_read_reg(UART_LSR) & UART_LSR_RX_READY));
    80000658:	10000737          	lui	a4,0x10000
    8000065c:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80000660:	0017f793          	andi	a5,a5,1
    80000664:	fe078ce3          	beqz	a5,8000065c <_wait_for_uart_read+0x10>
}
    80000668:	00813403          	ld	s0,8(sp)
    8000066c:	01010113          	addi	sp,sp,16
    80000670:	00008067          	ret

0000000080000674 <_uart_put_c>:

void _uart_put_c(char c) {
    80000674:	ff010113          	addi	sp,sp,-16
    80000678:	00813423          	sd	s0,8(sp)
    8000067c:	01010413          	addi	s0,sp,16
    uart_write_reg(UART_THR, c);
    80000680:	100007b7          	lui	a5,0x10000
    80000684:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>
}
    80000688:	00813403          	ld	s0,8(sp)
    8000068c:	01010113          	addi	sp,sp,16
    80000690:	00008067          	ret

0000000080000694 <_uart_get_c>:

char _uart_get_c() {
    80000694:	ff010113          	addi	sp,sp,-16
    80000698:	00813423          	sd	s0,8(sp)
    8000069c:	01010413          	addi	s0,sp,16
    return uart_read_reg(UART_RHR);
    800006a0:	100007b7          	lui	a5,0x10000
    800006a4:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
}
    800006a8:	00813403          	ld	s0,8(sp)
    800006ac:	01010113          	addi	sp,sp,16
    800006b0:	00008067          	ret

00000000800006b4 <uart_write>:

void uart_write(char c) {
    800006b4:	fe010113          	addi	sp,sp,-32
    800006b8:	00113c23          	sd	ra,24(sp)
    800006bc:	00813823          	sd	s0,16(sp)
    800006c0:	00913423          	sd	s1,8(sp)
    800006c4:	02010413          	addi	s0,sp,32
    800006c8:	00050493          	mv	s1,a0
    _wait_for_uart_write();
    800006cc:	00000097          	auipc	ra,0x0
    800006d0:	f58080e7          	jalr	-168(ra) # 80000624 <_wait_for_uart_write>
    uart_write_reg(UART_THR, c);
    800006d4:	100007b7          	lui	a5,0x10000
    800006d8:	00978023          	sb	s1,0(a5) # 10000000 <_entry-0x70000000>
    _uart_put_c(c);
}
    800006dc:	01813083          	ld	ra,24(sp)
    800006e0:	01013403          	ld	s0,16(sp)
    800006e4:	00813483          	ld	s1,8(sp)
    800006e8:	02010113          	addi	sp,sp,32
    800006ec:	00008067          	ret

00000000800006f0 <uart_read>:

char uart_read() {
    800006f0:	ff010113          	addi	sp,sp,-16
    800006f4:	00113423          	sd	ra,8(sp)
    800006f8:	00813023          	sd	s0,0(sp)
    800006fc:	01010413          	addi	s0,sp,16
    _wait_for_uart_read();
    80000700:	00000097          	auipc	ra,0x0
    80000704:	f4c080e7          	jalr	-180(ra) # 8000064c <_wait_for_uart_read>
    return uart_read_reg(UART_RHR);
    80000708:	100007b7          	lui	a5,0x10000
    8000070c:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    return _uart_get_c();
}
    80000710:	00813083          	ld	ra,8(sp)
    80000714:	00013403          	ld	s0,0(sp)
    80000718:	01010113          	addi	sp,sp,16
    8000071c:	00008067          	ret

0000000080000720 <uart_handle_interrupt>:

void uart_handle_interrupt() {
    // We got an interrupt! Collect the character(s) the user
    // typed and pass them to the console code in main.c.
    while (uart_read_reg(UART_LSR) & UART_LSR_RX_READY) {
    80000720:	100007b7          	lui	a5,0x10000
    80000724:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80000728:	0017f793          	andi	a5,a5,1
    8000072c:	04078463          	beqz	a5,80000774 <uart_handle_interrupt+0x54>
void uart_handle_interrupt() {
    80000730:	fe010113          	addi	sp,sp,-32
    80000734:	00113c23          	sd	ra,24(sp)
    80000738:	00813823          	sd	s0,16(sp)
    8000073c:	00913423          	sd	s1,8(sp)
    80000740:	02010413          	addi	s0,sp,32
    return uart_read_reg(UART_RHR);
    80000744:	100004b7          	lui	s1,0x10000
    80000748:	0004c503          	lbu	a0,0(s1) # 10000000 <_entry-0x70000000>
        main_handle_input(_uart_get_c());
    8000074c:	00000097          	auipc	ra,0x0
    80000750:	908080e7          	jalr	-1784(ra) # 80000054 <main_handle_input>
    while (uart_read_reg(UART_LSR) & UART_LSR_RX_READY) {
    80000754:	0054c783          	lbu	a5,5(s1)
    80000758:	0017f793          	andi	a5,a5,1
    8000075c:	fe0796e3          	bnez	a5,80000748 <uart_handle_interrupt+0x28>
    }
    80000760:	01813083          	ld	ra,24(sp)
    80000764:	01013403          	ld	s0,16(sp)
    80000768:	00813483          	ld	s1,8(sp)
    8000076c:	02010113          	addi	sp,sp,32
    80000770:	00008067          	ret
    80000774:	00008067          	ret
