
user/_stressfs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

int
main(int argc, char *argv[])
{
   0:	dd010113          	add	sp,sp,-560
   4:	22113423          	sd	ra,552(sp)
   8:	22813023          	sd	s0,544(sp)
   c:	20913c23          	sd	s1,536(sp)
  10:	21213823          	sd	s2,528(sp)
  14:	23010413          	add	s0,sp,560
  int fd, i;
  char path[] = "stressfs0";
  18:	00001797          	auipc	a5,0x1
  1c:	c6878793          	add	a5,a5,-920 # c80 <malloc+0x178>
  20:	0007b703          	ld	a4,0(a5)
  24:	fce43823          	sd	a4,-48(s0)
  28:	0087d783          	lhu	a5,8(a5)
  2c:	fcf41c23          	sh	a5,-40(s0)
  char data[512];

  printf("stressfs starting\n");
  30:	00001517          	auipc	a0,0x1
  34:	c2050513          	add	a0,a0,-992 # c50 <malloc+0x148>
  38:	00001097          	auipc	ra,0x1
  3c:	9cc080e7          	jalr	-1588(ra) # a04 <printf>
  memset(data, 'a', sizeof(data));
  40:	20000613          	li	a2,512
  44:	06100593          	li	a1,97
  48:	dd040513          	add	a0,s0,-560
  4c:	00000097          	auipc	ra,0x0
  50:	1c8080e7          	jalr	456(ra) # 214 <memset>

  for(i = 0; i < 4; i++)
  54:	00000493          	li	s1,0
  58:	00400913          	li	s2,4
    if(fork() > 0)
  5c:	00000097          	auipc	ra,0x0
  60:	4c0080e7          	jalr	1216(ra) # 51c <fork>
  64:	00a04663          	bgtz	a0,70 <main+0x70>
  for(i = 0; i < 4; i++)
  68:	0014849b          	addw	s1,s1,1
  6c:	ff2498e3          	bne	s1,s2,5c <main+0x5c>
      break;

  printf("write %d\n", i);
  70:	00048593          	mv	a1,s1
  74:	00001517          	auipc	a0,0x1
  78:	bf450513          	add	a0,a0,-1036 # c68 <malloc+0x160>
  7c:	00001097          	auipc	ra,0x1
  80:	988080e7          	jalr	-1656(ra) # a04 <printf>

  path[8] += i;
  84:	fd844783          	lbu	a5,-40(s0)
  88:	009787bb          	addw	a5,a5,s1
  8c:	fcf40c23          	sb	a5,-40(s0)
  fd = open(path, O_CREATE | O_RDWR);
  90:	20200593          	li	a1,514
  94:	fd040513          	add	a0,s0,-48
  98:	00000097          	auipc	ra,0x0
  9c:	4f0080e7          	jalr	1264(ra) # 588 <open>
  a0:	00050913          	mv	s2,a0
  a4:	01400493          	li	s1,20
  for(i = 0; i < 20; i++)
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  a8:	20000613          	li	a2,512
  ac:	dd040593          	add	a1,s0,-560
  b0:	00090513          	mv	a0,s2
  b4:	00000097          	auipc	ra,0x0
  b8:	4a4080e7          	jalr	1188(ra) # 558 <write>
  for(i = 0; i < 20; i++)
  bc:	fff4849b          	addw	s1,s1,-1
  c0:	fe0494e3          	bnez	s1,a8 <main+0xa8>
  close(fd);
  c4:	00090513          	mv	a0,s2
  c8:	00000097          	auipc	ra,0x0
  cc:	49c080e7          	jalr	1180(ra) # 564 <close>

  printf("read\n");
  d0:	00001517          	auipc	a0,0x1
  d4:	ba850513          	add	a0,a0,-1112 # c78 <malloc+0x170>
  d8:	00001097          	auipc	ra,0x1
  dc:	92c080e7          	jalr	-1748(ra) # a04 <printf>

  fd = open(path, O_RDONLY);
  e0:	00000593          	li	a1,0
  e4:	fd040513          	add	a0,s0,-48
  e8:	00000097          	auipc	ra,0x0
  ec:	4a0080e7          	jalr	1184(ra) # 588 <open>
  f0:	00050913          	mv	s2,a0
  f4:	01400493          	li	s1,20
  for (i = 0; i < 20; i++)
    read(fd, data, sizeof(data));
  f8:	20000613          	li	a2,512
  fc:	dd040593          	add	a1,s0,-560
 100:	00090513          	mv	a0,s2
 104:	00000097          	auipc	ra,0x0
 108:	448080e7          	jalr	1096(ra) # 54c <read>
  for (i = 0; i < 20; i++)
 10c:	fff4849b          	addw	s1,s1,-1
 110:	fe0494e3          	bnez	s1,f8 <main+0xf8>
  close(fd);
 114:	00090513          	mv	a0,s2
 118:	00000097          	auipc	ra,0x0
 11c:	44c080e7          	jalr	1100(ra) # 564 <close>

  wait(0);
 120:	00000513          	li	a0,0
 124:	00000097          	auipc	ra,0x0
 128:	410080e7          	jalr	1040(ra) # 534 <wait>

  exit(0);
 12c:	00000513          	li	a0,0
 130:	00000097          	auipc	ra,0x0
 134:	3f8080e7          	jalr	1016(ra) # 528 <exit>

0000000000000138 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 138:	ff010113          	add	sp,sp,-16
 13c:	00113423          	sd	ra,8(sp)
 140:	00813023          	sd	s0,0(sp)
 144:	01010413          	add	s0,sp,16
  extern int main();
  main();
 148:	00000097          	auipc	ra,0x0
 14c:	eb8080e7          	jalr	-328(ra) # 0 <main>
  exit(0);
 150:	00000513          	li	a0,0
 154:	00000097          	auipc	ra,0x0
 158:	3d4080e7          	jalr	980(ra) # 528 <exit>

000000000000015c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 15c:	ff010113          	add	sp,sp,-16
 160:	00813423          	sd	s0,8(sp)
 164:	01010413          	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 168:	00050793          	mv	a5,a0
 16c:	00158593          	add	a1,a1,1
 170:	00178793          	add	a5,a5,1
 174:	fff5c703          	lbu	a4,-1(a1)
 178:	fee78fa3          	sb	a4,-1(a5)
 17c:	fe0718e3          	bnez	a4,16c <strcpy+0x10>
    ;
  return os;
}
 180:	00813403          	ld	s0,8(sp)
 184:	01010113          	add	sp,sp,16
 188:	00008067          	ret

