
build/bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <entry>:
	/*
	We have a referrence to the bottom of the stack,
	but the stack grows down! So add 4096 to get the
	top of the stack (we know how big it is bc we just made it).
	*/
	la sp, stack0
    80000000:	00001117          	auipc	sp,0x1
    80000004:	66010113          	addi	sp,sp,1632 # 80001660 <stack0>
	rest of the OS operation. You can still call the assembly functions
	you already wrote, but for the rest of this course you will mostly
	be writing in C.
	*/
/* BEGIN DELETE BLOCK */
	call start
    80000008:	00000097          	auipc	ra,0x0
    8000000c:	258080e7          	jalr	600(ra) # 80000260 <start>

0000000080000010 <spin>:
damaging itself in the process. If something goes wrong and 
the code leaves the input loop above, it will hit this and 
hang here, preventing the CPU from doing anything dangerous.
*/
spin:
        j spin
    80000010:	0000006f          	j	80000010 <spin>

0000000080000014 <main_print_prompt>:

char main_cmd_buf[MAX_CMD_LEN] = { 0 };
unsigned char main_idx = 0;
char main_input = 0;

void main_print_prompt() {
    80000014:	ff010113          	addi	sp,sp,-16
    80000018:	00113423          	sd	ra,8(sp)
    8000001c:	00813023          	sd	s0,0(sp)
    80000020:	01010413          	addi	s0,sp,16
    uart_write('>');
    80000024:	03e00513          	li	a0,62
    80000028:	00000097          	auipc	ra,0x0
    8000002c:	3d4080e7          	jalr	980(ra) # 800003fc <uart_write>
    uart_write(' ');
    80000030:	02000513          	li	a0,32
    80000034:	00000097          	auipc	ra,0x0
    80000038:	3c8080e7          	jalr	968(ra) # 800003fc <uart_write>
}
    8000003c:	00813083          	ld	ra,8(sp)
    80000040:	00013403          	ld	s0,0(sp)
    80000044:	01010113          	addi	sp,sp,16
    80000048:	00008067          	ret

000000008000004c <main>:
/* BEGIN DELETE BLOCK */

