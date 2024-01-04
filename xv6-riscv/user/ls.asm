
user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "user/user.h"
#include "kernel/fs.h"

char*
fmtname(char *path)
{
   0:	fd010113          	add	sp,sp,-48
   4:	02113423          	sd	ra,40(sp)
   8:	02813023          	sd	s0,32(sp)
   c:	00913c23          	sd	s1,24(sp)
  10:	01213823          	sd	s2,16(sp)
  14:	01313423          	sd	s3,8(sp)
  18:	03010413          	add	s0,sp,48
  1c:	00050493          	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
  20:	00000097          	auipc	ra,0x0
  24:	3e8080e7          	jalr	1000(ra) # 408 <strlen>
  28:	02051793          	sll	a5,a0,0x20
  2c:	0207d793          	srl	a5,a5,0x20
  30:	00f487b3          	add	a5,s1,a5
  34:	02f00693          	li	a3,47
  38:	0097ea63          	bltu	a5,s1,4c <fmtname+0x4c>
  3c:	0007c703          	lbu	a4,0(a5)
  40:	00d70663          	beq	a4,a3,4c <fmtname+0x4c>
  44:	fff78793          	add	a5,a5,-1
  48:	fe97fae3          	bgeu	a5,s1,3c <fmtname+0x3c>
    ;
  p++;
  4c:	00178493          	add	s1,a5,1

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  50:	00048513          	mv	a0,s1
  54:	00000097          	auipc	ra,0x0
  58:	3b4080e7          	jalr	948(ra) # 408 <strlen>
  5c:	0005051b          	sext.w	a0,a0
  60:	00d00793          	li	a5,13
  64:	02a7f263          	bgeu	a5,a0,88 <fmtname+0x88>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
  68:	00048513          	mv	a0,s1
  6c:	02813083          	ld	ra,40(sp)
  70:	02013403          	ld	s0,32(sp)
  74:	01813483          	ld	s1,24(sp)
  78:	01013903          	ld	s2,16(sp)
  7c:	00813983          	ld	s3,8(sp)
  80:	03010113          	add	sp,sp,48
  84:	00008067          	ret
  memmove(buf, p, strlen(p));
  88:	00048513          	mv	a0,s1
  8c:	00000097          	auipc	ra,0x0
  90:	37c080e7          	jalr	892(ra) # 408 <strlen>
  94:	00001997          	auipc	s3,0x1
  98:	f7c98993          	add	s3,s3,-132 # 1010 <buf.0>
  9c:	0005061b          	sext.w	a2,a0
  a0:	00048593          	mv	a1,s1
  a4:	00098513          	mv	a0,s3
  a8:	00000097          	auipc	ra,0x0
  ac:	5b0080e7          	jalr	1456(ra) # 658 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  b0:	00048513          	mv	a0,s1
  b4:	00000097          	auipc	ra,0x0
  b8:	354080e7          	jalr	852(ra) # 408 <strlen>
  bc:	0005091b          	sext.w	s2,a0
  c0:	00048513          	mv	a0,s1
  c4:	00000097          	auipc	ra,0x0
  c8:	344080e7          	jalr	836(ra) # 408 <strlen>
  cc:	02091913          	sll	s2,s2,0x20
  d0:	02095913          	srl	s2,s2,0x20
  d4:	00e00613          	li	a2,14
  d8:	40a6063b          	subw	a2,a2,a0
  dc:	02000593          	li	a1,32
  e0:	01298533          	add	a0,s3,s2
  e4:	00000097          	auipc	ra,0x0
  e8:	36c080e7          	jalr	876(ra) # 450 <memset>
  return buf;
  ec:	00098493          	mv	s1,s3
  f0:	f79ff06f          	j	68 <fmtname+0x68>

00000000000000f4 <ls>:

void
ls(char *path)
{
  f4:	d9010113          	add	sp,sp,-624
  f8:	26113423          	sd	ra,616(sp)
  fc:	26813023          	sd	s0,608(sp)
 100:	24913c23          	sd	s1,600(sp)
 104:	25213823          	sd	s2,592(sp)
 108:	25313423          	sd	s3,584(sp)
 10c:	25413023          	sd	s4,576(sp)
 110:	23513c23          	sd	s5,568(sp)
 114:	27010413          	add	s0,sp,624
 118:	00050913          	mv	s2,a0
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
 11c:	00000593          	li	a1,0
 120:	00000097          	auipc	ra,0x0
 124:	6a4080e7          	jalr	1700(ra) # 7c4 <open>
 128:	08054863          	bltz	a0,1b8 <ls+0xc4>
 12c:	00050493          	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
 130:	d9840593          	add	a1,s0,-616
 134:	00000097          	auipc	ra,0x0
 138:	6b4080e7          	jalr	1716(ra) # 7e8 <fstat>
 13c:	08054c63          	bltz	a0,1d4 <ls+0xe0>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
 140:	da041783          	lh	a5,-608(s0)
 144:	00100713          	li	a4,1
 148:	0ae78a63          	beq	a5,a4,1fc <ls+0x108>
 14c:	ffe7879b          	addw	a5,a5,-2
 150:	03079793          	sll	a5,a5,0x30
 154:	0307d793          	srl	a5,a5,0x30
 158:	02f76863          	bltu	a4,a5,188 <ls+0x94>
  case T_DEVICE:
  case T_FILE:
    printf("%s %d %d %l\n", fmtname(path), st.type, st.ino, st.size);
 15c:	00090513          	mv	a0,s2
 160:	00000097          	auipc	ra,0x0
 164:	ea0080e7          	jalr	-352(ra) # 0 <fmtname>
 168:	00050593          	mv	a1,a0
 16c:	da843703          	ld	a4,-600(s0)
 170:	d9c42683          	lw	a3,-612(s0)
 174:	da041603          	lh	a2,-608(s0)
 178:	00001517          	auipc	a0,0x1
 17c:	d4850513          	add	a0,a0,-696 # ec0 <malloc+0x17c>
 180:	00001097          	auipc	ra,0x1
 184:	ac0080e7          	jalr	-1344(ra) # c40 <printf>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
 188:	00048513          	mv	a0,s1
 18c:	00000097          	auipc	ra,0x0
 190:	614080e7          	jalr	1556(ra) # 7a0 <close>
}
 194:	26813083          	ld	ra,616(sp)
 198:	26013403          	ld	s0,608(sp)
 19c:	25813483          	ld	s1,600(sp)
 1a0:	25013903          	ld	s2,592(sp)
 1a4:	24813983          	ld	s3,584(sp)
 1a8:	24013a03          	ld	s4,576(sp)
 1ac:	23813a83          	ld	s5,568(sp)
 1b0:	27010113          	add	sp,sp,624
 1b4:	00008067          	ret
    fprintf(2, "ls: cannot open %s\n", path);
 1b8:	00090613          	mv	a2,s2
 1bc:	00001597          	auipc	a1,0x1
 1c0:	cd458593          	add	a1,a1,-812 # e90 <malloc+0x14c>
 1c4:	00200513          	li	a0,2
 1c8:	00001097          	auipc	ra,0x1
 1cc:	a30080e7          	jalr	-1488(ra) # bf8 <fprintf>
    return;
 1d0:	fc5ff06f          	j	194 <ls+0xa0>
    fprintf(2, "ls: cannot stat %s\n", path);
 1d4:	00090613          	mv	a2,s2
 1d8:	00001597          	auipc	a1,0x1
 1dc:	cd058593          	add	a1,a1,-816 # ea8 <malloc+0x164>
 1e0:	00200513          	li	a0,2
 1e4:	00001097          	auipc	ra,0x1
 1e8:	a14080e7          	jalr	-1516(ra) # bf8 <fprintf>
    close(fd);
 1ec:	00048513          	mv	a0,s1
 1f0:	00000097          	auipc	ra,0x0
 1f4:	5b0080e7          	jalr	1456(ra) # 7a0 <close>
    return;
 1f8:	f9dff06f          	j	194 <ls+0xa0>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 1fc:	00090513          	mv	a0,s2
 200:	00000097          	auipc	ra,0x0
 204:	208080e7          	jalr	520(ra) # 408 <strlen>
 208:	0105051b          	addw	a0,a0,16
 20c:	20000793          	li	a5,512
 210:	00a7fc63          	bgeu	a5,a0,228 <ls+0x134>
      printf("ls: path too long\n");
 214:	00001517          	auipc	a0,0x1
 218:	cbc50513          	add	a0,a0,-836 # ed0 <malloc+0x18c>
 21c:	00001097          	auipc	ra,0x1
 220:	a24080e7          	jalr	-1500(ra) # c40 <printf>
      break;
 224:	f65ff06f          	j	188 <ls+0x94>
    strcpy(buf, path);
 228:	00090593          	mv	a1,s2
 22c:	dc040513          	add	a0,s0,-576
 230:	00000097          	auipc	ra,0x0
 234:	168080e7          	jalr	360(ra) # 398 <strcpy>
    p = buf+strlen(buf);
 238:	dc040513          	add	a0,s0,-576
 23c:	00000097          	auipc	ra,0x0
 240:	1cc080e7          	jalr	460(ra) # 408 <strlen>
 244:	02051513          	sll	a0,a0,0x20
 248:	02055513          	srl	a0,a0,0x20
 24c:	dc040793          	add	a5,s0,-576
 250:	00a78933          	add	s2,a5,a0
    *p++ = '/';
 254:	00190993          	add	s3,s2,1
 258:	02f00793          	li	a5,47
 25c:	00f90023          	sb	a5,0(s2)
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 260:	00001a17          	auipc	s4,0x1
 264:	c88a0a13          	add	s4,s4,-888 # ee8 <malloc+0x1a4>
        printf("ls: cannot stat %s\n", buf);
 268:	00001a97          	auipc	s5,0x1
 26c:	c40a8a93          	add	s5,s5,-960 # ea8 <malloc+0x164>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 270:	0140006f          	j	284 <ls+0x190>
        printf("ls: cannot stat %s\n", buf);
 274:	dc040593          	add	a1,s0,-576
 278:	000a8513          	mv	a0,s5
 27c:	00001097          	auipc	ra,0x1
 280:	9c4080e7          	jalr	-1596(ra) # c40 <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 284:	01000613          	li	a2,16
 288:	db040593          	add	a1,s0,-592
 28c:	00048513          	mv	a0,s1
 290:	00000097          	auipc	ra,0x0
 294:	4f8080e7          	jalr	1272(ra) # 788 <read>
 298:	01000793          	li	a5,16
 29c:	eef516e3          	bne	a0,a5,188 <ls+0x94>
      if(de.inum == 0)
 2a0:	db045783          	lhu	a5,-592(s0)
 2a4:	fe0780e3          	beqz	a5,284 <ls+0x190>
      memmove(p, de.name, DIRSIZ);
 2a8:	00e00613          	li	a2,14
 2ac:	db240593          	add	a1,s0,-590
 2b0:	00098513          	mv	a0,s3
 2b4:	00000097          	auipc	ra,0x0
 2b8:	3a4080e7          	jalr	932(ra) # 658 <memmove>
      p[DIRSIZ] = 0;
 2bc:	000907a3          	sb	zero,15(s2)
      if(stat(buf, &st) < 0){
 2c0:	d9840593          	add	a1,s0,-616
 2c4:	dc040513          	add	a0,s0,-576
 2c8:	00000097          	auipc	ra,0x0
 2cc:	2bc080e7          	jalr	700(ra) # 584 <stat>
 2d0:	fa0542e3          	bltz	a0,274 <ls+0x180>
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 2d4:	dc040513          	add	a0,s0,-576
 2d8:	00000097          	auipc	ra,0x0
 2dc:	d28080e7          	jalr	-728(ra) # 0 <fmtname>
 2e0:	00050593          	mv	a1,a0
 2e4:	da843703          	ld	a4,-600(s0)
 2e8:	d9c42683          	lw	a3,-612(s0)
 2ec:	da041603          	lh	a2,-608(s0)
 2f0:	000a0513          	mv	a0,s4
 2f4:	00001097          	auipc	ra,0x1
 2f8:	94c080e7          	jalr	-1716(ra) # c40 <printf>
 2fc:	f89ff06f          	j	284 <ls+0x190>

0000000000000300 <main>:

int
main(int argc, char *argv[])
{
 300:	fe010113          	add	sp,sp,-32
 304:	00113c23          	sd	ra,24(sp)
 308:	00813823          	sd	s0,16(sp)
 30c:	00913423          	sd	s1,8(sp)
 310:	01213023          	sd	s2,0(sp)
 314:	02010413          	add	s0,sp,32
  int i;

  if(argc < 2){
 318:	00100793          	li	a5,1
 31c:	02a7de63          	bge	a5,a0,358 <main+0x58>
 320:	00858493          	add	s1,a1,8
 324:	ffe5091b          	addw	s2,a0,-2
 328:	02091793          	sll	a5,s2,0x20
 32c:	01d7d913          	srl	s2,a5,0x1d
 330:	01058593          	add	a1,a1,16
 334:	00b90933          	add	s2,s2,a1
    ls(".");
    exit(0);
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
 338:	0004b503          	ld	a0,0(s1)
 33c:	00000097          	auipc	ra,0x0
 340:	db8080e7          	jalr	-584(ra) # f4 <ls>
  for(i=1; i<argc; i++)
 344:	00848493          	add	s1,s1,8
 348:	ff2498e3          	bne	s1,s2,338 <main+0x38>
  exit(0);
 34c:	00000513          	li	a0,0
 350:	00000097          	auipc	ra,0x0
 354:	414080e7          	jalr	1044(ra) # 764 <exit>
    ls(".");
 358:	00001517          	auipc	a0,0x1
 35c:	ba050513          	add	a0,a0,-1120 # ef8 <malloc+0x1b4>
 360:	00000097          	auipc	ra,0x0
 364:	d94080e7          	jalr	-620(ra) # f4 <ls>
    exit(0);
 368:	00000513          	li	a0,0
 36c:	00000097          	auipc	ra,0x0
 370:	3f8080e7          	jalr	1016(ra) # 764 <exit>

0000000000000374 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 374:	ff010113          	add	sp,sp,-16
 378:	00113423          	sd	ra,8(sp)
 37c:	00813023          	sd	s0,0(sp)
 380:	01010413          	add	s0,sp,16
  extern int main();
  main();
 384:	00000097          	auipc	ra,0x0
 388:	f7c080e7          	jalr	-132(ra) # 300 <main>
  exit(0);
 38c:	00000513          	li	a0,0
 390:	00000097          	auipc	ra,0x0
 394:	3d4080e7          	jalr	980(ra) # 764 <exit>

0000000000000398 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 398:	ff010113          	add	sp,sp,-16
 39c:	00813423          	sd	s0,8(sp)
 3a0:	01010413          	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 3a4:	00050793          	mv	a5,a0
 3a8:	00158593          	add	a1,a1,1
 3ac:	00178793          	add	a5,a5,1
 3b0:	fff5c703          	lbu	a4,-1(a1)
 3b4:	fee78fa3          	sb	a4,-1(a5)
 3b8:	fe0718e3          	bnez	a4,3a8 <strcpy+0x10>
    ;
  return os;
}
 3bc:	00813403          	ld	s0,8(sp)
 3c0:	01010113          	add	sp,sp,16
 3c4:	00008067          	ret

00000000000003c8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3c8:	ff010113          	add	sp,sp,-16
 3cc:	00813423          	sd	s0,8(sp)
 3d0:	01010413          	add	s0,sp,16
  while(*p && *p == *q)
 3d4:	00054783          	lbu	a5,0(a0)
 3d8:	00078e63          	beqz	a5,3f4 <strcmp+0x2c>
 3dc:	0005c703          	lbu	a4,0(a1)
 3e0:	00f71a63          	bne	a4,a5,3f4 <strcmp+0x2c>
    p++, q++;
 3e4:	00150513          	add	a0,a0,1
 3e8:	00158593          	add	a1,a1,1
  while(*p && *p == *q)
 3ec:	00054783          	lbu	a5,0(a0)
 3f0:	fe0796e3          	bnez	a5,3dc <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 3f4:	0005c503          	lbu	a0,0(a1)
}
 3f8:	40a7853b          	subw	a0,a5,a0
 3fc:	00813403          	ld	s0,8(sp)
 400:	01010113          	add	sp,sp,16
 404:	00008067          	ret

0000000000000408 <strlen>:

uint
strlen(const char *s)
{
 408:	ff010113          	add	sp,sp,-16
 40c:	00813423          	sd	s0,8(sp)
 410:	01010413          	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 414:	00054783          	lbu	a5,0(a0)
 418:	02078863          	beqz	a5,448 <strlen+0x40>
 41c:	00150513          	add	a0,a0,1
 420:	00050793          	mv	a5,a0
 424:	00078693          	mv	a3,a5
 428:	00178793          	add	a5,a5,1
 42c:	fff7c703          	lbu	a4,-1(a5)
 430:	fe071ae3          	bnez	a4,424 <strlen+0x1c>
 434:	40a6853b          	subw	a0,a3,a0
 438:	0015051b          	addw	a0,a0,1
    ;
  return n;
}
 43c:	00813403          	ld	s0,8(sp)
 440:	01010113          	add	sp,sp,16
 444:	00008067          	ret
  for(n = 0; s[n]; n++)
 448:	00000513          	li	a0,0
 44c:	ff1ff06f          	j	43c <strlen+0x34>

0000000000000450 <memset>:

void*
memset(void *dst, int c, uint n)
{
 450:	ff010113          	add	sp,sp,-16
 454:	00813423          	sd	s0,8(sp)
 458:	01010413          	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 45c:	02060063          	beqz	a2,47c <memset+0x2c>
 460:	00050793          	mv	a5,a0
 464:	02061613          	sll	a2,a2,0x20
 468:	02065613          	srl	a2,a2,0x20
 46c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 470:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 474:	00178793          	add	a5,a5,1
 478:	fee79ce3          	bne	a5,a4,470 <memset+0x20>
  }
  return dst;
}
 47c:	00813403          	ld	s0,8(sp)
 480:	01010113          	add	sp,sp,16
 484:	00008067          	ret

0000000000000488 <strchr>:

char*
strchr(const char *s, char c)
{
 488:	ff010113          	add	sp,sp,-16
 48c:	00813423          	sd	s0,8(sp)
 490:	01010413          	add	s0,sp,16
  for(; *s; s++)
 494:	00054783          	lbu	a5,0(a0)
 498:	02078263          	beqz	a5,4bc <strchr+0x34>
    if(*s == c)
 49c:	00f58a63          	beq	a1,a5,4b0 <strchr+0x28>
  for(; *s; s++)
 4a0:	00150513          	add	a0,a0,1
 4a4:	00054783          	lbu	a5,0(a0)
 4a8:	fe079ae3          	bnez	a5,49c <strchr+0x14>
      return (char*)s;
  return 0;
 4ac:	00000513          	li	a0,0
}
 4b0:	00813403          	ld	s0,8(sp)
 4b4:	01010113          	add	sp,sp,16
 4b8:	00008067          	ret
  return 0;
 4bc:	00000513          	li	a0,0
 4c0:	ff1ff06f          	j	4b0 <strchr+0x28>

00000000000004c4 <gets>:

char*
gets(char *buf, int max)
{
 4c4:	fa010113          	add	sp,sp,-96
 4c8:	04113c23          	sd	ra,88(sp)
 4cc:	04813823          	sd	s0,80(sp)
 4d0:	04913423          	sd	s1,72(sp)
 4d4:	05213023          	sd	s2,64(sp)
 4d8:	03313c23          	sd	s3,56(sp)
 4dc:	03413823          	sd	s4,48(sp)
 4e0:	03513423          	sd	s5,40(sp)
 4e4:	03613023          	sd	s6,32(sp)
 4e8:	01713c23          	sd	s7,24(sp)
 4ec:	06010413          	add	s0,sp,96
 4f0:	00050b93          	mv	s7,a0
 4f4:	00058a13          	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4f8:	00050913          	mv	s2,a0
 4fc:	00000493          	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 500:	00a00a93          	li	s5,10
 504:	00d00b13          	li	s6,13
  for(i=0; i+1 < max; ){
 508:	00048993          	mv	s3,s1
 50c:	0014849b          	addw	s1,s1,1
 510:	0344de63          	bge	s1,s4,54c <gets+0x88>
    cc = read(0, &c, 1);
 514:	00100613          	li	a2,1
 518:	faf40593          	add	a1,s0,-81
 51c:	00000513          	li	a0,0
 520:	00000097          	auipc	ra,0x0
 524:	268080e7          	jalr	616(ra) # 788 <read>
    if(cc < 1)
 528:	02a05263          	blez	a0,54c <gets+0x88>
    buf[i++] = c;
 52c:	faf44783          	lbu	a5,-81(s0)
 530:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 534:	01578a63          	beq	a5,s5,548 <gets+0x84>
 538:	00190913          	add	s2,s2,1
 53c:	fd6796e3          	bne	a5,s6,508 <gets+0x44>
  for(i=0; i+1 < max; ){
 540:	00048993          	mv	s3,s1
 544:	0080006f          	j	54c <gets+0x88>
 548:	00048993          	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 54c:	013b89b3          	add	s3,s7,s3
 550:	00098023          	sb	zero,0(s3)
  return buf;
}
 554:	000b8513          	mv	a0,s7
 558:	05813083          	ld	ra,88(sp)
 55c:	05013403          	ld	s0,80(sp)
 560:	04813483          	ld	s1,72(sp)
 564:	04013903          	ld	s2,64(sp)
 568:	03813983          	ld	s3,56(sp)
 56c:	03013a03          	ld	s4,48(sp)
 570:	02813a83          	ld	s5,40(sp)
 574:	02013b03          	ld	s6,32(sp)
 578:	01813b83          	ld	s7,24(sp)
 57c:	06010113          	add	sp,sp,96
 580:	00008067          	ret

0000000000000584 <stat>:

int
stat(const char *n, struct stat *st)
{
 584:	fe010113          	add	sp,sp,-32
 588:	00113c23          	sd	ra,24(sp)
 58c:	00813823          	sd	s0,16(sp)
 590:	00913423          	sd	s1,8(sp)
 594:	01213023          	sd	s2,0(sp)
 598:	02010413          	add	s0,sp,32
 59c:	00058913          	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 5a0:	00000593          	li	a1,0
 5a4:	00000097          	auipc	ra,0x0
 5a8:	220080e7          	jalr	544(ra) # 7c4 <open>
  if(fd < 0)
 5ac:	04054063          	bltz	a0,5ec <stat+0x68>
 5b0:	00050493          	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 5b4:	00090593          	mv	a1,s2
 5b8:	00000097          	auipc	ra,0x0
 5bc:	230080e7          	jalr	560(ra) # 7e8 <fstat>
 5c0:	00050913          	mv	s2,a0
  close(fd);
 5c4:	00048513          	mv	a0,s1
 5c8:	00000097          	auipc	ra,0x0
 5cc:	1d8080e7          	jalr	472(ra) # 7a0 <close>
  return r;
}
 5d0:	00090513          	mv	a0,s2
 5d4:	01813083          	ld	ra,24(sp)
 5d8:	01013403          	ld	s0,16(sp)
 5dc:	00813483          	ld	s1,8(sp)
 5e0:	00013903          	ld	s2,0(sp)
 5e4:	02010113          	add	sp,sp,32
 5e8:	00008067          	ret
    return -1;
 5ec:	fff00913          	li	s2,-1
 5f0:	fe1ff06f          	j	5d0 <stat+0x4c>

00000000000005f4 <atoi>:

int
atoi(const char *s)
{
 5f4:	ff010113          	add	sp,sp,-16
 5f8:	00813423          	sd	s0,8(sp)
 5fc:	01010413          	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 600:	00054683          	lbu	a3,0(a0)
 604:	fd06879b          	addw	a5,a3,-48
 608:	0ff7f793          	zext.b	a5,a5
 60c:	00900613          	li	a2,9
 610:	04f66063          	bltu	a2,a5,650 <atoi+0x5c>
 614:	00050713          	mv	a4,a0
  n = 0;
 618:	00000513          	li	a0,0
    n = n*10 + *s++ - '0';
 61c:	00170713          	add	a4,a4,1
 620:	0025179b          	sllw	a5,a0,0x2
 624:	00a787bb          	addw	a5,a5,a0
 628:	0017979b          	sllw	a5,a5,0x1
 62c:	00d787bb          	addw	a5,a5,a3
 630:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 634:	00074683          	lbu	a3,0(a4)
 638:	fd06879b          	addw	a5,a3,-48
 63c:	0ff7f793          	zext.b	a5,a5
 640:	fcf67ee3          	bgeu	a2,a5,61c <atoi+0x28>
  return n;
}
 644:	00813403          	ld	s0,8(sp)
 648:	01010113          	add	sp,sp,16
 64c:	00008067          	ret
  n = 0;
 650:	00000513          	li	a0,0
 654:	ff1ff06f          	j	644 <atoi+0x50>

0000000000000658 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 658:	ff010113          	add	sp,sp,-16
 65c:	00813423          	sd	s0,8(sp)
 660:	01010413          	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 664:	02b57c63          	bgeu	a0,a1,69c <memmove+0x44>
    while(n-- > 0)
 668:	02c05463          	blez	a2,690 <memmove+0x38>
 66c:	02061613          	sll	a2,a2,0x20
 670:	02065613          	srl	a2,a2,0x20
 674:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 678:	00050713          	mv	a4,a0
      *dst++ = *src++;
 67c:	00158593          	add	a1,a1,1
 680:	00170713          	add	a4,a4,1
 684:	fff5c683          	lbu	a3,-1(a1)
 688:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 68c:	fee798e3          	bne	a5,a4,67c <memmove+0x24>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 690:	00813403          	ld	s0,8(sp)
 694:	01010113          	add	sp,sp,16
 698:	00008067          	ret
    dst += n;
 69c:	00c50733          	add	a4,a0,a2
    src += n;
 6a0:	00c585b3          	add	a1,a1,a2
    while(n-- > 0)
 6a4:	fec056e3          	blez	a2,690 <memmove+0x38>
 6a8:	fff6079b          	addw	a5,a2,-1
 6ac:	02079793          	sll	a5,a5,0x20
 6b0:	0207d793          	srl	a5,a5,0x20
 6b4:	fff7c793          	not	a5,a5
 6b8:	00f707b3          	add	a5,a4,a5
      *--dst = *--src;
 6bc:	fff58593          	add	a1,a1,-1
 6c0:	fff70713          	add	a4,a4,-1
 6c4:	0005c683          	lbu	a3,0(a1)
 6c8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 6cc:	fee798e3          	bne	a5,a4,6bc <memmove+0x64>
 6d0:	fc1ff06f          	j	690 <memmove+0x38>

00000000000006d4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 6d4:	ff010113          	add	sp,sp,-16
 6d8:	00813423          	sd	s0,8(sp)
 6dc:	01010413          	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 6e0:	04060463          	beqz	a2,728 <memcmp+0x54>
 6e4:	fff6069b          	addw	a3,a2,-1
 6e8:	02069693          	sll	a3,a3,0x20
 6ec:	0206d693          	srl	a3,a3,0x20
 6f0:	00168693          	add	a3,a3,1
 6f4:	00d506b3          	add	a3,a0,a3
    if (*p1 != *p2) {
 6f8:	00054783          	lbu	a5,0(a0)
 6fc:	0005c703          	lbu	a4,0(a1)
 700:	00e79c63          	bne	a5,a4,718 <memcmp+0x44>
      return *p1 - *p2;
    }
    p1++;
 704:	00150513          	add	a0,a0,1
    p2++;
 708:	00158593          	add	a1,a1,1
  while (n-- > 0) {
 70c:	fed516e3          	bne	a0,a3,6f8 <memcmp+0x24>
  }
  return 0;
 710:	00000513          	li	a0,0
 714:	0080006f          	j	71c <memcmp+0x48>
      return *p1 - *p2;
 718:	40e7853b          	subw	a0,a5,a4
}
 71c:	00813403          	ld	s0,8(sp)
 720:	01010113          	add	sp,sp,16
 724:	00008067          	ret
  return 0;
 728:	00000513          	li	a0,0
 72c:	ff1ff06f          	j	71c <memcmp+0x48>

0000000000000730 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 730:	ff010113          	add	sp,sp,-16
 734:	00113423          	sd	ra,8(sp)
 738:	00813023          	sd	s0,0(sp)
 73c:	01010413          	add	s0,sp,16
  return memmove(dst, src, n);
 740:	00000097          	auipc	ra,0x0
 744:	f18080e7          	jalr	-232(ra) # 658 <memmove>
}
 748:	00813083          	ld	ra,8(sp)
 74c:	00013403          	ld	s0,0(sp)
 750:	01010113          	add	sp,sp,16
 754:	00008067          	ret

0000000000000758 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 758:	00100893          	li	a7,1
 ecall
 75c:	00000073          	ecall
 ret
 760:	00008067          	ret

0000000000000764 <exit>:
.global exit
exit:
 li a7, SYS_exit
 764:	00200893          	li	a7,2
 ecall
 768:	00000073          	ecall
 ret
 76c:	00008067          	ret

0000000000000770 <wait>:
.global wait
wait:
 li a7, SYS_wait
 770:	00300893          	li	a7,3
 ecall
 774:	00000073          	ecall
 ret
 778:	00008067          	ret

000000000000077c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 77c:	00400893          	li	a7,4
 ecall
 780:	00000073          	ecall
 ret
 784:	00008067          	ret

0000000000000788 <read>:
.global read
read:
 li a7, SYS_read
 788:	00500893          	li	a7,5
 ecall
 78c:	00000073          	ecall
 ret
 790:	00008067          	ret

0000000000000794 <write>:
.global write
write:
 li a7, SYS_write
 794:	01000893          	li	a7,16
 ecall
 798:	00000073          	ecall
 ret
 79c:	00008067          	ret

00000000000007a0 <close>:
.global close
close:
 li a7, SYS_close
 7a0:	01500893          	li	a7,21
 ecall
 7a4:	00000073          	ecall
 ret
 7a8:	00008067          	ret

00000000000007ac <kill>:
.global kill
kill:
 li a7, SYS_kill
 7ac:	00600893          	li	a7,6
 ecall
 7b0:	00000073          	ecall
 ret
 7b4:	00008067          	ret

00000000000007b8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 7b8:	00700893          	li	a7,7
 ecall
 7bc:	00000073          	ecall
 ret
 7c0:	00008067          	ret

00000000000007c4 <open>:
.global open
open:
 li a7, SYS_open
 7c4:	00f00893          	li	a7,15
 ecall
 7c8:	00000073          	ecall
 ret
 7cc:	00008067          	ret

00000000000007d0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 7d0:	01100893          	li	a7,17
 ecall
 7d4:	00000073          	ecall
 ret
 7d8:	00008067          	ret

00000000000007dc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 7dc:	01200893          	li	a7,18
 ecall
 7e0:	00000073          	ecall
 ret
 7e4:	00008067          	ret

00000000000007e8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 7e8:	00800893          	li	a7,8
 ecall
 7ec:	00000073          	ecall
 ret
 7f0:	00008067          	ret

00000000000007f4 <link>:
.global link
link:
 li a7, SYS_link
 7f4:	01300893          	li	a7,19
 ecall
 7f8:	00000073          	ecall
 ret
 7fc:	00008067          	ret

0000000000000800 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 800:	01400893          	li	a7,20
 ecall
 804:	00000073          	ecall
 ret
 808:	00008067          	ret

000000000000080c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 80c:	00900893          	li	a7,9
 ecall
 810:	00000073          	ecall
 ret
 814:	00008067          	ret

0000000000000818 <dup>:
.global dup
dup:
 li a7, SYS_dup
 818:	00a00893          	li	a7,10
 ecall
 81c:	00000073          	ecall
 ret
 820:	00008067          	ret

0000000000000824 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 824:	00b00893          	li	a7,11
 ecall
 828:	00000073          	ecall
 ret
 82c:	00008067          	ret

0000000000000830 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 830:	00c00893          	li	a7,12
 ecall
 834:	00000073          	ecall
 ret
 838:	00008067          	ret

000000000000083c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 83c:	00d00893          	li	a7,13
 ecall
 840:	00000073          	ecall
 ret
 844:	00008067          	ret

0000000000000848 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 848:	00e00893          	li	a7,14
 ecall
 84c:	00000073          	ecall
 ret
 850:	00008067          	ret

0000000000000854 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 854:	fe010113          	add	sp,sp,-32
 858:	00113c23          	sd	ra,24(sp)
 85c:	00813823          	sd	s0,16(sp)
 860:	02010413          	add	s0,sp,32
 864:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 868:	00100613          	li	a2,1
 86c:	fef40593          	add	a1,s0,-17
 870:	00000097          	auipc	ra,0x0
 874:	f24080e7          	jalr	-220(ra) # 794 <write>
}
 878:	01813083          	ld	ra,24(sp)
 87c:	01013403          	ld	s0,16(sp)
 880:	02010113          	add	sp,sp,32
 884:	00008067          	ret

