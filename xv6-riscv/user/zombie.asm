
user/_zombie:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
   0:	ff010113          	add	sp,sp,-16
   4:	00113423          	sd	ra,8(sp)
   8:	00813023          	sd	s0,0(sp)
   c:	01010413          	add	s0,sp,16
  if(fork() > 0)
  10:	00000097          	auipc	ra,0x0
  14:	40c080e7          	jalr	1036(ra) # 41c <fork>
  18:	00a04863          	bgtz	a0,28 <main+0x28>
    sleep(5);  // Let child exit before parent.
  exit(0);
  1c:	00000513          	li	a0,0
  20:	00000097          	auipc	ra,0x0
  24:	408080e7          	jalr	1032(ra) # 428 <exit>
    sleep(5);  // Let child exit before parent.
  28:	00500513          	li	a0,5
  2c:	00000097          	auipc	ra,0x0
  30:	4d4080e7          	jalr	1236(ra) # 500 <sleep>
  34:	fe9ff06f          	j	1c <main+0x1c>

0000000000000038 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  38:	ff010113          	add	sp,sp,-16
  3c:	00113423          	sd	ra,8(sp)
  40:	00813023          	sd	s0,0(sp)
  44:	01010413          	add	s0,sp,16
  extern int main();
  main();
  48:	00000097          	auipc	ra,0x0
  4c:	fb8080e7          	jalr	-72(ra) # 0 <main>
  exit(0);
  50:	00000513          	li	a0,0
  54:	00000097          	auipc	ra,0x0
  58:	3d4080e7          	jalr	980(ra) # 428 <exit>

000000000000005c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  5c:	ff010113          	add	sp,sp,-16
  60:	00813423          	sd	s0,8(sp)
  64:	01010413          	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  68:	00050793          	mv	a5,a0
  6c:	00158593          	add	a1,a1,1
  70:	00178793          	add	a5,a5,1
  74:	fff5c703          	lbu	a4,-1(a1)
  78:	fee78fa3          	sb	a4,-1(a5)
  7c:	fe0718e3          	bnez	a4,6c <strcpy+0x10>
    ;
  return os;
}
  80:	00813403          	ld	s0,8(sp)
  84:	01010113          	add	sp,sp,16
  88:	00008067          	ret

000000000000008c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8c:	ff010113          	add	sp,sp,-16
  90:	00813423          	sd	s0,8(sp)
  94:	01010413          	add	s0,sp,16
  while(*p && *p == *q)
  98:	00054783          	lbu	a5,0(a0)
  9c:	00078e63          	beqz	a5,b8 <strcmp+0x2c>
  a0:	0005c703          	lbu	a4,0(a1)
  a4:	00f71a63          	bne	a4,a5,b8 <strcmp+0x2c>
    p++, q++;
  a8:	00150513          	add	a0,a0,1
  ac:	00158593          	add	a1,a1,1
  while(*p && *p == *q)
  b0:	00054783          	lbu	a5,0(a0)
  b4:	fe0796e3          	bnez	a5,a0 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
  b8:	0005c503          	lbu	a0,0(a1)
}
  bc:	40a7853b          	subw	a0,a5,a0
  c0:	00813403          	ld	s0,8(sp)
  c4:	01010113          	add	sp,sp,16
  c8:	00008067          	ret

00000000000000cc <strlen>:

uint
strlen(const char *s)
{
  cc:	ff010113          	add	sp,sp,-16
  d0:	00813423          	sd	s0,8(sp)
  d4:	01010413          	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  d8:	00054783          	lbu	a5,0(a0)
  dc:	02078863          	beqz	a5,10c <strlen+0x40>
  e0:	00150513          	add	a0,a0,1
  e4:	00050793          	mv	a5,a0
  e8:	00078693          	mv	a3,a5
  ec:	00178793          	add	a5,a5,1
  f0:	fff7c703          	lbu	a4,-1(a5)
  f4:	fe071ae3          	bnez	a4,e8 <strlen+0x1c>
  f8:	40a6853b          	subw	a0,a3,a0
  fc:	0015051b          	addw	a0,a0,1
    ;
  return n;
}
 100:	00813403          	ld	s0,8(sp)
 104:	01010113          	add	sp,sp,16
 108:	00008067          	ret
  for(n = 0; s[n]; n++)
 10c:	00000513          	li	a0,0
 110:	ff1ff06f          	j	100 <strlen+0x34>

0000000000000114 <memset>:

void*
memset(void *dst, int c, uint n)
{
 114:	ff010113          	add	sp,sp,-16
 118:	00813423          	sd	s0,8(sp)
 11c:	01010413          	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 120:	02060063          	beqz	a2,140 <memset+0x2c>
 124:	00050793          	mv	a5,a0
 128:	02061613          	sll	a2,a2,0x20
 12c:	02065613          	srl	a2,a2,0x20
 130:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 134:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 138:	00178793          	add	a5,a5,1
 13c:	fee79ce3          	bne	a5,a4,134 <memset+0x20>
  }
  return dst;
}
 140:	00813403          	ld	s0,8(sp)
 144:	01010113          	add	sp,sp,16
 148:	00008067          	ret

000000000000014c <strchr>:

