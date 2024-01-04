
user/_cat:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	fd010113          	add	sp,sp,-48
   4:	02113423          	sd	ra,40(sp)
   8:	02813023          	sd	s0,32(sp)
   c:	00913c23          	sd	s1,24(sp)
  10:	01213823          	sd	s2,16(sp)
  14:	01313423          	sd	s3,8(sp)
  18:	03010413          	add	s0,sp,48
  1c:	00050993          	mv	s3,a0
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
  20:	00001917          	auipc	s2,0x1
  24:	ff090913          	add	s2,s2,-16 # 1010 <buf>
  28:	20000613          	li	a2,512
  2c:	00090593          	mv	a1,s2
  30:	00098513          	mv	a0,s3
  34:	00000097          	auipc	ra,0x0
  38:	554080e7          	jalr	1364(ra) # 588 <read>
  3c:	00050493          	mv	s1,a0
  40:	02a05e63          	blez	a0,7c <cat+0x7c>
    if (write(1, buf, n) != n) {
  44:	00048613          	mv	a2,s1
  48:	00090593          	mv	a1,s2
  4c:	00100513          	li	a0,1
  50:	00000097          	auipc	ra,0x0
  54:	544080e7          	jalr	1348(ra) # 594 <write>
  58:	fc9508e3          	beq	a0,s1,28 <cat+0x28>
      fprintf(2, "cat: write error\n");
  5c:	00001597          	auipc	a1,0x1
  60:	c3458593          	add	a1,a1,-972 # c90 <malloc+0x14c>
  64:	00200513          	li	a0,2
  68:	00001097          	auipc	ra,0x1
  6c:	990080e7          	jalr	-1648(ra) # 9f8 <fprintf>
      exit(1);
  70:	00100513          	li	a0,1
  74:	00000097          	auipc	ra,0x0
  78:	4f0080e7          	jalr	1264(ra) # 564 <exit>
    }
  }
  if(n < 0){
  7c:	02054063          	bltz	a0,9c <cat+0x9c>
    fprintf(2, "cat: read error\n");
    exit(1);
  }
}
  80:	02813083          	ld	ra,40(sp)
  84:	02013403          	ld	s0,32(sp)
  88:	01813483          	ld	s1,24(sp)
  8c:	01013903          	ld	s2,16(sp)
  90:	00813983          	ld	s3,8(sp)
  94:	03010113          	add	sp,sp,48
  98:	00008067          	ret
    fprintf(2, "cat: read error\n");
  9c:	00001597          	auipc	a1,0x1
  a0:	c0c58593          	add	a1,a1,-1012 # ca8 <malloc+0x164>
  a4:	00200513          	li	a0,2
  a8:	00001097          	auipc	ra,0x1
  ac:	950080e7          	jalr	-1712(ra) # 9f8 <fprintf>
    exit(1);
  b0:	00100513          	li	a0,1
  b4:	00000097          	auipc	ra,0x0
  b8:	4b0080e7          	jalr	1200(ra) # 564 <exit>

00000000000000bc <main>:

int
main(int argc, char *argv[])
{
  bc:	fd010113          	add	sp,sp,-48
  c0:	02113423          	sd	ra,40(sp)
  c4:	02813023          	sd	s0,32(sp)
  c8:	00913c23          	sd	s1,24(sp)
  cc:	01213823          	sd	s2,16(sp)
  d0:	01313423          	sd	s3,8(sp)
  d4:	03010413          	add	s0,sp,48
  int fd, i;

  if(argc <= 1){
  d8:	00100793          	li	a5,1
  dc:	04a7de63          	bge	a5,a0,138 <main+0x7c>
  e0:	00858913          	add	s2,a1,8
  e4:	ffe5099b          	addw	s3,a0,-2
  e8:	02099793          	sll	a5,s3,0x20
  ec:	01d7d993          	srl	s3,a5,0x1d
  f0:	01058593          	add	a1,a1,16
  f4:	00b989b3          	add	s3,s3,a1
    cat(0);
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
  f8:	00000593          	li	a1,0
  fc:	00093503          	ld	a0,0(s2)
 100:	00000097          	auipc	ra,0x0
 104:	4c4080e7          	jalr	1220(ra) # 5c4 <open>
 108:	00050493          	mv	s1,a0
 10c:	04054263          	bltz	a0,150 <main+0x94>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
      exit(1);
    }
    cat(fd);
 110:	00000097          	auipc	ra,0x0
 114:	ef0080e7          	jalr	-272(ra) # 0 <cat>
    close(fd);
 118:	00048513          	mv	a0,s1
 11c:	00000097          	auipc	ra,0x0
 120:	484080e7          	jalr	1156(ra) # 5a0 <close>
  for(i = 1; i < argc; i++){
 124:	00890913          	add	s2,s2,8
 128:	fd3918e3          	bne	s2,s3,f8 <main+0x3c>
  }
  exit(0);
 12c:	00000513          	li	a0,0
 130:	00000097          	auipc	ra,0x0
 134:	434080e7          	jalr	1076(ra) # 564 <exit>
    cat(0);
 138:	00000513          	li	a0,0
 13c:	00000097          	auipc	ra,0x0
 140:	ec4080e7          	jalr	-316(ra) # 0 <cat>
    exit(0);
 144:	00000513          	li	a0,0
 148:	00000097          	auipc	ra,0x0
 14c:	41c080e7          	jalr	1052(ra) # 564 <exit>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
 150:	00093603          	ld	a2,0(s2)
 154:	00001597          	auipc	a1,0x1
 158:	b6c58593          	add	a1,a1,-1172 # cc0 <malloc+0x17c>
 15c:	00200513          	li	a0,2
 160:	00001097          	auipc	ra,0x1
 164:	898080e7          	jalr	-1896(ra) # 9f8 <fprintf>
      exit(1);
 168:	00100513          	li	a0,1
 16c:	00000097          	auipc	ra,0x0
 170:	3f8080e7          	jalr	1016(ra) # 564 <exit>

0000000000000174 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 174:	ff010113          	add	sp,sp,-16
 178:	00113423          	sd	ra,8(sp)
 17c:	00813023          	sd	s0,0(sp)
 180:	01010413          	add	s0,sp,16
  extern int main();
  main();
 184:	00000097          	auipc	ra,0x0
 188:	f38080e7          	jalr	-200(ra) # bc <main>
  exit(0);
 18c:	00000513          	li	a0,0
 190:	00000097          	auipc	ra,0x0
 194:	3d4080e7          	jalr	980(ra) # 564 <exit>

0000000000000198 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 198:	ff010113          	add	sp,sp,-16
 19c:	00813423          	sd	s0,8(sp)
 1a0:	01010413          	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1a4:	00050793          	mv	a5,a0
 1a8:	00158593          	add	a1,a1,1
 1ac:	00178793          	add	a5,a5,1
 1b0:	fff5c703          	lbu	a4,-1(a1)
 1b4:	fee78fa3          	sb	a4,-1(a5)
 1b8:	fe0718e3          	bnez	a4,1a8 <strcpy+0x10>
    ;
  return os;
}
 1bc:	00813403          	ld	s0,8(sp)
 1c0:	01010113          	add	sp,sp,16
 1c4:	00008067          	ret