000000000000018c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 18c:	ff010113          	add	sp,sp,-16
 190:	00813423          	sd	s0,8(sp)
 194:	01010413          	add	s0,sp,16
  while(*p && *p == *q)
 198:	00054783          	lbu	a5,0(a0)
 19c:	00078e63          	beqz	a5,1b8 <strcmp+0x2c>
 1a0:	0005c703          	lbu	a4,0(a1)
 1a4:	00f71a63          	bne	a4,a5,1b8 <strcmp+0x2c>
    p++, q++;
 1a8:	00150513          	add	a0,a0,1
 1ac:	00158593          	add	a1,a1,1
  while(*p && *p == *q)
 1b0:	00054783          	lbu	a5,0(a0)
 1b4:	fe0796e3          	bnez	a5,1a0 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 1b8:	0005c503          	lbu	a0,0(a1)
}
 1bc:	40a7853b          	subw	a0,a5,a0
 1c0:	00813403          	ld	s0,8(sp)
 1c4:	01010113          	add	sp,sp,16
 1c8:	00008067          	ret

00000000000001cc <strlen>:

uint
strlen(const char *s)
{
 1cc:	ff010113          	add	sp,sp,-16
 1d0:	00813423          	sd	s0,8(sp)
 1d4:	01010413          	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1d8:	00054783          	lbu	a5,0(a0)
 1dc:	02078863          	beqz	a5,20c <strlen+0x40>
 1e0:	00150513          	add	a0,a0,1
 1e4:	00050793          	mv	a5,a0
 1e8:	00078693          	mv	a3,a5
 1ec:	00178793          	add	a5,a5,1
 1f0:	fff7c703          	lbu	a4,-1(a5)
 1f4:	fe071ae3          	bnez	a4,1e8 <strlen+0x1c>
 1f8:	40a6853b          	subw	a0,a3,a0
 1fc:	0015051b          	addw	a0,a0,1
    ;
  return n;
}
 200:	00813403          	ld	s0,8(sp)
 204:	01010113          	add	sp,sp,16
 208:	00008067          	ret
  for(n = 0; s[n]; n++)
 20c:	00000513          	li	a0,0
 210:	ff1ff06f          	j	200 <strlen+0x34>

0000000000000214 <memset>:

void*
memset(void *dst, int c, uint n)
{
 214:	ff010113          	add	sp,sp,-16
 218:	00813423          	sd	s0,8(sp)
 21c:	01010413          	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 220:	02060063          	beqz	a2,240 <memset+0x2c>
 224:	00050793          	mv	a5,a0
 228:	02061613          	sll	a2,a2,0x20
 22c:	02065613          	srl	a2,a2,0x20
 230:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 234:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 238:	00178793          	add	a5,a5,1
 23c:	fee79ce3          	bne	a5,a4,234 <memset+0x20>
  }
  return dst;
}
 240:	00813403          	ld	s0,8(sp)
 244:	01010113          	add	sp,sp,16
 248:	00008067          	ret

000000000000024c <strchr>:

char*
strchr(const char *s, char c)
{
 24c:	ff010113          	add	sp,sp,-16
 250:	00813423          	sd	s0,8(sp)
 254:	01010413          	add	s0,sp,16
  for(; *s; s++)
 258:	00054783          	lbu	a5,0(a0)
 25c:	02078263          	beqz	a5,280 <strchr+0x34>
    if(*s == c)
 260:	00f58a63          	beq	a1,a5,274 <strchr+0x28>
  for(; *s; s++)
 264:	00150513          	add	a0,a0,1
 268:	00054783          	lbu	a5,0(a0)
 26c:	fe079ae3          	bnez	a5,260 <strchr+0x14>
      return (char*)s;
  return 0;
 270:	00000513          	li	a0,0
}
 274:	00813403          	ld	s0,8(sp)
 278:	01010113          	add	sp,sp,16
 27c:	00008067          	ret
  return 0;
 280:	00000513          	li	a0,0
 284:	ff1ff06f          	j	274 <strchr+0x28>

0000000000000288 <gets>:

char*
gets(char *buf, int max)
{
 288:	fa010113          	add	sp,sp,-96
 28c:	04113c23          	sd	ra,88(sp)
 290:	04813823          	sd	s0,80(sp)
 294:	04913423          	sd	s1,72(sp)
 298:	05213023          	sd	s2,64(sp)
 29c:	03313c23          	sd	s3,56(sp)
 2a0:	03413823          	sd	s4,48(sp)
 2a4:	03513423          	sd	s5,40(sp)
 2a8:	03613023          	sd	s6,32(sp)
 2ac:	01713c23          	sd	s7,24(sp)
 2b0:	06010413          	add	s0,sp,96
 2b4:	00050b93          	mv	s7,a0
 2b8:	00058a13          	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2bc:	00050913          	mv	s2,a0
 2c0:	00000493          	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2c4:	00a00a93          	li	s5,10
 2c8:	00d00b13          	li	s6,13
  for(i=0; i+1 < max; ){
 2cc:	00048993          	mv	s3,s1
 2d0:	0014849b          	addw	s1,s1,1
 2d4:	0344de63          	bge	s1,s4,310 <gets+0x88>
    cc = read(0, &c, 1);
 2d8:	00100613          	li	a2,1
 2dc:	faf40593          	add	a1,s0,-81
 2e0:	00000513          	li	a0,0
 2e4:	00000097          	auipc	ra,0x0
 2e8:	268080e7          	jalr	616(ra) # 54c <read>
    if(cc < 1)
 2ec:	02a05263          	blez	a0,310 <gets+0x88>
    buf[i++] = c;
 2f0:	faf44783          	lbu	a5,-81(s0)
 2f4:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2f8:	01578a63          	beq	a5,s5,30c <gets+0x84>
 2fc:	00190913          	add	s2,s2,1
 300:	fd6796e3          	bne	a5,s6,2cc <gets+0x44>
  for(i=0; i+1 < max; ){
 304:	00048993          	mv	s3,s1
 308:	0080006f          	j	310 <gets+0x88>
 30c:	00048993          	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 310:	013b89b3          	add	s3,s7,s3
 314:	00098023          	sb	zero,0(s3)
  return buf;
}
 318:	000b8513          	mv	a0,s7
 31c:	05813083          	ld	ra,88(sp)
 320:	05013403          	ld	s0,80(sp)
 324:	04813483          	ld	s1,72(sp)
 328:	04013903          	ld	s2,64(sp)
 32c:	03813983          	ld	s3,56(sp)
 330:	03013a03          	ld	s4,48(sp)
 334:	02813a83          	ld	s5,40(sp)
 338:	02013b03          	ld	s6,32(sp)
 33c:	01813b83          	ld	s7,24(sp)
 340:	06010113          	add	sp,sp,96
 344:	00008067          	ret

0000000000000348 <stat>:

int
stat(const char *n, struct stat *st)
{
 348:	fe010113          	add	sp,sp,-32
 34c:	00113c23          	sd	ra,24(sp)
 350:	00813823          	sd	s0,16(sp)
 354:	00913423          	sd	s1,8(sp)
 358:	01213023          	sd	s2,0(sp)
 35c:	02010413          	add	s0,sp,32
 360:	00058913          	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 364:	00000593          	li	a1,0
 368:	00000097          	auipc	ra,0x0
 36c:	220080e7          	jalr	544(ra) # 588 <open>
  if(fd < 0)
 370:	04054063          	bltz	a0,3b0 <stat+0x68>
 374:	00050493          	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 378:	00090593          	mv	a1,s2
 37c:	00000097          	auipc	ra,0x0
 380:	230080e7          	jalr	560(ra) # 5ac <fstat>
 384:	00050913          	mv	s2,a0
  close(fd);
 388:	00048513          	mv	a0,s1
 38c:	00000097          	auipc	ra,0x0
 390:	1d8080e7          	jalr	472(ra) # 564 <close>
  return r;
}
 394:	00090513          	mv	a0,s2
 398:	01813083          	ld	ra,24(sp)
 39c:	01013403          	ld	s0,16(sp)
 3a0:	00813483          	ld	s1,8(sp)
 3a4:	00013903          	ld	s2,0(sp)
 3a8:	02010113          	add	sp,sp,32
 3ac:	00008067          	ret
    return -1;
 3b0:	fff00913          	li	s2,-1
 3b4:	fe1ff06f          	j	394 <stat+0x4c>

00000000000003b8 <atoi>:

int
atoi(const char *s)
{
 3b8:	ff010113          	add	sp,sp,-16
 3bc:	00813423          	sd	s0,8(sp)
 3c0:	01010413          	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3c4:	00054683          	lbu	a3,0(a0)
 3c8:	fd06879b          	addw	a5,a3,-48
 3cc:	0ff7f793          	zext.b	a5,a5
 3d0:	00900613          	li	a2,9
 3d4:	04f66063          	bltu	a2,a5,414 <atoi+0x5c>
 3d8:	00050713          	mv	a4,a0
  n = 0;
 3dc:	00000513          	li	a0,0
    n = n*10 + *s++ - '0';
 3e0:	00170713          	add	a4,a4,1
 3e4:	0025179b          	sllw	a5,a0,0x2
 3e8:	00a787bb          	addw	a5,a5,a0
 3ec:	0017979b          	sllw	a5,a5,0x1
 3f0:	00d787bb          	addw	a5,a5,a3
 3f4:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3f8:	00074683          	lbu	a3,0(a4)
 3fc:	fd06879b          	addw	a5,a3,-48
 400:	0ff7f793          	zext.b	a5,a5
 404:	fcf67ee3          	bgeu	a2,a5,3e0 <atoi+0x28>
  return n;
}
 408:	00813403          	ld	s0,8(sp)
 40c:	01010113          	add	sp,sp,16
 410:	00008067          	ret
  n = 0;
 414:	00000513          	li	a0,0
 418:	ff1ff06f          	j	408 <atoi+0x50>

000000000000041c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 41c:	ff010113          	add	sp,sp,-16
 420:	00813423          	sd	s0,8(sp)
 424:	01010413          	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 428:	02b57c63          	bgeu	a0,a1,460 <memmove+0x44>
    while(n-- > 0)
 42c:	02c05463          	blez	a2,454 <memmove+0x38>
 430:	02061613          	sll	a2,a2,0x20
 434:	02065613          	srl	a2,a2,0x20
 438:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 43c:	00050713          	mv	a4,a0
      *dst++ = *src++;
 440:	00158593          	add	a1,a1,1
 444:	00170713          	add	a4,a4,1
 448:	fff5c683          	lbu	a3,-1(a1)
 44c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 450:	fee798e3          	bne	a5,a4,440 <memmove+0x24>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 454:	00813403          	ld	s0,8(sp)
 458:	01010113          	add	sp,sp,16
 45c:	00008067          	ret
    dst += n;
 460:	00c50733          	add	a4,a0,a2
    src += n;
 464:	00c585b3          	add	a1,a1,a2
    while(n-- > 0)
 468:	fec056e3          	blez	a2,454 <memmove+0x38>
 46c:	fff6079b          	addw	a5,a2,-1
 470:	02079793          	sll	a5,a5,0x20
 474:	0207d793          	srl	a5,a5,0x20
 478:	fff7c793          	not	a5,a5
 47c:	00f707b3          	add	a5,a4,a5
      *--dst = *--src;
 480:	fff58593          	add	a1,a1,-1
 484:	fff70713          	add	a4,a4,-1
 488:	0005c683          	lbu	a3,0(a1)
 48c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 490:	fee798e3          	bne	a5,a4,480 <memmove+0x64>
 494:	fc1ff06f          	j	454 <memmove+0x38>

0000000000000498 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 498:	ff010113          	add	sp,sp,-16
 49c:	00813423          	sd	s0,8(sp)
 4a0:	01010413          	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4a4:	04060463          	beqz	a2,4ec <memcmp+0x54>
 4a8:	fff6069b          	addw	a3,a2,-1
 4ac:	02069693          	sll	a3,a3,0x20
 4b0:	0206d693          	srl	a3,a3,0x20
 4b4:	00168693          	add	a3,a3,1
 4b8:	00d506b3          	add	a3,a0,a3
    if (*p1 != *p2) {
 4bc:	00054783          	lbu	a5,0(a0)
 4c0:	0005c703          	lbu	a4,0(a1)
 4c4:	00e79c63          	bne	a5,a4,4dc <memcmp+0x44>
      return *p1 - *p2;
    }
    p1++;
 4c8:	00150513          	add	a0,a0,1
    p2++;
 4cc:	00158593          	add	a1,a1,1
  while (n-- > 0) {
 4d0:	fed516e3          	bne	a0,a3,4bc <memcmp+0x24>
  }
  return 0;
 4d4:	00000513          	li	a0,0
 4d8:	0080006f          	j	4e0 <memcmp+0x48>
      return *p1 - *p2;
 4dc:	40e7853b          	subw	a0,a5,a4
}
 4e0:	00813403          	ld	s0,8(sp)
 4e4:	01010113          	add	sp,sp,16
 4e8:	00008067          	ret
  return 0;
 4ec:	00000513          	li	a0,0
 4f0:	ff1ff06f          	j	4e0 <memcmp+0x48>

00000000000004f4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4f4:	ff010113          	add	sp,sp,-16
 4f8:	00113423          	sd	ra,8(sp)
 4fc:	00813023          	sd	s0,0(sp)
 500:	01010413          	add	s0,sp,16
  return memmove(dst, src, n);
 504:	00000097          	auipc	ra,0x0
 508:	f18080e7          	jalr	-232(ra) # 41c <memmove>
}
 50c:	00813083          	ld	ra,8(sp)
 510:	00013403          	ld	s0,0(sp)
 514:	01010113          	add	sp,sp,16
 518:	00008067          	ret

