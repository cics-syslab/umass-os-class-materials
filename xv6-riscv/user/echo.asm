
user/_echo:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	fc010113          	add	sp,sp,-64
   4:	02113c23          	sd	ra,56(sp)
   8:	02813823          	sd	s0,48(sp)
   c:	02913423          	sd	s1,40(sp)
  10:	03213023          	sd	s2,32(sp)
  14:	01313c23          	sd	s3,24(sp)
  18:	01413823          	sd	s4,16(sp)
  1c:	01513423          	sd	s5,8(sp)
  20:	04010413          	add	s0,sp,64
  int i;

  for(i = 1; i < argc; i++){
  24:	00100793          	li	a5,1
  28:	08a7d463          	bge	a5,a0,b0 <main+0xb0>
  2c:	00858493          	add	s1,a1,8
  30:	ffe5051b          	addw	a0,a0,-2
  34:	02051793          	sll	a5,a0,0x20
  38:	01d7d513          	srl	a0,a5,0x1d
  3c:	00a48a33          	add	s4,s1,a0
  40:	01058593          	add	a1,a1,16
  44:	00a589b3          	add	s3,a1,a0
    write(1, argv[i], strlen(argv[i]));
    if(i + 1 < argc){
      write(1, " ", 1);
  48:	00001a97          	auipc	s5,0x1
  4c:	b88a8a93          	add	s5,s5,-1144 # bd0 <malloc+0x144>
  50:	0200006f          	j	70 <main+0x70>
  54:	00100613          	li	a2,1
  58:	000a8593          	mv	a1,s5
  5c:	00100513          	li	a0,1
  60:	00000097          	auipc	ra,0x0
  64:	47c080e7          	jalr	1148(ra) # 4dc <write>
  for(i = 1; i < argc; i++){
  68:	00848493          	add	s1,s1,8
  6c:	05348263          	beq	s1,s3,b0 <main+0xb0>
    write(1, argv[i], strlen(argv[i]));
  70:	0004b903          	ld	s2,0(s1)
  74:	00090513          	mv	a0,s2
  78:	00000097          	auipc	ra,0x0
  7c:	0d8080e7          	jalr	216(ra) # 150 <strlen>
  80:	0005061b          	sext.w	a2,a0
  84:	00090593          	mv	a1,s2
  88:	00100513          	li	a0,1
  8c:	00000097          	auipc	ra,0x0
  90:	450080e7          	jalr	1104(ra) # 4dc <write>
    if(i + 1 < argc){
  94:	fd4490e3          	bne	s1,s4,54 <main+0x54>
    } else {
      write(1, "\n", 1);
  98:	00100613          	li	a2,1
  9c:	00001597          	auipc	a1,0x1
  a0:	b3c58593          	add	a1,a1,-1220 # bd8 <malloc+0x14c>
  a4:	00100513          	li	a0,1
  a8:	00000097          	auipc	ra,0x0
  ac:	434080e7          	jalr	1076(ra) # 4dc <write>
    }
  }
  exit(0);
  b0:	00000513          	li	a0,0
  b4:	00000097          	auipc	ra,0x0
  b8:	3f8080e7          	jalr	1016(ra) # 4ac <exit>

00000000000000bc <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  bc:	ff010113          	add	sp,sp,-16
  c0:	00113423          	sd	ra,8(sp)
  c4:	00813023          	sd	s0,0(sp)
  c8:	01010413          	add	s0,sp,16
  extern int main();
  main();
  cc:	00000097          	auipc	ra,0x0
  d0:	f34080e7          	jalr	-204(ra) # 0 <main>
  exit(0);
  d4:	00000513          	li	a0,0
  d8:	00000097          	auipc	ra,0x0
  dc:	3d4080e7          	jalr	980(ra) # 4ac <exit>

00000000000000e0 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  e0:	ff010113          	add	sp,sp,-16
  e4:	00813423          	sd	s0,8(sp)
  e8:	01010413          	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  ec:	00050793          	mv	a5,a0
  f0:	00158593          	add	a1,a1,1
  f4:	00178793          	add	a5,a5,1
  f8:	fff5c703          	lbu	a4,-1(a1)
  fc:	fee78fa3          	sb	a4,-1(a5)
 100:	fe0718e3          	bnez	a4,f0 <strcpy+0x10>
    ;
  return os;
}
 104:	00813403          	ld	s0,8(sp)
 108:	01010113          	add	sp,sp,16
 10c:	00008067          	ret

0000000000000110 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 110:	ff010113          	add	sp,sp,-16
 114:	00813423          	sd	s0,8(sp)
 118:	01010413          	add	s0,sp,16
  while(*p && *p == *q)
 11c:	00054783          	lbu	a5,0(a0)
 120:	00078e63          	beqz	a5,13c <strcmp+0x2c>
 124:	0005c703          	lbu	a4,0(a1)
 128:	00f71a63          	bne	a4,a5,13c <strcmp+0x2c>
    p++, q++;
 12c:	00150513          	add	a0,a0,1
 130:	00158593          	add	a1,a1,1
  while(*p && *p == *q)
 134:	00054783          	lbu	a5,0(a0)
 138:	fe0796e3          	bnez	a5,124 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 13c:	0005c503          	lbu	a0,0(a1)
}
 140:	40a7853b          	subw	a0,a5,a0
 144:	00813403          	ld	s0,8(sp)
 148:	01010113          	add	sp,sp,16
 14c:	00008067          	ret

0000000000000150 <strlen>:

