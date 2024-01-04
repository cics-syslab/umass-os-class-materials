
user/_ln:     file format elf64-littleriscv


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
  10:	02010413          	add	s0,sp,32
  if(argc != 3){
  14:	00300793          	li	a5,3
  18:	02f50263          	beq	a0,a5,3c <main+0x3c>
    fprintf(2, "Usage: ln old new\n");
  1c:	00001597          	auipc	a1,0x1
  20:	b8458593          	add	a1,a1,-1148 # ba0 <malloc+0x150>
  24:	00200513          	li	a0,2
  28:	00001097          	auipc	ra,0x1
  2c:	8dc080e7          	jalr	-1828(ra) # 904 <fprintf>
    exit(1);
  30:	00100513          	li	a0,1
  34:	00000097          	auipc	ra,0x0
  38:	43c080e7          	jalr	1084(ra) # 470 <exit>
  3c:	00058493          	mv	s1,a1
  }
  if(link(argv[1], argv[2]) < 0)
  40:	0105b583          	ld	a1,16(a1)
  44:	0084b503          	ld	a0,8(s1)
  48:	00000097          	auipc	ra,0x0
  4c:	4b8080e7          	jalr	1208(ra) # 500 <link>
  50:	00054863          	bltz	a0,60 <main+0x60>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit(0);
  54:	00000513          	li	a0,0
  58:	00000097          	auipc	ra,0x0
  5c:	418080e7          	jalr	1048(ra) # 470 <exit>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  60:	0104b683          	ld	a3,16(s1)
  64:	0084b603          	ld	a2,8(s1)
  68:	00001597          	auipc	a1,0x1
  6c:	b5058593          	add	a1,a1,-1200 # bb8 <malloc+0x168>
  70:	00200513          	li	a0,2
  74:	00001097          	auipc	ra,0x1
  78:	890080e7          	jalr	-1904(ra) # 904 <fprintf>
  7c:	fd9ff06f          	j	54 <main+0x54>

0000000000000080 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  80:	ff010113          	add	sp,sp,-16
  84:	00113423          	sd	ra,8(sp)
  88:	00813023          	sd	s0,0(sp)
  8c:	01010413          	add	s0,sp,16
  extern int main();
  main();
  90:	00000097          	auipc	ra,0x0
  94:	f70080e7          	jalr	-144(ra) # 0 <main>
  exit(0);
  98:	00000513          	li	a0,0
  9c:	00000097          	auipc	ra,0x0
  a0:	3d4080e7          	jalr	980(ra) # 470 <exit>

00000000000000a4 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  a4:	ff010113          	add	sp,sp,-16
  a8:	00813423          	sd	s0,8(sp)
  ac:	01010413          	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  b0:	00050793          	mv	a5,a0
  b4:	00158593          	add	a1,a1,1
  b8:	00178793          	add	a5,a5,1
  bc:	fff5c703          	lbu	a4,-1(a1)
  c0:	fee78fa3          	sb	a4,-1(a5)
  c4:	fe0718e3          	bnez	a4,b4 <strcpy+0x10>
    ;
  return os;
}
  c8:	00813403          	ld	s0,8(sp)
  cc:	01010113          	add	sp,sp,16
  d0:	00008067          	ret

00000000000000d4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  d4:	ff010113          	add	sp,sp,-16
  d8:	00813423          	sd	s0,8(sp)
  dc:	01010413          	add	s0,sp,16
  while(*p && *p == *q)
  e0:	00054783          	lbu	a5,0(a0)
  e4:	00078e63          	beqz	a5,100 <strcmp+0x2c>
  e8:	0005c703          	lbu	a4,0(a1)
  ec:	00f71a63          	bne	a4,a5,100 <strcmp+0x2c>
    p++, q++;
  f0:	00150513          	add	a0,a0,1
  f4:	00158593          	add	a1,a1,1
  while(*p && *p == *q)
  f8:	00054783          	lbu	a5,0(a0)
  fc:	fe0796e3          	bnez	a5,e8 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 100:	0005c503          	lbu	a0,0(a1)
}
 104:	40a7853b          	subw	a0,a5,a0
 108:	00813403          	ld	s0,8(sp)
 10c:	01010113          	add	sp,sp,16
 110:	00008067          	ret

0000000000000114 <strlen>:

uint
strlen(const char *s)
{
 114:	ff010113          	add	sp,sp,-16
 118:	00813423          	sd	s0,8(sp)
 11c:	01010413          	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 120:	00054783          	lbu	a5,0(a0)
 124:	02078863          	beqz	a5,154 <strlen+0x40>
 128:	00150513          	add	a0,a0,1
 12c:	00050793          	mv	a5,a0
 130:	00078693          	mv	a3,a5
 134:	00178793          	add	a5,a5,1
 138:	fff7c703          	lbu	a4,-1(a5)
 13c:	fe071ae3          	bnez	a4,130 <strlen+0x1c>
 140:	40a6853b          	subw	a0,a3,a0
 144:	0015051b          	addw	a0,a0,1
    ;
  return n;
}
 148:	00813403          	ld	s0,8(sp)
 14c:	01010113          	add	sp,sp,16
 150:	00008067          	ret
  for(n = 0; s[n]; n++)
 154:	00000513          	li	a0,0
 158:	ff1ff06f          	j	148 <strlen+0x34>

000000000000015c <memset>:

void*
memset(void *dst, int c, uint n)
{
 15c:	ff010113          	add	sp,sp,-16
 160:	00813423          	sd	s0,8(sp)
 164:	01010413          	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 168:	02060063          	beqz	a2,188 <memset+0x2c>
 16c:	00050793          	mv	a5,a0
 170:	02061613          	sll	a2,a2,0x20
 174:	02065613          	srl	a2,a2,0x20
 178:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 17c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 180:	00178793          	add	a5,a5,1
 184:	fee79ce3          	bne	a5,a4,17c <memset+0x20>
  }
  return dst;
}
 188:	00813403          	ld	s0,8(sp)
 18c:	01010113          	add	sp,sp,16
 190:	00008067          	ret

0000000000000194 <strchr>:

char*
strchr(const char *s, char c)
{
 194:	ff010113          	add	sp,sp,-16
 198:	00813423          	sd	s0,8(sp)
 19c:	01010413          	add	s0,sp,16
  for(; *s; s++)
 1a0:	00054783          	lbu	a5,0(a0)
 1a4:	02078263          	beqz	a5,1c8 <strchr+0x34>
    if(*s == c)
 1a8:	00f58a63          	beq	a1,a5,1bc <strchr+0x28>
  for(; *s; s++)
 1ac:	00150513          	add	a0,a0,1
 1b0:	00054783          	lbu	a5,0(a0)
 1b4:	fe079ae3          	bnez	a5,1a8 <strchr+0x14>
      return (char*)s;
  return 0;
 1b8:	00000513          	li	a0,0
}
 1bc:	00813403          	ld	s0,8(sp)
 1c0:	01010113          	add	sp,sp,16
 1c4:	00008067          	ret
  return 0;
 1c8:	00000513          	li	a0,0
 1cc:	ff1ff06f          	j	1bc <strchr+0x28>

00000000000001d0 <gets>:

char*
gets(char *buf, int max)
{
 1d0:	fa010113          	add	sp,sp,-96
 1d4:	04113c23          	sd	ra,88(sp)
 1d8:	04813823          	sd	s0,80(sp)
 1dc:	04913423          	sd	s1,72(sp)
 1e0:	05213023          	sd	s2,64(sp)
 1e4:	03313c23          	sd	s3,56(sp)
 1e8:	03413823          	sd	s4,48(sp)
 1ec:	03513423          	sd	s5,40(sp)
 1f0:	03613023          	sd	s6,32(sp)
 1f4:	01713c23          	sd	s7,24(sp)
 1f8:	06010413          	add	s0,sp,96
 1fc:	00050b93          	mv	s7,a0
 200:	00058a13          	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 204:	00050913          	mv	s2,a0
 208:	00000493          	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 20c:	00a00a93          	li	s5,10
 210:	00d00b13          	li	s6,13
  for(i=0; i+1 < max; ){
 214:	00048993          	mv	s3,s1
 218:	0014849b          	addw	s1,s1,1
 21c:	0344de63          	bge	s1,s4,258 <gets+0x88>
    cc = read(0, &c, 1);
 220:	00100613          	li	a2,1
 224:	faf40593          	add	a1,s0,-81
 228:	00000513          	li	a0,0
 22c:	00000097          	auipc	ra,0x0
 230:	268080e7          	jalr	616(ra) # 494 <read>
    if(cc < 1)
 234:	02a05263          	blez	a0,258 <gets+0x88>
    buf[i++] = c;
 238:	faf44783          	lbu	a5,-81(s0)
 23c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 240:	01578a63          	beq	a5,s5,254 <gets+0x84>
 244:	00190913          	add	s2,s2,1
 248:	fd6796e3          	bne	a5,s6,214 <gets+0x44>
  for(i=0; i+1 < max; ){
 24c:	00048993          	mv	s3,s1
 250:	0080006f          	j	258 <gets+0x88>
 254:	00048993          	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 258:	013b89b3          	add	s3,s7,s3
 25c:	00098023          	sb	zero,0(s3)
  return buf;
}
 260:	000b8513          	mv	a0,s7
 264:	05813083          	ld	ra,88(sp)
 268:	05013403          	ld	s0,80(sp)
 26c:	04813483          	ld	s1,72(sp)
 270:	04013903          	ld	s2,64(sp)
 274:	03813983          	ld	s3,56(sp)
 278:	03013a03          	ld	s4,48(sp)
 27c:	02813a83          	ld	s5,40(sp)
 280:	02013b03          	ld	s6,32(sp)
 284:	01813b83          	ld	s7,24(sp)
 288:	06010113          	add	sp,sp,96
 28c:	00008067          	ret

0000000000000290 <stat>:

int
stat(const char *n, struct stat *st)
{
 290:	fe010113          	add	sp,sp,-32
 294:	00113c23          	sd	ra,24(sp)
 298:	00813823          	sd	s0,16(sp)
 29c:	00913423          	sd	s1,8(sp)
 2a0:	01213023          	sd	s2,0(sp)
 2a4:	02010413          	add	s0,sp,32
 2a8:	00058913          	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2ac:	00000593          	li	a1,0
 2b0:	00000097          	auipc	ra,0x0
 2b4:	220080e7          	jalr	544(ra) # 4d0 <open>
  if(fd < 0)
 2b8:	04054063          	bltz	a0,2f8 <stat+0x68>
 2bc:	00050493          	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2c0:	00090593          	mv	a1,s2
 2c4:	00000097          	auipc	ra,0x0
 2c8:	230080e7          	jalr	560(ra) # 4f4 <fstat>
 2cc:	00050913          	mv	s2,a0
  close(fd);
 2d0:	00048513          	mv	a0,s1
 2d4:	00000097          	auipc	ra,0x0
 2d8:	1d8080e7          	jalr	472(ra) # 4ac <close>
  return r;
}
 2dc:	00090513          	mv	a0,s2
 2e0:	01813083          	ld	ra,24(sp)
 2e4:	01013403          	ld	s0,16(sp)
 2e8:	00813483          	ld	s1,8(sp)
 2ec:	00013903          	ld	s2,0(sp)
 2f0:	02010113          	add	sp,sp,32
 2f4:	00008067          	ret
    return -1;
 2f8:	fff00913          	li	s2,-1
 2fc:	fe1ff06f          	j	2dc <stat+0x4c>

0000000000000300 <atoi>:

int
atoi(const char *s)
{
 300:	ff010113          	add	sp,sp,-16
 304:	00813423          	sd	s0,8(sp)
 308:	01010413          	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 30c:	00054683          	lbu	a3,0(a0)
 310:	fd06879b          	addw	a5,a3,-48
 314:	0ff7f793          	zext.b	a5,a5
 318:	00900613          	li	a2,9
 31c:	04f66063          	bltu	a2,a5,35c <atoi+0x5c>
 320:	00050713          	mv	a4,a0
  n = 0;
 324:	00000513          	li	a0,0
    n = n*10 + *s++ - '0';
 328:	00170713          	add	a4,a4,1
 32c:	0025179b          	sllw	a5,a0,0x2
 330:	00a787bb          	addw	a5,a5,a0
 334:	0017979b          	sllw	a5,a5,0x1
 338:	00d787bb          	addw	a5,a5,a3
 33c:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 340:	00074683          	lbu	a3,0(a4)
 344:	fd06879b          	addw	a5,a3,-48
 348:	0ff7f793          	zext.b	a5,a5
 34c:	fcf67ee3          	bgeu	a2,a5,328 <atoi+0x28>
  return n;
}
 350:	00813403          	ld	s0,8(sp)
 354:	01010113          	add	sp,sp,16
 358:	00008067          	ret
  n = 0;
 35c:	00000513          	li	a0,0
 360:	ff1ff06f          	j	350 <atoi+0x50>

0000000000000364 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 364:	ff010113          	add	sp,sp,-16
 368:	00813423          	sd	s0,8(sp)
 36c:	01010413          	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 370:	02b57c63          	bgeu	a0,a1,3a8 <memmove+0x44>
    while(n-- > 0)
 374:	02c05463          	blez	a2,39c <memmove+0x38>
 378:	02061613          	sll	a2,a2,0x20
 37c:	02065613          	srl	a2,a2,0x20
 380:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 384:	00050713          	mv	a4,a0
      *dst++ = *src++;
 388:	00158593          	add	a1,a1,1
 38c:	00170713          	add	a4,a4,1
 390:	fff5c683          	lbu	a3,-1(a1)
 394:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 398:	fee798e3          	bne	a5,a4,388 <memmove+0x24>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 39c:	00813403          	ld	s0,8(sp)
 3a0:	01010113          	add	sp,sp,16
 3a4:	00008067          	ret
    dst += n;
 3a8:	00c50733          	add	a4,a0,a2
    src += n;
 3ac:	00c585b3          	add	a1,a1,a2
    while(n-- > 0)
 3b0:	fec056e3          	blez	a2,39c <memmove+0x38>
 3b4:	fff6079b          	addw	a5,a2,-1
 3b8:	02079793          	sll	a5,a5,0x20
 3bc:	0207d793          	srl	a5,a5,0x20
 3c0:	fff7c793          	not	a5,a5
 3c4:	00f707b3          	add	a5,a4,a5
      *--dst = *--src;
 3c8:	fff58593          	add	a1,a1,-1
 3cc:	fff70713          	add	a4,a4,-1
 3d0:	0005c683          	lbu	a3,0(a1)
 3d4:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3d8:	fee798e3          	bne	a5,a4,3c8 <memmove+0x64>
 3dc:	fc1ff06f          	j	39c <memmove+0x38>

00000000000003e0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3e0:	ff010113          	add	sp,sp,-16
 3e4:	00813423          	sd	s0,8(sp)
 3e8:	01010413          	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3ec:	04060463          	beqz	a2,434 <memcmp+0x54>
 3f0:	fff6069b          	addw	a3,a2,-1
 3f4:	02069693          	sll	a3,a3,0x20
 3f8:	0206d693          	srl	a3,a3,0x20
 3fc:	00168693          	add	a3,a3,1
 400:	00d506b3          	add	a3,a0,a3
    if (*p1 != *p2) {
 404:	00054783          	lbu	a5,0(a0)
 408:	0005c703          	lbu	a4,0(a1)
 40c:	00e79c63          	bne	a5,a4,424 <memcmp+0x44>
      return *p1 - *p2;
    }
    p1++;
 410:	00150513          	add	a0,a0,1
    p2++;
 414:	00158593          	add	a1,a1,1
  while (n-- > 0) {
 418:	fed516e3          	bne	a0,a3,404 <memcmp+0x24>
  }
  return 0;
 41c:	00000513          	li	a0,0
 420:	0080006f          	j	428 <memcmp+0x48>
      return *p1 - *p2;
 424:	40e7853b          	subw	a0,a5,a4
}
 428:	00813403          	ld	s0,8(sp)
 42c:	01010113          	add	sp,sp,16
 430:	00008067          	ret
  return 0;
 434:	00000513          	li	a0,0
 438:	ff1ff06f          	j	428 <memcmp+0x48>

000000000000043c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 43c:	ff010113          	add	sp,sp,-16
 440:	00113423          	sd	ra,8(sp)
 444:	00813023          	sd	s0,0(sp)
 448:	01010413          	add	s0,sp,16
  return memmove(dst, src, n);
 44c:	00000097          	auipc	ra,0x0
 450:	f18080e7          	jalr	-232(ra) # 364 <memmove>
}
 454:	00813083          	ld	ra,8(sp)
 458:	00013403          	ld	s0,0(sp)
 45c:	01010113          	add	sp,sp,16
 460:	00008067          	ret

