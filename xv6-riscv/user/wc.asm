
user/_wc:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	f8010113          	add	sp,sp,-128
   4:	06113c23          	sd	ra,120(sp)
   8:	06813823          	sd	s0,112(sp)
   c:	06913423          	sd	s1,104(sp)
  10:	07213023          	sd	s2,96(sp)
  14:	05313c23          	sd	s3,88(sp)
  18:	05413823          	sd	s4,80(sp)
  1c:	05513423          	sd	s5,72(sp)
  20:	05613023          	sd	s6,64(sp)
  24:	03713c23          	sd	s7,56(sp)
  28:	03813823          	sd	s8,48(sp)
  2c:	03913423          	sd	s9,40(sp)
  30:	03a13023          	sd	s10,32(sp)
  34:	01b13c23          	sd	s11,24(sp)
  38:	08010413          	add	s0,sp,128
  3c:	f8a43423          	sd	a0,-120(s0)
  40:	f8b43023          	sd	a1,-128(s0)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  44:	00000913          	li	s2,0
  l = w = c = 0;
  48:	00000d13          	li	s10,0
  4c:	00000c93          	li	s9,0
  50:	00000c13          	li	s8,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  54:	00001d97          	auipc	s11,0x1
  58:	fbcd8d93          	add	s11,s11,-68 # 1010 <buf>
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
  5c:	00a00a93          	li	s5,10
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  60:	00001a17          	auipc	s4,0x1
  64:	cd0a0a13          	add	s4,s4,-816 # d30 <malloc+0x148>
        inword = 0;
  68:	00000b93          	li	s7,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  6c:	0440006f          	j	b0 <wc+0xb0>
      if(strchr(" \r\t\n\v", buf[i]))
  70:	000a0513          	mv	a0,s4
  74:	00000097          	auipc	ra,0x0
  78:	2b8080e7          	jalr	696(ra) # 32c <strchr>
  7c:	02050063          	beqz	a0,9c <wc+0x9c>
        inword = 0;
  80:	000b8913          	mv	s2,s7
    for(i=0; i<n; i++){
  84:	00148493          	add	s1,s1,1
  88:	02998263          	beq	s3,s1,ac <wc+0xac>
      if(buf[i] == '\n')
  8c:	0004c583          	lbu	a1,0(s1)
  90:	ff5590e3          	bne	a1,s5,70 <wc+0x70>
        l++;
  94:	001c0c1b          	addw	s8,s8,1
  98:	fd9ff06f          	j	70 <wc+0x70>
      else if(!inword){
  9c:	fe0914e3          	bnez	s2,84 <wc+0x84>
        w++;
  a0:	001c8c9b          	addw	s9,s9,1
        inword = 1;
  a4:	00100913          	li	s2,1
  a8:	fddff06f          	j	84 <wc+0x84>
      c++;
  ac:	01ab0d3b          	addw	s10,s6,s10
  while((n = read(fd, buf, sizeof(buf))) > 0){
  b0:	20000613          	li	a2,512
  b4:	000d8593          	mv	a1,s11
  b8:	f8843503          	ld	a0,-120(s0)
  bc:	00000097          	auipc	ra,0x0
  c0:	570080e7          	jalr	1392(ra) # 62c <read>
  c4:	00050b13          	mv	s6,a0
  c8:	00a05a63          	blez	a0,dc <wc+0xdc>
    for(i=0; i<n; i++){
  cc:	00001497          	auipc	s1,0x1
  d0:	f4448493          	add	s1,s1,-188 # 1010 <buf>
  d4:	009509b3          	add	s3,a0,s1
  d8:	fb5ff06f          	j	8c <wc+0x8c>
      }
    }
  }
  if(n < 0){
  dc:	06054063          	bltz	a0,13c <wc+0x13c>
    printf("wc: read error\n");
    exit(1);
  }
  printf("%d %d %d %s\n", l, w, c, name);
  e0:	f8043703          	ld	a4,-128(s0)
  e4:	000d0693          	mv	a3,s10
  e8:	000c8613          	mv	a2,s9
  ec:	000c0593          	mv	a1,s8
  f0:	00001517          	auipc	a0,0x1
  f4:	c5850513          	add	a0,a0,-936 # d48 <malloc+0x160>
  f8:	00001097          	auipc	ra,0x1
  fc:	9ec080e7          	jalr	-1556(ra) # ae4 <printf>
}
 100:	07813083          	ld	ra,120(sp)
 104:	07013403          	ld	s0,112(sp)
 108:	06813483          	ld	s1,104(sp)
 10c:	06013903          	ld	s2,96(sp)
 110:	05813983          	ld	s3,88(sp)
 114:	05013a03          	ld	s4,80(sp)
 118:	04813a83          	ld	s5,72(sp)
 11c:	04013b03          	ld	s6,64(sp)
 120:	03813b83          	ld	s7,56(sp)
 124:	03013c03          	ld	s8,48(sp)
 128:	02813c83          	ld	s9,40(sp)
 12c:	02013d03          	ld	s10,32(sp)
 130:	01813d83          	ld	s11,24(sp)
 134:	08010113          	add	sp,sp,128
 138:	00008067          	ret
    printf("wc: read error\n");
 13c:	00001517          	auipc	a0,0x1
 140:	bfc50513          	add	a0,a0,-1028 # d38 <malloc+0x150>
 144:	00001097          	auipc	ra,0x1
 148:	9a0080e7          	jalr	-1632(ra) # ae4 <printf>
    exit(1);
 14c:	00100513          	li	a0,1
 150:	00000097          	auipc	ra,0x0
 154:	4b8080e7          	jalr	1208(ra) # 608 <exit>

0000000000000158 <main>:

int
main(int argc, char *argv[])
{
 158:	fd010113          	add	sp,sp,-48
 15c:	02113423          	sd	ra,40(sp)
 160:	02813023          	sd	s0,32(sp)
 164:	00913c23          	sd	s1,24(sp)
 168:	01213823          	sd	s2,16(sp)
 16c:	01313423          	sd	s3,8(sp)
 170:	03010413          	add	s0,sp,48
  int fd, i;

  if(argc <= 1){
 174:	00100793          	li	a5,1
 178:	06a7d063          	bge	a5,a0,1d8 <main+0x80>
 17c:	00858913          	add	s2,a1,8
 180:	ffe5099b          	addw	s3,a0,-2
 184:	02099793          	sll	a5,s3,0x20
 188:	01d7d993          	srl	s3,a5,0x1d
 18c:	01058593          	add	a1,a1,16
 190:	00b989b3          	add	s3,s3,a1
    wc(0, "");
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
 194:	00000593          	li	a1,0
 198:	00093503          	ld	a0,0(s2)
 19c:	00000097          	auipc	ra,0x0
 1a0:	4cc080e7          	jalr	1228(ra) # 668 <open>
 1a4:	00050493          	mv	s1,a0
 1a8:	04054863          	bltz	a0,1f8 <main+0xa0>
      printf("wc: cannot open %s\n", argv[i]);
      exit(1);
    }
    wc(fd, argv[i]);
 1ac:	00093583          	ld	a1,0(s2)
 1b0:	00000097          	auipc	ra,0x0
 1b4:	e50080e7          	jalr	-432(ra) # 0 <wc>
    close(fd);
 1b8:	00048513          	mv	a0,s1
 1bc:	00000097          	auipc	ra,0x0
 1c0:	488080e7          	jalr	1160(ra) # 644 <close>
  for(i = 1; i < argc; i++){
 1c4:	00890913          	add	s2,s2,8
 1c8:	fd3916e3          	bne	s2,s3,194 <main+0x3c>
  }
  exit(0);
 1cc:	00000513          	li	a0,0
 1d0:	00000097          	auipc	ra,0x0
 1d4:	438080e7          	jalr	1080(ra) # 608 <exit>
    wc(0, "");
 1d8:	00001597          	auipc	a1,0x1
 1dc:	b8058593          	add	a1,a1,-1152 # d58 <malloc+0x170>
 1e0:	00000513          	li	a0,0
 1e4:	00000097          	auipc	ra,0x0
 1e8:	e1c080e7          	jalr	-484(ra) # 0 <wc>
    exit(0);
 1ec:	00000513          	li	a0,0
 1f0:	00000097          	auipc	ra,0x0
 1f4:	418080e7          	jalr	1048(ra) # 608 <exit>
      printf("wc: cannot open %s\n", argv[i]);
 1f8:	00093583          	ld	a1,0(s2)
 1fc:	00001517          	auipc	a0,0x1
 200:	b6450513          	add	a0,a0,-1180 # d60 <malloc+0x178>
 204:	00001097          	auipc	ra,0x1
 208:	8e0080e7          	jalr	-1824(ra) # ae4 <printf>
      exit(1);
 20c:	00100513          	li	a0,1
 210:	00000097          	auipc	ra,0x0
 214:	3f8080e7          	jalr	1016(ra) # 608 <exit>

0000000000000218 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 218:	ff010113          	add	sp,sp,-16
 21c:	00113423          	sd	ra,8(sp)
 220:	00813023          	sd	s0,0(sp)
 224:	01010413          	add	s0,sp,16
  extern int main();
  main();
 228:	00000097          	auipc	ra,0x0
 22c:	f30080e7          	jalr	-208(ra) # 158 <main>
  exit(0);
 230:	00000513          	li	a0,0
 234:	00000097          	auipc	ra,0x0
 238:	3d4080e7          	jalr	980(ra) # 608 <exit>

000000000000023c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 23c:	ff010113          	add	sp,sp,-16
 240:	00813423          	sd	s0,8(sp)
 244:	01010413          	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 248:	00050793          	mv	a5,a0
 24c:	00158593          	add	a1,a1,1
 250:	00178793          	add	a5,a5,1
 254:	fff5c703          	lbu	a4,-1(a1)
 258:	fee78fa3          	sb	a4,-1(a5)
 25c:	fe0718e3          	bnez	a4,24c <strcpy+0x10>
    ;
  return os;
}
 260:	00813403          	ld	s0,8(sp)
 264:	01010113          	add	sp,sp,16
 268:	00008067          	ret

000000000000026c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 26c:	ff010113          	add	sp,sp,-16
 270:	00813423          	sd	s0,8(sp)
 274:	01010413          	add	s0,sp,16
  while(*p && *p == *q)
 278:	00054783          	lbu	a5,0(a0)
 27c:	00078e63          	beqz	a5,298 <strcmp+0x2c>
 280:	0005c703          	lbu	a4,0(a1)
 284:	00f71a63          	bne	a4,a5,298 <strcmp+0x2c>
    p++, q++;
 288:	00150513          	add	a0,a0,1
 28c:	00158593          	add	a1,a1,1
  while(*p && *p == *q)
 290:	00054783          	lbu	a5,0(a0)
 294:	fe0796e3          	bnez	a5,280 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 298:	0005c503          	lbu	a0,0(a1)
}
 29c:	40a7853b          	subw	a0,a5,a0
 2a0:	00813403          	ld	s0,8(sp)
 2a4:	01010113          	add	sp,sp,16
 2a8:	00008067          	ret

00000000000002ac <strlen>:

uint
strlen(const char *s)
{
 2ac:	ff010113          	add	sp,sp,-16
 2b0:	00813423          	sd	s0,8(sp)
 2b4:	01010413          	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2b8:	00054783          	lbu	a5,0(a0)
 2bc:	02078863          	beqz	a5,2ec <strlen+0x40>
 2c0:	00150513          	add	a0,a0,1
 2c4:	00050793          	mv	a5,a0
 2c8:	00078693          	mv	a3,a5
 2cc:	00178793          	add	a5,a5,1
 2d0:	fff7c703          	lbu	a4,-1(a5)
 2d4:	fe071ae3          	bnez	a4,2c8 <strlen+0x1c>
 2d8:	40a6853b          	subw	a0,a3,a0
 2dc:	0015051b          	addw	a0,a0,1
    ;
  return n;
}
 2e0:	00813403          	ld	s0,8(sp)
 2e4:	01010113          	add	sp,sp,16
 2e8:	00008067          	ret
  for(n = 0; s[n]; n++)
 2ec:	00000513          	li	a0,0
 2f0:	ff1ff06f          	j	2e0 <strlen+0x34>

00000000000002f4 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2f4:	ff010113          	add	sp,sp,-16
 2f8:	00813423          	sd	s0,8(sp)
 2fc:	01010413          	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 300:	02060063          	beqz	a2,320 <memset+0x2c>
 304:	00050793          	mv	a5,a0
 308:	02061613          	sll	a2,a2,0x20
 30c:	02065613          	srl	a2,a2,0x20
 310:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 314:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 318:	00178793          	add	a5,a5,1
 31c:	fee79ce3          	bne	a5,a4,314 <memset+0x20>
  }
  return dst;
}
 320:	00813403          	ld	s0,8(sp)
 324:	01010113          	add	sp,sp,16
 328:	00008067          	ret

