
user/_mkdir:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	fe010113          	add	sp,sp,-32
   4:	00113c23          	sd	ra,24(sp)
   8:	00813823          	sd	s0,16(sp)
   c:	00913423          	sd	s1,8(sp)
  10:	01213023          	sd	s2,0(sp)
  14:	02010413          	add	s0,sp,32
  int i;

  if(argc < 2){
  18:	00100793          	li	a5,1
  1c:	02a7dc63          	bge	a5,a0,54 <main+0x54>
  20:	00858493          	add	s1,a1,8
  24:	ffe5091b          	addw	s2,a0,-2
  28:	02091793          	sll	a5,s2,0x20
  2c:	01d7d913          	srl	s2,a5,0x1d
  30:	01058593          	add	a1,a1,16
  34:	00b90933          	add	s2,s2,a1
    fprintf(2, "Usage: mkdir files...\n");
    exit(1);
  }

  for(i = 1; i < argc; i++){
    if(mkdir(argv[i]) < 0){
  38:	0004b503          	ld	a0,0(s1)
  3c:	00000097          	auipc	ra,0x0
  40:	4e8080e7          	jalr	1256(ra) # 524 <mkdir>
  44:	02054863          	bltz	a0,74 <main+0x74>
  for(i = 1; i < argc; i++){
  48:	00848493          	add	s1,s1,8
  4c:	ff2496e3          	bne	s1,s2,38 <main+0x38>
  50:	03c0006f          	j	8c <main+0x8c>
    fprintf(2, "Usage: mkdir files...\n");
  54:	00001597          	auipc	a1,0x1
  58:	b5c58593          	add	a1,a1,-1188 # bb0 <malloc+0x148>
  5c:	00200513          	li	a0,2
  60:	00001097          	auipc	ra,0x1
  64:	8bc080e7          	jalr	-1860(ra) # 91c <fprintf>
    exit(1);
  68:	00100513          	li	a0,1
  6c:	00000097          	auipc	ra,0x0
  70:	41c080e7          	jalr	1052(ra) # 488 <exit>
      fprintf(2, "mkdir: %s failed to create\n", argv[i]);
  74:	0004b603          	ld	a2,0(s1)
  78:	00001597          	auipc	a1,0x1
  7c:	b5058593          	add	a1,a1,-1200 # bc8 <malloc+0x160>
  80:	00200513          	li	a0,2
  84:	00001097          	auipc	ra,0x1
  88:	898080e7          	jalr	-1896(ra) # 91c <fprintf>
      break;
    }
  }

  exit(0);
  8c:	00000513          	li	a0,0
  90:	00000097          	auipc	ra,0x0
  94:	3f8080e7          	jalr	1016(ra) # 488 <exit>

0000000000000098 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  98:	ff010113          	add	sp,sp,-16
  9c:	00113423          	sd	ra,8(sp)
  a0:	00813023          	sd	s0,0(sp)
  a4:	01010413          	add	s0,sp,16
  extern int main();
  main();
  a8:	00000097          	auipc	ra,0x0
  ac:	f58080e7          	jalr	-168(ra) # 0 <main>
  exit(0);
  b0:	00000513          	li	a0,0
  b4:	00000097          	auipc	ra,0x0
  b8:	3d4080e7          	jalr	980(ra) # 488 <exit>

00000000000000bc <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  bc:	ff010113          	add	sp,sp,-16
  c0:	00813423          	sd	s0,8(sp)
  c4:	01010413          	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  c8:	00050793          	mv	a5,a0
  cc:	00158593          	add	a1,a1,1
  d0:	00178793          	add	a5,a5,1
  d4:	fff5c703          	lbu	a4,-1(a1)
  d8:	fee78fa3          	sb	a4,-1(a5)
  dc:	fe0718e3          	bnez	a4,cc <strcpy+0x10>
    ;
  return os;
}
  e0:	00813403          	ld	s0,8(sp)
  e4:	01010113          	add	sp,sp,16
  e8:	00008067          	ret

00000000000000ec <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ec:	ff010113          	add	sp,sp,-16
  f0:	00813423          	sd	s0,8(sp)
  f4:	01010413          	add	s0,sp,16
  while(*p && *p == *q)
  f8:	00054783          	lbu	a5,0(a0)
  fc:	00078e63          	beqz	a5,118 <strcmp+0x2c>
 100:	0005c703          	lbu	a4,0(a1)
 104:	00f71a63          	bne	a4,a5,118 <strcmp+0x2c>
    p++, q++;
 108:	00150513          	add	a0,a0,1
 10c:	00158593          	add	a1,a1,1
  while(*p && *p == *q)
 110:	00054783          	lbu	a5,0(a0)
 114:	fe0796e3          	bnez	a5,100 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 118:	0005c503          	lbu	a0,0(a1)
}
 11c:	40a7853b          	subw	a0,a5,a0
 120:	00813403          	ld	s0,8(sp)
 124:	01010113          	add	sp,sp,16
 128:	00008067          	ret

000000000000012c <strlen>:

uint
strlen(const char *s)
{
 12c:	ff010113          	add	sp,sp,-16
 130:	00813423          	sd	s0,8(sp)
 134:	01010413          	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 138:	00054783          	lbu	a5,0(a0)
 13c:	02078863          	beqz	a5,16c <strlen+0x40>
 140:	00150513          	add	a0,a0,1
 144:	00050793          	mv	a5,a0
 148:	00078693          	mv	a3,a5
 14c:	00178793          	add	a5,a5,1
 150:	fff7c703          	lbu	a4,-1(a5)
 154:	fe071ae3          	bnez	a4,148 <strlen+0x1c>
 158:	40a6853b          	subw	a0,a3,a0
 15c:	0015051b          	addw	a0,a0,1
    ;
  return n;
}
 160:	00813403          	ld	s0,8(sp)
 164:	01010113          	add	sp,sp,16
 168:	00008067          	ret
  for(n = 0; s[n]; n++)
 16c:	00000513          	li	a0,0
 170:	ff1ff06f          	j	160 <strlen+0x34>