0000000000000464 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 464:	00100893          	li	a7,1
 ecall
 468:	00000073          	ecall
 ret
 46c:	00008067          	ret

0000000000000470 <exit>:
.global exit
exit:
 li a7, SYS_exit
 470:	00200893          	li	a7,2
 ecall
 474:	00000073          	ecall
 ret
 478:	00008067          	ret

000000000000047c <wait>:
.global wait
wait:
 li a7, SYS_wait
 47c:	00300893          	li	a7,3
 ecall
 480:	00000073          	ecall
 ret
 484:	00008067          	ret

0000000000000488 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 488:	00400893          	li	a7,4
 ecall
 48c:	00000073          	ecall
 ret
 490:	00008067          	ret

0000000000000494 <read>:
.global read
read:
 li a7, SYS_read
 494:	00500893          	li	a7,5
 ecall
 498:	00000073          	ecall
 ret
 49c:	00008067          	ret

00000000000004a0 <write>:
.global write
write:
 li a7, SYS_write
 4a0:	01000893          	li	a7,16
 ecall
 4a4:	00000073          	ecall
 ret
 4a8:	00008067          	ret

00000000000004ac <close>:
.global close
close:
 li a7, SYS_close
 4ac:	01500893          	li	a7,21
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	00008067          	ret

00000000000004b8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4b8:	00600893          	li	a7,6
 ecall
 4bc:	00000073          	ecall
 ret
 4c0:	00008067          	ret

00000000000004c4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4c4:	00700893          	li	a7,7
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	00008067          	ret

00000000000004d0 <open>:
.global open
open:
 li a7, SYS_open
 4d0:	00f00893          	li	a7,15
 ecall
 4d4:	00000073          	ecall
 ret
 4d8:	00008067          	ret

00000000000004dc <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4dc:	01100893          	li	a7,17
 ecall
 4e0:	00000073          	ecall
 ret
 4e4:	00008067          	ret

00000000000004e8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4e8:	01200893          	li	a7,18
 ecall
 4ec:	00000073          	ecall
 ret
 4f0:	00008067          	ret

00000000000004f4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4f4:	00800893          	li	a7,8
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	00008067          	ret

0000000000000500 <link>:
.global link
link:
 li a7, SYS_link
 500:	01300893          	li	a7,19
 ecall
 504:	00000073          	ecall
 ret
 508:	00008067          	ret

000000000000050c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 50c:	01400893          	li	a7,20
 ecall
 510:	00000073          	ecall
 ret
 514:	00008067          	ret

0000000000000518 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 518:	00900893          	li	a7,9
 ecall
 51c:	00000073          	ecall
 ret
 520:	00008067          	ret

0000000000000524 <dup>:
.global dup
dup:
 li a7, SYS_dup
 524:	00a00893          	li	a7,10
 ecall
 528:	00000073          	ecall
 ret
 52c:	00008067          	ret

0000000000000530 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 530:	00b00893          	li	a7,11
 ecall
 534:	00000073          	ecall
 ret
 538:	00008067          	ret

000000000000053c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 53c:	00c00893          	li	a7,12
 ecall
 540:	00000073          	ecall
 ret
 544:	00008067          	ret

0000000000000548 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 548:	00d00893          	li	a7,13
 ecall
 54c:	00000073          	ecall
 ret
 550:	00008067          	ret

0000000000000554 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 554:	00e00893          	li	a7,14
 ecall
 558:	00000073          	ecall
 ret
 55c:	00008067          	ret

0000000000000560 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 560:	fe010113          	add	sp,sp,-32
 564:	00113c23          	sd	ra,24(sp)
 568:	00813823          	sd	s0,16(sp)
 56c:	02010413          	add	s0,sp,32
 570:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 574:	00100613          	li	a2,1
 578:	fef40593          	add	a1,s0,-17
 57c:	00000097          	auipc	ra,0x0
 580:	f24080e7          	jalr	-220(ra) # 4a0 <write>
}
 584:	01813083          	ld	ra,24(sp)
 588:	01013403          	ld	s0,16(sp)
 58c:	02010113          	add	sp,sp,32
 590:	00008067          	ret