uint
strlen(const char *s)
{
 150:	ff010113          	add	sp,sp,-16
 154:	00813423          	sd	s0,8(sp)
 158:	01010413          	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 15c:	00054783          	lbu	a5,0(a0)
 160:	02078863          	beqz	a5,190 <strlen+0x40>
 164:	00150513          	add	a0,a0,1
 168:	00050793          	mv	a5,a0
 16c:	00078693          	mv	a3,a5
 170:	00178793          	add	a5,a5,1
 174:	fff7c703          	lbu	a4,-1(a5)
 178:	fe071ae3          	bnez	a4,16c <strlen+0x1c>
 17c:	40a6853b          	subw	a0,a3,a0
 180:	0015051b          	addw	a0,a0,1
    ;
  return n;
}
 184:	00813403          	ld	s0,8(sp)
 188:	01010113          	add	sp,sp,16
 18c:	00008067          	ret
  for(n = 0; s[n]; n++)
 190:	00000513          	li	a0,0
 194:	ff1ff06f          	j	184 <strlen+0x34>

0000000000000198 <memset>:

void*
memset(void *dst, int c, uint n)
{
 198:	ff010113          	add	sp,sp,-16
 19c:	00813423          	sd	s0,8(sp)
 1a0:	01010413          	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1a4:	02060063          	beqz	a2,1c4 <memset+0x2c>
 1a8:	00050793          	mv	a5,a0
 1ac:	02061613          	sll	a2,a2,0x20
 1b0:	02065613          	srl	a2,a2,0x20
 1b4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1b8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1bc:	00178793          	add	a5,a5,1
 1c0:	fee79ce3          	bne	a5,a4,1b8 <memset+0x20>
  }
  return dst;
}
 1c4:	00813403          	ld	s0,8(sp)
 1c8:	01010113          	add	sp,sp,16
 1cc:	00008067          	ret

00000000000001d0 <strchr>:

char*
strchr(const char *s, char c)
{
 1d0:	ff010113          	add	sp,sp,-16
 1d4:	00813423          	sd	s0,8(sp)
 1d8:	01010413          	add	s0,sp,16
  for(; *s; s++)
 1dc:	00054783          	lbu	a5,0(a0)
 1e0:	02078263          	beqz	a5,204 <strchr+0x34>
    if(*s == c)
 1e4:	00f58a63          	beq	a1,a5,1f8 <strchr+0x28>
  for(; *s; s++)
 1e8:	00150513          	add	a0,a0,1
 1ec:	00054783          	lbu	a5,0(a0)
 1f0:	fe079ae3          	bnez	a5,1e4 <strchr+0x14>
      return (char*)s;
  return 0;
 1f4:	00000513          	li	a0,0
}
 1f8:	00813403          	ld	s0,8(sp)
 1fc:	01010113          	add	sp,sp,16
 200:	00008067          	ret
  return 0;
 204:	00000513          	li	a0,0
 208:	ff1ff06f          	j	1f8 <strchr+0x28>

000000000000020c <gets>:

char*
gets(char *buf, int max)
{
 20c:	fa010113          	add	sp,sp,-96
 210:	04113c23          	sd	ra,88(sp)
 214:	04813823          	sd	s0,80(sp)
 218:	04913423          	sd	s1,72(sp)
 21c:	05213023          	sd	s2,64(sp)
 220:	03313c23          	sd	s3,56(sp)
 224:	03413823          	sd	s4,48(sp)
 228:	03513423          	sd	s5,40(sp)
 22c:	03613023          	sd	s6,32(sp)
 230:	01713c23          	sd	s7,24(sp)
 234:	06010413          	add	s0,sp,96
 238:	00050b93          	mv	s7,a0
 23c:	00058a13          	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 240:	00050913          	mv	s2,a0
 244:	00000493          	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 248:	00a00a93          	li	s5,10
 24c:	00d00b13          	li	s6,13
  for(i=0; i+1 < max; ){
 250:	00048993          	mv	s3,s1
 254:	0014849b          	addw	s1,s1,1
 258:	0344de63          	bge	s1,s4,294 <gets+0x88>
    cc = read(0, &c, 1);
 25c:	00100613          	li	a2,1
 260:	faf40593          	add	a1,s0,-81
 264:	00000513          	li	a0,0
 268:	00000097          	auipc	ra,0x0
 26c:	268080e7          	jalr	616(ra) # 4d0 <read>
    if(cc < 1)
 270:	02a05263          	blez	a0,294 <gets+0x88>
    buf[i++] = c;
 274:	faf44783          	lbu	a5,-81(s0)
 278:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 27c:	01578a63          	beq	a5,s5,290 <gets+0x84>
 280:	00190913          	add	s2,s2,1
 284:	fd6796e3          	bne	a5,s6,250 <gets+0x44>
  for(i=0; i+1 < max; ){
 288:	00048993          	mv	s3,s1
 28c:	0080006f          	j	294 <gets+0x88>
 290:	00048993          	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 294:	013b89b3          	add	s3,s7,s3
 298:	00098023          	sb	zero,0(s3)
  return buf;
}
 29c:	000b8513          	mv	a0,s7
 2a0:	05813083          	ld	ra,88(sp)
 2a4:	05013403          	ld	s0,80(sp)
 2a8:	04813483          	ld	s1,72(sp)
 2ac:	04013903          	ld	s2,64(sp)
 2b0:	03813983          	ld	s3,56(sp)
 2b4:	03013a03          	ld	s4,48(sp)
 2b8:	02813a83          	ld	s5,40(sp)
 2bc:	02013b03          	ld	s6,32(sp)
 2c0:	01813b83          	ld	s7,24(sp)
 2c4:	06010113          	add	sp,sp,96
 2c8:	00008067          	ret

00000000000002cc <stat>:

int
stat(const char *n, struct stat *st)
{
 2cc:	fe010113          	add	sp,sp,-32
 2d0:	00113c23          	sd	ra,24(sp)
 2d4:	00813823          	sd	s0,16(sp)
 2d8:	00913423          	sd	s1,8(sp)
 2dc:	01213023          	sd	s2,0(sp)
 2e0:	02010413          	add	s0,sp,32
 2e4:	00058913          	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2e8:	00000593          	li	a1,0
 2ec:	00000097          	auipc	ra,0x0
 2f0:	220080e7          	jalr	544(ra) # 50c <open>
  if(fd < 0)
 2f4:	04054063          	bltz	a0,334 <stat+0x68>
 2f8:	00050493          	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2fc:	00090593          	mv	a1,s2
 300:	00000097          	auipc	ra,0x0
 304:	230080e7          	jalr	560(ra) # 530 <fstat>
 308:	00050913          	mv	s2,a0
  close(fd);
 30c:	00048513          	mv	a0,s1
 310:	00000097          	auipc	ra,0x0
 314:	1d8080e7          	jalr	472(ra) # 4e8 <close>
  return r;
}
 318:	00090513          	mv	a0,s2
 31c:	01813083          	ld	ra,24(sp)
 320:	01013403          	ld	s0,16(sp)
 324:	00813483          	ld	s1,8(sp)
 328:	00013903          	ld	s2,0(sp)
 32c:	02010113          	add	sp,sp,32
 330:	00008067          	ret
    return -1;
 334:	fff00913          	li	s2,-1
 338:	fe1ff06f          	j	318 <stat+0x4c>

000000000000033c <atoi>:

int
atoi(const char *s)
{
 33c:	ff010113          	add	sp,sp,-16
 340:	00813423          	sd	s0,8(sp)
 344:	01010413          	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 348:	00054683          	lbu	a3,0(a0)
 34c:	fd06879b          	addw	a5,a3,-48
 350:	0ff7f793          	zext.b	a5,a5
 354:	00900613          	li	a2,9
 358:	04f66063          	bltu	a2,a5,398 <atoi+0x5c>
 35c:	00050713          	mv	a4,a0
  n = 0;
 360:	00000513          	li	a0,0
    n = n*10 + *s++ - '0';
 364:	00170713          	add	a4,a4,1
 368:	0025179b          	sllw	a5,a0,0x2
 36c:	00a787bb          	addw	a5,a5,a0
 370:	0017979b          	sllw	a5,a5,0x1
 374:	00d787bb          	addw	a5,a5,a3
 378:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 37c:	00074683          	lbu	a3,0(a4)
 380:	fd06879b          	addw	a5,a3,-48
 384:	0ff7f793          	zext.b	a5,a5
 388:	fcf67ee3          	bgeu	a2,a5,364 <atoi+0x28>
  return n;
}
 38c:	00813403          	ld	s0,8(sp)
 390:	01010113          	add	sp,sp,16
 394:	00008067          	ret
  n = 0;
 398:	00000513          	li	a0,0
 39c:	ff1ff06f          	j	38c <atoi+0x50>

00000000000003a0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3a0:	ff010113          	add	sp,sp,-16
 3a4:	00813423          	sd	s0,8(sp)
 3a8:	01010413          	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3ac:	02b57c63          	bgeu	a0,a1,3e4 <memmove+0x44>
    while(n-- > 0)
 3b0:	02c05463          	blez	a2,3d8 <memmove+0x38>
 3b4:	02061613          	sll	a2,a2,0x20
 3b8:	02065613          	srl	a2,a2,0x20
 3bc:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3c0:	00050713          	mv	a4,a0
      *dst++ = *src++;
 3c4:	00158593          	add	a1,a1,1
 3c8:	00170713          	add	a4,a4,1
 3cc:	fff5c683          	lbu	a3,-1(a1)
 3d0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3d4:	fee798e3          	bne	a5,a4,3c4 <memmove+0x24>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3d8:	00813403          	ld	s0,8(sp)
 3dc:	01010113          	add	sp,sp,16
 3e0:	00008067          	ret
    dst += n;
 3e4:	00c50733          	add	a4,a0,a2
    src += n;
 3e8:	00c585b3          	add	a1,a1,a2
    while(n-- > 0)
 3ec:	fec056e3          	blez	a2,3d8 <memmove+0x38>
 3f0:	fff6079b          	addw	a5,a2,-1
 3f4:	02079793          	sll	a5,a5,0x20
 3f8:	0207d793          	srl	a5,a5,0x20
 3fc:	fff7c793          	not	a5,a5
 400:	00f707b3          	add	a5,a4,a5
      *--dst = *--src;
 404:	fff58593          	add	a1,a1,-1
 408:	fff70713          	add	a4,a4,-1
 40c:	0005c683          	lbu	a3,0(a1)
 410:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 414:	fee798e3          	bne	a5,a4,404 <memmove+0x64>
 418:	fc1ff06f          	j	3d8 <memmove+0x38>

000000000000041c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 41c:	ff010113          	add	sp,sp,-16
 420:	00813423          	sd	s0,8(sp)
 424:	01010413          	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 428:	04060463          	beqz	a2,470 <memcmp+0x54>
 42c:	fff6069b          	addw	a3,a2,-1
 430:	02069693          	sll	a3,a3,0x20
 434:	0206d693          	srl	a3,a3,0x20
 438:	00168693          	add	a3,a3,1
 43c:	00d506b3          	add	a3,a0,a3
    if (*p1 != *p2) {
 440:	00054783          	lbu	a5,0(a0)
 444:	0005c703          	lbu	a4,0(a1)
 448:	00e79c63          	bne	a5,a4,460 <memcmp+0x44>
      return *p1 - *p2;
    }
    p1++;
 44c:	00150513          	add	a0,a0,1
    p2++;
 450:	00158593          	add	a1,a1,1
  while (n-- > 0) {
 454:	fed516e3          	bne	a0,a3,440 <memcmp+0x24>
  }
  return 0;
 458:	00000513          	li	a0,0
 45c:	0080006f          	j	464 <memcmp+0x48>
      return *p1 - *p2;
 460:	40e7853b          	subw	a0,a5,a4
}
 464:	00813403          	ld	s0,8(sp)
 468:	01010113          	add	sp,sp,16
 46c:	00008067          	ret
  return 0;
 470:	00000513          	li	a0,0
 474:	ff1ff06f          	j	464 <memcmp+0x48>

0000000000000478 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 478:	ff010113          	add	sp,sp,-16
 47c:	00113423          	sd	ra,8(sp)
 480:	00813023          	sd	s0,0(sp)
 484:	01010413          	add	s0,sp,16
  return memmove(dst, src, n);
 488:	00000097          	auipc	ra,0x0
 48c:	f18080e7          	jalr	-232(ra) # 3a0 <memmove>
}
 490:	00813083          	ld	ra,8(sp)
 494:	00013403          	ld	s0,0(sp)
 498:	01010113          	add	sp,sp,16
 49c:	00008067          	ret