00000000000001c8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1c8:	ff010113          	add	sp,sp,-16
 1cc:	00813423          	sd	s0,8(sp)
 1d0:	01010413          	add	s0,sp,16
  while(*p && *p == *q)
 1d4:	00054783          	lbu	a5,0(a0)
 1d8:	00078e63          	beqz	a5,1f4 <strcmp+0x2c>
 1dc:	0005c703          	lbu	a4,0(a1)
 1e0:	00f71a63          	bne	a4,a5,1f4 <strcmp+0x2c>
    p++, q++;
 1e4:	00150513          	add	a0,a0,1
 1e8:	00158593          	add	a1,a1,1
  while(*p && *p == *q)
 1ec:	00054783          	lbu	a5,0(a0)
 1f0:	fe0796e3          	bnez	a5,1dc <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 1f4:	0005c503          	lbu	a0,0(a1)
}
 1f8:	40a7853b          	subw	a0,a5,a0
 1fc:	00813403          	ld	s0,8(sp)
 200:	01010113          	add	sp,sp,16
 204:	00008067          	ret

0000000000000208 <strlen>:

uint
strlen(const char *s)
{
 208:	ff010113          	add	sp,sp,-16
 20c:	00813423          	sd	s0,8(sp)
 210:	01010413          	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 214:	00054783          	lbu	a5,0(a0)
 218:	02078863          	beqz	a5,248 <strlen+0x40>
 21c:	00150513          	add	a0,a0,1
 220:	00050793          	mv	a5,a0
 224:	00078693          	mv	a3,a5
 228:	00178793          	add	a5,a5,1
 22c:	fff7c703          	lbu	a4,-1(a5)
 230:	fe071ae3          	bnez	a4,224 <strlen+0x1c>
 234:	40a6853b          	subw	a0,a3,a0
 238:	0015051b          	addw	a0,a0,1
    ;
  return n;
}
 23c:	00813403          	ld	s0,8(sp)
 240:	01010113          	add	sp,sp,16
 244:	00008067          	ret
  for(n = 0; s[n]; n++)
 248:	00000513          	li	a0,0
 24c:	ff1ff06f          	j	23c <strlen+0x34>

0000000000000250 <memset>:

void*
memset(void *dst, int c, uint n)
{
 250:	ff010113          	add	sp,sp,-16
 254:	00813423          	sd	s0,8(sp)
 258:	01010413          	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 25c:	02060063          	beqz	a2,27c <memset+0x2c>
 260:	00050793          	mv	a5,a0
 264:	02061613          	sll	a2,a2,0x20
 268:	02065613          	srl	a2,a2,0x20
 26c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 270:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 274:	00178793          	add	a5,a5,1
 278:	fee79ce3          	bne	a5,a4,270 <memset+0x20>
  }
  return dst;
}
 27c:	00813403          	ld	s0,8(sp)
 280:	01010113          	add	sp,sp,16
 284:	00008067          	ret

0000000000000288 <strchr>:

char*
strchr(const char *s, char c)
{
 288:	ff010113          	add	sp,sp,-16
 28c:	00813423          	sd	s0,8(sp)
 290:	01010413          	add	s0,sp,16
  for(; *s; s++)
 294:	00054783          	lbu	a5,0(a0)
 298:	02078263          	beqz	a5,2bc <strchr+0x34>
    if(*s == c)
 29c:	00f58a63          	beq	a1,a5,2b0 <strchr+0x28>
  for(; *s; s++)
 2a0:	00150513          	add	a0,a0,1
 2a4:	00054783          	lbu	a5,0(a0)
 2a8:	fe079ae3          	bnez	a5,29c <strchr+0x14>
      return (char*)s;
  return 0;
 2ac:	00000513          	li	a0,0
}
 2b0:	00813403          	ld	s0,8(sp)
 2b4:	01010113          	add	sp,sp,16
 2b8:	00008067          	ret
  return 0;
 2bc:	00000513          	li	a0,0
 2c0:	ff1ff06f          	j	2b0 <strchr+0x28>

00000000000002c4 <gets>:

char*
gets(char *buf, int max)
{
 2c4:	fa010113          	add	sp,sp,-96
 2c8:	04113c23          	sd	ra,88(sp)
 2cc:	04813823          	sd	s0,80(sp)
 2d0:	04913423          	sd	s1,72(sp)
 2d4:	05213023          	sd	s2,64(sp)
 2d8:	03313c23          	sd	s3,56(sp)
 2dc:	03413823          	sd	s4,48(sp)
 2e0:	03513423          	sd	s5,40(sp)
 2e4:	03613023          	sd	s6,32(sp)
 2e8:	01713c23          	sd	s7,24(sp)
 2ec:	06010413          	add	s0,sp,96
 2f0:	00050b93          	mv	s7,a0
 2f4:	00058a13          	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2f8:	00050913          	mv	s2,a0
 2fc:	00000493          	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 300:	00a00a93          	li	s5,10
 304:	00d00b13          	li	s6,13
  for(i=0; i+1 < max; ){
 308:	00048993          	mv	s3,s1
 30c:	0014849b          	addw	s1,s1,1
 310:	0344de63          	bge	s1,s4,34c <gets+0x88>
    cc = read(0, &c, 1);
 314:	00100613          	li	a2,1
 318:	faf40593          	add	a1,s0,-81
 31c:	00000513          	li	a0,0
 320:	00000097          	auipc	ra,0x0
 324:	268080e7          	jalr	616(ra) # 588 <read>
    if(cc < 1)
 328:	02a05263          	blez	a0,34c <gets+0x88>
    buf[i++] = c;
 32c:	faf44783          	lbu	a5,-81(s0)
 330:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 334:	01578a63          	beq	a5,s5,348 <gets+0x84>
 338:	00190913          	add	s2,s2,1
 33c:	fd6796e3          	bne	a5,s6,308 <gets+0x44>
  for(i=0; i+1 < max; ){
 340:	00048993          	mv	s3,s1
 344:	0080006f          	j	34c <gets+0x88>
 348:	00048993          	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 34c:	013b89b3          	add	s3,s7,s3
 350:	00098023          	sb	zero,0(s3)
  return buf;
}
 354:	000b8513          	mv	a0,s7
 358:	05813083          	ld	ra,88(sp)
 35c:	05013403          	ld	s0,80(sp)
 360:	04813483          	ld	s1,72(sp)
 364:	04013903          	ld	s2,64(sp)
 368:	03813983          	ld	s3,56(sp)
 36c:	03013a03          	ld	s4,48(sp)
 370:	02813a83          	ld	s5,40(sp)
 374:	02013b03          	ld	s6,32(sp)
 378:	01813b83          	ld	s7,24(sp)
 37c:	06010113          	add	sp,sp,96
 380:	00008067          	ret

0000000000000384 <stat>:

int
stat(const char *n, struct stat *st)
{
 384:	fe010113          	add	sp,sp,-32
 388:	00113c23          	sd	ra,24(sp)
 38c:	00813823          	sd	s0,16(sp)
 390:	00913423          	sd	s1,8(sp)
 394:	01213023          	sd	s2,0(sp)
 398:	02010413          	add	s0,sp,32
 39c:	00058913          	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3a0:	00000593          	li	a1,0
 3a4:	00000097          	auipc	ra,0x0
 3a8:	220080e7          	jalr	544(ra) # 5c4 <open>
  if(fd < 0)
 3ac:	04054063          	bltz	a0,3ec <stat+0x68>
 3b0:	00050493          	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3b4:	00090593          	mv	a1,s2
 3b8:	00000097          	auipc	ra,0x0
 3bc:	230080e7          	jalr	560(ra) # 5e8 <fstat>
 3c0:	00050913          	mv	s2,a0
  close(fd);
 3c4:	00048513          	mv	a0,s1
 3c8:	00000097          	auipc	ra,0x0
 3cc:	1d8080e7          	jalr	472(ra) # 5a0 <close>
  return r;
}
 3d0:	00090513          	mv	a0,s2
 3d4:	01813083          	ld	ra,24(sp)
 3d8:	01013403          	ld	s0,16(sp)
 3dc:	00813483          	ld	s1,8(sp)
 3e0:	00013903          	ld	s2,0(sp)
 3e4:	02010113          	add	sp,sp,32
 3e8:	00008067          	ret
    return -1;
 3ec:	fff00913          	li	s2,-1
 3f0:	fe1ff06f          	j	3d0 <stat+0x4c>

00000000000003f4 <atoi>:

int
atoi(const char *s)
{
 3f4:	ff010113          	add	sp,sp,-16
 3f8:	00813423          	sd	s0,8(sp)
 3fc:	01010413          	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 400:	00054683          	lbu	a3,0(a0)
 404:	fd06879b          	addw	a5,a3,-48
 408:	0ff7f793          	zext.b	a5,a5
 40c:	00900613          	li	a2,9
 410:	04f66063          	bltu	a2,a5,450 <atoi+0x5c>
 414:	00050713          	mv	a4,a0
  n = 0;
 418:	00000513          	li	a0,0
    n = n*10 + *s++ - '0';
 41c:	00170713          	add	a4,a4,1
 420:	0025179b          	sllw	a5,a0,0x2
 424:	00a787bb          	addw	a5,a5,a0
 428:	0017979b          	sllw	a5,a5,0x1
 42c:	00d787bb          	addw	a5,a5,a3
 430:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 434:	00074683          	lbu	a3,0(a4)
 438:	fd06879b          	addw	a5,a3,-48
 43c:	0ff7f793          	zext.b	a5,a5
 440:	fcf67ee3          	bgeu	a2,a5,41c <atoi+0x28>
  return n;
}
 444:	00813403          	ld	s0,8(sp)
 448:	01010113          	add	sp,sp,16
 44c:	00008067          	ret
  n = 0;
 450:	00000513          	li	a0,0
 454:	ff1ff06f          	j	444 <atoi+0x50>

0000000000000458 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 458:	ff010113          	add	sp,sp,-16
 45c:	00813423          	sd	s0,8(sp)
 460:	01010413          	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 464:	02b57c63          	bgeu	a0,a1,49c <memmove+0x44>
    while(n-- > 0)
 468:	02c05463          	blez	a2,490 <memmove+0x38>
 46c:	02061613          	sll	a2,a2,0x20
 470:	02065613          	srl	a2,a2,0x20
 474:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 478:	00050713          	mv	a4,a0
      *dst++ = *src++;
 47c:	00158593          	add	a1,a1,1
 480:	00170713          	add	a4,a4,1
 484:	fff5c683          	lbu	a3,-1(a1)
 488:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 48c:	fee798e3          	bne	a5,a4,47c <memmove+0x24>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 490:	00813403          	ld	s0,8(sp)
 494:	01010113          	add	sp,sp,16
 498:	00008067          	ret
    dst += n;
 49c:	00c50733          	add	a4,a0,a2
    src += n;
 4a0:	00c585b3          	add	a1,a1,a2
    while(n-- > 0)
 4a4:	fec056e3          	blez	a2,490 <memmove+0x38>
 4a8:	fff6079b          	addw	a5,a2,-1
 4ac:	02079793          	sll	a5,a5,0x20
 4b0:	0207d793          	srl	a5,a5,0x20
 4b4:	fff7c793          	not	a5,a5
 4b8:	00f707b3          	add	a5,a4,a5
      *--dst = *--src;
 4bc:	fff58593          	add	a1,a1,-1
 4c0:	fff70713          	add	a4,a4,-1
 4c4:	0005c683          	lbu	a3,0(a1)
 4c8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4cc:	fee798e3          	bne	a5,a4,4bc <memmove+0x64>
 4d0:	fc1ff06f          	j	490 <memmove+0x38>

00000000000004d4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4d4:	ff010113          	add	sp,sp,-16
 4d8:	00813423          	sd	s0,8(sp)
 4dc:	01010413          	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4e0:	04060463          	beqz	a2,528 <memcmp+0x54>
 4e4:	fff6069b          	addw	a3,a2,-1
 4e8:	02069693          	sll	a3,a3,0x20
 4ec:	0206d693          	srl	a3,a3,0x20
 4f0:	00168693          	add	a3,a3,1
 4f4:	00d506b3          	add	a3,a0,a3
    if (*p1 != *p2) {
 4f8:	00054783          	lbu	a5,0(a0)
 4fc:	0005c703          	lbu	a4,0(a1)
 500:	00e79c63          	bne	a5,a4,518 <memcmp+0x44>
      return *p1 - *p2;
    }
    p1++;
 504:	00150513          	add	a0,a0,1
    p2++;
 508:	00158593          	add	a1,a1,1
  while (n-- > 0) {
 50c:	fed516e3          	bne	a0,a3,4f8 <memcmp+0x24>
  }
  return 0;
 510:	00000513          	li	a0,0
 514:	0080006f          	j	51c <memcmp+0x48>
      return *p1 - *p2;
 518:	40e7853b          	subw	a0,a5,a4
}
 51c:	00813403          	ld	s0,8(sp)
 520:	01010113          	add	sp,sp,16
 524:	00008067          	ret
  return 0;
 528:	00000513          	li	a0,0
 52c:	ff1ff06f          	j	51c <memcmp+0x48>

0000000000000530 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 530:	ff010113          	add	sp,sp,-16
 534:	00113423          	sd	ra,8(sp)
 538:	00813023          	sd	s0,0(sp)
 53c:	01010413          	add	s0,sp,16
  return memmove(dst, src, n);
 540:	00000097          	auipc	ra,0x0
 544:	f18080e7          	jalr	-232(ra) # 458 <memmove>
}
 548:	00813083          	ld	ra,8(sp)
 54c:	00013403          	ld	s0,0(sp)
 550:	01010113          	add	sp,sp,16
 554:	00008067          	ret

