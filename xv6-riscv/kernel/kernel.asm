
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
_entry:
        # set up a stack for C.
        # stack0 is declared in start.c,
        # with a 4096-byte stack per CPU.
        # sp = stack0 + (hartid * 4096)
        la sp, stack0
    80000000:	0000b117          	auipc	sp,0xb
    80000004:	ad010113          	add	sp,sp,-1328 # 8000aad0 <stack0>
        li a0, 1024*4
    80000008:	00001537          	lui	a0,0x1
        csrr a1, mhartid
    8000000c:	f14025f3          	csrr	a1,mhartid
        addi a1, a1, 1
    80000010:	00158593          	add	a1,a1,1
        mul a0, a0, a1
    80000014:	02b50533          	mul	a0,a0,a1
        add sp, sp, a0
    80000018:	00a10133          	add	sp,sp,a0
        # jump to start() in start.c
        call start
    8000001c:	00000097          	auipc	ra,0x0
    80000020:	098080e7          	jalr	152(ra) # 800000b4 <start>

0000000080000024 <spin>:
spin:
        j spin
    80000024:	0000006f          	j	80000024 <spin>

0000000080000028 <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80000028:	ff010113          	add	sp,sp,-16
    8000002c:	00813423          	sd	s0,8(sp)
    80000030:	01010413          	add	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000034:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80000038:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000003c:	0037979b          	sllw	a5,a5,0x3
    80000040:	02004737          	lui	a4,0x2004
    80000044:	00e787b3          	add	a5,a5,a4
    80000048:	0200c737          	lui	a4,0x200c
    8000004c:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80000050:	000f4637          	lui	a2,0xf4
    80000054:	24060613          	add	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80000058:	00c70733          	add	a4,a4,a2
    8000005c:	00e7b023          	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80000060:	00259693          	sll	a3,a1,0x2
    80000064:	00b686b3          	add	a3,a3,a1
    80000068:	00369693          	sll	a3,a3,0x3
    8000006c:	0000b717          	auipc	a4,0xb
    80000070:	92470713          	add	a4,a4,-1756 # 8000a990 <timer_scratch>
    80000074:	00d70733          	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80000078:	00f73c23          	sd	a5,24(a4)
  scratch[4] = interval;
    8000007c:	02c73023          	sd	a2,32(a4)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80000080:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80000084:	00008797          	auipc	a5,0x8
    80000088:	e2c78793          	add	a5,a5,-468 # 80007eb0 <timervec>
    8000008c:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000090:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80000094:	0087e793          	or	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000098:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000009c:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800000a0:	0807e793          	or	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800000a4:	30479073          	csrw	mie,a5
}
    800000a8:	00813403          	ld	s0,8(sp)
    800000ac:	01010113          	add	sp,sp,16
    800000b0:	00008067          	ret

00000000800000b4 <start>:
{
    800000b4:	ff010113          	add	sp,sp,-16
    800000b8:	00113423          	sd	ra,8(sp)
    800000bc:	00813023          	sd	s0,0(sp)
    800000c0:	01010413          	add	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800000c4:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800000c8:	ffffe737          	lui	a4,0xffffe
    800000cc:	7ff70713          	add	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffda9ff>
    800000d0:	00e7f7b3          	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000d4:	00001737          	lui	a4,0x1
    800000d8:	80070713          	add	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000dc:	00e7e7b3          	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000e0:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000e4:	00001797          	auipc	a5,0x1
    800000e8:	2cc78793          	add	a5,a5,716 # 800013b0 <main>
    800000ec:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000f0:	00000793          	li	a5,0
    800000f4:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000f8:	000107b7          	lui	a5,0x10
    800000fc:	fff78793          	add	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80000100:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80000104:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80000108:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    8000010c:	2227e793          	or	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80000110:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80000114:	fff00793          	li	a5,-1
    80000118:	00a7d793          	srl	a5,a5,0xa
    8000011c:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80000120:	00f00793          	li	a5,15
    80000124:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80000128:	00000097          	auipc	ra,0x0
    8000012c:	f00080e7          	jalr	-256(ra) # 80000028 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000130:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80000134:	0007879b          	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    80000138:	00078213          	mv	tp,a5
  asm volatile("mret");
    8000013c:	30200073          	mret
}
    80000140:	00813083          	ld	ra,8(sp)
    80000144:	00013403          	ld	s0,0(sp)
    80000148:	01010113          	add	sp,sp,16
    8000014c:	00008067          	ret

0000000080000150 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80000150:	fb010113          	add	sp,sp,-80
    80000154:	04113423          	sd	ra,72(sp)
    80000158:	04813023          	sd	s0,64(sp)
    8000015c:	02913c23          	sd	s1,56(sp)
    80000160:	03213823          	sd	s2,48(sp)
    80000164:	03313423          	sd	s3,40(sp)
    80000168:	03413023          	sd	s4,32(sp)
    8000016c:	01513c23          	sd	s5,24(sp)
    80000170:	05010413          	add	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80000174:	06c05c63          	blez	a2,800001ec <consolewrite+0x9c>
    80000178:	00050a13          	mv	s4,a0
    8000017c:	00058493          	mv	s1,a1
    80000180:	00060993          	mv	s3,a2
    80000184:	00000913          	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80000188:	fff00a93          	li	s5,-1
    8000018c:	00100693          	li	a3,1
    80000190:	00048613          	mv	a2,s1
    80000194:	000a0593          	mv	a1,s4
    80000198:	fbf40513          	add	a0,s0,-65
    8000019c:	00003097          	auipc	ra,0x3
    800001a0:	228080e7          	jalr	552(ra) # 800033c4 <either_copyin>
    800001a4:	03550063          	beq	a0,s5,800001c4 <consolewrite+0x74>
      break;
    uartputc(c);
    800001a8:	fbf44503          	lbu	a0,-65(s0)
    800001ac:	00001097          	auipc	ra,0x1
    800001b0:	9b4080e7          	jalr	-1612(ra) # 80000b60 <uartputc>
  for(i = 0; i < n; i++){
    800001b4:	0019091b          	addw	s2,s2,1
    800001b8:	00148493          	add	s1,s1,1
    800001bc:	fd2998e3          	bne	s3,s2,8000018c <consolewrite+0x3c>
    800001c0:	00098913          	mv	s2,s3
  }

  return i;
}
    800001c4:	00090513          	mv	a0,s2
    800001c8:	04813083          	ld	ra,72(sp)
    800001cc:	04013403          	ld	s0,64(sp)
    800001d0:	03813483          	ld	s1,56(sp)
    800001d4:	03013903          	ld	s2,48(sp)
    800001d8:	02813983          	ld	s3,40(sp)
    800001dc:	02013a03          	ld	s4,32(sp)
    800001e0:	01813a83          	ld	s5,24(sp)
    800001e4:	05010113          	add	sp,sp,80
    800001e8:	00008067          	ret
  for(i = 0; i < n; i++){
    800001ec:	00000913          	li	s2,0
    800001f0:	fd5ff06f          	j	800001c4 <consolewrite+0x74>

00000000800001f4 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800001f4:	fa010113          	add	sp,sp,-96
    800001f8:	04113c23          	sd	ra,88(sp)
    800001fc:	04813823          	sd	s0,80(sp)
    80000200:	04913423          	sd	s1,72(sp)
    80000204:	05213023          	sd	s2,64(sp)
    80000208:	03313c23          	sd	s3,56(sp)
    8000020c:	03413823          	sd	s4,48(sp)
    80000210:	03513423          	sd	s5,40(sp)
    80000214:	03613023          	sd	s6,32(sp)
    80000218:	01713c23          	sd	s7,24(sp)
    8000021c:	06010413          	add	s0,sp,96
    80000220:	00050a93          	mv	s5,a0
    80000224:	00058a13          	mv	s4,a1
    80000228:	00060993          	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    8000022c:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80000230:	00013517          	auipc	a0,0x13
    80000234:	8a050513          	add	a0,a0,-1888 # 80012ad0 <cons>
    80000238:	00001097          	auipc	ra,0x1
    8000023c:	d8c080e7          	jalr	-628(ra) # 80000fc4 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80000240:	00013497          	auipc	s1,0x13
    80000244:	89048493          	add	s1,s1,-1904 # 80012ad0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80000248:	00013917          	auipc	s2,0x13
    8000024c:	92090913          	add	s2,s2,-1760 # 80012b68 <cons+0x98>
  while(n > 0){
    80000250:	09305e63          	blez	s3,800002ec <consoleread+0xf8>
    while(cons.r == cons.w){
    80000254:	0984a783          	lw	a5,152(s1)
    80000258:	09c4a703          	lw	a4,156(s1)
    8000025c:	02f71a63          	bne	a4,a5,80000290 <consoleread+0x9c>
      if(killed(myproc())){
    80000260:	00002097          	auipc	ra,0x2
    80000264:	1f4080e7          	jalr	500(ra) # 80002454 <myproc>
    80000268:	00003097          	auipc	ra,0x3
    8000026c:	ee4080e7          	jalr	-284(ra) # 8000314c <killed>
    80000270:	08051a63          	bnez	a0,80000304 <consoleread+0x110>
      sleep(&cons.r, &cons.lock);
    80000274:	00048593          	mv	a1,s1
    80000278:	00090513          	mv	a0,s2
    8000027c:	00003097          	auipc	ra,0x3
    80000280:	b20080e7          	jalr	-1248(ra) # 80002d9c <sleep>
    while(cons.r == cons.w){
    80000284:	0984a783          	lw	a5,152(s1)
    80000288:	09c4a703          	lw	a4,156(s1)
    8000028c:	fcf70ae3          	beq	a4,a5,80000260 <consoleread+0x6c>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80000290:	00013717          	auipc	a4,0x13
    80000294:	84070713          	add	a4,a4,-1984 # 80012ad0 <cons>
    80000298:	0017869b          	addw	a3,a5,1
    8000029c:	08d72c23          	sw	a3,152(a4)
    800002a0:	07f7f693          	and	a3,a5,127
    800002a4:	00d70733          	add	a4,a4,a3
    800002a8:	01874703          	lbu	a4,24(a4)
    800002ac:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    800002b0:	00400693          	li	a3,4
    800002b4:	08db8863          	beq	s7,a3,80000344 <consoleread+0x150>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    800002b8:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800002bc:	00100693          	li	a3,1
    800002c0:	faf40613          	add	a2,s0,-81
    800002c4:	000a0593          	mv	a1,s4
    800002c8:	000a8513          	mv	a0,s5
    800002cc:	00003097          	auipc	ra,0x3
    800002d0:	068080e7          	jalr	104(ra) # 80003334 <either_copyout>
    800002d4:	fff00793          	li	a5,-1
    800002d8:	00f50a63          	beq	a0,a5,800002ec <consoleread+0xf8>
      break;

    dst++;
    800002dc:	001a0a13          	add	s4,s4,1
    --n;
    800002e0:	fff9899b          	addw	s3,s3,-1

    if(c == '\n'){
    800002e4:	00a00793          	li	a5,10
    800002e8:	f6fb94e3          	bne	s7,a5,80000250 <consoleread+0x5c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    800002ec:	00012517          	auipc	a0,0x12
    800002f0:	7e450513          	add	a0,a0,2020 # 80012ad0 <cons>
    800002f4:	00001097          	auipc	ra,0x1
    800002f8:	dc8080e7          	jalr	-568(ra) # 800010bc <release>

  return target - n;
    800002fc:	413b053b          	subw	a0,s6,s3
    80000300:	0180006f          	j	80000318 <consoleread+0x124>
        release(&cons.lock);
    80000304:	00012517          	auipc	a0,0x12
    80000308:	7cc50513          	add	a0,a0,1996 # 80012ad0 <cons>
    8000030c:	00001097          	auipc	ra,0x1
    80000310:	db0080e7          	jalr	-592(ra) # 800010bc <release>
        return -1;
    80000314:	fff00513          	li	a0,-1
}
    80000318:	05813083          	ld	ra,88(sp)
    8000031c:	05013403          	ld	s0,80(sp)
    80000320:	04813483          	ld	s1,72(sp)
    80000324:	04013903          	ld	s2,64(sp)
    80000328:	03813983          	ld	s3,56(sp)
    8000032c:	03013a03          	ld	s4,48(sp)
    80000330:	02813a83          	ld	s5,40(sp)
    80000334:	02013b03          	ld	s6,32(sp)
    80000338:	01813b83          	ld	s7,24(sp)
    8000033c:	06010113          	add	sp,sp,96
    80000340:	00008067          	ret
      if(n < target){
    80000344:	0009871b          	sext.w	a4,s3
    80000348:	fb6772e3          	bgeu	a4,s6,800002ec <consoleread+0xf8>
        cons.r--;
    8000034c:	00013717          	auipc	a4,0x13
    80000350:	80f72e23          	sw	a5,-2020(a4) # 80012b68 <cons+0x98>
    80000354:	f99ff06f          	j	800002ec <consoleread+0xf8>

0000000080000358 <consputc>:
{
    80000358:	ff010113          	add	sp,sp,-16
    8000035c:	00113423          	sd	ra,8(sp)
    80000360:	00813023          	sd	s0,0(sp)
    80000364:	01010413          	add	s0,sp,16
  if(c == BACKSPACE){
    80000368:	10000793          	li	a5,256
    8000036c:	00f50e63          	beq	a0,a5,80000388 <consputc+0x30>
    uartputc_sync(c);
    80000370:	00000097          	auipc	ra,0x0
    80000374:	6d0080e7          	jalr	1744(ra) # 80000a40 <uartputc_sync>
}
    80000378:	00813083          	ld	ra,8(sp)
    8000037c:	00013403          	ld	s0,0(sp)
    80000380:	01010113          	add	sp,sp,16
    80000384:	00008067          	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80000388:	00800513          	li	a0,8
    8000038c:	00000097          	auipc	ra,0x0
    80000390:	6b4080e7          	jalr	1716(ra) # 80000a40 <uartputc_sync>
    80000394:	02000513          	li	a0,32
    80000398:	00000097          	auipc	ra,0x0
    8000039c:	6a8080e7          	jalr	1704(ra) # 80000a40 <uartputc_sync>
    800003a0:	00800513          	li	a0,8
    800003a4:	00000097          	auipc	ra,0x0
    800003a8:	69c080e7          	jalr	1692(ra) # 80000a40 <uartputc_sync>
    800003ac:	fcdff06f          	j	80000378 <consputc+0x20>

00000000800003b0 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800003b0:	fe010113          	add	sp,sp,-32
    800003b4:	00113c23          	sd	ra,24(sp)
    800003b8:	00813823          	sd	s0,16(sp)
    800003bc:	00913423          	sd	s1,8(sp)
    800003c0:	01213023          	sd	s2,0(sp)
    800003c4:	02010413          	add	s0,sp,32
    800003c8:	00050493          	mv	s1,a0
  acquire(&cons.lock);
    800003cc:	00012517          	auipc	a0,0x12
    800003d0:	70450513          	add	a0,a0,1796 # 80012ad0 <cons>
    800003d4:	00001097          	auipc	ra,0x1
    800003d8:	bf0080e7          	jalr	-1040(ra) # 80000fc4 <acquire>

  switch(c){
    800003dc:	01500793          	li	a5,21
    800003e0:	0cf48663          	beq	s1,a5,800004ac <consoleintr+0xfc>
    800003e4:	0497c263          	blt	a5,s1,80000428 <consoleintr+0x78>
    800003e8:	00800793          	li	a5,8
    800003ec:	10f48a63          	beq	s1,a5,80000500 <consoleintr+0x150>
    800003f0:	01000793          	li	a5,16
    800003f4:	12f49e63          	bne	s1,a5,80000530 <consoleintr+0x180>
  case C('P'):  // Print process list.
    procdump();
    800003f8:	00003097          	auipc	ra,0x3
    800003fc:	05c080e7          	jalr	92(ra) # 80003454 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80000400:	00012517          	auipc	a0,0x12
    80000404:	6d050513          	add	a0,a0,1744 # 80012ad0 <cons>
    80000408:	00001097          	auipc	ra,0x1
    8000040c:	cb4080e7          	jalr	-844(ra) # 800010bc <release>
}
    80000410:	01813083          	ld	ra,24(sp)
    80000414:	01013403          	ld	s0,16(sp)
    80000418:	00813483          	ld	s1,8(sp)
    8000041c:	00013903          	ld	s2,0(sp)
    80000420:	02010113          	add	sp,sp,32
    80000424:	00008067          	ret
  switch(c){
    80000428:	07f00793          	li	a5,127
    8000042c:	0cf48a63          	beq	s1,a5,80000500 <consoleintr+0x150>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80000430:	00012717          	auipc	a4,0x12
    80000434:	6a070713          	add	a4,a4,1696 # 80012ad0 <cons>
    80000438:	0a072783          	lw	a5,160(a4)
    8000043c:	09872703          	lw	a4,152(a4)
    80000440:	40e787bb          	subw	a5,a5,a4
    80000444:	07f00713          	li	a4,127
    80000448:	faf76ce3          	bltu	a4,a5,80000400 <consoleintr+0x50>
      c = (c == '\r') ? '\n' : c;
    8000044c:	00d00793          	li	a5,13
    80000450:	0ef48463          	beq	s1,a5,80000538 <consoleintr+0x188>
      consputc(c);
    80000454:	00048513          	mv	a0,s1
    80000458:	00000097          	auipc	ra,0x0
    8000045c:	f00080e7          	jalr	-256(ra) # 80000358 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000460:	00012797          	auipc	a5,0x12
    80000464:	67078793          	add	a5,a5,1648 # 80012ad0 <cons>
    80000468:	0a07a683          	lw	a3,160(a5)
    8000046c:	0016871b          	addw	a4,a3,1
    80000470:	0007061b          	sext.w	a2,a4
    80000474:	0ae7a023          	sw	a4,160(a5)
    80000478:	07f6f693          	and	a3,a3,127
    8000047c:	00d787b3          	add	a5,a5,a3
    80000480:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80000484:	00a00793          	li	a5,10
    80000488:	0ef48263          	beq	s1,a5,8000056c <consoleintr+0x1bc>
    8000048c:	00400793          	li	a5,4
    80000490:	0cf48e63          	beq	s1,a5,8000056c <consoleintr+0x1bc>
    80000494:	00012797          	auipc	a5,0x12
    80000498:	6d47a783          	lw	a5,1748(a5) # 80012b68 <cons+0x98>
    8000049c:	40f7073b          	subw	a4,a4,a5
    800004a0:	08000793          	li	a5,128
    800004a4:	f4f71ee3          	bne	a4,a5,80000400 <consoleintr+0x50>
    800004a8:	0c40006f          	j	8000056c <consoleintr+0x1bc>
    while(cons.e != cons.w &&
    800004ac:	00012717          	auipc	a4,0x12
    800004b0:	62470713          	add	a4,a4,1572 # 80012ad0 <cons>
    800004b4:	0a072783          	lw	a5,160(a4)
    800004b8:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800004bc:	00012497          	auipc	s1,0x12
    800004c0:	61448493          	add	s1,s1,1556 # 80012ad0 <cons>
    while(cons.e != cons.w &&
    800004c4:	00a00913          	li	s2,10
    800004c8:	f2f70ce3          	beq	a4,a5,80000400 <consoleintr+0x50>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800004cc:	fff7879b          	addw	a5,a5,-1
    800004d0:	07f7f713          	and	a4,a5,127
    800004d4:	00e48733          	add	a4,s1,a4
    while(cons.e != cons.w &&
    800004d8:	01874703          	lbu	a4,24(a4)
    800004dc:	f32702e3          	beq	a4,s2,80000400 <consoleintr+0x50>
      cons.e--;
    800004e0:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800004e4:	10000513          	li	a0,256
    800004e8:	00000097          	auipc	ra,0x0
    800004ec:	e70080e7          	jalr	-400(ra) # 80000358 <consputc>
    while(cons.e != cons.w &&
    800004f0:	0a04a783          	lw	a5,160(s1)
    800004f4:	09c4a703          	lw	a4,156(s1)
    800004f8:	fcf71ae3          	bne	a4,a5,800004cc <consoleintr+0x11c>
    800004fc:	f05ff06f          	j	80000400 <consoleintr+0x50>
    if(cons.e != cons.w){
    80000500:	00012717          	auipc	a4,0x12
    80000504:	5d070713          	add	a4,a4,1488 # 80012ad0 <cons>
    80000508:	0a072783          	lw	a5,160(a4)
    8000050c:	09c72703          	lw	a4,156(a4)
    80000510:	eef708e3          	beq	a4,a5,80000400 <consoleintr+0x50>
      cons.e--;
    80000514:	fff7879b          	addw	a5,a5,-1
    80000518:	00012717          	auipc	a4,0x12
    8000051c:	64f72c23          	sw	a5,1624(a4) # 80012b70 <cons+0xa0>
      consputc(BACKSPACE);
    80000520:	10000513          	li	a0,256
    80000524:	00000097          	auipc	ra,0x0
    80000528:	e34080e7          	jalr	-460(ra) # 80000358 <consputc>
    8000052c:	ed5ff06f          	j	80000400 <consoleintr+0x50>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80000530:	ec0488e3          	beqz	s1,80000400 <consoleintr+0x50>
    80000534:	efdff06f          	j	80000430 <consoleintr+0x80>
      consputc(c);
    80000538:	00a00513          	li	a0,10
    8000053c:	00000097          	auipc	ra,0x0
    80000540:	e1c080e7          	jalr	-484(ra) # 80000358 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000544:	00012797          	auipc	a5,0x12
    80000548:	58c78793          	add	a5,a5,1420 # 80012ad0 <cons>
    8000054c:	0a07a703          	lw	a4,160(a5)
    80000550:	0017069b          	addw	a3,a4,1
    80000554:	0006861b          	sext.w	a2,a3
    80000558:	0ad7a023          	sw	a3,160(a5)
    8000055c:	07f77713          	and	a4,a4,127
    80000560:	00e787b3          	add	a5,a5,a4
    80000564:	00a00713          	li	a4,10
    80000568:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    8000056c:	00012797          	auipc	a5,0x12
    80000570:	60c7a023          	sw	a2,1536(a5) # 80012b6c <cons+0x9c>
        wakeup(&cons.r);
    80000574:	00012517          	auipc	a0,0x12
    80000578:	5f450513          	add	a0,a0,1524 # 80012b68 <cons+0x98>
    8000057c:	00003097          	auipc	ra,0x3
    80000580:	8b0080e7          	jalr	-1872(ra) # 80002e2c <wakeup>
    80000584:	e7dff06f          	j	80000400 <consoleintr+0x50>

0000000080000588 <consoleinit>:

void
consoleinit(void)
{
    80000588:	ff010113          	add	sp,sp,-16
    8000058c:	00113423          	sd	ra,8(sp)
    80000590:	00813023          	sd	s0,0(sp)
    80000594:	01010413          	add	s0,sp,16
  initlock(&cons.lock, "cons");
    80000598:	0000a597          	auipc	a1,0xa
    8000059c:	a7858593          	add	a1,a1,-1416 # 8000a010 <etext+0x10>
    800005a0:	00012517          	auipc	a0,0x12
    800005a4:	53050513          	add	a0,a0,1328 # 80012ad0 <cons>
    800005a8:	00001097          	auipc	ra,0x1
    800005ac:	938080e7          	jalr	-1736(ra) # 80000ee0 <initlock>

  uartinit();
    800005b0:	00000097          	auipc	ra,0x0
    800005b4:	42c080e7          	jalr	1068(ra) # 800009dc <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    800005b8:	00022797          	auipc	a5,0x22
    800005bc:	6b078793          	add	a5,a5,1712 # 80022c68 <devsw>
    800005c0:	00000717          	auipc	a4,0x0
    800005c4:	c3470713          	add	a4,a4,-972 # 800001f4 <consoleread>
    800005c8:	00e7b823          	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    800005cc:	00000717          	auipc	a4,0x0
    800005d0:	b8470713          	add	a4,a4,-1148 # 80000150 <consolewrite>
    800005d4:	00e7bc23          	sd	a4,24(a5)
}
    800005d8:	00813083          	ld	ra,8(sp)
    800005dc:	00013403          	ld	s0,0(sp)
    800005e0:	01010113          	add	sp,sp,16
    800005e4:	00008067          	ret

00000000800005e8 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    800005e8:	fd010113          	add	sp,sp,-48
    800005ec:	02113423          	sd	ra,40(sp)
    800005f0:	02813023          	sd	s0,32(sp)
    800005f4:	00913c23          	sd	s1,24(sp)
    800005f8:	01213823          	sd	s2,16(sp)
    800005fc:	03010413          	add	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80000600:	00060463          	beqz	a2,80000608 <printint+0x20>
    80000604:	0a054c63          	bltz	a0,800006bc <printint+0xd4>
    x = -xx;
  else
    x = xx;
    80000608:	0005051b          	sext.w	a0,a0
    8000060c:	00000893          	li	a7,0
    80000610:	fd040693          	add	a3,s0,-48

  i = 0;
    80000614:	00000713          	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80000618:	0005859b          	sext.w	a1,a1
    8000061c:	0000a617          	auipc	a2,0xa
    80000620:	a2460613          	add	a2,a2,-1500 # 8000a040 <digits>
    80000624:	00070813          	mv	a6,a4
    80000628:	0017071b          	addw	a4,a4,1
    8000062c:	02b577bb          	remuw	a5,a0,a1
    80000630:	02079793          	sll	a5,a5,0x20
    80000634:	0207d793          	srl	a5,a5,0x20
    80000638:	00f607b3          	add	a5,a2,a5
    8000063c:	0007c783          	lbu	a5,0(a5)
    80000640:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80000644:	0005079b          	sext.w	a5,a0
    80000648:	02b5553b          	divuw	a0,a0,a1
    8000064c:	00168693          	add	a3,a3,1
    80000650:	fcb7fae3          	bgeu	a5,a1,80000624 <printint+0x3c>

  if(sign)
    80000654:	00088c63          	beqz	a7,8000066c <printint+0x84>
    buf[i++] = '-';
    80000658:	fe070793          	add	a5,a4,-32
    8000065c:	00878733          	add	a4,a5,s0
    80000660:	02d00793          	li	a5,45
    80000664:	fef70823          	sb	a5,-16(a4)
    80000668:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
    8000066c:	02e05c63          	blez	a4,800006a4 <printint+0xbc>
    80000670:	fd040793          	add	a5,s0,-48
    80000674:	00e784b3          	add	s1,a5,a4
    80000678:	fff78913          	add	s2,a5,-1
    8000067c:	00e90933          	add	s2,s2,a4
    80000680:	fff7071b          	addw	a4,a4,-1
    80000684:	02071713          	sll	a4,a4,0x20
    80000688:	02075713          	srl	a4,a4,0x20
    8000068c:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80000690:	fff4c503          	lbu	a0,-1(s1)
    80000694:	00000097          	auipc	ra,0x0
    80000698:	cc4080e7          	jalr	-828(ra) # 80000358 <consputc>
  while(--i >= 0)
    8000069c:	fff48493          	add	s1,s1,-1
    800006a0:	ff2498e3          	bne	s1,s2,80000690 <printint+0xa8>
}
    800006a4:	02813083          	ld	ra,40(sp)
    800006a8:	02013403          	ld	s0,32(sp)
    800006ac:	01813483          	ld	s1,24(sp)
    800006b0:	01013903          	ld	s2,16(sp)
    800006b4:	03010113          	add	sp,sp,48
    800006b8:	00008067          	ret
    x = -xx;
    800006bc:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    800006c0:	00100893          	li	a7,1
    x = -xx;
    800006c4:	f4dff06f          	j	80000610 <printint+0x28>

00000000800006c8 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    800006c8:	fe010113          	add	sp,sp,-32
    800006cc:	00113c23          	sd	ra,24(sp)
    800006d0:	00813823          	sd	s0,16(sp)
    800006d4:	00913423          	sd	s1,8(sp)
    800006d8:	02010413          	add	s0,sp,32
    800006dc:	00050493          	mv	s1,a0
  pr.locking = 0;
    800006e0:	00012797          	auipc	a5,0x12
    800006e4:	4a07a823          	sw	zero,1200(a5) # 80012b90 <pr+0x18>
  printf("panic: ");
    800006e8:	0000a517          	auipc	a0,0xa
    800006ec:	93050513          	add	a0,a0,-1744 # 8000a018 <etext+0x18>
    800006f0:	00000097          	auipc	ra,0x0
    800006f4:	034080e7          	jalr	52(ra) # 80000724 <printf>
  printf(s);
    800006f8:	00048513          	mv	a0,s1
    800006fc:	00000097          	auipc	ra,0x0
    80000700:	028080e7          	jalr	40(ra) # 80000724 <printf>
  printf("\n");
    80000704:	0000a517          	auipc	a0,0xa
    80000708:	dac50513          	add	a0,a0,-596 # 8000a4b0 <states.0+0x130>
    8000070c:	00000097          	auipc	ra,0x0
    80000710:	018080e7          	jalr	24(ra) # 80000724 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80000714:	00100793          	li	a5,1
    80000718:	0000a717          	auipc	a4,0xa
    8000071c:	22f72c23          	sw	a5,568(a4) # 8000a950 <panicked>
  for(;;)
    80000720:	0000006f          	j	80000720 <panic+0x58>

0000000080000724 <printf>:
{
    80000724:	f4010113          	add	sp,sp,-192
    80000728:	06113c23          	sd	ra,120(sp)
    8000072c:	06813823          	sd	s0,112(sp)
    80000730:	06913423          	sd	s1,104(sp)
    80000734:	07213023          	sd	s2,96(sp)
    80000738:	05313c23          	sd	s3,88(sp)
    8000073c:	05413823          	sd	s4,80(sp)
    80000740:	05513423          	sd	s5,72(sp)
    80000744:	05613023          	sd	s6,64(sp)
    80000748:	03713c23          	sd	s7,56(sp)
    8000074c:	03813823          	sd	s8,48(sp)
    80000750:	03913423          	sd	s9,40(sp)
    80000754:	03a13023          	sd	s10,32(sp)
    80000758:	01b13c23          	sd	s11,24(sp)
    8000075c:	08010413          	add	s0,sp,128
    80000760:	00050a13          	mv	s4,a0
    80000764:	00b43423          	sd	a1,8(s0)
    80000768:	00c43823          	sd	a2,16(s0)
    8000076c:	00d43c23          	sd	a3,24(s0)
    80000770:	02e43023          	sd	a4,32(s0)
    80000774:	02f43423          	sd	a5,40(s0)
    80000778:	03043823          	sd	a6,48(s0)
    8000077c:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80000780:	00012d97          	auipc	s11,0x12
    80000784:	410dad83          	lw	s11,1040(s11) # 80012b90 <pr+0x18>
  if(locking)
    80000788:	020d9e63          	bnez	s11,800007c4 <printf+0xa0>
  if (fmt == 0)
    8000078c:	040a0663          	beqz	s4,800007d8 <printf+0xb4>
  va_start(ap, fmt);
    80000790:	00840793          	add	a5,s0,8
    80000794:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80000798:	000a4503          	lbu	a0,0(s4)
    8000079c:	1a050063          	beqz	a0,8000093c <printf+0x218>
    800007a0:	00000993          	li	s3,0
    if(c != '%'){
    800007a4:	02500a93          	li	s5,37
    switch(c){
    800007a8:	07000b93          	li	s7,112
  consputc('x');
    800007ac:	01000d13          	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800007b0:	0000ab17          	auipc	s6,0xa
    800007b4:	890b0b13          	add	s6,s6,-1904 # 8000a040 <digits>
    switch(c){
    800007b8:	07300c93          	li	s9,115
    800007bc:	06400c13          	li	s8,100
    800007c0:	0400006f          	j	80000800 <printf+0xdc>
    acquire(&pr.lock);
    800007c4:	00012517          	auipc	a0,0x12
    800007c8:	3b450513          	add	a0,a0,948 # 80012b78 <pr>
    800007cc:	00000097          	auipc	ra,0x0
    800007d0:	7f8080e7          	jalr	2040(ra) # 80000fc4 <acquire>
    800007d4:	fb9ff06f          	j	8000078c <printf+0x68>
    panic("null fmt");
    800007d8:	0000a517          	auipc	a0,0xa
    800007dc:	85050513          	add	a0,a0,-1968 # 8000a028 <etext+0x28>
    800007e0:	00000097          	auipc	ra,0x0
    800007e4:	ee8080e7          	jalr	-280(ra) # 800006c8 <panic>
      consputc(c);
    800007e8:	00000097          	auipc	ra,0x0
    800007ec:	b70080e7          	jalr	-1168(ra) # 80000358 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800007f0:	0019899b          	addw	s3,s3,1
    800007f4:	013a07b3          	add	a5,s4,s3
    800007f8:	0007c503          	lbu	a0,0(a5)
    800007fc:	14050063          	beqz	a0,8000093c <printf+0x218>
    if(c != '%'){
    80000800:	ff5514e3          	bne	a0,s5,800007e8 <printf+0xc4>
    c = fmt[++i] & 0xff;
    80000804:	0019899b          	addw	s3,s3,1
    80000808:	013a07b3          	add	a5,s4,s3
    8000080c:	0007c783          	lbu	a5,0(a5)
    80000810:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80000814:	12078463          	beqz	a5,8000093c <printf+0x218>
    switch(c){
    80000818:	07778263          	beq	a5,s7,8000087c <printf+0x158>
    8000081c:	02fbfa63          	bgeu	s7,a5,80000850 <printf+0x12c>
    80000820:	0b978663          	beq	a5,s9,800008cc <printf+0x1a8>
    80000824:	07800713          	li	a4,120
    80000828:	0ee79c63          	bne	a5,a4,80000920 <printf+0x1fc>
      printint(va_arg(ap, int), 16, 1);
    8000082c:	f8843783          	ld	a5,-120(s0)
    80000830:	00878713          	add	a4,a5,8
    80000834:	f8e43423          	sd	a4,-120(s0)
    80000838:	00100613          	li	a2,1
    8000083c:	000d0593          	mv	a1,s10
    80000840:	0007a503          	lw	a0,0(a5)
    80000844:	00000097          	auipc	ra,0x0
    80000848:	da4080e7          	jalr	-604(ra) # 800005e8 <printint>
      break;
    8000084c:	fa5ff06f          	j	800007f0 <printf+0xcc>
    switch(c){
    80000850:	0d578063          	beq	a5,s5,80000910 <printf+0x1ec>
    80000854:	0d879663          	bne	a5,s8,80000920 <printf+0x1fc>
      printint(va_arg(ap, int), 10, 1);
    80000858:	f8843783          	ld	a5,-120(s0)
    8000085c:	00878713          	add	a4,a5,8
    80000860:	f8e43423          	sd	a4,-120(s0)
    80000864:	00100613          	li	a2,1
    80000868:	00a00593          	li	a1,10
    8000086c:	0007a503          	lw	a0,0(a5)
    80000870:	00000097          	auipc	ra,0x0
    80000874:	d78080e7          	jalr	-648(ra) # 800005e8 <printint>
      break;
    80000878:	f79ff06f          	j	800007f0 <printf+0xcc>
      printptr(va_arg(ap, uint64));
    8000087c:	f8843783          	ld	a5,-120(s0)
    80000880:	00878713          	add	a4,a5,8
    80000884:	f8e43423          	sd	a4,-120(s0)
    80000888:	0007b903          	ld	s2,0(a5)
  consputc('0');
    8000088c:	03000513          	li	a0,48
    80000890:	00000097          	auipc	ra,0x0
    80000894:	ac8080e7          	jalr	-1336(ra) # 80000358 <consputc>
  consputc('x');
    80000898:	07800513          	li	a0,120
    8000089c:	00000097          	auipc	ra,0x0
    800008a0:	abc080e7          	jalr	-1348(ra) # 80000358 <consputc>
    800008a4:	000d0493          	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800008a8:	03c95793          	srl	a5,s2,0x3c
    800008ac:	00fb07b3          	add	a5,s6,a5
    800008b0:	0007c503          	lbu	a0,0(a5)
    800008b4:	00000097          	auipc	ra,0x0
    800008b8:	aa4080e7          	jalr	-1372(ra) # 80000358 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800008bc:	00491913          	sll	s2,s2,0x4
    800008c0:	fff4849b          	addw	s1,s1,-1
    800008c4:	fe0492e3          	bnez	s1,800008a8 <printf+0x184>
    800008c8:	f29ff06f          	j	800007f0 <printf+0xcc>
      if((s = va_arg(ap, char*)) == 0)
    800008cc:	f8843783          	ld	a5,-120(s0)
    800008d0:	00878713          	add	a4,a5,8
    800008d4:	f8e43423          	sd	a4,-120(s0)
    800008d8:	0007b483          	ld	s1,0(a5)
    800008dc:	02048263          	beqz	s1,80000900 <printf+0x1dc>
      for(; *s; s++)
    800008e0:	0004c503          	lbu	a0,0(s1)
    800008e4:	f00506e3          	beqz	a0,800007f0 <printf+0xcc>
        consputc(*s);
    800008e8:	00000097          	auipc	ra,0x0
    800008ec:	a70080e7          	jalr	-1424(ra) # 80000358 <consputc>
      for(; *s; s++)
    800008f0:	00148493          	add	s1,s1,1
    800008f4:	0004c503          	lbu	a0,0(s1)
    800008f8:	fe0518e3          	bnez	a0,800008e8 <printf+0x1c4>
    800008fc:	ef5ff06f          	j	800007f0 <printf+0xcc>
        s = "(null)";
    80000900:	00009497          	auipc	s1,0x9
    80000904:	72048493          	add	s1,s1,1824 # 8000a020 <etext+0x20>
      for(; *s; s++)
    80000908:	02800513          	li	a0,40
    8000090c:	fddff06f          	j	800008e8 <printf+0x1c4>
      consputc('%');
    80000910:	000a8513          	mv	a0,s5
    80000914:	00000097          	auipc	ra,0x0
    80000918:	a44080e7          	jalr	-1468(ra) # 80000358 <consputc>
      break;
    8000091c:	ed5ff06f          	j	800007f0 <printf+0xcc>
      consputc('%');
    80000920:	000a8513          	mv	a0,s5
    80000924:	00000097          	auipc	ra,0x0
    80000928:	a34080e7          	jalr	-1484(ra) # 80000358 <consputc>
      consputc(c);
    8000092c:	00048513          	mv	a0,s1
    80000930:	00000097          	auipc	ra,0x0
    80000934:	a28080e7          	jalr	-1496(ra) # 80000358 <consputc>
      break;
    80000938:	eb9ff06f          	j	800007f0 <printf+0xcc>
  if(locking)
    8000093c:	040d9063          	bnez	s11,8000097c <printf+0x258>
}
    80000940:	07813083          	ld	ra,120(sp)
    80000944:	07013403          	ld	s0,112(sp)
    80000948:	06813483          	ld	s1,104(sp)
    8000094c:	06013903          	ld	s2,96(sp)
    80000950:	05813983          	ld	s3,88(sp)
    80000954:	05013a03          	ld	s4,80(sp)
    80000958:	04813a83          	ld	s5,72(sp)
    8000095c:	04013b03          	ld	s6,64(sp)
    80000960:	03813b83          	ld	s7,56(sp)
    80000964:	03013c03          	ld	s8,48(sp)
    80000968:	02813c83          	ld	s9,40(sp)
    8000096c:	02013d03          	ld	s10,32(sp)
    80000970:	01813d83          	ld	s11,24(sp)
    80000974:	0c010113          	add	sp,sp,192
    80000978:	00008067          	ret
    release(&pr.lock);
    8000097c:	00012517          	auipc	a0,0x12
    80000980:	1fc50513          	add	a0,a0,508 # 80012b78 <pr>
    80000984:	00000097          	auipc	ra,0x0
    80000988:	738080e7          	jalr	1848(ra) # 800010bc <release>
}
    8000098c:	fb5ff06f          	j	80000940 <printf+0x21c>

0000000080000990 <printfinit>:
    ;
}

void
printfinit(void)
{
    80000990:	fe010113          	add	sp,sp,-32
    80000994:	00113c23          	sd	ra,24(sp)
    80000998:	00813823          	sd	s0,16(sp)
    8000099c:	00913423          	sd	s1,8(sp)
    800009a0:	02010413          	add	s0,sp,32
  initlock(&pr.lock, "pr");
    800009a4:	00012497          	auipc	s1,0x12
    800009a8:	1d448493          	add	s1,s1,468 # 80012b78 <pr>
    800009ac:	00009597          	auipc	a1,0x9
    800009b0:	68c58593          	add	a1,a1,1676 # 8000a038 <etext+0x38>
    800009b4:	00048513          	mv	a0,s1
    800009b8:	00000097          	auipc	ra,0x0
    800009bc:	528080e7          	jalr	1320(ra) # 80000ee0 <initlock>
  pr.locking = 1;
    800009c0:	00100793          	li	a5,1
    800009c4:	00f4ac23          	sw	a5,24(s1)
}
    800009c8:	01813083          	ld	ra,24(sp)
    800009cc:	01013403          	ld	s0,16(sp)
    800009d0:	00813483          	ld	s1,8(sp)
    800009d4:	02010113          	add	sp,sp,32
    800009d8:	00008067          	ret

00000000800009dc <uartinit>:

void uartstart();

void
uartinit(void)
{
    800009dc:	ff010113          	add	sp,sp,-16
    800009e0:	00113423          	sd	ra,8(sp)
    800009e4:	00813023          	sd	s0,0(sp)
    800009e8:	01010413          	add	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800009ec:	100007b7          	lui	a5,0x10000
    800009f0:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800009f4:	f8000713          	li	a4,-128
    800009f8:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800009fc:	00300713          	li	a4,3
    80000a00:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80000a04:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80000a08:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80000a0c:	00700693          	li	a3,7
    80000a10:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80000a14:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80000a18:	00009597          	auipc	a1,0x9
    80000a1c:	64058593          	add	a1,a1,1600 # 8000a058 <digits+0x18>
    80000a20:	00012517          	auipc	a0,0x12
    80000a24:	17850513          	add	a0,a0,376 # 80012b98 <uart_tx_lock>
    80000a28:	00000097          	auipc	ra,0x0
    80000a2c:	4b8080e7          	jalr	1208(ra) # 80000ee0 <initlock>
}
    80000a30:	00813083          	ld	ra,8(sp)
    80000a34:	00013403          	ld	s0,0(sp)
    80000a38:	01010113          	add	sp,sp,16
    80000a3c:	00008067          	ret

0000000080000a40 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80000a40:	fe010113          	add	sp,sp,-32
    80000a44:	00113c23          	sd	ra,24(sp)
    80000a48:	00813823          	sd	s0,16(sp)
    80000a4c:	00913423          	sd	s1,8(sp)
    80000a50:	02010413          	add	s0,sp,32
    80000a54:	00050493          	mv	s1,a0
  push_off();
    80000a58:	00000097          	auipc	ra,0x0
    80000a5c:	4f8080e7          	jalr	1272(ra) # 80000f50 <push_off>

  if(panicked){
    80000a60:	0000a797          	auipc	a5,0xa
    80000a64:	ef07a783          	lw	a5,-272(a5) # 8000a950 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000a68:	10000737          	lui	a4,0x10000
  if(panicked){
    80000a6c:	00078463          	beqz	a5,80000a74 <uartputc_sync+0x34>
    for(;;)
    80000a70:	0000006f          	j	80000a70 <uartputc_sync+0x30>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000a74:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80000a78:	0207f793          	and	a5,a5,32
    80000a7c:	fe078ce3          	beqz	a5,80000a74 <uartputc_sync+0x34>
    ;
  WriteReg(THR, c);
    80000a80:	0ff4f513          	zext.b	a0,s1
    80000a84:	100007b7          	lui	a5,0x10000
    80000a88:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80000a8c:	00000097          	auipc	ra,0x0
    80000a90:	5b0080e7          	jalr	1456(ra) # 8000103c <pop_off>
}
    80000a94:	01813083          	ld	ra,24(sp)
    80000a98:	01013403          	ld	s0,16(sp)
    80000a9c:	00813483          	ld	s1,8(sp)
    80000aa0:	02010113          	add	sp,sp,32
    80000aa4:	00008067          	ret

0000000080000aa8 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80000aa8:	0000a797          	auipc	a5,0xa
    80000aac:	eb07b783          	ld	a5,-336(a5) # 8000a958 <uart_tx_r>
    80000ab0:	0000a717          	auipc	a4,0xa
    80000ab4:	eb073703          	ld	a4,-336(a4) # 8000a960 <uart_tx_w>
    80000ab8:	0af70263          	beq	a4,a5,80000b5c <uartstart+0xb4>
{
    80000abc:	fc010113          	add	sp,sp,-64
    80000ac0:	02113c23          	sd	ra,56(sp)
    80000ac4:	02813823          	sd	s0,48(sp)
    80000ac8:	02913423          	sd	s1,40(sp)
    80000acc:	03213023          	sd	s2,32(sp)
    80000ad0:	01313c23          	sd	s3,24(sp)
    80000ad4:	01413823          	sd	s4,16(sp)
    80000ad8:	01513423          	sd	s5,8(sp)
    80000adc:	04010413          	add	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000ae0:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80000ae4:	00012a17          	auipc	s4,0x12
    80000ae8:	0b4a0a13          	add	s4,s4,180 # 80012b98 <uart_tx_lock>
    uart_tx_r += 1;
    80000aec:	0000a497          	auipc	s1,0xa
    80000af0:	e6c48493          	add	s1,s1,-404 # 8000a958 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80000af4:	0000a997          	auipc	s3,0xa
    80000af8:	e6c98993          	add	s3,s3,-404 # 8000a960 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000afc:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80000b00:	02077713          	and	a4,a4,32
    80000b04:	02070a63          	beqz	a4,80000b38 <uartstart+0x90>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80000b08:	01f7f713          	and	a4,a5,31
    80000b0c:	00ea0733          	add	a4,s4,a4
    80000b10:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80000b14:	00178793          	add	a5,a5,1
    80000b18:	00f4b023          	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80000b1c:	00048513          	mv	a0,s1
    80000b20:	00002097          	auipc	ra,0x2
    80000b24:	30c080e7          	jalr	780(ra) # 80002e2c <wakeup>
    
    WriteReg(THR, c);
    80000b28:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80000b2c:	0004b783          	ld	a5,0(s1)
    80000b30:	0009b703          	ld	a4,0(s3)
    80000b34:	fcf714e3          	bne	a4,a5,80000afc <uartstart+0x54>
  }
}
    80000b38:	03813083          	ld	ra,56(sp)
    80000b3c:	03013403          	ld	s0,48(sp)
    80000b40:	02813483          	ld	s1,40(sp)
    80000b44:	02013903          	ld	s2,32(sp)
    80000b48:	01813983          	ld	s3,24(sp)
    80000b4c:	01013a03          	ld	s4,16(sp)
    80000b50:	00813a83          	ld	s5,8(sp)
    80000b54:	04010113          	add	sp,sp,64
    80000b58:	00008067          	ret
    80000b5c:	00008067          	ret

0000000080000b60 <uartputc>:
{
    80000b60:	fd010113          	add	sp,sp,-48
    80000b64:	02113423          	sd	ra,40(sp)
    80000b68:	02813023          	sd	s0,32(sp)
    80000b6c:	00913c23          	sd	s1,24(sp)
    80000b70:	01213823          	sd	s2,16(sp)
    80000b74:	01313423          	sd	s3,8(sp)
    80000b78:	01413023          	sd	s4,0(sp)
    80000b7c:	03010413          	add	s0,sp,48
    80000b80:	00050a13          	mv	s4,a0
  acquire(&uart_tx_lock);
    80000b84:	00012517          	auipc	a0,0x12
    80000b88:	01450513          	add	a0,a0,20 # 80012b98 <uart_tx_lock>
    80000b8c:	00000097          	auipc	ra,0x0
    80000b90:	438080e7          	jalr	1080(ra) # 80000fc4 <acquire>
  if(panicked){
    80000b94:	0000a797          	auipc	a5,0xa
    80000b98:	dbc7a783          	lw	a5,-580(a5) # 8000a950 <panicked>
    80000b9c:	0a079463          	bnez	a5,80000c44 <uartputc+0xe4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000ba0:	0000a717          	auipc	a4,0xa
    80000ba4:	dc073703          	ld	a4,-576(a4) # 8000a960 <uart_tx_w>
    80000ba8:	0000a797          	auipc	a5,0xa
    80000bac:	db07b783          	ld	a5,-592(a5) # 8000a958 <uart_tx_r>
    80000bb0:	02078793          	add	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80000bb4:	00012997          	auipc	s3,0x12
    80000bb8:	fe498993          	add	s3,s3,-28 # 80012b98 <uart_tx_lock>
    80000bbc:	0000a497          	auipc	s1,0xa
    80000bc0:	d9c48493          	add	s1,s1,-612 # 8000a958 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000bc4:	0000a917          	auipc	s2,0xa
    80000bc8:	d9c90913          	add	s2,s2,-612 # 8000a960 <uart_tx_w>
    80000bcc:	02e79263          	bne	a5,a4,80000bf0 <uartputc+0x90>
    sleep(&uart_tx_r, &uart_tx_lock);
    80000bd0:	00098593          	mv	a1,s3
    80000bd4:	00048513          	mv	a0,s1
    80000bd8:	00002097          	auipc	ra,0x2
    80000bdc:	1c4080e7          	jalr	452(ra) # 80002d9c <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000be0:	00093703          	ld	a4,0(s2)
    80000be4:	0004b783          	ld	a5,0(s1)
    80000be8:	02078793          	add	a5,a5,32
    80000bec:	fee782e3          	beq	a5,a4,80000bd0 <uartputc+0x70>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000bf0:	00012497          	auipc	s1,0x12
    80000bf4:	fa848493          	add	s1,s1,-88 # 80012b98 <uart_tx_lock>
    80000bf8:	01f77793          	and	a5,a4,31
    80000bfc:	00f487b3          	add	a5,s1,a5
    80000c00:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80000c04:	00170713          	add	a4,a4,1
    80000c08:	0000a797          	auipc	a5,0xa
    80000c0c:	d4e7bc23          	sd	a4,-680(a5) # 8000a960 <uart_tx_w>
  uartstart();
    80000c10:	00000097          	auipc	ra,0x0
    80000c14:	e98080e7          	jalr	-360(ra) # 80000aa8 <uartstart>
  release(&uart_tx_lock);
    80000c18:	00048513          	mv	a0,s1
    80000c1c:	00000097          	auipc	ra,0x0
    80000c20:	4a0080e7          	jalr	1184(ra) # 800010bc <release>
}
    80000c24:	02813083          	ld	ra,40(sp)
    80000c28:	02013403          	ld	s0,32(sp)
    80000c2c:	01813483          	ld	s1,24(sp)
    80000c30:	01013903          	ld	s2,16(sp)
    80000c34:	00813983          	ld	s3,8(sp)
    80000c38:	00013a03          	ld	s4,0(sp)
    80000c3c:	03010113          	add	sp,sp,48
    80000c40:	00008067          	ret
    for(;;)
    80000c44:	0000006f          	j	80000c44 <uartputc+0xe4>

0000000080000c48 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80000c48:	ff010113          	add	sp,sp,-16
    80000c4c:	00813423          	sd	s0,8(sp)
    80000c50:	01010413          	add	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80000c54:	100007b7          	lui	a5,0x10000
    80000c58:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80000c5c:	0017f793          	and	a5,a5,1
    80000c60:	00078c63          	beqz	a5,80000c78 <uartgetc+0x30>
    // input data is ready.
    return ReadReg(RHR);
    80000c64:	100007b7          	lui	a5,0x10000
    80000c68:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80000c6c:	00813403          	ld	s0,8(sp)
    80000c70:	01010113          	add	sp,sp,16
    80000c74:	00008067          	ret
    return -1;
    80000c78:	fff00513          	li	a0,-1
    80000c7c:	ff1ff06f          	j	80000c6c <uartgetc+0x24>

0000000080000c80 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80000c80:	fe010113          	add	sp,sp,-32
    80000c84:	00113c23          	sd	ra,24(sp)
    80000c88:	00813823          	sd	s0,16(sp)
    80000c8c:	00913423          	sd	s1,8(sp)
    80000c90:	02010413          	add	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000c94:	fff00493          	li	s1,-1
    80000c98:	00c0006f          	j	80000ca4 <uartintr+0x24>
      break;
    consoleintr(c);
    80000c9c:	fffff097          	auipc	ra,0xfffff
    80000ca0:	714080e7          	jalr	1812(ra) # 800003b0 <consoleintr>
    int c = uartgetc();
    80000ca4:	00000097          	auipc	ra,0x0
    80000ca8:	fa4080e7          	jalr	-92(ra) # 80000c48 <uartgetc>
    if(c == -1)
    80000cac:	fe9518e3          	bne	a0,s1,80000c9c <uartintr+0x1c>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80000cb0:	00012497          	auipc	s1,0x12
    80000cb4:	ee848493          	add	s1,s1,-280 # 80012b98 <uart_tx_lock>
    80000cb8:	00048513          	mv	a0,s1
    80000cbc:	00000097          	auipc	ra,0x0
    80000cc0:	308080e7          	jalr	776(ra) # 80000fc4 <acquire>
  uartstart();
    80000cc4:	00000097          	auipc	ra,0x0
    80000cc8:	de4080e7          	jalr	-540(ra) # 80000aa8 <uartstart>
  release(&uart_tx_lock);
    80000ccc:	00048513          	mv	a0,s1
    80000cd0:	00000097          	auipc	ra,0x0
    80000cd4:	3ec080e7          	jalr	1004(ra) # 800010bc <release>
}
    80000cd8:	01813083          	ld	ra,24(sp)
    80000cdc:	01013403          	ld	s0,16(sp)
    80000ce0:	00813483          	ld	s1,8(sp)
    80000ce4:	02010113          	add	sp,sp,32
    80000ce8:	00008067          	ret

0000000080000cec <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000cec:	fe010113          	add	sp,sp,-32
    80000cf0:	00113c23          	sd	ra,24(sp)
    80000cf4:	00813823          	sd	s0,16(sp)
    80000cf8:	00913423          	sd	s1,8(sp)
    80000cfc:	01213023          	sd	s2,0(sp)
    80000d00:	02010413          	add	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000d04:	03451793          	sll	a5,a0,0x34
    80000d08:	06079a63          	bnez	a5,80000d7c <kfree+0x90>
    80000d0c:	00050493          	mv	s1,a0
    80000d10:	00023797          	auipc	a5,0x23
    80000d14:	0f078793          	add	a5,a5,240 # 80023e00 <end>
    80000d18:	06f56263          	bltu	a0,a5,80000d7c <kfree+0x90>
    80000d1c:	01100793          	li	a5,17
    80000d20:	01b79793          	sll	a5,a5,0x1b
    80000d24:	04f57c63          	bgeu	a0,a5,80000d7c <kfree+0x90>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000d28:	00001637          	lui	a2,0x1
    80000d2c:	00100593          	li	a1,1
    80000d30:	00000097          	auipc	ra,0x0
    80000d34:	3ec080e7          	jalr	1004(ra) # 8000111c <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000d38:	00012917          	auipc	s2,0x12
    80000d3c:	e9890913          	add	s2,s2,-360 # 80012bd0 <kmem>
    80000d40:	00090513          	mv	a0,s2
    80000d44:	00000097          	auipc	ra,0x0
    80000d48:	280080e7          	jalr	640(ra) # 80000fc4 <acquire>
  r->next = kmem.freelist;
    80000d4c:	01893783          	ld	a5,24(s2)
    80000d50:	00f4b023          	sd	a5,0(s1)
  kmem.freelist = r;
    80000d54:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000d58:	00090513          	mv	a0,s2
    80000d5c:	00000097          	auipc	ra,0x0
    80000d60:	360080e7          	jalr	864(ra) # 800010bc <release>
}
    80000d64:	01813083          	ld	ra,24(sp)
    80000d68:	01013403          	ld	s0,16(sp)
    80000d6c:	00813483          	ld	s1,8(sp)
    80000d70:	00013903          	ld	s2,0(sp)
    80000d74:	02010113          	add	sp,sp,32
    80000d78:	00008067          	ret
    panic("kfree");
    80000d7c:	00009517          	auipc	a0,0x9
    80000d80:	2e450513          	add	a0,a0,740 # 8000a060 <digits+0x20>
    80000d84:	00000097          	auipc	ra,0x0
    80000d88:	944080e7          	jalr	-1724(ra) # 800006c8 <panic>

0000000080000d8c <freerange>:
{
    80000d8c:	fd010113          	add	sp,sp,-48
    80000d90:	02113423          	sd	ra,40(sp)
    80000d94:	02813023          	sd	s0,32(sp)
    80000d98:	00913c23          	sd	s1,24(sp)
    80000d9c:	01213823          	sd	s2,16(sp)
    80000da0:	01313423          	sd	s3,8(sp)
    80000da4:	01413023          	sd	s4,0(sp)
    80000da8:	03010413          	add	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000dac:	000017b7          	lui	a5,0x1
    80000db0:	fff78713          	add	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000db4:	00e504b3          	add	s1,a0,a4
    80000db8:	fffff737          	lui	a4,0xfffff
    80000dbc:	00e4f4b3          	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000dc0:	00f484b3          	add	s1,s1,a5
    80000dc4:	0295e263          	bltu	a1,s1,80000de8 <freerange+0x5c>
    80000dc8:	00058913          	mv	s2,a1
    kfree(p);
    80000dcc:	fffffa37          	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000dd0:	000019b7          	lui	s3,0x1
    kfree(p);
    80000dd4:	01448533          	add	a0,s1,s4
    80000dd8:	00000097          	auipc	ra,0x0
    80000ddc:	f14080e7          	jalr	-236(ra) # 80000cec <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000de0:	013484b3          	add	s1,s1,s3
    80000de4:	fe9978e3          	bgeu	s2,s1,80000dd4 <freerange+0x48>
}
    80000de8:	02813083          	ld	ra,40(sp)
    80000dec:	02013403          	ld	s0,32(sp)
    80000df0:	01813483          	ld	s1,24(sp)
    80000df4:	01013903          	ld	s2,16(sp)
    80000df8:	00813983          	ld	s3,8(sp)
    80000dfc:	00013a03          	ld	s4,0(sp)
    80000e00:	03010113          	add	sp,sp,48
    80000e04:	00008067          	ret

0000000080000e08 <kinit>:
{
    80000e08:	ff010113          	add	sp,sp,-16
    80000e0c:	00113423          	sd	ra,8(sp)
    80000e10:	00813023          	sd	s0,0(sp)
    80000e14:	01010413          	add	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000e18:	00009597          	auipc	a1,0x9
    80000e1c:	25058593          	add	a1,a1,592 # 8000a068 <digits+0x28>
    80000e20:	00012517          	auipc	a0,0x12
    80000e24:	db050513          	add	a0,a0,-592 # 80012bd0 <kmem>
    80000e28:	00000097          	auipc	ra,0x0
    80000e2c:	0b8080e7          	jalr	184(ra) # 80000ee0 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000e30:	01100593          	li	a1,17
    80000e34:	01b59593          	sll	a1,a1,0x1b
    80000e38:	00023517          	auipc	a0,0x23
    80000e3c:	fc850513          	add	a0,a0,-56 # 80023e00 <end>
    80000e40:	00000097          	auipc	ra,0x0
    80000e44:	f4c080e7          	jalr	-180(ra) # 80000d8c <freerange>
}
    80000e48:	00813083          	ld	ra,8(sp)
    80000e4c:	00013403          	ld	s0,0(sp)
    80000e50:	01010113          	add	sp,sp,16
    80000e54:	00008067          	ret

0000000080000e58 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000e58:	fe010113          	add	sp,sp,-32
    80000e5c:	00113c23          	sd	ra,24(sp)
    80000e60:	00813823          	sd	s0,16(sp)
    80000e64:	00913423          	sd	s1,8(sp)
    80000e68:	02010413          	add	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000e6c:	00012497          	auipc	s1,0x12
    80000e70:	d6448493          	add	s1,s1,-668 # 80012bd0 <kmem>
    80000e74:	00048513          	mv	a0,s1
    80000e78:	00000097          	auipc	ra,0x0
    80000e7c:	14c080e7          	jalr	332(ra) # 80000fc4 <acquire>
  r = kmem.freelist;
    80000e80:	0184b483          	ld	s1,24(s1)
  if(r)
    80000e84:	04048463          	beqz	s1,80000ecc <kalloc+0x74>
    kmem.freelist = r->next;
    80000e88:	0004b783          	ld	a5,0(s1)
    80000e8c:	00012517          	auipc	a0,0x12
    80000e90:	d4450513          	add	a0,a0,-700 # 80012bd0 <kmem>
    80000e94:	00f53c23          	sd	a5,24(a0)
  release(&kmem.lock);
    80000e98:	00000097          	auipc	ra,0x0
    80000e9c:	224080e7          	jalr	548(ra) # 800010bc <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000ea0:	00001637          	lui	a2,0x1
    80000ea4:	00500593          	li	a1,5
    80000ea8:	00048513          	mv	a0,s1
    80000eac:	00000097          	auipc	ra,0x0
    80000eb0:	270080e7          	jalr	624(ra) # 8000111c <memset>
  return (void*)r;
}
    80000eb4:	00048513          	mv	a0,s1
    80000eb8:	01813083          	ld	ra,24(sp)
    80000ebc:	01013403          	ld	s0,16(sp)
    80000ec0:	00813483          	ld	s1,8(sp)
    80000ec4:	02010113          	add	sp,sp,32
    80000ec8:	00008067          	ret
  release(&kmem.lock);
    80000ecc:	00012517          	auipc	a0,0x12
    80000ed0:	d0450513          	add	a0,a0,-764 # 80012bd0 <kmem>
    80000ed4:	00000097          	auipc	ra,0x0
    80000ed8:	1e8080e7          	jalr	488(ra) # 800010bc <release>
  if(r)
    80000edc:	fd9ff06f          	j	80000eb4 <kalloc+0x5c>

0000000080000ee0 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000ee0:	ff010113          	add	sp,sp,-16
    80000ee4:	00813423          	sd	s0,8(sp)
    80000ee8:	01010413          	add	s0,sp,16
  lk->name = name;
    80000eec:	00b53423          	sd	a1,8(a0)
  lk->locked = 0;
    80000ef0:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000ef4:	00053823          	sd	zero,16(a0)
}
    80000ef8:	00813403          	ld	s0,8(sp)
    80000efc:	01010113          	add	sp,sp,16
    80000f00:	00008067          	ret

0000000080000f04 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000f04:	00052783          	lw	a5,0(a0)
    80000f08:	00079663          	bnez	a5,80000f14 <holding+0x10>
    80000f0c:	00000513          	li	a0,0
  return r;
}
    80000f10:	00008067          	ret
{
    80000f14:	fe010113          	add	sp,sp,-32
    80000f18:	00113c23          	sd	ra,24(sp)
    80000f1c:	00813823          	sd	s0,16(sp)
    80000f20:	00913423          	sd	s1,8(sp)
    80000f24:	02010413          	add	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000f28:	01053483          	ld	s1,16(a0)
    80000f2c:	00001097          	auipc	ra,0x1
    80000f30:	4f8080e7          	jalr	1272(ra) # 80002424 <mycpu>
    80000f34:	40a48533          	sub	a0,s1,a0
    80000f38:	00153513          	seqz	a0,a0
}
    80000f3c:	01813083          	ld	ra,24(sp)
    80000f40:	01013403          	ld	s0,16(sp)
    80000f44:	00813483          	ld	s1,8(sp)
    80000f48:	02010113          	add	sp,sp,32
    80000f4c:	00008067          	ret

0000000080000f50 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000f50:	fe010113          	add	sp,sp,-32
    80000f54:	00113c23          	sd	ra,24(sp)
    80000f58:	00813823          	sd	s0,16(sp)
    80000f5c:	00913423          	sd	s1,8(sp)
    80000f60:	02010413          	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000f64:	100024f3          	csrr	s1,sstatus
    80000f68:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000f6c:	ffd7f793          	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000f70:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000f74:	00001097          	auipc	ra,0x1
    80000f78:	4b0080e7          	jalr	1200(ra) # 80002424 <mycpu>
    80000f7c:	07852783          	lw	a5,120(a0)
    80000f80:	02078663          	beqz	a5,80000fac <push_off+0x5c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000f84:	00001097          	auipc	ra,0x1
    80000f88:	4a0080e7          	jalr	1184(ra) # 80002424 <mycpu>
    80000f8c:	07852783          	lw	a5,120(a0)
    80000f90:	0017879b          	addw	a5,a5,1
    80000f94:	06f52c23          	sw	a5,120(a0)
}
    80000f98:	01813083          	ld	ra,24(sp)
    80000f9c:	01013403          	ld	s0,16(sp)
    80000fa0:	00813483          	ld	s1,8(sp)
    80000fa4:	02010113          	add	sp,sp,32
    80000fa8:	00008067          	ret
    mycpu()->intena = old;
    80000fac:	00001097          	auipc	ra,0x1
    80000fb0:	478080e7          	jalr	1144(ra) # 80002424 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000fb4:	0014d493          	srl	s1,s1,0x1
    80000fb8:	0014f493          	and	s1,s1,1
    80000fbc:	06952e23          	sw	s1,124(a0)
    80000fc0:	fc5ff06f          	j	80000f84 <push_off+0x34>

0000000080000fc4 <acquire>:
{
    80000fc4:	fe010113          	add	sp,sp,-32
    80000fc8:	00113c23          	sd	ra,24(sp)
    80000fcc:	00813823          	sd	s0,16(sp)
    80000fd0:	00913423          	sd	s1,8(sp)
    80000fd4:	02010413          	add	s0,sp,32
    80000fd8:	00050493          	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000fdc:	00000097          	auipc	ra,0x0
    80000fe0:	f74080e7          	jalr	-140(ra) # 80000f50 <push_off>
  if(holding(lk))
    80000fe4:	00048513          	mv	a0,s1
    80000fe8:	00000097          	auipc	ra,0x0
    80000fec:	f1c080e7          	jalr	-228(ra) # 80000f04 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000ff0:	00100713          	li	a4,1
  if(holding(lk))
    80000ff4:	02051c63          	bnez	a0,8000102c <acquire+0x68>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000ff8:	00070793          	mv	a5,a4
    80000ffc:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80001000:	0007879b          	sext.w	a5,a5
    80001004:	fe079ae3          	bnez	a5,80000ff8 <acquire+0x34>
  __sync_synchronize();
    80001008:	0ff0000f          	fence
  lk->cpu = mycpu();
    8000100c:	00001097          	auipc	ra,0x1
    80001010:	418080e7          	jalr	1048(ra) # 80002424 <mycpu>
    80001014:	00a4b823          	sd	a0,16(s1)
}
    80001018:	01813083          	ld	ra,24(sp)
    8000101c:	01013403          	ld	s0,16(sp)
    80001020:	00813483          	ld	s1,8(sp)
    80001024:	02010113          	add	sp,sp,32
    80001028:	00008067          	ret
    panic("acquire");
    8000102c:	00009517          	auipc	a0,0x9
    80001030:	04450513          	add	a0,a0,68 # 8000a070 <digits+0x30>
    80001034:	fffff097          	auipc	ra,0xfffff
    80001038:	694080e7          	jalr	1684(ra) # 800006c8 <panic>

000000008000103c <pop_off>:

void
pop_off(void)
{
    8000103c:	ff010113          	add	sp,sp,-16
    80001040:	00113423          	sd	ra,8(sp)
    80001044:	00813023          	sd	s0,0(sp)
    80001048:	01010413          	add	s0,sp,16
  struct cpu *c = mycpu();
    8000104c:	00001097          	auipc	ra,0x1
    80001050:	3d8080e7          	jalr	984(ra) # 80002424 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001054:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001058:	0027f793          	and	a5,a5,2
  if(intr_get())
    8000105c:	04079063          	bnez	a5,8000109c <pop_off+0x60>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80001060:	07852783          	lw	a5,120(a0)
    80001064:	04f05463          	blez	a5,800010ac <pop_off+0x70>
    panic("pop_off");
  c->noff -= 1;
    80001068:	fff7879b          	addw	a5,a5,-1
    8000106c:	0007871b          	sext.w	a4,a5
    80001070:	06f52c23          	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80001074:	00071c63          	bnez	a4,8000108c <pop_off+0x50>
    80001078:	07c52783          	lw	a5,124(a0)
    8000107c:	00078863          	beqz	a5,8000108c <pop_off+0x50>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001080:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001084:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001088:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000108c:	00813083          	ld	ra,8(sp)
    80001090:	00013403          	ld	s0,0(sp)
    80001094:	01010113          	add	sp,sp,16
    80001098:	00008067          	ret
    panic("pop_off - interruptible");
    8000109c:	00009517          	auipc	a0,0x9
    800010a0:	fdc50513          	add	a0,a0,-36 # 8000a078 <digits+0x38>
    800010a4:	fffff097          	auipc	ra,0xfffff
    800010a8:	624080e7          	jalr	1572(ra) # 800006c8 <panic>
    panic("pop_off");
    800010ac:	00009517          	auipc	a0,0x9
    800010b0:	fe450513          	add	a0,a0,-28 # 8000a090 <digits+0x50>
    800010b4:	fffff097          	auipc	ra,0xfffff
    800010b8:	614080e7          	jalr	1556(ra) # 800006c8 <panic>

00000000800010bc <release>:
{
    800010bc:	fe010113          	add	sp,sp,-32
    800010c0:	00113c23          	sd	ra,24(sp)
    800010c4:	00813823          	sd	s0,16(sp)
    800010c8:	00913423          	sd	s1,8(sp)
    800010cc:	02010413          	add	s0,sp,32
    800010d0:	00050493          	mv	s1,a0
  if(!holding(lk))
    800010d4:	00000097          	auipc	ra,0x0
    800010d8:	e30080e7          	jalr	-464(ra) # 80000f04 <holding>
    800010dc:	02050863          	beqz	a0,8000110c <release+0x50>
  lk->cpu = 0;
    800010e0:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800010e4:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800010e8:	0f50000f          	fence	iorw,ow
    800010ec:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800010f0:	00000097          	auipc	ra,0x0
    800010f4:	f4c080e7          	jalr	-180(ra) # 8000103c <pop_off>
}
    800010f8:	01813083          	ld	ra,24(sp)
    800010fc:	01013403          	ld	s0,16(sp)
    80001100:	00813483          	ld	s1,8(sp)
    80001104:	02010113          	add	sp,sp,32
    80001108:	00008067          	ret
    panic("release");
    8000110c:	00009517          	auipc	a0,0x9
    80001110:	f8c50513          	add	a0,a0,-116 # 8000a098 <digits+0x58>
    80001114:	fffff097          	auipc	ra,0xfffff
    80001118:	5b4080e7          	jalr	1460(ra) # 800006c8 <panic>

000000008000111c <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000111c:	ff010113          	add	sp,sp,-16
    80001120:	00813423          	sd	s0,8(sp)
    80001124:	01010413          	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80001128:	02060063          	beqz	a2,80001148 <memset+0x2c>
    8000112c:	00050793          	mv	a5,a0
    80001130:	02061613          	sll	a2,a2,0x20
    80001134:	02065613          	srl	a2,a2,0x20
    80001138:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    8000113c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80001140:	00178793          	add	a5,a5,1
    80001144:	fee79ce3          	bne	a5,a4,8000113c <memset+0x20>
  }
  return dst;
}
    80001148:	00813403          	ld	s0,8(sp)
    8000114c:	01010113          	add	sp,sp,16
    80001150:	00008067          	ret

0000000080001154 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80001154:	ff010113          	add	sp,sp,-16
    80001158:	00813423          	sd	s0,8(sp)
    8000115c:	01010413          	add	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80001160:	04060463          	beqz	a2,800011a8 <memcmp+0x54>
    80001164:	fff6069b          	addw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80001168:	02069693          	sll	a3,a3,0x20
    8000116c:	0206d693          	srl	a3,a3,0x20
    80001170:	00168693          	add	a3,a3,1
    80001174:	00d506b3          	add	a3,a0,a3
    if(*s1 != *s2)
    80001178:	00054783          	lbu	a5,0(a0)
    8000117c:	0005c703          	lbu	a4,0(a1)
    80001180:	00e79c63          	bne	a5,a4,80001198 <memcmp+0x44>
      return *s1 - *s2;
    s1++, s2++;
    80001184:	00150513          	add	a0,a0,1
    80001188:	00158593          	add	a1,a1,1
  while(n-- > 0){
    8000118c:	fed516e3          	bne	a0,a3,80001178 <memcmp+0x24>
  }

  return 0;
    80001190:	00000513          	li	a0,0
    80001194:	0080006f          	j	8000119c <memcmp+0x48>
      return *s1 - *s2;
    80001198:	40e7853b          	subw	a0,a5,a4
}
    8000119c:	00813403          	ld	s0,8(sp)
    800011a0:	01010113          	add	sp,sp,16
    800011a4:	00008067          	ret
  return 0;
    800011a8:	00000513          	li	a0,0
    800011ac:	ff1ff06f          	j	8000119c <memcmp+0x48>

00000000800011b0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800011b0:	ff010113          	add	sp,sp,-16
    800011b4:	00813423          	sd	s0,8(sp)
    800011b8:	01010413          	add	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800011bc:	02060663          	beqz	a2,800011e8 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800011c0:	02a5ea63          	bltu	a1,a0,800011f4 <memmove+0x44>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800011c4:	02061613          	sll	a2,a2,0x20
    800011c8:	02065613          	srl	a2,a2,0x20
    800011cc:	00c587b3          	add	a5,a1,a2
{
    800011d0:	00050713          	mv	a4,a0
      *d++ = *s++;
    800011d4:	00158593          	add	a1,a1,1
    800011d8:	00170713          	add	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdb201>
    800011dc:	fff5c683          	lbu	a3,-1(a1)
    800011e0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800011e4:	fef598e3          	bne	a1,a5,800011d4 <memmove+0x24>

  return dst;
}
    800011e8:	00813403          	ld	s0,8(sp)
    800011ec:	01010113          	add	sp,sp,16
    800011f0:	00008067          	ret
  if(s < d && s + n > d){
    800011f4:	02061693          	sll	a3,a2,0x20
    800011f8:	0206d693          	srl	a3,a3,0x20
    800011fc:	00d58733          	add	a4,a1,a3
    80001200:	fce572e3          	bgeu	a0,a4,800011c4 <memmove+0x14>
    d += n;
    80001204:	00d506b3          	add	a3,a0,a3
    while(n-- > 0)
    80001208:	fff6079b          	addw	a5,a2,-1
    8000120c:	02079793          	sll	a5,a5,0x20
    80001210:	0207d793          	srl	a5,a5,0x20
    80001214:	fff7c793          	not	a5,a5
    80001218:	00f707b3          	add	a5,a4,a5
      *--d = *--s;
    8000121c:	fff70713          	add	a4,a4,-1
    80001220:	fff68693          	add	a3,a3,-1
    80001224:	00074603          	lbu	a2,0(a4)
    80001228:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000122c:	fee798e3          	bne	a5,a4,8000121c <memmove+0x6c>
    80001230:	fb9ff06f          	j	800011e8 <memmove+0x38>

0000000080001234 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80001234:	ff010113          	add	sp,sp,-16
    80001238:	00113423          	sd	ra,8(sp)
    8000123c:	00813023          	sd	s0,0(sp)
    80001240:	01010413          	add	s0,sp,16
  return memmove(dst, src, n);
    80001244:	00000097          	auipc	ra,0x0
    80001248:	f6c080e7          	jalr	-148(ra) # 800011b0 <memmove>
}
    8000124c:	00813083          	ld	ra,8(sp)
    80001250:	00013403          	ld	s0,0(sp)
    80001254:	01010113          	add	sp,sp,16
    80001258:	00008067          	ret

000000008000125c <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000125c:	ff010113          	add	sp,sp,-16
    80001260:	00813423          	sd	s0,8(sp)
    80001264:	01010413          	add	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80001268:	02060663          	beqz	a2,80001294 <strncmp+0x38>
    8000126c:	00054783          	lbu	a5,0(a0)
    80001270:	02078663          	beqz	a5,8000129c <strncmp+0x40>
    80001274:	0005c703          	lbu	a4,0(a1)
    80001278:	02f71263          	bne	a4,a5,8000129c <strncmp+0x40>
    n--, p++, q++;
    8000127c:	fff6061b          	addw	a2,a2,-1
    80001280:	00150513          	add	a0,a0,1
    80001284:	00158593          	add	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80001288:	fe0612e3          	bnez	a2,8000126c <strncmp+0x10>
  if(n == 0)
    return 0;
    8000128c:	00000513          	li	a0,0
    80001290:	01c0006f          	j	800012ac <strncmp+0x50>
    80001294:	00000513          	li	a0,0
    80001298:	0140006f          	j	800012ac <strncmp+0x50>
  if(n == 0)
    8000129c:	00060e63          	beqz	a2,800012b8 <strncmp+0x5c>
  return (uchar)*p - (uchar)*q;
    800012a0:	00054503          	lbu	a0,0(a0)
    800012a4:	0005c783          	lbu	a5,0(a1)
    800012a8:	40f5053b          	subw	a0,a0,a5
}
    800012ac:	00813403          	ld	s0,8(sp)
    800012b0:	01010113          	add	sp,sp,16
    800012b4:	00008067          	ret
    return 0;
    800012b8:	00000513          	li	a0,0
    800012bc:	ff1ff06f          	j	800012ac <strncmp+0x50>

00000000800012c0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800012c0:	ff010113          	add	sp,sp,-16
    800012c4:	00813423          	sd	s0,8(sp)
    800012c8:	01010413          	add	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800012cc:	00050793          	mv	a5,a0
    800012d0:	00060693          	mv	a3,a2
    800012d4:	fff6061b          	addw	a2,a2,-1
    800012d8:	00d05c63          	blez	a3,800012f0 <strncpy+0x30>
    800012dc:	00178793          	add	a5,a5,1
    800012e0:	0005c703          	lbu	a4,0(a1)
    800012e4:	fee78fa3          	sb	a4,-1(a5)
    800012e8:	00158593          	add	a1,a1,1
    800012ec:	fe0712e3          	bnez	a4,800012d0 <strncpy+0x10>
    ;
  while(n-- > 0)
    800012f0:	00078713          	mv	a4,a5
    800012f4:	00d787bb          	addw	a5,a5,a3
    800012f8:	fff7879b          	addw	a5,a5,-1
    800012fc:	00c05a63          	blez	a2,80001310 <strncpy+0x50>
    *s++ = 0;
    80001300:	00170713          	add	a4,a4,1
    80001304:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80001308:	40e786bb          	subw	a3,a5,a4
    8000130c:	fed04ae3          	bgtz	a3,80001300 <strncpy+0x40>
  return os;
}
    80001310:	00813403          	ld	s0,8(sp)
    80001314:	01010113          	add	sp,sp,16
    80001318:	00008067          	ret

000000008000131c <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    8000131c:	ff010113          	add	sp,sp,-16
    80001320:	00813423          	sd	s0,8(sp)
    80001324:	01010413          	add	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80001328:	02c05a63          	blez	a2,8000135c <safestrcpy+0x40>
    8000132c:	fff6069b          	addw	a3,a2,-1
    80001330:	02069693          	sll	a3,a3,0x20
    80001334:	0206d693          	srl	a3,a3,0x20
    80001338:	00d586b3          	add	a3,a1,a3
    8000133c:	00050793          	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80001340:	00d58c63          	beq	a1,a3,80001358 <safestrcpy+0x3c>
    80001344:	00158593          	add	a1,a1,1
    80001348:	00178793          	add	a5,a5,1
    8000134c:	fff5c703          	lbu	a4,-1(a1)
    80001350:	fee78fa3          	sb	a4,-1(a5)
    80001354:	fe0716e3          	bnez	a4,80001340 <safestrcpy+0x24>
    ;
  *s = 0;
    80001358:	00078023          	sb	zero,0(a5)
  return os;
}
    8000135c:	00813403          	ld	s0,8(sp)
    80001360:	01010113          	add	sp,sp,16
    80001364:	00008067          	ret

0000000080001368 <strlen>:

int
strlen(const char *s)
{
    80001368:	ff010113          	add	sp,sp,-16
    8000136c:	00813423          	sd	s0,8(sp)
    80001370:	01010413          	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80001374:	00054783          	lbu	a5,0(a0)
    80001378:	02078863          	beqz	a5,800013a8 <strlen+0x40>
    8000137c:	00150513          	add	a0,a0,1
    80001380:	00050793          	mv	a5,a0
    80001384:	00078693          	mv	a3,a5
    80001388:	00178793          	add	a5,a5,1
    8000138c:	fff7c703          	lbu	a4,-1(a5)
    80001390:	fe071ae3          	bnez	a4,80001384 <strlen+0x1c>
    80001394:	40a6853b          	subw	a0,a3,a0
    80001398:	0015051b          	addw	a0,a0,1
    ;
  return n;
}
    8000139c:	00813403          	ld	s0,8(sp)
    800013a0:	01010113          	add	sp,sp,16
    800013a4:	00008067          	ret
  for(n = 0; s[n]; n++)
    800013a8:	00000513          	li	a0,0
    800013ac:	ff1ff06f          	j	8000139c <strlen+0x34>

00000000800013b0 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    800013b0:	ff010113          	add	sp,sp,-16
    800013b4:	00113423          	sd	ra,8(sp)
    800013b8:	00813023          	sd	s0,0(sp)
    800013bc:	01010413          	add	s0,sp,16
  if(cpuid() == 0){
    800013c0:	00001097          	auipc	ra,0x1
    800013c4:	044080e7          	jalr	68(ra) # 80002404 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    800013c8:	00009717          	auipc	a4,0x9
    800013cc:	5a070713          	add	a4,a4,1440 # 8000a968 <started>
  if(cpuid() == 0){
    800013d0:	04050063          	beqz	a0,80001410 <main+0x60>
    while(started == 0)
    800013d4:	00072783          	lw	a5,0(a4)
    800013d8:	0007879b          	sext.w	a5,a5
    800013dc:	fe078ce3          	beqz	a5,800013d4 <main+0x24>
      ;
    __sync_synchronize();
    800013e0:	0ff0000f          	fence
    kvminithart();    // turn on paging
    800013e4:	00000097          	auipc	ra,0x0
    800013e8:	0fc080e7          	jalr	252(ra) # 800014e0 <kvminithart>
    trapinithart();   // install kernel trap vector
    800013ec:	00002097          	auipc	ra,0x2
    800013f0:	208080e7          	jalr	520(ra) # 800035f4 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    800013f4:	00007097          	auipc	ra,0x7
    800013f8:	b24080e7          	jalr	-1244(ra) # 80007f18 <plicinithart>
  }

  if (cpuid() == 0) {
    800013fc:	00001097          	auipc	ra,0x1
    80001400:	008080e7          	jalr	8(ra) # 80002404 <cpuid>
    80001404:	0a050c63          	beqz	a0,800014bc <main+0x10c>
      " | |_| | |  | | (_| \\__ \\__ \\ |_| |___) |\n"
      "  \\___/|_|  |_|\\__,_|___/___/\\___/|____/ \n"
    );
  }

  scheduler();        
    80001408:	00001097          	auipc	ra,0x1
    8000140c:	74c080e7          	jalr	1868(ra) # 80002b54 <scheduler>
    consoleinit();
    80001410:	fffff097          	auipc	ra,0xfffff
    80001414:	178080e7          	jalr	376(ra) # 80000588 <consoleinit>
    printfinit();
    80001418:	fffff097          	auipc	ra,0xfffff
    8000141c:	578080e7          	jalr	1400(ra) # 80000990 <printfinit>
    printf("\n");
    80001420:	00009517          	auipc	a0,0x9
    80001424:	09050513          	add	a0,a0,144 # 8000a4b0 <states.0+0x130>
    80001428:	fffff097          	auipc	ra,0xfffff
    8000142c:	2fc080e7          	jalr	764(ra) # 80000724 <printf>
    printf("\n");
    80001430:	00009517          	auipc	a0,0x9
    80001434:	08050513          	add	a0,a0,128 # 8000a4b0 <states.0+0x130>
    80001438:	fffff097          	auipc	ra,0xfffff
    8000143c:	2ec080e7          	jalr	748(ra) # 80000724 <printf>
    kinit();         // physical page allocator
    80001440:	00000097          	auipc	ra,0x0
    80001444:	9c8080e7          	jalr	-1592(ra) # 80000e08 <kinit>
    kvminit();       // create kernel page table
    80001448:	00000097          	auipc	ra,0x0
    8000144c:	4a4080e7          	jalr	1188(ra) # 800018ec <kvminit>
    kvminithart();   // turn on paging
    80001450:	00000097          	auipc	ra,0x0
    80001454:	090080e7          	jalr	144(ra) # 800014e0 <kvminithart>
    procinit();      // process table
    80001458:	00001097          	auipc	ra,0x1
    8000145c:	ec0080e7          	jalr	-320(ra) # 80002318 <procinit>
    trapinit();      // trap vectors
    80001460:	00002097          	auipc	ra,0x2
    80001464:	15c080e7          	jalr	348(ra) # 800035bc <trapinit>
    trapinithart();  // install kernel trap vector
    80001468:	00002097          	auipc	ra,0x2
    8000146c:	18c080e7          	jalr	396(ra) # 800035f4 <trapinithart>
    plicinit();      // set up interrupt controller
    80001470:	00007097          	auipc	ra,0x7
    80001474:	a80080e7          	jalr	-1408(ra) # 80007ef0 <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80001478:	00007097          	auipc	ra,0x7
    8000147c:	aa0080e7          	jalr	-1376(ra) # 80007f18 <plicinithart>
    binit();         // buffer cache
    80001480:	00003097          	auipc	ra,0x3
    80001484:	bc0080e7          	jalr	-1088(ra) # 80004040 <binit>
    iinit();         // inode table
    80001488:	00003097          	auipc	ra,0x3
    8000148c:	4a0080e7          	jalr	1184(ra) # 80004928 <iinit>
    fileinit();      // file table
    80001490:	00005097          	auipc	ra,0x5
    80001494:	a58080e7          	jalr	-1448(ra) # 80005ee8 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80001498:	00007097          	auipc	ra,0x7
    8000149c:	bec080e7          	jalr	-1044(ra) # 80008084 <virtio_disk_init>
    userinit();      // first user process
    800014a0:	00001097          	auipc	ra,0x1
    800014a4:	3d8080e7          	jalr	984(ra) # 80002878 <userinit>
    __sync_synchronize();
    800014a8:	0ff0000f          	fence
    started = 1;
    800014ac:	00100793          	li	a5,1
    800014b0:	00009717          	auipc	a4,0x9
    800014b4:	4af72c23          	sw	a5,1208(a4) # 8000a968 <started>
    800014b8:	f45ff06f          	j	800013fc <main+0x4c>
    printf("Welcome to\n");
    800014bc:	00009517          	auipc	a0,0x9
    800014c0:	be450513          	add	a0,a0,-1052 # 8000a0a0 <digits+0x60>
    800014c4:	fffff097          	auipc	ra,0xfffff
    800014c8:	260080e7          	jalr	608(ra) # 80000724 <printf>
    printf(
    800014cc:	00009517          	auipc	a0,0x9
    800014d0:	be450513          	add	a0,a0,-1052 # 8000a0b0 <digits+0x70>
    800014d4:	fffff097          	auipc	ra,0xfffff
    800014d8:	250080e7          	jalr	592(ra) # 80000724 <printf>
    800014dc:	f2dff06f          	j	80001408 <main+0x58>

00000000800014e0 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    800014e0:	ff010113          	add	sp,sp,-16
    800014e4:	00813423          	sd	s0,8(sp)
    800014e8:	01010413          	add	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800014ec:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    800014f0:	00009797          	auipc	a5,0x9
    800014f4:	4807b783          	ld	a5,1152(a5) # 8000a970 <kernel_pagetable>
    800014f8:	00c7d793          	srl	a5,a5,0xc
    800014fc:	fff00713          	li	a4,-1
    80001500:	03f71713          	sll	a4,a4,0x3f
    80001504:	00e7e7b3          	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80001508:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    8000150c:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80001510:	00813403          	ld	s0,8(sp)
    80001514:	01010113          	add	sp,sp,16
    80001518:	00008067          	ret

000000008000151c <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000151c:	fc010113          	add	sp,sp,-64
    80001520:	02113c23          	sd	ra,56(sp)
    80001524:	02813823          	sd	s0,48(sp)
    80001528:	02913423          	sd	s1,40(sp)
    8000152c:	03213023          	sd	s2,32(sp)
    80001530:	01313c23          	sd	s3,24(sp)
    80001534:	01413823          	sd	s4,16(sp)
    80001538:	01513423          	sd	s5,8(sp)
    8000153c:	01613023          	sd	s6,0(sp)
    80001540:	04010413          	add	s0,sp,64
    80001544:	00050493          	mv	s1,a0
    80001548:	00058993          	mv	s3,a1
    8000154c:	00060a93          	mv	s5,a2
  if(va >= MAXVA)
    80001550:	fff00793          	li	a5,-1
    80001554:	01a7d793          	srl	a5,a5,0x1a
    80001558:	01e00a13          	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000155c:	00c00b13          	li	s6,12
  if(va >= MAXVA)
    80001560:	04b7f863          	bgeu	a5,a1,800015b0 <walk+0x94>
    panic("walk");
    80001564:	00009517          	auipc	a0,0x9
    80001568:	c2450513          	add	a0,a0,-988 # 8000a188 <digits+0x148>
    8000156c:	fffff097          	auipc	ra,0xfffff
    80001570:	15c080e7          	jalr	348(ra) # 800006c8 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80001574:	080a8e63          	beqz	s5,80001610 <walk+0xf4>
    80001578:	00000097          	auipc	ra,0x0
    8000157c:	8e0080e7          	jalr	-1824(ra) # 80000e58 <kalloc>
    80001580:	00050493          	mv	s1,a0
    80001584:	06050263          	beqz	a0,800015e8 <walk+0xcc>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80001588:	00001637          	lui	a2,0x1
    8000158c:	00000593          	li	a1,0
    80001590:	00000097          	auipc	ra,0x0
    80001594:	b8c080e7          	jalr	-1140(ra) # 8000111c <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80001598:	00c4d793          	srl	a5,s1,0xc
    8000159c:	00a79793          	sll	a5,a5,0xa
    800015a0:	0017e793          	or	a5,a5,1
    800015a4:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800015a8:	ff7a0a1b          	addw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdb1f7>
    800015ac:	036a0663          	beq	s4,s6,800015d8 <walk+0xbc>
    pte_t *pte = &pagetable[PX(level, va)];
    800015b0:	0149d933          	srl	s2,s3,s4
    800015b4:	1ff97913          	and	s2,s2,511
    800015b8:	00391913          	sll	s2,s2,0x3
    800015bc:	01248933          	add	s2,s1,s2
    if(*pte & PTE_V) {
    800015c0:	00093483          	ld	s1,0(s2)
    800015c4:	0014f793          	and	a5,s1,1
    800015c8:	fa0786e3          	beqz	a5,80001574 <walk+0x58>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800015cc:	00a4d493          	srl	s1,s1,0xa
    800015d0:	00c49493          	sll	s1,s1,0xc
    800015d4:	fd5ff06f          	j	800015a8 <walk+0x8c>
    }
  }
  return &pagetable[PX(0, va)];
    800015d8:	00c9d513          	srl	a0,s3,0xc
    800015dc:	1ff57513          	and	a0,a0,511
    800015e0:	00351513          	sll	a0,a0,0x3
    800015e4:	00a48533          	add	a0,s1,a0
}
    800015e8:	03813083          	ld	ra,56(sp)
    800015ec:	03013403          	ld	s0,48(sp)
    800015f0:	02813483          	ld	s1,40(sp)
    800015f4:	02013903          	ld	s2,32(sp)
    800015f8:	01813983          	ld	s3,24(sp)
    800015fc:	01013a03          	ld	s4,16(sp)
    80001600:	00813a83          	ld	s5,8(sp)
    80001604:	00013b03          	ld	s6,0(sp)
    80001608:	04010113          	add	sp,sp,64
    8000160c:	00008067          	ret
        return 0;
    80001610:	00000513          	li	a0,0
    80001614:	fd5ff06f          	j	800015e8 <walk+0xcc>

0000000080001618 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80001618:	fff00793          	li	a5,-1
    8000161c:	01a7d793          	srl	a5,a5,0x1a
    80001620:	00b7f663          	bgeu	a5,a1,8000162c <walkaddr+0x14>
    return 0;
    80001624:	00000513          	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80001628:	00008067          	ret
{
    8000162c:	ff010113          	add	sp,sp,-16
    80001630:	00113423          	sd	ra,8(sp)
    80001634:	00813023          	sd	s0,0(sp)
    80001638:	01010413          	add	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000163c:	00000613          	li	a2,0
    80001640:	00000097          	auipc	ra,0x0
    80001644:	edc080e7          	jalr	-292(ra) # 8000151c <walk>
  if(pte == 0)
    80001648:	02050a63          	beqz	a0,8000167c <walkaddr+0x64>
  if((*pte & PTE_V) == 0)
    8000164c:	00053783          	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80001650:	0117f693          	and	a3,a5,17
    80001654:	01100713          	li	a4,17
    return 0;
    80001658:	00000513          	li	a0,0
  if((*pte & PTE_U) == 0)
    8000165c:	00e68a63          	beq	a3,a4,80001670 <walkaddr+0x58>
}
    80001660:	00813083          	ld	ra,8(sp)
    80001664:	00013403          	ld	s0,0(sp)
    80001668:	01010113          	add	sp,sp,16
    8000166c:	00008067          	ret
  pa = PTE2PA(*pte);
    80001670:	00a7d793          	srl	a5,a5,0xa
    80001674:	00c79513          	sll	a0,a5,0xc
  return pa;
    80001678:	fe9ff06f          	j	80001660 <walkaddr+0x48>
    return 0;
    8000167c:	00000513          	li	a0,0
    80001680:	fe1ff06f          	j	80001660 <walkaddr+0x48>

0000000080001684 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001684:	fb010113          	add	sp,sp,-80
    80001688:	04113423          	sd	ra,72(sp)
    8000168c:	04813023          	sd	s0,64(sp)
    80001690:	02913c23          	sd	s1,56(sp)
    80001694:	03213823          	sd	s2,48(sp)
    80001698:	03313423          	sd	s3,40(sp)
    8000169c:	03413023          	sd	s4,32(sp)
    800016a0:	01513c23          	sd	s5,24(sp)
    800016a4:	01613823          	sd	s6,16(sp)
    800016a8:	01713423          	sd	s7,8(sp)
    800016ac:	05010413          	add	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    800016b0:	06060a63          	beqz	a2,80001724 <mappages+0xa0>
    800016b4:	00050a93          	mv	s5,a0
    800016b8:	00070b13          	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    800016bc:	fffff737          	lui	a4,0xfffff
    800016c0:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    800016c4:	fff58993          	add	s3,a1,-1
    800016c8:	00c989b3          	add	s3,s3,a2
    800016cc:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    800016d0:	00078913          	mv	s2,a5
    800016d4:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800016d8:	00001bb7          	lui	s7,0x1
    800016dc:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800016e0:	00100613          	li	a2,1
    800016e4:	00090593          	mv	a1,s2
    800016e8:	000a8513          	mv	a0,s5
    800016ec:	00000097          	auipc	ra,0x0
    800016f0:	e30080e7          	jalr	-464(ra) # 8000151c <walk>
    800016f4:	04050863          	beqz	a0,80001744 <mappages+0xc0>
    if(*pte & PTE_V)
    800016f8:	00053783          	ld	a5,0(a0)
    800016fc:	0017f793          	and	a5,a5,1
    80001700:	02079a63          	bnez	a5,80001734 <mappages+0xb0>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001704:	00c4d493          	srl	s1,s1,0xc
    80001708:	00a49493          	sll	s1,s1,0xa
    8000170c:	0164e4b3          	or	s1,s1,s6
    80001710:	0014e493          	or	s1,s1,1
    80001714:	00953023          	sd	s1,0(a0)
    if(a == last)
    80001718:	05390e63          	beq	s2,s3,80001774 <mappages+0xf0>
    a += PGSIZE;
    8000171c:	01790933          	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80001720:	fbdff06f          	j	800016dc <mappages+0x58>
    panic("mappages: size");
    80001724:	00009517          	auipc	a0,0x9
    80001728:	a6c50513          	add	a0,a0,-1428 # 8000a190 <digits+0x150>
    8000172c:	fffff097          	auipc	ra,0xfffff
    80001730:	f9c080e7          	jalr	-100(ra) # 800006c8 <panic>
      panic("mappages: remap");
    80001734:	00009517          	auipc	a0,0x9
    80001738:	a6c50513          	add	a0,a0,-1428 # 8000a1a0 <digits+0x160>
    8000173c:	fffff097          	auipc	ra,0xfffff
    80001740:	f8c080e7          	jalr	-116(ra) # 800006c8 <panic>
      return -1;
    80001744:	fff00513          	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80001748:	04813083          	ld	ra,72(sp)
    8000174c:	04013403          	ld	s0,64(sp)
    80001750:	03813483          	ld	s1,56(sp)
    80001754:	03013903          	ld	s2,48(sp)
    80001758:	02813983          	ld	s3,40(sp)
    8000175c:	02013a03          	ld	s4,32(sp)
    80001760:	01813a83          	ld	s5,24(sp)
    80001764:	01013b03          	ld	s6,16(sp)
    80001768:	00813b83          	ld	s7,8(sp)
    8000176c:	05010113          	add	sp,sp,80
    80001770:	00008067          	ret
  return 0;
    80001774:	00000513          	li	a0,0
    80001778:	fd1ff06f          	j	80001748 <mappages+0xc4>

000000008000177c <kvmmap>:
{
    8000177c:	ff010113          	add	sp,sp,-16
    80001780:	00113423          	sd	ra,8(sp)
    80001784:	00813023          	sd	s0,0(sp)
    80001788:	01010413          	add	s0,sp,16
    8000178c:	00068793          	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80001790:	00060693          	mv	a3,a2
    80001794:	00078613          	mv	a2,a5
    80001798:	00000097          	auipc	ra,0x0
    8000179c:	eec080e7          	jalr	-276(ra) # 80001684 <mappages>
    800017a0:	00051a63          	bnez	a0,800017b4 <kvmmap+0x38>
}
    800017a4:	00813083          	ld	ra,8(sp)
    800017a8:	00013403          	ld	s0,0(sp)
    800017ac:	01010113          	add	sp,sp,16
    800017b0:	00008067          	ret
    panic("kvmmap");
    800017b4:	00009517          	auipc	a0,0x9
    800017b8:	9fc50513          	add	a0,a0,-1540 # 8000a1b0 <digits+0x170>
    800017bc:	fffff097          	auipc	ra,0xfffff
    800017c0:	f0c080e7          	jalr	-244(ra) # 800006c8 <panic>

00000000800017c4 <kvmmake>:
{
    800017c4:	fe010113          	add	sp,sp,-32
    800017c8:	00113c23          	sd	ra,24(sp)
    800017cc:	00813823          	sd	s0,16(sp)
    800017d0:	00913423          	sd	s1,8(sp)
    800017d4:	01213023          	sd	s2,0(sp)
    800017d8:	02010413          	add	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800017dc:	fffff097          	auipc	ra,0xfffff
    800017e0:	67c080e7          	jalr	1660(ra) # 80000e58 <kalloc>
    800017e4:	00050493          	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800017e8:	00001637          	lui	a2,0x1
    800017ec:	00000593          	li	a1,0
    800017f0:	00000097          	auipc	ra,0x0
    800017f4:	92c080e7          	jalr	-1748(ra) # 8000111c <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800017f8:	00600713          	li	a4,6
    800017fc:	000016b7          	lui	a3,0x1
    80001800:	10000637          	lui	a2,0x10000
    80001804:	100005b7          	lui	a1,0x10000
    80001808:	00048513          	mv	a0,s1
    8000180c:	00000097          	auipc	ra,0x0
    80001810:	f70080e7          	jalr	-144(ra) # 8000177c <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001814:	00600713          	li	a4,6
    80001818:	000016b7          	lui	a3,0x1
    8000181c:	10001637          	lui	a2,0x10001
    80001820:	100015b7          	lui	a1,0x10001
    80001824:	00048513          	mv	a0,s1
    80001828:	00000097          	auipc	ra,0x0
    8000182c:	f54080e7          	jalr	-172(ra) # 8000177c <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80001830:	00600713          	li	a4,6
    80001834:	004006b7          	lui	a3,0x400
    80001838:	0c000637          	lui	a2,0xc000
    8000183c:	0c0005b7          	lui	a1,0xc000
    80001840:	00048513          	mv	a0,s1
    80001844:	00000097          	auipc	ra,0x0
    80001848:	f38080e7          	jalr	-200(ra) # 8000177c <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000184c:	00008917          	auipc	s2,0x8
    80001850:	7b490913          	add	s2,s2,1972 # 8000a000 <etext>
    80001854:	00a00713          	li	a4,10
    80001858:	80008697          	auipc	a3,0x80008
    8000185c:	7a868693          	add	a3,a3,1960 # a000 <_entry-0x7fff6000>
    80001860:	00100613          	li	a2,1
    80001864:	01f61613          	sll	a2,a2,0x1f
    80001868:	00060593          	mv	a1,a2
    8000186c:	00048513          	mv	a0,s1
    80001870:	00000097          	auipc	ra,0x0
    80001874:	f0c080e7          	jalr	-244(ra) # 8000177c <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001878:	00600713          	li	a4,6
    8000187c:	01100693          	li	a3,17
    80001880:	01b69693          	sll	a3,a3,0x1b
    80001884:	412686b3          	sub	a3,a3,s2
    80001888:	00090613          	mv	a2,s2
    8000188c:	00090593          	mv	a1,s2
    80001890:	00048513          	mv	a0,s1
    80001894:	00000097          	auipc	ra,0x0
    80001898:	ee8080e7          	jalr	-280(ra) # 8000177c <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000189c:	00a00713          	li	a4,10
    800018a0:	000016b7          	lui	a3,0x1
    800018a4:	00007617          	auipc	a2,0x7
    800018a8:	75c60613          	add	a2,a2,1884 # 80009000 <_trampoline>
    800018ac:	040005b7          	lui	a1,0x4000
    800018b0:	fff58593          	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800018b4:	00c59593          	sll	a1,a1,0xc
    800018b8:	00048513          	mv	a0,s1
    800018bc:	00000097          	auipc	ra,0x0
    800018c0:	ec0080e7          	jalr	-320(ra) # 8000177c <kvmmap>
  proc_mapstacks(kpgtbl);
    800018c4:	00048513          	mv	a0,s1
    800018c8:	00001097          	auipc	ra,0x1
    800018cc:	97c080e7          	jalr	-1668(ra) # 80002244 <proc_mapstacks>
}
    800018d0:	00048513          	mv	a0,s1
    800018d4:	01813083          	ld	ra,24(sp)
    800018d8:	01013403          	ld	s0,16(sp)
    800018dc:	00813483          	ld	s1,8(sp)
    800018e0:	00013903          	ld	s2,0(sp)
    800018e4:	02010113          	add	sp,sp,32
    800018e8:	00008067          	ret

00000000800018ec <kvminit>:
{
    800018ec:	ff010113          	add	sp,sp,-16
    800018f0:	00113423          	sd	ra,8(sp)
    800018f4:	00813023          	sd	s0,0(sp)
    800018f8:	01010413          	add	s0,sp,16
  kernel_pagetable = kvmmake();
    800018fc:	00000097          	auipc	ra,0x0
    80001900:	ec8080e7          	jalr	-312(ra) # 800017c4 <kvmmake>
    80001904:	00009797          	auipc	a5,0x9
    80001908:	06a7b623          	sd	a0,108(a5) # 8000a970 <kernel_pagetable>
}
    8000190c:	00813083          	ld	ra,8(sp)
    80001910:	00013403          	ld	s0,0(sp)
    80001914:	01010113          	add	sp,sp,16
    80001918:	00008067          	ret

000000008000191c <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000191c:	fb010113          	add	sp,sp,-80
    80001920:	04113423          	sd	ra,72(sp)
    80001924:	04813023          	sd	s0,64(sp)
    80001928:	02913c23          	sd	s1,56(sp)
    8000192c:	03213823          	sd	s2,48(sp)
    80001930:	03313423          	sd	s3,40(sp)
    80001934:	03413023          	sd	s4,32(sp)
    80001938:	01513c23          	sd	s5,24(sp)
    8000193c:	01613823          	sd	s6,16(sp)
    80001940:	01713423          	sd	s7,8(sp)
    80001944:	05010413          	add	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001948:	03459793          	sll	a5,a1,0x34
    8000194c:	04079863          	bnez	a5,8000199c <uvmunmap+0x80>
    80001950:	00050a13          	mv	s4,a0
    80001954:	00058913          	mv	s2,a1
    80001958:	00068a93          	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000195c:	00c61613          	sll	a2,a2,0xc
    80001960:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80001964:	00100b93          	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001968:	00001b37          	lui	s6,0x1
    8000196c:	0735ee63          	bltu	a1,s3,800019e8 <uvmunmap+0xcc>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80001970:	04813083          	ld	ra,72(sp)
    80001974:	04013403          	ld	s0,64(sp)
    80001978:	03813483          	ld	s1,56(sp)
    8000197c:	03013903          	ld	s2,48(sp)
    80001980:	02813983          	ld	s3,40(sp)
    80001984:	02013a03          	ld	s4,32(sp)
    80001988:	01813a83          	ld	s5,24(sp)
    8000198c:	01013b03          	ld	s6,16(sp)
    80001990:	00813b83          	ld	s7,8(sp)
    80001994:	05010113          	add	sp,sp,80
    80001998:	00008067          	ret
    panic("uvmunmap: not aligned");
    8000199c:	00009517          	auipc	a0,0x9
    800019a0:	81c50513          	add	a0,a0,-2020 # 8000a1b8 <digits+0x178>
    800019a4:	fffff097          	auipc	ra,0xfffff
    800019a8:	d24080e7          	jalr	-732(ra) # 800006c8 <panic>
      panic("uvmunmap: walk");
    800019ac:	00009517          	auipc	a0,0x9
    800019b0:	82450513          	add	a0,a0,-2012 # 8000a1d0 <digits+0x190>
    800019b4:	fffff097          	auipc	ra,0xfffff
    800019b8:	d14080e7          	jalr	-748(ra) # 800006c8 <panic>
      panic("uvmunmap: not mapped");
    800019bc:	00009517          	auipc	a0,0x9
    800019c0:	82450513          	add	a0,a0,-2012 # 8000a1e0 <digits+0x1a0>
    800019c4:	fffff097          	auipc	ra,0xfffff
    800019c8:	d04080e7          	jalr	-764(ra) # 800006c8 <panic>
      panic("uvmunmap: not a leaf");
    800019cc:	00009517          	auipc	a0,0x9
    800019d0:	82c50513          	add	a0,a0,-2004 # 8000a1f8 <digits+0x1b8>
    800019d4:	fffff097          	auipc	ra,0xfffff
    800019d8:	cf4080e7          	jalr	-780(ra) # 800006c8 <panic>
    *pte = 0;
    800019dc:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800019e0:	01690933          	add	s2,s2,s6
    800019e4:	f93976e3          	bgeu	s2,s3,80001970 <uvmunmap+0x54>
    if((pte = walk(pagetable, a, 0)) == 0)
    800019e8:	00000613          	li	a2,0
    800019ec:	00090593          	mv	a1,s2
    800019f0:	000a0513          	mv	a0,s4
    800019f4:	00000097          	auipc	ra,0x0
    800019f8:	b28080e7          	jalr	-1240(ra) # 8000151c <walk>
    800019fc:	00050493          	mv	s1,a0
    80001a00:	fa0506e3          	beqz	a0,800019ac <uvmunmap+0x90>
    if((*pte & PTE_V) == 0)
    80001a04:	00053503          	ld	a0,0(a0)
    80001a08:	00157793          	and	a5,a0,1
    80001a0c:	fa0788e3          	beqz	a5,800019bc <uvmunmap+0xa0>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001a10:	3ff57793          	and	a5,a0,1023
    80001a14:	fb778ce3          	beq	a5,s7,800019cc <uvmunmap+0xb0>
    if(do_free){
    80001a18:	fc0a82e3          	beqz	s5,800019dc <uvmunmap+0xc0>
      uint64 pa = PTE2PA(*pte);
    80001a1c:	00a55513          	srl	a0,a0,0xa
      kfree((void*)pa);
    80001a20:	00c51513          	sll	a0,a0,0xc
    80001a24:	fffff097          	auipc	ra,0xfffff
    80001a28:	2c8080e7          	jalr	712(ra) # 80000cec <kfree>
    80001a2c:	fb1ff06f          	j	800019dc <uvmunmap+0xc0>

0000000080001a30 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001a30:	fe010113          	add	sp,sp,-32
    80001a34:	00113c23          	sd	ra,24(sp)
    80001a38:	00813823          	sd	s0,16(sp)
    80001a3c:	00913423          	sd	s1,8(sp)
    80001a40:	02010413          	add	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80001a44:	fffff097          	auipc	ra,0xfffff
    80001a48:	414080e7          	jalr	1044(ra) # 80000e58 <kalloc>
    80001a4c:	00050493          	mv	s1,a0
  if(pagetable == 0)
    80001a50:	00050a63          	beqz	a0,80001a64 <uvmcreate+0x34>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80001a54:	00001637          	lui	a2,0x1
    80001a58:	00000593          	li	a1,0
    80001a5c:	fffff097          	auipc	ra,0xfffff
    80001a60:	6c0080e7          	jalr	1728(ra) # 8000111c <memset>
  return pagetable;
}
    80001a64:	00048513          	mv	a0,s1
    80001a68:	01813083          	ld	ra,24(sp)
    80001a6c:	01013403          	ld	s0,16(sp)
    80001a70:	00813483          	ld	s1,8(sp)
    80001a74:	02010113          	add	sp,sp,32
    80001a78:	00008067          	ret

0000000080001a7c <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80001a7c:	fd010113          	add	sp,sp,-48
    80001a80:	02113423          	sd	ra,40(sp)
    80001a84:	02813023          	sd	s0,32(sp)
    80001a88:	00913c23          	sd	s1,24(sp)
    80001a8c:	01213823          	sd	s2,16(sp)
    80001a90:	01313423          	sd	s3,8(sp)
    80001a94:	01413023          	sd	s4,0(sp)
    80001a98:	03010413          	add	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80001a9c:	000017b7          	lui	a5,0x1
    80001aa0:	06f67e63          	bgeu	a2,a5,80001b1c <uvmfirst+0xa0>
    80001aa4:	00050a13          	mv	s4,a0
    80001aa8:	00058993          	mv	s3,a1
    80001aac:	00060493          	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80001ab0:	fffff097          	auipc	ra,0xfffff
    80001ab4:	3a8080e7          	jalr	936(ra) # 80000e58 <kalloc>
    80001ab8:	00050913          	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80001abc:	00001637          	lui	a2,0x1
    80001ac0:	00000593          	li	a1,0
    80001ac4:	fffff097          	auipc	ra,0xfffff
    80001ac8:	658080e7          	jalr	1624(ra) # 8000111c <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80001acc:	01e00713          	li	a4,30
    80001ad0:	00090693          	mv	a3,s2
    80001ad4:	00001637          	lui	a2,0x1
    80001ad8:	00000593          	li	a1,0
    80001adc:	000a0513          	mv	a0,s4
    80001ae0:	00000097          	auipc	ra,0x0
    80001ae4:	ba4080e7          	jalr	-1116(ra) # 80001684 <mappages>
  memmove(mem, src, sz);
    80001ae8:	00048613          	mv	a2,s1
    80001aec:	00098593          	mv	a1,s3
    80001af0:	00090513          	mv	a0,s2
    80001af4:	fffff097          	auipc	ra,0xfffff
    80001af8:	6bc080e7          	jalr	1724(ra) # 800011b0 <memmove>
}
    80001afc:	02813083          	ld	ra,40(sp)
    80001b00:	02013403          	ld	s0,32(sp)
    80001b04:	01813483          	ld	s1,24(sp)
    80001b08:	01013903          	ld	s2,16(sp)
    80001b0c:	00813983          	ld	s3,8(sp)
    80001b10:	00013a03          	ld	s4,0(sp)
    80001b14:	03010113          	add	sp,sp,48
    80001b18:	00008067          	ret
    panic("uvmfirst: more than a page");
    80001b1c:	00008517          	auipc	a0,0x8
    80001b20:	6f450513          	add	a0,a0,1780 # 8000a210 <digits+0x1d0>
    80001b24:	fffff097          	auipc	ra,0xfffff
    80001b28:	ba4080e7          	jalr	-1116(ra) # 800006c8 <panic>

0000000080001b2c <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80001b2c:	fe010113          	add	sp,sp,-32
    80001b30:	00113c23          	sd	ra,24(sp)
    80001b34:	00813823          	sd	s0,16(sp)
    80001b38:	00913423          	sd	s1,8(sp)
    80001b3c:	02010413          	add	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80001b40:	00058493          	mv	s1,a1
  if(newsz >= oldsz)
    80001b44:	02b67463          	bgeu	a2,a1,80001b6c <uvmdealloc+0x40>
    80001b48:	00060493          	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80001b4c:	000017b7          	lui	a5,0x1
    80001b50:	fff78793          	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001b54:	00f60733          	add	a4,a2,a5
    80001b58:	fffff6b7          	lui	a3,0xfffff
    80001b5c:	00d77733          	and	a4,a4,a3
    80001b60:	00f587b3          	add	a5,a1,a5
    80001b64:	00d7f7b3          	and	a5,a5,a3
    80001b68:	00f76e63          	bltu	a4,a5,80001b84 <uvmdealloc+0x58>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001b6c:	00048513          	mv	a0,s1
    80001b70:	01813083          	ld	ra,24(sp)
    80001b74:	01013403          	ld	s0,16(sp)
    80001b78:	00813483          	ld	s1,8(sp)
    80001b7c:	02010113          	add	sp,sp,32
    80001b80:	00008067          	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80001b84:	40e787b3          	sub	a5,a5,a4
    80001b88:	00c7d793          	srl	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001b8c:	00100693          	li	a3,1
    80001b90:	0007861b          	sext.w	a2,a5
    80001b94:	00070593          	mv	a1,a4
    80001b98:	00000097          	auipc	ra,0x0
    80001b9c:	d84080e7          	jalr	-636(ra) # 8000191c <uvmunmap>
    80001ba0:	fcdff06f          	j	80001b6c <uvmdealloc+0x40>

0000000080001ba4 <uvmalloc>:
  if(newsz < oldsz)
    80001ba4:	10b66863          	bltu	a2,a1,80001cb4 <uvmalloc+0x110>
{
    80001ba8:	fc010113          	add	sp,sp,-64
    80001bac:	02113c23          	sd	ra,56(sp)
    80001bb0:	02813823          	sd	s0,48(sp)
    80001bb4:	02913423          	sd	s1,40(sp)
    80001bb8:	03213023          	sd	s2,32(sp)
    80001bbc:	01313c23          	sd	s3,24(sp)
    80001bc0:	01413823          	sd	s4,16(sp)
    80001bc4:	01513423          	sd	s5,8(sp)
    80001bc8:	01613023          	sd	s6,0(sp)
    80001bcc:	04010413          	add	s0,sp,64
    80001bd0:	00050a93          	mv	s5,a0
    80001bd4:	00060a13          	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001bd8:	000017b7          	lui	a5,0x1
    80001bdc:	fff78793          	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001be0:	00f585b3          	add	a1,a1,a5
    80001be4:	fffff7b7          	lui	a5,0xfffff
    80001be8:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001bec:	0cc9f863          	bgeu	s3,a2,80001cbc <uvmalloc+0x118>
    80001bf0:	00098913          	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001bf4:	0126eb13          	or	s6,a3,18
    mem = kalloc();
    80001bf8:	fffff097          	auipc	ra,0xfffff
    80001bfc:	260080e7          	jalr	608(ra) # 80000e58 <kalloc>
    80001c00:	00050493          	mv	s1,a0
    if(mem == 0){
    80001c04:	04050463          	beqz	a0,80001c4c <uvmalloc+0xa8>
    memset(mem, 0, PGSIZE);
    80001c08:	00001637          	lui	a2,0x1
    80001c0c:	00000593          	li	a1,0
    80001c10:	fffff097          	auipc	ra,0xfffff
    80001c14:	50c080e7          	jalr	1292(ra) # 8000111c <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001c18:	000b0713          	mv	a4,s6
    80001c1c:	00048693          	mv	a3,s1
    80001c20:	00001637          	lui	a2,0x1
    80001c24:	00090593          	mv	a1,s2
    80001c28:	000a8513          	mv	a0,s5
    80001c2c:	00000097          	auipc	ra,0x0
    80001c30:	a58080e7          	jalr	-1448(ra) # 80001684 <mappages>
    80001c34:	04051c63          	bnez	a0,80001c8c <uvmalloc+0xe8>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001c38:	000017b7          	lui	a5,0x1
    80001c3c:	00f90933          	add	s2,s2,a5
    80001c40:	fb496ce3          	bltu	s2,s4,80001bf8 <uvmalloc+0x54>
  return newsz;
    80001c44:	000a0513          	mv	a0,s4
    80001c48:	01c0006f          	j	80001c64 <uvmalloc+0xc0>
      uvmdealloc(pagetable, a, oldsz);
    80001c4c:	00098613          	mv	a2,s3
    80001c50:	00090593          	mv	a1,s2
    80001c54:	000a8513          	mv	a0,s5
    80001c58:	00000097          	auipc	ra,0x0
    80001c5c:	ed4080e7          	jalr	-300(ra) # 80001b2c <uvmdealloc>
      return 0;
    80001c60:	00000513          	li	a0,0
}
    80001c64:	03813083          	ld	ra,56(sp)
    80001c68:	03013403          	ld	s0,48(sp)
    80001c6c:	02813483          	ld	s1,40(sp)
    80001c70:	02013903          	ld	s2,32(sp)
    80001c74:	01813983          	ld	s3,24(sp)
    80001c78:	01013a03          	ld	s4,16(sp)
    80001c7c:	00813a83          	ld	s5,8(sp)
    80001c80:	00013b03          	ld	s6,0(sp)
    80001c84:	04010113          	add	sp,sp,64
    80001c88:	00008067          	ret
      kfree(mem);
    80001c8c:	00048513          	mv	a0,s1
    80001c90:	fffff097          	auipc	ra,0xfffff
    80001c94:	05c080e7          	jalr	92(ra) # 80000cec <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001c98:	00098613          	mv	a2,s3
    80001c9c:	00090593          	mv	a1,s2
    80001ca0:	000a8513          	mv	a0,s5
    80001ca4:	00000097          	auipc	ra,0x0
    80001ca8:	e88080e7          	jalr	-376(ra) # 80001b2c <uvmdealloc>
      return 0;
    80001cac:	00000513          	li	a0,0
    80001cb0:	fb5ff06f          	j	80001c64 <uvmalloc+0xc0>
    return oldsz;
    80001cb4:	00058513          	mv	a0,a1
}
    80001cb8:	00008067          	ret
  return newsz;
    80001cbc:	00060513          	mv	a0,a2
    80001cc0:	fa5ff06f          	j	80001c64 <uvmalloc+0xc0>

0000000080001cc4 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80001cc4:	fd010113          	add	sp,sp,-48
    80001cc8:	02113423          	sd	ra,40(sp)
    80001ccc:	02813023          	sd	s0,32(sp)
    80001cd0:	00913c23          	sd	s1,24(sp)
    80001cd4:	01213823          	sd	s2,16(sp)
    80001cd8:	01313423          	sd	s3,8(sp)
    80001cdc:	01413023          	sd	s4,0(sp)
    80001ce0:	03010413          	add	s0,sp,48
    80001ce4:	00050a13          	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80001ce8:	00050493          	mv	s1,a0
    80001cec:	00001937          	lui	s2,0x1
    80001cf0:	01250933          	add	s2,a0,s2
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001cf4:	00100993          	li	s3,1
    80001cf8:	0200006f          	j	80001d18 <freewalk+0x54>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80001cfc:	00a7d793          	srl	a5,a5,0xa
      freewalk((pagetable_t)child);
    80001d00:	00c79513          	sll	a0,a5,0xc
    80001d04:	00000097          	auipc	ra,0x0
    80001d08:	fc0080e7          	jalr	-64(ra) # 80001cc4 <freewalk>
      pagetable[i] = 0;
    80001d0c:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80001d10:	00848493          	add	s1,s1,8
    80001d14:	03248463          	beq	s1,s2,80001d3c <freewalk+0x78>
    pte_t pte = pagetable[i];
    80001d18:	0004b783          	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001d1c:	00f7f713          	and	a4,a5,15
    80001d20:	fd370ee3          	beq	a4,s3,80001cfc <freewalk+0x38>
    } else if(pte & PTE_V){
    80001d24:	0017f793          	and	a5,a5,1
    80001d28:	fe0784e3          	beqz	a5,80001d10 <freewalk+0x4c>
      panic("freewalk: leaf");
    80001d2c:	00008517          	auipc	a0,0x8
    80001d30:	50450513          	add	a0,a0,1284 # 8000a230 <digits+0x1f0>
    80001d34:	fffff097          	auipc	ra,0xfffff
    80001d38:	994080e7          	jalr	-1644(ra) # 800006c8 <panic>
    }
  }
  kfree((void*)pagetable);
    80001d3c:	000a0513          	mv	a0,s4
    80001d40:	fffff097          	auipc	ra,0xfffff
    80001d44:	fac080e7          	jalr	-84(ra) # 80000cec <kfree>
}
    80001d48:	02813083          	ld	ra,40(sp)
    80001d4c:	02013403          	ld	s0,32(sp)
    80001d50:	01813483          	ld	s1,24(sp)
    80001d54:	01013903          	ld	s2,16(sp)
    80001d58:	00813983          	ld	s3,8(sp)
    80001d5c:	00013a03          	ld	s4,0(sp)
    80001d60:	03010113          	add	sp,sp,48
    80001d64:	00008067          	ret

0000000080001d68 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001d68:	fe010113          	add	sp,sp,-32
    80001d6c:	00113c23          	sd	ra,24(sp)
    80001d70:	00813823          	sd	s0,16(sp)
    80001d74:	00913423          	sd	s1,8(sp)
    80001d78:	02010413          	add	s0,sp,32
    80001d7c:	00050493          	mv	s1,a0
  if(sz > 0)
    80001d80:	02059263          	bnez	a1,80001da4 <uvmfree+0x3c>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80001d84:	00048513          	mv	a0,s1
    80001d88:	00000097          	auipc	ra,0x0
    80001d8c:	f3c080e7          	jalr	-196(ra) # 80001cc4 <freewalk>
}
    80001d90:	01813083          	ld	ra,24(sp)
    80001d94:	01013403          	ld	s0,16(sp)
    80001d98:	00813483          	ld	s1,8(sp)
    80001d9c:	02010113          	add	sp,sp,32
    80001da0:	00008067          	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001da4:	000017b7          	lui	a5,0x1
    80001da8:	fff78793          	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001dac:	00f585b3          	add	a1,a1,a5
    80001db0:	00100693          	li	a3,1
    80001db4:	00c5d613          	srl	a2,a1,0xc
    80001db8:	00000593          	li	a1,0
    80001dbc:	00000097          	auipc	ra,0x0
    80001dc0:	b60080e7          	jalr	-1184(ra) # 8000191c <uvmunmap>
    80001dc4:	fc1ff06f          	j	80001d84 <uvmfree+0x1c>

0000000080001dc8 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80001dc8:	12060a63          	beqz	a2,80001efc <uvmcopy+0x134>
{
    80001dcc:	fb010113          	add	sp,sp,-80
    80001dd0:	04113423          	sd	ra,72(sp)
    80001dd4:	04813023          	sd	s0,64(sp)
    80001dd8:	02913c23          	sd	s1,56(sp)
    80001ddc:	03213823          	sd	s2,48(sp)
    80001de0:	03313423          	sd	s3,40(sp)
    80001de4:	03413023          	sd	s4,32(sp)
    80001de8:	01513c23          	sd	s5,24(sp)
    80001dec:	01613823          	sd	s6,16(sp)
    80001df0:	01713423          	sd	s7,8(sp)
    80001df4:	05010413          	add	s0,sp,80
    80001df8:	00050b13          	mv	s6,a0
    80001dfc:	00058a93          	mv	s5,a1
    80001e00:	00060a13          	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001e04:	00000993          	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80001e08:	00000613          	li	a2,0
    80001e0c:	00098593          	mv	a1,s3
    80001e10:	000b0513          	mv	a0,s6
    80001e14:	fffff097          	auipc	ra,0xfffff
    80001e18:	708080e7          	jalr	1800(ra) # 8000151c <walk>
    80001e1c:	06050663          	beqz	a0,80001e88 <uvmcopy+0xc0>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80001e20:	00053703          	ld	a4,0(a0)
    80001e24:	00177793          	and	a5,a4,1
    80001e28:	06078863          	beqz	a5,80001e98 <uvmcopy+0xd0>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80001e2c:	00a75593          	srl	a1,a4,0xa
    80001e30:	00c59b93          	sll	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80001e34:	3ff77493          	and	s1,a4,1023
    if((mem = kalloc()) == 0)
    80001e38:	fffff097          	auipc	ra,0xfffff
    80001e3c:	020080e7          	jalr	32(ra) # 80000e58 <kalloc>
    80001e40:	00050913          	mv	s2,a0
    80001e44:	06050863          	beqz	a0,80001eb4 <uvmcopy+0xec>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80001e48:	00001637          	lui	a2,0x1
    80001e4c:	000b8593          	mv	a1,s7
    80001e50:	fffff097          	auipc	ra,0xfffff
    80001e54:	360080e7          	jalr	864(ra) # 800011b0 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80001e58:	00048713          	mv	a4,s1
    80001e5c:	00090693          	mv	a3,s2
    80001e60:	00001637          	lui	a2,0x1
    80001e64:	00098593          	mv	a1,s3
    80001e68:	000a8513          	mv	a0,s5
    80001e6c:	00000097          	auipc	ra,0x0
    80001e70:	818080e7          	jalr	-2024(ra) # 80001684 <mappages>
    80001e74:	02051a63          	bnez	a0,80001ea8 <uvmcopy+0xe0>
  for(i = 0; i < sz; i += PGSIZE){
    80001e78:	000017b7          	lui	a5,0x1
    80001e7c:	00f989b3          	add	s3,s3,a5
    80001e80:	f949e4e3          	bltu	s3,s4,80001e08 <uvmcopy+0x40>
    80001e84:	04c0006f          	j	80001ed0 <uvmcopy+0x108>
      panic("uvmcopy: pte should exist");
    80001e88:	00008517          	auipc	a0,0x8
    80001e8c:	3b850513          	add	a0,a0,952 # 8000a240 <digits+0x200>
    80001e90:	fffff097          	auipc	ra,0xfffff
    80001e94:	838080e7          	jalr	-1992(ra) # 800006c8 <panic>
      panic("uvmcopy: page not present");
    80001e98:	00008517          	auipc	a0,0x8
    80001e9c:	3c850513          	add	a0,a0,968 # 8000a260 <digits+0x220>
    80001ea0:	fffff097          	auipc	ra,0xfffff
    80001ea4:	828080e7          	jalr	-2008(ra) # 800006c8 <panic>
      kfree(mem);
    80001ea8:	00090513          	mv	a0,s2
    80001eac:	fffff097          	auipc	ra,0xfffff
    80001eb0:	e40080e7          	jalr	-448(ra) # 80000cec <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001eb4:	00100693          	li	a3,1
    80001eb8:	00c9d613          	srl	a2,s3,0xc
    80001ebc:	00000593          	li	a1,0
    80001ec0:	000a8513          	mv	a0,s5
    80001ec4:	00000097          	auipc	ra,0x0
    80001ec8:	a58080e7          	jalr	-1448(ra) # 8000191c <uvmunmap>
  return -1;
    80001ecc:	fff00513          	li	a0,-1
}
    80001ed0:	04813083          	ld	ra,72(sp)
    80001ed4:	04013403          	ld	s0,64(sp)
    80001ed8:	03813483          	ld	s1,56(sp)
    80001edc:	03013903          	ld	s2,48(sp)
    80001ee0:	02813983          	ld	s3,40(sp)
    80001ee4:	02013a03          	ld	s4,32(sp)
    80001ee8:	01813a83          	ld	s5,24(sp)
    80001eec:	01013b03          	ld	s6,16(sp)
    80001ef0:	00813b83          	ld	s7,8(sp)
    80001ef4:	05010113          	add	sp,sp,80
    80001ef8:	00008067          	ret
  return 0;
    80001efc:	00000513          	li	a0,0
}
    80001f00:	00008067          	ret

0000000080001f04 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001f04:	ff010113          	add	sp,sp,-16
    80001f08:	00113423          	sd	ra,8(sp)
    80001f0c:	00813023          	sd	s0,0(sp)
    80001f10:	01010413          	add	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001f14:	00000613          	li	a2,0
    80001f18:	fffff097          	auipc	ra,0xfffff
    80001f1c:	604080e7          	jalr	1540(ra) # 8000151c <walk>
  if(pte == 0)
    80001f20:	02050063          	beqz	a0,80001f40 <uvmclear+0x3c>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001f24:	00053783          	ld	a5,0(a0)
    80001f28:	fef7f793          	and	a5,a5,-17
    80001f2c:	00f53023          	sd	a5,0(a0)
}
    80001f30:	00813083          	ld	ra,8(sp)
    80001f34:	00013403          	ld	s0,0(sp)
    80001f38:	01010113          	add	sp,sp,16
    80001f3c:	00008067          	ret
    panic("uvmclear");
    80001f40:	00008517          	auipc	a0,0x8
    80001f44:	34050513          	add	a0,a0,832 # 8000a280 <digits+0x240>
    80001f48:	ffffe097          	auipc	ra,0xffffe
    80001f4c:	780080e7          	jalr	1920(ra) # 800006c8 <panic>

0000000080001f50 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001f50:	0a068663          	beqz	a3,80001ffc <copyout+0xac>
{
    80001f54:	fb010113          	add	sp,sp,-80
    80001f58:	04113423          	sd	ra,72(sp)
    80001f5c:	04813023          	sd	s0,64(sp)
    80001f60:	02913c23          	sd	s1,56(sp)
    80001f64:	03213823          	sd	s2,48(sp)
    80001f68:	03313423          	sd	s3,40(sp)
    80001f6c:	03413023          	sd	s4,32(sp)
    80001f70:	01513c23          	sd	s5,24(sp)
    80001f74:	01613823          	sd	s6,16(sp)
    80001f78:	01713423          	sd	s7,8(sp)
    80001f7c:	01813023          	sd	s8,0(sp)
    80001f80:	05010413          	add	s0,sp,80
    80001f84:	00050b13          	mv	s6,a0
    80001f88:	00058c13          	mv	s8,a1
    80001f8c:	00060a13          	mv	s4,a2
    80001f90:	00068993          	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80001f94:	fffffbb7          	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80001f98:	00001ab7          	lui	s5,0x1
    80001f9c:	02c0006f          	j	80001fc8 <copyout+0x78>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001fa0:	01850533          	add	a0,a0,s8
    80001fa4:	0004861b          	sext.w	a2,s1
    80001fa8:	000a0593          	mv	a1,s4
    80001fac:	41250533          	sub	a0,a0,s2
    80001fb0:	fffff097          	auipc	ra,0xfffff
    80001fb4:	200080e7          	jalr	512(ra) # 800011b0 <memmove>

    len -= n;
    80001fb8:	409989b3          	sub	s3,s3,s1
    src += n;
    80001fbc:	009a0a33          	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80001fc0:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001fc4:	02098863          	beqz	s3,80001ff4 <copyout+0xa4>
    va0 = PGROUNDDOWN(dstva);
    80001fc8:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001fcc:	00090593          	mv	a1,s2
    80001fd0:	000b0513          	mv	a0,s6
    80001fd4:	fffff097          	auipc	ra,0xfffff
    80001fd8:	644080e7          	jalr	1604(ra) # 80001618 <walkaddr>
    if(pa0 == 0)
    80001fdc:	02050463          	beqz	a0,80002004 <copyout+0xb4>
    n = PGSIZE - (dstva - va0);
    80001fe0:	418904b3          	sub	s1,s2,s8
    80001fe4:	015484b3          	add	s1,s1,s5
    80001fe8:	fa99fce3          	bgeu	s3,s1,80001fa0 <copyout+0x50>
    80001fec:	00098493          	mv	s1,s3
    80001ff0:	fb1ff06f          	j	80001fa0 <copyout+0x50>
  }
  return 0;
    80001ff4:	00000513          	li	a0,0
    80001ff8:	0100006f          	j	80002008 <copyout+0xb8>
    80001ffc:	00000513          	li	a0,0
}
    80002000:	00008067          	ret
      return -1;
    80002004:	fff00513          	li	a0,-1
}
    80002008:	04813083          	ld	ra,72(sp)
    8000200c:	04013403          	ld	s0,64(sp)
    80002010:	03813483          	ld	s1,56(sp)
    80002014:	03013903          	ld	s2,48(sp)
    80002018:	02813983          	ld	s3,40(sp)
    8000201c:	02013a03          	ld	s4,32(sp)
    80002020:	01813a83          	ld	s5,24(sp)
    80002024:	01013b03          	ld	s6,16(sp)
    80002028:	00813b83          	ld	s7,8(sp)
    8000202c:	00013c03          	ld	s8,0(sp)
    80002030:	05010113          	add	sp,sp,80
    80002034:	00008067          	ret

0000000080002038 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80002038:	0a068663          	beqz	a3,800020e4 <copyin+0xac>
{
    8000203c:	fb010113          	add	sp,sp,-80
    80002040:	04113423          	sd	ra,72(sp)
    80002044:	04813023          	sd	s0,64(sp)
    80002048:	02913c23          	sd	s1,56(sp)
    8000204c:	03213823          	sd	s2,48(sp)
    80002050:	03313423          	sd	s3,40(sp)
    80002054:	03413023          	sd	s4,32(sp)
    80002058:	01513c23          	sd	s5,24(sp)
    8000205c:	01613823          	sd	s6,16(sp)
    80002060:	01713423          	sd	s7,8(sp)
    80002064:	01813023          	sd	s8,0(sp)
    80002068:	05010413          	add	s0,sp,80
    8000206c:	00050b13          	mv	s6,a0
    80002070:	00058a13          	mv	s4,a1
    80002074:	00060c13          	mv	s8,a2
    80002078:	00068993          	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    8000207c:	fffffbb7          	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80002080:	00001ab7          	lui	s5,0x1
    80002084:	02c0006f          	j	800020b0 <copyin+0x78>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80002088:	018505b3          	add	a1,a0,s8
    8000208c:	0004861b          	sext.w	a2,s1
    80002090:	412585b3          	sub	a1,a1,s2
    80002094:	000a0513          	mv	a0,s4
    80002098:	fffff097          	auipc	ra,0xfffff
    8000209c:	118080e7          	jalr	280(ra) # 800011b0 <memmove>

    len -= n;
    800020a0:	409989b3          	sub	s3,s3,s1
    dst += n;
    800020a4:	009a0a33          	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    800020a8:	01590c33          	add	s8,s2,s5
  while(len > 0){
    800020ac:	02098863          	beqz	s3,800020dc <copyin+0xa4>
    va0 = PGROUNDDOWN(srcva);
    800020b0:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    800020b4:	00090593          	mv	a1,s2
    800020b8:	000b0513          	mv	a0,s6
    800020bc:	fffff097          	auipc	ra,0xfffff
    800020c0:	55c080e7          	jalr	1372(ra) # 80001618 <walkaddr>
    if(pa0 == 0)
    800020c4:	02050463          	beqz	a0,800020ec <copyin+0xb4>
    n = PGSIZE - (srcva - va0);
    800020c8:	418904b3          	sub	s1,s2,s8
    800020cc:	015484b3          	add	s1,s1,s5
    800020d0:	fa99fce3          	bgeu	s3,s1,80002088 <copyin+0x50>
    800020d4:	00098493          	mv	s1,s3
    800020d8:	fb1ff06f          	j	80002088 <copyin+0x50>
  }
  return 0;
    800020dc:	00000513          	li	a0,0
    800020e0:	0100006f          	j	800020f0 <copyin+0xb8>
    800020e4:	00000513          	li	a0,0
}
    800020e8:	00008067          	ret
      return -1;
    800020ec:	fff00513          	li	a0,-1
}
    800020f0:	04813083          	ld	ra,72(sp)
    800020f4:	04013403          	ld	s0,64(sp)
    800020f8:	03813483          	ld	s1,56(sp)
    800020fc:	03013903          	ld	s2,48(sp)
    80002100:	02813983          	ld	s3,40(sp)
    80002104:	02013a03          	ld	s4,32(sp)
    80002108:	01813a83          	ld	s5,24(sp)
    8000210c:	01013b03          	ld	s6,16(sp)
    80002110:	00813b83          	ld	s7,8(sp)
    80002114:	00013c03          	ld	s8,0(sp)
    80002118:	05010113          	add	sp,sp,80
    8000211c:	00008067          	ret

0000000080002120 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80002120:	10068a63          	beqz	a3,80002234 <copyinstr+0x114>
{
    80002124:	fb010113          	add	sp,sp,-80
    80002128:	04113423          	sd	ra,72(sp)
    8000212c:	04813023          	sd	s0,64(sp)
    80002130:	02913c23          	sd	s1,56(sp)
    80002134:	03213823          	sd	s2,48(sp)
    80002138:	03313423          	sd	s3,40(sp)
    8000213c:	03413023          	sd	s4,32(sp)
    80002140:	01513c23          	sd	s5,24(sp)
    80002144:	01613823          	sd	s6,16(sp)
    80002148:	01713423          	sd	s7,8(sp)
    8000214c:	05010413          	add	s0,sp,80
    80002150:	00050a13          	mv	s4,a0
    80002154:	00058b13          	mv	s6,a1
    80002158:	00060b93          	mv	s7,a2
    8000215c:	00068493          	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80002160:	fffffab7          	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80002164:	000019b7          	lui	s3,0x1
    80002168:	0480006f          	j	800021b0 <copyinstr+0x90>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    8000216c:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80002170:	00100793          	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80002174:	fff7879b          	addw	a5,a5,-1
    80002178:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    8000217c:	04813083          	ld	ra,72(sp)
    80002180:	04013403          	ld	s0,64(sp)
    80002184:	03813483          	ld	s1,56(sp)
    80002188:	03013903          	ld	s2,48(sp)
    8000218c:	02813983          	ld	s3,40(sp)
    80002190:	02013a03          	ld	s4,32(sp)
    80002194:	01813a83          	ld	s5,24(sp)
    80002198:	01013b03          	ld	s6,16(sp)
    8000219c:	00813b83          	ld	s7,8(sp)
    800021a0:	05010113          	add	sp,sp,80
    800021a4:	00008067          	ret
    srcva = va0 + PGSIZE;
    800021a8:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    800021ac:	06048c63          	beqz	s1,80002224 <copyinstr+0x104>
    va0 = PGROUNDDOWN(srcva);
    800021b0:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    800021b4:	00090593          	mv	a1,s2
    800021b8:	000a0513          	mv	a0,s4
    800021bc:	fffff097          	auipc	ra,0xfffff
    800021c0:	45c080e7          	jalr	1116(ra) # 80001618 <walkaddr>
    if(pa0 == 0)
    800021c4:	06050463          	beqz	a0,8000222c <copyinstr+0x10c>
    n = PGSIZE - (srcva - va0);
    800021c8:	417906b3          	sub	a3,s2,s7
    800021cc:	013686b3          	add	a3,a3,s3
    800021d0:	00d4f463          	bgeu	s1,a3,800021d8 <copyinstr+0xb8>
    800021d4:	00048693          	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    800021d8:	01750533          	add	a0,a0,s7
    800021dc:	41250533          	sub	a0,a0,s2
    while(n > 0){
    800021e0:	fc0684e3          	beqz	a3,800021a8 <copyinstr+0x88>
    800021e4:	000b0793          	mv	a5,s6
    800021e8:	000b0813          	mv	a6,s6
      if(*p == '\0'){
    800021ec:	41650633          	sub	a2,a0,s6
    while(n > 0){
    800021f0:	00db06b3          	add	a3,s6,a3
    800021f4:	00078593          	mv	a1,a5
      if(*p == '\0'){
    800021f8:	00f60733          	add	a4,a2,a5
    800021fc:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffdb200>
    80002200:	f60706e3          	beqz	a4,8000216c <copyinstr+0x4c>
        *dst = *p;
    80002204:	00e78023          	sb	a4,0(a5)
      dst++;
    80002208:	00178793          	add	a5,a5,1
    while(n > 0){
    8000220c:	fed794e3          	bne	a5,a3,800021f4 <copyinstr+0xd4>
    80002210:	fff48493          	add	s1,s1,-1
    80002214:	010484b3          	add	s1,s1,a6
      --max;
    80002218:	40b484b3          	sub	s1,s1,a1
      dst++;
    8000221c:	00078b13          	mv	s6,a5
    80002220:	f89ff06f          	j	800021a8 <copyinstr+0x88>
    80002224:	00000793          	li	a5,0
    80002228:	f4dff06f          	j	80002174 <copyinstr+0x54>
      return -1;
    8000222c:	fff00513          	li	a0,-1
    80002230:	f4dff06f          	j	8000217c <copyinstr+0x5c>
  int got_null = 0;
    80002234:	00000793          	li	a5,0
  if(got_null){
    80002238:	fff7879b          	addw	a5,a5,-1
    8000223c:	0007851b          	sext.w	a0,a5
}
    80002240:	00008067          	ret

0000000080002244 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80002244:	fc010113          	add	sp,sp,-64
    80002248:	02113c23          	sd	ra,56(sp)
    8000224c:	02813823          	sd	s0,48(sp)
    80002250:	02913423          	sd	s1,40(sp)
    80002254:	03213023          	sd	s2,32(sp)
    80002258:	01313c23          	sd	s3,24(sp)
    8000225c:	01413823          	sd	s4,16(sp)
    80002260:	01513423          	sd	s5,8(sp)
    80002264:	01613023          	sd	s6,0(sp)
    80002268:	04010413          	add	s0,sp,64
    8000226c:	00050993          	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80002270:	00011497          	auipc	s1,0x11
    80002274:	db048493          	add	s1,s1,-592 # 80013020 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80002278:	00048b13          	mv	s6,s1
    8000227c:	00008a97          	auipc	s5,0x8
    80002280:	d84a8a93          	add	s5,s5,-636 # 8000a000 <etext>
    80002284:	04000937          	lui	s2,0x4000
    80002288:	fff90913          	add	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    8000228c:	00c91913          	sll	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80002290:	00016a17          	auipc	s4,0x16
    80002294:	790a0a13          	add	s4,s4,1936 # 80018a20 <tickslock>
    char *pa = kalloc();
    80002298:	fffff097          	auipc	ra,0xfffff
    8000229c:	bc0080e7          	jalr	-1088(ra) # 80000e58 <kalloc>
    800022a0:	00050613          	mv	a2,a0
    if(pa == 0)
    800022a4:	06050263          	beqz	a0,80002308 <proc_mapstacks+0xc4>
    uint64 va = KSTACK((int) (p - proc));
    800022a8:	416485b3          	sub	a1,s1,s6
    800022ac:	4035d593          	sra	a1,a1,0x3
    800022b0:	000ab783          	ld	a5,0(s5)
    800022b4:	02f585b3          	mul	a1,a1,a5
    800022b8:	0015859b          	addw	a1,a1,1
    800022bc:	00d5959b          	sllw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800022c0:	00600713          	li	a4,6
    800022c4:	000016b7          	lui	a3,0x1
    800022c8:	40b905b3          	sub	a1,s2,a1
    800022cc:	00098513          	mv	a0,s3
    800022d0:	fffff097          	auipc	ra,0xfffff
    800022d4:	4ac080e7          	jalr	1196(ra) # 8000177c <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    800022d8:	16848493          	add	s1,s1,360
    800022dc:	fb449ee3          	bne	s1,s4,80002298 <proc_mapstacks+0x54>
  }
}
    800022e0:	03813083          	ld	ra,56(sp)
    800022e4:	03013403          	ld	s0,48(sp)
    800022e8:	02813483          	ld	s1,40(sp)
    800022ec:	02013903          	ld	s2,32(sp)
    800022f0:	01813983          	ld	s3,24(sp)
    800022f4:	01013a03          	ld	s4,16(sp)
    800022f8:	00813a83          	ld	s5,8(sp)
    800022fc:	00013b03          	ld	s6,0(sp)
    80002300:	04010113          	add	sp,sp,64
    80002304:	00008067          	ret
      panic("kalloc");
    80002308:	00008517          	auipc	a0,0x8
    8000230c:	f8850513          	add	a0,a0,-120 # 8000a290 <digits+0x250>
    80002310:	ffffe097          	auipc	ra,0xffffe
    80002314:	3b8080e7          	jalr	952(ra) # 800006c8 <panic>

0000000080002318 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80002318:	fc010113          	add	sp,sp,-64
    8000231c:	02113c23          	sd	ra,56(sp)
    80002320:	02813823          	sd	s0,48(sp)
    80002324:	02913423          	sd	s1,40(sp)
    80002328:	03213023          	sd	s2,32(sp)
    8000232c:	01313c23          	sd	s3,24(sp)
    80002330:	01413823          	sd	s4,16(sp)
    80002334:	01513423          	sd	s5,8(sp)
    80002338:	01613023          	sd	s6,0(sp)
    8000233c:	04010413          	add	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80002340:	00008597          	auipc	a1,0x8
    80002344:	f5858593          	add	a1,a1,-168 # 8000a298 <digits+0x258>
    80002348:	00011517          	auipc	a0,0x11
    8000234c:	8a850513          	add	a0,a0,-1880 # 80012bf0 <pid_lock>
    80002350:	fffff097          	auipc	ra,0xfffff
    80002354:	b90080e7          	jalr	-1136(ra) # 80000ee0 <initlock>
  initlock(&wait_lock, "wait_lock");
    80002358:	00008597          	auipc	a1,0x8
    8000235c:	f4858593          	add	a1,a1,-184 # 8000a2a0 <digits+0x260>
    80002360:	00011517          	auipc	a0,0x11
    80002364:	8a850513          	add	a0,a0,-1880 # 80012c08 <wait_lock>
    80002368:	fffff097          	auipc	ra,0xfffff
    8000236c:	b78080e7          	jalr	-1160(ra) # 80000ee0 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002370:	00011497          	auipc	s1,0x11
    80002374:	cb048493          	add	s1,s1,-848 # 80013020 <proc>
      initlock(&p->lock, "proc");
    80002378:	00008b17          	auipc	s6,0x8
    8000237c:	f38b0b13          	add	s6,s6,-200 # 8000a2b0 <digits+0x270>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80002380:	00048a93          	mv	s5,s1
    80002384:	00008a17          	auipc	s4,0x8
    80002388:	c7ca0a13          	add	s4,s4,-900 # 8000a000 <etext>
    8000238c:	04000937          	lui	s2,0x4000
    80002390:	fff90913          	add	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80002394:	00c91913          	sll	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80002398:	00016997          	auipc	s3,0x16
    8000239c:	68898993          	add	s3,s3,1672 # 80018a20 <tickslock>
      initlock(&p->lock, "proc");
    800023a0:	000b0593          	mv	a1,s6
    800023a4:	00048513          	mv	a0,s1
    800023a8:	fffff097          	auipc	ra,0xfffff
    800023ac:	b38080e7          	jalr	-1224(ra) # 80000ee0 <initlock>
      p->state = UNUSED;
    800023b0:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    800023b4:	415487b3          	sub	a5,s1,s5
    800023b8:	4037d793          	sra	a5,a5,0x3
    800023bc:	000a3703          	ld	a4,0(s4)
    800023c0:	02e787b3          	mul	a5,a5,a4
    800023c4:	0017879b          	addw	a5,a5,1
    800023c8:	00d7979b          	sllw	a5,a5,0xd
    800023cc:	40f907b3          	sub	a5,s2,a5
    800023d0:	04f4b023          	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    800023d4:	16848493          	add	s1,s1,360
    800023d8:	fd3494e3          	bne	s1,s3,800023a0 <procinit+0x88>
  }
}
    800023dc:	03813083          	ld	ra,56(sp)
    800023e0:	03013403          	ld	s0,48(sp)
    800023e4:	02813483          	ld	s1,40(sp)
    800023e8:	02013903          	ld	s2,32(sp)
    800023ec:	01813983          	ld	s3,24(sp)
    800023f0:	01013a03          	ld	s4,16(sp)
    800023f4:	00813a83          	ld	s5,8(sp)
    800023f8:	00013b03          	ld	s6,0(sp)
    800023fc:	04010113          	add	sp,sp,64
    80002400:	00008067          	ret

0000000080002404 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80002404:	ff010113          	add	sp,sp,-16
    80002408:	00813423          	sd	s0,8(sp)
    8000240c:	01010413          	add	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80002410:	00020513          	mv	a0,tp
  int id = r_tp();
  return id;
}
    80002414:	0005051b          	sext.w	a0,a0
    80002418:	00813403          	ld	s0,8(sp)
    8000241c:	01010113          	add	sp,sp,16
    80002420:	00008067          	ret

0000000080002424 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80002424:	ff010113          	add	sp,sp,-16
    80002428:	00813423          	sd	s0,8(sp)
    8000242c:	01010413          	add	s0,sp,16
    80002430:	00020793          	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80002434:	0007879b          	sext.w	a5,a5
    80002438:	00779793          	sll	a5,a5,0x7
  return c;
}
    8000243c:	00010517          	auipc	a0,0x10
    80002440:	7e450513          	add	a0,a0,2020 # 80012c20 <cpus>
    80002444:	00f50533          	add	a0,a0,a5
    80002448:	00813403          	ld	s0,8(sp)
    8000244c:	01010113          	add	sp,sp,16
    80002450:	00008067          	ret

0000000080002454 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80002454:	fe010113          	add	sp,sp,-32
    80002458:	00113c23          	sd	ra,24(sp)
    8000245c:	00813823          	sd	s0,16(sp)
    80002460:	00913423          	sd	s1,8(sp)
    80002464:	02010413          	add	s0,sp,32
  push_off();
    80002468:	fffff097          	auipc	ra,0xfffff
    8000246c:	ae8080e7          	jalr	-1304(ra) # 80000f50 <push_off>
    80002470:	00020793          	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80002474:	0007879b          	sext.w	a5,a5
    80002478:	00779793          	sll	a5,a5,0x7
    8000247c:	00010717          	auipc	a4,0x10
    80002480:	77470713          	add	a4,a4,1908 # 80012bf0 <pid_lock>
    80002484:	00f707b3          	add	a5,a4,a5
    80002488:	0307b483          	ld	s1,48(a5)
  pop_off();
    8000248c:	fffff097          	auipc	ra,0xfffff
    80002490:	bb0080e7          	jalr	-1104(ra) # 8000103c <pop_off>
  return p;
}
    80002494:	00048513          	mv	a0,s1
    80002498:	01813083          	ld	ra,24(sp)
    8000249c:	01013403          	ld	s0,16(sp)
    800024a0:	00813483          	ld	s1,8(sp)
    800024a4:	02010113          	add	sp,sp,32
    800024a8:	00008067          	ret

00000000800024ac <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    800024ac:	ff010113          	add	sp,sp,-16
    800024b0:	00113423          	sd	ra,8(sp)
    800024b4:	00813023          	sd	s0,0(sp)
    800024b8:	01010413          	add	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    800024bc:	00000097          	auipc	ra,0x0
    800024c0:	f98080e7          	jalr	-104(ra) # 80002454 <myproc>
    800024c4:	fffff097          	auipc	ra,0xfffff
    800024c8:	bf8080e7          	jalr	-1032(ra) # 800010bc <release>

  if (first) {
    800024cc:	00008797          	auipc	a5,0x8
    800024d0:	4347a783          	lw	a5,1076(a5) # 8000a900 <first.1>
    800024d4:	00079e63          	bnez	a5,800024f0 <forkret+0x44>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    800024d8:	00001097          	auipc	ra,0x1
    800024dc:	140080e7          	jalr	320(ra) # 80003618 <usertrapret>
}
    800024e0:	00813083          	ld	ra,8(sp)
    800024e4:	00013403          	ld	s0,0(sp)
    800024e8:	01010113          	add	sp,sp,16
    800024ec:	00008067          	ret
    first = 0;
    800024f0:	00008797          	auipc	a5,0x8
    800024f4:	4007a823          	sw	zero,1040(a5) # 8000a900 <first.1>
    fsinit(ROOTDEV);
    800024f8:	00100513          	li	a0,1
    800024fc:	00002097          	auipc	ra,0x2
    80002500:	384080e7          	jalr	900(ra) # 80004880 <fsinit>
    80002504:	fd5ff06f          	j	800024d8 <forkret+0x2c>

0000000080002508 <allocpid>:
{
    80002508:	fe010113          	add	sp,sp,-32
    8000250c:	00113c23          	sd	ra,24(sp)
    80002510:	00813823          	sd	s0,16(sp)
    80002514:	00913423          	sd	s1,8(sp)
    80002518:	01213023          	sd	s2,0(sp)
    8000251c:	02010413          	add	s0,sp,32
  acquire(&pid_lock);
    80002520:	00010917          	auipc	s2,0x10
    80002524:	6d090913          	add	s2,s2,1744 # 80012bf0 <pid_lock>
    80002528:	00090513          	mv	a0,s2
    8000252c:	fffff097          	auipc	ra,0xfffff
    80002530:	a98080e7          	jalr	-1384(ra) # 80000fc4 <acquire>
  pid = nextpid;
    80002534:	00008797          	auipc	a5,0x8
    80002538:	3d078793          	add	a5,a5,976 # 8000a904 <nextpid>
    8000253c:	0007a483          	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80002540:	0014871b          	addw	a4,s1,1
    80002544:	00e7a023          	sw	a4,0(a5)
  release(&pid_lock);
    80002548:	00090513          	mv	a0,s2
    8000254c:	fffff097          	auipc	ra,0xfffff
    80002550:	b70080e7          	jalr	-1168(ra) # 800010bc <release>
}
    80002554:	00048513          	mv	a0,s1
    80002558:	01813083          	ld	ra,24(sp)
    8000255c:	01013403          	ld	s0,16(sp)
    80002560:	00813483          	ld	s1,8(sp)
    80002564:	00013903          	ld	s2,0(sp)
    80002568:	02010113          	add	sp,sp,32
    8000256c:	00008067          	ret

0000000080002570 <proc_pagetable>:
{
    80002570:	fe010113          	add	sp,sp,-32
    80002574:	00113c23          	sd	ra,24(sp)
    80002578:	00813823          	sd	s0,16(sp)
    8000257c:	00913423          	sd	s1,8(sp)
    80002580:	01213023          	sd	s2,0(sp)
    80002584:	02010413          	add	s0,sp,32
    80002588:	00050913          	mv	s2,a0
  pagetable = uvmcreate();
    8000258c:	fffff097          	auipc	ra,0xfffff
    80002590:	4a4080e7          	jalr	1188(ra) # 80001a30 <uvmcreate>
    80002594:	00050493          	mv	s1,a0
  if(pagetable == 0)
    80002598:	04050a63          	beqz	a0,800025ec <proc_pagetable+0x7c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    8000259c:	00a00713          	li	a4,10
    800025a0:	00007697          	auipc	a3,0x7
    800025a4:	a6068693          	add	a3,a3,-1440 # 80009000 <_trampoline>
    800025a8:	00001637          	lui	a2,0x1
    800025ac:	040005b7          	lui	a1,0x4000
    800025b0:	fff58593          	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800025b4:	00c59593          	sll	a1,a1,0xc
    800025b8:	fffff097          	auipc	ra,0xfffff
    800025bc:	0cc080e7          	jalr	204(ra) # 80001684 <mappages>
    800025c0:	04054463          	bltz	a0,80002608 <proc_pagetable+0x98>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    800025c4:	00600713          	li	a4,6
    800025c8:	05893683          	ld	a3,88(s2)
    800025cc:	00001637          	lui	a2,0x1
    800025d0:	020005b7          	lui	a1,0x2000
    800025d4:	fff58593          	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800025d8:	00d59593          	sll	a1,a1,0xd
    800025dc:	00048513          	mv	a0,s1
    800025e0:	fffff097          	auipc	ra,0xfffff
    800025e4:	0a4080e7          	jalr	164(ra) # 80001684 <mappages>
    800025e8:	02054c63          	bltz	a0,80002620 <proc_pagetable+0xb0>
}
    800025ec:	00048513          	mv	a0,s1
    800025f0:	01813083          	ld	ra,24(sp)
    800025f4:	01013403          	ld	s0,16(sp)
    800025f8:	00813483          	ld	s1,8(sp)
    800025fc:	00013903          	ld	s2,0(sp)
    80002600:	02010113          	add	sp,sp,32
    80002604:	00008067          	ret
    uvmfree(pagetable, 0);
    80002608:	00000593          	li	a1,0
    8000260c:	00048513          	mv	a0,s1
    80002610:	fffff097          	auipc	ra,0xfffff
    80002614:	758080e7          	jalr	1880(ra) # 80001d68 <uvmfree>
    return 0;
    80002618:	00000493          	li	s1,0
    8000261c:	fd1ff06f          	j	800025ec <proc_pagetable+0x7c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80002620:	00000693          	li	a3,0
    80002624:	00100613          	li	a2,1
    80002628:	040005b7          	lui	a1,0x4000
    8000262c:	fff58593          	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80002630:	00c59593          	sll	a1,a1,0xc
    80002634:	00048513          	mv	a0,s1
    80002638:	fffff097          	auipc	ra,0xfffff
    8000263c:	2e4080e7          	jalr	740(ra) # 8000191c <uvmunmap>
    uvmfree(pagetable, 0);
    80002640:	00000593          	li	a1,0
    80002644:	00048513          	mv	a0,s1
    80002648:	fffff097          	auipc	ra,0xfffff
    8000264c:	720080e7          	jalr	1824(ra) # 80001d68 <uvmfree>
    return 0;
    80002650:	00000493          	li	s1,0
    80002654:	f99ff06f          	j	800025ec <proc_pagetable+0x7c>

0000000080002658 <proc_freepagetable>:
{
    80002658:	fe010113          	add	sp,sp,-32
    8000265c:	00113c23          	sd	ra,24(sp)
    80002660:	00813823          	sd	s0,16(sp)
    80002664:	00913423          	sd	s1,8(sp)
    80002668:	01213023          	sd	s2,0(sp)
    8000266c:	02010413          	add	s0,sp,32
    80002670:	00050493          	mv	s1,a0
    80002674:	00058913          	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80002678:	00000693          	li	a3,0
    8000267c:	00100613          	li	a2,1
    80002680:	040005b7          	lui	a1,0x4000
    80002684:	fff58593          	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80002688:	00c59593          	sll	a1,a1,0xc
    8000268c:	fffff097          	auipc	ra,0xfffff
    80002690:	290080e7          	jalr	656(ra) # 8000191c <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80002694:	00000693          	li	a3,0
    80002698:	00100613          	li	a2,1
    8000269c:	020005b7          	lui	a1,0x2000
    800026a0:	fff58593          	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800026a4:	00d59593          	sll	a1,a1,0xd
    800026a8:	00048513          	mv	a0,s1
    800026ac:	fffff097          	auipc	ra,0xfffff
    800026b0:	270080e7          	jalr	624(ra) # 8000191c <uvmunmap>
  uvmfree(pagetable, sz);
    800026b4:	00090593          	mv	a1,s2
    800026b8:	00048513          	mv	a0,s1
    800026bc:	fffff097          	auipc	ra,0xfffff
    800026c0:	6ac080e7          	jalr	1708(ra) # 80001d68 <uvmfree>
}
    800026c4:	01813083          	ld	ra,24(sp)
    800026c8:	01013403          	ld	s0,16(sp)
    800026cc:	00813483          	ld	s1,8(sp)
    800026d0:	00013903          	ld	s2,0(sp)
    800026d4:	02010113          	add	sp,sp,32
    800026d8:	00008067          	ret

00000000800026dc <freeproc>:
{
    800026dc:	fe010113          	add	sp,sp,-32
    800026e0:	00113c23          	sd	ra,24(sp)
    800026e4:	00813823          	sd	s0,16(sp)
    800026e8:	00913423          	sd	s1,8(sp)
    800026ec:	02010413          	add	s0,sp,32
    800026f0:	00050493          	mv	s1,a0
  if(p->trapframe)
    800026f4:	05853503          	ld	a0,88(a0)
    800026f8:	00050663          	beqz	a0,80002704 <freeproc+0x28>
    kfree((void*)p->trapframe);
    800026fc:	ffffe097          	auipc	ra,0xffffe
    80002700:	5f0080e7          	jalr	1520(ra) # 80000cec <kfree>
  p->trapframe = 0;
    80002704:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80002708:	0504b503          	ld	a0,80(s1)
    8000270c:	00050863          	beqz	a0,8000271c <freeproc+0x40>
    proc_freepagetable(p->pagetable, p->sz);
    80002710:	0484b583          	ld	a1,72(s1)
    80002714:	00000097          	auipc	ra,0x0
    80002718:	f44080e7          	jalr	-188(ra) # 80002658 <proc_freepagetable>
  p->pagetable = 0;
    8000271c:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80002720:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80002724:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80002728:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    8000272c:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80002730:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80002734:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80002738:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    8000273c:	0004ac23          	sw	zero,24(s1)
}
    80002740:	01813083          	ld	ra,24(sp)
    80002744:	01013403          	ld	s0,16(sp)
    80002748:	00813483          	ld	s1,8(sp)
    8000274c:	02010113          	add	sp,sp,32
    80002750:	00008067          	ret

0000000080002754 <allocproc>:
{
    80002754:	fe010113          	add	sp,sp,-32
    80002758:	00113c23          	sd	ra,24(sp)
    8000275c:	00813823          	sd	s0,16(sp)
    80002760:	00913423          	sd	s1,8(sp)
    80002764:	01213023          	sd	s2,0(sp)
    80002768:	02010413          	add	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000276c:	00011497          	auipc	s1,0x11
    80002770:	8b448493          	add	s1,s1,-1868 # 80013020 <proc>
    80002774:	00016917          	auipc	s2,0x16
    80002778:	2ac90913          	add	s2,s2,684 # 80018a20 <tickslock>
    acquire(&p->lock);
    8000277c:	00048513          	mv	a0,s1
    80002780:	fffff097          	auipc	ra,0xfffff
    80002784:	844080e7          	jalr	-1980(ra) # 80000fc4 <acquire>
    if(p->state == UNUSED) {
    80002788:	0184a783          	lw	a5,24(s1)
    8000278c:	02078063          	beqz	a5,800027ac <allocproc+0x58>
      release(&p->lock);
    80002790:	00048513          	mv	a0,s1
    80002794:	fffff097          	auipc	ra,0xfffff
    80002798:	928080e7          	jalr	-1752(ra) # 800010bc <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000279c:	16848493          	add	s1,s1,360
    800027a0:	fd249ee3          	bne	s1,s2,8000277c <allocproc+0x28>
  return 0;
    800027a4:	00000493          	li	s1,0
    800027a8:	0740006f          	j	8000281c <allocproc+0xc8>
  p->pid = allocpid();
    800027ac:	00000097          	auipc	ra,0x0
    800027b0:	d5c080e7          	jalr	-676(ra) # 80002508 <allocpid>
    800027b4:	02a4a823          	sw	a0,48(s1)
  p->state = USED;
    800027b8:	00100793          	li	a5,1
    800027bc:	00f4ac23          	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800027c0:	ffffe097          	auipc	ra,0xffffe
    800027c4:	698080e7          	jalr	1688(ra) # 80000e58 <kalloc>
    800027c8:	00050913          	mv	s2,a0
    800027cc:	04a4bc23          	sd	a0,88(s1)
    800027d0:	06050463          	beqz	a0,80002838 <allocproc+0xe4>
  p->pagetable = proc_pagetable(p);
    800027d4:	00048513          	mv	a0,s1
    800027d8:	00000097          	auipc	ra,0x0
    800027dc:	d98080e7          	jalr	-616(ra) # 80002570 <proc_pagetable>
    800027e0:	00050913          	mv	s2,a0
    800027e4:	04a4b823          	sd	a0,80(s1)
  if(p->pagetable == 0){
    800027e8:	06050863          	beqz	a0,80002858 <allocproc+0x104>
  memset(&p->context, 0, sizeof(p->context));
    800027ec:	07000613          	li	a2,112
    800027f0:	00000593          	li	a1,0
    800027f4:	06048513          	add	a0,s1,96
    800027f8:	fffff097          	auipc	ra,0xfffff
    800027fc:	924080e7          	jalr	-1756(ra) # 8000111c <memset>
  p->context.ra = (uint64)forkret;
    80002800:	00000797          	auipc	a5,0x0
    80002804:	cac78793          	add	a5,a5,-852 # 800024ac <forkret>
    80002808:	06f4b023          	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000280c:	0404b783          	ld	a5,64(s1)
    80002810:	00001737          	lui	a4,0x1
    80002814:	00e787b3          	add	a5,a5,a4
    80002818:	06f4b423          	sd	a5,104(s1)
}
    8000281c:	00048513          	mv	a0,s1
    80002820:	01813083          	ld	ra,24(sp)
    80002824:	01013403          	ld	s0,16(sp)
    80002828:	00813483          	ld	s1,8(sp)
    8000282c:	00013903          	ld	s2,0(sp)
    80002830:	02010113          	add	sp,sp,32
    80002834:	00008067          	ret
    freeproc(p);
    80002838:	00048513          	mv	a0,s1
    8000283c:	00000097          	auipc	ra,0x0
    80002840:	ea0080e7          	jalr	-352(ra) # 800026dc <freeproc>
    release(&p->lock);
    80002844:	00048513          	mv	a0,s1
    80002848:	fffff097          	auipc	ra,0xfffff
    8000284c:	874080e7          	jalr	-1932(ra) # 800010bc <release>
    return 0;
    80002850:	00090493          	mv	s1,s2
    80002854:	fc9ff06f          	j	8000281c <allocproc+0xc8>
    freeproc(p);
    80002858:	00048513          	mv	a0,s1
    8000285c:	00000097          	auipc	ra,0x0
    80002860:	e80080e7          	jalr	-384(ra) # 800026dc <freeproc>
    release(&p->lock);
    80002864:	00048513          	mv	a0,s1
    80002868:	fffff097          	auipc	ra,0xfffff
    8000286c:	854080e7          	jalr	-1964(ra) # 800010bc <release>
    return 0;
    80002870:	00090493          	mv	s1,s2
    80002874:	fa9ff06f          	j	8000281c <allocproc+0xc8>

0000000080002878 <userinit>:
{
    80002878:	fe010113          	add	sp,sp,-32
    8000287c:	00113c23          	sd	ra,24(sp)
    80002880:	00813823          	sd	s0,16(sp)
    80002884:	00913423          	sd	s1,8(sp)
    80002888:	02010413          	add	s0,sp,32
  p = allocproc();
    8000288c:	00000097          	auipc	ra,0x0
    80002890:	ec8080e7          	jalr	-312(ra) # 80002754 <allocproc>
    80002894:	00050493          	mv	s1,a0
  initproc = p;
    80002898:	00008797          	auipc	a5,0x8
    8000289c:	0ea7b023          	sd	a0,224(a5) # 8000a978 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    800028a0:	03400613          	li	a2,52
    800028a4:	00008597          	auipc	a1,0x8
    800028a8:	06c58593          	add	a1,a1,108 # 8000a910 <initcode>
    800028ac:	05053503          	ld	a0,80(a0)
    800028b0:	fffff097          	auipc	ra,0xfffff
    800028b4:	1cc080e7          	jalr	460(ra) # 80001a7c <uvmfirst>
  p->sz = PGSIZE;
    800028b8:	000017b7          	lui	a5,0x1
    800028bc:	04f4b423          	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800028c0:	0584b703          	ld	a4,88(s1)
    800028c4:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800028c8:	0584b703          	ld	a4,88(s1)
    800028cc:	02f73823          	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800028d0:	01000613          	li	a2,16
    800028d4:	00008597          	auipc	a1,0x8
    800028d8:	9e458593          	add	a1,a1,-1564 # 8000a2b8 <digits+0x278>
    800028dc:	15848513          	add	a0,s1,344
    800028e0:	fffff097          	auipc	ra,0xfffff
    800028e4:	a3c080e7          	jalr	-1476(ra) # 8000131c <safestrcpy>
  p->cwd = namei("/");
    800028e8:	00008517          	auipc	a0,0x8
    800028ec:	9e050513          	add	a0,a0,-1568 # 8000a2c8 <digits+0x288>
    800028f0:	00003097          	auipc	ra,0x3
    800028f4:	dd0080e7          	jalr	-560(ra) # 800056c0 <namei>
    800028f8:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800028fc:	00300793          	li	a5,3
    80002900:	00f4ac23          	sw	a5,24(s1)
  release(&p->lock);
    80002904:	00048513          	mv	a0,s1
    80002908:	ffffe097          	auipc	ra,0xffffe
    8000290c:	7b4080e7          	jalr	1972(ra) # 800010bc <release>
}
    80002910:	01813083          	ld	ra,24(sp)
    80002914:	01013403          	ld	s0,16(sp)
    80002918:	00813483          	ld	s1,8(sp)
    8000291c:	02010113          	add	sp,sp,32
    80002920:	00008067          	ret

0000000080002924 <growproc>:
{
    80002924:	fe010113          	add	sp,sp,-32
    80002928:	00113c23          	sd	ra,24(sp)
    8000292c:	00813823          	sd	s0,16(sp)
    80002930:	00913423          	sd	s1,8(sp)
    80002934:	01213023          	sd	s2,0(sp)
    80002938:	02010413          	add	s0,sp,32
    8000293c:	00050913          	mv	s2,a0
  struct proc *p = myproc();
    80002940:	00000097          	auipc	ra,0x0
    80002944:	b14080e7          	jalr	-1260(ra) # 80002454 <myproc>
    80002948:	00050493          	mv	s1,a0
  sz = p->sz;
    8000294c:	04853583          	ld	a1,72(a0)
  if(n > 0){
    80002950:	03204463          	bgtz	s2,80002978 <growproc+0x54>
  } else if(n < 0){
    80002954:	04094463          	bltz	s2,8000299c <growproc+0x78>
  p->sz = sz;
    80002958:	04b4b423          	sd	a1,72(s1)
  return 0;
    8000295c:	00000513          	li	a0,0
}
    80002960:	01813083          	ld	ra,24(sp)
    80002964:	01013403          	ld	s0,16(sp)
    80002968:	00813483          	ld	s1,8(sp)
    8000296c:	00013903          	ld	s2,0(sp)
    80002970:	02010113          	add	sp,sp,32
    80002974:	00008067          	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80002978:	00400693          	li	a3,4
    8000297c:	00b90633          	add	a2,s2,a1
    80002980:	05053503          	ld	a0,80(a0)
    80002984:	fffff097          	auipc	ra,0xfffff
    80002988:	220080e7          	jalr	544(ra) # 80001ba4 <uvmalloc>
    8000298c:	00050593          	mv	a1,a0
    80002990:	fc0514e3          	bnez	a0,80002958 <growproc+0x34>
      return -1;
    80002994:	fff00513          	li	a0,-1
    80002998:	fc9ff06f          	j	80002960 <growproc+0x3c>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000299c:	00b90633          	add	a2,s2,a1
    800029a0:	05053503          	ld	a0,80(a0)
    800029a4:	fffff097          	auipc	ra,0xfffff
    800029a8:	188080e7          	jalr	392(ra) # 80001b2c <uvmdealloc>
    800029ac:	00050593          	mv	a1,a0
    800029b0:	fa9ff06f          	j	80002958 <growproc+0x34>

00000000800029b4 <fork>:
{
    800029b4:	fc010113          	add	sp,sp,-64
    800029b8:	02113c23          	sd	ra,56(sp)
    800029bc:	02813823          	sd	s0,48(sp)
    800029c0:	02913423          	sd	s1,40(sp)
    800029c4:	03213023          	sd	s2,32(sp)
    800029c8:	01313c23          	sd	s3,24(sp)
    800029cc:	01413823          	sd	s4,16(sp)
    800029d0:	01513423          	sd	s5,8(sp)
    800029d4:	04010413          	add	s0,sp,64
  struct proc *p = myproc();
    800029d8:	00000097          	auipc	ra,0x0
    800029dc:	a7c080e7          	jalr	-1412(ra) # 80002454 <myproc>
    800029e0:	00050a93          	mv	s5,a0
  if((np = allocproc()) == 0){
    800029e4:	00000097          	auipc	ra,0x0
    800029e8:	d70080e7          	jalr	-656(ra) # 80002754 <allocproc>
    800029ec:	16050063          	beqz	a0,80002b4c <fork+0x198>
    800029f0:	00050a13          	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800029f4:	048ab603          	ld	a2,72(s5)
    800029f8:	05053583          	ld	a1,80(a0)
    800029fc:	050ab503          	ld	a0,80(s5)
    80002a00:	fffff097          	auipc	ra,0xfffff
    80002a04:	3c8080e7          	jalr	968(ra) # 80001dc8 <uvmcopy>
    80002a08:	06054063          	bltz	a0,80002a68 <fork+0xb4>
  np->sz = p->sz;
    80002a0c:	048ab783          	ld	a5,72(s5)
    80002a10:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80002a14:	058ab683          	ld	a3,88(s5)
    80002a18:	00068793          	mv	a5,a3
    80002a1c:	058a3703          	ld	a4,88(s4)
    80002a20:	12068693          	add	a3,a3,288
    80002a24:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80002a28:	0087b503          	ld	a0,8(a5)
    80002a2c:	0107b583          	ld	a1,16(a5)
    80002a30:	0187b603          	ld	a2,24(a5)
    80002a34:	01073023          	sd	a6,0(a4)
    80002a38:	00a73423          	sd	a0,8(a4)
    80002a3c:	00b73823          	sd	a1,16(a4)
    80002a40:	00c73c23          	sd	a2,24(a4)
    80002a44:	02078793          	add	a5,a5,32
    80002a48:	02070713          	add	a4,a4,32
    80002a4c:	fcd79ce3          	bne	a5,a3,80002a24 <fork+0x70>
  np->trapframe->a0 = 0;
    80002a50:	058a3783          	ld	a5,88(s4)
    80002a54:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80002a58:	0d0a8493          	add	s1,s5,208
    80002a5c:	0d0a0913          	add	s2,s4,208
    80002a60:	150a8993          	add	s3,s5,336
    80002a64:	0300006f          	j	80002a94 <fork+0xe0>
    freeproc(np);
    80002a68:	000a0513          	mv	a0,s4
    80002a6c:	00000097          	auipc	ra,0x0
    80002a70:	c70080e7          	jalr	-912(ra) # 800026dc <freeproc>
    release(&np->lock);
    80002a74:	000a0513          	mv	a0,s4
    80002a78:	ffffe097          	auipc	ra,0xffffe
    80002a7c:	644080e7          	jalr	1604(ra) # 800010bc <release>
    return -1;
    80002a80:	fff00913          	li	s2,-1
    80002a84:	0a00006f          	j	80002b24 <fork+0x170>
  for(i = 0; i < NOFILE; i++)
    80002a88:	00848493          	add	s1,s1,8
    80002a8c:	00890913          	add	s2,s2,8
    80002a90:	01348e63          	beq	s1,s3,80002aac <fork+0xf8>
    if(p->ofile[i])
    80002a94:	0004b503          	ld	a0,0(s1)
    80002a98:	fe0508e3          	beqz	a0,80002a88 <fork+0xd4>
      np->ofile[i] = filedup(p->ofile[i]);
    80002a9c:	00003097          	auipc	ra,0x3
    80002aa0:	510080e7          	jalr	1296(ra) # 80005fac <filedup>
    80002aa4:	00a93023          	sd	a0,0(s2)
    80002aa8:	fe1ff06f          	j	80002a88 <fork+0xd4>
  np->cwd = idup(p->cwd);
    80002aac:	150ab503          	ld	a0,336(s5)
    80002ab0:	00002097          	auipc	ra,0x2
    80002ab4:	0d0080e7          	jalr	208(ra) # 80004b80 <idup>
    80002ab8:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80002abc:	01000613          	li	a2,16
    80002ac0:	158a8593          	add	a1,s5,344
    80002ac4:	158a0513          	add	a0,s4,344
    80002ac8:	fffff097          	auipc	ra,0xfffff
    80002acc:	854080e7          	jalr	-1964(ra) # 8000131c <safestrcpy>
  pid = np->pid;
    80002ad0:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80002ad4:	000a0513          	mv	a0,s4
    80002ad8:	ffffe097          	auipc	ra,0xffffe
    80002adc:	5e4080e7          	jalr	1508(ra) # 800010bc <release>
  acquire(&wait_lock);
    80002ae0:	00010497          	auipc	s1,0x10
    80002ae4:	12848493          	add	s1,s1,296 # 80012c08 <wait_lock>
    80002ae8:	00048513          	mv	a0,s1
    80002aec:	ffffe097          	auipc	ra,0xffffe
    80002af0:	4d8080e7          	jalr	1240(ra) # 80000fc4 <acquire>
  np->parent = p;
    80002af4:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80002af8:	00048513          	mv	a0,s1
    80002afc:	ffffe097          	auipc	ra,0xffffe
    80002b00:	5c0080e7          	jalr	1472(ra) # 800010bc <release>
  acquire(&np->lock);
    80002b04:	000a0513          	mv	a0,s4
    80002b08:	ffffe097          	auipc	ra,0xffffe
    80002b0c:	4bc080e7          	jalr	1212(ra) # 80000fc4 <acquire>
  np->state = RUNNABLE;
    80002b10:	00300793          	li	a5,3
    80002b14:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80002b18:	000a0513          	mv	a0,s4
    80002b1c:	ffffe097          	auipc	ra,0xffffe
    80002b20:	5a0080e7          	jalr	1440(ra) # 800010bc <release>
}
    80002b24:	00090513          	mv	a0,s2
    80002b28:	03813083          	ld	ra,56(sp)
    80002b2c:	03013403          	ld	s0,48(sp)
    80002b30:	02813483          	ld	s1,40(sp)
    80002b34:	02013903          	ld	s2,32(sp)
    80002b38:	01813983          	ld	s3,24(sp)
    80002b3c:	01013a03          	ld	s4,16(sp)
    80002b40:	00813a83          	ld	s5,8(sp)
    80002b44:	04010113          	add	sp,sp,64
    80002b48:	00008067          	ret
    return -1;
    80002b4c:	fff00913          	li	s2,-1
    80002b50:	fd5ff06f          	j	80002b24 <fork+0x170>

0000000080002b54 <scheduler>:
{
    80002b54:	fc010113          	add	sp,sp,-64
    80002b58:	02113c23          	sd	ra,56(sp)
    80002b5c:	02813823          	sd	s0,48(sp)
    80002b60:	02913423          	sd	s1,40(sp)
    80002b64:	03213023          	sd	s2,32(sp)
    80002b68:	01313c23          	sd	s3,24(sp)
    80002b6c:	01413823          	sd	s4,16(sp)
    80002b70:	01513423          	sd	s5,8(sp)
    80002b74:	01613023          	sd	s6,0(sp)
    80002b78:	04010413          	add	s0,sp,64
    80002b7c:	00020793          	mv	a5,tp
  int id = r_tp();
    80002b80:	0007879b          	sext.w	a5,a5
  c->proc = 0;
    80002b84:	00779a93          	sll	s5,a5,0x7
    80002b88:	00010717          	auipc	a4,0x10
    80002b8c:	06870713          	add	a4,a4,104 # 80012bf0 <pid_lock>
    80002b90:	01570733          	add	a4,a4,s5
    80002b94:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80002b98:	00010717          	auipc	a4,0x10
    80002b9c:	09070713          	add	a4,a4,144 # 80012c28 <cpus+0x8>
    80002ba0:	00ea8ab3          	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80002ba4:	00300993          	li	s3,3
        p->state = RUNNING;
    80002ba8:	00400b13          	li	s6,4
        c->proc = p;
    80002bac:	00779793          	sll	a5,a5,0x7
    80002bb0:	00010a17          	auipc	s4,0x10
    80002bb4:	040a0a13          	add	s4,s4,64 # 80012bf0 <pid_lock>
    80002bb8:	00fa0a33          	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80002bbc:	00016917          	auipc	s2,0x16
    80002bc0:	e6490913          	add	s2,s2,-412 # 80018a20 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002bc4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002bc8:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002bcc:	10079073          	csrw	sstatus,a5
    80002bd0:	00010497          	auipc	s1,0x10
    80002bd4:	45048493          	add	s1,s1,1104 # 80013020 <proc>
    80002bd8:	0180006f          	j	80002bf0 <scheduler+0x9c>
      release(&p->lock);
    80002bdc:	00048513          	mv	a0,s1
    80002be0:	ffffe097          	auipc	ra,0xffffe
    80002be4:	4dc080e7          	jalr	1244(ra) # 800010bc <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80002be8:	16848493          	add	s1,s1,360
    80002bec:	fd248ce3          	beq	s1,s2,80002bc4 <scheduler+0x70>
      acquire(&p->lock);
    80002bf0:	00048513          	mv	a0,s1
    80002bf4:	ffffe097          	auipc	ra,0xffffe
    80002bf8:	3d0080e7          	jalr	976(ra) # 80000fc4 <acquire>
      if(p->state == RUNNABLE) {
    80002bfc:	0184a783          	lw	a5,24(s1)
    80002c00:	fd379ee3          	bne	a5,s3,80002bdc <scheduler+0x88>
        p->state = RUNNING;
    80002c04:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80002c08:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80002c0c:	06048593          	add	a1,s1,96
    80002c10:	000a8513          	mv	a0,s5
    80002c14:	00001097          	auipc	ra,0x1
    80002c18:	934080e7          	jalr	-1740(ra) # 80003548 <swtch>
        c->proc = 0;
    80002c1c:	020a3823          	sd	zero,48(s4)
    80002c20:	fbdff06f          	j	80002bdc <scheduler+0x88>

0000000080002c24 <sched>:
{
    80002c24:	fd010113          	add	sp,sp,-48
    80002c28:	02113423          	sd	ra,40(sp)
    80002c2c:	02813023          	sd	s0,32(sp)
    80002c30:	00913c23          	sd	s1,24(sp)
    80002c34:	01213823          	sd	s2,16(sp)
    80002c38:	01313423          	sd	s3,8(sp)
    80002c3c:	03010413          	add	s0,sp,48
  struct proc *p = myproc();
    80002c40:	00000097          	auipc	ra,0x0
    80002c44:	814080e7          	jalr	-2028(ra) # 80002454 <myproc>
    80002c48:	00050493          	mv	s1,a0
  if(!holding(&p->lock))
    80002c4c:	ffffe097          	auipc	ra,0xffffe
    80002c50:	2b8080e7          	jalr	696(ra) # 80000f04 <holding>
    80002c54:	0a050863          	beqz	a0,80002d04 <sched+0xe0>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002c58:	00020793          	mv	a5,tp
  if(mycpu()->noff != 1)
    80002c5c:	0007879b          	sext.w	a5,a5
    80002c60:	00779793          	sll	a5,a5,0x7
    80002c64:	00010717          	auipc	a4,0x10
    80002c68:	f8c70713          	add	a4,a4,-116 # 80012bf0 <pid_lock>
    80002c6c:	00f707b3          	add	a5,a4,a5
    80002c70:	0a87a703          	lw	a4,168(a5)
    80002c74:	00100793          	li	a5,1
    80002c78:	08f71e63          	bne	a4,a5,80002d14 <sched+0xf0>
  if(p->state == RUNNING)
    80002c7c:	0184a703          	lw	a4,24(s1)
    80002c80:	00400793          	li	a5,4
    80002c84:	0af70063          	beq	a4,a5,80002d24 <sched+0x100>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002c88:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002c8c:	0027f793          	and	a5,a5,2
  if(intr_get())
    80002c90:	0a079263          	bnez	a5,80002d34 <sched+0x110>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002c94:	00020793          	mv	a5,tp
  intena = mycpu()->intena;
    80002c98:	00010917          	auipc	s2,0x10
    80002c9c:	f5890913          	add	s2,s2,-168 # 80012bf0 <pid_lock>
    80002ca0:	0007879b          	sext.w	a5,a5
    80002ca4:	00779793          	sll	a5,a5,0x7
    80002ca8:	00f907b3          	add	a5,s2,a5
    80002cac:	0ac7a983          	lw	s3,172(a5)
    80002cb0:	00020793          	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80002cb4:	0007879b          	sext.w	a5,a5
    80002cb8:	00779793          	sll	a5,a5,0x7
    80002cbc:	00010597          	auipc	a1,0x10
    80002cc0:	f6c58593          	add	a1,a1,-148 # 80012c28 <cpus+0x8>
    80002cc4:	00b785b3          	add	a1,a5,a1
    80002cc8:	06048513          	add	a0,s1,96
    80002ccc:	00001097          	auipc	ra,0x1
    80002cd0:	87c080e7          	jalr	-1924(ra) # 80003548 <swtch>
    80002cd4:	00020793          	mv	a5,tp
  mycpu()->intena = intena;
    80002cd8:	0007879b          	sext.w	a5,a5
    80002cdc:	00779793          	sll	a5,a5,0x7
    80002ce0:	00f90933          	add	s2,s2,a5
    80002ce4:	0b392623          	sw	s3,172(s2)
}
    80002ce8:	02813083          	ld	ra,40(sp)
    80002cec:	02013403          	ld	s0,32(sp)
    80002cf0:	01813483          	ld	s1,24(sp)
    80002cf4:	01013903          	ld	s2,16(sp)
    80002cf8:	00813983          	ld	s3,8(sp)
    80002cfc:	03010113          	add	sp,sp,48
    80002d00:	00008067          	ret
    panic("sched p->lock");
    80002d04:	00007517          	auipc	a0,0x7
    80002d08:	5cc50513          	add	a0,a0,1484 # 8000a2d0 <digits+0x290>
    80002d0c:	ffffe097          	auipc	ra,0xffffe
    80002d10:	9bc080e7          	jalr	-1604(ra) # 800006c8 <panic>
    panic("sched locks");
    80002d14:	00007517          	auipc	a0,0x7
    80002d18:	5cc50513          	add	a0,a0,1484 # 8000a2e0 <digits+0x2a0>
    80002d1c:	ffffe097          	auipc	ra,0xffffe
    80002d20:	9ac080e7          	jalr	-1620(ra) # 800006c8 <panic>
    panic("sched running");
    80002d24:	00007517          	auipc	a0,0x7
    80002d28:	5cc50513          	add	a0,a0,1484 # 8000a2f0 <digits+0x2b0>
    80002d2c:	ffffe097          	auipc	ra,0xffffe
    80002d30:	99c080e7          	jalr	-1636(ra) # 800006c8 <panic>
    panic("sched interruptible");
    80002d34:	00007517          	auipc	a0,0x7
    80002d38:	5cc50513          	add	a0,a0,1484 # 8000a300 <digits+0x2c0>
    80002d3c:	ffffe097          	auipc	ra,0xffffe
    80002d40:	98c080e7          	jalr	-1652(ra) # 800006c8 <panic>

0000000080002d44 <yield>:
{
    80002d44:	fe010113          	add	sp,sp,-32
    80002d48:	00113c23          	sd	ra,24(sp)
    80002d4c:	00813823          	sd	s0,16(sp)
    80002d50:	00913423          	sd	s1,8(sp)
    80002d54:	02010413          	add	s0,sp,32
  struct proc *p = myproc();
    80002d58:	fffff097          	auipc	ra,0xfffff
    80002d5c:	6fc080e7          	jalr	1788(ra) # 80002454 <myproc>
    80002d60:	00050493          	mv	s1,a0
  acquire(&p->lock);
    80002d64:	ffffe097          	auipc	ra,0xffffe
    80002d68:	260080e7          	jalr	608(ra) # 80000fc4 <acquire>
  p->state = RUNNABLE;
    80002d6c:	00300793          	li	a5,3
    80002d70:	00f4ac23          	sw	a5,24(s1)
  sched();
    80002d74:	00000097          	auipc	ra,0x0
    80002d78:	eb0080e7          	jalr	-336(ra) # 80002c24 <sched>
  release(&p->lock);
    80002d7c:	00048513          	mv	a0,s1
    80002d80:	ffffe097          	auipc	ra,0xffffe
    80002d84:	33c080e7          	jalr	828(ra) # 800010bc <release>
}
    80002d88:	01813083          	ld	ra,24(sp)
    80002d8c:	01013403          	ld	s0,16(sp)
    80002d90:	00813483          	ld	s1,8(sp)
    80002d94:	02010113          	add	sp,sp,32
    80002d98:	00008067          	ret

0000000080002d9c <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80002d9c:	fd010113          	add	sp,sp,-48
    80002da0:	02113423          	sd	ra,40(sp)
    80002da4:	02813023          	sd	s0,32(sp)
    80002da8:	00913c23          	sd	s1,24(sp)
    80002dac:	01213823          	sd	s2,16(sp)
    80002db0:	01313423          	sd	s3,8(sp)
    80002db4:	03010413          	add	s0,sp,48
    80002db8:	00050993          	mv	s3,a0
    80002dbc:	00058913          	mv	s2,a1
  struct proc *p = myproc();
    80002dc0:	fffff097          	auipc	ra,0xfffff
    80002dc4:	694080e7          	jalr	1684(ra) # 80002454 <myproc>
    80002dc8:	00050493          	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80002dcc:	ffffe097          	auipc	ra,0xffffe
    80002dd0:	1f8080e7          	jalr	504(ra) # 80000fc4 <acquire>
  release(lk);
    80002dd4:	00090513          	mv	a0,s2
    80002dd8:	ffffe097          	auipc	ra,0xffffe
    80002ddc:	2e4080e7          	jalr	740(ra) # 800010bc <release>

  // Go to sleep.
  p->chan = chan;
    80002de0:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80002de4:	00200793          	li	a5,2
    80002de8:	00f4ac23          	sw	a5,24(s1)

  sched();
    80002dec:	00000097          	auipc	ra,0x0
    80002df0:	e38080e7          	jalr	-456(ra) # 80002c24 <sched>

  // Tidy up.
  p->chan = 0;
    80002df4:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80002df8:	00048513          	mv	a0,s1
    80002dfc:	ffffe097          	auipc	ra,0xffffe
    80002e00:	2c0080e7          	jalr	704(ra) # 800010bc <release>
  acquire(lk);
    80002e04:	00090513          	mv	a0,s2
    80002e08:	ffffe097          	auipc	ra,0xffffe
    80002e0c:	1bc080e7          	jalr	444(ra) # 80000fc4 <acquire>
}
    80002e10:	02813083          	ld	ra,40(sp)
    80002e14:	02013403          	ld	s0,32(sp)
    80002e18:	01813483          	ld	s1,24(sp)
    80002e1c:	01013903          	ld	s2,16(sp)
    80002e20:	00813983          	ld	s3,8(sp)
    80002e24:	03010113          	add	sp,sp,48
    80002e28:	00008067          	ret

0000000080002e2c <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80002e2c:	fc010113          	add	sp,sp,-64
    80002e30:	02113c23          	sd	ra,56(sp)
    80002e34:	02813823          	sd	s0,48(sp)
    80002e38:	02913423          	sd	s1,40(sp)
    80002e3c:	03213023          	sd	s2,32(sp)
    80002e40:	01313c23          	sd	s3,24(sp)
    80002e44:	01413823          	sd	s4,16(sp)
    80002e48:	01513423          	sd	s5,8(sp)
    80002e4c:	04010413          	add	s0,sp,64
    80002e50:	00050a13          	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80002e54:	00010497          	auipc	s1,0x10
    80002e58:	1cc48493          	add	s1,s1,460 # 80013020 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80002e5c:	00200993          	li	s3,2
        p->state = RUNNABLE;
    80002e60:	00300a93          	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80002e64:	00016917          	auipc	s2,0x16
    80002e68:	bbc90913          	add	s2,s2,-1092 # 80018a20 <tickslock>
    80002e6c:	0180006f          	j	80002e84 <wakeup+0x58>
      }
      release(&p->lock);
    80002e70:	00048513          	mv	a0,s1
    80002e74:	ffffe097          	auipc	ra,0xffffe
    80002e78:	248080e7          	jalr	584(ra) # 800010bc <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002e7c:	16848493          	add	s1,s1,360
    80002e80:	03248a63          	beq	s1,s2,80002eb4 <wakeup+0x88>
    if(p != myproc()){
    80002e84:	fffff097          	auipc	ra,0xfffff
    80002e88:	5d0080e7          	jalr	1488(ra) # 80002454 <myproc>
    80002e8c:	fea488e3          	beq	s1,a0,80002e7c <wakeup+0x50>
      acquire(&p->lock);
    80002e90:	00048513          	mv	a0,s1
    80002e94:	ffffe097          	auipc	ra,0xffffe
    80002e98:	130080e7          	jalr	304(ra) # 80000fc4 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80002e9c:	0184a783          	lw	a5,24(s1)
    80002ea0:	fd3798e3          	bne	a5,s3,80002e70 <wakeup+0x44>
    80002ea4:	0204b783          	ld	a5,32(s1)
    80002ea8:	fd4794e3          	bne	a5,s4,80002e70 <wakeup+0x44>
        p->state = RUNNABLE;
    80002eac:	0154ac23          	sw	s5,24(s1)
    80002eb0:	fc1ff06f          	j	80002e70 <wakeup+0x44>
    }
  }
}
    80002eb4:	03813083          	ld	ra,56(sp)
    80002eb8:	03013403          	ld	s0,48(sp)
    80002ebc:	02813483          	ld	s1,40(sp)
    80002ec0:	02013903          	ld	s2,32(sp)
    80002ec4:	01813983          	ld	s3,24(sp)
    80002ec8:	01013a03          	ld	s4,16(sp)
    80002ecc:	00813a83          	ld	s5,8(sp)
    80002ed0:	04010113          	add	sp,sp,64
    80002ed4:	00008067          	ret

0000000080002ed8 <reparent>:
{
    80002ed8:	fd010113          	add	sp,sp,-48
    80002edc:	02113423          	sd	ra,40(sp)
    80002ee0:	02813023          	sd	s0,32(sp)
    80002ee4:	00913c23          	sd	s1,24(sp)
    80002ee8:	01213823          	sd	s2,16(sp)
    80002eec:	01313423          	sd	s3,8(sp)
    80002ef0:	01413023          	sd	s4,0(sp)
    80002ef4:	03010413          	add	s0,sp,48
    80002ef8:	00050913          	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002efc:	00010497          	auipc	s1,0x10
    80002f00:	12448493          	add	s1,s1,292 # 80013020 <proc>
      pp->parent = initproc;
    80002f04:	00008a17          	auipc	s4,0x8
    80002f08:	a74a0a13          	add	s4,s4,-1420 # 8000a978 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002f0c:	00016997          	auipc	s3,0x16
    80002f10:	b1498993          	add	s3,s3,-1260 # 80018a20 <tickslock>
    80002f14:	00c0006f          	j	80002f20 <reparent+0x48>
    80002f18:	16848493          	add	s1,s1,360
    80002f1c:	03348063          	beq	s1,s3,80002f3c <reparent+0x64>
    if(pp->parent == p){
    80002f20:	0384b783          	ld	a5,56(s1)
    80002f24:	ff279ae3          	bne	a5,s2,80002f18 <reparent+0x40>
      pp->parent = initproc;
    80002f28:	000a3503          	ld	a0,0(s4)
    80002f2c:	02a4bc23          	sd	a0,56(s1)
      wakeup(initproc);
    80002f30:	00000097          	auipc	ra,0x0
    80002f34:	efc080e7          	jalr	-260(ra) # 80002e2c <wakeup>
    80002f38:	fe1ff06f          	j	80002f18 <reparent+0x40>
}
    80002f3c:	02813083          	ld	ra,40(sp)
    80002f40:	02013403          	ld	s0,32(sp)
    80002f44:	01813483          	ld	s1,24(sp)
    80002f48:	01013903          	ld	s2,16(sp)
    80002f4c:	00813983          	ld	s3,8(sp)
    80002f50:	00013a03          	ld	s4,0(sp)
    80002f54:	03010113          	add	sp,sp,48
    80002f58:	00008067          	ret

0000000080002f5c <exit>:
{
    80002f5c:	fd010113          	add	sp,sp,-48
    80002f60:	02113423          	sd	ra,40(sp)
    80002f64:	02813023          	sd	s0,32(sp)
    80002f68:	00913c23          	sd	s1,24(sp)
    80002f6c:	01213823          	sd	s2,16(sp)
    80002f70:	01313423          	sd	s3,8(sp)
    80002f74:	01413023          	sd	s4,0(sp)
    80002f78:	03010413          	add	s0,sp,48
    80002f7c:	00050a13          	mv	s4,a0
  struct proc *p = myproc();
    80002f80:	fffff097          	auipc	ra,0xfffff
    80002f84:	4d4080e7          	jalr	1236(ra) # 80002454 <myproc>
    80002f88:	00050993          	mv	s3,a0
  if(p == initproc)
    80002f8c:	00008797          	auipc	a5,0x8
    80002f90:	9ec7b783          	ld	a5,-1556(a5) # 8000a978 <initproc>
    80002f94:	0d050493          	add	s1,a0,208
    80002f98:	15050913          	add	s2,a0,336
    80002f9c:	02a79463          	bne	a5,a0,80002fc4 <exit+0x68>
    panic("init exiting");
    80002fa0:	00007517          	auipc	a0,0x7
    80002fa4:	37850513          	add	a0,a0,888 # 8000a318 <digits+0x2d8>
    80002fa8:	ffffd097          	auipc	ra,0xffffd
    80002fac:	720080e7          	jalr	1824(ra) # 800006c8 <panic>
      fileclose(f);
    80002fb0:	00003097          	auipc	ra,0x3
    80002fb4:	06c080e7          	jalr	108(ra) # 8000601c <fileclose>
      p->ofile[fd] = 0;
    80002fb8:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80002fbc:	00848493          	add	s1,s1,8
    80002fc0:	01248863          	beq	s1,s2,80002fd0 <exit+0x74>
    if(p->ofile[fd]){
    80002fc4:	0004b503          	ld	a0,0(s1)
    80002fc8:	fe0514e3          	bnez	a0,80002fb0 <exit+0x54>
    80002fcc:	ff1ff06f          	j	80002fbc <exit+0x60>
  begin_op();
    80002fd0:	00003097          	auipc	ra,0x3
    80002fd4:	9c4080e7          	jalr	-1596(ra) # 80005994 <begin_op>
  iput(p->cwd);
    80002fd8:	1509b503          	ld	a0,336(s3)
    80002fdc:	00002097          	auipc	ra,0x2
    80002fe0:	e60080e7          	jalr	-416(ra) # 80004e3c <iput>
  end_op();
    80002fe4:	00003097          	auipc	ra,0x3
    80002fe8:	a60080e7          	jalr	-1440(ra) # 80005a44 <end_op>
  p->cwd = 0;
    80002fec:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80002ff0:	00010497          	auipc	s1,0x10
    80002ff4:	c1848493          	add	s1,s1,-1000 # 80012c08 <wait_lock>
    80002ff8:	00048513          	mv	a0,s1
    80002ffc:	ffffe097          	auipc	ra,0xffffe
    80003000:	fc8080e7          	jalr	-56(ra) # 80000fc4 <acquire>
  reparent(p);
    80003004:	00098513          	mv	a0,s3
    80003008:	00000097          	auipc	ra,0x0
    8000300c:	ed0080e7          	jalr	-304(ra) # 80002ed8 <reparent>
  wakeup(p->parent);
    80003010:	0389b503          	ld	a0,56(s3)
    80003014:	00000097          	auipc	ra,0x0
    80003018:	e18080e7          	jalr	-488(ra) # 80002e2c <wakeup>
  acquire(&p->lock);
    8000301c:	00098513          	mv	a0,s3
    80003020:	ffffe097          	auipc	ra,0xffffe
    80003024:	fa4080e7          	jalr	-92(ra) # 80000fc4 <acquire>
  p->xstate = status;
    80003028:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000302c:	00500793          	li	a5,5
    80003030:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80003034:	00048513          	mv	a0,s1
    80003038:	ffffe097          	auipc	ra,0xffffe
    8000303c:	084080e7          	jalr	132(ra) # 800010bc <release>
  sched();
    80003040:	00000097          	auipc	ra,0x0
    80003044:	be4080e7          	jalr	-1052(ra) # 80002c24 <sched>
  panic("zombie exit");
    80003048:	00007517          	auipc	a0,0x7
    8000304c:	2e050513          	add	a0,a0,736 # 8000a328 <digits+0x2e8>
    80003050:	ffffd097          	auipc	ra,0xffffd
    80003054:	678080e7          	jalr	1656(ra) # 800006c8 <panic>

0000000080003058 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80003058:	fd010113          	add	sp,sp,-48
    8000305c:	02113423          	sd	ra,40(sp)
    80003060:	02813023          	sd	s0,32(sp)
    80003064:	00913c23          	sd	s1,24(sp)
    80003068:	01213823          	sd	s2,16(sp)
    8000306c:	01313423          	sd	s3,8(sp)
    80003070:	03010413          	add	s0,sp,48
    80003074:	00050913          	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80003078:	00010497          	auipc	s1,0x10
    8000307c:	fa848493          	add	s1,s1,-88 # 80013020 <proc>
    80003080:	00016997          	auipc	s3,0x16
    80003084:	9a098993          	add	s3,s3,-1632 # 80018a20 <tickslock>
    acquire(&p->lock);
    80003088:	00048513          	mv	a0,s1
    8000308c:	ffffe097          	auipc	ra,0xffffe
    80003090:	f38080e7          	jalr	-200(ra) # 80000fc4 <acquire>
    if(p->pid == pid){
    80003094:	0304a783          	lw	a5,48(s1)
    80003098:	03278063          	beq	a5,s2,800030b8 <kill+0x60>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000309c:	00048513          	mv	a0,s1
    800030a0:	ffffe097          	auipc	ra,0xffffe
    800030a4:	01c080e7          	jalr	28(ra) # 800010bc <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800030a8:	16848493          	add	s1,s1,360
    800030ac:	fd349ee3          	bne	s1,s3,80003088 <kill+0x30>
  }
  return -1;
    800030b0:	fff00513          	li	a0,-1
    800030b4:	0280006f          	j	800030dc <kill+0x84>
      p->killed = 1;
    800030b8:	00100793          	li	a5,1
    800030bc:	02f4a423          	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800030c0:	0184a703          	lw	a4,24(s1)
    800030c4:	00200793          	li	a5,2
    800030c8:	02f70863          	beq	a4,a5,800030f8 <kill+0xa0>
      release(&p->lock);
    800030cc:	00048513          	mv	a0,s1
    800030d0:	ffffe097          	auipc	ra,0xffffe
    800030d4:	fec080e7          	jalr	-20(ra) # 800010bc <release>
      return 0;
    800030d8:	00000513          	li	a0,0
}
    800030dc:	02813083          	ld	ra,40(sp)
    800030e0:	02013403          	ld	s0,32(sp)
    800030e4:	01813483          	ld	s1,24(sp)
    800030e8:	01013903          	ld	s2,16(sp)
    800030ec:	00813983          	ld	s3,8(sp)
    800030f0:	03010113          	add	sp,sp,48
    800030f4:	00008067          	ret
        p->state = RUNNABLE;
    800030f8:	00300793          	li	a5,3
    800030fc:	00f4ac23          	sw	a5,24(s1)
    80003100:	fcdff06f          	j	800030cc <kill+0x74>

0000000080003104 <setkilled>:

void
setkilled(struct proc *p)
{
    80003104:	fe010113          	add	sp,sp,-32
    80003108:	00113c23          	sd	ra,24(sp)
    8000310c:	00813823          	sd	s0,16(sp)
    80003110:	00913423          	sd	s1,8(sp)
    80003114:	02010413          	add	s0,sp,32
    80003118:	00050493          	mv	s1,a0
  acquire(&p->lock);
    8000311c:	ffffe097          	auipc	ra,0xffffe
    80003120:	ea8080e7          	jalr	-344(ra) # 80000fc4 <acquire>
  p->killed = 1;
    80003124:	00100793          	li	a5,1
    80003128:	02f4a423          	sw	a5,40(s1)
  release(&p->lock);
    8000312c:	00048513          	mv	a0,s1
    80003130:	ffffe097          	auipc	ra,0xffffe
    80003134:	f8c080e7          	jalr	-116(ra) # 800010bc <release>
}
    80003138:	01813083          	ld	ra,24(sp)
    8000313c:	01013403          	ld	s0,16(sp)
    80003140:	00813483          	ld	s1,8(sp)
    80003144:	02010113          	add	sp,sp,32
    80003148:	00008067          	ret

000000008000314c <killed>:

int
killed(struct proc *p)
{
    8000314c:	fe010113          	add	sp,sp,-32
    80003150:	00113c23          	sd	ra,24(sp)
    80003154:	00813823          	sd	s0,16(sp)
    80003158:	00913423          	sd	s1,8(sp)
    8000315c:	01213023          	sd	s2,0(sp)
    80003160:	02010413          	add	s0,sp,32
    80003164:	00050493          	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80003168:	ffffe097          	auipc	ra,0xffffe
    8000316c:	e5c080e7          	jalr	-420(ra) # 80000fc4 <acquire>
  k = p->killed;
    80003170:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80003174:	00048513          	mv	a0,s1
    80003178:	ffffe097          	auipc	ra,0xffffe
    8000317c:	f44080e7          	jalr	-188(ra) # 800010bc <release>
  return k;
}
    80003180:	00090513          	mv	a0,s2
    80003184:	01813083          	ld	ra,24(sp)
    80003188:	01013403          	ld	s0,16(sp)
    8000318c:	00813483          	ld	s1,8(sp)
    80003190:	00013903          	ld	s2,0(sp)
    80003194:	02010113          	add	sp,sp,32
    80003198:	00008067          	ret

000000008000319c <wait>:
{
    8000319c:	fb010113          	add	sp,sp,-80
    800031a0:	04113423          	sd	ra,72(sp)
    800031a4:	04813023          	sd	s0,64(sp)
    800031a8:	02913c23          	sd	s1,56(sp)
    800031ac:	03213823          	sd	s2,48(sp)
    800031b0:	03313423          	sd	s3,40(sp)
    800031b4:	03413023          	sd	s4,32(sp)
    800031b8:	01513c23          	sd	s5,24(sp)
    800031bc:	01613823          	sd	s6,16(sp)
    800031c0:	01713423          	sd	s7,8(sp)
    800031c4:	01813023          	sd	s8,0(sp)
    800031c8:	05010413          	add	s0,sp,80
    800031cc:	00050b13          	mv	s6,a0
  struct proc *p = myproc();
    800031d0:	fffff097          	auipc	ra,0xfffff
    800031d4:	284080e7          	jalr	644(ra) # 80002454 <myproc>
    800031d8:	00050913          	mv	s2,a0
  acquire(&wait_lock);
    800031dc:	00010517          	auipc	a0,0x10
    800031e0:	a2c50513          	add	a0,a0,-1492 # 80012c08 <wait_lock>
    800031e4:	ffffe097          	auipc	ra,0xffffe
    800031e8:	de0080e7          	jalr	-544(ra) # 80000fc4 <acquire>
    havekids = 0;
    800031ec:	00000b93          	li	s7,0
        if(pp->state == ZOMBIE){
    800031f0:	00500a13          	li	s4,5
        havekids = 1;
    800031f4:	00100a93          	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800031f8:	00016997          	auipc	s3,0x16
    800031fc:	82898993          	add	s3,s3,-2008 # 80018a20 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80003200:	00010c17          	auipc	s8,0x10
    80003204:	a08c0c13          	add	s8,s8,-1528 # 80012c08 <wait_lock>
    80003208:	1040006f          	j	8000330c <wait+0x170>
          pid = pp->pid;
    8000320c:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80003210:	020b0063          	beqz	s6,80003230 <wait+0x94>
    80003214:	00400693          	li	a3,4
    80003218:	02c48613          	add	a2,s1,44
    8000321c:	000b0593          	mv	a1,s6
    80003220:	05093503          	ld	a0,80(s2)
    80003224:	fffff097          	auipc	ra,0xfffff
    80003228:	d2c080e7          	jalr	-724(ra) # 80001f50 <copyout>
    8000322c:	06054063          	bltz	a0,8000328c <wait+0xf0>
          freeproc(pp);
    80003230:	00048513          	mv	a0,s1
    80003234:	fffff097          	auipc	ra,0xfffff
    80003238:	4a8080e7          	jalr	1192(ra) # 800026dc <freeproc>
          release(&pp->lock);
    8000323c:	00048513          	mv	a0,s1
    80003240:	ffffe097          	auipc	ra,0xffffe
    80003244:	e7c080e7          	jalr	-388(ra) # 800010bc <release>
          release(&wait_lock);
    80003248:	00010517          	auipc	a0,0x10
    8000324c:	9c050513          	add	a0,a0,-1600 # 80012c08 <wait_lock>
    80003250:	ffffe097          	auipc	ra,0xffffe
    80003254:	e6c080e7          	jalr	-404(ra) # 800010bc <release>
}
    80003258:	00098513          	mv	a0,s3
    8000325c:	04813083          	ld	ra,72(sp)
    80003260:	04013403          	ld	s0,64(sp)
    80003264:	03813483          	ld	s1,56(sp)
    80003268:	03013903          	ld	s2,48(sp)
    8000326c:	02813983          	ld	s3,40(sp)
    80003270:	02013a03          	ld	s4,32(sp)
    80003274:	01813a83          	ld	s5,24(sp)
    80003278:	01013b03          	ld	s6,16(sp)
    8000327c:	00813b83          	ld	s7,8(sp)
    80003280:	00013c03          	ld	s8,0(sp)
    80003284:	05010113          	add	sp,sp,80
    80003288:	00008067          	ret
            release(&pp->lock);
    8000328c:	00048513          	mv	a0,s1
    80003290:	ffffe097          	auipc	ra,0xffffe
    80003294:	e2c080e7          	jalr	-468(ra) # 800010bc <release>
            release(&wait_lock);
    80003298:	00010517          	auipc	a0,0x10
    8000329c:	97050513          	add	a0,a0,-1680 # 80012c08 <wait_lock>
    800032a0:	ffffe097          	auipc	ra,0xffffe
    800032a4:	e1c080e7          	jalr	-484(ra) # 800010bc <release>
            return -1;
    800032a8:	fff00993          	li	s3,-1
    800032ac:	fadff06f          	j	80003258 <wait+0xbc>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800032b0:	16848493          	add	s1,s1,360
    800032b4:	03348a63          	beq	s1,s3,800032e8 <wait+0x14c>
      if(pp->parent == p){
    800032b8:	0384b783          	ld	a5,56(s1)
    800032bc:	ff279ae3          	bne	a5,s2,800032b0 <wait+0x114>
        acquire(&pp->lock);
    800032c0:	00048513          	mv	a0,s1
    800032c4:	ffffe097          	auipc	ra,0xffffe
    800032c8:	d00080e7          	jalr	-768(ra) # 80000fc4 <acquire>
        if(pp->state == ZOMBIE){
    800032cc:	0184a783          	lw	a5,24(s1)
    800032d0:	f3478ee3          	beq	a5,s4,8000320c <wait+0x70>
        release(&pp->lock);
    800032d4:	00048513          	mv	a0,s1
    800032d8:	ffffe097          	auipc	ra,0xffffe
    800032dc:	de4080e7          	jalr	-540(ra) # 800010bc <release>
        havekids = 1;
    800032e0:	000a8713          	mv	a4,s5
    800032e4:	fcdff06f          	j	800032b0 <wait+0x114>
    if(!havekids || killed(p)){
    800032e8:	02070a63          	beqz	a4,8000331c <wait+0x180>
    800032ec:	00090513          	mv	a0,s2
    800032f0:	00000097          	auipc	ra,0x0
    800032f4:	e5c080e7          	jalr	-420(ra) # 8000314c <killed>
    800032f8:	02051263          	bnez	a0,8000331c <wait+0x180>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800032fc:	000c0593          	mv	a1,s8
    80003300:	00090513          	mv	a0,s2
    80003304:	00000097          	auipc	ra,0x0
    80003308:	a98080e7          	jalr	-1384(ra) # 80002d9c <sleep>
    havekids = 0;
    8000330c:	000b8713          	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80003310:	00010497          	auipc	s1,0x10
    80003314:	d1048493          	add	s1,s1,-752 # 80013020 <proc>
    80003318:	fa1ff06f          	j	800032b8 <wait+0x11c>
      release(&wait_lock);
    8000331c:	00010517          	auipc	a0,0x10
    80003320:	8ec50513          	add	a0,a0,-1812 # 80012c08 <wait_lock>
    80003324:	ffffe097          	auipc	ra,0xffffe
    80003328:	d98080e7          	jalr	-616(ra) # 800010bc <release>
      return -1;
    8000332c:	fff00993          	li	s3,-1
    80003330:	f29ff06f          	j	80003258 <wait+0xbc>

0000000080003334 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80003334:	fd010113          	add	sp,sp,-48
    80003338:	02113423          	sd	ra,40(sp)
    8000333c:	02813023          	sd	s0,32(sp)
    80003340:	00913c23          	sd	s1,24(sp)
    80003344:	01213823          	sd	s2,16(sp)
    80003348:	01313423          	sd	s3,8(sp)
    8000334c:	01413023          	sd	s4,0(sp)
    80003350:	03010413          	add	s0,sp,48
    80003354:	00050493          	mv	s1,a0
    80003358:	00058913          	mv	s2,a1
    8000335c:	00060993          	mv	s3,a2
    80003360:	00068a13          	mv	s4,a3
  struct proc *p = myproc();
    80003364:	fffff097          	auipc	ra,0xfffff
    80003368:	0f0080e7          	jalr	240(ra) # 80002454 <myproc>
  if(user_dst){
    8000336c:	02048e63          	beqz	s1,800033a8 <either_copyout+0x74>
    return copyout(p->pagetable, dst, src, len);
    80003370:	000a0693          	mv	a3,s4
    80003374:	00098613          	mv	a2,s3
    80003378:	00090593          	mv	a1,s2
    8000337c:	05053503          	ld	a0,80(a0)
    80003380:	fffff097          	auipc	ra,0xfffff
    80003384:	bd0080e7          	jalr	-1072(ra) # 80001f50 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80003388:	02813083          	ld	ra,40(sp)
    8000338c:	02013403          	ld	s0,32(sp)
    80003390:	01813483          	ld	s1,24(sp)
    80003394:	01013903          	ld	s2,16(sp)
    80003398:	00813983          	ld	s3,8(sp)
    8000339c:	00013a03          	ld	s4,0(sp)
    800033a0:	03010113          	add	sp,sp,48
    800033a4:	00008067          	ret
    memmove((char *)dst, src, len);
    800033a8:	000a061b          	sext.w	a2,s4
    800033ac:	00098593          	mv	a1,s3
    800033b0:	00090513          	mv	a0,s2
    800033b4:	ffffe097          	auipc	ra,0xffffe
    800033b8:	dfc080e7          	jalr	-516(ra) # 800011b0 <memmove>
    return 0;
    800033bc:	00048513          	mv	a0,s1
    800033c0:	fc9ff06f          	j	80003388 <either_copyout+0x54>

00000000800033c4 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800033c4:	fd010113          	add	sp,sp,-48
    800033c8:	02113423          	sd	ra,40(sp)
    800033cc:	02813023          	sd	s0,32(sp)
    800033d0:	00913c23          	sd	s1,24(sp)
    800033d4:	01213823          	sd	s2,16(sp)
    800033d8:	01313423          	sd	s3,8(sp)
    800033dc:	01413023          	sd	s4,0(sp)
    800033e0:	03010413          	add	s0,sp,48
    800033e4:	00050913          	mv	s2,a0
    800033e8:	00058493          	mv	s1,a1
    800033ec:	00060993          	mv	s3,a2
    800033f0:	00068a13          	mv	s4,a3
  struct proc *p = myproc();
    800033f4:	fffff097          	auipc	ra,0xfffff
    800033f8:	060080e7          	jalr	96(ra) # 80002454 <myproc>
  if(user_src){
    800033fc:	02048e63          	beqz	s1,80003438 <either_copyin+0x74>
    return copyin(p->pagetable, dst, src, len);
    80003400:	000a0693          	mv	a3,s4
    80003404:	00098613          	mv	a2,s3
    80003408:	00090593          	mv	a1,s2
    8000340c:	05053503          	ld	a0,80(a0)
    80003410:	fffff097          	auipc	ra,0xfffff
    80003414:	c28080e7          	jalr	-984(ra) # 80002038 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80003418:	02813083          	ld	ra,40(sp)
    8000341c:	02013403          	ld	s0,32(sp)
    80003420:	01813483          	ld	s1,24(sp)
    80003424:	01013903          	ld	s2,16(sp)
    80003428:	00813983          	ld	s3,8(sp)
    8000342c:	00013a03          	ld	s4,0(sp)
    80003430:	03010113          	add	sp,sp,48
    80003434:	00008067          	ret
    memmove(dst, (char*)src, len);
    80003438:	000a061b          	sext.w	a2,s4
    8000343c:	00098593          	mv	a1,s3
    80003440:	00090513          	mv	a0,s2
    80003444:	ffffe097          	auipc	ra,0xffffe
    80003448:	d6c080e7          	jalr	-660(ra) # 800011b0 <memmove>
    return 0;
    8000344c:	00048513          	mv	a0,s1
    80003450:	fc9ff06f          	j	80003418 <either_copyin+0x54>

0000000080003454 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80003454:	fb010113          	add	sp,sp,-80
    80003458:	04113423          	sd	ra,72(sp)
    8000345c:	04813023          	sd	s0,64(sp)
    80003460:	02913c23          	sd	s1,56(sp)
    80003464:	03213823          	sd	s2,48(sp)
    80003468:	03313423          	sd	s3,40(sp)
    8000346c:	03413023          	sd	s4,32(sp)
    80003470:	01513c23          	sd	s5,24(sp)
    80003474:	01613823          	sd	s6,16(sp)
    80003478:	01713423          	sd	s7,8(sp)
    8000347c:	05010413          	add	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80003480:	00007517          	auipc	a0,0x7
    80003484:	03050513          	add	a0,a0,48 # 8000a4b0 <states.0+0x130>
    80003488:	ffffd097          	auipc	ra,0xffffd
    8000348c:	29c080e7          	jalr	668(ra) # 80000724 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80003490:	00010497          	auipc	s1,0x10
    80003494:	ce848493          	add	s1,s1,-792 # 80013178 <proc+0x158>
    80003498:	00015917          	auipc	s2,0x15
    8000349c:	6e090913          	add	s2,s2,1760 # 80018b78 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800034a0:	00500b13          	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800034a4:	00007997          	auipc	s3,0x7
    800034a8:	e9498993          	add	s3,s3,-364 # 8000a338 <digits+0x2f8>
    printf("%d %s %s", p->pid, state, p->name);
    800034ac:	00007a97          	auipc	s5,0x7
    800034b0:	e94a8a93          	add	s5,s5,-364 # 8000a340 <digits+0x300>
    printf("\n");
    800034b4:	00007a17          	auipc	s4,0x7
    800034b8:	ffca0a13          	add	s4,s4,-4 # 8000a4b0 <states.0+0x130>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800034bc:	00007b97          	auipc	s7,0x7
    800034c0:	ec4b8b93          	add	s7,s7,-316 # 8000a380 <states.0>
    800034c4:	0280006f          	j	800034ec <procdump+0x98>
    printf("%d %s %s", p->pid, state, p->name);
    800034c8:	ed86a583          	lw	a1,-296(a3)
    800034cc:	000a8513          	mv	a0,s5
    800034d0:	ffffd097          	auipc	ra,0xffffd
    800034d4:	254080e7          	jalr	596(ra) # 80000724 <printf>
    printf("\n");
    800034d8:	000a0513          	mv	a0,s4
    800034dc:	ffffd097          	auipc	ra,0xffffd
    800034e0:	248080e7          	jalr	584(ra) # 80000724 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800034e4:	16848493          	add	s1,s1,360
    800034e8:	03248a63          	beq	s1,s2,8000351c <procdump+0xc8>
    if(p->state == UNUSED)
    800034ec:	00048693          	mv	a3,s1
    800034f0:	ec04a783          	lw	a5,-320(s1)
    800034f4:	fe0788e3          	beqz	a5,800034e4 <procdump+0x90>
      state = "???";
    800034f8:	00098613          	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800034fc:	fcfb66e3          	bltu	s6,a5,800034c8 <procdump+0x74>
    80003500:	02079713          	sll	a4,a5,0x20
    80003504:	01d75793          	srl	a5,a4,0x1d
    80003508:	00fb87b3          	add	a5,s7,a5
    8000350c:	0007b603          	ld	a2,0(a5)
    80003510:	fa061ce3          	bnez	a2,800034c8 <procdump+0x74>
      state = "???";
    80003514:	00098613          	mv	a2,s3
    80003518:	fb1ff06f          	j	800034c8 <procdump+0x74>
  }
}
    8000351c:	04813083          	ld	ra,72(sp)
    80003520:	04013403          	ld	s0,64(sp)
    80003524:	03813483          	ld	s1,56(sp)
    80003528:	03013903          	ld	s2,48(sp)
    8000352c:	02813983          	ld	s3,40(sp)
    80003530:	02013a03          	ld	s4,32(sp)
    80003534:	01813a83          	ld	s5,24(sp)
    80003538:	01013b03          	ld	s6,16(sp)
    8000353c:	00813b83          	ld	s7,8(sp)
    80003540:	05010113          	add	sp,sp,80
    80003544:	00008067          	ret

0000000080003548 <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    80003548:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    8000354c:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    80003550:	00853823          	sd	s0,16(a0)
        sd s1, 24(a0)
    80003554:	00953c23          	sd	s1,24(a0)
        sd s2, 32(a0)
    80003558:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    8000355c:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    80003560:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    80003564:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    80003568:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    8000356c:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    80003570:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    80003574:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    80003578:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    8000357c:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    80003580:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    80003584:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    80003588:	0105b403          	ld	s0,16(a1)
        ld s1, 24(a1)
    8000358c:	0185b483          	ld	s1,24(a1)
        ld s2, 32(a1)
    80003590:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    80003594:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    80003598:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    8000359c:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    800035a0:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    800035a4:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    800035a8:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    800035ac:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    800035b0:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    800035b4:	0685bd83          	ld	s11,104(a1)
        
        ret
    800035b8:	00008067          	ret

00000000800035bc <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800035bc:	ff010113          	add	sp,sp,-16
    800035c0:	00113423          	sd	ra,8(sp)
    800035c4:	00813023          	sd	s0,0(sp)
    800035c8:	01010413          	add	s0,sp,16
  initlock(&tickslock, "time");
    800035cc:	00007597          	auipc	a1,0x7
    800035d0:	de458593          	add	a1,a1,-540 # 8000a3b0 <states.0+0x30>
    800035d4:	00015517          	auipc	a0,0x15
    800035d8:	44c50513          	add	a0,a0,1100 # 80018a20 <tickslock>
    800035dc:	ffffe097          	auipc	ra,0xffffe
    800035e0:	904080e7          	jalr	-1788(ra) # 80000ee0 <initlock>
}
    800035e4:	00813083          	ld	ra,8(sp)
    800035e8:	00013403          	ld	s0,0(sp)
    800035ec:	01010113          	add	sp,sp,16
    800035f0:	00008067          	ret

00000000800035f4 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800035f4:	ff010113          	add	sp,sp,-16
    800035f8:	00813423          	sd	s0,8(sp)
    800035fc:	01010413          	add	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80003600:	00004797          	auipc	a5,0x4
    80003604:	7a078793          	add	a5,a5,1952 # 80007da0 <kernelvec>
    80003608:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    8000360c:	00813403          	ld	s0,8(sp)
    80003610:	01010113          	add	sp,sp,16
    80003614:	00008067          	ret

0000000080003618 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80003618:	ff010113          	add	sp,sp,-16
    8000361c:	00113423          	sd	ra,8(sp)
    80003620:	00813023          	sd	s0,0(sp)
    80003624:	01010413          	add	s0,sp,16
  struct proc *p = myproc();
    80003628:	fffff097          	auipc	ra,0xfffff
    8000362c:	e2c080e7          	jalr	-468(ra) # 80002454 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003630:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80003634:	ffd7f793          	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80003638:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    8000363c:	00006697          	auipc	a3,0x6
    80003640:	9c468693          	add	a3,a3,-1596 # 80009000 <_trampoline>
    80003644:	00006717          	auipc	a4,0x6
    80003648:	9bc70713          	add	a4,a4,-1604 # 80009000 <_trampoline>
    8000364c:	40d70733          	sub	a4,a4,a3
    80003650:	040007b7          	lui	a5,0x4000
    80003654:	fff78793          	add	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80003658:	00c79793          	sll	a5,a5,0xc
    8000365c:	00f70733          	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80003660:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80003664:	05853703          	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80003668:	18002673          	csrr	a2,satp
    8000366c:	00c73023          	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80003670:	05853603          	ld	a2,88(a0)
    80003674:	04053703          	ld	a4,64(a0)
    80003678:	000015b7          	lui	a1,0x1
    8000367c:	00b70733          	add	a4,a4,a1
    80003680:	00e63423          	sd	a4,8(a2) # 1008 <_entry-0x7fffeff8>
  p->trapframe->kernel_trap = (uint64)usertrap;
    80003684:	05853703          	ld	a4,88(a0)
    80003688:	00000617          	auipc	a2,0x0
    8000368c:	1b860613          	add	a2,a2,440 # 80003840 <usertrap>
    80003690:	00c73823          	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80003694:	05853703          	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80003698:	00020613          	mv	a2,tp
    8000369c:	02c73023          	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800036a0:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800036a4:	eff77713          	and	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800036a8:	02076713          	or	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800036ac:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800036b0:	05853703          	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800036b4:	01873703          	ld	a4,24(a4)
    800036b8:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    800036bc:	05053503          	ld	a0,80(a0)
    800036c0:	00c55513          	srl	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    800036c4:	00006717          	auipc	a4,0x6
    800036c8:	9ec70713          	add	a4,a4,-1556 # 800090b0 <userret>
    800036cc:	40d70733          	sub	a4,a4,a3
    800036d0:	00f707b3          	add	a5,a4,a5
  ((void (*)(uint64))trampoline_userret)(satp);
    800036d4:	fff00713          	li	a4,-1
    800036d8:	03f71713          	sll	a4,a4,0x3f
    800036dc:	00e56533          	or	a0,a0,a4
    800036e0:	000780e7          	jalr	a5
}
    800036e4:	00813083          	ld	ra,8(sp)
    800036e8:	00013403          	ld	s0,0(sp)
    800036ec:	01010113          	add	sp,sp,16
    800036f0:	00008067          	ret

00000000800036f4 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800036f4:	fe010113          	add	sp,sp,-32
    800036f8:	00113c23          	sd	ra,24(sp)
    800036fc:	00813823          	sd	s0,16(sp)
    80003700:	00913423          	sd	s1,8(sp)
    80003704:	02010413          	add	s0,sp,32
  acquire(&tickslock);
    80003708:	00015497          	auipc	s1,0x15
    8000370c:	31848493          	add	s1,s1,792 # 80018a20 <tickslock>
    80003710:	00048513          	mv	a0,s1
    80003714:	ffffe097          	auipc	ra,0xffffe
    80003718:	8b0080e7          	jalr	-1872(ra) # 80000fc4 <acquire>
  ticks++;
    8000371c:	00007517          	auipc	a0,0x7
    80003720:	26450513          	add	a0,a0,612 # 8000a980 <ticks>
    80003724:	00052783          	lw	a5,0(a0)
    80003728:	0017879b          	addw	a5,a5,1
    8000372c:	00f52023          	sw	a5,0(a0)
  wakeup(&ticks);
    80003730:	fffff097          	auipc	ra,0xfffff
    80003734:	6fc080e7          	jalr	1788(ra) # 80002e2c <wakeup>
  release(&tickslock);
    80003738:	00048513          	mv	a0,s1
    8000373c:	ffffe097          	auipc	ra,0xffffe
    80003740:	980080e7          	jalr	-1664(ra) # 800010bc <release>
}
    80003744:	01813083          	ld	ra,24(sp)
    80003748:	01013403          	ld	s0,16(sp)
    8000374c:	00813483          	ld	s1,8(sp)
    80003750:	02010113          	add	sp,sp,32
    80003754:	00008067          	ret

0000000080003758 <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80003758:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    8000375c:	00000513          	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80003760:	0c07de63          	bgez	a5,8000383c <devintr+0xe4>
{
    80003764:	fe010113          	add	sp,sp,-32
    80003768:	00113c23          	sd	ra,24(sp)
    8000376c:	00813823          	sd	s0,16(sp)
    80003770:	00913423          	sd	s1,8(sp)
    80003774:	02010413          	add	s0,sp,32
     (scause & 0xff) == 9){
    80003778:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    8000377c:	00900693          	li	a3,9
    80003780:	02d70663          	beq	a4,a3,800037ac <devintr+0x54>
  } else if(scause == 0x8000000000000001L){
    80003784:	fff00713          	li	a4,-1
    80003788:	03f71713          	sll	a4,a4,0x3f
    8000378c:	00170713          	add	a4,a4,1
    return 0;
    80003790:	00000513          	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80003794:	06e78e63          	beq	a5,a4,80003810 <devintr+0xb8>
  }
}
    80003798:	01813083          	ld	ra,24(sp)
    8000379c:	01013403          	ld	s0,16(sp)
    800037a0:	00813483          	ld	s1,8(sp)
    800037a4:	02010113          	add	sp,sp,32
    800037a8:	00008067          	ret
    int irq = plic_claim();
    800037ac:	00004097          	auipc	ra,0x4
    800037b0:	7b8080e7          	jalr	1976(ra) # 80007f64 <plic_claim>
    800037b4:	00050493          	mv	s1,a0
    if(irq == UART0_IRQ){
    800037b8:	00a00793          	li	a5,10
    800037bc:	02f50e63          	beq	a0,a5,800037f8 <devintr+0xa0>
    } else if(irq == VIRTIO0_IRQ){
    800037c0:	00100793          	li	a5,1
    800037c4:	04f50063          	beq	a0,a5,80003804 <devintr+0xac>
    return 1;
    800037c8:	00100513          	li	a0,1
    } else if(irq){
    800037cc:	fc0486e3          	beqz	s1,80003798 <devintr+0x40>
      printf("unexpected interrupt irq=%d\n", irq);
    800037d0:	00048593          	mv	a1,s1
    800037d4:	00007517          	auipc	a0,0x7
    800037d8:	be450513          	add	a0,a0,-1052 # 8000a3b8 <states.0+0x38>
    800037dc:	ffffd097          	auipc	ra,0xffffd
    800037e0:	f48080e7          	jalr	-184(ra) # 80000724 <printf>
      plic_complete(irq);
    800037e4:	00048513          	mv	a0,s1
    800037e8:	00004097          	auipc	ra,0x4
    800037ec:	7b4080e7          	jalr	1972(ra) # 80007f9c <plic_complete>
    return 1;
    800037f0:	00100513          	li	a0,1
    800037f4:	fa5ff06f          	j	80003798 <devintr+0x40>
      uartintr();
    800037f8:	ffffd097          	auipc	ra,0xffffd
    800037fc:	488080e7          	jalr	1160(ra) # 80000c80 <uartintr>
    if(irq)
    80003800:	fe5ff06f          	j	800037e4 <devintr+0x8c>
      virtio_disk_intr();
    80003804:	00005097          	auipc	ra,0x5
    80003808:	dcc080e7          	jalr	-564(ra) # 800085d0 <virtio_disk_intr>
    if(irq)
    8000380c:	fd9ff06f          	j	800037e4 <devintr+0x8c>
    if(cpuid() == 0){
    80003810:	fffff097          	auipc	ra,0xfffff
    80003814:	bf4080e7          	jalr	-1036(ra) # 80002404 <cpuid>
    80003818:	00050c63          	beqz	a0,80003830 <devintr+0xd8>
  asm volatile("csrr %0, sip" : "=r" (x) );
    8000381c:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80003820:	ffd7f793          	and	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80003824:	14479073          	csrw	sip,a5
    return 2;
    80003828:	00200513          	li	a0,2
    8000382c:	f6dff06f          	j	80003798 <devintr+0x40>
      clockintr();
    80003830:	00000097          	auipc	ra,0x0
    80003834:	ec4080e7          	jalr	-316(ra) # 800036f4 <clockintr>
    80003838:	fe5ff06f          	j	8000381c <devintr+0xc4>
}
    8000383c:	00008067          	ret

0000000080003840 <usertrap>:
{
    80003840:	fe010113          	add	sp,sp,-32
    80003844:	00113c23          	sd	ra,24(sp)
    80003848:	00813823          	sd	s0,16(sp)
    8000384c:	00913423          	sd	s1,8(sp)
    80003850:	01213023          	sd	s2,0(sp)
    80003854:	02010413          	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003858:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    8000385c:	1007f793          	and	a5,a5,256
    80003860:	04079c63          	bnez	a5,800038b8 <usertrap+0x78>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80003864:	00004797          	auipc	a5,0x4
    80003868:	53c78793          	add	a5,a5,1340 # 80007da0 <kernelvec>
    8000386c:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80003870:	fffff097          	auipc	ra,0xfffff
    80003874:	be4080e7          	jalr	-1052(ra) # 80002454 <myproc>
    80003878:	00050493          	mv	s1,a0
  p->trapframe->epc = r_sepc();
    8000387c:	05853783          	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80003880:	14102773          	csrr	a4,sepc
    80003884:	00e7bc23          	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80003888:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    8000388c:	00800793          	li	a5,8
    80003890:	02f70c63          	beq	a4,a5,800038c8 <usertrap+0x88>
  } else if((which_dev = devintr()) != 0){
    80003894:	00000097          	auipc	ra,0x0
    80003898:	ec4080e7          	jalr	-316(ra) # 80003758 <devintr>
    8000389c:	00050913          	mv	s2,a0
    800038a0:	0a050863          	beqz	a0,80003950 <usertrap+0x110>
  if(killed(p))
    800038a4:	00048513          	mv	a0,s1
    800038a8:	00000097          	auipc	ra,0x0
    800038ac:	8a4080e7          	jalr	-1884(ra) # 8000314c <killed>
    800038b0:	06050463          	beqz	a0,80003918 <usertrap+0xd8>
    800038b4:	0580006f          	j	8000390c <usertrap+0xcc>
    panic("usertrap: not from user mode");
    800038b8:	00007517          	auipc	a0,0x7
    800038bc:	b2050513          	add	a0,a0,-1248 # 8000a3d8 <states.0+0x58>
    800038c0:	ffffd097          	auipc	ra,0xffffd
    800038c4:	e08080e7          	jalr	-504(ra) # 800006c8 <panic>
    if(killed(p))
    800038c8:	00000097          	auipc	ra,0x0
    800038cc:	884080e7          	jalr	-1916(ra) # 8000314c <killed>
    800038d0:	06051863          	bnez	a0,80003940 <usertrap+0x100>
    p->trapframe->epc += 4;
    800038d4:	0584b703          	ld	a4,88(s1)
    800038d8:	01873783          	ld	a5,24(a4)
    800038dc:	00478793          	add	a5,a5,4
    800038e0:	00f73c23          	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800038e4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800038e8:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800038ec:	10079073          	csrw	sstatus,a5
    syscall();
    800038f0:	00000097          	auipc	ra,0x0
    800038f4:	418080e7          	jalr	1048(ra) # 80003d08 <syscall>
  if(killed(p))
    800038f8:	00048513          	mv	a0,s1
    800038fc:	00000097          	auipc	ra,0x0
    80003900:	850080e7          	jalr	-1968(ra) # 8000314c <killed>
    80003904:	00050e63          	beqz	a0,80003920 <usertrap+0xe0>
    80003908:	00000913          	li	s2,0
    exit(-1);
    8000390c:	fff00513          	li	a0,-1
    80003910:	fffff097          	auipc	ra,0xfffff
    80003914:	64c080e7          	jalr	1612(ra) # 80002f5c <exit>
  if(which_dev == 2)
    80003918:	00200793          	li	a5,2
    8000391c:	06f90a63          	beq	s2,a5,80003990 <usertrap+0x150>
  usertrapret();
    80003920:	00000097          	auipc	ra,0x0
    80003924:	cf8080e7          	jalr	-776(ra) # 80003618 <usertrapret>
}
    80003928:	01813083          	ld	ra,24(sp)
    8000392c:	01013403          	ld	s0,16(sp)
    80003930:	00813483          	ld	s1,8(sp)
    80003934:	00013903          	ld	s2,0(sp)
    80003938:	02010113          	add	sp,sp,32
    8000393c:	00008067          	ret
      exit(-1);
    80003940:	fff00513          	li	a0,-1
    80003944:	fffff097          	auipc	ra,0xfffff
    80003948:	618080e7          	jalr	1560(ra) # 80002f5c <exit>
    8000394c:	f89ff06f          	j	800038d4 <usertrap+0x94>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80003950:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80003954:	0304a603          	lw	a2,48(s1)
    80003958:	00007517          	auipc	a0,0x7
    8000395c:	aa050513          	add	a0,a0,-1376 # 8000a3f8 <states.0+0x78>
    80003960:	ffffd097          	auipc	ra,0xffffd
    80003964:	dc4080e7          	jalr	-572(ra) # 80000724 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80003968:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000396c:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80003970:	00007517          	auipc	a0,0x7
    80003974:	ab850513          	add	a0,a0,-1352 # 8000a428 <states.0+0xa8>
    80003978:	ffffd097          	auipc	ra,0xffffd
    8000397c:	dac080e7          	jalr	-596(ra) # 80000724 <printf>
    setkilled(p);
    80003980:	00048513          	mv	a0,s1
    80003984:	fffff097          	auipc	ra,0xfffff
    80003988:	780080e7          	jalr	1920(ra) # 80003104 <setkilled>
    8000398c:	f6dff06f          	j	800038f8 <usertrap+0xb8>
    yield();
    80003990:	fffff097          	auipc	ra,0xfffff
    80003994:	3b4080e7          	jalr	948(ra) # 80002d44 <yield>
    80003998:	f89ff06f          	j	80003920 <usertrap+0xe0>

000000008000399c <kerneltrap>:
{
    8000399c:	fd010113          	add	sp,sp,-48
    800039a0:	02113423          	sd	ra,40(sp)
    800039a4:	02813023          	sd	s0,32(sp)
    800039a8:	00913c23          	sd	s1,24(sp)
    800039ac:	01213823          	sd	s2,16(sp)
    800039b0:	01313423          	sd	s3,8(sp)
    800039b4:	03010413          	add	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800039b8:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800039bc:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    800039c0:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    800039c4:	1004f793          	and	a5,s1,256
    800039c8:	04078463          	beqz	a5,80003a10 <kerneltrap+0x74>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800039cc:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800039d0:	0027f793          	and	a5,a5,2
  if(intr_get() != 0)
    800039d4:	04079663          	bnez	a5,80003a20 <kerneltrap+0x84>
  if((which_dev = devintr()) == 0){
    800039d8:	00000097          	auipc	ra,0x0
    800039dc:	d80080e7          	jalr	-640(ra) # 80003758 <devintr>
    800039e0:	04050863          	beqz	a0,80003a30 <kerneltrap+0x94>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800039e4:	00200793          	li	a5,2
    800039e8:	08f50263          	beq	a0,a5,80003a6c <kerneltrap+0xd0>
  asm volatile("csrw sepc, %0" : : "r" (x));
    800039ec:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800039f0:	10049073          	csrw	sstatus,s1
}
    800039f4:	02813083          	ld	ra,40(sp)
    800039f8:	02013403          	ld	s0,32(sp)
    800039fc:	01813483          	ld	s1,24(sp)
    80003a00:	01013903          	ld	s2,16(sp)
    80003a04:	00813983          	ld	s3,8(sp)
    80003a08:	03010113          	add	sp,sp,48
    80003a0c:	00008067          	ret
    panic("kerneltrap: not from supervisor mode");
    80003a10:	00007517          	auipc	a0,0x7
    80003a14:	a3850513          	add	a0,a0,-1480 # 8000a448 <states.0+0xc8>
    80003a18:	ffffd097          	auipc	ra,0xffffd
    80003a1c:	cb0080e7          	jalr	-848(ra) # 800006c8 <panic>
    panic("kerneltrap: interrupts enabled");
    80003a20:	00007517          	auipc	a0,0x7
    80003a24:	a5050513          	add	a0,a0,-1456 # 8000a470 <states.0+0xf0>
    80003a28:	ffffd097          	auipc	ra,0xffffd
    80003a2c:	ca0080e7          	jalr	-864(ra) # 800006c8 <panic>
    printf("scause %p\n", scause);
    80003a30:	00098593          	mv	a1,s3
    80003a34:	00007517          	auipc	a0,0x7
    80003a38:	a5c50513          	add	a0,a0,-1444 # 8000a490 <states.0+0x110>
    80003a3c:	ffffd097          	auipc	ra,0xffffd
    80003a40:	ce8080e7          	jalr	-792(ra) # 80000724 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80003a44:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80003a48:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80003a4c:	00007517          	auipc	a0,0x7
    80003a50:	a5450513          	add	a0,a0,-1452 # 8000a4a0 <states.0+0x120>
    80003a54:	ffffd097          	auipc	ra,0xffffd
    80003a58:	cd0080e7          	jalr	-816(ra) # 80000724 <printf>
    panic("kerneltrap");
    80003a5c:	00007517          	auipc	a0,0x7
    80003a60:	a5c50513          	add	a0,a0,-1444 # 8000a4b8 <states.0+0x138>
    80003a64:	ffffd097          	auipc	ra,0xffffd
    80003a68:	c64080e7          	jalr	-924(ra) # 800006c8 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80003a6c:	fffff097          	auipc	ra,0xfffff
    80003a70:	9e8080e7          	jalr	-1560(ra) # 80002454 <myproc>
    80003a74:	f6050ce3          	beqz	a0,800039ec <kerneltrap+0x50>
    80003a78:	fffff097          	auipc	ra,0xfffff
    80003a7c:	9dc080e7          	jalr	-1572(ra) # 80002454 <myproc>
    80003a80:	01852703          	lw	a4,24(a0)
    80003a84:	00400793          	li	a5,4
    80003a88:	f6f712e3          	bne	a4,a5,800039ec <kerneltrap+0x50>
    yield();
    80003a8c:	fffff097          	auipc	ra,0xfffff
    80003a90:	2b8080e7          	jalr	696(ra) # 80002d44 <yield>
    80003a94:	f59ff06f          	j	800039ec <kerneltrap+0x50>

0000000080003a98 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80003a98:	fe010113          	add	sp,sp,-32
    80003a9c:	00113c23          	sd	ra,24(sp)
    80003aa0:	00813823          	sd	s0,16(sp)
    80003aa4:	00913423          	sd	s1,8(sp)
    80003aa8:	02010413          	add	s0,sp,32
    80003aac:	00050493          	mv	s1,a0
  struct proc *p = myproc();
    80003ab0:	fffff097          	auipc	ra,0xfffff
    80003ab4:	9a4080e7          	jalr	-1628(ra) # 80002454 <myproc>
  switch (n) {
    80003ab8:	00500793          	li	a5,5
    80003abc:	0697ec63          	bltu	a5,s1,80003b34 <argraw+0x9c>
    80003ac0:	00249493          	sll	s1,s1,0x2
    80003ac4:	00007717          	auipc	a4,0x7
    80003ac8:	a2c70713          	add	a4,a4,-1492 # 8000a4f0 <states.0+0x170>
    80003acc:	00e484b3          	add	s1,s1,a4
    80003ad0:	0004a783          	lw	a5,0(s1)
    80003ad4:	00e787b3          	add	a5,a5,a4
    80003ad8:	00078067          	jr	a5
  case 0:
    return p->trapframe->a0;
    80003adc:	05853783          	ld	a5,88(a0)
    80003ae0:	0707b503          	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80003ae4:	01813083          	ld	ra,24(sp)
    80003ae8:	01013403          	ld	s0,16(sp)
    80003aec:	00813483          	ld	s1,8(sp)
    80003af0:	02010113          	add	sp,sp,32
    80003af4:	00008067          	ret
    return p->trapframe->a1;
    80003af8:	05853783          	ld	a5,88(a0)
    80003afc:	0787b503          	ld	a0,120(a5)
    80003b00:	fe5ff06f          	j	80003ae4 <argraw+0x4c>
    return p->trapframe->a2;
    80003b04:	05853783          	ld	a5,88(a0)
    80003b08:	0807b503          	ld	a0,128(a5)
    80003b0c:	fd9ff06f          	j	80003ae4 <argraw+0x4c>
    return p->trapframe->a3;
    80003b10:	05853783          	ld	a5,88(a0)
    80003b14:	0887b503          	ld	a0,136(a5)
    80003b18:	fcdff06f          	j	80003ae4 <argraw+0x4c>
    return p->trapframe->a4;
    80003b1c:	05853783          	ld	a5,88(a0)
    80003b20:	0907b503          	ld	a0,144(a5)
    80003b24:	fc1ff06f          	j	80003ae4 <argraw+0x4c>
    return p->trapframe->a5;
    80003b28:	05853783          	ld	a5,88(a0)
    80003b2c:	0987b503          	ld	a0,152(a5)
    80003b30:	fb5ff06f          	j	80003ae4 <argraw+0x4c>
  panic("argraw");
    80003b34:	00007517          	auipc	a0,0x7
    80003b38:	99450513          	add	a0,a0,-1644 # 8000a4c8 <states.0+0x148>
    80003b3c:	ffffd097          	auipc	ra,0xffffd
    80003b40:	b8c080e7          	jalr	-1140(ra) # 800006c8 <panic>

0000000080003b44 <fetchaddr>:
{
    80003b44:	fe010113          	add	sp,sp,-32
    80003b48:	00113c23          	sd	ra,24(sp)
    80003b4c:	00813823          	sd	s0,16(sp)
    80003b50:	00913423          	sd	s1,8(sp)
    80003b54:	01213023          	sd	s2,0(sp)
    80003b58:	02010413          	add	s0,sp,32
    80003b5c:	00050493          	mv	s1,a0
    80003b60:	00058913          	mv	s2,a1
  struct proc *p = myproc();
    80003b64:	fffff097          	auipc	ra,0xfffff
    80003b68:	8f0080e7          	jalr	-1808(ra) # 80002454 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80003b6c:	04853783          	ld	a5,72(a0)
    80003b70:	04f4f263          	bgeu	s1,a5,80003bb4 <fetchaddr+0x70>
    80003b74:	00848713          	add	a4,s1,8
    80003b78:	04e7e263          	bltu	a5,a4,80003bbc <fetchaddr+0x78>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80003b7c:	00800693          	li	a3,8
    80003b80:	00048613          	mv	a2,s1
    80003b84:	00090593          	mv	a1,s2
    80003b88:	05053503          	ld	a0,80(a0)
    80003b8c:	ffffe097          	auipc	ra,0xffffe
    80003b90:	4ac080e7          	jalr	1196(ra) # 80002038 <copyin>
    80003b94:	00a03533          	snez	a0,a0
    80003b98:	40a00533          	neg	a0,a0
}
    80003b9c:	01813083          	ld	ra,24(sp)
    80003ba0:	01013403          	ld	s0,16(sp)
    80003ba4:	00813483          	ld	s1,8(sp)
    80003ba8:	00013903          	ld	s2,0(sp)
    80003bac:	02010113          	add	sp,sp,32
    80003bb0:	00008067          	ret
    return -1;
    80003bb4:	fff00513          	li	a0,-1
    80003bb8:	fe5ff06f          	j	80003b9c <fetchaddr+0x58>
    80003bbc:	fff00513          	li	a0,-1
    80003bc0:	fddff06f          	j	80003b9c <fetchaddr+0x58>

0000000080003bc4 <fetchstr>:
{
    80003bc4:	fd010113          	add	sp,sp,-48
    80003bc8:	02113423          	sd	ra,40(sp)
    80003bcc:	02813023          	sd	s0,32(sp)
    80003bd0:	00913c23          	sd	s1,24(sp)
    80003bd4:	01213823          	sd	s2,16(sp)
    80003bd8:	01313423          	sd	s3,8(sp)
    80003bdc:	03010413          	add	s0,sp,48
    80003be0:	00050913          	mv	s2,a0
    80003be4:	00058493          	mv	s1,a1
    80003be8:	00060993          	mv	s3,a2
  struct proc *p = myproc();
    80003bec:	fffff097          	auipc	ra,0xfffff
    80003bf0:	868080e7          	jalr	-1944(ra) # 80002454 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80003bf4:	00098693          	mv	a3,s3
    80003bf8:	00090613          	mv	a2,s2
    80003bfc:	00048593          	mv	a1,s1
    80003c00:	05053503          	ld	a0,80(a0)
    80003c04:	ffffe097          	auipc	ra,0xffffe
    80003c08:	51c080e7          	jalr	1308(ra) # 80002120 <copyinstr>
    80003c0c:	02054663          	bltz	a0,80003c38 <fetchstr+0x74>
  return strlen(buf);
    80003c10:	00048513          	mv	a0,s1
    80003c14:	ffffd097          	auipc	ra,0xffffd
    80003c18:	754080e7          	jalr	1876(ra) # 80001368 <strlen>
}
    80003c1c:	02813083          	ld	ra,40(sp)
    80003c20:	02013403          	ld	s0,32(sp)
    80003c24:	01813483          	ld	s1,24(sp)
    80003c28:	01013903          	ld	s2,16(sp)
    80003c2c:	00813983          	ld	s3,8(sp)
    80003c30:	03010113          	add	sp,sp,48
    80003c34:	00008067          	ret
    return -1;
    80003c38:	fff00513          	li	a0,-1
    80003c3c:	fe1ff06f          	j	80003c1c <fetchstr+0x58>

0000000080003c40 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80003c40:	fe010113          	add	sp,sp,-32
    80003c44:	00113c23          	sd	ra,24(sp)
    80003c48:	00813823          	sd	s0,16(sp)
    80003c4c:	00913423          	sd	s1,8(sp)
    80003c50:	02010413          	add	s0,sp,32
    80003c54:	00058493          	mv	s1,a1
  *ip = argraw(n);
    80003c58:	00000097          	auipc	ra,0x0
    80003c5c:	e40080e7          	jalr	-448(ra) # 80003a98 <argraw>
    80003c60:	00a4a023          	sw	a0,0(s1)
}
    80003c64:	01813083          	ld	ra,24(sp)
    80003c68:	01013403          	ld	s0,16(sp)
    80003c6c:	00813483          	ld	s1,8(sp)
    80003c70:	02010113          	add	sp,sp,32
    80003c74:	00008067          	ret

0000000080003c78 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80003c78:	fe010113          	add	sp,sp,-32
    80003c7c:	00113c23          	sd	ra,24(sp)
    80003c80:	00813823          	sd	s0,16(sp)
    80003c84:	00913423          	sd	s1,8(sp)
    80003c88:	02010413          	add	s0,sp,32
    80003c8c:	00058493          	mv	s1,a1
  *ip = argraw(n);
    80003c90:	00000097          	auipc	ra,0x0
    80003c94:	e08080e7          	jalr	-504(ra) # 80003a98 <argraw>
    80003c98:	00a4b023          	sd	a0,0(s1)
}
    80003c9c:	01813083          	ld	ra,24(sp)
    80003ca0:	01013403          	ld	s0,16(sp)
    80003ca4:	00813483          	ld	s1,8(sp)
    80003ca8:	02010113          	add	sp,sp,32
    80003cac:	00008067          	ret

0000000080003cb0 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80003cb0:	fd010113          	add	sp,sp,-48
    80003cb4:	02113423          	sd	ra,40(sp)
    80003cb8:	02813023          	sd	s0,32(sp)
    80003cbc:	00913c23          	sd	s1,24(sp)
    80003cc0:	01213823          	sd	s2,16(sp)
    80003cc4:	03010413          	add	s0,sp,48
    80003cc8:	00058493          	mv	s1,a1
    80003ccc:	00060913          	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80003cd0:	fd840593          	add	a1,s0,-40
    80003cd4:	00000097          	auipc	ra,0x0
    80003cd8:	fa4080e7          	jalr	-92(ra) # 80003c78 <argaddr>
  return fetchstr(addr, buf, max);
    80003cdc:	00090613          	mv	a2,s2
    80003ce0:	00048593          	mv	a1,s1
    80003ce4:	fd843503          	ld	a0,-40(s0)
    80003ce8:	00000097          	auipc	ra,0x0
    80003cec:	edc080e7          	jalr	-292(ra) # 80003bc4 <fetchstr>
}
    80003cf0:	02813083          	ld	ra,40(sp)
    80003cf4:	02013403          	ld	s0,32(sp)
    80003cf8:	01813483          	ld	s1,24(sp)
    80003cfc:	01013903          	ld	s2,16(sp)
    80003d00:	03010113          	add	sp,sp,48
    80003d04:	00008067          	ret

0000000080003d08 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80003d08:	fe010113          	add	sp,sp,-32
    80003d0c:	00113c23          	sd	ra,24(sp)
    80003d10:	00813823          	sd	s0,16(sp)
    80003d14:	00913423          	sd	s1,8(sp)
    80003d18:	01213023          	sd	s2,0(sp)
    80003d1c:	02010413          	add	s0,sp,32
  int num;
  struct proc *p = myproc();
    80003d20:	ffffe097          	auipc	ra,0xffffe
    80003d24:	734080e7          	jalr	1844(ra) # 80002454 <myproc>
    80003d28:	00050493          	mv	s1,a0

  num = p->trapframe->a7;
    80003d2c:	05853903          	ld	s2,88(a0)
    80003d30:	0a893783          	ld	a5,168(s2)
    80003d34:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80003d38:	fff7879b          	addw	a5,a5,-1
    80003d3c:	01400713          	li	a4,20
    80003d40:	02f76463          	bltu	a4,a5,80003d68 <syscall+0x60>
    80003d44:	00369713          	sll	a4,a3,0x3
    80003d48:	00006797          	auipc	a5,0x6
    80003d4c:	7c078793          	add	a5,a5,1984 # 8000a508 <syscalls>
    80003d50:	00e787b3          	add	a5,a5,a4
    80003d54:	0007b783          	ld	a5,0(a5)
    80003d58:	00078863          	beqz	a5,80003d68 <syscall+0x60>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80003d5c:	000780e7          	jalr	a5
    80003d60:	06a93823          	sd	a0,112(s2)
    80003d64:	0280006f          	j	80003d8c <syscall+0x84>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80003d68:	15848613          	add	a2,s1,344
    80003d6c:	0304a583          	lw	a1,48(s1)
    80003d70:	00006517          	auipc	a0,0x6
    80003d74:	76050513          	add	a0,a0,1888 # 8000a4d0 <states.0+0x150>
    80003d78:	ffffd097          	auipc	ra,0xffffd
    80003d7c:	9ac080e7          	jalr	-1620(ra) # 80000724 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80003d80:	0584b783          	ld	a5,88(s1)
    80003d84:	fff00713          	li	a4,-1
    80003d88:	06e7b823          	sd	a4,112(a5)
  }
}
    80003d8c:	01813083          	ld	ra,24(sp)
    80003d90:	01013403          	ld	s0,16(sp)
    80003d94:	00813483          	ld	s1,8(sp)
    80003d98:	00013903          	ld	s2,0(sp)
    80003d9c:	02010113          	add	sp,sp,32
    80003da0:	00008067          	ret

0000000080003da4 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80003da4:	fe010113          	add	sp,sp,-32
    80003da8:	00113c23          	sd	ra,24(sp)
    80003dac:	00813823          	sd	s0,16(sp)
    80003db0:	02010413          	add	s0,sp,32
  int n;
  argint(0, &n);
    80003db4:	fec40593          	add	a1,s0,-20
    80003db8:	00000513          	li	a0,0
    80003dbc:	00000097          	auipc	ra,0x0
    80003dc0:	e84080e7          	jalr	-380(ra) # 80003c40 <argint>
  exit(n);
    80003dc4:	fec42503          	lw	a0,-20(s0)
    80003dc8:	fffff097          	auipc	ra,0xfffff
    80003dcc:	194080e7          	jalr	404(ra) # 80002f5c <exit>
  return 0;  // not reached
}
    80003dd0:	00000513          	li	a0,0
    80003dd4:	01813083          	ld	ra,24(sp)
    80003dd8:	01013403          	ld	s0,16(sp)
    80003ddc:	02010113          	add	sp,sp,32
    80003de0:	00008067          	ret

0000000080003de4 <sys_getpid>:

uint64
sys_getpid(void)
{
    80003de4:	ff010113          	add	sp,sp,-16
    80003de8:	00113423          	sd	ra,8(sp)
    80003dec:	00813023          	sd	s0,0(sp)
    80003df0:	01010413          	add	s0,sp,16
  return myproc()->pid;
    80003df4:	ffffe097          	auipc	ra,0xffffe
    80003df8:	660080e7          	jalr	1632(ra) # 80002454 <myproc>
}
    80003dfc:	03052503          	lw	a0,48(a0)
    80003e00:	00813083          	ld	ra,8(sp)
    80003e04:	00013403          	ld	s0,0(sp)
    80003e08:	01010113          	add	sp,sp,16
    80003e0c:	00008067          	ret

0000000080003e10 <sys_fork>:

uint64
sys_fork(void)
{
    80003e10:	ff010113          	add	sp,sp,-16
    80003e14:	00113423          	sd	ra,8(sp)
    80003e18:	00813023          	sd	s0,0(sp)
    80003e1c:	01010413          	add	s0,sp,16
  return fork();
    80003e20:	fffff097          	auipc	ra,0xfffff
    80003e24:	b94080e7          	jalr	-1132(ra) # 800029b4 <fork>
}
    80003e28:	00813083          	ld	ra,8(sp)
    80003e2c:	00013403          	ld	s0,0(sp)
    80003e30:	01010113          	add	sp,sp,16
    80003e34:	00008067          	ret

0000000080003e38 <sys_wait>:

uint64
sys_wait(void)
{
    80003e38:	fe010113          	add	sp,sp,-32
    80003e3c:	00113c23          	sd	ra,24(sp)
    80003e40:	00813823          	sd	s0,16(sp)
    80003e44:	02010413          	add	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80003e48:	fe840593          	add	a1,s0,-24
    80003e4c:	00000513          	li	a0,0
    80003e50:	00000097          	auipc	ra,0x0
    80003e54:	e28080e7          	jalr	-472(ra) # 80003c78 <argaddr>
  return wait(p);
    80003e58:	fe843503          	ld	a0,-24(s0)
    80003e5c:	fffff097          	auipc	ra,0xfffff
    80003e60:	340080e7          	jalr	832(ra) # 8000319c <wait>
}
    80003e64:	01813083          	ld	ra,24(sp)
    80003e68:	01013403          	ld	s0,16(sp)
    80003e6c:	02010113          	add	sp,sp,32
    80003e70:	00008067          	ret

0000000080003e74 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80003e74:	fd010113          	add	sp,sp,-48
    80003e78:	02113423          	sd	ra,40(sp)
    80003e7c:	02813023          	sd	s0,32(sp)
    80003e80:	00913c23          	sd	s1,24(sp)
    80003e84:	03010413          	add	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80003e88:	fdc40593          	add	a1,s0,-36
    80003e8c:	00000513          	li	a0,0
    80003e90:	00000097          	auipc	ra,0x0
    80003e94:	db0080e7          	jalr	-592(ra) # 80003c40 <argint>
  addr = myproc()->sz;
    80003e98:	ffffe097          	auipc	ra,0xffffe
    80003e9c:	5bc080e7          	jalr	1468(ra) # 80002454 <myproc>
    80003ea0:	04853483          	ld	s1,72(a0)
  if(growproc(n) < 0)
    80003ea4:	fdc42503          	lw	a0,-36(s0)
    80003ea8:	fffff097          	auipc	ra,0xfffff
    80003eac:	a7c080e7          	jalr	-1412(ra) # 80002924 <growproc>
    80003eb0:	00054e63          	bltz	a0,80003ecc <sys_sbrk+0x58>
    return -1;
  return addr;
}
    80003eb4:	00048513          	mv	a0,s1
    80003eb8:	02813083          	ld	ra,40(sp)
    80003ebc:	02013403          	ld	s0,32(sp)
    80003ec0:	01813483          	ld	s1,24(sp)
    80003ec4:	03010113          	add	sp,sp,48
    80003ec8:	00008067          	ret
    return -1;
    80003ecc:	fff00493          	li	s1,-1
    80003ed0:	fe5ff06f          	j	80003eb4 <sys_sbrk+0x40>

0000000080003ed4 <sys_sleep>:

uint64
sys_sleep(void)
{
    80003ed4:	fc010113          	add	sp,sp,-64
    80003ed8:	02113c23          	sd	ra,56(sp)
    80003edc:	02813823          	sd	s0,48(sp)
    80003ee0:	02913423          	sd	s1,40(sp)
    80003ee4:	03213023          	sd	s2,32(sp)
    80003ee8:	01313c23          	sd	s3,24(sp)
    80003eec:	04010413          	add	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80003ef0:	fcc40593          	add	a1,s0,-52
    80003ef4:	00000513          	li	a0,0
    80003ef8:	00000097          	auipc	ra,0x0
    80003efc:	d48080e7          	jalr	-696(ra) # 80003c40 <argint>
  acquire(&tickslock);
    80003f00:	00015517          	auipc	a0,0x15
    80003f04:	b2050513          	add	a0,a0,-1248 # 80018a20 <tickslock>
    80003f08:	ffffd097          	auipc	ra,0xffffd
    80003f0c:	0bc080e7          	jalr	188(ra) # 80000fc4 <acquire>
  ticks0 = ticks;
    80003f10:	00007917          	auipc	s2,0x7
    80003f14:	a7092903          	lw	s2,-1424(s2) # 8000a980 <ticks>
  while(ticks - ticks0 < n){
    80003f18:	fcc42783          	lw	a5,-52(s0)
    80003f1c:	04078463          	beqz	a5,80003f64 <sys_sleep+0x90>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80003f20:	00015997          	auipc	s3,0x15
    80003f24:	b0098993          	add	s3,s3,-1280 # 80018a20 <tickslock>
    80003f28:	00007497          	auipc	s1,0x7
    80003f2c:	a5848493          	add	s1,s1,-1448 # 8000a980 <ticks>
    if(killed(myproc())){
    80003f30:	ffffe097          	auipc	ra,0xffffe
    80003f34:	524080e7          	jalr	1316(ra) # 80002454 <myproc>
    80003f38:	fffff097          	auipc	ra,0xfffff
    80003f3c:	214080e7          	jalr	532(ra) # 8000314c <killed>
    80003f40:	04051a63          	bnez	a0,80003f94 <sys_sleep+0xc0>
    sleep(&ticks, &tickslock);
    80003f44:	00098593          	mv	a1,s3
    80003f48:	00048513          	mv	a0,s1
    80003f4c:	fffff097          	auipc	ra,0xfffff
    80003f50:	e50080e7          	jalr	-432(ra) # 80002d9c <sleep>
  while(ticks - ticks0 < n){
    80003f54:	0004a783          	lw	a5,0(s1)
    80003f58:	412787bb          	subw	a5,a5,s2
    80003f5c:	fcc42703          	lw	a4,-52(s0)
    80003f60:	fce7e8e3          	bltu	a5,a4,80003f30 <sys_sleep+0x5c>
  }
  release(&tickslock);
    80003f64:	00015517          	auipc	a0,0x15
    80003f68:	abc50513          	add	a0,a0,-1348 # 80018a20 <tickslock>
    80003f6c:	ffffd097          	auipc	ra,0xffffd
    80003f70:	150080e7          	jalr	336(ra) # 800010bc <release>
  return 0;
    80003f74:	00000513          	li	a0,0
}
    80003f78:	03813083          	ld	ra,56(sp)
    80003f7c:	03013403          	ld	s0,48(sp)
    80003f80:	02813483          	ld	s1,40(sp)
    80003f84:	02013903          	ld	s2,32(sp)
    80003f88:	01813983          	ld	s3,24(sp)
    80003f8c:	04010113          	add	sp,sp,64
    80003f90:	00008067          	ret
      release(&tickslock);
    80003f94:	00015517          	auipc	a0,0x15
    80003f98:	a8c50513          	add	a0,a0,-1396 # 80018a20 <tickslock>
    80003f9c:	ffffd097          	auipc	ra,0xffffd
    80003fa0:	120080e7          	jalr	288(ra) # 800010bc <release>
      return -1;
    80003fa4:	fff00513          	li	a0,-1
    80003fa8:	fd1ff06f          	j	80003f78 <sys_sleep+0xa4>

0000000080003fac <sys_kill>:

uint64
sys_kill(void)
{
    80003fac:	fe010113          	add	sp,sp,-32
    80003fb0:	00113c23          	sd	ra,24(sp)
    80003fb4:	00813823          	sd	s0,16(sp)
    80003fb8:	02010413          	add	s0,sp,32
  int pid;

  argint(0, &pid);
    80003fbc:	fec40593          	add	a1,s0,-20
    80003fc0:	00000513          	li	a0,0
    80003fc4:	00000097          	auipc	ra,0x0
    80003fc8:	c7c080e7          	jalr	-900(ra) # 80003c40 <argint>
  return kill(pid);
    80003fcc:	fec42503          	lw	a0,-20(s0)
    80003fd0:	fffff097          	auipc	ra,0xfffff
    80003fd4:	088080e7          	jalr	136(ra) # 80003058 <kill>
}
    80003fd8:	01813083          	ld	ra,24(sp)
    80003fdc:	01013403          	ld	s0,16(sp)
    80003fe0:	02010113          	add	sp,sp,32
    80003fe4:	00008067          	ret

0000000080003fe8 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80003fe8:	fe010113          	add	sp,sp,-32
    80003fec:	00113c23          	sd	ra,24(sp)
    80003ff0:	00813823          	sd	s0,16(sp)
    80003ff4:	00913423          	sd	s1,8(sp)
    80003ff8:	02010413          	add	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80003ffc:	00015517          	auipc	a0,0x15
    80004000:	a2450513          	add	a0,a0,-1500 # 80018a20 <tickslock>
    80004004:	ffffd097          	auipc	ra,0xffffd
    80004008:	fc0080e7          	jalr	-64(ra) # 80000fc4 <acquire>
  xticks = ticks;
    8000400c:	00007497          	auipc	s1,0x7
    80004010:	9744a483          	lw	s1,-1676(s1) # 8000a980 <ticks>
  release(&tickslock);
    80004014:	00015517          	auipc	a0,0x15
    80004018:	a0c50513          	add	a0,a0,-1524 # 80018a20 <tickslock>
    8000401c:	ffffd097          	auipc	ra,0xffffd
    80004020:	0a0080e7          	jalr	160(ra) # 800010bc <release>
  return xticks;
}
    80004024:	02049513          	sll	a0,s1,0x20
    80004028:	02055513          	srl	a0,a0,0x20
    8000402c:	01813083          	ld	ra,24(sp)
    80004030:	01013403          	ld	s0,16(sp)
    80004034:	00813483          	ld	s1,8(sp)
    80004038:	02010113          	add	sp,sp,32
    8000403c:	00008067          	ret

0000000080004040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80004040:	fd010113          	add	sp,sp,-48
    80004044:	02113423          	sd	ra,40(sp)
    80004048:	02813023          	sd	s0,32(sp)
    8000404c:	00913c23          	sd	s1,24(sp)
    80004050:	01213823          	sd	s2,16(sp)
    80004054:	01313423          	sd	s3,8(sp)
    80004058:	01413023          	sd	s4,0(sp)
    8000405c:	03010413          	add	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80004060:	00006597          	auipc	a1,0x6
    80004064:	55858593          	add	a1,a1,1368 # 8000a5b8 <syscalls+0xb0>
    80004068:	00015517          	auipc	a0,0x15
    8000406c:	9d050513          	add	a0,a0,-1584 # 80018a38 <bcache>
    80004070:	ffffd097          	auipc	ra,0xffffd
    80004074:	e70080e7          	jalr	-400(ra) # 80000ee0 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80004078:	0001d797          	auipc	a5,0x1d
    8000407c:	9c078793          	add	a5,a5,-1600 # 80020a38 <bcache+0x8000>
    80004080:	0001d717          	auipc	a4,0x1d
    80004084:	c2070713          	add	a4,a4,-992 # 80020ca0 <bcache+0x8268>
    80004088:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000408c:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80004090:	00015497          	auipc	s1,0x15
    80004094:	9c048493          	add	s1,s1,-1600 # 80018a50 <bcache+0x18>
    b->next = bcache.head.next;
    80004098:	00078913          	mv	s2,a5
    b->prev = &bcache.head;
    8000409c:	00070993          	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800040a0:	00006a17          	auipc	s4,0x6
    800040a4:	520a0a13          	add	s4,s4,1312 # 8000a5c0 <syscalls+0xb8>
    b->next = bcache.head.next;
    800040a8:	2b893783          	ld	a5,696(s2)
    800040ac:	04f4b823          	sd	a5,80(s1)
    b->prev = &bcache.head;
    800040b0:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800040b4:	000a0593          	mv	a1,s4
    800040b8:	01048513          	add	a0,s1,16
    800040bc:	00002097          	auipc	ra,0x2
    800040c0:	c64080e7          	jalr	-924(ra) # 80005d20 <initsleeplock>
    bcache.head.next->prev = b;
    800040c4:	2b893783          	ld	a5,696(s2)
    800040c8:	0497b423          	sd	s1,72(a5)
    bcache.head.next = b;
    800040cc:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800040d0:	45848493          	add	s1,s1,1112
    800040d4:	fd349ae3          	bne	s1,s3,800040a8 <binit+0x68>
  }
}
    800040d8:	02813083          	ld	ra,40(sp)
    800040dc:	02013403          	ld	s0,32(sp)
    800040e0:	01813483          	ld	s1,24(sp)
    800040e4:	01013903          	ld	s2,16(sp)
    800040e8:	00813983          	ld	s3,8(sp)
    800040ec:	00013a03          	ld	s4,0(sp)
    800040f0:	03010113          	add	sp,sp,48
    800040f4:	00008067          	ret

00000000800040f8 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800040f8:	fd010113          	add	sp,sp,-48
    800040fc:	02113423          	sd	ra,40(sp)
    80004100:	02813023          	sd	s0,32(sp)
    80004104:	00913c23          	sd	s1,24(sp)
    80004108:	01213823          	sd	s2,16(sp)
    8000410c:	01313423          	sd	s3,8(sp)
    80004110:	03010413          	add	s0,sp,48
    80004114:	00050913          	mv	s2,a0
    80004118:	00058993          	mv	s3,a1
  acquire(&bcache.lock);
    8000411c:	00015517          	auipc	a0,0x15
    80004120:	91c50513          	add	a0,a0,-1764 # 80018a38 <bcache>
    80004124:	ffffd097          	auipc	ra,0xffffd
    80004128:	ea0080e7          	jalr	-352(ra) # 80000fc4 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000412c:	0001d497          	auipc	s1,0x1d
    80004130:	bc44b483          	ld	s1,-1084(s1) # 80020cf0 <bcache+0x82b8>
    80004134:	0001d797          	auipc	a5,0x1d
    80004138:	b6c78793          	add	a5,a5,-1172 # 80020ca0 <bcache+0x8268>
    8000413c:	04f48863          	beq	s1,a5,8000418c <bread+0x94>
    80004140:	00078713          	mv	a4,a5
    80004144:	00c0006f          	j	80004150 <bread+0x58>
    80004148:	0504b483          	ld	s1,80(s1)
    8000414c:	04e48063          	beq	s1,a4,8000418c <bread+0x94>
    if(b->dev == dev && b->blockno == blockno){
    80004150:	0084a783          	lw	a5,8(s1)
    80004154:	ff279ae3          	bne	a5,s2,80004148 <bread+0x50>
    80004158:	00c4a783          	lw	a5,12(s1)
    8000415c:	ff3796e3          	bne	a5,s3,80004148 <bread+0x50>
      b->refcnt++;
    80004160:	0404a783          	lw	a5,64(s1)
    80004164:	0017879b          	addw	a5,a5,1
    80004168:	04f4a023          	sw	a5,64(s1)
      release(&bcache.lock);
    8000416c:	00015517          	auipc	a0,0x15
    80004170:	8cc50513          	add	a0,a0,-1844 # 80018a38 <bcache>
    80004174:	ffffd097          	auipc	ra,0xffffd
    80004178:	f48080e7          	jalr	-184(ra) # 800010bc <release>
      acquiresleep(&b->lock);
    8000417c:	01048513          	add	a0,s1,16
    80004180:	00002097          	auipc	ra,0x2
    80004184:	bf8080e7          	jalr	-1032(ra) # 80005d78 <acquiresleep>
      return b;
    80004188:	06c0006f          	j	800041f4 <bread+0xfc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000418c:	0001d497          	auipc	s1,0x1d
    80004190:	b5c4b483          	ld	s1,-1188(s1) # 80020ce8 <bcache+0x82b0>
    80004194:	0001d797          	auipc	a5,0x1d
    80004198:	b0c78793          	add	a5,a5,-1268 # 80020ca0 <bcache+0x8268>
    8000419c:	00f48c63          	beq	s1,a5,800041b4 <bread+0xbc>
    800041a0:	00078713          	mv	a4,a5
    if(b->refcnt == 0) {
    800041a4:	0404a783          	lw	a5,64(s1)
    800041a8:	00078e63          	beqz	a5,800041c4 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800041ac:	0484b483          	ld	s1,72(s1)
    800041b0:	fee49ae3          	bne	s1,a4,800041a4 <bread+0xac>
  panic("bget: no buffers");
    800041b4:	00006517          	auipc	a0,0x6
    800041b8:	41450513          	add	a0,a0,1044 # 8000a5c8 <syscalls+0xc0>
    800041bc:	ffffc097          	auipc	ra,0xffffc
    800041c0:	50c080e7          	jalr	1292(ra) # 800006c8 <panic>
      b->dev = dev;
    800041c4:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800041c8:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800041cc:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800041d0:	00100793          	li	a5,1
    800041d4:	04f4a023          	sw	a5,64(s1)
      release(&bcache.lock);
    800041d8:	00015517          	auipc	a0,0x15
    800041dc:	86050513          	add	a0,a0,-1952 # 80018a38 <bcache>
    800041e0:	ffffd097          	auipc	ra,0xffffd
    800041e4:	edc080e7          	jalr	-292(ra) # 800010bc <release>
      acquiresleep(&b->lock);
    800041e8:	01048513          	add	a0,s1,16
    800041ec:	00002097          	auipc	ra,0x2
    800041f0:	b8c080e7          	jalr	-1140(ra) # 80005d78 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800041f4:	0004a783          	lw	a5,0(s1)
    800041f8:	02078263          	beqz	a5,8000421c <bread+0x124>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800041fc:	00048513          	mv	a0,s1
    80004200:	02813083          	ld	ra,40(sp)
    80004204:	02013403          	ld	s0,32(sp)
    80004208:	01813483          	ld	s1,24(sp)
    8000420c:	01013903          	ld	s2,16(sp)
    80004210:	00813983          	ld	s3,8(sp)
    80004214:	03010113          	add	sp,sp,48
    80004218:	00008067          	ret
    virtio_disk_rw(b, 0);
    8000421c:	00000593          	li	a1,0
    80004220:	00048513          	mv	a0,s1
    80004224:	00004097          	auipc	ra,0x4
    80004228:	0c8080e7          	jalr	200(ra) # 800082ec <virtio_disk_rw>
    b->valid = 1;
    8000422c:	00100793          	li	a5,1
    80004230:	00f4a023          	sw	a5,0(s1)
  return b;
    80004234:	fc9ff06f          	j	800041fc <bread+0x104>

0000000080004238 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80004238:	fe010113          	add	sp,sp,-32
    8000423c:	00113c23          	sd	ra,24(sp)
    80004240:	00813823          	sd	s0,16(sp)
    80004244:	00913423          	sd	s1,8(sp)
    80004248:	02010413          	add	s0,sp,32
    8000424c:	00050493          	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80004250:	01050513          	add	a0,a0,16
    80004254:	00002097          	auipc	ra,0x2
    80004258:	c10080e7          	jalr	-1008(ra) # 80005e64 <holdingsleep>
    8000425c:	02050463          	beqz	a0,80004284 <bwrite+0x4c>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80004260:	00100593          	li	a1,1
    80004264:	00048513          	mv	a0,s1
    80004268:	00004097          	auipc	ra,0x4
    8000426c:	084080e7          	jalr	132(ra) # 800082ec <virtio_disk_rw>
}
    80004270:	01813083          	ld	ra,24(sp)
    80004274:	01013403          	ld	s0,16(sp)
    80004278:	00813483          	ld	s1,8(sp)
    8000427c:	02010113          	add	sp,sp,32
    80004280:	00008067          	ret
    panic("bwrite");
    80004284:	00006517          	auipc	a0,0x6
    80004288:	35c50513          	add	a0,a0,860 # 8000a5e0 <syscalls+0xd8>
    8000428c:	ffffc097          	auipc	ra,0xffffc
    80004290:	43c080e7          	jalr	1084(ra) # 800006c8 <panic>

0000000080004294 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80004294:	fe010113          	add	sp,sp,-32
    80004298:	00113c23          	sd	ra,24(sp)
    8000429c:	00813823          	sd	s0,16(sp)
    800042a0:	00913423          	sd	s1,8(sp)
    800042a4:	01213023          	sd	s2,0(sp)
    800042a8:	02010413          	add	s0,sp,32
    800042ac:	00050493          	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800042b0:	01050913          	add	s2,a0,16
    800042b4:	00090513          	mv	a0,s2
    800042b8:	00002097          	auipc	ra,0x2
    800042bc:	bac080e7          	jalr	-1108(ra) # 80005e64 <holdingsleep>
    800042c0:	08050c63          	beqz	a0,80004358 <brelse+0xc4>
    panic("brelse");

  releasesleep(&b->lock);
    800042c4:	00090513          	mv	a0,s2
    800042c8:	00002097          	auipc	ra,0x2
    800042cc:	b38080e7          	jalr	-1224(ra) # 80005e00 <releasesleep>

  acquire(&bcache.lock);
    800042d0:	00014517          	auipc	a0,0x14
    800042d4:	76850513          	add	a0,a0,1896 # 80018a38 <bcache>
    800042d8:	ffffd097          	auipc	ra,0xffffd
    800042dc:	cec080e7          	jalr	-788(ra) # 80000fc4 <acquire>
  b->refcnt--;
    800042e0:	0404a783          	lw	a5,64(s1)
    800042e4:	fff7879b          	addw	a5,a5,-1
    800042e8:	0007871b          	sext.w	a4,a5
    800042ec:	04f4a023          	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800042f0:	04071063          	bnez	a4,80004330 <brelse+0x9c>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800042f4:	0504b703          	ld	a4,80(s1)
    800042f8:	0484b783          	ld	a5,72(s1)
    800042fc:	04f73423          	sd	a5,72(a4)
    b->prev->next = b->next;
    80004300:	0504b703          	ld	a4,80(s1)
    80004304:	04e7b823          	sd	a4,80(a5)
    b->next = bcache.head.next;
    80004308:	0001c797          	auipc	a5,0x1c
    8000430c:	73078793          	add	a5,a5,1840 # 80020a38 <bcache+0x8000>
    80004310:	2b87b703          	ld	a4,696(a5)
    80004314:	04e4b823          	sd	a4,80(s1)
    b->prev = &bcache.head;
    80004318:	0001d717          	auipc	a4,0x1d
    8000431c:	98870713          	add	a4,a4,-1656 # 80020ca0 <bcache+0x8268>
    80004320:	04e4b423          	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80004324:	2b87b703          	ld	a4,696(a5)
    80004328:	04973423          	sd	s1,72(a4)
    bcache.head.next = b;
    8000432c:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80004330:	00014517          	auipc	a0,0x14
    80004334:	70850513          	add	a0,a0,1800 # 80018a38 <bcache>
    80004338:	ffffd097          	auipc	ra,0xffffd
    8000433c:	d84080e7          	jalr	-636(ra) # 800010bc <release>
}
    80004340:	01813083          	ld	ra,24(sp)
    80004344:	01013403          	ld	s0,16(sp)
    80004348:	00813483          	ld	s1,8(sp)
    8000434c:	00013903          	ld	s2,0(sp)
    80004350:	02010113          	add	sp,sp,32
    80004354:	00008067          	ret
    panic("brelse");
    80004358:	00006517          	auipc	a0,0x6
    8000435c:	29050513          	add	a0,a0,656 # 8000a5e8 <syscalls+0xe0>
    80004360:	ffffc097          	auipc	ra,0xffffc
    80004364:	368080e7          	jalr	872(ra) # 800006c8 <panic>

0000000080004368 <bpin>:

void
bpin(struct buf *b) {
    80004368:	fe010113          	add	sp,sp,-32
    8000436c:	00113c23          	sd	ra,24(sp)
    80004370:	00813823          	sd	s0,16(sp)
    80004374:	00913423          	sd	s1,8(sp)
    80004378:	02010413          	add	s0,sp,32
    8000437c:	00050493          	mv	s1,a0
  acquire(&bcache.lock);
    80004380:	00014517          	auipc	a0,0x14
    80004384:	6b850513          	add	a0,a0,1720 # 80018a38 <bcache>
    80004388:	ffffd097          	auipc	ra,0xffffd
    8000438c:	c3c080e7          	jalr	-964(ra) # 80000fc4 <acquire>
  b->refcnt++;
    80004390:	0404a783          	lw	a5,64(s1)
    80004394:	0017879b          	addw	a5,a5,1
    80004398:	04f4a023          	sw	a5,64(s1)
  release(&bcache.lock);
    8000439c:	00014517          	auipc	a0,0x14
    800043a0:	69c50513          	add	a0,a0,1692 # 80018a38 <bcache>
    800043a4:	ffffd097          	auipc	ra,0xffffd
    800043a8:	d18080e7          	jalr	-744(ra) # 800010bc <release>
}
    800043ac:	01813083          	ld	ra,24(sp)
    800043b0:	01013403          	ld	s0,16(sp)
    800043b4:	00813483          	ld	s1,8(sp)
    800043b8:	02010113          	add	sp,sp,32
    800043bc:	00008067          	ret

00000000800043c0 <bunpin>:

void
bunpin(struct buf *b) {
    800043c0:	fe010113          	add	sp,sp,-32
    800043c4:	00113c23          	sd	ra,24(sp)
    800043c8:	00813823          	sd	s0,16(sp)
    800043cc:	00913423          	sd	s1,8(sp)
    800043d0:	02010413          	add	s0,sp,32
    800043d4:	00050493          	mv	s1,a0
  acquire(&bcache.lock);
    800043d8:	00014517          	auipc	a0,0x14
    800043dc:	66050513          	add	a0,a0,1632 # 80018a38 <bcache>
    800043e0:	ffffd097          	auipc	ra,0xffffd
    800043e4:	be4080e7          	jalr	-1052(ra) # 80000fc4 <acquire>
  b->refcnt--;
    800043e8:	0404a783          	lw	a5,64(s1)
    800043ec:	fff7879b          	addw	a5,a5,-1
    800043f0:	04f4a023          	sw	a5,64(s1)
  release(&bcache.lock);
    800043f4:	00014517          	auipc	a0,0x14
    800043f8:	64450513          	add	a0,a0,1604 # 80018a38 <bcache>
    800043fc:	ffffd097          	auipc	ra,0xffffd
    80004400:	cc0080e7          	jalr	-832(ra) # 800010bc <release>
}
    80004404:	01813083          	ld	ra,24(sp)
    80004408:	01013403          	ld	s0,16(sp)
    8000440c:	00813483          	ld	s1,8(sp)
    80004410:	02010113          	add	sp,sp,32
    80004414:	00008067          	ret

0000000080004418 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80004418:	fe010113          	add	sp,sp,-32
    8000441c:	00113c23          	sd	ra,24(sp)
    80004420:	00813823          	sd	s0,16(sp)
    80004424:	00913423          	sd	s1,8(sp)
    80004428:	01213023          	sd	s2,0(sp)
    8000442c:	02010413          	add	s0,sp,32
    80004430:	00058493          	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80004434:	00d5d59b          	srlw	a1,a1,0xd
    80004438:	0001d797          	auipc	a5,0x1d
    8000443c:	cdc7a783          	lw	a5,-804(a5) # 80021114 <sb+0x1c>
    80004440:	00f585bb          	addw	a1,a1,a5
    80004444:	00000097          	auipc	ra,0x0
    80004448:	cb4080e7          	jalr	-844(ra) # 800040f8 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000444c:	0074f713          	and	a4,s1,7
    80004450:	00100793          	li	a5,1
    80004454:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80004458:	03349493          	sll	s1,s1,0x33
    8000445c:	0364d493          	srl	s1,s1,0x36
    80004460:	00950733          	add	a4,a0,s1
    80004464:	05874703          	lbu	a4,88(a4)
    80004468:	00e7f6b3          	and	a3,a5,a4
    8000446c:	04068263          	beqz	a3,800044b0 <bfree+0x98>
    80004470:	00050913          	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80004474:	009504b3          	add	s1,a0,s1
    80004478:	fff7c793          	not	a5,a5
    8000447c:	00f77733          	and	a4,a4,a5
    80004480:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80004484:	00001097          	auipc	ra,0x1
    80004488:	770080e7          	jalr	1904(ra) # 80005bf4 <log_write>
  brelse(bp);
    8000448c:	00090513          	mv	a0,s2
    80004490:	00000097          	auipc	ra,0x0
    80004494:	e04080e7          	jalr	-508(ra) # 80004294 <brelse>
}
    80004498:	01813083          	ld	ra,24(sp)
    8000449c:	01013403          	ld	s0,16(sp)
    800044a0:	00813483          	ld	s1,8(sp)
    800044a4:	00013903          	ld	s2,0(sp)
    800044a8:	02010113          	add	sp,sp,32
    800044ac:	00008067          	ret
    panic("freeing free block");
    800044b0:	00006517          	auipc	a0,0x6
    800044b4:	14050513          	add	a0,a0,320 # 8000a5f0 <syscalls+0xe8>
    800044b8:	ffffc097          	auipc	ra,0xffffc
    800044bc:	210080e7          	jalr	528(ra) # 800006c8 <panic>

00000000800044c0 <balloc>:
{
    800044c0:	fa010113          	add	sp,sp,-96
    800044c4:	04113c23          	sd	ra,88(sp)
    800044c8:	04813823          	sd	s0,80(sp)
    800044cc:	04913423          	sd	s1,72(sp)
    800044d0:	05213023          	sd	s2,64(sp)
    800044d4:	03313c23          	sd	s3,56(sp)
    800044d8:	03413823          	sd	s4,48(sp)
    800044dc:	03513423          	sd	s5,40(sp)
    800044e0:	03613023          	sd	s6,32(sp)
    800044e4:	01713c23          	sd	s7,24(sp)
    800044e8:	01813823          	sd	s8,16(sp)
    800044ec:	01913423          	sd	s9,8(sp)
    800044f0:	06010413          	add	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800044f4:	0001d797          	auipc	a5,0x1d
    800044f8:	c087a783          	lw	a5,-1016(a5) # 800210fc <sb+0x4>
    800044fc:	14078863          	beqz	a5,8000464c <balloc+0x18c>
    80004500:	00050b93          	mv	s7,a0
    80004504:	00000a93          	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80004508:	0001db17          	auipc	s6,0x1d
    8000450c:	bf0b0b13          	add	s6,s6,-1040 # 800210f8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80004510:	00000c13          	li	s8,0
      m = 1 << (bi % 8);
    80004514:	00100993          	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80004518:	00002a37          	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000451c:	00002cb7          	lui	s9,0x2
    80004520:	0bc0006f          	j	800045dc <balloc+0x11c>
        bp->data[bi/8] |= m;  // Mark block in use.
    80004524:	00f907b3          	add	a5,s2,a5
    80004528:	00d66633          	or	a2,a2,a3
    8000452c:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80004530:	00090513          	mv	a0,s2
    80004534:	00001097          	auipc	ra,0x1
    80004538:	6c0080e7          	jalr	1728(ra) # 80005bf4 <log_write>
        brelse(bp);
    8000453c:	00090513          	mv	a0,s2
    80004540:	00000097          	auipc	ra,0x0
    80004544:	d54080e7          	jalr	-684(ra) # 80004294 <brelse>
  bp = bread(dev, bno);
    80004548:	00048593          	mv	a1,s1
    8000454c:	000b8513          	mv	a0,s7
    80004550:	00000097          	auipc	ra,0x0
    80004554:	ba8080e7          	jalr	-1112(ra) # 800040f8 <bread>
    80004558:	00050913          	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000455c:	40000613          	li	a2,1024
    80004560:	00000593          	li	a1,0
    80004564:	05850513          	add	a0,a0,88
    80004568:	ffffd097          	auipc	ra,0xffffd
    8000456c:	bb4080e7          	jalr	-1100(ra) # 8000111c <memset>
  log_write(bp);
    80004570:	00090513          	mv	a0,s2
    80004574:	00001097          	auipc	ra,0x1
    80004578:	680080e7          	jalr	1664(ra) # 80005bf4 <log_write>
  brelse(bp);
    8000457c:	00090513          	mv	a0,s2
    80004580:	00000097          	auipc	ra,0x0
    80004584:	d14080e7          	jalr	-748(ra) # 80004294 <brelse>
}
    80004588:	00048513          	mv	a0,s1
    8000458c:	05813083          	ld	ra,88(sp)
    80004590:	05013403          	ld	s0,80(sp)
    80004594:	04813483          	ld	s1,72(sp)
    80004598:	04013903          	ld	s2,64(sp)
    8000459c:	03813983          	ld	s3,56(sp)
    800045a0:	03013a03          	ld	s4,48(sp)
    800045a4:	02813a83          	ld	s5,40(sp)
    800045a8:	02013b03          	ld	s6,32(sp)
    800045ac:	01813b83          	ld	s7,24(sp)
    800045b0:	01013c03          	ld	s8,16(sp)
    800045b4:	00813c83          	ld	s9,8(sp)
    800045b8:	06010113          	add	sp,sp,96
    800045bc:	00008067          	ret
    brelse(bp);
    800045c0:	00090513          	mv	a0,s2
    800045c4:	00000097          	auipc	ra,0x0
    800045c8:	cd0080e7          	jalr	-816(ra) # 80004294 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800045cc:	015c87bb          	addw	a5,s9,s5
    800045d0:	00078a9b          	sext.w	s5,a5
    800045d4:	004b2703          	lw	a4,4(s6)
    800045d8:	06eafa63          	bgeu	s5,a4,8000464c <balloc+0x18c>
    bp = bread(dev, BBLOCK(b, sb));
    800045dc:	41fad79b          	sraw	a5,s5,0x1f
    800045e0:	0137d79b          	srlw	a5,a5,0x13
    800045e4:	015787bb          	addw	a5,a5,s5
    800045e8:	40d7d79b          	sraw	a5,a5,0xd
    800045ec:	01cb2583          	lw	a1,28(s6)
    800045f0:	00b785bb          	addw	a1,a5,a1
    800045f4:	000b8513          	mv	a0,s7
    800045f8:	00000097          	auipc	ra,0x0
    800045fc:	b00080e7          	jalr	-1280(ra) # 800040f8 <bread>
    80004600:	00050913          	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80004604:	004b2503          	lw	a0,4(s6)
    80004608:	000a849b          	sext.w	s1,s5
    8000460c:	000c0713          	mv	a4,s8
    80004610:	faa4f8e3          	bgeu	s1,a0,800045c0 <balloc+0x100>
      m = 1 << (bi % 8);
    80004614:	00777693          	and	a3,a4,7
    80004618:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000461c:	41f7579b          	sraw	a5,a4,0x1f
    80004620:	01d7d79b          	srlw	a5,a5,0x1d
    80004624:	00e787bb          	addw	a5,a5,a4
    80004628:	4037d79b          	sraw	a5,a5,0x3
    8000462c:	00f90633          	add	a2,s2,a5
    80004630:	05864603          	lbu	a2,88(a2)
    80004634:	00c6f5b3          	and	a1,a3,a2
    80004638:	ee0586e3          	beqz	a1,80004524 <balloc+0x64>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000463c:	0017071b          	addw	a4,a4,1
    80004640:	0014849b          	addw	s1,s1,1
    80004644:	fd4716e3          	bne	a4,s4,80004610 <balloc+0x150>
    80004648:	f79ff06f          	j	800045c0 <balloc+0x100>
  printf("balloc: out of blocks\n");
    8000464c:	00006517          	auipc	a0,0x6
    80004650:	fbc50513          	add	a0,a0,-68 # 8000a608 <syscalls+0x100>
    80004654:	ffffc097          	auipc	ra,0xffffc
    80004658:	0d0080e7          	jalr	208(ra) # 80000724 <printf>
  return 0;
    8000465c:	00000493          	li	s1,0
    80004660:	f29ff06f          	j	80004588 <balloc+0xc8>

0000000080004664 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80004664:	fd010113          	add	sp,sp,-48
    80004668:	02113423          	sd	ra,40(sp)
    8000466c:	02813023          	sd	s0,32(sp)
    80004670:	00913c23          	sd	s1,24(sp)
    80004674:	01213823          	sd	s2,16(sp)
    80004678:	01313423          	sd	s3,8(sp)
    8000467c:	01413023          	sd	s4,0(sp)
    80004680:	03010413          	add	s0,sp,48
    80004684:	00050993          	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80004688:	00b00793          	li	a5,11
    8000468c:	02b7ea63          	bltu	a5,a1,800046c0 <bmap+0x5c>
    if((addr = ip->addrs[bn]) == 0){
    80004690:	02059793          	sll	a5,a1,0x20
    80004694:	01e7d593          	srl	a1,a5,0x1e
    80004698:	00b504b3          	add	s1,a0,a1
    8000469c:	0504a903          	lw	s2,80(s1)
    800046a0:	08091463          	bnez	s2,80004728 <bmap+0xc4>
      addr = balloc(ip->dev);
    800046a4:	00052503          	lw	a0,0(a0)
    800046a8:	00000097          	auipc	ra,0x0
    800046ac:	e18080e7          	jalr	-488(ra) # 800044c0 <balloc>
    800046b0:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800046b4:	06090a63          	beqz	s2,80004728 <bmap+0xc4>
        return 0;
      ip->addrs[bn] = addr;
    800046b8:	0524a823          	sw	s2,80(s1)
    800046bc:	06c0006f          	j	80004728 <bmap+0xc4>
    }
    return addr;
  }
  bn -= NDIRECT;
    800046c0:	ff45849b          	addw	s1,a1,-12
    800046c4:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800046c8:	0ff00793          	li	a5,255
    800046cc:	0ae7e463          	bltu	a5,a4,80004774 <bmap+0x110>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800046d0:	08052903          	lw	s2,128(a0)
    800046d4:	00091e63          	bnez	s2,800046f0 <bmap+0x8c>
      addr = balloc(ip->dev);
    800046d8:	00052503          	lw	a0,0(a0)
    800046dc:	00000097          	auipc	ra,0x0
    800046e0:	de4080e7          	jalr	-540(ra) # 800044c0 <balloc>
    800046e4:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800046e8:	04090063          	beqz	s2,80004728 <bmap+0xc4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    800046ec:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    800046f0:	00090593          	mv	a1,s2
    800046f4:	0009a503          	lw	a0,0(s3)
    800046f8:	00000097          	auipc	ra,0x0
    800046fc:	a00080e7          	jalr	-1536(ra) # 800040f8 <bread>
    80004700:	00050a13          	mv	s4,a0
    a = (uint*)bp->data;
    80004704:	05850793          	add	a5,a0,88
    if((addr = a[bn]) == 0){
    80004708:	02049713          	sll	a4,s1,0x20
    8000470c:	01e75593          	srl	a1,a4,0x1e
    80004710:	00b784b3          	add	s1,a5,a1
    80004714:	0004a903          	lw	s2,0(s1)
    80004718:	02090a63          	beqz	s2,8000474c <bmap+0xe8>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    8000471c:	000a0513          	mv	a0,s4
    80004720:	00000097          	auipc	ra,0x0
    80004724:	b74080e7          	jalr	-1164(ra) # 80004294 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80004728:	00090513          	mv	a0,s2
    8000472c:	02813083          	ld	ra,40(sp)
    80004730:	02013403          	ld	s0,32(sp)
    80004734:	01813483          	ld	s1,24(sp)
    80004738:	01013903          	ld	s2,16(sp)
    8000473c:	00813983          	ld	s3,8(sp)
    80004740:	00013a03          	ld	s4,0(sp)
    80004744:	03010113          	add	sp,sp,48
    80004748:	00008067          	ret
      addr = balloc(ip->dev);
    8000474c:	0009a503          	lw	a0,0(s3)
    80004750:	00000097          	auipc	ra,0x0
    80004754:	d70080e7          	jalr	-656(ra) # 800044c0 <balloc>
    80004758:	0005091b          	sext.w	s2,a0
      if(addr){
    8000475c:	fc0900e3          	beqz	s2,8000471c <bmap+0xb8>
        a[bn] = addr;
    80004760:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80004764:	000a0513          	mv	a0,s4
    80004768:	00001097          	auipc	ra,0x1
    8000476c:	48c080e7          	jalr	1164(ra) # 80005bf4 <log_write>
    80004770:	fadff06f          	j	8000471c <bmap+0xb8>
  panic("bmap: out of range");
    80004774:	00006517          	auipc	a0,0x6
    80004778:	eac50513          	add	a0,a0,-340 # 8000a620 <syscalls+0x118>
    8000477c:	ffffc097          	auipc	ra,0xffffc
    80004780:	f4c080e7          	jalr	-180(ra) # 800006c8 <panic>

0000000080004784 <iget>:
{
    80004784:	fd010113          	add	sp,sp,-48
    80004788:	02113423          	sd	ra,40(sp)
    8000478c:	02813023          	sd	s0,32(sp)
    80004790:	00913c23          	sd	s1,24(sp)
    80004794:	01213823          	sd	s2,16(sp)
    80004798:	01313423          	sd	s3,8(sp)
    8000479c:	01413023          	sd	s4,0(sp)
    800047a0:	03010413          	add	s0,sp,48
    800047a4:	00050993          	mv	s3,a0
    800047a8:	00058a13          	mv	s4,a1
  acquire(&itable.lock);
    800047ac:	0001d517          	auipc	a0,0x1d
    800047b0:	96c50513          	add	a0,a0,-1684 # 80021118 <itable>
    800047b4:	ffffd097          	auipc	ra,0xffffd
    800047b8:	810080e7          	jalr	-2032(ra) # 80000fc4 <acquire>
  empty = 0;
    800047bc:	00000913          	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800047c0:	0001d497          	auipc	s1,0x1d
    800047c4:	97048493          	add	s1,s1,-1680 # 80021130 <itable+0x18>
    800047c8:	0001e697          	auipc	a3,0x1e
    800047cc:	3f868693          	add	a3,a3,1016 # 80022bc0 <log>
    800047d0:	0100006f          	j	800047e0 <iget+0x5c>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800047d4:	04090263          	beqz	s2,80004818 <iget+0x94>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800047d8:	08848493          	add	s1,s1,136
    800047dc:	04d48463          	beq	s1,a3,80004824 <iget+0xa0>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800047e0:	0084a783          	lw	a5,8(s1)
    800047e4:	fef058e3          	blez	a5,800047d4 <iget+0x50>
    800047e8:	0004a703          	lw	a4,0(s1)
    800047ec:	ff3714e3          	bne	a4,s3,800047d4 <iget+0x50>
    800047f0:	0044a703          	lw	a4,4(s1)
    800047f4:	ff4710e3          	bne	a4,s4,800047d4 <iget+0x50>
      ip->ref++;
    800047f8:	0017879b          	addw	a5,a5,1
    800047fc:	00f4a423          	sw	a5,8(s1)
      release(&itable.lock);
    80004800:	0001d517          	auipc	a0,0x1d
    80004804:	91850513          	add	a0,a0,-1768 # 80021118 <itable>
    80004808:	ffffd097          	auipc	ra,0xffffd
    8000480c:	8b4080e7          	jalr	-1868(ra) # 800010bc <release>
      return ip;
    80004810:	00048913          	mv	s2,s1
    80004814:	0380006f          	j	8000484c <iget+0xc8>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80004818:	fc0790e3          	bnez	a5,800047d8 <iget+0x54>
    8000481c:	00048913          	mv	s2,s1
    80004820:	fb9ff06f          	j	800047d8 <iget+0x54>
  if(empty == 0)
    80004824:	04090663          	beqz	s2,80004870 <iget+0xec>
  ip->dev = dev;
    80004828:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000482c:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80004830:	00100793          	li	a5,1
    80004834:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80004838:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000483c:	0001d517          	auipc	a0,0x1d
    80004840:	8dc50513          	add	a0,a0,-1828 # 80021118 <itable>
    80004844:	ffffd097          	auipc	ra,0xffffd
    80004848:	878080e7          	jalr	-1928(ra) # 800010bc <release>
}
    8000484c:	00090513          	mv	a0,s2
    80004850:	02813083          	ld	ra,40(sp)
    80004854:	02013403          	ld	s0,32(sp)
    80004858:	01813483          	ld	s1,24(sp)
    8000485c:	01013903          	ld	s2,16(sp)
    80004860:	00813983          	ld	s3,8(sp)
    80004864:	00013a03          	ld	s4,0(sp)
    80004868:	03010113          	add	sp,sp,48
    8000486c:	00008067          	ret
    panic("iget: no inodes");
    80004870:	00006517          	auipc	a0,0x6
    80004874:	dc850513          	add	a0,a0,-568 # 8000a638 <syscalls+0x130>
    80004878:	ffffc097          	auipc	ra,0xffffc
    8000487c:	e50080e7          	jalr	-432(ra) # 800006c8 <panic>

0000000080004880 <fsinit>:
fsinit(int dev) {
    80004880:	fd010113          	add	sp,sp,-48
    80004884:	02113423          	sd	ra,40(sp)
    80004888:	02813023          	sd	s0,32(sp)
    8000488c:	00913c23          	sd	s1,24(sp)
    80004890:	01213823          	sd	s2,16(sp)
    80004894:	01313423          	sd	s3,8(sp)
    80004898:	03010413          	add	s0,sp,48
    8000489c:	00050913          	mv	s2,a0
  bp = bread(dev, 1);
    800048a0:	00100593          	li	a1,1
    800048a4:	00000097          	auipc	ra,0x0
    800048a8:	854080e7          	jalr	-1964(ra) # 800040f8 <bread>
    800048ac:	00050493          	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800048b0:	0001d997          	auipc	s3,0x1d
    800048b4:	84898993          	add	s3,s3,-1976 # 800210f8 <sb>
    800048b8:	02000613          	li	a2,32
    800048bc:	05850593          	add	a1,a0,88
    800048c0:	00098513          	mv	a0,s3
    800048c4:	ffffd097          	auipc	ra,0xffffd
    800048c8:	8ec080e7          	jalr	-1812(ra) # 800011b0 <memmove>
  brelse(bp);
    800048cc:	00048513          	mv	a0,s1
    800048d0:	00000097          	auipc	ra,0x0
    800048d4:	9c4080e7          	jalr	-1596(ra) # 80004294 <brelse>
  if(sb.magic != FSMAGIC)
    800048d8:	0009a703          	lw	a4,0(s3)
    800048dc:	102037b7          	lui	a5,0x10203
    800048e0:	04078793          	add	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800048e4:	02f71a63          	bne	a4,a5,80004918 <fsinit+0x98>
  initlog(dev, &sb);
    800048e8:	0001d597          	auipc	a1,0x1d
    800048ec:	81058593          	add	a1,a1,-2032 # 800210f8 <sb>
    800048f0:	00090513          	mv	a0,s2
    800048f4:	00001097          	auipc	ra,0x1
    800048f8:	fcc080e7          	jalr	-52(ra) # 800058c0 <initlog>
}
    800048fc:	02813083          	ld	ra,40(sp)
    80004900:	02013403          	ld	s0,32(sp)
    80004904:	01813483          	ld	s1,24(sp)
    80004908:	01013903          	ld	s2,16(sp)
    8000490c:	00813983          	ld	s3,8(sp)
    80004910:	03010113          	add	sp,sp,48
    80004914:	00008067          	ret
    panic("invalid file system");
    80004918:	00006517          	auipc	a0,0x6
    8000491c:	d3050513          	add	a0,a0,-720 # 8000a648 <syscalls+0x140>
    80004920:	ffffc097          	auipc	ra,0xffffc
    80004924:	da8080e7          	jalr	-600(ra) # 800006c8 <panic>

0000000080004928 <iinit>:
{
    80004928:	fd010113          	add	sp,sp,-48
    8000492c:	02113423          	sd	ra,40(sp)
    80004930:	02813023          	sd	s0,32(sp)
    80004934:	00913c23          	sd	s1,24(sp)
    80004938:	01213823          	sd	s2,16(sp)
    8000493c:	01313423          	sd	s3,8(sp)
    80004940:	03010413          	add	s0,sp,48
  initlock(&itable.lock, "itable");
    80004944:	00006597          	auipc	a1,0x6
    80004948:	d1c58593          	add	a1,a1,-740 # 8000a660 <syscalls+0x158>
    8000494c:	0001c517          	auipc	a0,0x1c
    80004950:	7cc50513          	add	a0,a0,1996 # 80021118 <itable>
    80004954:	ffffc097          	auipc	ra,0xffffc
    80004958:	58c080e7          	jalr	1420(ra) # 80000ee0 <initlock>
  for(i = 0; i < NINODE; i++) {
    8000495c:	0001c497          	auipc	s1,0x1c
    80004960:	7e448493          	add	s1,s1,2020 # 80021140 <itable+0x28>
    80004964:	0001e997          	auipc	s3,0x1e
    80004968:	26c98993          	add	s3,s3,620 # 80022bd0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    8000496c:	00006917          	auipc	s2,0x6
    80004970:	cfc90913          	add	s2,s2,-772 # 8000a668 <syscalls+0x160>
    80004974:	00090593          	mv	a1,s2
    80004978:	00048513          	mv	a0,s1
    8000497c:	00001097          	auipc	ra,0x1
    80004980:	3a4080e7          	jalr	932(ra) # 80005d20 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80004984:	08848493          	add	s1,s1,136
    80004988:	ff3496e3          	bne	s1,s3,80004974 <iinit+0x4c>
}
    8000498c:	02813083          	ld	ra,40(sp)
    80004990:	02013403          	ld	s0,32(sp)
    80004994:	01813483          	ld	s1,24(sp)
    80004998:	01013903          	ld	s2,16(sp)
    8000499c:	00813983          	ld	s3,8(sp)
    800049a0:	03010113          	add	sp,sp,48
    800049a4:	00008067          	ret

00000000800049a8 <ialloc>:
{
    800049a8:	fc010113          	add	sp,sp,-64
    800049ac:	02113c23          	sd	ra,56(sp)
    800049b0:	02813823          	sd	s0,48(sp)
    800049b4:	02913423          	sd	s1,40(sp)
    800049b8:	03213023          	sd	s2,32(sp)
    800049bc:	01313c23          	sd	s3,24(sp)
    800049c0:	01413823          	sd	s4,16(sp)
    800049c4:	01513423          	sd	s5,8(sp)
    800049c8:	01613023          	sd	s6,0(sp)
    800049cc:	04010413          	add	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800049d0:	0001c717          	auipc	a4,0x1c
    800049d4:	73472703          	lw	a4,1844(a4) # 80021104 <sb+0xc>
    800049d8:	00100793          	li	a5,1
    800049dc:	06e7f263          	bgeu	a5,a4,80004a40 <ialloc+0x98>
    800049e0:	00050a93          	mv	s5,a0
    800049e4:	00058b13          	mv	s6,a1
    800049e8:	00100913          	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    800049ec:	0001ca17          	auipc	s4,0x1c
    800049f0:	70ca0a13          	add	s4,s4,1804 # 800210f8 <sb>
    800049f4:	00495593          	srl	a1,s2,0x4
    800049f8:	018a2783          	lw	a5,24(s4)
    800049fc:	00b785bb          	addw	a1,a5,a1
    80004a00:	000a8513          	mv	a0,s5
    80004a04:	fffff097          	auipc	ra,0xfffff
    80004a08:	6f4080e7          	jalr	1780(ra) # 800040f8 <bread>
    80004a0c:	00050493          	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80004a10:	05850993          	add	s3,a0,88
    80004a14:	00f97793          	and	a5,s2,15
    80004a18:	00679793          	sll	a5,a5,0x6
    80004a1c:	00f989b3          	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80004a20:	00099783          	lh	a5,0(s3)
    80004a24:	04078c63          	beqz	a5,80004a7c <ialloc+0xd4>
    brelse(bp);
    80004a28:	00000097          	auipc	ra,0x0
    80004a2c:	86c080e7          	jalr	-1940(ra) # 80004294 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80004a30:	00190913          	add	s2,s2,1
    80004a34:	00ca2703          	lw	a4,12(s4)
    80004a38:	0009079b          	sext.w	a5,s2
    80004a3c:	fae7ece3          	bltu	a5,a4,800049f4 <ialloc+0x4c>
  printf("ialloc: no inodes\n");
    80004a40:	00006517          	auipc	a0,0x6
    80004a44:	c3050513          	add	a0,a0,-976 # 8000a670 <syscalls+0x168>
    80004a48:	ffffc097          	auipc	ra,0xffffc
    80004a4c:	cdc080e7          	jalr	-804(ra) # 80000724 <printf>
  return 0;
    80004a50:	00000513          	li	a0,0
}
    80004a54:	03813083          	ld	ra,56(sp)
    80004a58:	03013403          	ld	s0,48(sp)
    80004a5c:	02813483          	ld	s1,40(sp)
    80004a60:	02013903          	ld	s2,32(sp)
    80004a64:	01813983          	ld	s3,24(sp)
    80004a68:	01013a03          	ld	s4,16(sp)
    80004a6c:	00813a83          	ld	s5,8(sp)
    80004a70:	00013b03          	ld	s6,0(sp)
    80004a74:	04010113          	add	sp,sp,64
    80004a78:	00008067          	ret
      memset(dip, 0, sizeof(*dip));
    80004a7c:	04000613          	li	a2,64
    80004a80:	00000593          	li	a1,0
    80004a84:	00098513          	mv	a0,s3
    80004a88:	ffffc097          	auipc	ra,0xffffc
    80004a8c:	694080e7          	jalr	1684(ra) # 8000111c <memset>
      dip->type = type;
    80004a90:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80004a94:	00048513          	mv	a0,s1
    80004a98:	00001097          	auipc	ra,0x1
    80004a9c:	15c080e7          	jalr	348(ra) # 80005bf4 <log_write>
      brelse(bp);
    80004aa0:	00048513          	mv	a0,s1
    80004aa4:	fffff097          	auipc	ra,0xfffff
    80004aa8:	7f0080e7          	jalr	2032(ra) # 80004294 <brelse>
      return iget(dev, inum);
    80004aac:	0009059b          	sext.w	a1,s2
    80004ab0:	000a8513          	mv	a0,s5
    80004ab4:	00000097          	auipc	ra,0x0
    80004ab8:	cd0080e7          	jalr	-816(ra) # 80004784 <iget>
    80004abc:	f99ff06f          	j	80004a54 <ialloc+0xac>

0000000080004ac0 <iupdate>:
{
    80004ac0:	fe010113          	add	sp,sp,-32
    80004ac4:	00113c23          	sd	ra,24(sp)
    80004ac8:	00813823          	sd	s0,16(sp)
    80004acc:	00913423          	sd	s1,8(sp)
    80004ad0:	01213023          	sd	s2,0(sp)
    80004ad4:	02010413          	add	s0,sp,32
    80004ad8:	00050493          	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80004adc:	00452783          	lw	a5,4(a0)
    80004ae0:	0047d79b          	srlw	a5,a5,0x4
    80004ae4:	0001c597          	auipc	a1,0x1c
    80004ae8:	62c5a583          	lw	a1,1580(a1) # 80021110 <sb+0x18>
    80004aec:	00b785bb          	addw	a1,a5,a1
    80004af0:	00052503          	lw	a0,0(a0)
    80004af4:	fffff097          	auipc	ra,0xfffff
    80004af8:	604080e7          	jalr	1540(ra) # 800040f8 <bread>
    80004afc:	00050913          	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80004b00:	05850793          	add	a5,a0,88
    80004b04:	0044a703          	lw	a4,4(s1)
    80004b08:	00f77713          	and	a4,a4,15
    80004b0c:	00671713          	sll	a4,a4,0x6
    80004b10:	00e787b3          	add	a5,a5,a4
  dip->type = ip->type;
    80004b14:	04449703          	lh	a4,68(s1)
    80004b18:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80004b1c:	04649703          	lh	a4,70(s1)
    80004b20:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80004b24:	04849703          	lh	a4,72(s1)
    80004b28:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80004b2c:	04a49703          	lh	a4,74(s1)
    80004b30:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80004b34:	04c4a703          	lw	a4,76(s1)
    80004b38:	00e7a423          	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80004b3c:	03400613          	li	a2,52
    80004b40:	05048593          	add	a1,s1,80
    80004b44:	00c78513          	add	a0,a5,12
    80004b48:	ffffc097          	auipc	ra,0xffffc
    80004b4c:	668080e7          	jalr	1640(ra) # 800011b0 <memmove>
  log_write(bp);
    80004b50:	00090513          	mv	a0,s2
    80004b54:	00001097          	auipc	ra,0x1
    80004b58:	0a0080e7          	jalr	160(ra) # 80005bf4 <log_write>
  brelse(bp);
    80004b5c:	00090513          	mv	a0,s2
    80004b60:	fffff097          	auipc	ra,0xfffff
    80004b64:	734080e7          	jalr	1844(ra) # 80004294 <brelse>
}
    80004b68:	01813083          	ld	ra,24(sp)
    80004b6c:	01013403          	ld	s0,16(sp)
    80004b70:	00813483          	ld	s1,8(sp)
    80004b74:	00013903          	ld	s2,0(sp)
    80004b78:	02010113          	add	sp,sp,32
    80004b7c:	00008067          	ret

0000000080004b80 <idup>:
{
    80004b80:	fe010113          	add	sp,sp,-32
    80004b84:	00113c23          	sd	ra,24(sp)
    80004b88:	00813823          	sd	s0,16(sp)
    80004b8c:	00913423          	sd	s1,8(sp)
    80004b90:	02010413          	add	s0,sp,32
    80004b94:	00050493          	mv	s1,a0
  acquire(&itable.lock);
    80004b98:	0001c517          	auipc	a0,0x1c
    80004b9c:	58050513          	add	a0,a0,1408 # 80021118 <itable>
    80004ba0:	ffffc097          	auipc	ra,0xffffc
    80004ba4:	424080e7          	jalr	1060(ra) # 80000fc4 <acquire>
  ip->ref++;
    80004ba8:	0084a783          	lw	a5,8(s1)
    80004bac:	0017879b          	addw	a5,a5,1
    80004bb0:	00f4a423          	sw	a5,8(s1)
  release(&itable.lock);
    80004bb4:	0001c517          	auipc	a0,0x1c
    80004bb8:	56450513          	add	a0,a0,1380 # 80021118 <itable>
    80004bbc:	ffffc097          	auipc	ra,0xffffc
    80004bc0:	500080e7          	jalr	1280(ra) # 800010bc <release>
}
    80004bc4:	00048513          	mv	a0,s1
    80004bc8:	01813083          	ld	ra,24(sp)
    80004bcc:	01013403          	ld	s0,16(sp)
    80004bd0:	00813483          	ld	s1,8(sp)
    80004bd4:	02010113          	add	sp,sp,32
    80004bd8:	00008067          	ret

0000000080004bdc <ilock>:
{
    80004bdc:	fe010113          	add	sp,sp,-32
    80004be0:	00113c23          	sd	ra,24(sp)
    80004be4:	00813823          	sd	s0,16(sp)
    80004be8:	00913423          	sd	s1,8(sp)
    80004bec:	01213023          	sd	s2,0(sp)
    80004bf0:	02010413          	add	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80004bf4:	02050e63          	beqz	a0,80004c30 <ilock+0x54>
    80004bf8:	00050493          	mv	s1,a0
    80004bfc:	00852783          	lw	a5,8(a0)
    80004c00:	02f05863          	blez	a5,80004c30 <ilock+0x54>
  acquiresleep(&ip->lock);
    80004c04:	01050513          	add	a0,a0,16
    80004c08:	00001097          	auipc	ra,0x1
    80004c0c:	170080e7          	jalr	368(ra) # 80005d78 <acquiresleep>
  if(ip->valid == 0){
    80004c10:	0404a783          	lw	a5,64(s1)
    80004c14:	02078663          	beqz	a5,80004c40 <ilock+0x64>
}
    80004c18:	01813083          	ld	ra,24(sp)
    80004c1c:	01013403          	ld	s0,16(sp)
    80004c20:	00813483          	ld	s1,8(sp)
    80004c24:	00013903          	ld	s2,0(sp)
    80004c28:	02010113          	add	sp,sp,32
    80004c2c:	00008067          	ret
    panic("ilock");
    80004c30:	00006517          	auipc	a0,0x6
    80004c34:	a5850513          	add	a0,a0,-1448 # 8000a688 <syscalls+0x180>
    80004c38:	ffffc097          	auipc	ra,0xffffc
    80004c3c:	a90080e7          	jalr	-1392(ra) # 800006c8 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80004c40:	0044a783          	lw	a5,4(s1)
    80004c44:	0047d79b          	srlw	a5,a5,0x4
    80004c48:	0001c597          	auipc	a1,0x1c
    80004c4c:	4c85a583          	lw	a1,1224(a1) # 80021110 <sb+0x18>
    80004c50:	00b785bb          	addw	a1,a5,a1
    80004c54:	0004a503          	lw	a0,0(s1)
    80004c58:	fffff097          	auipc	ra,0xfffff
    80004c5c:	4a0080e7          	jalr	1184(ra) # 800040f8 <bread>
    80004c60:	00050913          	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80004c64:	05850593          	add	a1,a0,88
    80004c68:	0044a783          	lw	a5,4(s1)
    80004c6c:	00f7f793          	and	a5,a5,15
    80004c70:	00679793          	sll	a5,a5,0x6
    80004c74:	00f585b3          	add	a1,a1,a5
    ip->type = dip->type;
    80004c78:	00059783          	lh	a5,0(a1)
    80004c7c:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80004c80:	00259783          	lh	a5,2(a1)
    80004c84:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80004c88:	00459783          	lh	a5,4(a1)
    80004c8c:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80004c90:	00659783          	lh	a5,6(a1)
    80004c94:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80004c98:	0085a783          	lw	a5,8(a1)
    80004c9c:	04f4a623          	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80004ca0:	03400613          	li	a2,52
    80004ca4:	00c58593          	add	a1,a1,12
    80004ca8:	05048513          	add	a0,s1,80
    80004cac:	ffffc097          	auipc	ra,0xffffc
    80004cb0:	504080e7          	jalr	1284(ra) # 800011b0 <memmove>
    brelse(bp);
    80004cb4:	00090513          	mv	a0,s2
    80004cb8:	fffff097          	auipc	ra,0xfffff
    80004cbc:	5dc080e7          	jalr	1500(ra) # 80004294 <brelse>
    ip->valid = 1;
    80004cc0:	00100793          	li	a5,1
    80004cc4:	04f4a023          	sw	a5,64(s1)
    if(ip->type == 0)
    80004cc8:	04449783          	lh	a5,68(s1)
    80004ccc:	f40796e3          	bnez	a5,80004c18 <ilock+0x3c>
      panic("ilock: no type");
    80004cd0:	00006517          	auipc	a0,0x6
    80004cd4:	9c050513          	add	a0,a0,-1600 # 8000a690 <syscalls+0x188>
    80004cd8:	ffffc097          	auipc	ra,0xffffc
    80004cdc:	9f0080e7          	jalr	-1552(ra) # 800006c8 <panic>

0000000080004ce0 <iunlock>:
{
    80004ce0:	fe010113          	add	sp,sp,-32
    80004ce4:	00113c23          	sd	ra,24(sp)
    80004ce8:	00813823          	sd	s0,16(sp)
    80004cec:	00913423          	sd	s1,8(sp)
    80004cf0:	01213023          	sd	s2,0(sp)
    80004cf4:	02010413          	add	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80004cf8:	04050463          	beqz	a0,80004d40 <iunlock+0x60>
    80004cfc:	00050493          	mv	s1,a0
    80004d00:	01050913          	add	s2,a0,16
    80004d04:	00090513          	mv	a0,s2
    80004d08:	00001097          	auipc	ra,0x1
    80004d0c:	15c080e7          	jalr	348(ra) # 80005e64 <holdingsleep>
    80004d10:	02050863          	beqz	a0,80004d40 <iunlock+0x60>
    80004d14:	0084a783          	lw	a5,8(s1)
    80004d18:	02f05463          	blez	a5,80004d40 <iunlock+0x60>
  releasesleep(&ip->lock);
    80004d1c:	00090513          	mv	a0,s2
    80004d20:	00001097          	auipc	ra,0x1
    80004d24:	0e0080e7          	jalr	224(ra) # 80005e00 <releasesleep>
}
    80004d28:	01813083          	ld	ra,24(sp)
    80004d2c:	01013403          	ld	s0,16(sp)
    80004d30:	00813483          	ld	s1,8(sp)
    80004d34:	00013903          	ld	s2,0(sp)
    80004d38:	02010113          	add	sp,sp,32
    80004d3c:	00008067          	ret
    panic("iunlock");
    80004d40:	00006517          	auipc	a0,0x6
    80004d44:	96050513          	add	a0,a0,-1696 # 8000a6a0 <syscalls+0x198>
    80004d48:	ffffc097          	auipc	ra,0xffffc
    80004d4c:	980080e7          	jalr	-1664(ra) # 800006c8 <panic>

0000000080004d50 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80004d50:	fd010113          	add	sp,sp,-48
    80004d54:	02113423          	sd	ra,40(sp)
    80004d58:	02813023          	sd	s0,32(sp)
    80004d5c:	00913c23          	sd	s1,24(sp)
    80004d60:	01213823          	sd	s2,16(sp)
    80004d64:	01313423          	sd	s3,8(sp)
    80004d68:	01413023          	sd	s4,0(sp)
    80004d6c:	03010413          	add	s0,sp,48
    80004d70:	00050993          	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80004d74:	05050493          	add	s1,a0,80
    80004d78:	08050913          	add	s2,a0,128
    80004d7c:	00c0006f          	j	80004d88 <itrunc+0x38>
    80004d80:	00448493          	add	s1,s1,4
    80004d84:	03248063          	beq	s1,s2,80004da4 <itrunc+0x54>
    if(ip->addrs[i]){
    80004d88:	0004a583          	lw	a1,0(s1)
    80004d8c:	fe058ae3          	beqz	a1,80004d80 <itrunc+0x30>
      bfree(ip->dev, ip->addrs[i]);
    80004d90:	0009a503          	lw	a0,0(s3)
    80004d94:	fffff097          	auipc	ra,0xfffff
    80004d98:	684080e7          	jalr	1668(ra) # 80004418 <bfree>
      ip->addrs[i] = 0;
    80004d9c:	0004a023          	sw	zero,0(s1)
    80004da0:	fe1ff06f          	j	80004d80 <itrunc+0x30>
    }
  }

  if(ip->addrs[NDIRECT]){
    80004da4:	0809a583          	lw	a1,128(s3)
    80004da8:	02059a63          	bnez	a1,80004ddc <itrunc+0x8c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80004dac:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80004db0:	00098513          	mv	a0,s3
    80004db4:	00000097          	auipc	ra,0x0
    80004db8:	d0c080e7          	jalr	-756(ra) # 80004ac0 <iupdate>
}
    80004dbc:	02813083          	ld	ra,40(sp)
    80004dc0:	02013403          	ld	s0,32(sp)
    80004dc4:	01813483          	ld	s1,24(sp)
    80004dc8:	01013903          	ld	s2,16(sp)
    80004dcc:	00813983          	ld	s3,8(sp)
    80004dd0:	00013a03          	ld	s4,0(sp)
    80004dd4:	03010113          	add	sp,sp,48
    80004dd8:	00008067          	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80004ddc:	0009a503          	lw	a0,0(s3)
    80004de0:	fffff097          	auipc	ra,0xfffff
    80004de4:	318080e7          	jalr	792(ra) # 800040f8 <bread>
    80004de8:	00050a13          	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80004dec:	05850493          	add	s1,a0,88
    80004df0:	45850913          	add	s2,a0,1112
    80004df4:	00c0006f          	j	80004e00 <itrunc+0xb0>
    80004df8:	00448493          	add	s1,s1,4
    80004dfc:	01248e63          	beq	s1,s2,80004e18 <itrunc+0xc8>
      if(a[j])
    80004e00:	0004a583          	lw	a1,0(s1)
    80004e04:	fe058ae3          	beqz	a1,80004df8 <itrunc+0xa8>
        bfree(ip->dev, a[j]);
    80004e08:	0009a503          	lw	a0,0(s3)
    80004e0c:	fffff097          	auipc	ra,0xfffff
    80004e10:	60c080e7          	jalr	1548(ra) # 80004418 <bfree>
    80004e14:	fe5ff06f          	j	80004df8 <itrunc+0xa8>
    brelse(bp);
    80004e18:	000a0513          	mv	a0,s4
    80004e1c:	fffff097          	auipc	ra,0xfffff
    80004e20:	478080e7          	jalr	1144(ra) # 80004294 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80004e24:	0809a583          	lw	a1,128(s3)
    80004e28:	0009a503          	lw	a0,0(s3)
    80004e2c:	fffff097          	auipc	ra,0xfffff
    80004e30:	5ec080e7          	jalr	1516(ra) # 80004418 <bfree>
    ip->addrs[NDIRECT] = 0;
    80004e34:	0809a023          	sw	zero,128(s3)
    80004e38:	f75ff06f          	j	80004dac <itrunc+0x5c>

0000000080004e3c <iput>:
{
    80004e3c:	fe010113          	add	sp,sp,-32
    80004e40:	00113c23          	sd	ra,24(sp)
    80004e44:	00813823          	sd	s0,16(sp)
    80004e48:	00913423          	sd	s1,8(sp)
    80004e4c:	01213023          	sd	s2,0(sp)
    80004e50:	02010413          	add	s0,sp,32
    80004e54:	00050493          	mv	s1,a0
  acquire(&itable.lock);
    80004e58:	0001c517          	auipc	a0,0x1c
    80004e5c:	2c050513          	add	a0,a0,704 # 80021118 <itable>
    80004e60:	ffffc097          	auipc	ra,0xffffc
    80004e64:	164080e7          	jalr	356(ra) # 80000fc4 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80004e68:	0084a703          	lw	a4,8(s1)
    80004e6c:	00100793          	li	a5,1
    80004e70:	02f70c63          	beq	a4,a5,80004ea8 <iput+0x6c>
  ip->ref--;
    80004e74:	0084a783          	lw	a5,8(s1)
    80004e78:	fff7879b          	addw	a5,a5,-1
    80004e7c:	00f4a423          	sw	a5,8(s1)
  release(&itable.lock);
    80004e80:	0001c517          	auipc	a0,0x1c
    80004e84:	29850513          	add	a0,a0,664 # 80021118 <itable>
    80004e88:	ffffc097          	auipc	ra,0xffffc
    80004e8c:	234080e7          	jalr	564(ra) # 800010bc <release>
}
    80004e90:	01813083          	ld	ra,24(sp)
    80004e94:	01013403          	ld	s0,16(sp)
    80004e98:	00813483          	ld	s1,8(sp)
    80004e9c:	00013903          	ld	s2,0(sp)
    80004ea0:	02010113          	add	sp,sp,32
    80004ea4:	00008067          	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80004ea8:	0404a783          	lw	a5,64(s1)
    80004eac:	fc0784e3          	beqz	a5,80004e74 <iput+0x38>
    80004eb0:	04a49783          	lh	a5,74(s1)
    80004eb4:	fc0790e3          	bnez	a5,80004e74 <iput+0x38>
    acquiresleep(&ip->lock);
    80004eb8:	01048913          	add	s2,s1,16
    80004ebc:	00090513          	mv	a0,s2
    80004ec0:	00001097          	auipc	ra,0x1
    80004ec4:	eb8080e7          	jalr	-328(ra) # 80005d78 <acquiresleep>
    release(&itable.lock);
    80004ec8:	0001c517          	auipc	a0,0x1c
    80004ecc:	25050513          	add	a0,a0,592 # 80021118 <itable>
    80004ed0:	ffffc097          	auipc	ra,0xffffc
    80004ed4:	1ec080e7          	jalr	492(ra) # 800010bc <release>
    itrunc(ip);
    80004ed8:	00048513          	mv	a0,s1
    80004edc:	00000097          	auipc	ra,0x0
    80004ee0:	e74080e7          	jalr	-396(ra) # 80004d50 <itrunc>
    ip->type = 0;
    80004ee4:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80004ee8:	00048513          	mv	a0,s1
    80004eec:	00000097          	auipc	ra,0x0
    80004ef0:	bd4080e7          	jalr	-1068(ra) # 80004ac0 <iupdate>
    ip->valid = 0;
    80004ef4:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80004ef8:	00090513          	mv	a0,s2
    80004efc:	00001097          	auipc	ra,0x1
    80004f00:	f04080e7          	jalr	-252(ra) # 80005e00 <releasesleep>
    acquire(&itable.lock);
    80004f04:	0001c517          	auipc	a0,0x1c
    80004f08:	21450513          	add	a0,a0,532 # 80021118 <itable>
    80004f0c:	ffffc097          	auipc	ra,0xffffc
    80004f10:	0b8080e7          	jalr	184(ra) # 80000fc4 <acquire>
    80004f14:	f61ff06f          	j	80004e74 <iput+0x38>

0000000080004f18 <iunlockput>:
{
    80004f18:	fe010113          	add	sp,sp,-32
    80004f1c:	00113c23          	sd	ra,24(sp)
    80004f20:	00813823          	sd	s0,16(sp)
    80004f24:	00913423          	sd	s1,8(sp)
    80004f28:	02010413          	add	s0,sp,32
    80004f2c:	00050493          	mv	s1,a0
  iunlock(ip);
    80004f30:	00000097          	auipc	ra,0x0
    80004f34:	db0080e7          	jalr	-592(ra) # 80004ce0 <iunlock>
  iput(ip);
    80004f38:	00048513          	mv	a0,s1
    80004f3c:	00000097          	auipc	ra,0x0
    80004f40:	f00080e7          	jalr	-256(ra) # 80004e3c <iput>
}
    80004f44:	01813083          	ld	ra,24(sp)
    80004f48:	01013403          	ld	s0,16(sp)
    80004f4c:	00813483          	ld	s1,8(sp)
    80004f50:	02010113          	add	sp,sp,32
    80004f54:	00008067          	ret

0000000080004f58 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80004f58:	ff010113          	add	sp,sp,-16
    80004f5c:	00813423          	sd	s0,8(sp)
    80004f60:	01010413          	add	s0,sp,16
  st->dev = ip->dev;
    80004f64:	00052783          	lw	a5,0(a0)
    80004f68:	00f5a023          	sw	a5,0(a1)
  st->ino = ip->inum;
    80004f6c:	00452783          	lw	a5,4(a0)
    80004f70:	00f5a223          	sw	a5,4(a1)
  st->type = ip->type;
    80004f74:	04451783          	lh	a5,68(a0)
    80004f78:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80004f7c:	04a51783          	lh	a5,74(a0)
    80004f80:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80004f84:	04c56783          	lwu	a5,76(a0)
    80004f88:	00f5b823          	sd	a5,16(a1)
}
    80004f8c:	00813403          	ld	s0,8(sp)
    80004f90:	01010113          	add	sp,sp,16
    80004f94:	00008067          	ret

0000000080004f98 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80004f98:	04c52783          	lw	a5,76(a0)
    80004f9c:	16d7e263          	bltu	a5,a3,80005100 <readi+0x168>
{
    80004fa0:	f9010113          	add	sp,sp,-112
    80004fa4:	06113423          	sd	ra,104(sp)
    80004fa8:	06813023          	sd	s0,96(sp)
    80004fac:	04913c23          	sd	s1,88(sp)
    80004fb0:	05213823          	sd	s2,80(sp)
    80004fb4:	05313423          	sd	s3,72(sp)
    80004fb8:	05413023          	sd	s4,64(sp)
    80004fbc:	03513c23          	sd	s5,56(sp)
    80004fc0:	03613823          	sd	s6,48(sp)
    80004fc4:	03713423          	sd	s7,40(sp)
    80004fc8:	03813023          	sd	s8,32(sp)
    80004fcc:	01913c23          	sd	s9,24(sp)
    80004fd0:	01a13823          	sd	s10,16(sp)
    80004fd4:	01b13423          	sd	s11,8(sp)
    80004fd8:	07010413          	add	s0,sp,112
    80004fdc:	00050b13          	mv	s6,a0
    80004fe0:	00058b93          	mv	s7,a1
    80004fe4:	00060a13          	mv	s4,a2
    80004fe8:	00068493          	mv	s1,a3
    80004fec:	00070a93          	mv	s5,a4
  if(off > ip->size || off + n < off)
    80004ff0:	00e6873b          	addw	a4,a3,a4
    return 0;
    80004ff4:	00000513          	li	a0,0
  if(off > ip->size || off + n < off)
    80004ff8:	0cd76263          	bltu	a4,a3,800050bc <readi+0x124>
  if(off + n > ip->size)
    80004ffc:	00e7f463          	bgeu	a5,a4,80005004 <readi+0x6c>
    n = ip->size - off;
    80005000:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80005004:	0e0a8a63          	beqz	s5,800050f8 <readi+0x160>
    80005008:	00000993          	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000500c:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80005010:	fff00c13          	li	s8,-1
    80005014:	0480006f          	j	8000505c <readi+0xc4>
    80005018:	020d1d93          	sll	s11,s10,0x20
    8000501c:	020ddd93          	srl	s11,s11,0x20
    80005020:	05890613          	add	a2,s2,88
    80005024:	000d8693          	mv	a3,s11
    80005028:	00e60633          	add	a2,a2,a4
    8000502c:	000a0593          	mv	a1,s4
    80005030:	000b8513          	mv	a0,s7
    80005034:	ffffe097          	auipc	ra,0xffffe
    80005038:	300080e7          	jalr	768(ra) # 80003334 <either_copyout>
    8000503c:	07850663          	beq	a0,s8,800050a8 <readi+0x110>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80005040:	00090513          	mv	a0,s2
    80005044:	fffff097          	auipc	ra,0xfffff
    80005048:	250080e7          	jalr	592(ra) # 80004294 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000504c:	013d09bb          	addw	s3,s10,s3
    80005050:	009d04bb          	addw	s1,s10,s1
    80005054:	01ba0a33          	add	s4,s4,s11
    80005058:	0759f063          	bgeu	s3,s5,800050b8 <readi+0x120>
    uint addr = bmap(ip, off/BSIZE);
    8000505c:	00a4d59b          	srlw	a1,s1,0xa
    80005060:	000b0513          	mv	a0,s6
    80005064:	fffff097          	auipc	ra,0xfffff
    80005068:	600080e7          	jalr	1536(ra) # 80004664 <bmap>
    8000506c:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80005070:	04058463          	beqz	a1,800050b8 <readi+0x120>
    bp = bread(ip->dev, addr);
    80005074:	000b2503          	lw	a0,0(s6)
    80005078:	fffff097          	auipc	ra,0xfffff
    8000507c:	080080e7          	jalr	128(ra) # 800040f8 <bread>
    80005080:	00050913          	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80005084:	3ff4f713          	and	a4,s1,1023
    80005088:	40ec87bb          	subw	a5,s9,a4
    8000508c:	413a86bb          	subw	a3,s5,s3
    80005090:	00078d13          	mv	s10,a5
    80005094:	0007879b          	sext.w	a5,a5
    80005098:	0006861b          	sext.w	a2,a3
    8000509c:	f6f67ee3          	bgeu	a2,a5,80005018 <readi+0x80>
    800050a0:	00068d13          	mv	s10,a3
    800050a4:	f75ff06f          	j	80005018 <readi+0x80>
      brelse(bp);
    800050a8:	00090513          	mv	a0,s2
    800050ac:	fffff097          	auipc	ra,0xfffff
    800050b0:	1e8080e7          	jalr	488(ra) # 80004294 <brelse>
      tot = -1;
    800050b4:	fff00993          	li	s3,-1
  }
  return tot;
    800050b8:	0009851b          	sext.w	a0,s3
}
    800050bc:	06813083          	ld	ra,104(sp)
    800050c0:	06013403          	ld	s0,96(sp)
    800050c4:	05813483          	ld	s1,88(sp)
    800050c8:	05013903          	ld	s2,80(sp)
    800050cc:	04813983          	ld	s3,72(sp)
    800050d0:	04013a03          	ld	s4,64(sp)
    800050d4:	03813a83          	ld	s5,56(sp)
    800050d8:	03013b03          	ld	s6,48(sp)
    800050dc:	02813b83          	ld	s7,40(sp)
    800050e0:	02013c03          	ld	s8,32(sp)
    800050e4:	01813c83          	ld	s9,24(sp)
    800050e8:	01013d03          	ld	s10,16(sp)
    800050ec:	00813d83          	ld	s11,8(sp)
    800050f0:	07010113          	add	sp,sp,112
    800050f4:	00008067          	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800050f8:	000a8993          	mv	s3,s5
    800050fc:	fbdff06f          	j	800050b8 <readi+0x120>
    return 0;
    80005100:	00000513          	li	a0,0
}
    80005104:	00008067          	ret

0000000080005108 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80005108:	04c52783          	lw	a5,76(a0)
    8000510c:	18d7e063          	bltu	a5,a3,8000528c <writei+0x184>
{
    80005110:	f9010113          	add	sp,sp,-112
    80005114:	06113423          	sd	ra,104(sp)
    80005118:	06813023          	sd	s0,96(sp)
    8000511c:	04913c23          	sd	s1,88(sp)
    80005120:	05213823          	sd	s2,80(sp)
    80005124:	05313423          	sd	s3,72(sp)
    80005128:	05413023          	sd	s4,64(sp)
    8000512c:	03513c23          	sd	s5,56(sp)
    80005130:	03613823          	sd	s6,48(sp)
    80005134:	03713423          	sd	s7,40(sp)
    80005138:	03813023          	sd	s8,32(sp)
    8000513c:	01913c23          	sd	s9,24(sp)
    80005140:	01a13823          	sd	s10,16(sp)
    80005144:	01b13423          	sd	s11,8(sp)
    80005148:	07010413          	add	s0,sp,112
    8000514c:	00050a93          	mv	s5,a0
    80005150:	00058b93          	mv	s7,a1
    80005154:	00060a13          	mv	s4,a2
    80005158:	00068913          	mv	s2,a3
    8000515c:	00070b13          	mv	s6,a4
  if(off > ip->size || off + n < off)
    80005160:	00e687bb          	addw	a5,a3,a4
    80005164:	12d7e863          	bltu	a5,a3,80005294 <writei+0x18c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80005168:	00043737          	lui	a4,0x43
    8000516c:	12f76863          	bltu	a4,a5,8000529c <writei+0x194>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80005170:	100b0a63          	beqz	s6,80005284 <writei+0x17c>
    80005174:	00000993          	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80005178:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000517c:	fff00c13          	li	s8,-1
    80005180:	0540006f          	j	800051d4 <writei+0xcc>
    80005184:	020d1d93          	sll	s11,s10,0x20
    80005188:	020ddd93          	srl	s11,s11,0x20
    8000518c:	05848513          	add	a0,s1,88
    80005190:	000d8693          	mv	a3,s11
    80005194:	000a0613          	mv	a2,s4
    80005198:	000b8593          	mv	a1,s7
    8000519c:	00e50533          	add	a0,a0,a4
    800051a0:	ffffe097          	auipc	ra,0xffffe
    800051a4:	224080e7          	jalr	548(ra) # 800033c4 <either_copyin>
    800051a8:	07850c63          	beq	a0,s8,80005220 <writei+0x118>
      brelse(bp);
      break;
    }
    log_write(bp);
    800051ac:	00048513          	mv	a0,s1
    800051b0:	00001097          	auipc	ra,0x1
    800051b4:	a44080e7          	jalr	-1468(ra) # 80005bf4 <log_write>
    brelse(bp);
    800051b8:	00048513          	mv	a0,s1
    800051bc:	fffff097          	auipc	ra,0xfffff
    800051c0:	0d8080e7          	jalr	216(ra) # 80004294 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800051c4:	013d09bb          	addw	s3,s10,s3
    800051c8:	012d093b          	addw	s2,s10,s2
    800051cc:	01ba0a33          	add	s4,s4,s11
    800051d0:	0569fe63          	bgeu	s3,s6,8000522c <writei+0x124>
    uint addr = bmap(ip, off/BSIZE);
    800051d4:	00a9559b          	srlw	a1,s2,0xa
    800051d8:	000a8513          	mv	a0,s5
    800051dc:	fffff097          	auipc	ra,0xfffff
    800051e0:	488080e7          	jalr	1160(ra) # 80004664 <bmap>
    800051e4:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800051e8:	04058263          	beqz	a1,8000522c <writei+0x124>
    bp = bread(ip->dev, addr);
    800051ec:	000aa503          	lw	a0,0(s5)
    800051f0:	fffff097          	auipc	ra,0xfffff
    800051f4:	f08080e7          	jalr	-248(ra) # 800040f8 <bread>
    800051f8:	00050493          	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800051fc:	3ff97713          	and	a4,s2,1023
    80005200:	40ec87bb          	subw	a5,s9,a4
    80005204:	413b06bb          	subw	a3,s6,s3
    80005208:	00078d13          	mv	s10,a5
    8000520c:	0007879b          	sext.w	a5,a5
    80005210:	0006861b          	sext.w	a2,a3
    80005214:	f6f678e3          	bgeu	a2,a5,80005184 <writei+0x7c>
    80005218:	00068d13          	mv	s10,a3
    8000521c:	f69ff06f          	j	80005184 <writei+0x7c>
      brelse(bp);
    80005220:	00048513          	mv	a0,s1
    80005224:	fffff097          	auipc	ra,0xfffff
    80005228:	070080e7          	jalr	112(ra) # 80004294 <brelse>
  }

  if(off > ip->size)
    8000522c:	04caa783          	lw	a5,76(s5)
    80005230:	0127f463          	bgeu	a5,s2,80005238 <writei+0x130>
    ip->size = off;
    80005234:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80005238:	000a8513          	mv	a0,s5
    8000523c:	00000097          	auipc	ra,0x0
    80005240:	884080e7          	jalr	-1916(ra) # 80004ac0 <iupdate>

  return tot;
    80005244:	0009851b          	sext.w	a0,s3
}
    80005248:	06813083          	ld	ra,104(sp)
    8000524c:	06013403          	ld	s0,96(sp)
    80005250:	05813483          	ld	s1,88(sp)
    80005254:	05013903          	ld	s2,80(sp)
    80005258:	04813983          	ld	s3,72(sp)
    8000525c:	04013a03          	ld	s4,64(sp)
    80005260:	03813a83          	ld	s5,56(sp)
    80005264:	03013b03          	ld	s6,48(sp)
    80005268:	02813b83          	ld	s7,40(sp)
    8000526c:	02013c03          	ld	s8,32(sp)
    80005270:	01813c83          	ld	s9,24(sp)
    80005274:	01013d03          	ld	s10,16(sp)
    80005278:	00813d83          	ld	s11,8(sp)
    8000527c:	07010113          	add	sp,sp,112
    80005280:	00008067          	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80005284:	000b0993          	mv	s3,s6
    80005288:	fb1ff06f          	j	80005238 <writei+0x130>
    return -1;
    8000528c:	fff00513          	li	a0,-1
}
    80005290:	00008067          	ret
    return -1;
    80005294:	fff00513          	li	a0,-1
    80005298:	fb1ff06f          	j	80005248 <writei+0x140>
    return -1;
    8000529c:	fff00513          	li	a0,-1
    800052a0:	fa9ff06f          	j	80005248 <writei+0x140>

00000000800052a4 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800052a4:	ff010113          	add	sp,sp,-16
    800052a8:	00113423          	sd	ra,8(sp)
    800052ac:	00813023          	sd	s0,0(sp)
    800052b0:	01010413          	add	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800052b4:	00e00613          	li	a2,14
    800052b8:	ffffc097          	auipc	ra,0xffffc
    800052bc:	fa4080e7          	jalr	-92(ra) # 8000125c <strncmp>
}
    800052c0:	00813083          	ld	ra,8(sp)
    800052c4:	00013403          	ld	s0,0(sp)
    800052c8:	01010113          	add	sp,sp,16
    800052cc:	00008067          	ret

00000000800052d0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800052d0:	fc010113          	add	sp,sp,-64
    800052d4:	02113c23          	sd	ra,56(sp)
    800052d8:	02813823          	sd	s0,48(sp)
    800052dc:	02913423          	sd	s1,40(sp)
    800052e0:	03213023          	sd	s2,32(sp)
    800052e4:	01313c23          	sd	s3,24(sp)
    800052e8:	01413823          	sd	s4,16(sp)
    800052ec:	04010413          	add	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800052f0:	04451703          	lh	a4,68(a0)
    800052f4:	00100793          	li	a5,1
    800052f8:	02f71263          	bne	a4,a5,8000531c <dirlookup+0x4c>
    800052fc:	00050913          	mv	s2,a0
    80005300:	00058993          	mv	s3,a1
    80005304:	00060a13          	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80005308:	04c52783          	lw	a5,76(a0)
    8000530c:	00000493          	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80005310:	00000513          	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80005314:	02079a63          	bnez	a5,80005348 <dirlookup+0x78>
    80005318:	0900006f          	j	800053a8 <dirlookup+0xd8>
    panic("dirlookup not DIR");
    8000531c:	00005517          	auipc	a0,0x5
    80005320:	38c50513          	add	a0,a0,908 # 8000a6a8 <syscalls+0x1a0>
    80005324:	ffffb097          	auipc	ra,0xffffb
    80005328:	3a4080e7          	jalr	932(ra) # 800006c8 <panic>
      panic("dirlookup read");
    8000532c:	00005517          	auipc	a0,0x5
    80005330:	39450513          	add	a0,a0,916 # 8000a6c0 <syscalls+0x1b8>
    80005334:	ffffb097          	auipc	ra,0xffffb
    80005338:	394080e7          	jalr	916(ra) # 800006c8 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000533c:	0104849b          	addw	s1,s1,16
    80005340:	04c92783          	lw	a5,76(s2)
    80005344:	06f4f063          	bgeu	s1,a5,800053a4 <dirlookup+0xd4>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005348:	01000713          	li	a4,16
    8000534c:	00048693          	mv	a3,s1
    80005350:	fc040613          	add	a2,s0,-64
    80005354:	00000593          	li	a1,0
    80005358:	00090513          	mv	a0,s2
    8000535c:	00000097          	auipc	ra,0x0
    80005360:	c3c080e7          	jalr	-964(ra) # 80004f98 <readi>
    80005364:	01000793          	li	a5,16
    80005368:	fcf512e3          	bne	a0,a5,8000532c <dirlookup+0x5c>
    if(de.inum == 0)
    8000536c:	fc045783          	lhu	a5,-64(s0)
    80005370:	fc0786e3          	beqz	a5,8000533c <dirlookup+0x6c>
    if(namecmp(name, de.name) == 0){
    80005374:	fc240593          	add	a1,s0,-62
    80005378:	00098513          	mv	a0,s3
    8000537c:	00000097          	auipc	ra,0x0
    80005380:	f28080e7          	jalr	-216(ra) # 800052a4 <namecmp>
    80005384:	fa051ce3          	bnez	a0,8000533c <dirlookup+0x6c>
      if(poff)
    80005388:	000a0463          	beqz	s4,80005390 <dirlookup+0xc0>
        *poff = off;
    8000538c:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80005390:	fc045583          	lhu	a1,-64(s0)
    80005394:	00092503          	lw	a0,0(s2)
    80005398:	fffff097          	auipc	ra,0xfffff
    8000539c:	3ec080e7          	jalr	1004(ra) # 80004784 <iget>
    800053a0:	0080006f          	j	800053a8 <dirlookup+0xd8>
  return 0;
    800053a4:	00000513          	li	a0,0
}
    800053a8:	03813083          	ld	ra,56(sp)
    800053ac:	03013403          	ld	s0,48(sp)
    800053b0:	02813483          	ld	s1,40(sp)
    800053b4:	02013903          	ld	s2,32(sp)
    800053b8:	01813983          	ld	s3,24(sp)
    800053bc:	01013a03          	ld	s4,16(sp)
    800053c0:	04010113          	add	sp,sp,64
    800053c4:	00008067          	ret

00000000800053c8 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800053c8:	fa010113          	add	sp,sp,-96
    800053cc:	04113c23          	sd	ra,88(sp)
    800053d0:	04813823          	sd	s0,80(sp)
    800053d4:	04913423          	sd	s1,72(sp)
    800053d8:	05213023          	sd	s2,64(sp)
    800053dc:	03313c23          	sd	s3,56(sp)
    800053e0:	03413823          	sd	s4,48(sp)
    800053e4:	03513423          	sd	s5,40(sp)
    800053e8:	03613023          	sd	s6,32(sp)
    800053ec:	01713c23          	sd	s7,24(sp)
    800053f0:	01813823          	sd	s8,16(sp)
    800053f4:	01913423          	sd	s9,8(sp)
    800053f8:	06010413          	add	s0,sp,96
    800053fc:	00050493          	mv	s1,a0
    80005400:	00058b13          	mv	s6,a1
    80005404:	00060a93          	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80005408:	00054703          	lbu	a4,0(a0)
    8000540c:	02f00793          	li	a5,47
    80005410:	02f70663          	beq	a4,a5,8000543c <namex+0x74>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80005414:	ffffd097          	auipc	ra,0xffffd
    80005418:	040080e7          	jalr	64(ra) # 80002454 <myproc>
    8000541c:	15053503          	ld	a0,336(a0)
    80005420:	fffff097          	auipc	ra,0xfffff
    80005424:	760080e7          	jalr	1888(ra) # 80004b80 <idup>
    80005428:	00050a13          	mv	s4,a0
  while(*path == '/')
    8000542c:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80005430:	00d00c13          	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80005434:	00100b93          	li	s7,1
    80005438:	10c0006f          	j	80005544 <namex+0x17c>
    ip = iget(ROOTDEV, ROOTINO);
    8000543c:	00100593          	li	a1,1
    80005440:	00100513          	li	a0,1
    80005444:	fffff097          	auipc	ra,0xfffff
    80005448:	340080e7          	jalr	832(ra) # 80004784 <iget>
    8000544c:	00050a13          	mv	s4,a0
    80005450:	fddff06f          	j	8000542c <namex+0x64>
      iunlockput(ip);
    80005454:	000a0513          	mv	a0,s4
    80005458:	00000097          	auipc	ra,0x0
    8000545c:	ac0080e7          	jalr	-1344(ra) # 80004f18 <iunlockput>
      return 0;
    80005460:	00000a13          	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80005464:	000a0513          	mv	a0,s4
    80005468:	05813083          	ld	ra,88(sp)
    8000546c:	05013403          	ld	s0,80(sp)
    80005470:	04813483          	ld	s1,72(sp)
    80005474:	04013903          	ld	s2,64(sp)
    80005478:	03813983          	ld	s3,56(sp)
    8000547c:	03013a03          	ld	s4,48(sp)
    80005480:	02813a83          	ld	s5,40(sp)
    80005484:	02013b03          	ld	s6,32(sp)
    80005488:	01813b83          	ld	s7,24(sp)
    8000548c:	01013c03          	ld	s8,16(sp)
    80005490:	00813c83          	ld	s9,8(sp)
    80005494:	06010113          	add	sp,sp,96
    80005498:	00008067          	ret
      iunlock(ip);
    8000549c:	000a0513          	mv	a0,s4
    800054a0:	00000097          	auipc	ra,0x0
    800054a4:	840080e7          	jalr	-1984(ra) # 80004ce0 <iunlock>
      return ip;
    800054a8:	fbdff06f          	j	80005464 <namex+0x9c>
      iunlockput(ip);
    800054ac:	000a0513          	mv	a0,s4
    800054b0:	00000097          	auipc	ra,0x0
    800054b4:	a68080e7          	jalr	-1432(ra) # 80004f18 <iunlockput>
      return 0;
    800054b8:	00098a13          	mv	s4,s3
    800054bc:	fa9ff06f          	j	80005464 <namex+0x9c>
  len = path - s;
    800054c0:	40998633          	sub	a2,s3,s1
    800054c4:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    800054c8:	0b9c5e63          	bge	s8,s9,80005584 <namex+0x1bc>
    memmove(name, s, DIRSIZ);
    800054cc:	00e00613          	li	a2,14
    800054d0:	00048593          	mv	a1,s1
    800054d4:	000a8513          	mv	a0,s5
    800054d8:	ffffc097          	auipc	ra,0xffffc
    800054dc:	cd8080e7          	jalr	-808(ra) # 800011b0 <memmove>
    800054e0:	00098493          	mv	s1,s3
  while(*path == '/')
    800054e4:	0004c783          	lbu	a5,0(s1)
    800054e8:	01279863          	bne	a5,s2,800054f8 <namex+0x130>
    path++;
    800054ec:	00148493          	add	s1,s1,1
  while(*path == '/')
    800054f0:	0004c783          	lbu	a5,0(s1)
    800054f4:	ff278ce3          	beq	a5,s2,800054ec <namex+0x124>
    ilock(ip);
    800054f8:	000a0513          	mv	a0,s4
    800054fc:	fffff097          	auipc	ra,0xfffff
    80005500:	6e0080e7          	jalr	1760(ra) # 80004bdc <ilock>
    if(ip->type != T_DIR){
    80005504:	044a1783          	lh	a5,68(s4)
    80005508:	f57796e3          	bne	a5,s7,80005454 <namex+0x8c>
    if(nameiparent && *path == '\0'){
    8000550c:	000b0663          	beqz	s6,80005518 <namex+0x150>
    80005510:	0004c783          	lbu	a5,0(s1)
    80005514:	f80784e3          	beqz	a5,8000549c <namex+0xd4>
    if((next = dirlookup(ip, name, 0)) == 0){
    80005518:	00000613          	li	a2,0
    8000551c:	000a8593          	mv	a1,s5
    80005520:	000a0513          	mv	a0,s4
    80005524:	00000097          	auipc	ra,0x0
    80005528:	dac080e7          	jalr	-596(ra) # 800052d0 <dirlookup>
    8000552c:	00050993          	mv	s3,a0
    80005530:	f6050ee3          	beqz	a0,800054ac <namex+0xe4>
    iunlockput(ip);
    80005534:	000a0513          	mv	a0,s4
    80005538:	00000097          	auipc	ra,0x0
    8000553c:	9e0080e7          	jalr	-1568(ra) # 80004f18 <iunlockput>
    ip = next;
    80005540:	00098a13          	mv	s4,s3
  while(*path == '/')
    80005544:	0004c783          	lbu	a5,0(s1)
    80005548:	01279863          	bne	a5,s2,80005558 <namex+0x190>
    path++;
    8000554c:	00148493          	add	s1,s1,1
  while(*path == '/')
    80005550:	0004c783          	lbu	a5,0(s1)
    80005554:	ff278ce3          	beq	a5,s2,8000554c <namex+0x184>
  if(*path == 0)
    80005558:	04078863          	beqz	a5,800055a8 <namex+0x1e0>
  while(*path != '/' && *path != 0)
    8000555c:	0004c783          	lbu	a5,0(s1)
    80005560:	00048993          	mv	s3,s1
  len = path - s;
    80005564:	00000c93          	li	s9,0
    80005568:	00000613          	li	a2,0
  while(*path != '/' && *path != 0)
    8000556c:	01278c63          	beq	a5,s2,80005584 <namex+0x1bc>
    80005570:	f40788e3          	beqz	a5,800054c0 <namex+0xf8>
    path++;
    80005574:	00198993          	add	s3,s3,1
  while(*path != '/' && *path != 0)
    80005578:	0009c783          	lbu	a5,0(s3)
    8000557c:	ff279ae3          	bne	a5,s2,80005570 <namex+0x1a8>
    80005580:	f41ff06f          	j	800054c0 <namex+0xf8>
    memmove(name, s, len);
    80005584:	0006061b          	sext.w	a2,a2
    80005588:	00048593          	mv	a1,s1
    8000558c:	000a8513          	mv	a0,s5
    80005590:	ffffc097          	auipc	ra,0xffffc
    80005594:	c20080e7          	jalr	-992(ra) # 800011b0 <memmove>
    name[len] = 0;
    80005598:	019a8cb3          	add	s9,s5,s9
    8000559c:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    800055a0:	00098493          	mv	s1,s3
    800055a4:	f41ff06f          	j	800054e4 <namex+0x11c>
  if(nameiparent){
    800055a8:	ea0b0ee3          	beqz	s6,80005464 <namex+0x9c>
    iput(ip);
    800055ac:	000a0513          	mv	a0,s4
    800055b0:	00000097          	auipc	ra,0x0
    800055b4:	88c080e7          	jalr	-1908(ra) # 80004e3c <iput>
    return 0;
    800055b8:	00000a13          	li	s4,0
    800055bc:	ea9ff06f          	j	80005464 <namex+0x9c>

00000000800055c0 <dirlink>:
{
    800055c0:	fc010113          	add	sp,sp,-64
    800055c4:	02113c23          	sd	ra,56(sp)
    800055c8:	02813823          	sd	s0,48(sp)
    800055cc:	02913423          	sd	s1,40(sp)
    800055d0:	03213023          	sd	s2,32(sp)
    800055d4:	01313c23          	sd	s3,24(sp)
    800055d8:	01413823          	sd	s4,16(sp)
    800055dc:	04010413          	add	s0,sp,64
    800055e0:	00050913          	mv	s2,a0
    800055e4:	00058a13          	mv	s4,a1
    800055e8:	00060993          	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800055ec:	00000613          	li	a2,0
    800055f0:	00000097          	auipc	ra,0x0
    800055f4:	ce0080e7          	jalr	-800(ra) # 800052d0 <dirlookup>
    800055f8:	0a051463          	bnez	a0,800056a0 <dirlink+0xe0>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800055fc:	04c92483          	lw	s1,76(s2)
    80005600:	04048063          	beqz	s1,80005640 <dirlink+0x80>
    80005604:	00000493          	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005608:	01000713          	li	a4,16
    8000560c:	00048693          	mv	a3,s1
    80005610:	fc040613          	add	a2,s0,-64
    80005614:	00000593          	li	a1,0
    80005618:	00090513          	mv	a0,s2
    8000561c:	00000097          	auipc	ra,0x0
    80005620:	97c080e7          	jalr	-1668(ra) # 80004f98 <readi>
    80005624:	01000793          	li	a5,16
    80005628:	08f51463          	bne	a0,a5,800056b0 <dirlink+0xf0>
    if(de.inum == 0)
    8000562c:	fc045783          	lhu	a5,-64(s0)
    80005630:	00078863          	beqz	a5,80005640 <dirlink+0x80>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80005634:	0104849b          	addw	s1,s1,16
    80005638:	04c92783          	lw	a5,76(s2)
    8000563c:	fcf4e6e3          	bltu	s1,a5,80005608 <dirlink+0x48>
  strncpy(de.name, name, DIRSIZ);
    80005640:	00e00613          	li	a2,14
    80005644:	000a0593          	mv	a1,s4
    80005648:	fc240513          	add	a0,s0,-62
    8000564c:	ffffc097          	auipc	ra,0xffffc
    80005650:	c74080e7          	jalr	-908(ra) # 800012c0 <strncpy>
  de.inum = inum;
    80005654:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005658:	01000713          	li	a4,16
    8000565c:	00048693          	mv	a3,s1
    80005660:	fc040613          	add	a2,s0,-64
    80005664:	00000593          	li	a1,0
    80005668:	00090513          	mv	a0,s2
    8000566c:	00000097          	auipc	ra,0x0
    80005670:	a9c080e7          	jalr	-1380(ra) # 80005108 <writei>
    80005674:	ff050513          	add	a0,a0,-16
    80005678:	00a03533          	snez	a0,a0
    8000567c:	40a00533          	neg	a0,a0
}
    80005680:	03813083          	ld	ra,56(sp)
    80005684:	03013403          	ld	s0,48(sp)
    80005688:	02813483          	ld	s1,40(sp)
    8000568c:	02013903          	ld	s2,32(sp)
    80005690:	01813983          	ld	s3,24(sp)
    80005694:	01013a03          	ld	s4,16(sp)
    80005698:	04010113          	add	sp,sp,64
    8000569c:	00008067          	ret
    iput(ip);
    800056a0:	fffff097          	auipc	ra,0xfffff
    800056a4:	79c080e7          	jalr	1948(ra) # 80004e3c <iput>
    return -1;
    800056a8:	fff00513          	li	a0,-1
    800056ac:	fd5ff06f          	j	80005680 <dirlink+0xc0>
      panic("dirlink read");
    800056b0:	00005517          	auipc	a0,0x5
    800056b4:	02050513          	add	a0,a0,32 # 8000a6d0 <syscalls+0x1c8>
    800056b8:	ffffb097          	auipc	ra,0xffffb
    800056bc:	010080e7          	jalr	16(ra) # 800006c8 <panic>

00000000800056c0 <namei>:

struct inode*
namei(char *path)
{
    800056c0:	fe010113          	add	sp,sp,-32
    800056c4:	00113c23          	sd	ra,24(sp)
    800056c8:	00813823          	sd	s0,16(sp)
    800056cc:	02010413          	add	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800056d0:	fe040613          	add	a2,s0,-32
    800056d4:	00000593          	li	a1,0
    800056d8:	00000097          	auipc	ra,0x0
    800056dc:	cf0080e7          	jalr	-784(ra) # 800053c8 <namex>
}
    800056e0:	01813083          	ld	ra,24(sp)
    800056e4:	01013403          	ld	s0,16(sp)
    800056e8:	02010113          	add	sp,sp,32
    800056ec:	00008067          	ret

00000000800056f0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800056f0:	ff010113          	add	sp,sp,-16
    800056f4:	00113423          	sd	ra,8(sp)
    800056f8:	00813023          	sd	s0,0(sp)
    800056fc:	01010413          	add	s0,sp,16
    80005700:	00058613          	mv	a2,a1
  return namex(path, 1, name);
    80005704:	00100593          	li	a1,1
    80005708:	00000097          	auipc	ra,0x0
    8000570c:	cc0080e7          	jalr	-832(ra) # 800053c8 <namex>
}
    80005710:	00813083          	ld	ra,8(sp)
    80005714:	00013403          	ld	s0,0(sp)
    80005718:	01010113          	add	sp,sp,16
    8000571c:	00008067          	ret

0000000080005720 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80005720:	fe010113          	add	sp,sp,-32
    80005724:	00113c23          	sd	ra,24(sp)
    80005728:	00813823          	sd	s0,16(sp)
    8000572c:	00913423          	sd	s1,8(sp)
    80005730:	01213023          	sd	s2,0(sp)
    80005734:	02010413          	add	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80005738:	0001d917          	auipc	s2,0x1d
    8000573c:	48890913          	add	s2,s2,1160 # 80022bc0 <log>
    80005740:	01892583          	lw	a1,24(s2)
    80005744:	02892503          	lw	a0,40(s2)
    80005748:	fffff097          	auipc	ra,0xfffff
    8000574c:	9b0080e7          	jalr	-1616(ra) # 800040f8 <bread>
    80005750:	00050493          	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80005754:	02c92603          	lw	a2,44(s2)
    80005758:	04c52c23          	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000575c:	02c05663          	blez	a2,80005788 <write_head+0x68>
    80005760:	0001d717          	auipc	a4,0x1d
    80005764:	49070713          	add	a4,a4,1168 # 80022bf0 <log+0x30>
    80005768:	00050793          	mv	a5,a0
    8000576c:	00261613          	sll	a2,a2,0x2
    80005770:	00a60633          	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80005774:	00072683          	lw	a3,0(a4)
    80005778:	04d7ae23          	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    8000577c:	00470713          	add	a4,a4,4
    80005780:	00478793          	add	a5,a5,4
    80005784:	fec798e3          	bne	a5,a2,80005774 <write_head+0x54>
  }
  bwrite(buf);
    80005788:	00048513          	mv	a0,s1
    8000578c:	fffff097          	auipc	ra,0xfffff
    80005790:	aac080e7          	jalr	-1364(ra) # 80004238 <bwrite>
  brelse(buf);
    80005794:	00048513          	mv	a0,s1
    80005798:	fffff097          	auipc	ra,0xfffff
    8000579c:	afc080e7          	jalr	-1284(ra) # 80004294 <brelse>
}
    800057a0:	01813083          	ld	ra,24(sp)
    800057a4:	01013403          	ld	s0,16(sp)
    800057a8:	00813483          	ld	s1,8(sp)
    800057ac:	00013903          	ld	s2,0(sp)
    800057b0:	02010113          	add	sp,sp,32
    800057b4:	00008067          	ret

00000000800057b8 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800057b8:	0001d797          	auipc	a5,0x1d
    800057bc:	4347a783          	lw	a5,1076(a5) # 80022bec <log+0x2c>
    800057c0:	0ef05e63          	blez	a5,800058bc <install_trans+0x104>
{
    800057c4:	fc010113          	add	sp,sp,-64
    800057c8:	02113c23          	sd	ra,56(sp)
    800057cc:	02813823          	sd	s0,48(sp)
    800057d0:	02913423          	sd	s1,40(sp)
    800057d4:	03213023          	sd	s2,32(sp)
    800057d8:	01313c23          	sd	s3,24(sp)
    800057dc:	01413823          	sd	s4,16(sp)
    800057e0:	01513423          	sd	s5,8(sp)
    800057e4:	01613023          	sd	s6,0(sp)
    800057e8:	04010413          	add	s0,sp,64
    800057ec:	00050b13          	mv	s6,a0
    800057f0:	0001da97          	auipc	s5,0x1d
    800057f4:	400a8a93          	add	s5,s5,1024 # 80022bf0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800057f8:	00000a13          	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800057fc:	0001d997          	auipc	s3,0x1d
    80005800:	3c498993          	add	s3,s3,964 # 80022bc0 <log>
    80005804:	02c0006f          	j	80005830 <install_trans+0x78>
    brelse(lbuf);
    80005808:	00090513          	mv	a0,s2
    8000580c:	fffff097          	auipc	ra,0xfffff
    80005810:	a88080e7          	jalr	-1400(ra) # 80004294 <brelse>
    brelse(dbuf);
    80005814:	00048513          	mv	a0,s1
    80005818:	fffff097          	auipc	ra,0xfffff
    8000581c:	a7c080e7          	jalr	-1412(ra) # 80004294 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80005820:	001a0a1b          	addw	s4,s4,1
    80005824:	004a8a93          	add	s5,s5,4
    80005828:	02c9a783          	lw	a5,44(s3)
    8000582c:	06fa5463          	bge	s4,a5,80005894 <install_trans+0xdc>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80005830:	0189a583          	lw	a1,24(s3)
    80005834:	014585bb          	addw	a1,a1,s4
    80005838:	0015859b          	addw	a1,a1,1
    8000583c:	0289a503          	lw	a0,40(s3)
    80005840:	fffff097          	auipc	ra,0xfffff
    80005844:	8b8080e7          	jalr	-1864(ra) # 800040f8 <bread>
    80005848:	00050913          	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000584c:	000aa583          	lw	a1,0(s5)
    80005850:	0289a503          	lw	a0,40(s3)
    80005854:	fffff097          	auipc	ra,0xfffff
    80005858:	8a4080e7          	jalr	-1884(ra) # 800040f8 <bread>
    8000585c:	00050493          	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80005860:	40000613          	li	a2,1024
    80005864:	05890593          	add	a1,s2,88
    80005868:	05850513          	add	a0,a0,88
    8000586c:	ffffc097          	auipc	ra,0xffffc
    80005870:	944080e7          	jalr	-1724(ra) # 800011b0 <memmove>
    bwrite(dbuf);  // write dst to disk
    80005874:	00048513          	mv	a0,s1
    80005878:	fffff097          	auipc	ra,0xfffff
    8000587c:	9c0080e7          	jalr	-1600(ra) # 80004238 <bwrite>
    if(recovering == 0)
    80005880:	f80b14e3          	bnez	s6,80005808 <install_trans+0x50>
      bunpin(dbuf);
    80005884:	00048513          	mv	a0,s1
    80005888:	fffff097          	auipc	ra,0xfffff
    8000588c:	b38080e7          	jalr	-1224(ra) # 800043c0 <bunpin>
    80005890:	f79ff06f          	j	80005808 <install_trans+0x50>
}
    80005894:	03813083          	ld	ra,56(sp)
    80005898:	03013403          	ld	s0,48(sp)
    8000589c:	02813483          	ld	s1,40(sp)
    800058a0:	02013903          	ld	s2,32(sp)
    800058a4:	01813983          	ld	s3,24(sp)
    800058a8:	01013a03          	ld	s4,16(sp)
    800058ac:	00813a83          	ld	s5,8(sp)
    800058b0:	00013b03          	ld	s6,0(sp)
    800058b4:	04010113          	add	sp,sp,64
    800058b8:	00008067          	ret
    800058bc:	00008067          	ret

00000000800058c0 <initlog>:
{
    800058c0:	fd010113          	add	sp,sp,-48
    800058c4:	02113423          	sd	ra,40(sp)
    800058c8:	02813023          	sd	s0,32(sp)
    800058cc:	00913c23          	sd	s1,24(sp)
    800058d0:	01213823          	sd	s2,16(sp)
    800058d4:	01313423          	sd	s3,8(sp)
    800058d8:	03010413          	add	s0,sp,48
    800058dc:	00050913          	mv	s2,a0
    800058e0:	00058993          	mv	s3,a1
  initlock(&log.lock, "log");
    800058e4:	0001d497          	auipc	s1,0x1d
    800058e8:	2dc48493          	add	s1,s1,732 # 80022bc0 <log>
    800058ec:	00005597          	auipc	a1,0x5
    800058f0:	df458593          	add	a1,a1,-524 # 8000a6e0 <syscalls+0x1d8>
    800058f4:	00048513          	mv	a0,s1
    800058f8:	ffffb097          	auipc	ra,0xffffb
    800058fc:	5e8080e7          	jalr	1512(ra) # 80000ee0 <initlock>
  log.start = sb->logstart;
    80005900:	0149a583          	lw	a1,20(s3)
    80005904:	00b4ac23          	sw	a1,24(s1)
  log.size = sb->nlog;
    80005908:	0109a783          	lw	a5,16(s3)
    8000590c:	00f4ae23          	sw	a5,28(s1)
  log.dev = dev;
    80005910:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80005914:	00090513          	mv	a0,s2
    80005918:	ffffe097          	auipc	ra,0xffffe
    8000591c:	7e0080e7          	jalr	2016(ra) # 800040f8 <bread>
  log.lh.n = lh->n;
    80005920:	05852603          	lw	a2,88(a0)
    80005924:	02c4a623          	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80005928:	02c05663          	blez	a2,80005954 <initlog+0x94>
    8000592c:	00050793          	mv	a5,a0
    80005930:	0001d717          	auipc	a4,0x1d
    80005934:	2c070713          	add	a4,a4,704 # 80022bf0 <log+0x30>
    80005938:	00261613          	sll	a2,a2,0x2
    8000593c:	00a60633          	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80005940:	05c7a683          	lw	a3,92(a5)
    80005944:	00d72023          	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80005948:	00478793          	add	a5,a5,4
    8000594c:	00470713          	add	a4,a4,4
    80005950:	fec798e3          	bne	a5,a2,80005940 <initlog+0x80>
  brelse(buf);
    80005954:	fffff097          	auipc	ra,0xfffff
    80005958:	940080e7          	jalr	-1728(ra) # 80004294 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000595c:	00100513          	li	a0,1
    80005960:	00000097          	auipc	ra,0x0
    80005964:	e58080e7          	jalr	-424(ra) # 800057b8 <install_trans>
  log.lh.n = 0;
    80005968:	0001d797          	auipc	a5,0x1d
    8000596c:	2807a223          	sw	zero,644(a5) # 80022bec <log+0x2c>
  write_head(); // clear the log
    80005970:	00000097          	auipc	ra,0x0
    80005974:	db0080e7          	jalr	-592(ra) # 80005720 <write_head>
}
    80005978:	02813083          	ld	ra,40(sp)
    8000597c:	02013403          	ld	s0,32(sp)
    80005980:	01813483          	ld	s1,24(sp)
    80005984:	01013903          	ld	s2,16(sp)
    80005988:	00813983          	ld	s3,8(sp)
    8000598c:	03010113          	add	sp,sp,48
    80005990:	00008067          	ret

0000000080005994 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80005994:	fe010113          	add	sp,sp,-32
    80005998:	00113c23          	sd	ra,24(sp)
    8000599c:	00813823          	sd	s0,16(sp)
    800059a0:	00913423          	sd	s1,8(sp)
    800059a4:	01213023          	sd	s2,0(sp)
    800059a8:	02010413          	add	s0,sp,32
  acquire(&log.lock);
    800059ac:	0001d517          	auipc	a0,0x1d
    800059b0:	21450513          	add	a0,a0,532 # 80022bc0 <log>
    800059b4:	ffffb097          	auipc	ra,0xffffb
    800059b8:	610080e7          	jalr	1552(ra) # 80000fc4 <acquire>
  while(1){
    if(log.committing){
    800059bc:	0001d497          	auipc	s1,0x1d
    800059c0:	20448493          	add	s1,s1,516 # 80022bc0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800059c4:	01e00913          	li	s2,30
    800059c8:	0140006f          	j	800059dc <begin_op+0x48>
      sleep(&log, &log.lock);
    800059cc:	00048593          	mv	a1,s1
    800059d0:	00048513          	mv	a0,s1
    800059d4:	ffffd097          	auipc	ra,0xffffd
    800059d8:	3c8080e7          	jalr	968(ra) # 80002d9c <sleep>
    if(log.committing){
    800059dc:	0244a783          	lw	a5,36(s1)
    800059e0:	fe0796e3          	bnez	a5,800059cc <begin_op+0x38>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800059e4:	0204a703          	lw	a4,32(s1)
    800059e8:	0017071b          	addw	a4,a4,1
    800059ec:	0027179b          	sllw	a5,a4,0x2
    800059f0:	00e787bb          	addw	a5,a5,a4
    800059f4:	0017979b          	sllw	a5,a5,0x1
    800059f8:	02c4a683          	lw	a3,44(s1)
    800059fc:	00d787bb          	addw	a5,a5,a3
    80005a00:	00f95c63          	bge	s2,a5,80005a18 <begin_op+0x84>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80005a04:	00048593          	mv	a1,s1
    80005a08:	00048513          	mv	a0,s1
    80005a0c:	ffffd097          	auipc	ra,0xffffd
    80005a10:	390080e7          	jalr	912(ra) # 80002d9c <sleep>
    80005a14:	fc9ff06f          	j	800059dc <begin_op+0x48>
    } else {
      log.outstanding += 1;
    80005a18:	0001d517          	auipc	a0,0x1d
    80005a1c:	1a850513          	add	a0,a0,424 # 80022bc0 <log>
    80005a20:	02e52023          	sw	a4,32(a0)
      release(&log.lock);
    80005a24:	ffffb097          	auipc	ra,0xffffb
    80005a28:	698080e7          	jalr	1688(ra) # 800010bc <release>
      break;
    }
  }
}
    80005a2c:	01813083          	ld	ra,24(sp)
    80005a30:	01013403          	ld	s0,16(sp)
    80005a34:	00813483          	ld	s1,8(sp)
    80005a38:	00013903          	ld	s2,0(sp)
    80005a3c:	02010113          	add	sp,sp,32
    80005a40:	00008067          	ret

0000000080005a44 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80005a44:	fc010113          	add	sp,sp,-64
    80005a48:	02113c23          	sd	ra,56(sp)
    80005a4c:	02813823          	sd	s0,48(sp)
    80005a50:	02913423          	sd	s1,40(sp)
    80005a54:	03213023          	sd	s2,32(sp)
    80005a58:	01313c23          	sd	s3,24(sp)
    80005a5c:	01413823          	sd	s4,16(sp)
    80005a60:	01513423          	sd	s5,8(sp)
    80005a64:	04010413          	add	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80005a68:	0001d497          	auipc	s1,0x1d
    80005a6c:	15848493          	add	s1,s1,344 # 80022bc0 <log>
    80005a70:	00048513          	mv	a0,s1
    80005a74:	ffffb097          	auipc	ra,0xffffb
    80005a78:	550080e7          	jalr	1360(ra) # 80000fc4 <acquire>
  log.outstanding -= 1;
    80005a7c:	0204a783          	lw	a5,32(s1)
    80005a80:	fff7879b          	addw	a5,a5,-1
    80005a84:	0007891b          	sext.w	s2,a5
    80005a88:	02f4a023          	sw	a5,32(s1)
  if(log.committing)
    80005a8c:	0244a783          	lw	a5,36(s1)
    80005a90:	06079063          	bnez	a5,80005af0 <end_op+0xac>
    panic("log.committing");
  if(log.outstanding == 0){
    80005a94:	06091663          	bnez	s2,80005b00 <end_op+0xbc>
    do_commit = 1;
    log.committing = 1;
    80005a98:	0001d497          	auipc	s1,0x1d
    80005a9c:	12848493          	add	s1,s1,296 # 80022bc0 <log>
    80005aa0:	00100793          	li	a5,1
    80005aa4:	02f4a223          	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80005aa8:	00048513          	mv	a0,s1
    80005aac:	ffffb097          	auipc	ra,0xffffb
    80005ab0:	610080e7          	jalr	1552(ra) # 800010bc <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80005ab4:	02c4a783          	lw	a5,44(s1)
    80005ab8:	08f04663          	bgtz	a5,80005b44 <end_op+0x100>
    acquire(&log.lock);
    80005abc:	0001d497          	auipc	s1,0x1d
    80005ac0:	10448493          	add	s1,s1,260 # 80022bc0 <log>
    80005ac4:	00048513          	mv	a0,s1
    80005ac8:	ffffb097          	auipc	ra,0xffffb
    80005acc:	4fc080e7          	jalr	1276(ra) # 80000fc4 <acquire>
    log.committing = 0;
    80005ad0:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80005ad4:	00048513          	mv	a0,s1
    80005ad8:	ffffd097          	auipc	ra,0xffffd
    80005adc:	354080e7          	jalr	852(ra) # 80002e2c <wakeup>
    release(&log.lock);
    80005ae0:	00048513          	mv	a0,s1
    80005ae4:	ffffb097          	auipc	ra,0xffffb
    80005ae8:	5d8080e7          	jalr	1496(ra) # 800010bc <release>
}
    80005aec:	0340006f          	j	80005b20 <end_op+0xdc>
    panic("log.committing");
    80005af0:	00005517          	auipc	a0,0x5
    80005af4:	bf850513          	add	a0,a0,-1032 # 8000a6e8 <syscalls+0x1e0>
    80005af8:	ffffb097          	auipc	ra,0xffffb
    80005afc:	bd0080e7          	jalr	-1072(ra) # 800006c8 <panic>
    wakeup(&log);
    80005b00:	0001d497          	auipc	s1,0x1d
    80005b04:	0c048493          	add	s1,s1,192 # 80022bc0 <log>
    80005b08:	00048513          	mv	a0,s1
    80005b0c:	ffffd097          	auipc	ra,0xffffd
    80005b10:	320080e7          	jalr	800(ra) # 80002e2c <wakeup>
  release(&log.lock);
    80005b14:	00048513          	mv	a0,s1
    80005b18:	ffffb097          	auipc	ra,0xffffb
    80005b1c:	5a4080e7          	jalr	1444(ra) # 800010bc <release>
}
    80005b20:	03813083          	ld	ra,56(sp)
    80005b24:	03013403          	ld	s0,48(sp)
    80005b28:	02813483          	ld	s1,40(sp)
    80005b2c:	02013903          	ld	s2,32(sp)
    80005b30:	01813983          	ld	s3,24(sp)
    80005b34:	01013a03          	ld	s4,16(sp)
    80005b38:	00813a83          	ld	s5,8(sp)
    80005b3c:	04010113          	add	sp,sp,64
    80005b40:	00008067          	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80005b44:	0001da97          	auipc	s5,0x1d
    80005b48:	0aca8a93          	add	s5,s5,172 # 80022bf0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80005b4c:	0001da17          	auipc	s4,0x1d
    80005b50:	074a0a13          	add	s4,s4,116 # 80022bc0 <log>
    80005b54:	018a2583          	lw	a1,24(s4)
    80005b58:	012585bb          	addw	a1,a1,s2
    80005b5c:	0015859b          	addw	a1,a1,1
    80005b60:	028a2503          	lw	a0,40(s4)
    80005b64:	ffffe097          	auipc	ra,0xffffe
    80005b68:	594080e7          	jalr	1428(ra) # 800040f8 <bread>
    80005b6c:	00050493          	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80005b70:	000aa583          	lw	a1,0(s5)
    80005b74:	028a2503          	lw	a0,40(s4)
    80005b78:	ffffe097          	auipc	ra,0xffffe
    80005b7c:	580080e7          	jalr	1408(ra) # 800040f8 <bread>
    80005b80:	00050993          	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80005b84:	40000613          	li	a2,1024
    80005b88:	05850593          	add	a1,a0,88
    80005b8c:	05848513          	add	a0,s1,88
    80005b90:	ffffb097          	auipc	ra,0xffffb
    80005b94:	620080e7          	jalr	1568(ra) # 800011b0 <memmove>
    bwrite(to);  // write the log
    80005b98:	00048513          	mv	a0,s1
    80005b9c:	ffffe097          	auipc	ra,0xffffe
    80005ba0:	69c080e7          	jalr	1692(ra) # 80004238 <bwrite>
    brelse(from);
    80005ba4:	00098513          	mv	a0,s3
    80005ba8:	ffffe097          	auipc	ra,0xffffe
    80005bac:	6ec080e7          	jalr	1772(ra) # 80004294 <brelse>
    brelse(to);
    80005bb0:	00048513          	mv	a0,s1
    80005bb4:	ffffe097          	auipc	ra,0xffffe
    80005bb8:	6e0080e7          	jalr	1760(ra) # 80004294 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80005bbc:	0019091b          	addw	s2,s2,1
    80005bc0:	004a8a93          	add	s5,s5,4
    80005bc4:	02ca2783          	lw	a5,44(s4)
    80005bc8:	f8f946e3          	blt	s2,a5,80005b54 <end_op+0x110>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80005bcc:	00000097          	auipc	ra,0x0
    80005bd0:	b54080e7          	jalr	-1196(ra) # 80005720 <write_head>
    install_trans(0); // Now install writes to home locations
    80005bd4:	00000513          	li	a0,0
    80005bd8:	00000097          	auipc	ra,0x0
    80005bdc:	be0080e7          	jalr	-1056(ra) # 800057b8 <install_trans>
    log.lh.n = 0;
    80005be0:	0001d797          	auipc	a5,0x1d
    80005be4:	0007a623          	sw	zero,12(a5) # 80022bec <log+0x2c>
    write_head();    // Erase the transaction from the log
    80005be8:	00000097          	auipc	ra,0x0
    80005bec:	b38080e7          	jalr	-1224(ra) # 80005720 <write_head>
    80005bf0:	ecdff06f          	j	80005abc <end_op+0x78>

0000000080005bf4 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80005bf4:	fe010113          	add	sp,sp,-32
    80005bf8:	00113c23          	sd	ra,24(sp)
    80005bfc:	00813823          	sd	s0,16(sp)
    80005c00:	00913423          	sd	s1,8(sp)
    80005c04:	01213023          	sd	s2,0(sp)
    80005c08:	02010413          	add	s0,sp,32
    80005c0c:	00050493          	mv	s1,a0
  int i;

  acquire(&log.lock);
    80005c10:	0001d917          	auipc	s2,0x1d
    80005c14:	fb090913          	add	s2,s2,-80 # 80022bc0 <log>
    80005c18:	00090513          	mv	a0,s2
    80005c1c:	ffffb097          	auipc	ra,0xffffb
    80005c20:	3a8080e7          	jalr	936(ra) # 80000fc4 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80005c24:	02c92603          	lw	a2,44(s2)
    80005c28:	01d00793          	li	a5,29
    80005c2c:	08c7c663          	blt	a5,a2,80005cb8 <log_write+0xc4>
    80005c30:	0001d797          	auipc	a5,0x1d
    80005c34:	fac7a783          	lw	a5,-84(a5) # 80022bdc <log+0x1c>
    80005c38:	fff7879b          	addw	a5,a5,-1
    80005c3c:	06f65e63          	bge	a2,a5,80005cb8 <log_write+0xc4>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80005c40:	0001d797          	auipc	a5,0x1d
    80005c44:	fa07a783          	lw	a5,-96(a5) # 80022be0 <log+0x20>
    80005c48:	08f05063          	blez	a5,80005cc8 <log_write+0xd4>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80005c4c:	00000793          	li	a5,0
    80005c50:	08c05463          	blez	a2,80005cd8 <log_write+0xe4>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80005c54:	00c4a583          	lw	a1,12(s1)
    80005c58:	0001d717          	auipc	a4,0x1d
    80005c5c:	f9870713          	add	a4,a4,-104 # 80022bf0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80005c60:	00000793          	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80005c64:	00072683          	lw	a3,0(a4)
    80005c68:	06b68863          	beq	a3,a1,80005cd8 <log_write+0xe4>
  for (i = 0; i < log.lh.n; i++) {
    80005c6c:	0017879b          	addw	a5,a5,1
    80005c70:	00470713          	add	a4,a4,4
    80005c74:	fef618e3          	bne	a2,a5,80005c64 <log_write+0x70>
      break;
  }
  log.lh.block[i] = b->blockno;
    80005c78:	00860613          	add	a2,a2,8
    80005c7c:	00261613          	sll	a2,a2,0x2
    80005c80:	0001d797          	auipc	a5,0x1d
    80005c84:	f4078793          	add	a5,a5,-192 # 80022bc0 <log>
    80005c88:	00c787b3          	add	a5,a5,a2
    80005c8c:	00c4a703          	lw	a4,12(s1)
    80005c90:	00e7a823          	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80005c94:	00048513          	mv	a0,s1
    80005c98:	ffffe097          	auipc	ra,0xffffe
    80005c9c:	6d0080e7          	jalr	1744(ra) # 80004368 <bpin>
    log.lh.n++;
    80005ca0:	0001d717          	auipc	a4,0x1d
    80005ca4:	f2070713          	add	a4,a4,-224 # 80022bc0 <log>
    80005ca8:	02c72783          	lw	a5,44(a4)
    80005cac:	0017879b          	addw	a5,a5,1
    80005cb0:	02f72623          	sw	a5,44(a4)
    80005cb4:	0440006f          	j	80005cf8 <log_write+0x104>
    panic("too big a transaction");
    80005cb8:	00005517          	auipc	a0,0x5
    80005cbc:	a4050513          	add	a0,a0,-1472 # 8000a6f8 <syscalls+0x1f0>
    80005cc0:	ffffb097          	auipc	ra,0xffffb
    80005cc4:	a08080e7          	jalr	-1528(ra) # 800006c8 <panic>
    panic("log_write outside of trans");
    80005cc8:	00005517          	auipc	a0,0x5
    80005ccc:	a4850513          	add	a0,a0,-1464 # 8000a710 <syscalls+0x208>
    80005cd0:	ffffb097          	auipc	ra,0xffffb
    80005cd4:	9f8080e7          	jalr	-1544(ra) # 800006c8 <panic>
  log.lh.block[i] = b->blockno;
    80005cd8:	00878693          	add	a3,a5,8
    80005cdc:	00269693          	sll	a3,a3,0x2
    80005ce0:	0001d717          	auipc	a4,0x1d
    80005ce4:	ee070713          	add	a4,a4,-288 # 80022bc0 <log>
    80005ce8:	00d70733          	add	a4,a4,a3
    80005cec:	00c4a683          	lw	a3,12(s1)
    80005cf0:	00d72823          	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80005cf4:	faf600e3          	beq	a2,a5,80005c94 <log_write+0xa0>
  }
  release(&log.lock);
    80005cf8:	0001d517          	auipc	a0,0x1d
    80005cfc:	ec850513          	add	a0,a0,-312 # 80022bc0 <log>
    80005d00:	ffffb097          	auipc	ra,0xffffb
    80005d04:	3bc080e7          	jalr	956(ra) # 800010bc <release>
}
    80005d08:	01813083          	ld	ra,24(sp)
    80005d0c:	01013403          	ld	s0,16(sp)
    80005d10:	00813483          	ld	s1,8(sp)
    80005d14:	00013903          	ld	s2,0(sp)
    80005d18:	02010113          	add	sp,sp,32
    80005d1c:	00008067          	ret

0000000080005d20 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80005d20:	fe010113          	add	sp,sp,-32
    80005d24:	00113c23          	sd	ra,24(sp)
    80005d28:	00813823          	sd	s0,16(sp)
    80005d2c:	00913423          	sd	s1,8(sp)
    80005d30:	01213023          	sd	s2,0(sp)
    80005d34:	02010413          	add	s0,sp,32
    80005d38:	00050493          	mv	s1,a0
    80005d3c:	00058913          	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80005d40:	00005597          	auipc	a1,0x5
    80005d44:	9f058593          	add	a1,a1,-1552 # 8000a730 <syscalls+0x228>
    80005d48:	00850513          	add	a0,a0,8
    80005d4c:	ffffb097          	auipc	ra,0xffffb
    80005d50:	194080e7          	jalr	404(ra) # 80000ee0 <initlock>
  lk->name = name;
    80005d54:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80005d58:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80005d5c:	0204a423          	sw	zero,40(s1)
}
    80005d60:	01813083          	ld	ra,24(sp)
    80005d64:	01013403          	ld	s0,16(sp)
    80005d68:	00813483          	ld	s1,8(sp)
    80005d6c:	00013903          	ld	s2,0(sp)
    80005d70:	02010113          	add	sp,sp,32
    80005d74:	00008067          	ret

0000000080005d78 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80005d78:	fe010113          	add	sp,sp,-32
    80005d7c:	00113c23          	sd	ra,24(sp)
    80005d80:	00813823          	sd	s0,16(sp)
    80005d84:	00913423          	sd	s1,8(sp)
    80005d88:	01213023          	sd	s2,0(sp)
    80005d8c:	02010413          	add	s0,sp,32
    80005d90:	00050493          	mv	s1,a0
  acquire(&lk->lk);
    80005d94:	00850913          	add	s2,a0,8
    80005d98:	00090513          	mv	a0,s2
    80005d9c:	ffffb097          	auipc	ra,0xffffb
    80005da0:	228080e7          	jalr	552(ra) # 80000fc4 <acquire>
  while (lk->locked) {
    80005da4:	0004a783          	lw	a5,0(s1)
    80005da8:	00078e63          	beqz	a5,80005dc4 <acquiresleep+0x4c>
    sleep(lk, &lk->lk);
    80005dac:	00090593          	mv	a1,s2
    80005db0:	00048513          	mv	a0,s1
    80005db4:	ffffd097          	auipc	ra,0xffffd
    80005db8:	fe8080e7          	jalr	-24(ra) # 80002d9c <sleep>
  while (lk->locked) {
    80005dbc:	0004a783          	lw	a5,0(s1)
    80005dc0:	fe0796e3          	bnez	a5,80005dac <acquiresleep+0x34>
  }
  lk->locked = 1;
    80005dc4:	00100793          	li	a5,1
    80005dc8:	00f4a023          	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80005dcc:	ffffc097          	auipc	ra,0xffffc
    80005dd0:	688080e7          	jalr	1672(ra) # 80002454 <myproc>
    80005dd4:	03052783          	lw	a5,48(a0)
    80005dd8:	02f4a423          	sw	a5,40(s1)
  release(&lk->lk);
    80005ddc:	00090513          	mv	a0,s2
    80005de0:	ffffb097          	auipc	ra,0xffffb
    80005de4:	2dc080e7          	jalr	732(ra) # 800010bc <release>
}
    80005de8:	01813083          	ld	ra,24(sp)
    80005dec:	01013403          	ld	s0,16(sp)
    80005df0:	00813483          	ld	s1,8(sp)
    80005df4:	00013903          	ld	s2,0(sp)
    80005df8:	02010113          	add	sp,sp,32
    80005dfc:	00008067          	ret

0000000080005e00 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80005e00:	fe010113          	add	sp,sp,-32
    80005e04:	00113c23          	sd	ra,24(sp)
    80005e08:	00813823          	sd	s0,16(sp)
    80005e0c:	00913423          	sd	s1,8(sp)
    80005e10:	01213023          	sd	s2,0(sp)
    80005e14:	02010413          	add	s0,sp,32
    80005e18:	00050493          	mv	s1,a0
  acquire(&lk->lk);
    80005e1c:	00850913          	add	s2,a0,8
    80005e20:	00090513          	mv	a0,s2
    80005e24:	ffffb097          	auipc	ra,0xffffb
    80005e28:	1a0080e7          	jalr	416(ra) # 80000fc4 <acquire>
  lk->locked = 0;
    80005e2c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80005e30:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80005e34:	00048513          	mv	a0,s1
    80005e38:	ffffd097          	auipc	ra,0xffffd
    80005e3c:	ff4080e7          	jalr	-12(ra) # 80002e2c <wakeup>
  release(&lk->lk);
    80005e40:	00090513          	mv	a0,s2
    80005e44:	ffffb097          	auipc	ra,0xffffb
    80005e48:	278080e7          	jalr	632(ra) # 800010bc <release>
}
    80005e4c:	01813083          	ld	ra,24(sp)
    80005e50:	01013403          	ld	s0,16(sp)
    80005e54:	00813483          	ld	s1,8(sp)
    80005e58:	00013903          	ld	s2,0(sp)
    80005e5c:	02010113          	add	sp,sp,32
    80005e60:	00008067          	ret

0000000080005e64 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80005e64:	fd010113          	add	sp,sp,-48
    80005e68:	02113423          	sd	ra,40(sp)
    80005e6c:	02813023          	sd	s0,32(sp)
    80005e70:	00913c23          	sd	s1,24(sp)
    80005e74:	01213823          	sd	s2,16(sp)
    80005e78:	01313423          	sd	s3,8(sp)
    80005e7c:	03010413          	add	s0,sp,48
    80005e80:	00050493          	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80005e84:	00850913          	add	s2,a0,8
    80005e88:	00090513          	mv	a0,s2
    80005e8c:	ffffb097          	auipc	ra,0xffffb
    80005e90:	138080e7          	jalr	312(ra) # 80000fc4 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80005e94:	0004a783          	lw	a5,0(s1)
    80005e98:	02079a63          	bnez	a5,80005ecc <holdingsleep+0x68>
    80005e9c:	00000493          	li	s1,0
  release(&lk->lk);
    80005ea0:	00090513          	mv	a0,s2
    80005ea4:	ffffb097          	auipc	ra,0xffffb
    80005ea8:	218080e7          	jalr	536(ra) # 800010bc <release>
  return r;
}
    80005eac:	00048513          	mv	a0,s1
    80005eb0:	02813083          	ld	ra,40(sp)
    80005eb4:	02013403          	ld	s0,32(sp)
    80005eb8:	01813483          	ld	s1,24(sp)
    80005ebc:	01013903          	ld	s2,16(sp)
    80005ec0:	00813983          	ld	s3,8(sp)
    80005ec4:	03010113          	add	sp,sp,48
    80005ec8:	00008067          	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80005ecc:	0284a983          	lw	s3,40(s1)
    80005ed0:	ffffc097          	auipc	ra,0xffffc
    80005ed4:	584080e7          	jalr	1412(ra) # 80002454 <myproc>
    80005ed8:	03052483          	lw	s1,48(a0)
    80005edc:	413484b3          	sub	s1,s1,s3
    80005ee0:	0014b493          	seqz	s1,s1
    80005ee4:	fbdff06f          	j	80005ea0 <holdingsleep+0x3c>

0000000080005ee8 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80005ee8:	ff010113          	add	sp,sp,-16
    80005eec:	00113423          	sd	ra,8(sp)
    80005ef0:	00813023          	sd	s0,0(sp)
    80005ef4:	01010413          	add	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80005ef8:	00005597          	auipc	a1,0x5
    80005efc:	84858593          	add	a1,a1,-1976 # 8000a740 <syscalls+0x238>
    80005f00:	0001d517          	auipc	a0,0x1d
    80005f04:	e0850513          	add	a0,a0,-504 # 80022d08 <ftable>
    80005f08:	ffffb097          	auipc	ra,0xffffb
    80005f0c:	fd8080e7          	jalr	-40(ra) # 80000ee0 <initlock>
}
    80005f10:	00813083          	ld	ra,8(sp)
    80005f14:	00013403          	ld	s0,0(sp)
    80005f18:	01010113          	add	sp,sp,16
    80005f1c:	00008067          	ret

0000000080005f20 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80005f20:	fe010113          	add	sp,sp,-32
    80005f24:	00113c23          	sd	ra,24(sp)
    80005f28:	00813823          	sd	s0,16(sp)
    80005f2c:	00913423          	sd	s1,8(sp)
    80005f30:	02010413          	add	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80005f34:	0001d517          	auipc	a0,0x1d
    80005f38:	dd450513          	add	a0,a0,-556 # 80022d08 <ftable>
    80005f3c:	ffffb097          	auipc	ra,0xffffb
    80005f40:	088080e7          	jalr	136(ra) # 80000fc4 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80005f44:	0001d497          	auipc	s1,0x1d
    80005f48:	ddc48493          	add	s1,s1,-548 # 80022d20 <ftable+0x18>
    80005f4c:	0001e717          	auipc	a4,0x1e
    80005f50:	d7470713          	add	a4,a4,-652 # 80023cc0 <disk>
    if(f->ref == 0){
    80005f54:	0044a783          	lw	a5,4(s1)
    80005f58:	02078263          	beqz	a5,80005f7c <filealloc+0x5c>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80005f5c:	02848493          	add	s1,s1,40
    80005f60:	fee49ae3          	bne	s1,a4,80005f54 <filealloc+0x34>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80005f64:	0001d517          	auipc	a0,0x1d
    80005f68:	da450513          	add	a0,a0,-604 # 80022d08 <ftable>
    80005f6c:	ffffb097          	auipc	ra,0xffffb
    80005f70:	150080e7          	jalr	336(ra) # 800010bc <release>
  return 0;
    80005f74:	00000493          	li	s1,0
    80005f78:	01c0006f          	j	80005f94 <filealloc+0x74>
      f->ref = 1;
    80005f7c:	00100793          	li	a5,1
    80005f80:	00f4a223          	sw	a5,4(s1)
      release(&ftable.lock);
    80005f84:	0001d517          	auipc	a0,0x1d
    80005f88:	d8450513          	add	a0,a0,-636 # 80022d08 <ftable>
    80005f8c:	ffffb097          	auipc	ra,0xffffb
    80005f90:	130080e7          	jalr	304(ra) # 800010bc <release>
}
    80005f94:	00048513          	mv	a0,s1
    80005f98:	01813083          	ld	ra,24(sp)
    80005f9c:	01013403          	ld	s0,16(sp)
    80005fa0:	00813483          	ld	s1,8(sp)
    80005fa4:	02010113          	add	sp,sp,32
    80005fa8:	00008067          	ret

0000000080005fac <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80005fac:	fe010113          	add	sp,sp,-32
    80005fb0:	00113c23          	sd	ra,24(sp)
    80005fb4:	00813823          	sd	s0,16(sp)
    80005fb8:	00913423          	sd	s1,8(sp)
    80005fbc:	02010413          	add	s0,sp,32
    80005fc0:	00050493          	mv	s1,a0
  acquire(&ftable.lock);
    80005fc4:	0001d517          	auipc	a0,0x1d
    80005fc8:	d4450513          	add	a0,a0,-700 # 80022d08 <ftable>
    80005fcc:	ffffb097          	auipc	ra,0xffffb
    80005fd0:	ff8080e7          	jalr	-8(ra) # 80000fc4 <acquire>
  if(f->ref < 1)
    80005fd4:	0044a783          	lw	a5,4(s1)
    80005fd8:	02f05a63          	blez	a5,8000600c <filedup+0x60>
    panic("filedup");
  f->ref++;
    80005fdc:	0017879b          	addw	a5,a5,1
    80005fe0:	00f4a223          	sw	a5,4(s1)
  release(&ftable.lock);
    80005fe4:	0001d517          	auipc	a0,0x1d
    80005fe8:	d2450513          	add	a0,a0,-732 # 80022d08 <ftable>
    80005fec:	ffffb097          	auipc	ra,0xffffb
    80005ff0:	0d0080e7          	jalr	208(ra) # 800010bc <release>
  return f;
}
    80005ff4:	00048513          	mv	a0,s1
    80005ff8:	01813083          	ld	ra,24(sp)
    80005ffc:	01013403          	ld	s0,16(sp)
    80006000:	00813483          	ld	s1,8(sp)
    80006004:	02010113          	add	sp,sp,32
    80006008:	00008067          	ret
    panic("filedup");
    8000600c:	00004517          	auipc	a0,0x4
    80006010:	73c50513          	add	a0,a0,1852 # 8000a748 <syscalls+0x240>
    80006014:	ffffa097          	auipc	ra,0xffffa
    80006018:	6b4080e7          	jalr	1716(ra) # 800006c8 <panic>

000000008000601c <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    8000601c:	fc010113          	add	sp,sp,-64
    80006020:	02113c23          	sd	ra,56(sp)
    80006024:	02813823          	sd	s0,48(sp)
    80006028:	02913423          	sd	s1,40(sp)
    8000602c:	03213023          	sd	s2,32(sp)
    80006030:	01313c23          	sd	s3,24(sp)
    80006034:	01413823          	sd	s4,16(sp)
    80006038:	01513423          	sd	s5,8(sp)
    8000603c:	04010413          	add	s0,sp,64
    80006040:	00050493          	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80006044:	0001d517          	auipc	a0,0x1d
    80006048:	cc450513          	add	a0,a0,-828 # 80022d08 <ftable>
    8000604c:	ffffb097          	auipc	ra,0xffffb
    80006050:	f78080e7          	jalr	-136(ra) # 80000fc4 <acquire>
  if(f->ref < 1)
    80006054:	0044a783          	lw	a5,4(s1)
    80006058:	06f05863          	blez	a5,800060c8 <fileclose+0xac>
    panic("fileclose");
  if(--f->ref > 0){
    8000605c:	fff7879b          	addw	a5,a5,-1
    80006060:	0007871b          	sext.w	a4,a5
    80006064:	00f4a223          	sw	a5,4(s1)
    80006068:	06e04863          	bgtz	a4,800060d8 <fileclose+0xbc>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    8000606c:	0004a903          	lw	s2,0(s1)
    80006070:	0094ca83          	lbu	s5,9(s1)
    80006074:	0104ba03          	ld	s4,16(s1)
    80006078:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    8000607c:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80006080:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80006084:	0001d517          	auipc	a0,0x1d
    80006088:	c8450513          	add	a0,a0,-892 # 80022d08 <ftable>
    8000608c:	ffffb097          	auipc	ra,0xffffb
    80006090:	030080e7          	jalr	48(ra) # 800010bc <release>

  if(ff.type == FD_PIPE){
    80006094:	00100793          	li	a5,1
    80006098:	06f90a63          	beq	s2,a5,8000610c <fileclose+0xf0>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    8000609c:	ffe9091b          	addw	s2,s2,-2
    800060a0:	00100793          	li	a5,1
    800060a4:	0527e263          	bltu	a5,s2,800060e8 <fileclose+0xcc>
    begin_op();
    800060a8:	00000097          	auipc	ra,0x0
    800060ac:	8ec080e7          	jalr	-1812(ra) # 80005994 <begin_op>
    iput(ff.ip);
    800060b0:	00098513          	mv	a0,s3
    800060b4:	fffff097          	auipc	ra,0xfffff
    800060b8:	d88080e7          	jalr	-632(ra) # 80004e3c <iput>
    end_op();
    800060bc:	00000097          	auipc	ra,0x0
    800060c0:	988080e7          	jalr	-1656(ra) # 80005a44 <end_op>
    800060c4:	0240006f          	j	800060e8 <fileclose+0xcc>
    panic("fileclose");
    800060c8:	00004517          	auipc	a0,0x4
    800060cc:	68850513          	add	a0,a0,1672 # 8000a750 <syscalls+0x248>
    800060d0:	ffffa097          	auipc	ra,0xffffa
    800060d4:	5f8080e7          	jalr	1528(ra) # 800006c8 <panic>
    release(&ftable.lock);
    800060d8:	0001d517          	auipc	a0,0x1d
    800060dc:	c3050513          	add	a0,a0,-976 # 80022d08 <ftable>
    800060e0:	ffffb097          	auipc	ra,0xffffb
    800060e4:	fdc080e7          	jalr	-36(ra) # 800010bc <release>
  }
}
    800060e8:	03813083          	ld	ra,56(sp)
    800060ec:	03013403          	ld	s0,48(sp)
    800060f0:	02813483          	ld	s1,40(sp)
    800060f4:	02013903          	ld	s2,32(sp)
    800060f8:	01813983          	ld	s3,24(sp)
    800060fc:	01013a03          	ld	s4,16(sp)
    80006100:	00813a83          	ld	s5,8(sp)
    80006104:	04010113          	add	sp,sp,64
    80006108:	00008067          	ret
    pipeclose(ff.pipe, ff.writable);
    8000610c:	000a8593          	mv	a1,s5
    80006110:	000a0513          	mv	a0,s4
    80006114:	00000097          	auipc	ra,0x0
    80006118:	4b8080e7          	jalr	1208(ra) # 800065cc <pipeclose>
    8000611c:	fcdff06f          	j	800060e8 <fileclose+0xcc>

0000000080006120 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80006120:	fb010113          	add	sp,sp,-80
    80006124:	04113423          	sd	ra,72(sp)
    80006128:	04813023          	sd	s0,64(sp)
    8000612c:	02913c23          	sd	s1,56(sp)
    80006130:	03213823          	sd	s2,48(sp)
    80006134:	03313423          	sd	s3,40(sp)
    80006138:	05010413          	add	s0,sp,80
    8000613c:	00050493          	mv	s1,a0
    80006140:	00058993          	mv	s3,a1
  struct proc *p = myproc();
    80006144:	ffffc097          	auipc	ra,0xffffc
    80006148:	310080e7          	jalr	784(ra) # 80002454 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    8000614c:	0004a783          	lw	a5,0(s1)
    80006150:	ffe7879b          	addw	a5,a5,-2
    80006154:	00100713          	li	a4,1
    80006158:	06f76463          	bltu	a4,a5,800061c0 <filestat+0xa0>
    8000615c:	00050913          	mv	s2,a0
    ilock(f->ip);
    80006160:	0184b503          	ld	a0,24(s1)
    80006164:	fffff097          	auipc	ra,0xfffff
    80006168:	a78080e7          	jalr	-1416(ra) # 80004bdc <ilock>
    stati(f->ip, &st);
    8000616c:	fb840593          	add	a1,s0,-72
    80006170:	0184b503          	ld	a0,24(s1)
    80006174:	fffff097          	auipc	ra,0xfffff
    80006178:	de4080e7          	jalr	-540(ra) # 80004f58 <stati>
    iunlock(f->ip);
    8000617c:	0184b503          	ld	a0,24(s1)
    80006180:	fffff097          	auipc	ra,0xfffff
    80006184:	b60080e7          	jalr	-1184(ra) # 80004ce0 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80006188:	01800693          	li	a3,24
    8000618c:	fb840613          	add	a2,s0,-72
    80006190:	00098593          	mv	a1,s3
    80006194:	05093503          	ld	a0,80(s2)
    80006198:	ffffc097          	auipc	ra,0xffffc
    8000619c:	db8080e7          	jalr	-584(ra) # 80001f50 <copyout>
    800061a0:	41f5551b          	sraw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    800061a4:	04813083          	ld	ra,72(sp)
    800061a8:	04013403          	ld	s0,64(sp)
    800061ac:	03813483          	ld	s1,56(sp)
    800061b0:	03013903          	ld	s2,48(sp)
    800061b4:	02813983          	ld	s3,40(sp)
    800061b8:	05010113          	add	sp,sp,80
    800061bc:	00008067          	ret
  return -1;
    800061c0:	fff00513          	li	a0,-1
    800061c4:	fe1ff06f          	j	800061a4 <filestat+0x84>

00000000800061c8 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800061c8:	fd010113          	add	sp,sp,-48
    800061cc:	02113423          	sd	ra,40(sp)
    800061d0:	02813023          	sd	s0,32(sp)
    800061d4:	00913c23          	sd	s1,24(sp)
    800061d8:	01213823          	sd	s2,16(sp)
    800061dc:	01313423          	sd	s3,8(sp)
    800061e0:	03010413          	add	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800061e4:	00854783          	lbu	a5,8(a0)
    800061e8:	0e078a63          	beqz	a5,800062dc <fileread+0x114>
    800061ec:	00050493          	mv	s1,a0
    800061f0:	00058993          	mv	s3,a1
    800061f4:	00060913          	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800061f8:	00052783          	lw	a5,0(a0)
    800061fc:	00100713          	li	a4,1
    80006200:	06e78e63          	beq	a5,a4,8000627c <fileread+0xb4>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80006204:	00300713          	li	a4,3
    80006208:	08e78463          	beq	a5,a4,80006290 <fileread+0xc8>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    8000620c:	00200713          	li	a4,2
    80006210:	0ae79e63          	bne	a5,a4,800062cc <fileread+0x104>
    ilock(f->ip);
    80006214:	01853503          	ld	a0,24(a0)
    80006218:	fffff097          	auipc	ra,0xfffff
    8000621c:	9c4080e7          	jalr	-1596(ra) # 80004bdc <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80006220:	00090713          	mv	a4,s2
    80006224:	0204a683          	lw	a3,32(s1)
    80006228:	00098613          	mv	a2,s3
    8000622c:	00100593          	li	a1,1
    80006230:	0184b503          	ld	a0,24(s1)
    80006234:	fffff097          	auipc	ra,0xfffff
    80006238:	d64080e7          	jalr	-668(ra) # 80004f98 <readi>
    8000623c:	00050913          	mv	s2,a0
    80006240:	00a05863          	blez	a0,80006250 <fileread+0x88>
      f->off += r;
    80006244:	0204a783          	lw	a5,32(s1)
    80006248:	00a787bb          	addw	a5,a5,a0
    8000624c:	02f4a023          	sw	a5,32(s1)
    iunlock(f->ip);
    80006250:	0184b503          	ld	a0,24(s1)
    80006254:	fffff097          	auipc	ra,0xfffff
    80006258:	a8c080e7          	jalr	-1396(ra) # 80004ce0 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    8000625c:	00090513          	mv	a0,s2
    80006260:	02813083          	ld	ra,40(sp)
    80006264:	02013403          	ld	s0,32(sp)
    80006268:	01813483          	ld	s1,24(sp)
    8000626c:	01013903          	ld	s2,16(sp)
    80006270:	00813983          	ld	s3,8(sp)
    80006274:	03010113          	add	sp,sp,48
    80006278:	00008067          	ret
    r = piperead(f->pipe, addr, n);
    8000627c:	01053503          	ld	a0,16(a0)
    80006280:	00000097          	auipc	ra,0x0
    80006284:	53c080e7          	jalr	1340(ra) # 800067bc <piperead>
    80006288:	00050913          	mv	s2,a0
    8000628c:	fd1ff06f          	j	8000625c <fileread+0x94>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80006290:	02451783          	lh	a5,36(a0)
    80006294:	03079693          	sll	a3,a5,0x30
    80006298:	0306d693          	srl	a3,a3,0x30
    8000629c:	00900713          	li	a4,9
    800062a0:	04d76263          	bltu	a4,a3,800062e4 <fileread+0x11c>
    800062a4:	00479793          	sll	a5,a5,0x4
    800062a8:	0001d717          	auipc	a4,0x1d
    800062ac:	9c070713          	add	a4,a4,-1600 # 80022c68 <devsw>
    800062b0:	00f707b3          	add	a5,a4,a5
    800062b4:	0007b783          	ld	a5,0(a5)
    800062b8:	02078a63          	beqz	a5,800062ec <fileread+0x124>
    r = devsw[f->major].read(1, addr, n);
    800062bc:	00100513          	li	a0,1
    800062c0:	000780e7          	jalr	a5
    800062c4:	00050913          	mv	s2,a0
    800062c8:	f95ff06f          	j	8000625c <fileread+0x94>
    panic("fileread");
    800062cc:	00004517          	auipc	a0,0x4
    800062d0:	49450513          	add	a0,a0,1172 # 8000a760 <syscalls+0x258>
    800062d4:	ffffa097          	auipc	ra,0xffffa
    800062d8:	3f4080e7          	jalr	1012(ra) # 800006c8 <panic>
    return -1;
    800062dc:	fff00913          	li	s2,-1
    800062e0:	f7dff06f          	j	8000625c <fileread+0x94>
      return -1;
    800062e4:	fff00913          	li	s2,-1
    800062e8:	f75ff06f          	j	8000625c <fileread+0x94>
    800062ec:	fff00913          	li	s2,-1
    800062f0:	f6dff06f          	j	8000625c <fileread+0x94>

00000000800062f4 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    800062f4:	00954783          	lbu	a5,9(a0)
    800062f8:	18078463          	beqz	a5,80006480 <filewrite+0x18c>
{
    800062fc:	fb010113          	add	sp,sp,-80
    80006300:	04113423          	sd	ra,72(sp)
    80006304:	04813023          	sd	s0,64(sp)
    80006308:	02913c23          	sd	s1,56(sp)
    8000630c:	03213823          	sd	s2,48(sp)
    80006310:	03313423          	sd	s3,40(sp)
    80006314:	03413023          	sd	s4,32(sp)
    80006318:	01513c23          	sd	s5,24(sp)
    8000631c:	01613823          	sd	s6,16(sp)
    80006320:	01713423          	sd	s7,8(sp)
    80006324:	01813023          	sd	s8,0(sp)
    80006328:	05010413          	add	s0,sp,80
    8000632c:	00050913          	mv	s2,a0
    80006330:	00058b13          	mv	s6,a1
    80006334:	00060a13          	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80006338:	00052783          	lw	a5,0(a0)
    8000633c:	00100713          	li	a4,1
    80006340:	02e78863          	beq	a5,a4,80006370 <filewrite+0x7c>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80006344:	00300713          	li	a4,3
    80006348:	02e78c63          	beq	a5,a4,80006380 <filewrite+0x8c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    8000634c:	00200713          	li	a4,2
    80006350:	12e79063          	bne	a5,a4,80006470 <filewrite+0x17c>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80006354:	0ec05063          	blez	a2,80006434 <filewrite+0x140>
    int i = 0;
    80006358:	00000993          	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    8000635c:	00001bb7          	lui	s7,0x1
    80006360:	c00b8b93          	add	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80006364:	00001c37          	lui	s8,0x1
    80006368:	c00c0c1b          	addw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    8000636c:	0b40006f          	j	80006420 <filewrite+0x12c>
    ret = pipewrite(f->pipe, addr, n);
    80006370:	01053503          	ld	a0,16(a0)
    80006374:	00000097          	auipc	ra,0x0
    80006378:	2f0080e7          	jalr	752(ra) # 80006664 <pipewrite>
    8000637c:	0c40006f          	j	80006440 <filewrite+0x14c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80006380:	02451783          	lh	a5,36(a0)
    80006384:	03079693          	sll	a3,a5,0x30
    80006388:	0306d693          	srl	a3,a3,0x30
    8000638c:	00900713          	li	a4,9
    80006390:	0ed76c63          	bltu	a4,a3,80006488 <filewrite+0x194>
    80006394:	00479793          	sll	a5,a5,0x4
    80006398:	0001d717          	auipc	a4,0x1d
    8000639c:	8d070713          	add	a4,a4,-1840 # 80022c68 <devsw>
    800063a0:	00f707b3          	add	a5,a4,a5
    800063a4:	0087b783          	ld	a5,8(a5)
    800063a8:	0e078463          	beqz	a5,80006490 <filewrite+0x19c>
    ret = devsw[f->major].write(1, addr, n);
    800063ac:	00100513          	li	a0,1
    800063b0:	000780e7          	jalr	a5
    800063b4:	08c0006f          	j	80006440 <filewrite+0x14c>
      if(n1 > max)
    800063b8:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    800063bc:	fffff097          	auipc	ra,0xfffff
    800063c0:	5d8080e7          	jalr	1496(ra) # 80005994 <begin_op>
      ilock(f->ip);
    800063c4:	01893503          	ld	a0,24(s2)
    800063c8:	fffff097          	auipc	ra,0xfffff
    800063cc:	814080e7          	jalr	-2028(ra) # 80004bdc <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800063d0:	000a8713          	mv	a4,s5
    800063d4:	02092683          	lw	a3,32(s2)
    800063d8:	01698633          	add	a2,s3,s6
    800063dc:	00100593          	li	a1,1
    800063e0:	01893503          	ld	a0,24(s2)
    800063e4:	fffff097          	auipc	ra,0xfffff
    800063e8:	d24080e7          	jalr	-732(ra) # 80005108 <writei>
    800063ec:	00050493          	mv	s1,a0
    800063f0:	00a05863          	blez	a0,80006400 <filewrite+0x10c>
        f->off += r;
    800063f4:	02092783          	lw	a5,32(s2)
    800063f8:	00a787bb          	addw	a5,a5,a0
    800063fc:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80006400:	01893503          	ld	a0,24(s2)
    80006404:	fffff097          	auipc	ra,0xfffff
    80006408:	8dc080e7          	jalr	-1828(ra) # 80004ce0 <iunlock>
      end_op();
    8000640c:	fffff097          	auipc	ra,0xfffff
    80006410:	638080e7          	jalr	1592(ra) # 80005a44 <end_op>

      if(r != n1){
    80006414:	029a9263          	bne	s5,s1,80006438 <filewrite+0x144>
        // error from writei
        break;
      }
      i += r;
    80006418:	013489bb          	addw	s3,s1,s3
    while(i < n){
    8000641c:	0149de63          	bge	s3,s4,80006438 <filewrite+0x144>
      int n1 = n - i;
    80006420:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80006424:	0004879b          	sext.w	a5,s1
    80006428:	f8fbd8e3          	bge	s7,a5,800063b8 <filewrite+0xc4>
    8000642c:	000c0493          	mv	s1,s8
    80006430:	f89ff06f          	j	800063b8 <filewrite+0xc4>
    int i = 0;
    80006434:	00000993          	li	s3,0
    }
    ret = (i == n ? n : -1);
    80006438:	073a1063          	bne	s4,s3,80006498 <filewrite+0x1a4>
    8000643c:	000a0513          	mv	a0,s4
  } else {
    panic("filewrite");
  }

  return ret;
}
    80006440:	04813083          	ld	ra,72(sp)
    80006444:	04013403          	ld	s0,64(sp)
    80006448:	03813483          	ld	s1,56(sp)
    8000644c:	03013903          	ld	s2,48(sp)
    80006450:	02813983          	ld	s3,40(sp)
    80006454:	02013a03          	ld	s4,32(sp)
    80006458:	01813a83          	ld	s5,24(sp)
    8000645c:	01013b03          	ld	s6,16(sp)
    80006460:	00813b83          	ld	s7,8(sp)
    80006464:	00013c03          	ld	s8,0(sp)
    80006468:	05010113          	add	sp,sp,80
    8000646c:	00008067          	ret
    panic("filewrite");
    80006470:	00004517          	auipc	a0,0x4
    80006474:	30050513          	add	a0,a0,768 # 8000a770 <syscalls+0x268>
    80006478:	ffffa097          	auipc	ra,0xffffa
    8000647c:	250080e7          	jalr	592(ra) # 800006c8 <panic>
    return -1;
    80006480:	fff00513          	li	a0,-1
}
    80006484:	00008067          	ret
      return -1;
    80006488:	fff00513          	li	a0,-1
    8000648c:	fb5ff06f          	j	80006440 <filewrite+0x14c>
    80006490:	fff00513          	li	a0,-1
    80006494:	fadff06f          	j	80006440 <filewrite+0x14c>
    ret = (i == n ? n : -1);
    80006498:	fff00513          	li	a0,-1
    8000649c:	fa5ff06f          	j	80006440 <filewrite+0x14c>

00000000800064a0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800064a0:	fd010113          	add	sp,sp,-48
    800064a4:	02113423          	sd	ra,40(sp)
    800064a8:	02813023          	sd	s0,32(sp)
    800064ac:	00913c23          	sd	s1,24(sp)
    800064b0:	01213823          	sd	s2,16(sp)
    800064b4:	01313423          	sd	s3,8(sp)
    800064b8:	01413023          	sd	s4,0(sp)
    800064bc:	03010413          	add	s0,sp,48
    800064c0:	00050493          	mv	s1,a0
    800064c4:	00058a13          	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800064c8:	0005b023          	sd	zero,0(a1)
    800064cc:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800064d0:	00000097          	auipc	ra,0x0
    800064d4:	a50080e7          	jalr	-1456(ra) # 80005f20 <filealloc>
    800064d8:	00a4b023          	sd	a0,0(s1)
    800064dc:	0a050663          	beqz	a0,80006588 <pipealloc+0xe8>
    800064e0:	00000097          	auipc	ra,0x0
    800064e4:	a40080e7          	jalr	-1472(ra) # 80005f20 <filealloc>
    800064e8:	00aa3023          	sd	a0,0(s4)
    800064ec:	08050663          	beqz	a0,80006578 <pipealloc+0xd8>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800064f0:	ffffb097          	auipc	ra,0xffffb
    800064f4:	968080e7          	jalr	-1688(ra) # 80000e58 <kalloc>
    800064f8:	00050913          	mv	s2,a0
    800064fc:	06050863          	beqz	a0,8000656c <pipealloc+0xcc>
    goto bad;
  pi->readopen = 1;
    80006500:	00100993          	li	s3,1
    80006504:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80006508:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    8000650c:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80006510:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80006514:	00004597          	auipc	a1,0x4
    80006518:	26c58593          	add	a1,a1,620 # 8000a780 <syscalls+0x278>
    8000651c:	ffffb097          	auipc	ra,0xffffb
    80006520:	9c4080e7          	jalr	-1596(ra) # 80000ee0 <initlock>
  (*f0)->type = FD_PIPE;
    80006524:	0004b783          	ld	a5,0(s1)
    80006528:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    8000652c:	0004b783          	ld	a5,0(s1)
    80006530:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80006534:	0004b783          	ld	a5,0(s1)
    80006538:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    8000653c:	0004b783          	ld	a5,0(s1)
    80006540:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80006544:	000a3783          	ld	a5,0(s4)
    80006548:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    8000654c:	000a3783          	ld	a5,0(s4)
    80006550:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80006554:	000a3783          	ld	a5,0(s4)
    80006558:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    8000655c:	000a3783          	ld	a5,0(s4)
    80006560:	0127b823          	sd	s2,16(a5)
  return 0;
    80006564:	00000513          	li	a0,0
    80006568:	03c0006f          	j	800065a4 <pipealloc+0x104>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    8000656c:	0004b503          	ld	a0,0(s1)
    80006570:	00051863          	bnez	a0,80006580 <pipealloc+0xe0>
    80006574:	0140006f          	j	80006588 <pipealloc+0xe8>
    80006578:	0004b503          	ld	a0,0(s1)
    8000657c:	04050463          	beqz	a0,800065c4 <pipealloc+0x124>
    fileclose(*f0);
    80006580:	00000097          	auipc	ra,0x0
    80006584:	a9c080e7          	jalr	-1380(ra) # 8000601c <fileclose>
  if(*f1)
    80006588:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    8000658c:	fff00513          	li	a0,-1
  if(*f1)
    80006590:	00078a63          	beqz	a5,800065a4 <pipealloc+0x104>
    fileclose(*f1);
    80006594:	00078513          	mv	a0,a5
    80006598:	00000097          	auipc	ra,0x0
    8000659c:	a84080e7          	jalr	-1404(ra) # 8000601c <fileclose>
  return -1;
    800065a0:	fff00513          	li	a0,-1
}
    800065a4:	02813083          	ld	ra,40(sp)
    800065a8:	02013403          	ld	s0,32(sp)
    800065ac:	01813483          	ld	s1,24(sp)
    800065b0:	01013903          	ld	s2,16(sp)
    800065b4:	00813983          	ld	s3,8(sp)
    800065b8:	00013a03          	ld	s4,0(sp)
    800065bc:	03010113          	add	sp,sp,48
    800065c0:	00008067          	ret
  return -1;
    800065c4:	fff00513          	li	a0,-1
    800065c8:	fddff06f          	j	800065a4 <pipealloc+0x104>

00000000800065cc <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800065cc:	fe010113          	add	sp,sp,-32
    800065d0:	00113c23          	sd	ra,24(sp)
    800065d4:	00813823          	sd	s0,16(sp)
    800065d8:	00913423          	sd	s1,8(sp)
    800065dc:	01213023          	sd	s2,0(sp)
    800065e0:	02010413          	add	s0,sp,32
    800065e4:	00050493          	mv	s1,a0
    800065e8:	00058913          	mv	s2,a1
  acquire(&pi->lock);
    800065ec:	ffffb097          	auipc	ra,0xffffb
    800065f0:	9d8080e7          	jalr	-1576(ra) # 80000fc4 <acquire>
  if(writable){
    800065f4:	04090663          	beqz	s2,80006640 <pipeclose+0x74>
    pi->writeopen = 0;
    800065f8:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800065fc:	21848513          	add	a0,s1,536
    80006600:	ffffd097          	auipc	ra,0xffffd
    80006604:	82c080e7          	jalr	-2004(ra) # 80002e2c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80006608:	2204b783          	ld	a5,544(s1)
    8000660c:	04079463          	bnez	a5,80006654 <pipeclose+0x88>
    release(&pi->lock);
    80006610:	00048513          	mv	a0,s1
    80006614:	ffffb097          	auipc	ra,0xffffb
    80006618:	aa8080e7          	jalr	-1368(ra) # 800010bc <release>
    kfree((char*)pi);
    8000661c:	00048513          	mv	a0,s1
    80006620:	ffffa097          	auipc	ra,0xffffa
    80006624:	6cc080e7          	jalr	1740(ra) # 80000cec <kfree>
  } else
    release(&pi->lock);
}
    80006628:	01813083          	ld	ra,24(sp)
    8000662c:	01013403          	ld	s0,16(sp)
    80006630:	00813483          	ld	s1,8(sp)
    80006634:	00013903          	ld	s2,0(sp)
    80006638:	02010113          	add	sp,sp,32
    8000663c:	00008067          	ret
    pi->readopen = 0;
    80006640:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80006644:	21c48513          	add	a0,s1,540
    80006648:	ffffc097          	auipc	ra,0xffffc
    8000664c:	7e4080e7          	jalr	2020(ra) # 80002e2c <wakeup>
    80006650:	fb9ff06f          	j	80006608 <pipeclose+0x3c>
    release(&pi->lock);
    80006654:	00048513          	mv	a0,s1
    80006658:	ffffb097          	auipc	ra,0xffffb
    8000665c:	a64080e7          	jalr	-1436(ra) # 800010bc <release>
}
    80006660:	fc9ff06f          	j	80006628 <pipeclose+0x5c>

0000000080006664 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80006664:	fa010113          	add	sp,sp,-96
    80006668:	04113c23          	sd	ra,88(sp)
    8000666c:	04813823          	sd	s0,80(sp)
    80006670:	04913423          	sd	s1,72(sp)
    80006674:	05213023          	sd	s2,64(sp)
    80006678:	03313c23          	sd	s3,56(sp)
    8000667c:	03413823          	sd	s4,48(sp)
    80006680:	03513423          	sd	s5,40(sp)
    80006684:	03613023          	sd	s6,32(sp)
    80006688:	01713c23          	sd	s7,24(sp)
    8000668c:	01813823          	sd	s8,16(sp)
    80006690:	06010413          	add	s0,sp,96
    80006694:	00050493          	mv	s1,a0
    80006698:	00058a93          	mv	s5,a1
    8000669c:	00060a13          	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800066a0:	ffffc097          	auipc	ra,0xffffc
    800066a4:	db4080e7          	jalr	-588(ra) # 80002454 <myproc>
    800066a8:	00050993          	mv	s3,a0

  acquire(&pi->lock);
    800066ac:	00048513          	mv	a0,s1
    800066b0:	ffffb097          	auipc	ra,0xffffb
    800066b4:	914080e7          	jalr	-1772(ra) # 80000fc4 <acquire>
  while(i < n){
    800066b8:	0f405263          	blez	s4,8000679c <pipewrite+0x138>
  int i = 0;
    800066bc:	00000913          	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800066c0:	fff00b13          	li	s6,-1
      wakeup(&pi->nread);
    800066c4:	21848c13          	add	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800066c8:	21c48b93          	add	s7,s1,540
    800066cc:	0680006f          	j	80006734 <pipewrite+0xd0>
      release(&pi->lock);
    800066d0:	00048513          	mv	a0,s1
    800066d4:	ffffb097          	auipc	ra,0xffffb
    800066d8:	9e8080e7          	jalr	-1560(ra) # 800010bc <release>
      return -1;
    800066dc:	fff00913          	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800066e0:	00090513          	mv	a0,s2
    800066e4:	05813083          	ld	ra,88(sp)
    800066e8:	05013403          	ld	s0,80(sp)
    800066ec:	04813483          	ld	s1,72(sp)
    800066f0:	04013903          	ld	s2,64(sp)
    800066f4:	03813983          	ld	s3,56(sp)
    800066f8:	03013a03          	ld	s4,48(sp)
    800066fc:	02813a83          	ld	s5,40(sp)
    80006700:	02013b03          	ld	s6,32(sp)
    80006704:	01813b83          	ld	s7,24(sp)
    80006708:	01013c03          	ld	s8,16(sp)
    8000670c:	06010113          	add	sp,sp,96
    80006710:	00008067          	ret
      wakeup(&pi->nread);
    80006714:	000c0513          	mv	a0,s8
    80006718:	ffffc097          	auipc	ra,0xffffc
    8000671c:	714080e7          	jalr	1812(ra) # 80002e2c <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80006720:	00048593          	mv	a1,s1
    80006724:	000b8513          	mv	a0,s7
    80006728:	ffffc097          	auipc	ra,0xffffc
    8000672c:	674080e7          	jalr	1652(ra) # 80002d9c <sleep>
  while(i < n){
    80006730:	07495863          	bge	s2,s4,800067a0 <pipewrite+0x13c>
    if(pi->readopen == 0 || killed(pr)){
    80006734:	2204a783          	lw	a5,544(s1)
    80006738:	f8078ce3          	beqz	a5,800066d0 <pipewrite+0x6c>
    8000673c:	00098513          	mv	a0,s3
    80006740:	ffffd097          	auipc	ra,0xffffd
    80006744:	a0c080e7          	jalr	-1524(ra) # 8000314c <killed>
    80006748:	f80514e3          	bnez	a0,800066d0 <pipewrite+0x6c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000674c:	2184a783          	lw	a5,536(s1)
    80006750:	21c4a703          	lw	a4,540(s1)
    80006754:	2007879b          	addw	a5,a5,512
    80006758:	faf70ee3          	beq	a4,a5,80006714 <pipewrite+0xb0>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000675c:	00100693          	li	a3,1
    80006760:	01590633          	add	a2,s2,s5
    80006764:	faf40593          	add	a1,s0,-81
    80006768:	0509b503          	ld	a0,80(s3)
    8000676c:	ffffc097          	auipc	ra,0xffffc
    80006770:	8cc080e7          	jalr	-1844(ra) # 80002038 <copyin>
    80006774:	03650663          	beq	a0,s6,800067a0 <pipewrite+0x13c>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80006778:	21c4a783          	lw	a5,540(s1)
    8000677c:	0017871b          	addw	a4,a5,1
    80006780:	20e4ae23          	sw	a4,540(s1)
    80006784:	1ff7f793          	and	a5,a5,511
    80006788:	00f487b3          	add	a5,s1,a5
    8000678c:	faf44703          	lbu	a4,-81(s0)
    80006790:	00e78c23          	sb	a4,24(a5)
      i++;
    80006794:	0019091b          	addw	s2,s2,1
    80006798:	f99ff06f          	j	80006730 <pipewrite+0xcc>
  int i = 0;
    8000679c:	00000913          	li	s2,0
  wakeup(&pi->nread);
    800067a0:	21848513          	add	a0,s1,536
    800067a4:	ffffc097          	auipc	ra,0xffffc
    800067a8:	688080e7          	jalr	1672(ra) # 80002e2c <wakeup>
  release(&pi->lock);
    800067ac:	00048513          	mv	a0,s1
    800067b0:	ffffb097          	auipc	ra,0xffffb
    800067b4:	90c080e7          	jalr	-1780(ra) # 800010bc <release>
  return i;
    800067b8:	f29ff06f          	j	800066e0 <pipewrite+0x7c>

00000000800067bc <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800067bc:	fb010113          	add	sp,sp,-80
    800067c0:	04113423          	sd	ra,72(sp)
    800067c4:	04813023          	sd	s0,64(sp)
    800067c8:	02913c23          	sd	s1,56(sp)
    800067cc:	03213823          	sd	s2,48(sp)
    800067d0:	03313423          	sd	s3,40(sp)
    800067d4:	03413023          	sd	s4,32(sp)
    800067d8:	01513c23          	sd	s5,24(sp)
    800067dc:	01613823          	sd	s6,16(sp)
    800067e0:	05010413          	add	s0,sp,80
    800067e4:	00050493          	mv	s1,a0
    800067e8:	00058913          	mv	s2,a1
    800067ec:	00060a93          	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800067f0:	ffffc097          	auipc	ra,0xffffc
    800067f4:	c64080e7          	jalr	-924(ra) # 80002454 <myproc>
    800067f8:	00050a13          	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800067fc:	00048513          	mv	a0,s1
    80006800:	ffffa097          	auipc	ra,0xffffa
    80006804:	7c4080e7          	jalr	1988(ra) # 80000fc4 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80006808:	2184a703          	lw	a4,536(s1)
    8000680c:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80006810:	21848993          	add	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80006814:	02f71c63          	bne	a4,a5,8000684c <piperead+0x90>
    80006818:	2244a783          	lw	a5,548(s1)
    8000681c:	02078863          	beqz	a5,8000684c <piperead+0x90>
    if(killed(pr)){
    80006820:	000a0513          	mv	a0,s4
    80006824:	ffffd097          	auipc	ra,0xffffd
    80006828:	928080e7          	jalr	-1752(ra) # 8000314c <killed>
    8000682c:	0c051063          	bnez	a0,800068ec <piperead+0x130>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80006830:	00048593          	mv	a1,s1
    80006834:	00098513          	mv	a0,s3
    80006838:	ffffc097          	auipc	ra,0xffffc
    8000683c:	564080e7          	jalr	1380(ra) # 80002d9c <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80006840:	2184a703          	lw	a4,536(s1)
    80006844:	21c4a783          	lw	a5,540(s1)
    80006848:	fcf708e3          	beq	a4,a5,80006818 <piperead+0x5c>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000684c:	00000993          	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80006850:	fff00b13          	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80006854:	05505a63          	blez	s5,800068a8 <piperead+0xec>
    if(pi->nread == pi->nwrite)
    80006858:	2184a783          	lw	a5,536(s1)
    8000685c:	21c4a703          	lw	a4,540(s1)
    80006860:	04f70463          	beq	a4,a5,800068a8 <piperead+0xec>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80006864:	0017871b          	addw	a4,a5,1
    80006868:	20e4ac23          	sw	a4,536(s1)
    8000686c:	1ff7f793          	and	a5,a5,511
    80006870:	00f487b3          	add	a5,s1,a5
    80006874:	0187c783          	lbu	a5,24(a5)
    80006878:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000687c:	00100693          	li	a3,1
    80006880:	fbf40613          	add	a2,s0,-65
    80006884:	00090593          	mv	a1,s2
    80006888:	050a3503          	ld	a0,80(s4)
    8000688c:	ffffb097          	auipc	ra,0xffffb
    80006890:	6c4080e7          	jalr	1732(ra) # 80001f50 <copyout>
    80006894:	01650a63          	beq	a0,s6,800068a8 <piperead+0xec>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80006898:	0019899b          	addw	s3,s3,1
    8000689c:	00190913          	add	s2,s2,1
    800068a0:	fb3a9ce3          	bne	s5,s3,80006858 <piperead+0x9c>
    800068a4:	000a8993          	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800068a8:	21c48513          	add	a0,s1,540
    800068ac:	ffffc097          	auipc	ra,0xffffc
    800068b0:	580080e7          	jalr	1408(ra) # 80002e2c <wakeup>
  release(&pi->lock);
    800068b4:	00048513          	mv	a0,s1
    800068b8:	ffffb097          	auipc	ra,0xffffb
    800068bc:	804080e7          	jalr	-2044(ra) # 800010bc <release>
  return i;
}
    800068c0:	00098513          	mv	a0,s3
    800068c4:	04813083          	ld	ra,72(sp)
    800068c8:	04013403          	ld	s0,64(sp)
    800068cc:	03813483          	ld	s1,56(sp)
    800068d0:	03013903          	ld	s2,48(sp)
    800068d4:	02813983          	ld	s3,40(sp)
    800068d8:	02013a03          	ld	s4,32(sp)
    800068dc:	01813a83          	ld	s5,24(sp)
    800068e0:	01013b03          	ld	s6,16(sp)
    800068e4:	05010113          	add	sp,sp,80
    800068e8:	00008067          	ret
      release(&pi->lock);
    800068ec:	00048513          	mv	a0,s1
    800068f0:	ffffa097          	auipc	ra,0xffffa
    800068f4:	7cc080e7          	jalr	1996(ra) # 800010bc <release>
      return -1;
    800068f8:	fff00993          	li	s3,-1
    800068fc:	fc5ff06f          	j	800068c0 <piperead+0x104>

0000000080006900 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80006900:	ff010113          	add	sp,sp,-16
    80006904:	00813423          	sd	s0,8(sp)
    80006908:	01010413          	add	s0,sp,16
    8000690c:	00050793          	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80006910:	00157513          	and	a0,a0,1
    80006914:	00351513          	sll	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80006918:	0027f793          	and	a5,a5,2
    8000691c:	00078463          	beqz	a5,80006924 <flags2perm+0x24>
      perm |= PTE_W;
    80006920:	00456513          	or	a0,a0,4
    return perm;
}
    80006924:	00813403          	ld	s0,8(sp)
    80006928:	01010113          	add	sp,sp,16
    8000692c:	00008067          	ret

0000000080006930 <exec>:

int
exec(char *path, char **argv)
{
    80006930:	df010113          	add	sp,sp,-528
    80006934:	20113423          	sd	ra,520(sp)
    80006938:	20813023          	sd	s0,512(sp)
    8000693c:	1e913c23          	sd	s1,504(sp)
    80006940:	1f213823          	sd	s2,496(sp)
    80006944:	1f313423          	sd	s3,488(sp)
    80006948:	1f413023          	sd	s4,480(sp)
    8000694c:	1d513c23          	sd	s5,472(sp)
    80006950:	1d613823          	sd	s6,464(sp)
    80006954:	1d713423          	sd	s7,456(sp)
    80006958:	1d813023          	sd	s8,448(sp)
    8000695c:	1b913c23          	sd	s9,440(sp)
    80006960:	1ba13823          	sd	s10,432(sp)
    80006964:	1bb13423          	sd	s11,424(sp)
    80006968:	21010413          	add	s0,sp,528
    8000696c:	00050913          	mv	s2,a0
    80006970:	dea43c23          	sd	a0,-520(s0)
    80006974:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80006978:	ffffc097          	auipc	ra,0xffffc
    8000697c:	adc080e7          	jalr	-1316(ra) # 80002454 <myproc>
    80006980:	00050493          	mv	s1,a0

  begin_op();
    80006984:	fffff097          	auipc	ra,0xfffff
    80006988:	010080e7          	jalr	16(ra) # 80005994 <begin_op>

  if((ip = namei(path)) == 0){
    8000698c:	00090513          	mv	a0,s2
    80006990:	fffff097          	auipc	ra,0xfffff
    80006994:	d30080e7          	jalr	-720(ra) # 800056c0 <namei>
    80006998:	08050c63          	beqz	a0,80006a30 <exec+0x100>
    8000699c:	00050a13          	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800069a0:	ffffe097          	auipc	ra,0xffffe
    800069a4:	23c080e7          	jalr	572(ra) # 80004bdc <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800069a8:	04000713          	li	a4,64
    800069ac:	00000693          	li	a3,0
    800069b0:	e5040613          	add	a2,s0,-432
    800069b4:	00000593          	li	a1,0
    800069b8:	000a0513          	mv	a0,s4
    800069bc:	ffffe097          	auipc	ra,0xffffe
    800069c0:	5dc080e7          	jalr	1500(ra) # 80004f98 <readi>
    800069c4:	04000793          	li	a5,64
    800069c8:	00f51a63          	bne	a0,a5,800069dc <exec+0xac>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800069cc:	e5042703          	lw	a4,-432(s0)
    800069d0:	464c47b7          	lui	a5,0x464c4
    800069d4:	57f78793          	add	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800069d8:	06f70463          	beq	a4,a5,80006a40 <exec+0x110>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800069dc:	000a0513          	mv	a0,s4
    800069e0:	ffffe097          	auipc	ra,0xffffe
    800069e4:	538080e7          	jalr	1336(ra) # 80004f18 <iunlockput>
    end_op();
    800069e8:	fffff097          	auipc	ra,0xfffff
    800069ec:	05c080e7          	jalr	92(ra) # 80005a44 <end_op>
  }
  return -1;
    800069f0:	fff00513          	li	a0,-1
}
    800069f4:	20813083          	ld	ra,520(sp)
    800069f8:	20013403          	ld	s0,512(sp)
    800069fc:	1f813483          	ld	s1,504(sp)
    80006a00:	1f013903          	ld	s2,496(sp)
    80006a04:	1e813983          	ld	s3,488(sp)
    80006a08:	1e013a03          	ld	s4,480(sp)
    80006a0c:	1d813a83          	ld	s5,472(sp)
    80006a10:	1d013b03          	ld	s6,464(sp)
    80006a14:	1c813b83          	ld	s7,456(sp)
    80006a18:	1c013c03          	ld	s8,448(sp)
    80006a1c:	1b813c83          	ld	s9,440(sp)
    80006a20:	1b013d03          	ld	s10,432(sp)
    80006a24:	1a813d83          	ld	s11,424(sp)
    80006a28:	21010113          	add	sp,sp,528
    80006a2c:	00008067          	ret
    end_op();
    80006a30:	fffff097          	auipc	ra,0xfffff
    80006a34:	014080e7          	jalr	20(ra) # 80005a44 <end_op>
    return -1;
    80006a38:	fff00513          	li	a0,-1
    80006a3c:	fb9ff06f          	j	800069f4 <exec+0xc4>
  if((pagetable = proc_pagetable(p)) == 0)
    80006a40:	00048513          	mv	a0,s1
    80006a44:	ffffc097          	auipc	ra,0xffffc
    80006a48:	b2c080e7          	jalr	-1236(ra) # 80002570 <proc_pagetable>
    80006a4c:	00050b13          	mv	s6,a0
    80006a50:	f80506e3          	beqz	a0,800069dc <exec+0xac>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80006a54:	e7042d03          	lw	s10,-400(s0)
    80006a58:	e8845783          	lhu	a5,-376(s0)
    80006a5c:	14078463          	beqz	a5,80006ba4 <exec+0x274>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80006a60:	00000913          	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80006a64:	00000d93          	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80006a68:	00001cb7          	lui	s9,0x1
    80006a6c:	fffc8793          	add	a5,s9,-1 # fff <_entry-0x7ffff001>
    80006a70:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80006a74:	00001ab7          	lui	s5,0x1
    80006a78:	0880006f          	j	80006b00 <exec+0x1d0>
      panic("loadseg: address should exist");
    80006a7c:	00004517          	auipc	a0,0x4
    80006a80:	d0c50513          	add	a0,a0,-756 # 8000a788 <syscalls+0x280>
    80006a84:	ffffa097          	auipc	ra,0xffffa
    80006a88:	c44080e7          	jalr	-956(ra) # 800006c8 <panic>
    if(sz - i < PGSIZE)
    80006a8c:	0004849b          	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80006a90:	00048713          	mv	a4,s1
    80006a94:	012c06bb          	addw	a3,s8,s2
    80006a98:	00000593          	li	a1,0
    80006a9c:	000a0513          	mv	a0,s4
    80006aa0:	ffffe097          	auipc	ra,0xffffe
    80006aa4:	4f8080e7          	jalr	1272(ra) # 80004f98 <readi>
    80006aa8:	0005051b          	sext.w	a0,a0
    80006aac:	2ca49e63          	bne	s1,a0,80006d88 <exec+0x458>
  for(i = 0; i < sz; i += PGSIZE){
    80006ab0:	012a893b          	addw	s2,s5,s2
    80006ab4:	03397c63          	bgeu	s2,s3,80006aec <exec+0x1bc>
    pa = walkaddr(pagetable, va + i);
    80006ab8:	02091593          	sll	a1,s2,0x20
    80006abc:	0205d593          	srl	a1,a1,0x20
    80006ac0:	017585b3          	add	a1,a1,s7
    80006ac4:	000b0513          	mv	a0,s6
    80006ac8:	ffffb097          	auipc	ra,0xffffb
    80006acc:	b50080e7          	jalr	-1200(ra) # 80001618 <walkaddr>
    80006ad0:	00050613          	mv	a2,a0
    if(pa == 0)
    80006ad4:	fa0504e3          	beqz	a0,80006a7c <exec+0x14c>
    if(sz - i < PGSIZE)
    80006ad8:	412984bb          	subw	s1,s3,s2
    80006adc:	0004879b          	sext.w	a5,s1
    80006ae0:	fafcf6e3          	bgeu	s9,a5,80006a8c <exec+0x15c>
    80006ae4:	000a8493          	mv	s1,s5
    80006ae8:	fa5ff06f          	j	80006a8c <exec+0x15c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80006aec:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80006af0:	001d8d9b          	addw	s11,s11,1
    80006af4:	038d0d1b          	addw	s10,s10,56
    80006af8:	e8845783          	lhu	a5,-376(s0)
    80006afc:	0afdd663          	bge	s11,a5,80006ba8 <exec+0x278>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80006b00:	000d0d1b          	sext.w	s10,s10
    80006b04:	03800713          	li	a4,56
    80006b08:	000d0693          	mv	a3,s10
    80006b0c:	e1840613          	add	a2,s0,-488
    80006b10:	00000593          	li	a1,0
    80006b14:	000a0513          	mv	a0,s4
    80006b18:	ffffe097          	auipc	ra,0xffffe
    80006b1c:	480080e7          	jalr	1152(ra) # 80004f98 <readi>
    80006b20:	03800793          	li	a5,56
    80006b24:	26f51063          	bne	a0,a5,80006d84 <exec+0x454>
    if(ph.type != ELF_PROG_LOAD)
    80006b28:	e1842783          	lw	a5,-488(s0)
    80006b2c:	00100713          	li	a4,1
    80006b30:	fce790e3          	bne	a5,a4,80006af0 <exec+0x1c0>
    if(ph.memsz < ph.filesz)
    80006b34:	e4043483          	ld	s1,-448(s0)
    80006b38:	e3843783          	ld	a5,-456(s0)
    80006b3c:	26f4e463          	bltu	s1,a5,80006da4 <exec+0x474>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80006b40:	e2843783          	ld	a5,-472(s0)
    80006b44:	00f484b3          	add	s1,s1,a5
    80006b48:	26f4e263          	bltu	s1,a5,80006dac <exec+0x47c>
    if(ph.vaddr % PGSIZE != 0)
    80006b4c:	df043703          	ld	a4,-528(s0)
    80006b50:	00e7f7b3          	and	a5,a5,a4
    80006b54:	26079063          	bnez	a5,80006db4 <exec+0x484>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80006b58:	e1c42503          	lw	a0,-484(s0)
    80006b5c:	00000097          	auipc	ra,0x0
    80006b60:	da4080e7          	jalr	-604(ra) # 80006900 <flags2perm>
    80006b64:	00050693          	mv	a3,a0
    80006b68:	00048613          	mv	a2,s1
    80006b6c:	00090593          	mv	a1,s2
    80006b70:	000b0513          	mv	a0,s6
    80006b74:	ffffb097          	auipc	ra,0xffffb
    80006b78:	030080e7          	jalr	48(ra) # 80001ba4 <uvmalloc>
    80006b7c:	e0a43423          	sd	a0,-504(s0)
    80006b80:	22050e63          	beqz	a0,80006dbc <exec+0x48c>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80006b84:	e2843b83          	ld	s7,-472(s0)
    80006b88:	e2042c03          	lw	s8,-480(s0)
    80006b8c:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80006b90:	00098663          	beqz	s3,80006b9c <exec+0x26c>
    80006b94:	00000913          	li	s2,0
    80006b98:	f21ff06f          	j	80006ab8 <exec+0x188>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80006b9c:	e0843903          	ld	s2,-504(s0)
    80006ba0:	f51ff06f          	j	80006af0 <exec+0x1c0>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80006ba4:	00000913          	li	s2,0
  iunlockput(ip);
    80006ba8:	000a0513          	mv	a0,s4
    80006bac:	ffffe097          	auipc	ra,0xffffe
    80006bb0:	36c080e7          	jalr	876(ra) # 80004f18 <iunlockput>
  end_op();
    80006bb4:	fffff097          	auipc	ra,0xfffff
    80006bb8:	e90080e7          	jalr	-368(ra) # 80005a44 <end_op>
  p = myproc();
    80006bbc:	ffffc097          	auipc	ra,0xffffc
    80006bc0:	898080e7          	jalr	-1896(ra) # 80002454 <myproc>
    80006bc4:	00050a93          	mv	s5,a0
  uint64 oldsz = p->sz;
    80006bc8:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80006bcc:	000019b7          	lui	s3,0x1
    80006bd0:	fff98993          	add	s3,s3,-1 # fff <_entry-0x7ffff001>
    80006bd4:	013909b3          	add	s3,s2,s3
    80006bd8:	fffff7b7          	lui	a5,0xfffff
    80006bdc:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80006be0:	00400693          	li	a3,4
    80006be4:	00002637          	lui	a2,0x2
    80006be8:	00c98633          	add	a2,s3,a2
    80006bec:	00098593          	mv	a1,s3
    80006bf0:	000b0513          	mv	a0,s6
    80006bf4:	ffffb097          	auipc	ra,0xffffb
    80006bf8:	fb0080e7          	jalr	-80(ra) # 80001ba4 <uvmalloc>
    80006bfc:	00050913          	mv	s2,a0
    80006c00:	e0a43423          	sd	a0,-504(s0)
    80006c04:	00051863          	bnez	a0,80006c14 <exec+0x2e4>
  if(pagetable)
    80006c08:	e1343423          	sd	s3,-504(s0)
    80006c0c:	00000a13          	li	s4,0
    80006c10:	1780006f          	j	80006d88 <exec+0x458>
  uvmclear(pagetable, sz-2*PGSIZE);
    80006c14:	ffffe5b7          	lui	a1,0xffffe
    80006c18:	00b505b3          	add	a1,a0,a1
    80006c1c:	000b0513          	mv	a0,s6
    80006c20:	ffffb097          	auipc	ra,0xffffb
    80006c24:	2e4080e7          	jalr	740(ra) # 80001f04 <uvmclear>
  stackbase = sp - PGSIZE;
    80006c28:	fffffbb7          	lui	s7,0xfffff
    80006c2c:	01790bb3          	add	s7,s2,s7
  for(argc = 0; argv[argc]; argc++) {
    80006c30:	e0043783          	ld	a5,-512(s0)
    80006c34:	0007b503          	ld	a0,0(a5) # fffffffffffff000 <end+0xffffffff7ffdb200>
    80006c38:	08050063          	beqz	a0,80006cb8 <exec+0x388>
    80006c3c:	e9040993          	add	s3,s0,-368
    80006c40:	f9040c13          	add	s8,s0,-112
    80006c44:	00000493          	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80006c48:	ffffa097          	auipc	ra,0xffffa
    80006c4c:	720080e7          	jalr	1824(ra) # 80001368 <strlen>
    80006c50:	0015079b          	addw	a5,a0,1
    80006c54:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80006c58:	ff07f913          	and	s2,a5,-16
    if(sp < stackbase)
    80006c5c:	17796463          	bltu	s2,s7,80006dc4 <exec+0x494>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80006c60:	e0043d03          	ld	s10,-512(s0)
    80006c64:	000d3a03          	ld	s4,0(s10)
    80006c68:	000a0513          	mv	a0,s4
    80006c6c:	ffffa097          	auipc	ra,0xffffa
    80006c70:	6fc080e7          	jalr	1788(ra) # 80001368 <strlen>
    80006c74:	0015069b          	addw	a3,a0,1
    80006c78:	000a0613          	mv	a2,s4
    80006c7c:	00090593          	mv	a1,s2
    80006c80:	000b0513          	mv	a0,s6
    80006c84:	ffffb097          	auipc	ra,0xffffb
    80006c88:	2cc080e7          	jalr	716(ra) # 80001f50 <copyout>
    80006c8c:	14054063          	bltz	a0,80006dcc <exec+0x49c>
    ustack[argc] = sp;
    80006c90:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80006c94:	00148493          	add	s1,s1,1
    80006c98:	008d0793          	add	a5,s10,8
    80006c9c:	e0f43023          	sd	a5,-512(s0)
    80006ca0:	008d3503          	ld	a0,8(s10)
    80006ca4:	00050e63          	beqz	a0,80006cc0 <exec+0x390>
    if(argc >= MAXARG)
    80006ca8:	00898993          	add	s3,s3,8
    80006cac:	f9899ee3          	bne	s3,s8,80006c48 <exec+0x318>
  ip = 0;
    80006cb0:	00000a13          	li	s4,0
    80006cb4:	0d40006f          	j	80006d88 <exec+0x458>
  sp = sz;
    80006cb8:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80006cbc:	00000493          	li	s1,0
  ustack[argc] = 0;
    80006cc0:	00349793          	sll	a5,s1,0x3
    80006cc4:	f9078793          	add	a5,a5,-112
    80006cc8:	008787b3          	add	a5,a5,s0
    80006ccc:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80006cd0:	00148693          	add	a3,s1,1
    80006cd4:	00369693          	sll	a3,a3,0x3
    80006cd8:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80006cdc:	ff097913          	and	s2,s2,-16
  sz = sz1;
    80006ce0:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80006ce4:	f37962e3          	bltu	s2,s7,80006c08 <exec+0x2d8>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80006ce8:	e9040613          	add	a2,s0,-368
    80006cec:	00090593          	mv	a1,s2
    80006cf0:	000b0513          	mv	a0,s6
    80006cf4:	ffffb097          	auipc	ra,0xffffb
    80006cf8:	25c080e7          	jalr	604(ra) # 80001f50 <copyout>
    80006cfc:	0c054c63          	bltz	a0,80006dd4 <exec+0x4a4>
  p->trapframe->a1 = sp;
    80006d00:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80006d04:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80006d08:	df843783          	ld	a5,-520(s0)
    80006d0c:	0007c703          	lbu	a4,0(a5)
    80006d10:	02070463          	beqz	a4,80006d38 <exec+0x408>
    80006d14:	00178793          	add	a5,a5,1
    if(*s == '/')
    80006d18:	02f00693          	li	a3,47
    80006d1c:	0140006f          	j	80006d30 <exec+0x400>
      last = s+1;
    80006d20:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80006d24:	00178793          	add	a5,a5,1
    80006d28:	fff7c703          	lbu	a4,-1(a5)
    80006d2c:	00070663          	beqz	a4,80006d38 <exec+0x408>
    if(*s == '/')
    80006d30:	fed71ae3          	bne	a4,a3,80006d24 <exec+0x3f4>
    80006d34:	fedff06f          	j	80006d20 <exec+0x3f0>
  safestrcpy(p->name, last, sizeof(p->name));
    80006d38:	01000613          	li	a2,16
    80006d3c:	df843583          	ld	a1,-520(s0)
    80006d40:	158a8513          	add	a0,s5,344
    80006d44:	ffffa097          	auipc	ra,0xffffa
    80006d48:	5d8080e7          	jalr	1496(ra) # 8000131c <safestrcpy>
  oldpagetable = p->pagetable;
    80006d4c:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80006d50:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80006d54:	e0843783          	ld	a5,-504(s0)
    80006d58:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80006d5c:	058ab783          	ld	a5,88(s5)
    80006d60:	e6843703          	ld	a4,-408(s0)
    80006d64:	00e7bc23          	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80006d68:	058ab783          	ld	a5,88(s5)
    80006d6c:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80006d70:	000c8593          	mv	a1,s9
    80006d74:	ffffc097          	auipc	ra,0xffffc
    80006d78:	8e4080e7          	jalr	-1820(ra) # 80002658 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80006d7c:	0004851b          	sext.w	a0,s1
    80006d80:	c75ff06f          	j	800069f4 <exec+0xc4>
    80006d84:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    80006d88:	e0843583          	ld	a1,-504(s0)
    80006d8c:	000b0513          	mv	a0,s6
    80006d90:	ffffc097          	auipc	ra,0xffffc
    80006d94:	8c8080e7          	jalr	-1848(ra) # 80002658 <proc_freepagetable>
  return -1;
    80006d98:	fff00513          	li	a0,-1
  if(ip){
    80006d9c:	c40a0ce3          	beqz	s4,800069f4 <exec+0xc4>
    80006da0:	c3dff06f          	j	800069dc <exec+0xac>
    80006da4:	e1243423          	sd	s2,-504(s0)
    80006da8:	fe1ff06f          	j	80006d88 <exec+0x458>
    80006dac:	e1243423          	sd	s2,-504(s0)
    80006db0:	fd9ff06f          	j	80006d88 <exec+0x458>
    80006db4:	e1243423          	sd	s2,-504(s0)
    80006db8:	fd1ff06f          	j	80006d88 <exec+0x458>
    80006dbc:	e1243423          	sd	s2,-504(s0)
    80006dc0:	fc9ff06f          	j	80006d88 <exec+0x458>
  ip = 0;
    80006dc4:	00000a13          	li	s4,0
    80006dc8:	fc1ff06f          	j	80006d88 <exec+0x458>
    80006dcc:	00000a13          	li	s4,0
  if(pagetable)
    80006dd0:	fb9ff06f          	j	80006d88 <exec+0x458>
  sz = sz1;
    80006dd4:	e0843983          	ld	s3,-504(s0)
    80006dd8:	e31ff06f          	j	80006c08 <exec+0x2d8>

0000000080006ddc <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80006ddc:	fd010113          	add	sp,sp,-48
    80006de0:	02113423          	sd	ra,40(sp)
    80006de4:	02813023          	sd	s0,32(sp)
    80006de8:	00913c23          	sd	s1,24(sp)
    80006dec:	01213823          	sd	s2,16(sp)
    80006df0:	03010413          	add	s0,sp,48
    80006df4:	00058913          	mv	s2,a1
    80006df8:	00060493          	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80006dfc:	fdc40593          	add	a1,s0,-36
    80006e00:	ffffd097          	auipc	ra,0xffffd
    80006e04:	e40080e7          	jalr	-448(ra) # 80003c40 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80006e08:	fdc42703          	lw	a4,-36(s0)
    80006e0c:	00f00793          	li	a5,15
    80006e10:	04e7e863          	bltu	a5,a4,80006e60 <argfd+0x84>
    80006e14:	ffffb097          	auipc	ra,0xffffb
    80006e18:	640080e7          	jalr	1600(ra) # 80002454 <myproc>
    80006e1c:	fdc42703          	lw	a4,-36(s0)
    80006e20:	01a70793          	add	a5,a4,26
    80006e24:	00379793          	sll	a5,a5,0x3
    80006e28:	00f50533          	add	a0,a0,a5
    80006e2c:	00053783          	ld	a5,0(a0)
    80006e30:	02078c63          	beqz	a5,80006e68 <argfd+0x8c>
    return -1;
  if(pfd)
    80006e34:	00090463          	beqz	s2,80006e3c <argfd+0x60>
    *pfd = fd;
    80006e38:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80006e3c:	00000513          	li	a0,0
  if(pf)
    80006e40:	00048463          	beqz	s1,80006e48 <argfd+0x6c>
    *pf = f;
    80006e44:	00f4b023          	sd	a5,0(s1)
}
    80006e48:	02813083          	ld	ra,40(sp)
    80006e4c:	02013403          	ld	s0,32(sp)
    80006e50:	01813483          	ld	s1,24(sp)
    80006e54:	01013903          	ld	s2,16(sp)
    80006e58:	03010113          	add	sp,sp,48
    80006e5c:	00008067          	ret
    return -1;
    80006e60:	fff00513          	li	a0,-1
    80006e64:	fe5ff06f          	j	80006e48 <argfd+0x6c>
    80006e68:	fff00513          	li	a0,-1
    80006e6c:	fddff06f          	j	80006e48 <argfd+0x6c>

0000000080006e70 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80006e70:	fe010113          	add	sp,sp,-32
    80006e74:	00113c23          	sd	ra,24(sp)
    80006e78:	00813823          	sd	s0,16(sp)
    80006e7c:	00913423          	sd	s1,8(sp)
    80006e80:	02010413          	add	s0,sp,32
    80006e84:	00050493          	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80006e88:	ffffb097          	auipc	ra,0xffffb
    80006e8c:	5cc080e7          	jalr	1484(ra) # 80002454 <myproc>
    80006e90:	00050613          	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80006e94:	0d050793          	add	a5,a0,208
    80006e98:	00000513          	li	a0,0
    80006e9c:	01000693          	li	a3,16
    if(p->ofile[fd] == 0){
    80006ea0:	0007b703          	ld	a4,0(a5)
    80006ea4:	02070463          	beqz	a4,80006ecc <fdalloc+0x5c>
  for(fd = 0; fd < NOFILE; fd++){
    80006ea8:	0015051b          	addw	a0,a0,1
    80006eac:	00878793          	add	a5,a5,8
    80006eb0:	fed518e3          	bne	a0,a3,80006ea0 <fdalloc+0x30>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80006eb4:	fff00513          	li	a0,-1
}
    80006eb8:	01813083          	ld	ra,24(sp)
    80006ebc:	01013403          	ld	s0,16(sp)
    80006ec0:	00813483          	ld	s1,8(sp)
    80006ec4:	02010113          	add	sp,sp,32
    80006ec8:	00008067          	ret
      p->ofile[fd] = f;
    80006ecc:	01a50793          	add	a5,a0,26
    80006ed0:	00379793          	sll	a5,a5,0x3
    80006ed4:	00f60633          	add	a2,a2,a5
    80006ed8:	00963023          	sd	s1,0(a2) # 2000 <_entry-0x7fffe000>
      return fd;
    80006edc:	fddff06f          	j	80006eb8 <fdalloc+0x48>

0000000080006ee0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80006ee0:	fb010113          	add	sp,sp,-80
    80006ee4:	04113423          	sd	ra,72(sp)
    80006ee8:	04813023          	sd	s0,64(sp)
    80006eec:	02913c23          	sd	s1,56(sp)
    80006ef0:	03213823          	sd	s2,48(sp)
    80006ef4:	03313423          	sd	s3,40(sp)
    80006ef8:	03413023          	sd	s4,32(sp)
    80006efc:	01513c23          	sd	s5,24(sp)
    80006f00:	01613823          	sd	s6,16(sp)
    80006f04:	05010413          	add	s0,sp,80
    80006f08:	00058b13          	mv	s6,a1
    80006f0c:	00060993          	mv	s3,a2
    80006f10:	00068913          	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80006f14:	fb040593          	add	a1,s0,-80
    80006f18:	ffffe097          	auipc	ra,0xffffe
    80006f1c:	7d8080e7          	jalr	2008(ra) # 800056f0 <nameiparent>
    80006f20:	00050493          	mv	s1,a0
    80006f24:	1a050c63          	beqz	a0,800070dc <create+0x1fc>
    return 0;

  ilock(dp);
    80006f28:	ffffe097          	auipc	ra,0xffffe
    80006f2c:	cb4080e7          	jalr	-844(ra) # 80004bdc <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80006f30:	00000613          	li	a2,0
    80006f34:	fb040593          	add	a1,s0,-80
    80006f38:	00048513          	mv	a0,s1
    80006f3c:	ffffe097          	auipc	ra,0xffffe
    80006f40:	394080e7          	jalr	916(ra) # 800052d0 <dirlookup>
    80006f44:	00050a93          	mv	s5,a0
    80006f48:	06050e63          	beqz	a0,80006fc4 <create+0xe4>
    iunlockput(dp);
    80006f4c:	00048513          	mv	a0,s1
    80006f50:	ffffe097          	auipc	ra,0xffffe
    80006f54:	fc8080e7          	jalr	-56(ra) # 80004f18 <iunlockput>
    ilock(ip);
    80006f58:	000a8513          	mv	a0,s5
    80006f5c:	ffffe097          	auipc	ra,0xffffe
    80006f60:	c80080e7          	jalr	-896(ra) # 80004bdc <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80006f64:	00200793          	li	a5,2
    80006f68:	04fb1463          	bne	s6,a5,80006fb0 <create+0xd0>
    80006f6c:	044ad783          	lhu	a5,68(s5)
    80006f70:	ffe7879b          	addw	a5,a5,-2
    80006f74:	03079793          	sll	a5,a5,0x30
    80006f78:	0307d793          	srl	a5,a5,0x30
    80006f7c:	00100713          	li	a4,1
    80006f80:	02f76863          	bltu	a4,a5,80006fb0 <create+0xd0>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80006f84:	000a8513          	mv	a0,s5
    80006f88:	04813083          	ld	ra,72(sp)
    80006f8c:	04013403          	ld	s0,64(sp)
    80006f90:	03813483          	ld	s1,56(sp)
    80006f94:	03013903          	ld	s2,48(sp)
    80006f98:	02813983          	ld	s3,40(sp)
    80006f9c:	02013a03          	ld	s4,32(sp)
    80006fa0:	01813a83          	ld	s5,24(sp)
    80006fa4:	01013b03          	ld	s6,16(sp)
    80006fa8:	05010113          	add	sp,sp,80
    80006fac:	00008067          	ret
    iunlockput(ip);
    80006fb0:	000a8513          	mv	a0,s5
    80006fb4:	ffffe097          	auipc	ra,0xffffe
    80006fb8:	f64080e7          	jalr	-156(ra) # 80004f18 <iunlockput>
    return 0;
    80006fbc:	00000a93          	li	s5,0
    80006fc0:	fc5ff06f          	j	80006f84 <create+0xa4>
  if((ip = ialloc(dp->dev, type)) == 0){
    80006fc4:	000b0593          	mv	a1,s6
    80006fc8:	0004a503          	lw	a0,0(s1)
    80006fcc:	ffffe097          	auipc	ra,0xffffe
    80006fd0:	9dc080e7          	jalr	-1572(ra) # 800049a8 <ialloc>
    80006fd4:	00050a13          	mv	s4,a0
    80006fd8:	04050c63          	beqz	a0,80007030 <create+0x150>
  ilock(ip);
    80006fdc:	ffffe097          	auipc	ra,0xffffe
    80006fe0:	c00080e7          	jalr	-1024(ra) # 80004bdc <ilock>
  ip->major = major;
    80006fe4:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80006fe8:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80006fec:	00100913          	li	s2,1
    80006ff0:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80006ff4:	000a0513          	mv	a0,s4
    80006ff8:	ffffe097          	auipc	ra,0xffffe
    80006ffc:	ac8080e7          	jalr	-1336(ra) # 80004ac0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80007000:	052b0263          	beq	s6,s2,80007044 <create+0x164>
  if(dirlink(dp, name, ip->inum) < 0)
    80007004:	004a2603          	lw	a2,4(s4)
    80007008:	fb040593          	add	a1,s0,-80
    8000700c:	00048513          	mv	a0,s1
    80007010:	ffffe097          	auipc	ra,0xffffe
    80007014:	5b0080e7          	jalr	1456(ra) # 800055c0 <dirlink>
    80007018:	08054c63          	bltz	a0,800070b0 <create+0x1d0>
  iunlockput(dp);
    8000701c:	00048513          	mv	a0,s1
    80007020:	ffffe097          	auipc	ra,0xffffe
    80007024:	ef8080e7          	jalr	-264(ra) # 80004f18 <iunlockput>
  return ip;
    80007028:	000a0a93          	mv	s5,s4
    8000702c:	f59ff06f          	j	80006f84 <create+0xa4>
    iunlockput(dp);
    80007030:	00048513          	mv	a0,s1
    80007034:	ffffe097          	auipc	ra,0xffffe
    80007038:	ee4080e7          	jalr	-284(ra) # 80004f18 <iunlockput>
    return 0;
    8000703c:	000a0a93          	mv	s5,s4
    80007040:	f45ff06f          	j	80006f84 <create+0xa4>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80007044:	004a2603          	lw	a2,4(s4)
    80007048:	00003597          	auipc	a1,0x3
    8000704c:	76058593          	add	a1,a1,1888 # 8000a7a8 <syscalls+0x2a0>
    80007050:	000a0513          	mv	a0,s4
    80007054:	ffffe097          	auipc	ra,0xffffe
    80007058:	56c080e7          	jalr	1388(ra) # 800055c0 <dirlink>
    8000705c:	04054a63          	bltz	a0,800070b0 <create+0x1d0>
    80007060:	0044a603          	lw	a2,4(s1)
    80007064:	00003597          	auipc	a1,0x3
    80007068:	74c58593          	add	a1,a1,1868 # 8000a7b0 <syscalls+0x2a8>
    8000706c:	000a0513          	mv	a0,s4
    80007070:	ffffe097          	auipc	ra,0xffffe
    80007074:	550080e7          	jalr	1360(ra) # 800055c0 <dirlink>
    80007078:	02054c63          	bltz	a0,800070b0 <create+0x1d0>
  if(dirlink(dp, name, ip->inum) < 0)
    8000707c:	004a2603          	lw	a2,4(s4)
    80007080:	fb040593          	add	a1,s0,-80
    80007084:	00048513          	mv	a0,s1
    80007088:	ffffe097          	auipc	ra,0xffffe
    8000708c:	538080e7          	jalr	1336(ra) # 800055c0 <dirlink>
    80007090:	02054063          	bltz	a0,800070b0 <create+0x1d0>
    dp->nlink++;  // for ".."
    80007094:	04a4d783          	lhu	a5,74(s1)
    80007098:	0017879b          	addw	a5,a5,1
    8000709c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800070a0:	00048513          	mv	a0,s1
    800070a4:	ffffe097          	auipc	ra,0xffffe
    800070a8:	a1c080e7          	jalr	-1508(ra) # 80004ac0 <iupdate>
    800070ac:	f71ff06f          	j	8000701c <create+0x13c>
  ip->nlink = 0;
    800070b0:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800070b4:	000a0513          	mv	a0,s4
    800070b8:	ffffe097          	auipc	ra,0xffffe
    800070bc:	a08080e7          	jalr	-1528(ra) # 80004ac0 <iupdate>
  iunlockput(ip);
    800070c0:	000a0513          	mv	a0,s4
    800070c4:	ffffe097          	auipc	ra,0xffffe
    800070c8:	e54080e7          	jalr	-428(ra) # 80004f18 <iunlockput>
  iunlockput(dp);
    800070cc:	00048513          	mv	a0,s1
    800070d0:	ffffe097          	auipc	ra,0xffffe
    800070d4:	e48080e7          	jalr	-440(ra) # 80004f18 <iunlockput>
  return 0;
    800070d8:	eadff06f          	j	80006f84 <create+0xa4>
    return 0;
    800070dc:	00050a93          	mv	s5,a0
    800070e0:	ea5ff06f          	j	80006f84 <create+0xa4>

00000000800070e4 <sys_dup>:
{
    800070e4:	fd010113          	add	sp,sp,-48
    800070e8:	02113423          	sd	ra,40(sp)
    800070ec:	02813023          	sd	s0,32(sp)
    800070f0:	00913c23          	sd	s1,24(sp)
    800070f4:	01213823          	sd	s2,16(sp)
    800070f8:	03010413          	add	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800070fc:	fd840613          	add	a2,s0,-40
    80007100:	00000593          	li	a1,0
    80007104:	00000513          	li	a0,0
    80007108:	00000097          	auipc	ra,0x0
    8000710c:	cd4080e7          	jalr	-812(ra) # 80006ddc <argfd>
    return -1;
    80007110:	fff00793          	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80007114:	02054863          	bltz	a0,80007144 <sys_dup+0x60>
  if((fd=fdalloc(f)) < 0)
    80007118:	fd843903          	ld	s2,-40(s0)
    8000711c:	00090513          	mv	a0,s2
    80007120:	00000097          	auipc	ra,0x0
    80007124:	d50080e7          	jalr	-688(ra) # 80006e70 <fdalloc>
    80007128:	00050493          	mv	s1,a0
    return -1;
    8000712c:	fff00793          	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80007130:	00054a63          	bltz	a0,80007144 <sys_dup+0x60>
  filedup(f);
    80007134:	00090513          	mv	a0,s2
    80007138:	fffff097          	auipc	ra,0xfffff
    8000713c:	e74080e7          	jalr	-396(ra) # 80005fac <filedup>
  return fd;
    80007140:	00048793          	mv	a5,s1
}
    80007144:	00078513          	mv	a0,a5
    80007148:	02813083          	ld	ra,40(sp)
    8000714c:	02013403          	ld	s0,32(sp)
    80007150:	01813483          	ld	s1,24(sp)
    80007154:	01013903          	ld	s2,16(sp)
    80007158:	03010113          	add	sp,sp,48
    8000715c:	00008067          	ret

0000000080007160 <sys_read>:
{
    80007160:	fd010113          	add	sp,sp,-48
    80007164:	02113423          	sd	ra,40(sp)
    80007168:	02813023          	sd	s0,32(sp)
    8000716c:	03010413          	add	s0,sp,48
  argaddr(1, &p);
    80007170:	fd840593          	add	a1,s0,-40
    80007174:	00100513          	li	a0,1
    80007178:	ffffd097          	auipc	ra,0xffffd
    8000717c:	b00080e7          	jalr	-1280(ra) # 80003c78 <argaddr>
  argint(2, &n);
    80007180:	fe440593          	add	a1,s0,-28
    80007184:	00200513          	li	a0,2
    80007188:	ffffd097          	auipc	ra,0xffffd
    8000718c:	ab8080e7          	jalr	-1352(ra) # 80003c40 <argint>
  if(argfd(0, 0, &f) < 0)
    80007190:	fe840613          	add	a2,s0,-24
    80007194:	00000593          	li	a1,0
    80007198:	00000513          	li	a0,0
    8000719c:	00000097          	auipc	ra,0x0
    800071a0:	c40080e7          	jalr	-960(ra) # 80006ddc <argfd>
    800071a4:	00050793          	mv	a5,a0
    return -1;
    800071a8:	fff00513          	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800071ac:	0007cc63          	bltz	a5,800071c4 <sys_read+0x64>
  return fileread(f, p, n);
    800071b0:	fe442603          	lw	a2,-28(s0)
    800071b4:	fd843583          	ld	a1,-40(s0)
    800071b8:	fe843503          	ld	a0,-24(s0)
    800071bc:	fffff097          	auipc	ra,0xfffff
    800071c0:	00c080e7          	jalr	12(ra) # 800061c8 <fileread>
}
    800071c4:	02813083          	ld	ra,40(sp)
    800071c8:	02013403          	ld	s0,32(sp)
    800071cc:	03010113          	add	sp,sp,48
    800071d0:	00008067          	ret

00000000800071d4 <sys_write>:
{
    800071d4:	fd010113          	add	sp,sp,-48
    800071d8:	02113423          	sd	ra,40(sp)
    800071dc:	02813023          	sd	s0,32(sp)
    800071e0:	03010413          	add	s0,sp,48
  argaddr(1, &p);
    800071e4:	fd840593          	add	a1,s0,-40
    800071e8:	00100513          	li	a0,1
    800071ec:	ffffd097          	auipc	ra,0xffffd
    800071f0:	a8c080e7          	jalr	-1396(ra) # 80003c78 <argaddr>
  argint(2, &n);
    800071f4:	fe440593          	add	a1,s0,-28
    800071f8:	00200513          	li	a0,2
    800071fc:	ffffd097          	auipc	ra,0xffffd
    80007200:	a44080e7          	jalr	-1468(ra) # 80003c40 <argint>
  if(argfd(0, 0, &f) < 0)
    80007204:	fe840613          	add	a2,s0,-24
    80007208:	00000593          	li	a1,0
    8000720c:	00000513          	li	a0,0
    80007210:	00000097          	auipc	ra,0x0
    80007214:	bcc080e7          	jalr	-1076(ra) # 80006ddc <argfd>
    80007218:	00050793          	mv	a5,a0
    return -1;
    8000721c:	fff00513          	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80007220:	0007cc63          	bltz	a5,80007238 <sys_write+0x64>
  return filewrite(f, p, n);
    80007224:	fe442603          	lw	a2,-28(s0)
    80007228:	fd843583          	ld	a1,-40(s0)
    8000722c:	fe843503          	ld	a0,-24(s0)
    80007230:	fffff097          	auipc	ra,0xfffff
    80007234:	0c4080e7          	jalr	196(ra) # 800062f4 <filewrite>
}
    80007238:	02813083          	ld	ra,40(sp)
    8000723c:	02013403          	ld	s0,32(sp)
    80007240:	03010113          	add	sp,sp,48
    80007244:	00008067          	ret

0000000080007248 <sys_close>:
{
    80007248:	fe010113          	add	sp,sp,-32
    8000724c:	00113c23          	sd	ra,24(sp)
    80007250:	00813823          	sd	s0,16(sp)
    80007254:	02010413          	add	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80007258:	fe040613          	add	a2,s0,-32
    8000725c:	fec40593          	add	a1,s0,-20
    80007260:	00000513          	li	a0,0
    80007264:	00000097          	auipc	ra,0x0
    80007268:	b78080e7          	jalr	-1160(ra) # 80006ddc <argfd>
    return -1;
    8000726c:	fff00793          	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80007270:	02054863          	bltz	a0,800072a0 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
    80007274:	ffffb097          	auipc	ra,0xffffb
    80007278:	1e0080e7          	jalr	480(ra) # 80002454 <myproc>
    8000727c:	fec42783          	lw	a5,-20(s0)
    80007280:	01a78793          	add	a5,a5,26
    80007284:	00379793          	sll	a5,a5,0x3
    80007288:	00f50533          	add	a0,a0,a5
    8000728c:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80007290:	fe043503          	ld	a0,-32(s0)
    80007294:	fffff097          	auipc	ra,0xfffff
    80007298:	d88080e7          	jalr	-632(ra) # 8000601c <fileclose>
  return 0;
    8000729c:	00000793          	li	a5,0
}
    800072a0:	00078513          	mv	a0,a5
    800072a4:	01813083          	ld	ra,24(sp)
    800072a8:	01013403          	ld	s0,16(sp)
    800072ac:	02010113          	add	sp,sp,32
    800072b0:	00008067          	ret

00000000800072b4 <sys_fstat>:
{
    800072b4:	fe010113          	add	sp,sp,-32
    800072b8:	00113c23          	sd	ra,24(sp)
    800072bc:	00813823          	sd	s0,16(sp)
    800072c0:	02010413          	add	s0,sp,32
  argaddr(1, &st);
    800072c4:	fe040593          	add	a1,s0,-32
    800072c8:	00100513          	li	a0,1
    800072cc:	ffffd097          	auipc	ra,0xffffd
    800072d0:	9ac080e7          	jalr	-1620(ra) # 80003c78 <argaddr>
  if(argfd(0, 0, &f) < 0)
    800072d4:	fe840613          	add	a2,s0,-24
    800072d8:	00000593          	li	a1,0
    800072dc:	00000513          	li	a0,0
    800072e0:	00000097          	auipc	ra,0x0
    800072e4:	afc080e7          	jalr	-1284(ra) # 80006ddc <argfd>
    800072e8:	00050793          	mv	a5,a0
    return -1;
    800072ec:	fff00513          	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800072f0:	0007ca63          	bltz	a5,80007304 <sys_fstat+0x50>
  return filestat(f, st);
    800072f4:	fe043583          	ld	a1,-32(s0)
    800072f8:	fe843503          	ld	a0,-24(s0)
    800072fc:	fffff097          	auipc	ra,0xfffff
    80007300:	e24080e7          	jalr	-476(ra) # 80006120 <filestat>
}
    80007304:	01813083          	ld	ra,24(sp)
    80007308:	01013403          	ld	s0,16(sp)
    8000730c:	02010113          	add	sp,sp,32
    80007310:	00008067          	ret

0000000080007314 <sys_link>:
{
    80007314:	ed010113          	add	sp,sp,-304
    80007318:	12113423          	sd	ra,296(sp)
    8000731c:	12813023          	sd	s0,288(sp)
    80007320:	10913c23          	sd	s1,280(sp)
    80007324:	11213823          	sd	s2,272(sp)
    80007328:	13010413          	add	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000732c:	08000613          	li	a2,128
    80007330:	ed040593          	add	a1,s0,-304
    80007334:	00000513          	li	a0,0
    80007338:	ffffd097          	auipc	ra,0xffffd
    8000733c:	978080e7          	jalr	-1672(ra) # 80003cb0 <argstr>
    return -1;
    80007340:	fff00793          	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80007344:	14054a63          	bltz	a0,80007498 <sys_link+0x184>
    80007348:	08000613          	li	a2,128
    8000734c:	f5040593          	add	a1,s0,-176
    80007350:	00100513          	li	a0,1
    80007354:	ffffd097          	auipc	ra,0xffffd
    80007358:	95c080e7          	jalr	-1700(ra) # 80003cb0 <argstr>
    return -1;
    8000735c:	fff00793          	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80007360:	12054c63          	bltz	a0,80007498 <sys_link+0x184>
  begin_op();
    80007364:	ffffe097          	auipc	ra,0xffffe
    80007368:	630080e7          	jalr	1584(ra) # 80005994 <begin_op>
  if((ip = namei(old)) == 0){
    8000736c:	ed040513          	add	a0,s0,-304
    80007370:	ffffe097          	auipc	ra,0xffffe
    80007374:	350080e7          	jalr	848(ra) # 800056c0 <namei>
    80007378:	00050493          	mv	s1,a0
    8000737c:	0a050463          	beqz	a0,80007424 <sys_link+0x110>
  ilock(ip);
    80007380:	ffffe097          	auipc	ra,0xffffe
    80007384:	85c080e7          	jalr	-1956(ra) # 80004bdc <ilock>
  if(ip->type == T_DIR){
    80007388:	04449703          	lh	a4,68(s1)
    8000738c:	00100793          	li	a5,1
    80007390:	0af70263          	beq	a4,a5,80007434 <sys_link+0x120>
  ip->nlink++;
    80007394:	04a4d783          	lhu	a5,74(s1)
    80007398:	0017879b          	addw	a5,a5,1
    8000739c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800073a0:	00048513          	mv	a0,s1
    800073a4:	ffffd097          	auipc	ra,0xffffd
    800073a8:	71c080e7          	jalr	1820(ra) # 80004ac0 <iupdate>
  iunlock(ip);
    800073ac:	00048513          	mv	a0,s1
    800073b0:	ffffe097          	auipc	ra,0xffffe
    800073b4:	930080e7          	jalr	-1744(ra) # 80004ce0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800073b8:	fd040593          	add	a1,s0,-48
    800073bc:	f5040513          	add	a0,s0,-176
    800073c0:	ffffe097          	auipc	ra,0xffffe
    800073c4:	330080e7          	jalr	816(ra) # 800056f0 <nameiparent>
    800073c8:	00050913          	mv	s2,a0
    800073cc:	08050863          	beqz	a0,8000745c <sys_link+0x148>
  ilock(dp);
    800073d0:	ffffe097          	auipc	ra,0xffffe
    800073d4:	80c080e7          	jalr	-2036(ra) # 80004bdc <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800073d8:	00092703          	lw	a4,0(s2)
    800073dc:	0004a783          	lw	a5,0(s1)
    800073e0:	06f71863          	bne	a4,a5,80007450 <sys_link+0x13c>
    800073e4:	0044a603          	lw	a2,4(s1)
    800073e8:	fd040593          	add	a1,s0,-48
    800073ec:	00090513          	mv	a0,s2
    800073f0:	ffffe097          	auipc	ra,0xffffe
    800073f4:	1d0080e7          	jalr	464(ra) # 800055c0 <dirlink>
    800073f8:	04054c63          	bltz	a0,80007450 <sys_link+0x13c>
  iunlockput(dp);
    800073fc:	00090513          	mv	a0,s2
    80007400:	ffffe097          	auipc	ra,0xffffe
    80007404:	b18080e7          	jalr	-1256(ra) # 80004f18 <iunlockput>
  iput(ip);
    80007408:	00048513          	mv	a0,s1
    8000740c:	ffffe097          	auipc	ra,0xffffe
    80007410:	a30080e7          	jalr	-1488(ra) # 80004e3c <iput>
  end_op();
    80007414:	ffffe097          	auipc	ra,0xffffe
    80007418:	630080e7          	jalr	1584(ra) # 80005a44 <end_op>
  return 0;
    8000741c:	00000793          	li	a5,0
    80007420:	0780006f          	j	80007498 <sys_link+0x184>
    end_op();
    80007424:	ffffe097          	auipc	ra,0xffffe
    80007428:	620080e7          	jalr	1568(ra) # 80005a44 <end_op>
    return -1;
    8000742c:	fff00793          	li	a5,-1
    80007430:	0680006f          	j	80007498 <sys_link+0x184>
    iunlockput(ip);
    80007434:	00048513          	mv	a0,s1
    80007438:	ffffe097          	auipc	ra,0xffffe
    8000743c:	ae0080e7          	jalr	-1312(ra) # 80004f18 <iunlockput>
    end_op();
    80007440:	ffffe097          	auipc	ra,0xffffe
    80007444:	604080e7          	jalr	1540(ra) # 80005a44 <end_op>
    return -1;
    80007448:	fff00793          	li	a5,-1
    8000744c:	04c0006f          	j	80007498 <sys_link+0x184>
    iunlockput(dp);
    80007450:	00090513          	mv	a0,s2
    80007454:	ffffe097          	auipc	ra,0xffffe
    80007458:	ac4080e7          	jalr	-1340(ra) # 80004f18 <iunlockput>
  ilock(ip);
    8000745c:	00048513          	mv	a0,s1
    80007460:	ffffd097          	auipc	ra,0xffffd
    80007464:	77c080e7          	jalr	1916(ra) # 80004bdc <ilock>
  ip->nlink--;
    80007468:	04a4d783          	lhu	a5,74(s1)
    8000746c:	fff7879b          	addw	a5,a5,-1
    80007470:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80007474:	00048513          	mv	a0,s1
    80007478:	ffffd097          	auipc	ra,0xffffd
    8000747c:	648080e7          	jalr	1608(ra) # 80004ac0 <iupdate>
  iunlockput(ip);
    80007480:	00048513          	mv	a0,s1
    80007484:	ffffe097          	auipc	ra,0xffffe
    80007488:	a94080e7          	jalr	-1388(ra) # 80004f18 <iunlockput>
  end_op();
    8000748c:	ffffe097          	auipc	ra,0xffffe
    80007490:	5b8080e7          	jalr	1464(ra) # 80005a44 <end_op>
  return -1;
    80007494:	fff00793          	li	a5,-1
}
    80007498:	00078513          	mv	a0,a5
    8000749c:	12813083          	ld	ra,296(sp)
    800074a0:	12013403          	ld	s0,288(sp)
    800074a4:	11813483          	ld	s1,280(sp)
    800074a8:	11013903          	ld	s2,272(sp)
    800074ac:	13010113          	add	sp,sp,304
    800074b0:	00008067          	ret

00000000800074b4 <sys_unlink>:
{
    800074b4:	f1010113          	add	sp,sp,-240
    800074b8:	0e113423          	sd	ra,232(sp)
    800074bc:	0e813023          	sd	s0,224(sp)
    800074c0:	0c913c23          	sd	s1,216(sp)
    800074c4:	0d213823          	sd	s2,208(sp)
    800074c8:	0d313423          	sd	s3,200(sp)
    800074cc:	0f010413          	add	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800074d0:	08000613          	li	a2,128
    800074d4:	f3040593          	add	a1,s0,-208
    800074d8:	00000513          	li	a0,0
    800074dc:	ffffc097          	auipc	ra,0xffffc
    800074e0:	7d4080e7          	jalr	2004(ra) # 80003cb0 <argstr>
    800074e4:	1c054063          	bltz	a0,800076a4 <sys_unlink+0x1f0>
  begin_op();
    800074e8:	ffffe097          	auipc	ra,0xffffe
    800074ec:	4ac080e7          	jalr	1196(ra) # 80005994 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800074f0:	fb040593          	add	a1,s0,-80
    800074f4:	f3040513          	add	a0,s0,-208
    800074f8:	ffffe097          	auipc	ra,0xffffe
    800074fc:	1f8080e7          	jalr	504(ra) # 800056f0 <nameiparent>
    80007500:	00050493          	mv	s1,a0
    80007504:	0e050c63          	beqz	a0,800075fc <sys_unlink+0x148>
  ilock(dp);
    80007508:	ffffd097          	auipc	ra,0xffffd
    8000750c:	6d4080e7          	jalr	1748(ra) # 80004bdc <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80007510:	00003597          	auipc	a1,0x3
    80007514:	29858593          	add	a1,a1,664 # 8000a7a8 <syscalls+0x2a0>
    80007518:	fb040513          	add	a0,s0,-80
    8000751c:	ffffe097          	auipc	ra,0xffffe
    80007520:	d88080e7          	jalr	-632(ra) # 800052a4 <namecmp>
    80007524:	18050a63          	beqz	a0,800076b8 <sys_unlink+0x204>
    80007528:	00003597          	auipc	a1,0x3
    8000752c:	28858593          	add	a1,a1,648 # 8000a7b0 <syscalls+0x2a8>
    80007530:	fb040513          	add	a0,s0,-80
    80007534:	ffffe097          	auipc	ra,0xffffe
    80007538:	d70080e7          	jalr	-656(ra) # 800052a4 <namecmp>
    8000753c:	16050e63          	beqz	a0,800076b8 <sys_unlink+0x204>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80007540:	f2c40613          	add	a2,s0,-212
    80007544:	fb040593          	add	a1,s0,-80
    80007548:	00048513          	mv	a0,s1
    8000754c:	ffffe097          	auipc	ra,0xffffe
    80007550:	d84080e7          	jalr	-636(ra) # 800052d0 <dirlookup>
    80007554:	00050913          	mv	s2,a0
    80007558:	16050063          	beqz	a0,800076b8 <sys_unlink+0x204>
  ilock(ip);
    8000755c:	ffffd097          	auipc	ra,0xffffd
    80007560:	680080e7          	jalr	1664(ra) # 80004bdc <ilock>
  if(ip->nlink < 1)
    80007564:	04a91783          	lh	a5,74(s2)
    80007568:	0af05263          	blez	a5,8000760c <sys_unlink+0x158>
  if(ip->type == T_DIR && !isdirempty(ip)){
    8000756c:	04491703          	lh	a4,68(s2)
    80007570:	00100793          	li	a5,1
    80007574:	0af70463          	beq	a4,a5,8000761c <sys_unlink+0x168>
  memset(&de, 0, sizeof(de));
    80007578:	01000613          	li	a2,16
    8000757c:	00000593          	li	a1,0
    80007580:	fc040513          	add	a0,s0,-64
    80007584:	ffffa097          	auipc	ra,0xffffa
    80007588:	b98080e7          	jalr	-1128(ra) # 8000111c <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000758c:	01000713          	li	a4,16
    80007590:	f2c42683          	lw	a3,-212(s0)
    80007594:	fc040613          	add	a2,s0,-64
    80007598:	00000593          	li	a1,0
    8000759c:	00048513          	mv	a0,s1
    800075a0:	ffffe097          	auipc	ra,0xffffe
    800075a4:	b68080e7          	jalr	-1176(ra) # 80005108 <writei>
    800075a8:	01000793          	li	a5,16
    800075ac:	0cf51663          	bne	a0,a5,80007678 <sys_unlink+0x1c4>
  if(ip->type == T_DIR){
    800075b0:	04491703          	lh	a4,68(s2)
    800075b4:	00100793          	li	a5,1
    800075b8:	0cf70863          	beq	a4,a5,80007688 <sys_unlink+0x1d4>
  iunlockput(dp);
    800075bc:	00048513          	mv	a0,s1
    800075c0:	ffffe097          	auipc	ra,0xffffe
    800075c4:	958080e7          	jalr	-1704(ra) # 80004f18 <iunlockput>
  ip->nlink--;
    800075c8:	04a95783          	lhu	a5,74(s2)
    800075cc:	fff7879b          	addw	a5,a5,-1
    800075d0:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800075d4:	00090513          	mv	a0,s2
    800075d8:	ffffd097          	auipc	ra,0xffffd
    800075dc:	4e8080e7          	jalr	1256(ra) # 80004ac0 <iupdate>
  iunlockput(ip);
    800075e0:	00090513          	mv	a0,s2
    800075e4:	ffffe097          	auipc	ra,0xffffe
    800075e8:	934080e7          	jalr	-1740(ra) # 80004f18 <iunlockput>
  end_op();
    800075ec:	ffffe097          	auipc	ra,0xffffe
    800075f0:	458080e7          	jalr	1112(ra) # 80005a44 <end_op>
  return 0;
    800075f4:	00000513          	li	a0,0
    800075f8:	0d80006f          	j	800076d0 <sys_unlink+0x21c>
    end_op();
    800075fc:	ffffe097          	auipc	ra,0xffffe
    80007600:	448080e7          	jalr	1096(ra) # 80005a44 <end_op>
    return -1;
    80007604:	fff00513          	li	a0,-1
    80007608:	0c80006f          	j	800076d0 <sys_unlink+0x21c>
    panic("unlink: nlink < 1");
    8000760c:	00003517          	auipc	a0,0x3
    80007610:	1ac50513          	add	a0,a0,428 # 8000a7b8 <syscalls+0x2b0>
    80007614:	ffff9097          	auipc	ra,0xffff9
    80007618:	0b4080e7          	jalr	180(ra) # 800006c8 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000761c:	04c92703          	lw	a4,76(s2)
    80007620:	02000793          	li	a5,32
    80007624:	f4e7fae3          	bgeu	a5,a4,80007578 <sys_unlink+0xc4>
    80007628:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000762c:	01000713          	li	a4,16
    80007630:	00098693          	mv	a3,s3
    80007634:	f1840613          	add	a2,s0,-232
    80007638:	00000593          	li	a1,0
    8000763c:	00090513          	mv	a0,s2
    80007640:	ffffe097          	auipc	ra,0xffffe
    80007644:	958080e7          	jalr	-1704(ra) # 80004f98 <readi>
    80007648:	01000793          	li	a5,16
    8000764c:	00f51e63          	bne	a0,a5,80007668 <sys_unlink+0x1b4>
    if(de.inum != 0)
    80007650:	f1845783          	lhu	a5,-232(s0)
    80007654:	04079c63          	bnez	a5,800076ac <sys_unlink+0x1f8>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80007658:	0109899b          	addw	s3,s3,16
    8000765c:	04c92783          	lw	a5,76(s2)
    80007660:	fcf9e6e3          	bltu	s3,a5,8000762c <sys_unlink+0x178>
    80007664:	f15ff06f          	j	80007578 <sys_unlink+0xc4>
      panic("isdirempty: readi");
    80007668:	00003517          	auipc	a0,0x3
    8000766c:	16850513          	add	a0,a0,360 # 8000a7d0 <syscalls+0x2c8>
    80007670:	ffff9097          	auipc	ra,0xffff9
    80007674:	058080e7          	jalr	88(ra) # 800006c8 <panic>
    panic("unlink: writei");
    80007678:	00003517          	auipc	a0,0x3
    8000767c:	17050513          	add	a0,a0,368 # 8000a7e8 <syscalls+0x2e0>
    80007680:	ffff9097          	auipc	ra,0xffff9
    80007684:	048080e7          	jalr	72(ra) # 800006c8 <panic>
    dp->nlink--;
    80007688:	04a4d783          	lhu	a5,74(s1)
    8000768c:	fff7879b          	addw	a5,a5,-1
    80007690:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80007694:	00048513          	mv	a0,s1
    80007698:	ffffd097          	auipc	ra,0xffffd
    8000769c:	428080e7          	jalr	1064(ra) # 80004ac0 <iupdate>
    800076a0:	f1dff06f          	j	800075bc <sys_unlink+0x108>
    return -1;
    800076a4:	fff00513          	li	a0,-1
    800076a8:	0280006f          	j	800076d0 <sys_unlink+0x21c>
    iunlockput(ip);
    800076ac:	00090513          	mv	a0,s2
    800076b0:	ffffe097          	auipc	ra,0xffffe
    800076b4:	868080e7          	jalr	-1944(ra) # 80004f18 <iunlockput>
  iunlockput(dp);
    800076b8:	00048513          	mv	a0,s1
    800076bc:	ffffe097          	auipc	ra,0xffffe
    800076c0:	85c080e7          	jalr	-1956(ra) # 80004f18 <iunlockput>
  end_op();
    800076c4:	ffffe097          	auipc	ra,0xffffe
    800076c8:	380080e7          	jalr	896(ra) # 80005a44 <end_op>
  return -1;
    800076cc:	fff00513          	li	a0,-1
}
    800076d0:	0e813083          	ld	ra,232(sp)
    800076d4:	0e013403          	ld	s0,224(sp)
    800076d8:	0d813483          	ld	s1,216(sp)
    800076dc:	0d013903          	ld	s2,208(sp)
    800076e0:	0c813983          	ld	s3,200(sp)
    800076e4:	0f010113          	add	sp,sp,240
    800076e8:	00008067          	ret

00000000800076ec <sys_open>:

uint64
sys_open(void)
{
    800076ec:	f4010113          	add	sp,sp,-192
    800076f0:	0a113c23          	sd	ra,184(sp)
    800076f4:	0a813823          	sd	s0,176(sp)
    800076f8:	0a913423          	sd	s1,168(sp)
    800076fc:	0b213023          	sd	s2,160(sp)
    80007700:	09313c23          	sd	s3,152(sp)
    80007704:	0c010413          	add	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80007708:	f4c40593          	add	a1,s0,-180
    8000770c:	00100513          	li	a0,1
    80007710:	ffffc097          	auipc	ra,0xffffc
    80007714:	530080e7          	jalr	1328(ra) # 80003c40 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80007718:	08000613          	li	a2,128
    8000771c:	f5040593          	add	a1,s0,-176
    80007720:	00000513          	li	a0,0
    80007724:	ffffc097          	auipc	ra,0xffffc
    80007728:	58c080e7          	jalr	1420(ra) # 80003cb0 <argstr>
    8000772c:	00050793          	mv	a5,a0
    return -1;
    80007730:	fff00513          	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80007734:	0c07ca63          	bltz	a5,80007808 <sys_open+0x11c>

  begin_op();
    80007738:	ffffe097          	auipc	ra,0xffffe
    8000773c:	25c080e7          	jalr	604(ra) # 80005994 <begin_op>

  if(omode & O_CREATE){
    80007740:	f4c42783          	lw	a5,-180(s0)
    80007744:	2007f793          	and	a5,a5,512
    80007748:	0e078663          	beqz	a5,80007834 <sys_open+0x148>
    ip = create(path, T_FILE, 0, 0);
    8000774c:	00000693          	li	a3,0
    80007750:	00000613          	li	a2,0
    80007754:	00200593          	li	a1,2
    80007758:	f5040513          	add	a0,s0,-176
    8000775c:	fffff097          	auipc	ra,0xfffff
    80007760:	784080e7          	jalr	1924(ra) # 80006ee0 <create>
    80007764:	00050493          	mv	s1,a0
    if(ip == 0){
    80007768:	0a050e63          	beqz	a0,80007824 <sys_open+0x138>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    8000776c:	04449703          	lh	a4,68(s1)
    80007770:	00300793          	li	a5,3
    80007774:	00f71863          	bne	a4,a5,80007784 <sys_open+0x98>
    80007778:	0464d703          	lhu	a4,70(s1)
    8000777c:	00900793          	li	a5,9
    80007780:	10e7e863          	bltu	a5,a4,80007890 <sys_open+0x1a4>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80007784:	ffffe097          	auipc	ra,0xffffe
    80007788:	79c080e7          	jalr	1948(ra) # 80005f20 <filealloc>
    8000778c:	00050913          	mv	s2,a0
    80007790:	12050463          	beqz	a0,800078b8 <sys_open+0x1cc>
    80007794:	fffff097          	auipc	ra,0xfffff
    80007798:	6dc080e7          	jalr	1756(ra) # 80006e70 <fdalloc>
    8000779c:	00050993          	mv	s3,a0
    800077a0:	10054663          	bltz	a0,800078ac <sys_open+0x1c0>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    800077a4:	04449703          	lh	a4,68(s1)
    800077a8:	00300793          	li	a5,3
    800077ac:	12f70463          	beq	a4,a5,800078d4 <sys_open+0x1e8>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    800077b0:	00200793          	li	a5,2
    800077b4:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    800077b8:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    800077bc:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    800077c0:	f4c42783          	lw	a5,-180(s0)
    800077c4:	0017c713          	xor	a4,a5,1
    800077c8:	00177713          	and	a4,a4,1
    800077cc:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800077d0:	0037f713          	and	a4,a5,3
    800077d4:	00e03733          	snez	a4,a4
    800077d8:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    800077dc:	4007f793          	and	a5,a5,1024
    800077e0:	00078863          	beqz	a5,800077f0 <sys_open+0x104>
    800077e4:	04449703          	lh	a4,68(s1)
    800077e8:	00200793          	li	a5,2
    800077ec:	0ef70c63          	beq	a4,a5,800078e4 <sys_open+0x1f8>
    itrunc(ip);
  }

  iunlock(ip);
    800077f0:	00048513          	mv	a0,s1
    800077f4:	ffffd097          	auipc	ra,0xffffd
    800077f8:	4ec080e7          	jalr	1260(ra) # 80004ce0 <iunlock>
  end_op();
    800077fc:	ffffe097          	auipc	ra,0xffffe
    80007800:	248080e7          	jalr	584(ra) # 80005a44 <end_op>

  return fd;
    80007804:	00098513          	mv	a0,s3
}
    80007808:	0b813083          	ld	ra,184(sp)
    8000780c:	0b013403          	ld	s0,176(sp)
    80007810:	0a813483          	ld	s1,168(sp)
    80007814:	0a013903          	ld	s2,160(sp)
    80007818:	09813983          	ld	s3,152(sp)
    8000781c:	0c010113          	add	sp,sp,192
    80007820:	00008067          	ret
      end_op();
    80007824:	ffffe097          	auipc	ra,0xffffe
    80007828:	220080e7          	jalr	544(ra) # 80005a44 <end_op>
      return -1;
    8000782c:	fff00513          	li	a0,-1
    80007830:	fd9ff06f          	j	80007808 <sys_open+0x11c>
    if((ip = namei(path)) == 0){
    80007834:	f5040513          	add	a0,s0,-176
    80007838:	ffffe097          	auipc	ra,0xffffe
    8000783c:	e88080e7          	jalr	-376(ra) # 800056c0 <namei>
    80007840:	00050493          	mv	s1,a0
    80007844:	02050e63          	beqz	a0,80007880 <sys_open+0x194>
    ilock(ip);
    80007848:	ffffd097          	auipc	ra,0xffffd
    8000784c:	394080e7          	jalr	916(ra) # 80004bdc <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80007850:	04449703          	lh	a4,68(s1)
    80007854:	00100793          	li	a5,1
    80007858:	f0f71ae3          	bne	a4,a5,8000776c <sys_open+0x80>
    8000785c:	f4c42783          	lw	a5,-180(s0)
    80007860:	f20782e3          	beqz	a5,80007784 <sys_open+0x98>
      iunlockput(ip);
    80007864:	00048513          	mv	a0,s1
    80007868:	ffffd097          	auipc	ra,0xffffd
    8000786c:	6b0080e7          	jalr	1712(ra) # 80004f18 <iunlockput>
      end_op();
    80007870:	ffffe097          	auipc	ra,0xffffe
    80007874:	1d4080e7          	jalr	468(ra) # 80005a44 <end_op>
      return -1;
    80007878:	fff00513          	li	a0,-1
    8000787c:	f8dff06f          	j	80007808 <sys_open+0x11c>
      end_op();
    80007880:	ffffe097          	auipc	ra,0xffffe
    80007884:	1c4080e7          	jalr	452(ra) # 80005a44 <end_op>
      return -1;
    80007888:	fff00513          	li	a0,-1
    8000788c:	f7dff06f          	j	80007808 <sys_open+0x11c>
    iunlockput(ip);
    80007890:	00048513          	mv	a0,s1
    80007894:	ffffd097          	auipc	ra,0xffffd
    80007898:	684080e7          	jalr	1668(ra) # 80004f18 <iunlockput>
    end_op();
    8000789c:	ffffe097          	auipc	ra,0xffffe
    800078a0:	1a8080e7          	jalr	424(ra) # 80005a44 <end_op>
    return -1;
    800078a4:	fff00513          	li	a0,-1
    800078a8:	f61ff06f          	j	80007808 <sys_open+0x11c>
      fileclose(f);
    800078ac:	00090513          	mv	a0,s2
    800078b0:	ffffe097          	auipc	ra,0xffffe
    800078b4:	76c080e7          	jalr	1900(ra) # 8000601c <fileclose>
    iunlockput(ip);
    800078b8:	00048513          	mv	a0,s1
    800078bc:	ffffd097          	auipc	ra,0xffffd
    800078c0:	65c080e7          	jalr	1628(ra) # 80004f18 <iunlockput>
    end_op();
    800078c4:	ffffe097          	auipc	ra,0xffffe
    800078c8:	180080e7          	jalr	384(ra) # 80005a44 <end_op>
    return -1;
    800078cc:	fff00513          	li	a0,-1
    800078d0:	f39ff06f          	j	80007808 <sys_open+0x11c>
    f->type = FD_DEVICE;
    800078d4:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    800078d8:	04649783          	lh	a5,70(s1)
    800078dc:	02f91223          	sh	a5,36(s2)
    800078e0:	eddff06f          	j	800077bc <sys_open+0xd0>
    itrunc(ip);
    800078e4:	00048513          	mv	a0,s1
    800078e8:	ffffd097          	auipc	ra,0xffffd
    800078ec:	468080e7          	jalr	1128(ra) # 80004d50 <itrunc>
    800078f0:	f01ff06f          	j	800077f0 <sys_open+0x104>

00000000800078f4 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    800078f4:	f7010113          	add	sp,sp,-144
    800078f8:	08113423          	sd	ra,136(sp)
    800078fc:	08813023          	sd	s0,128(sp)
    80007900:	09010413          	add	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80007904:	ffffe097          	auipc	ra,0xffffe
    80007908:	090080e7          	jalr	144(ra) # 80005994 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    8000790c:	08000613          	li	a2,128
    80007910:	f7040593          	add	a1,s0,-144
    80007914:	00000513          	li	a0,0
    80007918:	ffffc097          	auipc	ra,0xffffc
    8000791c:	398080e7          	jalr	920(ra) # 80003cb0 <argstr>
    80007920:	04054263          	bltz	a0,80007964 <sys_mkdir+0x70>
    80007924:	00000693          	li	a3,0
    80007928:	00000613          	li	a2,0
    8000792c:	00100593          	li	a1,1
    80007930:	f7040513          	add	a0,s0,-144
    80007934:	fffff097          	auipc	ra,0xfffff
    80007938:	5ac080e7          	jalr	1452(ra) # 80006ee0 <create>
    8000793c:	02050463          	beqz	a0,80007964 <sys_mkdir+0x70>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80007940:	ffffd097          	auipc	ra,0xffffd
    80007944:	5d8080e7          	jalr	1496(ra) # 80004f18 <iunlockput>
  end_op();
    80007948:	ffffe097          	auipc	ra,0xffffe
    8000794c:	0fc080e7          	jalr	252(ra) # 80005a44 <end_op>
  return 0;
    80007950:	00000513          	li	a0,0
}
    80007954:	08813083          	ld	ra,136(sp)
    80007958:	08013403          	ld	s0,128(sp)
    8000795c:	09010113          	add	sp,sp,144
    80007960:	00008067          	ret
    end_op();
    80007964:	ffffe097          	auipc	ra,0xffffe
    80007968:	0e0080e7          	jalr	224(ra) # 80005a44 <end_op>
    return -1;
    8000796c:	fff00513          	li	a0,-1
    80007970:	fe5ff06f          	j	80007954 <sys_mkdir+0x60>

0000000080007974 <sys_mknod>:

uint64
sys_mknod(void)
{
    80007974:	f6010113          	add	sp,sp,-160
    80007978:	08113c23          	sd	ra,152(sp)
    8000797c:	08813823          	sd	s0,144(sp)
    80007980:	0a010413          	add	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80007984:	ffffe097          	auipc	ra,0xffffe
    80007988:	010080e7          	jalr	16(ra) # 80005994 <begin_op>
  argint(1, &major);
    8000798c:	f6c40593          	add	a1,s0,-148
    80007990:	00100513          	li	a0,1
    80007994:	ffffc097          	auipc	ra,0xffffc
    80007998:	2ac080e7          	jalr	684(ra) # 80003c40 <argint>
  argint(2, &minor);
    8000799c:	f6840593          	add	a1,s0,-152
    800079a0:	00200513          	li	a0,2
    800079a4:	ffffc097          	auipc	ra,0xffffc
    800079a8:	29c080e7          	jalr	668(ra) # 80003c40 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800079ac:	08000613          	li	a2,128
    800079b0:	f7040593          	add	a1,s0,-144
    800079b4:	00000513          	li	a0,0
    800079b8:	ffffc097          	auipc	ra,0xffffc
    800079bc:	2f8080e7          	jalr	760(ra) # 80003cb0 <argstr>
    800079c0:	04054263          	bltz	a0,80007a04 <sys_mknod+0x90>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800079c4:	f6841683          	lh	a3,-152(s0)
    800079c8:	f6c41603          	lh	a2,-148(s0)
    800079cc:	00300593          	li	a1,3
    800079d0:	f7040513          	add	a0,s0,-144
    800079d4:	fffff097          	auipc	ra,0xfffff
    800079d8:	50c080e7          	jalr	1292(ra) # 80006ee0 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800079dc:	02050463          	beqz	a0,80007a04 <sys_mknod+0x90>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800079e0:	ffffd097          	auipc	ra,0xffffd
    800079e4:	538080e7          	jalr	1336(ra) # 80004f18 <iunlockput>
  end_op();
    800079e8:	ffffe097          	auipc	ra,0xffffe
    800079ec:	05c080e7          	jalr	92(ra) # 80005a44 <end_op>
  return 0;
    800079f0:	00000513          	li	a0,0
}
    800079f4:	09813083          	ld	ra,152(sp)
    800079f8:	09013403          	ld	s0,144(sp)
    800079fc:	0a010113          	add	sp,sp,160
    80007a00:	00008067          	ret
    end_op();
    80007a04:	ffffe097          	auipc	ra,0xffffe
    80007a08:	040080e7          	jalr	64(ra) # 80005a44 <end_op>
    return -1;
    80007a0c:	fff00513          	li	a0,-1
    80007a10:	fe5ff06f          	j	800079f4 <sys_mknod+0x80>

0000000080007a14 <sys_chdir>:

uint64
sys_chdir(void)
{
    80007a14:	f6010113          	add	sp,sp,-160
    80007a18:	08113c23          	sd	ra,152(sp)
    80007a1c:	08813823          	sd	s0,144(sp)
    80007a20:	08913423          	sd	s1,136(sp)
    80007a24:	09213023          	sd	s2,128(sp)
    80007a28:	0a010413          	add	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80007a2c:	ffffb097          	auipc	ra,0xffffb
    80007a30:	a28080e7          	jalr	-1496(ra) # 80002454 <myproc>
    80007a34:	00050913          	mv	s2,a0
  
  begin_op();
    80007a38:	ffffe097          	auipc	ra,0xffffe
    80007a3c:	f5c080e7          	jalr	-164(ra) # 80005994 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80007a40:	08000613          	li	a2,128
    80007a44:	f6040593          	add	a1,s0,-160
    80007a48:	00000513          	li	a0,0
    80007a4c:	ffffc097          	auipc	ra,0xffffc
    80007a50:	264080e7          	jalr	612(ra) # 80003cb0 <argstr>
    80007a54:	06054663          	bltz	a0,80007ac0 <sys_chdir+0xac>
    80007a58:	f6040513          	add	a0,s0,-160
    80007a5c:	ffffe097          	auipc	ra,0xffffe
    80007a60:	c64080e7          	jalr	-924(ra) # 800056c0 <namei>
    80007a64:	00050493          	mv	s1,a0
    80007a68:	04050c63          	beqz	a0,80007ac0 <sys_chdir+0xac>
    end_op();
    return -1;
  }
  ilock(ip);
    80007a6c:	ffffd097          	auipc	ra,0xffffd
    80007a70:	170080e7          	jalr	368(ra) # 80004bdc <ilock>
  if(ip->type != T_DIR){
    80007a74:	04449703          	lh	a4,68(s1)
    80007a78:	00100793          	li	a5,1
    80007a7c:	04f71a63          	bne	a4,a5,80007ad0 <sys_chdir+0xbc>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80007a80:	00048513          	mv	a0,s1
    80007a84:	ffffd097          	auipc	ra,0xffffd
    80007a88:	25c080e7          	jalr	604(ra) # 80004ce0 <iunlock>
  iput(p->cwd);
    80007a8c:	15093503          	ld	a0,336(s2)
    80007a90:	ffffd097          	auipc	ra,0xffffd
    80007a94:	3ac080e7          	jalr	940(ra) # 80004e3c <iput>
  end_op();
    80007a98:	ffffe097          	auipc	ra,0xffffe
    80007a9c:	fac080e7          	jalr	-84(ra) # 80005a44 <end_op>
  p->cwd = ip;
    80007aa0:	14993823          	sd	s1,336(s2)
  return 0;
    80007aa4:	00000513          	li	a0,0
}
    80007aa8:	09813083          	ld	ra,152(sp)
    80007aac:	09013403          	ld	s0,144(sp)
    80007ab0:	08813483          	ld	s1,136(sp)
    80007ab4:	08013903          	ld	s2,128(sp)
    80007ab8:	0a010113          	add	sp,sp,160
    80007abc:	00008067          	ret
    end_op();
    80007ac0:	ffffe097          	auipc	ra,0xffffe
    80007ac4:	f84080e7          	jalr	-124(ra) # 80005a44 <end_op>
    return -1;
    80007ac8:	fff00513          	li	a0,-1
    80007acc:	fddff06f          	j	80007aa8 <sys_chdir+0x94>
    iunlockput(ip);
    80007ad0:	00048513          	mv	a0,s1
    80007ad4:	ffffd097          	auipc	ra,0xffffd
    80007ad8:	444080e7          	jalr	1092(ra) # 80004f18 <iunlockput>
    end_op();
    80007adc:	ffffe097          	auipc	ra,0xffffe
    80007ae0:	f68080e7          	jalr	-152(ra) # 80005a44 <end_op>
    return -1;
    80007ae4:	fff00513          	li	a0,-1
    80007ae8:	fc1ff06f          	j	80007aa8 <sys_chdir+0x94>

0000000080007aec <sys_exec>:

uint64
sys_exec(void)
{
    80007aec:	e4010113          	add	sp,sp,-448
    80007af0:	1a113c23          	sd	ra,440(sp)
    80007af4:	1a813823          	sd	s0,432(sp)
    80007af8:	1a913423          	sd	s1,424(sp)
    80007afc:	1b213023          	sd	s2,416(sp)
    80007b00:	19313c23          	sd	s3,408(sp)
    80007b04:	19413823          	sd	s4,400(sp)
    80007b08:	1c010413          	add	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80007b0c:	e4840593          	add	a1,s0,-440
    80007b10:	00100513          	li	a0,1
    80007b14:	ffffc097          	auipc	ra,0xffffc
    80007b18:	164080e7          	jalr	356(ra) # 80003c78 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80007b1c:	08000613          	li	a2,128
    80007b20:	f5040593          	add	a1,s0,-176
    80007b24:	00000513          	li	a0,0
    80007b28:	ffffc097          	auipc	ra,0xffffc
    80007b2c:	188080e7          	jalr	392(ra) # 80003cb0 <argstr>
    80007b30:	00050793          	mv	a5,a0
    return -1;
    80007b34:	fff00513          	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80007b38:	0e07ca63          	bltz	a5,80007c2c <sys_exec+0x140>
  }
  memset(argv, 0, sizeof(argv));
    80007b3c:	10000613          	li	a2,256
    80007b40:	00000593          	li	a1,0
    80007b44:	e5040513          	add	a0,s0,-432
    80007b48:	ffff9097          	auipc	ra,0xffff9
    80007b4c:	5d4080e7          	jalr	1492(ra) # 8000111c <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80007b50:	e5040493          	add	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80007b54:	00048993          	mv	s3,s1
    80007b58:	00000913          	li	s2,0
    if(i >= NELEM(argv)){
    80007b5c:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80007b60:	00391513          	sll	a0,s2,0x3
    80007b64:	e4040593          	add	a1,s0,-448
    80007b68:	e4843783          	ld	a5,-440(s0)
    80007b6c:	00f50533          	add	a0,a0,a5
    80007b70:	ffffc097          	auipc	ra,0xffffc
    80007b74:	fd4080e7          	jalr	-44(ra) # 80003b44 <fetchaddr>
    80007b78:	04054063          	bltz	a0,80007bb8 <sys_exec+0xcc>
      goto bad;
    }
    if(uarg == 0){
    80007b7c:	e4043783          	ld	a5,-448(s0)
    80007b80:	04078e63          	beqz	a5,80007bdc <sys_exec+0xf0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80007b84:	ffff9097          	auipc	ra,0xffff9
    80007b88:	2d4080e7          	jalr	724(ra) # 80000e58 <kalloc>
    80007b8c:	00050593          	mv	a1,a0
    80007b90:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80007b94:	02050263          	beqz	a0,80007bb8 <sys_exec+0xcc>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80007b98:	00001637          	lui	a2,0x1
    80007b9c:	e4043503          	ld	a0,-448(s0)
    80007ba0:	ffffc097          	auipc	ra,0xffffc
    80007ba4:	024080e7          	jalr	36(ra) # 80003bc4 <fetchstr>
    80007ba8:	00054863          	bltz	a0,80007bb8 <sys_exec+0xcc>
    if(i >= NELEM(argv)){
    80007bac:	00190913          	add	s2,s2,1
    80007bb0:	00898993          	add	s3,s3,8
    80007bb4:	fb4916e3          	bne	s2,s4,80007b60 <sys_exec+0x74>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80007bb8:	f5040913          	add	s2,s0,-176
    80007bbc:	0004b503          	ld	a0,0(s1)
    80007bc0:	06050463          	beqz	a0,80007c28 <sys_exec+0x13c>
    kfree(argv[i]);
    80007bc4:	ffff9097          	auipc	ra,0xffff9
    80007bc8:	128080e7          	jalr	296(ra) # 80000cec <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80007bcc:	00848493          	add	s1,s1,8
    80007bd0:	ff2496e3          	bne	s1,s2,80007bbc <sys_exec+0xd0>
  return -1;
    80007bd4:	fff00513          	li	a0,-1
    80007bd8:	0540006f          	j	80007c2c <sys_exec+0x140>
      argv[i] = 0;
    80007bdc:	0009079b          	sext.w	a5,s2
    80007be0:	00379793          	sll	a5,a5,0x3
    80007be4:	fd078793          	add	a5,a5,-48
    80007be8:	008787b3          	add	a5,a5,s0
    80007bec:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80007bf0:	e5040593          	add	a1,s0,-432
    80007bf4:	f5040513          	add	a0,s0,-176
    80007bf8:	fffff097          	auipc	ra,0xfffff
    80007bfc:	d38080e7          	jalr	-712(ra) # 80006930 <exec>
    80007c00:	00050913          	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80007c04:	f5040993          	add	s3,s0,-176
    80007c08:	0004b503          	ld	a0,0(s1)
    80007c0c:	00050a63          	beqz	a0,80007c20 <sys_exec+0x134>
    kfree(argv[i]);
    80007c10:	ffff9097          	auipc	ra,0xffff9
    80007c14:	0dc080e7          	jalr	220(ra) # 80000cec <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80007c18:	00848493          	add	s1,s1,8
    80007c1c:	ff3496e3          	bne	s1,s3,80007c08 <sys_exec+0x11c>
  return ret;
    80007c20:	00090513          	mv	a0,s2
    80007c24:	0080006f          	j	80007c2c <sys_exec+0x140>
  return -1;
    80007c28:	fff00513          	li	a0,-1
}
    80007c2c:	1b813083          	ld	ra,440(sp)
    80007c30:	1b013403          	ld	s0,432(sp)
    80007c34:	1a813483          	ld	s1,424(sp)
    80007c38:	1a013903          	ld	s2,416(sp)
    80007c3c:	19813983          	ld	s3,408(sp)
    80007c40:	19013a03          	ld	s4,400(sp)
    80007c44:	1c010113          	add	sp,sp,448
    80007c48:	00008067          	ret

0000000080007c4c <sys_pipe>:

uint64
sys_pipe(void)
{
    80007c4c:	fc010113          	add	sp,sp,-64
    80007c50:	02113c23          	sd	ra,56(sp)
    80007c54:	02813823          	sd	s0,48(sp)
    80007c58:	02913423          	sd	s1,40(sp)
    80007c5c:	04010413          	add	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80007c60:	ffffa097          	auipc	ra,0xffffa
    80007c64:	7f4080e7          	jalr	2036(ra) # 80002454 <myproc>
    80007c68:	00050493          	mv	s1,a0

  argaddr(0, &fdarray);
    80007c6c:	fd840593          	add	a1,s0,-40
    80007c70:	00000513          	li	a0,0
    80007c74:	ffffc097          	auipc	ra,0xffffc
    80007c78:	004080e7          	jalr	4(ra) # 80003c78 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80007c7c:	fc840593          	add	a1,s0,-56
    80007c80:	fd040513          	add	a0,s0,-48
    80007c84:	fffff097          	auipc	ra,0xfffff
    80007c88:	81c080e7          	jalr	-2020(ra) # 800064a0 <pipealloc>
    return -1;
    80007c8c:	fff00793          	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80007c90:	0e054663          	bltz	a0,80007d7c <sys_pipe+0x130>
  fd0 = -1;
    80007c94:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80007c98:	fd043503          	ld	a0,-48(s0)
    80007c9c:	fffff097          	auipc	ra,0xfffff
    80007ca0:	1d4080e7          	jalr	468(ra) # 80006e70 <fdalloc>
    80007ca4:	fca42223          	sw	a0,-60(s0)
    80007ca8:	0a054c63          	bltz	a0,80007d60 <sys_pipe+0x114>
    80007cac:	fc843503          	ld	a0,-56(s0)
    80007cb0:	fffff097          	auipc	ra,0xfffff
    80007cb4:	1c0080e7          	jalr	448(ra) # 80006e70 <fdalloc>
    80007cb8:	fca42023          	sw	a0,-64(s0)
    80007cbc:	08054663          	bltz	a0,80007d48 <sys_pipe+0xfc>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80007cc0:	00400693          	li	a3,4
    80007cc4:	fc440613          	add	a2,s0,-60
    80007cc8:	fd843583          	ld	a1,-40(s0)
    80007ccc:	0504b503          	ld	a0,80(s1)
    80007cd0:	ffffa097          	auipc	ra,0xffffa
    80007cd4:	280080e7          	jalr	640(ra) # 80001f50 <copyout>
    80007cd8:	02054463          	bltz	a0,80007d00 <sys_pipe+0xb4>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80007cdc:	00400693          	li	a3,4
    80007ce0:	fc040613          	add	a2,s0,-64
    80007ce4:	fd843583          	ld	a1,-40(s0)
    80007ce8:	00458593          	add	a1,a1,4
    80007cec:	0504b503          	ld	a0,80(s1)
    80007cf0:	ffffa097          	auipc	ra,0xffffa
    80007cf4:	260080e7          	jalr	608(ra) # 80001f50 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80007cf8:	00000793          	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80007cfc:	08055063          	bgez	a0,80007d7c <sys_pipe+0x130>
    p->ofile[fd0] = 0;
    80007d00:	fc442783          	lw	a5,-60(s0)
    80007d04:	01a78793          	add	a5,a5,26
    80007d08:	00379793          	sll	a5,a5,0x3
    80007d0c:	00f487b3          	add	a5,s1,a5
    80007d10:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80007d14:	fc042783          	lw	a5,-64(s0)
    80007d18:	01a78793          	add	a5,a5,26
    80007d1c:	00379793          	sll	a5,a5,0x3
    80007d20:	00f484b3          	add	s1,s1,a5
    80007d24:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80007d28:	fd043503          	ld	a0,-48(s0)
    80007d2c:	ffffe097          	auipc	ra,0xffffe
    80007d30:	2f0080e7          	jalr	752(ra) # 8000601c <fileclose>
    fileclose(wf);
    80007d34:	fc843503          	ld	a0,-56(s0)
    80007d38:	ffffe097          	auipc	ra,0xffffe
    80007d3c:	2e4080e7          	jalr	740(ra) # 8000601c <fileclose>
    return -1;
    80007d40:	fff00793          	li	a5,-1
    80007d44:	0380006f          	j	80007d7c <sys_pipe+0x130>
    if(fd0 >= 0)
    80007d48:	fc442783          	lw	a5,-60(s0)
    80007d4c:	0007ca63          	bltz	a5,80007d60 <sys_pipe+0x114>
      p->ofile[fd0] = 0;
    80007d50:	01a78793          	add	a5,a5,26
    80007d54:	00379793          	sll	a5,a5,0x3
    80007d58:	00f487b3          	add	a5,s1,a5
    80007d5c:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80007d60:	fd043503          	ld	a0,-48(s0)
    80007d64:	ffffe097          	auipc	ra,0xffffe
    80007d68:	2b8080e7          	jalr	696(ra) # 8000601c <fileclose>
    fileclose(wf);
    80007d6c:	fc843503          	ld	a0,-56(s0)
    80007d70:	ffffe097          	auipc	ra,0xffffe
    80007d74:	2ac080e7          	jalr	684(ra) # 8000601c <fileclose>
    return -1;
    80007d78:	fff00793          	li	a5,-1
}
    80007d7c:	00078513          	mv	a0,a5
    80007d80:	03813083          	ld	ra,56(sp)
    80007d84:	03013403          	ld	s0,48(sp)
    80007d88:	02813483          	ld	s1,40(sp)
    80007d8c:	04010113          	add	sp,sp,64
    80007d90:	00008067          	ret
	...

0000000080007da0 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80007da0:	f0010113          	add	sp,sp,-256

        # save the registers.
        sd ra, 0(sp)
    80007da4:	00113023          	sd	ra,0(sp)
        sd sp, 8(sp)
    80007da8:	00213423          	sd	sp,8(sp)
        sd gp, 16(sp)
    80007dac:	00313823          	sd	gp,16(sp)
        sd tp, 24(sp)
    80007db0:	00413c23          	sd	tp,24(sp)
        sd t0, 32(sp)
    80007db4:	02513023          	sd	t0,32(sp)
        sd t1, 40(sp)
    80007db8:	02613423          	sd	t1,40(sp)
        sd t2, 48(sp)
    80007dbc:	02713823          	sd	t2,48(sp)
        sd s0, 56(sp)
    80007dc0:	02813c23          	sd	s0,56(sp)
        sd s1, 64(sp)
    80007dc4:	04913023          	sd	s1,64(sp)
        sd a0, 72(sp)
    80007dc8:	04a13423          	sd	a0,72(sp)
        sd a1, 80(sp)
    80007dcc:	04b13823          	sd	a1,80(sp)
        sd a2, 88(sp)
    80007dd0:	04c13c23          	sd	a2,88(sp)
        sd a3, 96(sp)
    80007dd4:	06d13023          	sd	a3,96(sp)
        sd a4, 104(sp)
    80007dd8:	06e13423          	sd	a4,104(sp)
        sd a5, 112(sp)
    80007ddc:	06f13823          	sd	a5,112(sp)
        sd a6, 120(sp)
    80007de0:	07013c23          	sd	a6,120(sp)
        sd a7, 128(sp)
    80007de4:	09113023          	sd	a7,128(sp)
        sd s2, 136(sp)
    80007de8:	09213423          	sd	s2,136(sp)
        sd s3, 144(sp)
    80007dec:	09313823          	sd	s3,144(sp)
        sd s4, 152(sp)
    80007df0:	09413c23          	sd	s4,152(sp)
        sd s5, 160(sp)
    80007df4:	0b513023          	sd	s5,160(sp)
        sd s6, 168(sp)
    80007df8:	0b613423          	sd	s6,168(sp)
        sd s7, 176(sp)
    80007dfc:	0b713823          	sd	s7,176(sp)
        sd s8, 184(sp)
    80007e00:	0b813c23          	sd	s8,184(sp)
        sd s9, 192(sp)
    80007e04:	0d913023          	sd	s9,192(sp)
        sd s10, 200(sp)
    80007e08:	0da13423          	sd	s10,200(sp)
        sd s11, 208(sp)
    80007e0c:	0db13823          	sd	s11,208(sp)
        sd t3, 216(sp)
    80007e10:	0dc13c23          	sd	t3,216(sp)
        sd t4, 224(sp)
    80007e14:	0fd13023          	sd	t4,224(sp)
        sd t5, 232(sp)
    80007e18:	0fe13423          	sd	t5,232(sp)
        sd t6, 240(sp)
    80007e1c:	0ff13823          	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    80007e20:	ffffc097          	auipc	ra,0xffffc
    80007e24:	b7c080e7          	jalr	-1156(ra) # 8000399c <kerneltrap>

        # restore registers.
        ld ra, 0(sp)
    80007e28:	00013083          	ld	ra,0(sp)
        ld sp, 8(sp)
    80007e2c:	00813103          	ld	sp,8(sp)
        ld gp, 16(sp)
    80007e30:	01013183          	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    80007e34:	02013283          	ld	t0,32(sp)
        ld t1, 40(sp)
    80007e38:	02813303          	ld	t1,40(sp)
        ld t2, 48(sp)
    80007e3c:	03013383          	ld	t2,48(sp)
        ld s0, 56(sp)
    80007e40:	03813403          	ld	s0,56(sp)
        ld s1, 64(sp)
    80007e44:	04013483          	ld	s1,64(sp)
        ld a0, 72(sp)
    80007e48:	04813503          	ld	a0,72(sp)
        ld a1, 80(sp)
    80007e4c:	05013583          	ld	a1,80(sp)
        ld a2, 88(sp)
    80007e50:	05813603          	ld	a2,88(sp)
        ld a3, 96(sp)
    80007e54:	06013683          	ld	a3,96(sp)
        ld a4, 104(sp)
    80007e58:	06813703          	ld	a4,104(sp)
        ld a5, 112(sp)
    80007e5c:	07013783          	ld	a5,112(sp)
        ld a6, 120(sp)
    80007e60:	07813803          	ld	a6,120(sp)
        ld a7, 128(sp)
    80007e64:	08013883          	ld	a7,128(sp)
        ld s2, 136(sp)
    80007e68:	08813903          	ld	s2,136(sp)
        ld s3, 144(sp)
    80007e6c:	09013983          	ld	s3,144(sp)
        ld s4, 152(sp)
    80007e70:	09813a03          	ld	s4,152(sp)
        ld s5, 160(sp)
    80007e74:	0a013a83          	ld	s5,160(sp)
        ld s6, 168(sp)
    80007e78:	0a813b03          	ld	s6,168(sp)
        ld s7, 176(sp)
    80007e7c:	0b013b83          	ld	s7,176(sp)
        ld s8, 184(sp)
    80007e80:	0b813c03          	ld	s8,184(sp)
        ld s9, 192(sp)
    80007e84:	0c013c83          	ld	s9,192(sp)
        ld s10, 200(sp)
    80007e88:	0c813d03          	ld	s10,200(sp)
        ld s11, 208(sp)
    80007e8c:	0d013d83          	ld	s11,208(sp)
        ld t3, 216(sp)
    80007e90:	0d813e03          	ld	t3,216(sp)
        ld t4, 224(sp)
    80007e94:	0e013e83          	ld	t4,224(sp)
        ld t5, 232(sp)
    80007e98:	0e813f03          	ld	t5,232(sp)
        ld t6, 240(sp)
    80007e9c:	0f013f83          	ld	t6,240(sp)

        addi sp, sp, 256
    80007ea0:	10010113          	add	sp,sp,256

        # return to whatever we were doing in the kernel.
        sret
    80007ea4:	10200073          	sret
    80007ea8:	00000013          	nop
    80007eac:	00000013          	nop

0000000080007eb0 <timervec>:
        # start.c has set up the memory that mscratch points to:
        # scratch[0,8,16] : register save area.
        # scratch[24] : address of CLINT's MTIMECMP register.
        # scratch[32] : desired interval between interrupts.
        
        csrrw a0, mscratch, a0
    80007eb0:	34051573          	csrrw	a0,mscratch,a0
        sd a1, 0(a0)
    80007eb4:	00b53023          	sd	a1,0(a0)
        sd a2, 8(a0)
    80007eb8:	00c53423          	sd	a2,8(a0)
        sd a3, 16(a0)
    80007ebc:	00d53823          	sd	a3,16(a0)

        # schedule the next timer interrupt
        # by adding interval to mtimecmp.
        ld a1, 24(a0) # CLINT_MTIMECMP(hart)
    80007ec0:	01853583          	ld	a1,24(a0)
        ld a2, 32(a0) # interval
    80007ec4:	02053603          	ld	a2,32(a0)
        ld a3, 0(a1)
    80007ec8:	0005b683          	ld	a3,0(a1)
        add a3, a3, a2
    80007ecc:	00c686b3          	add	a3,a3,a2
        sd a3, 0(a1)
    80007ed0:	00d5b023          	sd	a3,0(a1)

        # arrange for a supervisor software interrupt
        # after this handler returns.
        li a1, 2
    80007ed4:	00200593          	li	a1,2
        csrw sip, a1
    80007ed8:	14459073          	csrw	sip,a1

        ld a3, 16(a0)
    80007edc:	01053683          	ld	a3,16(a0)
        ld a2, 8(a0)
    80007ee0:	00853603          	ld	a2,8(a0)
        ld a1, 0(a0)
    80007ee4:	00053583          	ld	a1,0(a0)
        csrrw a0, mscratch, a0
    80007ee8:	34051573          	csrrw	a0,mscratch,a0

        mret
    80007eec:	30200073          	mret

0000000080007ef0 <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80007ef0:	ff010113          	add	sp,sp,-16
    80007ef4:	00813423          	sd	s0,8(sp)
    80007ef8:	01010413          	add	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  // UARTx_IRQ are the interrupt source numbers, each source gets 4 bytes
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80007efc:	0c0007b7          	lui	a5,0xc000
    80007f00:	00100713          	li	a4,1
    80007f04:	02e7a423          	sw	a4,40(a5) # c000028 <_entry-0x73ffffd8>
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80007f08:	00e7a223          	sw	a4,4(a5)
}
    80007f0c:	00813403          	ld	s0,8(sp)
    80007f10:	01010113          	add	sp,sp,16
    80007f14:	00008067          	ret

0000000080007f18 <plicinithart>:

void
plicinithart(void)
{
    80007f18:	ff010113          	add	sp,sp,-16
    80007f1c:	00113423          	sd	ra,8(sp)
    80007f20:	00813023          	sd	s0,0(sp)
    80007f24:	01010413          	add	s0,sp,16
  int hart = cpuid();
    80007f28:	ffffa097          	auipc	ra,0xffffa
    80007f2c:	4dc080e7          	jalr	1244(ra) # 80002404 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80007f30:	0085171b          	sllw	a4,a0,0x8
    80007f34:	0c0027b7          	lui	a5,0xc002
    80007f38:	00e787b3          	add	a5,a5,a4
    80007f3c:	40200713          	li	a4,1026
    80007f40:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80007f44:	00d5151b          	sllw	a0,a0,0xd
    80007f48:	0c2017b7          	lui	a5,0xc201
    80007f4c:	00a787b3          	add	a5,a5,a0
    80007f50:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80007f54:	00813083          	ld	ra,8(sp)
    80007f58:	00013403          	ld	s0,0(sp)
    80007f5c:	01010113          	add	sp,sp,16
    80007f60:	00008067          	ret

0000000080007f64 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80007f64:	ff010113          	add	sp,sp,-16
    80007f68:	00113423          	sd	ra,8(sp)
    80007f6c:	00813023          	sd	s0,0(sp)
    80007f70:	01010413          	add	s0,sp,16
  int hart = cpuid();
    80007f74:	ffffa097          	auipc	ra,0xffffa
    80007f78:	490080e7          	jalr	1168(ra) # 80002404 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80007f7c:	00d5151b          	sllw	a0,a0,0xd
    80007f80:	0c2017b7          	lui	a5,0xc201
    80007f84:	00a787b3          	add	a5,a5,a0
  return irq;
}
    80007f88:	0047a503          	lw	a0,4(a5) # c201004 <_entry-0x73dfeffc>
    80007f8c:	00813083          	ld	ra,8(sp)
    80007f90:	00013403          	ld	s0,0(sp)
    80007f94:	01010113          	add	sp,sp,16
    80007f98:	00008067          	ret

0000000080007f9c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80007f9c:	fe010113          	add	sp,sp,-32
    80007fa0:	00113c23          	sd	ra,24(sp)
    80007fa4:	00813823          	sd	s0,16(sp)
    80007fa8:	00913423          	sd	s1,8(sp)
    80007fac:	02010413          	add	s0,sp,32
    80007fb0:	00050493          	mv	s1,a0
  int hart = cpuid();
    80007fb4:	ffffa097          	auipc	ra,0xffffa
    80007fb8:	450080e7          	jalr	1104(ra) # 80002404 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80007fbc:	00d5151b          	sllw	a0,a0,0xd
    80007fc0:	0c2017b7          	lui	a5,0xc201
    80007fc4:	00a787b3          	add	a5,a5,a0
    80007fc8:	0097a223          	sw	s1,4(a5) # c201004 <_entry-0x73dfeffc>
}
    80007fcc:	01813083          	ld	ra,24(sp)
    80007fd0:	01013403          	ld	s0,16(sp)
    80007fd4:	00813483          	ld	s1,8(sp)
    80007fd8:	02010113          	add	sp,sp,32
    80007fdc:	00008067          	ret

0000000080007fe0 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80007fe0:	ff010113          	add	sp,sp,-16
    80007fe4:	00113423          	sd	ra,8(sp)
    80007fe8:	00813023          	sd	s0,0(sp)
    80007fec:	01010413          	add	s0,sp,16
  if(i >= NUM)
    80007ff0:	00700793          	li	a5,7
    80007ff4:	06a7c863          	blt	a5,a0,80008064 <free_desc+0x84>
    panic("free_desc 1");
  if(disk.free[i])
    80007ff8:	0001c797          	auipc	a5,0x1c
    80007ffc:	cc878793          	add	a5,a5,-824 # 80023cc0 <disk>
    80008000:	00a787b3          	add	a5,a5,a0
    80008004:	0187c783          	lbu	a5,24(a5)
    80008008:	06079663          	bnez	a5,80008074 <free_desc+0x94>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000800c:	00451693          	sll	a3,a0,0x4
    80008010:	0001c797          	auipc	a5,0x1c
    80008014:	cb078793          	add	a5,a5,-848 # 80023cc0 <disk>
    80008018:	0007b703          	ld	a4,0(a5)
    8000801c:	00d70733          	add	a4,a4,a3
    80008020:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80008024:	0007b703          	ld	a4,0(a5)
    80008028:	00d70733          	add	a4,a4,a3
    8000802c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80008030:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80008034:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80008038:	00a787b3          	add	a5,a5,a0
    8000803c:	00100713          	li	a4,1
    80008040:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80008044:	0001c517          	auipc	a0,0x1c
    80008048:	c9450513          	add	a0,a0,-876 # 80023cd8 <disk+0x18>
    8000804c:	ffffb097          	auipc	ra,0xffffb
    80008050:	de0080e7          	jalr	-544(ra) # 80002e2c <wakeup>
}
    80008054:	00813083          	ld	ra,8(sp)
    80008058:	00013403          	ld	s0,0(sp)
    8000805c:	01010113          	add	sp,sp,16
    80008060:	00008067          	ret
    panic("free_desc 1");
    80008064:	00002517          	auipc	a0,0x2
    80008068:	79450513          	add	a0,a0,1940 # 8000a7f8 <syscalls+0x2f0>
    8000806c:	ffff8097          	auipc	ra,0xffff8
    80008070:	65c080e7          	jalr	1628(ra) # 800006c8 <panic>
    panic("free_desc 2");
    80008074:	00002517          	auipc	a0,0x2
    80008078:	79450513          	add	a0,a0,1940 # 8000a808 <syscalls+0x300>
    8000807c:	ffff8097          	auipc	ra,0xffff8
    80008080:	64c080e7          	jalr	1612(ra) # 800006c8 <panic>

0000000080008084 <virtio_disk_init>:
{
    80008084:	fe010113          	add	sp,sp,-32
    80008088:	00113c23          	sd	ra,24(sp)
    8000808c:	00813823          	sd	s0,16(sp)
    80008090:	00913423          	sd	s1,8(sp)
    80008094:	01213023          	sd	s2,0(sp)
    80008098:	02010413          	add	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000809c:	00002597          	auipc	a1,0x2
    800080a0:	77c58593          	add	a1,a1,1916 # 8000a818 <syscalls+0x310>
    800080a4:	0001c517          	auipc	a0,0x1c
    800080a8:	d4450513          	add	a0,a0,-700 # 80023de8 <disk+0x128>
    800080ac:	ffff9097          	auipc	ra,0xffff9
    800080b0:	e34080e7          	jalr	-460(ra) # 80000ee0 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800080b4:	100017b7          	lui	a5,0x10001
    800080b8:	0007a703          	lw	a4,0(a5) # 10001000 <_entry-0x6ffff000>
    800080bc:	0007071b          	sext.w	a4,a4
    800080c0:	747277b7          	lui	a5,0x74727
    800080c4:	97678793          	add	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800080c8:	1cf71263          	bne	a4,a5,8000828c <virtio_disk_init+0x208>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800080cc:	100017b7          	lui	a5,0x10001
    800080d0:	0047a783          	lw	a5,4(a5) # 10001004 <_entry-0x6fffeffc>
    800080d4:	0007879b          	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800080d8:	00200713          	li	a4,2
    800080dc:	1ae79863          	bne	a5,a4,8000828c <virtio_disk_init+0x208>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800080e0:	100017b7          	lui	a5,0x10001
    800080e4:	0087a783          	lw	a5,8(a5) # 10001008 <_entry-0x6fffeff8>
    800080e8:	0007879b          	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800080ec:	1ae79063          	bne	a5,a4,8000828c <virtio_disk_init+0x208>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800080f0:	100017b7          	lui	a5,0x10001
    800080f4:	00c7a703          	lw	a4,12(a5) # 1000100c <_entry-0x6fffeff4>
    800080f8:	0007071b          	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800080fc:	554d47b7          	lui	a5,0x554d4
    80008100:	55178793          	add	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80008104:	18f71463          	bne	a4,a5,8000828c <virtio_disk_init+0x208>
  *R(VIRTIO_MMIO_STATUS) = status;
    80008108:	100017b7          	lui	a5,0x10001
    8000810c:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80008110:	00100713          	li	a4,1
    80008114:	06e7a823          	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80008118:	00300713          	li	a4,3
    8000811c:	06e7a823          	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80008120:	0107a703          	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80008124:	c7ffe6b7          	lui	a3,0xc7ffe
    80008128:	75f68693          	add	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fda95f>
    8000812c:	00d77733          	and	a4,a4,a3
    80008130:	02e7a023          	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80008134:	00b00713          	li	a4,11
    80008138:	06e7a823          	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    8000813c:	0707a783          	lw	a5,112(a5)
    80008140:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80008144:	0087f793          	and	a5,a5,8
    80008148:	14078a63          	beqz	a5,8000829c <virtio_disk_init+0x218>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000814c:	100017b7          	lui	a5,0x10001
    80008150:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80008154:	0447a783          	lw	a5,68(a5)
    80008158:	0007879b          	sext.w	a5,a5
    8000815c:	14079863          	bnez	a5,800082ac <virtio_disk_init+0x228>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80008160:	100017b7          	lui	a5,0x10001
    80008164:	0347a783          	lw	a5,52(a5) # 10001034 <_entry-0x6fffefcc>
    80008168:	0007879b          	sext.w	a5,a5
  if(max == 0)
    8000816c:	14078863          	beqz	a5,800082bc <virtio_disk_init+0x238>
  if(max < NUM)
    80008170:	00700713          	li	a4,7
    80008174:	14f77c63          	bgeu	a4,a5,800082cc <virtio_disk_init+0x248>
  disk.desc = kalloc();
    80008178:	ffff9097          	auipc	ra,0xffff9
    8000817c:	ce0080e7          	jalr	-800(ra) # 80000e58 <kalloc>
    80008180:	0001c497          	auipc	s1,0x1c
    80008184:	b4048493          	add	s1,s1,-1216 # 80023cc0 <disk>
    80008188:	00a4b023          	sd	a0,0(s1)
  disk.avail = kalloc();
    8000818c:	ffff9097          	auipc	ra,0xffff9
    80008190:	ccc080e7          	jalr	-820(ra) # 80000e58 <kalloc>
    80008194:	00a4b423          	sd	a0,8(s1)
  disk.used = kalloc();
    80008198:	ffff9097          	auipc	ra,0xffff9
    8000819c:	cc0080e7          	jalr	-832(ra) # 80000e58 <kalloc>
    800081a0:	00050793          	mv	a5,a0
    800081a4:	00a4b823          	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800081a8:	0004b503          	ld	a0,0(s1)
    800081ac:	12050863          	beqz	a0,800082dc <virtio_disk_init+0x258>
    800081b0:	0001c717          	auipc	a4,0x1c
    800081b4:	b1873703          	ld	a4,-1256(a4) # 80023cc8 <disk+0x8>
    800081b8:	12070263          	beqz	a4,800082dc <virtio_disk_init+0x258>
    800081bc:	12078063          	beqz	a5,800082dc <virtio_disk_init+0x258>
  memset(disk.desc, 0, PGSIZE);
    800081c0:	00001637          	lui	a2,0x1
    800081c4:	00000593          	li	a1,0
    800081c8:	ffff9097          	auipc	ra,0xffff9
    800081cc:	f54080e7          	jalr	-172(ra) # 8000111c <memset>
  memset(disk.avail, 0, PGSIZE);
    800081d0:	0001c497          	auipc	s1,0x1c
    800081d4:	af048493          	add	s1,s1,-1296 # 80023cc0 <disk>
    800081d8:	00001637          	lui	a2,0x1
    800081dc:	00000593          	li	a1,0
    800081e0:	0084b503          	ld	a0,8(s1)
    800081e4:	ffff9097          	auipc	ra,0xffff9
    800081e8:	f38080e7          	jalr	-200(ra) # 8000111c <memset>
  memset(disk.used, 0, PGSIZE);
    800081ec:	00001637          	lui	a2,0x1
    800081f0:	00000593          	li	a1,0
    800081f4:	0104b503          	ld	a0,16(s1)
    800081f8:	ffff9097          	auipc	ra,0xffff9
    800081fc:	f24080e7          	jalr	-220(ra) # 8000111c <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80008200:	100017b7          	lui	a5,0x10001
    80008204:	00800713          	li	a4,8
    80008208:	02e7ac23          	sw	a4,56(a5) # 10001038 <_entry-0x6fffefc8>
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    8000820c:	0004a703          	lw	a4,0(s1)
    80008210:	08e7a023          	sw	a4,128(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80008214:	0044a703          	lw	a4,4(s1)
    80008218:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000821c:	0084b703          	ld	a4,8(s1)
    80008220:	0007069b          	sext.w	a3,a4
    80008224:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80008228:	42075713          	sra	a4,a4,0x20
    8000822c:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80008230:	0104b703          	ld	a4,16(s1)
    80008234:	0007069b          	sext.w	a3,a4
    80008238:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000823c:	42075713          	sra	a4,a4,0x20
    80008240:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80008244:	00100713          	li	a4,1
    80008248:	04e7a223          	sw	a4,68(a5)
    disk.free[i] = 1;
    8000824c:	00e48c23          	sb	a4,24(s1)
    80008250:	00e48ca3          	sb	a4,25(s1)
    80008254:	00e48d23          	sb	a4,26(s1)
    80008258:	00e48da3          	sb	a4,27(s1)
    8000825c:	00e48e23          	sb	a4,28(s1)
    80008260:	00e48ea3          	sb	a4,29(s1)
    80008264:	00e48f23          	sb	a4,30(s1)
    80008268:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    8000826c:	00496913          	or	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80008270:	0727a823          	sw	s2,112(a5)
}
    80008274:	01813083          	ld	ra,24(sp)
    80008278:	01013403          	ld	s0,16(sp)
    8000827c:	00813483          	ld	s1,8(sp)
    80008280:	00013903          	ld	s2,0(sp)
    80008284:	02010113          	add	sp,sp,32
    80008288:	00008067          	ret
    panic("could not find virtio disk");
    8000828c:	00002517          	auipc	a0,0x2
    80008290:	59c50513          	add	a0,a0,1436 # 8000a828 <syscalls+0x320>
    80008294:	ffff8097          	auipc	ra,0xffff8
    80008298:	434080e7          	jalr	1076(ra) # 800006c8 <panic>
    panic("virtio disk FEATURES_OK unset");
    8000829c:	00002517          	auipc	a0,0x2
    800082a0:	5ac50513          	add	a0,a0,1452 # 8000a848 <syscalls+0x340>
    800082a4:	ffff8097          	auipc	ra,0xffff8
    800082a8:	424080e7          	jalr	1060(ra) # 800006c8 <panic>
    panic("virtio disk should not be ready");
    800082ac:	00002517          	auipc	a0,0x2
    800082b0:	5bc50513          	add	a0,a0,1468 # 8000a868 <syscalls+0x360>
    800082b4:	ffff8097          	auipc	ra,0xffff8
    800082b8:	414080e7          	jalr	1044(ra) # 800006c8 <panic>
    panic("virtio disk has no queue 0");
    800082bc:	00002517          	auipc	a0,0x2
    800082c0:	5cc50513          	add	a0,a0,1484 # 8000a888 <syscalls+0x380>
    800082c4:	ffff8097          	auipc	ra,0xffff8
    800082c8:	404080e7          	jalr	1028(ra) # 800006c8 <panic>
    panic("virtio disk max queue too short");
    800082cc:	00002517          	auipc	a0,0x2
    800082d0:	5dc50513          	add	a0,a0,1500 # 8000a8a8 <syscalls+0x3a0>
    800082d4:	ffff8097          	auipc	ra,0xffff8
    800082d8:	3f4080e7          	jalr	1012(ra) # 800006c8 <panic>
    panic("virtio disk kalloc");
    800082dc:	00002517          	auipc	a0,0x2
    800082e0:	5ec50513          	add	a0,a0,1516 # 8000a8c8 <syscalls+0x3c0>
    800082e4:	ffff8097          	auipc	ra,0xffff8
    800082e8:	3e4080e7          	jalr	996(ra) # 800006c8 <panic>

00000000800082ec <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800082ec:	f9010113          	add	sp,sp,-112
    800082f0:	06113423          	sd	ra,104(sp)
    800082f4:	06813023          	sd	s0,96(sp)
    800082f8:	04913c23          	sd	s1,88(sp)
    800082fc:	05213823          	sd	s2,80(sp)
    80008300:	05313423          	sd	s3,72(sp)
    80008304:	05413023          	sd	s4,64(sp)
    80008308:	03513c23          	sd	s5,56(sp)
    8000830c:	03613823          	sd	s6,48(sp)
    80008310:	03713423          	sd	s7,40(sp)
    80008314:	03813023          	sd	s8,32(sp)
    80008318:	01913c23          	sd	s9,24(sp)
    8000831c:	01a13823          	sd	s10,16(sp)
    80008320:	07010413          	add	s0,sp,112
    80008324:	00050a13          	mv	s4,a0
    80008328:	00058b93          	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    8000832c:	00c52c83          	lw	s9,12(a0)
    80008330:	001c9c9b          	sllw	s9,s9,0x1
    80008334:	020c9c93          	sll	s9,s9,0x20
    80008338:	020cdc93          	srl	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    8000833c:	0001c517          	auipc	a0,0x1c
    80008340:	aac50513          	add	a0,a0,-1364 # 80023de8 <disk+0x128>
    80008344:	ffff9097          	auipc	ra,0xffff9
    80008348:	c80080e7          	jalr	-896(ra) # 80000fc4 <acquire>
  for(int i = 0; i < 3; i++){
    8000834c:	00000913          	li	s2,0
  for(int i = 0; i < NUM; i++){
    80008350:	00800493          	li	s1,8
      disk.free[i] = 0;
    80008354:	0001cb17          	auipc	s6,0x1c
    80008358:	96cb0b13          	add	s6,s6,-1684 # 80023cc0 <disk>
  for(int i = 0; i < 3; i++){
    8000835c:	00300a93          	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80008360:	0001cc17          	auipc	s8,0x1c
    80008364:	a88c0c13          	add	s8,s8,-1400 # 80023de8 <disk+0x128>
    80008368:	0800006f          	j	800083e8 <virtio_disk_rw+0xfc>
      disk.free[i] = 0;
    8000836c:	00fb0733          	add	a4,s6,a5
    80008370:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80008374:	00f52023          	sw	a5,0(a0)
    if(idx[i] < 0){
    80008378:	0207ce63          	bltz	a5,800083b4 <virtio_disk_rw+0xc8>
  for(int i = 0; i < 3; i++){
    8000837c:	0016061b          	addw	a2,a2,1 # 1001 <_entry-0x7fffefff>
    80008380:	00458593          	add	a1,a1,4
    80008384:	07560a63          	beq	a2,s5,800083f8 <virtio_disk_rw+0x10c>
    idx[i] = alloc_desc();
    80008388:	00058513          	mv	a0,a1
  for(int i = 0; i < NUM; i++){
    8000838c:	0001c717          	auipc	a4,0x1c
    80008390:	93470713          	add	a4,a4,-1740 # 80023cc0 <disk>
    80008394:	00090793          	mv	a5,s2
    if(disk.free[i]){
    80008398:	01874683          	lbu	a3,24(a4)
    8000839c:	fc0698e3          	bnez	a3,8000836c <virtio_disk_rw+0x80>
  for(int i = 0; i < NUM; i++){
    800083a0:	0017879b          	addw	a5,a5,1
    800083a4:	00170713          	add	a4,a4,1
    800083a8:	fe9798e3          	bne	a5,s1,80008398 <virtio_disk_rw+0xac>
    idx[i] = alloc_desc();
    800083ac:	fff00793          	li	a5,-1
    800083b0:	00f52023          	sw	a5,0(a0)
      for(int j = 0; j < i; j++)
    800083b4:	02c05063          	blez	a2,800083d4 <virtio_disk_rw+0xe8>
    800083b8:	00261613          	sll	a2,a2,0x2
    800083bc:	01360d33          	add	s10,a2,s3
        free_desc(idx[j]);
    800083c0:	0009a503          	lw	a0,0(s3)
    800083c4:	00000097          	auipc	ra,0x0
    800083c8:	c1c080e7          	jalr	-996(ra) # 80007fe0 <free_desc>
      for(int j = 0; j < i; j++)
    800083cc:	00498993          	add	s3,s3,4
    800083d0:	ffa998e3          	bne	s3,s10,800083c0 <virtio_disk_rw+0xd4>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800083d4:	000c0593          	mv	a1,s8
    800083d8:	0001c517          	auipc	a0,0x1c
    800083dc:	90050513          	add	a0,a0,-1792 # 80023cd8 <disk+0x18>
    800083e0:	ffffb097          	auipc	ra,0xffffb
    800083e4:	9bc080e7          	jalr	-1604(ra) # 80002d9c <sleep>
  for(int i = 0; i < 3; i++){
    800083e8:	f9040993          	add	s3,s0,-112
{
    800083ec:	00098593          	mv	a1,s3
  for(int i = 0; i < 3; i++){
    800083f0:	00090613          	mv	a2,s2
    800083f4:	f95ff06f          	j	80008388 <virtio_disk_rw+0x9c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800083f8:	f9042503          	lw	a0,-112(s0)
    800083fc:	00a50713          	add	a4,a0,10
    80008400:	00471713          	sll	a4,a4,0x4

  if(write)
    80008404:	0001c797          	auipc	a5,0x1c
    80008408:	8bc78793          	add	a5,a5,-1860 # 80023cc0 <disk>
    8000840c:	00e786b3          	add	a3,a5,a4
    80008410:	01703633          	snez	a2,s7
    80008414:	00c6a423          	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80008418:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    8000841c:	0196b823          	sd	s9,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80008420:	f6070613          	add	a2,a4,-160
    80008424:	0007b683          	ld	a3,0(a5)
    80008428:	00c686b3          	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000842c:	00870593          	add	a1,a4,8
    80008430:	00b785b3          	add	a1,a5,a1
  disk.desc[idx[0]].addr = (uint64) buf0;
    80008434:	00b6b023          	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80008438:	0007b803          	ld	a6,0(a5)
    8000843c:	00c80633          	add	a2,a6,a2
    80008440:	01000693          	li	a3,16
    80008444:	00d62423          	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80008448:	00100593          	li	a1,1
    8000844c:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    80008450:	f9442683          	lw	a3,-108(s0)
    80008454:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80008458:	00469693          	sll	a3,a3,0x4
    8000845c:	00d80833          	add	a6,a6,a3
    80008460:	058a0613          	add	a2,s4,88
    80008464:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    80008468:	0007b803          	ld	a6,0(a5)
    8000846c:	00d806b3          	add	a3,a6,a3
    80008470:	40000613          	li	a2,1024
    80008474:	00c6a423          	sw	a2,8(a3)
  if(write)
    80008478:	001bb613          	seqz	a2,s7
    8000847c:	0016161b          	sllw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80008480:	00166613          	or	a2,a2,1
    80008484:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80008488:	f9842603          	lw	a2,-104(s0)
    8000848c:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80008490:	00250693          	add	a3,a0,2
    80008494:	00469693          	sll	a3,a3,0x4
    80008498:	00d786b3          	add	a3,a5,a3
    8000849c:	fff00893          	li	a7,-1
    800084a0:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800084a4:	00461613          	sll	a2,a2,0x4
    800084a8:	00c80833          	add	a6,a6,a2
    800084ac:	f9070713          	add	a4,a4,-112
    800084b0:	00e78733          	add	a4,a5,a4
    800084b4:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    800084b8:	0007b703          	ld	a4,0(a5)
    800084bc:	00c70733          	add	a4,a4,a2
    800084c0:	00b72423          	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800084c4:	00200613          	li	a2,2
    800084c8:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    800084cc:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800084d0:	00ba2223          	sw	a1,4(s4)
  disk.info[idx[0]].b = b;
    800084d4:	0146b423          	sd	s4,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800084d8:	0087b683          	ld	a3,8(a5)
    800084dc:	0026d703          	lhu	a4,2(a3)
    800084e0:	00777713          	and	a4,a4,7
    800084e4:	00171713          	sll	a4,a4,0x1
    800084e8:	00e686b3          	add	a3,a3,a4
    800084ec:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800084f0:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800084f4:	0087b703          	ld	a4,8(a5)
    800084f8:	00275783          	lhu	a5,2(a4)
    800084fc:	0017879b          	addw	a5,a5,1
    80008500:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80008504:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80008508:	100017b7          	lui	a5,0x10001
    8000850c:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80008510:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80008514:	0001c917          	auipc	s2,0x1c
    80008518:	8d490913          	add	s2,s2,-1836 # 80023de8 <disk+0x128>
  while(b->disk == 1) {
    8000851c:	00100493          	li	s1,1
    80008520:	00b79e63          	bne	a5,a1,8000853c <virtio_disk_rw+0x250>
    sleep(b, &disk.vdisk_lock);
    80008524:	00090593          	mv	a1,s2
    80008528:	000a0513          	mv	a0,s4
    8000852c:	ffffb097          	auipc	ra,0xffffb
    80008530:	870080e7          	jalr	-1936(ra) # 80002d9c <sleep>
  while(b->disk == 1) {
    80008534:	004a2783          	lw	a5,4(s4)
    80008538:	fe9786e3          	beq	a5,s1,80008524 <virtio_disk_rw+0x238>
  }

  disk.info[idx[0]].b = 0;
    8000853c:	f9042903          	lw	s2,-112(s0)
    80008540:	00290713          	add	a4,s2,2
    80008544:	00471713          	sll	a4,a4,0x4
    80008548:	0001b797          	auipc	a5,0x1b
    8000854c:	77878793          	add	a5,a5,1912 # 80023cc0 <disk>
    80008550:	00e787b3          	add	a5,a5,a4
    80008554:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80008558:	0001b997          	auipc	s3,0x1b
    8000855c:	76898993          	add	s3,s3,1896 # 80023cc0 <disk>
    80008560:	00491713          	sll	a4,s2,0x4
    80008564:	0009b783          	ld	a5,0(s3)
    80008568:	00e787b3          	add	a5,a5,a4
    8000856c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80008570:	00090513          	mv	a0,s2
    80008574:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80008578:	00000097          	auipc	ra,0x0
    8000857c:	a68080e7          	jalr	-1432(ra) # 80007fe0 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80008580:	0014f493          	and	s1,s1,1
    80008584:	fc049ee3          	bnez	s1,80008560 <virtio_disk_rw+0x274>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80008588:	0001c517          	auipc	a0,0x1c
    8000858c:	86050513          	add	a0,a0,-1952 # 80023de8 <disk+0x128>
    80008590:	ffff9097          	auipc	ra,0xffff9
    80008594:	b2c080e7          	jalr	-1236(ra) # 800010bc <release>
}
    80008598:	06813083          	ld	ra,104(sp)
    8000859c:	06013403          	ld	s0,96(sp)
    800085a0:	05813483          	ld	s1,88(sp)
    800085a4:	05013903          	ld	s2,80(sp)
    800085a8:	04813983          	ld	s3,72(sp)
    800085ac:	04013a03          	ld	s4,64(sp)
    800085b0:	03813a83          	ld	s5,56(sp)
    800085b4:	03013b03          	ld	s6,48(sp)
    800085b8:	02813b83          	ld	s7,40(sp)
    800085bc:	02013c03          	ld	s8,32(sp)
    800085c0:	01813c83          	ld	s9,24(sp)
    800085c4:	01013d03          	ld	s10,16(sp)
    800085c8:	07010113          	add	sp,sp,112
    800085cc:	00008067          	ret

00000000800085d0 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800085d0:	fe010113          	add	sp,sp,-32
    800085d4:	00113c23          	sd	ra,24(sp)
    800085d8:	00813823          	sd	s0,16(sp)
    800085dc:	00913423          	sd	s1,8(sp)
    800085e0:	02010413          	add	s0,sp,32
  acquire(&disk.vdisk_lock);
    800085e4:	0001b497          	auipc	s1,0x1b
    800085e8:	6dc48493          	add	s1,s1,1756 # 80023cc0 <disk>
    800085ec:	0001b517          	auipc	a0,0x1b
    800085f0:	7fc50513          	add	a0,a0,2044 # 80023de8 <disk+0x128>
    800085f4:	ffff9097          	auipc	ra,0xffff9
    800085f8:	9d0080e7          	jalr	-1584(ra) # 80000fc4 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800085fc:	10001737          	lui	a4,0x10001
    80008600:	06072783          	lw	a5,96(a4) # 10001060 <_entry-0x6fffefa0>
    80008604:	0037f793          	and	a5,a5,3
    80008608:	06f72223          	sw	a5,100(a4)

  __sync_synchronize();
    8000860c:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80008610:	0104b783          	ld	a5,16(s1)
    80008614:	0204d703          	lhu	a4,32(s1)
    80008618:	0027d783          	lhu	a5,2(a5)
    8000861c:	06f70863          	beq	a4,a5,8000868c <virtio_disk_intr+0xbc>
    __sync_synchronize();
    80008620:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80008624:	0104b703          	ld	a4,16(s1)
    80008628:	0204d783          	lhu	a5,32(s1)
    8000862c:	0077f793          	and	a5,a5,7
    80008630:	00379793          	sll	a5,a5,0x3
    80008634:	00f707b3          	add	a5,a4,a5
    80008638:	0047a783          	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000863c:	00278713          	add	a4,a5,2
    80008640:	00471713          	sll	a4,a4,0x4
    80008644:	00e48733          	add	a4,s1,a4
    80008648:	01074703          	lbu	a4,16(a4)
    8000864c:	06071263          	bnez	a4,800086b0 <virtio_disk_intr+0xe0>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80008650:	00278793          	add	a5,a5,2
    80008654:	00479793          	sll	a5,a5,0x4
    80008658:	00f487b3          	add	a5,s1,a5
    8000865c:	0087b503          	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80008660:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80008664:	ffffa097          	auipc	ra,0xffffa
    80008668:	7c8080e7          	jalr	1992(ra) # 80002e2c <wakeup>

    disk.used_idx += 1;
    8000866c:	0204d783          	lhu	a5,32(s1)
    80008670:	0017879b          	addw	a5,a5,1
    80008674:	03079793          	sll	a5,a5,0x30
    80008678:	0307d793          	srl	a5,a5,0x30
    8000867c:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80008680:	0104b703          	ld	a4,16(s1)
    80008684:	00275703          	lhu	a4,2(a4)
    80008688:	f8f71ce3          	bne	a4,a5,80008620 <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    8000868c:	0001b517          	auipc	a0,0x1b
    80008690:	75c50513          	add	a0,a0,1884 # 80023de8 <disk+0x128>
    80008694:	ffff9097          	auipc	ra,0xffff9
    80008698:	a28080e7          	jalr	-1496(ra) # 800010bc <release>
}
    8000869c:	01813083          	ld	ra,24(sp)
    800086a0:	01013403          	ld	s0,16(sp)
    800086a4:	00813483          	ld	s1,8(sp)
    800086a8:	02010113          	add	sp,sp,32
    800086ac:	00008067          	ret
      panic("virtio_disk_intr status");
    800086b0:	00002517          	auipc	a0,0x2
    800086b4:	23050513          	add	a0,a0,560 # 8000a8e0 <syscalls+0x3d8>
    800086b8:	ffff8097          	auipc	ra,0xffff8
    800086bc:	010080e7          	jalr	16(ra) # 800006c8 <panic>
	...

0000000080009000 <_trampoline>:
    80009000:	14051073          	csrw	sscratch,a0
    80009004:	02000537          	lui	a0,0x2000
    80009008:	fff5051b          	addw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000900c:	00d51513          	sll	a0,a0,0xd
    80009010:	02153423          	sd	ra,40(a0)
    80009014:	02253823          	sd	sp,48(a0)
    80009018:	02353c23          	sd	gp,56(a0)
    8000901c:	04453023          	sd	tp,64(a0)
    80009020:	04553423          	sd	t0,72(a0)
    80009024:	04653823          	sd	t1,80(a0)
    80009028:	04753c23          	sd	t2,88(a0)
    8000902c:	06853023          	sd	s0,96(a0)
    80009030:	06953423          	sd	s1,104(a0)
    80009034:	06b53c23          	sd	a1,120(a0)
    80009038:	08c53023          	sd	a2,128(a0)
    8000903c:	08d53423          	sd	a3,136(a0)
    80009040:	08e53823          	sd	a4,144(a0)
    80009044:	08f53c23          	sd	a5,152(a0)
    80009048:	0b053023          	sd	a6,160(a0)
    8000904c:	0b153423          	sd	a7,168(a0)
    80009050:	0b253823          	sd	s2,176(a0)
    80009054:	0b353c23          	sd	s3,184(a0)
    80009058:	0d453023          	sd	s4,192(a0)
    8000905c:	0d553423          	sd	s5,200(a0)
    80009060:	0d653823          	sd	s6,208(a0)
    80009064:	0d753c23          	sd	s7,216(a0)
    80009068:	0f853023          	sd	s8,224(a0)
    8000906c:	0f953423          	sd	s9,232(a0)
    80009070:	0fa53823          	sd	s10,240(a0)
    80009074:	0fb53c23          	sd	s11,248(a0)
    80009078:	11c53023          	sd	t3,256(a0)
    8000907c:	11d53423          	sd	t4,264(a0)
    80009080:	11e53823          	sd	t5,272(a0)
    80009084:	11f53c23          	sd	t6,280(a0)
    80009088:	140022f3          	csrr	t0,sscratch
    8000908c:	06553823          	sd	t0,112(a0)
    80009090:	00853103          	ld	sp,8(a0)
    80009094:	02053203          	ld	tp,32(a0)
    80009098:	01053283          	ld	t0,16(a0)
    8000909c:	00053303          	ld	t1,0(a0)
    800090a0:	12000073          	sfence.vma
    800090a4:	18031073          	csrw	satp,t1
    800090a8:	12000073          	sfence.vma
    800090ac:	00028067          	jr	t0

00000000800090b0 <userret>:
    800090b0:	12000073          	sfence.vma
    800090b4:	18051073          	csrw	satp,a0
    800090b8:	12000073          	sfence.vma
    800090bc:	02000537          	lui	a0,0x2000
    800090c0:	fff5051b          	addw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800090c4:	00d51513          	sll	a0,a0,0xd
    800090c8:	02853083          	ld	ra,40(a0)
    800090cc:	03053103          	ld	sp,48(a0)
    800090d0:	03853183          	ld	gp,56(a0)
    800090d4:	04053203          	ld	tp,64(a0)
    800090d8:	04853283          	ld	t0,72(a0)
    800090dc:	05053303          	ld	t1,80(a0)
    800090e0:	05853383          	ld	t2,88(a0)
    800090e4:	06053403          	ld	s0,96(a0)
    800090e8:	06853483          	ld	s1,104(a0)
    800090ec:	07853583          	ld	a1,120(a0)
    800090f0:	08053603          	ld	a2,128(a0)
    800090f4:	08853683          	ld	a3,136(a0)
    800090f8:	09053703          	ld	a4,144(a0)
    800090fc:	09853783          	ld	a5,152(a0)
    80009100:	0a053803          	ld	a6,160(a0)
    80009104:	0a853883          	ld	a7,168(a0)
    80009108:	0b053903          	ld	s2,176(a0)
    8000910c:	0b853983          	ld	s3,184(a0)
    80009110:	0c053a03          	ld	s4,192(a0)
    80009114:	0c853a83          	ld	s5,200(a0)
    80009118:	0d053b03          	ld	s6,208(a0)
    8000911c:	0d853b83          	ld	s7,216(a0)
    80009120:	0e053c03          	ld	s8,224(a0)
    80009124:	0e853c83          	ld	s9,232(a0)
    80009128:	0f053d03          	ld	s10,240(a0)
    8000912c:	0f853d83          	ld	s11,248(a0)
    80009130:	10053e03          	ld	t3,256(a0)
    80009134:	10853e83          	ld	t4,264(a0)
    80009138:	11053f03          	ld	t5,272(a0)
    8000913c:	11853f83          	ld	t6,280(a0)
    80009140:	07053503          	ld	a0,112(a0)
    80009144:	10200073          	sret
	...