00000000000004a0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4a0:	00100893          	li	a7,1
 ecall
 4a4:	00000073          	ecall
 ret
 4a8:	00008067          	ret

00000000000004ac <exit>:
.global exit
exit:
 li a7, SYS_exit
 4ac:	00200893          	li	a7,2
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	00008067          	ret

00000000000004b8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4b8:	00300893          	li	a7,3
 ecall
 4bc:	00000073          	ecall
 ret
 4c0:	00008067          	ret

00000000000004c4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4c4:	00400893          	li	a7,4
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	00008067          	ret

00000000000004d0 <read>:
.global read
read:
 li a7, SYS_read
 4d0:	00500893          	li	a7,5
 ecall
 4d4:	00000073          	ecall
 ret
 4d8:	00008067          	ret

00000000000004dc <write>:
.global write
write:
 li a7, SYS_write
 4dc:	01000893          	li	a7,16
 ecall
 4e0:	00000073          	ecall
 ret
 4e4:	00008067          	ret

00000000000004e8 <close>:
.global close
close:
 li a7, SYS_close
 4e8:	01500893          	li	a7,21
 ecall
 4ec:	00000073          	ecall
 ret
 4f0:	00008067          	ret

00000000000004f4 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4f4:	00600893          	li	a7,6
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	00008067          	ret

0000000000000500 <exec>:
.global exec
exec:
 li a7, SYS_exec
 500:	00700893          	li	a7,7
 ecall
 504:	00000073          	ecall
 ret
 508:	00008067          	ret

000000000000050c <open>:
.global open
open:
 li a7, SYS_open
 50c:	00f00893          	li	a7,15
 ecall
 510:	00000073          	ecall
 ret
 514:	00008067          	ret

0000000000000518 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 518:	01100893          	li	a7,17
 ecall
 51c:	00000073          	ecall
 ret
 520:	00008067          	ret

0000000000000524 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 524:	01200893          	li	a7,18
 ecall
 528:	00000073          	ecall
 ret
 52c:	00008067          	ret

0000000000000530 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 530:	00800893          	li	a7,8
 ecall
 534:	00000073          	ecall
 ret
 538:	00008067          	ret

000000000000053c <link>:
.global link
link:
 li a7, SYS_link
 53c:	01300893          	li	a7,19
 ecall
 540:	00000073          	ecall
 ret
 544:	00008067          	ret

0000000000000548 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 548:	01400893          	li	a7,20
 ecall
 54c:	00000073          	ecall
 ret
 550:	00008067          	ret

0000000000000554 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 554:	00900893          	li	a7,9
 ecall
 558:	00000073          	ecall
 ret
 55c:	00008067          	ret

0000000000000560 <dup>:
.global dup
dup:
 li a7, SYS_dup
 560:	00a00893          	li	a7,10
 ecall
 564:	00000073          	ecall
 ret
 568:	00008067          	ret

000000000000056c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 56c:	00b00893          	li	a7,11
 ecall
 570:	00000073          	ecall
 ret
 574:	00008067          	ret

0000000000000578 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 578:	00c00893          	li	a7,12
 ecall
 57c:	00000073          	ecall
 ret
 580:	00008067          	ret

0000000000000584 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 584:	00d00893          	li	a7,13
 ecall
 588:	00000073          	ecall
 ret
 58c:	00008067          	ret

0000000000000590 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 590:	00e00893          	li	a7,14
 ecall
 594:	00000073          	ecall
 ret
 598:	00008067          	ret

000000000000059c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 59c:	fe010113          	add	sp,sp,-32
 5a0:	00113c23          	sd	ra,24(sp)
 5a4:	00813823          	sd	s0,16(sp)
 5a8:	02010413          	add	s0,sp,32
 5ac:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5b0:	00100613          	li	a2,1
 5b4:	fef40593          	add	a1,s0,-17
 5b8:	00000097          	auipc	ra,0x0
 5bc:	f24080e7          	jalr	-220(ra) # 4dc <write>
}
 5c0:	01813083          	ld	ra,24(sp)
 5c4:	01013403          	ld	s0,16(sp)
 5c8:	02010113          	add	sp,sp,32
 5cc:	00008067          	ret