0000000000000558 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 558:	00100893          	li	a7,1
 ecall
 55c:	00000073          	ecall
 ret
 560:	00008067          	ret

0000000000000564 <exit>:
.global exit
exit:
 li a7, SYS_exit
 564:	00200893          	li	a7,2
 ecall
 568:	00000073          	ecall
 ret
 56c:	00008067          	ret

0000000000000570 <wait>:
.global wait
wait:
 li a7, SYS_wait
 570:	00300893          	li	a7,3
 ecall
 574:	00000073          	ecall
 ret
 578:	00008067          	ret

000000000000057c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 57c:	00400893          	li	a7,4
 ecall
 580:	00000073          	ecall
 ret
 584:	00008067          	ret

0000000000000588 <read>:
.global read
read:
 li a7, SYS_read
 588:	00500893          	li	a7,5
 ecall
 58c:	00000073          	ecall
 ret
 590:	00008067          	ret

0000000000000594 <write>:
.global write
write:
 li a7, SYS_write
 594:	01000893          	li	a7,16
 ecall
 598:	00000073          	ecall
 ret
 59c:	00008067          	ret

00000000000005a0 <close>:
.global close
close:
 li a7, SYS_close
 5a0:	01500893          	li	a7,21
 ecall
 5a4:	00000073          	ecall
 ret
 5a8:	00008067          	ret

00000000000005ac <kill>:
.global kill
kill:
 li a7, SYS_kill
 5ac:	00600893          	li	a7,6
 ecall
 5b0:	00000073          	ecall
 ret
 5b4:	00008067          	ret

00000000000005b8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 5b8:	00700893          	li	a7,7
 ecall
 5bc:	00000073          	ecall
 ret
 5c0:	00008067          	ret

00000000000005c4 <open>:
.global open
open:
 li a7, SYS_open
 5c4:	00f00893          	li	a7,15
 ecall
 5c8:	00000073          	ecall
 ret
 5cc:	00008067          	ret

00000000000005d0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5d0:	01100893          	li	a7,17
 ecall
 5d4:	00000073          	ecall
 ret
 5d8:	00008067          	ret

00000000000005dc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5dc:	01200893          	li	a7,18
 ecall
 5e0:	00000073          	ecall
 ret
 5e4:	00008067          	ret

00000000000005e8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5e8:	00800893          	li	a7,8
 ecall
 5ec:	00000073          	ecall
 ret
 5f0:	00008067          	ret

00000000000005f4 <link>:
.global link
link:
 li a7, SYS_link
 5f4:	01300893          	li	a7,19
 ecall
 5f8:	00000073          	ecall
 ret
 5fc:	00008067          	ret

0000000000000600 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 600:	01400893          	li	a7,20
 ecall
 604:	00000073          	ecall
 ret
 608:	00008067          	ret

000000000000060c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 60c:	00900893          	li	a7,9
 ecall
 610:	00000073          	ecall
 ret
 614:	00008067          	ret

0000000000000618 <dup>:
.global dup
dup:
 li a7, SYS_dup
 618:	00a00893          	li	a7,10
 ecall
 61c:	00000073          	ecall
 ret
 620:	00008067          	ret

0000000000000624 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 624:	00b00893          	li	a7,11
 ecall
 628:	00000073          	ecall
 ret
 62c:	00008067          	ret

0000000000000630 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 630:	00c00893          	li	a7,12
 ecall
 634:	00000073          	ecall
 ret
 638:	00008067          	ret

