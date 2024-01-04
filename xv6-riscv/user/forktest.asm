
user/_forktest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <print>:

#define N  1000

void
print(const char *s)
{
   0:	fe010113          	add	sp,sp,-32
   4:	00113c23          	sd	ra,24(sp)
   8:	00813823          	sd	s0,16(sp)
   c:	00913423          	sd	s1,8(sp)
  10:	02010413          	add	s0,sp,32
  14:	00050493          	mv	s1,a0
  write(1, s, strlen(s));
  18:	00000097          	auipc	ra,0x0
  1c:	1ec080e7          	jalr	492(ra) # 204 <strlen>
  20:	0005061b          	sext.w	a2,a0
  24:	00048593          	mv	a1,s1
  28:	00100513          	li	a0,1
  2c:	00000097          	auipc	ra,0x0
  30:	564080e7          	jalr	1380(ra) # 590 <write>
}
  34:	01813083          	ld	ra,24(sp)
  38:	01013403          	ld	s0,16(sp)
  3c:	00813483          	ld	s1,8(sp)
  40:	02010113          	add	sp,sp,32
  44:	00008067          	ret

0000000000000048 <forktest>:

void
forktest(void)
{
  48:	fe010113          	add	sp,sp,-32
  4c:	00113c23          	sd	ra,24(sp)
  50:	00813823          	sd	s0,16(sp)
  54:	00913423          	sd	s1,8(sp)
  58:	01213023          	sd	s2,0(sp)
  5c:	02010413          	add	s0,sp,32
  int n, pid;

  print("fork test\n");
  60:	00000517          	auipc	a0,0x0
  64:	5f050513          	add	a0,a0,1520 # 650 <uptime+0xc>
  68:	00000097          	auipc	ra,0x0
  6c:	f98080e7          	jalr	-104(ra) # 0 <print>

  for(n=0; n<N; n++){
  70:	00000493          	li	s1,0
  74:	3e800913          	li	s2,1000
    pid = fork();
  78:	00000097          	auipc	ra,0x0
  7c:	4dc080e7          	jalr	1244(ra) # 554 <fork>
    if(pid < 0)
  80:	02054a63          	bltz	a0,b4 <forktest+0x6c>
      break;
    if(pid == 0)
  84:	02050463          	beqz	a0,ac <forktest+0x64>
  for(n=0; n<N; n++){
  88:	0014849b          	addw	s1,s1,1
  8c:	ff2496e3          	bne	s1,s2,78 <forktest+0x30>
      exit(0);
  }

  if(n == N){
    print("fork claimed to work N times!\n");
  90:	00000517          	auipc	a0,0x0
  94:	5d050513          	add	a0,a0,1488 # 660 <uptime+0x1c>
  98:	00000097          	auipc	ra,0x0
  9c:	f68080e7          	jalr	-152(ra) # 0 <print>
    exit(1);
  a0:	00100513          	li	a0,1
  a4:	00000097          	auipc	ra,0x0
  a8:	4bc080e7          	jalr	1212(ra) # 560 <exit>
      exit(0);
  ac:	00000097          	auipc	ra,0x0
  b0:	4b4080e7          	jalr	1204(ra) # 560 <exit>
  if(n == N){
  b4:	3e800793          	li	a5,1000
  b8:	fcf48ce3          	beq	s1,a5,90 <forktest+0x48>
  }

  for(; n > 0; n--){
  bc:	00905e63          	blez	s1,d8 <forktest+0x90>
    if(wait(0) < 0){
  c0:	00000513          	li	a0,0
  c4:	00000097          	auipc	ra,0x0
  c8:	4a8080e7          	jalr	1192(ra) # 56c <wait>
  cc:	04054463          	bltz	a0,114 <forktest+0xcc>
  for(; n > 0; n--){
  d0:	fff4849b          	addw	s1,s1,-1
  d4:	fe0496e3          	bnez	s1,c0 <forktest+0x78>
      print("wait stopped early\n");
      exit(1);
    }
  }

  if(wait(0) != -1){
  d8:	00000513          	li	a0,0
  dc:	00000097          	auipc	ra,0x0
  e0:	490080e7          	jalr	1168(ra) # 56c <wait>
  e4:	fff00793          	li	a5,-1
  e8:	04f51463          	bne	a0,a5,130 <forktest+0xe8>
    print("wait got too many\n");
    exit(1);
  }

  print("fork test OK\n");
  ec:	00000517          	auipc	a0,0x0
  f0:	5c450513          	add	a0,a0,1476 # 6b0 <uptime+0x6c>
  f4:	00000097          	auipc	ra,0x0
  f8:	f0c080e7          	jalr	-244(ra) # 0 <print>
}
  fc:	01813083          	ld	ra,24(sp)
 100:	01013403          	ld	s0,16(sp)
 104:	00813483          	ld	s1,8(sp)
 108:	00013903          	ld	s2,0(sp)
 10c:	02010113          	add	sp,sp,32
 110:	00008067          	ret
      print("wait stopped early\n");
 114:	00000517          	auipc	a0,0x0
 118:	56c50513          	add	a0,a0,1388 # 680 <uptime+0x3c>
 11c:	00000097          	auipc	ra,0x0
 120:	ee4080e7          	jalr	-284(ra) # 0 <print>
      exit(1);
 124:	00100513          	li	a0,1
 128:	00000097          	auipc	ra,0x0
 12c:	438080e7          	jalr	1080(ra) # 560 <exit>
    print("wait got too many\n");
 130:	00000517          	auipc	a0,0x0
 134:	56850513          	add	a0,a0,1384 # 698 <uptime+0x54>
 138:	00000097          	auipc	ra,0x0
 13c:	ec8080e7          	jalr	-312(ra) # 0 <print>
    exit(1);
 140:	00100513          	li	a0,1
 144:	00000097          	auipc	ra,0x0
 148:	41c080e7          	jalr	1052(ra) # 560 <exit>

000000000000014c <main>:

int
main(void)
{
 14c:	ff010113          	add	sp,sp,-16
 150:	00113423          	sd	ra,8(sp)
 154:	00813023          	sd	s0,0(sp)
 158:	01010413          	add	s0,sp,16
  forktest();
 15c:	00000097          	auipc	ra,0x0
 160:	eec080e7          	jalr	-276(ra) # 48 <forktest>
  exit(0);
 164:	00000513          	li	a0,0
 168:	00000097          	auipc	ra,0x0
 16c:	3f8080e7          	jalr	1016(ra) # 560 <exit>

0000000000000170 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 170:	ff010113          	add	sp,sp,-16
 174:	00113423          	sd	ra,8(sp)
 178:	00813023          	sd	s0,0(sp)
 17c:	01010413          	add	s0,sp,16
  extern int main();
  main();
 180:	00000097          	auipc	ra,0x0
 184:	fcc080e7          	jalr	-52(ra) # 14c <main>
  exit(0);
 188:	00000513          	li	a0,0
 18c:	00000097          	auipc	ra,0x0
 190:	3d4080e7          	jalr	980(ra) # 560 <exit>

0000000000000194 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 194:	ff010113          	add	sp,sp,-16
 198:	00813423          	sd	s0,8(sp)
 19c:	01010413          	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1a0:	00050793          	mv	a5,a0
 1a4:	00158593          	add	a1,a1,1
 1a8:	00178793          	add	a5,a5,1
 1ac:	fff5c703          	lbu	a4,-1(a1)
 1b0:	fee78fa3          	sb	a4,-1(a5)
 1b4:	fe0718e3          	bnez	a4,1a4 <strcpy+0x10>
    ;
  return os;
}
 1b8:	00813403          	ld	s0,8(sp)
 1bc:	01010113          	add	sp,sp,16
 1c0:	00008067          	ret

00000000000001c4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1c4:	ff010113          	add	sp,sp,-16
 1c8:	00813423          	sd	s0,8(sp)
 1cc:	01010413          	add	s0,sp,16
  while(*p && *p == *q)
 1d0:	00054783          	lbu	a5,0(a0)
 1d4:	00078e63          	beqz	a5,1f0 <strcmp+0x2c>
 1d8:	0005c703          	lbu	a4,0(a1)
 1dc:	00f71a63          	bne	a4,a5,1f0 <strcmp+0x2c>
    p++, q++;
 1e0:	00150513          	add	a0,a0,1
 1e4:	00158593          	add	a1,a1,1
  while(*p && *p == *q)
 1e8:	00054783          	lbu	a5,0(a0)
 1ec:	fe0796e3          	bnez	a5,1d8 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 1f0:	0005c503          	lbu	a0,0(a1)
}
 1f4:	40a7853b          	subw	a0,a5,a0
 1f8:	00813403          	ld	s0,8(sp)
 1fc:	01010113          	add	sp,sp,16
 200:	00008067          	ret

0000000000000204 <strlen>:

uint
strlen(const char *s)
{
 204:	ff010113          	add	sp,sp,-16
 208:	00813423          	sd	s0,8(sp)
 20c:	01010413          	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 210:	00054783          	lbu	a5,0(a0)
 214:	02078863          	beqz	a5,244 <strlen+0x40>
 218:	00150513          	add	a0,a0,1
 21c:	00050793          	mv	a5,a0
 220:	00078693          	mv	a3,a5
 224:	00178793          	add	a5,a5,1
 228:	fff7c703          	lbu	a4,-1(a5)
 22c:	fe071ae3          	bnez	a4,220 <strlen+0x1c>
 230:	40a6853b          	subw	a0,a3,a0
 234:	0015051b          	addw	a0,a0,1
    ;
  return n;
}
 238:	00813403          	ld	s0,8(sp)
 23c:	01010113          	add	sp,sp,16
 240:	00008067          	ret
  for(n = 0; s[n]; n++)
 244:	00000513          	li	a0,0
 248:	ff1ff06f          	j	238 <strlen+0x34>

000000000000024c <memset>:

void*
memset(void *dst, int c, uint n)
{
 24c:	ff010113          	add	sp,sp,-16
 250:	00813423          	sd	s0,8(sp)
 254:	01010413          	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 258:	02060063          	beqz	a2,278 <memset+0x2c>
 25c:	00050793          	mv	a5,a0
 260:	02061613          	sll	a2,a2,0x20
 264:	02065613          	srl	a2,a2,0x20
 268:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 26c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 270:	00178793          	add	a5,a5,1
 274:	fee79ce3          	bne	a5,a4,26c <memset+0x20>
  }
  return dst;
}
 278:	00813403          	ld	s0,8(sp)
 27c:	01010113          	add	sp,sp,16
 280:	00008067          	ret

0000000000000284 <strchr>:

char*
strchr(const char *s, char c)
{
 284:	ff010113          	add	sp,sp,-16
 288:	00813423          	sd	s0,8(sp)
 28c:	01010413          	add	s0,sp,16
  for(; *s; s++)
 290:	00054783          	lbu	a5,0(a0)
 294:	02078263          	beqz	a5,2b8 <strchr+0x34>
    if(*s == c)
 298:	00f58a63          	beq	a1,a5,2ac <strchr+0x28>
  for(; *s; s++)
 29c:	00150513          	add	a0,a0,1
 2a0:	00054783          	lbu	a5,0(a0)
 2a4:	fe079ae3          	bnez	a5,298 <strchr+0x14>
      return (char*)s;
  return 0;
 2a8:	00000513          	li	a0,0
}
 2ac:	00813403          	ld	s0,8(sp)
 2b0:	01010113          	add	sp,sp,16
 2b4:	00008067          	ret
  return 0;
 2b8:	00000513          	li	a0,0
 2bc:	ff1ff06f          	j	2ac <strchr+0x28>

00000000000002c0 <gets>:

char*
gets(char *buf, int max)
{
 2c0:	fa010113          	add	sp,sp,-96
 2c4:	04113c23          	sd	ra,88(sp)
 2c8:	04813823          	sd	s0,80(sp)
 2cc:	04913423          	sd	s1,72(sp)
 2d0:	05213023          	sd	s2,64(sp)
 2d4:	03313c23          	sd	s3,56(sp)
 2d8:	03413823          	sd	s4,48(sp)
 2dc:	03513423          	sd	s5,40(sp)
 2e0:	03613023          	sd	s6,32(sp)
 2e4:	01713c23          	sd	s7,24(sp)
 2e8:	06010413          	add	s0,sp,96
 2ec:	00050b93          	mv	s7,a0
 2f0:	00058a13          	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2f4:	00050913          	mv	s2,a0
 2f8:	00000493          	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2fc:	00a00a93          	li	s5,10
 300:	00d00b13          	li	s6,13
  for(i=0; i+1 < max; ){
 304:	00048993          	mv	s3,s1
 308:	0014849b          	addw	s1,s1,1
 30c:	0344de63          	bge	s1,s4,348 <gets+0x88>
    cc = read(0, &c, 1);
 310:	00100613          	li	a2,1
 314:	faf40593          	add	a1,s0,-81
 318:	00000513          	li	a0,0
 31c:	00000097          	auipc	ra,0x0
 320:	268080e7          	jalr	616(ra) # 584 <read>
    if(cc < 1)
 324:	02a05263          	blez	a0,348 <gets+0x88>
    buf[i++] = c;
 328:	faf44783          	lbu	a5,-81(s0)
 32c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 330:	01578a63          	beq	a5,s5,344 <gets+0x84>
 334:	00190913          	add	s2,s2,1
 338:	fd6796e3          	bne	a5,s6,304 <gets+0x44>
  for(i=0; i+1 < max; ){
 33c:	00048993          	mv	s3,s1
 340:	0080006f          	j	348 <gets+0x88>
 344:	00048993          	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 348:	013b89b3          	add	s3,s7,s3
 34c:	00098023          	sb	zero,0(s3)
  return buf;
}
 350:	000b8513          	mv	a0,s7
 354:	05813083          	ld	ra,88(sp)
 358:	05013403          	ld	s0,80(sp)
 35c:	04813483          	ld	s1,72(sp)
 360:	04013903          	ld	s2,64(sp)
 364:	03813983          	ld	s3,56(sp)
 368:	03013a03          	ld	s4,48(sp)
 36c:	02813a83          	ld	s5,40(sp)
 370:	02013b03          	ld	s6,32(sp)
 374:	01813b83          	ld	s7,24(sp)
 378:	06010113          	add	sp,sp,96
 37c:	00008067          	ret

0000000000000380 <stat>:

int
stat(const char *n, struct stat *st)
{
 380:	fe010113          	add	sp,sp,-32
 384:	00113c23          	sd	ra,24(sp)
 388:	00813823          	sd	s0,16(sp)
 38c:	00913423          	sd	s1,8(sp)
 390:	01213023          	sd	s2,0(sp)
 394:	02010413          	add	s0,sp,32
 398:	00058913          	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 39c:	00000593          	li	a1,0
 3a0:	00000097          	auipc	ra,0x0
 3a4:	220080e7          	jalr	544(ra) # 5c0 <open>
  if(fd < 0)
 3a8:	04054063          	bltz	a0,3e8 <stat+0x68>
 3ac:	00050493          	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3b0:	00090593          	mv	a1,s2
 3b4:	00000097          	auipc	ra,0x0
 3b8:	230080e7          	jalr	560(ra) # 5e4 <fstat>
 3bc:	00050913          	mv	s2,a0
  close(fd);
 3c0:	00048513          	mv	a0,s1
 3c4:	00000097          	auipc	ra,0x0
 3c8:	1d8080e7          	jalr	472(ra) # 59c <close>
  return r;
}
 3cc:	00090513          	mv	a0,s2
 3d0:	01813083          	ld	ra,24(sp)
 3d4:	01013403          	ld	s0,16(sp)
 3d8:	00813483          	ld	s1,8(sp)
 3dc:	00013903          	ld	s2,0(sp)
 3e0:	02010113          	add	sp,sp,32
 3e4:	00008067          	ret
    return -1;
 3e8:	fff00913          	li	s2,-1
 3ec:	fe1ff06f          	j	3cc <stat+0x4c>

00000000000003f0 <atoi>:

int
atoi(const char *s)
{
 3f0:	ff010113          	add	sp,sp,-16
 3f4:	00813423          	sd	s0,8(sp)
 3f8:	01010413          	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3fc:	00054683          	lbu	a3,0(a0)
 400:	fd06879b          	addw	a5,a3,-48
 404:	0ff7f793          	zext.b	a5,a5
 408:	00900613          	li	a2,9
 40c:	04f66063          	bltu	a2,a5,44c <atoi+0x5c>
 410:	00050713          	mv	a4,a0
  n = 0;
 414:	00000513          	li	a0,0
    n = n*10 + *s++ - '0';
 418:	00170713          	add	a4,a4,1
 41c:	0025179b          	sllw	a5,a0,0x2
 420:	00a787bb          	addw	a5,a5,a0
 424:	0017979b          	sllw	a5,a5,0x1
 428:	00d787bb          	addw	a5,a5,a3
 42c:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 430:	00074683          	lbu	a3,0(a4)
 434:	fd06879b          	addw	a5,a3,-48
 438:	0ff7f793          	zext.b	a5,a5
 43c:	fcf67ee3          	bgeu	a2,a5,418 <atoi+0x28>
  return n;
}
 440:	00813403          	ld	s0,8(sp)
 444:	01010113          	add	sp,sp,16
 448:	00008067          	ret
  n = 0;
 44c:	00000513          	li	a0,0
 450:	ff1ff06f          	j	440 <atoi+0x50>

0000000000000454 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 454:	ff010113          	add	sp,sp,-16
 458:	00813423          	sd	s0,8(sp)
 45c:	01010413          	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 460:	02b57c63          	bgeu	a0,a1,498 <memmove+0x44>
    while(n-- > 0)
 464:	02c05463          	blez	a2,48c <memmove+0x38>
 468:	02061613          	sll	a2,a2,0x20
 46c:	02065613          	srl	a2,a2,0x20
 470:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 474:	00050713          	mv	a4,a0
      *dst++ = *src++;
 478:	00158593          	add	a1,a1,1
 47c:	00170713          	add	a4,a4,1
 480:	fff5c683          	lbu	a3,-1(a1)
 484:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 488:	fee798e3          	bne	a5,a4,478 <memmove+0x24>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 48c:	00813403          	ld	s0,8(sp)
 490:	01010113          	add	sp,sp,16
 494:	00008067          	ret
    dst += n;
 498:	00c50733          	add	a4,a0,a2
    src += n;
 49c:	00c585b3          	add	a1,a1,a2
    while(n-- > 0)
 4a0:	fec056e3          	blez	a2,48c <memmove+0x38>
 4a4:	fff6079b          	addw	a5,a2,-1
 4a8:	02079793          	sll	a5,a5,0x20
 4ac:	0207d793          	srl	a5,a5,0x20
 4b0:	fff7c793          	not	a5,a5
 4b4:	00f707b3          	add	a5,a4,a5
      *--dst = *--src;
 4b8:	fff58593          	add	a1,a1,-1
 4bc:	fff70713          	add	a4,a4,-1
 4c0:	0005c683          	lbu	a3,0(a1)
 4c4:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4c8:	fee798e3          	bne	a5,a4,4b8 <memmove+0x64>
 4cc:	fc1ff06f          	j	48c <memmove+0x38>

00000000000004d0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4d0:	ff010113          	add	sp,sp,-16
 4d4:	00813423          	sd	s0,8(sp)
 4d8:	01010413          	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4dc:	04060463          	beqz	a2,524 <memcmp+0x54>
 4e0:	fff6069b          	addw	a3,a2,-1
 4e4:	02069693          	sll	a3,a3,0x20
 4e8:	0206d693          	srl	a3,a3,0x20
 4ec:	00168693          	add	a3,a3,1
 4f0:	00d506b3          	add	a3,a0,a3
    if (*p1 != *p2) {
 4f4:	00054783          	lbu	a5,0(a0)
 4f8:	0005c703          	lbu	a4,0(a1)
 4fc:	00e79c63          	bne	a5,a4,514 <memcmp+0x44>
      return *p1 - *p2;
    }
    p1++;
 500:	00150513          	add	a0,a0,1
    p2++;
 504:	00158593          	add	a1,a1,1
  while (n-- > 0) {
 508:	fed516e3          	bne	a0,a3,4f4 <memcmp+0x24>
  }
  return 0;
 50c:	00000513          	li	a0,0
 510:	0080006f          	j	518 <memcmp+0x48>
      return *p1 - *p2;
 514:	40e7853b          	subw	a0,a5,a4
}
 518:	00813403          	ld	s0,8(sp)
 51c:	01010113          	add	sp,sp,16
 520:	00008067          	ret
  return 0;
 524:	00000513          	li	a0,0
 528:	ff1ff06f          	j	518 <memcmp+0x48>

000000000000052c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 52c:	ff010113          	add	sp,sp,-16
 530:	00113423          	sd	ra,8(sp)
 534:	00813023          	sd	s0,0(sp)
 538:	01010413          	add	s0,sp,16
  return memmove(dst, src, n);
 53c:	00000097          	auipc	ra,0x0
 540:	f18080e7          	jalr	-232(ra) # 454 <memmove>
}
 544:	00813083          	ld	ra,8(sp)
 548:	00013403          	ld	s0,0(sp)
 54c:	01010113          	add	sp,sp,16
 550:	00008067          	ret

0000000000000554 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 554:	00100893          	li	a7,1
 ecall
 558:	00000073          	ecall
 ret
 55c:	00008067          	ret

0000000000000560 <exit>:
.global exit
exit:
 li a7, SYS_exit
 560:	00200893          	li	a7,2
 ecall
 564:	00000073          	ecall
 ret
 568:	00008067          	ret

000000000000056c <wait>:
.global wait
wait:
 li a7, SYS_wait
 56c:	00300893          	li	a7,3
 ecall
 570:	00000073          	ecall
 ret
 574:	00008067          	ret

0000000000000578 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 578:	00400893          	li	a7,4
 ecall
 57c:	00000073          	ecall
 ret
 580:	00008067          	ret

0000000000000584 <read>:
.global read
read:
 li a7, SYS_read
 584:	00500893          	li	a7,5
 ecall
 588:	00000073          	ecall
 ret
 58c:	00008067          	ret

0000000000000590 <write>:
.global write
write:
 li a7, SYS_write
 590:	01000893          	li	a7,16
 ecall
 594:	00000073          	ecall
 ret
 598:	00008067          	ret

000000000000059c <close>:
.global close
close:
 li a7, SYS_close
 59c:	01500893          	li	a7,21
 ecall
 5a0:	00000073          	ecall
 ret
 5a4:	00008067          	ret

00000000000005a8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 5a8:	00600893          	li	a7,6
 ecall
 5ac:	00000073          	ecall
 ret
 5b0:	00008067          	ret

00000000000005b4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 5b4:	00700893          	li	a7,7
 ecall
 5b8:	00000073          	ecall
 ret
 5bc:	00008067          	ret

00000000000005c0 <open>:
.global open
open:
 li a7, SYS_open
 5c0:	00f00893          	li	a7,15
 ecall
 5c4:	00000073          	ecall
 ret
 5c8:	00008067          	ret

00000000000005cc <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5cc:	01100893          	li	a7,17
 ecall
 5d0:	00000073          	ecall
 ret
 5d4:	00008067          	ret

00000000000005d8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5d8:	01200893          	li	a7,18
 ecall
 5dc:	00000073          	ecall
 ret
 5e0:	00008067          	ret

00000000000005e4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5e4:	00800893          	li	a7,8
 ecall
 5e8:	00000073          	ecall
 ret
 5ec:	00008067          	ret

00000000000005f0 <link>:
.global link
link:
 li a7, SYS_link
 5f0:	01300893          	li	a7,19
 ecall
 5f4:	00000073          	ecall
 ret
 5f8:	00008067          	ret

00000000000005fc <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5fc:	01400893          	li	a7,20
 ecall
 600:	00000073          	ecall
 ret
 604:	00008067          	ret

0000000000000608 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 608:	00900893          	li	a7,9
 ecall
 60c:	00000073          	ecall
 ret
 610:	00008067          	ret

0000000000000614 <dup>:
.global dup
dup:
 li a7, SYS_dup
 614:	00a00893          	li	a7,10
 ecall
 618:	00000073          	ecall
 ret
 61c:	00008067          	ret

0000000000000620 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 620:	00b00893          	li	a7,11
 ecall
 624:	00000073          	ecall
 ret
 628:	00008067          	ret

000000000000062c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 62c:	00c00893          	li	a7,12
 ecall
 630:	00000073          	ecall
 ret
 634:	00008067          	ret

0000000000000638 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 638:	00d00893          	li	a7,13
 ecall
 63c:	00000073          	ecall
 ret
 640:	00008067          	ret

0000000000000644 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 644:	00e00893          	li	a7,14
 ecall
 648:	00000073          	ecall
 ret
 64c:	00008067          	ret
