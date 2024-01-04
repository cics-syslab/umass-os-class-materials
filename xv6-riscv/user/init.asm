
user/_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	fe010113          	add	sp,sp,-32
   4:	00113c23          	sd	ra,24(sp)
   8:	00813823          	sd	s0,16(sp)
   c:	00913423          	sd	s1,8(sp)
  10:	02010413          	add	s0,sp,32
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
  14:	00200593          	li	a1,2
  18:	00001517          	auipc	a0,0x1
  1c:	c0850513          	add	a0,a0,-1016 # c20 <malloc+0x148>
  20:	00000097          	auipc	ra,0x0
  24:	538080e7          	jalr	1336(ra) # 558 <open>
  28:	06054063          	bltz	a0,88 <main+0x88>
    mknod("console", CONSOLE, 0);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  2c:	00000513          	li	a0,0
  30:	00000097          	auipc	ra,0x0
  34:	57c080e7          	jalr	1404(ra) # 5ac <dup>
  dup(0);  // stderr
  38:	00000513          	li	a0,0
  3c:	00000097          	auipc	ra,0x0
  40:	570080e7          	jalr	1392(ra) # 5ac <dup>

  for(;;){
    pid = fork();
  44:	00000097          	auipc	ra,0x0
  48:	4a8080e7          	jalr	1192(ra) # 4ec <fork>
  4c:	00050493          	mv	s1,a0
    if(pid < 0){
  50:	06054463          	bltz	a0,b8 <main+0xb8>
      printf("init: fork failed\n");
      exit(1);
    }
    if(pid == 0){
  54:	08050063          	beqz	a0,d4 <main+0xd4>
    }

    for(;;){
      // this call to wait() returns if the shell exits,
      // or if a parentless process exits.
      wpid = wait((int *) 0);
  58:	00000513          	li	a0,0
  5c:	00000097          	auipc	ra,0x0
  60:	4a8080e7          	jalr	1192(ra) # 504 <wait>
      if(wpid == pid){
  64:	fea480e3          	beq	s1,a0,44 <main+0x44>
        // the shell exited; restart it.
        break;
      } else if(wpid < 0){
  68:	fe0558e3          	bgez	a0,58 <main+0x58>
        printf("init: wait returned an error\n");
  6c:	00001517          	auipc	a0,0x1
  70:	bf450513          	add	a0,a0,-1036 # c60 <malloc+0x188>
  74:	00001097          	auipc	ra,0x1
  78:	960080e7          	jalr	-1696(ra) # 9d4 <printf>
        exit(1);
  7c:	00100513          	li	a0,1
  80:	00000097          	auipc	ra,0x0
  84:	478080e7          	jalr	1144(ra) # 4f8 <exit>
    mknod("console", CONSOLE, 0);
  88:	00000613          	li	a2,0
  8c:	00100593          	li	a1,1
  90:	00001517          	auipc	a0,0x1
  94:	b9050513          	add	a0,a0,-1136 # c20 <malloc+0x148>
  98:	00000097          	auipc	ra,0x0
  9c:	4cc080e7          	jalr	1228(ra) # 564 <mknod>
    open("console", O_RDWR);
  a0:	00200593          	li	a1,2
  a4:	00001517          	auipc	a0,0x1
  a8:	b7c50513          	add	a0,a0,-1156 # c20 <malloc+0x148>
  ac:	00000097          	auipc	ra,0x0
  b0:	4ac080e7          	jalr	1196(ra) # 558 <open>
  b4:	f79ff06f          	j	2c <main+0x2c>
      printf("init: fork failed\n");
  b8:	00001517          	auipc	a0,0x1
  bc:	b7050513          	add	a0,a0,-1168 # c28 <malloc+0x150>
  c0:	00001097          	auipc	ra,0x1
  c4:	914080e7          	jalr	-1772(ra) # 9d4 <printf>
      exit(1);
  c8:	00100513          	li	a0,1
  cc:	00000097          	auipc	ra,0x0
  d0:	42c080e7          	jalr	1068(ra) # 4f8 <exit>
      exec("sh", argv);
  d4:	00001597          	auipc	a1,0x1
  d8:	f2c58593          	add	a1,a1,-212 # 1000 <argv>
  dc:	00001517          	auipc	a0,0x1
  e0:	b6450513          	add	a0,a0,-1180 # c40 <malloc+0x168>
  e4:	00000097          	auipc	ra,0x0
  e8:	468080e7          	jalr	1128(ra) # 54c <exec>
      printf("init: exec sh failed\n");
  ec:	00001517          	auipc	a0,0x1
  f0:	b5c50513          	add	a0,a0,-1188 # c48 <malloc+0x170>
  f4:	00001097          	auipc	ra,0x1
  f8:	8e0080e7          	jalr	-1824(ra) # 9d4 <printf>
      exit(1);
  fc:	00100513          	li	a0,1
 100:	00000097          	auipc	ra,0x0
 104:	3f8080e7          	jalr	1016(ra) # 4f8 <exit>

0000000000000108 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 108:	ff010113          	add	sp,sp,-16
 10c:	00113423          	sd	ra,8(sp)
 110:	00813023          	sd	s0,0(sp)
 114:	01010413          	add	s0,sp,16
  extern int main();
  main();
 118:	00000097          	auipc	ra,0x0
 11c:	ee8080e7          	jalr	-280(ra) # 0 <main>
  exit(0);
 120:	00000513          	li	a0,0
 124:	00000097          	auipc	ra,0x0
 128:	3d4080e7          	jalr	980(ra) # 4f8 <exit>

000000000000012c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 12c:	ff010113          	add	sp,sp,-16
 130:	00813423          	sd	s0,8(sp)
 134:	01010413          	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 138:	00050793          	mv	a5,a0
 13c:	00158593          	add	a1,a1,1
 140:	00178793          	add	a5,a5,1
 144:	fff5c703          	lbu	a4,-1(a1)
 148:	fee78fa3          	sb	a4,-1(a5)
 14c:	fe0718e3          	bnez	a4,13c <strcpy+0x10>
    ;
  return os;
}
 150:	00813403          	ld	s0,8(sp)
 154:	01010113          	add	sp,sp,16
 158:	00008067          	ret

000000000000015c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 15c:	ff010113          	add	sp,sp,-16
 160:	00813423          	sd	s0,8(sp)
 164:	01010413          	add	s0,sp,16
  while(*p && *p == *q)
 168:	00054783          	lbu	a5,0(a0)
 16c:	00078e63          	beqz	a5,188 <strcmp+0x2c>
 170:	0005c703          	lbu	a4,0(a1)
 174:	00f71a63          	bne	a4,a5,188 <strcmp+0x2c>
    p++, q++;
 178:	00150513          	add	a0,a0,1
 17c:	00158593          	add	a1,a1,1
  while(*p && *p == *q)
 180:	00054783          	lbu	a5,0(a0)
 184:	fe0796e3          	bnez	a5,170 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 188:	0005c503          	lbu	a0,0(a1)
}
 18c:	40a7853b          	subw	a0,a5,a0
 190:	00813403          	ld	s0,8(sp)
 194:	01010113          	add	sp,sp,16
 198:	00008067          	ret

000000000000019c <strlen>:

uint
strlen(const char *s)
{
 19c:	ff010113          	add	sp,sp,-16
 1a0:	00813423          	sd	s0,8(sp)
 1a4:	01010413          	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1a8:	00054783          	lbu	a5,0(a0)
 1ac:	02078863          	beqz	a5,1dc <strlen+0x40>
 1b0:	00150513          	add	a0,a0,1
 1b4:	00050793          	mv	a5,a0
 1b8:	00078693          	mv	a3,a5
 1bc:	00178793          	add	a5,a5,1
 1c0:	fff7c703          	lbu	a4,-1(a5)
 1c4:	fe071ae3          	bnez	a4,1b8 <strlen+0x1c>
 1c8:	40a6853b          	subw	a0,a3,a0
 1cc:	0015051b          	addw	a0,a0,1
    ;
  return n;
}
 1d0:	00813403          	ld	s0,8(sp)
 1d4:	01010113          	add	sp,sp,16
 1d8:	00008067          	ret
  for(n = 0; s[n]; n++)
 1dc:	00000513          	li	a0,0
 1e0:	ff1ff06f          	j	1d0 <strlen+0x34>

00000000000001e4 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1e4:	ff010113          	add	sp,sp,-16
 1e8:	00813423          	sd	s0,8(sp)
 1ec:	01010413          	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1f0:	02060063          	beqz	a2,210 <memset+0x2c>
 1f4:	00050793          	mv	a5,a0
 1f8:	02061613          	sll	a2,a2,0x20
 1fc:	02065613          	srl	a2,a2,0x20
 200:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 204:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 208:	00178793          	add	a5,a5,1
 20c:	fee79ce3          	bne	a5,a4,204 <memset+0x20>
  }
  return dst;
}
 210:	00813403          	ld	s0,8(sp)
 214:	01010113          	add	sp,sp,16
 218:	00008067          	ret