000000000000051c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 51c:	00100893          	li	a7,1
 ecall
 520:	00000073          	ecall
 ret
 524:	00008067          	ret

0000000000000528 <exit>:
.global exit
exit:
 li a7, SYS_exit
 528:	00200893          	li	a7,2
 ecall
 52c:	00000073          	ecall
 ret
 530:	00008067          	ret

0000000000000534 <wait>:
.global wait
wait:
 li a7, SYS_wait
 534:	00300893          	li	a7,3
 ecall
 538:	00000073          	ecall
 ret
 53c:	00008067          	ret

0000000000000540 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 540:	00400893          	li	a7,4
 ecall
 544:	00000073          	ecall
 ret
 548:	00008067          	ret

000000000000054c <read>:
.global read
read:
 li a7, SYS_read
 54c:	00500893          	li	a7,5
 ecall
 550:	00000073          	ecall
 ret
 554:	00008067          	ret

0000000000000558 <write>:
.global write
write:
 li a7, SYS_write
 558:	01000893          	li	a7,16
 ecall
 55c:	00000073          	ecall
 ret
 560:	00008067          	ret

0000000000000564 <close>:
.global close
close:
 li a7, SYS_close
 564:	01500893          	li	a7,21
 ecall
 568:	00000073          	ecall
 ret
 56c:	00008067          	ret

0000000000000570 <kill>:
.global kill
kill:
 li a7, SYS_kill
 570:	00600893          	li	a7,6
 ecall
 574:	00000073          	ecall
 ret
 578:	00008067          	ret

000000000000057c <exec>:
.global exec
exec:
 li a7, SYS_exec
 57c:	00700893          	li	a7,7
 ecall
 580:	00000073          	ecall
 ret
 584:	00008067          	ret

0000000000000588 <open>:
.global open
open:
 li a7, SYS_open
 588:	00f00893          	li	a7,15
 ecall
 58c:	00000073          	ecall
 ret
 590:	00008067          	ret

0000000000000594 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 594:	01100893          	li	a7,17
 ecall
 598:	00000073          	ecall
 ret
 59c:	00008067          	ret

00000000000005a0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5a0:	01200893          	li	a7,18
 ecall
 5a4:	00000073          	ecall
 ret
 5a8:	00008067          	ret

00000000000005ac <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5ac:	00800893          	li	a7,8
 ecall
 5b0:	00000073          	ecall
 ret
 5b4:	00008067          	ret

00000000000005b8 <link>:
.global link
link:
 li a7, SYS_link
 5b8:	01300893          	li	a7,19
 ecall
 5bc:	00000073          	ecall
 ret
 5c0:	00008067          	ret

00000000000005c4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5c4:	01400893          	li	a7,20
 ecall
 5c8:	00000073          	ecall
 ret
 5cc:	00008067          	ret

00000000000005d0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5d0:	00900893          	li	a7,9
 ecall
 5d4:	00000073          	ecall
 ret
 5d8:	00008067          	ret

00000000000005dc <dup>:
.global dup
dup:
 li a7, SYS_dup
 5dc:	00a00893          	li	a7,10
 ecall
 5e0:	00000073          	ecall
 ret
 5e4:	00008067          	ret

00000000000005e8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5e8:	00b00893          	li	a7,11
 ecall
 5ec:	00000073          	ecall
 ret
 5f0:	00008067          	ret

00000000000005f4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5f4:	00c00893          	li	a7,12
 ecall
 5f8:	00000073          	ecall
 ret
 5fc:	00008067          	ret

0000000000000600 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 600:	00d00893          	li	a7,13
 ecall
 604:	00000073          	ecall
 ret
 608:	00008067          	ret

000000000000060c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 60c:	00e00893          	li	a7,14
 ecall
 610:	00000073          	ecall
 ret
 614:	00008067          	ret