000000000000063c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 63c:	00d00893          	li	a7,13
 ecall
 640:	00000073          	ecall
 ret
 644:	00008067          	ret

0000000000000648 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 648:	00e00893          	li	a7,14
 ecall
 64c:	00000073          	ecall
 ret
 650:	00008067          	ret

0000000000000654 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 654:	fe010113          	add	sp,sp,-32
 658:	00113c23          	sd	ra,24(sp)
 65c:	00813823          	sd	s0,16(sp)
 660:	02010413          	add	s0,sp,32
 664:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 668:	00100613          	li	a2,1
 66c:	fef40593          	add	a1,s0,-17
 670:	00000097          	auipc	ra,0x0
 674:	f24080e7          	jalr	-220(ra) # 594 <write>
}
 678:	01813083          	ld	ra,24(sp)
 67c:	01013403          	ld	s0,16(sp)
 680:	02010113          	add	sp,sp,32
 684:	00008067          	ret

0000000000000688 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 688:	fc010113          	add	sp,sp,-64
 68c:	02113c23          	sd	ra,56(sp)
 690:	02813823          	sd	s0,48(sp)
 694:	02913423          	sd	s1,40(sp)
 698:	03213023          	sd	s2,32(sp)
 69c:	01313c23          	sd	s3,24(sp)
 6a0:	04010413          	add	s0,sp,64
 6a4:	00050493          	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 6a8:	00068463          	beqz	a3,6b0 <printint+0x28>
 6ac:	0c05c063          	bltz	a1,76c <printint+0xe4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 6b0:	0005859b          	sext.w	a1,a1
  neg = 0;
 6b4:	00000893          	li	a7,0
 6b8:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 6bc:	00000713          	li	a4,0
  do{
    buf[i++] = digits[x % base];
 6c0:	0006061b          	sext.w	a2,a2
 6c4:	00000517          	auipc	a0,0x0
 6c8:	67450513          	add	a0,a0,1652 # d38 <digits>
 6cc:	00070813          	mv	a6,a4
 6d0:	0017071b          	addw	a4,a4,1
 6d4:	02c5f7bb          	remuw	a5,a1,a2
 6d8:	02079793          	sll	a5,a5,0x20
 6dc:	0207d793          	srl	a5,a5,0x20
 6e0:	00f507b3          	add	a5,a0,a5
 6e4:	0007c783          	lbu	a5,0(a5)
 6e8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 6ec:	0005879b          	sext.w	a5,a1
 6f0:	02c5d5bb          	divuw	a1,a1,a2
 6f4:	00168693          	add	a3,a3,1
 6f8:	fcc7fae3          	bgeu	a5,a2,6cc <printint+0x44>
  if(neg)
 6fc:	00088c63          	beqz	a7,714 <printint+0x8c>
    buf[i++] = '-';
 700:	fd070793          	add	a5,a4,-48
 704:	00878733          	add	a4,a5,s0
 708:	02d00793          	li	a5,45
 70c:	fef70823          	sb	a5,-16(a4)
 710:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 714:	02e05e63          	blez	a4,750 <printint+0xc8>
 718:	fc040793          	add	a5,s0,-64
 71c:	00e78933          	add	s2,a5,a4
 720:	fff78993          	add	s3,a5,-1
 724:	00e989b3          	add	s3,s3,a4
 728:	fff7071b          	addw	a4,a4,-1
 72c:	02071713          	sll	a4,a4,0x20
 730:	02075713          	srl	a4,a4,0x20
 734:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 738:	fff94583          	lbu	a1,-1(s2)
 73c:	00048513          	mv	a0,s1
 740:	00000097          	auipc	ra,0x0
 744:	f14080e7          	jalr	-236(ra) # 654 <putc>
  while(--i >= 0)
 748:	fff90913          	add	s2,s2,-1
 74c:	ff3916e3          	bne	s2,s3,738 <printint+0xb0>
}
 750:	03813083          	ld	ra,56(sp)
 754:	03013403          	ld	s0,48(sp)
 758:	02813483          	ld	s1,40(sp)
 75c:	02013903          	ld	s2,32(sp)
 760:	01813983          	ld	s3,24(sp)
 764:	04010113          	add	sp,sp,64
 768:	00008067          	ret
    x = -xx;
 76c:	40b005bb          	negw	a1,a1
    neg = 1;
 770:	00100893          	li	a7,1
    x = -xx;
 774:	f45ff06f          	j	6b8 <printint+0x30>