00000000000005d0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5d0:	fc010113          	add	sp,sp,-64
 5d4:	02113c23          	sd	ra,56(sp)
 5d8:	02813823          	sd	s0,48(sp)
 5dc:	02913423          	sd	s1,40(sp)
 5e0:	03213023          	sd	s2,32(sp)
 5e4:	01313c23          	sd	s3,24(sp)
 5e8:	04010413          	add	s0,sp,64
 5ec:	00050493          	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5f0:	00068463          	beqz	a3,5f8 <printint+0x28>
 5f4:	0c05c063          	bltz	a1,6b4 <printint+0xe4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5f8:	0005859b          	sext.w	a1,a1
  neg = 0;
 5fc:	00000893          	li	a7,0
 600:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 604:	00000713          	li	a4,0
  do{
    buf[i++] = digits[x % base];
 608:	0006061b          	sext.w	a2,a2
 60c:	00000517          	auipc	a0,0x0
 610:	63450513          	add	a0,a0,1588 # c40 <digits>
 614:	00070813          	mv	a6,a4
 618:	0017071b          	addw	a4,a4,1
 61c:	02c5f7bb          	remuw	a5,a1,a2
 620:	02079793          	sll	a5,a5,0x20
 624:	0207d793          	srl	a5,a5,0x20
 628:	00f507b3          	add	a5,a0,a5
 62c:	0007c783          	lbu	a5,0(a5)
 630:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 634:	0005879b          	sext.w	a5,a1
 638:	02c5d5bb          	divuw	a1,a1,a2
 63c:	00168693          	add	a3,a3,1
 640:	fcc7fae3          	bgeu	a5,a2,614 <printint+0x44>
  if(neg)
 644:	00088c63          	beqz	a7,65c <printint+0x8c>
    buf[i++] = '-';
 648:	fd070793          	add	a5,a4,-48
 64c:	00878733          	add	a4,a5,s0
 650:	02d00793          	li	a5,45
 654:	fef70823          	sb	a5,-16(a4)
 658:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 65c:	02e05e63          	blez	a4,698 <printint+0xc8>
 660:	fc040793          	add	a5,s0,-64
 664:	00e78933          	add	s2,a5,a4
 668:	fff78993          	add	s3,a5,-1
 66c:	00e989b3          	add	s3,s3,a4
 670:	fff7071b          	addw	a4,a4,-1
 674:	02071713          	sll	a4,a4,0x20
 678:	02075713          	srl	a4,a4,0x20
 67c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 680:	fff94583          	lbu	a1,-1(s2)
 684:	00048513          	mv	a0,s1
 688:	00000097          	auipc	ra,0x0
 68c:	f14080e7          	jalr	-236(ra) # 59c <putc>
  while(--i >= 0)
 690:	fff90913          	add	s2,s2,-1
 694:	ff3916e3          	bne	s2,s3,680 <printint+0xb0>
}
 698:	03813083          	ld	ra,56(sp)
 69c:	03013403          	ld	s0,48(sp)
 6a0:	02813483          	ld	s1,40(sp)
 6a4:	02013903          	ld	s2,32(sp)
 6a8:	01813983          	ld	s3,24(sp)
 6ac:	04010113          	add	sp,sp,64
 6b0:	00008067          	ret
    x = -xx;
 6b4:	40b005bb          	negw	a1,a1
    neg = 1;
 6b8:	00100893          	li	a7,1
    x = -xx;
 6bc:	f45ff06f          	j	600 <printint+0x30>