000000000000032c <strchr>:

char*
strchr(const char *s, char c)
{
 32c:	ff010113          	add	sp,sp,-16
 330:	00813423          	sd	s0,8(sp)
 334:	01010413          	add	s0,sp,16
  for(; *s; s++)
 338:	00054783          	lbu	a5,0(a0)
 33c:	02078263          	beqz	a5,360 <strchr+0x34>
    if(*s == c)
 340:	00f58a63          	beq	a1,a5,354 <strchr+0x28>
  for(; *s; s++)
 344:	00150513          	add	a0,a0,1
 348:	00054783          	lbu	a5,0(a0)
 34c:	fe079ae3          	bnez	a5,340 <strchr+0x14>
      return (char*)s;
  return 0;
 350:	00000513          	li	a0,0
}
 354:	00813403          	ld	s0,8(sp)
 358:	01010113          	add	sp,sp,16
 35c:	00008067          	ret
  return 0;
 360:	00000513          	li	a0,0
 364:	ff1ff06f          	j	354 <strchr+0x28>

0000000000000368 <gets>:

char*
gets(char *buf, int max)
{
 368:	fa010113          	add	sp,sp,-96
 36c:	04113c23          	sd	ra,88(sp)
 370:	04813823          	sd	s0,80(sp)
 374:	04913423          	sd	s1,72(sp)
 378:	05213023          	sd	s2,64(sp)
 37c:	03313c23          	sd	s3,56(sp)
 380:	03413823          	sd	s4,48(sp)
 384:	03513423          	sd	s5,40(sp)
 388:	03613023          	sd	s6,32(sp)
 38c:	01713c23          	sd	s7,24(sp)
 390:	06010413          	add	s0,sp,96
 394:	00050b93          	mv	s7,a0
 398:	00058a13          	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 39c:	00050913          	mv	s2,a0
 3a0:	00000493          	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3a4:	00a00a93          	li	s5,10
 3a8:	00d00b13          	li	s6,13
  for(i=0; i+1 < max; ){
 3ac:	00048993          	mv	s3,s1
 3b0:	0014849b          	addw	s1,s1,1
 3b4:	0344de63          	bge	s1,s4,3f0 <gets+0x88>
    cc = read(0, &c, 1);
 3b8:	00100613          	li	a2,1
 3bc:	faf40593          	add	a1,s0,-81
 3c0:	00000513          	li	a0,0
 3c4:	00000097          	auipc	ra,0x0
 3c8:	268080e7          	jalr	616(ra) # 62c <read>
    if(cc < 1)
 3cc:	02a05263          	blez	a0,3f0 <gets+0x88>
    buf[i++] = c;
 3d0:	faf44783          	lbu	a5,-81(s0)
 3d4:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3d8:	01578a63          	beq	a5,s5,3ec <gets+0x84>
 3dc:	00190913          	add	s2,s2,1
 3e0:	fd6796e3          	bne	a5,s6,3ac <gets+0x44>
  for(i=0; i+1 < max; ){
 3e4:	00048993          	mv	s3,s1
 3e8:	0080006f          	j	3f0 <gets+0x88>
 3ec:	00048993          	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3f0:	013b89b3          	add	s3,s7,s3
 3f4:	00098023          	sb	zero,0(s3)
  return buf;
}
 3f8:	000b8513          	mv	a0,s7
 3fc:	05813083          	ld	ra,88(sp)
 400:	05013403          	ld	s0,80(sp)
 404:	04813483          	ld	s1,72(sp)
 408:	04013903          	ld	s2,64(sp)
 40c:	03813983          	ld	s3,56(sp)
 410:	03013a03          	ld	s4,48(sp)
 414:	02813a83          	ld	s5,40(sp)
 418:	02013b03          	ld	s6,32(sp)
 41c:	01813b83          	ld	s7,24(sp)
 420:	06010113          	add	sp,sp,96
 424:	00008067          	ret

0000000000000428 <stat>:

int
stat(const char *n, struct stat *st)
{
 428:	fe010113          	add	sp,sp,-32
 42c:	00113c23          	sd	ra,24(sp)
 430:	00813823          	sd	s0,16(sp)
 434:	00913423          	sd	s1,8(sp)
 438:	01213023          	sd	s2,0(sp)
 43c:	02010413          	add	s0,sp,32
 440:	00058913          	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 444:	00000593          	li	a1,0
 448:	00000097          	auipc	ra,0x0
 44c:	220080e7          	jalr	544(ra) # 668 <open>
  if(fd < 0)
 450:	04054063          	bltz	a0,490 <stat+0x68>
 454:	00050493          	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 458:	00090593          	mv	a1,s2
 45c:	00000097          	auipc	ra,0x0
 460:	230080e7          	jalr	560(ra) # 68c <fstat>
 464:	00050913          	mv	s2,a0
  close(fd);
 468:	00048513          	mv	a0,s1
 46c:	00000097          	auipc	ra,0x0
 470:	1d8080e7          	jalr	472(ra) # 644 <close>
  return r;
}
 474:	00090513          	mv	a0,s2
 478:	01813083          	ld	ra,24(sp)
 47c:	01013403          	ld	s0,16(sp)
 480:	00813483          	ld	s1,8(sp)
 484:	00013903          	ld	s2,0(sp)
 488:	02010113          	add	sp,sp,32
 48c:	00008067          	ret
    return -1;
 490:	fff00913          	li	s2,-1
 494:	fe1ff06f          	j	474 <stat+0x4c>

0000000000000498 <atoi>:

int
atoi(const char *s)
{
 498:	ff010113          	add	sp,sp,-16
 49c:	00813423          	sd	s0,8(sp)
 4a0:	01010413          	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 4a4:	00054683          	lbu	a3,0(a0)
 4a8:	fd06879b          	addw	a5,a3,-48
 4ac:	0ff7f793          	zext.b	a5,a5
 4b0:	00900613          	li	a2,9
 4b4:	04f66063          	bltu	a2,a5,4f4 <atoi+0x5c>
 4b8:	00050713          	mv	a4,a0
  n = 0;
 4bc:	00000513          	li	a0,0
    n = n*10 + *s++ - '0';
 4c0:	00170713          	add	a4,a4,1
 4c4:	0025179b          	sllw	a5,a0,0x2
 4c8:	00a787bb          	addw	a5,a5,a0
 4cc:	0017979b          	sllw	a5,a5,0x1
 4d0:	00d787bb          	addw	a5,a5,a3
 4d4:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 4d8:	00074683          	lbu	a3,0(a4)
 4dc:	fd06879b          	addw	a5,a3,-48
 4e0:	0ff7f793          	zext.b	a5,a5
 4e4:	fcf67ee3          	bgeu	a2,a5,4c0 <atoi+0x28>
  return n;
}
 4e8:	00813403          	ld	s0,8(sp)
 4ec:	01010113          	add	sp,sp,16
 4f0:	00008067          	ret
  n = 0;
 4f4:	00000513          	li	a0,0
 4f8:	ff1ff06f          	j	4e8 <atoi+0x50>

00000000000004fc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4fc:	ff010113          	add	sp,sp,-16
 500:	00813423          	sd	s0,8(sp)
 504:	01010413          	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 508:	02b57c63          	bgeu	a0,a1,540 <memmove+0x44>
    while(n-- > 0)
 50c:	02c05463          	blez	a2,534 <memmove+0x38>
 510:	02061613          	sll	a2,a2,0x20
 514:	02065613          	srl	a2,a2,0x20
 518:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 51c:	00050713          	mv	a4,a0
      *dst++ = *src++;
 520:	00158593          	add	a1,a1,1
 524:	00170713          	add	a4,a4,1
 528:	fff5c683          	lbu	a3,-1(a1)
 52c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 530:	fee798e3          	bne	a5,a4,520 <memmove+0x24>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 534:	00813403          	ld	s0,8(sp)
 538:	01010113          	add	sp,sp,16
 53c:	00008067          	ret
    dst += n;
 540:	00c50733          	add	a4,a0,a2
    src += n;
 544:	00c585b3          	add	a1,a1,a2
    while(n-- > 0)
 548:	fec056e3          	blez	a2,534 <memmove+0x38>
 54c:	fff6079b          	addw	a5,a2,-1
 550:	02079793          	sll	a5,a5,0x20
 554:	0207d793          	srl	a5,a5,0x20
 558:	fff7c793          	not	a5,a5
 55c:	00f707b3          	add	a5,a4,a5
      *--dst = *--src;
 560:	fff58593          	add	a1,a1,-1
 564:	fff70713          	add	a4,a4,-1
 568:	0005c683          	lbu	a3,0(a1)
 56c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 570:	fee798e3          	bne	a5,a4,560 <memmove+0x64>
 574:	fc1ff06f          	j	534 <memmove+0x38>

0000000000000578 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 578:	ff010113          	add	sp,sp,-16
 57c:	00813423          	sd	s0,8(sp)
 580:	01010413          	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 584:	04060463          	beqz	a2,5cc <memcmp+0x54>
 588:	fff6069b          	addw	a3,a2,-1
 58c:	02069693          	sll	a3,a3,0x20
 590:	0206d693          	srl	a3,a3,0x20
 594:	00168693          	add	a3,a3,1
 598:	00d506b3          	add	a3,a0,a3
    if (*p1 != *p2) {
 59c:	00054783          	lbu	a5,0(a0)
 5a0:	0005c703          	lbu	a4,0(a1)
 5a4:	00e79c63          	bne	a5,a4,5bc <memcmp+0x44>
      return *p1 - *p2;
    }
    p1++;
 5a8:	00150513          	add	a0,a0,1
    p2++;
 5ac:	00158593          	add	a1,a1,1
  while (n-- > 0) {
 5b0:	fed516e3          	bne	a0,a3,59c <memcmp+0x24>
  }
  return 0;
 5b4:	00000513          	li	a0,0
 5b8:	0080006f          	j	5c0 <memcmp+0x48>
      return *p1 - *p2;
 5bc:	40e7853b          	subw	a0,a5,a4
}
 5c0:	00813403          	ld	s0,8(sp)
 5c4:	01010113          	add	sp,sp,16
 5c8:	00008067          	ret
  return 0;
 5cc:	00000513          	li	a0,0
 5d0:	ff1ff06f          	j	5c0 <memcmp+0x48>

00000000000005d4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 5d4:	ff010113          	add	sp,sp,-16
 5d8:	00113423          	sd	ra,8(sp)
 5dc:	00813023          	sd	s0,0(sp)
 5e0:	01010413          	add	s0,sp,16
  return memmove(dst, src, n);
 5e4:	00000097          	auipc	ra,0x0
 5e8:	f18080e7          	jalr	-232(ra) # 4fc <memmove>
}
 5ec:	00813083          	ld	ra,8(sp)
 5f0:	00013403          	ld	s0,0(sp)
 5f4:	01010113          	add	sp,sp,16
 5f8:	00008067          	ret