000000000000021c <strchr>:

char*
strchr(const char *s, char c)
{
 21c:	ff010113          	add	sp,sp,-16
 220:	00813423          	sd	s0,8(sp)
 224:	01010413          	add	s0,sp,16
  for(; *s; s++)
 228:	00054783          	lbu	a5,0(a0)
 22c:	02078263          	beqz	a5,250 <strchr+0x34>
    if(*s == c)
 230:	00f58a63          	beq	a1,a5,244 <strchr+0x28>
  for(; *s; s++)
 234:	00150513          	add	a0,a0,1
 238:	00054783          	lbu	a5,0(a0)
 23c:	fe079ae3          	bnez	a5,230 <strchr+0x14>
      return (char*)s;
  return 0;
 240:	00000513          	li	a0,0
}
 244:	00813403          	ld	s0,8(sp)
 248:	01010113          	add	sp,sp,16
 24c:	00008067          	ret
  return 0;
 250:	00000513          	li	a0,0
 254:	ff1ff06f          	j	244 <strchr+0x28>

0000000000000258 <gets>:

char*
gets(char *buf, int max)
{
 258:	fa010113          	add	sp,sp,-96
 25c:	04113c23          	sd	ra,88(sp)
 260:	04813823          	sd	s0,80(sp)
 264:	04913423          	sd	s1,72(sp)
 268:	05213023          	sd	s2,64(sp)
 26c:	03313c23          	sd	s3,56(sp)
 270:	03413823          	sd	s4,48(sp)
 274:	03513423          	sd	s5,40(sp)
 278:	03613023          	sd	s6,32(sp)
 27c:	01713c23          	sd	s7,24(sp)
 280:	06010413          	add	s0,sp,96
 284:	00050b93          	mv	s7,a0
 288:	00058a13          	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 28c:	00050913          	mv	s2,a0
 290:	00000493          	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 294:	00a00a93          	li	s5,10
 298:	00d00b13          	li	s6,13
  for(i=0; i+1 < max; ){
 29c:	00048993          	mv	s3,s1
 2a0:	0014849b          	addw	s1,s1,1
 2a4:	0344de63          	bge	s1,s4,2e0 <gets+0x88>
    cc = read(0, &c, 1);
 2a8:	00100613          	li	a2,1
 2ac:	faf40593          	add	a1,s0,-81
 2b0:	00000513          	li	a0,0
 2b4:	00000097          	auipc	ra,0x0
 2b8:	268080e7          	jalr	616(ra) # 51c <read>
    if(cc < 1)
 2bc:	02a05263          	blez	a0,2e0 <gets+0x88>
    buf[i++] = c;
 2c0:	faf44783          	lbu	a5,-81(s0)
 2c4:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2c8:	01578a63          	beq	a5,s5,2dc <gets+0x84>
 2cc:	00190913          	add	s2,s2,1
 2d0:	fd6796e3          	bne	a5,s6,29c <gets+0x44>
  for(i=0; i+1 < max; ){
 2d4:	00048993          	mv	s3,s1
 2d8:	0080006f          	j	2e0 <gets+0x88>
 2dc:	00048993          	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2e0:	013b89b3          	add	s3,s7,s3
 2e4:	00098023          	sb	zero,0(s3)
  return buf;
}
 2e8:	000b8513          	mv	a0,s7
 2ec:	05813083          	ld	ra,88(sp)
 2f0:	05013403          	ld	s0,80(sp)
 2f4:	04813483          	ld	s1,72(sp)
 2f8:	04013903          	ld	s2,64(sp)
 2fc:	03813983          	ld	s3,56(sp)
 300:	03013a03          	ld	s4,48(sp)
 304:	02813a83          	ld	s5,40(sp)
 308:	02013b03          	ld	s6,32(sp)
 30c:	01813b83          	ld	s7,24(sp)
 310:	06010113          	add	sp,sp,96
 314:	00008067          	ret

0000000000000318 <stat>:

int
stat(const char *n, struct stat *st)
{
 318:	fe010113          	add	sp,sp,-32
 31c:	00113c23          	sd	ra,24(sp)
 320:	00813823          	sd	s0,16(sp)
 324:	00913423          	sd	s1,8(sp)
 328:	01213023          	sd	s2,0(sp)
 32c:	02010413          	add	s0,sp,32
 330:	00058913          	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 334:	00000593          	li	a1,0
 338:	00000097          	auipc	ra,0x0
 33c:	220080e7          	jalr	544(ra) # 558 <open>
  if(fd < 0)
 340:	04054063          	bltz	a0,380 <stat+0x68>
 344:	00050493          	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 348:	00090593          	mv	a1,s2
 34c:	00000097          	auipc	ra,0x0
 350:	230080e7          	jalr	560(ra) # 57c <fstat>
 354:	00050913          	mv	s2,a0
  close(fd);
 358:	00048513          	mv	a0,s1
 35c:	00000097          	auipc	ra,0x0
 360:	1d8080e7          	jalr	472(ra) # 534 <close>
  return r;
}
 364:	00090513          	mv	a0,s2
 368:	01813083          	ld	ra,24(sp)
 36c:	01013403          	ld	s0,16(sp)
 370:	00813483          	ld	s1,8(sp)
 374:	00013903          	ld	s2,0(sp)
 378:	02010113          	add	sp,sp,32
 37c:	00008067          	ret
    return -1;
 380:	fff00913          	li	s2,-1
 384:	fe1ff06f          	j	364 <stat+0x4c>

0000000000000388 <atoi>:

int
atoi(const char *s)
{
 388:	ff010113          	add	sp,sp,-16
 38c:	00813423          	sd	s0,8(sp)
 390:	01010413          	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 394:	00054683          	lbu	a3,0(a0)
 398:	fd06879b          	addw	a5,a3,-48
 39c:	0ff7f793          	zext.b	a5,a5
 3a0:	00900613          	li	a2,9
 3a4:	04f66063          	bltu	a2,a5,3e4 <atoi+0x5c>
 3a8:	00050713          	mv	a4,a0
  n = 0;
 3ac:	00000513          	li	a0,0
    n = n*10 + *s++ - '0';
 3b0:	00170713          	add	a4,a4,1
 3b4:	0025179b          	sllw	a5,a0,0x2
 3b8:	00a787bb          	addw	a5,a5,a0
 3bc:	0017979b          	sllw	a5,a5,0x1
 3c0:	00d787bb          	addw	a5,a5,a3
 3c4:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3c8:	00074683          	lbu	a3,0(a4)
 3cc:	fd06879b          	addw	a5,a3,-48
 3d0:	0ff7f793          	zext.b	a5,a5
 3d4:	fcf67ee3          	bgeu	a2,a5,3b0 <atoi+0x28>
  return n;
}
 3d8:	00813403          	ld	s0,8(sp)
 3dc:	01010113          	add	sp,sp,16
 3e0:	00008067          	ret
  n = 0;
 3e4:	00000513          	li	a0,0
 3e8:	ff1ff06f          	j	3d8 <atoi+0x50>

00000000000003ec <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3ec:	ff010113          	add	sp,sp,-16
 3f0:	00813423          	sd	s0,8(sp)
 3f4:	01010413          	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3f8:	02b57c63          	bgeu	a0,a1,430 <memmove+0x44>
    while(n-- > 0)
 3fc:	02c05463          	blez	a2,424 <memmove+0x38>
 400:	02061613          	sll	a2,a2,0x20
 404:	02065613          	srl	a2,a2,0x20
 408:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 40c:	00050713          	mv	a4,a0
      *dst++ = *src++;
 410:	00158593          	add	a1,a1,1
 414:	00170713          	add	a4,a4,1
 418:	fff5c683          	lbu	a3,-1(a1)
 41c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 420:	fee798e3          	bne	a5,a4,410 <memmove+0x24>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 424:	00813403          	ld	s0,8(sp)
 428:	01010113          	add	sp,sp,16
 42c:	00008067          	ret
    dst += n;
 430:	00c50733          	add	a4,a0,a2
    src += n;
 434:	00c585b3          	add	a1,a1,a2
    while(n-- > 0)
 438:	fec056e3          	blez	a2,424 <memmove+0x38>
 43c:	fff6079b          	addw	a5,a2,-1
 440:	02079793          	sll	a5,a5,0x20
 444:	0207d793          	srl	a5,a5,0x20
 448:	fff7c793          	not	a5,a5
 44c:	00f707b3          	add	a5,a4,a5
      *--dst = *--src;
 450:	fff58593          	add	a1,a1,-1
 454:	fff70713          	add	a4,a4,-1
 458:	0005c683          	lbu	a3,0(a1)
 45c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 460:	fee798e3          	bne	a5,a4,450 <memmove+0x64>
 464:	fc1ff06f          	j	424 <memmove+0x38>

0000000000000468 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 468:	ff010113          	add	sp,sp,-16
 46c:	00813423          	sd	s0,8(sp)
 470:	01010413          	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 474:	04060463          	beqz	a2,4bc <memcmp+0x54>
 478:	fff6069b          	addw	a3,a2,-1
 47c:	02069693          	sll	a3,a3,0x20
 480:	0206d693          	srl	a3,a3,0x20
 484:	00168693          	add	a3,a3,1
 488:	00d506b3          	add	a3,a0,a3
    if (*p1 != *p2) {
 48c:	00054783          	lbu	a5,0(a0)
 490:	0005c703          	lbu	a4,0(a1)
 494:	00e79c63          	bne	a5,a4,4ac <memcmp+0x44>
      return *p1 - *p2;
    }
    p1++;
 498:	00150513          	add	a0,a0,1
    p2++;
 49c:	00158593          	add	a1,a1,1
  while (n-- > 0) {
 4a0:	fed516e3          	bne	a0,a3,48c <memcmp+0x24>
  }
  return 0;
 4a4:	00000513          	li	a0,0
 4a8:	0080006f          	j	4b0 <memcmp+0x48>
      return *p1 - *p2;
 4ac:	40e7853b          	subw	a0,a5,a4
}
 4b0:	00813403          	ld	s0,8(sp)
 4b4:	01010113          	add	sp,sp,16
 4b8:	00008067          	ret
  return 0;
 4bc:	00000513          	li	a0,0
 4c0:	ff1ff06f          	j	4b0 <memcmp+0x48>

00000000000004c4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4c4:	ff010113          	add	sp,sp,-16
 4c8:	00113423          	sd	ra,8(sp)
 4cc:	00813023          	sd	s0,0(sp)
 4d0:	01010413          	add	s0,sp,16
  return memmove(dst, src, n);
 4d4:	00000097          	auipc	ra,0x0
 4d8:	f18080e7          	jalr	-232(ra) # 3ec <memmove>
}
 4dc:	00813083          	ld	ra,8(sp)
 4e0:	00013403          	ld	s0,0(sp)
 4e4:	01010113          	add	sp,sp,16
 4e8:	00008067          	ret