char*
strchr(const char *s, char c)
{
 14c:	ff010113          	add	sp,sp,-16
 150:	00813423          	sd	s0,8(sp)
 154:	01010413          	add	s0,sp,16
  for(; *s; s++)
 158:	00054783          	lbu	a5,0(a0)
 15c:	02078263          	beqz	a5,180 <strchr+0x34>
    if(*s == c)
 160:	00f58a63          	beq	a1,a5,174 <strchr+0x28>
  for(; *s; s++)
 164:	00150513          	add	a0,a0,1
 168:	00054783          	lbu	a5,0(a0)
 16c:	fe079ae3          	bnez	a5,160 <strchr+0x14>
      return (char*)s;
  return 0;
 170:	00000513          	li	a0,0
}
 174:	00813403          	ld	s0,8(sp)
 178:	01010113          	add	sp,sp,16
 17c:	00008067          	ret
  return 0;
 180:	00000513          	li	a0,0
 184:	ff1ff06f          	j	174 <strchr+0x28>

0000000000000188 <gets>:

char*
gets(char *buf, int max)
{
 188:	fa010113          	add	sp,sp,-96
 18c:	04113c23          	sd	ra,88(sp)
 190:	04813823          	sd	s0,80(sp)
 194:	04913423          	sd	s1,72(sp)
 198:	05213023          	sd	s2,64(sp)
 19c:	03313c23          	sd	s3,56(sp)
 1a0:	03413823          	sd	s4,48(sp)
 1a4:	03513423          	sd	s5,40(sp)
 1a8:	03613023          	sd	s6,32(sp)
 1ac:	01713c23          	sd	s7,24(sp)
 1b0:	06010413          	add	s0,sp,96
 1b4:	00050b93          	mv	s7,a0
 1b8:	00058a13          	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1bc:	00050913          	mv	s2,a0
 1c0:	00000493          	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1c4:	00a00a93          	li	s5,10
 1c8:	00d00b13          	li	s6,13
  for(i=0; i+1 < max; ){
 1cc:	00048993          	mv	s3,s1
 1d0:	0014849b          	addw	s1,s1,1
 1d4:	0344de63          	bge	s1,s4,210 <gets+0x88>
    cc = read(0, &c, 1);
 1d8:	00100613          	li	a2,1
 1dc:	faf40593          	add	a1,s0,-81
 1e0:	00000513          	li	a0,0
 1e4:	00000097          	auipc	ra,0x0
 1e8:	268080e7          	jalr	616(ra) # 44c <read>
    if(cc < 1)
 1ec:	02a05263          	blez	a0,210 <gets+0x88>
    buf[i++] = c;
 1f0:	faf44783          	lbu	a5,-81(s0)
 1f4:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1f8:	01578a63          	beq	a5,s5,20c <gets+0x84>
 1fc:	00190913          	add	s2,s2,1
 200:	fd6796e3          	bne	a5,s6,1cc <gets+0x44>
  for(i=0; i+1 < max; ){
 204:	00048993          	mv	s3,s1
 208:	0080006f          	j	210 <gets+0x88>
 20c:	00048993          	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 210:	013b89b3          	add	s3,s7,s3
 214:	00098023          	sb	zero,0(s3)
  return buf;
}
 218:	000b8513          	mv	a0,s7
 21c:	05813083          	ld	ra,88(sp)
 220:	05013403          	ld	s0,80(sp)
 224:	04813483          	ld	s1,72(sp)
 228:	04013903          	ld	s2,64(sp)
 22c:	03813983          	ld	s3,56(sp)
 230:	03013a03          	ld	s4,48(sp)
 234:	02813a83          	ld	s5,40(sp)
 238:	02013b03          	ld	s6,32(sp)
 23c:	01813b83          	ld	s7,24(sp)
 240:	06010113          	add	sp,sp,96
 244:	00008067          	ret

0000000000000248 <stat>:

int
stat(const char *n, struct stat *st)
{
 248:	fe010113          	add	sp,sp,-32
 24c:	00113c23          	sd	ra,24(sp)
 250:	00813823          	sd	s0,16(sp)
 254:	00913423          	sd	s1,8(sp)
 258:	01213023          	sd	s2,0(sp)
 25c:	02010413          	add	s0,sp,32
 260:	00058913          	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 264:	00000593          	li	a1,0
 268:	00000097          	auipc	ra,0x0
 26c:	220080e7          	jalr	544(ra) # 488 <open>
  if(fd < 0)
 270:	04054063          	bltz	a0,2b0 <stat+0x68>
 274:	00050493          	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 278:	00090593          	mv	a1,s2
 27c:	00000097          	auipc	ra,0x0
 280:	230080e7          	jalr	560(ra) # 4ac <fstat>
 284:	00050913          	mv	s2,a0
  close(fd);
 288:	00048513          	mv	a0,s1
 28c:	00000097          	auipc	ra,0x0
 290:	1d8080e7          	jalr	472(ra) # 464 <close>
  return r;
}
 294:	00090513          	mv	a0,s2
 298:	01813083          	ld	ra,24(sp)
 29c:	01013403          	ld	s0,16(sp)
 2a0:	00813483          	ld	s1,8(sp)
 2a4:	00013903          	ld	s2,0(sp)
 2a8:	02010113          	add	sp,sp,32
 2ac:	00008067          	ret
    return -1;
 2b0:	fff00913          	li	s2,-1
 2b4:	fe1ff06f          	j	294 <stat+0x4c>

00000000000002b8 <atoi>:

int
atoi(const char *s)
{
 2b8:	ff010113          	add	sp,sp,-16
 2bc:	00813423          	sd	s0,8(sp)
 2c0:	01010413          	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2c4:	00054683          	lbu	a3,0(a0)
 2c8:	fd06879b          	addw	a5,a3,-48
 2cc:	0ff7f793          	zext.b	a5,a5
 2d0:	00900613          	li	a2,9
 2d4:	04f66063          	bltu	a2,a5,314 <atoi+0x5c>
 2d8:	00050713          	mv	a4,a0
  n = 0;
 2dc:	00000513          	li	a0,0
    n = n*10 + *s++ - '0';
 2e0:	00170713          	add	a4,a4,1
 2e4:	0025179b          	sllw	a5,a0,0x2
 2e8:	00a787bb          	addw	a5,a5,a0
 2ec:	0017979b          	sllw	a5,a5,0x1
 2f0:	00d787bb          	addw	a5,a5,a3
 2f4:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2f8:	00074683          	lbu	a3,0(a4)
 2fc:	fd06879b          	addw	a5,a3,-48
 300:	0ff7f793          	zext.b	a5,a5
 304:	fcf67ee3          	bgeu	a2,a5,2e0 <atoi+0x28>
  return n;
}
 308:	00813403          	ld	s0,8(sp)
 30c:	01010113          	add	sp,sp,16
 310:	00008067          	ret
  n = 0;
 314:	00000513          	li	a0,0
 318:	ff1ff06f          	j	308 <atoi+0x50>

000000000000031c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 31c:	ff010113          	add	sp,sp,-16
 320:	00813423          	sd	s0,8(sp)
 324:	01010413          	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 328:	02b57c63          	bgeu	a0,a1,360 <memmove+0x44>
    while(n-- > 0)
 32c:	02c05463          	blez	a2,354 <memmove+0x38>
 330:	02061613          	sll	a2,a2,0x20
 334:	02065613          	srl	a2,a2,0x20
 338:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 33c:	00050713          	mv	a4,a0
      *dst++ = *src++;
 340:	00158593          	add	a1,a1,1
 344:	00170713          	add	a4,a4,1
 348:	fff5c683          	lbu	a3,-1(a1)
 34c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 350:	fee798e3          	bne	a5,a4,340 <memmove+0x24>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 354:	00813403          	ld	s0,8(sp)
 358:	01010113          	add	sp,sp,16
 35c:	00008067          	ret
    dst += n;
 360:	00c50733          	add	a4,a0,a2
    src += n;
 364:	00c585b3          	add	a1,a1,a2
    while(n-- > 0)
 368:	fec056e3          	blez	a2,354 <memmove+0x38>
 36c:	fff6079b          	addw	a5,a2,-1
 370:	02079793          	sll	a5,a5,0x20
 374:	0207d793          	srl	a5,a5,0x20
 378:	fff7c793          	not	a5,a5
 37c:	00f707b3          	add	a5,a4,a5
      *--dst = *--src;
 380:	fff58593          	add	a1,a1,-1
 384:	fff70713          	add	a4,a4,-1
 388:	0005c683          	lbu	a3,0(a1)
 38c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 390:	fee798e3          	bne	a5,a4,380 <memmove+0x64>
 394:	fc1ff06f          	j	354 <memmove+0x38>

0000000000000398 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 398:	ff010113          	add	sp,sp,-16
 39c:	00813423          	sd	s0,8(sp)
 3a0:	01010413          	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3a4:	04060463          	beqz	a2,3ec <memcmp+0x54>
 3a8:	fff6069b          	addw	a3,a2,-1
 3ac:	02069693          	sll	a3,a3,0x20
 3b0:	0206d693          	srl	a3,a3,0x20
 3b4:	00168693          	add	a3,a3,1
 3b8:	00d506b3          	add	a3,a0,a3
    if (*p1 != *p2) {
 3bc:	00054783          	lbu	a5,0(a0)
 3c0:	0005c703          	lbu	a4,0(a1)
 3c4:	00e79c63          	bne	a5,a4,3dc <memcmp+0x44>
      return *p1 - *p2;
    }
    p1++;
 3c8:	00150513          	add	a0,a0,1
    p2++;
 3cc:	00158593          	add	a1,a1,1
  while (n-- > 0) {
 3d0:	fed516e3          	bne	a0,a3,3bc <memcmp+0x24>
  }
  return 0;
 3d4:	00000513          	li	a0,0
 3d8:	0080006f          	j	3e0 <memcmp+0x48>
      return *p1 - *p2;
 3dc:	40e7853b          	subw	a0,a5,a4
}
 3e0:	00813403          	ld	s0,8(sp)
 3e4:	01010113          	add	sp,sp,16
 3e8:	00008067          	ret
  return 0;
 3ec:	00000513          	li	a0,0
 3f0:	ff1ff06f          	j	3e0 <memcmp+0x48>

00000000000003f4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3f4:	ff010113          	add	sp,sp,-16
 3f8:	00113423          	sd	ra,8(sp)
 3fc:	00813023          	sd	s0,0(sp)
 400:	01010413          	add	s0,sp,16
  return memmove(dst, src, n);
 404:	00000097          	auipc	ra,0x0
 408:	f18080e7          	jalr	-232(ra) # 31c <memmove>
}
 40c:	00813083          	ld	ra,8(sp)
 410:	00013403          	ld	s0,0(sp)
 414:	01010113          	add	sp,sp,16
 418:	00008067          	ret