void main() {
    8000004c:	fb010113          	addi	sp,sp,-80
    80000050:	04113423          	sd	ra,72(sp)
    80000054:	04813023          	sd	s0,64(sp)
    80000058:	02913c23          	sd	s1,56(sp)
    8000005c:	03213823          	sd	s2,48(sp)
    80000060:	03313423          	sd	s3,40(sp)
    80000064:	03413023          	sd	s4,32(sp)
    80000068:	01513c23          	sd	s5,24(sp)
    8000006c:	01613823          	sd	s6,16(sp)
    80000070:	01713423          	sd	s7,8(sp)
    80000074:	01813023          	sd	s8,0(sp)
    80000078:	05010413          	addi	s0,sp,80
/* BEGIN DELETE BLOCK */
    main_print_prompt();
    8000007c:	00000097          	auipc	ra,0x0
    80000080:	f98080e7          	jalr	-104(ra) # 80000014 <main_print_prompt>
    while (1) {
        main_input = uart_read();
    80000084:	00000a17          	auipc	s4,0x0
    80000088:	5d4a0a13          	addi	s4,s4,1492 # 80000658 <main_input>
        if (main_input == '\n' || main_input == '\r') {
    8000008c:	00a00993          	li	s3,10
            // Insert null terminator in place of newline character,
            // otherwise we might read into old commands in the buffer
            main_cmd_buf[main_idx] = 0;
    80000090:	00000917          	auipc	s2,0x0
    80000094:	5b890913          	addi	s2,s2,1464 # 80000648 <main_cmd_buf>
    80000098:	00000497          	auipc	s1,0x0
    8000009c:	5c148493          	addi	s1,s1,1473 # 80000659 <main_idx>
            // Convert the carriage return to a newline and echo it back to user
            util_print_buf("\n");
    800000a0:	00000a97          	auipc	s5,0x0
    800000a4:	438a8a93          	addi	s5,s5,1080 # 800004d8 <uart_read+0xa0>
            // There is always a newline at the end, ignore it
            if (main_idx > 1) {
    800000a8:	00100b13          	li	s6,1
                // Parse special commands.
                // Credit to my wonderful friend Charlie and my lovely girlfriend Elizabeth Sheridan.
                // A reminder to always personalize your os and also stop working on it 
                // occasionally and get some fresh air.
                if (util_strcmp(main_cmd_buf, "hello") == 0) {
    800000ac:	00000b97          	auipc	s7,0x0
    800000b0:	3bcb8b93          	addi	s7,s7,956 # 80000468 <uart_read+0x30>
                    util_print_buf("world");
                } else if (util_strcmp(main_cmd_buf, "charlie") == 0) {
    800000b4:	00000c17          	auipc	s8,0x0
    800000b8:	3c4c0c13          	addi	s8,s8,964 # 80000478 <uart_read+0x40>
    800000bc:	0300006f          	j	800000ec <main+0xa0>
            main_cmd_buf[main_idx] = 0;
    800000c0:	0004c783          	lbu	a5,0(s1)
    800000c4:	00f907b3          	add	a5,s2,a5
    800000c8:	00078023          	sb	zero,0(a5)
            util_print_buf("\n");
    800000cc:	000a8513          	mv	a0,s5
    800000d0:	00000097          	auipc	ra,0x0
    800000d4:	1c0080e7          	jalr	448(ra) # 80000290 <util_print_buf>
            if (main_idx > 1) {
    800000d8:	0004c783          	lbu	a5,0(s1)
    800000dc:	04fb6c63          	bltu	s6,a5,80000134 <main+0xe8>
                    util_print_buf(main_cmd_buf);
                }
                // Make a newline after the output
                util_print_buf("\n");
            }
            main_print_prompt();
    800000e0:	00000097          	auipc	ra,0x0
    800000e4:	f34080e7          	jalr	-204(ra) # 80000014 <main_print_prompt>
            main_idx = 0;
    800000e8:	00048023          	sb	zero,0(s1)
        main_input = uart_read();
    800000ec:	00000097          	auipc	ra,0x0
    800000f0:	34c080e7          	jalr	844(ra) # 80000438 <uart_read>
    800000f4:	00aa0023          	sb	a0,0(s4)
        if (main_input == '\n' || main_input == '\r') {
    800000f8:	fd3504e3          	beq	a0,s3,800000c0 <main+0x74>
    800000fc:	00d00793          	li	a5,13
    80000100:	fcf500e3          	beq	a0,a5,800000c0 <main+0x74>
        } else if (main_input == '\x7f') {
    80000104:	07f00793          	li	a5,127
    80000108:	12f50863          	beq	a0,a5,80000238 <main+0x1ec>
            }

        } else {
            // Make sure to always leave a null terminator, otherwise
            // *bad things* will happen. Don't save \n or \r
            if (main_idx < MAX_CMD_LEN - 1) {
    8000010c:	0004c783          	lbu	a5,0(s1)
    80000110:	00e00713          	li	a4,14
    80000114:	00f76a63          	bltu	a4,a5,80000128 <main+0xdc>
                main_cmd_buf[main_idx] = main_input;
    80000118:	00f90733          	add	a4,s2,a5
    8000011c:	00a70023          	sb	a0,0(a4)
                main_idx++;
    80000120:	0017879b          	addiw	a5,a5,1
    80000124:	00f48023          	sb	a5,0(s1)
            }
            // Echo the character back to the console
            uart_write(main_input);
    80000128:	00000097          	auipc	ra,0x0
    8000012c:	2d4080e7          	jalr	724(ra) # 800003fc <uart_write>
    80000130:	fbdff06f          	j	800000ec <main+0xa0>
                if (util_strcmp(main_cmd_buf, "hello") == 0) {
    80000134:	000b8593          	mv	a1,s7
    80000138:	00090513          	mv	a0,s2
    8000013c:	00000097          	auipc	ra,0x0
    80000140:	1b0080e7          	jalr	432(ra) # 800002ec <util_strcmp>
    80000144:	02051263          	bnez	a0,80000168 <main+0x11c>
                    util_print_buf("world");
    80000148:	00000517          	auipc	a0,0x0
    8000014c:	32850513          	addi	a0,a0,808 # 80000470 <uart_read+0x38>
    80000150:	00000097          	auipc	ra,0x0
    80000154:	140080e7          	jalr	320(ra) # 80000290 <util_print_buf>
                util_print_buf("\n");
    80000158:	000a8513          	mv	a0,s5
    8000015c:	00000097          	auipc	ra,0x0
    80000160:	134080e7          	jalr	308(ra) # 80000290 <util_print_buf>
    80000164:	f7dff06f          	j	800000e0 <main+0x94>
                } else if (util_strcmp(main_cmd_buf, "charlie") == 0) {
    80000168:	000c0593          	mv	a1,s8
    8000016c:	00090513          	mv	a0,s2
    80000170:	00000097          	auipc	ra,0x0
    80000174:	17c080e7          	jalr	380(ra) # 800002ec <util_strcmp>
    80000178:	00051c63          	bnez	a0,80000190 <main+0x144>
                    util_print_buf("weinstock");
    8000017c:	00000517          	auipc	a0,0x0
    80000180:	30450513          	addi	a0,a0,772 # 80000480 <uart_read+0x48>
    80000184:	00000097          	auipc	ra,0x0
    80000188:	10c080e7          	jalr	268(ra) # 80000290 <util_print_buf>
    8000018c:	fcdff06f          	j	80000158 <main+0x10c>
                } else if (util_strcmp(main_cmd_buf, "elizabeth") == 0) {
    80000190:	00000597          	auipc	a1,0x0
    80000194:	30058593          	addi	a1,a1,768 # 80000490 <uart_read+0x58>
    80000198:	00090513          	mv	a0,s2
    8000019c:	00000097          	auipc	ra,0x0
    800001a0:	150080e7          	jalr	336(ra) # 800002ec <util_strcmp>
    800001a4:	06051a63          	bnez	a0,80000218 <main+0x1cc>
                    util_print_buf("\n");
    800001a8:	000a8513          	mv	a0,s5
    800001ac:	00000097          	auipc	ra,0x0
    800001b0:	0e4080e7          	jalr	228(ra) # 80000290 <util_print_buf>
                    util_print_buf("  _________.__                 .__    .___              \n");
    800001b4:	00000517          	auipc	a0,0x0
    800001b8:	2ec50513          	addi	a0,a0,748 # 800004a0 <uart_read+0x68>
    800001bc:	00000097          	auipc	ra,0x0
    800001c0:	0d4080e7          	jalr	212(ra) # 80000290 <util_print_buf>
                    util_print_buf(" /   _____/|  |__   ___________|__| __| _/____    ____  \n");
    800001c4:	00000517          	auipc	a0,0x0
    800001c8:	31c50513          	addi	a0,a0,796 # 800004e0 <uart_read+0xa8>
    800001cc:	00000097          	auipc	ra,0x0
    800001d0:	0c4080e7          	jalr	196(ra) # 80000290 <util_print_buf>
                    util_print_buf(" \\_____  \\ |  |  \\_/ __ \\_  __ \\  |/ __ |\\__  \\  /    \\ \n");
    800001d4:	00000517          	auipc	a0,0x0
    800001d8:	34c50513          	addi	a0,a0,844 # 80000520 <uart_read+0xe8>
    800001dc:	00000097          	auipc	ra,0x0
    800001e0:	0b4080e7          	jalr	180(ra) # 80000290 <util_print_buf>
                    util_print_buf(" /        \\|   Y  \\  ___/|  | \\/  / /_/ | / __ \\|   |  \\\n");
    800001e4:	00000517          	auipc	a0,0x0
    800001e8:	37c50513          	addi	a0,a0,892 # 80000560 <uart_read+0x128>
    800001ec:	00000097          	auipc	ra,0x0
    800001f0:	0a4080e7          	jalr	164(ra) # 80000290 <util_print_buf>
                    util_print_buf("/_______  /|___|  /\\___  >__|  |__\\____ |(____  /___|  /\n");
    800001f4:	00000517          	auipc	a0,0x0
    800001f8:	3ac50513          	addi	a0,a0,940 # 800005a0 <uart_read+0x168>
    800001fc:	00000097          	auipc	ra,0x0
    80000200:	094080e7          	jalr	148(ra) # 80000290 <util_print_buf>
                    util_print_buf("        \\/      \\/     \\/              \\/     \\/     \\/ \n");
    80000204:	00000517          	auipc	a0,0x0
    80000208:	3dc50513          	addi	a0,a0,988 # 800005e0 <uart_read+0x1a8>
    8000020c:	00000097          	auipc	ra,0x0
    80000210:	084080e7          	jalr	132(ra) # 80000290 <util_print_buf>
    80000214:	f45ff06f          	j	80000158 <main+0x10c>
                    util_print_buf("command not recognized: ");
    80000218:	00000517          	auipc	a0,0x0
    8000021c:	40850513          	addi	a0,a0,1032 # 80000620 <uart_read+0x1e8>
    80000220:	00000097          	auipc	ra,0x0
    80000224:	070080e7          	jalr	112(ra) # 80000290 <util_print_buf>
                    util_print_buf(main_cmd_buf);
    80000228:	00090513          	mv	a0,s2
    8000022c:	00000097          	auipc	ra,0x0
    80000230:	064080e7          	jalr	100(ra) # 80000290 <util_print_buf>
    80000234:	f25ff06f          	j	80000158 <main+0x10c>
            if (main_idx > 0) { 
    80000238:	0004c783          	lbu	a5,0(s1)
    8000023c:	ea0788e3          	beqz	a5,800000ec <main+0xa0>
                util_print_buf("\b \b");
    80000240:	00000517          	auipc	a0,0x0
    80000244:	40050513          	addi	a0,a0,1024 # 80000640 <uart_read+0x208>
    80000248:	00000097          	auipc	ra,0x0
    8000024c:	048080e7          	jalr	72(ra) # 80000290 <util_print_buf>
                main_idx--; 
    80000250:	0004c783          	lbu	a5,0(s1)
    80000254:	fff7879b          	addiw	a5,a5,-1
    80000258:	00f48023          	sb	a5,0(s1)
    8000025c:	e91ff06f          	j	800000ec <main+0xa0>

0000000080000260 <start>:
#include "main.h"
#include "uart.h"

void start() {
    80000260:	ff010113          	addi	sp,sp,-16
    80000264:	00113423          	sd	ra,8(sp)
    80000268:	00813023          	sd	s0,0(sp)
    8000026c:	01010413          	addi	s0,sp,16
    uart_init();
    80000270:	00000097          	auipc	ra,0x0
    80000274:	0b8080e7          	jalr	184(ra) # 80000328 <uart_init>
    main();
    80000278:	00000097          	auipc	ra,0x0
    8000027c:	dd4080e7          	jalr	-556(ra) # 8000004c <main>
    80000280:	00813083          	ld	ra,8(sp)
    80000284:	00013403          	ld	s0,0(sp)
    80000288:	01010113          	addi	sp,sp,16
    8000028c:	00008067          	ret

0000000080000290 <util_print_buf>:
#include "uart.h"


void util_print_buf(char *buf) {
    80000290:	fe010113          	addi	sp,sp,-32
    80000294:	00113c23          	sd	ra,24(sp)
    80000298:	00813823          	sd	s0,16(sp)
    8000029c:	00913423          	sd	s1,8(sp)
    800002a0:	01213023          	sd	s2,0(sp)
    800002a4:	02010413          	addi	s0,sp,32
    800002a8:	00050913          	mv	s2,a0
    unsigned char print_idx = 0;
    while (buf[print_idx] != 0) {
    800002ac:	00054503          	lbu	a0,0(a0)
    800002b0:	02050263          	beqz	a0,800002d4 <util_print_buf+0x44>
    unsigned char print_idx = 0;
    800002b4:	00000493          	li	s1,0
        uart_write(buf[print_idx]);
    800002b8:	00000097          	auipc	ra,0x0
    800002bc:	144080e7          	jalr	324(ra) # 800003fc <uart_write>
        print_idx++;
    800002c0:	0014849b          	addiw	s1,s1,1
    800002c4:	0ff4f493          	zext.b	s1,s1
    while (buf[print_idx] != 0) {
    800002c8:	009907b3          	add	a5,s2,s1
    800002cc:	0007c503          	lbu	a0,0(a5)
    800002d0:	fe0514e3          	bnez	a0,800002b8 <util_print_buf+0x28>
    }
}
    800002d4:	01813083          	ld	ra,24(sp)
    800002d8:	01013403          	ld	s0,16(sp)
    800002dc:	00813483          	ld	s1,8(sp)
    800002e0:	00013903          	ld	s2,0(sp)
    800002e4:	02010113          	addi	sp,sp,32
    800002e8:	00008067          	ret

00000000800002ec <util_strcmp>:

int util_strcmp(char *str1, char *str2) {
    800002ec:	ff010113          	addi	sp,sp,-16
    800002f0:	00813423          	sd	s0,8(sp)
    800002f4:	01010413          	addi	s0,sp,16
    const unsigned char *s1 = (const unsigned char *) str1;
    const unsigned char *s2 = (const unsigned char *) str2;
    unsigned char c1, c2;
    do {
        c1 = (unsigned char) *s1++;
    800002f8:	00150513          	addi	a0,a0,1
    800002fc:	fff54783          	lbu	a5,-1(a0)
        c2 = (unsigned char) *s2++;
    80000300:	00158593          	addi	a1,a1,1
    80000304:	fff5c703          	lbu	a4,-1(a1)
        if (c1 == '\0') { return c1 - c2; }
    80000308:	00078863          	beqz	a5,80000318 <util_strcmp+0x2c>
    } while (c1 == c2);
    8000030c:	fee786e3          	beq	a5,a4,800002f8 <util_strcmp+0xc>
    
    return c1 - c2;
    80000310:	40e7853b          	subw	a0,a5,a4
    80000314:	0080006f          	j	8000031c <util_strcmp+0x30>
        if (c1 == '\0') { return c1 - c2; }
    80000318:	40e0053b          	negw	a0,a4
    8000031c:	00813403          	ld	s0,8(sp)
    80000320:	01010113          	addi	sp,sp,16
    80000324:	00008067          	ret

0000000080000328 <uart_init>:
/* BEGIN DELETE BLOCK */
#include "uart.h"
void uart_init() {
    80000328:	ff010113          	addi	sp,sp,-16
    8000032c:	00813423          	sd	s0,8(sp)
    80000330:	01010413          	addi	s0,sp,16
  // disable interrupts.
  uart_write_reg(UART_IER, UART_IER_GLOBAL_DISABLE);
    80000334:	100007b7          	lui	a5,0x10000
    80000338:	000780a3          	sb	zero,1(a5) # 10000001 <entry-0x6fffffff>
  // special mode to set baud rate.
  uart_write_reg(UART_LCR, UART_LCR_BAUD_LATCH);
    8000033c:	f8000713          	li	a4,-128
    80000340:	00e781a3          	sb	a4,3(a5)
  // LSB for baud rate of 38.4K.
  uart_write_reg(0, 0x03);
    80000344:	00300713          	li	a4,3
    80000348:	00e78023          	sb	a4,0(a5)
  // MSB for baud rate of 38.4K.
  uart_write_reg(1, 0x00);
    8000034c:	000780a3          	sb	zero,1(a5)
  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  uart_write_reg(UART_LCR, UART_LCR_EIGHT_BITS);
    80000350:	00e781a3          	sb	a4,3(a5)
  // reset and enable FIFOs.
  uart_write_reg(UART_FCR, UART_FCR_FIFO_ENABLE | UART_FCR_FIFO_CLEAR);
    80000354:	00700693          	li	a3,7
    80000358:	00d78123          	sb	a3,2(a5)
  // enable transmit and receive interrupts.
  uart_write_reg(UART_IER, UART_IER_TX_ENABLE | UART_IER_RX_ENABLE);
    8000035c:	00e780a3          	sb	a4,1(a5)
}
    80000360:	00813403          	ld	s0,8(sp)
    80000364:	01010113          	addi	sp,sp,16
    80000368:	00008067          	ret

000000008000036c <uart_wait_for_write>:

void uart_wait_for_write() {
    8000036c:	ff010113          	addi	sp,sp,-16
    80000370:	00813423          	sd	s0,8(sp)
    80000374:	01010413          	addi	s0,sp,16
  while (!(uart_read_reg(UART_LSR) & UART_LSR_TX_IDLE));
    80000378:	10000737          	lui	a4,0x10000
    8000037c:	00574783          	lbu	a5,5(a4) # 10000005 <entry-0x6ffffffb>
    80000380:	0207f793          	andi	a5,a5,32
    80000384:	fe078ce3          	beqz	a5,8000037c <uart_wait_for_write+0x10>
}
    80000388:	00813403          	ld	s0,8(sp)
    8000038c:	01010113          	addi	sp,sp,16
    80000390:	00008067          	ret

0000000080000394 <uart_wait_for_read>:

void uart_wait_for_read() {
    80000394:	ff010113          	addi	sp,sp,-16
    80000398:	00813423          	sd	s0,8(sp)
    8000039c:	01010413          	addi	s0,sp,16
  while (!(uart_read_reg(UART_LSR) & UART_LSR_RX_READY));
    800003a0:	10000737          	lui	a4,0x10000
    800003a4:	00574783          	lbu	a5,5(a4) # 10000005 <entry-0x6ffffffb>
    800003a8:	0017f793          	andi	a5,a5,1
    800003ac:	fe078ce3          	beqz	a5,800003a4 <uart_wait_for_read+0x10>
}
    800003b0:	00813403          	ld	s0,8(sp)
    800003b4:	01010113          	addi	sp,sp,16
    800003b8:	00008067          	ret

00000000800003bc <uart_put_c>:

void uart_put_c(char c) { uart_write_reg(UART_THR, c); }
    800003bc:	ff010113          	addi	sp,sp,-16
    800003c0:	00813423          	sd	s0,8(sp)
    800003c4:	01010413          	addi	s0,sp,16
    800003c8:	100007b7          	lui	a5,0x10000
    800003cc:	00a78023          	sb	a0,0(a5) # 10000000 <entry-0x70000000>
    800003d0:	00813403          	ld	s0,8(sp)
    800003d4:	01010113          	addi	sp,sp,16
    800003d8:	00008067          	ret

00000000800003dc <uart_get_c>:

char uart_get_c() { return uart_read_reg(UART_RHR); }
    800003dc:	ff010113          	addi	sp,sp,-16
    800003e0:	00813423          	sd	s0,8(sp)
    800003e4:	01010413          	addi	s0,sp,16
    800003e8:	100007b7          	lui	a5,0x10000
    800003ec:	0007c503          	lbu	a0,0(a5) # 10000000 <entry-0x70000000>
    800003f0:	00813403          	ld	s0,8(sp)
    800003f4:	01010113          	addi	sp,sp,16
    800003f8:	00008067          	ret

00000000800003fc <uart_write>:

void uart_write(char c) {
    800003fc:	fe010113          	addi	sp,sp,-32
    80000400:	00113c23          	sd	ra,24(sp)
    80000404:	00813823          	sd	s0,16(sp)
    80000408:	00913423          	sd	s1,8(sp)
    8000040c:	02010413          	addi	s0,sp,32
    80000410:	00050493          	mv	s1,a0
  uart_wait_for_write();
    80000414:	00000097          	auipc	ra,0x0
    80000418:	f58080e7          	jalr	-168(ra) # 8000036c <uart_wait_for_write>
void uart_put_c(char c) { uart_write_reg(UART_THR, c); }
    8000041c:	100007b7          	lui	a5,0x10000
    80000420:	00978023          	sb	s1,0(a5) # 10000000 <entry-0x70000000>
  uart_put_c(c);
}
    80000424:	01813083          	ld	ra,24(sp)
    80000428:	01013403          	ld	s0,16(sp)
    8000042c:	00813483          	ld	s1,8(sp)
    80000430:	02010113          	addi	sp,sp,32
    80000434:	00008067          	ret

0000000080000438 <uart_read>:

char uart_read() {
    80000438:	ff010113          	addi	sp,sp,-16
    8000043c:	00113423          	sd	ra,8(sp)
    80000440:	00813023          	sd	s0,0(sp)
    80000444:	01010413          	addi	s0,sp,16
  uart_wait_for_read();
    80000448:	00000097          	auipc	ra,0x0
    8000044c:	f4c080e7          	jalr	-180(ra) # 80000394 <uart_wait_for_read>
char uart_get_c() { return uart_read_reg(UART_RHR); }
    80000450:	100007b7          	lui	a5,0x10000
    80000454:	0007c503          	lbu	a0,0(a5) # 10000000 <entry-0x70000000>
  return uart_get_c();
}
    80000458:	00813083          	ld	ra,8(sp)
    8000045c:	00013403          	ld	s0,0(sp)
    80000460:	01010113          	addi	sp,sp,16
    80000464:	00008067          	ret