00000000000005fc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 5fc:	00100893          	li	a7,1
 ecall
 600:	00000073          	ecall
 ret
 604:	00008067          	ret

0000000000000608 <exit>:
.global exit
exit:
 li a7, SYS_exit
 608:	00200893          	li	a7,2
 ecall
 60c:	00000073          	ecall
 ret
 610:	00008067          	ret

0000000000000614 <wait>:
.global wait
wait:
 li a7, SYS_wait
 614:	00300893          	li	a7,3
 ecall
 618:	00000073          	ecall
 ret
 61c:	00008067          	ret

0000000000000620 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 620:	00400893          	li	a7,4
 ecall
 624:	00000073          	ecall
 ret
 628:	00008067          	ret

000000000000062c <read>:
.global read
read:
 li a7, SYS_read
 62c:	00500893          	li	a7,5
 ecall
 630:	00000073          	ecall
 ret
 634:	00008067          	ret

0000000000000638 <write>:
.global write
write:
 li a7, SYS_write
 638:	01000893          	li	a7,16
 ecall
 63c:	00000073          	ecall
 ret
 640:	00008067          	ret

0000000000000644 <close>:
.global close
close:
 li a7, SYS_close
 644:	01500893          	li	a7,21
 ecall
 648:	00000073          	ecall
 ret
 64c:	00008067          	ret

0000000000000650 <kill>:
.global kill
kill:
 li a7, SYS_kill
 650:	00600893          	li	a7,6
 ecall
 654:	00000073          	ecall
 ret
 658:	00008067          	ret

000000000000065c <exec>:
.global exec
exec:
 li a7, SYS_exec
 65c:	00700893          	li	a7,7
 ecall
 660:	00000073          	ecall
 ret
 664:	00008067          	ret

0000000000000668 <open>:
.global open
open:
 li a7, SYS_open
 668:	00f00893          	li	a7,15
 ecall
 66c:	00000073          	ecall
 ret
 670:	00008067          	ret

0000000000000674 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 674:	01100893          	li	a7,17
 ecall
 678:	00000073          	ecall
 ret
 67c:	00008067          	ret