000000000000041c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 41c:	00100893          	li	a7,1
 ecall
 420:	00000073          	ecall
 ret
 424:	00008067          	ret

0000000000000428 <exit>:
.global exit
exit:
 li a7, SYS_exit
 428:	00200893          	li	a7,2
 ecall
 42c:	00000073          	ecall
 ret
 430:	00008067          	ret

0000000000000434 <wait>:
.global wait
wait:
 li a7, SYS_wait
 434:	00300893          	li	a7,3
 ecall
 438:	00000073          	ecall
 ret
 43c:	00008067          	ret

0000000000000440 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 440:	00400893          	li	a7,4
 ecall
 444:	00000073          	ecall
 ret
 448:	00008067          	ret

000000000000044c <read>:
.global read
read:
 li a7, SYS_read
 44c:	00500893          	li	a7,5
 ecall
 450:	00000073          	ecall
 ret
 454:	00008067          	ret

0000000000000458 <write>:
.global write
write:
 li a7, SYS_write
 458:	01000893          	li	a7,16
 ecall
 45c:	00000073          	ecall
 ret
 460:	00008067          	ret

0000000000000464 <close>:
.global close
close:
 li a7, SYS_close
 464:	01500893          	li	a7,21
 ecall
 468:	00000073          	ecall
 ret
 46c:	00008067          	ret

