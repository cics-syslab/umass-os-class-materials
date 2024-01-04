
user/_grep:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
   0:	fd010113          	add	sp,sp,-48
   4:	02113423          	sd	ra,40(sp)
   8:	02813023          	sd	s0,32(sp)
   c:	00913c23          	sd	s1,24(sp)
  10:	01213823          	sd	s2,16(sp)
  14:	01313423          	sd	s3,8(sp)
  18:	01413023          	sd	s4,0(sp)
  1c:	03010413          	add	s0,sp,48
  20:	00050913          	mv	s2,a0
  24:	00058993          	mv	s3,a1
  28:	00060493          	mv	s1,a2
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  2c:	02e00a13          	li	s4,46
    if(matchhere(re, text))
  30:	00048593          	mv	a1,s1
  34:	00098513          	mv	a0,s3
  38:	00000097          	auipc	ra,0x0
  3c:	04c080e7          	jalr	76(ra) # 84 <matchhere>
  40:	02051063          	bnez	a0,60 <matchstar+0x60>
  }while(*text!='\0' && (*text++==c || c=='.'));
  44:	0004c783          	lbu	a5,0(s1)
  48:	00078e63          	beqz	a5,64 <matchstar+0x64>
  4c:	00148493          	add	s1,s1,1
  50:	0007879b          	sext.w	a5,a5
  54:	fd278ee3          	beq	a5,s2,30 <matchstar+0x30>
  58:	fd490ce3          	beq	s2,s4,30 <matchstar+0x30>
  5c:	0080006f          	j	64 <matchstar+0x64>
      return 1;
  60:	00100513          	li	a0,1
  return 0;
}
  64:	02813083          	ld	ra,40(sp)
  68:	02013403          	ld	s0,32(sp)
  6c:	01813483          	ld	s1,24(sp)
  70:	01013903          	ld	s2,16(sp)
  74:	00813983          	ld	s3,8(sp)
  78:	00013a03          	ld	s4,0(sp)
  7c:	03010113          	add	sp,sp,48
  80:	00008067          	ret

0000000000000084 <matchhere>:
  if(re[0] == '\0')
  84:	00054703          	lbu	a4,0(a0)
  88:	0a070263          	beqz	a4,12c <matchhere+0xa8>
{
  8c:	ff010113          	add	sp,sp,-16
  90:	00113423          	sd	ra,8(sp)
  94:	00813023          	sd	s0,0(sp)
  98:	01010413          	add	s0,sp,16
  9c:	00050793          	mv	a5,a0
  if(re[1] == '*')
  a0:	00154683          	lbu	a3,1(a0)
  a4:	02a00613          	li	a2,42
  a8:	02c68c63          	beq	a3,a2,e0 <matchhere+0x5c>
  if(re[0] == '$' && re[1] == '\0')
  ac:	02400613          	li	a2,36
  b0:	04c70463          	beq	a4,a2,f8 <matchhere+0x74>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  b4:	0005c683          	lbu	a3,0(a1)
  return 0;
  b8:	00000513          	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  bc:	00068a63          	beqz	a3,d0 <matchhere+0x4c>
  c0:	02e00613          	li	a2,46
  c4:	04c70a63          	beq	a4,a2,118 <matchhere+0x94>
  return 0;
  c8:	00000513          	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  cc:	04d70663          	beq	a4,a3,118 <matchhere+0x94>
}
  d0:	00813083          	ld	ra,8(sp)
  d4:	00013403          	ld	s0,0(sp)
  d8:	01010113          	add	sp,sp,16
  dc:	00008067          	ret
    return matchstar(re[0], re+2, text);
  e0:	00058613          	mv	a2,a1
  e4:	00250593          	add	a1,a0,2
  e8:	00070513          	mv	a0,a4
  ec:	00000097          	auipc	ra,0x0
  f0:	f14080e7          	jalr	-236(ra) # 0 <matchstar>
  f4:	fddff06f          	j	d0 <matchhere+0x4c>
  if(re[0] == '$' && re[1] == '\0')
  f8:	00068a63          	beqz	a3,10c <matchhere+0x88>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  fc:	0005c683          	lbu	a3,0(a1)
 100:	fc0694e3          	bnez	a3,c8 <matchhere+0x44>
  return 0;
 104:	00000513          	li	a0,0
 108:	fc9ff06f          	j	d0 <matchhere+0x4c>
    return *text == '\0';
 10c:	0005c503          	lbu	a0,0(a1)
 110:	00153513          	seqz	a0,a0
 114:	fbdff06f          	j	d0 <matchhere+0x4c>
    return matchhere(re+1, text+1);
 118:	00158593          	add	a1,a1,1
 11c:	00178513          	add	a0,a5,1
 120:	00000097          	auipc	ra,0x0
 124:	f64080e7          	jalr	-156(ra) # 84 <matchhere>
 128:	fa9ff06f          	j	d0 <matchhere+0x4c>
    return 1;
 12c:	00100513          	li	a0,1
}
 130:	00008067          	ret

0000000000000134 <match>:
{
 134:	fe010113          	add	sp,sp,-32
 138:	00113c23          	sd	ra,24(sp)
 13c:	00813823          	sd	s0,16(sp)
 140:	00913423          	sd	s1,8(sp)
 144:	01213023          	sd	s2,0(sp)
 148:	02010413          	add	s0,sp,32
 14c:	00050913          	mv	s2,a0
 150:	00058493          	mv	s1,a1
  if(re[0] == '^')
 154:	00054703          	lbu	a4,0(a0)
 158:	05e00793          	li	a5,94
 15c:	02f70463          	beq	a4,a5,184 <match+0x50>
    if(matchhere(re, text))
 160:	00048593          	mv	a1,s1
 164:	00090513          	mv	a0,s2
 168:	00000097          	auipc	ra,0x0
 16c:	f1c080e7          	jalr	-228(ra) # 84 <matchhere>
 170:	02051263          	bnez	a0,194 <match+0x60>
  }while(*text++ != '\0');
 174:	00148493          	add	s1,s1,1
 178:	fff4c783          	lbu	a5,-1(s1)
 17c:	fe0792e3          	bnez	a5,160 <match+0x2c>
 180:	0180006f          	j	198 <match+0x64>
    return matchhere(re+1, text);
 184:	00150513          	add	a0,a0,1
 188:	00000097          	auipc	ra,0x0
 18c:	efc080e7          	jalr	-260(ra) # 84 <matchhere>
 190:	0080006f          	j	198 <match+0x64>
      return 1;
 194:	00100513          	li	a0,1
}
 198:	01813083          	ld	ra,24(sp)
 19c:	01013403          	ld	s0,16(sp)
 1a0:	00813483          	ld	s1,8(sp)
 1a4:	00013903          	ld	s2,0(sp)
 1a8:	02010113          	add	sp,sp,32
 1ac:	00008067          	ret