0000000000000618 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 618:	fe010113          	add	sp,sp,-32
 61c:	00113c23          	sd	ra,24(sp)
 620:	00813823          	sd	s0,16(sp)
 624:	02010413          	add	s0,sp,32
 628:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 62c:	00100613          	li	a2,1
 630:	fef40593          	add	a1,s0,-17
 634:	00000097          	auipc	ra,0x0
 638:	f24080e7          	jalr	-220(ra) # 558 <write>
}
 63c:	01813083          	ld	ra,24(sp)
 640:	01013403          	ld	s0,16(sp)
 644:	02010113          	add	sp,sp,32
 648:	00008067          	ret

000000000000064c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 64c:	fc010113          	add	sp,sp,-64
 650:	02113c23          	sd	ra,56(sp)
 654:	02813823          	sd	s0,48(sp)
 658:	02913423          	sd	s1,40(sp)
 65c:	03213023          	sd	s2,32(sp)
 660:	01313c23          	sd	s3,24(sp)
 664:	04010413          	add	s0,sp,64
 668:	00050493          	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 66c:	00068463          	beqz	a3,674 <printint+0x28>
 670:	0c05c063          	bltz	a1,730 <printint+0xe4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 674:	0005859b          	sext.w	a1,a1
  neg = 0;
 678:	00000893          	li	a7,0
 67c:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 680:	00000713          	li	a4,0
  do{
    buf[i++] = digits[x % base];
 684:	0006061b          	sext.w	a2,a2
 688:	00000517          	auipc	a0,0x0
 68c:	66850513          	add	a0,a0,1640 # cf0 <digits>
 690:	00070813          	mv	a6,a4
 694:	0017071b          	addw	a4,a4,1
 698:	02c5f7bb          	remuw	a5,a1,a2
 69c:	02079793          	sll	a5,a5,0x20
 6a0:	0207d793          	srl	a5,a5,0x20
 6a4:	00f507b3          	add	a5,a0,a5
 6a8:	0007c783          	lbu	a5,0(a5)
 6ac:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 6b0:	0005879b          	sext.w	a5,a1
 6b4:	02c5d5bb          	divuw	a1,a1,a2
 6b8:	00168693          	add	a3,a3,1
 6bc:	fcc7fae3          	bgeu	a5,a2,690 <printint+0x44>
  if(neg)
 6c0:	00088c63          	beqz	a7,6d8 <printint+0x8c>
    buf[i++] = '-';
 6c4:	fd070793          	add	a5,a4,-48
 6c8:	00878733          	add	a4,a5,s0
 6cc:	02d00793          	li	a5,45
 6d0:	fef70823          	sb	a5,-16(a4)
 6d4:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 6d8:	02e05e63          	blez	a4,714 <printint+0xc8>
 6dc:	fc040793          	add	a5,s0,-64
 6e0:	00e78933          	add	s2,a5,a4
 6e4:	fff78993          	add	s3,a5,-1
 6e8:	00e989b3          	add	s3,s3,a4
 6ec:	fff7071b          	addw	a4,a4,-1
 6f0:	02071713          	sll	a4,a4,0x20
 6f4:	02075713          	srl	a4,a4,0x20
 6f8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6fc:	fff94583          	lbu	a1,-1(s2)
 700:	00048513          	mv	a0,s1
 704:	00000097          	auipc	ra,0x0
 708:	f14080e7          	jalr	-236(ra) # 618 <putc>
  while(--i >= 0)
 70c:	fff90913          	add	s2,s2,-1
 710:	ff3916e3          	bne	s2,s3,6fc <printint+0xb0>
}
 714:	03813083          	ld	ra,56(sp)
 718:	03013403          	ld	s0,48(sp)
 71c:	02813483          	ld	s1,40(sp)
 720:	02013903          	ld	s2,32(sp)
 724:	01813983          	ld	s3,24(sp)
 728:	04010113          	add	sp,sp,64
 72c:	00008067          	ret
    x = -xx;
 730:	40b005bb          	negw	a1,a1
    neg = 1;
 734:	00100893          	li	a7,1
    x = -xx;
 738:	f45ff06f          	j	67c <printint+0x30>