0000000000000470 <kill>:
.global kill
kill:
 li a7, SYS_kill
 470:	00600893          	li	a7,6
 ecall
 474:	00000073          	ecall
 ret
 478:	00008067          	ret

000000000000047c <exec>:
.global exec
exec:
 li a7, SYS_exec
 47c:	00700893          	li	a7,7
 ecall
 480:	00000073          	ecall
 ret
 484:	00008067          	ret

0000000000000488 <open>:
.global open
open:
 li a7, SYS_open
 488:	00f00893          	li	a7,15
 ecall
 48c:	00000073          	ecall
 ret
 490:	00008067          	ret

0000000000000494 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 494:	01100893          	li	a7,17
 ecall
 498:	00000073          	ecall
 ret
 49c:	00008067          	ret

00000000000004a0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4a0:	01200893          	li	a7,18
 ecall
 4a4:	00000073          	ecall
 ret
 4a8:	00008067          	ret

00000000000004ac <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4ac:	00800893          	li	a7,8
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	00008067          	ret

00000000000004b8 <link>:
.global link
link:
 li a7, SYS_link
 4b8:	01300893          	li	a7,19
 ecall
 4bc:	00000073          	ecall
 ret
 4c0:	00008067          	ret

00000000000004c4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4c4:	01400893          	li	a7,20
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	00008067          	ret

00000000000004d0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4d0:	00900893          	li	a7,9
 ecall
 4d4:	00000073          	ecall
 ret
 4d8:	00008067          	ret

00000000000004dc <dup>:
.global dup
dup:
 li a7, SYS_dup
 4dc:	00a00893          	li	a7,10
 ecall
 4e0:	00000073          	ecall
 ret
 4e4:	00008067          	ret

00000000000004e8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4e8:	00b00893          	li	a7,11
 ecall
 4ec:	00000073          	ecall
 ret
 4f0:	00008067          	ret

00000000000004f4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4f4:	00c00893          	li	a7,12
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	00008067          	ret

0000000000000500 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 500:	00d00893          	li	a7,13
 ecall
 504:	00000073          	ecall
 ret
 508:	00008067          	ret

000000000000050c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 50c:	00e00893          	li	a7,14
 ecall
 510:	00000073          	ecall
 ret
 514:	00008067          	ret

0000000000000518 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 518:	fe010113          	add	sp,sp,-32
 51c:	00113c23          	sd	ra,24(sp)
 520:	00813823          	sd	s0,16(sp)
 524:	02010413          	add	s0,sp,32
 528:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 52c:	00100613          	li	a2,1
 530:	fef40593          	add	a1,s0,-17
 534:	00000097          	auipc	ra,0x0
 538:	f24080e7          	jalr	-220(ra) # 458 <write>
}
 53c:	01813083          	ld	ra,24(sp)
 540:	01013403          	ld	s0,16(sp)
 544:	02010113          	add	sp,sp,32
 548:	00008067          	ret