00000000000001b0 <grep>:
{
 1b0:	fb010113          	add	sp,sp,-80
 1b4:	04113423          	sd	ra,72(sp)
 1b8:	04813023          	sd	s0,64(sp)
 1bc:	02913c23          	sd	s1,56(sp)
 1c0:	03213823          	sd	s2,48(sp)
 1c4:	03313423          	sd	s3,40(sp)
 1c8:	03413023          	sd	s4,32(sp)
 1cc:	01513c23          	sd	s5,24(sp)
 1d0:	01613823          	sd	s6,16(sp)
 1d4:	01713423          	sd	s7,8(sp)
 1d8:	01813023          	sd	s8,0(sp)
 1dc:	05010413          	add	s0,sp,80
 1e0:	00050993          	mv	s3,a0
 1e4:	00058b13          	mv	s6,a1
  m = 0;
 1e8:	00000a13          	li	s4,0
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 1ec:	3ff00b93          	li	s7,1023
 1f0:	00001a97          	auipc	s5,0x1
 1f4:	e20a8a93          	add	s5,s5,-480 # 1010 <buf>
 1f8:	0600006f          	j	258 <grep+0xa8>
      p = q+1;
 1fc:	00148913          	add	s2,s1,1
    while((q = strchr(p, '\n')) != 0){
 200:	00a00593          	li	a1,10
 204:	00090513          	mv	a0,s2
 208:	00000097          	auipc	ra,0x0
 20c:	2d8080e7          	jalr	728(ra) # 4e0 <strchr>
 210:	00050493          	mv	s1,a0
 214:	04050063          	beqz	a0,254 <grep+0xa4>
      *q = 0;
 218:	00048023          	sb	zero,0(s1)
      if(match(pattern, p)){
 21c:	00090593          	mv	a1,s2
 220:	00098513          	mv	a0,s3
 224:	00000097          	auipc	ra,0x0
 228:	f10080e7          	jalr	-240(ra) # 134 <match>
 22c:	fc0508e3          	beqz	a0,1fc <grep+0x4c>
        *q = '\n';
 230:	00a00793          	li	a5,10
 234:	00f48023          	sb	a5,0(s1)
        write(1, p, q+1 - p);
 238:	00148613          	add	a2,s1,1
 23c:	4126063b          	subw	a2,a2,s2
 240:	00090593          	mv	a1,s2
 244:	00100513          	li	a0,1
 248:	00000097          	auipc	ra,0x0
 24c:	5a4080e7          	jalr	1444(ra) # 7ec <write>
 250:	fadff06f          	j	1fc <grep+0x4c>
    if(m > 0){
 254:	03404a63          	bgtz	s4,288 <grep+0xd8>
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 258:	414b863b          	subw	a2,s7,s4
 25c:	014a85b3          	add	a1,s5,s4
 260:	000b0513          	mv	a0,s6
 264:	00000097          	auipc	ra,0x0
 268:	57c080e7          	jalr	1404(ra) # 7e0 <read>
 26c:	04a05063          	blez	a0,2ac <grep+0xfc>
    m += n;
 270:	00aa0c3b          	addw	s8,s4,a0
 274:	000c0a1b          	sext.w	s4,s8
    buf[m] = '\0';
 278:	014a87b3          	add	a5,s5,s4
 27c:	00078023          	sb	zero,0(a5)
    p = buf;
 280:	000a8913          	mv	s2,s5
    while((q = strchr(p, '\n')) != 0){
 284:	f7dff06f          	j	200 <grep+0x50>
      m -= p - buf;
 288:	00001517          	auipc	a0,0x1
 28c:	d8850513          	add	a0,a0,-632 # 1010 <buf>
 290:	40a90a33          	sub	s4,s2,a0
 294:	414c0a3b          	subw	s4,s8,s4
      memmove(buf, p, m);
 298:	000a0613          	mv	a2,s4
 29c:	00090593          	mv	a1,s2
 2a0:	00000097          	auipc	ra,0x0
 2a4:	410080e7          	jalr	1040(ra) # 6b0 <memmove>
 2a8:	fb1ff06f          	j	258 <grep+0xa8>
}
 2ac:	04813083          	ld	ra,72(sp)
 2b0:	04013403          	ld	s0,64(sp)
 2b4:	03813483          	ld	s1,56(sp)
 2b8:	03013903          	ld	s2,48(sp)
 2bc:	02813983          	ld	s3,40(sp)
 2c0:	02013a03          	ld	s4,32(sp)
 2c4:	01813a83          	ld	s5,24(sp)
 2c8:	01013b03          	ld	s6,16(sp)
 2cc:	00813b83          	ld	s7,8(sp)
 2d0:	00013c03          	ld	s8,0(sp)
 2d4:	05010113          	add	sp,sp,80
 2d8:	00008067          	ret

00000000000002dc <main>:
{
 2dc:	fd010113          	add	sp,sp,-48
 2e0:	02113423          	sd	ra,40(sp)
 2e4:	02813023          	sd	s0,32(sp)
 2e8:	00913c23          	sd	s1,24(sp)
 2ec:	01213823          	sd	s2,16(sp)
 2f0:	01313423          	sd	s3,8(sp)
 2f4:	01413023          	sd	s4,0(sp)
 2f8:	03010413          	add	s0,sp,48
  if(argc <= 1){
 2fc:	00100793          	li	a5,1
 300:	06a7d863          	bge	a5,a0,370 <main+0x94>
  pattern = argv[1];
 304:	0085ba03          	ld	s4,8(a1)
  if(argc <= 2){
 308:	00200793          	li	a5,2
 30c:	08a7d263          	bge	a5,a0,390 <main+0xb4>
 310:	01058913          	add	s2,a1,16
 314:	ffd5099b          	addw	s3,a0,-3
 318:	02099793          	sll	a5,s3,0x20
 31c:	01d7d993          	srl	s3,a5,0x1d
 320:	01858593          	add	a1,a1,24
 324:	00b989b3          	add	s3,s3,a1
    if((fd = open(argv[i], 0)) < 0){
 328:	00000593          	li	a1,0
 32c:	00093503          	ld	a0,0(s2)
 330:	00000097          	auipc	ra,0x0
 334:	4ec080e7          	jalr	1260(ra) # 81c <open>
 338:	00050493          	mv	s1,a0
 33c:	06054863          	bltz	a0,3ac <main+0xd0>
    grep(pattern, fd);
 340:	00050593          	mv	a1,a0
 344:	000a0513          	mv	a0,s4
 348:	00000097          	auipc	ra,0x0
 34c:	e68080e7          	jalr	-408(ra) # 1b0 <grep>
    close(fd);
 350:	00048513          	mv	a0,s1
 354:	00000097          	auipc	ra,0x0
 358:	4a4080e7          	jalr	1188(ra) # 7f8 <close>
  for(i = 2; i < argc; i++){
 35c:	00890913          	add	s2,s2,8
 360:	fd3914e3          	bne	s2,s3,328 <main+0x4c>
  exit(0);
 364:	00000513          	li	a0,0
 368:	00000097          	auipc	ra,0x0
 36c:	454080e7          	jalr	1108(ra) # 7bc <exit>
    fprintf(2, "usage: grep pattern [file ...]\n");
 370:	00001597          	auipc	a1,0x1
 374:	b7058593          	add	a1,a1,-1168 # ee0 <malloc+0x144>
 378:	00200513          	li	a0,2
 37c:	00001097          	auipc	ra,0x1
 380:	8d4080e7          	jalr	-1836(ra) # c50 <fprintf>
    exit(1);
 384:	00100513          	li	a0,1
 388:	00000097          	auipc	ra,0x0
 38c:	434080e7          	jalr	1076(ra) # 7bc <exit>
    grep(pattern, 0);
 390:	00000593          	li	a1,0
 394:	000a0513          	mv	a0,s4
 398:	00000097          	auipc	ra,0x0
 39c:	e18080e7          	jalr	-488(ra) # 1b0 <grep>
    exit(0);
 3a0:	00000513          	li	a0,0
 3a4:	00000097          	auipc	ra,0x0
 3a8:	418080e7          	jalr	1048(ra) # 7bc <exit>
      printf("grep: cannot open %s\n", argv[i]);
 3ac:	00093583          	ld	a1,0(s2)
 3b0:	00001517          	auipc	a0,0x1
 3b4:	b5050513          	add	a0,a0,-1200 # f00 <malloc+0x164>
 3b8:	00001097          	auipc	ra,0x1
 3bc:	8e0080e7          	jalr	-1824(ra) # c98 <printf>
      exit(1);
 3c0:	00100513          	li	a0,1
 3c4:	00000097          	auipc	ra,0x0
 3c8:	3f8080e7          	jalr	1016(ra) # 7bc <exit>

00000000000003cc <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 3cc:	ff010113          	add	sp,sp,-16
 3d0:	00113423          	sd	ra,8(sp)
 3d4:	00813023          	sd	s0,0(sp)
 3d8:	01010413          	add	s0,sp,16
  extern int main();
  main();
 3dc:	00000097          	auipc	ra,0x0
 3e0:	f00080e7          	jalr	-256(ra) # 2dc <main>
  exit(0);
 3e4:	00000513          	li	a0,0
 3e8:	00000097          	auipc	ra,0x0
 3ec:	3d4080e7          	jalr	980(ra) # 7bc <exit>

00000000000003f0 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 3f0:	ff010113          	add	sp,sp,-16
 3f4:	00813423          	sd	s0,8(sp)
 3f8:	01010413          	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 3fc:	00050793          	mv	a5,a0
 400:	00158593          	add	a1,a1,1
 404:	00178793          	add	a5,a5,1
 408:	fff5c703          	lbu	a4,-1(a1)
 40c:	fee78fa3          	sb	a4,-1(a5)
 410:	fe0718e3          	bnez	a4,400 <strcpy+0x10>
    ;
  return os;
}
 414:	00813403          	ld	s0,8(sp)
 418:	01010113          	add	sp,sp,16
 41c:	00008067          	ret

0000000000000420 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 420:	ff010113          	add	sp,sp,-16
 424:	00813423          	sd	s0,8(sp)
 428:	01010413          	add	s0,sp,16
  while(*p && *p == *q)
 42c:	00054783          	lbu	a5,0(a0)
 430:	00078e63          	beqz	a5,44c <strcmp+0x2c>
 434:	0005c703          	lbu	a4,0(a1)
 438:	00f71a63          	bne	a4,a5,44c <strcmp+0x2c>
    p++, q++;
 43c:	00150513          	add	a0,a0,1
 440:	00158593          	add	a1,a1,1
  while(*p && *p == *q)
 444:	00054783          	lbu	a5,0(a0)
 448:	fe0796e3          	bnez	a5,434 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 44c:	0005c503          	lbu	a0,0(a1)
}
 450:	40a7853b          	subw	a0,a5,a0
 454:	00813403          	ld	s0,8(sp)
 458:	01010113          	add	sp,sp,16
 45c:	00008067          	ret

0000000000000460 <strlen>:

uint
strlen(const char *s)
{
 460:	ff010113          	add	sp,sp,-16
 464:	00813423          	sd	s0,8(sp)
 468:	01010413          	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 46c:	00054783          	lbu	a5,0(a0)
 470:	02078863          	beqz	a5,4a0 <strlen+0x40>
 474:	00150513          	add	a0,a0,1
 478:	00050793          	mv	a5,a0
 47c:	00078693          	mv	a3,a5
 480:	00178793          	add	a5,a5,1
 484:	fff7c703          	lbu	a4,-1(a5)
 488:	fe071ae3          	bnez	a4,47c <strlen+0x1c>
 48c:	40a6853b          	subw	a0,a3,a0
 490:	0015051b          	addw	a0,a0,1
    ;
  return n;
}
 494:	00813403          	ld	s0,8(sp)
 498:	01010113          	add	sp,sp,16
 49c:	00008067          	ret
  for(n = 0; s[n]; n++)
 4a0:	00000513          	li	a0,0
 4a4:	ff1ff06f          	j	494 <strlen+0x34>

00000000000004a8 <memset>:

void*
memset(void *dst, int c, uint n)
{
 4a8:	ff010113          	add	sp,sp,-16
 4ac:	00813423          	sd	s0,8(sp)
 4b0:	01010413          	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 4b4:	02060063          	beqz	a2,4d4 <memset+0x2c>
 4b8:	00050793          	mv	a5,a0
 4bc:	02061613          	sll	a2,a2,0x20
 4c0:	02065613          	srl	a2,a2,0x20
 4c4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 4c8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 4cc:	00178793          	add	a5,a5,1
 4d0:	fee79ce3          	bne	a5,a4,4c8 <memset+0x20>
  }
  return dst;
}
 4d4:	00813403          	ld	s0,8(sp)
 4d8:	01010113          	add	sp,sp,16
 4dc:	00008067          	ret

00000000000004e0 <strchr>:

char*
strchr(const char *s, char c)
{
 4e0:	ff010113          	add	sp,sp,-16
 4e4:	00813423          	sd	s0,8(sp)
 4e8:	01010413          	add	s0,sp,16
  for(; *s; s++)
 4ec:	00054783          	lbu	a5,0(a0)
 4f0:	02078263          	beqz	a5,514 <strchr+0x34>
    if(*s == c)
 4f4:	00f58a63          	beq	a1,a5,508 <strchr+0x28>
  for(; *s; s++)
 4f8:	00150513          	add	a0,a0,1
 4fc:	00054783          	lbu	a5,0(a0)
 500:	fe079ae3          	bnez	a5,4f4 <strchr+0x14>
      return (char*)s;
  return 0;
 504:	00000513          	li	a0,0
}
 508:	00813403          	ld	s0,8(sp)
 50c:	01010113          	add	sp,sp,16
 510:	00008067          	ret
  return 0;
 514:	00000513          	li	a0,0
 518:	ff1ff06f          	j	508 <strchr+0x28>

000000000000051c <gets>:

char*
gets(char *buf, int max)
{
 51c:	fa010113          	add	sp,sp,-96
 520:	04113c23          	sd	ra,88(sp)
 524:	04813823          	sd	s0,80(sp)
 528:	04913423          	sd	s1,72(sp)
 52c:	05213023          	sd	s2,64(sp)
 530:	03313c23          	sd	s3,56(sp)
 534:	03413823          	sd	s4,48(sp)
 538:	03513423          	sd	s5,40(sp)
 53c:	03613023          	sd	s6,32(sp)
 540:	01713c23          	sd	s7,24(sp)
 544:	06010413          	add	s0,sp,96
 548:	00050b93          	mv	s7,a0
 54c:	00058a13          	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 550:	00050913          	mv	s2,a0
 554:	00000493          	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 558:	00a00a93          	li	s5,10
 55c:	00d00b13          	li	s6,13
  for(i=0; i+1 < max; ){
 560:	00048993          	mv	s3,s1
 564:	0014849b          	addw	s1,s1,1
 568:	0344de63          	bge	s1,s4,5a4 <gets+0x88>
    cc = read(0, &c, 1);
 56c:	00100613          	li	a2,1
 570:	faf40593          	add	a1,s0,-81
 574:	00000513          	li	a0,0
 578:	00000097          	auipc	ra,0x0
 57c:	268080e7          	jalr	616(ra) # 7e0 <read>
    if(cc < 1)
 580:	02a05263          	blez	a0,5a4 <gets+0x88>
    buf[i++] = c;
 584:	faf44783          	lbu	a5,-81(s0)
 588:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 58c:	01578a63          	beq	a5,s5,5a0 <gets+0x84>
 590:	00190913          	add	s2,s2,1
 594:	fd6796e3          	bne	a5,s6,560 <gets+0x44>
  for(i=0; i+1 < max; ){
 598:	00048993          	mv	s3,s1
 59c:	0080006f          	j	5a4 <gets+0x88>
 5a0:	00048993          	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 5a4:	013b89b3          	add	s3,s7,s3
 5a8:	00098023          	sb	zero,0(s3)
  return buf;
}
 5ac:	000b8513          	mv	a0,s7
 5b0:	05813083          	ld	ra,88(sp)
 5b4:	05013403          	ld	s0,80(sp)
 5b8:	04813483          	ld	s1,72(sp)
 5bc:	04013903          	ld	s2,64(sp)
 5c0:	03813983          	ld	s3,56(sp)
 5c4:	03013a03          	ld	s4,48(sp)
 5c8:	02813a83          	ld	s5,40(sp)
 5cc:	02013b03          	ld	s6,32(sp)
 5d0:	01813b83          	ld	s7,24(sp)
 5d4:	06010113          	add	sp,sp,96
 5d8:	00008067          	ret

00000000000005dc <stat>:

int
stat(const char *n, struct stat *st)
{
 5dc:	fe010113          	add	sp,sp,-32
 5e0:	00113c23          	sd	ra,24(sp)
 5e4:	00813823          	sd	s0,16(sp)
 5e8:	00913423          	sd	s1,8(sp)
 5ec:	01213023          	sd	s2,0(sp)
 5f0:	02010413          	add	s0,sp,32
 5f4:	00058913          	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 5f8:	00000593          	li	a1,0
 5fc:	00000097          	auipc	ra,0x0
 600:	220080e7          	jalr	544(ra) # 81c <open>
  if(fd < 0)
 604:	04054063          	bltz	a0,644 <stat+0x68>
 608:	00050493          	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 60c:	00090593          	mv	a1,s2
 610:	00000097          	auipc	ra,0x0
 614:	230080e7          	jalr	560(ra) # 840 <fstat>
 618:	00050913          	mv	s2,a0
  close(fd);
 61c:	00048513          	mv	a0,s1
 620:	00000097          	auipc	ra,0x0
 624:	1d8080e7          	jalr	472(ra) # 7f8 <close>
  return r;
}
 628:	00090513          	mv	a0,s2
 62c:	01813083          	ld	ra,24(sp)
 630:	01013403          	ld	s0,16(sp)
 634:	00813483          	ld	s1,8(sp)
 638:	00013903          	ld	s2,0(sp)
 63c:	02010113          	add	sp,sp,32
 640:	00008067          	ret
    return -1;
 644:	fff00913          	li	s2,-1
 648:	fe1ff06f          	j	628 <stat+0x4c>

000000000000064c <atoi>:

int
atoi(const char *s)
{
 64c:	ff010113          	add	sp,sp,-16
 650:	00813423          	sd	s0,8(sp)
 654:	01010413          	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 658:	00054683          	lbu	a3,0(a0)
 65c:	fd06879b          	addw	a5,a3,-48
 660:	0ff7f793          	zext.b	a5,a5
 664:	00900613          	li	a2,9
 668:	04f66063          	bltu	a2,a5,6a8 <atoi+0x5c>
 66c:	00050713          	mv	a4,a0
  n = 0;
 670:	00000513          	li	a0,0
    n = n*10 + *s++ - '0';
 674:	00170713          	add	a4,a4,1
 678:	0025179b          	sllw	a5,a0,0x2
 67c:	00a787bb          	addw	a5,a5,a0
 680:	0017979b          	sllw	a5,a5,0x1
 684:	00d787bb          	addw	a5,a5,a3
 688:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 68c:	00074683          	lbu	a3,0(a4)
 690:	fd06879b          	addw	a5,a3,-48
 694:	0ff7f793          	zext.b	a5,a5
 698:	fcf67ee3          	bgeu	a2,a5,674 <atoi+0x28>
  return n;
}
 69c:	00813403          	ld	s0,8(sp)
 6a0:	01010113          	add	sp,sp,16
 6a4:	00008067          	ret
  n = 0;
 6a8:	00000513          	li	a0,0
 6ac:	ff1ff06f          	j	69c <atoi+0x50>

00000000000006b0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 6b0:	ff010113          	add	sp,sp,-16
 6b4:	00813423          	sd	s0,8(sp)
 6b8:	01010413          	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 6bc:	02b57c63          	bgeu	a0,a1,6f4 <memmove+0x44>
    while(n-- > 0)
 6c0:	02c05463          	blez	a2,6e8 <memmove+0x38>
 6c4:	02061613          	sll	a2,a2,0x20
 6c8:	02065613          	srl	a2,a2,0x20
 6cc:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 6d0:	00050713          	mv	a4,a0
      *dst++ = *src++;
 6d4:	00158593          	add	a1,a1,1
 6d8:	00170713          	add	a4,a4,1
 6dc:	fff5c683          	lbu	a3,-1(a1)
 6e0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 6e4:	fee798e3          	bne	a5,a4,6d4 <memmove+0x24>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 6e8:	00813403          	ld	s0,8(sp)
 6ec:	01010113          	add	sp,sp,16
 6f0:	00008067          	ret
    dst += n;
 6f4:	00c50733          	add	a4,a0,a2
    src += n;
 6f8:	00c585b3          	add	a1,a1,a2
    while(n-- > 0)
 6fc:	fec056e3          	blez	a2,6e8 <memmove+0x38>
 700:	fff6079b          	addw	a5,a2,-1
 704:	02079793          	sll	a5,a5,0x20
 708:	0207d793          	srl	a5,a5,0x20
 70c:	fff7c793          	not	a5,a5
 710:	00f707b3          	add	a5,a4,a5
      *--dst = *--src;
 714:	fff58593          	add	a1,a1,-1
 718:	fff70713          	add	a4,a4,-1
 71c:	0005c683          	lbu	a3,0(a1)
 720:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 724:	fee798e3          	bne	a5,a4,714 <memmove+0x64>
 728:	fc1ff06f          	j	6e8 <memmove+0x38>

000000000000072c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 72c:	ff010113          	add	sp,sp,-16
 730:	00813423          	sd	s0,8(sp)
 734:	01010413          	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 738:	04060463          	beqz	a2,780 <memcmp+0x54>
 73c:	fff6069b          	addw	a3,a2,-1
 740:	02069693          	sll	a3,a3,0x20
 744:	0206d693          	srl	a3,a3,0x20
 748:	00168693          	add	a3,a3,1
 74c:	00d506b3          	add	a3,a0,a3
    if (*p1 != *p2) {
 750:	00054783          	lbu	a5,0(a0)
 754:	0005c703          	lbu	a4,0(a1)
 758:	00e79c63          	bne	a5,a4,770 <memcmp+0x44>
      return *p1 - *p2;
    }
    p1++;
 75c:	00150513          	add	a0,a0,1
    p2++;
 760:	00158593          	add	a1,a1,1
  while (n-- > 0) {
 764:	fed516e3          	bne	a0,a3,750 <memcmp+0x24>
  }
  return 0;
 768:	00000513          	li	a0,0
 76c:	0080006f          	j	774 <memcmp+0x48>
      return *p1 - *p2;
 770:	40e7853b          	subw	a0,a5,a4
}
 774:	00813403          	ld	s0,8(sp)
 778:	01010113          	add	sp,sp,16
 77c:	00008067          	ret
  return 0;
 780:	00000513          	li	a0,0
 784:	ff1ff06f          	j	774 <memcmp+0x48>

0000000000000788 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 788:	ff010113          	add	sp,sp,-16
 78c:	00113423          	sd	ra,8(sp)
 790:	00813023          	sd	s0,0(sp)
 794:	01010413          	add	s0,sp,16
  return memmove(dst, src, n);
 798:	00000097          	auipc	ra,0x0
 79c:	f18080e7          	jalr	-232(ra) # 6b0 <memmove>
}
 7a0:	00813083          	ld	ra,8(sp)
 7a4:	00013403          	ld	s0,0(sp)
 7a8:	01010113          	add	sp,sp,16
 7ac:	00008067          	ret

00000000000007b0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 7b0:	00100893          	li	a7,1
 ecall
 7b4:	00000073          	ecall
 ret
 7b8:	00008067          	ret

00000000000007bc <exit>:
.global exit
exit:
 li a7, SYS_exit
 7bc:	00200893          	li	a7,2
 ecall
 7c0:	00000073          	ecall
 ret
 7c4:	00008067          	ret

00000000000007c8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 7c8:	00300893          	li	a7,3
 ecall
 7cc:	00000073          	ecall
 ret
 7d0:	00008067          	ret

00000000000007d4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 7d4:	00400893          	li	a7,4
 ecall
 7d8:	00000073          	ecall
 ret
 7dc:	00008067          	ret

00000000000007e0 <read>:
.global read
read:
 li a7, SYS_read
 7e0:	00500893          	li	a7,5
 ecall
 7e4:	00000073          	ecall
 ret
 7e8:	00008067          	ret

00000000000007ec <write>:
.global write
write:
 li a7, SYS_write
 7ec:	01000893          	li	a7,16
 ecall
 7f0:	00000073          	ecall
 ret
 7f4:	00008067          	ret

00000000000007f8 <close>:
.global close
close:
 li a7, SYS_close
 7f8:	01500893          	li	a7,21
 ecall
 7fc:	00000073          	ecall
 ret
 800:	00008067          	ret

0000000000000804 <kill>:
.global kill
kill:
 li a7, SYS_kill
 804:	00600893          	li	a7,6
 ecall
 808:	00000073          	ecall
 ret
 80c:	00008067          	ret

0000000000000810 <exec>:
.global exec
exec:
 li a7, SYS_exec
 810:	00700893          	li	a7,7
 ecall
 814:	00000073          	ecall
 ret
 818:	00008067          	ret

000000000000081c <open>:
.global open
open:
 li a7, SYS_open
 81c:	00f00893          	li	a7,15
 ecall
 820:	00000073          	ecall
 ret
 824:	00008067          	ret

0000000000000828 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 828:	01100893          	li	a7,17
 ecall
 82c:	00000073          	ecall
 ret
 830:	00008067          	ret

0000000000000834 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 834:	01200893          	li	a7,18
 ecall
 838:	00000073          	ecall
 ret
 83c:	00008067          	ret

0000000000000840 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 840:	00800893          	li	a7,8
 ecall
 844:	00000073          	ecall
 ret
 848:	00008067          	ret

000000000000084c <link>:
.global link
link:
 li a7, SYS_link
 84c:	01300893          	li	a7,19
 ecall
 850:	00000073          	ecall
 ret
 854:	00008067          	ret

0000000000000858 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 858:	01400893          	li	a7,20
 ecall
 85c:	00000073          	ecall
 ret
 860:	00008067          	ret

0000000000000864 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 864:	00900893          	li	a7,9
 ecall
 868:	00000073          	ecall
 ret
 86c:	00008067          	ret

0000000000000870 <dup>:
.global dup
dup:
 li a7, SYS_dup
 870:	00a00893          	li	a7,10
 ecall
 874:	00000073          	ecall
 ret
 878:	00008067          	ret

000000000000087c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 87c:	00b00893          	li	a7,11
 ecall
 880:	00000073          	ecall
 ret
 884:	00008067          	ret

0000000000000888 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 888:	00c00893          	li	a7,12
 ecall
 88c:	00000073          	ecall
 ret
 890:	00008067          	ret

0000000000000894 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 894:	00d00893          	li	a7,13
 ecall
 898:	00000073          	ecall
 ret
 89c:	00008067          	ret

00000000000008a0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 8a0:	00e00893          	li	a7,14
 ecall
 8a4:	00000073          	ecall
 ret
 8a8:	00008067          	ret

00000000000008ac <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 8ac:	fe010113          	add	sp,sp,-32
 8b0:	00113c23          	sd	ra,24(sp)
 8b4:	00813823          	sd	s0,16(sp)
 8b8:	02010413          	add	s0,sp,32
 8bc:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 8c0:	00100613          	li	a2,1
 8c4:	fef40593          	add	a1,s0,-17
 8c8:	00000097          	auipc	ra,0x0
 8cc:	f24080e7          	jalr	-220(ra) # 7ec <write>
}
 8d0:	01813083          	ld	ra,24(sp)
 8d4:	01013403          	ld	s0,16(sp)
 8d8:	02010113          	add	sp,sp,32
 8dc:	00008067          	ret

00000000000008e0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 8e0:	fc010113          	add	sp,sp,-64
 8e4:	02113c23          	sd	ra,56(sp)
 8e8:	02813823          	sd	s0,48(sp)
 8ec:	02913423          	sd	s1,40(sp)
 8f0:	03213023          	sd	s2,32(sp)
 8f4:	01313c23          	sd	s3,24(sp)
 8f8:	04010413          	add	s0,sp,64
 8fc:	00050493          	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 900:	00068463          	beqz	a3,908 <printint+0x28>
 904:	0c05c063          	bltz	a1,9c4 <printint+0xe4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 908:	0005859b          	sext.w	a1,a1
  neg = 0;
 90c:	00000893          	li	a7,0
 910:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 914:	00000713          	li	a4,0
  do{
    buf[i++] = digits[x % base];
 918:	0006061b          	sext.w	a2,a2
 91c:	00000517          	auipc	a0,0x0
 920:	65c50513          	add	a0,a0,1628 # f78 <digits>
 924:	00070813          	mv	a6,a4
 928:	0017071b          	addw	a4,a4,1
 92c:	02c5f7bb          	remuw	a5,a1,a2
 930:	02079793          	sll	a5,a5,0x20
 934:	0207d793          	srl	a5,a5,0x20
 938:	00f507b3          	add	a5,a0,a5
 93c:	0007c783          	lbu	a5,0(a5)
 940:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 944:	0005879b          	sext.w	a5,a1
 948:	02c5d5bb          	divuw	a1,a1,a2
 94c:	00168693          	add	a3,a3,1
 950:	fcc7fae3          	bgeu	a5,a2,924 <printint+0x44>
  if(neg)
 954:	00088c63          	beqz	a7,96c <printint+0x8c>
    buf[i++] = '-';
 958:	fd070793          	add	a5,a4,-48
 95c:	00878733          	add	a4,a5,s0
 960:	02d00793          	li	a5,45
 964:	fef70823          	sb	a5,-16(a4)
 968:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 96c:	02e05e63          	blez	a4,9a8 <printint+0xc8>
 970:	fc040793          	add	a5,s0,-64
 974:	00e78933          	add	s2,a5,a4
 978:	fff78993          	add	s3,a5,-1
 97c:	00e989b3          	add	s3,s3,a4
 980:	fff7071b          	addw	a4,a4,-1
 984:	02071713          	sll	a4,a4,0x20
 988:	02075713          	srl	a4,a4,0x20
 98c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 990:	fff94583          	lbu	a1,-1(s2)
 994:	00048513          	mv	a0,s1
 998:	00000097          	auipc	ra,0x0
 99c:	f14080e7          	jalr	-236(ra) # 8ac <putc>
  while(--i >= 0)
 9a0:	fff90913          	add	s2,s2,-1
 9a4:	ff3916e3          	bne	s2,s3,990 <printint+0xb0>
}
 9a8:	03813083          	ld	ra,56(sp)
 9ac:	03013403          	ld	s0,48(sp)
 9b0:	02813483          	ld	s1,40(sp)
 9b4:	02013903          	ld	s2,32(sp)
 9b8:	01813983          	ld	s3,24(sp)
 9bc:	04010113          	add	sp,sp,64
 9c0:	00008067          	ret
    x = -xx;
 9c4:	40b005bb          	negw	a1,a1
    neg = 1;
 9c8:	00100893          	li	a7,1
    x = -xx;
 9cc:	f45ff06f          	j	910 <printint+0x30>

00000000000009d0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 9d0:	fb010113          	add	sp,sp,-80
 9d4:	04113423          	sd	ra,72(sp)
 9d8:	04813023          	sd	s0,64(sp)
 9dc:	02913c23          	sd	s1,56(sp)
 9e0:	03213823          	sd	s2,48(sp)
 9e4:	03313423          	sd	s3,40(sp)
 9e8:	03413023          	sd	s4,32(sp)
 9ec:	01513c23          	sd	s5,24(sp)
 9f0:	01613823          	sd	s6,16(sp)
 9f4:	01713423          	sd	s7,8(sp)
 9f8:	01813023          	sd	s8,0(sp)
 9fc:	05010413          	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 a00:	0005c903          	lbu	s2,0(a1)
 a04:	20090e63          	beqz	s2,c20 <vprintf+0x250>
 a08:	00050a93          	mv	s5,a0
 a0c:	00060b93          	mv	s7,a2
 a10:	00158493          	add	s1,a1,1
  state = 0;
 a14:	00000993          	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 a18:	02500a13          	li	s4,37
 a1c:	01500b13          	li	s6,21
 a20:	0280006f          	j	a48 <vprintf+0x78>
        putc(fd, c);
 a24:	00090593          	mv	a1,s2
 a28:	000a8513          	mv	a0,s5
 a2c:	00000097          	auipc	ra,0x0
 a30:	e80080e7          	jalr	-384(ra) # 8ac <putc>
 a34:	0080006f          	j	a3c <vprintf+0x6c>
    } else if(state == '%'){
 a38:	03498063          	beq	s3,s4,a58 <vprintf+0x88>
  for(i = 0; fmt[i]; i++){
 a3c:	00148493          	add	s1,s1,1
 a40:	fff4c903          	lbu	s2,-1(s1)
 a44:	1c090e63          	beqz	s2,c20 <vprintf+0x250>
    if(state == 0){
 a48:	fe0998e3          	bnez	s3,a38 <vprintf+0x68>
      if(c == '%'){
 a4c:	fd491ce3          	bne	s2,s4,a24 <vprintf+0x54>
        state = '%';
 a50:	000a0993          	mv	s3,s4
 a54:	fe9ff06f          	j	a3c <vprintf+0x6c>
      if(c == 'd'){
 a58:	17490e63          	beq	s2,s4,bd4 <vprintf+0x204>
 a5c:	f9d9079b          	addw	a5,s2,-99
 a60:	0ff7f793          	zext.b	a5,a5
 a64:	18fb6463          	bltu	s6,a5,bec <vprintf+0x21c>
 a68:	f9d9079b          	addw	a5,s2,-99
 a6c:	0ff7f713          	zext.b	a4,a5
 a70:	16eb6e63          	bltu	s6,a4,bec <vprintf+0x21c>
 a74:	00271793          	sll	a5,a4,0x2
 a78:	00000717          	auipc	a4,0x0
 a7c:	4a870713          	add	a4,a4,1192 # f20 <malloc+0x184>
 a80:	00e787b3          	add	a5,a5,a4
 a84:	0007a783          	lw	a5,0(a5)
 a88:	00e787b3          	add	a5,a5,a4
 a8c:	00078067          	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 a90:	008b8913          	add	s2,s7,8
 a94:	00100693          	li	a3,1
 a98:	00a00613          	li	a2,10
 a9c:	000ba583          	lw	a1,0(s7)
 aa0:	000a8513          	mv	a0,s5
 aa4:	00000097          	auipc	ra,0x0
 aa8:	e3c080e7          	jalr	-452(ra) # 8e0 <printint>
 aac:	00090b93          	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 ab0:	00000993          	li	s3,0
 ab4:	f89ff06f          	j	a3c <vprintf+0x6c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 ab8:	008b8913          	add	s2,s7,8
 abc:	00000693          	li	a3,0
 ac0:	00a00613          	li	a2,10
 ac4:	000ba583          	lw	a1,0(s7)
 ac8:	000a8513          	mv	a0,s5
 acc:	00000097          	auipc	ra,0x0
 ad0:	e14080e7          	jalr	-492(ra) # 8e0 <printint>
 ad4:	00090b93          	mv	s7,s2
      state = 0;
 ad8:	00000993          	li	s3,0
 adc:	f61ff06f          	j	a3c <vprintf+0x6c>
        printint(fd, va_arg(ap, int), 16, 0);
 ae0:	008b8913          	add	s2,s7,8
 ae4:	00000693          	li	a3,0
 ae8:	01000613          	li	a2,16
 aec:	000ba583          	lw	a1,0(s7)
 af0:	000a8513          	mv	a0,s5
 af4:	00000097          	auipc	ra,0x0
 af8:	dec080e7          	jalr	-532(ra) # 8e0 <printint>
 afc:	00090b93          	mv	s7,s2
      state = 0;
 b00:	00000993          	li	s3,0
 b04:	f39ff06f          	j	a3c <vprintf+0x6c>
        printptr(fd, va_arg(ap, uint64));
 b08:	008b8c13          	add	s8,s7,8
 b0c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 b10:	03000593          	li	a1,48
 b14:	000a8513          	mv	a0,s5
 b18:	00000097          	auipc	ra,0x0
 b1c:	d94080e7          	jalr	-620(ra) # 8ac <putc>
  putc(fd, 'x');
 b20:	07800593          	li	a1,120
 b24:	000a8513          	mv	a0,s5
 b28:	00000097          	auipc	ra,0x0
 b2c:	d84080e7          	jalr	-636(ra) # 8ac <putc>
 b30:	01000913          	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 b34:	00000b97          	auipc	s7,0x0
 b38:	444b8b93          	add	s7,s7,1092 # f78 <digits>
 b3c:	03c9d793          	srl	a5,s3,0x3c
 b40:	00fb87b3          	add	a5,s7,a5
 b44:	0007c583          	lbu	a1,0(a5)
 b48:	000a8513          	mv	a0,s5
 b4c:	00000097          	auipc	ra,0x0
 b50:	d60080e7          	jalr	-672(ra) # 8ac <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 b54:	00499993          	sll	s3,s3,0x4
 b58:	fff9091b          	addw	s2,s2,-1
 b5c:	fe0910e3          	bnez	s2,b3c <vprintf+0x16c>
        printptr(fd, va_arg(ap, uint64));
 b60:	000c0b93          	mv	s7,s8
      state = 0;
 b64:	00000993          	li	s3,0
 b68:	ed5ff06f          	j	a3c <vprintf+0x6c>
        s = va_arg(ap, char*);
 b6c:	008b8993          	add	s3,s7,8
 b70:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 b74:	02090863          	beqz	s2,ba4 <vprintf+0x1d4>
        while(*s != 0){
 b78:	00094583          	lbu	a1,0(s2)
 b7c:	08058c63          	beqz	a1,c14 <vprintf+0x244>
          putc(fd, *s);
 b80:	000a8513          	mv	a0,s5
 b84:	00000097          	auipc	ra,0x0
 b88:	d28080e7          	jalr	-728(ra) # 8ac <putc>
          s++;
 b8c:	00190913          	add	s2,s2,1
        while(*s != 0){
 b90:	00094583          	lbu	a1,0(s2)
 b94:	fe0596e3          	bnez	a1,b80 <vprintf+0x1b0>
        s = va_arg(ap, char*);
 b98:	00098b93          	mv	s7,s3
      state = 0;
 b9c:	00000993          	li	s3,0
 ba0:	e9dff06f          	j	a3c <vprintf+0x6c>
          s = "(null)";
 ba4:	00000917          	auipc	s2,0x0
 ba8:	37490913          	add	s2,s2,884 # f18 <malloc+0x17c>
        while(*s != 0){
 bac:	02800593          	li	a1,40
 bb0:	fd1ff06f          	j	b80 <vprintf+0x1b0>
        putc(fd, va_arg(ap, uint));
 bb4:	008b8913          	add	s2,s7,8
 bb8:	000bc583          	lbu	a1,0(s7)
 bbc:	000a8513          	mv	a0,s5
 bc0:	00000097          	auipc	ra,0x0
 bc4:	cec080e7          	jalr	-788(ra) # 8ac <putc>
 bc8:	00090b93          	mv	s7,s2
      state = 0;
 bcc:	00000993          	li	s3,0
 bd0:	e6dff06f          	j	a3c <vprintf+0x6c>
        putc(fd, c);
 bd4:	02500593          	li	a1,37
 bd8:	000a8513          	mv	a0,s5
 bdc:	00000097          	auipc	ra,0x0
 be0:	cd0080e7          	jalr	-816(ra) # 8ac <putc>
      state = 0;
 be4:	00000993          	li	s3,0
 be8:	e55ff06f          	j	a3c <vprintf+0x6c>
        putc(fd, '%');
 bec:	02500593          	li	a1,37
 bf0:	000a8513          	mv	a0,s5
 bf4:	00000097          	auipc	ra,0x0
 bf8:	cb8080e7          	jalr	-840(ra) # 8ac <putc>
        putc(fd, c);
 bfc:	00090593          	mv	a1,s2
 c00:	000a8513          	mv	a0,s5
 c04:	00000097          	auipc	ra,0x0
 c08:	ca8080e7          	jalr	-856(ra) # 8ac <putc>
      state = 0;
 c0c:	00000993          	li	s3,0
 c10:	e2dff06f          	j	a3c <vprintf+0x6c>
        s = va_arg(ap, char*);
 c14:	00098b93          	mv	s7,s3
      state = 0;
 c18:	00000993          	li	s3,0
 c1c:	e21ff06f          	j	a3c <vprintf+0x6c>
    }
  }
}
 c20:	04813083          	ld	ra,72(sp)
 c24:	04013403          	ld	s0,64(sp)
 c28:	03813483          	ld	s1,56(sp)
 c2c:	03013903          	ld	s2,48(sp)
 c30:	02813983          	ld	s3,40(sp)
 c34:	02013a03          	ld	s4,32(sp)
 c38:	01813a83          	ld	s5,24(sp)
 c3c:	01013b03          	ld	s6,16(sp)
 c40:	00813b83          	ld	s7,8(sp)
 c44:	00013c03          	ld	s8,0(sp)
 c48:	05010113          	add	sp,sp,80
 c4c:	00008067          	ret

0000000000000c50 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 c50:	fb010113          	add	sp,sp,-80
 c54:	00113c23          	sd	ra,24(sp)
 c58:	00813823          	sd	s0,16(sp)
 c5c:	02010413          	add	s0,sp,32
 c60:	00c43023          	sd	a2,0(s0)
 c64:	00d43423          	sd	a3,8(s0)
 c68:	00e43823          	sd	a4,16(s0)
 c6c:	00f43c23          	sd	a5,24(s0)
 c70:	03043023          	sd	a6,32(s0)
 c74:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 c78:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 c7c:	00040613          	mv	a2,s0
 c80:	00000097          	auipc	ra,0x0
 c84:	d50080e7          	jalr	-688(ra) # 9d0 <vprintf>
}
 c88:	01813083          	ld	ra,24(sp)
 c8c:	01013403          	ld	s0,16(sp)
 c90:	05010113          	add	sp,sp,80
 c94:	00008067          	ret

0000000000000c98 <printf>:

void
printf(const char *fmt, ...)
{
 c98:	fa010113          	add	sp,sp,-96
 c9c:	00113c23          	sd	ra,24(sp)
 ca0:	00813823          	sd	s0,16(sp)
 ca4:	02010413          	add	s0,sp,32
 ca8:	00b43423          	sd	a1,8(s0)
 cac:	00c43823          	sd	a2,16(s0)
 cb0:	00d43c23          	sd	a3,24(s0)
 cb4:	02e43023          	sd	a4,32(s0)
 cb8:	02f43423          	sd	a5,40(s0)
 cbc:	03043823          	sd	a6,48(s0)
 cc0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 cc4:	00840613          	add	a2,s0,8
 cc8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 ccc:	00050593          	mv	a1,a0
 cd0:	00100513          	li	a0,1
 cd4:	00000097          	auipc	ra,0x0
 cd8:	cfc080e7          	jalr	-772(ra) # 9d0 <vprintf>
}
 cdc:	01813083          	ld	ra,24(sp)
 ce0:	01013403          	ld	s0,16(sp)
 ce4:	06010113          	add	sp,sp,96
 ce8:	00008067          	ret

0000000000000cec <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 cec:	ff010113          	add	sp,sp,-16
 cf0:	00813423          	sd	s0,8(sp)
 cf4:	01010413          	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 cf8:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 cfc:	00000797          	auipc	a5,0x0
 d00:	3047b783          	ld	a5,772(a5) # 1000 <freep>
 d04:	0400006f          	j	d44 <free+0x58>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 d08:	00862703          	lw	a4,8(a2)
 d0c:	00b7073b          	addw	a4,a4,a1
 d10:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 d14:	0007b703          	ld	a4,0(a5)
 d18:	00073603          	ld	a2,0(a4)
 d1c:	0500006f          	j	d6c <free+0x80>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 d20:	ff852703          	lw	a4,-8(a0)
 d24:	00c7073b          	addw	a4,a4,a2
 d28:	00e7a423          	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 d2c:	ff053683          	ld	a3,-16(a0)
 d30:	0540006f          	j	d84 <free+0x98>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 d34:	0007b703          	ld	a4,0(a5)
 d38:	00e7e463          	bltu	a5,a4,d40 <free+0x54>
 d3c:	00e6ec63          	bltu	a3,a4,d54 <free+0x68>
{
 d40:	00070793          	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 d44:	fed7f8e3          	bgeu	a5,a3,d34 <free+0x48>
 d48:	0007b703          	ld	a4,0(a5)
 d4c:	00e6e463          	bltu	a3,a4,d54 <free+0x68>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 d50:	fee7e8e3          	bltu	a5,a4,d40 <free+0x54>
  if(bp + bp->s.size == p->s.ptr){
 d54:	ff852583          	lw	a1,-8(a0)
 d58:	0007b603          	ld	a2,0(a5)
 d5c:	02059813          	sll	a6,a1,0x20
 d60:	01c85713          	srl	a4,a6,0x1c
 d64:	00e68733          	add	a4,a3,a4
 d68:	fae600e3          	beq	a2,a4,d08 <free+0x1c>
    bp->s.ptr = p->s.ptr->s.ptr;
 d6c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 d70:	0087a603          	lw	a2,8(a5)
 d74:	02061593          	sll	a1,a2,0x20
 d78:	01c5d713          	srl	a4,a1,0x1c
 d7c:	00e78733          	add	a4,a5,a4
 d80:	fae680e3          	beq	a3,a4,d20 <free+0x34>
    p->s.ptr = bp->s.ptr;
 d84:	00d7b023          	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 d88:	00000717          	auipc	a4,0x0
 d8c:	26f73c23          	sd	a5,632(a4) # 1000 <freep>
}
 d90:	00813403          	ld	s0,8(sp)
 d94:	01010113          	add	sp,sp,16
 d98:	00008067          	ret

0000000000000d9c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 d9c:	fc010113          	add	sp,sp,-64
 da0:	02113c23          	sd	ra,56(sp)
 da4:	02813823          	sd	s0,48(sp)
 da8:	02913423          	sd	s1,40(sp)
 dac:	03213023          	sd	s2,32(sp)
 db0:	01313c23          	sd	s3,24(sp)
 db4:	01413823          	sd	s4,16(sp)
 db8:	01513423          	sd	s5,8(sp)
 dbc:	01613023          	sd	s6,0(sp)
 dc0:	04010413          	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 dc4:	02051493          	sll	s1,a0,0x20
 dc8:	0204d493          	srl	s1,s1,0x20
 dcc:	00f48493          	add	s1,s1,15
 dd0:	0044d493          	srl	s1,s1,0x4
 dd4:	0014899b          	addw	s3,s1,1
 dd8:	00148493          	add	s1,s1,1
  if((prevp = freep) == 0){
 ddc:	00000517          	auipc	a0,0x0
 de0:	22453503          	ld	a0,548(a0) # 1000 <freep>
 de4:	02050e63          	beqz	a0,e20 <malloc+0x84>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 de8:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
 dec:	0087a703          	lw	a4,8(a5)
 df0:	04977663          	bgeu	a4,s1,e3c <malloc+0xa0>
  if(nu < 4096)
 df4:	00098a13          	mv	s4,s3
 df8:	0009871b          	sext.w	a4,s3
 dfc:	000016b7          	lui	a3,0x1
 e00:	00d77463          	bgeu	a4,a3,e08 <malloc+0x6c>
 e04:	00001a37          	lui	s4,0x1
 e08:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 e0c:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 e10:	00000917          	auipc	s2,0x0
 e14:	1f090913          	add	s2,s2,496 # 1000 <freep>
  if(p == (char*)-1)
 e18:	fff00a93          	li	s5,-1
 e1c:	0a00006f          	j	ebc <malloc+0x120>
    base.s.ptr = freep = prevp = &base;
 e20:	00000797          	auipc	a5,0x0
 e24:	5f078793          	add	a5,a5,1520 # 1410 <base>
 e28:	00000717          	auipc	a4,0x0
 e2c:	1cf73c23          	sd	a5,472(a4) # 1000 <freep>
 e30:	00f7b023          	sd	a5,0(a5)
    base.s.size = 0;
 e34:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 e38:	fbdff06f          	j	df4 <malloc+0x58>
      if(p->s.size == nunits)
 e3c:	04e48863          	beq	s1,a4,e8c <malloc+0xf0>
        p->s.size -= nunits;
 e40:	4137073b          	subw	a4,a4,s3
 e44:	00e7a423          	sw	a4,8(a5)
        p += p->s.size;
 e48:	02071693          	sll	a3,a4,0x20
 e4c:	01c6d713          	srl	a4,a3,0x1c
 e50:	00e787b3          	add	a5,a5,a4
        p->s.size = nunits;
 e54:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 e58:	00000717          	auipc	a4,0x0
 e5c:	1aa73423          	sd	a0,424(a4) # 1000 <freep>
      return (void*)(p + 1);
 e60:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 e64:	03813083          	ld	ra,56(sp)
 e68:	03013403          	ld	s0,48(sp)
 e6c:	02813483          	ld	s1,40(sp)
 e70:	02013903          	ld	s2,32(sp)
 e74:	01813983          	ld	s3,24(sp)
 e78:	01013a03          	ld	s4,16(sp)
 e7c:	00813a83          	ld	s5,8(sp)
 e80:	00013b03          	ld	s6,0(sp)
 e84:	04010113          	add	sp,sp,64
 e88:	00008067          	ret
        prevp->s.ptr = p->s.ptr;
 e8c:	0007b703          	ld	a4,0(a5)
 e90:	00e53023          	sd	a4,0(a0)
 e94:	fc5ff06f          	j	e58 <malloc+0xbc>
  hp->s.size = nu;
 e98:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 e9c:	01050513          	add	a0,a0,16
 ea0:	00000097          	auipc	ra,0x0
 ea4:	e4c080e7          	jalr	-436(ra) # cec <free>
  return freep;
 ea8:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 eac:	fa050ce3          	beqz	a0,e64 <malloc+0xc8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 eb0:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
 eb4:	0087a703          	lw	a4,8(a5)
 eb8:	f89772e3          	bgeu	a4,s1,e3c <malloc+0xa0>
    if(p == freep)
 ebc:	00093703          	ld	a4,0(s2)
 ec0:	00078513          	mv	a0,a5
 ec4:	fef716e3          	bne	a4,a5,eb0 <malloc+0x114>
  p = sbrk(nu * sizeof(Header));
 ec8:	000a0513          	mv	a0,s4
 ecc:	00000097          	auipc	ra,0x0
 ed0:	9bc080e7          	jalr	-1604(ra) # 888 <sbrk>
  if(p == (char*)-1)
 ed4:	fd5512e3          	bne	a0,s5,e98 <malloc+0xfc>
        return 0;
 ed8:	00000513          	li	a0,0
 edc:	f89ff06f          	j	e64 <malloc+0xc8>