0000000000000680 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 680:	01200893          	li	a7,18
 ecall
 684:	00000073          	ecall
 ret
 688:	00008067          	ret

000000000000068c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 68c:	00800893          	li	a7,8
 ecall
 690:	00000073          	ecall
 ret
 694:	00008067          	ret

0000000000000698 <link>:
.global link
link:
 li a7, SYS_link
 698:	01300893          	li	a7,19
 ecall
 69c:	00000073          	ecall
 ret
 6a0:	00008067          	ret

00000000000006a4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 6a4:	01400893          	li	a7,20
 ecall
 6a8:	00000073          	ecall
 ret
 6ac:	00008067          	ret

00000000000006b0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 6b0:	00900893          	li	a7,9
 ecall
 6b4:	00000073          	ecall
 ret
 6b8:	00008067          	ret

00000000000006bc <dup>:
.global dup
dup:
 li a7, SYS_dup
 6bc:	00a00893          	li	a7,10
 ecall
 6c0:	00000073          	ecall
 ret
 6c4:	00008067          	ret

00000000000006c8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 6c8:	00b00893          	li	a7,11
 ecall
 6cc:	00000073          	ecall
 ret
 6d0:	00008067          	ret

00000000000006d4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 6d4:	00c00893          	li	a7,12
 ecall
 6d8:	00000073          	ecall
 ret
 6dc:	00008067          	ret

00000000000006e0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 6e0:	00d00893          	li	a7,13
 ecall
 6e4:	00000073          	ecall
 ret
 6e8:	00008067          	ret

00000000000006ec <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 6ec:	00e00893          	li	a7,14
 ecall
 6f0:	00000073          	ecall
 ret
 6f4:	00008067          	ret

00000000000006f8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 6f8:	fe010113          	add	sp,sp,-32
 6fc:	00113c23          	sd	ra,24(sp)
 700:	00813823          	sd	s0,16(sp)
 704:	02010413          	add	s0,sp,32
 708:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 70c:	00100613          	li	a2,1
 710:	fef40593          	add	a1,s0,-17
 714:	00000097          	auipc	ra,0x0
 718:	f24080e7          	jalr	-220(ra) # 638 <write>
}
 71c:	01813083          	ld	ra,24(sp)
 720:	01013403          	ld	s0,16(sp)
 724:	02010113          	add	sp,sp,32
 728:	00008067          	ret

000000000000072c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 72c:	fc010113          	add	sp,sp,-64
 730:	02113c23          	sd	ra,56(sp)
 734:	02813823          	sd	s0,48(sp)
 738:	02913423          	sd	s1,40(sp)
 73c:	03213023          	sd	s2,32(sp)
 740:	01313c23          	sd	s3,24(sp)
 744:	04010413          	add	s0,sp,64
 748:	00050493          	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 74c:	00068463          	beqz	a3,754 <printint+0x28>
 750:	0c05c063          	bltz	a1,810 <printint+0xe4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 754:	0005859b          	sext.w	a1,a1
  neg = 0;
 758:	00000893          	li	a7,0
 75c:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 760:	00000713          	li	a4,0
  do{
    buf[i++] = digits[x % base];
 764:	0006061b          	sext.w	a2,a2
 768:	00000517          	auipc	a0,0x0
 76c:	67050513          	add	a0,a0,1648 # dd8 <digits>
 770:	00070813          	mv	a6,a4
 774:	0017071b          	addw	a4,a4,1
 778:	02c5f7bb          	remuw	a5,a1,a2
 77c:	02079793          	sll	a5,a5,0x20
 780:	0207d793          	srl	a5,a5,0x20
 784:	00f507b3          	add	a5,a0,a5
 788:	0007c783          	lbu	a5,0(a5)
 78c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 790:	0005879b          	sext.w	a5,a1
 794:	02c5d5bb          	divuw	a1,a1,a2
 798:	00168693          	add	a3,a3,1
 79c:	fcc7fae3          	bgeu	a5,a2,770 <printint+0x44>
  if(neg)
 7a0:	00088c63          	beqz	a7,7b8 <printint+0x8c>
    buf[i++] = '-';
 7a4:	fd070793          	add	a5,a4,-48
 7a8:	00878733          	add	a4,a5,s0
 7ac:	02d00793          	li	a5,45
 7b0:	fef70823          	sb	a5,-16(a4)
 7b4:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 7b8:	02e05e63          	blez	a4,7f4 <printint+0xc8>
 7bc:	fc040793          	add	a5,s0,-64
 7c0:	00e78933          	add	s2,a5,a4
 7c4:	fff78993          	add	s3,a5,-1
 7c8:	00e989b3          	add	s3,s3,a4
 7cc:	fff7071b          	addw	a4,a4,-1
 7d0:	02071713          	sll	a4,a4,0x20
 7d4:	02075713          	srl	a4,a4,0x20
 7d8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 7dc:	fff94583          	lbu	a1,-1(s2)
 7e0:	00048513          	mv	a0,s1
 7e4:	00000097          	auipc	ra,0x0
 7e8:	f14080e7          	jalr	-236(ra) # 6f8 <putc>
  while(--i >= 0)
 7ec:	fff90913          	add	s2,s2,-1
 7f0:	ff3916e3          	bne	s2,s3,7dc <printint+0xb0>
}
 7f4:	03813083          	ld	ra,56(sp)
 7f8:	03013403          	ld	s0,48(sp)
 7fc:	02813483          	ld	s1,40(sp)
 800:	02013903          	ld	s2,32(sp)
 804:	01813983          	ld	s3,24(sp)
 808:	04010113          	add	sp,sp,64
 80c:	00008067          	ret
    x = -xx;
 810:	40b005bb          	negw	a1,a1
    neg = 1;
 814:	00100893          	li	a7,1
    x = -xx;
 818:	f45ff06f          	j	75c <printint+0x30>