000000000000054c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 54c:	fc010113          	add	sp,sp,-64
 550:	02113c23          	sd	ra,56(sp)
 554:	02813823          	sd	s0,48(sp)
 558:	02913423          	sd	s1,40(sp)
 55c:	03213023          	sd	s2,32(sp)
 560:	01313c23          	sd	s3,24(sp)
 564:	04010413          	add	s0,sp,64
 568:	00050493          	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 56c:	00068463          	beqz	a3,574 <printint+0x28>
 570:	0c05c063          	bltz	a1,630 <printint+0xe4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 574:	0005859b          	sext.w	a1,a1
  neg = 0;
 578:	00000893          	li	a7,0
 57c:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 580:	00000713          	li	a4,0
  do{
    buf[i++] = digits[x % base];
 584:	0006061b          	sext.w	a2,a2
 588:	00000517          	auipc	a0,0x0
 58c:	62850513          	add	a0,a0,1576 # bb0 <digits>
 590:	00070813          	mv	a6,a4
 594:	0017071b          	addw	a4,a4,1
 598:	02c5f7bb          	remuw	a5,a1,a2
 59c:	02079793          	sll	a5,a5,0x20
 5a0:	0207d793          	srl	a5,a5,0x20
 5a4:	00f507b3          	add	a5,a0,a5
 5a8:	0007c783          	lbu	a5,0(a5)
 5ac:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5b0:	0005879b          	sext.w	a5,a1
 5b4:	02c5d5bb          	divuw	a1,a1,a2
 5b8:	00168693          	add	a3,a3,1
 5bc:	fcc7fae3          	bgeu	a5,a2,590 <printint+0x44>
  if(neg)
 5c0:	00088c63          	beqz	a7,5d8 <printint+0x8c>
    buf[i++] = '-';
 5c4:	fd070793          	add	a5,a4,-48
 5c8:	00878733          	add	a4,a5,s0
 5cc:	02d00793          	li	a5,45
 5d0:	fef70823          	sb	a5,-16(a4)
 5d4:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 5d8:	02e05e63          	blez	a4,614 <printint+0xc8>
 5dc:	fc040793          	add	a5,s0,-64
 5e0:	00e78933          	add	s2,a5,a4
 5e4:	fff78993          	add	s3,a5,-1
 5e8:	00e989b3          	add	s3,s3,a4
 5ec:	fff7071b          	addw	a4,a4,-1
 5f0:	02071713          	sll	a4,a4,0x20
 5f4:	02075713          	srl	a4,a4,0x20
 5f8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5fc:	fff94583          	lbu	a1,-1(s2)
 600:	00048513          	mv	a0,s1
 604:	00000097          	auipc	ra,0x0
 608:	f14080e7          	jalr	-236(ra) # 518 <putc>
  while(--i >= 0)
 60c:	fff90913          	add	s2,s2,-1
 610:	ff3916e3          	bne	s2,s3,5fc <printint+0xb0>
}
 614:	03813083          	ld	ra,56(sp)
 618:	03013403          	ld	s0,48(sp)
 61c:	02813483          	ld	s1,40(sp)
 620:	02013903          	ld	s2,32(sp)
 624:	01813983          	ld	s3,24(sp)
 628:	04010113          	add	sp,sp,64
 62c:	00008067          	ret
    x = -xx;
 630:	40b005bb          	negw	a1,a1
    neg = 1;
 634:	00100893          	li	a7,1
    x = -xx;
 638:	f45ff06f          	j	57c <printint+0x30>