00000000000004ec <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4ec:	00100893          	li	a7,1
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	00008067          	ret

00000000000004f8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4f8:	00200893          	li	a7,2
 ecall
 4fc:	00000073          	ecall
 ret
 500:	00008067          	ret

0000000000000504 <wait>:
.global wait
wait:
 li a7, SYS_wait
 504:	00300893          	li	a7,3
 ecall
 508:	00000073          	ecall
 ret
 50c:	00008067          	ret

0000000000000510 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 510:	00400893          	li	a7,4
 ecall
 514:	00000073          	ecall
 ret
 518:	00008067          	ret

000000000000051c <read>:
.global read
read:
 li a7, SYS_read
 51c:	00500893          	li	a7,5
 ecall
 520:	00000073          	ecall
 ret
 524:	00008067          	ret

0000000000000528 <write>:
.global write
write:
 li a7, SYS_write
 528:	01000893          	li	a7,16
 ecall
 52c:	00000073          	ecall
 ret
 530:	00008067          	ret

0000000000000534 <close>:
.global close
close:
 li a7, SYS_close
 534:	01500893          	li	a7,21
 ecall
 538:	00000073          	ecall
 ret
 53c:	00008067          	ret

0000000000000540 <kill>:
.global kill
kill:
 li a7, SYS_kill
 540:	00600893          	li	a7,6
 ecall
 544:	00000073          	ecall
 ret
 548:	00008067          	ret