000000000000073c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 73c:	fb010113          	add	sp,sp,-80
 740:	04113423          	sd	ra,72(sp)
 744:	04813023          	sd	s0,64(sp)
 748:	02913c23          	sd	s1,56(sp)
 74c:	03213823          	sd	s2,48(sp)
 750:	03313423          	sd	s3,40(sp)
 754:	03413023          	sd	s4,32(sp)
 758:	01513c23          	sd	s5,24(sp)
 75c:	01613823          	sd	s6,16(sp)
 760:	01713423          	sd	s7,8(sp)
 764:	01813023          	sd	s8,0(sp)
 768:	05010413          	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 76c:	0005c903          	lbu	s2,0(a1)
 770:	20090e63          	beqz	s2,98c <vprintf+0x250>
 774:	00050a93          	mv	s5,a0
 778:	00060b93          	mv	s7,a2
 77c:	00158493          	add	s1,a1,1
  state = 0;
 780:	00000993          	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 784:	02500a13          	li	s4,37
 788:	01500b13          	li	s6,21
 78c:	0280006f          	j	7b4 <vprintf+0x78>
        putc(fd, c);
 790:	00090593          	mv	a1,s2
 794:	000a8513          	mv	a0,s5
 798:	00000097          	auipc	ra,0x0
 79c:	e80080e7          	jalr	-384(ra) # 618 <putc>
 7a0:	0080006f          	j	7a8 <vprintf+0x6c>
    } else if(state == '%'){
 7a4:	03498063          	beq	s3,s4,7c4 <vprintf+0x88>
  for(i = 0; fmt[i]; i++){
 7a8:	00148493          	add	s1,s1,1
 7ac:	fff4c903          	lbu	s2,-1(s1)
 7b0:	1c090e63          	beqz	s2,98c <vprintf+0x250>
    if(state == 0){
 7b4:	fe0998e3          	bnez	s3,7a4 <vprintf+0x68>
      if(c == '%'){
 7b8:	fd491ce3          	bne	s2,s4,790 <vprintf+0x54>
        state = '%';
 7bc:	000a0993          	mv	s3,s4
 7c0:	fe9ff06f          	j	7a8 <vprintf+0x6c>
      if(c == 'd'){
 7c4:	17490e63          	beq	s2,s4,940 <vprintf+0x204>
 7c8:	f9d9079b          	addw	a5,s2,-99
 7cc:	0ff7f793          	zext.b	a5,a5
 7d0:	18fb6463          	bltu	s6,a5,958 <vprintf+0x21c>
 7d4:	f9d9079b          	addw	a5,s2,-99
 7d8:	0ff7f713          	zext.b	a4,a5
 7dc:	16eb6e63          	bltu	s6,a4,958 <vprintf+0x21c>
 7e0:	00271793          	sll	a5,a4,0x2
 7e4:	00000717          	auipc	a4,0x0
 7e8:	4b470713          	add	a4,a4,1204 # c98 <malloc+0x190>
 7ec:	00e787b3          	add	a5,a5,a4
 7f0:	0007a783          	lw	a5,0(a5)
 7f4:	00e787b3          	add	a5,a5,a4
 7f8:	00078067          	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 7fc:	008b8913          	add	s2,s7,8
 800:	00100693          	li	a3,1
 804:	00a00613          	li	a2,10
 808:	000ba583          	lw	a1,0(s7)
 80c:	000a8513          	mv	a0,s5
 810:	00000097          	auipc	ra,0x0
 814:	e3c080e7          	jalr	-452(ra) # 64c <printint>
 818:	00090b93          	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 81c:	00000993          	li	s3,0
 820:	f89ff06f          	j	7a8 <vprintf+0x6c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 824:	008b8913          	add	s2,s7,8
 828:	00000693          	li	a3,0
 82c:	00a00613          	li	a2,10
 830:	000ba583          	lw	a1,0(s7)
 834:	000a8513          	mv	a0,s5
 838:	00000097          	auipc	ra,0x0
 83c:	e14080e7          	jalr	-492(ra) # 64c <printint>
 840:	00090b93          	mv	s7,s2
      state = 0;
 844:	00000993          	li	s3,0
 848:	f61ff06f          	j	7a8 <vprintf+0x6c>
        printint(fd, va_arg(ap, int), 16, 0);
 84c:	008b8913          	add	s2,s7,8
 850:	00000693          	li	a3,0
 854:	01000613          	li	a2,16
 858:	000ba583          	lw	a1,0(s7)
 85c:	000a8513          	mv	a0,s5
 860:	00000097          	auipc	ra,0x0
 864:	dec080e7          	jalr	-532(ra) # 64c <printint>
 868:	00090b93          	mv	s7,s2
      state = 0;
 86c:	00000993          	li	s3,0
 870:	f39ff06f          	j	7a8 <vprintf+0x6c>
        printptr(fd, va_arg(ap, uint64));
 874:	008b8c13          	add	s8,s7,8
 878:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 87c:	03000593          	li	a1,48
 880:	000a8513          	mv	a0,s5
 884:	00000097          	auipc	ra,0x0
 888:	d94080e7          	jalr	-620(ra) # 618 <putc>
  putc(fd, 'x');
 88c:	07800593          	li	a1,120
 890:	000a8513          	mv	a0,s5
 894:	00000097          	auipc	ra,0x0
 898:	d84080e7          	jalr	-636(ra) # 618 <putc>
 89c:	01000913          	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8a0:	00000b97          	auipc	s7,0x0
 8a4:	450b8b93          	add	s7,s7,1104 # cf0 <digits>
 8a8:	03c9d793          	srl	a5,s3,0x3c
 8ac:	00fb87b3          	add	a5,s7,a5
 8b0:	0007c583          	lbu	a1,0(a5)
 8b4:	000a8513          	mv	a0,s5
 8b8:	00000097          	auipc	ra,0x0
 8bc:	d60080e7          	jalr	-672(ra) # 618 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 8c0:	00499993          	sll	s3,s3,0x4
 8c4:	fff9091b          	addw	s2,s2,-1
 8c8:	fe0910e3          	bnez	s2,8a8 <vprintf+0x16c>
        printptr(fd, va_arg(ap, uint64));
 8cc:	000c0b93          	mv	s7,s8
      state = 0;
 8d0:	00000993          	li	s3,0
 8d4:	ed5ff06f          	j	7a8 <vprintf+0x6c>
        s = va_arg(ap, char*);
 8d8:	008b8993          	add	s3,s7,8
 8dc:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 8e0:	02090863          	beqz	s2,910 <vprintf+0x1d4>
        while(*s != 0){
 8e4:	00094583          	lbu	a1,0(s2)
 8e8:	08058c63          	beqz	a1,980 <vprintf+0x244>
          putc(fd, *s);
 8ec:	000a8513          	mv	a0,s5
 8f0:	00000097          	auipc	ra,0x0
 8f4:	d28080e7          	jalr	-728(ra) # 618 <putc>
          s++;
 8f8:	00190913          	add	s2,s2,1
        while(*s != 0){
 8fc:	00094583          	lbu	a1,0(s2)
 900:	fe0596e3          	bnez	a1,8ec <vprintf+0x1b0>
        s = va_arg(ap, char*);
 904:	00098b93          	mv	s7,s3
      state = 0;
 908:	00000993          	li	s3,0
 90c:	e9dff06f          	j	7a8 <vprintf+0x6c>
          s = "(null)";
 910:	00000917          	auipc	s2,0x0
 914:	38090913          	add	s2,s2,896 # c90 <malloc+0x188>
        while(*s != 0){
 918:	02800593          	li	a1,40
 91c:	fd1ff06f          	j	8ec <vprintf+0x1b0>
        putc(fd, va_arg(ap, uint));
 920:	008b8913          	add	s2,s7,8
 924:	000bc583          	lbu	a1,0(s7)
 928:	000a8513          	mv	a0,s5
 92c:	00000097          	auipc	ra,0x0
 930:	cec080e7          	jalr	-788(ra) # 618 <putc>
 934:	00090b93          	mv	s7,s2
      state = 0;
 938:	00000993          	li	s3,0
 93c:	e6dff06f          	j	7a8 <vprintf+0x6c>
        putc(fd, c);
 940:	02500593          	li	a1,37
 944:	000a8513          	mv	a0,s5
 948:	00000097          	auipc	ra,0x0
 94c:	cd0080e7          	jalr	-816(ra) # 618 <putc>
      state = 0;
 950:	00000993          	li	s3,0
 954:	e55ff06f          	j	7a8 <vprintf+0x6c>
        putc(fd, '%');
 958:	02500593          	li	a1,37
 95c:	000a8513          	mv	a0,s5
 960:	00000097          	auipc	ra,0x0
 964:	cb8080e7          	jalr	-840(ra) # 618 <putc>
        putc(fd, c);
 968:	00090593          	mv	a1,s2
 96c:	000a8513          	mv	a0,s5
 970:	00000097          	auipc	ra,0x0
 974:	ca8080e7          	jalr	-856(ra) # 618 <putc>
      state = 0;
 978:	00000993          	li	s3,0
 97c:	e2dff06f          	j	7a8 <vprintf+0x6c>
        s = va_arg(ap, char*);
 980:	00098b93          	mv	s7,s3
      state = 0;
 984:	00000993          	li	s3,0
 988:	e21ff06f          	j	7a8 <vprintf+0x6c>
    }
  }
}
 98c:	04813083          	ld	ra,72(sp)
 990:	04013403          	ld	s0,64(sp)
 994:	03813483          	ld	s1,56(sp)
 998:	03013903          	ld	s2,48(sp)
 99c:	02813983          	ld	s3,40(sp)
 9a0:	02013a03          	ld	s4,32(sp)
 9a4:	01813a83          	ld	s5,24(sp)
 9a8:	01013b03          	ld	s6,16(sp)
 9ac:	00813b83          	ld	s7,8(sp)
 9b0:	00013c03          	ld	s8,0(sp)
 9b4:	05010113          	add	sp,sp,80
 9b8:	00008067          	ret

00000000000009bc <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 9bc:	fb010113          	add	sp,sp,-80
 9c0:	00113c23          	sd	ra,24(sp)
 9c4:	00813823          	sd	s0,16(sp)
 9c8:	02010413          	add	s0,sp,32
 9cc:	00c43023          	sd	a2,0(s0)
 9d0:	00d43423          	sd	a3,8(s0)
 9d4:	00e43823          	sd	a4,16(s0)
 9d8:	00f43c23          	sd	a5,24(s0)
 9dc:	03043023          	sd	a6,32(s0)
 9e0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 9e4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 9e8:	00040613          	mv	a2,s0
 9ec:	00000097          	auipc	ra,0x0
 9f0:	d50080e7          	jalr	-688(ra) # 73c <vprintf>
}
 9f4:	01813083          	ld	ra,24(sp)
 9f8:	01013403          	ld	s0,16(sp)
 9fc:	05010113          	add	sp,sp,80
 a00:	00008067          	ret

0000000000000a04 <printf>:

void
printf(const char *fmt, ...)
{
 a04:	fa010113          	add	sp,sp,-96
 a08:	00113c23          	sd	ra,24(sp)
 a0c:	00813823          	sd	s0,16(sp)
 a10:	02010413          	add	s0,sp,32
 a14:	00b43423          	sd	a1,8(s0)
 a18:	00c43823          	sd	a2,16(s0)
 a1c:	00d43c23          	sd	a3,24(s0)
 a20:	02e43023          	sd	a4,32(s0)
 a24:	02f43423          	sd	a5,40(s0)
 a28:	03043823          	sd	a6,48(s0)
 a2c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a30:	00840613          	add	a2,s0,8
 a34:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a38:	00050593          	mv	a1,a0
 a3c:	00100513          	li	a0,1
 a40:	00000097          	auipc	ra,0x0
 a44:	cfc080e7          	jalr	-772(ra) # 73c <vprintf>
}
 a48:	01813083          	ld	ra,24(sp)
 a4c:	01013403          	ld	s0,16(sp)
 a50:	06010113          	add	sp,sp,96
 a54:	00008067          	ret

0000000000000a58 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a58:	ff010113          	add	sp,sp,-16
 a5c:	00813423          	sd	s0,8(sp)
 a60:	01010413          	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a64:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a68:	00000797          	auipc	a5,0x0
 a6c:	5987b783          	ld	a5,1432(a5) # 1000 <freep>
 a70:	0400006f          	j	ab0 <free+0x58>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 a74:	00862703          	lw	a4,8(a2)
 a78:	00b7073b          	addw	a4,a4,a1
 a7c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a80:	0007b703          	ld	a4,0(a5)
 a84:	00073603          	ld	a2,0(a4)
 a88:	0500006f          	j	ad8 <free+0x80>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 a8c:	ff852703          	lw	a4,-8(a0)
 a90:	00c7073b          	addw	a4,a4,a2
 a94:	00e7a423          	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 a98:	ff053683          	ld	a3,-16(a0)
 a9c:	0540006f          	j	af0 <free+0x98>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 aa0:	0007b703          	ld	a4,0(a5)
 aa4:	00e7e463          	bltu	a5,a4,aac <free+0x54>
 aa8:	00e6ec63          	bltu	a3,a4,ac0 <free+0x68>
{
 aac:	00070793          	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ab0:	fed7f8e3          	bgeu	a5,a3,aa0 <free+0x48>
 ab4:	0007b703          	ld	a4,0(a5)
 ab8:	00e6e463          	bltu	a3,a4,ac0 <free+0x68>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 abc:	fee7e8e3          	bltu	a5,a4,aac <free+0x54>
  if(bp + bp->s.size == p->s.ptr){
 ac0:	ff852583          	lw	a1,-8(a0)
 ac4:	0007b603          	ld	a2,0(a5)
 ac8:	02059813          	sll	a6,a1,0x20
 acc:	01c85713          	srl	a4,a6,0x1c
 ad0:	00e68733          	add	a4,a3,a4
 ad4:	fae600e3          	beq	a2,a4,a74 <free+0x1c>
    bp->s.ptr = p->s.ptr->s.ptr;
 ad8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 adc:	0087a603          	lw	a2,8(a5)
 ae0:	02061593          	sll	a1,a2,0x20
 ae4:	01c5d713          	srl	a4,a1,0x1c
 ae8:	00e78733          	add	a4,a5,a4
 aec:	fae680e3          	beq	a3,a4,a8c <free+0x34>
    p->s.ptr = bp->s.ptr;
 af0:	00d7b023          	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 af4:	00000717          	auipc	a4,0x0
 af8:	50f73623          	sd	a5,1292(a4) # 1000 <freep>
}
 afc:	00813403          	ld	s0,8(sp)
 b00:	01010113          	add	sp,sp,16
 b04:	00008067          	ret

0000000000000b08 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b08:	fc010113          	add	sp,sp,-64
 b0c:	02113c23          	sd	ra,56(sp)
 b10:	02813823          	sd	s0,48(sp)
 b14:	02913423          	sd	s1,40(sp)
 b18:	03213023          	sd	s2,32(sp)
 b1c:	01313c23          	sd	s3,24(sp)
 b20:	01413823          	sd	s4,16(sp)
 b24:	01513423          	sd	s5,8(sp)
 b28:	01613023          	sd	s6,0(sp)
 b2c:	04010413          	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b30:	02051493          	sll	s1,a0,0x20
 b34:	0204d493          	srl	s1,s1,0x20
 b38:	00f48493          	add	s1,s1,15
 b3c:	0044d493          	srl	s1,s1,0x4
 b40:	0014899b          	addw	s3,s1,1
 b44:	00148493          	add	s1,s1,1
  if((prevp = freep) == 0){
 b48:	00000517          	auipc	a0,0x0
 b4c:	4b853503          	ld	a0,1208(a0) # 1000 <freep>
 b50:	02050e63          	beqz	a0,b8c <malloc+0x84>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b54:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b58:	0087a703          	lw	a4,8(a5)
 b5c:	04977663          	bgeu	a4,s1,ba8 <malloc+0xa0>
  if(nu < 4096)
 b60:	00098a13          	mv	s4,s3
 b64:	0009871b          	sext.w	a4,s3
 b68:	000016b7          	lui	a3,0x1
 b6c:	00d77463          	bgeu	a4,a3,b74 <malloc+0x6c>
 b70:	00001a37          	lui	s4,0x1
 b74:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 b78:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 b7c:	00000917          	auipc	s2,0x0
 b80:	48490913          	add	s2,s2,1156 # 1000 <freep>
  if(p == (char*)-1)
 b84:	fff00a93          	li	s5,-1
 b88:	0a00006f          	j	c28 <malloc+0x120>
    base.s.ptr = freep = prevp = &base;
 b8c:	00000797          	auipc	a5,0x0
 b90:	48478793          	add	a5,a5,1156 # 1010 <base>
 b94:	00000717          	auipc	a4,0x0
 b98:	46f73623          	sd	a5,1132(a4) # 1000 <freep>
 b9c:	00f7b023          	sd	a5,0(a5)
    base.s.size = 0;
 ba0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 ba4:	fbdff06f          	j	b60 <malloc+0x58>
      if(p->s.size == nunits)
 ba8:	04e48863          	beq	s1,a4,bf8 <malloc+0xf0>
        p->s.size -= nunits;
 bac:	4137073b          	subw	a4,a4,s3
 bb0:	00e7a423          	sw	a4,8(a5)
        p += p->s.size;
 bb4:	02071693          	sll	a3,a4,0x20
 bb8:	01c6d713          	srl	a4,a3,0x1c
 bbc:	00e787b3          	add	a5,a5,a4
        p->s.size = nunits;
 bc0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 bc4:	00000717          	auipc	a4,0x0
 bc8:	42a73e23          	sd	a0,1084(a4) # 1000 <freep>
      return (void*)(p + 1);
 bcc:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 bd0:	03813083          	ld	ra,56(sp)
 bd4:	03013403          	ld	s0,48(sp)
 bd8:	02813483          	ld	s1,40(sp)
 bdc:	02013903          	ld	s2,32(sp)
 be0:	01813983          	ld	s3,24(sp)
 be4:	01013a03          	ld	s4,16(sp)
 be8:	00813a83          	ld	s5,8(sp)
 bec:	00013b03          	ld	s6,0(sp)
 bf0:	04010113          	add	sp,sp,64
 bf4:	00008067          	ret
        prevp->s.ptr = p->s.ptr;
 bf8:	0007b703          	ld	a4,0(a5)
 bfc:	00e53023          	sd	a4,0(a0)
 c00:	fc5ff06f          	j	bc4 <malloc+0xbc>
  hp->s.size = nu;
 c04:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 c08:	01050513          	add	a0,a0,16
 c0c:	00000097          	auipc	ra,0x0
 c10:	e4c080e7          	jalr	-436(ra) # a58 <free>
  return freep;
 c14:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 c18:	fa050ce3          	beqz	a0,bd0 <malloc+0xc8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c1c:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
 c20:	0087a703          	lw	a4,8(a5)
 c24:	f89772e3          	bgeu	a4,s1,ba8 <malloc+0xa0>
    if(p == freep)
 c28:	00093703          	ld	a4,0(s2)
 c2c:	00078513          	mv	a0,a5
 c30:	fef716e3          	bne	a4,a5,c1c <malloc+0x114>
  p = sbrk(nu * sizeof(Header));
 c34:	000a0513          	mv	a0,s4
 c38:	00000097          	auipc	ra,0x0
 c3c:	9bc080e7          	jalr	-1604(ra) # 5f4 <sbrk>
  if(p == (char*)-1)
 c40:	fd5512e3          	bne	a0,s5,c04 <malloc+0xfc>
        return 0;
 c44:	00000513          	li	a0,0
 c48:	f89ff06f          	j	bd0 <malloc+0xc8>