0000000000000174 <memset>:

void*
memset(void *dst, int c, uint n)
{
 174:	ff010113          	add	sp,sp,-16
 178:	00813423          	sd	s0,8(sp)
 17c:	01010413          	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 180:	02060063          	beqz	a2,1a0 <memset+0x2c>
 184:	00050793          	mv	a5,a0
 188:	02061613          	sll	a2,a2,0x20
 18c:	02065613          	srl	a2,a2,0x20
 190:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 194:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 198:	00178793          	add	a5,a5,1
 19c:	fee79ce3          	bne	a5,a4,194 <memset+0x20>
  }
  return dst;
}
 1a0:	00813403          	ld	s0,8(sp)
 1a4:	01010113          	add	sp,sp,16
 1a8:	00008067          	ret

00000000000001ac <strchr>:

char*
strchr(const char *s, char c)
{
 1ac:	ff010113          	add	sp,sp,-16
 1b0:	00813423          	sd	s0,8(sp)
 1b4:	01010413          	add	s0,sp,16
  for(; *s; s++)
 1b8:	00054783          	lbu	a5,0(a0)
 1bc:	02078263          	beqz	a5,1e0 <strchr+0x34>
    if(*s == c)
 1c0:	00f58a63          	beq	a1,a5,1d4 <strchr+0x28>
  for(; *s; s++)
 1c4:	00150513          	add	a0,a0,1
 1c8:	00054783          	lbu	a5,0(a0)
 1cc:	fe079ae3          	bnez	a5,1c0 <strchr+0x14>
      return (char*)s;
  return 0;
 1d0:	00000513          	li	a0,0
}
 1d4:	00813403          	ld	s0,8(sp)
 1d8:	01010113          	add	sp,sp,16
 1dc:	00008067          	ret
  return 0;
 1e0:	00000513          	li	a0,0
 1e4:	ff1ff06f          	j	1d4 <strchr+0x28>

00000000000001e8 <gets>:

char*
gets(char *buf, int max)
{
 1e8:	fa010113          	add	sp,sp,-96
 1ec:	04113c23          	sd	ra,88(sp)
 1f0:	04813823          	sd	s0,80(sp)
 1f4:	04913423          	sd	s1,72(sp)
 1f8:	05213023          	sd	s2,64(sp)
 1fc:	03313c23          	sd	s3,56(sp)
 200:	03413823          	sd	s4,48(sp)
 204:	03513423          	sd	s5,40(sp)
 208:	03613023          	sd	s6,32(sp)
 20c:	01713c23          	sd	s7,24(sp)
 210:	06010413          	add	s0,sp,96
 214:	00050b93          	mv	s7,a0
 218:	00058a13          	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 21c:	00050913          	mv	s2,a0
 220:	00000493          	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 224:	00a00a93          	li	s5,10
 228:	00d00b13          	li	s6,13
  for(i=0; i+1 < max; ){
 22c:	00048993          	mv	s3,s1
 230:	0014849b          	addw	s1,s1,1
 234:	0344de63          	bge	s1,s4,270 <gets+0x88>
    cc = read(0, &c, 1);
 238:	00100613          	li	a2,1
 23c:	faf40593          	add	a1,s0,-81
 240:	00000513          	li	a0,0
 244:	00000097          	auipc	ra,0x0
 248:	268080e7          	jalr	616(ra) # 4ac <read>
    if(cc < 1)
 24c:	02a05263          	blez	a0,270 <gets+0x88>
    buf[i++] = c;
 250:	faf44783          	lbu	a5,-81(s0)
 254:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 258:	01578a63          	beq	a5,s5,26c <gets+0x84>
 25c:	00190913          	add	s2,s2,1
 260:	fd6796e3          	bne	a5,s6,22c <gets+0x44>
  for(i=0; i+1 < max; ){
 264:	00048993          	mv	s3,s1
 268:	0080006f          	j	270 <gets+0x88>
 26c:	00048993          	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 270:	013b89b3          	add	s3,s7,s3
 274:	00098023          	sb	zero,0(s3)
  return buf;
}
 278:	000b8513          	mv	a0,s7
 27c:	05813083          	ld	ra,88(sp)
 280:	05013403          	ld	s0,80(sp)
 284:	04813483          	ld	s1,72(sp)
 288:	04013903          	ld	s2,64(sp)
 28c:	03813983          	ld	s3,56(sp)
 290:	03013a03          	ld	s4,48(sp)
 294:	02813a83          	ld	s5,40(sp)
 298:	02013b03          	ld	s6,32(sp)
 29c:	01813b83          	ld	s7,24(sp)
 2a0:	06010113          	add	sp,sp,96
 2a4:	00008067          	ret

00000000000002a8 <stat>:

int
stat(const char *n, struct stat *st)
{
 2a8:	fe010113          	add	sp,sp,-32
 2ac:	00113c23          	sd	ra,24(sp)
 2b0:	00813823          	sd	s0,16(sp)
 2b4:	00913423          	sd	s1,8(sp)
 2b8:	01213023          	sd	s2,0(sp)
 2bc:	02010413          	add	s0,sp,32
 2c0:	00058913          	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2c4:	00000593          	li	a1,0
 2c8:	00000097          	auipc	ra,0x0
 2cc:	220080e7          	jalr	544(ra) # 4e8 <open>
  if(fd < 0)
 2d0:	04054063          	bltz	a0,310 <stat+0x68>
 2d4:	00050493          	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2d8:	00090593          	mv	a1,s2
 2dc:	00000097          	auipc	ra,0x0
 2e0:	230080e7          	jalr	560(ra) # 50c <fstat>
 2e4:	00050913          	mv	s2,a0
  close(fd);
 2e8:	00048513          	mv	a0,s1
 2ec:	00000097          	auipc	ra,0x0
 2f0:	1d8080e7          	jalr	472(ra) # 4c4 <close>
  return r;
}
 2f4:	00090513          	mv	a0,s2
 2f8:	01813083          	ld	ra,24(sp)
 2fc:	01013403          	ld	s0,16(sp)
 300:	00813483          	ld	s1,8(sp)
 304:	00013903          	ld	s2,0(sp)
 308:	02010113          	add	sp,sp,32
 30c:	00008067          	ret
    return -1;
 310:	fff00913          	li	s2,-1
 314:	fe1ff06f          	j	2f4 <stat+0x4c>

0000000000000318 <atoi>:

int
atoi(const char *s)
{
 318:	ff010113          	add	sp,sp,-16
 31c:	00813423          	sd	s0,8(sp)
 320:	01010413          	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 324:	00054683          	lbu	a3,0(a0)
 328:	fd06879b          	addw	a5,a3,-48
 32c:	0ff7f793          	zext.b	a5,a5
 330:	00900613          	li	a2,9
 334:	04f66063          	bltu	a2,a5,374 <atoi+0x5c>
 338:	00050713          	mv	a4,a0
  n = 0;
 33c:	00000513          	li	a0,0
    n = n*10 + *s++ - '0';
 340:	00170713          	add	a4,a4,1
 344:	0025179b          	sllw	a5,a0,0x2
 348:	00a787bb          	addw	a5,a5,a0
 34c:	0017979b          	sllw	a5,a5,0x1
 350:	00d787bb          	addw	a5,a5,a3
 354:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 358:	00074683          	lbu	a3,0(a4)
 35c:	fd06879b          	addw	a5,a3,-48
 360:	0ff7f793          	zext.b	a5,a5
 364:	fcf67ee3          	bgeu	a2,a5,340 <atoi+0x28>
  return n;
}
 368:	00813403          	ld	s0,8(sp)
 36c:	01010113          	add	sp,sp,16
 370:	00008067          	ret
  n = 0;
 374:	00000513          	li	a0,0
 378:	ff1ff06f          	j	368 <atoi+0x50>

000000000000037c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 37c:	ff010113          	add	sp,sp,-16
 380:	00813423          	sd	s0,8(sp)
 384:	01010413          	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 388:	02b57c63          	bgeu	a0,a1,3c0 <memmove+0x44>
    while(n-- > 0)
 38c:	02c05463          	blez	a2,3b4 <memmove+0x38>
 390:	02061613          	sll	a2,a2,0x20
 394:	02065613          	srl	a2,a2,0x20
 398:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 39c:	00050713          	mv	a4,a0
      *dst++ = *src++;
 3a0:	00158593          	add	a1,a1,1
 3a4:	00170713          	add	a4,a4,1
 3a8:	fff5c683          	lbu	a3,-1(a1)
 3ac:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3b0:	fee798e3          	bne	a5,a4,3a0 <memmove+0x24>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3b4:	00813403          	ld	s0,8(sp)
 3b8:	01010113          	add	sp,sp,16
 3bc:	00008067          	ret
    dst += n;
 3c0:	00c50733          	add	a4,a0,a2
    src += n;
 3c4:	00c585b3          	add	a1,a1,a2
    while(n-- > 0)
 3c8:	fec056e3          	blez	a2,3b4 <memmove+0x38>
 3cc:	fff6079b          	addw	a5,a2,-1
 3d0:	02079793          	sll	a5,a5,0x20
 3d4:	0207d793          	srl	a5,a5,0x20
 3d8:	fff7c793          	not	a5,a5
 3dc:	00f707b3          	add	a5,a4,a5
      *--dst = *--src;
 3e0:	fff58593          	add	a1,a1,-1
 3e4:	fff70713          	add	a4,a4,-1
 3e8:	0005c683          	lbu	a3,0(a1)
 3ec:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3f0:	fee798e3          	bne	a5,a4,3e0 <memmove+0x64>
 3f4:	fc1ff06f          	j	3b4 <memmove+0x38>

00000000000003f8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3f8:	ff010113          	add	sp,sp,-16
 3fc:	00813423          	sd	s0,8(sp)
 400:	01010413          	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 404:	04060463          	beqz	a2,44c <memcmp+0x54>
 408:	fff6069b          	addw	a3,a2,-1
 40c:	02069693          	sll	a3,a3,0x20
 410:	0206d693          	srl	a3,a3,0x20
 414:	00168693          	add	a3,a3,1
 418:	00d506b3          	add	a3,a0,a3
    if (*p1 != *p2) {
 41c:	00054783          	lbu	a5,0(a0)
 420:	0005c703          	lbu	a4,0(a1)
 424:	00e79c63          	bne	a5,a4,43c <memcmp+0x44>
      return *p1 - *p2;
    }
    p1++;
 428:	00150513          	add	a0,a0,1
    p2++;
 42c:	00158593          	add	a1,a1,1
  while (n-- > 0) {
 430:	fed516e3          	bne	a0,a3,41c <memcmp+0x24>
  }
  return 0;
 434:	00000513          	li	a0,0
 438:	0080006f          	j	440 <memcmp+0x48>
      return *p1 - *p2;
 43c:	40e7853b          	subw	a0,a5,a4
}
 440:	00813403          	ld	s0,8(sp)
 444:	01010113          	add	sp,sp,16
 448:	00008067          	ret
  return 0;
 44c:	00000513          	li	a0,0
 450:	ff1ff06f          	j	440 <memcmp+0x48>

0000000000000454 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 454:	ff010113          	add	sp,sp,-16
 458:	00113423          	sd	ra,8(sp)
 45c:	00813023          	sd	s0,0(sp)
 460:	01010413          	add	s0,sp,16
  return memmove(dst, src, n);
 464:	00000097          	auipc	ra,0x0
 468:	f18080e7          	jalr	-232(ra) # 37c <memmove>
}
 46c:	00813083          	ld	ra,8(sp)
 470:	00013403          	ld	s0,0(sp)
 474:	01010113          	add	sp,sp,16
 478:	00008067          	ret