0000000000000888 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 888:	fc010113          	add	sp,sp,-64
 88c:	02113c23          	sd	ra,56(sp)
 890:	02813823          	sd	s0,48(sp)
 894:	02913423          	sd	s1,40(sp)
 898:	03213023          	sd	s2,32(sp)
 89c:	01313c23          	sd	s3,24(sp)
 8a0:	04010413          	add	s0,sp,64
 8a4:	00050493          	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 8a8:	00068463          	beqz	a3,8b0 <printint+0x28>
 8ac:	0c05c063          	bltz	a1,96c <printint+0xe4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 8b0:	0005859b          	sext.w	a1,a1
  neg = 0;
 8b4:	00000893          	li	a7,0
 8b8:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 8bc:	00000713          	li	a4,0
  do{
    buf[i++] = digits[x % base];
 8c0:	0006061b          	sext.w	a2,a2
 8c4:	00000517          	auipc	a0,0x0
 8c8:	69c50513          	add	a0,a0,1692 # f60 <digits>
 8cc:	00070813          	mv	a6,a4
 8d0:	0017071b          	addw	a4,a4,1
 8d4:	02c5f7bb          	remuw	a5,a1,a2
 8d8:	02079793          	sll	a5,a5,0x20
 8dc:	0207d793          	srl	a5,a5,0x20
 8e0:	00f507b3          	add	a5,a0,a5
 8e4:	0007c783          	lbu	a5,0(a5)
 8e8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 8ec:	0005879b          	sext.w	a5,a1
 8f0:	02c5d5bb          	divuw	a1,a1,a2
 8f4:	00168693          	add	a3,a3,1
 8f8:	fcc7fae3          	bgeu	a5,a2,8cc <printint+0x44>
  if(neg)
 8fc:	00088c63          	beqz	a7,914 <printint+0x8c>
    buf[i++] = '-';
 900:	fd070793          	add	a5,a4,-48
 904:	00878733          	add	a4,a5,s0
 908:	02d00793          	li	a5,45
 90c:	fef70823          	sb	a5,-16(a4)
 910:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 914:	02e05e63          	blez	a4,950 <printint+0xc8>
 918:	fc040793          	add	a5,s0,-64
 91c:	00e78933          	add	s2,a5,a4
 920:	fff78993          	add	s3,a5,-1
 924:	00e989b3          	add	s3,s3,a4
 928:	fff7071b          	addw	a4,a4,-1
 92c:	02071713          	sll	a4,a4,0x20
 930:	02075713          	srl	a4,a4,0x20
 934:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 938:	fff94583          	lbu	a1,-1(s2)
 93c:	00048513          	mv	a0,s1
 940:	00000097          	auipc	ra,0x0
 944:	f14080e7          	jalr	-236(ra) # 854 <putc>
  while(--i >= 0)
 948:	fff90913          	add	s2,s2,-1
 94c:	ff3916e3          	bne	s2,s3,938 <printint+0xb0>
}
 950:	03813083          	ld	ra,56(sp)
 954:	03013403          	ld	s0,48(sp)
 958:	02813483          	ld	s1,40(sp)
 95c:	02013903          	ld	s2,32(sp)
 960:	01813983          	ld	s3,24(sp)
 964:	04010113          	add	sp,sp,64
 968:	00008067          	ret
    x = -xx;
 96c:	40b005bb          	negw	a1,a1
    neg = 1;
 970:	00100893          	li	a7,1
    x = -xx;
 974:	f45ff06f          	j	8b8 <printint+0x30>