00000000000006c0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6c0:	fb010113          	add	sp,sp,-80
 6c4:	04113423          	sd	ra,72(sp)
 6c8:	04813023          	sd	s0,64(sp)
 6cc:	02913c23          	sd	s1,56(sp)
 6d0:	03213823          	sd	s2,48(sp)
 6d4:	03313423          	sd	s3,40(sp)
 6d8:	03413023          	sd	s4,32(sp)
 6dc:	01513c23          	sd	s5,24(sp)
 6e0:	01613823          	sd	s6,16(sp)
 6e4:	01713423          	sd	s7,8(sp)
 6e8:	01813023          	sd	s8,0(sp)
 6ec:	05010413          	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6f0:	0005c903          	lbu	s2,0(a1)
 6f4:	20090e63          	beqz	s2,910 <vprintf+0x250>
 6f8:	00050a93          	mv	s5,a0
 6fc:	00060b93          	mv	s7,a2
 700:	00158493          	add	s1,a1,1
  state = 0;
 704:	00000993          	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 708:	02500a13          	li	s4,37
 70c:	01500b13          	li	s6,21
 710:	0280006f          	j	738 <vprintf+0x78>
        putc(fd, c);
 714:	00090593          	mv	a1,s2
 718:	000a8513          	mv	a0,s5
 71c:	00000097          	auipc	ra,0x0
 720:	e80080e7          	jalr	-384(ra) # 59c <putc>
 724:	0080006f          	j	72c <vprintf+0x6c>
    } else if(state == '%'){
 728:	03498063          	beq	s3,s4,748 <vprintf+0x88>
  for(i = 0; fmt[i]; i++){
 72c:	00148493          	add	s1,s1,1
 730:	fff4c903          	lbu	s2,-1(s1)
 734:	1c090e63          	beqz	s2,910 <vprintf+0x250>
    if(state == 0){
 738:	fe0998e3          	bnez	s3,728 <vprintf+0x68>
      if(c == '%'){
 73c:	fd491ce3          	bne	s2,s4,714 <vprintf+0x54>
        state = '%';
 740:	000a0993          	mv	s3,s4
 744:	fe9ff06f          	j	72c <vprintf+0x6c>
      if(c == 'd'){
 748:	17490e63          	beq	s2,s4,8c4 <vprintf+0x204>
 74c:	f9d9079b          	addw	a5,s2,-99
 750:	0ff7f793          	zext.b	a5,a5
 754:	18fb6463          	bltu	s6,a5,8dc <vprintf+0x21c>
 758:	f9d9079b          	addw	a5,s2,-99
 75c:	0ff7f713          	zext.b	a4,a5
 760:	16eb6e63          	bltu	s6,a4,8dc <vprintf+0x21c>
 764:	00271793          	sll	a5,a4,0x2
 768:	00000717          	auipc	a4,0x0
 76c:	48070713          	add	a4,a4,1152 # be8 <malloc+0x15c>
 770:	00e787b3          	add	a5,a5,a4
 774:	0007a783          	lw	a5,0(a5)
 778:	00e787b3          	add	a5,a5,a4
 77c:	00078067          	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 780:	008b8913          	add	s2,s7,8
 784:	00100693          	li	a3,1
 788:	00a00613          	li	a2,10
 78c:	000ba583          	lw	a1,0(s7)
 790:	000a8513          	mv	a0,s5
 794:	00000097          	auipc	ra,0x0
 798:	e3c080e7          	jalr	-452(ra) # 5d0 <printint>
 79c:	00090b93          	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 7a0:	00000993          	li	s3,0
 7a4:	f89ff06f          	j	72c <vprintf+0x6c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7a8:	008b8913          	add	s2,s7,8
 7ac:	00000693          	li	a3,0
 7b0:	00a00613          	li	a2,10
 7b4:	000ba583          	lw	a1,0(s7)
 7b8:	000a8513          	mv	a0,s5
 7bc:	00000097          	auipc	ra,0x0
 7c0:	e14080e7          	jalr	-492(ra) # 5d0 <printint>
 7c4:	00090b93          	mv	s7,s2
      state = 0;
 7c8:	00000993          	li	s3,0
 7cc:	f61ff06f          	j	72c <vprintf+0x6c>
        printint(fd, va_arg(ap, int), 16, 0);
 7d0:	008b8913          	add	s2,s7,8
 7d4:	00000693          	li	a3,0
 7d8:	01000613          	li	a2,16
 7dc:	000ba583          	lw	a1,0(s7)
 7e0:	000a8513          	mv	a0,s5
 7e4:	00000097          	auipc	ra,0x0
 7e8:	dec080e7          	jalr	-532(ra) # 5d0 <printint>
 7ec:	00090b93          	mv	s7,s2
      state = 0;
 7f0:	00000993          	li	s3,0
 7f4:	f39ff06f          	j	72c <vprintf+0x6c>
        printptr(fd, va_arg(ap, uint64));
 7f8:	008b8c13          	add	s8,s7,8
 7fc:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 800:	03000593          	li	a1,48
 804:	000a8513          	mv	a0,s5
 808:	00000097          	auipc	ra,0x0
 80c:	d94080e7          	jalr	-620(ra) # 59c <putc>
  putc(fd, 'x');
 810:	07800593          	li	a1,120
 814:	000a8513          	mv	a0,s5
 818:	00000097          	auipc	ra,0x0
 81c:	d84080e7          	jalr	-636(ra) # 59c <putc>
 820:	01000913          	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 824:	00000b97          	auipc	s7,0x0
 828:	41cb8b93          	add	s7,s7,1052 # c40 <digits>
 82c:	03c9d793          	srl	a5,s3,0x3c
 830:	00fb87b3          	add	a5,s7,a5
 834:	0007c583          	lbu	a1,0(a5)
 838:	000a8513          	mv	a0,s5
 83c:	00000097          	auipc	ra,0x0
 840:	d60080e7          	jalr	-672(ra) # 59c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 844:	00499993          	sll	s3,s3,0x4
 848:	fff9091b          	addw	s2,s2,-1
 84c:	fe0910e3          	bnez	s2,82c <vprintf+0x16c>
        printptr(fd, va_arg(ap, uint64));
 850:	000c0b93          	mv	s7,s8
      state = 0;
 854:	00000993          	li	s3,0
 858:	ed5ff06f          	j	72c <vprintf+0x6c>
        s = va_arg(ap, char*);
 85c:	008b8993          	add	s3,s7,8
 860:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 864:	02090863          	beqz	s2,894 <vprintf+0x1d4>
        while(*s != 0){
 868:	00094583          	lbu	a1,0(s2)
 86c:	08058c63          	beqz	a1,904 <vprintf+0x244>
          putc(fd, *s);
 870:	000a8513          	mv	a0,s5
 874:	00000097          	auipc	ra,0x0
 878:	d28080e7          	jalr	-728(ra) # 59c <putc>
          s++;
 87c:	00190913          	add	s2,s2,1
        while(*s != 0){
 880:	00094583          	lbu	a1,0(s2)
 884:	fe0596e3          	bnez	a1,870 <vprintf+0x1b0>
        s = va_arg(ap, char*);
 888:	00098b93          	mv	s7,s3
      state = 0;
 88c:	00000993          	li	s3,0
 890:	e9dff06f          	j	72c <vprintf+0x6c>
          s = "(null)";
 894:	00000917          	auipc	s2,0x0
 898:	34c90913          	add	s2,s2,844 # be0 <malloc+0x154>
        while(*s != 0){
 89c:	02800593          	li	a1,40
 8a0:	fd1ff06f          	j	870 <vprintf+0x1b0>
        putc(fd, va_arg(ap, uint));
 8a4:	008b8913          	add	s2,s7,8
 8a8:	000bc583          	lbu	a1,0(s7)
 8ac:	000a8513          	mv	a0,s5
 8b0:	00000097          	auipc	ra,0x0
 8b4:	cec080e7          	jalr	-788(ra) # 59c <putc>
 8b8:	00090b93          	mv	s7,s2
      state = 0;
 8bc:	00000993          	li	s3,0
 8c0:	e6dff06f          	j	72c <vprintf+0x6c>
        putc(fd, c);
 8c4:	02500593          	li	a1,37
 8c8:	000a8513          	mv	a0,s5
 8cc:	00000097          	auipc	ra,0x0
 8d0:	cd0080e7          	jalr	-816(ra) # 59c <putc>
      state = 0;
 8d4:	00000993          	li	s3,0
 8d8:	e55ff06f          	j	72c <vprintf+0x6c>
        putc(fd, '%');
 8dc:	02500593          	li	a1,37
 8e0:	000a8513          	mv	a0,s5
 8e4:	00000097          	auipc	ra,0x0
 8e8:	cb8080e7          	jalr	-840(ra) # 59c <putc>
        putc(fd, c);
 8ec:	00090593          	mv	a1,s2
 8f0:	000a8513          	mv	a0,s5
 8f4:	00000097          	auipc	ra,0x0
 8f8:	ca8080e7          	jalr	-856(ra) # 59c <putc>
      state = 0;
 8fc:	00000993          	li	s3,0
 900:	e2dff06f          	j	72c <vprintf+0x6c>
        s = va_arg(ap, char*);
 904:	00098b93          	mv	s7,s3
      state = 0;
 908:	00000993          	li	s3,0
 90c:	e21ff06f          	j	72c <vprintf+0x6c>
    }
  }
}
 910:	04813083          	ld	ra,72(sp)
 914:	04013403          	ld	s0,64(sp)
 918:	03813483          	ld	s1,56(sp)
 91c:	03013903          	ld	s2,48(sp)
 920:	02813983          	ld	s3,40(sp)
 924:	02013a03          	ld	s4,32(sp)
 928:	01813a83          	ld	s5,24(sp)
 92c:	01013b03          	ld	s6,16(sp)
 930:	00813b83          	ld	s7,8(sp)
 934:	00013c03          	ld	s8,0(sp)
 938:	05010113          	add	sp,sp,80
 93c:	00008067          	ret

0000000000000940 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 940:	fb010113          	add	sp,sp,-80
 944:	00113c23          	sd	ra,24(sp)
 948:	00813823          	sd	s0,16(sp)
 94c:	02010413          	add	s0,sp,32
 950:	00c43023          	sd	a2,0(s0)
 954:	00d43423          	sd	a3,8(s0)
 958:	00e43823          	sd	a4,16(s0)
 95c:	00f43c23          	sd	a5,24(s0)
 960:	03043023          	sd	a6,32(s0)
 964:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 968:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 96c:	00040613          	mv	a2,s0
 970:	00000097          	auipc	ra,0x0
 974:	d50080e7          	jalr	-688(ra) # 6c0 <vprintf>
}
 978:	01813083          	ld	ra,24(sp)
 97c:	01013403          	ld	s0,16(sp)
 980:	05010113          	add	sp,sp,80
 984:	00008067          	ret

0000000000000988 <printf>:

void
printf(const char *fmt, ...)
{
 988:	fa010113          	add	sp,sp,-96
 98c:	00113c23          	sd	ra,24(sp)
 990:	00813823          	sd	s0,16(sp)
 994:	02010413          	add	s0,sp,32
 998:	00b43423          	sd	a1,8(s0)
 99c:	00c43823          	sd	a2,16(s0)
 9a0:	00d43c23          	sd	a3,24(s0)
 9a4:	02e43023          	sd	a4,32(s0)
 9a8:	02f43423          	sd	a5,40(s0)
 9ac:	03043823          	sd	a6,48(s0)
 9b0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 9b4:	00840613          	add	a2,s0,8
 9b8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 9bc:	00050593          	mv	a1,a0
 9c0:	00100513          	li	a0,1
 9c4:	00000097          	auipc	ra,0x0
 9c8:	cfc080e7          	jalr	-772(ra) # 6c0 <vprintf>
}
 9cc:	01813083          	ld	ra,24(sp)
 9d0:	01013403          	ld	s0,16(sp)
 9d4:	06010113          	add	sp,sp,96
 9d8:	00008067          	ret

00000000000009dc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9dc:	ff010113          	add	sp,sp,-16
 9e0:	00813423          	sd	s0,8(sp)
 9e4:	01010413          	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 9e8:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9ec:	00000797          	auipc	a5,0x0
 9f0:	6147b783          	ld	a5,1556(a5) # 1000 <freep>
 9f4:	0400006f          	j	a34 <free+0x58>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 9f8:	00862703          	lw	a4,8(a2)
 9fc:	00b7073b          	addw	a4,a4,a1
 a00:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a04:	0007b703          	ld	a4,0(a5)
 a08:	00073603          	ld	a2,0(a4)
 a0c:	0500006f          	j	a5c <free+0x80>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 a10:	ff852703          	lw	a4,-8(a0)
 a14:	00c7073b          	addw	a4,a4,a2
 a18:	00e7a423          	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 a1c:	ff053683          	ld	a3,-16(a0)
 a20:	0540006f          	j	a74 <free+0x98>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a24:	0007b703          	ld	a4,0(a5)
 a28:	00e7e463          	bltu	a5,a4,a30 <free+0x54>
 a2c:	00e6ec63          	bltu	a3,a4,a44 <free+0x68>
{
 a30:	00070793          	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a34:	fed7f8e3          	bgeu	a5,a3,a24 <free+0x48>
 a38:	0007b703          	ld	a4,0(a5)
 a3c:	00e6e463          	bltu	a3,a4,a44 <free+0x68>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a40:	fee7e8e3          	bltu	a5,a4,a30 <free+0x54>
  if(bp + bp->s.size == p->s.ptr){
 a44:	ff852583          	lw	a1,-8(a0)
 a48:	0007b603          	ld	a2,0(a5)
 a4c:	02059813          	sll	a6,a1,0x20
 a50:	01c85713          	srl	a4,a6,0x1c
 a54:	00e68733          	add	a4,a3,a4
 a58:	fae600e3          	beq	a2,a4,9f8 <free+0x1c>
    bp->s.ptr = p->s.ptr->s.ptr;
 a5c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 a60:	0087a603          	lw	a2,8(a5)
 a64:	02061593          	sll	a1,a2,0x20
 a68:	01c5d713          	srl	a4,a1,0x1c
 a6c:	00e78733          	add	a4,a5,a4
 a70:	fae680e3          	beq	a3,a4,a10 <free+0x34>
    p->s.ptr = bp->s.ptr;
 a74:	00d7b023          	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 a78:	00000717          	auipc	a4,0x0
 a7c:	58f73423          	sd	a5,1416(a4) # 1000 <freep>
}
 a80:	00813403          	ld	s0,8(sp)
 a84:	01010113          	add	sp,sp,16
 a88:	00008067          	ret

0000000000000a8c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a8c:	fc010113          	add	sp,sp,-64
 a90:	02113c23          	sd	ra,56(sp)
 a94:	02813823          	sd	s0,48(sp)
 a98:	02913423          	sd	s1,40(sp)
 a9c:	03213023          	sd	s2,32(sp)
 aa0:	01313c23          	sd	s3,24(sp)
 aa4:	01413823          	sd	s4,16(sp)
 aa8:	01513423          	sd	s5,8(sp)
 aac:	01613023          	sd	s6,0(sp)
 ab0:	04010413          	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 ab4:	02051493          	sll	s1,a0,0x20
 ab8:	0204d493          	srl	s1,s1,0x20
 abc:	00f48493          	add	s1,s1,15
 ac0:	0044d493          	srl	s1,s1,0x4
 ac4:	0014899b          	addw	s3,s1,1
 ac8:	00148493          	add	s1,s1,1
  if((prevp = freep) == 0){
 acc:	00000517          	auipc	a0,0x0
 ad0:	53453503          	ld	a0,1332(a0) # 1000 <freep>
 ad4:	02050e63          	beqz	a0,b10 <malloc+0x84>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ad8:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
 adc:	0087a703          	lw	a4,8(a5)
 ae0:	04977663          	bgeu	a4,s1,b2c <malloc+0xa0>
  if(nu < 4096)
 ae4:	00098a13          	mv	s4,s3
 ae8:	0009871b          	sext.w	a4,s3
 aec:	000016b7          	lui	a3,0x1
 af0:	00d77463          	bgeu	a4,a3,af8 <malloc+0x6c>
 af4:	00001a37          	lui	s4,0x1
 af8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 afc:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 b00:	00000917          	auipc	s2,0x0
 b04:	50090913          	add	s2,s2,1280 # 1000 <freep>
  if(p == (char*)-1)
 b08:	fff00a93          	li	s5,-1
 b0c:	0a00006f          	j	bac <malloc+0x120>
    base.s.ptr = freep = prevp = &base;
 b10:	00000797          	auipc	a5,0x0
 b14:	50078793          	add	a5,a5,1280 # 1010 <base>
 b18:	00000717          	auipc	a4,0x0
 b1c:	4ef73423          	sd	a5,1256(a4) # 1000 <freep>
 b20:	00f7b023          	sd	a5,0(a5)
    base.s.size = 0;
 b24:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 b28:	fbdff06f          	j	ae4 <malloc+0x58>
      if(p->s.size == nunits)
 b2c:	04e48863          	beq	s1,a4,b7c <malloc+0xf0>
        p->s.size -= nunits;
 b30:	4137073b          	subw	a4,a4,s3
 b34:	00e7a423          	sw	a4,8(a5)
        p += p->s.size;
 b38:	02071693          	sll	a3,a4,0x20
 b3c:	01c6d713          	srl	a4,a3,0x1c
 b40:	00e787b3          	add	a5,a5,a4
        p->s.size = nunits;
 b44:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b48:	00000717          	auipc	a4,0x0
 b4c:	4aa73c23          	sd	a0,1208(a4) # 1000 <freep>
      return (void*)(p + 1);
 b50:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 b54:	03813083          	ld	ra,56(sp)
 b58:	03013403          	ld	s0,48(sp)
 b5c:	02813483          	ld	s1,40(sp)
 b60:	02013903          	ld	s2,32(sp)
 b64:	01813983          	ld	s3,24(sp)
 b68:	01013a03          	ld	s4,16(sp)
 b6c:	00813a83          	ld	s5,8(sp)
 b70:	00013b03          	ld	s6,0(sp)
 b74:	04010113          	add	sp,sp,64
 b78:	00008067          	ret
        prevp->s.ptr = p->s.ptr;
 b7c:	0007b703          	ld	a4,0(a5)
 b80:	00e53023          	sd	a4,0(a0)
 b84:	fc5ff06f          	j	b48 <malloc+0xbc>
  hp->s.size = nu;
 b88:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 b8c:	01050513          	add	a0,a0,16
 b90:	00000097          	auipc	ra,0x0
 b94:	e4c080e7          	jalr	-436(ra) # 9dc <free>
  return freep;
 b98:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 b9c:	fa050ce3          	beqz	a0,b54 <malloc+0xc8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ba0:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
 ba4:	0087a703          	lw	a4,8(a5)
 ba8:	f89772e3          	bgeu	a4,s1,b2c <malloc+0xa0>
    if(p == freep)
 bac:	00093703          	ld	a4,0(s2)
 bb0:	00078513          	mv	a0,a5
 bb4:	fef716e3          	bne	a4,a5,ba0 <malloc+0x114>
  p = sbrk(nu * sizeof(Header));
 bb8:	000a0513          	mv	a0,s4
 bbc:	00000097          	auipc	ra,0x0
 bc0:	9bc080e7          	jalr	-1604(ra) # 578 <sbrk>
  if(p == (char*)-1)
 bc4:	fd5512e3          	bne	a0,s5,b88 <malloc+0xfc>
        return 0;
 bc8:	00000513          	li	a0,0
 bcc:	f89ff06f          	j	b54 <malloc+0xc8>