000000000000054c <exec>:
.global exec
exec:
 li a7, SYS_exec
 54c:	00700893          	li	a7,7
 ecall
 550:	00000073          	ecall
 ret
 554:	00008067          	ret

0000000000000558 <open>:
.global open
open:
 li a7, SYS_open
 558:	00f00893          	li	a7,15
 ecall
 55c:	00000073          	ecall
 ret
 560:	00008067          	ret

0000000000000564 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 564:	01100893          	li	a7,17
 ecall
 568:	00000073          	ecall
 ret
 56c:	00008067          	ret

0000000000000570 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 570:	01200893          	li	a7,18
 ecall
 574:	00000073          	ecall
 ret
 578:	00008067          	ret

000000000000057c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 57c:	00800893          	li	a7,8
 ecall
 580:	00000073          	ecall
 ret
 584:	00008067          	ret

0000000000000588 <link>:
.global link
link:
 li a7, SYS_link
 588:	01300893          	li	a7,19
 ecall
 58c:	00000073          	ecall
 ret
 590:	00008067          	ret

0000000000000594 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 594:	01400893          	li	a7,20
 ecall
 598:	00000073          	ecall
 ret
 59c:	00008067          	ret

00000000000005a0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5a0:	00900893          	li	a7,9
 ecall
 5a4:	00000073          	ecall
 ret
 5a8:	00008067          	ret

00000000000005ac <dup>:
.global dup
dup:
 li a7, SYS_dup
 5ac:	00a00893          	li	a7,10
 ecall
 5b0:	00000073          	ecall
 ret
 5b4:	00008067          	ret

00000000000005b8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5b8:	00b00893          	li	a7,11
 ecall
 5bc:	00000073          	ecall
 ret
 5c0:	00008067          	ret

00000000000005c4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5c4:	00c00893          	li	a7,12
 ecall
 5c8:	00000073          	ecall
 ret
 5cc:	00008067          	ret

00000000000005d0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5d0:	00d00893          	li	a7,13
 ecall
 5d4:	00000073          	ecall
 ret
 5d8:	00008067          	ret

00000000000005dc <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5dc:	00e00893          	li	a7,14
 ecall
 5e0:	00000073          	ecall
 ret
 5e4:	00008067          	ret