0000000000000978 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 978:	fb010113          	add	sp,sp,-80
 97c:	04113423          	sd	ra,72(sp)
 980:	04813023          	sd	s0,64(sp)
 984:	02913c23          	sd	s1,56(sp)
 988:	03213823          	sd	s2,48(sp)
 98c:	03313423          	sd	s3,40(sp)
 990:	03413023          	sd	s4,32(sp)
 994:	01513c23          	sd	s5,24(sp)
 998:	01613823          	sd	s6,16(sp)
 99c:	01713423          	sd	s7,8(sp)
 9a0:	01813023          	sd	s8,0(sp)
 9a4:	05010413          	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 9a8:	0005c903          	lbu	s2,0(a1)
 9ac:	20090e63          	beqz	s2,bc8 <vprintf+0x250>
 9b0:	00050a93          	mv	s5,a0
 9b4:	00060b93          	mv	s7,a2
 9b8:	00158493          	add	s1,a1,1
  state = 0;
 9bc:	00000993          	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 9c0:	02500a13          	li	s4,37
 9c4:	01500b13          	li	s6,21
 9c8:	0280006f          	j	9f0 <vprintf+0x78>
        putc(fd, c);
 9cc:	00090593          	mv	a1,s2
 9d0:	000a8513          	mv	a0,s5
 9d4:	00000097          	auipc	ra,0x0
 9d8:	e80080e7          	jalr	-384(ra) # 854 <putc>
 9dc:	0080006f          	j	9e4 <vprintf+0x6c>
    } else if(state == '%'){
 9e0:	03498063          	beq	s3,s4,a00 <vprintf+0x88>
  for(i = 0; fmt[i]; i++){
 9e4:	00148493          	add	s1,s1,1
 9e8:	fff4c903          	lbu	s2,-1(s1)
 9ec:	1c090e63          	beqz	s2,bc8 <vprintf+0x250>
    if(state == 0){
 9f0:	fe0998e3          	bnez	s3,9e0 <vprintf+0x68>
      if(c == '%'){
 9f4:	fd491ce3          	bne	s2,s4,9cc <vprintf+0x54>
        state = '%';
 9f8:	000a0993          	mv	s3,s4
 9fc:	fe9ff06f          	j	9e4 <vprintf+0x6c>
      if(c == 'd'){
 a00:	17490e63          	beq	s2,s4,b7c <vprintf+0x204>
 a04:	f9d9079b          	addw	a5,s2,-99
 a08:	0ff7f793          	zext.b	a5,a5
 a0c:	18fb6463          	bltu	s6,a5,b94 <vprintf+0x21c>
 a10:	f9d9079b          	addw	a5,s2,-99
 a14:	0ff7f713          	zext.b	a4,a5
 a18:	16eb6e63          	bltu	s6,a4,b94 <vprintf+0x21c>
 a1c:	00271793          	sll	a5,a4,0x2
 a20:	00000717          	auipc	a4,0x0
 a24:	4e870713          	add	a4,a4,1256 # f08 <malloc+0x1c4>
 a28:	00e787b3          	add	a5,a5,a4
 a2c:	0007a783          	lw	a5,0(a5)
 a30:	00e787b3          	add	a5,a5,a4
 a34:	00078067          	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 a38:	008b8913          	add	s2,s7,8
 a3c:	00100693          	li	a3,1
 a40:	00a00613          	li	a2,10
 a44:	000ba583          	lw	a1,0(s7)
 a48:	000a8513          	mv	a0,s5
 a4c:	00000097          	auipc	ra,0x0
 a50:	e3c080e7          	jalr	-452(ra) # 888 <printint>
 a54:	00090b93          	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 a58:	00000993          	li	s3,0
 a5c:	f89ff06f          	j	9e4 <vprintf+0x6c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 a60:	008b8913          	add	s2,s7,8
 a64:	00000693          	li	a3,0
 a68:	00a00613          	li	a2,10
 a6c:	000ba583          	lw	a1,0(s7)
 a70:	000a8513          	mv	a0,s5
 a74:	00000097          	auipc	ra,0x0
 a78:	e14080e7          	jalr	-492(ra) # 888 <printint>
 a7c:	00090b93          	mv	s7,s2
      state = 0;
 a80:	00000993          	li	s3,0
 a84:	f61ff06f          	j	9e4 <vprintf+0x6c>
        printint(fd, va_arg(ap, int), 16, 0);
 a88:	008b8913          	add	s2,s7,8
 a8c:	00000693          	li	a3,0
 a90:	01000613          	li	a2,16
 a94:	000ba583          	lw	a1,0(s7)
 a98:	000a8513          	mv	a0,s5
 a9c:	00000097          	auipc	ra,0x0
 aa0:	dec080e7          	jalr	-532(ra) # 888 <printint>
 aa4:	00090b93          	mv	s7,s2
      state = 0;
 aa8:	00000993          	li	s3,0
 aac:	f39ff06f          	j	9e4 <vprintf+0x6c>
        printptr(fd, va_arg(ap, uint64));
 ab0:	008b8c13          	add	s8,s7,8
 ab4:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 ab8:	03000593          	li	a1,48
 abc:	000a8513          	mv	a0,s5
 ac0:	00000097          	auipc	ra,0x0
 ac4:	d94080e7          	jalr	-620(ra) # 854 <putc>
  putc(fd, 'x');
 ac8:	07800593          	li	a1,120
 acc:	000a8513          	mv	a0,s5
 ad0:	00000097          	auipc	ra,0x0
 ad4:	d84080e7          	jalr	-636(ra) # 854 <putc>
 ad8:	01000913          	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 adc:	00000b97          	auipc	s7,0x0
 ae0:	484b8b93          	add	s7,s7,1156 # f60 <digits>
 ae4:	03c9d793          	srl	a5,s3,0x3c
 ae8:	00fb87b3          	add	a5,s7,a5
 aec:	0007c583          	lbu	a1,0(a5)
 af0:	000a8513          	mv	a0,s5
 af4:	00000097          	auipc	ra,0x0
 af8:	d60080e7          	jalr	-672(ra) # 854 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 afc:	00499993          	sll	s3,s3,0x4
 b00:	fff9091b          	addw	s2,s2,-1
 b04:	fe0910e3          	bnez	s2,ae4 <vprintf+0x16c>
        printptr(fd, va_arg(ap, uint64));
 b08:	000c0b93          	mv	s7,s8
      state = 0;
 b0c:	00000993          	li	s3,0
 b10:	ed5ff06f          	j	9e4 <vprintf+0x6c>
        s = va_arg(ap, char*);
 b14:	008b8993          	add	s3,s7,8
 b18:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 b1c:	02090863          	beqz	s2,b4c <vprintf+0x1d4>
        while(*s != 0){
 b20:	00094583          	lbu	a1,0(s2)
 b24:	08058c63          	beqz	a1,bbc <vprintf+0x244>
          putc(fd, *s);
 b28:	000a8513          	mv	a0,s5
 b2c:	00000097          	auipc	ra,0x0
 b30:	d28080e7          	jalr	-728(ra) # 854 <putc>
          s++;
 b34:	00190913          	add	s2,s2,1
        while(*s != 0){
 b38:	00094583          	lbu	a1,0(s2)
 b3c:	fe0596e3          	bnez	a1,b28 <vprintf+0x1b0>
        s = va_arg(ap, char*);
 b40:	00098b93          	mv	s7,s3
      state = 0;
 b44:	00000993          	li	s3,0
 b48:	e9dff06f          	j	9e4 <vprintf+0x6c>
          s = "(null)";
 b4c:	00000917          	auipc	s2,0x0
 b50:	3b490913          	add	s2,s2,948 # f00 <malloc+0x1bc>
        while(*s != 0){
 b54:	02800593          	li	a1,40
 b58:	fd1ff06f          	j	b28 <vprintf+0x1b0>
        putc(fd, va_arg(ap, uint));
 b5c:	008b8913          	add	s2,s7,8
 b60:	000bc583          	lbu	a1,0(s7)
 b64:	000a8513          	mv	a0,s5
 b68:	00000097          	auipc	ra,0x0
 b6c:	cec080e7          	jalr	-788(ra) # 854 <putc>
 b70:	00090b93          	mv	s7,s2
      state = 0;
 b74:	00000993          	li	s3,0
 b78:	e6dff06f          	j	9e4 <vprintf+0x6c>
        putc(fd, c);
 b7c:	02500593          	li	a1,37
 b80:	000a8513          	mv	a0,s5
 b84:	00000097          	auipc	ra,0x0
 b88:	cd0080e7          	jalr	-816(ra) # 854 <putc>
      state = 0;
 b8c:	00000993          	li	s3,0
 b90:	e55ff06f          	j	9e4 <vprintf+0x6c>
        putc(fd, '%');
 b94:	02500593          	li	a1,37
 b98:	000a8513          	mv	a0,s5
 b9c:	00000097          	auipc	ra,0x0
 ba0:	cb8080e7          	jalr	-840(ra) # 854 <putc>
        putc(fd, c);
 ba4:	00090593          	mv	a1,s2
 ba8:	000a8513          	mv	a0,s5
 bac:	00000097          	auipc	ra,0x0
 bb0:	ca8080e7          	jalr	-856(ra) # 854 <putc>
      state = 0;
 bb4:	00000993          	li	s3,0
 bb8:	e2dff06f          	j	9e4 <vprintf+0x6c>
        s = va_arg(ap, char*);
 bbc:	00098b93          	mv	s7,s3
      state = 0;
 bc0:	00000993          	li	s3,0
 bc4:	e21ff06f          	j	9e4 <vprintf+0x6c>
    }
  }
}
 bc8:	04813083          	ld	ra,72(sp)
 bcc:	04013403          	ld	s0,64(sp)
 bd0:	03813483          	ld	s1,56(sp)
 bd4:	03013903          	ld	s2,48(sp)
 bd8:	02813983          	ld	s3,40(sp)
 bdc:	02013a03          	ld	s4,32(sp)
 be0:	01813a83          	ld	s5,24(sp)
 be4:	01013b03          	ld	s6,16(sp)
 be8:	00813b83          	ld	s7,8(sp)
 bec:	00013c03          	ld	s8,0(sp)
 bf0:	05010113          	add	sp,sp,80
 bf4:	00008067          	ret

0000000000000bf8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 bf8:	fb010113          	add	sp,sp,-80
 bfc:	00113c23          	sd	ra,24(sp)
 c00:	00813823          	sd	s0,16(sp)
 c04:	02010413          	add	s0,sp,32
 c08:	00c43023          	sd	a2,0(s0)
 c0c:	00d43423          	sd	a3,8(s0)
 c10:	00e43823          	sd	a4,16(s0)
 c14:	00f43c23          	sd	a5,24(s0)
 c18:	03043023          	sd	a6,32(s0)
 c1c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 c20:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 c24:	00040613          	mv	a2,s0
 c28:	00000097          	auipc	ra,0x0
 c2c:	d50080e7          	jalr	-688(ra) # 978 <vprintf>
}
 c30:	01813083          	ld	ra,24(sp)
 c34:	01013403          	ld	s0,16(sp)
 c38:	05010113          	add	sp,sp,80
 c3c:	00008067          	ret

0000000000000c40 <printf>:

void
printf(const char *fmt, ...)
{
 c40:	fa010113          	add	sp,sp,-96
 c44:	00113c23          	sd	ra,24(sp)
 c48:	00813823          	sd	s0,16(sp)
 c4c:	02010413          	add	s0,sp,32
 c50:	00b43423          	sd	a1,8(s0)
 c54:	00c43823          	sd	a2,16(s0)
 c58:	00d43c23          	sd	a3,24(s0)
 c5c:	02e43023          	sd	a4,32(s0)
 c60:	02f43423          	sd	a5,40(s0)
 c64:	03043823          	sd	a6,48(s0)
 c68:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 c6c:	00840613          	add	a2,s0,8
 c70:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 c74:	00050593          	mv	a1,a0
 c78:	00100513          	li	a0,1
 c7c:	00000097          	auipc	ra,0x0
 c80:	cfc080e7          	jalr	-772(ra) # 978 <vprintf>
}
 c84:	01813083          	ld	ra,24(sp)
 c88:	01013403          	ld	s0,16(sp)
 c8c:	06010113          	add	sp,sp,96
 c90:	00008067          	ret

0000000000000c94 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 c94:	ff010113          	add	sp,sp,-16
 c98:	00813423          	sd	s0,8(sp)
 c9c:	01010413          	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 ca0:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ca4:	00000797          	auipc	a5,0x0
 ca8:	35c7b783          	ld	a5,860(a5) # 1000 <freep>
 cac:	0400006f          	j	cec <free+0x58>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 cb0:	00862703          	lw	a4,8(a2)
 cb4:	00b7073b          	addw	a4,a4,a1
 cb8:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 cbc:	0007b703          	ld	a4,0(a5)
 cc0:	00073603          	ld	a2,0(a4)
 cc4:	0500006f          	j	d14 <free+0x80>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 cc8:	ff852703          	lw	a4,-8(a0)
 ccc:	00c7073b          	addw	a4,a4,a2
 cd0:	00e7a423          	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 cd4:	ff053683          	ld	a3,-16(a0)
 cd8:	0540006f          	j	d2c <free+0x98>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 cdc:	0007b703          	ld	a4,0(a5)
 ce0:	00e7e463          	bltu	a5,a4,ce8 <free+0x54>
 ce4:	00e6ec63          	bltu	a3,a4,cfc <free+0x68>
{
 ce8:	00070793          	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 cec:	fed7f8e3          	bgeu	a5,a3,cdc <free+0x48>
 cf0:	0007b703          	ld	a4,0(a5)
 cf4:	00e6e463          	bltu	a3,a4,cfc <free+0x68>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 cf8:	fee7e8e3          	bltu	a5,a4,ce8 <free+0x54>
  if(bp + bp->s.size == p->s.ptr){
 cfc:	ff852583          	lw	a1,-8(a0)
 d00:	0007b603          	ld	a2,0(a5)
 d04:	02059813          	sll	a6,a1,0x20
 d08:	01c85713          	srl	a4,a6,0x1c
 d0c:	00e68733          	add	a4,a3,a4
 d10:	fae600e3          	beq	a2,a4,cb0 <free+0x1c>
    bp->s.ptr = p->s.ptr->s.ptr;
 d14:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 d18:	0087a603          	lw	a2,8(a5)
 d1c:	02061593          	sll	a1,a2,0x20
 d20:	01c5d713          	srl	a4,a1,0x1c
 d24:	00e78733          	add	a4,a5,a4
 d28:	fae680e3          	beq	a3,a4,cc8 <free+0x34>
    p->s.ptr = bp->s.ptr;
 d2c:	00d7b023          	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 d30:	00000717          	auipc	a4,0x0
 d34:	2cf73823          	sd	a5,720(a4) # 1000 <freep>
}
 d38:	00813403          	ld	s0,8(sp)
 d3c:	01010113          	add	sp,sp,16
 d40:	00008067          	ret

0000000000000d44 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 d44:	fc010113          	add	sp,sp,-64
 d48:	02113c23          	sd	ra,56(sp)
 d4c:	02813823          	sd	s0,48(sp)
 d50:	02913423          	sd	s1,40(sp)
 d54:	03213023          	sd	s2,32(sp)
 d58:	01313c23          	sd	s3,24(sp)
 d5c:	01413823          	sd	s4,16(sp)
 d60:	01513423          	sd	s5,8(sp)
 d64:	01613023          	sd	s6,0(sp)
 d68:	04010413          	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d6c:	02051493          	sll	s1,a0,0x20
 d70:	0204d493          	srl	s1,s1,0x20
 d74:	00f48493          	add	s1,s1,15
 d78:	0044d493          	srl	s1,s1,0x4
 d7c:	0014899b          	addw	s3,s1,1
 d80:	00148493          	add	s1,s1,1
  if((prevp = freep) == 0){
 d84:	00000517          	auipc	a0,0x0
 d88:	27c53503          	ld	a0,636(a0) # 1000 <freep>
 d8c:	02050e63          	beqz	a0,dc8 <malloc+0x84>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d90:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
 d94:	0087a703          	lw	a4,8(a5)
 d98:	04977663          	bgeu	a4,s1,de4 <malloc+0xa0>
  if(nu < 4096)
 d9c:	00098a13          	mv	s4,s3
 da0:	0009871b          	sext.w	a4,s3
 da4:	000016b7          	lui	a3,0x1
 da8:	00d77463          	bgeu	a4,a3,db0 <malloc+0x6c>
 dac:	00001a37          	lui	s4,0x1
 db0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 db4:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 db8:	00000917          	auipc	s2,0x0
 dbc:	24890913          	add	s2,s2,584 # 1000 <freep>
  if(p == (char*)-1)
 dc0:	fff00a93          	li	s5,-1
 dc4:	0a00006f          	j	e64 <malloc+0x120>
    base.s.ptr = freep = prevp = &base;
 dc8:	00000797          	auipc	a5,0x0
 dcc:	25878793          	add	a5,a5,600 # 1020 <base>
 dd0:	00000717          	auipc	a4,0x0
 dd4:	22f73823          	sd	a5,560(a4) # 1000 <freep>
 dd8:	00f7b023          	sd	a5,0(a5)
    base.s.size = 0;
 ddc:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 de0:	fbdff06f          	j	d9c <malloc+0x58>
      if(p->s.size == nunits)
 de4:	04e48863          	beq	s1,a4,e34 <malloc+0xf0>
        p->s.size -= nunits;
 de8:	4137073b          	subw	a4,a4,s3
 dec:	00e7a423          	sw	a4,8(a5)
        p += p->s.size;
 df0:	02071693          	sll	a3,a4,0x20
 df4:	01c6d713          	srl	a4,a3,0x1c
 df8:	00e787b3          	add	a5,a5,a4
        p->s.size = nunits;
 dfc:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 e00:	00000717          	auipc	a4,0x0
 e04:	20a73023          	sd	a0,512(a4) # 1000 <freep>
      return (void*)(p + 1);
 e08:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 e0c:	03813083          	ld	ra,56(sp)
 e10:	03013403          	ld	s0,48(sp)
 e14:	02813483          	ld	s1,40(sp)
 e18:	02013903          	ld	s2,32(sp)
 e1c:	01813983          	ld	s3,24(sp)
 e20:	01013a03          	ld	s4,16(sp)
 e24:	00813a83          	ld	s5,8(sp)
 e28:	00013b03          	ld	s6,0(sp)
 e2c:	04010113          	add	sp,sp,64
 e30:	00008067          	ret
        prevp->s.ptr = p->s.ptr;
 e34:	0007b703          	ld	a4,0(a5)
 e38:	00e53023          	sd	a4,0(a0)
 e3c:	fc5ff06f          	j	e00 <malloc+0xbc>
  hp->s.size = nu;
 e40:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 e44:	01050513          	add	a0,a0,16
 e48:	00000097          	auipc	ra,0x0
 e4c:	e4c080e7          	jalr	-436(ra) # c94 <free>
  return freep;
 e50:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 e54:	fa050ce3          	beqz	a0,e0c <malloc+0xc8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 e58:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
 e5c:	0087a703          	lw	a4,8(a5)
 e60:	f89772e3          	bgeu	a4,s1,de4 <malloc+0xa0>
    if(p == freep)
 e64:	00093703          	ld	a4,0(s2)
 e68:	00078513          	mv	a0,a5
 e6c:	fef716e3          	bne	a4,a5,e58 <malloc+0x114>
  p = sbrk(nu * sizeof(Header));
 e70:	000a0513          	mv	a0,s4
 e74:	00000097          	auipc	ra,0x0
 e78:	9bc080e7          	jalr	-1604(ra) # 830 <sbrk>
  if(p == (char*)-1)
 e7c:	fd5512e3          	bne	a0,s5,e40 <malloc+0xfc>
        return 0;
 e80:	00000513          	li	a0,0
 e84:	f89ff06f          	j	e0c <malloc+0xc8>