000000000000081c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 81c:	fb010113          	add	sp,sp,-80
 820:	04113423          	sd	ra,72(sp)
 824:	04813023          	sd	s0,64(sp)
 828:	02913c23          	sd	s1,56(sp)
 82c:	03213823          	sd	s2,48(sp)
 830:	03313423          	sd	s3,40(sp)
 834:	03413023          	sd	s4,32(sp)
 838:	01513c23          	sd	s5,24(sp)
 83c:	01613823          	sd	s6,16(sp)
 840:	01713423          	sd	s7,8(sp)
 844:	01813023          	sd	s8,0(sp)
 848:	05010413          	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 84c:	0005c903          	lbu	s2,0(a1)
 850:	20090e63          	beqz	s2,a6c <vprintf+0x250>
 854:	00050a93          	mv	s5,a0
 858:	00060b93          	mv	s7,a2
 85c:	00158493          	add	s1,a1,1
  state = 0;
 860:	00000993          	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 864:	02500a13          	li	s4,37
 868:	01500b13          	li	s6,21
 86c:	0280006f          	j	894 <vprintf+0x78>
        putc(fd, c);
 870:	00090593          	mv	a1,s2
 874:	000a8513          	mv	a0,s5
 878:	00000097          	auipc	ra,0x0
 87c:	e80080e7          	jalr	-384(ra) # 6f8 <putc>
 880:	0080006f          	j	888 <vprintf+0x6c>
    } else if(state == '%'){
 884:	03498063          	beq	s3,s4,8a4 <vprintf+0x88>
  for(i = 0; fmt[i]; i++){
 888:	00148493          	add	s1,s1,1
 88c:	fff4c903          	lbu	s2,-1(s1)
 890:	1c090e63          	beqz	s2,a6c <vprintf+0x250>
    if(state == 0){
 894:	fe0998e3          	bnez	s3,884 <vprintf+0x68>
      if(c == '%'){
 898:	fd491ce3          	bne	s2,s4,870 <vprintf+0x54>
        state = '%';
 89c:	000a0993          	mv	s3,s4
 8a0:	fe9ff06f          	j	888 <vprintf+0x6c>
      if(c == 'd'){
 8a4:	17490e63          	beq	s2,s4,a20 <vprintf+0x204>
 8a8:	f9d9079b          	addw	a5,s2,-99
 8ac:	0ff7f793          	zext.b	a5,a5
 8b0:	18fb6463          	bltu	s6,a5,a38 <vprintf+0x21c>
 8b4:	f9d9079b          	addw	a5,s2,-99
 8b8:	0ff7f713          	zext.b	a4,a5
 8bc:	16eb6e63          	bltu	s6,a4,a38 <vprintf+0x21c>
 8c0:	00271793          	sll	a5,a4,0x2
 8c4:	00000717          	auipc	a4,0x0
 8c8:	4bc70713          	add	a4,a4,1212 # d80 <malloc+0x198>
 8cc:	00e787b3          	add	a5,a5,a4
 8d0:	0007a783          	lw	a5,0(a5)
 8d4:	00e787b3          	add	a5,a5,a4
 8d8:	00078067          	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 8dc:	008b8913          	add	s2,s7,8
 8e0:	00100693          	li	a3,1
 8e4:	00a00613          	li	a2,10
 8e8:	000ba583          	lw	a1,0(s7)
 8ec:	000a8513          	mv	a0,s5
 8f0:	00000097          	auipc	ra,0x0
 8f4:	e3c080e7          	jalr	-452(ra) # 72c <printint>
 8f8:	00090b93          	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 8fc:	00000993          	li	s3,0
 900:	f89ff06f          	j	888 <vprintf+0x6c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 904:	008b8913          	add	s2,s7,8
 908:	00000693          	li	a3,0
 90c:	00a00613          	li	a2,10
 910:	000ba583          	lw	a1,0(s7)
 914:	000a8513          	mv	a0,s5
 918:	00000097          	auipc	ra,0x0
 91c:	e14080e7          	jalr	-492(ra) # 72c <printint>
 920:	00090b93          	mv	s7,s2
      state = 0;
 924:	00000993          	li	s3,0
 928:	f61ff06f          	j	888 <vprintf+0x6c>
        printint(fd, va_arg(ap, int), 16, 0);
 92c:	008b8913          	add	s2,s7,8
 930:	00000693          	li	a3,0
 934:	01000613          	li	a2,16
 938:	000ba583          	lw	a1,0(s7)
 93c:	000a8513          	mv	a0,s5
 940:	00000097          	auipc	ra,0x0
 944:	dec080e7          	jalr	-532(ra) # 72c <printint>
 948:	00090b93          	mv	s7,s2
      state = 0;
 94c:	00000993          	li	s3,0
 950:	f39ff06f          	j	888 <vprintf+0x6c>
        printptr(fd, va_arg(ap, uint64));
 954:	008b8c13          	add	s8,s7,8
 958:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 95c:	03000593          	li	a1,48
 960:	000a8513          	mv	a0,s5
 964:	00000097          	auipc	ra,0x0
 968:	d94080e7          	jalr	-620(ra) # 6f8 <putc>
  putc(fd, 'x');
 96c:	07800593          	li	a1,120
 970:	000a8513          	mv	a0,s5
 974:	00000097          	auipc	ra,0x0
 978:	d84080e7          	jalr	-636(ra) # 6f8 <putc>
 97c:	01000913          	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 980:	00000b97          	auipc	s7,0x0
 984:	458b8b93          	add	s7,s7,1112 # dd8 <digits>
 988:	03c9d793          	srl	a5,s3,0x3c
 98c:	00fb87b3          	add	a5,s7,a5
 990:	0007c583          	lbu	a1,0(a5)
 994:	000a8513          	mv	a0,s5
 998:	00000097          	auipc	ra,0x0
 99c:	d60080e7          	jalr	-672(ra) # 6f8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 9a0:	00499993          	sll	s3,s3,0x4
 9a4:	fff9091b          	addw	s2,s2,-1
 9a8:	fe0910e3          	bnez	s2,988 <vprintf+0x16c>
        printptr(fd, va_arg(ap, uint64));
 9ac:	000c0b93          	mv	s7,s8
      state = 0;
 9b0:	00000993          	li	s3,0
 9b4:	ed5ff06f          	j	888 <vprintf+0x6c>
        s = va_arg(ap, char*);
 9b8:	008b8993          	add	s3,s7,8
 9bc:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 9c0:	02090863          	beqz	s2,9f0 <vprintf+0x1d4>
        while(*s != 0){
 9c4:	00094583          	lbu	a1,0(s2)
 9c8:	08058c63          	beqz	a1,a60 <vprintf+0x244>
          putc(fd, *s);
 9cc:	000a8513          	mv	a0,s5
 9d0:	00000097          	auipc	ra,0x0
 9d4:	d28080e7          	jalr	-728(ra) # 6f8 <putc>
          s++;
 9d8:	00190913          	add	s2,s2,1
        while(*s != 0){
 9dc:	00094583          	lbu	a1,0(s2)
 9e0:	fe0596e3          	bnez	a1,9cc <vprintf+0x1b0>
        s = va_arg(ap, char*);
 9e4:	00098b93          	mv	s7,s3
      state = 0;
 9e8:	00000993          	li	s3,0
 9ec:	e9dff06f          	j	888 <vprintf+0x6c>
          s = "(null)";
 9f0:	00000917          	auipc	s2,0x0
 9f4:	38890913          	add	s2,s2,904 # d78 <malloc+0x190>
        while(*s != 0){
 9f8:	02800593          	li	a1,40
 9fc:	fd1ff06f          	j	9cc <vprintf+0x1b0>
        putc(fd, va_arg(ap, uint));
 a00:	008b8913          	add	s2,s7,8
 a04:	000bc583          	lbu	a1,0(s7)
 a08:	000a8513          	mv	a0,s5
 a0c:	00000097          	auipc	ra,0x0
 a10:	cec080e7          	jalr	-788(ra) # 6f8 <putc>
 a14:	00090b93          	mv	s7,s2
      state = 0;
 a18:	00000993          	li	s3,0
 a1c:	e6dff06f          	j	888 <vprintf+0x6c>
        putc(fd, c);
 a20:	02500593          	li	a1,37
 a24:	000a8513          	mv	a0,s5
 a28:	00000097          	auipc	ra,0x0
 a2c:	cd0080e7          	jalr	-816(ra) # 6f8 <putc>
      state = 0;
 a30:	00000993          	li	s3,0
 a34:	e55ff06f          	j	888 <vprintf+0x6c>
        putc(fd, '%');
 a38:	02500593          	li	a1,37
 a3c:	000a8513          	mv	a0,s5
 a40:	00000097          	auipc	ra,0x0
 a44:	cb8080e7          	jalr	-840(ra) # 6f8 <putc>
        putc(fd, c);
 a48:	00090593          	mv	a1,s2
 a4c:	000a8513          	mv	a0,s5
 a50:	00000097          	auipc	ra,0x0
 a54:	ca8080e7          	jalr	-856(ra) # 6f8 <putc>
      state = 0;
 a58:	00000993          	li	s3,0
 a5c:	e2dff06f          	j	888 <vprintf+0x6c>
        s = va_arg(ap, char*);
 a60:	00098b93          	mv	s7,s3
      state = 0;
 a64:	00000993          	li	s3,0
 a68:	e21ff06f          	j	888 <vprintf+0x6c>
    }
  }
}
 a6c:	04813083          	ld	ra,72(sp)
 a70:	04013403          	ld	s0,64(sp)
 a74:	03813483          	ld	s1,56(sp)
 a78:	03013903          	ld	s2,48(sp)
 a7c:	02813983          	ld	s3,40(sp)
 a80:	02013a03          	ld	s4,32(sp)
 a84:	01813a83          	ld	s5,24(sp)
 a88:	01013b03          	ld	s6,16(sp)
 a8c:	00813b83          	ld	s7,8(sp)
 a90:	00013c03          	ld	s8,0(sp)
 a94:	05010113          	add	sp,sp,80
 a98:	00008067          	ret

0000000000000a9c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a9c:	fb010113          	add	sp,sp,-80
 aa0:	00113c23          	sd	ra,24(sp)
 aa4:	00813823          	sd	s0,16(sp)
 aa8:	02010413          	add	s0,sp,32
 aac:	00c43023          	sd	a2,0(s0)
 ab0:	00d43423          	sd	a3,8(s0)
 ab4:	00e43823          	sd	a4,16(s0)
 ab8:	00f43c23          	sd	a5,24(s0)
 abc:	03043023          	sd	a6,32(s0)
 ac0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 ac4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 ac8:	00040613          	mv	a2,s0
 acc:	00000097          	auipc	ra,0x0
 ad0:	d50080e7          	jalr	-688(ra) # 81c <vprintf>
}
 ad4:	01813083          	ld	ra,24(sp)
 ad8:	01013403          	ld	s0,16(sp)
 adc:	05010113          	add	sp,sp,80
 ae0:	00008067          	ret

0000000000000ae4 <printf>:

void
printf(const char *fmt, ...)
{
 ae4:	fa010113          	add	sp,sp,-96
 ae8:	00113c23          	sd	ra,24(sp)
 aec:	00813823          	sd	s0,16(sp)
 af0:	02010413          	add	s0,sp,32
 af4:	00b43423          	sd	a1,8(s0)
 af8:	00c43823          	sd	a2,16(s0)
 afc:	00d43c23          	sd	a3,24(s0)
 b00:	02e43023          	sd	a4,32(s0)
 b04:	02f43423          	sd	a5,40(s0)
 b08:	03043823          	sd	a6,48(s0)
 b0c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 b10:	00840613          	add	a2,s0,8
 b14:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 b18:	00050593          	mv	a1,a0
 b1c:	00100513          	li	a0,1
 b20:	00000097          	auipc	ra,0x0
 b24:	cfc080e7          	jalr	-772(ra) # 81c <vprintf>
}
 b28:	01813083          	ld	ra,24(sp)
 b2c:	01013403          	ld	s0,16(sp)
 b30:	06010113          	add	sp,sp,96
 b34:	00008067          	ret

0000000000000b38 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 b38:	ff010113          	add	sp,sp,-16
 b3c:	00813423          	sd	s0,8(sp)
 b40:	01010413          	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 b44:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b48:	00000797          	auipc	a5,0x0
 b4c:	4b87b783          	ld	a5,1208(a5) # 1000 <freep>
 b50:	0400006f          	j	b90 <free+0x58>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 b54:	00862703          	lw	a4,8(a2)
 b58:	00b7073b          	addw	a4,a4,a1
 b5c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 b60:	0007b703          	ld	a4,0(a5)
 b64:	00073603          	ld	a2,0(a4)
 b68:	0500006f          	j	bb8 <free+0x80>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 b6c:	ff852703          	lw	a4,-8(a0)
 b70:	00c7073b          	addw	a4,a4,a2
 b74:	00e7a423          	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 b78:	ff053683          	ld	a3,-16(a0)
 b7c:	0540006f          	j	bd0 <free+0x98>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b80:	0007b703          	ld	a4,0(a5)
 b84:	00e7e463          	bltu	a5,a4,b8c <free+0x54>
 b88:	00e6ec63          	bltu	a3,a4,ba0 <free+0x68>
{
 b8c:	00070793          	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b90:	fed7f8e3          	bgeu	a5,a3,b80 <free+0x48>
 b94:	0007b703          	ld	a4,0(a5)
 b98:	00e6e463          	bltu	a3,a4,ba0 <free+0x68>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b9c:	fee7e8e3          	bltu	a5,a4,b8c <free+0x54>
  if(bp + bp->s.size == p->s.ptr){
 ba0:	ff852583          	lw	a1,-8(a0)
 ba4:	0007b603          	ld	a2,0(a5)
 ba8:	02059813          	sll	a6,a1,0x20
 bac:	01c85713          	srl	a4,a6,0x1c
 bb0:	00e68733          	add	a4,a3,a4
 bb4:	fae600e3          	beq	a2,a4,b54 <free+0x1c>
    bp->s.ptr = p->s.ptr->s.ptr;
 bb8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 bbc:	0087a603          	lw	a2,8(a5)
 bc0:	02061593          	sll	a1,a2,0x20
 bc4:	01c5d713          	srl	a4,a1,0x1c
 bc8:	00e78733          	add	a4,a5,a4
 bcc:	fae680e3          	beq	a3,a4,b6c <free+0x34>
    p->s.ptr = bp->s.ptr;
 bd0:	00d7b023          	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 bd4:	00000717          	auipc	a4,0x0
 bd8:	42f73623          	sd	a5,1068(a4) # 1000 <freep>
}
 bdc:	00813403          	ld	s0,8(sp)
 be0:	01010113          	add	sp,sp,16
 be4:	00008067          	ret

0000000000000be8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 be8:	fc010113          	add	sp,sp,-64
 bec:	02113c23          	sd	ra,56(sp)
 bf0:	02813823          	sd	s0,48(sp)
 bf4:	02913423          	sd	s1,40(sp)
 bf8:	03213023          	sd	s2,32(sp)
 bfc:	01313c23          	sd	s3,24(sp)
 c00:	01413823          	sd	s4,16(sp)
 c04:	01513423          	sd	s5,8(sp)
 c08:	01613023          	sd	s6,0(sp)
 c0c:	04010413          	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c10:	02051493          	sll	s1,a0,0x20
 c14:	0204d493          	srl	s1,s1,0x20
 c18:	00f48493          	add	s1,s1,15
 c1c:	0044d493          	srl	s1,s1,0x4
 c20:	0014899b          	addw	s3,s1,1
 c24:	00148493          	add	s1,s1,1
  if((prevp = freep) == 0){
 c28:	00000517          	auipc	a0,0x0
 c2c:	3d853503          	ld	a0,984(a0) # 1000 <freep>
 c30:	02050e63          	beqz	a0,c6c <malloc+0x84>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c34:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
 c38:	0087a703          	lw	a4,8(a5)
 c3c:	04977663          	bgeu	a4,s1,c88 <malloc+0xa0>
  if(nu < 4096)
 c40:	00098a13          	mv	s4,s3
 c44:	0009871b          	sext.w	a4,s3
 c48:	000016b7          	lui	a3,0x1
 c4c:	00d77463          	bgeu	a4,a3,c54 <malloc+0x6c>
 c50:	00001a37          	lui	s4,0x1
 c54:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 c58:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 c5c:	00000917          	auipc	s2,0x0
 c60:	3a490913          	add	s2,s2,932 # 1000 <freep>
  if(p == (char*)-1)
 c64:	fff00a93          	li	s5,-1
 c68:	0a00006f          	j	d08 <malloc+0x120>
    base.s.ptr = freep = prevp = &base;
 c6c:	00000797          	auipc	a5,0x0
 c70:	5a478793          	add	a5,a5,1444 # 1210 <base>
 c74:	00000717          	auipc	a4,0x0
 c78:	38f73623          	sd	a5,908(a4) # 1000 <freep>
 c7c:	00f7b023          	sd	a5,0(a5)
    base.s.size = 0;
 c80:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 c84:	fbdff06f          	j	c40 <malloc+0x58>
      if(p->s.size == nunits)
 c88:	04e48863          	beq	s1,a4,cd8 <malloc+0xf0>
        p->s.size -= nunits;
 c8c:	4137073b          	subw	a4,a4,s3
 c90:	00e7a423          	sw	a4,8(a5)
        p += p->s.size;
 c94:	02071693          	sll	a3,a4,0x20
 c98:	01c6d713          	srl	a4,a3,0x1c
 c9c:	00e787b3          	add	a5,a5,a4
        p->s.size = nunits;
 ca0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 ca4:	00000717          	auipc	a4,0x0
 ca8:	34a73e23          	sd	a0,860(a4) # 1000 <freep>
      return (void*)(p + 1);
 cac:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 cb0:	03813083          	ld	ra,56(sp)
 cb4:	03013403          	ld	s0,48(sp)
 cb8:	02813483          	ld	s1,40(sp)
 cbc:	02013903          	ld	s2,32(sp)
 cc0:	01813983          	ld	s3,24(sp)
 cc4:	01013a03          	ld	s4,16(sp)
 cc8:	00813a83          	ld	s5,8(sp)
 ccc:	00013b03          	ld	s6,0(sp)
 cd0:	04010113          	add	sp,sp,64
 cd4:	00008067          	ret
        prevp->s.ptr = p->s.ptr;
 cd8:	0007b703          	ld	a4,0(a5)
 cdc:	00e53023          	sd	a4,0(a0)
 ce0:	fc5ff06f          	j	ca4 <malloc+0xbc>
  hp->s.size = nu;
 ce4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 ce8:	01050513          	add	a0,a0,16
 cec:	00000097          	auipc	ra,0x0
 cf0:	e4c080e7          	jalr	-436(ra) # b38 <free>
  return freep;
 cf4:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 cf8:	fa050ce3          	beqz	a0,cb0 <malloc+0xc8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 cfc:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
 d00:	0087a703          	lw	a4,8(a5)
 d04:	f89772e3          	bgeu	a4,s1,c88 <malloc+0xa0>
    if(p == freep)
 d08:	00093703          	ld	a4,0(s2)
 d0c:	00078513          	mv	a0,a5
 d10:	fef716e3          	bne	a4,a5,cfc <malloc+0x114>
  p = sbrk(nu * sizeof(Header));
 d14:	000a0513          	mv	a0,s4
 d18:	00000097          	auipc	ra,0x0
 d1c:	9bc080e7          	jalr	-1604(ra) # 6d4 <sbrk>
  if(p == (char*)-1)
 d20:	fd5512e3          	bne	a0,s5,ce4 <malloc+0xfc>
        return 0;
 d24:	00000513          	li	a0,0
 d28:	f89ff06f          	j	cb0 <malloc+0xc8>