0000000000000778 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 778:	fb010113          	add	sp,sp,-80
 77c:	04113423          	sd	ra,72(sp)
 780:	04813023          	sd	s0,64(sp)
 784:	02913c23          	sd	s1,56(sp)
 788:	03213823          	sd	s2,48(sp)
 78c:	03313423          	sd	s3,40(sp)
 790:	03413023          	sd	s4,32(sp)
 794:	01513c23          	sd	s5,24(sp)
 798:	01613823          	sd	s6,16(sp)
 79c:	01713423          	sd	s7,8(sp)
 7a0:	01813023          	sd	s8,0(sp)
 7a4:	05010413          	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 7a8:	0005c903          	lbu	s2,0(a1)
 7ac:	20090e63          	beqz	s2,9c8 <vprintf+0x250>
 7b0:	00050a93          	mv	s5,a0
 7b4:	00060b93          	mv	s7,a2
 7b8:	00158493          	add	s1,a1,1
  state = 0;
 7bc:	00000993          	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 7c0:	02500a13          	li	s4,37
 7c4:	01500b13          	li	s6,21
 7c8:	0280006f          	j	7f0 <vprintf+0x78>
        putc(fd, c);
 7cc:	00090593          	mv	a1,s2
 7d0:	000a8513          	mv	a0,s5
 7d4:	00000097          	auipc	ra,0x0
 7d8:	e80080e7          	jalr	-384(ra) # 654 <putc>
 7dc:	0080006f          	j	7e4 <vprintf+0x6c>
    } else if(state == '%'){
 7e0:	03498063          	beq	s3,s4,800 <vprintf+0x88>
  for(i = 0; fmt[i]; i++){
 7e4:	00148493          	add	s1,s1,1
 7e8:	fff4c903          	lbu	s2,-1(s1)
 7ec:	1c090e63          	beqz	s2,9c8 <vprintf+0x250>
    if(state == 0){
 7f0:	fe0998e3          	bnez	s3,7e0 <vprintf+0x68>
      if(c == '%'){
 7f4:	fd491ce3          	bne	s2,s4,7cc <vprintf+0x54>
        state = '%';
 7f8:	000a0993          	mv	s3,s4
 7fc:	fe9ff06f          	j	7e4 <vprintf+0x6c>
      if(c == 'd'){
 800:	17490e63          	beq	s2,s4,97c <vprintf+0x204>
 804:	f9d9079b          	addw	a5,s2,-99
 808:	0ff7f793          	zext.b	a5,a5
 80c:	18fb6463          	bltu	s6,a5,994 <vprintf+0x21c>
 810:	f9d9079b          	addw	a5,s2,-99
 814:	0ff7f713          	zext.b	a4,a5
 818:	16eb6e63          	bltu	s6,a4,994 <vprintf+0x21c>
 81c:	00271793          	sll	a5,a4,0x2
 820:	00000717          	auipc	a4,0x0
 824:	4c070713          	add	a4,a4,1216 # ce0 <malloc+0x19c>
 828:	00e787b3          	add	a5,a5,a4
 82c:	0007a783          	lw	a5,0(a5)
 830:	00e787b3          	add	a5,a5,a4
 834:	00078067          	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 838:	008b8913          	add	s2,s7,8
 83c:	00100693          	li	a3,1
 840:	00a00613          	li	a2,10
 844:	000ba583          	lw	a1,0(s7)
 848:	000a8513          	mv	a0,s5
 84c:	00000097          	auipc	ra,0x0
 850:	e3c080e7          	jalr	-452(ra) # 688 <printint>
 854:	00090b93          	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 858:	00000993          	li	s3,0
 85c:	f89ff06f          	j	7e4 <vprintf+0x6c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 860:	008b8913          	add	s2,s7,8
 864:	00000693          	li	a3,0
 868:	00a00613          	li	a2,10
 86c:	000ba583          	lw	a1,0(s7)
 870:	000a8513          	mv	a0,s5
 874:	00000097          	auipc	ra,0x0
 878:	e14080e7          	jalr	-492(ra) # 688 <printint>
 87c:	00090b93          	mv	s7,s2
      state = 0;
 880:	00000993          	li	s3,0
 884:	f61ff06f          	j	7e4 <vprintf+0x6c>
        printint(fd, va_arg(ap, int), 16, 0);
 888:	008b8913          	add	s2,s7,8
 88c:	00000693          	li	a3,0
 890:	01000613          	li	a2,16
 894:	000ba583          	lw	a1,0(s7)
 898:	000a8513          	mv	a0,s5
 89c:	00000097          	auipc	ra,0x0
 8a0:	dec080e7          	jalr	-532(ra) # 688 <printint>
 8a4:	00090b93          	mv	s7,s2
      state = 0;
 8a8:	00000993          	li	s3,0
 8ac:	f39ff06f          	j	7e4 <vprintf+0x6c>
        printptr(fd, va_arg(ap, uint64));
 8b0:	008b8c13          	add	s8,s7,8
 8b4:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 8b8:	03000593          	li	a1,48
 8bc:	000a8513          	mv	a0,s5
 8c0:	00000097          	auipc	ra,0x0
 8c4:	d94080e7          	jalr	-620(ra) # 654 <putc>
  putc(fd, 'x');
 8c8:	07800593          	li	a1,120
 8cc:	000a8513          	mv	a0,s5
 8d0:	00000097          	auipc	ra,0x0
 8d4:	d84080e7          	jalr	-636(ra) # 654 <putc>
 8d8:	01000913          	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8dc:	00000b97          	auipc	s7,0x0
 8e0:	45cb8b93          	add	s7,s7,1116 # d38 <digits>
 8e4:	03c9d793          	srl	a5,s3,0x3c
 8e8:	00fb87b3          	add	a5,s7,a5
 8ec:	0007c583          	lbu	a1,0(a5)
 8f0:	000a8513          	mv	a0,s5
 8f4:	00000097          	auipc	ra,0x0
 8f8:	d60080e7          	jalr	-672(ra) # 654 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 8fc:	00499993          	sll	s3,s3,0x4
 900:	fff9091b          	addw	s2,s2,-1
 904:	fe0910e3          	bnez	s2,8e4 <vprintf+0x16c>
        printptr(fd, va_arg(ap, uint64));
 908:	000c0b93          	mv	s7,s8
      state = 0;
 90c:	00000993          	li	s3,0
 910:	ed5ff06f          	j	7e4 <vprintf+0x6c>
        s = va_arg(ap, char*);
 914:	008b8993          	add	s3,s7,8
 918:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 91c:	02090863          	beqz	s2,94c <vprintf+0x1d4>
        while(*s != 0){
 920:	00094583          	lbu	a1,0(s2)
 924:	08058c63          	beqz	a1,9bc <vprintf+0x244>
          putc(fd, *s);
 928:	000a8513          	mv	a0,s5
 92c:	00000097          	auipc	ra,0x0
 930:	d28080e7          	jalr	-728(ra) # 654 <putc>
          s++;
 934:	00190913          	add	s2,s2,1
        while(*s != 0){
 938:	00094583          	lbu	a1,0(s2)
 93c:	fe0596e3          	bnez	a1,928 <vprintf+0x1b0>
        s = va_arg(ap, char*);
 940:	00098b93          	mv	s7,s3
      state = 0;
 944:	00000993          	li	s3,0
 948:	e9dff06f          	j	7e4 <vprintf+0x6c>
          s = "(null)";
 94c:	00000917          	auipc	s2,0x0
 950:	38c90913          	add	s2,s2,908 # cd8 <malloc+0x194>
        while(*s != 0){
 954:	02800593          	li	a1,40
 958:	fd1ff06f          	j	928 <vprintf+0x1b0>
        putc(fd, va_arg(ap, uint));
 95c:	008b8913          	add	s2,s7,8
 960:	000bc583          	lbu	a1,0(s7)
 964:	000a8513          	mv	a0,s5
 968:	00000097          	auipc	ra,0x0
 96c:	cec080e7          	jalr	-788(ra) # 654 <putc>
 970:	00090b93          	mv	s7,s2
      state = 0;
 974:	00000993          	li	s3,0
 978:	e6dff06f          	j	7e4 <vprintf+0x6c>
        putc(fd, c);
 97c:	02500593          	li	a1,37
 980:	000a8513          	mv	a0,s5
 984:	00000097          	auipc	ra,0x0
 988:	cd0080e7          	jalr	-816(ra) # 654 <putc>
      state = 0;
 98c:	00000993          	li	s3,0
 990:	e55ff06f          	j	7e4 <vprintf+0x6c>
        putc(fd, '%');
 994:	02500593          	li	a1,37
 998:	000a8513          	mv	a0,s5
 99c:	00000097          	auipc	ra,0x0
 9a0:	cb8080e7          	jalr	-840(ra) # 654 <putc>
        putc(fd, c);
 9a4:	00090593          	mv	a1,s2
 9a8:	000a8513          	mv	a0,s5
 9ac:	00000097          	auipc	ra,0x0
 9b0:	ca8080e7          	jalr	-856(ra) # 654 <putc>
      state = 0;
 9b4:	00000993          	li	s3,0
 9b8:	e2dff06f          	j	7e4 <vprintf+0x6c>
        s = va_arg(ap, char*);
 9bc:	00098b93          	mv	s7,s3
      state = 0;
 9c0:	00000993          	li	s3,0
 9c4:	e21ff06f          	j	7e4 <vprintf+0x6c>
    }
  }
}
 9c8:	04813083          	ld	ra,72(sp)
 9cc:	04013403          	ld	s0,64(sp)
 9d0:	03813483          	ld	s1,56(sp)
 9d4:	03013903          	ld	s2,48(sp)
 9d8:	02813983          	ld	s3,40(sp)
 9dc:	02013a03          	ld	s4,32(sp)
 9e0:	01813a83          	ld	s5,24(sp)
 9e4:	01013b03          	ld	s6,16(sp)
 9e8:	00813b83          	ld	s7,8(sp)
 9ec:	00013c03          	ld	s8,0(sp)
 9f0:	05010113          	add	sp,sp,80
 9f4:	00008067          	ret

00000000000009f8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 9f8:	fb010113          	add	sp,sp,-80
 9fc:	00113c23          	sd	ra,24(sp)
 a00:	00813823          	sd	s0,16(sp)
 a04:	02010413          	add	s0,sp,32
 a08:	00c43023          	sd	a2,0(s0)
 a0c:	00d43423          	sd	a3,8(s0)
 a10:	00e43823          	sd	a4,16(s0)
 a14:	00f43c23          	sd	a5,24(s0)
 a18:	03043023          	sd	a6,32(s0)
 a1c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 a20:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 a24:	00040613          	mv	a2,s0
 a28:	00000097          	auipc	ra,0x0
 a2c:	d50080e7          	jalr	-688(ra) # 778 <vprintf>
}
 a30:	01813083          	ld	ra,24(sp)
 a34:	01013403          	ld	s0,16(sp)
 a38:	05010113          	add	sp,sp,80
 a3c:	00008067          	ret

0000000000000a40 <printf>:

void
printf(const char *fmt, ...)
{
 a40:	fa010113          	add	sp,sp,-96
 a44:	00113c23          	sd	ra,24(sp)
 a48:	00813823          	sd	s0,16(sp)
 a4c:	02010413          	add	s0,sp,32
 a50:	00b43423          	sd	a1,8(s0)
 a54:	00c43823          	sd	a2,16(s0)
 a58:	00d43c23          	sd	a3,24(s0)
 a5c:	02e43023          	sd	a4,32(s0)
 a60:	02f43423          	sd	a5,40(s0)
 a64:	03043823          	sd	a6,48(s0)
 a68:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a6c:	00840613          	add	a2,s0,8
 a70:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a74:	00050593          	mv	a1,a0
 a78:	00100513          	li	a0,1
 a7c:	00000097          	auipc	ra,0x0
 a80:	cfc080e7          	jalr	-772(ra) # 778 <vprintf>
}
 a84:	01813083          	ld	ra,24(sp)
 a88:	01013403          	ld	s0,16(sp)
 a8c:	06010113          	add	sp,sp,96
 a90:	00008067          	ret

0000000000000a94 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a94:	ff010113          	add	sp,sp,-16
 a98:	00813423          	sd	s0,8(sp)
 a9c:	01010413          	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 aa0:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 aa4:	00000797          	auipc	a5,0x0
 aa8:	55c7b783          	ld	a5,1372(a5) # 1000 <freep>
 aac:	0400006f          	j	aec <free+0x58>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 ab0:	00862703          	lw	a4,8(a2)
 ab4:	00b7073b          	addw	a4,a4,a1
 ab8:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 abc:	0007b703          	ld	a4,0(a5)
 ac0:	00073603          	ld	a2,0(a4)
 ac4:	0500006f          	j	b14 <free+0x80>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 ac8:	ff852703          	lw	a4,-8(a0)
 acc:	00c7073b          	addw	a4,a4,a2
 ad0:	00e7a423          	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 ad4:	ff053683          	ld	a3,-16(a0)
 ad8:	0540006f          	j	b2c <free+0x98>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 adc:	0007b703          	ld	a4,0(a5)
 ae0:	00e7e463          	bltu	a5,a4,ae8 <free+0x54>
 ae4:	00e6ec63          	bltu	a3,a4,afc <free+0x68>
{
 ae8:	00070793          	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 aec:	fed7f8e3          	bgeu	a5,a3,adc <free+0x48>
 af0:	0007b703          	ld	a4,0(a5)
 af4:	00e6e463          	bltu	a3,a4,afc <free+0x68>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 af8:	fee7e8e3          	bltu	a5,a4,ae8 <free+0x54>
  if(bp + bp->s.size == p->s.ptr){
 afc:	ff852583          	lw	a1,-8(a0)
 b00:	0007b603          	ld	a2,0(a5)
 b04:	02059813          	sll	a6,a1,0x20
 b08:	01c85713          	srl	a4,a6,0x1c
 b0c:	00e68733          	add	a4,a3,a4
 b10:	fae600e3          	beq	a2,a4,ab0 <free+0x1c>
    bp->s.ptr = p->s.ptr->s.ptr;
 b14:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 b18:	0087a603          	lw	a2,8(a5)
 b1c:	02061593          	sll	a1,a2,0x20
 b20:	01c5d713          	srl	a4,a1,0x1c
 b24:	00e78733          	add	a4,a5,a4
 b28:	fae680e3          	beq	a3,a4,ac8 <free+0x34>
    p->s.ptr = bp->s.ptr;
 b2c:	00d7b023          	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 b30:	00000717          	auipc	a4,0x0
 b34:	4cf73823          	sd	a5,1232(a4) # 1000 <freep>
}
 b38:	00813403          	ld	s0,8(sp)
 b3c:	01010113          	add	sp,sp,16
 b40:	00008067          	ret

0000000000000b44 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b44:	fc010113          	add	sp,sp,-64
 b48:	02113c23          	sd	ra,56(sp)
 b4c:	02813823          	sd	s0,48(sp)
 b50:	02913423          	sd	s1,40(sp)
 b54:	03213023          	sd	s2,32(sp)
 b58:	01313c23          	sd	s3,24(sp)
 b5c:	01413823          	sd	s4,16(sp)
 b60:	01513423          	sd	s5,8(sp)
 b64:	01613023          	sd	s6,0(sp)
 b68:	04010413          	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b6c:	02051493          	sll	s1,a0,0x20
 b70:	0204d493          	srl	s1,s1,0x20
 b74:	00f48493          	add	s1,s1,15
 b78:	0044d493          	srl	s1,s1,0x4
 b7c:	0014899b          	addw	s3,s1,1
 b80:	00148493          	add	s1,s1,1
  if((prevp = freep) == 0){
 b84:	00000517          	auipc	a0,0x0
 b88:	47c53503          	ld	a0,1148(a0) # 1000 <freep>
 b8c:	02050e63          	beqz	a0,bc8 <malloc+0x84>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b90:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b94:	0087a703          	lw	a4,8(a5)
 b98:	04977663          	bgeu	a4,s1,be4 <malloc+0xa0>
  if(nu < 4096)
 b9c:	00098a13          	mv	s4,s3
 ba0:	0009871b          	sext.w	a4,s3
 ba4:	000016b7          	lui	a3,0x1
 ba8:	00d77463          	bgeu	a4,a3,bb0 <malloc+0x6c>
 bac:	00001a37          	lui	s4,0x1
 bb0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 bb4:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 bb8:	00000917          	auipc	s2,0x0
 bbc:	44890913          	add	s2,s2,1096 # 1000 <freep>
  if(p == (char*)-1)
 bc0:	fff00a93          	li	s5,-1
 bc4:	0a00006f          	j	c64 <malloc+0x120>
    base.s.ptr = freep = prevp = &base;
 bc8:	00000797          	auipc	a5,0x0
 bcc:	64878793          	add	a5,a5,1608 # 1210 <base>
 bd0:	00000717          	auipc	a4,0x0
 bd4:	42f73823          	sd	a5,1072(a4) # 1000 <freep>
 bd8:	00f7b023          	sd	a5,0(a5)
    base.s.size = 0;
 bdc:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 be0:	fbdff06f          	j	b9c <malloc+0x58>
      if(p->s.size == nunits)
 be4:	04e48863          	beq	s1,a4,c34 <malloc+0xf0>
        p->s.size -= nunits;
 be8:	4137073b          	subw	a4,a4,s3
 bec:	00e7a423          	sw	a4,8(a5)
        p += p->s.size;
 bf0:	02071693          	sll	a3,a4,0x20
 bf4:	01c6d713          	srl	a4,a3,0x1c
 bf8:	00e787b3          	add	a5,a5,a4
        p->s.size = nunits;
 bfc:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 c00:	00000717          	auipc	a4,0x0
 c04:	40a73023          	sd	a0,1024(a4) # 1000 <freep>
      return (void*)(p + 1);
 c08:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 c0c:	03813083          	ld	ra,56(sp)
 c10:	03013403          	ld	s0,48(sp)
 c14:	02813483          	ld	s1,40(sp)
 c18:	02013903          	ld	s2,32(sp)
 c1c:	01813983          	ld	s3,24(sp)
 c20:	01013a03          	ld	s4,16(sp)
 c24:	00813a83          	ld	s5,8(sp)
 c28:	00013b03          	ld	s6,0(sp)
 c2c:	04010113          	add	sp,sp,64
 c30:	00008067          	ret
        prevp->s.ptr = p->s.ptr;
 c34:	0007b703          	ld	a4,0(a5)
 c38:	00e53023          	sd	a4,0(a0)
 c3c:	fc5ff06f          	j	c00 <malloc+0xbc>
  hp->s.size = nu;
 c40:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 c44:	01050513          	add	a0,a0,16
 c48:	00000097          	auipc	ra,0x0
 c4c:	e4c080e7          	jalr	-436(ra) # a94 <free>
  return freep;
 c50:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 c54:	fa050ce3          	beqz	a0,c0c <malloc+0xc8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c58:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
 c5c:	0087a703          	lw	a4,8(a5)
 c60:	f89772e3          	bgeu	a4,s1,be4 <malloc+0xa0>
    if(p == freep)
 c64:	00093703          	ld	a4,0(s2)
 c68:	00078513          	mv	a0,a5
 c6c:	fef716e3          	bne	a4,a5,c58 <malloc+0x114>
  p = sbrk(nu * sizeof(Header));
 c70:	000a0513          	mv	a0,s4
 c74:	00000097          	auipc	ra,0x0
 c78:	9bc080e7          	jalr	-1604(ra) # 630 <sbrk>
  if(p == (char*)-1)
 c7c:	fd5512e3          	bne	a0,s5,c40 <malloc+0xfc>
        return 0;
 c80:	00000513          	li	a0,0
 c84:	f89ff06f          	j	c0c <malloc+0xc8>