0000000000000594 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 594:	fc010113          	add	sp,sp,-64
 598:	02113c23          	sd	ra,56(sp)
 59c:	02813823          	sd	s0,48(sp)
 5a0:	02913423          	sd	s1,40(sp)
 5a4:	03213023          	sd	s2,32(sp)
 5a8:	01313c23          	sd	s3,24(sp)
 5ac:	04010413          	add	s0,sp,64
 5b0:	00050493          	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5b4:	00068463          	beqz	a3,5bc <printint+0x28>
 5b8:	0c05c063          	bltz	a1,678 <printint+0xe4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5bc:	0005859b          	sext.w	a1,a1
  neg = 0;
 5c0:	00000893          	li	a7,0
 5c4:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 5c8:	00000713          	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5cc:	0006061b          	sext.w	a2,a2
 5d0:	00000517          	auipc	a0,0x0
 5d4:	66050513          	add	a0,a0,1632 # c30 <digits>
 5d8:	00070813          	mv	a6,a4
 5dc:	0017071b          	addw	a4,a4,1
 5e0:	02c5f7bb          	remuw	a5,a1,a2
 5e4:	02079793          	sll	a5,a5,0x20
 5e8:	0207d793          	srl	a5,a5,0x20
 5ec:	00f507b3          	add	a5,a0,a5
 5f0:	0007c783          	lbu	a5,0(a5)
 5f4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5f8:	0005879b          	sext.w	a5,a1
 5fc:	02c5d5bb          	divuw	a1,a1,a2
 600:	00168693          	add	a3,a3,1
 604:	fcc7fae3          	bgeu	a5,a2,5d8 <printint+0x44>
  if(neg)
 608:	00088c63          	beqz	a7,620 <printint+0x8c>
    buf[i++] = '-';
 60c:	fd070793          	add	a5,a4,-48
 610:	00878733          	add	a4,a5,s0
 614:	02d00793          	li	a5,45
 618:	fef70823          	sb	a5,-16(a4)
 61c:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 620:	02e05e63          	blez	a4,65c <printint+0xc8>
 624:	fc040793          	add	a5,s0,-64
 628:	00e78933          	add	s2,a5,a4
 62c:	fff78993          	add	s3,a5,-1
 630:	00e989b3          	add	s3,s3,a4
 634:	fff7071b          	addw	a4,a4,-1
 638:	02071713          	sll	a4,a4,0x20
 63c:	02075713          	srl	a4,a4,0x20
 640:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 644:	fff94583          	lbu	a1,-1(s2)
 648:	00048513          	mv	a0,s1
 64c:	00000097          	auipc	ra,0x0
 650:	f14080e7          	jalr	-236(ra) # 560 <putc>
  while(--i >= 0)
 654:	fff90913          	add	s2,s2,-1
 658:	ff3916e3          	bne	s2,s3,644 <printint+0xb0>
}
 65c:	03813083          	ld	ra,56(sp)
 660:	03013403          	ld	s0,48(sp)
 664:	02813483          	ld	s1,40(sp)
 668:	02013903          	ld	s2,32(sp)
 66c:	01813983          	ld	s3,24(sp)
 670:	04010113          	add	sp,sp,64
 674:	00008067          	ret
    x = -xx;
 678:	40b005bb          	negw	a1,a1
    neg = 1;
 67c:	00100893          	li	a7,1
    x = -xx;
 680:	f45ff06f          	j	5c4 <printint+0x30>