00000000000005e8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5e8:	fe010113          	add	sp,sp,-32
 5ec:	00113c23          	sd	ra,24(sp)
 5f0:	00813823          	sd	s0,16(sp)
 5f4:	02010413          	add	s0,sp,32
 5f8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5fc:	00100613          	li	a2,1
 600:	fef40593          	add	a1,s0,-17
 604:	00000097          	auipc	ra,0x0
 608:	f24080e7          	jalr	-220(ra) # 528 <write>
}
 60c:	01813083          	ld	ra,24(sp)
 610:	01013403          	ld	s0,16(sp)
 614:	02010113          	add	sp,sp,32
 618:	00008067          	ret

000000000000061c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 61c:	fc010113          	add	sp,sp,-64
 620:	02113c23          	sd	ra,56(sp)
 624:	02813823          	sd	s0,48(sp)
 628:	02913423          	sd	s1,40(sp)
 62c:	03213023          	sd	s2,32(sp)
 630:	01313c23          	sd	s3,24(sp)
 634:	04010413          	add	s0,sp,64
 638:	00050493          	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 63c:	00068463          	beqz	a3,644 <printint+0x28>
 640:	0c05c063          	bltz	a1,700 <printint+0xe4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 644:	0005859b          	sext.w	a1,a1
  neg = 0;
 648:	00000893          	li	a7,0
 64c:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 650:	00000713          	li	a4,0
  do{
    buf[i++] = digits[x % base];
 654:	0006061b          	sext.w	a2,a2
 658:	00000517          	auipc	a0,0x0
 65c:	68850513          	add	a0,a0,1672 # ce0 <digits>
 660:	00070813          	mv	a6,a4
 664:	0017071b          	addw	a4,a4,1
 668:	02c5f7bb          	remuw	a5,a1,a2
 66c:	02079793          	sll	a5,a5,0x20
 670:	0207d793          	srl	a5,a5,0x20
 674:	00f507b3          	add	a5,a0,a5
 678:	0007c783          	lbu	a5,0(a5)
 67c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 680:	0005879b          	sext.w	a5,a1
 684:	02c5d5bb          	divuw	a1,a1,a2
 688:	00168693          	add	a3,a3,1
 68c:	fcc7fae3          	bgeu	a5,a2,660 <printint+0x44>
  if(neg)
 690:	00088c63          	beqz	a7,6a8 <printint+0x8c>
    buf[i++] = '-';
 694:	fd070793          	add	a5,a4,-48
 698:	00878733          	add	a4,a5,s0
 69c:	02d00793          	li	a5,45
 6a0:	fef70823          	sb	a5,-16(a4)
 6a4:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 6a8:	02e05e63          	blez	a4,6e4 <printint+0xc8>
 6ac:	fc040793          	add	a5,s0,-64
 6b0:	00e78933          	add	s2,a5,a4
 6b4:	fff78993          	add	s3,a5,-1
 6b8:	00e989b3          	add	s3,s3,a4
 6bc:	fff7071b          	addw	a4,a4,-1
 6c0:	02071713          	sll	a4,a4,0x20
 6c4:	02075713          	srl	a4,a4,0x20
 6c8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6cc:	fff94583          	lbu	a1,-1(s2)
 6d0:	00048513          	mv	a0,s1
 6d4:	00000097          	auipc	ra,0x0
 6d8:	f14080e7          	jalr	-236(ra) # 5e8 <putc>
  while(--i >= 0)
 6dc:	fff90913          	add	s2,s2,-1
 6e0:	ff3916e3          	bne	s2,s3,6cc <printint+0xb0>
}
 6e4:	03813083          	ld	ra,56(sp)
 6e8:	03013403          	ld	s0,48(sp)
 6ec:	02813483          	ld	s1,40(sp)
 6f0:	02013903          	ld	s2,32(sp)
 6f4:	01813983          	ld	s3,24(sp)
 6f8:	04010113          	add	sp,sp,64
 6fc:	00008067          	ret
    x = -xx;
 700:	40b005bb          	negw	a1,a1
    neg = 1;
 704:	00100893          	li	a7,1
    x = -xx;
 708:	f45ff06f          	j	64c <printint+0x30>