000000000000047c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 47c:	00100893          	li	a7,1
 ecall
 480:	00000073          	ecall
 ret
 484:	00008067          	ret

0000000000000488 <exit>:
.global exit
exit:
 li a7, SYS_exit
 488:	00200893          	li	a7,2
 ecall
 48c:	00000073          	ecall
 ret
 490:	00008067          	ret

0000000000000494 <wait>:
.global wait
wait:
 li a7, SYS_wait
 494:	00300893          	li	a7,3
 ecall
 498:	00000073          	ecall
 ret
 49c:	00008067          	ret

00000000000004a0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4a0:	00400893          	li	a7,4
 ecall
 4a4:	00000073          	ecall
 ret
 4a8:	00008067          	ret

00000000000004ac <read>:
.global read
read:
 li a7, SYS_read
 4ac:	00500893          	li	a7,5
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	00008067          	ret

00000000000004b8 <write>:
.global write
write:
 li a7, SYS_write
 4b8:	01000893          	li	a7,16
 ecall
 4bc:	00000073          	ecall
 ret
 4c0:	00008067          	ret

00000000000004c4 <close>:
.global close
close:
 li a7, SYS_close
 4c4:	01500893          	li	a7,21
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	00008067          	ret

00000000000004d0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4d0:	00600893          	li	a7,6
 ecall
 4d4:	00000073          	ecall
 ret
 4d8:	00008067          	ret

00000000000004dc <exec>:
.global exec
exec:
 li a7, SYS_exec
 4dc:	00700893          	li	a7,7
 ecall
 4e0:	00000073          	ecall
 ret
 4e4:	00008067          	ret

00000000000004e8 <open>:
.global open
open:
 li a7, SYS_open
 4e8:	00f00893          	li	a7,15
 ecall
 4ec:	00000073          	ecall
 ret
 4f0:	00008067          	ret

00000000000004f4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4f4:	01100893          	li	a7,17
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	00008067          	ret

0000000000000500 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 500:	01200893          	li	a7,18
 ecall
 504:	00000073          	ecall
 ret
 508:	00008067          	ret

000000000000050c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 50c:	00800893          	li	a7,8
 ecall
 510:	00000073          	ecall
 ret
 514:	00008067          	ret

0000000000000518 <link>:
.global link
link:
 li a7, SYS_link
 518:	01300893          	li	a7,19
 ecall
 51c:	00000073          	ecall
 ret
 520:	00008067          	ret

0000000000000524 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 524:	01400893          	li	a7,20
 ecall
 528:	00000073          	ecall
 ret
 52c:	00008067          	ret

0000000000000530 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 530:	00900893          	li	a7,9
 ecall
 534:	00000073          	ecall
 ret
 538:	00008067          	ret

000000000000053c <dup>:
.global dup
dup:
 li a7, SYS_dup
 53c:	00a00893          	li	a7,10
 ecall
 540:	00000073          	ecall
 ret
 544:	00008067          	ret

0000000000000548 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 548:	00b00893          	li	a7,11
 ecall
 54c:	00000073          	ecall
 ret
 550:	00008067          	ret

0000000000000554 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 554:	00c00893          	li	a7,12
 ecall
 558:	00000073          	ecall
 ret
 55c:	00008067          	ret

0000000000000560 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 560:	00d00893          	li	a7,13
 ecall
 564:	00000073          	ecall
 ret
 568:	00008067          	ret

000000000000056c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 56c:	00e00893          	li	a7,14
 ecall
 570:	00000073          	ecall
 ret
 574:	00008067          	ret

0000000000000578 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 578:	fe010113          	add	sp,sp,-32
 57c:	00113c23          	sd	ra,24(sp)
 580:	00813823          	sd	s0,16(sp)
 584:	02010413          	add	s0,sp,32
 588:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 58c:	00100613          	li	a2,1
 590:	fef40593          	add	a1,s0,-17
 594:	00000097          	auipc	ra,0x0
 598:	f24080e7          	jalr	-220(ra) # 4b8 <write>
}
 59c:	01813083          	ld	ra,24(sp)
 5a0:	01013403          	ld	s0,16(sp)
 5a4:	02010113          	add	sp,sp,32
 5a8:	00008067          	ret