0000000000000684 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 684:	fb010113          	add	sp,sp,-80
 688:	04113423          	sd	ra,72(sp)
 68c:	04813023          	sd	s0,64(sp)
 690:	02913c23          	sd	s1,56(sp)
 694:	03213823          	sd	s2,48(sp)
 698:	03313423          	sd	s3,40(sp)
 69c:	03413023          	sd	s4,32(sp)
 6a0:	01513c23          	sd	s5,24(sp)
 6a4:	01613823          	sd	s6,16(sp)
 6a8:	01713423          	sd	s7,8(sp)
 6ac:	01813023          	sd	s8,0(sp)
 6b0:	05010413          	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6b4:	0005c903          	lbu	s2,0(a1)
 6b8:	20090e63          	beqz	s2,8d4 <vprintf+0x250>
 6bc:	00050a93          	mv	s5,a0
 6c0:	00060b93          	mv	s7,a2
 6c4:	00158493          	add	s1,a1,1
  state = 0;
 6c8:	00000993          	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 6cc:	02500a13          	li	s4,37
 6d0:	01500b13          	li	s6,21
 6d4:	0280006f          	j	6fc <vprintf+0x78>
        putc(fd, c);
 6d8:	00090593          	mv	a1,s2
 6dc:	000a8513          	mv	a0,s5
 6e0:	00000097          	auipc	ra,0x0
 6e4:	e80080e7          	jalr	-384(ra) # 560 <putc>
 6e8:	0080006f          	j	6f0 <vprintf+0x6c>
    } else if(state == '%'){
 6ec:	03498063          	beq	s3,s4,70c <vprintf+0x88>
  for(i = 0; fmt[i]; i++){
 6f0:	00148493          	add	s1,s1,1
 6f4:	fff4c903          	lbu	s2,-1(s1)
 6f8:	1c090e63          	beqz	s2,8d4 <vprintf+0x250>
    if(state == 0){
 6fc:	fe0998e3          	bnez	s3,6ec <vprintf+0x68>
      if(c == '%'){
 700:	fd491ce3          	bne	s2,s4,6d8 <vprintf+0x54>
        state = '%';
 704:	000a0993          	mv	s3,s4
 708:	fe9ff06f          	j	6f0 <vprintf+0x6c>
      if(c == 'd'){
 70c:	17490e63          	beq	s2,s4,888 <vprintf+0x204>
 710:	f9d9079b          	addw	a5,s2,-99
 714:	0ff7f793          	zext.b	a5,a5
 718:	18fb6463          	bltu	s6,a5,8a0 <vprintf+0x21c>
 71c:	f9d9079b          	addw	a5,s2,-99
 720:	0ff7f713          	zext.b	a4,a5
 724:	16eb6e63          	bltu	s6,a4,8a0 <vprintf+0x21c>
 728:	00271793          	sll	a5,a4,0x2
 72c:	00000717          	auipc	a4,0x0
 730:	4ac70713          	add	a4,a4,1196 # bd8 <malloc+0x188>
 734:	00e787b3          	add	a5,a5,a4
 738:	0007a783          	lw	a5,0(a5)
 73c:	00e787b3          	add	a5,a5,a4
 740:	00078067          	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 744:	008b8913          	add	s2,s7,8
 748:	00100693          	li	a3,1
 74c:	00a00613          	li	a2,10
 750:	000ba583          	lw	a1,0(s7)
 754:	000a8513          	mv	a0,s5
 758:	00000097          	auipc	ra,0x0
 75c:	e3c080e7          	jalr	-452(ra) # 594 <printint>
 760:	00090b93          	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 764:	00000993          	li	s3,0
 768:	f89ff06f          	j	6f0 <vprintf+0x6c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 76c:	008b8913          	add	s2,s7,8
 770:	00000693          	li	a3,0
 774:	00a00613          	li	a2,10
 778:	000ba583          	lw	a1,0(s7)
 77c:	000a8513          	mv	a0,s5
 780:	00000097          	auipc	ra,0x0
 784:	e14080e7          	jalr	-492(ra) # 594 <printint>
 788:	00090b93          	mv	s7,s2
      state = 0;
 78c:	00000993          	li	s3,0
 790:	f61ff06f          	j	6f0 <vprintf+0x6c>
        printint(fd, va_arg(ap, int), 16, 0);
 794:	008b8913          	add	s2,s7,8
 798:	00000693          	li	a3,0
 79c:	01000613          	li	a2,16
 7a0:	000ba583          	lw	a1,0(s7)
 7a4:	000a8513          	mv	a0,s5
 7a8:	00000097          	auipc	ra,0x0
 7ac:	dec080e7          	jalr	-532(ra) # 594 <printint>
 7b0:	00090b93          	mv	s7,s2
      state = 0;
 7b4:	00000993          	li	s3,0
 7b8:	f39ff06f          	j	6f0 <vprintf+0x6c>
        printptr(fd, va_arg(ap, uint64));
 7bc:	008b8c13          	add	s8,s7,8
 7c0:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7c4:	03000593          	li	a1,48
 7c8:	000a8513          	mv	a0,s5
 7cc:	00000097          	auipc	ra,0x0
 7d0:	d94080e7          	jalr	-620(ra) # 560 <putc>
  putc(fd, 'x');
 7d4:	07800593          	li	a1,120
 7d8:	000a8513          	mv	a0,s5
 7dc:	00000097          	auipc	ra,0x0
 7e0:	d84080e7          	jalr	-636(ra) # 560 <putc>
 7e4:	01000913          	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7e8:	00000b97          	auipc	s7,0x0
 7ec:	448b8b93          	add	s7,s7,1096 # c30 <digits>
 7f0:	03c9d793          	srl	a5,s3,0x3c
 7f4:	00fb87b3          	add	a5,s7,a5
 7f8:	0007c583          	lbu	a1,0(a5)
 7fc:	000a8513          	mv	a0,s5
 800:	00000097          	auipc	ra,0x0
 804:	d60080e7          	jalr	-672(ra) # 560 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 808:	00499993          	sll	s3,s3,0x4
 80c:	fff9091b          	addw	s2,s2,-1
 810:	fe0910e3          	bnez	s2,7f0 <vprintf+0x16c>
        printptr(fd, va_arg(ap, uint64));
 814:	000c0b93          	mv	s7,s8
      state = 0;
 818:	00000993          	li	s3,0
 81c:	ed5ff06f          	j	6f0 <vprintf+0x6c>
        s = va_arg(ap, char*);
 820:	008b8993          	add	s3,s7,8
 824:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 828:	02090863          	beqz	s2,858 <vprintf+0x1d4>
        while(*s != 0){
 82c:	00094583          	lbu	a1,0(s2)
 830:	08058c63          	beqz	a1,8c8 <vprintf+0x244>
          putc(fd, *s);
 834:	000a8513          	mv	a0,s5
 838:	00000097          	auipc	ra,0x0
 83c:	d28080e7          	jalr	-728(ra) # 560 <putc>
          s++;
 840:	00190913          	add	s2,s2,1
        while(*s != 0){
 844:	00094583          	lbu	a1,0(s2)
 848:	fe0596e3          	bnez	a1,834 <vprintf+0x1b0>
        s = va_arg(ap, char*);
 84c:	00098b93          	mv	s7,s3
      state = 0;
 850:	00000993          	li	s3,0
 854:	e9dff06f          	j	6f0 <vprintf+0x6c>
          s = "(null)";
 858:	00000917          	auipc	s2,0x0
 85c:	37890913          	add	s2,s2,888 # bd0 <malloc+0x180>
        while(*s != 0){
 860:	02800593          	li	a1,40
 864:	fd1ff06f          	j	834 <vprintf+0x1b0>
        putc(fd, va_arg(ap, uint));
 868:	008b8913          	add	s2,s7,8
 86c:	000bc583          	lbu	a1,0(s7)
 870:	000a8513          	mv	a0,s5
 874:	00000097          	auipc	ra,0x0
 878:	cec080e7          	jalr	-788(ra) # 560 <putc>
 87c:	00090b93          	mv	s7,s2
      state = 0;
 880:	00000993          	li	s3,0
 884:	e6dff06f          	j	6f0 <vprintf+0x6c>
        putc(fd, c);
 888:	02500593          	li	a1,37
 88c:	000a8513          	mv	a0,s5
 890:	00000097          	auipc	ra,0x0
 894:	cd0080e7          	jalr	-816(ra) # 560 <putc>
      state = 0;
 898:	00000993          	li	s3,0
 89c:	e55ff06f          	j	6f0 <vprintf+0x6c>
        putc(fd, '%');
 8a0:	02500593          	li	a1,37
 8a4:	000a8513          	mv	a0,s5
 8a8:	00000097          	auipc	ra,0x0
 8ac:	cb8080e7          	jalr	-840(ra) # 560 <putc>
        putc(fd, c);
 8b0:	00090593          	mv	a1,s2
 8b4:	000a8513          	mv	a0,s5
 8b8:	00000097          	auipc	ra,0x0
 8bc:	ca8080e7          	jalr	-856(ra) # 560 <putc>
      state = 0;
 8c0:	00000993          	li	s3,0
 8c4:	e2dff06f          	j	6f0 <vprintf+0x6c>
        s = va_arg(ap, char*);
 8c8:	00098b93          	mv	s7,s3
      state = 0;
 8cc:	00000993          	li	s3,0
 8d0:	e21ff06f          	j	6f0 <vprintf+0x6c>
    }
  }
}
 8d4:	04813083          	ld	ra,72(sp)
 8d8:	04013403          	ld	s0,64(sp)
 8dc:	03813483          	ld	s1,56(sp)
 8e0:	03013903          	ld	s2,48(sp)
 8e4:	02813983          	ld	s3,40(sp)
 8e8:	02013a03          	ld	s4,32(sp)
 8ec:	01813a83          	ld	s5,24(sp)
 8f0:	01013b03          	ld	s6,16(sp)
 8f4:	00813b83          	ld	s7,8(sp)
 8f8:	00013c03          	ld	s8,0(sp)
 8fc:	05010113          	add	sp,sp,80
 900:	00008067          	ret

0000000000000904 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 904:	fb010113          	add	sp,sp,-80
 908:	00113c23          	sd	ra,24(sp)
 90c:	00813823          	sd	s0,16(sp)
 910:	02010413          	add	s0,sp,32
 914:	00c43023          	sd	a2,0(s0)
 918:	00d43423          	sd	a3,8(s0)
 91c:	00e43823          	sd	a4,16(s0)
 920:	00f43c23          	sd	a5,24(s0)
 924:	03043023          	sd	a6,32(s0)
 928:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 92c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 930:	00040613          	mv	a2,s0
 934:	00000097          	auipc	ra,0x0
 938:	d50080e7          	jalr	-688(ra) # 684 <vprintf>
}
 93c:	01813083          	ld	ra,24(sp)
 940:	01013403          	ld	s0,16(sp)
 944:	05010113          	add	sp,sp,80
 948:	00008067          	ret

000000000000094c <printf>:

void
printf(const char *fmt, ...)
{
 94c:	fa010113          	add	sp,sp,-96
 950:	00113c23          	sd	ra,24(sp)
 954:	00813823          	sd	s0,16(sp)
 958:	02010413          	add	s0,sp,32
 95c:	00b43423          	sd	a1,8(s0)
 960:	00c43823          	sd	a2,16(s0)
 964:	00d43c23          	sd	a3,24(s0)
 968:	02e43023          	sd	a4,32(s0)
 96c:	02f43423          	sd	a5,40(s0)
 970:	03043823          	sd	a6,48(s0)
 974:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 978:	00840613          	add	a2,s0,8
 97c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 980:	00050593          	mv	a1,a0
 984:	00100513          	li	a0,1
 988:	00000097          	auipc	ra,0x0
 98c:	cfc080e7          	jalr	-772(ra) # 684 <vprintf>
}
 990:	01813083          	ld	ra,24(sp)
 994:	01013403          	ld	s0,16(sp)
 998:	06010113          	add	sp,sp,96
 99c:	00008067          	ret

00000000000009a0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9a0:	ff010113          	add	sp,sp,-16
 9a4:	00813423          	sd	s0,8(sp)
 9a8:	01010413          	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 9ac:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9b0:	00000797          	auipc	a5,0x0
 9b4:	6507b783          	ld	a5,1616(a5) # 1000 <freep>
 9b8:	0400006f          	j	9f8 <free+0x58>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 9bc:	00862703          	lw	a4,8(a2)
 9c0:	00b7073b          	addw	a4,a4,a1
 9c4:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 9c8:	0007b703          	ld	a4,0(a5)
 9cc:	00073603          	ld	a2,0(a4)
 9d0:	0500006f          	j	a20 <free+0x80>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 9d4:	ff852703          	lw	a4,-8(a0)
 9d8:	00c7073b          	addw	a4,a4,a2
 9dc:	00e7a423          	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 9e0:	ff053683          	ld	a3,-16(a0)
 9e4:	0540006f          	j	a38 <free+0x98>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9e8:	0007b703          	ld	a4,0(a5)
 9ec:	00e7e463          	bltu	a5,a4,9f4 <free+0x54>
 9f0:	00e6ec63          	bltu	a3,a4,a08 <free+0x68>
{
 9f4:	00070793          	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9f8:	fed7f8e3          	bgeu	a5,a3,9e8 <free+0x48>
 9fc:	0007b703          	ld	a4,0(a5)
 a00:	00e6e463          	bltu	a3,a4,a08 <free+0x68>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a04:	fee7e8e3          	bltu	a5,a4,9f4 <free+0x54>
  if(bp + bp->s.size == p->s.ptr){
 a08:	ff852583          	lw	a1,-8(a0)
 a0c:	0007b603          	ld	a2,0(a5)
 a10:	02059813          	sll	a6,a1,0x20
 a14:	01c85713          	srl	a4,a6,0x1c
 a18:	00e68733          	add	a4,a3,a4
 a1c:	fae600e3          	beq	a2,a4,9bc <free+0x1c>
    bp->s.ptr = p->s.ptr->s.ptr;
 a20:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 a24:	0087a603          	lw	a2,8(a5)
 a28:	02061593          	sll	a1,a2,0x20
 a2c:	01c5d713          	srl	a4,a1,0x1c
 a30:	00e78733          	add	a4,a5,a4
 a34:	fae680e3          	beq	a3,a4,9d4 <free+0x34>
    p->s.ptr = bp->s.ptr;
 a38:	00d7b023          	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 a3c:	00000717          	auipc	a4,0x0
 a40:	5cf73223          	sd	a5,1476(a4) # 1000 <freep>
}
 a44:	00813403          	ld	s0,8(sp)
 a48:	01010113          	add	sp,sp,16
 a4c:	00008067          	ret

0000000000000a50 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a50:	fc010113          	add	sp,sp,-64
 a54:	02113c23          	sd	ra,56(sp)
 a58:	02813823          	sd	s0,48(sp)
 a5c:	02913423          	sd	s1,40(sp)
 a60:	03213023          	sd	s2,32(sp)
 a64:	01313c23          	sd	s3,24(sp)
 a68:	01413823          	sd	s4,16(sp)
 a6c:	01513423          	sd	s5,8(sp)
 a70:	01613023          	sd	s6,0(sp)
 a74:	04010413          	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a78:	02051493          	sll	s1,a0,0x20
 a7c:	0204d493          	srl	s1,s1,0x20
 a80:	00f48493          	add	s1,s1,15
 a84:	0044d493          	srl	s1,s1,0x4
 a88:	0014899b          	addw	s3,s1,1
 a8c:	00148493          	add	s1,s1,1
  if((prevp = freep) == 0){
 a90:	00000517          	auipc	a0,0x0
 a94:	57053503          	ld	a0,1392(a0) # 1000 <freep>
 a98:	02050e63          	beqz	a0,ad4 <malloc+0x84>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a9c:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
 aa0:	0087a703          	lw	a4,8(a5)
 aa4:	04977663          	bgeu	a4,s1,af0 <malloc+0xa0>
  if(nu < 4096)
 aa8:	00098a13          	mv	s4,s3
 aac:	0009871b          	sext.w	a4,s3
 ab0:	000016b7          	lui	a3,0x1
 ab4:	00d77463          	bgeu	a4,a3,abc <malloc+0x6c>
 ab8:	00001a37          	lui	s4,0x1
 abc:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 ac0:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 ac4:	00000917          	auipc	s2,0x0
 ac8:	53c90913          	add	s2,s2,1340 # 1000 <freep>
  if(p == (char*)-1)
 acc:	fff00a93          	li	s5,-1
 ad0:	0a00006f          	j	b70 <malloc+0x120>
    base.s.ptr = freep = prevp = &base;
 ad4:	00000797          	auipc	a5,0x0
 ad8:	53c78793          	add	a5,a5,1340 # 1010 <base>
 adc:	00000717          	auipc	a4,0x0
 ae0:	52f73223          	sd	a5,1316(a4) # 1000 <freep>
 ae4:	00f7b023          	sd	a5,0(a5)
    base.s.size = 0;
 ae8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 aec:	fbdff06f          	j	aa8 <malloc+0x58>
      if(p->s.size == nunits)
 af0:	04e48863          	beq	s1,a4,b40 <malloc+0xf0>
        p->s.size -= nunits;
 af4:	4137073b          	subw	a4,a4,s3
 af8:	00e7a423          	sw	a4,8(a5)
        p += p->s.size;
 afc:	02071693          	sll	a3,a4,0x20
 b00:	01c6d713          	srl	a4,a3,0x1c
 b04:	00e787b3          	add	a5,a5,a4
        p->s.size = nunits;
 b08:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b0c:	00000717          	auipc	a4,0x0
 b10:	4ea73a23          	sd	a0,1268(a4) # 1000 <freep>
      return (void*)(p + 1);
 b14:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 b18:	03813083          	ld	ra,56(sp)
 b1c:	03013403          	ld	s0,48(sp)
 b20:	02813483          	ld	s1,40(sp)
 b24:	02013903          	ld	s2,32(sp)
 b28:	01813983          	ld	s3,24(sp)
 b2c:	01013a03          	ld	s4,16(sp)
 b30:	00813a83          	ld	s5,8(sp)
 b34:	00013b03          	ld	s6,0(sp)
 b38:	04010113          	add	sp,sp,64
 b3c:	00008067          	ret
        prevp->s.ptr = p->s.ptr;
 b40:	0007b703          	ld	a4,0(a5)
 b44:	00e53023          	sd	a4,0(a0)
 b48:	fc5ff06f          	j	b0c <malloc+0xbc>
  hp->s.size = nu;
 b4c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 b50:	01050513          	add	a0,a0,16
 b54:	00000097          	auipc	ra,0x0
 b58:	e4c080e7          	jalr	-436(ra) # 9a0 <free>
  return freep;
 b5c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 b60:	fa050ce3          	beqz	a0,b18 <malloc+0xc8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b64:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b68:	0087a703          	lw	a4,8(a5)
 b6c:	f89772e3          	bgeu	a4,s1,af0 <malloc+0xa0>
    if(p == freep)
 b70:	00093703          	ld	a4,0(s2)
 b74:	00078513          	mv	a0,a5
 b78:	fef716e3          	bne	a4,a5,b64 <malloc+0x114>
  p = sbrk(nu * sizeof(Header));
 b7c:	000a0513          	mv	a0,s4
 b80:	00000097          	auipc	ra,0x0
 b84:	9bc080e7          	jalr	-1604(ra) # 53c <sbrk>
  if(p == (char*)-1)
 b88:	fd5512e3          	bne	a0,s5,b4c <malloc+0xfc>
        return 0;
 b8c:	00000513          	li	a0,0
 b90:	f89ff06f          	j	b18 <malloc+0xc8>