000000000000063c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 63c:	fb010113          	add	sp,sp,-80
 640:	04113423          	sd	ra,72(sp)
 644:	04813023          	sd	s0,64(sp)
 648:	02913c23          	sd	s1,56(sp)
 64c:	03213823          	sd	s2,48(sp)
 650:	03313423          	sd	s3,40(sp)
 654:	03413023          	sd	s4,32(sp)
 658:	01513c23          	sd	s5,24(sp)
 65c:	01613823          	sd	s6,16(sp)
 660:	01713423          	sd	s7,8(sp)
 664:	01813023          	sd	s8,0(sp)
 668:	05010413          	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 66c:	0005c903          	lbu	s2,0(a1)
 670:	20090e63          	beqz	s2,88c <vprintf+0x250>
 674:	00050a93          	mv	s5,a0
 678:	00060b93          	mv	s7,a2
 67c:	00158493          	add	s1,a1,1
  state = 0;
 680:	00000993          	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 684:	02500a13          	li	s4,37
 688:	01500b13          	li	s6,21
 68c:	0280006f          	j	6b4 <vprintf+0x78>
        putc(fd, c);
 690:	00090593          	mv	a1,s2
 694:	000a8513          	mv	a0,s5
 698:	00000097          	auipc	ra,0x0
 69c:	e80080e7          	jalr	-384(ra) # 518 <putc>
 6a0:	0080006f          	j	6a8 <vprintf+0x6c>
    } else if(state == '%'){
 6a4:	03498063          	beq	s3,s4,6c4 <vprintf+0x88>
  for(i = 0; fmt[i]; i++){
 6a8:	00148493          	add	s1,s1,1
 6ac:	fff4c903          	lbu	s2,-1(s1)
 6b0:	1c090e63          	beqz	s2,88c <vprintf+0x250>
    if(state == 0){
 6b4:	fe0998e3          	bnez	s3,6a4 <vprintf+0x68>
      if(c == '%'){
 6b8:	fd491ce3          	bne	s2,s4,690 <vprintf+0x54>
        state = '%';
 6bc:	000a0993          	mv	s3,s4
 6c0:	fe9ff06f          	j	6a8 <vprintf+0x6c>
      if(c == 'd'){
 6c4:	17490e63          	beq	s2,s4,840 <vprintf+0x204>
 6c8:	f9d9079b          	addw	a5,s2,-99
 6cc:	0ff7f793          	zext.b	a5,a5
 6d0:	18fb6463          	bltu	s6,a5,858 <vprintf+0x21c>
 6d4:	f9d9079b          	addw	a5,s2,-99
 6d8:	0ff7f713          	zext.b	a4,a5
 6dc:	16eb6e63          	bltu	s6,a4,858 <vprintf+0x21c>
 6e0:	00271793          	sll	a5,a4,0x2
 6e4:	00000717          	auipc	a4,0x0
 6e8:	47470713          	add	a4,a4,1140 # b58 <malloc+0x150>
 6ec:	00e787b3          	add	a5,a5,a4
 6f0:	0007a783          	lw	a5,0(a5)
 6f4:	00e787b3          	add	a5,a5,a4
 6f8:	00078067          	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 6fc:	008b8913          	add	s2,s7,8
 700:	00100693          	li	a3,1
 704:	00a00613          	li	a2,10
 708:	000ba583          	lw	a1,0(s7)
 70c:	000a8513          	mv	a0,s5
 710:	00000097          	auipc	ra,0x0
 714:	e3c080e7          	jalr	-452(ra) # 54c <printint>
 718:	00090b93          	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 71c:	00000993          	li	s3,0
 720:	f89ff06f          	j	6a8 <vprintf+0x6c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 724:	008b8913          	add	s2,s7,8
 728:	00000693          	li	a3,0
 72c:	00a00613          	li	a2,10
 730:	000ba583          	lw	a1,0(s7)
 734:	000a8513          	mv	a0,s5
 738:	00000097          	auipc	ra,0x0
 73c:	e14080e7          	jalr	-492(ra) # 54c <printint>
 740:	00090b93          	mv	s7,s2
      state = 0;
 744:	00000993          	li	s3,0
 748:	f61ff06f          	j	6a8 <vprintf+0x6c>
        printint(fd, va_arg(ap, int), 16, 0);
 74c:	008b8913          	add	s2,s7,8
 750:	00000693          	li	a3,0
 754:	01000613          	li	a2,16
 758:	000ba583          	lw	a1,0(s7)
 75c:	000a8513          	mv	a0,s5
 760:	00000097          	auipc	ra,0x0
 764:	dec080e7          	jalr	-532(ra) # 54c <printint>
 768:	00090b93          	mv	s7,s2
      state = 0;
 76c:	00000993          	li	s3,0
 770:	f39ff06f          	j	6a8 <vprintf+0x6c>
        printptr(fd, va_arg(ap, uint64));
 774:	008b8c13          	add	s8,s7,8
 778:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 77c:	03000593          	li	a1,48
 780:	000a8513          	mv	a0,s5
 784:	00000097          	auipc	ra,0x0
 788:	d94080e7          	jalr	-620(ra) # 518 <putc>
  putc(fd, 'x');
 78c:	07800593          	li	a1,120
 790:	000a8513          	mv	a0,s5
 794:	00000097          	auipc	ra,0x0
 798:	d84080e7          	jalr	-636(ra) # 518 <putc>
 79c:	01000913          	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7a0:	00000b97          	auipc	s7,0x0
 7a4:	410b8b93          	add	s7,s7,1040 # bb0 <digits>
 7a8:	03c9d793          	srl	a5,s3,0x3c
 7ac:	00fb87b3          	add	a5,s7,a5
 7b0:	0007c583          	lbu	a1,0(a5)
 7b4:	000a8513          	mv	a0,s5
 7b8:	00000097          	auipc	ra,0x0
 7bc:	d60080e7          	jalr	-672(ra) # 518 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7c0:	00499993          	sll	s3,s3,0x4
 7c4:	fff9091b          	addw	s2,s2,-1
 7c8:	fe0910e3          	bnez	s2,7a8 <vprintf+0x16c>
        printptr(fd, va_arg(ap, uint64));
 7cc:	000c0b93          	mv	s7,s8
      state = 0;
 7d0:	00000993          	li	s3,0
 7d4:	ed5ff06f          	j	6a8 <vprintf+0x6c>
        s = va_arg(ap, char*);
 7d8:	008b8993          	add	s3,s7,8
 7dc:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 7e0:	02090863          	beqz	s2,810 <vprintf+0x1d4>
        while(*s != 0){
 7e4:	00094583          	lbu	a1,0(s2)
 7e8:	08058c63          	beqz	a1,880 <vprintf+0x244>
          putc(fd, *s);
 7ec:	000a8513          	mv	a0,s5
 7f0:	00000097          	auipc	ra,0x0
 7f4:	d28080e7          	jalr	-728(ra) # 518 <putc>
          s++;
 7f8:	00190913          	add	s2,s2,1
        while(*s != 0){
 7fc:	00094583          	lbu	a1,0(s2)
 800:	fe0596e3          	bnez	a1,7ec <vprintf+0x1b0>
        s = va_arg(ap, char*);
 804:	00098b93          	mv	s7,s3
      state = 0;
 808:	00000993          	li	s3,0
 80c:	e9dff06f          	j	6a8 <vprintf+0x6c>
          s = "(null)";
 810:	00000917          	auipc	s2,0x0
 814:	34090913          	add	s2,s2,832 # b50 <malloc+0x148>
        while(*s != 0){
 818:	02800593          	li	a1,40
 81c:	fd1ff06f          	j	7ec <vprintf+0x1b0>
        putc(fd, va_arg(ap, uint));
 820:	008b8913          	add	s2,s7,8
 824:	000bc583          	lbu	a1,0(s7)
 828:	000a8513          	mv	a0,s5
 82c:	00000097          	auipc	ra,0x0
 830:	cec080e7          	jalr	-788(ra) # 518 <putc>
 834:	00090b93          	mv	s7,s2
      state = 0;
 838:	00000993          	li	s3,0
 83c:	e6dff06f          	j	6a8 <vprintf+0x6c>
        putc(fd, c);
 840:	02500593          	li	a1,37
 844:	000a8513          	mv	a0,s5
 848:	00000097          	auipc	ra,0x0
 84c:	cd0080e7          	jalr	-816(ra) # 518 <putc>
      state = 0;
 850:	00000993          	li	s3,0
 854:	e55ff06f          	j	6a8 <vprintf+0x6c>
        putc(fd, '%');
 858:	02500593          	li	a1,37
 85c:	000a8513          	mv	a0,s5
 860:	00000097          	auipc	ra,0x0
 864:	cb8080e7          	jalr	-840(ra) # 518 <putc>
        putc(fd, c);
 868:	00090593          	mv	a1,s2
 86c:	000a8513          	mv	a0,s5
 870:	00000097          	auipc	ra,0x0
 874:	ca8080e7          	jalr	-856(ra) # 518 <putc>
      state = 0;
 878:	00000993          	li	s3,0
 87c:	e2dff06f          	j	6a8 <vprintf+0x6c>
        s = va_arg(ap, char*);
 880:	00098b93          	mv	s7,s3
      state = 0;
 884:	00000993          	li	s3,0
 888:	e21ff06f          	j	6a8 <vprintf+0x6c>
    }
  }
}
 88c:	04813083          	ld	ra,72(sp)
 890:	04013403          	ld	s0,64(sp)
 894:	03813483          	ld	s1,56(sp)
 898:	03013903          	ld	s2,48(sp)
 89c:	02813983          	ld	s3,40(sp)
 8a0:	02013a03          	ld	s4,32(sp)
 8a4:	01813a83          	ld	s5,24(sp)
 8a8:	01013b03          	ld	s6,16(sp)
 8ac:	00813b83          	ld	s7,8(sp)
 8b0:	00013c03          	ld	s8,0(sp)
 8b4:	05010113          	add	sp,sp,80
 8b8:	00008067          	ret

00000000000008bc <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8bc:	fb010113          	add	sp,sp,-80
 8c0:	00113c23          	sd	ra,24(sp)
 8c4:	00813823          	sd	s0,16(sp)
 8c8:	02010413          	add	s0,sp,32
 8cc:	00c43023          	sd	a2,0(s0)
 8d0:	00d43423          	sd	a3,8(s0)
 8d4:	00e43823          	sd	a4,16(s0)
 8d8:	00f43c23          	sd	a5,24(s0)
 8dc:	03043023          	sd	a6,32(s0)
 8e0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8e4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8e8:	00040613          	mv	a2,s0
 8ec:	00000097          	auipc	ra,0x0
 8f0:	d50080e7          	jalr	-688(ra) # 63c <vprintf>
}
 8f4:	01813083          	ld	ra,24(sp)
 8f8:	01013403          	ld	s0,16(sp)
 8fc:	05010113          	add	sp,sp,80
 900:	00008067          	ret

0000000000000904 <printf>:

void
printf(const char *fmt, ...)
{
 904:	fa010113          	add	sp,sp,-96
 908:	00113c23          	sd	ra,24(sp)
 90c:	00813823          	sd	s0,16(sp)
 910:	02010413          	add	s0,sp,32
 914:	00b43423          	sd	a1,8(s0)
 918:	00c43823          	sd	a2,16(s0)
 91c:	00d43c23          	sd	a3,24(s0)
 920:	02e43023          	sd	a4,32(s0)
 924:	02f43423          	sd	a5,40(s0)
 928:	03043823          	sd	a6,48(s0)
 92c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 930:	00840613          	add	a2,s0,8
 934:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 938:	00050593          	mv	a1,a0
 93c:	00100513          	li	a0,1
 940:	00000097          	auipc	ra,0x0
 944:	cfc080e7          	jalr	-772(ra) # 63c <vprintf>
}
 948:	01813083          	ld	ra,24(sp)
 94c:	01013403          	ld	s0,16(sp)
 950:	06010113          	add	sp,sp,96
 954:	00008067          	ret

0000000000000958 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 958:	ff010113          	add	sp,sp,-16
 95c:	00813423          	sd	s0,8(sp)
 960:	01010413          	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 964:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 968:	00000797          	auipc	a5,0x0
 96c:	6987b783          	ld	a5,1688(a5) # 1000 <freep>
 970:	0400006f          	j	9b0 <free+0x58>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 974:	00862703          	lw	a4,8(a2)
 978:	00b7073b          	addw	a4,a4,a1
 97c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 980:	0007b703          	ld	a4,0(a5)
 984:	00073603          	ld	a2,0(a4)
 988:	0500006f          	j	9d8 <free+0x80>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 98c:	ff852703          	lw	a4,-8(a0)
 990:	00c7073b          	addw	a4,a4,a2
 994:	00e7a423          	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 998:	ff053683          	ld	a3,-16(a0)
 99c:	0540006f          	j	9f0 <free+0x98>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9a0:	0007b703          	ld	a4,0(a5)
 9a4:	00e7e463          	bltu	a5,a4,9ac <free+0x54>
 9a8:	00e6ec63          	bltu	a3,a4,9c0 <free+0x68>
{
 9ac:	00070793          	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9b0:	fed7f8e3          	bgeu	a5,a3,9a0 <free+0x48>
 9b4:	0007b703          	ld	a4,0(a5)
 9b8:	00e6e463          	bltu	a3,a4,9c0 <free+0x68>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9bc:	fee7e8e3          	bltu	a5,a4,9ac <free+0x54>
  if(bp + bp->s.size == p->s.ptr){
 9c0:	ff852583          	lw	a1,-8(a0)
 9c4:	0007b603          	ld	a2,0(a5)
 9c8:	02059813          	sll	a6,a1,0x20
 9cc:	01c85713          	srl	a4,a6,0x1c
 9d0:	00e68733          	add	a4,a3,a4
 9d4:	fae600e3          	beq	a2,a4,974 <free+0x1c>
    bp->s.ptr = p->s.ptr->s.ptr;
 9d8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9dc:	0087a603          	lw	a2,8(a5)
 9e0:	02061593          	sll	a1,a2,0x20
 9e4:	01c5d713          	srl	a4,a1,0x1c
 9e8:	00e78733          	add	a4,a5,a4
 9ec:	fae680e3          	beq	a3,a4,98c <free+0x34>
    p->s.ptr = bp->s.ptr;
 9f0:	00d7b023          	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9f4:	00000717          	auipc	a4,0x0
 9f8:	60f73623          	sd	a5,1548(a4) # 1000 <freep>
}
 9fc:	00813403          	ld	s0,8(sp)
 a00:	01010113          	add	sp,sp,16
 a04:	00008067          	ret

0000000000000a08 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a08:	fc010113          	add	sp,sp,-64
 a0c:	02113c23          	sd	ra,56(sp)
 a10:	02813823          	sd	s0,48(sp)
 a14:	02913423          	sd	s1,40(sp)
 a18:	03213023          	sd	s2,32(sp)
 a1c:	01313c23          	sd	s3,24(sp)
 a20:	01413823          	sd	s4,16(sp)
 a24:	01513423          	sd	s5,8(sp)
 a28:	01613023          	sd	s6,0(sp)
 a2c:	04010413          	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a30:	02051493          	sll	s1,a0,0x20
 a34:	0204d493          	srl	s1,s1,0x20
 a38:	00f48493          	add	s1,s1,15
 a3c:	0044d493          	srl	s1,s1,0x4
 a40:	0014899b          	addw	s3,s1,1
 a44:	00148493          	add	s1,s1,1
  if((prevp = freep) == 0){
 a48:	00000517          	auipc	a0,0x0
 a4c:	5b853503          	ld	a0,1464(a0) # 1000 <freep>
 a50:	02050e63          	beqz	a0,a8c <malloc+0x84>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a54:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a58:	0087a703          	lw	a4,8(a5)
 a5c:	04977663          	bgeu	a4,s1,aa8 <malloc+0xa0>
  if(nu < 4096)
 a60:	00098a13          	mv	s4,s3
 a64:	0009871b          	sext.w	a4,s3
 a68:	000016b7          	lui	a3,0x1
 a6c:	00d77463          	bgeu	a4,a3,a74 <malloc+0x6c>
 a70:	00001a37          	lui	s4,0x1
 a74:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a78:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a7c:	00000917          	auipc	s2,0x0
 a80:	58490913          	add	s2,s2,1412 # 1000 <freep>
  if(p == (char*)-1)
 a84:	fff00a93          	li	s5,-1
 a88:	0a00006f          	j	b28 <malloc+0x120>
    base.s.ptr = freep = prevp = &base;
 a8c:	00000797          	auipc	a5,0x0
 a90:	58478793          	add	a5,a5,1412 # 1010 <base>
 a94:	00000717          	auipc	a4,0x0
 a98:	56f73623          	sd	a5,1388(a4) # 1000 <freep>
 a9c:	00f7b023          	sd	a5,0(a5)
    base.s.size = 0;
 aa0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 aa4:	fbdff06f          	j	a60 <malloc+0x58>
      if(p->s.size == nunits)
 aa8:	04e48863          	beq	s1,a4,af8 <malloc+0xf0>
        p->s.size -= nunits;
 aac:	4137073b          	subw	a4,a4,s3
 ab0:	00e7a423          	sw	a4,8(a5)
        p += p->s.size;
 ab4:	02071693          	sll	a3,a4,0x20
 ab8:	01c6d713          	srl	a4,a3,0x1c
 abc:	00e787b3          	add	a5,a5,a4
        p->s.size = nunits;
 ac0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 ac4:	00000717          	auipc	a4,0x0
 ac8:	52a73e23          	sd	a0,1340(a4) # 1000 <freep>
      return (void*)(p + 1);
 acc:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 ad0:	03813083          	ld	ra,56(sp)
 ad4:	03013403          	ld	s0,48(sp)
 ad8:	02813483          	ld	s1,40(sp)
 adc:	02013903          	ld	s2,32(sp)
 ae0:	01813983          	ld	s3,24(sp)
 ae4:	01013a03          	ld	s4,16(sp)
 ae8:	00813a83          	ld	s5,8(sp)
 aec:	00013b03          	ld	s6,0(sp)
 af0:	04010113          	add	sp,sp,64
 af4:	00008067          	ret
        prevp->s.ptr = p->s.ptr;
 af8:	0007b703          	ld	a4,0(a5)
 afc:	00e53023          	sd	a4,0(a0)
 b00:	fc5ff06f          	j	ac4 <malloc+0xbc>
  hp->s.size = nu;
 b04:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 b08:	01050513          	add	a0,a0,16
 b0c:	00000097          	auipc	ra,0x0
 b10:	e4c080e7          	jalr	-436(ra) # 958 <free>
  return freep;
 b14:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 b18:	fa050ce3          	beqz	a0,ad0 <malloc+0xc8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b1c:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b20:	0087a703          	lw	a4,8(a5)
 b24:	f89772e3          	bgeu	a4,s1,aa8 <malloc+0xa0>
    if(p == freep)
 b28:	00093703          	ld	a4,0(s2)
 b2c:	00078513          	mv	a0,a5
 b30:	fef716e3          	bne	a4,a5,b1c <malloc+0x114>
  p = sbrk(nu * sizeof(Header));
 b34:	000a0513          	mv	a0,s4
 b38:	00000097          	auipc	ra,0x0
 b3c:	9bc080e7          	jalr	-1604(ra) # 4f4 <sbrk>
  if(p == (char*)-1)
 b40:	fd5512e3          	bne	a0,s5,b04 <malloc+0xfc>
        return 0;
 b44:	00000513          	li	a0,0
 b48:	f89ff06f          	j	ad0 <malloc+0xc8>