00000000000005ac <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5ac:	fc010113          	add	sp,sp,-64
 5b0:	02113c23          	sd	ra,56(sp)
 5b4:	02813823          	sd	s0,48(sp)
 5b8:	02913423          	sd	s1,40(sp)
 5bc:	03213023          	sd	s2,32(sp)
 5c0:	01313c23          	sd	s3,24(sp)
 5c4:	04010413          	add	s0,sp,64
 5c8:	00050493          	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5cc:	00068463          	beqz	a3,5d4 <printint+0x28>
 5d0:	0c05c063          	bltz	a1,690 <printint+0xe4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5d4:	0005859b          	sext.w	a1,a1
  neg = 0;
 5d8:	00000893          	li	a7,0
 5dc:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 5e0:	00000713          	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5e4:	0006061b          	sext.w	a2,a2
 5e8:	00000517          	auipc	a0,0x0
 5ec:	66050513          	add	a0,a0,1632 # c48 <digits>
 5f0:	00070813          	mv	a6,a4
 5f4:	0017071b          	addw	a4,a4,1
 5f8:	02c5f7bb          	remuw	a5,a1,a2
 5fc:	02079793          	sll	a5,a5,0x20
 600:	0207d793          	srl	a5,a5,0x20
 604:	00f507b3          	add	a5,a0,a5
 608:	0007c783          	lbu	a5,0(a5)
 60c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 610:	0005879b          	sext.w	a5,a1
 614:	02c5d5bb          	divuw	a1,a1,a2
 618:	00168693          	add	a3,a3,1
 61c:	fcc7fae3          	bgeu	a5,a2,5f0 <printint+0x44>
  if(neg)
 620:	00088c63          	beqz	a7,638 <printint+0x8c>
    buf[i++] = '-';
 624:	fd070793          	add	a5,a4,-48
 628:	00878733          	add	a4,a5,s0
 62c:	02d00793          	li	a5,45
 630:	fef70823          	sb	a5,-16(a4)
 634:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 638:	02e05e63          	blez	a4,674 <printint+0xc8>
 63c:	fc040793          	add	a5,s0,-64
 640:	00e78933          	add	s2,a5,a4
 644:	fff78993          	add	s3,a5,-1
 648:	00e989b3          	add	s3,s3,a4
 64c:	fff7071b          	addw	a4,a4,-1
 650:	02071713          	sll	a4,a4,0x20
 654:	02075713          	srl	a4,a4,0x20
 658:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 65c:	fff94583          	lbu	a1,-1(s2)
 660:	00048513          	mv	a0,s1
 664:	00000097          	auipc	ra,0x0
 668:	f14080e7          	jalr	-236(ra) # 578 <putc>
  while(--i >= 0)
 66c:	fff90913          	add	s2,s2,-1
 670:	ff3916e3          	bne	s2,s3,65c <printint+0xb0>
}
 674:	03813083          	ld	ra,56(sp)
 678:	03013403          	ld	s0,48(sp)
 67c:	02813483          	ld	s1,40(sp)
 680:	02013903          	ld	s2,32(sp)
 684:	01813983          	ld	s3,24(sp)
 688:	04010113          	add	sp,sp,64
 68c:	00008067          	ret
    x = -xx;
 690:	40b005bb          	negw	a1,a1
    neg = 1;
 694:	00100893          	li	a7,1
    x = -xx;
 698:	f45ff06f          	j	5dc <printint+0x30>