000000000000070c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 70c:	fb010113          	add	sp,sp,-80
 710:	04113423          	sd	ra,72(sp)
 714:	04813023          	sd	s0,64(sp)
 718:	02913c23          	sd	s1,56(sp)
 71c:	03213823          	sd	s2,48(sp)
 720:	03313423          	sd	s3,40(sp)
 724:	03413023          	sd	s4,32(sp)
 728:	01513c23          	sd	s5,24(sp)
 72c:	01613823          	sd	s6,16(sp)
 730:	01713423          	sd	s7,8(sp)
 734:	01813023          	sd	s8,0(sp)
 738:	05010413          	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 73c:	0005c903          	lbu	s2,0(a1)
 740:	20090e63          	beqz	s2,95c <vprintf+0x250>
 744:	00050a93          	mv	s5,a0
 748:	00060b93          	mv	s7,a2
 74c:	00158493          	add	s1,a1,1
  state = 0;
 750:	00000993          	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 754:	02500a13          	li	s4,37
 758:	01500b13          	li	s6,21
 75c:	0280006f          	j	784 <vprintf+0x78>
        putc(fd, c);
 760:	00090593          	mv	a1,s2
 764:	000a8513          	mv	a0,s5
 768:	00000097          	auipc	ra,0x0
 76c:	e80080e7          	jalr	-384(ra) # 5e8 <putc>
 770:	0080006f          	j	778 <vprintf+0x6c>
    } else if(state == '%'){
 774:	03498063          	beq	s3,s4,794 <vprintf+0x88>
  for(i = 0; fmt[i]; i++){
 778:	00148493          	add	s1,s1,1
 77c:	fff4c903          	lbu	s2,-1(s1)
 780:	1c090e63          	beqz	s2,95c <vprintf+0x250>
    if(state == 0){
 784:	fe0998e3          	bnez	s3,774 <vprintf+0x68>
      if(c == '%'){
 788:	fd491ce3          	bne	s2,s4,760 <vprintf+0x54>
        state = '%';
 78c:	000a0993          	mv	s3,s4
 790:	fe9ff06f          	j	778 <vprintf+0x6c>
      if(c == 'd'){
 794:	17490e63          	beq	s2,s4,910 <vprintf+0x204>
 798:	f9d9079b          	addw	a5,s2,-99
 79c:	0ff7f793          	zext.b	a5,a5
 7a0:	18fb6463          	bltu	s6,a5,928 <vprintf+0x21c>
 7a4:	f9d9079b          	addw	a5,s2,-99
 7a8:	0ff7f713          	zext.b	a4,a5
 7ac:	16eb6e63          	bltu	s6,a4,928 <vprintf+0x21c>
 7b0:	00271793          	sll	a5,a4,0x2
 7b4:	00000717          	auipc	a4,0x0
 7b8:	4d470713          	add	a4,a4,1236 # c88 <malloc+0x1b0>
 7bc:	00e787b3          	add	a5,a5,a4
 7c0:	0007a783          	lw	a5,0(a5)
 7c4:	00e787b3          	add	a5,a5,a4
 7c8:	00078067          	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 7cc:	008b8913          	add	s2,s7,8
 7d0:	00100693          	li	a3,1
 7d4:	00a00613          	li	a2,10
 7d8:	000ba583          	lw	a1,0(s7)
 7dc:	000a8513          	mv	a0,s5
 7e0:	00000097          	auipc	ra,0x0
 7e4:	e3c080e7          	jalr	-452(ra) # 61c <printint>
 7e8:	00090b93          	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 7ec:	00000993          	li	s3,0
 7f0:	f89ff06f          	j	778 <vprintf+0x6c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7f4:	008b8913          	add	s2,s7,8
 7f8:	00000693          	li	a3,0
 7fc:	00a00613          	li	a2,10
 800:	000ba583          	lw	a1,0(s7)
 804:	000a8513          	mv	a0,s5
 808:	00000097          	auipc	ra,0x0
 80c:	e14080e7          	jalr	-492(ra) # 61c <printint>
 810:	00090b93          	mv	s7,s2
      state = 0;
 814:	00000993          	li	s3,0
 818:	f61ff06f          	j	778 <vprintf+0x6c>
        printint(fd, va_arg(ap, int), 16, 0);
 81c:	008b8913          	add	s2,s7,8
 820:	00000693          	li	a3,0
 824:	01000613          	li	a2,16
 828:	000ba583          	lw	a1,0(s7)
 82c:	000a8513          	mv	a0,s5
 830:	00000097          	auipc	ra,0x0
 834:	dec080e7          	jalr	-532(ra) # 61c <printint>
 838:	00090b93          	mv	s7,s2
      state = 0;
 83c:	00000993          	li	s3,0
 840:	f39ff06f          	j	778 <vprintf+0x6c>
        printptr(fd, va_arg(ap, uint64));
 844:	008b8c13          	add	s8,s7,8
 848:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 84c:	03000593          	li	a1,48
 850:	000a8513          	mv	a0,s5
 854:	00000097          	auipc	ra,0x0
 858:	d94080e7          	jalr	-620(ra) # 5e8 <putc>
  putc(fd, 'x');
 85c:	07800593          	li	a1,120
 860:	000a8513          	mv	a0,s5
 864:	00000097          	auipc	ra,0x0
 868:	d84080e7          	jalr	-636(ra) # 5e8 <putc>
 86c:	01000913          	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 870:	00000b97          	auipc	s7,0x0
 874:	470b8b93          	add	s7,s7,1136 # ce0 <digits>
 878:	03c9d793          	srl	a5,s3,0x3c
 87c:	00fb87b3          	add	a5,s7,a5
 880:	0007c583          	lbu	a1,0(a5)
 884:	000a8513          	mv	a0,s5
 888:	00000097          	auipc	ra,0x0
 88c:	d60080e7          	jalr	-672(ra) # 5e8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 890:	00499993          	sll	s3,s3,0x4
 894:	fff9091b          	addw	s2,s2,-1
 898:	fe0910e3          	bnez	s2,878 <vprintf+0x16c>
        printptr(fd, va_arg(ap, uint64));
 89c:	000c0b93          	mv	s7,s8
      state = 0;
 8a0:	00000993          	li	s3,0
 8a4:	ed5ff06f          	j	778 <vprintf+0x6c>
        s = va_arg(ap, char*);
 8a8:	008b8993          	add	s3,s7,8
 8ac:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 8b0:	02090863          	beqz	s2,8e0 <vprintf+0x1d4>
        while(*s != 0){
 8b4:	00094583          	lbu	a1,0(s2)
 8b8:	08058c63          	beqz	a1,950 <vprintf+0x244>
          putc(fd, *s);
 8bc:	000a8513          	mv	a0,s5
 8c0:	00000097          	auipc	ra,0x0
 8c4:	d28080e7          	jalr	-728(ra) # 5e8 <putc>
          s++;
 8c8:	00190913          	add	s2,s2,1
        while(*s != 0){
 8cc:	00094583          	lbu	a1,0(s2)
 8d0:	fe0596e3          	bnez	a1,8bc <vprintf+0x1b0>
        s = va_arg(ap, char*);
 8d4:	00098b93          	mv	s7,s3
      state = 0;
 8d8:	00000993          	li	s3,0
 8dc:	e9dff06f          	j	778 <vprintf+0x6c>
          s = "(null)";
 8e0:	00000917          	auipc	s2,0x0
 8e4:	3a090913          	add	s2,s2,928 # c80 <malloc+0x1a8>
        while(*s != 0){
 8e8:	02800593          	li	a1,40
 8ec:	fd1ff06f          	j	8bc <vprintf+0x1b0>
        putc(fd, va_arg(ap, uint));
 8f0:	008b8913          	add	s2,s7,8
 8f4:	000bc583          	lbu	a1,0(s7)
 8f8:	000a8513          	mv	a0,s5
 8fc:	00000097          	auipc	ra,0x0
 900:	cec080e7          	jalr	-788(ra) # 5e8 <putc>
 904:	00090b93          	mv	s7,s2
      state = 0;
 908:	00000993          	li	s3,0
 90c:	e6dff06f          	j	778 <vprintf+0x6c>
        putc(fd, c);
 910:	02500593          	li	a1,37
 914:	000a8513          	mv	a0,s5
 918:	00000097          	auipc	ra,0x0
 91c:	cd0080e7          	jalr	-816(ra) # 5e8 <putc>
      state = 0;
 920:	00000993          	li	s3,0
 924:	e55ff06f          	j	778 <vprintf+0x6c>
        putc(fd, '%');
 928:	02500593          	li	a1,37
 92c:	000a8513          	mv	a0,s5
 930:	00000097          	auipc	ra,0x0
 934:	cb8080e7          	jalr	-840(ra) # 5e8 <putc>
        putc(fd, c);
 938:	00090593          	mv	a1,s2
 93c:	000a8513          	mv	a0,s5
 940:	00000097          	auipc	ra,0x0
 944:	ca8080e7          	jalr	-856(ra) # 5e8 <putc>
      state = 0;
 948:	00000993          	li	s3,0
 94c:	e2dff06f          	j	778 <vprintf+0x6c>
        s = va_arg(ap, char*);
 950:	00098b93          	mv	s7,s3
      state = 0;
 954:	00000993          	li	s3,0
 958:	e21ff06f          	j	778 <vprintf+0x6c>
    }
  }
}
 95c:	04813083          	ld	ra,72(sp)
 960:	04013403          	ld	s0,64(sp)
 964:	03813483          	ld	s1,56(sp)
 968:	03013903          	ld	s2,48(sp)
 96c:	02813983          	ld	s3,40(sp)
 970:	02013a03          	ld	s4,32(sp)
 974:	01813a83          	ld	s5,24(sp)
 978:	01013b03          	ld	s6,16(sp)
 97c:	00813b83          	ld	s7,8(sp)
 980:	00013c03          	ld	s8,0(sp)
 984:	05010113          	add	sp,sp,80
 988:	00008067          	ret

000000000000098c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 98c:	fb010113          	add	sp,sp,-80
 990:	00113c23          	sd	ra,24(sp)
 994:	00813823          	sd	s0,16(sp)
 998:	02010413          	add	s0,sp,32
 99c:	00c43023          	sd	a2,0(s0)
 9a0:	00d43423          	sd	a3,8(s0)
 9a4:	00e43823          	sd	a4,16(s0)
 9a8:	00f43c23          	sd	a5,24(s0)
 9ac:	03043023          	sd	a6,32(s0)
 9b0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 9b4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 9b8:	00040613          	mv	a2,s0
 9bc:	00000097          	auipc	ra,0x0
 9c0:	d50080e7          	jalr	-688(ra) # 70c <vprintf>
}
 9c4:	01813083          	ld	ra,24(sp)
 9c8:	01013403          	ld	s0,16(sp)
 9cc:	05010113          	add	sp,sp,80
 9d0:	00008067          	ret

00000000000009d4 <printf>:

void
printf(const char *fmt, ...)
{
 9d4:	fa010113          	add	sp,sp,-96
 9d8:	00113c23          	sd	ra,24(sp)
 9dc:	00813823          	sd	s0,16(sp)
 9e0:	02010413          	add	s0,sp,32
 9e4:	00b43423          	sd	a1,8(s0)
 9e8:	00c43823          	sd	a2,16(s0)
 9ec:	00d43c23          	sd	a3,24(s0)
 9f0:	02e43023          	sd	a4,32(s0)
 9f4:	02f43423          	sd	a5,40(s0)
 9f8:	03043823          	sd	a6,48(s0)
 9fc:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a00:	00840613          	add	a2,s0,8
 a04:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a08:	00050593          	mv	a1,a0
 a0c:	00100513          	li	a0,1
 a10:	00000097          	auipc	ra,0x0
 a14:	cfc080e7          	jalr	-772(ra) # 70c <vprintf>
}
 a18:	01813083          	ld	ra,24(sp)
 a1c:	01013403          	ld	s0,16(sp)
 a20:	06010113          	add	sp,sp,96
 a24:	00008067          	ret

0000000000000a28 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a28:	ff010113          	add	sp,sp,-16
 a2c:	00813423          	sd	s0,8(sp)
 a30:	01010413          	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a34:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a38:	00000797          	auipc	a5,0x0
 a3c:	5d87b783          	ld	a5,1496(a5) # 1010 <freep>
 a40:	0400006f          	j	a80 <free+0x58>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 a44:	00862703          	lw	a4,8(a2)
 a48:	00b7073b          	addw	a4,a4,a1
 a4c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a50:	0007b703          	ld	a4,0(a5)
 a54:	00073603          	ld	a2,0(a4)
 a58:	0500006f          	j	aa8 <free+0x80>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 a5c:	ff852703          	lw	a4,-8(a0)
 a60:	00c7073b          	addw	a4,a4,a2
 a64:	00e7a423          	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 a68:	ff053683          	ld	a3,-16(a0)
 a6c:	0540006f          	j	ac0 <free+0x98>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a70:	0007b703          	ld	a4,0(a5)
 a74:	00e7e463          	bltu	a5,a4,a7c <free+0x54>
 a78:	00e6ec63          	bltu	a3,a4,a90 <free+0x68>
{
 a7c:	00070793          	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a80:	fed7f8e3          	bgeu	a5,a3,a70 <free+0x48>
 a84:	0007b703          	ld	a4,0(a5)
 a88:	00e6e463          	bltu	a3,a4,a90 <free+0x68>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a8c:	fee7e8e3          	bltu	a5,a4,a7c <free+0x54>
  if(bp + bp->s.size == p->s.ptr){
 a90:	ff852583          	lw	a1,-8(a0)
 a94:	0007b603          	ld	a2,0(a5)
 a98:	02059813          	sll	a6,a1,0x20
 a9c:	01c85713          	srl	a4,a6,0x1c
 aa0:	00e68733          	add	a4,a3,a4
 aa4:	fae600e3          	beq	a2,a4,a44 <free+0x1c>
    bp->s.ptr = p->s.ptr->s.ptr;
 aa8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 aac:	0087a603          	lw	a2,8(a5)
 ab0:	02061593          	sll	a1,a2,0x20
 ab4:	01c5d713          	srl	a4,a1,0x1c
 ab8:	00e78733          	add	a4,a5,a4
 abc:	fae680e3          	beq	a3,a4,a5c <free+0x34>
    p->s.ptr = bp->s.ptr;
 ac0:	00d7b023          	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 ac4:	00000717          	auipc	a4,0x0
 ac8:	54f73623          	sd	a5,1356(a4) # 1010 <freep>
}
 acc:	00813403          	ld	s0,8(sp)
 ad0:	01010113          	add	sp,sp,16
 ad4:	00008067          	ret

0000000000000ad8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 ad8:	fc010113          	add	sp,sp,-64
 adc:	02113c23          	sd	ra,56(sp)
 ae0:	02813823          	sd	s0,48(sp)
 ae4:	02913423          	sd	s1,40(sp)
 ae8:	03213023          	sd	s2,32(sp)
 aec:	01313c23          	sd	s3,24(sp)
 af0:	01413823          	sd	s4,16(sp)
 af4:	01513423          	sd	s5,8(sp)
 af8:	01613023          	sd	s6,0(sp)
 afc:	04010413          	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b00:	02051493          	sll	s1,a0,0x20
 b04:	0204d493          	srl	s1,s1,0x20
 b08:	00f48493          	add	s1,s1,15
 b0c:	0044d493          	srl	s1,s1,0x4
 b10:	0014899b          	addw	s3,s1,1
 b14:	00148493          	add	s1,s1,1
  if((prevp = freep) == 0){
 b18:	00000517          	auipc	a0,0x0
 b1c:	4f853503          	ld	a0,1272(a0) # 1010 <freep>
 b20:	02050e63          	beqz	a0,b5c <malloc+0x84>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b24:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b28:	0087a703          	lw	a4,8(a5)
 b2c:	04977663          	bgeu	a4,s1,b78 <malloc+0xa0>
  if(nu < 4096)
 b30:	00098a13          	mv	s4,s3
 b34:	0009871b          	sext.w	a4,s3
 b38:	000016b7          	lui	a3,0x1
 b3c:	00d77463          	bgeu	a4,a3,b44 <malloc+0x6c>
 b40:	00001a37          	lui	s4,0x1
 b44:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 b48:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 b4c:	00000917          	auipc	s2,0x0
 b50:	4c490913          	add	s2,s2,1220 # 1010 <freep>
  if(p == (char*)-1)
 b54:	fff00a93          	li	s5,-1
 b58:	0a00006f          	j	bf8 <malloc+0x120>
    base.s.ptr = freep = prevp = &base;
 b5c:	00000797          	auipc	a5,0x0
 b60:	4c478793          	add	a5,a5,1220 # 1020 <base>
 b64:	00000717          	auipc	a4,0x0
 b68:	4af73623          	sd	a5,1196(a4) # 1010 <freep>
 b6c:	00f7b023          	sd	a5,0(a5)
    base.s.size = 0;
 b70:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 b74:	fbdff06f          	j	b30 <malloc+0x58>
      if(p->s.size == nunits)
 b78:	04e48863          	beq	s1,a4,bc8 <malloc+0xf0>
        p->s.size -= nunits;
 b7c:	4137073b          	subw	a4,a4,s3
 b80:	00e7a423          	sw	a4,8(a5)
        p += p->s.size;
 b84:	02071693          	sll	a3,a4,0x20
 b88:	01c6d713          	srl	a4,a3,0x1c
 b8c:	00e787b3          	add	a5,a5,a4
        p->s.size = nunits;
 b90:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b94:	00000717          	auipc	a4,0x0
 b98:	46a73e23          	sd	a0,1148(a4) # 1010 <freep>
      return (void*)(p + 1);
 b9c:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 ba0:	03813083          	ld	ra,56(sp)
 ba4:	03013403          	ld	s0,48(sp)
 ba8:	02813483          	ld	s1,40(sp)
 bac:	02013903          	ld	s2,32(sp)
 bb0:	01813983          	ld	s3,24(sp)
 bb4:	01013a03          	ld	s4,16(sp)
 bb8:	00813a83          	ld	s5,8(sp)
 bbc:	00013b03          	ld	s6,0(sp)
 bc0:	04010113          	add	sp,sp,64
 bc4:	00008067          	ret
        prevp->s.ptr = p->s.ptr;
 bc8:	0007b703          	ld	a4,0(a5)
 bcc:	00e53023          	sd	a4,0(a0)
 bd0:	fc5ff06f          	j	b94 <malloc+0xbc>
  hp->s.size = nu;
 bd4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 bd8:	01050513          	add	a0,a0,16
 bdc:	00000097          	auipc	ra,0x0
 be0:	e4c080e7          	jalr	-436(ra) # a28 <free>
  return freep;
 be4:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 be8:	fa050ce3          	beqz	a0,ba0 <malloc+0xc8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bec:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
 bf0:	0087a703          	lw	a4,8(a5)
 bf4:	f89772e3          	bgeu	a4,s1,b78 <malloc+0xa0>
    if(p == freep)
 bf8:	00093703          	ld	a4,0(s2)
 bfc:	00078513          	mv	a0,a5
 c00:	fef716e3          	bne	a4,a5,bec <malloc+0x114>
  p = sbrk(nu * sizeof(Header));
 c04:	000a0513          	mv	a0,s4
 c08:	00000097          	auipc	ra,0x0
 c0c:	9bc080e7          	jalr	-1604(ra) # 5c4 <sbrk>
  if(p == (char*)-1)
 c10:	fd5512e3          	bne	a0,s5,bd4 <malloc+0xfc>
        return 0;
 c14:	00000513          	li	a0,0
 c18:	f89ff06f          	j	ba0 <malloc+0xc8>