000000000000069c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 69c:	fb010113          	add	sp,sp,-80
 6a0:	04113423          	sd	ra,72(sp)
 6a4:	04813023          	sd	s0,64(sp)
 6a8:	02913c23          	sd	s1,56(sp)
 6ac:	03213823          	sd	s2,48(sp)
 6b0:	03313423          	sd	s3,40(sp)
 6b4:	03413023          	sd	s4,32(sp)
 6b8:	01513c23          	sd	s5,24(sp)
 6bc:	01613823          	sd	s6,16(sp)
 6c0:	01713423          	sd	s7,8(sp)
 6c4:	01813023          	sd	s8,0(sp)
 6c8:	05010413          	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6cc:	0005c903          	lbu	s2,0(a1)
 6d0:	20090e63          	beqz	s2,8ec <vprintf+0x250>
 6d4:	00050a93          	mv	s5,a0
 6d8:	00060b93          	mv	s7,a2
 6dc:	00158493          	add	s1,a1,1
  state = 0;
 6e0:	00000993          	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 6e4:	02500a13          	li	s4,37
 6e8:	01500b13          	li	s6,21
 6ec:	0280006f          	j	714 <vprintf+0x78>
        putc(fd, c);
 6f0:	00090593          	mv	a1,s2
 6f4:	000a8513          	mv	a0,s5
 6f8:	00000097          	auipc	ra,0x0
 6fc:	e80080e7          	jalr	-384(ra) # 578 <putc>
 700:	0080006f          	j	708 <vprintf+0x6c>
    } else if(state == '%'){
 704:	03498063          	beq	s3,s4,724 <vprintf+0x88>
  for(i = 0; fmt[i]; i++){
 708:	00148493          	add	s1,s1,1
 70c:	fff4c903          	lbu	s2,-1(s1)
 710:	1c090e63          	beqz	s2,8ec <vprintf+0x250>
    if(state == 0){
 714:	fe0998e3          	bnez	s3,704 <vprintf+0x68>
      if(c == '%'){
 718:	fd491ce3          	bne	s2,s4,6f0 <vprintf+0x54>
        state = '%';
 71c:	000a0993          	mv	s3,s4
 720:	fe9ff06f          	j	708 <vprintf+0x6c>
      if(c == 'd'){
 724:	17490e63          	beq	s2,s4,8a0 <vprintf+0x204>
 728:	f9d9079b          	addw	a5,s2,-99
 72c:	0ff7f793          	zext.b	a5,a5
 730:	18fb6463          	bltu	s6,a5,8b8 <vprintf+0x21c>
 734:	f9d9079b          	addw	a5,s2,-99
 738:	0ff7f713          	zext.b	a4,a5
 73c:	16eb6e63          	bltu	s6,a4,8b8 <vprintf+0x21c>
 740:	00271793          	sll	a5,a4,0x2
 744:	00000717          	auipc	a4,0x0
 748:	4ac70713          	add	a4,a4,1196 # bf0 <malloc+0x188>
 74c:	00e787b3          	add	a5,a5,a4
 750:	0007a783          	lw	a5,0(a5)
 754:	00e787b3          	add	a5,a5,a4
 758:	00078067          	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 75c:	008b8913          	add	s2,s7,8
 760:	00100693          	li	a3,1
 764:	00a00613          	li	a2,10
 768:	000ba583          	lw	a1,0(s7)
 76c:	000a8513          	mv	a0,s5
 770:	00000097          	auipc	ra,0x0
 774:	e3c080e7          	jalr	-452(ra) # 5ac <printint>
 778:	00090b93          	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 77c:	00000993          	li	s3,0
 780:	f89ff06f          	j	708 <vprintf+0x6c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 784:	008b8913          	add	s2,s7,8
 788:	00000693          	li	a3,0
 78c:	00a00613          	li	a2,10
 790:	000ba583          	lw	a1,0(s7)
 794:	000a8513          	mv	a0,s5
 798:	00000097          	auipc	ra,0x0
 79c:	e14080e7          	jalr	-492(ra) # 5ac <printint>
 7a0:	00090b93          	mv	s7,s2
      state = 0;
 7a4:	00000993          	li	s3,0
 7a8:	f61ff06f          	j	708 <vprintf+0x6c>
        printint(fd, va_arg(ap, int), 16, 0);
 7ac:	008b8913          	add	s2,s7,8
 7b0:	00000693          	li	a3,0
 7b4:	01000613          	li	a2,16
 7b8:	000ba583          	lw	a1,0(s7)
 7bc:	000a8513          	mv	a0,s5
 7c0:	00000097          	auipc	ra,0x0
 7c4:	dec080e7          	jalr	-532(ra) # 5ac <printint>
 7c8:	00090b93          	mv	s7,s2
      state = 0;
 7cc:	00000993          	li	s3,0
 7d0:	f39ff06f          	j	708 <vprintf+0x6c>
        printptr(fd, va_arg(ap, uint64));
 7d4:	008b8c13          	add	s8,s7,8
 7d8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7dc:	03000593          	li	a1,48
 7e0:	000a8513          	mv	a0,s5
 7e4:	00000097          	auipc	ra,0x0
 7e8:	d94080e7          	jalr	-620(ra) # 578 <putc>
  putc(fd, 'x');
 7ec:	07800593          	li	a1,120
 7f0:	000a8513          	mv	a0,s5
 7f4:	00000097          	auipc	ra,0x0
 7f8:	d84080e7          	jalr	-636(ra) # 578 <putc>
 7fc:	01000913          	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 800:	00000b97          	auipc	s7,0x0
 804:	448b8b93          	add	s7,s7,1096 # c48 <digits>
 808:	03c9d793          	srl	a5,s3,0x3c
 80c:	00fb87b3          	add	a5,s7,a5
 810:	0007c583          	lbu	a1,0(a5)
 814:	000a8513          	mv	a0,s5
 818:	00000097          	auipc	ra,0x0
 81c:	d60080e7          	jalr	-672(ra) # 578 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 820:	00499993          	sll	s3,s3,0x4
 824:	fff9091b          	addw	s2,s2,-1
 828:	fe0910e3          	bnez	s2,808 <vprintf+0x16c>
        printptr(fd, va_arg(ap, uint64));
 82c:	000c0b93          	mv	s7,s8
      state = 0;
 830:	00000993          	li	s3,0
 834:	ed5ff06f          	j	708 <vprintf+0x6c>
        s = va_arg(ap, char*);
 838:	008b8993          	add	s3,s7,8
 83c:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 840:	02090863          	beqz	s2,870 <vprintf+0x1d4>
        while(*s != 0){
 844:	00094583          	lbu	a1,0(s2)
 848:	08058c63          	beqz	a1,8e0 <vprintf+0x244>
          putc(fd, *s);
 84c:	000a8513          	mv	a0,s5
 850:	00000097          	auipc	ra,0x0
 854:	d28080e7          	jalr	-728(ra) # 578 <putc>
          s++;
 858:	00190913          	add	s2,s2,1
        while(*s != 0){
 85c:	00094583          	lbu	a1,0(s2)
 860:	fe0596e3          	bnez	a1,84c <vprintf+0x1b0>
        s = va_arg(ap, char*);
 864:	00098b93          	mv	s7,s3
      state = 0;
 868:	00000993          	li	s3,0
 86c:	e9dff06f          	j	708 <vprintf+0x6c>
          s = "(null)";
 870:	00000917          	auipc	s2,0x0
 874:	37890913          	add	s2,s2,888 # be8 <malloc+0x180>
        while(*s != 0){
 878:	02800593          	li	a1,40
 87c:	fd1ff06f          	j	84c <vprintf+0x1b0>
        putc(fd, va_arg(ap, uint));
 880:	008b8913          	add	s2,s7,8
 884:	000bc583          	lbu	a1,0(s7)
 888:	000a8513          	mv	a0,s5
 88c:	00000097          	auipc	ra,0x0
 890:	cec080e7          	jalr	-788(ra) # 578 <putc>
 894:	00090b93          	mv	s7,s2
      state = 0;
 898:	00000993          	li	s3,0
 89c:	e6dff06f          	j	708 <vprintf+0x6c>
        putc(fd, c);
 8a0:	02500593          	li	a1,37
 8a4:	000a8513          	mv	a0,s5
 8a8:	00000097          	auipc	ra,0x0
 8ac:	cd0080e7          	jalr	-816(ra) # 578 <putc>
      state = 0;
 8b0:	00000993          	li	s3,0
 8b4:	e55ff06f          	j	708 <vprintf+0x6c>
        putc(fd, '%');
 8b8:	02500593          	li	a1,37
 8bc:	000a8513          	mv	a0,s5
 8c0:	00000097          	auipc	ra,0x0
 8c4:	cb8080e7          	jalr	-840(ra) # 578 <putc>
        putc(fd, c);
 8c8:	00090593          	mv	a1,s2
 8cc:	000a8513          	mv	a0,s5
 8d0:	00000097          	auipc	ra,0x0
 8d4:	ca8080e7          	jalr	-856(ra) # 578 <putc>
      state = 0;
 8d8:	00000993          	li	s3,0
 8dc:	e2dff06f          	j	708 <vprintf+0x6c>
        s = va_arg(ap, char*);
 8e0:	00098b93          	mv	s7,s3
      state = 0;
 8e4:	00000993          	li	s3,0
 8e8:	e21ff06f          	j	708 <vprintf+0x6c>
    }
  }
}
 8ec:	04813083          	ld	ra,72(sp)
 8f0:	04013403          	ld	s0,64(sp)
 8f4:	03813483          	ld	s1,56(sp)
 8f8:	03013903          	ld	s2,48(sp)
 8fc:	02813983          	ld	s3,40(sp)
 900:	02013a03          	ld	s4,32(sp)
 904:	01813a83          	ld	s5,24(sp)
 908:	01013b03          	ld	s6,16(sp)
 90c:	00813b83          	ld	s7,8(sp)
 910:	00013c03          	ld	s8,0(sp)
 914:	05010113          	add	sp,sp,80
 918:	00008067          	ret

000000000000091c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 91c:	fb010113          	add	sp,sp,-80
 920:	00113c23          	sd	ra,24(sp)
 924:	00813823          	sd	s0,16(sp)
 928:	02010413          	add	s0,sp,32
 92c:	00c43023          	sd	a2,0(s0)
 930:	00d43423          	sd	a3,8(s0)
 934:	00e43823          	sd	a4,16(s0)
 938:	00f43c23          	sd	a5,24(s0)
 93c:	03043023          	sd	a6,32(s0)
 940:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 944:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 948:	00040613          	mv	a2,s0
 94c:	00000097          	auipc	ra,0x0
 950:	d50080e7          	jalr	-688(ra) # 69c <vprintf>
}
 954:	01813083          	ld	ra,24(sp)
 958:	01013403          	ld	s0,16(sp)
 95c:	05010113          	add	sp,sp,80
 960:	00008067          	ret

0000000000000964 <printf>:

void
printf(const char *fmt, ...)
{
 964:	fa010113          	add	sp,sp,-96
 968:	00113c23          	sd	ra,24(sp)
 96c:	00813823          	sd	s0,16(sp)
 970:	02010413          	add	s0,sp,32
 974:	00b43423          	sd	a1,8(s0)
 978:	00c43823          	sd	a2,16(s0)
 97c:	00d43c23          	sd	a3,24(s0)
 980:	02e43023          	sd	a4,32(s0)
 984:	02f43423          	sd	a5,40(s0)
 988:	03043823          	sd	a6,48(s0)
 98c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 990:	00840613          	add	a2,s0,8
 994:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 998:	00050593          	mv	a1,a0
 99c:	00100513          	li	a0,1
 9a0:	00000097          	auipc	ra,0x0
 9a4:	cfc080e7          	jalr	-772(ra) # 69c <vprintf>
}
 9a8:	01813083          	ld	ra,24(sp)
 9ac:	01013403          	ld	s0,16(sp)
 9b0:	06010113          	add	sp,sp,96
 9b4:	00008067          	ret

00000000000009b8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9b8:	ff010113          	add	sp,sp,-16
 9bc:	00813423          	sd	s0,8(sp)
 9c0:	01010413          	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 9c4:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9c8:	00000797          	auipc	a5,0x0
 9cc:	6387b783          	ld	a5,1592(a5) # 1000 <freep>
 9d0:	0400006f          	j	a10 <free+0x58>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 9d4:	00862703          	lw	a4,8(a2)
 9d8:	00b7073b          	addw	a4,a4,a1
 9dc:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 9e0:	0007b703          	ld	a4,0(a5)
 9e4:	00073603          	ld	a2,0(a4)
 9e8:	0500006f          	j	a38 <free+0x80>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 9ec:	ff852703          	lw	a4,-8(a0)
 9f0:	00c7073b          	addw	a4,a4,a2
 9f4:	00e7a423          	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 9f8:	ff053683          	ld	a3,-16(a0)
 9fc:	0540006f          	j	a50 <free+0x98>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a00:	0007b703          	ld	a4,0(a5)
 a04:	00e7e463          	bltu	a5,a4,a0c <free+0x54>
 a08:	00e6ec63          	bltu	a3,a4,a20 <free+0x68>
{
 a0c:	00070793          	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a10:	fed7f8e3          	bgeu	a5,a3,a00 <free+0x48>
 a14:	0007b703          	ld	a4,0(a5)
 a18:	00e6e463          	bltu	a3,a4,a20 <free+0x68>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a1c:	fee7e8e3          	bltu	a5,a4,a0c <free+0x54>
  if(bp + bp->s.size == p->s.ptr){
 a20:	ff852583          	lw	a1,-8(a0)
 a24:	0007b603          	ld	a2,0(a5)
 a28:	02059813          	sll	a6,a1,0x20
 a2c:	01c85713          	srl	a4,a6,0x1c
 a30:	00e68733          	add	a4,a3,a4
 a34:	fae600e3          	beq	a2,a4,9d4 <free+0x1c>
    bp->s.ptr = p->s.ptr->s.ptr;
 a38:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 a3c:	0087a603          	lw	a2,8(a5)
 a40:	02061593          	sll	a1,a2,0x20
 a44:	01c5d713          	srl	a4,a1,0x1c
 a48:	00e78733          	add	a4,a5,a4
 a4c:	fae680e3          	beq	a3,a4,9ec <free+0x34>
    p->s.ptr = bp->s.ptr;
 a50:	00d7b023          	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 a54:	00000717          	auipc	a4,0x0
 a58:	5af73623          	sd	a5,1452(a4) # 1000 <freep>
}
 a5c:	00813403          	ld	s0,8(sp)
 a60:	01010113          	add	sp,sp,16
 a64:	00008067          	ret

0000000000000a68 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a68:	fc010113          	add	sp,sp,-64
 a6c:	02113c23          	sd	ra,56(sp)
 a70:	02813823          	sd	s0,48(sp)
 a74:	02913423          	sd	s1,40(sp)
 a78:	03213023          	sd	s2,32(sp)
 a7c:	01313c23          	sd	s3,24(sp)
 a80:	01413823          	sd	s4,16(sp)
 a84:	01513423          	sd	s5,8(sp)
 a88:	01613023          	sd	s6,0(sp)
 a8c:	04010413          	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a90:	02051493          	sll	s1,a0,0x20
 a94:	0204d493          	srl	s1,s1,0x20
 a98:	00f48493          	add	s1,s1,15
 a9c:	0044d493          	srl	s1,s1,0x4
 aa0:	0014899b          	addw	s3,s1,1
 aa4:	00148493          	add	s1,s1,1
  if((prevp = freep) == 0){
 aa8:	00000517          	auipc	a0,0x0
 aac:	55853503          	ld	a0,1368(a0) # 1000 <freep>
 ab0:	02050e63          	beqz	a0,aec <malloc+0x84>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ab4:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
 ab8:	0087a703          	lw	a4,8(a5)
 abc:	04977663          	bgeu	a4,s1,b08 <malloc+0xa0>
  if(nu < 4096)
 ac0:	00098a13          	mv	s4,s3
 ac4:	0009871b          	sext.w	a4,s3
 ac8:	000016b7          	lui	a3,0x1
 acc:	00d77463          	bgeu	a4,a3,ad4 <malloc+0x6c>
 ad0:	00001a37          	lui	s4,0x1
 ad4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 ad8:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 adc:	00000917          	auipc	s2,0x0
 ae0:	52490913          	add	s2,s2,1316 # 1000 <freep>
  if(p == (char*)-1)
 ae4:	fff00a93          	li	s5,-1
 ae8:	0a00006f          	j	b88 <malloc+0x120>
    base.s.ptr = freep = prevp = &base;
 aec:	00000797          	auipc	a5,0x0
 af0:	52478793          	add	a5,a5,1316 # 1010 <base>
 af4:	00000717          	auipc	a4,0x0
 af8:	50f73623          	sd	a5,1292(a4) # 1000 <freep>
 afc:	00f7b023          	sd	a5,0(a5)
    base.s.size = 0;
 b00:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 b04:	fbdff06f          	j	ac0 <malloc+0x58>
      if(p->s.size == nunits)
 b08:	04e48863          	beq	s1,a4,b58 <malloc+0xf0>
        p->s.size -= nunits;
 b0c:	4137073b          	subw	a4,a4,s3
 b10:	00e7a423          	sw	a4,8(a5)
        p += p->s.size;
 b14:	02071693          	sll	a3,a4,0x20
 b18:	01c6d713          	srl	a4,a3,0x1c
 b1c:	00e787b3          	add	a5,a5,a4
        p->s.size = nunits;
 b20:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b24:	00000717          	auipc	a4,0x0
 b28:	4ca73e23          	sd	a0,1244(a4) # 1000 <freep>
      return (void*)(p + 1);
 b2c:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 b30:	03813083          	ld	ra,56(sp)
 b34:	03013403          	ld	s0,48(sp)
 b38:	02813483          	ld	s1,40(sp)
 b3c:	02013903          	ld	s2,32(sp)
 b40:	01813983          	ld	s3,24(sp)
 b44:	01013a03          	ld	s4,16(sp)
 b48:	00813a83          	ld	s5,8(sp)
 b4c:	00013b03          	ld	s6,0(sp)
 b50:	04010113          	add	sp,sp,64
 b54:	00008067          	ret
        prevp->s.ptr = p->s.ptr;
 b58:	0007b703          	ld	a4,0(a5)
 b5c:	00e53023          	sd	a4,0(a0)
 b60:	fc5ff06f          	j	b24 <malloc+0xbc>
  hp->s.size = nu;
 b64:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 b68:	01050513          	add	a0,a0,16
 b6c:	00000097          	auipc	ra,0x0
 b70:	e4c080e7          	jalr	-436(ra) # 9b8 <free>
  return freep;
 b74:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 b78:	fa050ce3          	beqz	a0,b30 <malloc+0xc8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b7c:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b80:	0087a703          	lw	a4,8(a5)
 b84:	f89772e3          	bgeu	a4,s1,b08 <malloc+0xa0>
    if(p == freep)
 b88:	00093703          	ld	a4,0(s2)
 b8c:	00078513          	mv	a0,a5
 b90:	fef716e3          	bne	a4,a5,b7c <malloc+0x114>
  p = sbrk(nu * sizeof(Header));
 b94:	000a0513          	mv	a0,s4
 b98:	00000097          	auipc	ra,0x0
 b9c:	9bc080e7          	jalr	-1604(ra) # 554 <sbrk>
  if(p == (char*)-1)
 ba0:	fd5512e3          	bne	a0,s5,b64 <malloc+0xfc>
        return 0;
 ba4:	00000513          	li	a0,0
 ba8:	f89ff06f          	j	b30 <malloc+0xc8>
