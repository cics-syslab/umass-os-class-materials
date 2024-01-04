
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	ff010113          	add	sp,sp,-16
       4:	00113423          	sd	ra,8(sp)
       8:	00813023          	sd	s0,0(sp)
       c:	01010413          	add	s0,sp,16
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };

  for(int ai = 0; ai < 2; ai++){
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      10:	20100593          	li	a1,513
      14:	00100513          	li	a0,1
      18:	01f51513          	sll	a0,a0,0x1f
      1c:	00007097          	auipc	ra,0x7
      20:	07c080e7          	jalr	124(ra) # 7098 <open>
    if(fd >= 0){
      24:	02055663          	bgez	a0,50 <copyinstr1+0x50>
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      28:	20100593          	li	a1,513
      2c:	fff00513          	li	a0,-1
      30:	00007097          	auipc	ra,0x7
      34:	068080e7          	jalr	104(ra) # 7098 <open>
    uint64 addr = addrs[ai];
      38:	fff00593          	li	a1,-1
    if(fd >= 0){
      3c:	00055e63          	bgez	a0,58 <copyinstr1+0x58>
      printf("open(%p) returned %d, not -1\n", addr, fd);
      exit(1);
    }
  }
}
      40:	00813083          	ld	ra,8(sp)
      44:	00013403          	ld	s0,0(sp)
      48:	01010113          	add	sp,sp,16
      4c:	00008067          	ret
    uint64 addr = addrs[ai];
      50:	00100593          	li	a1,1
      54:	01f59593          	sll	a1,a1,0x1f
      printf("open(%p) returned %d, not -1\n", addr, fd);
      58:	00050613          	mv	a2,a0
      5c:	00007517          	auipc	a0,0x7
      60:	70450513          	add	a0,a0,1796 # 7760 <malloc+0x148>
      64:	00007097          	auipc	ra,0x7
      68:	4b0080e7          	jalr	1200(ra) # 7514 <printf>
      exit(1);
      6c:	00100513          	li	a0,1
      70:	00007097          	auipc	ra,0x7
      74:	fc8080e7          	jalr	-56(ra) # 7038 <exit>

0000000000000078 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      78:	0000b797          	auipc	a5,0xb
      7c:	4f078793          	add	a5,a5,1264 # b568 <uninit>
      80:	0000e697          	auipc	a3,0xe
      84:	bf868693          	add	a3,a3,-1032 # dc78 <buf>
    if(uninit[i] != '\0'){
      88:	0007c703          	lbu	a4,0(a5)
      8c:	00071863          	bnez	a4,9c <bsstest+0x24>
  for(i = 0; i < sizeof(uninit); i++){
      90:	00178793          	add	a5,a5,1
      94:	fed79ae3          	bne	a5,a3,88 <bsstest+0x10>
      98:	00008067          	ret
{
      9c:	ff010113          	add	sp,sp,-16
      a0:	00113423          	sd	ra,8(sp)
      a4:	00813023          	sd	s0,0(sp)
      a8:	01010413          	add	s0,sp,16
      printf("%s: bss test failed\n", s);
      ac:	00050593          	mv	a1,a0
      b0:	00007517          	auipc	a0,0x7
      b4:	6d050513          	add	a0,a0,1744 # 7780 <malloc+0x168>
      b8:	00007097          	auipc	ra,0x7
      bc:	45c080e7          	jalr	1116(ra) # 7514 <printf>
      exit(1);
      c0:	00100513          	li	a0,1
      c4:	00007097          	auipc	ra,0x7
      c8:	f74080e7          	jalr	-140(ra) # 7038 <exit>

00000000000000cc <opentest>:
{
      cc:	fe010113          	add	sp,sp,-32
      d0:	00113c23          	sd	ra,24(sp)
      d4:	00813823          	sd	s0,16(sp)
      d8:	00913423          	sd	s1,8(sp)
      dc:	02010413          	add	s0,sp,32
      e0:	00050493          	mv	s1,a0
  fd = open("echo", 0);
      e4:	00000593          	li	a1,0
      e8:	00007517          	auipc	a0,0x7
      ec:	6b050513          	add	a0,a0,1712 # 7798 <malloc+0x180>
      f0:	00007097          	auipc	ra,0x7
      f4:	fa8080e7          	jalr	-88(ra) # 7098 <open>
  if(fd < 0){
      f8:	02054c63          	bltz	a0,130 <opentest+0x64>
  close(fd);
      fc:	00007097          	auipc	ra,0x7
     100:	f78080e7          	jalr	-136(ra) # 7074 <close>
  fd = open("doesnotexist", 0);
     104:	00000593          	li	a1,0
     108:	00007517          	auipc	a0,0x7
     10c:	6b050513          	add	a0,a0,1712 # 77b8 <malloc+0x1a0>
     110:	00007097          	auipc	ra,0x7
     114:	f88080e7          	jalr	-120(ra) # 7098 <open>
  if(fd >= 0){
     118:	02055c63          	bgez	a0,150 <opentest+0x84>
}
     11c:	01813083          	ld	ra,24(sp)
     120:	01013403          	ld	s0,16(sp)
     124:	00813483          	ld	s1,8(sp)
     128:	02010113          	add	sp,sp,32
     12c:	00008067          	ret
    printf("%s: open echo failed!\n", s);
     130:	00048593          	mv	a1,s1
     134:	00007517          	auipc	a0,0x7
     138:	66c50513          	add	a0,a0,1644 # 77a0 <malloc+0x188>
     13c:	00007097          	auipc	ra,0x7
     140:	3d8080e7          	jalr	984(ra) # 7514 <printf>
    exit(1);
     144:	00100513          	li	a0,1
     148:	00007097          	auipc	ra,0x7
     14c:	ef0080e7          	jalr	-272(ra) # 7038 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     150:	00048593          	mv	a1,s1
     154:	00007517          	auipc	a0,0x7
     158:	67450513          	add	a0,a0,1652 # 77c8 <malloc+0x1b0>
     15c:	00007097          	auipc	ra,0x7
     160:	3b8080e7          	jalr	952(ra) # 7514 <printf>
    exit(1);
     164:	00100513          	li	a0,1
     168:	00007097          	auipc	ra,0x7
     16c:	ed0080e7          	jalr	-304(ra) # 7038 <exit>

0000000000000170 <truncate2>:
{
     170:	fd010113          	add	sp,sp,-48
     174:	02113423          	sd	ra,40(sp)
     178:	02813023          	sd	s0,32(sp)
     17c:	00913c23          	sd	s1,24(sp)
     180:	01213823          	sd	s2,16(sp)
     184:	01313423          	sd	s3,8(sp)
     188:	03010413          	add	s0,sp,48
     18c:	00050993          	mv	s3,a0
  unlink("truncfile");
     190:	00007517          	auipc	a0,0x7
     194:	66050513          	add	a0,a0,1632 # 77f0 <malloc+0x1d8>
     198:	00007097          	auipc	ra,0x7
     19c:	f18080e7          	jalr	-232(ra) # 70b0 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     1a0:	60100593          	li	a1,1537
     1a4:	00007517          	auipc	a0,0x7
     1a8:	64c50513          	add	a0,a0,1612 # 77f0 <malloc+0x1d8>
     1ac:	00007097          	auipc	ra,0x7
     1b0:	eec080e7          	jalr	-276(ra) # 7098 <open>
     1b4:	00050493          	mv	s1,a0
  write(fd1, "abcd", 4);
     1b8:	00400613          	li	a2,4
     1bc:	00007597          	auipc	a1,0x7
     1c0:	64458593          	add	a1,a1,1604 # 7800 <malloc+0x1e8>
     1c4:	00007097          	auipc	ra,0x7
     1c8:	ea4080e7          	jalr	-348(ra) # 7068 <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     1cc:	40100593          	li	a1,1025
     1d0:	00007517          	auipc	a0,0x7
     1d4:	62050513          	add	a0,a0,1568 # 77f0 <malloc+0x1d8>
     1d8:	00007097          	auipc	ra,0x7
     1dc:	ec0080e7          	jalr	-320(ra) # 7098 <open>
     1e0:	00050913          	mv	s2,a0
  int n = write(fd1, "x", 1);
     1e4:	00100613          	li	a2,1
     1e8:	00007597          	auipc	a1,0x7
     1ec:	62058593          	add	a1,a1,1568 # 7808 <malloc+0x1f0>
     1f0:	00048513          	mv	a0,s1
     1f4:	00007097          	auipc	ra,0x7
     1f8:	e74080e7          	jalr	-396(ra) # 7068 <write>
  if(n != -1){
     1fc:	fff00793          	li	a5,-1
     200:	04f51463          	bne	a0,a5,248 <truncate2+0xd8>
  unlink("truncfile");
     204:	00007517          	auipc	a0,0x7
     208:	5ec50513          	add	a0,a0,1516 # 77f0 <malloc+0x1d8>
     20c:	00007097          	auipc	ra,0x7
     210:	ea4080e7          	jalr	-348(ra) # 70b0 <unlink>
  close(fd1);
     214:	00048513          	mv	a0,s1
     218:	00007097          	auipc	ra,0x7
     21c:	e5c080e7          	jalr	-420(ra) # 7074 <close>
  close(fd2);
     220:	00090513          	mv	a0,s2
     224:	00007097          	auipc	ra,0x7
     228:	e50080e7          	jalr	-432(ra) # 7074 <close>
}
     22c:	02813083          	ld	ra,40(sp)
     230:	02013403          	ld	s0,32(sp)
     234:	01813483          	ld	s1,24(sp)
     238:	01013903          	ld	s2,16(sp)
     23c:	00813983          	ld	s3,8(sp)
     240:	03010113          	add	sp,sp,48
     244:	00008067          	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     248:	00050613          	mv	a2,a0
     24c:	00098593          	mv	a1,s3
     250:	00007517          	auipc	a0,0x7
     254:	5c050513          	add	a0,a0,1472 # 7810 <malloc+0x1f8>
     258:	00007097          	auipc	ra,0x7
     25c:	2bc080e7          	jalr	700(ra) # 7514 <printf>
    exit(1);
     260:	00100513          	li	a0,1
     264:	00007097          	auipc	ra,0x7
     268:	dd4080e7          	jalr	-556(ra) # 7038 <exit>

000000000000026c <createtest>:
{
     26c:	fd010113          	add	sp,sp,-48
     270:	02113423          	sd	ra,40(sp)
     274:	02813023          	sd	s0,32(sp)
     278:	00913c23          	sd	s1,24(sp)
     27c:	01213823          	sd	s2,16(sp)
     280:	03010413          	add	s0,sp,48
  name[0] = 'a';
     284:	06100793          	li	a5,97
     288:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     28c:	fc040d23          	sb	zero,-38(s0)
     290:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     294:	06400913          	li	s2,100
    name[1] = '0' + i;
     298:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE|O_RDWR);
     29c:	20200593          	li	a1,514
     2a0:	fd840513          	add	a0,s0,-40
     2a4:	00007097          	auipc	ra,0x7
     2a8:	df4080e7          	jalr	-524(ra) # 7098 <open>
    close(fd);
     2ac:	00007097          	auipc	ra,0x7
     2b0:	dc8080e7          	jalr	-568(ra) # 7074 <close>
  for(i = 0; i < N; i++){
     2b4:	0014849b          	addw	s1,s1,1
     2b8:	0ff4f493          	zext.b	s1,s1
     2bc:	fd249ee3          	bne	s1,s2,298 <createtest+0x2c>
  name[0] = 'a';
     2c0:	06100793          	li	a5,97
     2c4:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     2c8:	fc040d23          	sb	zero,-38(s0)
     2cc:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     2d0:	06400913          	li	s2,100
    name[1] = '0' + i;
     2d4:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
     2d8:	fd840513          	add	a0,s0,-40
     2dc:	00007097          	auipc	ra,0x7
     2e0:	dd4080e7          	jalr	-556(ra) # 70b0 <unlink>
  for(i = 0; i < N; i++){
     2e4:	0014849b          	addw	s1,s1,1
     2e8:	0ff4f493          	zext.b	s1,s1
     2ec:	ff2494e3          	bne	s1,s2,2d4 <createtest+0x68>
}
     2f0:	02813083          	ld	ra,40(sp)
     2f4:	02013403          	ld	s0,32(sp)
     2f8:	01813483          	ld	s1,24(sp)
     2fc:	01013903          	ld	s2,16(sp)
     300:	03010113          	add	sp,sp,48
     304:	00008067          	ret

0000000000000308 <bigwrite>:
{
     308:	fb010113          	add	sp,sp,-80
     30c:	04113423          	sd	ra,72(sp)
     310:	04813023          	sd	s0,64(sp)
     314:	02913c23          	sd	s1,56(sp)
     318:	03213823          	sd	s2,48(sp)
     31c:	03313423          	sd	s3,40(sp)
     320:	03413023          	sd	s4,32(sp)
     324:	01513c23          	sd	s5,24(sp)
     328:	01613823          	sd	s6,16(sp)
     32c:	01713423          	sd	s7,8(sp)
     330:	05010413          	add	s0,sp,80
     334:	00050b93          	mv	s7,a0
  unlink("bigwrite");
     338:	00007517          	auipc	a0,0x7
     33c:	50050513          	add	a0,a0,1280 # 7838 <malloc+0x220>
     340:	00007097          	auipc	ra,0x7
     344:	d70080e7          	jalr	-656(ra) # 70b0 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     348:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     34c:	00007a97          	auipc	s5,0x7
     350:	4eca8a93          	add	s5,s5,1260 # 7838 <malloc+0x220>
      int cc = write(fd, buf, sz);
     354:	0000ea17          	auipc	s4,0xe
     358:	924a0a13          	add	s4,s4,-1756 # dc78 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     35c:	00003b37          	lui	s6,0x3
     360:	1c9b0b13          	add	s6,s6,457 # 31c9 <rwsbrk+0x14d>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     364:	20200593          	li	a1,514
     368:	000a8513          	mv	a0,s5
     36c:	00007097          	auipc	ra,0x7
     370:	d2c080e7          	jalr	-724(ra) # 7098 <open>
     374:	00050913          	mv	s2,a0
    if(fd < 0){
     378:	08054063          	bltz	a0,3f8 <bigwrite+0xf0>
      int cc = write(fd, buf, sz);
     37c:	00048613          	mv	a2,s1
     380:	000a0593          	mv	a1,s4
     384:	00007097          	auipc	ra,0x7
     388:	ce4080e7          	jalr	-796(ra) # 7068 <write>
     38c:	00050993          	mv	s3,a0
      if(cc != sz){
     390:	08a49463          	bne	s1,a0,418 <bigwrite+0x110>
      int cc = write(fd, buf, sz);
     394:	00048613          	mv	a2,s1
     398:	000a0593          	mv	a1,s4
     39c:	00090513          	mv	a0,s2
     3a0:	00007097          	auipc	ra,0x7
     3a4:	cc8080e7          	jalr	-824(ra) # 7068 <write>
      if(cc != sz){
     3a8:	06951a63          	bne	a0,s1,41c <bigwrite+0x114>
    close(fd);
     3ac:	00090513          	mv	a0,s2
     3b0:	00007097          	auipc	ra,0x7
     3b4:	cc4080e7          	jalr	-828(ra) # 7074 <close>
    unlink("bigwrite");
     3b8:	000a8513          	mv	a0,s5
     3bc:	00007097          	auipc	ra,0x7
     3c0:	cf4080e7          	jalr	-780(ra) # 70b0 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     3c4:	1d74849b          	addw	s1,s1,471
     3c8:	f9649ee3          	bne	s1,s6,364 <bigwrite+0x5c>
}
     3cc:	04813083          	ld	ra,72(sp)
     3d0:	04013403          	ld	s0,64(sp)
     3d4:	03813483          	ld	s1,56(sp)
     3d8:	03013903          	ld	s2,48(sp)
     3dc:	02813983          	ld	s3,40(sp)
     3e0:	02013a03          	ld	s4,32(sp)
     3e4:	01813a83          	ld	s5,24(sp)
     3e8:	01013b03          	ld	s6,16(sp)
     3ec:	00813b83          	ld	s7,8(sp)
     3f0:	05010113          	add	sp,sp,80
     3f4:	00008067          	ret
      printf("%s: cannot create bigwrite\n", s);
     3f8:	000b8593          	mv	a1,s7
     3fc:	00007517          	auipc	a0,0x7
     400:	44c50513          	add	a0,a0,1100 # 7848 <malloc+0x230>
     404:	00007097          	auipc	ra,0x7
     408:	110080e7          	jalr	272(ra) # 7514 <printf>
      exit(1);
     40c:	00100513          	li	a0,1
     410:	00007097          	auipc	ra,0x7
     414:	c28080e7          	jalr	-984(ra) # 7038 <exit>
      if(cc != sz){
     418:	00048993          	mv	s3,s1
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     41c:	00050693          	mv	a3,a0
     420:	00098613          	mv	a2,s3
     424:	000b8593          	mv	a1,s7
     428:	00007517          	auipc	a0,0x7
     42c:	44050513          	add	a0,a0,1088 # 7868 <malloc+0x250>
     430:	00007097          	auipc	ra,0x7
     434:	0e4080e7          	jalr	228(ra) # 7514 <printf>
        exit(1);
     438:	00100513          	li	a0,1
     43c:	00007097          	auipc	ra,0x7
     440:	bfc080e7          	jalr	-1028(ra) # 7038 <exit>

0000000000000444 <badwrite>:
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void
badwrite(char *s)
{
     444:	fd010113          	add	sp,sp,-48
     448:	02113423          	sd	ra,40(sp)
     44c:	02813023          	sd	s0,32(sp)
     450:	00913c23          	sd	s1,24(sp)
     454:	01213823          	sd	s2,16(sp)
     458:	01313423          	sd	s3,8(sp)
     45c:	01413023          	sd	s4,0(sp)
     460:	03010413          	add	s0,sp,48
  int assumed_free = 600;
  
  unlink("junk");
     464:	00007517          	auipc	a0,0x7
     468:	41c50513          	add	a0,a0,1052 # 7880 <malloc+0x268>
     46c:	00007097          	auipc	ra,0x7
     470:	c44080e7          	jalr	-956(ra) # 70b0 <unlink>
     474:	25800913          	li	s2,600
  for(int i = 0; i < assumed_free; i++){
    int fd = open("junk", O_CREATE|O_WRONLY);
     478:	00007997          	auipc	s3,0x7
     47c:	40898993          	add	s3,s3,1032 # 7880 <malloc+0x268>
    if(fd < 0){
      printf("open junk failed\n");
      exit(1);
    }
    write(fd, (char*)0xffffffffffL, 1);
     480:	fff00a13          	li	s4,-1
     484:	018a5a13          	srl	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
     488:	20100593          	li	a1,513
     48c:	00098513          	mv	a0,s3
     490:	00007097          	auipc	ra,0x7
     494:	c08080e7          	jalr	-1016(ra) # 7098 <open>
     498:	00050493          	mv	s1,a0
    if(fd < 0){
     49c:	08054463          	bltz	a0,524 <badwrite+0xe0>
    write(fd, (char*)0xffffffffffL, 1);
     4a0:	00100613          	li	a2,1
     4a4:	000a0593          	mv	a1,s4
     4a8:	00007097          	auipc	ra,0x7
     4ac:	bc0080e7          	jalr	-1088(ra) # 7068 <write>
    close(fd);
     4b0:	00048513          	mv	a0,s1
     4b4:	00007097          	auipc	ra,0x7
     4b8:	bc0080e7          	jalr	-1088(ra) # 7074 <close>
    unlink("junk");
     4bc:	00098513          	mv	a0,s3
     4c0:	00007097          	auipc	ra,0x7
     4c4:	bf0080e7          	jalr	-1040(ra) # 70b0 <unlink>
  for(int i = 0; i < assumed_free; i++){
     4c8:	fff9091b          	addw	s2,s2,-1
     4cc:	fa091ee3          	bnez	s2,488 <badwrite+0x44>
  }

  int fd = open("junk", O_CREATE|O_WRONLY);
     4d0:	20100593          	li	a1,513
     4d4:	00007517          	auipc	a0,0x7
     4d8:	3ac50513          	add	a0,a0,940 # 7880 <malloc+0x268>
     4dc:	00007097          	auipc	ra,0x7
     4e0:	bbc080e7          	jalr	-1092(ra) # 7098 <open>
     4e4:	00050493          	mv	s1,a0
  if(fd < 0){
     4e8:	04054c63          	bltz	a0,540 <badwrite+0xfc>
    printf("open junk failed\n");
    exit(1);
  }
  if(write(fd, "x", 1) != 1){
     4ec:	00100613          	li	a2,1
     4f0:	00007597          	auipc	a1,0x7
     4f4:	31858593          	add	a1,a1,792 # 7808 <malloc+0x1f0>
     4f8:	00007097          	auipc	ra,0x7
     4fc:	b70080e7          	jalr	-1168(ra) # 7068 <write>
     500:	00100793          	li	a5,1
     504:	04f50c63          	beq	a0,a5,55c <badwrite+0x118>
    printf("write failed\n");
     508:	00007517          	auipc	a0,0x7
     50c:	39850513          	add	a0,a0,920 # 78a0 <malloc+0x288>
     510:	00007097          	auipc	ra,0x7
     514:	004080e7          	jalr	4(ra) # 7514 <printf>
    exit(1);
     518:	00100513          	li	a0,1
     51c:	00007097          	auipc	ra,0x7
     520:	b1c080e7          	jalr	-1252(ra) # 7038 <exit>
      printf("open junk failed\n");
     524:	00007517          	auipc	a0,0x7
     528:	36450513          	add	a0,a0,868 # 7888 <malloc+0x270>
     52c:	00007097          	auipc	ra,0x7
     530:	fe8080e7          	jalr	-24(ra) # 7514 <printf>
      exit(1);
     534:	00100513          	li	a0,1
     538:	00007097          	auipc	ra,0x7
     53c:	b00080e7          	jalr	-1280(ra) # 7038 <exit>
    printf("open junk failed\n");
     540:	00007517          	auipc	a0,0x7
     544:	34850513          	add	a0,a0,840 # 7888 <malloc+0x270>
     548:	00007097          	auipc	ra,0x7
     54c:	fcc080e7          	jalr	-52(ra) # 7514 <printf>
    exit(1);
     550:	00100513          	li	a0,1
     554:	00007097          	auipc	ra,0x7
     558:	ae4080e7          	jalr	-1308(ra) # 7038 <exit>
  }
  close(fd);
     55c:	00048513          	mv	a0,s1
     560:	00007097          	auipc	ra,0x7
     564:	b14080e7          	jalr	-1260(ra) # 7074 <close>
  unlink("junk");
     568:	00007517          	auipc	a0,0x7
     56c:	31850513          	add	a0,a0,792 # 7880 <malloc+0x268>
     570:	00007097          	auipc	ra,0x7
     574:	b40080e7          	jalr	-1216(ra) # 70b0 <unlink>

  exit(0);
     578:	00000513          	li	a0,0
     57c:	00007097          	auipc	ra,0x7
     580:	abc080e7          	jalr	-1348(ra) # 7038 <exit>

0000000000000584 <outofinodes>:
  }
}

void
outofinodes(char *s)
{
     584:	fb010113          	add	sp,sp,-80
     588:	04113423          	sd	ra,72(sp)
     58c:	04813023          	sd	s0,64(sp)
     590:	02913c23          	sd	s1,56(sp)
     594:	03213823          	sd	s2,48(sp)
     598:	03313423          	sd	s3,40(sp)
     59c:	05010413          	add	s0,sp,80
  int nzz = 32*32;
  for(int i = 0; i < nzz; i++){
     5a0:	00000493          	li	s1,0
    char name[32];
    name[0] = 'z';
     5a4:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     5a8:	40000993          	li	s3,1024
    name[0] = 'z';
     5ac:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     5b0:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     5b4:	41f4d71b          	sraw	a4,s1,0x1f
     5b8:	01b7571b          	srlw	a4,a4,0x1b
     5bc:	009707bb          	addw	a5,a4,s1
     5c0:	4057d69b          	sraw	a3,a5,0x5
     5c4:	0306869b          	addw	a3,a3,48
     5c8:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     5cc:	01f7f793          	and	a5,a5,31
     5d0:	40e787bb          	subw	a5,a5,a4
     5d4:	0307879b          	addw	a5,a5,48
     5d8:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     5dc:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     5e0:	fb040513          	add	a0,s0,-80
     5e4:	00007097          	auipc	ra,0x7
     5e8:	acc080e7          	jalr	-1332(ra) # 70b0 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
     5ec:	60200593          	li	a1,1538
     5f0:	fb040513          	add	a0,s0,-80
     5f4:	00007097          	auipc	ra,0x7
     5f8:	aa4080e7          	jalr	-1372(ra) # 7098 <open>
    if(fd < 0){
     5fc:	00054a63          	bltz	a0,610 <outofinodes+0x8c>
      // failure is eventually expected.
      break;
    }
    close(fd);
     600:	00007097          	auipc	ra,0x7
     604:	a74080e7          	jalr	-1420(ra) # 7074 <close>
  for(int i = 0; i < nzz; i++){
     608:	0014849b          	addw	s1,s1,1
     60c:	fb3490e3          	bne	s1,s3,5ac <outofinodes+0x28>
     610:	00000493          	li	s1,0
  }

  for(int i = 0; i < nzz; i++){
    char name[32];
    name[0] = 'z';
     614:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     618:	40000993          	li	s3,1024
    name[0] = 'z';
     61c:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     620:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     624:	41f4d71b          	sraw	a4,s1,0x1f
     628:	01b7571b          	srlw	a4,a4,0x1b
     62c:	009707bb          	addw	a5,a4,s1
     630:	4057d69b          	sraw	a3,a5,0x5
     634:	0306869b          	addw	a3,a3,48
     638:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     63c:	01f7f793          	and	a5,a5,31
     640:	40e787bb          	subw	a5,a5,a4
     644:	0307879b          	addw	a5,a5,48
     648:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     64c:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     650:	fb040513          	add	a0,s0,-80
     654:	00007097          	auipc	ra,0x7
     658:	a5c080e7          	jalr	-1444(ra) # 70b0 <unlink>
  for(int i = 0; i < nzz; i++){
     65c:	0014849b          	addw	s1,s1,1
     660:	fb349ee3          	bne	s1,s3,61c <outofinodes+0x98>
  }
}
     664:	04813083          	ld	ra,72(sp)
     668:	04013403          	ld	s0,64(sp)
     66c:	03813483          	ld	s1,56(sp)
     670:	03013903          	ld	s2,48(sp)
     674:	02813983          	ld	s3,40(sp)
     678:	05010113          	add	sp,sp,80
     67c:	00008067          	ret

0000000000000680 <copyin>:
{
     680:	fb010113          	add	sp,sp,-80
     684:	04113423          	sd	ra,72(sp)
     688:	04813023          	sd	s0,64(sp)
     68c:	02913c23          	sd	s1,56(sp)
     690:	03213823          	sd	s2,48(sp)
     694:	03313423          	sd	s3,40(sp)
     698:	03413023          	sd	s4,32(sp)
     69c:	05010413          	add	s0,sp,80
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     6a0:	00100793          	li	a5,1
     6a4:	01f79793          	sll	a5,a5,0x1f
     6a8:	fcf43023          	sd	a5,-64(s0)
     6ac:	fff00793          	li	a5,-1
     6b0:	fcf43423          	sd	a5,-56(s0)
  for(int ai = 0; ai < 2; ai++){
     6b4:	fc040913          	add	s2,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     6b8:	00007a17          	auipc	s4,0x7
     6bc:	1f8a0a13          	add	s4,s4,504 # 78b0 <malloc+0x298>
    uint64 addr = addrs[ai];
     6c0:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     6c4:	20100593          	li	a1,513
     6c8:	000a0513          	mv	a0,s4
     6cc:	00007097          	auipc	ra,0x7
     6d0:	9cc080e7          	jalr	-1588(ra) # 7098 <open>
     6d4:	00050493          	mv	s1,a0
    if(fd < 0){
     6d8:	0a054a63          	bltz	a0,78c <copyin+0x10c>
    int n = write(fd, (void*)addr, 8192);
     6dc:	00002637          	lui	a2,0x2
     6e0:	00098593          	mv	a1,s3
     6e4:	00007097          	auipc	ra,0x7
     6e8:	984080e7          	jalr	-1660(ra) # 7068 <write>
    if(n >= 0){
     6ec:	0a055e63          	bgez	a0,7a8 <copyin+0x128>
    close(fd);
     6f0:	00048513          	mv	a0,s1
     6f4:	00007097          	auipc	ra,0x7
     6f8:	980080e7          	jalr	-1664(ra) # 7074 <close>
    unlink("copyin1");
     6fc:	000a0513          	mv	a0,s4
     700:	00007097          	auipc	ra,0x7
     704:	9b0080e7          	jalr	-1616(ra) # 70b0 <unlink>
    n = write(1, (char*)addr, 8192);
     708:	00002637          	lui	a2,0x2
     70c:	00098593          	mv	a1,s3
     710:	00100513          	li	a0,1
     714:	00007097          	auipc	ra,0x7
     718:	954080e7          	jalr	-1708(ra) # 7068 <write>
    if(n > 0){
     71c:	0aa04863          	bgtz	a0,7cc <copyin+0x14c>
    if(pipe(fds) < 0){
     720:	fb840513          	add	a0,s0,-72
     724:	00007097          	auipc	ra,0x7
     728:	92c080e7          	jalr	-1748(ra) # 7050 <pipe>
     72c:	0c054263          	bltz	a0,7f0 <copyin+0x170>
    n = write(fds[1], (char*)addr, 8192);
     730:	00002637          	lui	a2,0x2
     734:	00098593          	mv	a1,s3
     738:	fbc42503          	lw	a0,-68(s0)
     73c:	00007097          	auipc	ra,0x7
     740:	92c080e7          	jalr	-1748(ra) # 7068 <write>
    if(n > 0){
     744:	0ca04463          	bgtz	a0,80c <copyin+0x18c>
    close(fds[0]);
     748:	fb842503          	lw	a0,-72(s0)
     74c:	00007097          	auipc	ra,0x7
     750:	928080e7          	jalr	-1752(ra) # 7074 <close>
    close(fds[1]);
     754:	fbc42503          	lw	a0,-68(s0)
     758:	00007097          	auipc	ra,0x7
     75c:	91c080e7          	jalr	-1764(ra) # 7074 <close>
  for(int ai = 0; ai < 2; ai++){
     760:	00890913          	add	s2,s2,8
     764:	fd040793          	add	a5,s0,-48
     768:	f4f91ce3          	bne	s2,a5,6c0 <copyin+0x40>
}
     76c:	04813083          	ld	ra,72(sp)
     770:	04013403          	ld	s0,64(sp)
     774:	03813483          	ld	s1,56(sp)
     778:	03013903          	ld	s2,48(sp)
     77c:	02813983          	ld	s3,40(sp)
     780:	02013a03          	ld	s4,32(sp)
     784:	05010113          	add	sp,sp,80
     788:	00008067          	ret
      printf("open(copyin1) failed\n");
     78c:	00007517          	auipc	a0,0x7
     790:	12c50513          	add	a0,a0,300 # 78b8 <malloc+0x2a0>
     794:	00007097          	auipc	ra,0x7
     798:	d80080e7          	jalr	-640(ra) # 7514 <printf>
      exit(1);
     79c:	00100513          	li	a0,1
     7a0:	00007097          	auipc	ra,0x7
     7a4:	898080e7          	jalr	-1896(ra) # 7038 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     7a8:	00050613          	mv	a2,a0
     7ac:	00098593          	mv	a1,s3
     7b0:	00007517          	auipc	a0,0x7
     7b4:	12050513          	add	a0,a0,288 # 78d0 <malloc+0x2b8>
     7b8:	00007097          	auipc	ra,0x7
     7bc:	d5c080e7          	jalr	-676(ra) # 7514 <printf>
      exit(1);
     7c0:	00100513          	li	a0,1
     7c4:	00007097          	auipc	ra,0x7
     7c8:	874080e7          	jalr	-1932(ra) # 7038 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     7cc:	00050613          	mv	a2,a0
     7d0:	00098593          	mv	a1,s3
     7d4:	00007517          	auipc	a0,0x7
     7d8:	12c50513          	add	a0,a0,300 # 7900 <malloc+0x2e8>
     7dc:	00007097          	auipc	ra,0x7
     7e0:	d38080e7          	jalr	-712(ra) # 7514 <printf>
      exit(1);
     7e4:	00100513          	li	a0,1
     7e8:	00007097          	auipc	ra,0x7
     7ec:	850080e7          	jalr	-1968(ra) # 7038 <exit>
      printf("pipe() failed\n");
     7f0:	00007517          	auipc	a0,0x7
     7f4:	14050513          	add	a0,a0,320 # 7930 <malloc+0x318>
     7f8:	00007097          	auipc	ra,0x7
     7fc:	d1c080e7          	jalr	-740(ra) # 7514 <printf>
      exit(1);
     800:	00100513          	li	a0,1
     804:	00007097          	auipc	ra,0x7
     808:	834080e7          	jalr	-1996(ra) # 7038 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     80c:	00050613          	mv	a2,a0
     810:	00098593          	mv	a1,s3
     814:	00007517          	auipc	a0,0x7
     818:	12c50513          	add	a0,a0,300 # 7940 <malloc+0x328>
     81c:	00007097          	auipc	ra,0x7
     820:	cf8080e7          	jalr	-776(ra) # 7514 <printf>
      exit(1);
     824:	00100513          	li	a0,1
     828:	00007097          	auipc	ra,0x7
     82c:	810080e7          	jalr	-2032(ra) # 7038 <exit>

0000000000000830 <copyout>:
{
     830:	fa010113          	add	sp,sp,-96
     834:	04113c23          	sd	ra,88(sp)
     838:	04813823          	sd	s0,80(sp)
     83c:	04913423          	sd	s1,72(sp)
     840:	05213023          	sd	s2,64(sp)
     844:	03313c23          	sd	s3,56(sp)
     848:	03413823          	sd	s4,48(sp)
     84c:	03513423          	sd	s5,40(sp)
     850:	06010413          	add	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     854:	00100793          	li	a5,1
     858:	01f79793          	sll	a5,a5,0x1f
     85c:	faf43823          	sd	a5,-80(s0)
     860:	fff00793          	li	a5,-1
     864:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < 2; ai++){
     868:	fb040913          	add	s2,s0,-80
    int fd = open("README", 0);
     86c:	00007a17          	auipc	s4,0x7
     870:	104a0a13          	add	s4,s4,260 # 7970 <malloc+0x358>
    n = write(fds[1], "x", 1);
     874:	00007a97          	auipc	s5,0x7
     878:	f94a8a93          	add	s5,s5,-108 # 7808 <malloc+0x1f0>
    uint64 addr = addrs[ai];
     87c:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     880:	00000593          	li	a1,0
     884:	000a0513          	mv	a0,s4
     888:	00007097          	auipc	ra,0x7
     88c:	810080e7          	jalr	-2032(ra) # 7098 <open>
     890:	00050493          	mv	s1,a0
    if(fd < 0){
     894:	0a054863          	bltz	a0,944 <copyout+0x114>
    int n = read(fd, (void*)addr, 8192);
     898:	00002637          	lui	a2,0x2
     89c:	00098593          	mv	a1,s3
     8a0:	00006097          	auipc	ra,0x6
     8a4:	7bc080e7          	jalr	1980(ra) # 705c <read>
    if(n > 0){
     8a8:	0aa04c63          	bgtz	a0,960 <copyout+0x130>
    close(fd);
     8ac:	00048513          	mv	a0,s1
     8b0:	00006097          	auipc	ra,0x6
     8b4:	7c4080e7          	jalr	1988(ra) # 7074 <close>
    if(pipe(fds) < 0){
     8b8:	fa840513          	add	a0,s0,-88
     8bc:	00006097          	auipc	ra,0x6
     8c0:	794080e7          	jalr	1940(ra) # 7050 <pipe>
     8c4:	0c054063          	bltz	a0,984 <copyout+0x154>
    n = write(fds[1], "x", 1);
     8c8:	00100613          	li	a2,1
     8cc:	000a8593          	mv	a1,s5
     8d0:	fac42503          	lw	a0,-84(s0)
     8d4:	00006097          	auipc	ra,0x6
     8d8:	794080e7          	jalr	1940(ra) # 7068 <write>
    if(n != 1){
     8dc:	00100793          	li	a5,1
     8e0:	0cf51063          	bne	a0,a5,9a0 <copyout+0x170>
    n = read(fds[0], (void*)addr, 8192);
     8e4:	00002637          	lui	a2,0x2
     8e8:	00098593          	mv	a1,s3
     8ec:	fa842503          	lw	a0,-88(s0)
     8f0:	00006097          	auipc	ra,0x6
     8f4:	76c080e7          	jalr	1900(ra) # 705c <read>
    if(n > 0){
     8f8:	0ca04263          	bgtz	a0,9bc <copyout+0x18c>
    close(fds[0]);
     8fc:	fa842503          	lw	a0,-88(s0)
     900:	00006097          	auipc	ra,0x6
     904:	774080e7          	jalr	1908(ra) # 7074 <close>
    close(fds[1]);
     908:	fac42503          	lw	a0,-84(s0)
     90c:	00006097          	auipc	ra,0x6
     910:	768080e7          	jalr	1896(ra) # 7074 <close>
  for(int ai = 0; ai < 2; ai++){
     914:	00890913          	add	s2,s2,8
     918:	fc040793          	add	a5,s0,-64
     91c:	f6f910e3          	bne	s2,a5,87c <copyout+0x4c>
}
     920:	05813083          	ld	ra,88(sp)
     924:	05013403          	ld	s0,80(sp)
     928:	04813483          	ld	s1,72(sp)
     92c:	04013903          	ld	s2,64(sp)
     930:	03813983          	ld	s3,56(sp)
     934:	03013a03          	ld	s4,48(sp)
     938:	02813a83          	ld	s5,40(sp)
     93c:	06010113          	add	sp,sp,96
     940:	00008067          	ret
      printf("open(README) failed\n");
     944:	00007517          	auipc	a0,0x7
     948:	03450513          	add	a0,a0,52 # 7978 <malloc+0x360>
     94c:	00007097          	auipc	ra,0x7
     950:	bc8080e7          	jalr	-1080(ra) # 7514 <printf>
      exit(1);
     954:	00100513          	li	a0,1
     958:	00006097          	auipc	ra,0x6
     95c:	6e0080e7          	jalr	1760(ra) # 7038 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     960:	00050613          	mv	a2,a0
     964:	00098593          	mv	a1,s3
     968:	00007517          	auipc	a0,0x7
     96c:	02850513          	add	a0,a0,40 # 7990 <malloc+0x378>
     970:	00007097          	auipc	ra,0x7
     974:	ba4080e7          	jalr	-1116(ra) # 7514 <printf>
      exit(1);
     978:	00100513          	li	a0,1
     97c:	00006097          	auipc	ra,0x6
     980:	6bc080e7          	jalr	1724(ra) # 7038 <exit>
      printf("pipe() failed\n");
     984:	00007517          	auipc	a0,0x7
     988:	fac50513          	add	a0,a0,-84 # 7930 <malloc+0x318>
     98c:	00007097          	auipc	ra,0x7
     990:	b88080e7          	jalr	-1144(ra) # 7514 <printf>
      exit(1);
     994:	00100513          	li	a0,1
     998:	00006097          	auipc	ra,0x6
     99c:	6a0080e7          	jalr	1696(ra) # 7038 <exit>
      printf("pipe write failed\n");
     9a0:	00007517          	auipc	a0,0x7
     9a4:	02050513          	add	a0,a0,32 # 79c0 <malloc+0x3a8>
     9a8:	00007097          	auipc	ra,0x7
     9ac:	b6c080e7          	jalr	-1172(ra) # 7514 <printf>
      exit(1);
     9b0:	00100513          	li	a0,1
     9b4:	00006097          	auipc	ra,0x6
     9b8:	684080e7          	jalr	1668(ra) # 7038 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     9bc:	00050613          	mv	a2,a0
     9c0:	00098593          	mv	a1,s3
     9c4:	00007517          	auipc	a0,0x7
     9c8:	01450513          	add	a0,a0,20 # 79d8 <malloc+0x3c0>
     9cc:	00007097          	auipc	ra,0x7
     9d0:	b48080e7          	jalr	-1208(ra) # 7514 <printf>
      exit(1);
     9d4:	00100513          	li	a0,1
     9d8:	00006097          	auipc	ra,0x6
     9dc:	660080e7          	jalr	1632(ra) # 7038 <exit>

00000000000009e0 <truncate1>:
{
     9e0:	fa010113          	add	sp,sp,-96
     9e4:	04113c23          	sd	ra,88(sp)
     9e8:	04813823          	sd	s0,80(sp)
     9ec:	04913423          	sd	s1,72(sp)
     9f0:	05213023          	sd	s2,64(sp)
     9f4:	03313c23          	sd	s3,56(sp)
     9f8:	03413823          	sd	s4,48(sp)
     9fc:	03513423          	sd	s5,40(sp)
     a00:	06010413          	add	s0,sp,96
     a04:	00050a93          	mv	s5,a0
  unlink("truncfile");
     a08:	00007517          	auipc	a0,0x7
     a0c:	de850513          	add	a0,a0,-536 # 77f0 <malloc+0x1d8>
     a10:	00006097          	auipc	ra,0x6
     a14:	6a0080e7          	jalr	1696(ra) # 70b0 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     a18:	60100593          	li	a1,1537
     a1c:	00007517          	auipc	a0,0x7
     a20:	dd450513          	add	a0,a0,-556 # 77f0 <malloc+0x1d8>
     a24:	00006097          	auipc	ra,0x6
     a28:	674080e7          	jalr	1652(ra) # 7098 <open>
     a2c:	00050493          	mv	s1,a0
  write(fd1, "abcd", 4);
     a30:	00400613          	li	a2,4
     a34:	00007597          	auipc	a1,0x7
     a38:	dcc58593          	add	a1,a1,-564 # 7800 <malloc+0x1e8>
     a3c:	00006097          	auipc	ra,0x6
     a40:	62c080e7          	jalr	1580(ra) # 7068 <write>
  close(fd1);
     a44:	00048513          	mv	a0,s1
     a48:	00006097          	auipc	ra,0x6
     a4c:	62c080e7          	jalr	1580(ra) # 7074 <close>
  int fd2 = open("truncfile", O_RDONLY);
     a50:	00000593          	li	a1,0
     a54:	00007517          	auipc	a0,0x7
     a58:	d9c50513          	add	a0,a0,-612 # 77f0 <malloc+0x1d8>
     a5c:	00006097          	auipc	ra,0x6
     a60:	63c080e7          	jalr	1596(ra) # 7098 <open>
     a64:	00050493          	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     a68:	02000613          	li	a2,32
     a6c:	fa040593          	add	a1,s0,-96
     a70:	00006097          	auipc	ra,0x6
     a74:	5ec080e7          	jalr	1516(ra) # 705c <read>
  if(n != 4){
     a78:	00400793          	li	a5,4
     a7c:	10f51863          	bne	a0,a5,b8c <truncate1+0x1ac>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     a80:	40100593          	li	a1,1025
     a84:	00007517          	auipc	a0,0x7
     a88:	d6c50513          	add	a0,a0,-660 # 77f0 <malloc+0x1d8>
     a8c:	00006097          	auipc	ra,0x6
     a90:	60c080e7          	jalr	1548(ra) # 7098 <open>
     a94:	00050993          	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     a98:	00000593          	li	a1,0
     a9c:	00007517          	auipc	a0,0x7
     aa0:	d5450513          	add	a0,a0,-684 # 77f0 <malloc+0x1d8>
     aa4:	00006097          	auipc	ra,0x6
     aa8:	5f4080e7          	jalr	1524(ra) # 7098 <open>
     aac:	00050913          	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     ab0:	02000613          	li	a2,32
     ab4:	fa040593          	add	a1,s0,-96
     ab8:	00006097          	auipc	ra,0x6
     abc:	5a4080e7          	jalr	1444(ra) # 705c <read>
     ac0:	00050a13          	mv	s4,a0
  if(n != 0){
     ac4:	0e051663          	bnez	a0,bb0 <truncate1+0x1d0>
  n = read(fd2, buf, sizeof(buf));
     ac8:	02000613          	li	a2,32
     acc:	fa040593          	add	a1,s0,-96
     ad0:	00048513          	mv	a0,s1
     ad4:	00006097          	auipc	ra,0x6
     ad8:	588080e7          	jalr	1416(ra) # 705c <read>
     adc:	00050a13          	mv	s4,a0
  if(n != 0){
     ae0:	10051463          	bnez	a0,be8 <truncate1+0x208>
  write(fd1, "abcdef", 6);
     ae4:	00600613          	li	a2,6
     ae8:	00007597          	auipc	a1,0x7
     aec:	f8058593          	add	a1,a1,-128 # 7a68 <malloc+0x450>
     af0:	00098513          	mv	a0,s3
     af4:	00006097          	auipc	ra,0x6
     af8:	574080e7          	jalr	1396(ra) # 7068 <write>
  n = read(fd3, buf, sizeof(buf));
     afc:	02000613          	li	a2,32
     b00:	fa040593          	add	a1,s0,-96
     b04:	00090513          	mv	a0,s2
     b08:	00006097          	auipc	ra,0x6
     b0c:	554080e7          	jalr	1364(ra) # 705c <read>
  if(n != 6){
     b10:	00600793          	li	a5,6
     b14:	10f51663          	bne	a0,a5,c20 <truncate1+0x240>
  n = read(fd2, buf, sizeof(buf));
     b18:	02000613          	li	a2,32
     b1c:	fa040593          	add	a1,s0,-96
     b20:	00048513          	mv	a0,s1
     b24:	00006097          	auipc	ra,0x6
     b28:	538080e7          	jalr	1336(ra) # 705c <read>
  if(n != 2){
     b2c:	00200793          	li	a5,2
     b30:	10f51a63          	bne	a0,a5,c44 <truncate1+0x264>
  unlink("truncfile");
     b34:	00007517          	auipc	a0,0x7
     b38:	cbc50513          	add	a0,a0,-836 # 77f0 <malloc+0x1d8>
     b3c:	00006097          	auipc	ra,0x6
     b40:	574080e7          	jalr	1396(ra) # 70b0 <unlink>
  close(fd1);
     b44:	00098513          	mv	a0,s3
     b48:	00006097          	auipc	ra,0x6
     b4c:	52c080e7          	jalr	1324(ra) # 7074 <close>
  close(fd2);
     b50:	00048513          	mv	a0,s1
     b54:	00006097          	auipc	ra,0x6
     b58:	520080e7          	jalr	1312(ra) # 7074 <close>
  close(fd3);
     b5c:	00090513          	mv	a0,s2
     b60:	00006097          	auipc	ra,0x6
     b64:	514080e7          	jalr	1300(ra) # 7074 <close>
}
     b68:	05813083          	ld	ra,88(sp)
     b6c:	05013403          	ld	s0,80(sp)
     b70:	04813483          	ld	s1,72(sp)
     b74:	04013903          	ld	s2,64(sp)
     b78:	03813983          	ld	s3,56(sp)
     b7c:	03013a03          	ld	s4,48(sp)
     b80:	02813a83          	ld	s5,40(sp)
     b84:	06010113          	add	sp,sp,96
     b88:	00008067          	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     b8c:	00050613          	mv	a2,a0
     b90:	000a8593          	mv	a1,s5
     b94:	00007517          	auipc	a0,0x7
     b98:	e7450513          	add	a0,a0,-396 # 7a08 <malloc+0x3f0>
     b9c:	00007097          	auipc	ra,0x7
     ba0:	978080e7          	jalr	-1672(ra) # 7514 <printf>
    exit(1);
     ba4:	00100513          	li	a0,1
     ba8:	00006097          	auipc	ra,0x6
     bac:	490080e7          	jalr	1168(ra) # 7038 <exit>
    printf("aaa fd3=%d\n", fd3);
     bb0:	00090593          	mv	a1,s2
     bb4:	00007517          	auipc	a0,0x7
     bb8:	e7450513          	add	a0,a0,-396 # 7a28 <malloc+0x410>
     bbc:	00007097          	auipc	ra,0x7
     bc0:	958080e7          	jalr	-1704(ra) # 7514 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     bc4:	000a0613          	mv	a2,s4
     bc8:	000a8593          	mv	a1,s5
     bcc:	00007517          	auipc	a0,0x7
     bd0:	e6c50513          	add	a0,a0,-404 # 7a38 <malloc+0x420>
     bd4:	00007097          	auipc	ra,0x7
     bd8:	940080e7          	jalr	-1728(ra) # 7514 <printf>
    exit(1);
     bdc:	00100513          	li	a0,1
     be0:	00006097          	auipc	ra,0x6
     be4:	458080e7          	jalr	1112(ra) # 7038 <exit>
    printf("bbb fd2=%d\n", fd2);
     be8:	00048593          	mv	a1,s1
     bec:	00007517          	auipc	a0,0x7
     bf0:	e6c50513          	add	a0,a0,-404 # 7a58 <malloc+0x440>
     bf4:	00007097          	auipc	ra,0x7
     bf8:	920080e7          	jalr	-1760(ra) # 7514 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     bfc:	000a0613          	mv	a2,s4
     c00:	000a8593          	mv	a1,s5
     c04:	00007517          	auipc	a0,0x7
     c08:	e3450513          	add	a0,a0,-460 # 7a38 <malloc+0x420>
     c0c:	00007097          	auipc	ra,0x7
     c10:	908080e7          	jalr	-1784(ra) # 7514 <printf>
    exit(1);
     c14:	00100513          	li	a0,1
     c18:	00006097          	auipc	ra,0x6
     c1c:	420080e7          	jalr	1056(ra) # 7038 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     c20:	00050613          	mv	a2,a0
     c24:	000a8593          	mv	a1,s5
     c28:	00007517          	auipc	a0,0x7
     c2c:	e4850513          	add	a0,a0,-440 # 7a70 <malloc+0x458>
     c30:	00007097          	auipc	ra,0x7
     c34:	8e4080e7          	jalr	-1820(ra) # 7514 <printf>
    exit(1);
     c38:	00100513          	li	a0,1
     c3c:	00006097          	auipc	ra,0x6
     c40:	3fc080e7          	jalr	1020(ra) # 7038 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     c44:	00050613          	mv	a2,a0
     c48:	000a8593          	mv	a1,s5
     c4c:	00007517          	auipc	a0,0x7
     c50:	e4450513          	add	a0,a0,-444 # 7a90 <malloc+0x478>
     c54:	00007097          	auipc	ra,0x7
     c58:	8c0080e7          	jalr	-1856(ra) # 7514 <printf>
    exit(1);
     c5c:	00100513          	li	a0,1
     c60:	00006097          	auipc	ra,0x6
     c64:	3d8080e7          	jalr	984(ra) # 7038 <exit>

0000000000000c68 <writetest>:
{
     c68:	fc010113          	add	sp,sp,-64
     c6c:	02113c23          	sd	ra,56(sp)
     c70:	02813823          	sd	s0,48(sp)
     c74:	02913423          	sd	s1,40(sp)
     c78:	03213023          	sd	s2,32(sp)
     c7c:	01313c23          	sd	s3,24(sp)
     c80:	01413823          	sd	s4,16(sp)
     c84:	01513423          	sd	s5,8(sp)
     c88:	01613023          	sd	s6,0(sp)
     c8c:	04010413          	add	s0,sp,64
     c90:	00050b13          	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     c94:	20200593          	li	a1,514
     c98:	00007517          	auipc	a0,0x7
     c9c:	e1850513          	add	a0,a0,-488 # 7ab0 <malloc+0x498>
     ca0:	00006097          	auipc	ra,0x6
     ca4:	3f8080e7          	jalr	1016(ra) # 7098 <open>
  if(fd < 0){
     ca8:	0e054663          	bltz	a0,d94 <writetest+0x12c>
     cac:	00050913          	mv	s2,a0
     cb0:	00000493          	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     cb4:	00007997          	auipc	s3,0x7
     cb8:	e2498993          	add	s3,s3,-476 # 7ad8 <malloc+0x4c0>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     cbc:	00007a97          	auipc	s5,0x7
     cc0:	e54a8a93          	add	s5,s5,-428 # 7b10 <malloc+0x4f8>
  for(i = 0; i < N; i++){
     cc4:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     cc8:	00a00613          	li	a2,10
     ccc:	00098593          	mv	a1,s3
     cd0:	00090513          	mv	a0,s2
     cd4:	00006097          	auipc	ra,0x6
     cd8:	394080e7          	jalr	916(ra) # 7068 <write>
     cdc:	00a00793          	li	a5,10
     ce0:	0cf51a63          	bne	a0,a5,db4 <writetest+0x14c>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     ce4:	00a00613          	li	a2,10
     ce8:	000a8593          	mv	a1,s5
     cec:	00090513          	mv	a0,s2
     cf0:	00006097          	auipc	ra,0x6
     cf4:	378080e7          	jalr	888(ra) # 7068 <write>
     cf8:	00a00793          	li	a5,10
     cfc:	0cf51e63          	bne	a0,a5,dd8 <writetest+0x170>
  for(i = 0; i < N; i++){
     d00:	0014849b          	addw	s1,s1,1
     d04:	fd4492e3          	bne	s1,s4,cc8 <writetest+0x60>
  close(fd);
     d08:	00090513          	mv	a0,s2
     d0c:	00006097          	auipc	ra,0x6
     d10:	368080e7          	jalr	872(ra) # 7074 <close>
  fd = open("small", O_RDONLY);
     d14:	00000593          	li	a1,0
     d18:	00007517          	auipc	a0,0x7
     d1c:	d9850513          	add	a0,a0,-616 # 7ab0 <malloc+0x498>
     d20:	00006097          	auipc	ra,0x6
     d24:	378080e7          	jalr	888(ra) # 7098 <open>
     d28:	00050493          	mv	s1,a0
  if(fd < 0){
     d2c:	0c054863          	bltz	a0,dfc <writetest+0x194>
  i = read(fd, buf, N*SZ*2);
     d30:	7d000613          	li	a2,2000
     d34:	0000d597          	auipc	a1,0xd
     d38:	f4458593          	add	a1,a1,-188 # dc78 <buf>
     d3c:	00006097          	auipc	ra,0x6
     d40:	320080e7          	jalr	800(ra) # 705c <read>
  if(i != N*SZ*2){
     d44:	7d000793          	li	a5,2000
     d48:	0cf51a63          	bne	a0,a5,e1c <writetest+0x1b4>
  close(fd);
     d4c:	00048513          	mv	a0,s1
     d50:	00006097          	auipc	ra,0x6
     d54:	324080e7          	jalr	804(ra) # 7074 <close>
  if(unlink("small") < 0){
     d58:	00007517          	auipc	a0,0x7
     d5c:	d5850513          	add	a0,a0,-680 # 7ab0 <malloc+0x498>
     d60:	00006097          	auipc	ra,0x6
     d64:	350080e7          	jalr	848(ra) # 70b0 <unlink>
     d68:	0c054a63          	bltz	a0,e3c <writetest+0x1d4>
}
     d6c:	03813083          	ld	ra,56(sp)
     d70:	03013403          	ld	s0,48(sp)
     d74:	02813483          	ld	s1,40(sp)
     d78:	02013903          	ld	s2,32(sp)
     d7c:	01813983          	ld	s3,24(sp)
     d80:	01013a03          	ld	s4,16(sp)
     d84:	00813a83          	ld	s5,8(sp)
     d88:	00013b03          	ld	s6,0(sp)
     d8c:	04010113          	add	sp,sp,64
     d90:	00008067          	ret
    printf("%s: error: creat small failed!\n", s);
     d94:	000b0593          	mv	a1,s6
     d98:	00007517          	auipc	a0,0x7
     d9c:	d2050513          	add	a0,a0,-736 # 7ab8 <malloc+0x4a0>
     da0:	00006097          	auipc	ra,0x6
     da4:	774080e7          	jalr	1908(ra) # 7514 <printf>
    exit(1);
     da8:	00100513          	li	a0,1
     dac:	00006097          	auipc	ra,0x6
     db0:	28c080e7          	jalr	652(ra) # 7038 <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     db4:	00048613          	mv	a2,s1
     db8:	000b0593          	mv	a1,s6
     dbc:	00007517          	auipc	a0,0x7
     dc0:	d2c50513          	add	a0,a0,-724 # 7ae8 <malloc+0x4d0>
     dc4:	00006097          	auipc	ra,0x6
     dc8:	750080e7          	jalr	1872(ra) # 7514 <printf>
      exit(1);
     dcc:	00100513          	li	a0,1
     dd0:	00006097          	auipc	ra,0x6
     dd4:	268080e7          	jalr	616(ra) # 7038 <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     dd8:	00048613          	mv	a2,s1
     ddc:	000b0593          	mv	a1,s6
     de0:	00007517          	auipc	a0,0x7
     de4:	d4050513          	add	a0,a0,-704 # 7b20 <malloc+0x508>
     de8:	00006097          	auipc	ra,0x6
     dec:	72c080e7          	jalr	1836(ra) # 7514 <printf>
      exit(1);
     df0:	00100513          	li	a0,1
     df4:	00006097          	auipc	ra,0x6
     df8:	244080e7          	jalr	580(ra) # 7038 <exit>
    printf("%s: error: open small failed!\n", s);
     dfc:	000b0593          	mv	a1,s6
     e00:	00007517          	auipc	a0,0x7
     e04:	d4850513          	add	a0,a0,-696 # 7b48 <malloc+0x530>
     e08:	00006097          	auipc	ra,0x6
     e0c:	70c080e7          	jalr	1804(ra) # 7514 <printf>
    exit(1);
     e10:	00100513          	li	a0,1
     e14:	00006097          	auipc	ra,0x6
     e18:	224080e7          	jalr	548(ra) # 7038 <exit>
    printf("%s: read failed\n", s);
     e1c:	000b0593          	mv	a1,s6
     e20:	00007517          	auipc	a0,0x7
     e24:	d4850513          	add	a0,a0,-696 # 7b68 <malloc+0x550>
     e28:	00006097          	auipc	ra,0x6
     e2c:	6ec080e7          	jalr	1772(ra) # 7514 <printf>
    exit(1);
     e30:	00100513          	li	a0,1
     e34:	00006097          	auipc	ra,0x6
     e38:	204080e7          	jalr	516(ra) # 7038 <exit>
    printf("%s: unlink small failed\n", s);
     e3c:	000b0593          	mv	a1,s6
     e40:	00007517          	auipc	a0,0x7
     e44:	d4050513          	add	a0,a0,-704 # 7b80 <malloc+0x568>
     e48:	00006097          	auipc	ra,0x6
     e4c:	6cc080e7          	jalr	1740(ra) # 7514 <printf>
    exit(1);
     e50:	00100513          	li	a0,1
     e54:	00006097          	auipc	ra,0x6
     e58:	1e4080e7          	jalr	484(ra) # 7038 <exit>

0000000000000e5c <writebig>:
{
     e5c:	fc010113          	add	sp,sp,-64
     e60:	02113c23          	sd	ra,56(sp)
     e64:	02813823          	sd	s0,48(sp)
     e68:	02913423          	sd	s1,40(sp)
     e6c:	03213023          	sd	s2,32(sp)
     e70:	01313c23          	sd	s3,24(sp)
     e74:	01413823          	sd	s4,16(sp)
     e78:	01513423          	sd	s5,8(sp)
     e7c:	04010413          	add	s0,sp,64
     e80:	00050a93          	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     e84:	20200593          	li	a1,514
     e88:	00007517          	auipc	a0,0x7
     e8c:	d1850513          	add	a0,a0,-744 # 7ba0 <malloc+0x588>
     e90:	00006097          	auipc	ra,0x6
     e94:	208080e7          	jalr	520(ra) # 7098 <open>
     e98:	00050993          	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
     e9c:	00000493          	li	s1,0
    ((int*)buf)[0] = i;
     ea0:	0000d917          	auipc	s2,0xd
     ea4:	dd890913          	add	s2,s2,-552 # dc78 <buf>
  for(i = 0; i < MAXFILE; i++){
     ea8:	10c00a13          	li	s4,268
  if(fd < 0){
     eac:	08054863          	bltz	a0,f3c <writebig+0xe0>
    ((int*)buf)[0] = i;
     eb0:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     eb4:	40000613          	li	a2,1024
     eb8:	00090593          	mv	a1,s2
     ebc:	00098513          	mv	a0,s3
     ec0:	00006097          	auipc	ra,0x6
     ec4:	1a8080e7          	jalr	424(ra) # 7068 <write>
     ec8:	40000793          	li	a5,1024
     ecc:	08f51863          	bne	a0,a5,f5c <writebig+0x100>
  for(i = 0; i < MAXFILE; i++){
     ed0:	0014849b          	addw	s1,s1,1
     ed4:	fd449ee3          	bne	s1,s4,eb0 <writebig+0x54>
  close(fd);
     ed8:	00098513          	mv	a0,s3
     edc:	00006097          	auipc	ra,0x6
     ee0:	198080e7          	jalr	408(ra) # 7074 <close>
  fd = open("big", O_RDONLY);
     ee4:	00000593          	li	a1,0
     ee8:	00007517          	auipc	a0,0x7
     eec:	cb850513          	add	a0,a0,-840 # 7ba0 <malloc+0x588>
     ef0:	00006097          	auipc	ra,0x6
     ef4:	1a8080e7          	jalr	424(ra) # 7098 <open>
     ef8:	00050993          	mv	s3,a0
  n = 0;
     efc:	00000493          	li	s1,0
    i = read(fd, buf, BSIZE);
     f00:	0000d917          	auipc	s2,0xd
     f04:	d7890913          	add	s2,s2,-648 # dc78 <buf>
  if(fd < 0){
     f08:	06054c63          	bltz	a0,f80 <writebig+0x124>
    i = read(fd, buf, BSIZE);
     f0c:	40000613          	li	a2,1024
     f10:	00090593          	mv	a1,s2
     f14:	00098513          	mv	a0,s3
     f18:	00006097          	auipc	ra,0x6
     f1c:	144080e7          	jalr	324(ra) # 705c <read>
    if(i == 0){
     f20:	08050063          	beqz	a0,fa0 <writebig+0x144>
    } else if(i != BSIZE){
     f24:	40000793          	li	a5,1024
     f28:	0ef51463          	bne	a0,a5,1010 <writebig+0x1b4>
    if(((int*)buf)[0] != n){
     f2c:	00092683          	lw	a3,0(s2)
     f30:	10969263          	bne	a3,s1,1034 <writebig+0x1d8>
    n++;
     f34:	0014849b          	addw	s1,s1,1
    i = read(fd, buf, BSIZE);
     f38:	fd5ff06f          	j	f0c <writebig+0xb0>
    printf("%s: error: creat big failed!\n", s);
     f3c:	000a8593          	mv	a1,s5
     f40:	00007517          	auipc	a0,0x7
     f44:	c6850513          	add	a0,a0,-920 # 7ba8 <malloc+0x590>
     f48:	00006097          	auipc	ra,0x6
     f4c:	5cc080e7          	jalr	1484(ra) # 7514 <printf>
    exit(1);
     f50:	00100513          	li	a0,1
     f54:	00006097          	auipc	ra,0x6
     f58:	0e4080e7          	jalr	228(ra) # 7038 <exit>
      printf("%s: error: write big file failed\n", s, i);
     f5c:	00048613          	mv	a2,s1
     f60:	000a8593          	mv	a1,s5
     f64:	00007517          	auipc	a0,0x7
     f68:	c6450513          	add	a0,a0,-924 # 7bc8 <malloc+0x5b0>
     f6c:	00006097          	auipc	ra,0x6
     f70:	5a8080e7          	jalr	1448(ra) # 7514 <printf>
      exit(1);
     f74:	00100513          	li	a0,1
     f78:	00006097          	auipc	ra,0x6
     f7c:	0c0080e7          	jalr	192(ra) # 7038 <exit>
    printf("%s: error: open big failed!\n", s);
     f80:	000a8593          	mv	a1,s5
     f84:	00007517          	auipc	a0,0x7
     f88:	c6c50513          	add	a0,a0,-916 # 7bf0 <malloc+0x5d8>
     f8c:	00006097          	auipc	ra,0x6
     f90:	588080e7          	jalr	1416(ra) # 7514 <printf>
    exit(1);
     f94:	00100513          	li	a0,1
     f98:	00006097          	auipc	ra,0x6
     f9c:	0a0080e7          	jalr	160(ra) # 7038 <exit>
      if(n == MAXFILE - 1){
     fa0:	10b00793          	li	a5,267
     fa4:	04f48463          	beq	s1,a5,fec <writebig+0x190>
  close(fd);
     fa8:	00098513          	mv	a0,s3
     fac:	00006097          	auipc	ra,0x6
     fb0:	0c8080e7          	jalr	200(ra) # 7074 <close>
  if(unlink("big") < 0){
     fb4:	00007517          	auipc	a0,0x7
     fb8:	bec50513          	add	a0,a0,-1044 # 7ba0 <malloc+0x588>
     fbc:	00006097          	auipc	ra,0x6
     fc0:	0f4080e7          	jalr	244(ra) # 70b0 <unlink>
     fc4:	08054a63          	bltz	a0,1058 <writebig+0x1fc>
}
     fc8:	03813083          	ld	ra,56(sp)
     fcc:	03013403          	ld	s0,48(sp)
     fd0:	02813483          	ld	s1,40(sp)
     fd4:	02013903          	ld	s2,32(sp)
     fd8:	01813983          	ld	s3,24(sp)
     fdc:	01013a03          	ld	s4,16(sp)
     fe0:	00813a83          	ld	s5,8(sp)
     fe4:	04010113          	add	sp,sp,64
     fe8:	00008067          	ret
        printf("%s: read only %d blocks from big", s, n);
     fec:	10b00613          	li	a2,267
     ff0:	000a8593          	mv	a1,s5
     ff4:	00007517          	auipc	a0,0x7
     ff8:	c1c50513          	add	a0,a0,-996 # 7c10 <malloc+0x5f8>
     ffc:	00006097          	auipc	ra,0x6
    1000:	518080e7          	jalr	1304(ra) # 7514 <printf>
        exit(1);
    1004:	00100513          	li	a0,1
    1008:	00006097          	auipc	ra,0x6
    100c:	030080e7          	jalr	48(ra) # 7038 <exit>
      printf("%s: read failed %d\n", s, i);
    1010:	00050613          	mv	a2,a0
    1014:	000a8593          	mv	a1,s5
    1018:	00007517          	auipc	a0,0x7
    101c:	c2050513          	add	a0,a0,-992 # 7c38 <malloc+0x620>
    1020:	00006097          	auipc	ra,0x6
    1024:	4f4080e7          	jalr	1268(ra) # 7514 <printf>
      exit(1);
    1028:	00100513          	li	a0,1
    102c:	00006097          	auipc	ra,0x6
    1030:	00c080e7          	jalr	12(ra) # 7038 <exit>
      printf("%s: read content of block %d is %d\n", s,
    1034:	00048613          	mv	a2,s1
    1038:	000a8593          	mv	a1,s5
    103c:	00007517          	auipc	a0,0x7
    1040:	c1450513          	add	a0,a0,-1004 # 7c50 <malloc+0x638>
    1044:	00006097          	auipc	ra,0x6
    1048:	4d0080e7          	jalr	1232(ra) # 7514 <printf>
      exit(1);
    104c:	00100513          	li	a0,1
    1050:	00006097          	auipc	ra,0x6
    1054:	fe8080e7          	jalr	-24(ra) # 7038 <exit>
    printf("%s: unlink big failed\n", s);
    1058:	000a8593          	mv	a1,s5
    105c:	00007517          	auipc	a0,0x7
    1060:	c1c50513          	add	a0,a0,-996 # 7c78 <malloc+0x660>
    1064:	00006097          	auipc	ra,0x6
    1068:	4b0080e7          	jalr	1200(ra) # 7514 <printf>
    exit(1);
    106c:	00100513          	li	a0,1
    1070:	00006097          	auipc	ra,0x6
    1074:	fc8080e7          	jalr	-56(ra) # 7038 <exit>

0000000000001078 <unlinkread>:
{
    1078:	fd010113          	add	sp,sp,-48
    107c:	02113423          	sd	ra,40(sp)
    1080:	02813023          	sd	s0,32(sp)
    1084:	00913c23          	sd	s1,24(sp)
    1088:	01213823          	sd	s2,16(sp)
    108c:	01313423          	sd	s3,8(sp)
    1090:	03010413          	add	s0,sp,48
    1094:	00050993          	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
    1098:	20200593          	li	a1,514
    109c:	00007517          	auipc	a0,0x7
    10a0:	bf450513          	add	a0,a0,-1036 # 7c90 <malloc+0x678>
    10a4:	00006097          	auipc	ra,0x6
    10a8:	ff4080e7          	jalr	-12(ra) # 7098 <open>
  if(fd < 0){
    10ac:	10054c63          	bltz	a0,11c4 <unlinkread+0x14c>
    10b0:	00050493          	mv	s1,a0
  write(fd, "hello", SZ);
    10b4:	00500613          	li	a2,5
    10b8:	00007597          	auipc	a1,0x7
    10bc:	c0858593          	add	a1,a1,-1016 # 7cc0 <malloc+0x6a8>
    10c0:	00006097          	auipc	ra,0x6
    10c4:	fa8080e7          	jalr	-88(ra) # 7068 <write>
  close(fd);
    10c8:	00048513          	mv	a0,s1
    10cc:	00006097          	auipc	ra,0x6
    10d0:	fa8080e7          	jalr	-88(ra) # 7074 <close>
  fd = open("unlinkread", O_RDWR);
    10d4:	00200593          	li	a1,2
    10d8:	00007517          	auipc	a0,0x7
    10dc:	bb850513          	add	a0,a0,-1096 # 7c90 <malloc+0x678>
    10e0:	00006097          	auipc	ra,0x6
    10e4:	fb8080e7          	jalr	-72(ra) # 7098 <open>
    10e8:	00050493          	mv	s1,a0
  if(fd < 0){
    10ec:	0e054c63          	bltz	a0,11e4 <unlinkread+0x16c>
  if(unlink("unlinkread") != 0){
    10f0:	00007517          	auipc	a0,0x7
    10f4:	ba050513          	add	a0,a0,-1120 # 7c90 <malloc+0x678>
    10f8:	00006097          	auipc	ra,0x6
    10fc:	fb8080e7          	jalr	-72(ra) # 70b0 <unlink>
    1100:	10051263          	bnez	a0,1204 <unlinkread+0x18c>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    1104:	20200593          	li	a1,514
    1108:	00007517          	auipc	a0,0x7
    110c:	b8850513          	add	a0,a0,-1144 # 7c90 <malloc+0x678>
    1110:	00006097          	auipc	ra,0x6
    1114:	f88080e7          	jalr	-120(ra) # 7098 <open>
    1118:	00050913          	mv	s2,a0
  write(fd1, "yyy", 3);
    111c:	00300613          	li	a2,3
    1120:	00007597          	auipc	a1,0x7
    1124:	be858593          	add	a1,a1,-1048 # 7d08 <malloc+0x6f0>
    1128:	00006097          	auipc	ra,0x6
    112c:	f40080e7          	jalr	-192(ra) # 7068 <write>
  close(fd1);
    1130:	00090513          	mv	a0,s2
    1134:	00006097          	auipc	ra,0x6
    1138:	f40080e7          	jalr	-192(ra) # 7074 <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
    113c:	00003637          	lui	a2,0x3
    1140:	0000d597          	auipc	a1,0xd
    1144:	b3858593          	add	a1,a1,-1224 # dc78 <buf>
    1148:	00048513          	mv	a0,s1
    114c:	00006097          	auipc	ra,0x6
    1150:	f10080e7          	jalr	-240(ra) # 705c <read>
    1154:	00500793          	li	a5,5
    1158:	0cf51663          	bne	a0,a5,1224 <unlinkread+0x1ac>
  if(buf[0] != 'h'){
    115c:	0000d717          	auipc	a4,0xd
    1160:	b1c74703          	lbu	a4,-1252(a4) # dc78 <buf>
    1164:	06800793          	li	a5,104
    1168:	0cf71e63          	bne	a4,a5,1244 <unlinkread+0x1cc>
  if(write(fd, buf, 10) != 10){
    116c:	00a00613          	li	a2,10
    1170:	0000d597          	auipc	a1,0xd
    1174:	b0858593          	add	a1,a1,-1272 # dc78 <buf>
    1178:	00048513          	mv	a0,s1
    117c:	00006097          	auipc	ra,0x6
    1180:	eec080e7          	jalr	-276(ra) # 7068 <write>
    1184:	00a00793          	li	a5,10
    1188:	0cf51e63          	bne	a0,a5,1264 <unlinkread+0x1ec>
  close(fd);
    118c:	00048513          	mv	a0,s1
    1190:	00006097          	auipc	ra,0x6
    1194:	ee4080e7          	jalr	-284(ra) # 7074 <close>
  unlink("unlinkread");
    1198:	00007517          	auipc	a0,0x7
    119c:	af850513          	add	a0,a0,-1288 # 7c90 <malloc+0x678>
    11a0:	00006097          	auipc	ra,0x6
    11a4:	f10080e7          	jalr	-240(ra) # 70b0 <unlink>
}
    11a8:	02813083          	ld	ra,40(sp)
    11ac:	02013403          	ld	s0,32(sp)
    11b0:	01813483          	ld	s1,24(sp)
    11b4:	01013903          	ld	s2,16(sp)
    11b8:	00813983          	ld	s3,8(sp)
    11bc:	03010113          	add	sp,sp,48
    11c0:	00008067          	ret
    printf("%s: create unlinkread failed\n", s);
    11c4:	00098593          	mv	a1,s3
    11c8:	00007517          	auipc	a0,0x7
    11cc:	ad850513          	add	a0,a0,-1320 # 7ca0 <malloc+0x688>
    11d0:	00006097          	auipc	ra,0x6
    11d4:	344080e7          	jalr	836(ra) # 7514 <printf>
    exit(1);
    11d8:	00100513          	li	a0,1
    11dc:	00006097          	auipc	ra,0x6
    11e0:	e5c080e7          	jalr	-420(ra) # 7038 <exit>
    printf("%s: open unlinkread failed\n", s);
    11e4:	00098593          	mv	a1,s3
    11e8:	00007517          	auipc	a0,0x7
    11ec:	ae050513          	add	a0,a0,-1312 # 7cc8 <malloc+0x6b0>
    11f0:	00006097          	auipc	ra,0x6
    11f4:	324080e7          	jalr	804(ra) # 7514 <printf>
    exit(1);
    11f8:	00100513          	li	a0,1
    11fc:	00006097          	auipc	ra,0x6
    1200:	e3c080e7          	jalr	-452(ra) # 7038 <exit>
    printf("%s: unlink unlinkread failed\n", s);
    1204:	00098593          	mv	a1,s3
    1208:	00007517          	auipc	a0,0x7
    120c:	ae050513          	add	a0,a0,-1312 # 7ce8 <malloc+0x6d0>
    1210:	00006097          	auipc	ra,0x6
    1214:	304080e7          	jalr	772(ra) # 7514 <printf>
    exit(1);
    1218:	00100513          	li	a0,1
    121c:	00006097          	auipc	ra,0x6
    1220:	e1c080e7          	jalr	-484(ra) # 7038 <exit>
    printf("%s: unlinkread read failed", s);
    1224:	00098593          	mv	a1,s3
    1228:	00007517          	auipc	a0,0x7
    122c:	ae850513          	add	a0,a0,-1304 # 7d10 <malloc+0x6f8>
    1230:	00006097          	auipc	ra,0x6
    1234:	2e4080e7          	jalr	740(ra) # 7514 <printf>
    exit(1);
    1238:	00100513          	li	a0,1
    123c:	00006097          	auipc	ra,0x6
    1240:	dfc080e7          	jalr	-516(ra) # 7038 <exit>
    printf("%s: unlinkread wrong data\n", s);
    1244:	00098593          	mv	a1,s3
    1248:	00007517          	auipc	a0,0x7
    124c:	ae850513          	add	a0,a0,-1304 # 7d30 <malloc+0x718>
    1250:	00006097          	auipc	ra,0x6
    1254:	2c4080e7          	jalr	708(ra) # 7514 <printf>
    exit(1);
    1258:	00100513          	li	a0,1
    125c:	00006097          	auipc	ra,0x6
    1260:	ddc080e7          	jalr	-548(ra) # 7038 <exit>
    printf("%s: unlinkread write failed\n", s);
    1264:	00098593          	mv	a1,s3
    1268:	00007517          	auipc	a0,0x7
    126c:	ae850513          	add	a0,a0,-1304 # 7d50 <malloc+0x738>
    1270:	00006097          	auipc	ra,0x6
    1274:	2a4080e7          	jalr	676(ra) # 7514 <printf>
    exit(1);
    1278:	00100513          	li	a0,1
    127c:	00006097          	auipc	ra,0x6
    1280:	dbc080e7          	jalr	-580(ra) # 7038 <exit>

0000000000001284 <linktest>:
{
    1284:	fe010113          	add	sp,sp,-32
    1288:	00113c23          	sd	ra,24(sp)
    128c:	00813823          	sd	s0,16(sp)
    1290:	00913423          	sd	s1,8(sp)
    1294:	01213023          	sd	s2,0(sp)
    1298:	02010413          	add	s0,sp,32
    129c:	00050913          	mv	s2,a0
  unlink("lf1");
    12a0:	00007517          	auipc	a0,0x7
    12a4:	ad050513          	add	a0,a0,-1328 # 7d70 <malloc+0x758>
    12a8:	00006097          	auipc	ra,0x6
    12ac:	e08080e7          	jalr	-504(ra) # 70b0 <unlink>
  unlink("lf2");
    12b0:	00007517          	auipc	a0,0x7
    12b4:	ac850513          	add	a0,a0,-1336 # 7d78 <malloc+0x760>
    12b8:	00006097          	auipc	ra,0x6
    12bc:	df8080e7          	jalr	-520(ra) # 70b0 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
    12c0:	20200593          	li	a1,514
    12c4:	00007517          	auipc	a0,0x7
    12c8:	aac50513          	add	a0,a0,-1364 # 7d70 <malloc+0x758>
    12cc:	00006097          	auipc	ra,0x6
    12d0:	dcc080e7          	jalr	-564(ra) # 7098 <open>
  if(fd < 0){
    12d4:	12054863          	bltz	a0,1404 <linktest+0x180>
    12d8:	00050493          	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
    12dc:	00500613          	li	a2,5
    12e0:	00007597          	auipc	a1,0x7
    12e4:	9e058593          	add	a1,a1,-1568 # 7cc0 <malloc+0x6a8>
    12e8:	00006097          	auipc	ra,0x6
    12ec:	d80080e7          	jalr	-640(ra) # 7068 <write>
    12f0:	00500793          	li	a5,5
    12f4:	12f51863          	bne	a0,a5,1424 <linktest+0x1a0>
  close(fd);
    12f8:	00048513          	mv	a0,s1
    12fc:	00006097          	auipc	ra,0x6
    1300:	d78080e7          	jalr	-648(ra) # 7074 <close>
  if(link("lf1", "lf2") < 0){
    1304:	00007597          	auipc	a1,0x7
    1308:	a7458593          	add	a1,a1,-1420 # 7d78 <malloc+0x760>
    130c:	00007517          	auipc	a0,0x7
    1310:	a6450513          	add	a0,a0,-1436 # 7d70 <malloc+0x758>
    1314:	00006097          	auipc	ra,0x6
    1318:	db4080e7          	jalr	-588(ra) # 70c8 <link>
    131c:	12054463          	bltz	a0,1444 <linktest+0x1c0>
  unlink("lf1");
    1320:	00007517          	auipc	a0,0x7
    1324:	a5050513          	add	a0,a0,-1456 # 7d70 <malloc+0x758>
    1328:	00006097          	auipc	ra,0x6
    132c:	d88080e7          	jalr	-632(ra) # 70b0 <unlink>
  if(open("lf1", 0) >= 0){
    1330:	00000593          	li	a1,0
    1334:	00007517          	auipc	a0,0x7
    1338:	a3c50513          	add	a0,a0,-1476 # 7d70 <malloc+0x758>
    133c:	00006097          	auipc	ra,0x6
    1340:	d5c080e7          	jalr	-676(ra) # 7098 <open>
    1344:	12055063          	bgez	a0,1464 <linktest+0x1e0>
  fd = open("lf2", 0);
    1348:	00000593          	li	a1,0
    134c:	00007517          	auipc	a0,0x7
    1350:	a2c50513          	add	a0,a0,-1492 # 7d78 <malloc+0x760>
    1354:	00006097          	auipc	ra,0x6
    1358:	d44080e7          	jalr	-700(ra) # 7098 <open>
    135c:	00050493          	mv	s1,a0
  if(fd < 0){
    1360:	12054263          	bltz	a0,1484 <linktest+0x200>
  if(read(fd, buf, sizeof(buf)) != SZ){
    1364:	00003637          	lui	a2,0x3
    1368:	0000d597          	auipc	a1,0xd
    136c:	91058593          	add	a1,a1,-1776 # dc78 <buf>
    1370:	00006097          	auipc	ra,0x6
    1374:	cec080e7          	jalr	-788(ra) # 705c <read>
    1378:	00500793          	li	a5,5
    137c:	12f51463          	bne	a0,a5,14a4 <linktest+0x220>
  close(fd);
    1380:	00048513          	mv	a0,s1
    1384:	00006097          	auipc	ra,0x6
    1388:	cf0080e7          	jalr	-784(ra) # 7074 <close>
  if(link("lf2", "lf2") >= 0){
    138c:	00007597          	auipc	a1,0x7
    1390:	9ec58593          	add	a1,a1,-1556 # 7d78 <malloc+0x760>
    1394:	00058513          	mv	a0,a1
    1398:	00006097          	auipc	ra,0x6
    139c:	d30080e7          	jalr	-720(ra) # 70c8 <link>
    13a0:	12055263          	bgez	a0,14c4 <linktest+0x240>
  unlink("lf2");
    13a4:	00007517          	auipc	a0,0x7
    13a8:	9d450513          	add	a0,a0,-1580 # 7d78 <malloc+0x760>
    13ac:	00006097          	auipc	ra,0x6
    13b0:	d04080e7          	jalr	-764(ra) # 70b0 <unlink>
  if(link("lf2", "lf1") >= 0){
    13b4:	00007597          	auipc	a1,0x7
    13b8:	9bc58593          	add	a1,a1,-1604 # 7d70 <malloc+0x758>
    13bc:	00007517          	auipc	a0,0x7
    13c0:	9bc50513          	add	a0,a0,-1604 # 7d78 <malloc+0x760>
    13c4:	00006097          	auipc	ra,0x6
    13c8:	d04080e7          	jalr	-764(ra) # 70c8 <link>
    13cc:	10055c63          	bgez	a0,14e4 <linktest+0x260>
  if(link(".", "lf1") >= 0){
    13d0:	00007597          	auipc	a1,0x7
    13d4:	9a058593          	add	a1,a1,-1632 # 7d70 <malloc+0x758>
    13d8:	00007517          	auipc	a0,0x7
    13dc:	aa850513          	add	a0,a0,-1368 # 7e80 <malloc+0x868>
    13e0:	00006097          	auipc	ra,0x6
    13e4:	ce8080e7          	jalr	-792(ra) # 70c8 <link>
    13e8:	10055e63          	bgez	a0,1504 <linktest+0x280>
}
    13ec:	01813083          	ld	ra,24(sp)
    13f0:	01013403          	ld	s0,16(sp)
    13f4:	00813483          	ld	s1,8(sp)
    13f8:	00013903          	ld	s2,0(sp)
    13fc:	02010113          	add	sp,sp,32
    1400:	00008067          	ret
    printf("%s: create lf1 failed\n", s);
    1404:	00090593          	mv	a1,s2
    1408:	00007517          	auipc	a0,0x7
    140c:	97850513          	add	a0,a0,-1672 # 7d80 <malloc+0x768>
    1410:	00006097          	auipc	ra,0x6
    1414:	104080e7          	jalr	260(ra) # 7514 <printf>
    exit(1);
    1418:	00100513          	li	a0,1
    141c:	00006097          	auipc	ra,0x6
    1420:	c1c080e7          	jalr	-996(ra) # 7038 <exit>
    printf("%s: write lf1 failed\n", s);
    1424:	00090593          	mv	a1,s2
    1428:	00007517          	auipc	a0,0x7
    142c:	97050513          	add	a0,a0,-1680 # 7d98 <malloc+0x780>
    1430:	00006097          	auipc	ra,0x6
    1434:	0e4080e7          	jalr	228(ra) # 7514 <printf>
    exit(1);
    1438:	00100513          	li	a0,1
    143c:	00006097          	auipc	ra,0x6
    1440:	bfc080e7          	jalr	-1028(ra) # 7038 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
    1444:	00090593          	mv	a1,s2
    1448:	00007517          	auipc	a0,0x7
    144c:	96850513          	add	a0,a0,-1688 # 7db0 <malloc+0x798>
    1450:	00006097          	auipc	ra,0x6
    1454:	0c4080e7          	jalr	196(ra) # 7514 <printf>
    exit(1);
    1458:	00100513          	li	a0,1
    145c:	00006097          	auipc	ra,0x6
    1460:	bdc080e7          	jalr	-1060(ra) # 7038 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
    1464:	00090593          	mv	a1,s2
    1468:	00007517          	auipc	a0,0x7
    146c:	96850513          	add	a0,a0,-1688 # 7dd0 <malloc+0x7b8>
    1470:	00006097          	auipc	ra,0x6
    1474:	0a4080e7          	jalr	164(ra) # 7514 <printf>
    exit(1);
    1478:	00100513          	li	a0,1
    147c:	00006097          	auipc	ra,0x6
    1480:	bbc080e7          	jalr	-1092(ra) # 7038 <exit>
    printf("%s: open lf2 failed\n", s);
    1484:	00090593          	mv	a1,s2
    1488:	00007517          	auipc	a0,0x7
    148c:	97850513          	add	a0,a0,-1672 # 7e00 <malloc+0x7e8>
    1490:	00006097          	auipc	ra,0x6
    1494:	084080e7          	jalr	132(ra) # 7514 <printf>
    exit(1);
    1498:	00100513          	li	a0,1
    149c:	00006097          	auipc	ra,0x6
    14a0:	b9c080e7          	jalr	-1124(ra) # 7038 <exit>
    printf("%s: read lf2 failed\n", s);
    14a4:	00090593          	mv	a1,s2
    14a8:	00007517          	auipc	a0,0x7
    14ac:	97050513          	add	a0,a0,-1680 # 7e18 <malloc+0x800>
    14b0:	00006097          	auipc	ra,0x6
    14b4:	064080e7          	jalr	100(ra) # 7514 <printf>
    exit(1);
    14b8:	00100513          	li	a0,1
    14bc:	00006097          	auipc	ra,0x6
    14c0:	b7c080e7          	jalr	-1156(ra) # 7038 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
    14c4:	00090593          	mv	a1,s2
    14c8:	00007517          	auipc	a0,0x7
    14cc:	96850513          	add	a0,a0,-1688 # 7e30 <malloc+0x818>
    14d0:	00006097          	auipc	ra,0x6
    14d4:	044080e7          	jalr	68(ra) # 7514 <printf>
    exit(1);
    14d8:	00100513          	li	a0,1
    14dc:	00006097          	auipc	ra,0x6
    14e0:	b5c080e7          	jalr	-1188(ra) # 7038 <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
    14e4:	00090593          	mv	a1,s2
    14e8:	00007517          	auipc	a0,0x7
    14ec:	97050513          	add	a0,a0,-1680 # 7e58 <malloc+0x840>
    14f0:	00006097          	auipc	ra,0x6
    14f4:	024080e7          	jalr	36(ra) # 7514 <printf>
    exit(1);
    14f8:	00100513          	li	a0,1
    14fc:	00006097          	auipc	ra,0x6
    1500:	b3c080e7          	jalr	-1220(ra) # 7038 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
    1504:	00090593          	mv	a1,s2
    1508:	00007517          	auipc	a0,0x7
    150c:	98050513          	add	a0,a0,-1664 # 7e88 <malloc+0x870>
    1510:	00006097          	auipc	ra,0x6
    1514:	004080e7          	jalr	4(ra) # 7514 <printf>
    exit(1);
    1518:	00100513          	li	a0,1
    151c:	00006097          	auipc	ra,0x6
    1520:	b1c080e7          	jalr	-1252(ra) # 7038 <exit>

0000000000001524 <validatetest>:
{
    1524:	fc010113          	add	sp,sp,-64
    1528:	02113c23          	sd	ra,56(sp)
    152c:	02813823          	sd	s0,48(sp)
    1530:	02913423          	sd	s1,40(sp)
    1534:	03213023          	sd	s2,32(sp)
    1538:	01313c23          	sd	s3,24(sp)
    153c:	01413823          	sd	s4,16(sp)
    1540:	01513423          	sd	s5,8(sp)
    1544:	01613023          	sd	s6,0(sp)
    1548:	04010413          	add	s0,sp,64
    154c:	00050b13          	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1550:	00000493          	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    1554:	00007997          	auipc	s3,0x7
    1558:	95498993          	add	s3,s3,-1708 # 7ea8 <malloc+0x890>
    155c:	fff00913          	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1560:	00001ab7          	lui	s5,0x1
    1564:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    1568:	00048593          	mv	a1,s1
    156c:	00098513          	mv	a0,s3
    1570:	00006097          	auipc	ra,0x6
    1574:	b58080e7          	jalr	-1192(ra) # 70c8 <link>
    1578:	03251a63          	bne	a0,s2,15ac <validatetest+0x88>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    157c:	015484b3          	add	s1,s1,s5
    1580:	ff4494e3          	bne	s1,s4,1568 <validatetest+0x44>
}
    1584:	03813083          	ld	ra,56(sp)
    1588:	03013403          	ld	s0,48(sp)
    158c:	02813483          	ld	s1,40(sp)
    1590:	02013903          	ld	s2,32(sp)
    1594:	01813983          	ld	s3,24(sp)
    1598:	01013a03          	ld	s4,16(sp)
    159c:	00813a83          	ld	s5,8(sp)
    15a0:	00013b03          	ld	s6,0(sp)
    15a4:	04010113          	add	sp,sp,64
    15a8:	00008067          	ret
      printf("%s: link should not succeed\n", s);
    15ac:	000b0593          	mv	a1,s6
    15b0:	00007517          	auipc	a0,0x7
    15b4:	90850513          	add	a0,a0,-1784 # 7eb8 <malloc+0x8a0>
    15b8:	00006097          	auipc	ra,0x6
    15bc:	f5c080e7          	jalr	-164(ra) # 7514 <printf>
      exit(1);
    15c0:	00100513          	li	a0,1
    15c4:	00006097          	auipc	ra,0x6
    15c8:	a74080e7          	jalr	-1420(ra) # 7038 <exit>

00000000000015cc <bigdir>:
{
    15cc:	fb010113          	add	sp,sp,-80
    15d0:	04113423          	sd	ra,72(sp)
    15d4:	04813023          	sd	s0,64(sp)
    15d8:	02913c23          	sd	s1,56(sp)
    15dc:	03213823          	sd	s2,48(sp)
    15e0:	03313423          	sd	s3,40(sp)
    15e4:	03413023          	sd	s4,32(sp)
    15e8:	01513c23          	sd	s5,24(sp)
    15ec:	01613823          	sd	s6,16(sp)
    15f0:	05010413          	add	s0,sp,80
    15f4:	00050993          	mv	s3,a0
  unlink("bd");
    15f8:	00007517          	auipc	a0,0x7
    15fc:	8e050513          	add	a0,a0,-1824 # 7ed8 <malloc+0x8c0>
    1600:	00006097          	auipc	ra,0x6
    1604:	ab0080e7          	jalr	-1360(ra) # 70b0 <unlink>
  fd = open("bd", O_CREATE);
    1608:	20000593          	li	a1,512
    160c:	00007517          	auipc	a0,0x7
    1610:	8cc50513          	add	a0,a0,-1844 # 7ed8 <malloc+0x8c0>
    1614:	00006097          	auipc	ra,0x6
    1618:	a84080e7          	jalr	-1404(ra) # 7098 <open>
  if(fd < 0){
    161c:	0e054c63          	bltz	a0,1714 <bigdir+0x148>
  close(fd);
    1620:	00006097          	auipc	ra,0x6
    1624:	a54080e7          	jalr	-1452(ra) # 7074 <close>
  for(i = 0; i < N; i++){
    1628:	00000913          	li	s2,0
    name[0] = 'x';
    162c:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
    1630:	00007a17          	auipc	s4,0x7
    1634:	8a8a0a13          	add	s4,s4,-1880 # 7ed8 <malloc+0x8c0>
  for(i = 0; i < N; i++){
    1638:	1f400b13          	li	s6,500
    name[0] = 'x';
    163c:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
    1640:	41f9571b          	sraw	a4,s2,0x1f
    1644:	01a7571b          	srlw	a4,a4,0x1a
    1648:	012707bb          	addw	a5,a4,s2
    164c:	4067d69b          	sraw	a3,a5,0x6
    1650:	0306869b          	addw	a3,a3,48
    1654:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1658:	03f7f793          	and	a5,a5,63
    165c:	40e787bb          	subw	a5,a5,a4
    1660:	0307879b          	addw	a5,a5,48
    1664:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1668:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
    166c:	fb040593          	add	a1,s0,-80
    1670:	000a0513          	mv	a0,s4
    1674:	00006097          	auipc	ra,0x6
    1678:	a54080e7          	jalr	-1452(ra) # 70c8 <link>
    167c:	00050493          	mv	s1,a0
    1680:	0a051a63          	bnez	a0,1734 <bigdir+0x168>
  for(i = 0; i < N; i++){
    1684:	0019091b          	addw	s2,s2,1
    1688:	fb691ae3          	bne	s2,s6,163c <bigdir+0x70>
  unlink("bd");
    168c:	00007517          	auipc	a0,0x7
    1690:	84c50513          	add	a0,a0,-1972 # 7ed8 <malloc+0x8c0>
    1694:	00006097          	auipc	ra,0x6
    1698:	a1c080e7          	jalr	-1508(ra) # 70b0 <unlink>
    name[0] = 'x';
    169c:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    16a0:	1f400a13          	li	s4,500
    name[0] = 'x';
    16a4:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    16a8:	41f4d71b          	sraw	a4,s1,0x1f
    16ac:	01a7571b          	srlw	a4,a4,0x1a
    16b0:	009707bb          	addw	a5,a4,s1
    16b4:	4067d69b          	sraw	a3,a5,0x6
    16b8:	0306869b          	addw	a3,a3,48
    16bc:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    16c0:	03f7f793          	and	a5,a5,63
    16c4:	40e787bb          	subw	a5,a5,a4
    16c8:	0307879b          	addw	a5,a5,48
    16cc:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    16d0:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    16d4:	fb040513          	add	a0,s0,-80
    16d8:	00006097          	auipc	ra,0x6
    16dc:	9d8080e7          	jalr	-1576(ra) # 70b0 <unlink>
    16e0:	06051c63          	bnez	a0,1758 <bigdir+0x18c>
  for(i = 0; i < N; i++){
    16e4:	0014849b          	addw	s1,s1,1
    16e8:	fb449ee3          	bne	s1,s4,16a4 <bigdir+0xd8>
}
    16ec:	04813083          	ld	ra,72(sp)
    16f0:	04013403          	ld	s0,64(sp)
    16f4:	03813483          	ld	s1,56(sp)
    16f8:	03013903          	ld	s2,48(sp)
    16fc:	02813983          	ld	s3,40(sp)
    1700:	02013a03          	ld	s4,32(sp)
    1704:	01813a83          	ld	s5,24(sp)
    1708:	01013b03          	ld	s6,16(sp)
    170c:	05010113          	add	sp,sp,80
    1710:	00008067          	ret
    printf("%s: bigdir create failed\n", s);
    1714:	00098593          	mv	a1,s3
    1718:	00006517          	auipc	a0,0x6
    171c:	7c850513          	add	a0,a0,1992 # 7ee0 <malloc+0x8c8>
    1720:	00006097          	auipc	ra,0x6
    1724:	df4080e7          	jalr	-524(ra) # 7514 <printf>
    exit(1);
    1728:	00100513          	li	a0,1
    172c:	00006097          	auipc	ra,0x6
    1730:	90c080e7          	jalr	-1780(ra) # 7038 <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    1734:	fb040613          	add	a2,s0,-80
    1738:	00098593          	mv	a1,s3
    173c:	00006517          	auipc	a0,0x6
    1740:	7c450513          	add	a0,a0,1988 # 7f00 <malloc+0x8e8>
    1744:	00006097          	auipc	ra,0x6
    1748:	dd0080e7          	jalr	-560(ra) # 7514 <printf>
      exit(1);
    174c:	00100513          	li	a0,1
    1750:	00006097          	auipc	ra,0x6
    1754:	8e8080e7          	jalr	-1816(ra) # 7038 <exit>
      printf("%s: bigdir unlink failed", s);
    1758:	00098593          	mv	a1,s3
    175c:	00006517          	auipc	a0,0x6
    1760:	7c450513          	add	a0,a0,1988 # 7f20 <malloc+0x908>
    1764:	00006097          	auipc	ra,0x6
    1768:	db0080e7          	jalr	-592(ra) # 7514 <printf>
      exit(1);
    176c:	00100513          	li	a0,1
    1770:	00006097          	auipc	ra,0x6
    1774:	8c8080e7          	jalr	-1848(ra) # 7038 <exit>

0000000000001778 <pgbug>:
{
    1778:	fd010113          	add	sp,sp,-48
    177c:	02113423          	sd	ra,40(sp)
    1780:	02813023          	sd	s0,32(sp)
    1784:	00913c23          	sd	s1,24(sp)
    1788:	03010413          	add	s0,sp,48
  argv[0] = 0;
    178c:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
    1790:	00009497          	auipc	s1,0x9
    1794:	87048493          	add	s1,s1,-1936 # a000 <big>
    1798:	fd840593          	add	a1,s0,-40
    179c:	0004b503          	ld	a0,0(s1)
    17a0:	00006097          	auipc	ra,0x6
    17a4:	8ec080e7          	jalr	-1812(ra) # 708c <exec>
  pipe(big);
    17a8:	0004b503          	ld	a0,0(s1)
    17ac:	00006097          	auipc	ra,0x6
    17b0:	8a4080e7          	jalr	-1884(ra) # 7050 <pipe>
  exit(0);
    17b4:	00000513          	li	a0,0
    17b8:	00006097          	auipc	ra,0x6
    17bc:	880080e7          	jalr	-1920(ra) # 7038 <exit>

00000000000017c0 <badarg>:
{
    17c0:	fc010113          	add	sp,sp,-64
    17c4:	02113c23          	sd	ra,56(sp)
    17c8:	02813823          	sd	s0,48(sp)
    17cc:	02913423          	sd	s1,40(sp)
    17d0:	03213023          	sd	s2,32(sp)
    17d4:	01313c23          	sd	s3,24(sp)
    17d8:	04010413          	add	s0,sp,64
    17dc:	0000c4b7          	lui	s1,0xc
    17e0:	35048493          	add	s1,s1,848 # c350 <uninit+0xde8>
    argv[0] = (char*)0xffffffff;
    17e4:	fff00913          	li	s2,-1
    17e8:	02095913          	srl	s2,s2,0x20
    exec("echo", argv);
    17ec:	00006997          	auipc	s3,0x6
    17f0:	fac98993          	add	s3,s3,-84 # 7798 <malloc+0x180>
    argv[0] = (char*)0xffffffff;
    17f4:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    17f8:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    17fc:	fc040593          	add	a1,s0,-64
    1800:	00098513          	mv	a0,s3
    1804:	00006097          	auipc	ra,0x6
    1808:	888080e7          	jalr	-1912(ra) # 708c <exec>
  for(int i = 0; i < 50000; i++){
    180c:	fff4849b          	addw	s1,s1,-1
    1810:	fe0492e3          	bnez	s1,17f4 <badarg+0x34>
  exit(0);
    1814:	00000513          	li	a0,0
    1818:	00006097          	auipc	ra,0x6
    181c:	820080e7          	jalr	-2016(ra) # 7038 <exit>

0000000000001820 <copyinstr2>:
{
    1820:	f3010113          	add	sp,sp,-208
    1824:	0c113423          	sd	ra,200(sp)
    1828:	0c813023          	sd	s0,192(sp)
    182c:	0d010413          	add	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    1830:	f6840793          	add	a5,s0,-152
    1834:	fe840693          	add	a3,s0,-24
    b[i] = 'x';
    1838:	07800713          	li	a4,120
    183c:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    1840:	00178793          	add	a5,a5,1
    1844:	fed79ce3          	bne	a5,a3,183c <copyinstr2+0x1c>
  b[MAXPATH] = '\0';
    1848:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    184c:	f6840513          	add	a0,s0,-152
    1850:	00006097          	auipc	ra,0x6
    1854:	860080e7          	jalr	-1952(ra) # 70b0 <unlink>
  if(ret != -1){
    1858:	fff00793          	li	a5,-1
    185c:	0ef51c63          	bne	a0,a5,1954 <copyinstr2+0x134>
  int fd = open(b, O_CREATE | O_WRONLY);
    1860:	20100593          	li	a1,513
    1864:	f6840513          	add	a0,s0,-152
    1868:	00006097          	auipc	ra,0x6
    186c:	830080e7          	jalr	-2000(ra) # 7098 <open>
  if(fd != -1){
    1870:	fff00793          	li	a5,-1
    1874:	10f51263          	bne	a0,a5,1978 <copyinstr2+0x158>
  ret = link(b, b);
    1878:	f6840593          	add	a1,s0,-152
    187c:	00058513          	mv	a0,a1
    1880:	00006097          	auipc	ra,0x6
    1884:	848080e7          	jalr	-1976(ra) # 70c8 <link>
  if(ret != -1){
    1888:	fff00793          	li	a5,-1
    188c:	10f51863          	bne	a0,a5,199c <copyinstr2+0x17c>
  char *args[] = { "xx", 0 };
    1890:	00008797          	auipc	a5,0x8
    1894:	8e878793          	add	a5,a5,-1816 # 9178 <malloc+0x1b60>
    1898:	f4f43c23          	sd	a5,-168(s0)
    189c:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    18a0:	f5840593          	add	a1,s0,-168
    18a4:	f6840513          	add	a0,s0,-152
    18a8:	00005097          	auipc	ra,0x5
    18ac:	7e4080e7          	jalr	2020(ra) # 708c <exec>
  if(ret != -1){
    18b0:	fff00793          	li	a5,-1
    18b4:	10f51863          	bne	a0,a5,19c4 <copyinstr2+0x1a4>
  int pid = fork();
    18b8:	00005097          	auipc	ra,0x5
    18bc:	774080e7          	jalr	1908(ra) # 702c <fork>
  if(pid < 0){
    18c0:	12054463          	bltz	a0,19e8 <copyinstr2+0x1c8>
  if(pid == 0){
    18c4:	14051663          	bnez	a0,1a10 <copyinstr2+0x1f0>
    18c8:	00009797          	auipc	a5,0x9
    18cc:	c9878793          	add	a5,a5,-872 # a560 <big.0>
    18d0:	0000a697          	auipc	a3,0xa
    18d4:	c9068693          	add	a3,a3,-880 # b560 <big.0+0x1000>
      big[i] = 'x';
    18d8:	07800713          	li	a4,120
    18dc:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    18e0:	00178793          	add	a5,a5,1
    18e4:	fed79ce3          	bne	a5,a3,18dc <copyinstr2+0xbc>
    big[PGSIZE] = '\0';
    18e8:	0000a797          	auipc	a5,0xa
    18ec:	c6078c23          	sb	zero,-904(a5) # b560 <big.0+0x1000>
    char *args2[] = { big, big, big, 0 };
    18f0:	00008797          	auipc	a5,0x8
    18f4:	2c878793          	add	a5,a5,712 # 9bb8 <malloc+0x25a0>
    18f8:	0007b603          	ld	a2,0(a5)
    18fc:	0087b683          	ld	a3,8(a5)
    1900:	0107b703          	ld	a4,16(a5)
    1904:	0187b783          	ld	a5,24(a5)
    1908:	f2c43823          	sd	a2,-208(s0)
    190c:	f2d43c23          	sd	a3,-200(s0)
    1910:	f4e43023          	sd	a4,-192(s0)
    1914:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    1918:	f3040593          	add	a1,s0,-208
    191c:	00006517          	auipc	a0,0x6
    1920:	e7c50513          	add	a0,a0,-388 # 7798 <malloc+0x180>
    1924:	00005097          	auipc	ra,0x5
    1928:	768080e7          	jalr	1896(ra) # 708c <exec>
    if(ret != -1){
    192c:	fff00793          	li	a5,-1
    1930:	0cf50a63          	beq	a0,a5,1a04 <copyinstr2+0x1e4>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    1934:	fff00593          	li	a1,-1
    1938:	00006517          	auipc	a0,0x6
    193c:	69050513          	add	a0,a0,1680 # 7fc8 <malloc+0x9b0>
    1940:	00006097          	auipc	ra,0x6
    1944:	bd4080e7          	jalr	-1068(ra) # 7514 <printf>
      exit(1);
    1948:	00100513          	li	a0,1
    194c:	00005097          	auipc	ra,0x5
    1950:	6ec080e7          	jalr	1772(ra) # 7038 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    1954:	00050613          	mv	a2,a0
    1958:	f6840593          	add	a1,s0,-152
    195c:	00006517          	auipc	a0,0x6
    1960:	5e450513          	add	a0,a0,1508 # 7f40 <malloc+0x928>
    1964:	00006097          	auipc	ra,0x6
    1968:	bb0080e7          	jalr	-1104(ra) # 7514 <printf>
    exit(1);
    196c:	00100513          	li	a0,1
    1970:	00005097          	auipc	ra,0x5
    1974:	6c8080e7          	jalr	1736(ra) # 7038 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    1978:	00050613          	mv	a2,a0
    197c:	f6840593          	add	a1,s0,-152
    1980:	00006517          	auipc	a0,0x6
    1984:	5e050513          	add	a0,a0,1504 # 7f60 <malloc+0x948>
    1988:	00006097          	auipc	ra,0x6
    198c:	b8c080e7          	jalr	-1140(ra) # 7514 <printf>
    exit(1);
    1990:	00100513          	li	a0,1
    1994:	00005097          	auipc	ra,0x5
    1998:	6a4080e7          	jalr	1700(ra) # 7038 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    199c:	00050693          	mv	a3,a0
    19a0:	f6840613          	add	a2,s0,-152
    19a4:	00060593          	mv	a1,a2
    19a8:	00006517          	auipc	a0,0x6
    19ac:	5d850513          	add	a0,a0,1496 # 7f80 <malloc+0x968>
    19b0:	00006097          	auipc	ra,0x6
    19b4:	b64080e7          	jalr	-1180(ra) # 7514 <printf>
    exit(1);
    19b8:	00100513          	li	a0,1
    19bc:	00005097          	auipc	ra,0x5
    19c0:	67c080e7          	jalr	1660(ra) # 7038 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    19c4:	fff00613          	li	a2,-1
    19c8:	f6840593          	add	a1,s0,-152
    19cc:	00006517          	auipc	a0,0x6
    19d0:	5dc50513          	add	a0,a0,1500 # 7fa8 <malloc+0x990>
    19d4:	00006097          	auipc	ra,0x6
    19d8:	b40080e7          	jalr	-1216(ra) # 7514 <printf>
    exit(1);
    19dc:	00100513          	li	a0,1
    19e0:	00005097          	auipc	ra,0x5
    19e4:	658080e7          	jalr	1624(ra) # 7038 <exit>
    printf("fork failed\n");
    19e8:	00007517          	auipc	a0,0x7
    19ec:	a4050513          	add	a0,a0,-1472 # 8428 <malloc+0xe10>
    19f0:	00006097          	auipc	ra,0x6
    19f4:	b24080e7          	jalr	-1244(ra) # 7514 <printf>
    exit(1);
    19f8:	00100513          	li	a0,1
    19fc:	00005097          	auipc	ra,0x5
    1a00:	63c080e7          	jalr	1596(ra) # 7038 <exit>
    exit(747); // OK
    1a04:	2eb00513          	li	a0,747
    1a08:	00005097          	auipc	ra,0x5
    1a0c:	630080e7          	jalr	1584(ra) # 7038 <exit>
  int st = 0;
    1a10:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    1a14:	f5440513          	add	a0,s0,-172
    1a18:	00005097          	auipc	ra,0x5
    1a1c:	62c080e7          	jalr	1580(ra) # 7044 <wait>
  if(st != 747){
    1a20:	f5442703          	lw	a4,-172(s0)
    1a24:	2eb00793          	li	a5,747
    1a28:	00f71a63          	bne	a4,a5,1a3c <copyinstr2+0x21c>
}
    1a2c:	0c813083          	ld	ra,200(sp)
    1a30:	0c013403          	ld	s0,192(sp)
    1a34:	0d010113          	add	sp,sp,208
    1a38:	00008067          	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    1a3c:	00006517          	auipc	a0,0x6
    1a40:	5b450513          	add	a0,a0,1460 # 7ff0 <malloc+0x9d8>
    1a44:	00006097          	auipc	ra,0x6
    1a48:	ad0080e7          	jalr	-1328(ra) # 7514 <printf>
    exit(1);
    1a4c:	00100513          	li	a0,1
    1a50:	00005097          	auipc	ra,0x5
    1a54:	5e8080e7          	jalr	1512(ra) # 7038 <exit>

0000000000001a58 <truncate3>:
{
    1a58:	f9010113          	add	sp,sp,-112
    1a5c:	06113423          	sd	ra,104(sp)
    1a60:	06813023          	sd	s0,96(sp)
    1a64:	04913c23          	sd	s1,88(sp)
    1a68:	05213823          	sd	s2,80(sp)
    1a6c:	05313423          	sd	s3,72(sp)
    1a70:	05413023          	sd	s4,64(sp)
    1a74:	03513c23          	sd	s5,56(sp)
    1a78:	07010413          	add	s0,sp,112
    1a7c:	00050913          	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    1a80:	60100593          	li	a1,1537
    1a84:	00006517          	auipc	a0,0x6
    1a88:	d6c50513          	add	a0,a0,-660 # 77f0 <malloc+0x1d8>
    1a8c:	00005097          	auipc	ra,0x5
    1a90:	60c080e7          	jalr	1548(ra) # 7098 <open>
    1a94:	00005097          	auipc	ra,0x5
    1a98:	5e0080e7          	jalr	1504(ra) # 7074 <close>
  pid = fork();
    1a9c:	00005097          	auipc	ra,0x5
    1aa0:	590080e7          	jalr	1424(ra) # 702c <fork>
  if(pid < 0){
    1aa4:	08054e63          	bltz	a0,1b40 <truncate3+0xe8>
  if(pid == 0){
    1aa8:	0e051e63          	bnez	a0,1ba4 <truncate3+0x14c>
    1aac:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    1ab0:	00006a17          	auipc	s4,0x6
    1ab4:	d40a0a13          	add	s4,s4,-704 # 77f0 <malloc+0x1d8>
      int n = write(fd, "1234567890", 10);
    1ab8:	00006a97          	auipc	s5,0x6
    1abc:	598a8a93          	add	s5,s5,1432 # 8050 <malloc+0xa38>
      int fd = open("truncfile", O_WRONLY);
    1ac0:	00100593          	li	a1,1
    1ac4:	000a0513          	mv	a0,s4
    1ac8:	00005097          	auipc	ra,0x5
    1acc:	5d0080e7          	jalr	1488(ra) # 7098 <open>
    1ad0:	00050493          	mv	s1,a0
      if(fd < 0){
    1ad4:	08054663          	bltz	a0,1b60 <truncate3+0x108>
      int n = write(fd, "1234567890", 10);
    1ad8:	00a00613          	li	a2,10
    1adc:	000a8593          	mv	a1,s5
    1ae0:	00005097          	auipc	ra,0x5
    1ae4:	588080e7          	jalr	1416(ra) # 7068 <write>
      if(n != 10){
    1ae8:	00a00793          	li	a5,10
    1aec:	08f51a63          	bne	a0,a5,1b80 <truncate3+0x128>
      close(fd);
    1af0:	00048513          	mv	a0,s1
    1af4:	00005097          	auipc	ra,0x5
    1af8:	580080e7          	jalr	1408(ra) # 7074 <close>
      fd = open("truncfile", O_RDONLY);
    1afc:	00000593          	li	a1,0
    1b00:	000a0513          	mv	a0,s4
    1b04:	00005097          	auipc	ra,0x5
    1b08:	594080e7          	jalr	1428(ra) # 7098 <open>
    1b0c:	00050493          	mv	s1,a0
      read(fd, buf, sizeof(buf));
    1b10:	02000613          	li	a2,32
    1b14:	f9840593          	add	a1,s0,-104
    1b18:	00005097          	auipc	ra,0x5
    1b1c:	544080e7          	jalr	1348(ra) # 705c <read>
      close(fd);
    1b20:	00048513          	mv	a0,s1
    1b24:	00005097          	auipc	ra,0x5
    1b28:	550080e7          	jalr	1360(ra) # 7074 <close>
    for(int i = 0; i < 100; i++){
    1b2c:	fff9899b          	addw	s3,s3,-1
    1b30:	f80998e3          	bnez	s3,1ac0 <truncate3+0x68>
    exit(0);
    1b34:	00000513          	li	a0,0
    1b38:	00005097          	auipc	ra,0x5
    1b3c:	500080e7          	jalr	1280(ra) # 7038 <exit>
    printf("%s: fork failed\n", s);
    1b40:	00090593          	mv	a1,s2
    1b44:	00006517          	auipc	a0,0x6
    1b48:	4dc50513          	add	a0,a0,1244 # 8020 <malloc+0xa08>
    1b4c:	00006097          	auipc	ra,0x6
    1b50:	9c8080e7          	jalr	-1592(ra) # 7514 <printf>
    exit(1);
    1b54:	00100513          	li	a0,1
    1b58:	00005097          	auipc	ra,0x5
    1b5c:	4e0080e7          	jalr	1248(ra) # 7038 <exit>
        printf("%s: open failed\n", s);
    1b60:	00090593          	mv	a1,s2
    1b64:	00006517          	auipc	a0,0x6
    1b68:	4d450513          	add	a0,a0,1236 # 8038 <malloc+0xa20>
    1b6c:	00006097          	auipc	ra,0x6
    1b70:	9a8080e7          	jalr	-1624(ra) # 7514 <printf>
        exit(1);
    1b74:	00100513          	li	a0,1
    1b78:	00005097          	auipc	ra,0x5
    1b7c:	4c0080e7          	jalr	1216(ra) # 7038 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    1b80:	00050613          	mv	a2,a0
    1b84:	00090593          	mv	a1,s2
    1b88:	00006517          	auipc	a0,0x6
    1b8c:	4d850513          	add	a0,a0,1240 # 8060 <malloc+0xa48>
    1b90:	00006097          	auipc	ra,0x6
    1b94:	984080e7          	jalr	-1660(ra) # 7514 <printf>
        exit(1);
    1b98:	00100513          	li	a0,1
    1b9c:	00005097          	auipc	ra,0x5
    1ba0:	49c080e7          	jalr	1180(ra) # 7038 <exit>
    1ba4:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    1ba8:	00006a17          	auipc	s4,0x6
    1bac:	c48a0a13          	add	s4,s4,-952 # 77f0 <malloc+0x1d8>
    int n = write(fd, "xxx", 3);
    1bb0:	00006a97          	auipc	s5,0x6
    1bb4:	4d0a8a93          	add	s5,s5,1232 # 8080 <malloc+0xa68>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    1bb8:	60100593          	li	a1,1537
    1bbc:	000a0513          	mv	a0,s4
    1bc0:	00005097          	auipc	ra,0x5
    1bc4:	4d8080e7          	jalr	1240(ra) # 7098 <open>
    1bc8:	00050493          	mv	s1,a0
    if(fd < 0){
    1bcc:	04054c63          	bltz	a0,1c24 <truncate3+0x1cc>
    int n = write(fd, "xxx", 3);
    1bd0:	00300613          	li	a2,3
    1bd4:	000a8593          	mv	a1,s5
    1bd8:	00005097          	auipc	ra,0x5
    1bdc:	490080e7          	jalr	1168(ra) # 7068 <write>
    if(n != 3){
    1be0:	00300793          	li	a5,3
    1be4:	06f51063          	bne	a0,a5,1c44 <truncate3+0x1ec>
    close(fd);
    1be8:	00048513          	mv	a0,s1
    1bec:	00005097          	auipc	ra,0x5
    1bf0:	488080e7          	jalr	1160(ra) # 7074 <close>
  for(int i = 0; i < 150; i++){
    1bf4:	fff9899b          	addw	s3,s3,-1
    1bf8:	fc0990e3          	bnez	s3,1bb8 <truncate3+0x160>
  wait(&xstatus);
    1bfc:	fbc40513          	add	a0,s0,-68
    1c00:	00005097          	auipc	ra,0x5
    1c04:	444080e7          	jalr	1092(ra) # 7044 <wait>
  unlink("truncfile");
    1c08:	00006517          	auipc	a0,0x6
    1c0c:	be850513          	add	a0,a0,-1048 # 77f0 <malloc+0x1d8>
    1c10:	00005097          	auipc	ra,0x5
    1c14:	4a0080e7          	jalr	1184(ra) # 70b0 <unlink>
  exit(xstatus);
    1c18:	fbc42503          	lw	a0,-68(s0)
    1c1c:	00005097          	auipc	ra,0x5
    1c20:	41c080e7          	jalr	1052(ra) # 7038 <exit>
      printf("%s: open failed\n", s);
    1c24:	00090593          	mv	a1,s2
    1c28:	00006517          	auipc	a0,0x6
    1c2c:	41050513          	add	a0,a0,1040 # 8038 <malloc+0xa20>
    1c30:	00006097          	auipc	ra,0x6
    1c34:	8e4080e7          	jalr	-1820(ra) # 7514 <printf>
      exit(1);
    1c38:	00100513          	li	a0,1
    1c3c:	00005097          	auipc	ra,0x5
    1c40:	3fc080e7          	jalr	1020(ra) # 7038 <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    1c44:	00050613          	mv	a2,a0
    1c48:	00090593          	mv	a1,s2
    1c4c:	00006517          	auipc	a0,0x6
    1c50:	43c50513          	add	a0,a0,1084 # 8088 <malloc+0xa70>
    1c54:	00006097          	auipc	ra,0x6
    1c58:	8c0080e7          	jalr	-1856(ra) # 7514 <printf>
      exit(1);
    1c5c:	00100513          	li	a0,1
    1c60:	00005097          	auipc	ra,0x5
    1c64:	3d8080e7          	jalr	984(ra) # 7038 <exit>

0000000000001c68 <exectest>:
{
    1c68:	fb010113          	add	sp,sp,-80
    1c6c:	04113423          	sd	ra,72(sp)
    1c70:	04813023          	sd	s0,64(sp)
    1c74:	02913c23          	sd	s1,56(sp)
    1c78:	03213823          	sd	s2,48(sp)
    1c7c:	05010413          	add	s0,sp,80
    1c80:	00050913          	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    1c84:	00006797          	auipc	a5,0x6
    1c88:	b1478793          	add	a5,a5,-1260 # 7798 <malloc+0x180>
    1c8c:	fcf43023          	sd	a5,-64(s0)
    1c90:	00006797          	auipc	a5,0x6
    1c94:	41878793          	add	a5,a5,1048 # 80a8 <malloc+0xa90>
    1c98:	fcf43423          	sd	a5,-56(s0)
    1c9c:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    1ca0:	00006517          	auipc	a0,0x6
    1ca4:	41050513          	add	a0,a0,1040 # 80b0 <malloc+0xa98>
    1ca8:	00005097          	auipc	ra,0x5
    1cac:	408080e7          	jalr	1032(ra) # 70b0 <unlink>
  pid = fork();
    1cb0:	00005097          	auipc	ra,0x5
    1cb4:	37c080e7          	jalr	892(ra) # 702c <fork>
  if(pid < 0) {
    1cb8:	04054c63          	bltz	a0,1d10 <exectest+0xa8>
    1cbc:	00050493          	mv	s1,a0
  if(pid == 0) {
    1cc0:	0a051463          	bnez	a0,1d68 <exectest+0x100>
    close(1);
    1cc4:	00100513          	li	a0,1
    1cc8:	00005097          	auipc	ra,0x5
    1ccc:	3ac080e7          	jalr	940(ra) # 7074 <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    1cd0:	20100593          	li	a1,513
    1cd4:	00006517          	auipc	a0,0x6
    1cd8:	3dc50513          	add	a0,a0,988 # 80b0 <malloc+0xa98>
    1cdc:	00005097          	auipc	ra,0x5
    1ce0:	3bc080e7          	jalr	956(ra) # 7098 <open>
    if(fd < 0) {
    1ce4:	04054663          	bltz	a0,1d30 <exectest+0xc8>
    if(fd != 1) {
    1ce8:	00100793          	li	a5,1
    1cec:	06f50263          	beq	a0,a5,1d50 <exectest+0xe8>
      printf("%s: wrong fd\n", s);
    1cf0:	00090593          	mv	a1,s2
    1cf4:	00006517          	auipc	a0,0x6
    1cf8:	3dc50513          	add	a0,a0,988 # 80d0 <malloc+0xab8>
    1cfc:	00006097          	auipc	ra,0x6
    1d00:	818080e7          	jalr	-2024(ra) # 7514 <printf>
      exit(1);
    1d04:	00100513          	li	a0,1
    1d08:	00005097          	auipc	ra,0x5
    1d0c:	330080e7          	jalr	816(ra) # 7038 <exit>
     printf("%s: fork failed\n", s);
    1d10:	00090593          	mv	a1,s2
    1d14:	00006517          	auipc	a0,0x6
    1d18:	30c50513          	add	a0,a0,780 # 8020 <malloc+0xa08>
    1d1c:	00005097          	auipc	ra,0x5
    1d20:	7f8080e7          	jalr	2040(ra) # 7514 <printf>
     exit(1);
    1d24:	00100513          	li	a0,1
    1d28:	00005097          	auipc	ra,0x5
    1d2c:	310080e7          	jalr	784(ra) # 7038 <exit>
      printf("%s: create failed\n", s);
    1d30:	00090593          	mv	a1,s2
    1d34:	00006517          	auipc	a0,0x6
    1d38:	38450513          	add	a0,a0,900 # 80b8 <malloc+0xaa0>
    1d3c:	00005097          	auipc	ra,0x5
    1d40:	7d8080e7          	jalr	2008(ra) # 7514 <printf>
      exit(1);
    1d44:	00100513          	li	a0,1
    1d48:	00005097          	auipc	ra,0x5
    1d4c:	2f0080e7          	jalr	752(ra) # 7038 <exit>
    if(exec("echo", echoargv) < 0){
    1d50:	fc040593          	add	a1,s0,-64
    1d54:	00006517          	auipc	a0,0x6
    1d58:	a4450513          	add	a0,a0,-1468 # 7798 <malloc+0x180>
    1d5c:	00005097          	auipc	ra,0x5
    1d60:	330080e7          	jalr	816(ra) # 708c <exec>
    1d64:	02054263          	bltz	a0,1d88 <exectest+0x120>
  if (wait(&xstatus) != pid) {
    1d68:	fdc40513          	add	a0,s0,-36
    1d6c:	00005097          	auipc	ra,0x5
    1d70:	2d8080e7          	jalr	728(ra) # 7044 <wait>
    1d74:	02951a63          	bne	a0,s1,1da8 <exectest+0x140>
  if(xstatus != 0)
    1d78:	fdc42503          	lw	a0,-36(s0)
    1d7c:	04050263          	beqz	a0,1dc0 <exectest+0x158>
    exit(xstatus);
    1d80:	00005097          	auipc	ra,0x5
    1d84:	2b8080e7          	jalr	696(ra) # 7038 <exit>
      printf("%s: exec echo failed\n", s);
    1d88:	00090593          	mv	a1,s2
    1d8c:	00006517          	auipc	a0,0x6
    1d90:	35450513          	add	a0,a0,852 # 80e0 <malloc+0xac8>
    1d94:	00005097          	auipc	ra,0x5
    1d98:	780080e7          	jalr	1920(ra) # 7514 <printf>
      exit(1);
    1d9c:	00100513          	li	a0,1
    1da0:	00005097          	auipc	ra,0x5
    1da4:	298080e7          	jalr	664(ra) # 7038 <exit>
    printf("%s: wait failed!\n", s);
    1da8:	00090593          	mv	a1,s2
    1dac:	00006517          	auipc	a0,0x6
    1db0:	34c50513          	add	a0,a0,844 # 80f8 <malloc+0xae0>
    1db4:	00005097          	auipc	ra,0x5
    1db8:	760080e7          	jalr	1888(ra) # 7514 <printf>
    1dbc:	fbdff06f          	j	1d78 <exectest+0x110>
  fd = open("echo-ok", O_RDONLY);
    1dc0:	00000593          	li	a1,0
    1dc4:	00006517          	auipc	a0,0x6
    1dc8:	2ec50513          	add	a0,a0,748 # 80b0 <malloc+0xa98>
    1dcc:	00005097          	auipc	ra,0x5
    1dd0:	2cc080e7          	jalr	716(ra) # 7098 <open>
  if(fd < 0) {
    1dd4:	02054e63          	bltz	a0,1e10 <exectest+0x1a8>
  if (read(fd, buf, 2) != 2) {
    1dd8:	00200613          	li	a2,2
    1ddc:	fb840593          	add	a1,s0,-72
    1de0:	00005097          	auipc	ra,0x5
    1de4:	27c080e7          	jalr	636(ra) # 705c <read>
    1de8:	00200793          	li	a5,2
    1dec:	04f50263          	beq	a0,a5,1e30 <exectest+0x1c8>
    printf("%s: read failed\n", s);
    1df0:	00090593          	mv	a1,s2
    1df4:	00006517          	auipc	a0,0x6
    1df8:	d7450513          	add	a0,a0,-652 # 7b68 <malloc+0x550>
    1dfc:	00005097          	auipc	ra,0x5
    1e00:	718080e7          	jalr	1816(ra) # 7514 <printf>
    exit(1);
    1e04:	00100513          	li	a0,1
    1e08:	00005097          	auipc	ra,0x5
    1e0c:	230080e7          	jalr	560(ra) # 7038 <exit>
    printf("%s: open failed\n", s);
    1e10:	00090593          	mv	a1,s2
    1e14:	00006517          	auipc	a0,0x6
    1e18:	22450513          	add	a0,a0,548 # 8038 <malloc+0xa20>
    1e1c:	00005097          	auipc	ra,0x5
    1e20:	6f8080e7          	jalr	1784(ra) # 7514 <printf>
    exit(1);
    1e24:	00100513          	li	a0,1
    1e28:	00005097          	auipc	ra,0x5
    1e2c:	210080e7          	jalr	528(ra) # 7038 <exit>
  unlink("echo-ok");
    1e30:	00006517          	auipc	a0,0x6
    1e34:	28050513          	add	a0,a0,640 # 80b0 <malloc+0xa98>
    1e38:	00005097          	auipc	ra,0x5
    1e3c:	278080e7          	jalr	632(ra) # 70b0 <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    1e40:	fb844703          	lbu	a4,-72(s0)
    1e44:	04f00793          	li	a5,79
    1e48:	00f71863          	bne	a4,a5,1e58 <exectest+0x1f0>
    1e4c:	fb944703          	lbu	a4,-71(s0)
    1e50:	04b00793          	li	a5,75
    1e54:	02f70263          	beq	a4,a5,1e78 <exectest+0x210>
    printf("%s: wrong output\n", s);
    1e58:	00090593          	mv	a1,s2
    1e5c:	00006517          	auipc	a0,0x6
    1e60:	2b450513          	add	a0,a0,692 # 8110 <malloc+0xaf8>
    1e64:	00005097          	auipc	ra,0x5
    1e68:	6b0080e7          	jalr	1712(ra) # 7514 <printf>
    exit(1);
    1e6c:	00100513          	li	a0,1
    1e70:	00005097          	auipc	ra,0x5
    1e74:	1c8080e7          	jalr	456(ra) # 7038 <exit>
    exit(0);
    1e78:	00000513          	li	a0,0
    1e7c:	00005097          	auipc	ra,0x5
    1e80:	1bc080e7          	jalr	444(ra) # 7038 <exit>

0000000000001e84 <pipe1>:
{
    1e84:	fa010113          	add	sp,sp,-96
    1e88:	04113c23          	sd	ra,88(sp)
    1e8c:	04813823          	sd	s0,80(sp)
    1e90:	04913423          	sd	s1,72(sp)
    1e94:	05213023          	sd	s2,64(sp)
    1e98:	03313c23          	sd	s3,56(sp)
    1e9c:	03413823          	sd	s4,48(sp)
    1ea0:	03513423          	sd	s5,40(sp)
    1ea4:	03613023          	sd	s6,32(sp)
    1ea8:	01713c23          	sd	s7,24(sp)
    1eac:	06010413          	add	s0,sp,96
    1eb0:	00050913          	mv	s2,a0
  if(pipe(fds) != 0){
    1eb4:	fa840513          	add	a0,s0,-88
    1eb8:	00005097          	auipc	ra,0x5
    1ebc:	198080e7          	jalr	408(ra) # 7050 <pipe>
    1ec0:	08051863          	bnez	a0,1f50 <pipe1+0xcc>
    1ec4:	00050493          	mv	s1,a0
  pid = fork();
    1ec8:	00005097          	auipc	ra,0x5
    1ecc:	164080e7          	jalr	356(ra) # 702c <fork>
    1ed0:	00050a13          	mv	s4,a0
  if(pid == 0){
    1ed4:	08050e63          	beqz	a0,1f70 <pipe1+0xec>
  } else if(pid > 0){
    1ed8:	1ca05063          	blez	a0,2098 <pipe1+0x214>
    close(fds[1]);
    1edc:	fac42503          	lw	a0,-84(s0)
    1ee0:	00005097          	auipc	ra,0x5
    1ee4:	194080e7          	jalr	404(ra) # 7074 <close>
    total = 0;
    1ee8:	00048a13          	mv	s4,s1
    cc = 1;
    1eec:	00100993          	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
    1ef0:	0000ca97          	auipc	s5,0xc
    1ef4:	d88a8a93          	add	s5,s5,-632 # dc78 <buf>
    1ef8:	00098613          	mv	a2,s3
    1efc:	000a8593          	mv	a1,s5
    1f00:	fa842503          	lw	a0,-88(s0)
    1f04:	00005097          	auipc	ra,0x5
    1f08:	158080e7          	jalr	344(ra) # 705c <read>
    1f0c:	12a05e63          	blez	a0,2048 <pipe1+0x1c4>
      for(i = 0; i < n; i++){
    1f10:	0000c717          	auipc	a4,0xc
    1f14:	d6870713          	add	a4,a4,-664 # dc78 <buf>
    1f18:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    1f1c:	00074683          	lbu	a3,0(a4)
    1f20:	0ff4f793          	zext.b	a5,s1
    1f24:	0014849b          	addw	s1,s1,1
    1f28:	0ef69063          	bne	a3,a5,2008 <pipe1+0x184>
      for(i = 0; i < n; i++){
    1f2c:	00170713          	add	a4,a4,1
    1f30:	fec496e3          	bne	s1,a2,1f1c <pipe1+0x98>
      total += n;
    1f34:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    1f38:	0019979b          	sllw	a5,s3,0x1
    1f3c:	0007899b          	sext.w	s3,a5
      if(cc > sizeof(buf))
    1f40:	00003737          	lui	a4,0x3
    1f44:	fb377ae3          	bgeu	a4,s3,1ef8 <pipe1+0x74>
        cc = sizeof(buf);
    1f48:	000039b7          	lui	s3,0x3
    1f4c:	fadff06f          	j	1ef8 <pipe1+0x74>
    printf("%s: pipe() failed\n", s);
    1f50:	00090593          	mv	a1,s2
    1f54:	00006517          	auipc	a0,0x6
    1f58:	1d450513          	add	a0,a0,468 # 8128 <malloc+0xb10>
    1f5c:	00005097          	auipc	ra,0x5
    1f60:	5b8080e7          	jalr	1464(ra) # 7514 <printf>
    exit(1);
    1f64:	00100513          	li	a0,1
    1f68:	00005097          	auipc	ra,0x5
    1f6c:	0d0080e7          	jalr	208(ra) # 7038 <exit>
    close(fds[0]);
    1f70:	fa842503          	lw	a0,-88(s0)
    1f74:	00005097          	auipc	ra,0x5
    1f78:	100080e7          	jalr	256(ra) # 7074 <close>
    for(n = 0; n < N; n++){
    1f7c:	0000cb17          	auipc	s6,0xc
    1f80:	cfcb0b13          	add	s6,s6,-772 # dc78 <buf>
    1f84:	416004bb          	negw	s1,s6
    1f88:	0ff4f493          	zext.b	s1,s1
    1f8c:	409b0993          	add	s3,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    1f90:	000b0b93          	mv	s7,s6
    for(n = 0; n < N; n++){
    1f94:	00001ab7          	lui	s5,0x1
    1f98:	42da8a93          	add	s5,s5,1069 # 142d <linktest+0x1a9>
{
    1f9c:	000b0793          	mv	a5,s6
        buf[i] = seq++;
    1fa0:	0097873b          	addw	a4,a5,s1
    1fa4:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1fa8:	00178793          	add	a5,a5,1
    1fac:	fef99ae3          	bne	s3,a5,1fa0 <pipe1+0x11c>
        buf[i] = seq++;
    1fb0:	409a0a1b          	addw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    1fb4:	40900613          	li	a2,1033
    1fb8:	000b8593          	mv	a1,s7
    1fbc:	fac42503          	lw	a0,-84(s0)
    1fc0:	00005097          	auipc	ra,0x5
    1fc4:	0a8080e7          	jalr	168(ra) # 7068 <write>
    1fc8:	40900793          	li	a5,1033
    1fcc:	00f51e63          	bne	a0,a5,1fe8 <pipe1+0x164>
    for(n = 0; n < N; n++){
    1fd0:	0094849b          	addw	s1,s1,9
    1fd4:	0ff4f493          	zext.b	s1,s1
    1fd8:	fd5a12e3          	bne	s4,s5,1f9c <pipe1+0x118>
    exit(0);
    1fdc:	00000513          	li	a0,0
    1fe0:	00005097          	auipc	ra,0x5
    1fe4:	058080e7          	jalr	88(ra) # 7038 <exit>
        printf("%s: pipe1 oops 1\n", s);
    1fe8:	00090593          	mv	a1,s2
    1fec:	00006517          	auipc	a0,0x6
    1ff0:	15450513          	add	a0,a0,340 # 8140 <malloc+0xb28>
    1ff4:	00005097          	auipc	ra,0x5
    1ff8:	520080e7          	jalr	1312(ra) # 7514 <printf>
        exit(1);
    1ffc:	00100513          	li	a0,1
    2000:	00005097          	auipc	ra,0x5
    2004:	038080e7          	jalr	56(ra) # 7038 <exit>
          printf("%s: pipe1 oops 2\n", s);
    2008:	00090593          	mv	a1,s2
    200c:	00006517          	auipc	a0,0x6
    2010:	14c50513          	add	a0,a0,332 # 8158 <malloc+0xb40>
    2014:	00005097          	auipc	ra,0x5
    2018:	500080e7          	jalr	1280(ra) # 7514 <printf>
}
    201c:	05813083          	ld	ra,88(sp)
    2020:	05013403          	ld	s0,80(sp)
    2024:	04813483          	ld	s1,72(sp)
    2028:	04013903          	ld	s2,64(sp)
    202c:	03813983          	ld	s3,56(sp)
    2030:	03013a03          	ld	s4,48(sp)
    2034:	02813a83          	ld	s5,40(sp)
    2038:	02013b03          	ld	s6,32(sp)
    203c:	01813b83          	ld	s7,24(sp)
    2040:	06010113          	add	sp,sp,96
    2044:	00008067          	ret
    if(total != N * SZ){
    2048:	000017b7          	lui	a5,0x1
    204c:	42d78793          	add	a5,a5,1069 # 142d <linktest+0x1a9>
    2050:	02fa0263          	beq	s4,a5,2074 <pipe1+0x1f0>
      printf("%s: pipe1 oops 3 total %d\n", total);
    2054:	000a0593          	mv	a1,s4
    2058:	00006517          	auipc	a0,0x6
    205c:	11850513          	add	a0,a0,280 # 8170 <malloc+0xb58>
    2060:	00005097          	auipc	ra,0x5
    2064:	4b4080e7          	jalr	1204(ra) # 7514 <printf>
      exit(1);
    2068:	00100513          	li	a0,1
    206c:	00005097          	auipc	ra,0x5
    2070:	fcc080e7          	jalr	-52(ra) # 7038 <exit>
    close(fds[0]);
    2074:	fa842503          	lw	a0,-88(s0)
    2078:	00005097          	auipc	ra,0x5
    207c:	ffc080e7          	jalr	-4(ra) # 7074 <close>
    wait(&xstatus);
    2080:	fa440513          	add	a0,s0,-92
    2084:	00005097          	auipc	ra,0x5
    2088:	fc0080e7          	jalr	-64(ra) # 7044 <wait>
    exit(xstatus);
    208c:	fa442503          	lw	a0,-92(s0)
    2090:	00005097          	auipc	ra,0x5
    2094:	fa8080e7          	jalr	-88(ra) # 7038 <exit>
    printf("%s: fork() failed\n", s);
    2098:	00090593          	mv	a1,s2
    209c:	00006517          	auipc	a0,0x6
    20a0:	0f450513          	add	a0,a0,244 # 8190 <malloc+0xb78>
    20a4:	00005097          	auipc	ra,0x5
    20a8:	470080e7          	jalr	1136(ra) # 7514 <printf>
    exit(1);
    20ac:	00100513          	li	a0,1
    20b0:	00005097          	auipc	ra,0x5
    20b4:	f88080e7          	jalr	-120(ra) # 7038 <exit>

00000000000020b8 <exitwait>:
{
    20b8:	fc010113          	add	sp,sp,-64
    20bc:	02113c23          	sd	ra,56(sp)
    20c0:	02813823          	sd	s0,48(sp)
    20c4:	02913423          	sd	s1,40(sp)
    20c8:	03213023          	sd	s2,32(sp)
    20cc:	01313c23          	sd	s3,24(sp)
    20d0:	01413823          	sd	s4,16(sp)
    20d4:	04010413          	add	s0,sp,64
    20d8:	00050a13          	mv	s4,a0
  for(i = 0; i < 100; i++){
    20dc:	00000913          	li	s2,0
    20e0:	06400993          	li	s3,100
    pid = fork();
    20e4:	00005097          	auipc	ra,0x5
    20e8:	f48080e7          	jalr	-184(ra) # 702c <fork>
    20ec:	00050493          	mv	s1,a0
    if(pid < 0){
    20f0:	04054463          	bltz	a0,2138 <exitwait+0x80>
    if(pid){
    20f4:	0a050263          	beqz	a0,2198 <exitwait+0xe0>
      if(wait(&xstate) != pid){
    20f8:	fcc40513          	add	a0,s0,-52
    20fc:	00005097          	auipc	ra,0x5
    2100:	f48080e7          	jalr	-184(ra) # 7044 <wait>
    2104:	04951a63          	bne	a0,s1,2158 <exitwait+0xa0>
      if(i != xstate) {
    2108:	fcc42783          	lw	a5,-52(s0)
    210c:	07279663          	bne	a5,s2,2178 <exitwait+0xc0>
  for(i = 0; i < 100; i++){
    2110:	0019091b          	addw	s2,s2,1
    2114:	fd3918e3          	bne	s2,s3,20e4 <exitwait+0x2c>
}
    2118:	03813083          	ld	ra,56(sp)
    211c:	03013403          	ld	s0,48(sp)
    2120:	02813483          	ld	s1,40(sp)
    2124:	02013903          	ld	s2,32(sp)
    2128:	01813983          	ld	s3,24(sp)
    212c:	01013a03          	ld	s4,16(sp)
    2130:	04010113          	add	sp,sp,64
    2134:	00008067          	ret
      printf("%s: fork failed\n", s);
    2138:	000a0593          	mv	a1,s4
    213c:	00006517          	auipc	a0,0x6
    2140:	ee450513          	add	a0,a0,-284 # 8020 <malloc+0xa08>
    2144:	00005097          	auipc	ra,0x5
    2148:	3d0080e7          	jalr	976(ra) # 7514 <printf>
      exit(1);
    214c:	00100513          	li	a0,1
    2150:	00005097          	auipc	ra,0x5
    2154:	ee8080e7          	jalr	-280(ra) # 7038 <exit>
        printf("%s: wait wrong pid\n", s);
    2158:	000a0593          	mv	a1,s4
    215c:	00006517          	auipc	a0,0x6
    2160:	04c50513          	add	a0,a0,76 # 81a8 <malloc+0xb90>
    2164:	00005097          	auipc	ra,0x5
    2168:	3b0080e7          	jalr	944(ra) # 7514 <printf>
        exit(1);
    216c:	00100513          	li	a0,1
    2170:	00005097          	auipc	ra,0x5
    2174:	ec8080e7          	jalr	-312(ra) # 7038 <exit>
        printf("%s: wait wrong exit status\n", s);
    2178:	000a0593          	mv	a1,s4
    217c:	00006517          	auipc	a0,0x6
    2180:	04450513          	add	a0,a0,68 # 81c0 <malloc+0xba8>
    2184:	00005097          	auipc	ra,0x5
    2188:	390080e7          	jalr	912(ra) # 7514 <printf>
        exit(1);
    218c:	00100513          	li	a0,1
    2190:	00005097          	auipc	ra,0x5
    2194:	ea8080e7          	jalr	-344(ra) # 7038 <exit>
      exit(i);
    2198:	00090513          	mv	a0,s2
    219c:	00005097          	auipc	ra,0x5
    21a0:	e9c080e7          	jalr	-356(ra) # 7038 <exit>

00000000000021a4 <twochildren>:
{
    21a4:	fe010113          	add	sp,sp,-32
    21a8:	00113c23          	sd	ra,24(sp)
    21ac:	00813823          	sd	s0,16(sp)
    21b0:	00913423          	sd	s1,8(sp)
    21b4:	01213023          	sd	s2,0(sp)
    21b8:	02010413          	add	s0,sp,32
    21bc:	00050913          	mv	s2,a0
    21c0:	3e800493          	li	s1,1000
    int pid1 = fork();
    21c4:	00005097          	auipc	ra,0x5
    21c8:	e68080e7          	jalr	-408(ra) # 702c <fork>
    if(pid1 < 0){
    21cc:	04054863          	bltz	a0,221c <twochildren+0x78>
    if(pid1 == 0){
    21d0:	06050663          	beqz	a0,223c <twochildren+0x98>
      int pid2 = fork();
    21d4:	00005097          	auipc	ra,0x5
    21d8:	e58080e7          	jalr	-424(ra) # 702c <fork>
      if(pid2 < 0){
    21dc:	06054463          	bltz	a0,2244 <twochildren+0xa0>
      if(pid2 == 0){
    21e0:	08050263          	beqz	a0,2264 <twochildren+0xc0>
        wait(0);
    21e4:	00000513          	li	a0,0
    21e8:	00005097          	auipc	ra,0x5
    21ec:	e5c080e7          	jalr	-420(ra) # 7044 <wait>
        wait(0);
    21f0:	00000513          	li	a0,0
    21f4:	00005097          	auipc	ra,0x5
    21f8:	e50080e7          	jalr	-432(ra) # 7044 <wait>
  for(int i = 0; i < 1000; i++){
    21fc:	fff4849b          	addw	s1,s1,-1
    2200:	fc0492e3          	bnez	s1,21c4 <twochildren+0x20>
}
    2204:	01813083          	ld	ra,24(sp)
    2208:	01013403          	ld	s0,16(sp)
    220c:	00813483          	ld	s1,8(sp)
    2210:	00013903          	ld	s2,0(sp)
    2214:	02010113          	add	sp,sp,32
    2218:	00008067          	ret
      printf("%s: fork failed\n", s);
    221c:	00090593          	mv	a1,s2
    2220:	00006517          	auipc	a0,0x6
    2224:	e0050513          	add	a0,a0,-512 # 8020 <malloc+0xa08>
    2228:	00005097          	auipc	ra,0x5
    222c:	2ec080e7          	jalr	748(ra) # 7514 <printf>
      exit(1);
    2230:	00100513          	li	a0,1
    2234:	00005097          	auipc	ra,0x5
    2238:	e04080e7          	jalr	-508(ra) # 7038 <exit>
      exit(0);
    223c:	00005097          	auipc	ra,0x5
    2240:	dfc080e7          	jalr	-516(ra) # 7038 <exit>
        printf("%s: fork failed\n", s);
    2244:	00090593          	mv	a1,s2
    2248:	00006517          	auipc	a0,0x6
    224c:	dd850513          	add	a0,a0,-552 # 8020 <malloc+0xa08>
    2250:	00005097          	auipc	ra,0x5
    2254:	2c4080e7          	jalr	708(ra) # 7514 <printf>
        exit(1);
    2258:	00100513          	li	a0,1
    225c:	00005097          	auipc	ra,0x5
    2260:	ddc080e7          	jalr	-548(ra) # 7038 <exit>
        exit(0);
    2264:	00005097          	auipc	ra,0x5
    2268:	dd4080e7          	jalr	-556(ra) # 7038 <exit>

000000000000226c <forkfork>:
{
    226c:	fd010113          	add	sp,sp,-48
    2270:	02113423          	sd	ra,40(sp)
    2274:	02813023          	sd	s0,32(sp)
    2278:	00913c23          	sd	s1,24(sp)
    227c:	03010413          	add	s0,sp,48
    2280:	00050493          	mv	s1,a0
    int pid = fork();
    2284:	00005097          	auipc	ra,0x5
    2288:	da8080e7          	jalr	-600(ra) # 702c <fork>
    if(pid < 0){
    228c:	04054a63          	bltz	a0,22e0 <forkfork+0x74>
    if(pid == 0){
    2290:	06050863          	beqz	a0,2300 <forkfork+0x94>
    int pid = fork();
    2294:	00005097          	auipc	ra,0x5
    2298:	d98080e7          	jalr	-616(ra) # 702c <fork>
    if(pid < 0){
    229c:	04054263          	bltz	a0,22e0 <forkfork+0x74>
    if(pid == 0){
    22a0:	06050063          	beqz	a0,2300 <forkfork+0x94>
    wait(&xstatus);
    22a4:	fdc40513          	add	a0,s0,-36
    22a8:	00005097          	auipc	ra,0x5
    22ac:	d9c080e7          	jalr	-612(ra) # 7044 <wait>
    if(xstatus != 0) {
    22b0:	fdc42783          	lw	a5,-36(s0)
    22b4:	08079a63          	bnez	a5,2348 <forkfork+0xdc>
    wait(&xstatus);
    22b8:	fdc40513          	add	a0,s0,-36
    22bc:	00005097          	auipc	ra,0x5
    22c0:	d88080e7          	jalr	-632(ra) # 7044 <wait>
    if(xstatus != 0) {
    22c4:	fdc42783          	lw	a5,-36(s0)
    22c8:	08079063          	bnez	a5,2348 <forkfork+0xdc>
}
    22cc:	02813083          	ld	ra,40(sp)
    22d0:	02013403          	ld	s0,32(sp)
    22d4:	01813483          	ld	s1,24(sp)
    22d8:	03010113          	add	sp,sp,48
    22dc:	00008067          	ret
      printf("%s: fork failed", s);
    22e0:	00048593          	mv	a1,s1
    22e4:	00006517          	auipc	a0,0x6
    22e8:	efc50513          	add	a0,a0,-260 # 81e0 <malloc+0xbc8>
    22ec:	00005097          	auipc	ra,0x5
    22f0:	228080e7          	jalr	552(ra) # 7514 <printf>
      exit(1);
    22f4:	00100513          	li	a0,1
    22f8:	00005097          	auipc	ra,0x5
    22fc:	d40080e7          	jalr	-704(ra) # 7038 <exit>
{
    2300:	0c800493          	li	s1,200
        int pid1 = fork();
    2304:	00005097          	auipc	ra,0x5
    2308:	d28080e7          	jalr	-728(ra) # 702c <fork>
        if(pid1 < 0){
    230c:	02054463          	bltz	a0,2334 <forkfork+0xc8>
        if(pid1 == 0){
    2310:	02050863          	beqz	a0,2340 <forkfork+0xd4>
        wait(0);
    2314:	00000513          	li	a0,0
    2318:	00005097          	auipc	ra,0x5
    231c:	d2c080e7          	jalr	-724(ra) # 7044 <wait>
      for(int j = 0; j < 200; j++){
    2320:	fff4849b          	addw	s1,s1,-1
    2324:	fe0490e3          	bnez	s1,2304 <forkfork+0x98>
      exit(0);
    2328:	00000513          	li	a0,0
    232c:	00005097          	auipc	ra,0x5
    2330:	d0c080e7          	jalr	-756(ra) # 7038 <exit>
          exit(1);
    2334:	00100513          	li	a0,1
    2338:	00005097          	auipc	ra,0x5
    233c:	d00080e7          	jalr	-768(ra) # 7038 <exit>
          exit(0);
    2340:	00005097          	auipc	ra,0x5
    2344:	cf8080e7          	jalr	-776(ra) # 7038 <exit>
      printf("%s: fork in child failed", s);
    2348:	00048593          	mv	a1,s1
    234c:	00006517          	auipc	a0,0x6
    2350:	ea450513          	add	a0,a0,-348 # 81f0 <malloc+0xbd8>
    2354:	00005097          	auipc	ra,0x5
    2358:	1c0080e7          	jalr	448(ra) # 7514 <printf>
      exit(1);
    235c:	00100513          	li	a0,1
    2360:	00005097          	auipc	ra,0x5
    2364:	cd8080e7          	jalr	-808(ra) # 7038 <exit>

0000000000002368 <reparent2>:
{
    2368:	fe010113          	add	sp,sp,-32
    236c:	00113c23          	sd	ra,24(sp)
    2370:	00813823          	sd	s0,16(sp)
    2374:	00913423          	sd	s1,8(sp)
    2378:	02010413          	add	s0,sp,32
    237c:	32000493          	li	s1,800
    int pid1 = fork();
    2380:	00005097          	auipc	ra,0x5
    2384:	cac080e7          	jalr	-852(ra) # 702c <fork>
    if(pid1 < 0){
    2388:	02054463          	bltz	a0,23b0 <reparent2+0x48>
    if(pid1 == 0){
    238c:	04050063          	beqz	a0,23cc <reparent2+0x64>
    wait(0);
    2390:	00000513          	li	a0,0
    2394:	00005097          	auipc	ra,0x5
    2398:	cb0080e7          	jalr	-848(ra) # 7044 <wait>
  for(int i = 0; i < 800; i++){
    239c:	fff4849b          	addw	s1,s1,-1
    23a0:	fe0490e3          	bnez	s1,2380 <reparent2+0x18>
  exit(0);
    23a4:	00000513          	li	a0,0
    23a8:	00005097          	auipc	ra,0x5
    23ac:	c90080e7          	jalr	-880(ra) # 7038 <exit>
      printf("fork failed\n");
    23b0:	00006517          	auipc	a0,0x6
    23b4:	07850513          	add	a0,a0,120 # 8428 <malloc+0xe10>
    23b8:	00005097          	auipc	ra,0x5
    23bc:	15c080e7          	jalr	348(ra) # 7514 <printf>
      exit(1);
    23c0:	00100513          	li	a0,1
    23c4:	00005097          	auipc	ra,0x5
    23c8:	c74080e7          	jalr	-908(ra) # 7038 <exit>
      fork();
    23cc:	00005097          	auipc	ra,0x5
    23d0:	c60080e7          	jalr	-928(ra) # 702c <fork>
      fork();
    23d4:	00005097          	auipc	ra,0x5
    23d8:	c58080e7          	jalr	-936(ra) # 702c <fork>
      exit(0);
    23dc:	00000513          	li	a0,0
    23e0:	00005097          	auipc	ra,0x5
    23e4:	c58080e7          	jalr	-936(ra) # 7038 <exit>

00000000000023e8 <createdelete>:
{
    23e8:	f7010113          	add	sp,sp,-144
    23ec:	08113423          	sd	ra,136(sp)
    23f0:	08813023          	sd	s0,128(sp)
    23f4:	06913c23          	sd	s1,120(sp)
    23f8:	07213823          	sd	s2,112(sp)
    23fc:	07313423          	sd	s3,104(sp)
    2400:	07413023          	sd	s4,96(sp)
    2404:	05513c23          	sd	s5,88(sp)
    2408:	05613823          	sd	s6,80(sp)
    240c:	05713423          	sd	s7,72(sp)
    2410:	05813023          	sd	s8,64(sp)
    2414:	03913c23          	sd	s9,56(sp)
    2418:	09010413          	add	s0,sp,144
    241c:	00050c93          	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    2420:	00000913          	li	s2,0
    2424:	00400993          	li	s3,4
    pid = fork();
    2428:	00005097          	auipc	ra,0x5
    242c:	c04080e7          	jalr	-1020(ra) # 702c <fork>
    2430:	00050493          	mv	s1,a0
    if(pid < 0){
    2434:	04054863          	bltz	a0,2484 <createdelete+0x9c>
    if(pid == 0){
    2438:	06050663          	beqz	a0,24a4 <createdelete+0xbc>
  for(pi = 0; pi < NCHILD; pi++){
    243c:	0019091b          	addw	s2,s2,1
    2440:	ff3914e3          	bne	s2,s3,2428 <createdelete+0x40>
    2444:	00400493          	li	s1,4
    wait(&xstatus);
    2448:	f7c40513          	add	a0,s0,-132
    244c:	00005097          	auipc	ra,0x5
    2450:	bf8080e7          	jalr	-1032(ra) # 7044 <wait>
    if(xstatus != 0)
    2454:	f7c42903          	lw	s2,-132(s0)
    2458:	10091463          	bnez	s2,2560 <createdelete+0x178>
  for(pi = 0; pi < NCHILD; pi++){
    245c:	fff4849b          	addw	s1,s1,-1
    2460:	fe0494e3          	bnez	s1,2448 <createdelete+0x60>
  name[0] = name[1] = name[2] = 0;
    2464:	f8040123          	sb	zero,-126(s0)
    2468:	03000993          	li	s3,48
    246c:	fff00a13          	li	s4,-1
    2470:	07000c13          	li	s8,112
      } else if((i >= 1 && i < N/2) && fd >= 0){
    2474:	00800b13          	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
    2478:	00900b93          	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
    247c:	07400a93          	li	s5,116
    2480:	1980006f          	j	2618 <createdelete+0x230>
      printf("fork failed\n", s);
    2484:	000c8593          	mv	a1,s9
    2488:	00006517          	auipc	a0,0x6
    248c:	fa050513          	add	a0,a0,-96 # 8428 <malloc+0xe10>
    2490:	00005097          	auipc	ra,0x5
    2494:	084080e7          	jalr	132(ra) # 7514 <printf>
      exit(1);
    2498:	00100513          	li	a0,1
    249c:	00005097          	auipc	ra,0x5
    24a0:	b9c080e7          	jalr	-1124(ra) # 7038 <exit>
      name[0] = 'p' + pi;
    24a4:	0709091b          	addw	s2,s2,112
    24a8:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    24ac:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    24b0:	01400913          	li	s2,20
    24b4:	02c0006f          	j	24e0 <createdelete+0xf8>
          printf("%s: create failed\n", s);
    24b8:	000c8593          	mv	a1,s9
    24bc:	00006517          	auipc	a0,0x6
    24c0:	bfc50513          	add	a0,a0,-1028 # 80b8 <malloc+0xaa0>
    24c4:	00005097          	auipc	ra,0x5
    24c8:	050080e7          	jalr	80(ra) # 7514 <printf>
          exit(1);
    24cc:	00100513          	li	a0,1
    24d0:	00005097          	auipc	ra,0x5
    24d4:	b68080e7          	jalr	-1176(ra) # 7038 <exit>
      for(i = 0; i < N; i++){
    24d8:	0014849b          	addw	s1,s1,1
    24dc:	07248c63          	beq	s1,s2,2554 <createdelete+0x16c>
        name[1] = '0' + i;
    24e0:	0304879b          	addw	a5,s1,48
    24e4:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    24e8:	20200593          	li	a1,514
    24ec:	f8040513          	add	a0,s0,-128
    24f0:	00005097          	auipc	ra,0x5
    24f4:	ba8080e7          	jalr	-1112(ra) # 7098 <open>
        if(fd < 0){
    24f8:	fc0540e3          	bltz	a0,24b8 <createdelete+0xd0>
        close(fd);
    24fc:	00005097          	auipc	ra,0x5
    2500:	b78080e7          	jalr	-1160(ra) # 7074 <close>
        if(i > 0 && (i % 2 ) == 0){
    2504:	fc905ae3          	blez	s1,24d8 <createdelete+0xf0>
    2508:	0014f793          	and	a5,s1,1
    250c:	fc0796e3          	bnez	a5,24d8 <createdelete+0xf0>
          name[1] = '0' + (i / 2);
    2510:	01f4d79b          	srlw	a5,s1,0x1f
    2514:	009787bb          	addw	a5,a5,s1
    2518:	4017d79b          	sraw	a5,a5,0x1
    251c:	0307879b          	addw	a5,a5,48
    2520:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    2524:	f8040513          	add	a0,s0,-128
    2528:	00005097          	auipc	ra,0x5
    252c:	b88080e7          	jalr	-1144(ra) # 70b0 <unlink>
    2530:	fa0554e3          	bgez	a0,24d8 <createdelete+0xf0>
            printf("%s: unlink failed\n", s);
    2534:	000c8593          	mv	a1,s9
    2538:	00006517          	auipc	a0,0x6
    253c:	cd850513          	add	a0,a0,-808 # 8210 <malloc+0xbf8>
    2540:	00005097          	auipc	ra,0x5
    2544:	fd4080e7          	jalr	-44(ra) # 7514 <printf>
            exit(1);
    2548:	00100513          	li	a0,1
    254c:	00005097          	auipc	ra,0x5
    2550:	aec080e7          	jalr	-1300(ra) # 7038 <exit>
      exit(0);
    2554:	00000513          	li	a0,0
    2558:	00005097          	auipc	ra,0x5
    255c:	ae0080e7          	jalr	-1312(ra) # 7038 <exit>
      exit(1);
    2560:	00100513          	li	a0,1
    2564:	00005097          	auipc	ra,0x5
    2568:	ad4080e7          	jalr	-1324(ra) # 7038 <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    256c:	f8040613          	add	a2,s0,-128
    2570:	000c8593          	mv	a1,s9
    2574:	00006517          	auipc	a0,0x6
    2578:	cb450513          	add	a0,a0,-844 # 8228 <malloc+0xc10>
    257c:	00005097          	auipc	ra,0x5
    2580:	f98080e7          	jalr	-104(ra) # 7514 <printf>
        exit(1);
    2584:	00100513          	li	a0,1
    2588:	00005097          	auipc	ra,0x5
    258c:	ab0080e7          	jalr	-1360(ra) # 7038 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    2590:	054b7463          	bgeu	s6,s4,25d8 <createdelete+0x1f0>
      if(fd >= 0)
    2594:	02055c63          	bgez	a0,25cc <createdelete+0x1e4>
    for(pi = 0; pi < NCHILD; pi++){
    2598:	0014849b          	addw	s1,s1,1
    259c:	0ff4f493          	zext.b	s1,s1
    25a0:	07548063          	beq	s1,s5,2600 <createdelete+0x218>
      name[0] = 'p' + pi;
    25a4:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    25a8:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    25ac:	00000593          	li	a1,0
    25b0:	f8040513          	add	a0,s0,-128
    25b4:	00005097          	auipc	ra,0x5
    25b8:	ae4080e7          	jalr	-1308(ra) # 7098 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    25bc:	00090463          	beqz	s2,25c4 <createdelete+0x1dc>
    25c0:	fd2bd8e3          	bge	s7,s2,2590 <createdelete+0x1a8>
    25c4:	fa0544e3          	bltz	a0,256c <createdelete+0x184>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    25c8:	014b7a63          	bgeu	s6,s4,25dc <createdelete+0x1f4>
        close(fd);
    25cc:	00005097          	auipc	ra,0x5
    25d0:	aa8080e7          	jalr	-1368(ra) # 7074 <close>
    25d4:	fc5ff06f          	j	2598 <createdelete+0x1b0>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    25d8:	fc0540e3          	bltz	a0,2598 <createdelete+0x1b0>
        printf("%s: oops createdelete %s did exist\n", s, name);
    25dc:	f8040613          	add	a2,s0,-128
    25e0:	000c8593          	mv	a1,s9
    25e4:	00006517          	auipc	a0,0x6
    25e8:	c6c50513          	add	a0,a0,-916 # 8250 <malloc+0xc38>
    25ec:	00005097          	auipc	ra,0x5
    25f0:	f28080e7          	jalr	-216(ra) # 7514 <printf>
        exit(1);
    25f4:	00100513          	li	a0,1
    25f8:	00005097          	auipc	ra,0x5
    25fc:	a40080e7          	jalr	-1472(ra) # 7038 <exit>
  for(i = 0; i < N; i++){
    2600:	0019091b          	addw	s2,s2,1
    2604:	001a0a1b          	addw	s4,s4,1
    2608:	0019899b          	addw	s3,s3,1 # 3001 <copyinstr3+0x121>
    260c:	0ff9f993          	zext.b	s3,s3
    2610:	01400793          	li	a5,20
    2614:	04f90263          	beq	s2,a5,2658 <createdelete+0x270>
    for(pi = 0; pi < NCHILD; pi++){
    2618:	000c0493          	mv	s1,s8
    261c:	f89ff06f          	j	25a4 <createdelete+0x1bc>
  for(i = 0; i < N; i++){
    2620:	0019091b          	addw	s2,s2,1
    2624:	0ff97913          	zext.b	s2,s2
    2628:	0019899b          	addw	s3,s3,1
    262c:	0ff9f993          	zext.b	s3,s3
    2630:	03490e63          	beq	s2,s4,266c <createdelete+0x284>
  name[0] = name[1] = name[2] = 0;
    2634:	000a8493          	mv	s1,s5
      name[0] = 'p' + i;
    2638:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    263c:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    2640:	f8040513          	add	a0,s0,-128
    2644:	00005097          	auipc	ra,0x5
    2648:	a6c080e7          	jalr	-1428(ra) # 70b0 <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    264c:	fff4849b          	addw	s1,s1,-1
    2650:	fe0494e3          	bnez	s1,2638 <createdelete+0x250>
    2654:	fcdff06f          	j	2620 <createdelete+0x238>
    2658:	03000993          	li	s3,48
    265c:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    2660:	00400a93          	li	s5,4
  for(i = 0; i < N; i++){
    2664:	08400a13          	li	s4,132
    2668:	fcdff06f          	j	2634 <createdelete+0x24c>
}
    266c:	08813083          	ld	ra,136(sp)
    2670:	08013403          	ld	s0,128(sp)
    2674:	07813483          	ld	s1,120(sp)
    2678:	07013903          	ld	s2,112(sp)
    267c:	06813983          	ld	s3,104(sp)
    2680:	06013a03          	ld	s4,96(sp)
    2684:	05813a83          	ld	s5,88(sp)
    2688:	05013b03          	ld	s6,80(sp)
    268c:	04813b83          	ld	s7,72(sp)
    2690:	04013c03          	ld	s8,64(sp)
    2694:	03813c83          	ld	s9,56(sp)
    2698:	09010113          	add	sp,sp,144
    269c:	00008067          	ret

00000000000026a0 <linkunlink>:
{
    26a0:	fa010113          	add	sp,sp,-96
    26a4:	04113c23          	sd	ra,88(sp)
    26a8:	04813823          	sd	s0,80(sp)
    26ac:	04913423          	sd	s1,72(sp)
    26b0:	05213023          	sd	s2,64(sp)
    26b4:	03313c23          	sd	s3,56(sp)
    26b8:	03413823          	sd	s4,48(sp)
    26bc:	03513423          	sd	s5,40(sp)
    26c0:	03613023          	sd	s6,32(sp)
    26c4:	01713c23          	sd	s7,24(sp)
    26c8:	01813823          	sd	s8,16(sp)
    26cc:	01913423          	sd	s9,8(sp)
    26d0:	06010413          	add	s0,sp,96
    26d4:	00050493          	mv	s1,a0
  unlink("x");
    26d8:	00005517          	auipc	a0,0x5
    26dc:	13050513          	add	a0,a0,304 # 7808 <malloc+0x1f0>
    26e0:	00005097          	auipc	ra,0x5
    26e4:	9d0080e7          	jalr	-1584(ra) # 70b0 <unlink>
  pid = fork();
    26e8:	00005097          	auipc	ra,0x5
    26ec:	944080e7          	jalr	-1724(ra) # 702c <fork>
  if(pid < 0){
    26f0:	04054263          	bltz	a0,2734 <linkunlink+0x94>
    26f4:	00050c13          	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    26f8:	06100c93          	li	s9,97
    26fc:	00050463          	beqz	a0,2704 <linkunlink+0x64>
    2700:	00100c93          	li	s9,1
    2704:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    2708:	41c659b7          	lui	s3,0x41c65
    270c:	e6d9899b          	addw	s3,s3,-403 # 41c64e6d <base+0x41c541f5>
    2710:	00003937          	lui	s2,0x3
    2714:	0399091b          	addw	s2,s2,57 # 3039 <copyinstr3+0x159>
    if((x % 3) == 0){
    2718:	00300a13          	li	s4,3
    } else if((x % 3) == 1){
    271c:	00100b13          	li	s6,1
      unlink("x");
    2720:	00005a97          	auipc	s5,0x5
    2724:	0e8a8a93          	add	s5,s5,232 # 7808 <malloc+0x1f0>
      link("cat", "x");
    2728:	00006b97          	auipc	s7,0x6
    272c:	b50b8b93          	add	s7,s7,-1200 # 8278 <malloc+0xc60>
    2730:	0440006f          	j	2774 <linkunlink+0xd4>
    printf("%s: fork failed\n", s);
    2734:	00048593          	mv	a1,s1
    2738:	00006517          	auipc	a0,0x6
    273c:	8e850513          	add	a0,a0,-1816 # 8020 <malloc+0xa08>
    2740:	00005097          	auipc	ra,0x5
    2744:	dd4080e7          	jalr	-556(ra) # 7514 <printf>
    exit(1);
    2748:	00100513          	li	a0,1
    274c:	00005097          	auipc	ra,0x5
    2750:	8ec080e7          	jalr	-1812(ra) # 7038 <exit>
      close(open("x", O_RDWR | O_CREATE));
    2754:	20200593          	li	a1,514
    2758:	000a8513          	mv	a0,s5
    275c:	00005097          	auipc	ra,0x5
    2760:	93c080e7          	jalr	-1732(ra) # 7098 <open>
    2764:	00005097          	auipc	ra,0x5
    2768:	910080e7          	jalr	-1776(ra) # 7074 <close>
  for(i = 0; i < 100; i++){
    276c:	fff4849b          	addw	s1,s1,-1
    2770:	04048063          	beqz	s1,27b0 <linkunlink+0x110>
    x = x * 1103515245 + 12345;
    2774:	033c87bb          	mulw	a5,s9,s3
    2778:	012787bb          	addw	a5,a5,s2
    277c:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    2780:	0347f7bb          	remuw	a5,a5,s4
    2784:	fc0788e3          	beqz	a5,2754 <linkunlink+0xb4>
    } else if((x % 3) == 1){
    2788:	01678a63          	beq	a5,s6,279c <linkunlink+0xfc>
      unlink("x");
    278c:	000a8513          	mv	a0,s5
    2790:	00005097          	auipc	ra,0x5
    2794:	920080e7          	jalr	-1760(ra) # 70b0 <unlink>
    2798:	fd5ff06f          	j	276c <linkunlink+0xcc>
      link("cat", "x");
    279c:	000a8593          	mv	a1,s5
    27a0:	000b8513          	mv	a0,s7
    27a4:	00005097          	auipc	ra,0x5
    27a8:	924080e7          	jalr	-1756(ra) # 70c8 <link>
    27ac:	fc1ff06f          	j	276c <linkunlink+0xcc>
  if(pid)
    27b0:	040c0263          	beqz	s8,27f4 <linkunlink+0x154>
    wait(0);
    27b4:	00000513          	li	a0,0
    27b8:	00005097          	auipc	ra,0x5
    27bc:	88c080e7          	jalr	-1908(ra) # 7044 <wait>
}
    27c0:	05813083          	ld	ra,88(sp)
    27c4:	05013403          	ld	s0,80(sp)
    27c8:	04813483          	ld	s1,72(sp)
    27cc:	04013903          	ld	s2,64(sp)
    27d0:	03813983          	ld	s3,56(sp)
    27d4:	03013a03          	ld	s4,48(sp)
    27d8:	02813a83          	ld	s5,40(sp)
    27dc:	02013b03          	ld	s6,32(sp)
    27e0:	01813b83          	ld	s7,24(sp)
    27e4:	01013c03          	ld	s8,16(sp)
    27e8:	00813c83          	ld	s9,8(sp)
    27ec:	06010113          	add	sp,sp,96
    27f0:	00008067          	ret
    exit(0);
    27f4:	00000513          	li	a0,0
    27f8:	00005097          	auipc	ra,0x5
    27fc:	840080e7          	jalr	-1984(ra) # 7038 <exit>

0000000000002800 <forktest>:
{
    2800:	fd010113          	add	sp,sp,-48
    2804:	02113423          	sd	ra,40(sp)
    2808:	02813023          	sd	s0,32(sp)
    280c:	00913c23          	sd	s1,24(sp)
    2810:	01213823          	sd	s2,16(sp)
    2814:	01313423          	sd	s3,8(sp)
    2818:	03010413          	add	s0,sp,48
    281c:	00050993          	mv	s3,a0
  for(n=0; n<N; n++){
    2820:	00000493          	li	s1,0
    2824:	3e800913          	li	s2,1000
    pid = fork();
    2828:	00005097          	auipc	ra,0x5
    282c:	804080e7          	jalr	-2044(ra) # 702c <fork>
    if(pid < 0)
    2830:	02054c63          	bltz	a0,2868 <forktest+0x68>
    if(pid == 0)
    2834:	02050663          	beqz	a0,2860 <forktest+0x60>
  for(n=0; n<N; n++){
    2838:	0014849b          	addw	s1,s1,1
    283c:	ff2496e3          	bne	s1,s2,2828 <forktest+0x28>
    printf("%s: fork claimed to work 1000 times!\n", s);
    2840:	00098593          	mv	a1,s3
    2844:	00006517          	auipc	a0,0x6
    2848:	a5450513          	add	a0,a0,-1452 # 8298 <malloc+0xc80>
    284c:	00005097          	auipc	ra,0x5
    2850:	cc8080e7          	jalr	-824(ra) # 7514 <printf>
    exit(1);
    2854:	00100513          	li	a0,1
    2858:	00004097          	auipc	ra,0x4
    285c:	7e0080e7          	jalr	2016(ra) # 7038 <exit>
      exit(0);
    2860:	00004097          	auipc	ra,0x4
    2864:	7d8080e7          	jalr	2008(ra) # 7038 <exit>
  if (n == 0) {
    2868:	04048c63          	beqz	s1,28c0 <forktest+0xc0>
  if(n == N){
    286c:	3e800793          	li	a5,1000
    2870:	fcf488e3          	beq	s1,a5,2840 <forktest+0x40>
  for(; n > 0; n--){
    2874:	00905e63          	blez	s1,2890 <forktest+0x90>
    if(wait(0) < 0){
    2878:	00000513          	li	a0,0
    287c:	00004097          	auipc	ra,0x4
    2880:	7c8080e7          	jalr	1992(ra) # 7044 <wait>
    2884:	04054e63          	bltz	a0,28e0 <forktest+0xe0>
  for(; n > 0; n--){
    2888:	fff4849b          	addw	s1,s1,-1
    288c:	fe0496e3          	bnez	s1,2878 <forktest+0x78>
  if(wait(0) != -1){
    2890:	00000513          	li	a0,0
    2894:	00004097          	auipc	ra,0x4
    2898:	7b0080e7          	jalr	1968(ra) # 7044 <wait>
    289c:	fff00793          	li	a5,-1
    28a0:	06f51063          	bne	a0,a5,2900 <forktest+0x100>
}
    28a4:	02813083          	ld	ra,40(sp)
    28a8:	02013403          	ld	s0,32(sp)
    28ac:	01813483          	ld	s1,24(sp)
    28b0:	01013903          	ld	s2,16(sp)
    28b4:	00813983          	ld	s3,8(sp)
    28b8:	03010113          	add	sp,sp,48
    28bc:	00008067          	ret
    printf("%s: no fork at all!\n", s);
    28c0:	00098593          	mv	a1,s3
    28c4:	00006517          	auipc	a0,0x6
    28c8:	9bc50513          	add	a0,a0,-1604 # 8280 <malloc+0xc68>
    28cc:	00005097          	auipc	ra,0x5
    28d0:	c48080e7          	jalr	-952(ra) # 7514 <printf>
    exit(1);
    28d4:	00100513          	li	a0,1
    28d8:	00004097          	auipc	ra,0x4
    28dc:	760080e7          	jalr	1888(ra) # 7038 <exit>
      printf("%s: wait stopped early\n", s);
    28e0:	00098593          	mv	a1,s3
    28e4:	00006517          	auipc	a0,0x6
    28e8:	9dc50513          	add	a0,a0,-1572 # 82c0 <malloc+0xca8>
    28ec:	00005097          	auipc	ra,0x5
    28f0:	c28080e7          	jalr	-984(ra) # 7514 <printf>
      exit(1);
    28f4:	00100513          	li	a0,1
    28f8:	00004097          	auipc	ra,0x4
    28fc:	740080e7          	jalr	1856(ra) # 7038 <exit>
    printf("%s: wait got too many\n", s);
    2900:	00098593          	mv	a1,s3
    2904:	00006517          	auipc	a0,0x6
    2908:	9d450513          	add	a0,a0,-1580 # 82d8 <malloc+0xcc0>
    290c:	00005097          	auipc	ra,0x5
    2910:	c08080e7          	jalr	-1016(ra) # 7514 <printf>
    exit(1);
    2914:	00100513          	li	a0,1
    2918:	00004097          	auipc	ra,0x4
    291c:	720080e7          	jalr	1824(ra) # 7038 <exit>

0000000000002920 <kernmem>:
{
    2920:	fb010113          	add	sp,sp,-80
    2924:	04113423          	sd	ra,72(sp)
    2928:	04813023          	sd	s0,64(sp)
    292c:	02913c23          	sd	s1,56(sp)
    2930:	03213823          	sd	s2,48(sp)
    2934:	03313423          	sd	s3,40(sp)
    2938:	03413023          	sd	s4,32(sp)
    293c:	01513c23          	sd	s5,24(sp)
    2940:	05010413          	add	s0,sp,80
    2944:	00050a13          	mv	s4,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2948:	00100493          	li	s1,1
    294c:	01f49493          	sll	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    2950:	fff00a93          	li	s5,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2954:	0000c9b7          	lui	s3,0xc
    2958:	35098993          	add	s3,s3,848 # c350 <uninit+0xde8>
    295c:	1003d937          	lui	s2,0x1003d
    2960:	00391913          	sll	s2,s2,0x3
    2964:	48090913          	add	s2,s2,1152 # 1003d480 <base+0x1002c808>
    pid = fork();
    2968:	00004097          	auipc	ra,0x4
    296c:	6c4080e7          	jalr	1732(ra) # 702c <fork>
    if(pid < 0){
    2970:	04054463          	bltz	a0,29b8 <kernmem+0x98>
    if(pid == 0){
    2974:	06050263          	beqz	a0,29d8 <kernmem+0xb8>
    wait(&xstatus);
    2978:	fbc40513          	add	a0,s0,-68
    297c:	00004097          	auipc	ra,0x4
    2980:	6c8080e7          	jalr	1736(ra) # 7044 <wait>
    if(xstatus != -1)  // did kernel kill child?
    2984:	fbc42783          	lw	a5,-68(s0)
    2988:	07579c63          	bne	a5,s5,2a00 <kernmem+0xe0>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    298c:	013484b3          	add	s1,s1,s3
    2990:	fd249ce3          	bne	s1,s2,2968 <kernmem+0x48>
}
    2994:	04813083          	ld	ra,72(sp)
    2998:	04013403          	ld	s0,64(sp)
    299c:	03813483          	ld	s1,56(sp)
    29a0:	03013903          	ld	s2,48(sp)
    29a4:	02813983          	ld	s3,40(sp)
    29a8:	02013a03          	ld	s4,32(sp)
    29ac:	01813a83          	ld	s5,24(sp)
    29b0:	05010113          	add	sp,sp,80
    29b4:	00008067          	ret
      printf("%s: fork failed\n", s);
    29b8:	000a0593          	mv	a1,s4
    29bc:	00005517          	auipc	a0,0x5
    29c0:	66450513          	add	a0,a0,1636 # 8020 <malloc+0xa08>
    29c4:	00005097          	auipc	ra,0x5
    29c8:	b50080e7          	jalr	-1200(ra) # 7514 <printf>
      exit(1);
    29cc:	00100513          	li	a0,1
    29d0:	00004097          	auipc	ra,0x4
    29d4:	668080e7          	jalr	1640(ra) # 7038 <exit>
      printf("%s: oops could read %x = %x\n", s, a, *a);
    29d8:	0004c683          	lbu	a3,0(s1)
    29dc:	00048613          	mv	a2,s1
    29e0:	000a0593          	mv	a1,s4
    29e4:	00006517          	auipc	a0,0x6
    29e8:	90c50513          	add	a0,a0,-1780 # 82f0 <malloc+0xcd8>
    29ec:	00005097          	auipc	ra,0x5
    29f0:	b28080e7          	jalr	-1240(ra) # 7514 <printf>
      exit(1);
    29f4:	00100513          	li	a0,1
    29f8:	00004097          	auipc	ra,0x4
    29fc:	640080e7          	jalr	1600(ra) # 7038 <exit>
      exit(1);
    2a00:	00100513          	li	a0,1
    2a04:	00004097          	auipc	ra,0x4
    2a08:	634080e7          	jalr	1588(ra) # 7038 <exit>

0000000000002a0c <MAXVAplus>:
{
    2a0c:	fd010113          	add	sp,sp,-48
    2a10:	02113423          	sd	ra,40(sp)
    2a14:	02813023          	sd	s0,32(sp)
    2a18:	00913c23          	sd	s1,24(sp)
    2a1c:	01213823          	sd	s2,16(sp)
    2a20:	03010413          	add	s0,sp,48
  volatile uint64 a = MAXVA;
    2a24:	00100793          	li	a5,1
    2a28:	02679793          	sll	a5,a5,0x26
    2a2c:	fcf43c23          	sd	a5,-40(s0)
  for( ; a != 0; a <<= 1){
    2a30:	fd843783          	ld	a5,-40(s0)
    2a34:	04078263          	beqz	a5,2a78 <MAXVAplus+0x6c>
    2a38:	00050913          	mv	s2,a0
    if(xstatus != -1)  // did kernel kill child?
    2a3c:	fff00493          	li	s1,-1
    pid = fork();
    2a40:	00004097          	auipc	ra,0x4
    2a44:	5ec080e7          	jalr	1516(ra) # 702c <fork>
    if(pid < 0){
    2a48:	04054463          	bltz	a0,2a90 <MAXVAplus+0x84>
    if(pid == 0){
    2a4c:	06050263          	beqz	a0,2ab0 <MAXVAplus+0xa4>
    wait(&xstatus);
    2a50:	fd440513          	add	a0,s0,-44
    2a54:	00004097          	auipc	ra,0x4
    2a58:	5f0080e7          	jalr	1520(ra) # 7044 <wait>
    if(xstatus != -1)  // did kernel kill child?
    2a5c:	fd442783          	lw	a5,-44(s0)
    2a60:	08979063          	bne	a5,s1,2ae0 <MAXVAplus+0xd4>
  for( ; a != 0; a <<= 1){
    2a64:	fd843783          	ld	a5,-40(s0)
    2a68:	00179793          	sll	a5,a5,0x1
    2a6c:	fcf43c23          	sd	a5,-40(s0)
    2a70:	fd843783          	ld	a5,-40(s0)
    2a74:	fc0796e3          	bnez	a5,2a40 <MAXVAplus+0x34>
}
    2a78:	02813083          	ld	ra,40(sp)
    2a7c:	02013403          	ld	s0,32(sp)
    2a80:	01813483          	ld	s1,24(sp)
    2a84:	01013903          	ld	s2,16(sp)
    2a88:	03010113          	add	sp,sp,48
    2a8c:	00008067          	ret
      printf("%s: fork failed\n", s);
    2a90:	00090593          	mv	a1,s2
    2a94:	00005517          	auipc	a0,0x5
    2a98:	58c50513          	add	a0,a0,1420 # 8020 <malloc+0xa08>
    2a9c:	00005097          	auipc	ra,0x5
    2aa0:	a78080e7          	jalr	-1416(ra) # 7514 <printf>
      exit(1);
    2aa4:	00100513          	li	a0,1
    2aa8:	00004097          	auipc	ra,0x4
    2aac:	590080e7          	jalr	1424(ra) # 7038 <exit>
      *(char*)a = 99;
    2ab0:	fd843783          	ld	a5,-40(s0)
    2ab4:	06300713          	li	a4,99
    2ab8:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %x\n", s, a);
    2abc:	fd843603          	ld	a2,-40(s0)
    2ac0:	00090593          	mv	a1,s2
    2ac4:	00006517          	auipc	a0,0x6
    2ac8:	84c50513          	add	a0,a0,-1972 # 8310 <malloc+0xcf8>
    2acc:	00005097          	auipc	ra,0x5
    2ad0:	a48080e7          	jalr	-1464(ra) # 7514 <printf>
      exit(1);
    2ad4:	00100513          	li	a0,1
    2ad8:	00004097          	auipc	ra,0x4
    2adc:	560080e7          	jalr	1376(ra) # 7038 <exit>
      exit(1);
    2ae0:	00100513          	li	a0,1
    2ae4:	00004097          	auipc	ra,0x4
    2ae8:	554080e7          	jalr	1364(ra) # 7038 <exit>

0000000000002aec <bigargtest>:
{
    2aec:	fd010113          	add	sp,sp,-48
    2af0:	02113423          	sd	ra,40(sp)
    2af4:	02813023          	sd	s0,32(sp)
    2af8:	00913c23          	sd	s1,24(sp)
    2afc:	03010413          	add	s0,sp,48
    2b00:	00050493          	mv	s1,a0
  unlink("bigarg-ok");
    2b04:	00006517          	auipc	a0,0x6
    2b08:	82450513          	add	a0,a0,-2012 # 8328 <malloc+0xd10>
    2b0c:	00004097          	auipc	ra,0x4
    2b10:	5a4080e7          	jalr	1444(ra) # 70b0 <unlink>
  pid = fork();
    2b14:	00004097          	auipc	ra,0x4
    2b18:	518080e7          	jalr	1304(ra) # 702c <fork>
  if(pid == 0){
    2b1c:	04050863          	beqz	a0,2b6c <bigargtest+0x80>
  } else if(pid < 0){
    2b20:	0a054a63          	bltz	a0,2bd4 <bigargtest+0xe8>
  wait(&xstatus);
    2b24:	fdc40513          	add	a0,s0,-36
    2b28:	00004097          	auipc	ra,0x4
    2b2c:	51c080e7          	jalr	1308(ra) # 7044 <wait>
  if(xstatus != 0)
    2b30:	fdc42503          	lw	a0,-36(s0)
    2b34:	0c051063          	bnez	a0,2bf4 <bigargtest+0x108>
  fd = open("bigarg-ok", 0);
    2b38:	00000593          	li	a1,0
    2b3c:	00005517          	auipc	a0,0x5
    2b40:	7ec50513          	add	a0,a0,2028 # 8328 <malloc+0xd10>
    2b44:	00004097          	auipc	ra,0x4
    2b48:	554080e7          	jalr	1364(ra) # 7098 <open>
  if(fd < 0){
    2b4c:	0a054863          	bltz	a0,2bfc <bigargtest+0x110>
  close(fd);
    2b50:	00004097          	auipc	ra,0x4
    2b54:	524080e7          	jalr	1316(ra) # 7074 <close>
}
    2b58:	02813083          	ld	ra,40(sp)
    2b5c:	02013403          	ld	s0,32(sp)
    2b60:	01813483          	ld	s1,24(sp)
    2b64:	03010113          	add	sp,sp,48
    2b68:	00008067          	ret
    2b6c:	00008797          	auipc	a5,0x8
    2b70:	8f478793          	add	a5,a5,-1804 # a460 <args.1>
    2b74:	00008697          	auipc	a3,0x8
    2b78:	9e468693          	add	a3,a3,-1564 # a558 <args.1+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    2b7c:	00005717          	auipc	a4,0x5
    2b80:	7bc70713          	add	a4,a4,1980 # 8338 <malloc+0xd20>
    2b84:	00e7b023          	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    2b88:	00878793          	add	a5,a5,8
    2b8c:	fed79ce3          	bne	a5,a3,2b84 <bigargtest+0x98>
    args[MAXARG-1] = 0;
    2b90:	00008597          	auipc	a1,0x8
    2b94:	8d058593          	add	a1,a1,-1840 # a460 <args.1>
    2b98:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    2b9c:	00005517          	auipc	a0,0x5
    2ba0:	bfc50513          	add	a0,a0,-1028 # 7798 <malloc+0x180>
    2ba4:	00004097          	auipc	ra,0x4
    2ba8:	4e8080e7          	jalr	1256(ra) # 708c <exec>
    fd = open("bigarg-ok", O_CREATE);
    2bac:	20000593          	li	a1,512
    2bb0:	00005517          	auipc	a0,0x5
    2bb4:	77850513          	add	a0,a0,1912 # 8328 <malloc+0xd10>
    2bb8:	00004097          	auipc	ra,0x4
    2bbc:	4e0080e7          	jalr	1248(ra) # 7098 <open>
    close(fd);
    2bc0:	00004097          	auipc	ra,0x4
    2bc4:	4b4080e7          	jalr	1204(ra) # 7074 <close>
    exit(0);
    2bc8:	00000513          	li	a0,0
    2bcc:	00004097          	auipc	ra,0x4
    2bd0:	46c080e7          	jalr	1132(ra) # 7038 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    2bd4:	00048593          	mv	a1,s1
    2bd8:	00006517          	auipc	a0,0x6
    2bdc:	84050513          	add	a0,a0,-1984 # 8418 <malloc+0xe00>
    2be0:	00005097          	auipc	ra,0x5
    2be4:	934080e7          	jalr	-1740(ra) # 7514 <printf>
    exit(1);
    2be8:	00100513          	li	a0,1
    2bec:	00004097          	auipc	ra,0x4
    2bf0:	44c080e7          	jalr	1100(ra) # 7038 <exit>
    exit(xstatus);
    2bf4:	00004097          	auipc	ra,0x4
    2bf8:	444080e7          	jalr	1092(ra) # 7038 <exit>
    printf("%s: bigarg test failed!\n", s);
    2bfc:	00048593          	mv	a1,s1
    2c00:	00006517          	auipc	a0,0x6
    2c04:	83850513          	add	a0,a0,-1992 # 8438 <malloc+0xe20>
    2c08:	00005097          	auipc	ra,0x5
    2c0c:	90c080e7          	jalr	-1780(ra) # 7514 <printf>
    exit(1);
    2c10:	00100513          	li	a0,1
    2c14:	00004097          	auipc	ra,0x4
    2c18:	424080e7          	jalr	1060(ra) # 7038 <exit>

0000000000002c1c <stacktest>:
{
    2c1c:	fd010113          	add	sp,sp,-48
    2c20:	02113423          	sd	ra,40(sp)
    2c24:	02813023          	sd	s0,32(sp)
    2c28:	00913c23          	sd	s1,24(sp)
    2c2c:	03010413          	add	s0,sp,48
    2c30:	00050493          	mv	s1,a0
  pid = fork();
    2c34:	00004097          	auipc	ra,0x4
    2c38:	3f8080e7          	jalr	1016(ra) # 702c <fork>
  if(pid == 0) {
    2c3c:	02050463          	beqz	a0,2c64 <stacktest+0x48>
  } else if(pid < 0){
    2c40:	04054a63          	bltz	a0,2c94 <stacktest+0x78>
  wait(&xstatus);
    2c44:	fdc40513          	add	a0,s0,-36
    2c48:	00004097          	auipc	ra,0x4
    2c4c:	3fc080e7          	jalr	1020(ra) # 7044 <wait>
  if(xstatus == -1)  // kernel killed child?
    2c50:	fdc42503          	lw	a0,-36(s0)
    2c54:	fff00793          	li	a5,-1
    2c58:	04f50e63          	beq	a0,a5,2cb4 <stacktest+0x98>
    exit(xstatus);
    2c5c:	00004097          	auipc	ra,0x4
    2c60:	3dc080e7          	jalr	988(ra) # 7038 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    2c64:	00010713          	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", s, *sp);
    2c68:	fffff7b7          	lui	a5,0xfffff
    2c6c:	00e787b3          	add	a5,a5,a4
    2c70:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <base+0xfffffffffffee388>
    2c74:	00048593          	mv	a1,s1
    2c78:	00005517          	auipc	a0,0x5
    2c7c:	7e050513          	add	a0,a0,2016 # 8458 <malloc+0xe40>
    2c80:	00005097          	auipc	ra,0x5
    2c84:	894080e7          	jalr	-1900(ra) # 7514 <printf>
    exit(1);
    2c88:	00100513          	li	a0,1
    2c8c:	00004097          	auipc	ra,0x4
    2c90:	3ac080e7          	jalr	940(ra) # 7038 <exit>
    printf("%s: fork failed\n", s);
    2c94:	00048593          	mv	a1,s1
    2c98:	00005517          	auipc	a0,0x5
    2c9c:	38850513          	add	a0,a0,904 # 8020 <malloc+0xa08>
    2ca0:	00005097          	auipc	ra,0x5
    2ca4:	874080e7          	jalr	-1932(ra) # 7514 <printf>
    exit(1);
    2ca8:	00100513          	li	a0,1
    2cac:	00004097          	auipc	ra,0x4
    2cb0:	38c080e7          	jalr	908(ra) # 7038 <exit>
    exit(0);
    2cb4:	00000513          	li	a0,0
    2cb8:	00004097          	auipc	ra,0x4
    2cbc:	380080e7          	jalr	896(ra) # 7038 <exit>

0000000000002cc0 <textwrite>:
{
    2cc0:	fd010113          	add	sp,sp,-48
    2cc4:	02113423          	sd	ra,40(sp)
    2cc8:	02813023          	sd	s0,32(sp)
    2ccc:	00913c23          	sd	s1,24(sp)
    2cd0:	03010413          	add	s0,sp,48
    2cd4:	00050493          	mv	s1,a0
  pid = fork();
    2cd8:	00004097          	auipc	ra,0x4
    2cdc:	354080e7          	jalr	852(ra) # 702c <fork>
  if(pid == 0) {
    2ce0:	02050463          	beqz	a0,2d08 <textwrite+0x48>
  } else if(pid < 0){
    2ce4:	02054c63          	bltz	a0,2d1c <textwrite+0x5c>
  wait(&xstatus);
    2ce8:	fdc40513          	add	a0,s0,-36
    2cec:	00004097          	auipc	ra,0x4
    2cf0:	358080e7          	jalr	856(ra) # 7044 <wait>
  if(xstatus == -1)  // kernel killed child?
    2cf4:	fdc42503          	lw	a0,-36(s0)
    2cf8:	fff00793          	li	a5,-1
    2cfc:	04f50063          	beq	a0,a5,2d3c <textwrite+0x7c>
    exit(xstatus);
    2d00:	00004097          	auipc	ra,0x4
    2d04:	338080e7          	jalr	824(ra) # 7038 <exit>
    *addr = 10;
    2d08:	00a00793          	li	a5,10
    2d0c:	00f02023          	sw	a5,0(zero) # 0 <copyinstr1>
    exit(1);
    2d10:	00100513          	li	a0,1
    2d14:	00004097          	auipc	ra,0x4
    2d18:	324080e7          	jalr	804(ra) # 7038 <exit>
    printf("%s: fork failed\n", s);
    2d1c:	00048593          	mv	a1,s1
    2d20:	00005517          	auipc	a0,0x5
    2d24:	30050513          	add	a0,a0,768 # 8020 <malloc+0xa08>
    2d28:	00004097          	auipc	ra,0x4
    2d2c:	7ec080e7          	jalr	2028(ra) # 7514 <printf>
    exit(1);
    2d30:	00100513          	li	a0,1
    2d34:	00004097          	auipc	ra,0x4
    2d38:	304080e7          	jalr	772(ra) # 7038 <exit>
    exit(0);
    2d3c:	00000513          	li	a0,0
    2d40:	00004097          	auipc	ra,0x4
    2d44:	2f8080e7          	jalr	760(ra) # 7038 <exit>

0000000000002d48 <manywrites>:
{
    2d48:	fa010113          	add	sp,sp,-96
    2d4c:	04113c23          	sd	ra,88(sp)
    2d50:	04813823          	sd	s0,80(sp)
    2d54:	04913423          	sd	s1,72(sp)
    2d58:	05213023          	sd	s2,64(sp)
    2d5c:	03313c23          	sd	s3,56(sp)
    2d60:	03413823          	sd	s4,48(sp)
    2d64:	03513423          	sd	s5,40(sp)
    2d68:	03613023          	sd	s6,32(sp)
    2d6c:	01713c23          	sd	s7,24(sp)
    2d70:	06010413          	add	s0,sp,96
    2d74:	00050a93          	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    2d78:	00000993          	li	s3,0
    2d7c:	00400913          	li	s2,4
    int pid = fork();
    2d80:	00004097          	auipc	ra,0x4
    2d84:	2ac080e7          	jalr	684(ra) # 702c <fork>
    2d88:	00050493          	mv	s1,a0
    if(pid < 0){
    2d8c:	04054063          	bltz	a0,2dcc <manywrites+0x84>
    if(pid == 0){
    2d90:	04050c63          	beqz	a0,2de8 <manywrites+0xa0>
  for(int ci = 0; ci < nchildren; ci++){
    2d94:	0019899b          	addw	s3,s3,1
    2d98:	ff2994e3          	bne	s3,s2,2d80 <manywrites+0x38>
    2d9c:	00400493          	li	s1,4
    int st = 0;
    2da0:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    2da4:	fa840513          	add	a0,s0,-88
    2da8:	00004097          	auipc	ra,0x4
    2dac:	29c080e7          	jalr	668(ra) # 7044 <wait>
    if(st != 0)
    2db0:	fa842503          	lw	a0,-88(s0)
    2db4:	12051263          	bnez	a0,2ed8 <manywrites+0x190>
  for(int ci = 0; ci < nchildren; ci++){
    2db8:	fff4849b          	addw	s1,s1,-1
    2dbc:	fe0492e3          	bnez	s1,2da0 <manywrites+0x58>
  exit(0);
    2dc0:	00000513          	li	a0,0
    2dc4:	00004097          	auipc	ra,0x4
    2dc8:	274080e7          	jalr	628(ra) # 7038 <exit>
      printf("fork failed\n");
    2dcc:	00005517          	auipc	a0,0x5
    2dd0:	65c50513          	add	a0,a0,1628 # 8428 <malloc+0xe10>
    2dd4:	00004097          	auipc	ra,0x4
    2dd8:	740080e7          	jalr	1856(ra) # 7514 <printf>
      exit(1);
    2ddc:	00100513          	li	a0,1
    2de0:	00004097          	auipc	ra,0x4
    2de4:	258080e7          	jalr	600(ra) # 7038 <exit>
      name[0] = 'b';
    2de8:	06200793          	li	a5,98
    2dec:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    2df0:	0619879b          	addw	a5,s3,97
    2df4:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    2df8:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    2dfc:	fa840513          	add	a0,s0,-88
    2e00:	00004097          	auipc	ra,0x4
    2e04:	2b0080e7          	jalr	688(ra) # 70b0 <unlink>
    2e08:	01e00b93          	li	s7,30
          int cc = write(fd, buf, sz);
    2e0c:	0000bb17          	auipc	s6,0xb
    2e10:	e6cb0b13          	add	s6,s6,-404 # dc78 <buf>
        for(int i = 0; i < ci+1; i++){
    2e14:	00048a13          	mv	s4,s1
    2e18:	0409c463          	bltz	s3,2e60 <manywrites+0x118>
          int fd = open(name, O_CREATE | O_RDWR);
    2e1c:	20200593          	li	a1,514
    2e20:	fa840513          	add	a0,s0,-88
    2e24:	00004097          	auipc	ra,0x4
    2e28:	274080e7          	jalr	628(ra) # 7098 <open>
    2e2c:	00050913          	mv	s2,a0
          if(fd < 0){
    2e30:	04054e63          	bltz	a0,2e8c <manywrites+0x144>
          int cc = write(fd, buf, sz);
    2e34:	00003637          	lui	a2,0x3
    2e38:	000b0593          	mv	a1,s6
    2e3c:	00004097          	auipc	ra,0x4
    2e40:	22c080e7          	jalr	556(ra) # 7068 <write>
          if(cc != sz){
    2e44:	000037b7          	lui	a5,0x3
    2e48:	06f51463          	bne	a0,a5,2eb0 <manywrites+0x168>
          close(fd);
    2e4c:	00090513          	mv	a0,s2
    2e50:	00004097          	auipc	ra,0x4
    2e54:	224080e7          	jalr	548(ra) # 7074 <close>
        for(int i = 0; i < ci+1; i++){
    2e58:	001a0a1b          	addw	s4,s4,1
    2e5c:	fd49d0e3          	bge	s3,s4,2e1c <manywrites+0xd4>
        unlink(name);
    2e60:	fa840513          	add	a0,s0,-88
    2e64:	00004097          	auipc	ra,0x4
    2e68:	24c080e7          	jalr	588(ra) # 70b0 <unlink>
      for(int iters = 0; iters < howmany; iters++){
    2e6c:	fffb8b9b          	addw	s7,s7,-1
    2e70:	fa0b92e3          	bnez	s7,2e14 <manywrites+0xcc>
      unlink(name);
    2e74:	fa840513          	add	a0,s0,-88
    2e78:	00004097          	auipc	ra,0x4
    2e7c:	238080e7          	jalr	568(ra) # 70b0 <unlink>
      exit(0);
    2e80:	00000513          	li	a0,0
    2e84:	00004097          	auipc	ra,0x4
    2e88:	1b4080e7          	jalr	436(ra) # 7038 <exit>
            printf("%s: cannot create %s\n", s, name);
    2e8c:	fa840613          	add	a2,s0,-88
    2e90:	000a8593          	mv	a1,s5
    2e94:	00005517          	auipc	a0,0x5
    2e98:	5ec50513          	add	a0,a0,1516 # 8480 <malloc+0xe68>
    2e9c:	00004097          	auipc	ra,0x4
    2ea0:	678080e7          	jalr	1656(ra) # 7514 <printf>
            exit(1);
    2ea4:	00100513          	li	a0,1
    2ea8:	00004097          	auipc	ra,0x4
    2eac:	190080e7          	jalr	400(ra) # 7038 <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    2eb0:	00050693          	mv	a3,a0
    2eb4:	00003637          	lui	a2,0x3
    2eb8:	000a8593          	mv	a1,s5
    2ebc:	00005517          	auipc	a0,0x5
    2ec0:	9ac50513          	add	a0,a0,-1620 # 7868 <malloc+0x250>
    2ec4:	00004097          	auipc	ra,0x4
    2ec8:	650080e7          	jalr	1616(ra) # 7514 <printf>
            exit(1);
    2ecc:	00100513          	li	a0,1
    2ed0:	00004097          	auipc	ra,0x4
    2ed4:	168080e7          	jalr	360(ra) # 7038 <exit>
      exit(st);
    2ed8:	00004097          	auipc	ra,0x4
    2edc:	160080e7          	jalr	352(ra) # 7038 <exit>

0000000000002ee0 <copyinstr3>:
{
    2ee0:	fd010113          	add	sp,sp,-48
    2ee4:	02113423          	sd	ra,40(sp)
    2ee8:	02813023          	sd	s0,32(sp)
    2eec:	00913c23          	sd	s1,24(sp)
    2ef0:	03010413          	add	s0,sp,48
  sbrk(8192);
    2ef4:	00002537          	lui	a0,0x2
    2ef8:	00004097          	auipc	ra,0x4
    2efc:	20c080e7          	jalr	524(ra) # 7104 <sbrk>
  uint64 top = (uint64) sbrk(0);
    2f00:	00000513          	li	a0,0
    2f04:	00004097          	auipc	ra,0x4
    2f08:	200080e7          	jalr	512(ra) # 7104 <sbrk>
  if((top % PGSIZE) != 0){
    2f0c:	03451793          	sll	a5,a0,0x34
    2f10:	0a079263          	bnez	a5,2fb4 <copyinstr3+0xd4>
  top = (uint64) sbrk(0);
    2f14:	00000513          	li	a0,0
    2f18:	00004097          	auipc	ra,0x4
    2f1c:	1ec080e7          	jalr	492(ra) # 7104 <sbrk>
  if(top % PGSIZE){
    2f20:	03451793          	sll	a5,a0,0x34
    2f24:	0a079463          	bnez	a5,2fcc <copyinstr3+0xec>
  char *b = (char *) (top - 1);
    2f28:	fff50493          	add	s1,a0,-1 # 1fff <pipe1+0x17b>
  *b = 'x';
    2f2c:	07800793          	li	a5,120
    2f30:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    2f34:	00048513          	mv	a0,s1
    2f38:	00004097          	auipc	ra,0x4
    2f3c:	178080e7          	jalr	376(ra) # 70b0 <unlink>
  if(ret != -1){
    2f40:	fff00793          	li	a5,-1
    2f44:	0af51263          	bne	a0,a5,2fe8 <copyinstr3+0x108>
  int fd = open(b, O_CREATE | O_WRONLY);
    2f48:	20100593          	li	a1,513
    2f4c:	00048513          	mv	a0,s1
    2f50:	00004097          	auipc	ra,0x4
    2f54:	148080e7          	jalr	328(ra) # 7098 <open>
  if(fd != -1){
    2f58:	fff00793          	li	a5,-1
    2f5c:	0af51863          	bne	a0,a5,300c <copyinstr3+0x12c>
  ret = link(b, b);
    2f60:	00048593          	mv	a1,s1
    2f64:	00048513          	mv	a0,s1
    2f68:	00004097          	auipc	ra,0x4
    2f6c:	160080e7          	jalr	352(ra) # 70c8 <link>
  if(ret != -1){
    2f70:	fff00793          	li	a5,-1
    2f74:	0af51e63          	bne	a0,a5,3030 <copyinstr3+0x150>
  char *args[] = { "xx", 0 };
    2f78:	00006797          	auipc	a5,0x6
    2f7c:	20078793          	add	a5,a5,512 # 9178 <malloc+0x1b60>
    2f80:	fcf43823          	sd	a5,-48(s0)
    2f84:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    2f88:	fd040593          	add	a1,s0,-48
    2f8c:	00048513          	mv	a0,s1
    2f90:	00004097          	auipc	ra,0x4
    2f94:	0fc080e7          	jalr	252(ra) # 708c <exec>
  if(ret != -1){
    2f98:	fff00793          	li	a5,-1
    2f9c:	0af51e63          	bne	a0,a5,3058 <copyinstr3+0x178>
}
    2fa0:	02813083          	ld	ra,40(sp)
    2fa4:	02013403          	ld	s0,32(sp)
    2fa8:	01813483          	ld	s1,24(sp)
    2fac:	03010113          	add	sp,sp,48
    2fb0:	00008067          	ret
    sbrk(PGSIZE - (top % PGSIZE));
    2fb4:	0347d513          	srl	a0,a5,0x34
    2fb8:	000017b7          	lui	a5,0x1
    2fbc:	40a7853b          	subw	a0,a5,a0
    2fc0:	00004097          	auipc	ra,0x4
    2fc4:	144080e7          	jalr	324(ra) # 7104 <sbrk>
    2fc8:	f4dff06f          	j	2f14 <copyinstr3+0x34>
    printf("oops\n");
    2fcc:	00005517          	auipc	a0,0x5
    2fd0:	4cc50513          	add	a0,a0,1228 # 8498 <malloc+0xe80>
    2fd4:	00004097          	auipc	ra,0x4
    2fd8:	540080e7          	jalr	1344(ra) # 7514 <printf>
    exit(1);
    2fdc:	00100513          	li	a0,1
    2fe0:	00004097          	auipc	ra,0x4
    2fe4:	058080e7          	jalr	88(ra) # 7038 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    2fe8:	00050613          	mv	a2,a0
    2fec:	00048593          	mv	a1,s1
    2ff0:	00005517          	auipc	a0,0x5
    2ff4:	f5050513          	add	a0,a0,-176 # 7f40 <malloc+0x928>
    2ff8:	00004097          	auipc	ra,0x4
    2ffc:	51c080e7          	jalr	1308(ra) # 7514 <printf>
    exit(1);
    3000:	00100513          	li	a0,1
    3004:	00004097          	auipc	ra,0x4
    3008:	034080e7          	jalr	52(ra) # 7038 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    300c:	00050613          	mv	a2,a0
    3010:	00048593          	mv	a1,s1
    3014:	00005517          	auipc	a0,0x5
    3018:	f4c50513          	add	a0,a0,-180 # 7f60 <malloc+0x948>
    301c:	00004097          	auipc	ra,0x4
    3020:	4f8080e7          	jalr	1272(ra) # 7514 <printf>
    exit(1);
    3024:	00100513          	li	a0,1
    3028:	00004097          	auipc	ra,0x4
    302c:	010080e7          	jalr	16(ra) # 7038 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    3030:	00050693          	mv	a3,a0
    3034:	00048613          	mv	a2,s1
    3038:	00048593          	mv	a1,s1
    303c:	00005517          	auipc	a0,0x5
    3040:	f4450513          	add	a0,a0,-188 # 7f80 <malloc+0x968>
    3044:	00004097          	auipc	ra,0x4
    3048:	4d0080e7          	jalr	1232(ra) # 7514 <printf>
    exit(1);
    304c:	00100513          	li	a0,1
    3050:	00004097          	auipc	ra,0x4
    3054:	fe8080e7          	jalr	-24(ra) # 7038 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    3058:	fff00613          	li	a2,-1
    305c:	00048593          	mv	a1,s1
    3060:	00005517          	auipc	a0,0x5
    3064:	f4850513          	add	a0,a0,-184 # 7fa8 <malloc+0x990>
    3068:	00004097          	auipc	ra,0x4
    306c:	4ac080e7          	jalr	1196(ra) # 7514 <printf>
    exit(1);
    3070:	00100513          	li	a0,1
    3074:	00004097          	auipc	ra,0x4
    3078:	fc4080e7          	jalr	-60(ra) # 7038 <exit>

000000000000307c <rwsbrk>:
{
    307c:	fe010113          	add	sp,sp,-32
    3080:	00113c23          	sd	ra,24(sp)
    3084:	00813823          	sd	s0,16(sp)
    3088:	00913423          	sd	s1,8(sp)
    308c:	01213023          	sd	s2,0(sp)
    3090:	02010413          	add	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    3094:	00002537          	lui	a0,0x2
    3098:	00004097          	auipc	ra,0x4
    309c:	06c080e7          	jalr	108(ra) # 7104 <sbrk>
  if(a == 0xffffffffffffffffLL) {
    30a0:	fff00793          	li	a5,-1
    30a4:	06f50c63          	beq	a0,a5,311c <rwsbrk+0xa0>
    30a8:	00050493          	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    30ac:	ffffe537          	lui	a0,0xffffe
    30b0:	00004097          	auipc	ra,0x4
    30b4:	054080e7          	jalr	84(ra) # 7104 <sbrk>
    30b8:	fff00793          	li	a5,-1
    30bc:	06f50e63          	beq	a0,a5,3138 <rwsbrk+0xbc>
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    30c0:	20100593          	li	a1,513
    30c4:	00005517          	auipc	a0,0x5
    30c8:	41450513          	add	a0,a0,1044 # 84d8 <malloc+0xec0>
    30cc:	00004097          	auipc	ra,0x4
    30d0:	fcc080e7          	jalr	-52(ra) # 7098 <open>
    30d4:	00050913          	mv	s2,a0
  if(fd < 0){
    30d8:	06054e63          	bltz	a0,3154 <rwsbrk+0xd8>
  n = write(fd, (void*)(a+4096), 1024);
    30dc:	000017b7          	lui	a5,0x1
    30e0:	00f484b3          	add	s1,s1,a5
    30e4:	40000613          	li	a2,1024
    30e8:	00048593          	mv	a1,s1
    30ec:	00004097          	auipc	ra,0x4
    30f0:	f7c080e7          	jalr	-132(ra) # 7068 <write>
    30f4:	00050613          	mv	a2,a0
  if(n >= 0){
    30f8:	06054c63          	bltz	a0,3170 <rwsbrk+0xf4>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a+4096, n);
    30fc:	00048593          	mv	a1,s1
    3100:	00005517          	auipc	a0,0x5
    3104:	3f850513          	add	a0,a0,1016 # 84f8 <malloc+0xee0>
    3108:	00004097          	auipc	ra,0x4
    310c:	40c080e7          	jalr	1036(ra) # 7514 <printf>
    exit(1);
    3110:	00100513          	li	a0,1
    3114:	00004097          	auipc	ra,0x4
    3118:	f24080e7          	jalr	-220(ra) # 7038 <exit>
    printf("sbrk(rwsbrk) failed\n");
    311c:	00005517          	auipc	a0,0x5
    3120:	38450513          	add	a0,a0,900 # 84a0 <malloc+0xe88>
    3124:	00004097          	auipc	ra,0x4
    3128:	3f0080e7          	jalr	1008(ra) # 7514 <printf>
    exit(1);
    312c:	00100513          	li	a0,1
    3130:	00004097          	auipc	ra,0x4
    3134:	f08080e7          	jalr	-248(ra) # 7038 <exit>
    printf("sbrk(rwsbrk) shrink failed\n");
    3138:	00005517          	auipc	a0,0x5
    313c:	38050513          	add	a0,a0,896 # 84b8 <malloc+0xea0>
    3140:	00004097          	auipc	ra,0x4
    3144:	3d4080e7          	jalr	980(ra) # 7514 <printf>
    exit(1);
    3148:	00100513          	li	a0,1
    314c:	00004097          	auipc	ra,0x4
    3150:	eec080e7          	jalr	-276(ra) # 7038 <exit>
    printf("open(rwsbrk) failed\n");
    3154:	00005517          	auipc	a0,0x5
    3158:	38c50513          	add	a0,a0,908 # 84e0 <malloc+0xec8>
    315c:	00004097          	auipc	ra,0x4
    3160:	3b8080e7          	jalr	952(ra) # 7514 <printf>
    exit(1);
    3164:	00100513          	li	a0,1
    3168:	00004097          	auipc	ra,0x4
    316c:	ed0080e7          	jalr	-304(ra) # 7038 <exit>
  close(fd);
    3170:	00090513          	mv	a0,s2
    3174:	00004097          	auipc	ra,0x4
    3178:	f00080e7          	jalr	-256(ra) # 7074 <close>
  unlink("rwsbrk");
    317c:	00005517          	auipc	a0,0x5
    3180:	35c50513          	add	a0,a0,860 # 84d8 <malloc+0xec0>
    3184:	00004097          	auipc	ra,0x4
    3188:	f2c080e7          	jalr	-212(ra) # 70b0 <unlink>
  fd = open("README", O_RDONLY);
    318c:	00000593          	li	a1,0
    3190:	00004517          	auipc	a0,0x4
    3194:	7e050513          	add	a0,a0,2016 # 7970 <malloc+0x358>
    3198:	00004097          	auipc	ra,0x4
    319c:	f00080e7          	jalr	-256(ra) # 7098 <open>
    31a0:	00050913          	mv	s2,a0
  if(fd < 0){
    31a4:	02054e63          	bltz	a0,31e0 <rwsbrk+0x164>
  n = read(fd, (void*)(a+4096), 10);
    31a8:	00a00613          	li	a2,10
    31ac:	00048593          	mv	a1,s1
    31b0:	00004097          	auipc	ra,0x4
    31b4:	eac080e7          	jalr	-340(ra) # 705c <read>
    31b8:	00050613          	mv	a2,a0
  if(n >= 0){
    31bc:	04054063          	bltz	a0,31fc <rwsbrk+0x180>
    printf("read(fd, %p, 10) returned %d, not -1\n", a+4096, n);
    31c0:	00048593          	mv	a1,s1
    31c4:	00005517          	auipc	a0,0x5
    31c8:	36450513          	add	a0,a0,868 # 8528 <malloc+0xf10>
    31cc:	00004097          	auipc	ra,0x4
    31d0:	348080e7          	jalr	840(ra) # 7514 <printf>
    exit(1);
    31d4:	00100513          	li	a0,1
    31d8:	00004097          	auipc	ra,0x4
    31dc:	e60080e7          	jalr	-416(ra) # 7038 <exit>
    printf("open(rwsbrk) failed\n");
    31e0:	00005517          	auipc	a0,0x5
    31e4:	30050513          	add	a0,a0,768 # 84e0 <malloc+0xec8>
    31e8:	00004097          	auipc	ra,0x4
    31ec:	32c080e7          	jalr	812(ra) # 7514 <printf>
    exit(1);
    31f0:	00100513          	li	a0,1
    31f4:	00004097          	auipc	ra,0x4
    31f8:	e44080e7          	jalr	-444(ra) # 7038 <exit>
  close(fd);
    31fc:	00090513          	mv	a0,s2
    3200:	00004097          	auipc	ra,0x4
    3204:	e74080e7          	jalr	-396(ra) # 7074 <close>
  exit(0);
    3208:	00000513          	li	a0,0
    320c:	00004097          	auipc	ra,0x4
    3210:	e2c080e7          	jalr	-468(ra) # 7038 <exit>

0000000000003214 <sbrkbasic>:
{
    3214:	fc010113          	add	sp,sp,-64
    3218:	02113c23          	sd	ra,56(sp)
    321c:	02813823          	sd	s0,48(sp)
    3220:	02913423          	sd	s1,40(sp)
    3224:	03213023          	sd	s2,32(sp)
    3228:	01313c23          	sd	s3,24(sp)
    322c:	01413823          	sd	s4,16(sp)
    3230:	04010413          	add	s0,sp,64
    3234:	00050a13          	mv	s4,a0
  pid = fork();
    3238:	00004097          	auipc	ra,0x4
    323c:	df4080e7          	jalr	-524(ra) # 702c <fork>
  if(pid < 0){
    3240:	04054263          	bltz	a0,3284 <sbrkbasic+0x70>
  if(pid == 0){
    3244:	06051463          	bnez	a0,32ac <sbrkbasic+0x98>
    a = sbrk(TOOMUCH);
    3248:	40000537          	lui	a0,0x40000
    324c:	00004097          	auipc	ra,0x4
    3250:	eb8080e7          	jalr	-328(ra) # 7104 <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    3254:	fff00793          	li	a5,-1
    3258:	04f50463          	beq	a0,a5,32a0 <sbrkbasic+0x8c>
    for(b = a; b < a+TOOMUCH; b += 4096){
    325c:	400007b7          	lui	a5,0x40000
    3260:	00f507b3          	add	a5,a0,a5
      *b = 99;
    3264:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    3268:	00001737          	lui	a4,0x1
      *b = 99;
    326c:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3ffef388>
    for(b = a; b < a+TOOMUCH; b += 4096){
    3270:	00e50533          	add	a0,a0,a4
    3274:	fef51ce3          	bne	a0,a5,326c <sbrkbasic+0x58>
    exit(1);
    3278:	00100513          	li	a0,1
    327c:	00004097          	auipc	ra,0x4
    3280:	dbc080e7          	jalr	-580(ra) # 7038 <exit>
    printf("fork failed in sbrkbasic\n");
    3284:	00005517          	auipc	a0,0x5
    3288:	2cc50513          	add	a0,a0,716 # 8550 <malloc+0xf38>
    328c:	00004097          	auipc	ra,0x4
    3290:	288080e7          	jalr	648(ra) # 7514 <printf>
    exit(1);
    3294:	00100513          	li	a0,1
    3298:	00004097          	auipc	ra,0x4
    329c:	da0080e7          	jalr	-608(ra) # 7038 <exit>
      exit(0);
    32a0:	00000513          	li	a0,0
    32a4:	00004097          	auipc	ra,0x4
    32a8:	d94080e7          	jalr	-620(ra) # 7038 <exit>
  wait(&xstatus);
    32ac:	fcc40513          	add	a0,s0,-52
    32b0:	00004097          	auipc	ra,0x4
    32b4:	d94080e7          	jalr	-620(ra) # 7044 <wait>
  if(xstatus == 1){
    32b8:	fcc42703          	lw	a4,-52(s0)
    32bc:	00100793          	li	a5,1
    32c0:	02f70263          	beq	a4,a5,32e4 <sbrkbasic+0xd0>
  a = sbrk(0);
    32c4:	00000513          	li	a0,0
    32c8:	00004097          	auipc	ra,0x4
    32cc:	e3c080e7          	jalr	-452(ra) # 7104 <sbrk>
    32d0:	00050493          	mv	s1,a0
  for(i = 0; i < 5000; i++){
    32d4:	00000913          	li	s2,0
    32d8:	000019b7          	lui	s3,0x1
    32dc:	38898993          	add	s3,s3,904 # 1388 <linktest+0x104>
    32e0:	0280006f          	j	3308 <sbrkbasic+0xf4>
    printf("%s: too much memory allocated!\n", s);
    32e4:	000a0593          	mv	a1,s4
    32e8:	00005517          	auipc	a0,0x5
    32ec:	28850513          	add	a0,a0,648 # 8570 <malloc+0xf58>
    32f0:	00004097          	auipc	ra,0x4
    32f4:	224080e7          	jalr	548(ra) # 7514 <printf>
    exit(1);
    32f8:	00100513          	li	a0,1
    32fc:	00004097          	auipc	ra,0x4
    3300:	d3c080e7          	jalr	-708(ra) # 7038 <exit>
    a = b + 1;
    3304:	00078493          	mv	s1,a5
    b = sbrk(1);
    3308:	00100513          	li	a0,1
    330c:	00004097          	auipc	ra,0x4
    3310:	df8080e7          	jalr	-520(ra) # 7104 <sbrk>
    if(b != a){
    3314:	06951463          	bne	a0,s1,337c <sbrkbasic+0x168>
    *b = 1;
    3318:	00100793          	li	a5,1
    331c:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    3320:	00148793          	add	a5,s1,1
  for(i = 0; i < 5000; i++){
    3324:	0019091b          	addw	s2,s2,1
    3328:	fd391ee3          	bne	s2,s3,3304 <sbrkbasic+0xf0>
  pid = fork();
    332c:	00004097          	auipc	ra,0x4
    3330:	d00080e7          	jalr	-768(ra) # 702c <fork>
    3334:	00050913          	mv	s2,a0
  if(pid < 0){
    3338:	06054863          	bltz	a0,33a8 <sbrkbasic+0x194>
  c = sbrk(1);
    333c:	00100513          	li	a0,1
    3340:	00004097          	auipc	ra,0x4
    3344:	dc4080e7          	jalr	-572(ra) # 7104 <sbrk>
  c = sbrk(1);
    3348:	00100513          	li	a0,1
    334c:	00004097          	auipc	ra,0x4
    3350:	db8080e7          	jalr	-584(ra) # 7104 <sbrk>
  if(c != a + 1){
    3354:	00248493          	add	s1,s1,2
    3358:	06a48863          	beq	s1,a0,33c8 <sbrkbasic+0x1b4>
    printf("%s: sbrk test failed post-fork\n", s);
    335c:	000a0593          	mv	a1,s4
    3360:	00005517          	auipc	a0,0x5
    3364:	27050513          	add	a0,a0,624 # 85d0 <malloc+0xfb8>
    3368:	00004097          	auipc	ra,0x4
    336c:	1ac080e7          	jalr	428(ra) # 7514 <printf>
    exit(1);
    3370:	00100513          	li	a0,1
    3374:	00004097          	auipc	ra,0x4
    3378:	cc4080e7          	jalr	-828(ra) # 7038 <exit>
      printf("%s: sbrk test failed %d %x %x\n", s, i, a, b);
    337c:	00050713          	mv	a4,a0
    3380:	00048693          	mv	a3,s1
    3384:	00090613          	mv	a2,s2
    3388:	000a0593          	mv	a1,s4
    338c:	00005517          	auipc	a0,0x5
    3390:	20450513          	add	a0,a0,516 # 8590 <malloc+0xf78>
    3394:	00004097          	auipc	ra,0x4
    3398:	180080e7          	jalr	384(ra) # 7514 <printf>
      exit(1);
    339c:	00100513          	li	a0,1
    33a0:	00004097          	auipc	ra,0x4
    33a4:	c98080e7          	jalr	-872(ra) # 7038 <exit>
    printf("%s: sbrk test fork failed\n", s);
    33a8:	000a0593          	mv	a1,s4
    33ac:	00005517          	auipc	a0,0x5
    33b0:	20450513          	add	a0,a0,516 # 85b0 <malloc+0xf98>
    33b4:	00004097          	auipc	ra,0x4
    33b8:	160080e7          	jalr	352(ra) # 7514 <printf>
    exit(1);
    33bc:	00100513          	li	a0,1
    33c0:	00004097          	auipc	ra,0x4
    33c4:	c78080e7          	jalr	-904(ra) # 7038 <exit>
  if(pid == 0)
    33c8:	00091863          	bnez	s2,33d8 <sbrkbasic+0x1c4>
    exit(0);
    33cc:	00000513          	li	a0,0
    33d0:	00004097          	auipc	ra,0x4
    33d4:	c68080e7          	jalr	-920(ra) # 7038 <exit>
  wait(&xstatus);
    33d8:	fcc40513          	add	a0,s0,-52
    33dc:	00004097          	auipc	ra,0x4
    33e0:	c68080e7          	jalr	-920(ra) # 7044 <wait>
  exit(xstatus);
    33e4:	fcc42503          	lw	a0,-52(s0)
    33e8:	00004097          	auipc	ra,0x4
    33ec:	c50080e7          	jalr	-944(ra) # 7038 <exit>

00000000000033f0 <sbrkmuch>:
{
    33f0:	fd010113          	add	sp,sp,-48
    33f4:	02113423          	sd	ra,40(sp)
    33f8:	02813023          	sd	s0,32(sp)
    33fc:	00913c23          	sd	s1,24(sp)
    3400:	01213823          	sd	s2,16(sp)
    3404:	01313423          	sd	s3,8(sp)
    3408:	01413023          	sd	s4,0(sp)
    340c:	03010413          	add	s0,sp,48
    3410:	00050993          	mv	s3,a0
  oldbrk = sbrk(0);
    3414:	00000513          	li	a0,0
    3418:	00004097          	auipc	ra,0x4
    341c:	cec080e7          	jalr	-788(ra) # 7104 <sbrk>
    3420:	00050913          	mv	s2,a0
  a = sbrk(0);
    3424:	00000513          	li	a0,0
    3428:	00004097          	auipc	ra,0x4
    342c:	cdc080e7          	jalr	-804(ra) # 7104 <sbrk>
    3430:	00050493          	mv	s1,a0
  p = sbrk(amt);
    3434:	06400537          	lui	a0,0x6400
    3438:	4095053b          	subw	a0,a0,s1
    343c:	00004097          	auipc	ra,0x4
    3440:	cc8080e7          	jalr	-824(ra) # 7104 <sbrk>
  if (p != a) {
    3444:	10a49663          	bne	s1,a0,3550 <sbrkmuch+0x160>
  char *eee = sbrk(0);
    3448:	00000513          	li	a0,0
    344c:	00004097          	auipc	ra,0x4
    3450:	cb8080e7          	jalr	-840(ra) # 7104 <sbrk>
    3454:	00050793          	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    3458:	00a4fc63          	bgeu	s1,a0,3470 <sbrkmuch+0x80>
    *pp = 1;
    345c:	00100693          	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    3460:	00001737          	lui	a4,0x1
    *pp = 1;
    3464:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    3468:	00e484b3          	add	s1,s1,a4
    346c:	fef4ece3          	bltu	s1,a5,3464 <sbrkmuch+0x74>
  *lastaddr = 99;
    3470:	064007b7          	lui	a5,0x6400
    3474:	06300713          	li	a4,99
    3478:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63ef387>
  a = sbrk(0);
    347c:	00000513          	li	a0,0
    3480:	00004097          	auipc	ra,0x4
    3484:	c84080e7          	jalr	-892(ra) # 7104 <sbrk>
    3488:	00050493          	mv	s1,a0
  c = sbrk(-PGSIZE);
    348c:	fffff537          	lui	a0,0xfffff
    3490:	00004097          	auipc	ra,0x4
    3494:	c74080e7          	jalr	-908(ra) # 7104 <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    3498:	fff00793          	li	a5,-1
    349c:	0cf50a63          	beq	a0,a5,3570 <sbrkmuch+0x180>
  c = sbrk(0);
    34a0:	00000513          	li	a0,0
    34a4:	00004097          	auipc	ra,0x4
    34a8:	c60080e7          	jalr	-928(ra) # 7104 <sbrk>
  if(c != a - PGSIZE){
    34ac:	fffff7b7          	lui	a5,0xfffff
    34b0:	00f487b3          	add	a5,s1,a5
    34b4:	0cf51e63          	bne	a0,a5,3590 <sbrkmuch+0x1a0>
  a = sbrk(0);
    34b8:	00000513          	li	a0,0
    34bc:	00004097          	auipc	ra,0x4
    34c0:	c48080e7          	jalr	-952(ra) # 7104 <sbrk>
    34c4:	00050493          	mv	s1,a0
  c = sbrk(PGSIZE);
    34c8:	00001537          	lui	a0,0x1
    34cc:	00004097          	auipc	ra,0x4
    34d0:	c38080e7          	jalr	-968(ra) # 7104 <sbrk>
    34d4:	00050a13          	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    34d8:	0ea49063          	bne	s1,a0,35b8 <sbrkmuch+0x1c8>
    34dc:	00000513          	li	a0,0
    34e0:	00004097          	auipc	ra,0x4
    34e4:	c24080e7          	jalr	-988(ra) # 7104 <sbrk>
    34e8:	000017b7          	lui	a5,0x1
    34ec:	00f487b3          	add	a5,s1,a5
    34f0:	0cf51463          	bne	a0,a5,35b8 <sbrkmuch+0x1c8>
  if(*lastaddr == 99){
    34f4:	064007b7          	lui	a5,0x6400
    34f8:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63ef387>
    34fc:	06300793          	li	a5,99
    3500:	0ef70063          	beq	a4,a5,35e0 <sbrkmuch+0x1f0>
  a = sbrk(0);
    3504:	00000513          	li	a0,0
    3508:	00004097          	auipc	ra,0x4
    350c:	bfc080e7          	jalr	-1028(ra) # 7104 <sbrk>
    3510:	00050493          	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    3514:	00000513          	li	a0,0
    3518:	00004097          	auipc	ra,0x4
    351c:	bec080e7          	jalr	-1044(ra) # 7104 <sbrk>
    3520:	40a9053b          	subw	a0,s2,a0
    3524:	00004097          	auipc	ra,0x4
    3528:	be0080e7          	jalr	-1056(ra) # 7104 <sbrk>
  if(c != a){
    352c:	0ca49a63          	bne	s1,a0,3600 <sbrkmuch+0x210>
}
    3530:	02813083          	ld	ra,40(sp)
    3534:	02013403          	ld	s0,32(sp)
    3538:	01813483          	ld	s1,24(sp)
    353c:	01013903          	ld	s2,16(sp)
    3540:	00813983          	ld	s3,8(sp)
    3544:	00013a03          	ld	s4,0(sp)
    3548:	03010113          	add	sp,sp,48
    354c:	00008067          	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    3550:	00098593          	mv	a1,s3
    3554:	00005517          	auipc	a0,0x5
    3558:	09c50513          	add	a0,a0,156 # 85f0 <malloc+0xfd8>
    355c:	00004097          	auipc	ra,0x4
    3560:	fb8080e7          	jalr	-72(ra) # 7514 <printf>
    exit(1);
    3564:	00100513          	li	a0,1
    3568:	00004097          	auipc	ra,0x4
    356c:	ad0080e7          	jalr	-1328(ra) # 7038 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    3570:	00098593          	mv	a1,s3
    3574:	00005517          	auipc	a0,0x5
    3578:	0c450513          	add	a0,a0,196 # 8638 <malloc+0x1020>
    357c:	00004097          	auipc	ra,0x4
    3580:	f98080e7          	jalr	-104(ra) # 7514 <printf>
    exit(1);
    3584:	00100513          	li	a0,1
    3588:	00004097          	auipc	ra,0x4
    358c:	ab0080e7          	jalr	-1360(ra) # 7038 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", s, a, c);
    3590:	00050693          	mv	a3,a0
    3594:	00048613          	mv	a2,s1
    3598:	00098593          	mv	a1,s3
    359c:	00005517          	auipc	a0,0x5
    35a0:	0bc50513          	add	a0,a0,188 # 8658 <malloc+0x1040>
    35a4:	00004097          	auipc	ra,0x4
    35a8:	f70080e7          	jalr	-144(ra) # 7514 <printf>
    exit(1);
    35ac:	00100513          	li	a0,1
    35b0:	00004097          	auipc	ra,0x4
    35b4:	a88080e7          	jalr	-1400(ra) # 7038 <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", s, a, c);
    35b8:	000a0693          	mv	a3,s4
    35bc:	00048613          	mv	a2,s1
    35c0:	00098593          	mv	a1,s3
    35c4:	00005517          	auipc	a0,0x5
    35c8:	0d450513          	add	a0,a0,212 # 8698 <malloc+0x1080>
    35cc:	00004097          	auipc	ra,0x4
    35d0:	f48080e7          	jalr	-184(ra) # 7514 <printf>
    exit(1);
    35d4:	00100513          	li	a0,1
    35d8:	00004097          	auipc	ra,0x4
    35dc:	a60080e7          	jalr	-1440(ra) # 7038 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    35e0:	00098593          	mv	a1,s3
    35e4:	00005517          	auipc	a0,0x5
    35e8:	0e450513          	add	a0,a0,228 # 86c8 <malloc+0x10b0>
    35ec:	00004097          	auipc	ra,0x4
    35f0:	f28080e7          	jalr	-216(ra) # 7514 <printf>
    exit(1);
    35f4:	00100513          	li	a0,1
    35f8:	00004097          	auipc	ra,0x4
    35fc:	a40080e7          	jalr	-1472(ra) # 7038 <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", s, a, c);
    3600:	00050693          	mv	a3,a0
    3604:	00048613          	mv	a2,s1
    3608:	00098593          	mv	a1,s3
    360c:	00005517          	auipc	a0,0x5
    3610:	0f450513          	add	a0,a0,244 # 8700 <malloc+0x10e8>
    3614:	00004097          	auipc	ra,0x4
    3618:	f00080e7          	jalr	-256(ra) # 7514 <printf>
    exit(1);
    361c:	00100513          	li	a0,1
    3620:	00004097          	auipc	ra,0x4
    3624:	a18080e7          	jalr	-1512(ra) # 7038 <exit>

0000000000003628 <sbrkarg>:
{
    3628:	fd010113          	add	sp,sp,-48
    362c:	02113423          	sd	ra,40(sp)
    3630:	02813023          	sd	s0,32(sp)
    3634:	00913c23          	sd	s1,24(sp)
    3638:	01213823          	sd	s2,16(sp)
    363c:	01313423          	sd	s3,8(sp)
    3640:	03010413          	add	s0,sp,48
    3644:	00050993          	mv	s3,a0
  a = sbrk(PGSIZE);
    3648:	00001537          	lui	a0,0x1
    364c:	00004097          	auipc	ra,0x4
    3650:	ab8080e7          	jalr	-1352(ra) # 7104 <sbrk>
    3654:	00050913          	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    3658:	20100593          	li	a1,513
    365c:	00005517          	auipc	a0,0x5
    3660:	0cc50513          	add	a0,a0,204 # 8728 <malloc+0x1110>
    3664:	00004097          	auipc	ra,0x4
    3668:	a34080e7          	jalr	-1484(ra) # 7098 <open>
    366c:	00050493          	mv	s1,a0
  unlink("sbrk");
    3670:	00005517          	auipc	a0,0x5
    3674:	0b850513          	add	a0,a0,184 # 8728 <malloc+0x1110>
    3678:	00004097          	auipc	ra,0x4
    367c:	a38080e7          	jalr	-1480(ra) # 70b0 <unlink>
  if(fd < 0)  {
    3680:	0404ce63          	bltz	s1,36dc <sbrkarg+0xb4>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    3684:	00001637          	lui	a2,0x1
    3688:	00090593          	mv	a1,s2
    368c:	00048513          	mv	a0,s1
    3690:	00004097          	auipc	ra,0x4
    3694:	9d8080e7          	jalr	-1576(ra) # 7068 <write>
    3698:	06054263          	bltz	a0,36fc <sbrkarg+0xd4>
  close(fd);
    369c:	00048513          	mv	a0,s1
    36a0:	00004097          	auipc	ra,0x4
    36a4:	9d4080e7          	jalr	-1580(ra) # 7074 <close>
  a = sbrk(PGSIZE);
    36a8:	00001537          	lui	a0,0x1
    36ac:	00004097          	auipc	ra,0x4
    36b0:	a58080e7          	jalr	-1448(ra) # 7104 <sbrk>
  if(pipe((int *) a) != 0){
    36b4:	00004097          	auipc	ra,0x4
    36b8:	99c080e7          	jalr	-1636(ra) # 7050 <pipe>
    36bc:	06051063          	bnez	a0,371c <sbrkarg+0xf4>
}
    36c0:	02813083          	ld	ra,40(sp)
    36c4:	02013403          	ld	s0,32(sp)
    36c8:	01813483          	ld	s1,24(sp)
    36cc:	01013903          	ld	s2,16(sp)
    36d0:	00813983          	ld	s3,8(sp)
    36d4:	03010113          	add	sp,sp,48
    36d8:	00008067          	ret
    printf("%s: open sbrk failed\n", s);
    36dc:	00098593          	mv	a1,s3
    36e0:	00005517          	auipc	a0,0x5
    36e4:	05050513          	add	a0,a0,80 # 8730 <malloc+0x1118>
    36e8:	00004097          	auipc	ra,0x4
    36ec:	e2c080e7          	jalr	-468(ra) # 7514 <printf>
    exit(1);
    36f0:	00100513          	li	a0,1
    36f4:	00004097          	auipc	ra,0x4
    36f8:	944080e7          	jalr	-1724(ra) # 7038 <exit>
    printf("%s: write sbrk failed\n", s);
    36fc:	00098593          	mv	a1,s3
    3700:	00005517          	auipc	a0,0x5
    3704:	04850513          	add	a0,a0,72 # 8748 <malloc+0x1130>
    3708:	00004097          	auipc	ra,0x4
    370c:	e0c080e7          	jalr	-500(ra) # 7514 <printf>
    exit(1);
    3710:	00100513          	li	a0,1
    3714:	00004097          	auipc	ra,0x4
    3718:	924080e7          	jalr	-1756(ra) # 7038 <exit>
    printf("%s: pipe() failed\n", s);
    371c:	00098593          	mv	a1,s3
    3720:	00005517          	auipc	a0,0x5
    3724:	a0850513          	add	a0,a0,-1528 # 8128 <malloc+0xb10>
    3728:	00004097          	auipc	ra,0x4
    372c:	dec080e7          	jalr	-532(ra) # 7514 <printf>
    exit(1);
    3730:	00100513          	li	a0,1
    3734:	00004097          	auipc	ra,0x4
    3738:	904080e7          	jalr	-1788(ra) # 7038 <exit>

000000000000373c <argptest>:
{
    373c:	fe010113          	add	sp,sp,-32
    3740:	00113c23          	sd	ra,24(sp)
    3744:	00813823          	sd	s0,16(sp)
    3748:	00913423          	sd	s1,8(sp)
    374c:	01213023          	sd	s2,0(sp)
    3750:	02010413          	add	s0,sp,32
    3754:	00050913          	mv	s2,a0
  fd = open("init", O_RDONLY);
    3758:	00000593          	li	a1,0
    375c:	00005517          	auipc	a0,0x5
    3760:	00450513          	add	a0,a0,4 # 8760 <malloc+0x1148>
    3764:	00004097          	auipc	ra,0x4
    3768:	934080e7          	jalr	-1740(ra) # 7098 <open>
  if (fd < 0) {
    376c:	04054663          	bltz	a0,37b8 <argptest+0x7c>
    3770:	00050493          	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    3774:	00000513          	li	a0,0
    3778:	00004097          	auipc	ra,0x4
    377c:	98c080e7          	jalr	-1652(ra) # 7104 <sbrk>
    3780:	fff00613          	li	a2,-1
    3784:	fff50593          	add	a1,a0,-1
    3788:	00048513          	mv	a0,s1
    378c:	00004097          	auipc	ra,0x4
    3790:	8d0080e7          	jalr	-1840(ra) # 705c <read>
  close(fd);
    3794:	00048513          	mv	a0,s1
    3798:	00004097          	auipc	ra,0x4
    379c:	8dc080e7          	jalr	-1828(ra) # 7074 <close>
}
    37a0:	01813083          	ld	ra,24(sp)
    37a4:	01013403          	ld	s0,16(sp)
    37a8:	00813483          	ld	s1,8(sp)
    37ac:	00013903          	ld	s2,0(sp)
    37b0:	02010113          	add	sp,sp,32
    37b4:	00008067          	ret
    printf("%s: open failed\n", s);
    37b8:	00090593          	mv	a1,s2
    37bc:	00005517          	auipc	a0,0x5
    37c0:	87c50513          	add	a0,a0,-1924 # 8038 <malloc+0xa20>
    37c4:	00004097          	auipc	ra,0x4
    37c8:	d50080e7          	jalr	-688(ra) # 7514 <printf>
    exit(1);
    37cc:	00100513          	li	a0,1
    37d0:	00004097          	auipc	ra,0x4
    37d4:	868080e7          	jalr	-1944(ra) # 7038 <exit>

00000000000037d8 <sbrkbugs>:
{
    37d8:	ff010113          	add	sp,sp,-16
    37dc:	00113423          	sd	ra,8(sp)
    37e0:	00813023          	sd	s0,0(sp)
    37e4:	01010413          	add	s0,sp,16
  int pid = fork();
    37e8:	00004097          	auipc	ra,0x4
    37ec:	844080e7          	jalr	-1980(ra) # 702c <fork>
  if(pid < 0){
    37f0:	02054463          	bltz	a0,3818 <sbrkbugs+0x40>
  if(pid == 0){
    37f4:	04051063          	bnez	a0,3834 <sbrkbugs+0x5c>
    int sz = (uint64) sbrk(0);
    37f8:	00004097          	auipc	ra,0x4
    37fc:	90c080e7          	jalr	-1780(ra) # 7104 <sbrk>
    sbrk(-sz);
    3800:	40a0053b          	negw	a0,a0
    3804:	00004097          	auipc	ra,0x4
    3808:	900080e7          	jalr	-1792(ra) # 7104 <sbrk>
    exit(0);
    380c:	00000513          	li	a0,0
    3810:	00004097          	auipc	ra,0x4
    3814:	828080e7          	jalr	-2008(ra) # 7038 <exit>
    printf("fork failed\n");
    3818:	00005517          	auipc	a0,0x5
    381c:	c1050513          	add	a0,a0,-1008 # 8428 <malloc+0xe10>
    3820:	00004097          	auipc	ra,0x4
    3824:	cf4080e7          	jalr	-780(ra) # 7514 <printf>
    exit(1);
    3828:	00100513          	li	a0,1
    382c:	00004097          	auipc	ra,0x4
    3830:	80c080e7          	jalr	-2036(ra) # 7038 <exit>
  wait(0);
    3834:	00000513          	li	a0,0
    3838:	00004097          	auipc	ra,0x4
    383c:	80c080e7          	jalr	-2036(ra) # 7044 <wait>
  pid = fork();
    3840:	00003097          	auipc	ra,0x3
    3844:	7ec080e7          	jalr	2028(ra) # 702c <fork>
  if(pid < 0){
    3848:	02054863          	bltz	a0,3878 <sbrkbugs+0xa0>
  if(pid == 0){
    384c:	04051463          	bnez	a0,3894 <sbrkbugs+0xbc>
    int sz = (uint64) sbrk(0);
    3850:	00004097          	auipc	ra,0x4
    3854:	8b4080e7          	jalr	-1868(ra) # 7104 <sbrk>
    sbrk(-(sz - 3500));
    3858:	000017b7          	lui	a5,0x1
    385c:	dac7879b          	addw	a5,a5,-596 # dac <writetest+0x144>
    3860:	40a7853b          	subw	a0,a5,a0
    3864:	00004097          	auipc	ra,0x4
    3868:	8a0080e7          	jalr	-1888(ra) # 7104 <sbrk>
    exit(0);
    386c:	00000513          	li	a0,0
    3870:	00003097          	auipc	ra,0x3
    3874:	7c8080e7          	jalr	1992(ra) # 7038 <exit>
    printf("fork failed\n");
    3878:	00005517          	auipc	a0,0x5
    387c:	bb050513          	add	a0,a0,-1104 # 8428 <malloc+0xe10>
    3880:	00004097          	auipc	ra,0x4
    3884:	c94080e7          	jalr	-876(ra) # 7514 <printf>
    exit(1);
    3888:	00100513          	li	a0,1
    388c:	00003097          	auipc	ra,0x3
    3890:	7ac080e7          	jalr	1964(ra) # 7038 <exit>
  wait(0);
    3894:	00000513          	li	a0,0
    3898:	00003097          	auipc	ra,0x3
    389c:	7ac080e7          	jalr	1964(ra) # 7044 <wait>
  pid = fork();
    38a0:	00003097          	auipc	ra,0x3
    38a4:	78c080e7          	jalr	1932(ra) # 702c <fork>
  if(pid < 0){
    38a8:	02054e63          	bltz	a0,38e4 <sbrkbugs+0x10c>
  if(pid == 0){
    38ac:	04051a63          	bnez	a0,3900 <sbrkbugs+0x128>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    38b0:	00004097          	auipc	ra,0x4
    38b4:	854080e7          	jalr	-1964(ra) # 7104 <sbrk>
    38b8:	0000b7b7          	lui	a5,0xb
    38bc:	8007879b          	addw	a5,a5,-2048 # a800 <big.0+0x2a0>
    38c0:	40a7853b          	subw	a0,a5,a0
    38c4:	00004097          	auipc	ra,0x4
    38c8:	840080e7          	jalr	-1984(ra) # 7104 <sbrk>
    sbrk(-10);
    38cc:	ff600513          	li	a0,-10
    38d0:	00004097          	auipc	ra,0x4
    38d4:	834080e7          	jalr	-1996(ra) # 7104 <sbrk>
    exit(0);
    38d8:	00000513          	li	a0,0
    38dc:	00003097          	auipc	ra,0x3
    38e0:	75c080e7          	jalr	1884(ra) # 7038 <exit>
    printf("fork failed\n");
    38e4:	00005517          	auipc	a0,0x5
    38e8:	b4450513          	add	a0,a0,-1212 # 8428 <malloc+0xe10>
    38ec:	00004097          	auipc	ra,0x4
    38f0:	c28080e7          	jalr	-984(ra) # 7514 <printf>
    exit(1);
    38f4:	00100513          	li	a0,1
    38f8:	00003097          	auipc	ra,0x3
    38fc:	740080e7          	jalr	1856(ra) # 7038 <exit>
  wait(0);
    3900:	00000513          	li	a0,0
    3904:	00003097          	auipc	ra,0x3
    3908:	740080e7          	jalr	1856(ra) # 7044 <wait>
  exit(0);
    390c:	00000513          	li	a0,0
    3910:	00003097          	auipc	ra,0x3
    3914:	728080e7          	jalr	1832(ra) # 7038 <exit>

0000000000003918 <sbrklast>:
{
    3918:	fd010113          	add	sp,sp,-48
    391c:	02113423          	sd	ra,40(sp)
    3920:	02813023          	sd	s0,32(sp)
    3924:	00913c23          	sd	s1,24(sp)
    3928:	01213823          	sd	s2,16(sp)
    392c:	01313423          	sd	s3,8(sp)
    3930:	01413023          	sd	s4,0(sp)
    3934:	03010413          	add	s0,sp,48
  uint64 top = (uint64) sbrk(0);
    3938:	00000513          	li	a0,0
    393c:	00003097          	auipc	ra,0x3
    3940:	7c8080e7          	jalr	1992(ra) # 7104 <sbrk>
  if((top % 4096) != 0)
    3944:	03451793          	sll	a5,a0,0x34
    3948:	0c079263          	bnez	a5,3a0c <sbrklast+0xf4>
  sbrk(4096);
    394c:	00001537          	lui	a0,0x1
    3950:	00003097          	auipc	ra,0x3
    3954:	7b4080e7          	jalr	1972(ra) # 7104 <sbrk>
  sbrk(10);
    3958:	00a00513          	li	a0,10
    395c:	00003097          	auipc	ra,0x3
    3960:	7a8080e7          	jalr	1960(ra) # 7104 <sbrk>
  sbrk(-20);
    3964:	fec00513          	li	a0,-20
    3968:	00003097          	auipc	ra,0x3
    396c:	79c080e7          	jalr	1948(ra) # 7104 <sbrk>
  top = (uint64) sbrk(0);
    3970:	00000513          	li	a0,0
    3974:	00003097          	auipc	ra,0x3
    3978:	790080e7          	jalr	1936(ra) # 7104 <sbrk>
    397c:	00050493          	mv	s1,a0
  char *p = (char *) (top - 64);
    3980:	fc050913          	add	s2,a0,-64 # fc0 <writebig+0x164>
  p[0] = 'x';
    3984:	07800a13          	li	s4,120
    3988:	fd450023          	sb	s4,-64(a0)
  p[1] = '\0';
    398c:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
    3990:	20200593          	li	a1,514
    3994:	00090513          	mv	a0,s2
    3998:	00003097          	auipc	ra,0x3
    399c:	700080e7          	jalr	1792(ra) # 7098 <open>
    39a0:	00050993          	mv	s3,a0
  write(fd, p, 1);
    39a4:	00100613          	li	a2,1
    39a8:	00090593          	mv	a1,s2
    39ac:	00003097          	auipc	ra,0x3
    39b0:	6bc080e7          	jalr	1724(ra) # 7068 <write>
  close(fd);
    39b4:	00098513          	mv	a0,s3
    39b8:	00003097          	auipc	ra,0x3
    39bc:	6bc080e7          	jalr	1724(ra) # 7074 <close>
  fd = open(p, O_RDWR);
    39c0:	00200593          	li	a1,2
    39c4:	00090513          	mv	a0,s2
    39c8:	00003097          	auipc	ra,0x3
    39cc:	6d0080e7          	jalr	1744(ra) # 7098 <open>
  p[0] = '\0';
    39d0:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    39d4:	00100613          	li	a2,1
    39d8:	00090593          	mv	a1,s2
    39dc:	00003097          	auipc	ra,0x3
    39e0:	680080e7          	jalr	1664(ra) # 705c <read>
  if(p[0] != 'x')
    39e4:	fc04c783          	lbu	a5,-64(s1)
    39e8:	03479e63          	bne	a5,s4,3a24 <sbrklast+0x10c>
}
    39ec:	02813083          	ld	ra,40(sp)
    39f0:	02013403          	ld	s0,32(sp)
    39f4:	01813483          	ld	s1,24(sp)
    39f8:	01013903          	ld	s2,16(sp)
    39fc:	00813983          	ld	s3,8(sp)
    3a00:	00013a03          	ld	s4,0(sp)
    3a04:	03010113          	add	sp,sp,48
    3a08:	00008067          	ret
    sbrk(4096 - (top % 4096));
    3a0c:	0347d513          	srl	a0,a5,0x34
    3a10:	000017b7          	lui	a5,0x1
    3a14:	40a7853b          	subw	a0,a5,a0
    3a18:	00003097          	auipc	ra,0x3
    3a1c:	6ec080e7          	jalr	1772(ra) # 7104 <sbrk>
    3a20:	f2dff06f          	j	394c <sbrklast+0x34>
    exit(1);
    3a24:	00100513          	li	a0,1
    3a28:	00003097          	auipc	ra,0x3
    3a2c:	610080e7          	jalr	1552(ra) # 7038 <exit>

0000000000003a30 <sbrk8000>:
{
    3a30:	ff010113          	add	sp,sp,-16
    3a34:	00113423          	sd	ra,8(sp)
    3a38:	00813023          	sd	s0,0(sp)
    3a3c:	01010413          	add	s0,sp,16
  sbrk(0x80000004);
    3a40:	80000537          	lui	a0,0x80000
    3a44:	00450513          	add	a0,a0,4 # ffffffff80000004 <base+0xffffffff7ffef38c>
    3a48:	00003097          	auipc	ra,0x3
    3a4c:	6bc080e7          	jalr	1724(ra) # 7104 <sbrk>
  volatile char *top = sbrk(0);
    3a50:	00000513          	li	a0,0
    3a54:	00003097          	auipc	ra,0x3
    3a58:	6b0080e7          	jalr	1712(ra) # 7104 <sbrk>
  *(top-1) = *(top-1) + 1;
    3a5c:	fff54783          	lbu	a5,-1(a0)
    3a60:	0017879b          	addw	a5,a5,1 # 1001 <writebig+0x1a5>
    3a64:	0ff7f793          	zext.b	a5,a5
    3a68:	fef50fa3          	sb	a5,-1(a0)
}
    3a6c:	00813083          	ld	ra,8(sp)
    3a70:	00013403          	ld	s0,0(sp)
    3a74:	01010113          	add	sp,sp,16
    3a78:	00008067          	ret

0000000000003a7c <execout>:
{
    3a7c:	fb010113          	add	sp,sp,-80
    3a80:	04113423          	sd	ra,72(sp)
    3a84:	04813023          	sd	s0,64(sp)
    3a88:	02913c23          	sd	s1,56(sp)
    3a8c:	03213823          	sd	s2,48(sp)
    3a90:	03313423          	sd	s3,40(sp)
    3a94:	03413023          	sd	s4,32(sp)
    3a98:	05010413          	add	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    3a9c:	00000913          	li	s2,0
    3aa0:	00f00993          	li	s3,15
    int pid = fork();
    3aa4:	00003097          	auipc	ra,0x3
    3aa8:	588080e7          	jalr	1416(ra) # 702c <fork>
    3aac:	00050493          	mv	s1,a0
    if(pid < 0){
    3ab0:	02054463          	bltz	a0,3ad8 <execout+0x5c>
    } else if(pid == 0){
    3ab4:	04050063          	beqz	a0,3af4 <execout+0x78>
      wait((int*)0);
    3ab8:	00000513          	li	a0,0
    3abc:	00003097          	auipc	ra,0x3
    3ac0:	588080e7          	jalr	1416(ra) # 7044 <wait>
  for(int avail = 0; avail < 15; avail++){
    3ac4:	0019091b          	addw	s2,s2,1
    3ac8:	fd391ee3          	bne	s2,s3,3aa4 <execout+0x28>
  exit(0);
    3acc:	00000513          	li	a0,0
    3ad0:	00003097          	auipc	ra,0x3
    3ad4:	568080e7          	jalr	1384(ra) # 7038 <exit>
      printf("fork failed\n");
    3ad8:	00005517          	auipc	a0,0x5
    3adc:	95050513          	add	a0,a0,-1712 # 8428 <malloc+0xe10>
    3ae0:	00004097          	auipc	ra,0x4
    3ae4:	a34080e7          	jalr	-1484(ra) # 7514 <printf>
      exit(1);
    3ae8:	00100513          	li	a0,1
    3aec:	00003097          	auipc	ra,0x3
    3af0:	54c080e7          	jalr	1356(ra) # 7038 <exit>
        if(a == 0xffffffffffffffffLL)
    3af4:	fff00993          	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    3af8:	00100a13          	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    3afc:	00001537          	lui	a0,0x1
    3b00:	00003097          	auipc	ra,0x3
    3b04:	604080e7          	jalr	1540(ra) # 7104 <sbrk>
        if(a == 0xffffffffffffffffLL)
    3b08:	01350a63          	beq	a0,s3,3b1c <execout+0xa0>
        *(char*)(a + 4096 - 1) = 1;
    3b0c:	000017b7          	lui	a5,0x1
    3b10:	00a787b3          	add	a5,a5,a0
    3b14:	ff478fa3          	sb	s4,-1(a5) # fff <writebig+0x1a3>
      while(1){
    3b18:	fe5ff06f          	j	3afc <execout+0x80>
      for(int i = 0; i < avail; i++)
    3b1c:	01205c63          	blez	s2,3b34 <execout+0xb8>
        sbrk(-4096);
    3b20:	fffff537          	lui	a0,0xfffff
    3b24:	00003097          	auipc	ra,0x3
    3b28:	5e0080e7          	jalr	1504(ra) # 7104 <sbrk>
      for(int i = 0; i < avail; i++)
    3b2c:	0014849b          	addw	s1,s1,1
    3b30:	ff2498e3          	bne	s1,s2,3b20 <execout+0xa4>
      close(1);
    3b34:	00100513          	li	a0,1
    3b38:	00003097          	auipc	ra,0x3
    3b3c:	53c080e7          	jalr	1340(ra) # 7074 <close>
      char *args[] = { "echo", "x", 0 };
    3b40:	00004517          	auipc	a0,0x4
    3b44:	c5850513          	add	a0,a0,-936 # 7798 <malloc+0x180>
    3b48:	faa43c23          	sd	a0,-72(s0)
    3b4c:	00004797          	auipc	a5,0x4
    3b50:	cbc78793          	add	a5,a5,-836 # 7808 <malloc+0x1f0>
    3b54:	fcf43023          	sd	a5,-64(s0)
    3b58:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    3b5c:	fb840593          	add	a1,s0,-72
    3b60:	00003097          	auipc	ra,0x3
    3b64:	52c080e7          	jalr	1324(ra) # 708c <exec>
      exit(0);
    3b68:	00000513          	li	a0,0
    3b6c:	00003097          	auipc	ra,0x3
    3b70:	4cc080e7          	jalr	1228(ra) # 7038 <exit>

0000000000003b74 <fourteen>:
{
    3b74:	fe010113          	add	sp,sp,-32
    3b78:	00113c23          	sd	ra,24(sp)
    3b7c:	00813823          	sd	s0,16(sp)
    3b80:	00913423          	sd	s1,8(sp)
    3b84:	02010413          	add	s0,sp,32
    3b88:	00050493          	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    3b8c:	00005517          	auipc	a0,0x5
    3b90:	dac50513          	add	a0,a0,-596 # 8938 <malloc+0x1320>
    3b94:	00003097          	auipc	ra,0x3
    3b98:	540080e7          	jalr	1344(ra) # 70d4 <mkdir>
    3b9c:	0e051a63          	bnez	a0,3c90 <fourteen+0x11c>
  if(mkdir("12345678901234/123456789012345") != 0){
    3ba0:	00005517          	auipc	a0,0x5
    3ba4:	bf050513          	add	a0,a0,-1040 # 8790 <malloc+0x1178>
    3ba8:	00003097          	auipc	ra,0x3
    3bac:	52c080e7          	jalr	1324(ra) # 70d4 <mkdir>
    3bb0:	10051063          	bnez	a0,3cb0 <fourteen+0x13c>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    3bb4:	20000593          	li	a1,512
    3bb8:	00005517          	auipc	a0,0x5
    3bbc:	c3050513          	add	a0,a0,-976 # 87e8 <malloc+0x11d0>
    3bc0:	00003097          	auipc	ra,0x3
    3bc4:	4d8080e7          	jalr	1240(ra) # 7098 <open>
  if(fd < 0){
    3bc8:	10054463          	bltz	a0,3cd0 <fourteen+0x15c>
  close(fd);
    3bcc:	00003097          	auipc	ra,0x3
    3bd0:	4a8080e7          	jalr	1192(ra) # 7074 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    3bd4:	00000593          	li	a1,0
    3bd8:	00005517          	auipc	a0,0x5
    3bdc:	c8850513          	add	a0,a0,-888 # 8860 <malloc+0x1248>
    3be0:	00003097          	auipc	ra,0x3
    3be4:	4b8080e7          	jalr	1208(ra) # 7098 <open>
  if(fd < 0){
    3be8:	10054463          	bltz	a0,3cf0 <fourteen+0x17c>
  close(fd);
    3bec:	00003097          	auipc	ra,0x3
    3bf0:	488080e7          	jalr	1160(ra) # 7074 <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    3bf4:	00005517          	auipc	a0,0x5
    3bf8:	cdc50513          	add	a0,a0,-804 # 88d0 <malloc+0x12b8>
    3bfc:	00003097          	auipc	ra,0x3
    3c00:	4d8080e7          	jalr	1240(ra) # 70d4 <mkdir>
    3c04:	10050663          	beqz	a0,3d10 <fourteen+0x19c>
  if(mkdir("123456789012345/12345678901234") == 0){
    3c08:	00005517          	auipc	a0,0x5
    3c0c:	d2050513          	add	a0,a0,-736 # 8928 <malloc+0x1310>
    3c10:	00003097          	auipc	ra,0x3
    3c14:	4c4080e7          	jalr	1220(ra) # 70d4 <mkdir>
    3c18:	10050c63          	beqz	a0,3d30 <fourteen+0x1bc>
  unlink("123456789012345/12345678901234");
    3c1c:	00005517          	auipc	a0,0x5
    3c20:	d0c50513          	add	a0,a0,-756 # 8928 <malloc+0x1310>
    3c24:	00003097          	auipc	ra,0x3
    3c28:	48c080e7          	jalr	1164(ra) # 70b0 <unlink>
  unlink("12345678901234/12345678901234");
    3c2c:	00005517          	auipc	a0,0x5
    3c30:	ca450513          	add	a0,a0,-860 # 88d0 <malloc+0x12b8>
    3c34:	00003097          	auipc	ra,0x3
    3c38:	47c080e7          	jalr	1148(ra) # 70b0 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    3c3c:	00005517          	auipc	a0,0x5
    3c40:	c2450513          	add	a0,a0,-988 # 8860 <malloc+0x1248>
    3c44:	00003097          	auipc	ra,0x3
    3c48:	46c080e7          	jalr	1132(ra) # 70b0 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    3c4c:	00005517          	auipc	a0,0x5
    3c50:	b9c50513          	add	a0,a0,-1124 # 87e8 <malloc+0x11d0>
    3c54:	00003097          	auipc	ra,0x3
    3c58:	45c080e7          	jalr	1116(ra) # 70b0 <unlink>
  unlink("12345678901234/123456789012345");
    3c5c:	00005517          	auipc	a0,0x5
    3c60:	b3450513          	add	a0,a0,-1228 # 8790 <malloc+0x1178>
    3c64:	00003097          	auipc	ra,0x3
    3c68:	44c080e7          	jalr	1100(ra) # 70b0 <unlink>
  unlink("12345678901234");
    3c6c:	00005517          	auipc	a0,0x5
    3c70:	ccc50513          	add	a0,a0,-820 # 8938 <malloc+0x1320>
    3c74:	00003097          	auipc	ra,0x3
    3c78:	43c080e7          	jalr	1084(ra) # 70b0 <unlink>
}
    3c7c:	01813083          	ld	ra,24(sp)
    3c80:	01013403          	ld	s0,16(sp)
    3c84:	00813483          	ld	s1,8(sp)
    3c88:	02010113          	add	sp,sp,32
    3c8c:	00008067          	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    3c90:	00048593          	mv	a1,s1
    3c94:	00005517          	auipc	a0,0x5
    3c98:	ad450513          	add	a0,a0,-1324 # 8768 <malloc+0x1150>
    3c9c:	00004097          	auipc	ra,0x4
    3ca0:	878080e7          	jalr	-1928(ra) # 7514 <printf>
    exit(1);
    3ca4:	00100513          	li	a0,1
    3ca8:	00003097          	auipc	ra,0x3
    3cac:	390080e7          	jalr	912(ra) # 7038 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    3cb0:	00048593          	mv	a1,s1
    3cb4:	00005517          	auipc	a0,0x5
    3cb8:	afc50513          	add	a0,a0,-1284 # 87b0 <malloc+0x1198>
    3cbc:	00004097          	auipc	ra,0x4
    3cc0:	858080e7          	jalr	-1960(ra) # 7514 <printf>
    exit(1);
    3cc4:	00100513          	li	a0,1
    3cc8:	00003097          	auipc	ra,0x3
    3ccc:	370080e7          	jalr	880(ra) # 7038 <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    3cd0:	00048593          	mv	a1,s1
    3cd4:	00005517          	auipc	a0,0x5
    3cd8:	b4450513          	add	a0,a0,-1212 # 8818 <malloc+0x1200>
    3cdc:	00004097          	auipc	ra,0x4
    3ce0:	838080e7          	jalr	-1992(ra) # 7514 <printf>
    exit(1);
    3ce4:	00100513          	li	a0,1
    3ce8:	00003097          	auipc	ra,0x3
    3cec:	350080e7          	jalr	848(ra) # 7038 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    3cf0:	00048593          	mv	a1,s1
    3cf4:	00005517          	auipc	a0,0x5
    3cf8:	b9c50513          	add	a0,a0,-1124 # 8890 <malloc+0x1278>
    3cfc:	00004097          	auipc	ra,0x4
    3d00:	818080e7          	jalr	-2024(ra) # 7514 <printf>
    exit(1);
    3d04:	00100513          	li	a0,1
    3d08:	00003097          	auipc	ra,0x3
    3d0c:	330080e7          	jalr	816(ra) # 7038 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    3d10:	00048593          	mv	a1,s1
    3d14:	00005517          	auipc	a0,0x5
    3d18:	bdc50513          	add	a0,a0,-1060 # 88f0 <malloc+0x12d8>
    3d1c:	00003097          	auipc	ra,0x3
    3d20:	7f8080e7          	jalr	2040(ra) # 7514 <printf>
    exit(1);
    3d24:	00100513          	li	a0,1
    3d28:	00003097          	auipc	ra,0x3
    3d2c:	310080e7          	jalr	784(ra) # 7038 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    3d30:	00048593          	mv	a1,s1
    3d34:	00005517          	auipc	a0,0x5
    3d38:	c1450513          	add	a0,a0,-1004 # 8948 <malloc+0x1330>
    3d3c:	00003097          	auipc	ra,0x3
    3d40:	7d8080e7          	jalr	2008(ra) # 7514 <printf>
    exit(1);
    3d44:	00100513          	li	a0,1
    3d48:	00003097          	auipc	ra,0x3
    3d4c:	2f0080e7          	jalr	752(ra) # 7038 <exit>

0000000000003d50 <diskfull>:
{
    3d50:	b9010113          	add	sp,sp,-1136
    3d54:	46113423          	sd	ra,1128(sp)
    3d58:	46813023          	sd	s0,1120(sp)
    3d5c:	44913c23          	sd	s1,1112(sp)
    3d60:	45213823          	sd	s2,1104(sp)
    3d64:	45313423          	sd	s3,1096(sp)
    3d68:	45413023          	sd	s4,1088(sp)
    3d6c:	43513c23          	sd	s5,1080(sp)
    3d70:	43613823          	sd	s6,1072(sp)
    3d74:	43713423          	sd	s7,1064(sp)
    3d78:	43813023          	sd	s8,1056(sp)
    3d7c:	47010413          	add	s0,sp,1136
    3d80:	00050c13          	mv	s8,a0
  unlink("diskfulldir");
    3d84:	00005517          	auipc	a0,0x5
    3d88:	bfc50513          	add	a0,a0,-1028 # 8980 <malloc+0x1368>
    3d8c:	00003097          	auipc	ra,0x3
    3d90:	324080e7          	jalr	804(ra) # 70b0 <unlink>
  for(fi = 0; done == 0; fi++){
    3d94:	00000a13          	li	s4,0
    name[0] = 'b';
    3d98:	06200b13          	li	s6,98
    name[1] = 'i';
    3d9c:	06900a93          	li	s5,105
    name[2] = 'g';
    3da0:	06700993          	li	s3,103
    3da4:	10c00b93          	li	s7,268
    3da8:	1a40006f          	j	3f4c <diskfull+0x1fc>
      printf("%s: could not create file %s\n", s, name);
    3dac:	b9040613          	add	a2,s0,-1136
    3db0:	000c0593          	mv	a1,s8
    3db4:	00005517          	auipc	a0,0x5
    3db8:	bdc50513          	add	a0,a0,-1060 # 8990 <malloc+0x1378>
    3dbc:	00003097          	auipc	ra,0x3
    3dc0:	758080e7          	jalr	1880(ra) # 7514 <printf>
      break;
    3dc4:	0200006f          	j	3de4 <diskfull+0x94>
        close(fd);
    3dc8:	00090513          	mv	a0,s2
    3dcc:	00003097          	auipc	ra,0x3
    3dd0:	2a8080e7          	jalr	680(ra) # 7074 <close>
    close(fd);
    3dd4:	00090513          	mv	a0,s2
    3dd8:	00003097          	auipc	ra,0x3
    3ddc:	29c080e7          	jalr	668(ra) # 7074 <close>
  for(fi = 0; done == 0; fi++){
    3de0:	001a0a1b          	addw	s4,s4,1
  for(int i = 0; i < nzz; i++){
    3de4:	00000493          	li	s1,0
    name[0] = 'z';
    3de8:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    3dec:	08000993          	li	s3,128
    name[0] = 'z';
    3df0:	bb240823          	sb	s2,-1104(s0)
    name[1] = 'z';
    3df4:	bb2408a3          	sb	s2,-1103(s0)
    name[2] = '0' + (i / 32);
    3df8:	41f4d71b          	sraw	a4,s1,0x1f
    3dfc:	01b7571b          	srlw	a4,a4,0x1b
    3e00:	009707bb          	addw	a5,a4,s1
    3e04:	4057d69b          	sraw	a3,a5,0x5
    3e08:	0306869b          	addw	a3,a3,48
    3e0c:	bad40923          	sb	a3,-1102(s0)
    name[3] = '0' + (i % 32);
    3e10:	01f7f793          	and	a5,a5,31
    3e14:	40e787bb          	subw	a5,a5,a4
    3e18:	0307879b          	addw	a5,a5,48
    3e1c:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    3e20:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    3e24:	bb040513          	add	a0,s0,-1104
    3e28:	00003097          	auipc	ra,0x3
    3e2c:	288080e7          	jalr	648(ra) # 70b0 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    3e30:	60200593          	li	a1,1538
    3e34:	bb040513          	add	a0,s0,-1104
    3e38:	00003097          	auipc	ra,0x3
    3e3c:	260080e7          	jalr	608(ra) # 7098 <open>
    if(fd < 0)
    3e40:	00054a63          	bltz	a0,3e54 <diskfull+0x104>
    close(fd);
    3e44:	00003097          	auipc	ra,0x3
    3e48:	230080e7          	jalr	560(ra) # 7074 <close>
  for(int i = 0; i < nzz; i++){
    3e4c:	0014849b          	addw	s1,s1,1
    3e50:	fb3490e3          	bne	s1,s3,3df0 <diskfull+0xa0>
  if(mkdir("diskfulldir") == 0)
    3e54:	00005517          	auipc	a0,0x5
    3e58:	b2c50513          	add	a0,a0,-1236 # 8980 <malloc+0x1368>
    3e5c:	00003097          	auipc	ra,0x3
    3e60:	278080e7          	jalr	632(ra) # 70d4 <mkdir>
    3e64:	14050863          	beqz	a0,3fb4 <diskfull+0x264>
  unlink("diskfulldir");
    3e68:	00005517          	auipc	a0,0x5
    3e6c:	b1850513          	add	a0,a0,-1256 # 8980 <malloc+0x1368>
    3e70:	00003097          	auipc	ra,0x3
    3e74:	240080e7          	jalr	576(ra) # 70b0 <unlink>
  for(int i = 0; i < nzz; i++){
    3e78:	00000493          	li	s1,0
    name[0] = 'z';
    3e7c:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    3e80:	08000993          	li	s3,128
    name[0] = 'z';
    3e84:	bb240823          	sb	s2,-1104(s0)
    name[1] = 'z';
    3e88:	bb2408a3          	sb	s2,-1103(s0)
    name[2] = '0' + (i / 32);
    3e8c:	41f4d71b          	sraw	a4,s1,0x1f
    3e90:	01b7571b          	srlw	a4,a4,0x1b
    3e94:	009707bb          	addw	a5,a4,s1
    3e98:	4057d69b          	sraw	a3,a5,0x5
    3e9c:	0306869b          	addw	a3,a3,48
    3ea0:	bad40923          	sb	a3,-1102(s0)
    name[3] = '0' + (i % 32);
    3ea4:	01f7f793          	and	a5,a5,31
    3ea8:	40e787bb          	subw	a5,a5,a4
    3eac:	0307879b          	addw	a5,a5,48
    3eb0:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    3eb4:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    3eb8:	bb040513          	add	a0,s0,-1104
    3ebc:	00003097          	auipc	ra,0x3
    3ec0:	1f4080e7          	jalr	500(ra) # 70b0 <unlink>
  for(int i = 0; i < nzz; i++){
    3ec4:	0014849b          	addw	s1,s1,1
    3ec8:	fb349ee3          	bne	s1,s3,3e84 <diskfull+0x134>
  for(int i = 0; i < fi; i++){
    3ecc:	05405063          	blez	s4,3f0c <diskfull+0x1bc>
    3ed0:	00000493          	li	s1,0
    name[0] = 'b';
    3ed4:	06200a93          	li	s5,98
    name[1] = 'i';
    3ed8:	06900993          	li	s3,105
    name[2] = 'g';
    3edc:	06700913          	li	s2,103
    name[0] = 'b';
    3ee0:	bb540823          	sb	s5,-1104(s0)
    name[1] = 'i';
    3ee4:	bb3408a3          	sb	s3,-1103(s0)
    name[2] = 'g';
    3ee8:	bb240923          	sb	s2,-1102(s0)
    name[3] = '0' + i;
    3eec:	0304879b          	addw	a5,s1,48
    3ef0:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    3ef4:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    3ef8:	bb040513          	add	a0,s0,-1104
    3efc:	00003097          	auipc	ra,0x3
    3f00:	1b4080e7          	jalr	436(ra) # 70b0 <unlink>
  for(int i = 0; i < fi; i++){
    3f04:	0014849b          	addw	s1,s1,1
    3f08:	fd449ce3          	bne	s1,s4,3ee0 <diskfull+0x190>
}
    3f0c:	46813083          	ld	ra,1128(sp)
    3f10:	46013403          	ld	s0,1120(sp)
    3f14:	45813483          	ld	s1,1112(sp)
    3f18:	45013903          	ld	s2,1104(sp)
    3f1c:	44813983          	ld	s3,1096(sp)
    3f20:	44013a03          	ld	s4,1088(sp)
    3f24:	43813a83          	ld	s5,1080(sp)
    3f28:	43013b03          	ld	s6,1072(sp)
    3f2c:	42813b83          	ld	s7,1064(sp)
    3f30:	42013c03          	ld	s8,1056(sp)
    3f34:	47010113          	add	sp,sp,1136
    3f38:	00008067          	ret
    close(fd);
    3f3c:	00090513          	mv	a0,s2
    3f40:	00003097          	auipc	ra,0x3
    3f44:	134080e7          	jalr	308(ra) # 7074 <close>
  for(fi = 0; done == 0; fi++){
    3f48:	001a0a1b          	addw	s4,s4,1
    name[0] = 'b';
    3f4c:	b9640823          	sb	s6,-1136(s0)
    name[1] = 'i';
    3f50:	b95408a3          	sb	s5,-1135(s0)
    name[2] = 'g';
    3f54:	b9340923          	sb	s3,-1134(s0)
    name[3] = '0' + fi;
    3f58:	030a079b          	addw	a5,s4,48
    3f5c:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    3f60:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    3f64:	b9040513          	add	a0,s0,-1136
    3f68:	00003097          	auipc	ra,0x3
    3f6c:	148080e7          	jalr	328(ra) # 70b0 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    3f70:	60200593          	li	a1,1538
    3f74:	b9040513          	add	a0,s0,-1136
    3f78:	00003097          	auipc	ra,0x3
    3f7c:	120080e7          	jalr	288(ra) # 7098 <open>
    3f80:	00050913          	mv	s2,a0
    if(fd < 0){
    3f84:	e20544e3          	bltz	a0,3dac <diskfull+0x5c>
    3f88:	000b8493          	mv	s1,s7
      if(write(fd, buf, BSIZE) != BSIZE){
    3f8c:	40000613          	li	a2,1024
    3f90:	bb040593          	add	a1,s0,-1104
    3f94:	00090513          	mv	a0,s2
    3f98:	00003097          	auipc	ra,0x3
    3f9c:	0d0080e7          	jalr	208(ra) # 7068 <write>
    3fa0:	40000793          	li	a5,1024
    3fa4:	e2f512e3          	bne	a0,a5,3dc8 <diskfull+0x78>
    for(int i = 0; i < MAXFILE; i++){
    3fa8:	fff4849b          	addw	s1,s1,-1
    3fac:	fe0490e3          	bnez	s1,3f8c <diskfull+0x23c>
    3fb0:	f8dff06f          	j	3f3c <diskfull+0x1ec>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n");
    3fb4:	00005517          	auipc	a0,0x5
    3fb8:	9fc50513          	add	a0,a0,-1540 # 89b0 <malloc+0x1398>
    3fbc:	00003097          	auipc	ra,0x3
    3fc0:	558080e7          	jalr	1368(ra) # 7514 <printf>
    3fc4:	ea5ff06f          	j	3e68 <diskfull+0x118>

0000000000003fc8 <iputtest>:
{
    3fc8:	fe010113          	add	sp,sp,-32
    3fcc:	00113c23          	sd	ra,24(sp)
    3fd0:	00813823          	sd	s0,16(sp)
    3fd4:	00913423          	sd	s1,8(sp)
    3fd8:	02010413          	add	s0,sp,32
    3fdc:	00050493          	mv	s1,a0
  if(mkdir("iputdir") < 0){
    3fe0:	00005517          	auipc	a0,0x5
    3fe4:	a0050513          	add	a0,a0,-1536 # 89e0 <malloc+0x13c8>
    3fe8:	00003097          	auipc	ra,0x3
    3fec:	0ec080e7          	jalr	236(ra) # 70d4 <mkdir>
    3ff0:	04054a63          	bltz	a0,4044 <iputtest+0x7c>
  if(chdir("iputdir") < 0){
    3ff4:	00005517          	auipc	a0,0x5
    3ff8:	9ec50513          	add	a0,a0,-1556 # 89e0 <malloc+0x13c8>
    3ffc:	00003097          	auipc	ra,0x3
    4000:	0e4080e7          	jalr	228(ra) # 70e0 <chdir>
    4004:	06054063          	bltz	a0,4064 <iputtest+0x9c>
  if(unlink("../iputdir") < 0){
    4008:	00005517          	auipc	a0,0x5
    400c:	a1850513          	add	a0,a0,-1512 # 8a20 <malloc+0x1408>
    4010:	00003097          	auipc	ra,0x3
    4014:	0a0080e7          	jalr	160(ra) # 70b0 <unlink>
    4018:	06054663          	bltz	a0,4084 <iputtest+0xbc>
  if(chdir("/") < 0){
    401c:	00005517          	auipc	a0,0x5
    4020:	a3450513          	add	a0,a0,-1484 # 8a50 <malloc+0x1438>
    4024:	00003097          	auipc	ra,0x3
    4028:	0bc080e7          	jalr	188(ra) # 70e0 <chdir>
    402c:	06054c63          	bltz	a0,40a4 <iputtest+0xdc>
}
    4030:	01813083          	ld	ra,24(sp)
    4034:	01013403          	ld	s0,16(sp)
    4038:	00813483          	ld	s1,8(sp)
    403c:	02010113          	add	sp,sp,32
    4040:	00008067          	ret
    printf("%s: mkdir failed\n", s);
    4044:	00048593          	mv	a1,s1
    4048:	00005517          	auipc	a0,0x5
    404c:	9a050513          	add	a0,a0,-1632 # 89e8 <malloc+0x13d0>
    4050:	00003097          	auipc	ra,0x3
    4054:	4c4080e7          	jalr	1220(ra) # 7514 <printf>
    exit(1);
    4058:	00100513          	li	a0,1
    405c:	00003097          	auipc	ra,0x3
    4060:	fdc080e7          	jalr	-36(ra) # 7038 <exit>
    printf("%s: chdir iputdir failed\n", s);
    4064:	00048593          	mv	a1,s1
    4068:	00005517          	auipc	a0,0x5
    406c:	99850513          	add	a0,a0,-1640 # 8a00 <malloc+0x13e8>
    4070:	00003097          	auipc	ra,0x3
    4074:	4a4080e7          	jalr	1188(ra) # 7514 <printf>
    exit(1);
    4078:	00100513          	li	a0,1
    407c:	00003097          	auipc	ra,0x3
    4080:	fbc080e7          	jalr	-68(ra) # 7038 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    4084:	00048593          	mv	a1,s1
    4088:	00005517          	auipc	a0,0x5
    408c:	9a850513          	add	a0,a0,-1624 # 8a30 <malloc+0x1418>
    4090:	00003097          	auipc	ra,0x3
    4094:	484080e7          	jalr	1156(ra) # 7514 <printf>
    exit(1);
    4098:	00100513          	li	a0,1
    409c:	00003097          	auipc	ra,0x3
    40a0:	f9c080e7          	jalr	-100(ra) # 7038 <exit>
    printf("%s: chdir / failed\n", s);
    40a4:	00048593          	mv	a1,s1
    40a8:	00005517          	auipc	a0,0x5
    40ac:	9b050513          	add	a0,a0,-1616 # 8a58 <malloc+0x1440>
    40b0:	00003097          	auipc	ra,0x3
    40b4:	464080e7          	jalr	1124(ra) # 7514 <printf>
    exit(1);
    40b8:	00100513          	li	a0,1
    40bc:	00003097          	auipc	ra,0x3
    40c0:	f7c080e7          	jalr	-132(ra) # 7038 <exit>

00000000000040c4 <exitiputtest>:
{
    40c4:	fd010113          	add	sp,sp,-48
    40c8:	02113423          	sd	ra,40(sp)
    40cc:	02813023          	sd	s0,32(sp)
    40d0:	00913c23          	sd	s1,24(sp)
    40d4:	03010413          	add	s0,sp,48
    40d8:	00050493          	mv	s1,a0
  pid = fork();
    40dc:	00003097          	auipc	ra,0x3
    40e0:	f50080e7          	jalr	-176(ra) # 702c <fork>
  if(pid < 0){
    40e4:	04054863          	bltz	a0,4134 <exitiputtest+0x70>
  if(pid == 0){
    40e8:	0c051663          	bnez	a0,41b4 <exitiputtest+0xf0>
    if(mkdir("iputdir") < 0){
    40ec:	00005517          	auipc	a0,0x5
    40f0:	8f450513          	add	a0,a0,-1804 # 89e0 <malloc+0x13c8>
    40f4:	00003097          	auipc	ra,0x3
    40f8:	fe0080e7          	jalr	-32(ra) # 70d4 <mkdir>
    40fc:	04054c63          	bltz	a0,4154 <exitiputtest+0x90>
    if(chdir("iputdir") < 0){
    4100:	00005517          	auipc	a0,0x5
    4104:	8e050513          	add	a0,a0,-1824 # 89e0 <malloc+0x13c8>
    4108:	00003097          	auipc	ra,0x3
    410c:	fd8080e7          	jalr	-40(ra) # 70e0 <chdir>
    4110:	06054263          	bltz	a0,4174 <exitiputtest+0xb0>
    if(unlink("../iputdir") < 0){
    4114:	00005517          	auipc	a0,0x5
    4118:	90c50513          	add	a0,a0,-1780 # 8a20 <malloc+0x1408>
    411c:	00003097          	auipc	ra,0x3
    4120:	f94080e7          	jalr	-108(ra) # 70b0 <unlink>
    4124:	06054863          	bltz	a0,4194 <exitiputtest+0xd0>
    exit(0);
    4128:	00000513          	li	a0,0
    412c:	00003097          	auipc	ra,0x3
    4130:	f0c080e7          	jalr	-244(ra) # 7038 <exit>
    printf("%s: fork failed\n", s);
    4134:	00048593          	mv	a1,s1
    4138:	00004517          	auipc	a0,0x4
    413c:	ee850513          	add	a0,a0,-280 # 8020 <malloc+0xa08>
    4140:	00003097          	auipc	ra,0x3
    4144:	3d4080e7          	jalr	980(ra) # 7514 <printf>
    exit(1);
    4148:	00100513          	li	a0,1
    414c:	00003097          	auipc	ra,0x3
    4150:	eec080e7          	jalr	-276(ra) # 7038 <exit>
      printf("%s: mkdir failed\n", s);
    4154:	00048593          	mv	a1,s1
    4158:	00005517          	auipc	a0,0x5
    415c:	89050513          	add	a0,a0,-1904 # 89e8 <malloc+0x13d0>
    4160:	00003097          	auipc	ra,0x3
    4164:	3b4080e7          	jalr	948(ra) # 7514 <printf>
      exit(1);
    4168:	00100513          	li	a0,1
    416c:	00003097          	auipc	ra,0x3
    4170:	ecc080e7          	jalr	-308(ra) # 7038 <exit>
      printf("%s: child chdir failed\n", s);
    4174:	00048593          	mv	a1,s1
    4178:	00005517          	auipc	a0,0x5
    417c:	8f850513          	add	a0,a0,-1800 # 8a70 <malloc+0x1458>
    4180:	00003097          	auipc	ra,0x3
    4184:	394080e7          	jalr	916(ra) # 7514 <printf>
      exit(1);
    4188:	00100513          	li	a0,1
    418c:	00003097          	auipc	ra,0x3
    4190:	eac080e7          	jalr	-340(ra) # 7038 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    4194:	00048593          	mv	a1,s1
    4198:	00005517          	auipc	a0,0x5
    419c:	89850513          	add	a0,a0,-1896 # 8a30 <malloc+0x1418>
    41a0:	00003097          	auipc	ra,0x3
    41a4:	374080e7          	jalr	884(ra) # 7514 <printf>
      exit(1);
    41a8:	00100513          	li	a0,1
    41ac:	00003097          	auipc	ra,0x3
    41b0:	e8c080e7          	jalr	-372(ra) # 7038 <exit>
  wait(&xstatus);
    41b4:	fdc40513          	add	a0,s0,-36
    41b8:	00003097          	auipc	ra,0x3
    41bc:	e8c080e7          	jalr	-372(ra) # 7044 <wait>
  exit(xstatus);
    41c0:	fdc42503          	lw	a0,-36(s0)
    41c4:	00003097          	auipc	ra,0x3
    41c8:	e74080e7          	jalr	-396(ra) # 7038 <exit>

00000000000041cc <dirtest>:
{
    41cc:	fe010113          	add	sp,sp,-32
    41d0:	00113c23          	sd	ra,24(sp)
    41d4:	00813823          	sd	s0,16(sp)
    41d8:	00913423          	sd	s1,8(sp)
    41dc:	02010413          	add	s0,sp,32
    41e0:	00050493          	mv	s1,a0
  if(mkdir("dir0") < 0){
    41e4:	00005517          	auipc	a0,0x5
    41e8:	8a450513          	add	a0,a0,-1884 # 8a88 <malloc+0x1470>
    41ec:	00003097          	auipc	ra,0x3
    41f0:	ee8080e7          	jalr	-280(ra) # 70d4 <mkdir>
    41f4:	04054a63          	bltz	a0,4248 <dirtest+0x7c>
  if(chdir("dir0") < 0){
    41f8:	00005517          	auipc	a0,0x5
    41fc:	89050513          	add	a0,a0,-1904 # 8a88 <malloc+0x1470>
    4200:	00003097          	auipc	ra,0x3
    4204:	ee0080e7          	jalr	-288(ra) # 70e0 <chdir>
    4208:	06054063          	bltz	a0,4268 <dirtest+0x9c>
  if(chdir("..") < 0){
    420c:	00005517          	auipc	a0,0x5
    4210:	89c50513          	add	a0,a0,-1892 # 8aa8 <malloc+0x1490>
    4214:	00003097          	auipc	ra,0x3
    4218:	ecc080e7          	jalr	-308(ra) # 70e0 <chdir>
    421c:	06054663          	bltz	a0,4288 <dirtest+0xbc>
  if(unlink("dir0") < 0){
    4220:	00005517          	auipc	a0,0x5
    4224:	86850513          	add	a0,a0,-1944 # 8a88 <malloc+0x1470>
    4228:	00003097          	auipc	ra,0x3
    422c:	e88080e7          	jalr	-376(ra) # 70b0 <unlink>
    4230:	06054c63          	bltz	a0,42a8 <dirtest+0xdc>
}
    4234:	01813083          	ld	ra,24(sp)
    4238:	01013403          	ld	s0,16(sp)
    423c:	00813483          	ld	s1,8(sp)
    4240:	02010113          	add	sp,sp,32
    4244:	00008067          	ret
    printf("%s: mkdir failed\n", s);
    4248:	00048593          	mv	a1,s1
    424c:	00004517          	auipc	a0,0x4
    4250:	79c50513          	add	a0,a0,1948 # 89e8 <malloc+0x13d0>
    4254:	00003097          	auipc	ra,0x3
    4258:	2c0080e7          	jalr	704(ra) # 7514 <printf>
    exit(1);
    425c:	00100513          	li	a0,1
    4260:	00003097          	auipc	ra,0x3
    4264:	dd8080e7          	jalr	-552(ra) # 7038 <exit>
    printf("%s: chdir dir0 failed\n", s);
    4268:	00048593          	mv	a1,s1
    426c:	00005517          	auipc	a0,0x5
    4270:	82450513          	add	a0,a0,-2012 # 8a90 <malloc+0x1478>
    4274:	00003097          	auipc	ra,0x3
    4278:	2a0080e7          	jalr	672(ra) # 7514 <printf>
    exit(1);
    427c:	00100513          	li	a0,1
    4280:	00003097          	auipc	ra,0x3
    4284:	db8080e7          	jalr	-584(ra) # 7038 <exit>
    printf("%s: chdir .. failed\n", s);
    4288:	00048593          	mv	a1,s1
    428c:	00005517          	auipc	a0,0x5
    4290:	82450513          	add	a0,a0,-2012 # 8ab0 <malloc+0x1498>
    4294:	00003097          	auipc	ra,0x3
    4298:	280080e7          	jalr	640(ra) # 7514 <printf>
    exit(1);
    429c:	00100513          	li	a0,1
    42a0:	00003097          	auipc	ra,0x3
    42a4:	d98080e7          	jalr	-616(ra) # 7038 <exit>
    printf("%s: unlink dir0 failed\n", s);
    42a8:	00048593          	mv	a1,s1
    42ac:	00005517          	auipc	a0,0x5
    42b0:	81c50513          	add	a0,a0,-2020 # 8ac8 <malloc+0x14b0>
    42b4:	00003097          	auipc	ra,0x3
    42b8:	260080e7          	jalr	608(ra) # 7514 <printf>
    exit(1);
    42bc:	00100513          	li	a0,1
    42c0:	00003097          	auipc	ra,0x3
    42c4:	d78080e7          	jalr	-648(ra) # 7038 <exit>

00000000000042c8 <subdir>:
{
    42c8:	fe010113          	add	sp,sp,-32
    42cc:	00113c23          	sd	ra,24(sp)
    42d0:	00813823          	sd	s0,16(sp)
    42d4:	00913423          	sd	s1,8(sp)
    42d8:	01213023          	sd	s2,0(sp)
    42dc:	02010413          	add	s0,sp,32
    42e0:	00050913          	mv	s2,a0
  unlink("ff");
    42e4:	00005517          	auipc	a0,0x5
    42e8:	92c50513          	add	a0,a0,-1748 # 8c10 <malloc+0x15f8>
    42ec:	00003097          	auipc	ra,0x3
    42f0:	dc4080e7          	jalr	-572(ra) # 70b0 <unlink>
  if(mkdir("dd") != 0){
    42f4:	00004517          	auipc	a0,0x4
    42f8:	7ec50513          	add	a0,a0,2028 # 8ae0 <malloc+0x14c8>
    42fc:	00003097          	auipc	ra,0x3
    4300:	dd8080e7          	jalr	-552(ra) # 70d4 <mkdir>
    4304:	3c051063          	bnez	a0,46c4 <subdir+0x3fc>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    4308:	20200593          	li	a1,514
    430c:	00004517          	auipc	a0,0x4
    4310:	7f450513          	add	a0,a0,2036 # 8b00 <malloc+0x14e8>
    4314:	00003097          	auipc	ra,0x3
    4318:	d84080e7          	jalr	-636(ra) # 7098 <open>
    431c:	00050493          	mv	s1,a0
  if(fd < 0){
    4320:	3c054263          	bltz	a0,46e4 <subdir+0x41c>
  write(fd, "ff", 2);
    4324:	00200613          	li	a2,2
    4328:	00005597          	auipc	a1,0x5
    432c:	8e858593          	add	a1,a1,-1816 # 8c10 <malloc+0x15f8>
    4330:	00003097          	auipc	ra,0x3
    4334:	d38080e7          	jalr	-712(ra) # 7068 <write>
  close(fd);
    4338:	00048513          	mv	a0,s1
    433c:	00003097          	auipc	ra,0x3
    4340:	d38080e7          	jalr	-712(ra) # 7074 <close>
  if(unlink("dd") >= 0){
    4344:	00004517          	auipc	a0,0x4
    4348:	79c50513          	add	a0,a0,1948 # 8ae0 <malloc+0x14c8>
    434c:	00003097          	auipc	ra,0x3
    4350:	d64080e7          	jalr	-668(ra) # 70b0 <unlink>
    4354:	3a055863          	bgez	a0,4704 <subdir+0x43c>
  if(mkdir("/dd/dd") != 0){
    4358:	00005517          	auipc	a0,0x5
    435c:	80050513          	add	a0,a0,-2048 # 8b58 <malloc+0x1540>
    4360:	00003097          	auipc	ra,0x3
    4364:	d74080e7          	jalr	-652(ra) # 70d4 <mkdir>
    4368:	3a051e63          	bnez	a0,4724 <subdir+0x45c>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    436c:	20200593          	li	a1,514
    4370:	00005517          	auipc	a0,0x5
    4374:	81050513          	add	a0,a0,-2032 # 8b80 <malloc+0x1568>
    4378:	00003097          	auipc	ra,0x3
    437c:	d20080e7          	jalr	-736(ra) # 7098 <open>
    4380:	00050493          	mv	s1,a0
  if(fd < 0){
    4384:	3c054063          	bltz	a0,4744 <subdir+0x47c>
  write(fd, "FF", 2);
    4388:	00200613          	li	a2,2
    438c:	00005597          	auipc	a1,0x5
    4390:	82458593          	add	a1,a1,-2012 # 8bb0 <malloc+0x1598>
    4394:	00003097          	auipc	ra,0x3
    4398:	cd4080e7          	jalr	-812(ra) # 7068 <write>
  close(fd);
    439c:	00048513          	mv	a0,s1
    43a0:	00003097          	auipc	ra,0x3
    43a4:	cd4080e7          	jalr	-812(ra) # 7074 <close>
  fd = open("dd/dd/../ff", 0);
    43a8:	00000593          	li	a1,0
    43ac:	00005517          	auipc	a0,0x5
    43b0:	80c50513          	add	a0,a0,-2036 # 8bb8 <malloc+0x15a0>
    43b4:	00003097          	auipc	ra,0x3
    43b8:	ce4080e7          	jalr	-796(ra) # 7098 <open>
    43bc:	00050493          	mv	s1,a0
  if(fd < 0){
    43c0:	3a054263          	bltz	a0,4764 <subdir+0x49c>
  cc = read(fd, buf, sizeof(buf));
    43c4:	00003637          	lui	a2,0x3
    43c8:	0000a597          	auipc	a1,0xa
    43cc:	8b058593          	add	a1,a1,-1872 # dc78 <buf>
    43d0:	00003097          	auipc	ra,0x3
    43d4:	c8c080e7          	jalr	-884(ra) # 705c <read>
  if(cc != 2 || buf[0] != 'f'){
    43d8:	00200793          	li	a5,2
    43dc:	3af51463          	bne	a0,a5,4784 <subdir+0x4bc>
    43e0:	0000a717          	auipc	a4,0xa
    43e4:	89874703          	lbu	a4,-1896(a4) # dc78 <buf>
    43e8:	06600793          	li	a5,102
    43ec:	38f71c63          	bne	a4,a5,4784 <subdir+0x4bc>
  close(fd);
    43f0:	00048513          	mv	a0,s1
    43f4:	00003097          	auipc	ra,0x3
    43f8:	c80080e7          	jalr	-896(ra) # 7074 <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    43fc:	00005597          	auipc	a1,0x5
    4400:	80c58593          	add	a1,a1,-2036 # 8c08 <malloc+0x15f0>
    4404:	00004517          	auipc	a0,0x4
    4408:	77c50513          	add	a0,a0,1916 # 8b80 <malloc+0x1568>
    440c:	00003097          	auipc	ra,0x3
    4410:	cbc080e7          	jalr	-836(ra) # 70c8 <link>
    4414:	38051863          	bnez	a0,47a4 <subdir+0x4dc>
  if(unlink("dd/dd/ff") != 0){
    4418:	00004517          	auipc	a0,0x4
    441c:	76850513          	add	a0,a0,1896 # 8b80 <malloc+0x1568>
    4420:	00003097          	auipc	ra,0x3
    4424:	c90080e7          	jalr	-880(ra) # 70b0 <unlink>
    4428:	38051e63          	bnez	a0,47c4 <subdir+0x4fc>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    442c:	00000593          	li	a1,0
    4430:	00004517          	auipc	a0,0x4
    4434:	75050513          	add	a0,a0,1872 # 8b80 <malloc+0x1568>
    4438:	00003097          	auipc	ra,0x3
    443c:	c60080e7          	jalr	-928(ra) # 7098 <open>
    4440:	3a055263          	bgez	a0,47e4 <subdir+0x51c>
  if(chdir("dd") != 0){
    4444:	00004517          	auipc	a0,0x4
    4448:	69c50513          	add	a0,a0,1692 # 8ae0 <malloc+0x14c8>
    444c:	00003097          	auipc	ra,0x3
    4450:	c94080e7          	jalr	-876(ra) # 70e0 <chdir>
    4454:	3a051863          	bnez	a0,4804 <subdir+0x53c>
  if(chdir("dd/../../dd") != 0){
    4458:	00005517          	auipc	a0,0x5
    445c:	84850513          	add	a0,a0,-1976 # 8ca0 <malloc+0x1688>
    4460:	00003097          	auipc	ra,0x3
    4464:	c80080e7          	jalr	-896(ra) # 70e0 <chdir>
    4468:	3a051e63          	bnez	a0,4824 <subdir+0x55c>
  if(chdir("dd/../../../dd") != 0){
    446c:	00005517          	auipc	a0,0x5
    4470:	86450513          	add	a0,a0,-1948 # 8cd0 <malloc+0x16b8>
    4474:	00003097          	auipc	ra,0x3
    4478:	c6c080e7          	jalr	-916(ra) # 70e0 <chdir>
    447c:	3c051463          	bnez	a0,4844 <subdir+0x57c>
  if(chdir("./..") != 0){
    4480:	00005517          	auipc	a0,0x5
    4484:	88050513          	add	a0,a0,-1920 # 8d00 <malloc+0x16e8>
    4488:	00003097          	auipc	ra,0x3
    448c:	c58080e7          	jalr	-936(ra) # 70e0 <chdir>
    4490:	3c051a63          	bnez	a0,4864 <subdir+0x59c>
  fd = open("dd/dd/ffff", 0);
    4494:	00000593          	li	a1,0
    4498:	00004517          	auipc	a0,0x4
    449c:	77050513          	add	a0,a0,1904 # 8c08 <malloc+0x15f0>
    44a0:	00003097          	auipc	ra,0x3
    44a4:	bf8080e7          	jalr	-1032(ra) # 7098 <open>
    44a8:	00050493          	mv	s1,a0
  if(fd < 0){
    44ac:	3c054c63          	bltz	a0,4884 <subdir+0x5bc>
  if(read(fd, buf, sizeof(buf)) != 2){
    44b0:	00003637          	lui	a2,0x3
    44b4:	00009597          	auipc	a1,0x9
    44b8:	7c458593          	add	a1,a1,1988 # dc78 <buf>
    44bc:	00003097          	auipc	ra,0x3
    44c0:	ba0080e7          	jalr	-1120(ra) # 705c <read>
    44c4:	00200793          	li	a5,2
    44c8:	3cf51e63          	bne	a0,a5,48a4 <subdir+0x5dc>
  close(fd);
    44cc:	00048513          	mv	a0,s1
    44d0:	00003097          	auipc	ra,0x3
    44d4:	ba4080e7          	jalr	-1116(ra) # 7074 <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    44d8:	00000593          	li	a1,0
    44dc:	00004517          	auipc	a0,0x4
    44e0:	6a450513          	add	a0,a0,1700 # 8b80 <malloc+0x1568>
    44e4:	00003097          	auipc	ra,0x3
    44e8:	bb4080e7          	jalr	-1100(ra) # 7098 <open>
    44ec:	3c055c63          	bgez	a0,48c4 <subdir+0x5fc>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    44f0:	20200593          	li	a1,514
    44f4:	00005517          	auipc	a0,0x5
    44f8:	89c50513          	add	a0,a0,-1892 # 8d90 <malloc+0x1778>
    44fc:	00003097          	auipc	ra,0x3
    4500:	b9c080e7          	jalr	-1124(ra) # 7098 <open>
    4504:	3e055063          	bgez	a0,48e4 <subdir+0x61c>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    4508:	20200593          	li	a1,514
    450c:	00005517          	auipc	a0,0x5
    4510:	8b450513          	add	a0,a0,-1868 # 8dc0 <malloc+0x17a8>
    4514:	00003097          	auipc	ra,0x3
    4518:	b84080e7          	jalr	-1148(ra) # 7098 <open>
    451c:	3e055463          	bgez	a0,4904 <subdir+0x63c>
  if(open("dd", O_CREATE) >= 0){
    4520:	20000593          	li	a1,512
    4524:	00004517          	auipc	a0,0x4
    4528:	5bc50513          	add	a0,a0,1468 # 8ae0 <malloc+0x14c8>
    452c:	00003097          	auipc	ra,0x3
    4530:	b6c080e7          	jalr	-1172(ra) # 7098 <open>
    4534:	3e055863          	bgez	a0,4924 <subdir+0x65c>
  if(open("dd", O_RDWR) >= 0){
    4538:	00200593          	li	a1,2
    453c:	00004517          	auipc	a0,0x4
    4540:	5a450513          	add	a0,a0,1444 # 8ae0 <malloc+0x14c8>
    4544:	00003097          	auipc	ra,0x3
    4548:	b54080e7          	jalr	-1196(ra) # 7098 <open>
    454c:	3e055c63          	bgez	a0,4944 <subdir+0x67c>
  if(open("dd", O_WRONLY) >= 0){
    4550:	00100593          	li	a1,1
    4554:	00004517          	auipc	a0,0x4
    4558:	58c50513          	add	a0,a0,1420 # 8ae0 <malloc+0x14c8>
    455c:	00003097          	auipc	ra,0x3
    4560:	b3c080e7          	jalr	-1220(ra) # 7098 <open>
    4564:	40055063          	bgez	a0,4964 <subdir+0x69c>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    4568:	00005597          	auipc	a1,0x5
    456c:	8e858593          	add	a1,a1,-1816 # 8e50 <malloc+0x1838>
    4570:	00005517          	auipc	a0,0x5
    4574:	82050513          	add	a0,a0,-2016 # 8d90 <malloc+0x1778>
    4578:	00003097          	auipc	ra,0x3
    457c:	b50080e7          	jalr	-1200(ra) # 70c8 <link>
    4580:	40050263          	beqz	a0,4984 <subdir+0x6bc>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    4584:	00005597          	auipc	a1,0x5
    4588:	8cc58593          	add	a1,a1,-1844 # 8e50 <malloc+0x1838>
    458c:	00005517          	auipc	a0,0x5
    4590:	83450513          	add	a0,a0,-1996 # 8dc0 <malloc+0x17a8>
    4594:	00003097          	auipc	ra,0x3
    4598:	b34080e7          	jalr	-1228(ra) # 70c8 <link>
    459c:	40050463          	beqz	a0,49a4 <subdir+0x6dc>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    45a0:	00004597          	auipc	a1,0x4
    45a4:	66858593          	add	a1,a1,1640 # 8c08 <malloc+0x15f0>
    45a8:	00004517          	auipc	a0,0x4
    45ac:	55850513          	add	a0,a0,1368 # 8b00 <malloc+0x14e8>
    45b0:	00003097          	auipc	ra,0x3
    45b4:	b18080e7          	jalr	-1256(ra) # 70c8 <link>
    45b8:	40050663          	beqz	a0,49c4 <subdir+0x6fc>
  if(mkdir("dd/ff/ff") == 0){
    45bc:	00004517          	auipc	a0,0x4
    45c0:	7d450513          	add	a0,a0,2004 # 8d90 <malloc+0x1778>
    45c4:	00003097          	auipc	ra,0x3
    45c8:	b10080e7          	jalr	-1264(ra) # 70d4 <mkdir>
    45cc:	40050c63          	beqz	a0,49e4 <subdir+0x71c>
  if(mkdir("dd/xx/ff") == 0){
    45d0:	00004517          	auipc	a0,0x4
    45d4:	7f050513          	add	a0,a0,2032 # 8dc0 <malloc+0x17a8>
    45d8:	00003097          	auipc	ra,0x3
    45dc:	afc080e7          	jalr	-1284(ra) # 70d4 <mkdir>
    45e0:	42050263          	beqz	a0,4a04 <subdir+0x73c>
  if(mkdir("dd/dd/ffff") == 0){
    45e4:	00004517          	auipc	a0,0x4
    45e8:	62450513          	add	a0,a0,1572 # 8c08 <malloc+0x15f0>
    45ec:	00003097          	auipc	ra,0x3
    45f0:	ae8080e7          	jalr	-1304(ra) # 70d4 <mkdir>
    45f4:	42050863          	beqz	a0,4a24 <subdir+0x75c>
  if(unlink("dd/xx/ff") == 0){
    45f8:	00004517          	auipc	a0,0x4
    45fc:	7c850513          	add	a0,a0,1992 # 8dc0 <malloc+0x17a8>
    4600:	00003097          	auipc	ra,0x3
    4604:	ab0080e7          	jalr	-1360(ra) # 70b0 <unlink>
    4608:	42050e63          	beqz	a0,4a44 <subdir+0x77c>
  if(unlink("dd/ff/ff") == 0){
    460c:	00004517          	auipc	a0,0x4
    4610:	78450513          	add	a0,a0,1924 # 8d90 <malloc+0x1778>
    4614:	00003097          	auipc	ra,0x3
    4618:	a9c080e7          	jalr	-1380(ra) # 70b0 <unlink>
    461c:	44050463          	beqz	a0,4a64 <subdir+0x79c>
  if(chdir("dd/ff") == 0){
    4620:	00004517          	auipc	a0,0x4
    4624:	4e050513          	add	a0,a0,1248 # 8b00 <malloc+0x14e8>
    4628:	00003097          	auipc	ra,0x3
    462c:	ab8080e7          	jalr	-1352(ra) # 70e0 <chdir>
    4630:	44050a63          	beqz	a0,4a84 <subdir+0x7bc>
  if(chdir("dd/xx") == 0){
    4634:	00005517          	auipc	a0,0x5
    4638:	96c50513          	add	a0,a0,-1684 # 8fa0 <malloc+0x1988>
    463c:	00003097          	auipc	ra,0x3
    4640:	aa4080e7          	jalr	-1372(ra) # 70e0 <chdir>
    4644:	46050063          	beqz	a0,4aa4 <subdir+0x7dc>
  if(unlink("dd/dd/ffff") != 0){
    4648:	00004517          	auipc	a0,0x4
    464c:	5c050513          	add	a0,a0,1472 # 8c08 <malloc+0x15f0>
    4650:	00003097          	auipc	ra,0x3
    4654:	a60080e7          	jalr	-1440(ra) # 70b0 <unlink>
    4658:	46051663          	bnez	a0,4ac4 <subdir+0x7fc>
  if(unlink("dd/ff") != 0){
    465c:	00004517          	auipc	a0,0x4
    4660:	4a450513          	add	a0,a0,1188 # 8b00 <malloc+0x14e8>
    4664:	00003097          	auipc	ra,0x3
    4668:	a4c080e7          	jalr	-1460(ra) # 70b0 <unlink>
    466c:	46051c63          	bnez	a0,4ae4 <subdir+0x81c>
  if(unlink("dd") == 0){
    4670:	00004517          	auipc	a0,0x4
    4674:	47050513          	add	a0,a0,1136 # 8ae0 <malloc+0x14c8>
    4678:	00003097          	auipc	ra,0x3
    467c:	a38080e7          	jalr	-1480(ra) # 70b0 <unlink>
    4680:	48050263          	beqz	a0,4b04 <subdir+0x83c>
  if(unlink("dd/dd") < 0){
    4684:	00005517          	auipc	a0,0x5
    4688:	98c50513          	add	a0,a0,-1652 # 9010 <malloc+0x19f8>
    468c:	00003097          	auipc	ra,0x3
    4690:	a24080e7          	jalr	-1500(ra) # 70b0 <unlink>
    4694:	48054863          	bltz	a0,4b24 <subdir+0x85c>
  if(unlink("dd") < 0){
    4698:	00004517          	auipc	a0,0x4
    469c:	44850513          	add	a0,a0,1096 # 8ae0 <malloc+0x14c8>
    46a0:	00003097          	auipc	ra,0x3
    46a4:	a10080e7          	jalr	-1520(ra) # 70b0 <unlink>
    46a8:	48054e63          	bltz	a0,4b44 <subdir+0x87c>
}
    46ac:	01813083          	ld	ra,24(sp)
    46b0:	01013403          	ld	s0,16(sp)
    46b4:	00813483          	ld	s1,8(sp)
    46b8:	00013903          	ld	s2,0(sp)
    46bc:	02010113          	add	sp,sp,32
    46c0:	00008067          	ret
    printf("%s: mkdir dd failed\n", s);
    46c4:	00090593          	mv	a1,s2
    46c8:	00004517          	auipc	a0,0x4
    46cc:	42050513          	add	a0,a0,1056 # 8ae8 <malloc+0x14d0>
    46d0:	00003097          	auipc	ra,0x3
    46d4:	e44080e7          	jalr	-444(ra) # 7514 <printf>
    exit(1);
    46d8:	00100513          	li	a0,1
    46dc:	00003097          	auipc	ra,0x3
    46e0:	95c080e7          	jalr	-1700(ra) # 7038 <exit>
    printf("%s: create dd/ff failed\n", s);
    46e4:	00090593          	mv	a1,s2
    46e8:	00004517          	auipc	a0,0x4
    46ec:	42050513          	add	a0,a0,1056 # 8b08 <malloc+0x14f0>
    46f0:	00003097          	auipc	ra,0x3
    46f4:	e24080e7          	jalr	-476(ra) # 7514 <printf>
    exit(1);
    46f8:	00100513          	li	a0,1
    46fc:	00003097          	auipc	ra,0x3
    4700:	93c080e7          	jalr	-1732(ra) # 7038 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    4704:	00090593          	mv	a1,s2
    4708:	00004517          	auipc	a0,0x4
    470c:	42050513          	add	a0,a0,1056 # 8b28 <malloc+0x1510>
    4710:	00003097          	auipc	ra,0x3
    4714:	e04080e7          	jalr	-508(ra) # 7514 <printf>
    exit(1);
    4718:	00100513          	li	a0,1
    471c:	00003097          	auipc	ra,0x3
    4720:	91c080e7          	jalr	-1764(ra) # 7038 <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    4724:	00090593          	mv	a1,s2
    4728:	00004517          	auipc	a0,0x4
    472c:	43850513          	add	a0,a0,1080 # 8b60 <malloc+0x1548>
    4730:	00003097          	auipc	ra,0x3
    4734:	de4080e7          	jalr	-540(ra) # 7514 <printf>
    exit(1);
    4738:	00100513          	li	a0,1
    473c:	00003097          	auipc	ra,0x3
    4740:	8fc080e7          	jalr	-1796(ra) # 7038 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    4744:	00090593          	mv	a1,s2
    4748:	00004517          	auipc	a0,0x4
    474c:	44850513          	add	a0,a0,1096 # 8b90 <malloc+0x1578>
    4750:	00003097          	auipc	ra,0x3
    4754:	dc4080e7          	jalr	-572(ra) # 7514 <printf>
    exit(1);
    4758:	00100513          	li	a0,1
    475c:	00003097          	auipc	ra,0x3
    4760:	8dc080e7          	jalr	-1828(ra) # 7038 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    4764:	00090593          	mv	a1,s2
    4768:	00004517          	auipc	a0,0x4
    476c:	46050513          	add	a0,a0,1120 # 8bc8 <malloc+0x15b0>
    4770:	00003097          	auipc	ra,0x3
    4774:	da4080e7          	jalr	-604(ra) # 7514 <printf>
    exit(1);
    4778:	00100513          	li	a0,1
    477c:	00003097          	auipc	ra,0x3
    4780:	8bc080e7          	jalr	-1860(ra) # 7038 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    4784:	00090593          	mv	a1,s2
    4788:	00004517          	auipc	a0,0x4
    478c:	46050513          	add	a0,a0,1120 # 8be8 <malloc+0x15d0>
    4790:	00003097          	auipc	ra,0x3
    4794:	d84080e7          	jalr	-636(ra) # 7514 <printf>
    exit(1);
    4798:	00100513          	li	a0,1
    479c:	00003097          	auipc	ra,0x3
    47a0:	89c080e7          	jalr	-1892(ra) # 7038 <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    47a4:	00090593          	mv	a1,s2
    47a8:	00004517          	auipc	a0,0x4
    47ac:	47050513          	add	a0,a0,1136 # 8c18 <malloc+0x1600>
    47b0:	00003097          	auipc	ra,0x3
    47b4:	d64080e7          	jalr	-668(ra) # 7514 <printf>
    exit(1);
    47b8:	00100513          	li	a0,1
    47bc:	00003097          	auipc	ra,0x3
    47c0:	87c080e7          	jalr	-1924(ra) # 7038 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    47c4:	00090593          	mv	a1,s2
    47c8:	00004517          	auipc	a0,0x4
    47cc:	47850513          	add	a0,a0,1144 # 8c40 <malloc+0x1628>
    47d0:	00003097          	auipc	ra,0x3
    47d4:	d44080e7          	jalr	-700(ra) # 7514 <printf>
    exit(1);
    47d8:	00100513          	li	a0,1
    47dc:	00003097          	auipc	ra,0x3
    47e0:	85c080e7          	jalr	-1956(ra) # 7038 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    47e4:	00090593          	mv	a1,s2
    47e8:	00004517          	auipc	a0,0x4
    47ec:	47850513          	add	a0,a0,1144 # 8c60 <malloc+0x1648>
    47f0:	00003097          	auipc	ra,0x3
    47f4:	d24080e7          	jalr	-732(ra) # 7514 <printf>
    exit(1);
    47f8:	00100513          	li	a0,1
    47fc:	00003097          	auipc	ra,0x3
    4800:	83c080e7          	jalr	-1988(ra) # 7038 <exit>
    printf("%s: chdir dd failed\n", s);
    4804:	00090593          	mv	a1,s2
    4808:	00004517          	auipc	a0,0x4
    480c:	48050513          	add	a0,a0,1152 # 8c88 <malloc+0x1670>
    4810:	00003097          	auipc	ra,0x3
    4814:	d04080e7          	jalr	-764(ra) # 7514 <printf>
    exit(1);
    4818:	00100513          	li	a0,1
    481c:	00003097          	auipc	ra,0x3
    4820:	81c080e7          	jalr	-2020(ra) # 7038 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    4824:	00090593          	mv	a1,s2
    4828:	00004517          	auipc	a0,0x4
    482c:	48850513          	add	a0,a0,1160 # 8cb0 <malloc+0x1698>
    4830:	00003097          	auipc	ra,0x3
    4834:	ce4080e7          	jalr	-796(ra) # 7514 <printf>
    exit(1);
    4838:	00100513          	li	a0,1
    483c:	00002097          	auipc	ra,0x2
    4840:	7fc080e7          	jalr	2044(ra) # 7038 <exit>
    printf("chdir dd/../../dd failed\n", s);
    4844:	00090593          	mv	a1,s2
    4848:	00004517          	auipc	a0,0x4
    484c:	49850513          	add	a0,a0,1176 # 8ce0 <malloc+0x16c8>
    4850:	00003097          	auipc	ra,0x3
    4854:	cc4080e7          	jalr	-828(ra) # 7514 <printf>
    exit(1);
    4858:	00100513          	li	a0,1
    485c:	00002097          	auipc	ra,0x2
    4860:	7dc080e7          	jalr	2012(ra) # 7038 <exit>
    printf("%s: chdir ./.. failed\n", s);
    4864:	00090593          	mv	a1,s2
    4868:	00004517          	auipc	a0,0x4
    486c:	4a050513          	add	a0,a0,1184 # 8d08 <malloc+0x16f0>
    4870:	00003097          	auipc	ra,0x3
    4874:	ca4080e7          	jalr	-860(ra) # 7514 <printf>
    exit(1);
    4878:	00100513          	li	a0,1
    487c:	00002097          	auipc	ra,0x2
    4880:	7bc080e7          	jalr	1980(ra) # 7038 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    4884:	00090593          	mv	a1,s2
    4888:	00004517          	auipc	a0,0x4
    488c:	49850513          	add	a0,a0,1176 # 8d20 <malloc+0x1708>
    4890:	00003097          	auipc	ra,0x3
    4894:	c84080e7          	jalr	-892(ra) # 7514 <printf>
    exit(1);
    4898:	00100513          	li	a0,1
    489c:	00002097          	auipc	ra,0x2
    48a0:	79c080e7          	jalr	1948(ra) # 7038 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    48a4:	00090593          	mv	a1,s2
    48a8:	00004517          	auipc	a0,0x4
    48ac:	49850513          	add	a0,a0,1176 # 8d40 <malloc+0x1728>
    48b0:	00003097          	auipc	ra,0x3
    48b4:	c64080e7          	jalr	-924(ra) # 7514 <printf>
    exit(1);
    48b8:	00100513          	li	a0,1
    48bc:	00002097          	auipc	ra,0x2
    48c0:	77c080e7          	jalr	1916(ra) # 7038 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    48c4:	00090593          	mv	a1,s2
    48c8:	00004517          	auipc	a0,0x4
    48cc:	49850513          	add	a0,a0,1176 # 8d60 <malloc+0x1748>
    48d0:	00003097          	auipc	ra,0x3
    48d4:	c44080e7          	jalr	-956(ra) # 7514 <printf>
    exit(1);
    48d8:	00100513          	li	a0,1
    48dc:	00002097          	auipc	ra,0x2
    48e0:	75c080e7          	jalr	1884(ra) # 7038 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    48e4:	00090593          	mv	a1,s2
    48e8:	00004517          	auipc	a0,0x4
    48ec:	4b850513          	add	a0,a0,1208 # 8da0 <malloc+0x1788>
    48f0:	00003097          	auipc	ra,0x3
    48f4:	c24080e7          	jalr	-988(ra) # 7514 <printf>
    exit(1);
    48f8:	00100513          	li	a0,1
    48fc:	00002097          	auipc	ra,0x2
    4900:	73c080e7          	jalr	1852(ra) # 7038 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    4904:	00090593          	mv	a1,s2
    4908:	00004517          	auipc	a0,0x4
    490c:	4c850513          	add	a0,a0,1224 # 8dd0 <malloc+0x17b8>
    4910:	00003097          	auipc	ra,0x3
    4914:	c04080e7          	jalr	-1020(ra) # 7514 <printf>
    exit(1);
    4918:	00100513          	li	a0,1
    491c:	00002097          	auipc	ra,0x2
    4920:	71c080e7          	jalr	1820(ra) # 7038 <exit>
    printf("%s: create dd succeeded!\n", s);
    4924:	00090593          	mv	a1,s2
    4928:	00004517          	auipc	a0,0x4
    492c:	4c850513          	add	a0,a0,1224 # 8df0 <malloc+0x17d8>
    4930:	00003097          	auipc	ra,0x3
    4934:	be4080e7          	jalr	-1052(ra) # 7514 <printf>
    exit(1);
    4938:	00100513          	li	a0,1
    493c:	00002097          	auipc	ra,0x2
    4940:	6fc080e7          	jalr	1788(ra) # 7038 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    4944:	00090593          	mv	a1,s2
    4948:	00004517          	auipc	a0,0x4
    494c:	4c850513          	add	a0,a0,1224 # 8e10 <malloc+0x17f8>
    4950:	00003097          	auipc	ra,0x3
    4954:	bc4080e7          	jalr	-1084(ra) # 7514 <printf>
    exit(1);
    4958:	00100513          	li	a0,1
    495c:	00002097          	auipc	ra,0x2
    4960:	6dc080e7          	jalr	1756(ra) # 7038 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    4964:	00090593          	mv	a1,s2
    4968:	00004517          	auipc	a0,0x4
    496c:	4c850513          	add	a0,a0,1224 # 8e30 <malloc+0x1818>
    4970:	00003097          	auipc	ra,0x3
    4974:	ba4080e7          	jalr	-1116(ra) # 7514 <printf>
    exit(1);
    4978:	00100513          	li	a0,1
    497c:	00002097          	auipc	ra,0x2
    4980:	6bc080e7          	jalr	1724(ra) # 7038 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    4984:	00090593          	mv	a1,s2
    4988:	00004517          	auipc	a0,0x4
    498c:	4d850513          	add	a0,a0,1240 # 8e60 <malloc+0x1848>
    4990:	00003097          	auipc	ra,0x3
    4994:	b84080e7          	jalr	-1148(ra) # 7514 <printf>
    exit(1);
    4998:	00100513          	li	a0,1
    499c:	00002097          	auipc	ra,0x2
    49a0:	69c080e7          	jalr	1692(ra) # 7038 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    49a4:	00090593          	mv	a1,s2
    49a8:	00004517          	auipc	a0,0x4
    49ac:	4e050513          	add	a0,a0,1248 # 8e88 <malloc+0x1870>
    49b0:	00003097          	auipc	ra,0x3
    49b4:	b64080e7          	jalr	-1180(ra) # 7514 <printf>
    exit(1);
    49b8:	00100513          	li	a0,1
    49bc:	00002097          	auipc	ra,0x2
    49c0:	67c080e7          	jalr	1660(ra) # 7038 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    49c4:	00090593          	mv	a1,s2
    49c8:	00004517          	auipc	a0,0x4
    49cc:	4e850513          	add	a0,a0,1256 # 8eb0 <malloc+0x1898>
    49d0:	00003097          	auipc	ra,0x3
    49d4:	b44080e7          	jalr	-1212(ra) # 7514 <printf>
    exit(1);
    49d8:	00100513          	li	a0,1
    49dc:	00002097          	auipc	ra,0x2
    49e0:	65c080e7          	jalr	1628(ra) # 7038 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    49e4:	00090593          	mv	a1,s2
    49e8:	00004517          	auipc	a0,0x4
    49ec:	4f050513          	add	a0,a0,1264 # 8ed8 <malloc+0x18c0>
    49f0:	00003097          	auipc	ra,0x3
    49f4:	b24080e7          	jalr	-1244(ra) # 7514 <printf>
    exit(1);
    49f8:	00100513          	li	a0,1
    49fc:	00002097          	auipc	ra,0x2
    4a00:	63c080e7          	jalr	1596(ra) # 7038 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    4a04:	00090593          	mv	a1,s2
    4a08:	00004517          	auipc	a0,0x4
    4a0c:	4f050513          	add	a0,a0,1264 # 8ef8 <malloc+0x18e0>
    4a10:	00003097          	auipc	ra,0x3
    4a14:	b04080e7          	jalr	-1276(ra) # 7514 <printf>
    exit(1);
    4a18:	00100513          	li	a0,1
    4a1c:	00002097          	auipc	ra,0x2
    4a20:	61c080e7          	jalr	1564(ra) # 7038 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    4a24:	00090593          	mv	a1,s2
    4a28:	00004517          	auipc	a0,0x4
    4a2c:	4f050513          	add	a0,a0,1264 # 8f18 <malloc+0x1900>
    4a30:	00003097          	auipc	ra,0x3
    4a34:	ae4080e7          	jalr	-1308(ra) # 7514 <printf>
    exit(1);
    4a38:	00100513          	li	a0,1
    4a3c:	00002097          	auipc	ra,0x2
    4a40:	5fc080e7          	jalr	1532(ra) # 7038 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    4a44:	00090593          	mv	a1,s2
    4a48:	00004517          	auipc	a0,0x4
    4a4c:	4f850513          	add	a0,a0,1272 # 8f40 <malloc+0x1928>
    4a50:	00003097          	auipc	ra,0x3
    4a54:	ac4080e7          	jalr	-1340(ra) # 7514 <printf>
    exit(1);
    4a58:	00100513          	li	a0,1
    4a5c:	00002097          	auipc	ra,0x2
    4a60:	5dc080e7          	jalr	1500(ra) # 7038 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    4a64:	00090593          	mv	a1,s2
    4a68:	00004517          	auipc	a0,0x4
    4a6c:	4f850513          	add	a0,a0,1272 # 8f60 <malloc+0x1948>
    4a70:	00003097          	auipc	ra,0x3
    4a74:	aa4080e7          	jalr	-1372(ra) # 7514 <printf>
    exit(1);
    4a78:	00100513          	li	a0,1
    4a7c:	00002097          	auipc	ra,0x2
    4a80:	5bc080e7          	jalr	1468(ra) # 7038 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    4a84:	00090593          	mv	a1,s2
    4a88:	00004517          	auipc	a0,0x4
    4a8c:	4f850513          	add	a0,a0,1272 # 8f80 <malloc+0x1968>
    4a90:	00003097          	auipc	ra,0x3
    4a94:	a84080e7          	jalr	-1404(ra) # 7514 <printf>
    exit(1);
    4a98:	00100513          	li	a0,1
    4a9c:	00002097          	auipc	ra,0x2
    4aa0:	59c080e7          	jalr	1436(ra) # 7038 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    4aa4:	00090593          	mv	a1,s2
    4aa8:	00004517          	auipc	a0,0x4
    4aac:	50050513          	add	a0,a0,1280 # 8fa8 <malloc+0x1990>
    4ab0:	00003097          	auipc	ra,0x3
    4ab4:	a64080e7          	jalr	-1436(ra) # 7514 <printf>
    exit(1);
    4ab8:	00100513          	li	a0,1
    4abc:	00002097          	auipc	ra,0x2
    4ac0:	57c080e7          	jalr	1404(ra) # 7038 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    4ac4:	00090593          	mv	a1,s2
    4ac8:	00004517          	auipc	a0,0x4
    4acc:	17850513          	add	a0,a0,376 # 8c40 <malloc+0x1628>
    4ad0:	00003097          	auipc	ra,0x3
    4ad4:	a44080e7          	jalr	-1468(ra) # 7514 <printf>
    exit(1);
    4ad8:	00100513          	li	a0,1
    4adc:	00002097          	auipc	ra,0x2
    4ae0:	55c080e7          	jalr	1372(ra) # 7038 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    4ae4:	00090593          	mv	a1,s2
    4ae8:	00004517          	auipc	a0,0x4
    4aec:	4e050513          	add	a0,a0,1248 # 8fc8 <malloc+0x19b0>
    4af0:	00003097          	auipc	ra,0x3
    4af4:	a24080e7          	jalr	-1500(ra) # 7514 <printf>
    exit(1);
    4af8:	00100513          	li	a0,1
    4afc:	00002097          	auipc	ra,0x2
    4b00:	53c080e7          	jalr	1340(ra) # 7038 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    4b04:	00090593          	mv	a1,s2
    4b08:	00004517          	auipc	a0,0x4
    4b0c:	4e050513          	add	a0,a0,1248 # 8fe8 <malloc+0x19d0>
    4b10:	00003097          	auipc	ra,0x3
    4b14:	a04080e7          	jalr	-1532(ra) # 7514 <printf>
    exit(1);
    4b18:	00100513          	li	a0,1
    4b1c:	00002097          	auipc	ra,0x2
    4b20:	51c080e7          	jalr	1308(ra) # 7038 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    4b24:	00090593          	mv	a1,s2
    4b28:	00004517          	auipc	a0,0x4
    4b2c:	4f050513          	add	a0,a0,1264 # 9018 <malloc+0x1a00>
    4b30:	00003097          	auipc	ra,0x3
    4b34:	9e4080e7          	jalr	-1564(ra) # 7514 <printf>
    exit(1);
    4b38:	00100513          	li	a0,1
    4b3c:	00002097          	auipc	ra,0x2
    4b40:	4fc080e7          	jalr	1276(ra) # 7038 <exit>
    printf("%s: unlink dd failed\n", s);
    4b44:	00090593          	mv	a1,s2
    4b48:	00004517          	auipc	a0,0x4
    4b4c:	4f050513          	add	a0,a0,1264 # 9038 <malloc+0x1a20>
    4b50:	00003097          	auipc	ra,0x3
    4b54:	9c4080e7          	jalr	-1596(ra) # 7514 <printf>
    exit(1);
    4b58:	00100513          	li	a0,1
    4b5c:	00002097          	auipc	ra,0x2
    4b60:	4dc080e7          	jalr	1244(ra) # 7038 <exit>

0000000000004b64 <rmdot>:
{
    4b64:	fe010113          	add	sp,sp,-32
    4b68:	00113c23          	sd	ra,24(sp)
    4b6c:	00813823          	sd	s0,16(sp)
    4b70:	00913423          	sd	s1,8(sp)
    4b74:	02010413          	add	s0,sp,32
    4b78:	00050493          	mv	s1,a0
  if(mkdir("dots") != 0){
    4b7c:	00004517          	auipc	a0,0x4
    4b80:	4d450513          	add	a0,a0,1236 # 9050 <malloc+0x1a38>
    4b84:	00002097          	auipc	ra,0x2
    4b88:	550080e7          	jalr	1360(ra) # 70d4 <mkdir>
    4b8c:	0a051263          	bnez	a0,4c30 <rmdot+0xcc>
  if(chdir("dots") != 0){
    4b90:	00004517          	auipc	a0,0x4
    4b94:	4c050513          	add	a0,a0,1216 # 9050 <malloc+0x1a38>
    4b98:	00002097          	auipc	ra,0x2
    4b9c:	548080e7          	jalr	1352(ra) # 70e0 <chdir>
    4ba0:	0a051863          	bnez	a0,4c50 <rmdot+0xec>
  if(unlink(".") == 0){
    4ba4:	00003517          	auipc	a0,0x3
    4ba8:	2dc50513          	add	a0,a0,732 # 7e80 <malloc+0x868>
    4bac:	00002097          	auipc	ra,0x2
    4bb0:	504080e7          	jalr	1284(ra) # 70b0 <unlink>
    4bb4:	0a050e63          	beqz	a0,4c70 <rmdot+0x10c>
  if(unlink("..") == 0){
    4bb8:	00004517          	auipc	a0,0x4
    4bbc:	ef050513          	add	a0,a0,-272 # 8aa8 <malloc+0x1490>
    4bc0:	00002097          	auipc	ra,0x2
    4bc4:	4f0080e7          	jalr	1264(ra) # 70b0 <unlink>
    4bc8:	0c050463          	beqz	a0,4c90 <rmdot+0x12c>
  if(chdir("/") != 0){
    4bcc:	00004517          	auipc	a0,0x4
    4bd0:	e8450513          	add	a0,a0,-380 # 8a50 <malloc+0x1438>
    4bd4:	00002097          	auipc	ra,0x2
    4bd8:	50c080e7          	jalr	1292(ra) # 70e0 <chdir>
    4bdc:	0c051a63          	bnez	a0,4cb0 <rmdot+0x14c>
  if(unlink("dots/.") == 0){
    4be0:	00004517          	auipc	a0,0x4
    4be4:	4d850513          	add	a0,a0,1240 # 90b8 <malloc+0x1aa0>
    4be8:	00002097          	auipc	ra,0x2
    4bec:	4c8080e7          	jalr	1224(ra) # 70b0 <unlink>
    4bf0:	0e050063          	beqz	a0,4cd0 <rmdot+0x16c>
  if(unlink("dots/..") == 0){
    4bf4:	00004517          	auipc	a0,0x4
    4bf8:	4ec50513          	add	a0,a0,1260 # 90e0 <malloc+0x1ac8>
    4bfc:	00002097          	auipc	ra,0x2
    4c00:	4b4080e7          	jalr	1204(ra) # 70b0 <unlink>
    4c04:	0e050663          	beqz	a0,4cf0 <rmdot+0x18c>
  if(unlink("dots") != 0){
    4c08:	00004517          	auipc	a0,0x4
    4c0c:	44850513          	add	a0,a0,1096 # 9050 <malloc+0x1a38>
    4c10:	00002097          	auipc	ra,0x2
    4c14:	4a0080e7          	jalr	1184(ra) # 70b0 <unlink>
    4c18:	0e051c63          	bnez	a0,4d10 <rmdot+0x1ac>
}
    4c1c:	01813083          	ld	ra,24(sp)
    4c20:	01013403          	ld	s0,16(sp)
    4c24:	00813483          	ld	s1,8(sp)
    4c28:	02010113          	add	sp,sp,32
    4c2c:	00008067          	ret
    printf("%s: mkdir dots failed\n", s);
    4c30:	00048593          	mv	a1,s1
    4c34:	00004517          	auipc	a0,0x4
    4c38:	42450513          	add	a0,a0,1060 # 9058 <malloc+0x1a40>
    4c3c:	00003097          	auipc	ra,0x3
    4c40:	8d8080e7          	jalr	-1832(ra) # 7514 <printf>
    exit(1);
    4c44:	00100513          	li	a0,1
    4c48:	00002097          	auipc	ra,0x2
    4c4c:	3f0080e7          	jalr	1008(ra) # 7038 <exit>
    printf("%s: chdir dots failed\n", s);
    4c50:	00048593          	mv	a1,s1
    4c54:	00004517          	auipc	a0,0x4
    4c58:	41c50513          	add	a0,a0,1052 # 9070 <malloc+0x1a58>
    4c5c:	00003097          	auipc	ra,0x3
    4c60:	8b8080e7          	jalr	-1864(ra) # 7514 <printf>
    exit(1);
    4c64:	00100513          	li	a0,1
    4c68:	00002097          	auipc	ra,0x2
    4c6c:	3d0080e7          	jalr	976(ra) # 7038 <exit>
    printf("%s: rm . worked!\n", s);
    4c70:	00048593          	mv	a1,s1
    4c74:	00004517          	auipc	a0,0x4
    4c78:	41450513          	add	a0,a0,1044 # 9088 <malloc+0x1a70>
    4c7c:	00003097          	auipc	ra,0x3
    4c80:	898080e7          	jalr	-1896(ra) # 7514 <printf>
    exit(1);
    4c84:	00100513          	li	a0,1
    4c88:	00002097          	auipc	ra,0x2
    4c8c:	3b0080e7          	jalr	944(ra) # 7038 <exit>
    printf("%s: rm .. worked!\n", s);
    4c90:	00048593          	mv	a1,s1
    4c94:	00004517          	auipc	a0,0x4
    4c98:	40c50513          	add	a0,a0,1036 # 90a0 <malloc+0x1a88>
    4c9c:	00003097          	auipc	ra,0x3
    4ca0:	878080e7          	jalr	-1928(ra) # 7514 <printf>
    exit(1);
    4ca4:	00100513          	li	a0,1
    4ca8:	00002097          	auipc	ra,0x2
    4cac:	390080e7          	jalr	912(ra) # 7038 <exit>
    printf("%s: chdir / failed\n", s);
    4cb0:	00048593          	mv	a1,s1
    4cb4:	00004517          	auipc	a0,0x4
    4cb8:	da450513          	add	a0,a0,-604 # 8a58 <malloc+0x1440>
    4cbc:	00003097          	auipc	ra,0x3
    4cc0:	858080e7          	jalr	-1960(ra) # 7514 <printf>
    exit(1);
    4cc4:	00100513          	li	a0,1
    4cc8:	00002097          	auipc	ra,0x2
    4ccc:	370080e7          	jalr	880(ra) # 7038 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    4cd0:	00048593          	mv	a1,s1
    4cd4:	00004517          	auipc	a0,0x4
    4cd8:	3ec50513          	add	a0,a0,1004 # 90c0 <malloc+0x1aa8>
    4cdc:	00003097          	auipc	ra,0x3
    4ce0:	838080e7          	jalr	-1992(ra) # 7514 <printf>
    exit(1);
    4ce4:	00100513          	li	a0,1
    4ce8:	00002097          	auipc	ra,0x2
    4cec:	350080e7          	jalr	848(ra) # 7038 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    4cf0:	00048593          	mv	a1,s1
    4cf4:	00004517          	auipc	a0,0x4
    4cf8:	3f450513          	add	a0,a0,1012 # 90e8 <malloc+0x1ad0>
    4cfc:	00003097          	auipc	ra,0x3
    4d00:	818080e7          	jalr	-2024(ra) # 7514 <printf>
    exit(1);
    4d04:	00100513          	li	a0,1
    4d08:	00002097          	auipc	ra,0x2
    4d0c:	330080e7          	jalr	816(ra) # 7038 <exit>
    printf("%s: unlink dots failed!\n", s);
    4d10:	00048593          	mv	a1,s1
    4d14:	00004517          	auipc	a0,0x4
    4d18:	3f450513          	add	a0,a0,1012 # 9108 <malloc+0x1af0>
    4d1c:	00002097          	auipc	ra,0x2
    4d20:	7f8080e7          	jalr	2040(ra) # 7514 <printf>
    exit(1);
    4d24:	00100513          	li	a0,1
    4d28:	00002097          	auipc	ra,0x2
    4d2c:	310080e7          	jalr	784(ra) # 7038 <exit>

0000000000004d30 <dirfile>:
{
    4d30:	fe010113          	add	sp,sp,-32
    4d34:	00113c23          	sd	ra,24(sp)
    4d38:	00813823          	sd	s0,16(sp)
    4d3c:	00913423          	sd	s1,8(sp)
    4d40:	01213023          	sd	s2,0(sp)
    4d44:	02010413          	add	s0,sp,32
    4d48:	00050913          	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    4d4c:	20000593          	li	a1,512
    4d50:	00004517          	auipc	a0,0x4
    4d54:	3d850513          	add	a0,a0,984 # 9128 <malloc+0x1b10>
    4d58:	00002097          	auipc	ra,0x2
    4d5c:	340080e7          	jalr	832(ra) # 7098 <open>
  if(fd < 0){
    4d60:	10054a63          	bltz	a0,4e74 <dirfile+0x144>
  close(fd);
    4d64:	00002097          	auipc	ra,0x2
    4d68:	310080e7          	jalr	784(ra) # 7074 <close>
  if(chdir("dirfile") == 0){
    4d6c:	00004517          	auipc	a0,0x4
    4d70:	3bc50513          	add	a0,a0,956 # 9128 <malloc+0x1b10>
    4d74:	00002097          	auipc	ra,0x2
    4d78:	36c080e7          	jalr	876(ra) # 70e0 <chdir>
    4d7c:	10050c63          	beqz	a0,4e94 <dirfile+0x164>
  fd = open("dirfile/xx", 0);
    4d80:	00000593          	li	a1,0
    4d84:	00004517          	auipc	a0,0x4
    4d88:	3ec50513          	add	a0,a0,1004 # 9170 <malloc+0x1b58>
    4d8c:	00002097          	auipc	ra,0x2
    4d90:	30c080e7          	jalr	780(ra) # 7098 <open>
  if(fd >= 0){
    4d94:	12055063          	bgez	a0,4eb4 <dirfile+0x184>
  fd = open("dirfile/xx", O_CREATE);
    4d98:	20000593          	li	a1,512
    4d9c:	00004517          	auipc	a0,0x4
    4da0:	3d450513          	add	a0,a0,980 # 9170 <malloc+0x1b58>
    4da4:	00002097          	auipc	ra,0x2
    4da8:	2f4080e7          	jalr	756(ra) # 7098 <open>
  if(fd >= 0){
    4dac:	12055463          	bgez	a0,4ed4 <dirfile+0x1a4>
  if(mkdir("dirfile/xx") == 0){
    4db0:	00004517          	auipc	a0,0x4
    4db4:	3c050513          	add	a0,a0,960 # 9170 <malloc+0x1b58>
    4db8:	00002097          	auipc	ra,0x2
    4dbc:	31c080e7          	jalr	796(ra) # 70d4 <mkdir>
    4dc0:	12050a63          	beqz	a0,4ef4 <dirfile+0x1c4>
  if(unlink("dirfile/xx") == 0){
    4dc4:	00004517          	auipc	a0,0x4
    4dc8:	3ac50513          	add	a0,a0,940 # 9170 <malloc+0x1b58>
    4dcc:	00002097          	auipc	ra,0x2
    4dd0:	2e4080e7          	jalr	740(ra) # 70b0 <unlink>
    4dd4:	14050063          	beqz	a0,4f14 <dirfile+0x1e4>
  if(link("README", "dirfile/xx") == 0){
    4dd8:	00004597          	auipc	a1,0x4
    4ddc:	39858593          	add	a1,a1,920 # 9170 <malloc+0x1b58>
    4de0:	00003517          	auipc	a0,0x3
    4de4:	b9050513          	add	a0,a0,-1136 # 7970 <malloc+0x358>
    4de8:	00002097          	auipc	ra,0x2
    4dec:	2e0080e7          	jalr	736(ra) # 70c8 <link>
    4df0:	14050263          	beqz	a0,4f34 <dirfile+0x204>
  if(unlink("dirfile") != 0){
    4df4:	00004517          	auipc	a0,0x4
    4df8:	33450513          	add	a0,a0,820 # 9128 <malloc+0x1b10>
    4dfc:	00002097          	auipc	ra,0x2
    4e00:	2b4080e7          	jalr	692(ra) # 70b0 <unlink>
    4e04:	14051863          	bnez	a0,4f54 <dirfile+0x224>
  fd = open(".", O_RDWR);
    4e08:	00200593          	li	a1,2
    4e0c:	00003517          	auipc	a0,0x3
    4e10:	07450513          	add	a0,a0,116 # 7e80 <malloc+0x868>
    4e14:	00002097          	auipc	ra,0x2
    4e18:	284080e7          	jalr	644(ra) # 7098 <open>
  if(fd >= 0){
    4e1c:	14055c63          	bgez	a0,4f74 <dirfile+0x244>
  fd = open(".", 0);
    4e20:	00000593          	li	a1,0
    4e24:	00003517          	auipc	a0,0x3
    4e28:	05c50513          	add	a0,a0,92 # 7e80 <malloc+0x868>
    4e2c:	00002097          	auipc	ra,0x2
    4e30:	26c080e7          	jalr	620(ra) # 7098 <open>
    4e34:	00050493          	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    4e38:	00100613          	li	a2,1
    4e3c:	00003597          	auipc	a1,0x3
    4e40:	9cc58593          	add	a1,a1,-1588 # 7808 <malloc+0x1f0>
    4e44:	00002097          	auipc	ra,0x2
    4e48:	224080e7          	jalr	548(ra) # 7068 <write>
    4e4c:	14a04463          	bgtz	a0,4f94 <dirfile+0x264>
  close(fd);
    4e50:	00048513          	mv	a0,s1
    4e54:	00002097          	auipc	ra,0x2
    4e58:	220080e7          	jalr	544(ra) # 7074 <close>
}
    4e5c:	01813083          	ld	ra,24(sp)
    4e60:	01013403          	ld	s0,16(sp)
    4e64:	00813483          	ld	s1,8(sp)
    4e68:	00013903          	ld	s2,0(sp)
    4e6c:	02010113          	add	sp,sp,32
    4e70:	00008067          	ret
    printf("%s: create dirfile failed\n", s);
    4e74:	00090593          	mv	a1,s2
    4e78:	00004517          	auipc	a0,0x4
    4e7c:	2b850513          	add	a0,a0,696 # 9130 <malloc+0x1b18>
    4e80:	00002097          	auipc	ra,0x2
    4e84:	694080e7          	jalr	1684(ra) # 7514 <printf>
    exit(1);
    4e88:	00100513          	li	a0,1
    4e8c:	00002097          	auipc	ra,0x2
    4e90:	1ac080e7          	jalr	428(ra) # 7038 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    4e94:	00090593          	mv	a1,s2
    4e98:	00004517          	auipc	a0,0x4
    4e9c:	2b850513          	add	a0,a0,696 # 9150 <malloc+0x1b38>
    4ea0:	00002097          	auipc	ra,0x2
    4ea4:	674080e7          	jalr	1652(ra) # 7514 <printf>
    exit(1);
    4ea8:	00100513          	li	a0,1
    4eac:	00002097          	auipc	ra,0x2
    4eb0:	18c080e7          	jalr	396(ra) # 7038 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    4eb4:	00090593          	mv	a1,s2
    4eb8:	00004517          	auipc	a0,0x4
    4ebc:	2c850513          	add	a0,a0,712 # 9180 <malloc+0x1b68>
    4ec0:	00002097          	auipc	ra,0x2
    4ec4:	654080e7          	jalr	1620(ra) # 7514 <printf>
    exit(1);
    4ec8:	00100513          	li	a0,1
    4ecc:	00002097          	auipc	ra,0x2
    4ed0:	16c080e7          	jalr	364(ra) # 7038 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    4ed4:	00090593          	mv	a1,s2
    4ed8:	00004517          	auipc	a0,0x4
    4edc:	2a850513          	add	a0,a0,680 # 9180 <malloc+0x1b68>
    4ee0:	00002097          	auipc	ra,0x2
    4ee4:	634080e7          	jalr	1588(ra) # 7514 <printf>
    exit(1);
    4ee8:	00100513          	li	a0,1
    4eec:	00002097          	auipc	ra,0x2
    4ef0:	14c080e7          	jalr	332(ra) # 7038 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    4ef4:	00090593          	mv	a1,s2
    4ef8:	00004517          	auipc	a0,0x4
    4efc:	2b050513          	add	a0,a0,688 # 91a8 <malloc+0x1b90>
    4f00:	00002097          	auipc	ra,0x2
    4f04:	614080e7          	jalr	1556(ra) # 7514 <printf>
    exit(1);
    4f08:	00100513          	li	a0,1
    4f0c:	00002097          	auipc	ra,0x2
    4f10:	12c080e7          	jalr	300(ra) # 7038 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    4f14:	00090593          	mv	a1,s2
    4f18:	00004517          	auipc	a0,0x4
    4f1c:	2b850513          	add	a0,a0,696 # 91d0 <malloc+0x1bb8>
    4f20:	00002097          	auipc	ra,0x2
    4f24:	5f4080e7          	jalr	1524(ra) # 7514 <printf>
    exit(1);
    4f28:	00100513          	li	a0,1
    4f2c:	00002097          	auipc	ra,0x2
    4f30:	10c080e7          	jalr	268(ra) # 7038 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    4f34:	00090593          	mv	a1,s2
    4f38:	00004517          	auipc	a0,0x4
    4f3c:	2c050513          	add	a0,a0,704 # 91f8 <malloc+0x1be0>
    4f40:	00002097          	auipc	ra,0x2
    4f44:	5d4080e7          	jalr	1492(ra) # 7514 <printf>
    exit(1);
    4f48:	00100513          	li	a0,1
    4f4c:	00002097          	auipc	ra,0x2
    4f50:	0ec080e7          	jalr	236(ra) # 7038 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    4f54:	00090593          	mv	a1,s2
    4f58:	00004517          	auipc	a0,0x4
    4f5c:	2c850513          	add	a0,a0,712 # 9220 <malloc+0x1c08>
    4f60:	00002097          	auipc	ra,0x2
    4f64:	5b4080e7          	jalr	1460(ra) # 7514 <printf>
    exit(1);
    4f68:	00100513          	li	a0,1
    4f6c:	00002097          	auipc	ra,0x2
    4f70:	0cc080e7          	jalr	204(ra) # 7038 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    4f74:	00090593          	mv	a1,s2
    4f78:	00004517          	auipc	a0,0x4
    4f7c:	2c850513          	add	a0,a0,712 # 9240 <malloc+0x1c28>
    4f80:	00002097          	auipc	ra,0x2
    4f84:	594080e7          	jalr	1428(ra) # 7514 <printf>
    exit(1);
    4f88:	00100513          	li	a0,1
    4f8c:	00002097          	auipc	ra,0x2
    4f90:	0ac080e7          	jalr	172(ra) # 7038 <exit>
    printf("%s: write . succeeded!\n", s);
    4f94:	00090593          	mv	a1,s2
    4f98:	00004517          	auipc	a0,0x4
    4f9c:	2d050513          	add	a0,a0,720 # 9268 <malloc+0x1c50>
    4fa0:	00002097          	auipc	ra,0x2
    4fa4:	574080e7          	jalr	1396(ra) # 7514 <printf>
    exit(1);
    4fa8:	00100513          	li	a0,1
    4fac:	00002097          	auipc	ra,0x2
    4fb0:	08c080e7          	jalr	140(ra) # 7038 <exit>

0000000000004fb4 <iref>:
{
    4fb4:	fc010113          	add	sp,sp,-64
    4fb8:	02113c23          	sd	ra,56(sp)
    4fbc:	02813823          	sd	s0,48(sp)
    4fc0:	02913423          	sd	s1,40(sp)
    4fc4:	03213023          	sd	s2,32(sp)
    4fc8:	01313c23          	sd	s3,24(sp)
    4fcc:	01413823          	sd	s4,16(sp)
    4fd0:	01513423          	sd	s5,8(sp)
    4fd4:	01613023          	sd	s6,0(sp)
    4fd8:	04010413          	add	s0,sp,64
    4fdc:	00050b13          	mv	s6,a0
    4fe0:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    4fe4:	00004a17          	auipc	s4,0x4
    4fe8:	29ca0a13          	add	s4,s4,668 # 9280 <malloc+0x1c68>
    mkdir("");
    4fec:	00004497          	auipc	s1,0x4
    4ff0:	d9c48493          	add	s1,s1,-612 # 8d88 <malloc+0x1770>
    link("README", "");
    4ff4:	00003a97          	auipc	s5,0x3
    4ff8:	97ca8a93          	add	s5,s5,-1668 # 7970 <malloc+0x358>
    fd = open("xx", O_CREATE);
    4ffc:	00004997          	auipc	s3,0x4
    5000:	17c98993          	add	s3,s3,380 # 9178 <malloc+0x1b60>
    5004:	0640006f          	j	5068 <iref+0xb4>
      printf("%s: mkdir irefd failed\n", s);
    5008:	000b0593          	mv	a1,s6
    500c:	00004517          	auipc	a0,0x4
    5010:	27c50513          	add	a0,a0,636 # 9288 <malloc+0x1c70>
    5014:	00002097          	auipc	ra,0x2
    5018:	500080e7          	jalr	1280(ra) # 7514 <printf>
      exit(1);
    501c:	00100513          	li	a0,1
    5020:	00002097          	auipc	ra,0x2
    5024:	018080e7          	jalr	24(ra) # 7038 <exit>
      printf("%s: chdir irefd failed\n", s);
    5028:	000b0593          	mv	a1,s6
    502c:	00004517          	auipc	a0,0x4
    5030:	27450513          	add	a0,a0,628 # 92a0 <malloc+0x1c88>
    5034:	00002097          	auipc	ra,0x2
    5038:	4e0080e7          	jalr	1248(ra) # 7514 <printf>
      exit(1);
    503c:	00100513          	li	a0,1
    5040:	00002097          	auipc	ra,0x2
    5044:	ff8080e7          	jalr	-8(ra) # 7038 <exit>
      close(fd);
    5048:	00002097          	auipc	ra,0x2
    504c:	02c080e7          	jalr	44(ra) # 7074 <close>
    5050:	0680006f          	j	50b8 <iref+0x104>
    unlink("xx");
    5054:	00098513          	mv	a0,s3
    5058:	00002097          	auipc	ra,0x2
    505c:	058080e7          	jalr	88(ra) # 70b0 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    5060:	fff9091b          	addw	s2,s2,-1
    5064:	06090a63          	beqz	s2,50d8 <iref+0x124>
    if(mkdir("irefd") != 0){
    5068:	000a0513          	mv	a0,s4
    506c:	00002097          	auipc	ra,0x2
    5070:	068080e7          	jalr	104(ra) # 70d4 <mkdir>
    5074:	f8051ae3          	bnez	a0,5008 <iref+0x54>
    if(chdir("irefd") != 0){
    5078:	000a0513          	mv	a0,s4
    507c:	00002097          	auipc	ra,0x2
    5080:	064080e7          	jalr	100(ra) # 70e0 <chdir>
    5084:	fa0512e3          	bnez	a0,5028 <iref+0x74>
    mkdir("");
    5088:	00048513          	mv	a0,s1
    508c:	00002097          	auipc	ra,0x2
    5090:	048080e7          	jalr	72(ra) # 70d4 <mkdir>
    link("README", "");
    5094:	00048593          	mv	a1,s1
    5098:	000a8513          	mv	a0,s5
    509c:	00002097          	auipc	ra,0x2
    50a0:	02c080e7          	jalr	44(ra) # 70c8 <link>
    fd = open("", O_CREATE);
    50a4:	20000593          	li	a1,512
    50a8:	00048513          	mv	a0,s1
    50ac:	00002097          	auipc	ra,0x2
    50b0:	fec080e7          	jalr	-20(ra) # 7098 <open>
    if(fd >= 0)
    50b4:	f8055ae3          	bgez	a0,5048 <iref+0x94>
    fd = open("xx", O_CREATE);
    50b8:	20000593          	li	a1,512
    50bc:	00098513          	mv	a0,s3
    50c0:	00002097          	auipc	ra,0x2
    50c4:	fd8080e7          	jalr	-40(ra) # 7098 <open>
    if(fd >= 0)
    50c8:	f80546e3          	bltz	a0,5054 <iref+0xa0>
      close(fd);
    50cc:	00002097          	auipc	ra,0x2
    50d0:	fa8080e7          	jalr	-88(ra) # 7074 <close>
    50d4:	f81ff06f          	j	5054 <iref+0xa0>
    50d8:	03300493          	li	s1,51
    chdir("..");
    50dc:	00004997          	auipc	s3,0x4
    50e0:	9cc98993          	add	s3,s3,-1588 # 8aa8 <malloc+0x1490>
    unlink("irefd");
    50e4:	00004917          	auipc	s2,0x4
    50e8:	19c90913          	add	s2,s2,412 # 9280 <malloc+0x1c68>
    chdir("..");
    50ec:	00098513          	mv	a0,s3
    50f0:	00002097          	auipc	ra,0x2
    50f4:	ff0080e7          	jalr	-16(ra) # 70e0 <chdir>
    unlink("irefd");
    50f8:	00090513          	mv	a0,s2
    50fc:	00002097          	auipc	ra,0x2
    5100:	fb4080e7          	jalr	-76(ra) # 70b0 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    5104:	fff4849b          	addw	s1,s1,-1
    5108:	fe0492e3          	bnez	s1,50ec <iref+0x138>
  chdir("/");
    510c:	00004517          	auipc	a0,0x4
    5110:	94450513          	add	a0,a0,-1724 # 8a50 <malloc+0x1438>
    5114:	00002097          	auipc	ra,0x2
    5118:	fcc080e7          	jalr	-52(ra) # 70e0 <chdir>
}
    511c:	03813083          	ld	ra,56(sp)
    5120:	03013403          	ld	s0,48(sp)
    5124:	02813483          	ld	s1,40(sp)
    5128:	02013903          	ld	s2,32(sp)
    512c:	01813983          	ld	s3,24(sp)
    5130:	01013a03          	ld	s4,16(sp)
    5134:	00813a83          	ld	s5,8(sp)
    5138:	00013b03          	ld	s6,0(sp)
    513c:	04010113          	add	sp,sp,64
    5140:	00008067          	ret

0000000000005144 <openiputtest>:
{
    5144:	fd010113          	add	sp,sp,-48
    5148:	02113423          	sd	ra,40(sp)
    514c:	02813023          	sd	s0,32(sp)
    5150:	00913c23          	sd	s1,24(sp)
    5154:	03010413          	add	s0,sp,48
    5158:	00050493          	mv	s1,a0
  if(mkdir("oidir") < 0){
    515c:	00004517          	auipc	a0,0x4
    5160:	15c50513          	add	a0,a0,348 # 92b8 <malloc+0x1ca0>
    5164:	00002097          	auipc	ra,0x2
    5168:	f70080e7          	jalr	-144(ra) # 70d4 <mkdir>
    516c:	04054663          	bltz	a0,51b8 <openiputtest+0x74>
  pid = fork();
    5170:	00002097          	auipc	ra,0x2
    5174:	ebc080e7          	jalr	-324(ra) # 702c <fork>
  if(pid < 0){
    5178:	06054063          	bltz	a0,51d8 <openiputtest+0x94>
  if(pid == 0){
    517c:	08051463          	bnez	a0,5204 <openiputtest+0xc0>
    int fd = open("oidir", O_RDWR);
    5180:	00200593          	li	a1,2
    5184:	00004517          	auipc	a0,0x4
    5188:	13450513          	add	a0,a0,308 # 92b8 <malloc+0x1ca0>
    518c:	00002097          	auipc	ra,0x2
    5190:	f0c080e7          	jalr	-244(ra) # 7098 <open>
    if(fd >= 0){
    5194:	06054263          	bltz	a0,51f8 <openiputtest+0xb4>
      printf("%s: open directory for write succeeded\n", s);
    5198:	00048593          	mv	a1,s1
    519c:	00004517          	auipc	a0,0x4
    51a0:	13c50513          	add	a0,a0,316 # 92d8 <malloc+0x1cc0>
    51a4:	00002097          	auipc	ra,0x2
    51a8:	370080e7          	jalr	880(ra) # 7514 <printf>
      exit(1);
    51ac:	00100513          	li	a0,1
    51b0:	00002097          	auipc	ra,0x2
    51b4:	e88080e7          	jalr	-376(ra) # 7038 <exit>
    printf("%s: mkdir oidir failed\n", s);
    51b8:	00048593          	mv	a1,s1
    51bc:	00004517          	auipc	a0,0x4
    51c0:	10450513          	add	a0,a0,260 # 92c0 <malloc+0x1ca8>
    51c4:	00002097          	auipc	ra,0x2
    51c8:	350080e7          	jalr	848(ra) # 7514 <printf>
    exit(1);
    51cc:	00100513          	li	a0,1
    51d0:	00002097          	auipc	ra,0x2
    51d4:	e68080e7          	jalr	-408(ra) # 7038 <exit>
    printf("%s: fork failed\n", s);
    51d8:	00048593          	mv	a1,s1
    51dc:	00003517          	auipc	a0,0x3
    51e0:	e4450513          	add	a0,a0,-444 # 8020 <malloc+0xa08>
    51e4:	00002097          	auipc	ra,0x2
    51e8:	330080e7          	jalr	816(ra) # 7514 <printf>
    exit(1);
    51ec:	00100513          	li	a0,1
    51f0:	00002097          	auipc	ra,0x2
    51f4:	e48080e7          	jalr	-440(ra) # 7038 <exit>
    exit(0);
    51f8:	00000513          	li	a0,0
    51fc:	00002097          	auipc	ra,0x2
    5200:	e3c080e7          	jalr	-452(ra) # 7038 <exit>
  sleep(1);
    5204:	00100513          	li	a0,1
    5208:	00002097          	auipc	ra,0x2
    520c:	f08080e7          	jalr	-248(ra) # 7110 <sleep>
  if(unlink("oidir") != 0){
    5210:	00004517          	auipc	a0,0x4
    5214:	0a850513          	add	a0,a0,168 # 92b8 <malloc+0x1ca0>
    5218:	00002097          	auipc	ra,0x2
    521c:	e98080e7          	jalr	-360(ra) # 70b0 <unlink>
    5220:	02050263          	beqz	a0,5244 <openiputtest+0x100>
    printf("%s: unlink failed\n", s);
    5224:	00048593          	mv	a1,s1
    5228:	00003517          	auipc	a0,0x3
    522c:	fe850513          	add	a0,a0,-24 # 8210 <malloc+0xbf8>
    5230:	00002097          	auipc	ra,0x2
    5234:	2e4080e7          	jalr	740(ra) # 7514 <printf>
    exit(1);
    5238:	00100513          	li	a0,1
    523c:	00002097          	auipc	ra,0x2
    5240:	dfc080e7          	jalr	-516(ra) # 7038 <exit>
  wait(&xstatus);
    5244:	fdc40513          	add	a0,s0,-36
    5248:	00002097          	auipc	ra,0x2
    524c:	dfc080e7          	jalr	-516(ra) # 7044 <wait>
  exit(xstatus);
    5250:	fdc42503          	lw	a0,-36(s0)
    5254:	00002097          	auipc	ra,0x2
    5258:	de4080e7          	jalr	-540(ra) # 7038 <exit>

000000000000525c <forkforkfork>:
{
    525c:	fe010113          	add	sp,sp,-32
    5260:	00113c23          	sd	ra,24(sp)
    5264:	00813823          	sd	s0,16(sp)
    5268:	00913423          	sd	s1,8(sp)
    526c:	02010413          	add	s0,sp,32
    5270:	00050493          	mv	s1,a0
  unlink("stopforking");
    5274:	00004517          	auipc	a0,0x4
    5278:	08c50513          	add	a0,a0,140 # 9300 <malloc+0x1ce8>
    527c:	00002097          	auipc	ra,0x2
    5280:	e34080e7          	jalr	-460(ra) # 70b0 <unlink>
  int pid = fork();
    5284:	00002097          	auipc	ra,0x2
    5288:	da8080e7          	jalr	-600(ra) # 702c <fork>
  if(pid < 0){
    528c:	04054e63          	bltz	a0,52e8 <forkforkfork+0x8c>
  if(pid == 0){
    5290:	06050c63          	beqz	a0,5308 <forkforkfork+0xac>
  sleep(20); // two seconds
    5294:	01400513          	li	a0,20
    5298:	00002097          	auipc	ra,0x2
    529c:	e78080e7          	jalr	-392(ra) # 7110 <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    52a0:	20200593          	li	a1,514
    52a4:	00004517          	auipc	a0,0x4
    52a8:	05c50513          	add	a0,a0,92 # 9300 <malloc+0x1ce8>
    52ac:	00002097          	auipc	ra,0x2
    52b0:	dec080e7          	jalr	-532(ra) # 7098 <open>
    52b4:	00002097          	auipc	ra,0x2
    52b8:	dc0080e7          	jalr	-576(ra) # 7074 <close>
  wait(0);
    52bc:	00000513          	li	a0,0
    52c0:	00002097          	auipc	ra,0x2
    52c4:	d84080e7          	jalr	-636(ra) # 7044 <wait>
  sleep(10); // one second
    52c8:	00a00513          	li	a0,10
    52cc:	00002097          	auipc	ra,0x2
    52d0:	e44080e7          	jalr	-444(ra) # 7110 <sleep>
}
    52d4:	01813083          	ld	ra,24(sp)
    52d8:	01013403          	ld	s0,16(sp)
    52dc:	00813483          	ld	s1,8(sp)
    52e0:	02010113          	add	sp,sp,32
    52e4:	00008067          	ret
    printf("%s: fork failed", s);
    52e8:	00048593          	mv	a1,s1
    52ec:	00003517          	auipc	a0,0x3
    52f0:	ef450513          	add	a0,a0,-268 # 81e0 <malloc+0xbc8>
    52f4:	00002097          	auipc	ra,0x2
    52f8:	220080e7          	jalr	544(ra) # 7514 <printf>
    exit(1);
    52fc:	00100513          	li	a0,1
    5300:	00002097          	auipc	ra,0x2
    5304:	d38080e7          	jalr	-712(ra) # 7038 <exit>
      int fd = open("stopforking", 0);
    5308:	00004497          	auipc	s1,0x4
    530c:	ff848493          	add	s1,s1,-8 # 9300 <malloc+0x1ce8>
    5310:	00000593          	li	a1,0
    5314:	00048513          	mv	a0,s1
    5318:	00002097          	auipc	ra,0x2
    531c:	d80080e7          	jalr	-640(ra) # 7098 <open>
      if(fd >= 0){
    5320:	02055863          	bgez	a0,5350 <forkforkfork+0xf4>
      if(fork() < 0){
    5324:	00002097          	auipc	ra,0x2
    5328:	d08080e7          	jalr	-760(ra) # 702c <fork>
    532c:	fe0552e3          	bgez	a0,5310 <forkforkfork+0xb4>
        close(open("stopforking", O_CREATE|O_RDWR));
    5330:	20200593          	li	a1,514
    5334:	00004517          	auipc	a0,0x4
    5338:	fcc50513          	add	a0,a0,-52 # 9300 <malloc+0x1ce8>
    533c:	00002097          	auipc	ra,0x2
    5340:	d5c080e7          	jalr	-676(ra) # 7098 <open>
    5344:	00002097          	auipc	ra,0x2
    5348:	d30080e7          	jalr	-720(ra) # 7074 <close>
    534c:	fc5ff06f          	j	5310 <forkforkfork+0xb4>
        exit(0);
    5350:	00000513          	li	a0,0
    5354:	00002097          	auipc	ra,0x2
    5358:	ce4080e7          	jalr	-796(ra) # 7038 <exit>

000000000000535c <killstatus>:
{
    535c:	fc010113          	add	sp,sp,-64
    5360:	02113c23          	sd	ra,56(sp)
    5364:	02813823          	sd	s0,48(sp)
    5368:	02913423          	sd	s1,40(sp)
    536c:	03213023          	sd	s2,32(sp)
    5370:	01313c23          	sd	s3,24(sp)
    5374:	01413823          	sd	s4,16(sp)
    5378:	04010413          	add	s0,sp,64
    537c:	00050a13          	mv	s4,a0
    5380:	06400913          	li	s2,100
    if(xst != -1) {
    5384:	fff00993          	li	s3,-1
    int pid1 = fork();
    5388:	00002097          	auipc	ra,0x2
    538c:	ca4080e7          	jalr	-860(ra) # 702c <fork>
    5390:	00050493          	mv	s1,a0
    if(pid1 < 0){
    5394:	04054463          	bltz	a0,53dc <killstatus+0x80>
    if(pid1 == 0){
    5398:	06050263          	beqz	a0,53fc <killstatus+0xa0>
    sleep(1);
    539c:	00100513          	li	a0,1
    53a0:	00002097          	auipc	ra,0x2
    53a4:	d70080e7          	jalr	-656(ra) # 7110 <sleep>
    kill(pid1);
    53a8:	00048513          	mv	a0,s1
    53ac:	00002097          	auipc	ra,0x2
    53b0:	cd4080e7          	jalr	-812(ra) # 7080 <kill>
    wait(&xst);
    53b4:	fcc40513          	add	a0,s0,-52
    53b8:	00002097          	auipc	ra,0x2
    53bc:	c8c080e7          	jalr	-884(ra) # 7044 <wait>
    if(xst != -1) {
    53c0:	fcc42783          	lw	a5,-52(s0)
    53c4:	05379263          	bne	a5,s3,5408 <killstatus+0xac>
  for(int i = 0; i < 100; i++){
    53c8:	fff9091b          	addw	s2,s2,-1
    53cc:	fa091ee3          	bnez	s2,5388 <killstatus+0x2c>
  exit(0);
    53d0:	00000513          	li	a0,0
    53d4:	00002097          	auipc	ra,0x2
    53d8:	c64080e7          	jalr	-924(ra) # 7038 <exit>
      printf("%s: fork failed\n", s);
    53dc:	000a0593          	mv	a1,s4
    53e0:	00003517          	auipc	a0,0x3
    53e4:	c4050513          	add	a0,a0,-960 # 8020 <malloc+0xa08>
    53e8:	00002097          	auipc	ra,0x2
    53ec:	12c080e7          	jalr	300(ra) # 7514 <printf>
      exit(1);
    53f0:	00100513          	li	a0,1
    53f4:	00002097          	auipc	ra,0x2
    53f8:	c44080e7          	jalr	-956(ra) # 7038 <exit>
        getpid();
    53fc:	00002097          	auipc	ra,0x2
    5400:	cfc080e7          	jalr	-772(ra) # 70f8 <getpid>
      while(1) {
    5404:	ff9ff06f          	j	53fc <killstatus+0xa0>
       printf("%s: status should be -1\n", s);
    5408:	000a0593          	mv	a1,s4
    540c:	00004517          	auipc	a0,0x4
    5410:	f0450513          	add	a0,a0,-252 # 9310 <malloc+0x1cf8>
    5414:	00002097          	auipc	ra,0x2
    5418:	100080e7          	jalr	256(ra) # 7514 <printf>
       exit(1);
    541c:	00100513          	li	a0,1
    5420:	00002097          	auipc	ra,0x2
    5424:	c18080e7          	jalr	-1000(ra) # 7038 <exit>

0000000000005428 <preempt>:
{
    5428:	fc010113          	add	sp,sp,-64
    542c:	02113c23          	sd	ra,56(sp)
    5430:	02813823          	sd	s0,48(sp)
    5434:	02913423          	sd	s1,40(sp)
    5438:	03213023          	sd	s2,32(sp)
    543c:	01313c23          	sd	s3,24(sp)
    5440:	01413823          	sd	s4,16(sp)
    5444:	04010413          	add	s0,sp,64
    5448:	00050913          	mv	s2,a0
  pid1 = fork();
    544c:	00002097          	auipc	ra,0x2
    5450:	be0080e7          	jalr	-1056(ra) # 702c <fork>
  if(pid1 < 0) {
    5454:	00054863          	bltz	a0,5464 <preempt+0x3c>
    5458:	00050493          	mv	s1,a0
  if(pid1 == 0)
    545c:	02051463          	bnez	a0,5484 <preempt+0x5c>
    for(;;)
    5460:	0000006f          	j	5460 <preempt+0x38>
    printf("%s: fork failed", s);
    5464:	00090593          	mv	a1,s2
    5468:	00003517          	auipc	a0,0x3
    546c:	d7850513          	add	a0,a0,-648 # 81e0 <malloc+0xbc8>
    5470:	00002097          	auipc	ra,0x2
    5474:	0a4080e7          	jalr	164(ra) # 7514 <printf>
    exit(1);
    5478:	00100513          	li	a0,1
    547c:	00002097          	auipc	ra,0x2
    5480:	bbc080e7          	jalr	-1092(ra) # 7038 <exit>
  pid2 = fork();
    5484:	00002097          	auipc	ra,0x2
    5488:	ba8080e7          	jalr	-1112(ra) # 702c <fork>
    548c:	00050993          	mv	s3,a0
  if(pid2 < 0) {
    5490:	00054663          	bltz	a0,549c <preempt+0x74>
  if(pid2 == 0)
    5494:	02051463          	bnez	a0,54bc <preempt+0x94>
    for(;;)
    5498:	0000006f          	j	5498 <preempt+0x70>
    printf("%s: fork failed\n", s);
    549c:	00090593          	mv	a1,s2
    54a0:	00003517          	auipc	a0,0x3
    54a4:	b8050513          	add	a0,a0,-1152 # 8020 <malloc+0xa08>
    54a8:	00002097          	auipc	ra,0x2
    54ac:	06c080e7          	jalr	108(ra) # 7514 <printf>
    exit(1);
    54b0:	00100513          	li	a0,1
    54b4:	00002097          	auipc	ra,0x2
    54b8:	b84080e7          	jalr	-1148(ra) # 7038 <exit>
  pipe(pfds);
    54bc:	fc840513          	add	a0,s0,-56
    54c0:	00002097          	auipc	ra,0x2
    54c4:	b90080e7          	jalr	-1136(ra) # 7050 <pipe>
  pid3 = fork();
    54c8:	00002097          	auipc	ra,0x2
    54cc:	b64080e7          	jalr	-1180(ra) # 702c <fork>
    54d0:	00050a13          	mv	s4,a0
  if(pid3 < 0) {
    54d4:	04054263          	bltz	a0,5518 <preempt+0xf0>
  if(pid3 == 0){
    54d8:	06051c63          	bnez	a0,5550 <preempt+0x128>
    close(pfds[0]);
    54dc:	fc842503          	lw	a0,-56(s0)
    54e0:	00002097          	auipc	ra,0x2
    54e4:	b94080e7          	jalr	-1132(ra) # 7074 <close>
    if(write(pfds[1], "x", 1) != 1)
    54e8:	00100613          	li	a2,1
    54ec:	00002597          	auipc	a1,0x2
    54f0:	31c58593          	add	a1,a1,796 # 7808 <malloc+0x1f0>
    54f4:	fcc42503          	lw	a0,-52(s0)
    54f8:	00002097          	auipc	ra,0x2
    54fc:	b70080e7          	jalr	-1168(ra) # 7068 <write>
    5500:	00100793          	li	a5,1
    5504:	02f51a63          	bne	a0,a5,5538 <preempt+0x110>
    close(pfds[1]);
    5508:	fcc42503          	lw	a0,-52(s0)
    550c:	00002097          	auipc	ra,0x2
    5510:	b68080e7          	jalr	-1176(ra) # 7074 <close>
    for(;;)
    5514:	0000006f          	j	5514 <preempt+0xec>
     printf("%s: fork failed\n", s);
    5518:	00090593          	mv	a1,s2
    551c:	00003517          	auipc	a0,0x3
    5520:	b0450513          	add	a0,a0,-1276 # 8020 <malloc+0xa08>
    5524:	00002097          	auipc	ra,0x2
    5528:	ff0080e7          	jalr	-16(ra) # 7514 <printf>
     exit(1);
    552c:	00100513          	li	a0,1
    5530:	00002097          	auipc	ra,0x2
    5534:	b08080e7          	jalr	-1272(ra) # 7038 <exit>
      printf("%s: preempt write error", s);
    5538:	00090593          	mv	a1,s2
    553c:	00004517          	auipc	a0,0x4
    5540:	df450513          	add	a0,a0,-524 # 9330 <malloc+0x1d18>
    5544:	00002097          	auipc	ra,0x2
    5548:	fd0080e7          	jalr	-48(ra) # 7514 <printf>
    554c:	fbdff06f          	j	5508 <preempt+0xe0>
  close(pfds[1]);
    5550:	fcc42503          	lw	a0,-52(s0)
    5554:	00002097          	auipc	ra,0x2
    5558:	b20080e7          	jalr	-1248(ra) # 7074 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    555c:	00003637          	lui	a2,0x3
    5560:	00008597          	auipc	a1,0x8
    5564:	71858593          	add	a1,a1,1816 # dc78 <buf>
    5568:	fc842503          	lw	a0,-56(s0)
    556c:	00002097          	auipc	ra,0x2
    5570:	af0080e7          	jalr	-1296(ra) # 705c <read>
    5574:	00100793          	li	a5,1
    5578:	02f50c63          	beq	a0,a5,55b0 <preempt+0x188>
    printf("%s: preempt read error", s);
    557c:	00090593          	mv	a1,s2
    5580:	00004517          	auipc	a0,0x4
    5584:	dc850513          	add	a0,a0,-568 # 9348 <malloc+0x1d30>
    5588:	00002097          	auipc	ra,0x2
    558c:	f8c080e7          	jalr	-116(ra) # 7514 <printf>
}
    5590:	03813083          	ld	ra,56(sp)
    5594:	03013403          	ld	s0,48(sp)
    5598:	02813483          	ld	s1,40(sp)
    559c:	02013903          	ld	s2,32(sp)
    55a0:	01813983          	ld	s3,24(sp)
    55a4:	01013a03          	ld	s4,16(sp)
    55a8:	04010113          	add	sp,sp,64
    55ac:	00008067          	ret
  close(pfds[0]);
    55b0:	fc842503          	lw	a0,-56(s0)
    55b4:	00002097          	auipc	ra,0x2
    55b8:	ac0080e7          	jalr	-1344(ra) # 7074 <close>
  printf("kill... ");
    55bc:	00004517          	auipc	a0,0x4
    55c0:	da450513          	add	a0,a0,-604 # 9360 <malloc+0x1d48>
    55c4:	00002097          	auipc	ra,0x2
    55c8:	f50080e7          	jalr	-176(ra) # 7514 <printf>
  kill(pid1);
    55cc:	00048513          	mv	a0,s1
    55d0:	00002097          	auipc	ra,0x2
    55d4:	ab0080e7          	jalr	-1360(ra) # 7080 <kill>
  kill(pid2);
    55d8:	00098513          	mv	a0,s3
    55dc:	00002097          	auipc	ra,0x2
    55e0:	aa4080e7          	jalr	-1372(ra) # 7080 <kill>
  kill(pid3);
    55e4:	000a0513          	mv	a0,s4
    55e8:	00002097          	auipc	ra,0x2
    55ec:	a98080e7          	jalr	-1384(ra) # 7080 <kill>
  printf("wait... ");
    55f0:	00004517          	auipc	a0,0x4
    55f4:	d8050513          	add	a0,a0,-640 # 9370 <malloc+0x1d58>
    55f8:	00002097          	auipc	ra,0x2
    55fc:	f1c080e7          	jalr	-228(ra) # 7514 <printf>
  wait(0);
    5600:	00000513          	li	a0,0
    5604:	00002097          	auipc	ra,0x2
    5608:	a40080e7          	jalr	-1472(ra) # 7044 <wait>
  wait(0);
    560c:	00000513          	li	a0,0
    5610:	00002097          	auipc	ra,0x2
    5614:	a34080e7          	jalr	-1484(ra) # 7044 <wait>
  wait(0);
    5618:	00000513          	li	a0,0
    561c:	00002097          	auipc	ra,0x2
    5620:	a28080e7          	jalr	-1496(ra) # 7044 <wait>
    5624:	f6dff06f          	j	5590 <preempt+0x168>

0000000000005628 <reparent>:
{
    5628:	fd010113          	add	sp,sp,-48
    562c:	02113423          	sd	ra,40(sp)
    5630:	02813023          	sd	s0,32(sp)
    5634:	00913c23          	sd	s1,24(sp)
    5638:	01213823          	sd	s2,16(sp)
    563c:	01313423          	sd	s3,8(sp)
    5640:	01413023          	sd	s4,0(sp)
    5644:	03010413          	add	s0,sp,48
    5648:	00050993          	mv	s3,a0
  int master_pid = getpid();
    564c:	00002097          	auipc	ra,0x2
    5650:	aac080e7          	jalr	-1364(ra) # 70f8 <getpid>
    5654:	00050a13          	mv	s4,a0
    5658:	0c800913          	li	s2,200
    int pid = fork();
    565c:	00002097          	auipc	ra,0x2
    5660:	9d0080e7          	jalr	-1584(ra) # 702c <fork>
    5664:	00050493          	mv	s1,a0
    if(pid < 0){
    5668:	02054663          	bltz	a0,5694 <reparent+0x6c>
    if(pid){
    566c:	06050463          	beqz	a0,56d4 <reparent+0xac>
      if(wait(0) != pid){
    5670:	00000513          	li	a0,0
    5674:	00002097          	auipc	ra,0x2
    5678:	9d0080e7          	jalr	-1584(ra) # 7044 <wait>
    567c:	02951c63          	bne	a0,s1,56b4 <reparent+0x8c>
  for(int i = 0; i < 200; i++){
    5680:	fff9091b          	addw	s2,s2,-1
    5684:	fc091ce3          	bnez	s2,565c <reparent+0x34>
  exit(0);
    5688:	00000513          	li	a0,0
    568c:	00002097          	auipc	ra,0x2
    5690:	9ac080e7          	jalr	-1620(ra) # 7038 <exit>
      printf("%s: fork failed\n", s);
    5694:	00098593          	mv	a1,s3
    5698:	00003517          	auipc	a0,0x3
    569c:	98850513          	add	a0,a0,-1656 # 8020 <malloc+0xa08>
    56a0:	00002097          	auipc	ra,0x2
    56a4:	e74080e7          	jalr	-396(ra) # 7514 <printf>
      exit(1);
    56a8:	00100513          	li	a0,1
    56ac:	00002097          	auipc	ra,0x2
    56b0:	98c080e7          	jalr	-1652(ra) # 7038 <exit>
        printf("%s: wait wrong pid\n", s);
    56b4:	00098593          	mv	a1,s3
    56b8:	00003517          	auipc	a0,0x3
    56bc:	af050513          	add	a0,a0,-1296 # 81a8 <malloc+0xb90>
    56c0:	00002097          	auipc	ra,0x2
    56c4:	e54080e7          	jalr	-428(ra) # 7514 <printf>
        exit(1);
    56c8:	00100513          	li	a0,1
    56cc:	00002097          	auipc	ra,0x2
    56d0:	96c080e7          	jalr	-1684(ra) # 7038 <exit>
      int pid2 = fork();
    56d4:	00002097          	auipc	ra,0x2
    56d8:	958080e7          	jalr	-1704(ra) # 702c <fork>
      if(pid2 < 0){
    56dc:	00054863          	bltz	a0,56ec <reparent+0xc4>
      exit(0);
    56e0:	00000513          	li	a0,0
    56e4:	00002097          	auipc	ra,0x2
    56e8:	954080e7          	jalr	-1708(ra) # 7038 <exit>
        kill(master_pid);
    56ec:	000a0513          	mv	a0,s4
    56f0:	00002097          	auipc	ra,0x2
    56f4:	990080e7          	jalr	-1648(ra) # 7080 <kill>
        exit(1);
    56f8:	00100513          	li	a0,1
    56fc:	00002097          	auipc	ra,0x2
    5700:	93c080e7          	jalr	-1732(ra) # 7038 <exit>

0000000000005704 <sbrkfail>:
{
    5704:	f8010113          	add	sp,sp,-128
    5708:	06113c23          	sd	ra,120(sp)
    570c:	06813823          	sd	s0,112(sp)
    5710:	06913423          	sd	s1,104(sp)
    5714:	07213023          	sd	s2,96(sp)
    5718:	05313c23          	sd	s3,88(sp)
    571c:	05413823          	sd	s4,80(sp)
    5720:	05513423          	sd	s5,72(sp)
    5724:	08010413          	add	s0,sp,128
    5728:	00050a93          	mv	s5,a0
  if(pipe(fds) != 0){
    572c:	fb040513          	add	a0,s0,-80
    5730:	00002097          	auipc	ra,0x2
    5734:	920080e7          	jalr	-1760(ra) # 7050 <pipe>
    5738:	00051c63          	bnez	a0,5750 <sbrkfail+0x4c>
    573c:	f8040493          	add	s1,s0,-128
    5740:	fa840993          	add	s3,s0,-88
    5744:	00048913          	mv	s2,s1
    if(pids[i] != -1)
    5748:	fff00a13          	li	s4,-1
    574c:	06c0006f          	j	57b8 <sbrkfail+0xb4>
    printf("%s: pipe() failed\n", s);
    5750:	000a8593          	mv	a1,s5
    5754:	00003517          	auipc	a0,0x3
    5758:	9d450513          	add	a0,a0,-1580 # 8128 <malloc+0xb10>
    575c:	00002097          	auipc	ra,0x2
    5760:	db8080e7          	jalr	-584(ra) # 7514 <printf>
    exit(1);
    5764:	00100513          	li	a0,1
    5768:	00002097          	auipc	ra,0x2
    576c:	8d0080e7          	jalr	-1840(ra) # 7038 <exit>
      sbrk(BIG - (uint64)sbrk(0));
    5770:	00002097          	auipc	ra,0x2
    5774:	994080e7          	jalr	-1644(ra) # 7104 <sbrk>
    5778:	064007b7          	lui	a5,0x6400
    577c:	40a7853b          	subw	a0,a5,a0
    5780:	00002097          	auipc	ra,0x2
    5784:	984080e7          	jalr	-1660(ra) # 7104 <sbrk>
      write(fds[1], "x", 1);
    5788:	00100613          	li	a2,1
    578c:	00002597          	auipc	a1,0x2
    5790:	07c58593          	add	a1,a1,124 # 7808 <malloc+0x1f0>
    5794:	fb442503          	lw	a0,-76(s0)
    5798:	00002097          	auipc	ra,0x2
    579c:	8d0080e7          	jalr	-1840(ra) # 7068 <write>
      for(;;) sleep(1000);
    57a0:	3e800513          	li	a0,1000
    57a4:	00002097          	auipc	ra,0x2
    57a8:	96c080e7          	jalr	-1684(ra) # 7110 <sleep>
    57ac:	ff5ff06f          	j	57a0 <sbrkfail+0x9c>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    57b0:	00490913          	add	s2,s2,4
    57b4:	03390863          	beq	s2,s3,57e4 <sbrkfail+0xe0>
    if((pids[i] = fork()) == 0){
    57b8:	00002097          	auipc	ra,0x2
    57bc:	874080e7          	jalr	-1932(ra) # 702c <fork>
    57c0:	00a92023          	sw	a0,0(s2)
    57c4:	fa0506e3          	beqz	a0,5770 <sbrkfail+0x6c>
    if(pids[i] != -1)
    57c8:	ff4504e3          	beq	a0,s4,57b0 <sbrkfail+0xac>
      read(fds[0], &scratch, 1);
    57cc:	00100613          	li	a2,1
    57d0:	faf40593          	add	a1,s0,-81
    57d4:	fb042503          	lw	a0,-80(s0)
    57d8:	00002097          	auipc	ra,0x2
    57dc:	884080e7          	jalr	-1916(ra) # 705c <read>
    57e0:	fd1ff06f          	j	57b0 <sbrkfail+0xac>
  c = sbrk(PGSIZE);
    57e4:	00001537          	lui	a0,0x1
    57e8:	00002097          	auipc	ra,0x2
    57ec:	91c080e7          	jalr	-1764(ra) # 7104 <sbrk>
    57f0:	00050a13          	mv	s4,a0
    if(pids[i] == -1)
    57f4:	fff00913          	li	s2,-1
    57f8:	00c0006f          	j	5804 <sbrkfail+0x100>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    57fc:	00448493          	add	s1,s1,4
    5800:	03348263          	beq	s1,s3,5824 <sbrkfail+0x120>
    if(pids[i] == -1)
    5804:	0004a503          	lw	a0,0(s1)
    5808:	ff250ae3          	beq	a0,s2,57fc <sbrkfail+0xf8>
    kill(pids[i]);
    580c:	00002097          	auipc	ra,0x2
    5810:	874080e7          	jalr	-1932(ra) # 7080 <kill>
    wait(0);
    5814:	00000513          	li	a0,0
    5818:	00002097          	auipc	ra,0x2
    581c:	82c080e7          	jalr	-2004(ra) # 7044 <wait>
    5820:	fddff06f          	j	57fc <sbrkfail+0xf8>
  if(c == (char*)0xffffffffffffffffL){
    5824:	fff00793          	li	a5,-1
    5828:	04fa0e63          	beq	s4,a5,5884 <sbrkfail+0x180>
  pid = fork();
    582c:	00002097          	auipc	ra,0x2
    5830:	800080e7          	jalr	-2048(ra) # 702c <fork>
    5834:	00050493          	mv	s1,a0
  if(pid < 0){
    5838:	06054663          	bltz	a0,58a4 <sbrkfail+0x1a0>
  if(pid == 0){
    583c:	08050463          	beqz	a0,58c4 <sbrkfail+0x1c0>
  wait(&xstatus);
    5840:	fbc40513          	add	a0,s0,-68
    5844:	00002097          	auipc	ra,0x2
    5848:	800080e7          	jalr	-2048(ra) # 7044 <wait>
  if(xstatus != -1 && xstatus != 2)
    584c:	fbc42783          	lw	a5,-68(s0)
    5850:	fff00713          	li	a4,-1
    5854:	00e78663          	beq	a5,a4,5860 <sbrkfail+0x15c>
    5858:	00200713          	li	a4,2
    585c:	0ce79463          	bne	a5,a4,5924 <sbrkfail+0x220>
}
    5860:	07813083          	ld	ra,120(sp)
    5864:	07013403          	ld	s0,112(sp)
    5868:	06813483          	ld	s1,104(sp)
    586c:	06013903          	ld	s2,96(sp)
    5870:	05813983          	ld	s3,88(sp)
    5874:	05013a03          	ld	s4,80(sp)
    5878:	04813a83          	ld	s5,72(sp)
    587c:	08010113          	add	sp,sp,128
    5880:	00008067          	ret
    printf("%s: failed sbrk leaked memory\n", s);
    5884:	000a8593          	mv	a1,s5
    5888:	00004517          	auipc	a0,0x4
    588c:	af850513          	add	a0,a0,-1288 # 9380 <malloc+0x1d68>
    5890:	00002097          	auipc	ra,0x2
    5894:	c84080e7          	jalr	-892(ra) # 7514 <printf>
    exit(1);
    5898:	00100513          	li	a0,1
    589c:	00001097          	auipc	ra,0x1
    58a0:	79c080e7          	jalr	1948(ra) # 7038 <exit>
    printf("%s: fork failed\n", s);
    58a4:	000a8593          	mv	a1,s5
    58a8:	00002517          	auipc	a0,0x2
    58ac:	77850513          	add	a0,a0,1912 # 8020 <malloc+0xa08>
    58b0:	00002097          	auipc	ra,0x2
    58b4:	c64080e7          	jalr	-924(ra) # 7514 <printf>
    exit(1);
    58b8:	00100513          	li	a0,1
    58bc:	00001097          	auipc	ra,0x1
    58c0:	77c080e7          	jalr	1916(ra) # 7038 <exit>
    a = sbrk(0);
    58c4:	00000513          	li	a0,0
    58c8:	00002097          	auipc	ra,0x2
    58cc:	83c080e7          	jalr	-1988(ra) # 7104 <sbrk>
    58d0:	00050913          	mv	s2,a0
    sbrk(10*BIG);
    58d4:	3e800537          	lui	a0,0x3e800
    58d8:	00002097          	auipc	ra,0x2
    58dc:	82c080e7          	jalr	-2004(ra) # 7104 <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    58e0:	00090793          	mv	a5,s2
    58e4:	3e800737          	lui	a4,0x3e800
    58e8:	00e90933          	add	s2,s2,a4
    58ec:	00001737          	lui	a4,0x1
      n += *(a+i);
    58f0:	0007c683          	lbu	a3,0(a5) # 6400000 <base+0x63ef388>
    58f4:	009684bb          	addw	s1,a3,s1
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    58f8:	00e787b3          	add	a5,a5,a4
    58fc:	ff279ae3          	bne	a5,s2,58f0 <sbrkfail+0x1ec>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    5900:	00048613          	mv	a2,s1
    5904:	000a8593          	mv	a1,s5
    5908:	00004517          	auipc	a0,0x4
    590c:	a9850513          	add	a0,a0,-1384 # 93a0 <malloc+0x1d88>
    5910:	00002097          	auipc	ra,0x2
    5914:	c04080e7          	jalr	-1020(ra) # 7514 <printf>
    exit(1);
    5918:	00100513          	li	a0,1
    591c:	00001097          	auipc	ra,0x1
    5920:	71c080e7          	jalr	1820(ra) # 7038 <exit>
    exit(1);
    5924:	00100513          	li	a0,1
    5928:	00001097          	auipc	ra,0x1
    592c:	710080e7          	jalr	1808(ra) # 7038 <exit>

0000000000005930 <mem>:
{
    5930:	fc010113          	add	sp,sp,-64
    5934:	02113c23          	sd	ra,56(sp)
    5938:	02813823          	sd	s0,48(sp)
    593c:	02913423          	sd	s1,40(sp)
    5940:	03213023          	sd	s2,32(sp)
    5944:	01313c23          	sd	s3,24(sp)
    5948:	04010413          	add	s0,sp,64
    594c:	00050993          	mv	s3,a0
  if((pid = fork()) == 0){
    5950:	00001097          	auipc	ra,0x1
    5954:	6dc080e7          	jalr	1756(ra) # 702c <fork>
    m1 = 0;
    5958:	00000493          	li	s1,0
    while((m2 = malloc(10001)) != 0){
    595c:	00002937          	lui	s2,0x2
    5960:	71190913          	add	s2,s2,1809 # 2711 <linkunlink+0x71>
  if((pid = fork()) == 0){
    5964:	02050663          	beqz	a0,5990 <mem+0x60>
    wait(&xstatus);
    5968:	fcc40513          	add	a0,s0,-52
    596c:	00001097          	auipc	ra,0x1
    5970:	6d8080e7          	jalr	1752(ra) # 7044 <wait>
    if(xstatus == -1){
    5974:	fcc42503          	lw	a0,-52(s0)
    5978:	fff00793          	li	a5,-1
    597c:	08f50063          	beq	a0,a5,59fc <mem+0xcc>
    exit(xstatus);
    5980:	00001097          	auipc	ra,0x1
    5984:	6b8080e7          	jalr	1720(ra) # 7038 <exit>
      *(char**)m2 = m1;
    5988:	00953023          	sd	s1,0(a0)
      m1 = m2;
    598c:	00050493          	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    5990:	00090513          	mv	a0,s2
    5994:	00002097          	auipc	ra,0x2
    5998:	c84080e7          	jalr	-892(ra) # 7618 <malloc>
    599c:	fe0516e3          	bnez	a0,5988 <mem+0x58>
    while(m1){
    59a0:	00048c63          	beqz	s1,59b8 <mem+0x88>
      m2 = *(char**)m1;
    59a4:	00048513          	mv	a0,s1
    59a8:	0004b483          	ld	s1,0(s1)
      free(m1);
    59ac:	00002097          	auipc	ra,0x2
    59b0:	bbc080e7          	jalr	-1092(ra) # 7568 <free>
    while(m1){
    59b4:	fe0498e3          	bnez	s1,59a4 <mem+0x74>
    m1 = malloc(1024*20);
    59b8:	00005537          	lui	a0,0x5
    59bc:	00002097          	auipc	ra,0x2
    59c0:	c5c080e7          	jalr	-932(ra) # 7618 <malloc>
    if(m1 == 0){
    59c4:	00050c63          	beqz	a0,59dc <mem+0xac>
    free(m1);
    59c8:	00002097          	auipc	ra,0x2
    59cc:	ba0080e7          	jalr	-1120(ra) # 7568 <free>
    exit(0);
    59d0:	00000513          	li	a0,0
    59d4:	00001097          	auipc	ra,0x1
    59d8:	664080e7          	jalr	1636(ra) # 7038 <exit>
      printf("couldn't allocate mem?!!\n", s);
    59dc:	00098593          	mv	a1,s3
    59e0:	00004517          	auipc	a0,0x4
    59e4:	9f050513          	add	a0,a0,-1552 # 93d0 <malloc+0x1db8>
    59e8:	00002097          	auipc	ra,0x2
    59ec:	b2c080e7          	jalr	-1236(ra) # 7514 <printf>
      exit(1);
    59f0:	00100513          	li	a0,1
    59f4:	00001097          	auipc	ra,0x1
    59f8:	644080e7          	jalr	1604(ra) # 7038 <exit>
      exit(0);
    59fc:	00000513          	li	a0,0
    5a00:	00001097          	auipc	ra,0x1
    5a04:	638080e7          	jalr	1592(ra) # 7038 <exit>

0000000000005a08 <sharedfd>:
{
    5a08:	f9010113          	add	sp,sp,-112
    5a0c:	06113423          	sd	ra,104(sp)
    5a10:	06813023          	sd	s0,96(sp)
    5a14:	04913c23          	sd	s1,88(sp)
    5a18:	05213823          	sd	s2,80(sp)
    5a1c:	05313423          	sd	s3,72(sp)
    5a20:	05413023          	sd	s4,64(sp)
    5a24:	03513c23          	sd	s5,56(sp)
    5a28:	03613823          	sd	s6,48(sp)
    5a2c:	03713423          	sd	s7,40(sp)
    5a30:	07010413          	add	s0,sp,112
    5a34:	00050a13          	mv	s4,a0
  unlink("sharedfd");
    5a38:	00004517          	auipc	a0,0x4
    5a3c:	9b850513          	add	a0,a0,-1608 # 93f0 <malloc+0x1dd8>
    5a40:	00001097          	auipc	ra,0x1
    5a44:	670080e7          	jalr	1648(ra) # 70b0 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    5a48:	20200593          	li	a1,514
    5a4c:	00004517          	auipc	a0,0x4
    5a50:	9a450513          	add	a0,a0,-1628 # 93f0 <malloc+0x1dd8>
    5a54:	00001097          	auipc	ra,0x1
    5a58:	644080e7          	jalr	1604(ra) # 7098 <open>
  if(fd < 0){
    5a5c:	06054463          	bltz	a0,5ac4 <sharedfd+0xbc>
    5a60:	00050913          	mv	s2,a0
  pid = fork();
    5a64:	00001097          	auipc	ra,0x1
    5a68:	5c8080e7          	jalr	1480(ra) # 702c <fork>
    5a6c:	00050993          	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    5a70:	07000593          	li	a1,112
    5a74:	00051463          	bnez	a0,5a7c <sharedfd+0x74>
    5a78:	06300593          	li	a1,99
    5a7c:	00a00613          	li	a2,10
    5a80:	fa040513          	add	a0,s0,-96
    5a84:	00001097          	auipc	ra,0x1
    5a88:	2a0080e7          	jalr	672(ra) # 6d24 <memset>
    5a8c:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    5a90:	00a00613          	li	a2,10
    5a94:	fa040593          	add	a1,s0,-96
    5a98:	00090513          	mv	a0,s2
    5a9c:	00001097          	auipc	ra,0x1
    5aa0:	5cc080e7          	jalr	1484(ra) # 7068 <write>
    5aa4:	00a00793          	li	a5,10
    5aa8:	02f51e63          	bne	a0,a5,5ae4 <sharedfd+0xdc>
  for(i = 0; i < N; i++){
    5aac:	fff4849b          	addw	s1,s1,-1
    5ab0:	fe0490e3          	bnez	s1,5a90 <sharedfd+0x88>
  if(pid == 0) {
    5ab4:	04099863          	bnez	s3,5b04 <sharedfd+0xfc>
    exit(0);
    5ab8:	00000513          	li	a0,0
    5abc:	00001097          	auipc	ra,0x1
    5ac0:	57c080e7          	jalr	1404(ra) # 7038 <exit>
    printf("%s: cannot open sharedfd for writing", s);
    5ac4:	000a0593          	mv	a1,s4
    5ac8:	00004517          	auipc	a0,0x4
    5acc:	93850513          	add	a0,a0,-1736 # 9400 <malloc+0x1de8>
    5ad0:	00002097          	auipc	ra,0x2
    5ad4:	a44080e7          	jalr	-1468(ra) # 7514 <printf>
    exit(1);
    5ad8:	00100513          	li	a0,1
    5adc:	00001097          	auipc	ra,0x1
    5ae0:	55c080e7          	jalr	1372(ra) # 7038 <exit>
      printf("%s: write sharedfd failed\n", s);
    5ae4:	000a0593          	mv	a1,s4
    5ae8:	00004517          	auipc	a0,0x4
    5aec:	94050513          	add	a0,a0,-1728 # 9428 <malloc+0x1e10>
    5af0:	00002097          	auipc	ra,0x2
    5af4:	a24080e7          	jalr	-1500(ra) # 7514 <printf>
      exit(1);
    5af8:	00100513          	li	a0,1
    5afc:	00001097          	auipc	ra,0x1
    5b00:	53c080e7          	jalr	1340(ra) # 7038 <exit>
    wait(&xstatus);
    5b04:	f9c40513          	add	a0,s0,-100
    5b08:	00001097          	auipc	ra,0x1
    5b0c:	53c080e7          	jalr	1340(ra) # 7044 <wait>
    if(xstatus != 0)
    5b10:	f9c42983          	lw	s3,-100(s0)
    5b14:	00098863          	beqz	s3,5b24 <sharedfd+0x11c>
      exit(xstatus);
    5b18:	00098513          	mv	a0,s3
    5b1c:	00001097          	auipc	ra,0x1
    5b20:	51c080e7          	jalr	1308(ra) # 7038 <exit>
  close(fd);
    5b24:	00090513          	mv	a0,s2
    5b28:	00001097          	auipc	ra,0x1
    5b2c:	54c080e7          	jalr	1356(ra) # 7074 <close>
  fd = open("sharedfd", 0);
    5b30:	00000593          	li	a1,0
    5b34:	00004517          	auipc	a0,0x4
    5b38:	8bc50513          	add	a0,a0,-1860 # 93f0 <malloc+0x1dd8>
    5b3c:	00001097          	auipc	ra,0x1
    5b40:	55c080e7          	jalr	1372(ra) # 7098 <open>
    5b44:	00050b93          	mv	s7,a0
  nc = np = 0;
    5b48:	00098a93          	mv	s5,s3
  if(fd < 0){
    5b4c:	02054863          	bltz	a0,5b7c <sharedfd+0x174>
    5b50:	faa40913          	add	s2,s0,-86
      if(buf[i] == 'c')
    5b54:	06300493          	li	s1,99
      if(buf[i] == 'p')
    5b58:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    5b5c:	00a00613          	li	a2,10
    5b60:	fa040593          	add	a1,s0,-96
    5b64:	000b8513          	mv	a0,s7
    5b68:	00001097          	auipc	ra,0x1
    5b6c:	4f4080e7          	jalr	1268(ra) # 705c <read>
    5b70:	04a05663          	blez	a0,5bbc <sharedfd+0x1b4>
    5b74:	fa040793          	add	a5,s0,-96
    5b78:	0300006f          	j	5ba8 <sharedfd+0x1a0>
    printf("%s: cannot open sharedfd for reading\n", s);
    5b7c:	000a0593          	mv	a1,s4
    5b80:	00004517          	auipc	a0,0x4
    5b84:	8c850513          	add	a0,a0,-1848 # 9448 <malloc+0x1e30>
    5b88:	00002097          	auipc	ra,0x2
    5b8c:	98c080e7          	jalr	-1652(ra) # 7514 <printf>
    exit(1);
    5b90:	00100513          	li	a0,1
    5b94:	00001097          	auipc	ra,0x1
    5b98:	4a4080e7          	jalr	1188(ra) # 7038 <exit>
        nc++;
    5b9c:	0019899b          	addw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    5ba0:	00178793          	add	a5,a5,1
    5ba4:	fb278ce3          	beq	a5,s2,5b5c <sharedfd+0x154>
      if(buf[i] == 'c')
    5ba8:	0007c703          	lbu	a4,0(a5)
    5bac:	fe9708e3          	beq	a4,s1,5b9c <sharedfd+0x194>
      if(buf[i] == 'p')
    5bb0:	ff6718e3          	bne	a4,s6,5ba0 <sharedfd+0x198>
        np++;
    5bb4:	001a8a9b          	addw	s5,s5,1
    5bb8:	fe9ff06f          	j	5ba0 <sharedfd+0x198>
  close(fd);
    5bbc:	000b8513          	mv	a0,s7
    5bc0:	00001097          	auipc	ra,0x1
    5bc4:	4b4080e7          	jalr	1204(ra) # 7074 <close>
  unlink("sharedfd");
    5bc8:	00004517          	auipc	a0,0x4
    5bcc:	82850513          	add	a0,a0,-2008 # 93f0 <malloc+0x1dd8>
    5bd0:	00001097          	auipc	ra,0x1
    5bd4:	4e0080e7          	jalr	1248(ra) # 70b0 <unlink>
  if(nc == N*SZ && np == N*SZ){
    5bd8:	000027b7          	lui	a5,0x2
    5bdc:	71078793          	add	a5,a5,1808 # 2710 <linkunlink+0x70>
    5be0:	00f99863          	bne	s3,a5,5bf0 <sharedfd+0x1e8>
    5be4:	000027b7          	lui	a5,0x2
    5be8:	71078793          	add	a5,a5,1808 # 2710 <linkunlink+0x70>
    5bec:	02fa8263          	beq	s5,a5,5c10 <sharedfd+0x208>
    printf("%s: nc/np test fails\n", s);
    5bf0:	000a0593          	mv	a1,s4
    5bf4:	00004517          	auipc	a0,0x4
    5bf8:	87c50513          	add	a0,a0,-1924 # 9470 <malloc+0x1e58>
    5bfc:	00002097          	auipc	ra,0x2
    5c00:	918080e7          	jalr	-1768(ra) # 7514 <printf>
    exit(1);
    5c04:	00100513          	li	a0,1
    5c08:	00001097          	auipc	ra,0x1
    5c0c:	430080e7          	jalr	1072(ra) # 7038 <exit>
    exit(0);
    5c10:	00000513          	li	a0,0
    5c14:	00001097          	auipc	ra,0x1
    5c18:	424080e7          	jalr	1060(ra) # 7038 <exit>

0000000000005c1c <fourfiles>:
{
    5c1c:	f6010113          	add	sp,sp,-160
    5c20:	08113c23          	sd	ra,152(sp)
    5c24:	08813823          	sd	s0,144(sp)
    5c28:	08913423          	sd	s1,136(sp)
    5c2c:	09213023          	sd	s2,128(sp)
    5c30:	07313c23          	sd	s3,120(sp)
    5c34:	07413823          	sd	s4,112(sp)
    5c38:	07513423          	sd	s5,104(sp)
    5c3c:	07613023          	sd	s6,96(sp)
    5c40:	05713c23          	sd	s7,88(sp)
    5c44:	05813823          	sd	s8,80(sp)
    5c48:	05913423          	sd	s9,72(sp)
    5c4c:	05a13023          	sd	s10,64(sp)
    5c50:	03b13c23          	sd	s11,56(sp)
    5c54:	0a010413          	add	s0,sp,160
    5c58:	00050c93          	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    5c5c:	00004797          	auipc	a5,0x4
    5c60:	82c78793          	add	a5,a5,-2004 # 9488 <malloc+0x1e70>
    5c64:	f6f43823          	sd	a5,-144(s0)
    5c68:	00004797          	auipc	a5,0x4
    5c6c:	82878793          	add	a5,a5,-2008 # 9490 <malloc+0x1e78>
    5c70:	f6f43c23          	sd	a5,-136(s0)
    5c74:	00004797          	auipc	a5,0x4
    5c78:	82478793          	add	a5,a5,-2012 # 9498 <malloc+0x1e80>
    5c7c:	f8f43023          	sd	a5,-128(s0)
    5c80:	00004797          	auipc	a5,0x4
    5c84:	82078793          	add	a5,a5,-2016 # 94a0 <malloc+0x1e88>
    5c88:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    5c8c:	f7040b93          	add	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    5c90:	000b8913          	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    5c94:	00000493          	li	s1,0
    5c98:	00400a13          	li	s4,4
    fname = names[pi];
    5c9c:	00093983          	ld	s3,0(s2)
    unlink(fname);
    5ca0:	00098513          	mv	a0,s3
    5ca4:	00001097          	auipc	ra,0x1
    5ca8:	40c080e7          	jalr	1036(ra) # 70b0 <unlink>
    pid = fork();
    5cac:	00001097          	auipc	ra,0x1
    5cb0:	380080e7          	jalr	896(ra) # 702c <fork>
    if(pid < 0){
    5cb4:	04054863          	bltz	a0,5d04 <fourfiles+0xe8>
    if(pid == 0){
    5cb8:	06050663          	beqz	a0,5d24 <fourfiles+0x108>
  for(pi = 0; pi < NCHILD; pi++){
    5cbc:	0014849b          	addw	s1,s1,1
    5cc0:	00890913          	add	s2,s2,8
    5cc4:	fd449ce3          	bne	s1,s4,5c9c <fourfiles+0x80>
    5cc8:	00400493          	li	s1,4
    wait(&xstatus);
    5ccc:	f6c40513          	add	a0,s0,-148
    5cd0:	00001097          	auipc	ra,0x1
    5cd4:	374080e7          	jalr	884(ra) # 7044 <wait>
    if(xstatus != 0)
    5cd8:	f6c42a83          	lw	s5,-148(s0)
    5cdc:	0e0a9a63          	bnez	s5,5dd0 <fourfiles+0x1b4>
  for(pi = 0; pi < NCHILD; pi++){
    5ce0:	fff4849b          	addw	s1,s1,-1
    5ce4:	fe0494e3          	bnez	s1,5ccc <fourfiles+0xb0>
    5ce8:	03000b13          	li	s6,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    5cec:	00008a17          	auipc	s4,0x8
    5cf0:	f8ca0a13          	add	s4,s4,-116 # dc78 <buf>
    if(total != N*SZ){
    5cf4:	00001d37          	lui	s10,0x1
    5cf8:	770d0d13          	add	s10,s10,1904 # 1770 <bigdir+0x1a4>
  for(i = 0; i < NCHILD; i++){
    5cfc:	03400d93          	li	s11,52
    5d00:	1600006f          	j	5e60 <fourfiles+0x244>
      printf("fork failed\n", s);
    5d04:	000c8593          	mv	a1,s9
    5d08:	00002517          	auipc	a0,0x2
    5d0c:	72050513          	add	a0,a0,1824 # 8428 <malloc+0xe10>
    5d10:	00002097          	auipc	ra,0x2
    5d14:	804080e7          	jalr	-2044(ra) # 7514 <printf>
      exit(1);
    5d18:	00100513          	li	a0,1
    5d1c:	00001097          	auipc	ra,0x1
    5d20:	31c080e7          	jalr	796(ra) # 7038 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    5d24:	20200593          	li	a1,514
    5d28:	00098513          	mv	a0,s3
    5d2c:	00001097          	auipc	ra,0x1
    5d30:	36c080e7          	jalr	876(ra) # 7098 <open>
    5d34:	00050913          	mv	s2,a0
      if(fd < 0){
    5d38:	04054e63          	bltz	a0,5d94 <fourfiles+0x178>
      memset(buf, '0'+pi, SZ);
    5d3c:	1f400613          	li	a2,500
    5d40:	0304859b          	addw	a1,s1,48
    5d44:	00008517          	auipc	a0,0x8
    5d48:	f3450513          	add	a0,a0,-204 # dc78 <buf>
    5d4c:	00001097          	auipc	ra,0x1
    5d50:	fd8080e7          	jalr	-40(ra) # 6d24 <memset>
    5d54:	00c00493          	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    5d58:	00008997          	auipc	s3,0x8
    5d5c:	f2098993          	add	s3,s3,-224 # dc78 <buf>
    5d60:	1f400613          	li	a2,500
    5d64:	00098593          	mv	a1,s3
    5d68:	00090513          	mv	a0,s2
    5d6c:	00001097          	auipc	ra,0x1
    5d70:	2fc080e7          	jalr	764(ra) # 7068 <write>
    5d74:	00050593          	mv	a1,a0
    5d78:	1f400793          	li	a5,500
    5d7c:	02f51c63          	bne	a0,a5,5db4 <fourfiles+0x198>
      for(i = 0; i < N; i++){
    5d80:	fff4849b          	addw	s1,s1,-1
    5d84:	fc049ee3          	bnez	s1,5d60 <fourfiles+0x144>
      exit(0);
    5d88:	00000513          	li	a0,0
    5d8c:	00001097          	auipc	ra,0x1
    5d90:	2ac080e7          	jalr	684(ra) # 7038 <exit>
        printf("create failed\n", s);
    5d94:	000c8593          	mv	a1,s9
    5d98:	00003517          	auipc	a0,0x3
    5d9c:	71050513          	add	a0,a0,1808 # 94a8 <malloc+0x1e90>
    5da0:	00001097          	auipc	ra,0x1
    5da4:	774080e7          	jalr	1908(ra) # 7514 <printf>
        exit(1);
    5da8:	00100513          	li	a0,1
    5dac:	00001097          	auipc	ra,0x1
    5db0:	28c080e7          	jalr	652(ra) # 7038 <exit>
          printf("write failed %d\n", n);
    5db4:	00003517          	auipc	a0,0x3
    5db8:	70450513          	add	a0,a0,1796 # 94b8 <malloc+0x1ea0>
    5dbc:	00001097          	auipc	ra,0x1
    5dc0:	758080e7          	jalr	1880(ra) # 7514 <printf>
          exit(1);
    5dc4:	00100513          	li	a0,1
    5dc8:	00001097          	auipc	ra,0x1
    5dcc:	270080e7          	jalr	624(ra) # 7038 <exit>
      exit(xstatus);
    5dd0:	000a8513          	mv	a0,s5
    5dd4:	00001097          	auipc	ra,0x1
    5dd8:	264080e7          	jalr	612(ra) # 7038 <exit>
          printf("wrong char\n", s);
    5ddc:	000c8593          	mv	a1,s9
    5de0:	00003517          	auipc	a0,0x3
    5de4:	6f050513          	add	a0,a0,1776 # 94d0 <malloc+0x1eb8>
    5de8:	00001097          	auipc	ra,0x1
    5dec:	72c080e7          	jalr	1836(ra) # 7514 <printf>
          exit(1);
    5df0:	00100513          	li	a0,1
    5df4:	00001097          	auipc	ra,0x1
    5df8:	244080e7          	jalr	580(ra) # 7038 <exit>
      total += n;
    5dfc:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    5e00:	00003637          	lui	a2,0x3
    5e04:	000a0593          	mv	a1,s4
    5e08:	00098513          	mv	a0,s3
    5e0c:	00001097          	auipc	ra,0x1
    5e10:	250080e7          	jalr	592(ra) # 705c <read>
    5e14:	02a05263          	blez	a0,5e38 <fourfiles+0x21c>
    5e18:	00008797          	auipc	a5,0x8
    5e1c:	e6078793          	add	a5,a5,-416 # dc78 <buf>
    5e20:	00f506b3          	add	a3,a0,a5
        if(buf[j] != '0'+i){
    5e24:	0007c703          	lbu	a4,0(a5)
    5e28:	fa971ae3          	bne	a4,s1,5ddc <fourfiles+0x1c0>
      for(j = 0; j < n; j++){
    5e2c:	00178793          	add	a5,a5,1
    5e30:	fed79ae3          	bne	a5,a3,5e24 <fourfiles+0x208>
    5e34:	fc9ff06f          	j	5dfc <fourfiles+0x1e0>
    close(fd);
    5e38:	00098513          	mv	a0,s3
    5e3c:	00001097          	auipc	ra,0x1
    5e40:	238080e7          	jalr	568(ra) # 7074 <close>
    if(total != N*SZ){
    5e44:	05a91063          	bne	s2,s10,5e84 <fourfiles+0x268>
    unlink(fname);
    5e48:	000c0513          	mv	a0,s8
    5e4c:	00001097          	auipc	ra,0x1
    5e50:	264080e7          	jalr	612(ra) # 70b0 <unlink>
  for(i = 0; i < NCHILD; i++){
    5e54:	008b8b93          	add	s7,s7,8
    5e58:	001b0b1b          	addw	s6,s6,1
    5e5c:	05bb0463          	beq	s6,s11,5ea4 <fourfiles+0x288>
    fname = names[i];
    5e60:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    5e64:	00000593          	li	a1,0
    5e68:	000c0513          	mv	a0,s8
    5e6c:	00001097          	auipc	ra,0x1
    5e70:	22c080e7          	jalr	556(ra) # 7098 <open>
    5e74:	00050993          	mv	s3,a0
    total = 0;
    5e78:	000a8913          	mv	s2,s5
        if(buf[j] != '0'+i){
    5e7c:	000b049b          	sext.w	s1,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    5e80:	f81ff06f          	j	5e00 <fourfiles+0x1e4>
      printf("wrong length %d\n", total);
    5e84:	00090593          	mv	a1,s2
    5e88:	00003517          	auipc	a0,0x3
    5e8c:	65850513          	add	a0,a0,1624 # 94e0 <malloc+0x1ec8>
    5e90:	00001097          	auipc	ra,0x1
    5e94:	684080e7          	jalr	1668(ra) # 7514 <printf>
      exit(1);
    5e98:	00100513          	li	a0,1
    5e9c:	00001097          	auipc	ra,0x1
    5ea0:	19c080e7          	jalr	412(ra) # 7038 <exit>
}
    5ea4:	09813083          	ld	ra,152(sp)
    5ea8:	09013403          	ld	s0,144(sp)
    5eac:	08813483          	ld	s1,136(sp)
    5eb0:	08013903          	ld	s2,128(sp)
    5eb4:	07813983          	ld	s3,120(sp)
    5eb8:	07013a03          	ld	s4,112(sp)
    5ebc:	06813a83          	ld	s5,104(sp)
    5ec0:	06013b03          	ld	s6,96(sp)
    5ec4:	05813b83          	ld	s7,88(sp)
    5ec8:	05013c03          	ld	s8,80(sp)
    5ecc:	04813c83          	ld	s9,72(sp)
    5ed0:	04013d03          	ld	s10,64(sp)
    5ed4:	03813d83          	ld	s11,56(sp)
    5ed8:	0a010113          	add	sp,sp,160
    5edc:	00008067          	ret

0000000000005ee0 <concreate>:
{
    5ee0:	f6010113          	add	sp,sp,-160
    5ee4:	08113c23          	sd	ra,152(sp)
    5ee8:	08813823          	sd	s0,144(sp)
    5eec:	08913423          	sd	s1,136(sp)
    5ef0:	09213023          	sd	s2,128(sp)
    5ef4:	07313c23          	sd	s3,120(sp)
    5ef8:	07413823          	sd	s4,112(sp)
    5efc:	07513423          	sd	s5,104(sp)
    5f00:	07613023          	sd	s6,96(sp)
    5f04:	05713c23          	sd	s7,88(sp)
    5f08:	0a010413          	add	s0,sp,160
    5f0c:	00050993          	mv	s3,a0
  file[0] = 'C';
    5f10:	04300793          	li	a5,67
    5f14:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    5f18:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    5f1c:	00000913          	li	s2,0
    if(pid && (i % 3) == 1){
    5f20:	00300b13          	li	s6,3
    5f24:	00100a93          	li	s5,1
      link("C0", file);
    5f28:	00003b97          	auipc	s7,0x3
    5f2c:	5d0b8b93          	add	s7,s7,1488 # 94f8 <malloc+0x1ee0>
  for(i = 0; i < N; i++){
    5f30:	02800a13          	li	s4,40
    5f34:	3340006f          	j	6268 <concreate+0x388>
      link("C0", file);
    5f38:	fa840593          	add	a1,s0,-88
    5f3c:	000b8513          	mv	a0,s7
    5f40:	00001097          	auipc	ra,0x1
    5f44:	188080e7          	jalr	392(ra) # 70c8 <link>
    if(pid == 0) {
    5f48:	3040006f          	j	624c <concreate+0x36c>
    } else if(pid == 0 && (i % 5) == 1){
    5f4c:	00500793          	li	a5,5
    5f50:	02f9693b          	remw	s2,s2,a5
    5f54:	00100793          	li	a5,1
    5f58:	02f90c63          	beq	s2,a5,5f90 <concreate+0xb0>
      fd = open(file, O_CREATE | O_RDWR);
    5f5c:	20200593          	li	a1,514
    5f60:	fa840513          	add	a0,s0,-88
    5f64:	00001097          	auipc	ra,0x1
    5f68:	134080e7          	jalr	308(ra) # 7098 <open>
      if(fd < 0){
    5f6c:	2c055663          	bgez	a0,6238 <concreate+0x358>
        printf("concreate create %s failed\n", file);
    5f70:	fa840593          	add	a1,s0,-88
    5f74:	00003517          	auipc	a0,0x3
    5f78:	58c50513          	add	a0,a0,1420 # 9500 <malloc+0x1ee8>
    5f7c:	00001097          	auipc	ra,0x1
    5f80:	598080e7          	jalr	1432(ra) # 7514 <printf>
        exit(1);
    5f84:	00100513          	li	a0,1
    5f88:	00001097          	auipc	ra,0x1
    5f8c:	0b0080e7          	jalr	176(ra) # 7038 <exit>
      link("C0", file);
    5f90:	fa840593          	add	a1,s0,-88
    5f94:	00003517          	auipc	a0,0x3
    5f98:	56450513          	add	a0,a0,1380 # 94f8 <malloc+0x1ee0>
    5f9c:	00001097          	auipc	ra,0x1
    5fa0:	12c080e7          	jalr	300(ra) # 70c8 <link>
      exit(0);
    5fa4:	00000513          	li	a0,0
    5fa8:	00001097          	auipc	ra,0x1
    5fac:	090080e7          	jalr	144(ra) # 7038 <exit>
        exit(1);
    5fb0:	00100513          	li	a0,1
    5fb4:	00001097          	auipc	ra,0x1
    5fb8:	084080e7          	jalr	132(ra) # 7038 <exit>
  memset(fa, 0, sizeof(fa));
    5fbc:	02800613          	li	a2,40
    5fc0:	00000593          	li	a1,0
    5fc4:	f8040513          	add	a0,s0,-128
    5fc8:	00001097          	auipc	ra,0x1
    5fcc:	d5c080e7          	jalr	-676(ra) # 6d24 <memset>
  fd = open(".", 0);
    5fd0:	00000593          	li	a1,0
    5fd4:	00002517          	auipc	a0,0x2
    5fd8:	eac50513          	add	a0,a0,-340 # 7e80 <malloc+0x868>
    5fdc:	00001097          	auipc	ra,0x1
    5fe0:	0bc080e7          	jalr	188(ra) # 7098 <open>
    5fe4:	00050913          	mv	s2,a0
  n = 0;
    5fe8:	00048a93          	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    5fec:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    5ff0:	02700b13          	li	s6,39
      fa[i] = 1;
    5ff4:	00100b93          	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    5ff8:	01000613          	li	a2,16
    5ffc:	f7040593          	add	a1,s0,-144
    6000:	00090513          	mv	a0,s2
    6004:	00001097          	auipc	ra,0x1
    6008:	058080e7          	jalr	88(ra) # 705c <read>
    600c:	08a05c63          	blez	a0,60a4 <concreate+0x1c4>
    if(de.inum == 0)
    6010:	f7045783          	lhu	a5,-144(s0)
    6014:	fe0782e3          	beqz	a5,5ff8 <concreate+0x118>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    6018:	f7244783          	lbu	a5,-142(s0)
    601c:	fd479ee3          	bne	a5,s4,5ff8 <concreate+0x118>
    6020:	f7444783          	lbu	a5,-140(s0)
    6024:	fc079ae3          	bnez	a5,5ff8 <concreate+0x118>
      i = de.name[1] - '0';
    6028:	f7344783          	lbu	a5,-141(s0)
    602c:	fd07879b          	addw	a5,a5,-48
    6030:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    6034:	02eb6463          	bltu	s6,a4,605c <concreate+0x17c>
      if(fa[i]){
    6038:	fb070793          	add	a5,a4,-80 # fb0 <writebig+0x154>
    603c:	008787b3          	add	a5,a5,s0
    6040:	fd07c783          	lbu	a5,-48(a5)
    6044:	02079e63          	bnez	a5,6080 <concreate+0x1a0>
      fa[i] = 1;
    6048:	fb070793          	add	a5,a4,-80
    604c:	00878733          	add	a4,a5,s0
    6050:	fd770823          	sb	s7,-48(a4)
      n++;
    6054:	001a8a9b          	addw	s5,s5,1
    6058:	fa1ff06f          	j	5ff8 <concreate+0x118>
        printf("%s: concreate weird file %s\n", s, de.name);
    605c:	f7240613          	add	a2,s0,-142
    6060:	00098593          	mv	a1,s3
    6064:	00003517          	auipc	a0,0x3
    6068:	4bc50513          	add	a0,a0,1212 # 9520 <malloc+0x1f08>
    606c:	00001097          	auipc	ra,0x1
    6070:	4a8080e7          	jalr	1192(ra) # 7514 <printf>
        exit(1);
    6074:	00100513          	li	a0,1
    6078:	00001097          	auipc	ra,0x1
    607c:	fc0080e7          	jalr	-64(ra) # 7038 <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    6080:	f7240613          	add	a2,s0,-142
    6084:	00098593          	mv	a1,s3
    6088:	00003517          	auipc	a0,0x3
    608c:	4b850513          	add	a0,a0,1208 # 9540 <malloc+0x1f28>
    6090:	00001097          	auipc	ra,0x1
    6094:	484080e7          	jalr	1156(ra) # 7514 <printf>
        exit(1);
    6098:	00100513          	li	a0,1
    609c:	00001097          	auipc	ra,0x1
    60a0:	f9c080e7          	jalr	-100(ra) # 7038 <exit>
  close(fd);
    60a4:	00090513          	mv	a0,s2
    60a8:	00001097          	auipc	ra,0x1
    60ac:	fcc080e7          	jalr	-52(ra) # 7074 <close>
  if(n != N){
    60b0:	02800793          	li	a5,40
    60b4:	00fa9a63          	bne	s5,a5,60c8 <concreate+0x1e8>
    if(((i % 3) == 0 && pid == 0) ||
    60b8:	00300a93          	li	s5,3
    60bc:	00100b13          	li	s6,1
  for(i = 0; i < N; i++){
    60c0:	02800a13          	li	s4,40
    60c4:	0ec0006f          	j	61b0 <concreate+0x2d0>
    printf("%s: concreate not enough files in directory listing\n", s);
    60c8:	00098593          	mv	a1,s3
    60cc:	00003517          	auipc	a0,0x3
    60d0:	49c50513          	add	a0,a0,1180 # 9568 <malloc+0x1f50>
    60d4:	00001097          	auipc	ra,0x1
    60d8:	440080e7          	jalr	1088(ra) # 7514 <printf>
    exit(1);
    60dc:	00100513          	li	a0,1
    60e0:	00001097          	auipc	ra,0x1
    60e4:	f58080e7          	jalr	-168(ra) # 7038 <exit>
      printf("%s: fork failed\n", s);
    60e8:	00098593          	mv	a1,s3
    60ec:	00002517          	auipc	a0,0x2
    60f0:	f3450513          	add	a0,a0,-204 # 8020 <malloc+0xa08>
    60f4:	00001097          	auipc	ra,0x1
    60f8:	420080e7          	jalr	1056(ra) # 7514 <printf>
      exit(1);
    60fc:	00100513          	li	a0,1
    6100:	00001097          	auipc	ra,0x1
    6104:	f38080e7          	jalr	-200(ra) # 7038 <exit>
      close(open(file, 0));
    6108:	00000593          	li	a1,0
    610c:	fa840513          	add	a0,s0,-88
    6110:	00001097          	auipc	ra,0x1
    6114:	f88080e7          	jalr	-120(ra) # 7098 <open>
    6118:	00001097          	auipc	ra,0x1
    611c:	f5c080e7          	jalr	-164(ra) # 7074 <close>
      close(open(file, 0));
    6120:	00000593          	li	a1,0
    6124:	fa840513          	add	a0,s0,-88
    6128:	00001097          	auipc	ra,0x1
    612c:	f70080e7          	jalr	-144(ra) # 7098 <open>
    6130:	00001097          	auipc	ra,0x1
    6134:	f44080e7          	jalr	-188(ra) # 7074 <close>
      close(open(file, 0));
    6138:	00000593          	li	a1,0
    613c:	fa840513          	add	a0,s0,-88
    6140:	00001097          	auipc	ra,0x1
    6144:	f58080e7          	jalr	-168(ra) # 7098 <open>
    6148:	00001097          	auipc	ra,0x1
    614c:	f2c080e7          	jalr	-212(ra) # 7074 <close>
      close(open(file, 0));
    6150:	00000593          	li	a1,0
    6154:	fa840513          	add	a0,s0,-88
    6158:	00001097          	auipc	ra,0x1
    615c:	f40080e7          	jalr	-192(ra) # 7098 <open>
    6160:	00001097          	auipc	ra,0x1
    6164:	f14080e7          	jalr	-236(ra) # 7074 <close>
      close(open(file, 0));
    6168:	00000593          	li	a1,0
    616c:	fa840513          	add	a0,s0,-88
    6170:	00001097          	auipc	ra,0x1
    6174:	f28080e7          	jalr	-216(ra) # 7098 <open>
    6178:	00001097          	auipc	ra,0x1
    617c:	efc080e7          	jalr	-260(ra) # 7074 <close>
      close(open(file, 0));
    6180:	00000593          	li	a1,0
    6184:	fa840513          	add	a0,s0,-88
    6188:	00001097          	auipc	ra,0x1
    618c:	f10080e7          	jalr	-240(ra) # 7098 <open>
    6190:	00001097          	auipc	ra,0x1
    6194:	ee4080e7          	jalr	-284(ra) # 7074 <close>
    if(pid == 0)
    6198:	08090a63          	beqz	s2,622c <concreate+0x34c>
      wait(0);
    619c:	00000513          	li	a0,0
    61a0:	00001097          	auipc	ra,0x1
    61a4:	ea4080e7          	jalr	-348(ra) # 7044 <wait>
  for(i = 0; i < N; i++){
    61a8:	0014849b          	addw	s1,s1,1
    61ac:	0f448e63          	beq	s1,s4,62a8 <concreate+0x3c8>
    file[1] = '0' + i;
    61b0:	0304879b          	addw	a5,s1,48
    61b4:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    61b8:	00001097          	auipc	ra,0x1
    61bc:	e74080e7          	jalr	-396(ra) # 702c <fork>
    61c0:	00050913          	mv	s2,a0
    if(pid < 0){
    61c4:	f20542e3          	bltz	a0,60e8 <concreate+0x208>
    if(((i % 3) == 0 && pid == 0) ||
    61c8:	0354e73b          	remw	a4,s1,s5
    61cc:	00a767b3          	or	a5,a4,a0
    61d0:	0007879b          	sext.w	a5,a5
    61d4:	f2078ae3          	beqz	a5,6108 <concreate+0x228>
    61d8:	01671463          	bne	a4,s6,61e0 <concreate+0x300>
       ((i % 3) == 1 && pid != 0)){
    61dc:	f20516e3          	bnez	a0,6108 <concreate+0x228>
      unlink(file);
    61e0:	fa840513          	add	a0,s0,-88
    61e4:	00001097          	auipc	ra,0x1
    61e8:	ecc080e7          	jalr	-308(ra) # 70b0 <unlink>
      unlink(file);
    61ec:	fa840513          	add	a0,s0,-88
    61f0:	00001097          	auipc	ra,0x1
    61f4:	ec0080e7          	jalr	-320(ra) # 70b0 <unlink>
      unlink(file);
    61f8:	fa840513          	add	a0,s0,-88
    61fc:	00001097          	auipc	ra,0x1
    6200:	eb4080e7          	jalr	-332(ra) # 70b0 <unlink>
      unlink(file);
    6204:	fa840513          	add	a0,s0,-88
    6208:	00001097          	auipc	ra,0x1
    620c:	ea8080e7          	jalr	-344(ra) # 70b0 <unlink>
      unlink(file);
    6210:	fa840513          	add	a0,s0,-88
    6214:	00001097          	auipc	ra,0x1
    6218:	e9c080e7          	jalr	-356(ra) # 70b0 <unlink>
      unlink(file);
    621c:	fa840513          	add	a0,s0,-88
    6220:	00001097          	auipc	ra,0x1
    6224:	e90080e7          	jalr	-368(ra) # 70b0 <unlink>
    6228:	f71ff06f          	j	6198 <concreate+0x2b8>
      exit(0);
    622c:	00000513          	li	a0,0
    6230:	00001097          	auipc	ra,0x1
    6234:	e08080e7          	jalr	-504(ra) # 7038 <exit>
      close(fd);
    6238:	00001097          	auipc	ra,0x1
    623c:	e3c080e7          	jalr	-452(ra) # 7074 <close>
    if(pid == 0) {
    6240:	d65ff06f          	j	5fa4 <concreate+0xc4>
      close(fd);
    6244:	00001097          	auipc	ra,0x1
    6248:	e30080e7          	jalr	-464(ra) # 7074 <close>
      wait(&xstatus);
    624c:	f6c40513          	add	a0,s0,-148
    6250:	00001097          	auipc	ra,0x1
    6254:	df4080e7          	jalr	-524(ra) # 7044 <wait>
      if(xstatus != 0)
    6258:	f6c42483          	lw	s1,-148(s0)
    625c:	d4049ae3          	bnez	s1,5fb0 <concreate+0xd0>
  for(i = 0; i < N; i++){
    6260:	0019091b          	addw	s2,s2,1
    6264:	d5490ce3          	beq	s2,s4,5fbc <concreate+0xdc>
    file[1] = '0' + i;
    6268:	0309079b          	addw	a5,s2,48
    626c:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    6270:	fa840513          	add	a0,s0,-88
    6274:	00001097          	auipc	ra,0x1
    6278:	e3c080e7          	jalr	-452(ra) # 70b0 <unlink>
    pid = fork();
    627c:	00001097          	auipc	ra,0x1
    6280:	db0080e7          	jalr	-592(ra) # 702c <fork>
    if(pid && (i % 3) == 1){
    6284:	cc0504e3          	beqz	a0,5f4c <concreate+0x6c>
    6288:	036967bb          	remw	a5,s2,s6
    628c:	cb5786e3          	beq	a5,s5,5f38 <concreate+0x58>
      fd = open(file, O_CREATE | O_RDWR);
    6290:	20200593          	li	a1,514
    6294:	fa840513          	add	a0,s0,-88
    6298:	00001097          	auipc	ra,0x1
    629c:	e00080e7          	jalr	-512(ra) # 7098 <open>
      if(fd < 0){
    62a0:	fa0552e3          	bgez	a0,6244 <concreate+0x364>
    62a4:	ccdff06f          	j	5f70 <concreate+0x90>
}
    62a8:	09813083          	ld	ra,152(sp)
    62ac:	09013403          	ld	s0,144(sp)
    62b0:	08813483          	ld	s1,136(sp)
    62b4:	08013903          	ld	s2,128(sp)
    62b8:	07813983          	ld	s3,120(sp)
    62bc:	07013a03          	ld	s4,112(sp)
    62c0:	06813a83          	ld	s5,104(sp)
    62c4:	06013b03          	ld	s6,96(sp)
    62c8:	05813b83          	ld	s7,88(sp)
    62cc:	0a010113          	add	sp,sp,160
    62d0:	00008067          	ret

00000000000062d4 <bigfile>:
{
    62d4:	fc010113          	add	sp,sp,-64
    62d8:	02113c23          	sd	ra,56(sp)
    62dc:	02813823          	sd	s0,48(sp)
    62e0:	02913423          	sd	s1,40(sp)
    62e4:	03213023          	sd	s2,32(sp)
    62e8:	01313c23          	sd	s3,24(sp)
    62ec:	01413823          	sd	s4,16(sp)
    62f0:	01513423          	sd	s5,8(sp)
    62f4:	04010413          	add	s0,sp,64
    62f8:	00050a93          	mv	s5,a0
  unlink("bigfile.dat");
    62fc:	00003517          	auipc	a0,0x3
    6300:	2a450513          	add	a0,a0,676 # 95a0 <malloc+0x1f88>
    6304:	00001097          	auipc	ra,0x1
    6308:	dac080e7          	jalr	-596(ra) # 70b0 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    630c:	20200593          	li	a1,514
    6310:	00003517          	auipc	a0,0x3
    6314:	29050513          	add	a0,a0,656 # 95a0 <malloc+0x1f88>
    6318:	00001097          	auipc	ra,0x1
    631c:	d80080e7          	jalr	-640(ra) # 7098 <open>
    6320:	00050993          	mv	s3,a0
  for(i = 0; i < N; i++){
    6324:	00000493          	li	s1,0
    memset(buf, i, SZ);
    6328:	00008917          	auipc	s2,0x8
    632c:	95090913          	add	s2,s2,-1712 # dc78 <buf>
  for(i = 0; i < N; i++){
    6330:	01400a13          	li	s4,20
  if(fd < 0){
    6334:	0c054063          	bltz	a0,63f4 <bigfile+0x120>
    memset(buf, i, SZ);
    6338:	25800613          	li	a2,600
    633c:	00048593          	mv	a1,s1
    6340:	00090513          	mv	a0,s2
    6344:	00001097          	auipc	ra,0x1
    6348:	9e0080e7          	jalr	-1568(ra) # 6d24 <memset>
    if(write(fd, buf, SZ) != SZ){
    634c:	25800613          	li	a2,600
    6350:	00090593          	mv	a1,s2
    6354:	00098513          	mv	a0,s3
    6358:	00001097          	auipc	ra,0x1
    635c:	d10080e7          	jalr	-752(ra) # 7068 <write>
    6360:	25800793          	li	a5,600
    6364:	0af51863          	bne	a0,a5,6414 <bigfile+0x140>
  for(i = 0; i < N; i++){
    6368:	0014849b          	addw	s1,s1,1
    636c:	fd4496e3          	bne	s1,s4,6338 <bigfile+0x64>
  close(fd);
    6370:	00098513          	mv	a0,s3
    6374:	00001097          	auipc	ra,0x1
    6378:	d00080e7          	jalr	-768(ra) # 7074 <close>
  fd = open("bigfile.dat", 0);
    637c:	00000593          	li	a1,0
    6380:	00003517          	auipc	a0,0x3
    6384:	22050513          	add	a0,a0,544 # 95a0 <malloc+0x1f88>
    6388:	00001097          	auipc	ra,0x1
    638c:	d10080e7          	jalr	-752(ra) # 7098 <open>
    6390:	00050a13          	mv	s4,a0
  total = 0;
    6394:	00000993          	li	s3,0
  for(i = 0; ; i++){
    6398:	00000493          	li	s1,0
    cc = read(fd, buf, SZ/2);
    639c:	00008917          	auipc	s2,0x8
    63a0:	8dc90913          	add	s2,s2,-1828 # dc78 <buf>
  if(fd < 0){
    63a4:	08054863          	bltz	a0,6434 <bigfile+0x160>
    cc = read(fd, buf, SZ/2);
    63a8:	12c00613          	li	a2,300
    63ac:	00090593          	mv	a1,s2
    63b0:	000a0513          	mv	a0,s4
    63b4:	00001097          	auipc	ra,0x1
    63b8:	ca8080e7          	jalr	-856(ra) # 705c <read>
    if(cc < 0){
    63bc:	08054c63          	bltz	a0,6454 <bigfile+0x180>
    if(cc == 0)
    63c0:	0e050a63          	beqz	a0,64b4 <bigfile+0x1e0>
    if(cc != SZ/2){
    63c4:	12c00793          	li	a5,300
    63c8:	0af51663          	bne	a0,a5,6474 <bigfile+0x1a0>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    63cc:	01f4d79b          	srlw	a5,s1,0x1f
    63d0:	009787bb          	addw	a5,a5,s1
    63d4:	4017d79b          	sraw	a5,a5,0x1
    63d8:	00094703          	lbu	a4,0(s2)
    63dc:	0af71c63          	bne	a4,a5,6494 <bigfile+0x1c0>
    63e0:	12b94703          	lbu	a4,299(s2)
    63e4:	0af71863          	bne	a4,a5,6494 <bigfile+0x1c0>
    total += cc;
    63e8:	12c9899b          	addw	s3,s3,300
  for(i = 0; ; i++){
    63ec:	0014849b          	addw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    63f0:	fb9ff06f          	j	63a8 <bigfile+0xd4>
    printf("%s: cannot create bigfile", s);
    63f4:	000a8593          	mv	a1,s5
    63f8:	00003517          	auipc	a0,0x3
    63fc:	1b850513          	add	a0,a0,440 # 95b0 <malloc+0x1f98>
    6400:	00001097          	auipc	ra,0x1
    6404:	114080e7          	jalr	276(ra) # 7514 <printf>
    exit(1);
    6408:	00100513          	li	a0,1
    640c:	00001097          	auipc	ra,0x1
    6410:	c2c080e7          	jalr	-980(ra) # 7038 <exit>
      printf("%s: write bigfile failed\n", s);
    6414:	000a8593          	mv	a1,s5
    6418:	00003517          	auipc	a0,0x3
    641c:	1b850513          	add	a0,a0,440 # 95d0 <malloc+0x1fb8>
    6420:	00001097          	auipc	ra,0x1
    6424:	0f4080e7          	jalr	244(ra) # 7514 <printf>
      exit(1);
    6428:	00100513          	li	a0,1
    642c:	00001097          	auipc	ra,0x1
    6430:	c0c080e7          	jalr	-1012(ra) # 7038 <exit>
    printf("%s: cannot open bigfile\n", s);
    6434:	000a8593          	mv	a1,s5
    6438:	00003517          	auipc	a0,0x3
    643c:	1b850513          	add	a0,a0,440 # 95f0 <malloc+0x1fd8>
    6440:	00001097          	auipc	ra,0x1
    6444:	0d4080e7          	jalr	212(ra) # 7514 <printf>
    exit(1);
    6448:	00100513          	li	a0,1
    644c:	00001097          	auipc	ra,0x1
    6450:	bec080e7          	jalr	-1044(ra) # 7038 <exit>
      printf("%s: read bigfile failed\n", s);
    6454:	000a8593          	mv	a1,s5
    6458:	00003517          	auipc	a0,0x3
    645c:	1b850513          	add	a0,a0,440 # 9610 <malloc+0x1ff8>
    6460:	00001097          	auipc	ra,0x1
    6464:	0b4080e7          	jalr	180(ra) # 7514 <printf>
      exit(1);
    6468:	00100513          	li	a0,1
    646c:	00001097          	auipc	ra,0x1
    6470:	bcc080e7          	jalr	-1076(ra) # 7038 <exit>
      printf("%s: short read bigfile\n", s);
    6474:	000a8593          	mv	a1,s5
    6478:	00003517          	auipc	a0,0x3
    647c:	1b850513          	add	a0,a0,440 # 9630 <malloc+0x2018>
    6480:	00001097          	auipc	ra,0x1
    6484:	094080e7          	jalr	148(ra) # 7514 <printf>
      exit(1);
    6488:	00100513          	li	a0,1
    648c:	00001097          	auipc	ra,0x1
    6490:	bac080e7          	jalr	-1108(ra) # 7038 <exit>
      printf("%s: read bigfile wrong data\n", s);
    6494:	000a8593          	mv	a1,s5
    6498:	00003517          	auipc	a0,0x3
    649c:	1b050513          	add	a0,a0,432 # 9648 <malloc+0x2030>
    64a0:	00001097          	auipc	ra,0x1
    64a4:	074080e7          	jalr	116(ra) # 7514 <printf>
      exit(1);
    64a8:	00100513          	li	a0,1
    64ac:	00001097          	auipc	ra,0x1
    64b0:	b8c080e7          	jalr	-1140(ra) # 7038 <exit>
  close(fd);
    64b4:	000a0513          	mv	a0,s4
    64b8:	00001097          	auipc	ra,0x1
    64bc:	bbc080e7          	jalr	-1092(ra) # 7074 <close>
  if(total != N*SZ){
    64c0:	000037b7          	lui	a5,0x3
    64c4:	ee078793          	add	a5,a5,-288 # 2ee0 <copyinstr3>
    64c8:	02f99c63          	bne	s3,a5,6500 <bigfile+0x22c>
  unlink("bigfile.dat");
    64cc:	00003517          	auipc	a0,0x3
    64d0:	0d450513          	add	a0,a0,212 # 95a0 <malloc+0x1f88>
    64d4:	00001097          	auipc	ra,0x1
    64d8:	bdc080e7          	jalr	-1060(ra) # 70b0 <unlink>
}
    64dc:	03813083          	ld	ra,56(sp)
    64e0:	03013403          	ld	s0,48(sp)
    64e4:	02813483          	ld	s1,40(sp)
    64e8:	02013903          	ld	s2,32(sp)
    64ec:	01813983          	ld	s3,24(sp)
    64f0:	01013a03          	ld	s4,16(sp)
    64f4:	00813a83          	ld	s5,8(sp)
    64f8:	04010113          	add	sp,sp,64
    64fc:	00008067          	ret
    printf("%s: read bigfile wrong total\n", s);
    6500:	000a8593          	mv	a1,s5
    6504:	00003517          	auipc	a0,0x3
    6508:	16450513          	add	a0,a0,356 # 9668 <malloc+0x2050>
    650c:	00001097          	auipc	ra,0x1
    6510:	008080e7          	jalr	8(ra) # 7514 <printf>
    exit(1);
    6514:	00100513          	li	a0,1
    6518:	00001097          	auipc	ra,0x1
    651c:	b20080e7          	jalr	-1248(ra) # 7038 <exit>

0000000000006520 <fsfull>:
{
    6520:	f6010113          	add	sp,sp,-160
    6524:	08113c23          	sd	ra,152(sp)
    6528:	08813823          	sd	s0,144(sp)
    652c:	08913423          	sd	s1,136(sp)
    6530:	09213023          	sd	s2,128(sp)
    6534:	07313c23          	sd	s3,120(sp)
    6538:	07413823          	sd	s4,112(sp)
    653c:	07513423          	sd	s5,104(sp)
    6540:	07613023          	sd	s6,96(sp)
    6544:	05713c23          	sd	s7,88(sp)
    6548:	05813823          	sd	s8,80(sp)
    654c:	05913423          	sd	s9,72(sp)
    6550:	05a13023          	sd	s10,64(sp)
    6554:	0a010413          	add	s0,sp,160
  printf("fsfull test\n");
    6558:	00003517          	auipc	a0,0x3
    655c:	13050513          	add	a0,a0,304 # 9688 <malloc+0x2070>
    6560:	00001097          	auipc	ra,0x1
    6564:	fb4080e7          	jalr	-76(ra) # 7514 <printf>
  for(nfiles = 0; ; nfiles++){
    6568:	00000493          	li	s1,0
    name[0] = 'f';
    656c:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    6570:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    6574:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    6578:	00a00b13          	li	s6,10
    printf("writing %s\n", name);
    657c:	00003c97          	auipc	s9,0x3
    6580:	11cc8c93          	add	s9,s9,284 # 9698 <malloc+0x2080>
    name[0] = 'f';
    6584:	f7a40023          	sb	s10,-160(s0)
    name[1] = '0' + nfiles / 1000;
    6588:	0384c7bb          	divw	a5,s1,s8
    658c:	0307879b          	addw	a5,a5,48
    6590:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    6594:	0384e7bb          	remw	a5,s1,s8
    6598:	0377c7bb          	divw	a5,a5,s7
    659c:	0307879b          	addw	a5,a5,48
    65a0:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    65a4:	0374e7bb          	remw	a5,s1,s7
    65a8:	0367c7bb          	divw	a5,a5,s6
    65ac:	0307879b          	addw	a5,a5,48
    65b0:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    65b4:	0364e7bb          	remw	a5,s1,s6
    65b8:	0307879b          	addw	a5,a5,48
    65bc:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    65c0:	f60402a3          	sb	zero,-155(s0)
    printf("writing %s\n", name);
    65c4:	f6040593          	add	a1,s0,-160
    65c8:	000c8513          	mv	a0,s9
    65cc:	00001097          	auipc	ra,0x1
    65d0:	f48080e7          	jalr	-184(ra) # 7514 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    65d4:	20200593          	li	a1,514
    65d8:	f6040513          	add	a0,s0,-160
    65dc:	00001097          	auipc	ra,0x1
    65e0:	abc080e7          	jalr	-1348(ra) # 7098 <open>
    65e4:	00050913          	mv	s2,a0
    if(fd < 0){
    65e8:	0c055663          	bgez	a0,66b4 <fsfull+0x194>
      printf("open %s failed\n", name);
    65ec:	f6040593          	add	a1,s0,-160
    65f0:	00003517          	auipc	a0,0x3
    65f4:	0b850513          	add	a0,a0,184 # 96a8 <malloc+0x2090>
    65f8:	00001097          	auipc	ra,0x1
    65fc:	f1c080e7          	jalr	-228(ra) # 7514 <printf>
  while(nfiles >= 0){
    6600:	0604c663          	bltz	s1,666c <fsfull+0x14c>
    name[0] = 'f';
    6604:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    6608:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    660c:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    6610:	00a00913          	li	s2,10
  while(nfiles >= 0){
    6614:	fff00a93          	li	s5,-1
    name[0] = 'f';
    6618:	f7640023          	sb	s6,-160(s0)
    name[1] = '0' + nfiles / 1000;
    661c:	0344c7bb          	divw	a5,s1,s4
    6620:	0307879b          	addw	a5,a5,48
    6624:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    6628:	0344e7bb          	remw	a5,s1,s4
    662c:	0337c7bb          	divw	a5,a5,s3
    6630:	0307879b          	addw	a5,a5,48
    6634:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    6638:	0334e7bb          	remw	a5,s1,s3
    663c:	0327c7bb          	divw	a5,a5,s2
    6640:	0307879b          	addw	a5,a5,48
    6644:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    6648:	0324e7bb          	remw	a5,s1,s2
    664c:	0307879b          	addw	a5,a5,48
    6650:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    6654:	f60402a3          	sb	zero,-155(s0)
    unlink(name);
    6658:	f6040513          	add	a0,s0,-160
    665c:	00001097          	auipc	ra,0x1
    6660:	a54080e7          	jalr	-1452(ra) # 70b0 <unlink>
    nfiles--;
    6664:	fff4849b          	addw	s1,s1,-1
  while(nfiles >= 0){
    6668:	fb5498e3          	bne	s1,s5,6618 <fsfull+0xf8>
  printf("fsfull test finished\n");
    666c:	00003517          	auipc	a0,0x3
    6670:	05c50513          	add	a0,a0,92 # 96c8 <malloc+0x20b0>
    6674:	00001097          	auipc	ra,0x1
    6678:	ea0080e7          	jalr	-352(ra) # 7514 <printf>
}
    667c:	09813083          	ld	ra,152(sp)
    6680:	09013403          	ld	s0,144(sp)
    6684:	08813483          	ld	s1,136(sp)
    6688:	08013903          	ld	s2,128(sp)
    668c:	07813983          	ld	s3,120(sp)
    6690:	07013a03          	ld	s4,112(sp)
    6694:	06813a83          	ld	s5,104(sp)
    6698:	06013b03          	ld	s6,96(sp)
    669c:	05813b83          	ld	s7,88(sp)
    66a0:	05013c03          	ld	s8,80(sp)
    66a4:	04813c83          	ld	s9,72(sp)
    66a8:	04013d03          	ld	s10,64(sp)
    66ac:	0a010113          	add	sp,sp,160
    66b0:	00008067          	ret
    int total = 0;
    66b4:	00000993          	li	s3,0
      int cc = write(fd, buf, BSIZE);
    66b8:	00007a97          	auipc	s5,0x7
    66bc:	5c0a8a93          	add	s5,s5,1472 # dc78 <buf>
      if(cc < BSIZE)
    66c0:	3ff00a13          	li	s4,1023
      int cc = write(fd, buf, BSIZE);
    66c4:	40000613          	li	a2,1024
    66c8:	000a8593          	mv	a1,s5
    66cc:	00090513          	mv	a0,s2
    66d0:	00001097          	auipc	ra,0x1
    66d4:	998080e7          	jalr	-1640(ra) # 7068 <write>
      if(cc < BSIZE)
    66d8:	00aa5663          	bge	s4,a0,66e4 <fsfull+0x1c4>
      total += cc;
    66dc:	00a989bb          	addw	s3,s3,a0
    while(1){
    66e0:	fe5ff06f          	j	66c4 <fsfull+0x1a4>
    printf("wrote %d bytes\n", total);
    66e4:	00098593          	mv	a1,s3
    66e8:	00003517          	auipc	a0,0x3
    66ec:	fd050513          	add	a0,a0,-48 # 96b8 <malloc+0x20a0>
    66f0:	00001097          	auipc	ra,0x1
    66f4:	e24080e7          	jalr	-476(ra) # 7514 <printf>
    close(fd);
    66f8:	00090513          	mv	a0,s2
    66fc:	00001097          	auipc	ra,0x1
    6700:	978080e7          	jalr	-1672(ra) # 7074 <close>
    if(total == 0)
    6704:	ee098ee3          	beqz	s3,6600 <fsfull+0xe0>
  for(nfiles = 0; ; nfiles++){
    6708:	0014849b          	addw	s1,s1,1
    670c:	e79ff06f          	j	6584 <fsfull+0x64>

0000000000006710 <run>:
//

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    6710:	fd010113          	add	sp,sp,-48
    6714:	02113423          	sd	ra,40(sp)
    6718:	02813023          	sd	s0,32(sp)
    671c:	00913c23          	sd	s1,24(sp)
    6720:	01213823          	sd	s2,16(sp)
    6724:	03010413          	add	s0,sp,48
    6728:	00050493          	mv	s1,a0
    672c:	00058913          	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    6730:	00003517          	auipc	a0,0x3
    6734:	fb050513          	add	a0,a0,-80 # 96e0 <malloc+0x20c8>
    6738:	00001097          	auipc	ra,0x1
    673c:	ddc080e7          	jalr	-548(ra) # 7514 <printf>
  if((pid = fork()) < 0) {
    6740:	00001097          	auipc	ra,0x1
    6744:	8ec080e7          	jalr	-1812(ra) # 702c <fork>
    6748:	04054663          	bltz	a0,6794 <run+0x84>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    674c:	06050263          	beqz	a0,67b0 <run+0xa0>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    6750:	fdc40513          	add	a0,s0,-36
    6754:	00001097          	auipc	ra,0x1
    6758:	8f0080e7          	jalr	-1808(ra) # 7044 <wait>
    if(xstatus != 0) 
    675c:	fdc42783          	lw	a5,-36(s0)
    6760:	06078263          	beqz	a5,67c4 <run+0xb4>
      printf("FAILED\n");
    6764:	00003517          	auipc	a0,0x3
    6768:	fa450513          	add	a0,a0,-92 # 9708 <malloc+0x20f0>
    676c:	00001097          	auipc	ra,0x1
    6770:	da8080e7          	jalr	-600(ra) # 7514 <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    6774:	fdc42503          	lw	a0,-36(s0)
  }
}
    6778:	00153513          	seqz	a0,a0
    677c:	02813083          	ld	ra,40(sp)
    6780:	02013403          	ld	s0,32(sp)
    6784:	01813483          	ld	s1,24(sp)
    6788:	01013903          	ld	s2,16(sp)
    678c:	03010113          	add	sp,sp,48
    6790:	00008067          	ret
    printf("runtest: fork error\n");
    6794:	00003517          	auipc	a0,0x3
    6798:	f5c50513          	add	a0,a0,-164 # 96f0 <malloc+0x20d8>
    679c:	00001097          	auipc	ra,0x1
    67a0:	d78080e7          	jalr	-648(ra) # 7514 <printf>
    exit(1);
    67a4:	00100513          	li	a0,1
    67a8:	00001097          	auipc	ra,0x1
    67ac:	890080e7          	jalr	-1904(ra) # 7038 <exit>
    f(s);
    67b0:	00090513          	mv	a0,s2
    67b4:	000480e7          	jalr	s1
    exit(0);
    67b8:	00000513          	li	a0,0
    67bc:	00001097          	auipc	ra,0x1
    67c0:	87c080e7          	jalr	-1924(ra) # 7038 <exit>
      printf("OK\n");
    67c4:	00003517          	auipc	a0,0x3
    67c8:	f4c50513          	add	a0,a0,-180 # 9710 <malloc+0x20f8>
    67cc:	00001097          	auipc	ra,0x1
    67d0:	d48080e7          	jalr	-696(ra) # 7514 <printf>
    67d4:	fa1ff06f          	j	6774 <run+0x64>

00000000000067d8 <runtests>:

int
runtests(struct test *tests, char *justone) {
    67d8:	fe010113          	add	sp,sp,-32
    67dc:	00113c23          	sd	ra,24(sp)
    67e0:	00813823          	sd	s0,16(sp)
    67e4:	00913423          	sd	s1,8(sp)
    67e8:	01213023          	sd	s2,0(sp)
    67ec:	02010413          	add	s0,sp,32
    67f0:	00050493          	mv	s1,a0
    67f4:	00058913          	mv	s2,a1
  for (struct test *t = tests; t->s != 0; t++) {
    67f8:	00853503          	ld	a0,8(a0)
    67fc:	02051663          	bnez	a0,6828 <runtests+0x50>
        printf("SOME TESTS FAILED\n");
        return 1;
      }
    }
  }
  return 0;
    6800:	00000513          	li	a0,0
    6804:	0500006f          	j	6854 <runtests+0x7c>
      if(!run(t->f, t->s)){
    6808:	0084b583          	ld	a1,8(s1)
    680c:	0004b503          	ld	a0,0(s1)
    6810:	00000097          	auipc	ra,0x0
    6814:	f00080e7          	jalr	-256(ra) # 6710 <run>
    6818:	02050463          	beqz	a0,6840 <runtests+0x68>
  for (struct test *t = tests; t->s != 0; t++) {
    681c:	01048493          	add	s1,s1,16
    6820:	0084b503          	ld	a0,8(s1)
    6824:	02050863          	beqz	a0,6854 <runtests+0x7c>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    6828:	fe0900e3          	beqz	s2,6808 <runtests+0x30>
    682c:	00090593          	mv	a1,s2
    6830:	00000097          	auipc	ra,0x0
    6834:	46c080e7          	jalr	1132(ra) # 6c9c <strcmp>
    6838:	fe0512e3          	bnez	a0,681c <runtests+0x44>
    683c:	fcdff06f          	j	6808 <runtests+0x30>
        printf("SOME TESTS FAILED\n");
    6840:	00003517          	auipc	a0,0x3
    6844:	ed850513          	add	a0,a0,-296 # 9718 <malloc+0x2100>
    6848:	00001097          	auipc	ra,0x1
    684c:	ccc080e7          	jalr	-820(ra) # 7514 <printf>
        return 1;
    6850:	00100513          	li	a0,1
}
    6854:	01813083          	ld	ra,24(sp)
    6858:	01013403          	ld	s0,16(sp)
    685c:	00813483          	ld	s1,8(sp)
    6860:	00013903          	ld	s2,0(sp)
    6864:	02010113          	add	sp,sp,32
    6868:	00008067          	ret

000000000000686c <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    686c:	fc010113          	add	sp,sp,-64
    6870:	02113c23          	sd	ra,56(sp)
    6874:	02813823          	sd	s0,48(sp)
    6878:	02913423          	sd	s1,40(sp)
    687c:	03213023          	sd	s2,32(sp)
    6880:	01313c23          	sd	s3,24(sp)
    6884:	04010413          	add	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    6888:	fc840513          	add	a0,s0,-56
    688c:	00000097          	auipc	ra,0x0
    6890:	7c4080e7          	jalr	1988(ra) # 7050 <pipe>
    6894:	08054063          	bltz	a0,6914 <countfree+0xa8>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    6898:	00000097          	auipc	ra,0x0
    689c:	794080e7          	jalr	1940(ra) # 702c <fork>

  if(pid < 0){
    68a0:	08054863          	bltz	a0,6930 <countfree+0xc4>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    68a4:	0a051a63          	bnez	a0,6958 <countfree+0xec>
    close(fds[0]);
    68a8:	fc842503          	lw	a0,-56(s0)
    68ac:	00000097          	auipc	ra,0x0
    68b0:	7c8080e7          	jalr	1992(ra) # 7074 <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    68b4:	fff00913          	li	s2,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    68b8:	00100493          	li	s1,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    68bc:	00001997          	auipc	s3,0x1
    68c0:	f4c98993          	add	s3,s3,-180 # 7808 <malloc+0x1f0>
      uint64 a = (uint64) sbrk(4096);
    68c4:	00001537          	lui	a0,0x1
    68c8:	00001097          	auipc	ra,0x1
    68cc:	83c080e7          	jalr	-1988(ra) # 7104 <sbrk>
      if(a == 0xffffffffffffffff){
    68d0:	07250e63          	beq	a0,s2,694c <countfree+0xe0>
      *(char *)(a + 4096 - 1) = 1;
    68d4:	000017b7          	lui	a5,0x1
    68d8:	00a787b3          	add	a5,a5,a0
    68dc:	fe978fa3          	sb	s1,-1(a5) # fff <writebig+0x1a3>
      if(write(fds[1], "x", 1) != 1){
    68e0:	00048613          	mv	a2,s1
    68e4:	00098593          	mv	a1,s3
    68e8:	fcc42503          	lw	a0,-52(s0)
    68ec:	00000097          	auipc	ra,0x0
    68f0:	77c080e7          	jalr	1916(ra) # 7068 <write>
    68f4:	fc9508e3          	beq	a0,s1,68c4 <countfree+0x58>
        printf("write() failed in countfree()\n");
    68f8:	00003517          	auipc	a0,0x3
    68fc:	e7850513          	add	a0,a0,-392 # 9770 <malloc+0x2158>
    6900:	00001097          	auipc	ra,0x1
    6904:	c14080e7          	jalr	-1004(ra) # 7514 <printf>
        exit(1);
    6908:	00100513          	li	a0,1
    690c:	00000097          	auipc	ra,0x0
    6910:	72c080e7          	jalr	1836(ra) # 7038 <exit>
    printf("pipe() failed in countfree()\n");
    6914:	00003517          	auipc	a0,0x3
    6918:	e1c50513          	add	a0,a0,-484 # 9730 <malloc+0x2118>
    691c:	00001097          	auipc	ra,0x1
    6920:	bf8080e7          	jalr	-1032(ra) # 7514 <printf>
    exit(1);
    6924:	00100513          	li	a0,1
    6928:	00000097          	auipc	ra,0x0
    692c:	710080e7          	jalr	1808(ra) # 7038 <exit>
    printf("fork failed in countfree()\n");
    6930:	00003517          	auipc	a0,0x3
    6934:	e2050513          	add	a0,a0,-480 # 9750 <malloc+0x2138>
    6938:	00001097          	auipc	ra,0x1
    693c:	bdc080e7          	jalr	-1060(ra) # 7514 <printf>
    exit(1);
    6940:	00100513          	li	a0,1
    6944:	00000097          	auipc	ra,0x0
    6948:	6f4080e7          	jalr	1780(ra) # 7038 <exit>
      }
    }

    exit(0);
    694c:	00000513          	li	a0,0
    6950:	00000097          	auipc	ra,0x0
    6954:	6e8080e7          	jalr	1768(ra) # 7038 <exit>
  }

  close(fds[1]);
    6958:	fcc42503          	lw	a0,-52(s0)
    695c:	00000097          	auipc	ra,0x0
    6960:	718080e7          	jalr	1816(ra) # 7074 <close>

  int n = 0;
    6964:	00000493          	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    6968:	00100613          	li	a2,1
    696c:	fc740593          	add	a1,s0,-57
    6970:	fc842503          	lw	a0,-56(s0)
    6974:	00000097          	auipc	ra,0x0
    6978:	6e8080e7          	jalr	1768(ra) # 705c <read>
    if(cc < 0){
    697c:	00054863          	bltz	a0,698c <countfree+0x120>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    6980:	02050463          	beqz	a0,69a8 <countfree+0x13c>
      break;
    n += 1;
    6984:	0014849b          	addw	s1,s1,1
  while(1){
    6988:	fe1ff06f          	j	6968 <countfree+0xfc>
      printf("read() failed in countfree()\n");
    698c:	00003517          	auipc	a0,0x3
    6990:	e0450513          	add	a0,a0,-508 # 9790 <malloc+0x2178>
    6994:	00001097          	auipc	ra,0x1
    6998:	b80080e7          	jalr	-1152(ra) # 7514 <printf>
      exit(1);
    699c:	00100513          	li	a0,1
    69a0:	00000097          	auipc	ra,0x0
    69a4:	698080e7          	jalr	1688(ra) # 7038 <exit>
  }

  close(fds[0]);
    69a8:	fc842503          	lw	a0,-56(s0)
    69ac:	00000097          	auipc	ra,0x0
    69b0:	6c8080e7          	jalr	1736(ra) # 7074 <close>
  wait((int*)0);
    69b4:	00000513          	li	a0,0
    69b8:	00000097          	auipc	ra,0x0
    69bc:	68c080e7          	jalr	1676(ra) # 7044 <wait>
  
  return n;
}
    69c0:	00048513          	mv	a0,s1
    69c4:	03813083          	ld	ra,56(sp)
    69c8:	03013403          	ld	s0,48(sp)
    69cc:	02813483          	ld	s1,40(sp)
    69d0:	02013903          	ld	s2,32(sp)
    69d4:	01813983          	ld	s3,24(sp)
    69d8:	04010113          	add	sp,sp,64
    69dc:	00008067          	ret

00000000000069e0 <drivetests>:

int
drivetests(int quick, int continuous, char *justone) {
    69e0:	fa010113          	add	sp,sp,-96
    69e4:	04113c23          	sd	ra,88(sp)
    69e8:	04813823          	sd	s0,80(sp)
    69ec:	04913423          	sd	s1,72(sp)
    69f0:	05213023          	sd	s2,64(sp)
    69f4:	03313c23          	sd	s3,56(sp)
    69f8:	03413823          	sd	s4,48(sp)
    69fc:	03513423          	sd	s5,40(sp)
    6a00:	03613023          	sd	s6,32(sp)
    6a04:	01713c23          	sd	s7,24(sp)
    6a08:	01813823          	sd	s8,16(sp)
    6a0c:	01913423          	sd	s9,8(sp)
    6a10:	01a13023          	sd	s10,0(sp)
    6a14:	06010413          	add	s0,sp,96
    6a18:	00050a93          	mv	s5,a0
    6a1c:	00058993          	mv	s3,a1
    6a20:	00060913          	mv	s2,a2
  do {
    printf("usertests starting\n");
    6a24:	00003b97          	auipc	s7,0x3
    6a28:	d8cb8b93          	add	s7,s7,-628 # 97b0 <malloc+0x2198>
    int free0 = countfree();
    int free1 = 0;
    if (runtests(quicktests, justone)) {
    6a2c:	00003b17          	auipc	s6,0x3
    6a30:	5e4b0b13          	add	s6,s6,1508 # a010 <quicktests>
      if(continuous != 2) {
    6a34:	00200a13          	li	s4,2
      }
    }
    if(!quick) {
      if (justone == 0)
        printf("usertests slow tests starting\n");
      if (runtests(slowtests, justone)) {
    6a38:	00004c17          	auipc	s8,0x4
    6a3c:	9a8c0c13          	add	s8,s8,-1624 # a3e0 <slowtests>
        printf("usertests slow tests starting\n");
    6a40:	00003d17          	auipc	s10,0x3
    6a44:	d88d0d13          	add	s10,s10,-632 # 97c8 <malloc+0x21b0>
          return 1;
        }
      }
    }
    if((free1 = countfree()) < free0) {
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    6a48:	00003c97          	auipc	s9,0x3
    6a4c:	da0c8c93          	add	s9,s9,-608 # 97e8 <malloc+0x21d0>
    6a50:	0240006f          	j	6a74 <drivetests+0x94>
        printf("usertests slow tests starting\n");
    6a54:	000d0513          	mv	a0,s10
    6a58:	00001097          	auipc	ra,0x1
    6a5c:	abc080e7          	jalr	-1348(ra) # 7514 <printf>
    6a60:	04c0006f          	j	6aac <drivetests+0xcc>
    if((free1 = countfree()) < free0) {
    6a64:	00000097          	auipc	ra,0x0
    6a68:	e08080e7          	jalr	-504(ra) # 686c <countfree>
    6a6c:	06954063          	blt	a0,s1,6acc <drivetests+0xec>
      if(continuous != 2) {
        return 1;
      }
    }
  } while(continuous);
    6a70:	08098263          	beqz	s3,6af4 <drivetests+0x114>
    printf("usertests starting\n");
    6a74:	000b8513          	mv	a0,s7
    6a78:	00001097          	auipc	ra,0x1
    6a7c:	a9c080e7          	jalr	-1380(ra) # 7514 <printf>
    int free0 = countfree();
    6a80:	00000097          	auipc	ra,0x0
    6a84:	dec080e7          	jalr	-532(ra) # 686c <countfree>
    6a88:	00050493          	mv	s1,a0
    if (runtests(quicktests, justone)) {
    6a8c:	00090593          	mv	a1,s2
    6a90:	000b0513          	mv	a0,s6
    6a94:	00000097          	auipc	ra,0x0
    6a98:	d44080e7          	jalr	-700(ra) # 67d8 <runtests>
    6a9c:	00050463          	beqz	a0,6aa4 <drivetests+0xc4>
      if(continuous != 2) {
    6aa0:	05499663          	bne	s3,s4,6aec <drivetests+0x10c>
    if(!quick) {
    6aa4:	fc0a90e3          	bnez	s5,6a64 <drivetests+0x84>
      if (justone == 0)
    6aa8:	fa0906e3          	beqz	s2,6a54 <drivetests+0x74>
      if (runtests(slowtests, justone)) {
    6aac:	00090593          	mv	a1,s2
    6ab0:	000c0513          	mv	a0,s8
    6ab4:	00000097          	auipc	ra,0x0
    6ab8:	d24080e7          	jalr	-732(ra) # 67d8 <runtests>
    6abc:	fa0504e3          	beqz	a0,6a64 <drivetests+0x84>
        if(continuous != 2) {
    6ac0:	fb4982e3          	beq	s3,s4,6a64 <drivetests+0x84>
          return 1;
    6ac4:	00100513          	li	a0,1
    6ac8:	0300006f          	j	6af8 <drivetests+0x118>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    6acc:	00048613          	mv	a2,s1
    6ad0:	00050593          	mv	a1,a0
    6ad4:	000c8513          	mv	a0,s9
    6ad8:	00001097          	auipc	ra,0x1
    6adc:	a3c080e7          	jalr	-1476(ra) # 7514 <printf>
      if(continuous != 2) {
    6ae0:	f9498ae3          	beq	s3,s4,6a74 <drivetests+0x94>
        return 1;
    6ae4:	00100513          	li	a0,1
    6ae8:	0100006f          	j	6af8 <drivetests+0x118>
        return 1;
    6aec:	00100513          	li	a0,1
    6af0:	0080006f          	j	6af8 <drivetests+0x118>
  return 0;
    6af4:	00098513          	mv	a0,s3
}
    6af8:	05813083          	ld	ra,88(sp)
    6afc:	05013403          	ld	s0,80(sp)
    6b00:	04813483          	ld	s1,72(sp)
    6b04:	04013903          	ld	s2,64(sp)
    6b08:	03813983          	ld	s3,56(sp)
    6b0c:	03013a03          	ld	s4,48(sp)
    6b10:	02813a83          	ld	s5,40(sp)
    6b14:	02013b03          	ld	s6,32(sp)
    6b18:	01813b83          	ld	s7,24(sp)
    6b1c:	01013c03          	ld	s8,16(sp)
    6b20:	00813c83          	ld	s9,8(sp)
    6b24:	00013d03          	ld	s10,0(sp)
    6b28:	06010113          	add	sp,sp,96
    6b2c:	00008067          	ret

0000000000006b30 <main>:

int
main(int argc, char *argv[])
{
    6b30:	fe010113          	add	sp,sp,-32
    6b34:	00113c23          	sd	ra,24(sp)
    6b38:	00813823          	sd	s0,16(sp)
    6b3c:	00913423          	sd	s1,8(sp)
    6b40:	01213023          	sd	s2,0(sp)
    6b44:	02010413          	add	s0,sp,32
    6b48:	00050493          	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    6b4c:	00200793          	li	a5,2
    6b50:	02f50863          	beq	a0,a5,6b80 <main+0x50>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    6b54:	00100793          	li	a5,1
    6b58:	0aa7c063          	blt	a5,a0,6bf8 <main+0xc8>
  char *justone = 0;
    6b5c:	00000613          	li	a2,0
  int quick = 0;
    6b60:	00000513          	li	a0,0
  int continuous = 0;
    6b64:	00000593          	li	a1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1);
  }
  if (drivetests(quick, continuous, justone)) {
    6b68:	00000097          	auipc	ra,0x0
    6b6c:	e78080e7          	jalr	-392(ra) # 69e0 <drivetests>
    6b70:	0a050e63          	beqz	a0,6c2c <main+0xfc>
    exit(1);
    6b74:	00100513          	li	a0,1
    6b78:	00000097          	auipc	ra,0x0
    6b7c:	4c0080e7          	jalr	1216(ra) # 7038 <exit>
    6b80:	00058913          	mv	s2,a1
  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    6b84:	00003597          	auipc	a1,0x3
    6b88:	c9458593          	add	a1,a1,-876 # 9818 <malloc+0x2200>
    6b8c:	00893503          	ld	a0,8(s2)
    6b90:	00000097          	auipc	ra,0x0
    6b94:	10c080e7          	jalr	268(ra) # 6c9c <strcmp>
    6b98:	00050593          	mv	a1,a0
    6b9c:	00051863          	bnez	a0,6bac <main+0x7c>
  char *justone = 0;
    6ba0:	00000613          	li	a2,0
    quick = 1;
    6ba4:	00100513          	li	a0,1
    6ba8:	fc1ff06f          	j	6b68 <main+0x38>
  } else if(argc == 2 && strcmp(argv[1], "-c") == 0){
    6bac:	00003597          	auipc	a1,0x3
    6bb0:	c7458593          	add	a1,a1,-908 # 9820 <malloc+0x2208>
    6bb4:	00893503          	ld	a0,8(s2)
    6bb8:	00000097          	auipc	ra,0x0
    6bbc:	0e4080e7          	jalr	228(ra) # 6c9c <strcmp>
    6bc0:	04050a63          	beqz	a0,6c14 <main+0xe4>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    6bc4:	00003597          	auipc	a1,0x3
    6bc8:	cac58593          	add	a1,a1,-852 # 9870 <malloc+0x2258>
    6bcc:	00893503          	ld	a0,8(s2)
    6bd0:	00000097          	auipc	ra,0x0
    6bd4:	0cc080e7          	jalr	204(ra) # 6c9c <strcmp>
    6bd8:	04050463          	beqz	a0,6c20 <main+0xf0>
  } else if(argc == 2 && argv[1][0] != '-'){
    6bdc:	00893603          	ld	a2,8(s2)
    6be0:	00064703          	lbu	a4,0(a2) # 3000 <copyinstr3+0x120>
    6be4:	02d00793          	li	a5,45
    6be8:	00f70863          	beq	a4,a5,6bf8 <main+0xc8>
  int quick = 0;
    6bec:	00000513          	li	a0,0
  int continuous = 0;
    6bf0:	00000593          	li	a1,0
    6bf4:	f75ff06f          	j	6b68 <main+0x38>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    6bf8:	00003517          	auipc	a0,0x3
    6bfc:	c3050513          	add	a0,a0,-976 # 9828 <malloc+0x2210>
    6c00:	00001097          	auipc	ra,0x1
    6c04:	914080e7          	jalr	-1772(ra) # 7514 <printf>
    exit(1);
    6c08:	00100513          	li	a0,1
    6c0c:	00000097          	auipc	ra,0x0
    6c10:	42c080e7          	jalr	1068(ra) # 7038 <exit>
  char *justone = 0;
    6c14:	00000613          	li	a2,0
    continuous = 1;
    6c18:	00100593          	li	a1,1
    6c1c:	f4dff06f          	j	6b68 <main+0x38>
    continuous = 2;
    6c20:	00048593          	mv	a1,s1
  char *justone = 0;
    6c24:	00000613          	li	a2,0
    6c28:	f41ff06f          	j	6b68 <main+0x38>
  }
  printf("ALL TESTS PASSED\n");
    6c2c:	00003517          	auipc	a0,0x3
    6c30:	c2c50513          	add	a0,a0,-980 # 9858 <malloc+0x2240>
    6c34:	00001097          	auipc	ra,0x1
    6c38:	8e0080e7          	jalr	-1824(ra) # 7514 <printf>
  exit(0);
    6c3c:	00000513          	li	a0,0
    6c40:	00000097          	auipc	ra,0x0
    6c44:	3f8080e7          	jalr	1016(ra) # 7038 <exit>

0000000000006c48 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
    6c48:	ff010113          	add	sp,sp,-16
    6c4c:	00113423          	sd	ra,8(sp)
    6c50:	00813023          	sd	s0,0(sp)
    6c54:	01010413          	add	s0,sp,16
  extern int main();
  main();
    6c58:	00000097          	auipc	ra,0x0
    6c5c:	ed8080e7          	jalr	-296(ra) # 6b30 <main>
  exit(0);
    6c60:	00000513          	li	a0,0
    6c64:	00000097          	auipc	ra,0x0
    6c68:	3d4080e7          	jalr	980(ra) # 7038 <exit>

0000000000006c6c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    6c6c:	ff010113          	add	sp,sp,-16
    6c70:	00813423          	sd	s0,8(sp)
    6c74:	01010413          	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    6c78:	00050793          	mv	a5,a0
    6c7c:	00158593          	add	a1,a1,1
    6c80:	00178793          	add	a5,a5,1
    6c84:	fff5c703          	lbu	a4,-1(a1)
    6c88:	fee78fa3          	sb	a4,-1(a5)
    6c8c:	fe0718e3          	bnez	a4,6c7c <strcpy+0x10>
    ;
  return os;
}
    6c90:	00813403          	ld	s0,8(sp)
    6c94:	01010113          	add	sp,sp,16
    6c98:	00008067          	ret

0000000000006c9c <strcmp>:

int
strcmp(const char *p, const char *q)
{
    6c9c:	ff010113          	add	sp,sp,-16
    6ca0:	00813423          	sd	s0,8(sp)
    6ca4:	01010413          	add	s0,sp,16
  while(*p && *p == *q)
    6ca8:	00054783          	lbu	a5,0(a0)
    6cac:	00078e63          	beqz	a5,6cc8 <strcmp+0x2c>
    6cb0:	0005c703          	lbu	a4,0(a1)
    6cb4:	00f71a63          	bne	a4,a5,6cc8 <strcmp+0x2c>
    p++, q++;
    6cb8:	00150513          	add	a0,a0,1
    6cbc:	00158593          	add	a1,a1,1
  while(*p && *p == *q)
    6cc0:	00054783          	lbu	a5,0(a0)
    6cc4:	fe0796e3          	bnez	a5,6cb0 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
    6cc8:	0005c503          	lbu	a0,0(a1)
}
    6ccc:	40a7853b          	subw	a0,a5,a0
    6cd0:	00813403          	ld	s0,8(sp)
    6cd4:	01010113          	add	sp,sp,16
    6cd8:	00008067          	ret

0000000000006cdc <strlen>:

uint
strlen(const char *s)
{
    6cdc:	ff010113          	add	sp,sp,-16
    6ce0:	00813423          	sd	s0,8(sp)
    6ce4:	01010413          	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    6ce8:	00054783          	lbu	a5,0(a0)
    6cec:	02078863          	beqz	a5,6d1c <strlen+0x40>
    6cf0:	00150513          	add	a0,a0,1
    6cf4:	00050793          	mv	a5,a0
    6cf8:	00078693          	mv	a3,a5
    6cfc:	00178793          	add	a5,a5,1
    6d00:	fff7c703          	lbu	a4,-1(a5)
    6d04:	fe071ae3          	bnez	a4,6cf8 <strlen+0x1c>
    6d08:	40a6853b          	subw	a0,a3,a0
    6d0c:	0015051b          	addw	a0,a0,1
    ;
  return n;
}
    6d10:	00813403          	ld	s0,8(sp)
    6d14:	01010113          	add	sp,sp,16
    6d18:	00008067          	ret
  for(n = 0; s[n]; n++)
    6d1c:	00000513          	li	a0,0
    6d20:	ff1ff06f          	j	6d10 <strlen+0x34>

0000000000006d24 <memset>:

void*
memset(void *dst, int c, uint n)
{
    6d24:	ff010113          	add	sp,sp,-16
    6d28:	00813423          	sd	s0,8(sp)
    6d2c:	01010413          	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    6d30:	02060063          	beqz	a2,6d50 <memset+0x2c>
    6d34:	00050793          	mv	a5,a0
    6d38:	02061613          	sll	a2,a2,0x20
    6d3c:	02065613          	srl	a2,a2,0x20
    6d40:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    6d44:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    6d48:	00178793          	add	a5,a5,1
    6d4c:	fee79ce3          	bne	a5,a4,6d44 <memset+0x20>
  }
  return dst;
}
    6d50:	00813403          	ld	s0,8(sp)
    6d54:	01010113          	add	sp,sp,16
    6d58:	00008067          	ret

0000000000006d5c <strchr>:

char*
strchr(const char *s, char c)
{
    6d5c:	ff010113          	add	sp,sp,-16
    6d60:	00813423          	sd	s0,8(sp)
    6d64:	01010413          	add	s0,sp,16
  for(; *s; s++)
    6d68:	00054783          	lbu	a5,0(a0)
    6d6c:	02078263          	beqz	a5,6d90 <strchr+0x34>
    if(*s == c)
    6d70:	00f58a63          	beq	a1,a5,6d84 <strchr+0x28>
  for(; *s; s++)
    6d74:	00150513          	add	a0,a0,1
    6d78:	00054783          	lbu	a5,0(a0)
    6d7c:	fe079ae3          	bnez	a5,6d70 <strchr+0x14>
      return (char*)s;
  return 0;
    6d80:	00000513          	li	a0,0
}
    6d84:	00813403          	ld	s0,8(sp)
    6d88:	01010113          	add	sp,sp,16
    6d8c:	00008067          	ret
  return 0;
    6d90:	00000513          	li	a0,0
    6d94:	ff1ff06f          	j	6d84 <strchr+0x28>

0000000000006d98 <gets>:

char*
gets(char *buf, int max)
{
    6d98:	fa010113          	add	sp,sp,-96
    6d9c:	04113c23          	sd	ra,88(sp)
    6da0:	04813823          	sd	s0,80(sp)
    6da4:	04913423          	sd	s1,72(sp)
    6da8:	05213023          	sd	s2,64(sp)
    6dac:	03313c23          	sd	s3,56(sp)
    6db0:	03413823          	sd	s4,48(sp)
    6db4:	03513423          	sd	s5,40(sp)
    6db8:	03613023          	sd	s6,32(sp)
    6dbc:	01713c23          	sd	s7,24(sp)
    6dc0:	06010413          	add	s0,sp,96
    6dc4:	00050b93          	mv	s7,a0
    6dc8:	00058a13          	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    6dcc:	00050913          	mv	s2,a0
    6dd0:	00000493          	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    6dd4:	00a00a93          	li	s5,10
    6dd8:	00d00b13          	li	s6,13
  for(i=0; i+1 < max; ){
    6ddc:	00048993          	mv	s3,s1
    6de0:	0014849b          	addw	s1,s1,1
    6de4:	0344de63          	bge	s1,s4,6e20 <gets+0x88>
    cc = read(0, &c, 1);
    6de8:	00100613          	li	a2,1
    6dec:	faf40593          	add	a1,s0,-81
    6df0:	00000513          	li	a0,0
    6df4:	00000097          	auipc	ra,0x0
    6df8:	268080e7          	jalr	616(ra) # 705c <read>
    if(cc < 1)
    6dfc:	02a05263          	blez	a0,6e20 <gets+0x88>
    buf[i++] = c;
    6e00:	faf44783          	lbu	a5,-81(s0)
    6e04:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    6e08:	01578a63          	beq	a5,s5,6e1c <gets+0x84>
    6e0c:	00190913          	add	s2,s2,1
    6e10:	fd6796e3          	bne	a5,s6,6ddc <gets+0x44>
  for(i=0; i+1 < max; ){
    6e14:	00048993          	mv	s3,s1
    6e18:	0080006f          	j	6e20 <gets+0x88>
    6e1c:	00048993          	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    6e20:	013b89b3          	add	s3,s7,s3
    6e24:	00098023          	sb	zero,0(s3)
  return buf;
}
    6e28:	000b8513          	mv	a0,s7
    6e2c:	05813083          	ld	ra,88(sp)
    6e30:	05013403          	ld	s0,80(sp)
    6e34:	04813483          	ld	s1,72(sp)
    6e38:	04013903          	ld	s2,64(sp)
    6e3c:	03813983          	ld	s3,56(sp)
    6e40:	03013a03          	ld	s4,48(sp)
    6e44:	02813a83          	ld	s5,40(sp)
    6e48:	02013b03          	ld	s6,32(sp)
    6e4c:	01813b83          	ld	s7,24(sp)
    6e50:	06010113          	add	sp,sp,96
    6e54:	00008067          	ret

0000000000006e58 <stat>:

int
stat(const char *n, struct stat *st)
{
    6e58:	fe010113          	add	sp,sp,-32
    6e5c:	00113c23          	sd	ra,24(sp)
    6e60:	00813823          	sd	s0,16(sp)
    6e64:	00913423          	sd	s1,8(sp)
    6e68:	01213023          	sd	s2,0(sp)
    6e6c:	02010413          	add	s0,sp,32
    6e70:	00058913          	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    6e74:	00000593          	li	a1,0
    6e78:	00000097          	auipc	ra,0x0
    6e7c:	220080e7          	jalr	544(ra) # 7098 <open>
  if(fd < 0)
    6e80:	04054063          	bltz	a0,6ec0 <stat+0x68>
    6e84:	00050493          	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    6e88:	00090593          	mv	a1,s2
    6e8c:	00000097          	auipc	ra,0x0
    6e90:	230080e7          	jalr	560(ra) # 70bc <fstat>
    6e94:	00050913          	mv	s2,a0
  close(fd);
    6e98:	00048513          	mv	a0,s1
    6e9c:	00000097          	auipc	ra,0x0
    6ea0:	1d8080e7          	jalr	472(ra) # 7074 <close>
  return r;
}
    6ea4:	00090513          	mv	a0,s2
    6ea8:	01813083          	ld	ra,24(sp)
    6eac:	01013403          	ld	s0,16(sp)
    6eb0:	00813483          	ld	s1,8(sp)
    6eb4:	00013903          	ld	s2,0(sp)
    6eb8:	02010113          	add	sp,sp,32
    6ebc:	00008067          	ret
    return -1;
    6ec0:	fff00913          	li	s2,-1
    6ec4:	fe1ff06f          	j	6ea4 <stat+0x4c>

0000000000006ec8 <atoi>:

int
atoi(const char *s)
{
    6ec8:	ff010113          	add	sp,sp,-16
    6ecc:	00813423          	sd	s0,8(sp)
    6ed0:	01010413          	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    6ed4:	00054683          	lbu	a3,0(a0)
    6ed8:	fd06879b          	addw	a5,a3,-48
    6edc:	0ff7f793          	zext.b	a5,a5
    6ee0:	00900613          	li	a2,9
    6ee4:	04f66063          	bltu	a2,a5,6f24 <atoi+0x5c>
    6ee8:	00050713          	mv	a4,a0
  n = 0;
    6eec:	00000513          	li	a0,0
    n = n*10 + *s++ - '0';
    6ef0:	00170713          	add	a4,a4,1
    6ef4:	0025179b          	sllw	a5,a0,0x2
    6ef8:	00a787bb          	addw	a5,a5,a0
    6efc:	0017979b          	sllw	a5,a5,0x1
    6f00:	00d787bb          	addw	a5,a5,a3
    6f04:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    6f08:	00074683          	lbu	a3,0(a4)
    6f0c:	fd06879b          	addw	a5,a3,-48
    6f10:	0ff7f793          	zext.b	a5,a5
    6f14:	fcf67ee3          	bgeu	a2,a5,6ef0 <atoi+0x28>
  return n;
}
    6f18:	00813403          	ld	s0,8(sp)
    6f1c:	01010113          	add	sp,sp,16
    6f20:	00008067          	ret
  n = 0;
    6f24:	00000513          	li	a0,0
    6f28:	ff1ff06f          	j	6f18 <atoi+0x50>

0000000000006f2c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    6f2c:	ff010113          	add	sp,sp,-16
    6f30:	00813423          	sd	s0,8(sp)
    6f34:	01010413          	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    6f38:	02b57c63          	bgeu	a0,a1,6f70 <memmove+0x44>
    while(n-- > 0)
    6f3c:	02c05463          	blez	a2,6f64 <memmove+0x38>
    6f40:	02061613          	sll	a2,a2,0x20
    6f44:	02065613          	srl	a2,a2,0x20
    6f48:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    6f4c:	00050713          	mv	a4,a0
      *dst++ = *src++;
    6f50:	00158593          	add	a1,a1,1
    6f54:	00170713          	add	a4,a4,1
    6f58:	fff5c683          	lbu	a3,-1(a1)
    6f5c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    6f60:	fee798e3          	bne	a5,a4,6f50 <memmove+0x24>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    6f64:	00813403          	ld	s0,8(sp)
    6f68:	01010113          	add	sp,sp,16
    6f6c:	00008067          	ret
    dst += n;
    6f70:	00c50733          	add	a4,a0,a2
    src += n;
    6f74:	00c585b3          	add	a1,a1,a2
    while(n-- > 0)
    6f78:	fec056e3          	blez	a2,6f64 <memmove+0x38>
    6f7c:	fff6079b          	addw	a5,a2,-1
    6f80:	02079793          	sll	a5,a5,0x20
    6f84:	0207d793          	srl	a5,a5,0x20
    6f88:	fff7c793          	not	a5,a5
    6f8c:	00f707b3          	add	a5,a4,a5
      *--dst = *--src;
    6f90:	fff58593          	add	a1,a1,-1
    6f94:	fff70713          	add	a4,a4,-1
    6f98:	0005c683          	lbu	a3,0(a1)
    6f9c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    6fa0:	fee798e3          	bne	a5,a4,6f90 <memmove+0x64>
    6fa4:	fc1ff06f          	j	6f64 <memmove+0x38>

0000000000006fa8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    6fa8:	ff010113          	add	sp,sp,-16
    6fac:	00813423          	sd	s0,8(sp)
    6fb0:	01010413          	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    6fb4:	04060463          	beqz	a2,6ffc <memcmp+0x54>
    6fb8:	fff6069b          	addw	a3,a2,-1
    6fbc:	02069693          	sll	a3,a3,0x20
    6fc0:	0206d693          	srl	a3,a3,0x20
    6fc4:	00168693          	add	a3,a3,1
    6fc8:	00d506b3          	add	a3,a0,a3
    if (*p1 != *p2) {
    6fcc:	00054783          	lbu	a5,0(a0)
    6fd0:	0005c703          	lbu	a4,0(a1)
    6fd4:	00e79c63          	bne	a5,a4,6fec <memcmp+0x44>
      return *p1 - *p2;
    }
    p1++;
    6fd8:	00150513          	add	a0,a0,1
    p2++;
    6fdc:	00158593          	add	a1,a1,1
  while (n-- > 0) {
    6fe0:	fed516e3          	bne	a0,a3,6fcc <memcmp+0x24>
  }
  return 0;
    6fe4:	00000513          	li	a0,0
    6fe8:	0080006f          	j	6ff0 <memcmp+0x48>
      return *p1 - *p2;
    6fec:	40e7853b          	subw	a0,a5,a4
}
    6ff0:	00813403          	ld	s0,8(sp)
    6ff4:	01010113          	add	sp,sp,16
    6ff8:	00008067          	ret
  return 0;
    6ffc:	00000513          	li	a0,0
    7000:	ff1ff06f          	j	6ff0 <memcmp+0x48>

0000000000007004 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    7004:	ff010113          	add	sp,sp,-16
    7008:	00113423          	sd	ra,8(sp)
    700c:	00813023          	sd	s0,0(sp)
    7010:	01010413          	add	s0,sp,16
  return memmove(dst, src, n);
    7014:	00000097          	auipc	ra,0x0
    7018:	f18080e7          	jalr	-232(ra) # 6f2c <memmove>
}
    701c:	00813083          	ld	ra,8(sp)
    7020:	00013403          	ld	s0,0(sp)
    7024:	01010113          	add	sp,sp,16
    7028:	00008067          	ret

000000000000702c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    702c:	00100893          	li	a7,1
 ecall
    7030:	00000073          	ecall
 ret
    7034:	00008067          	ret

0000000000007038 <exit>:
.global exit
exit:
 li a7, SYS_exit
    7038:	00200893          	li	a7,2
 ecall
    703c:	00000073          	ecall
 ret
    7040:	00008067          	ret

0000000000007044 <wait>:
.global wait
wait:
 li a7, SYS_wait
    7044:	00300893          	li	a7,3
 ecall
    7048:	00000073          	ecall
 ret
    704c:	00008067          	ret

0000000000007050 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    7050:	00400893          	li	a7,4
 ecall
    7054:	00000073          	ecall
 ret
    7058:	00008067          	ret

000000000000705c <read>:
.global read
read:
 li a7, SYS_read
    705c:	00500893          	li	a7,5
 ecall
    7060:	00000073          	ecall
 ret
    7064:	00008067          	ret

0000000000007068 <write>:
.global write
write:
 li a7, SYS_write
    7068:	01000893          	li	a7,16
 ecall
    706c:	00000073          	ecall
 ret
    7070:	00008067          	ret

0000000000007074 <close>:
.global close
close:
 li a7, SYS_close
    7074:	01500893          	li	a7,21
 ecall
    7078:	00000073          	ecall
 ret
    707c:	00008067          	ret

0000000000007080 <kill>:
.global kill
kill:
 li a7, SYS_kill
    7080:	00600893          	li	a7,6
 ecall
    7084:	00000073          	ecall
 ret
    7088:	00008067          	ret

000000000000708c <exec>:
.global exec
exec:
 li a7, SYS_exec
    708c:	00700893          	li	a7,7
 ecall
    7090:	00000073          	ecall
 ret
    7094:	00008067          	ret

0000000000007098 <open>:
.global open
open:
 li a7, SYS_open
    7098:	00f00893          	li	a7,15
 ecall
    709c:	00000073          	ecall
 ret
    70a0:	00008067          	ret

00000000000070a4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    70a4:	01100893          	li	a7,17
 ecall
    70a8:	00000073          	ecall
 ret
    70ac:	00008067          	ret

00000000000070b0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    70b0:	01200893          	li	a7,18
 ecall
    70b4:	00000073          	ecall
 ret
    70b8:	00008067          	ret

00000000000070bc <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    70bc:	00800893          	li	a7,8
 ecall
    70c0:	00000073          	ecall
 ret
    70c4:	00008067          	ret

00000000000070c8 <link>:
.global link
link:
 li a7, SYS_link
    70c8:	01300893          	li	a7,19
 ecall
    70cc:	00000073          	ecall
 ret
    70d0:	00008067          	ret

00000000000070d4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    70d4:	01400893          	li	a7,20
 ecall
    70d8:	00000073          	ecall
 ret
    70dc:	00008067          	ret

00000000000070e0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    70e0:	00900893          	li	a7,9
 ecall
    70e4:	00000073          	ecall
 ret
    70e8:	00008067          	ret

00000000000070ec <dup>:
.global dup
dup:
 li a7, SYS_dup
    70ec:	00a00893          	li	a7,10
 ecall
    70f0:	00000073          	ecall
 ret
    70f4:	00008067          	ret

00000000000070f8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    70f8:	00b00893          	li	a7,11
 ecall
    70fc:	00000073          	ecall
 ret
    7100:	00008067          	ret

0000000000007104 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    7104:	00c00893          	li	a7,12
 ecall
    7108:	00000073          	ecall
 ret
    710c:	00008067          	ret

0000000000007110 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    7110:	00d00893          	li	a7,13
 ecall
    7114:	00000073          	ecall
 ret
    7118:	00008067          	ret

000000000000711c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    711c:	00e00893          	li	a7,14
 ecall
    7120:	00000073          	ecall
 ret
    7124:	00008067          	ret

0000000000007128 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    7128:	fe010113          	add	sp,sp,-32
    712c:	00113c23          	sd	ra,24(sp)
    7130:	00813823          	sd	s0,16(sp)
    7134:	02010413          	add	s0,sp,32
    7138:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    713c:	00100613          	li	a2,1
    7140:	fef40593          	add	a1,s0,-17
    7144:	00000097          	auipc	ra,0x0
    7148:	f24080e7          	jalr	-220(ra) # 7068 <write>
}
    714c:	01813083          	ld	ra,24(sp)
    7150:	01013403          	ld	s0,16(sp)
    7154:	02010113          	add	sp,sp,32
    7158:	00008067          	ret

000000000000715c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    715c:	fc010113          	add	sp,sp,-64
    7160:	02113c23          	sd	ra,56(sp)
    7164:	02813823          	sd	s0,48(sp)
    7168:	02913423          	sd	s1,40(sp)
    716c:	03213023          	sd	s2,32(sp)
    7170:	01313c23          	sd	s3,24(sp)
    7174:	04010413          	add	s0,sp,64
    7178:	00050493          	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    717c:	00068463          	beqz	a3,7184 <printint+0x28>
    7180:	0c05c063          	bltz	a1,7240 <printint+0xe4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    7184:	0005859b          	sext.w	a1,a1
  neg = 0;
    7188:	00000893          	li	a7,0
    718c:	fc040693          	add	a3,s0,-64
  }

  i = 0;
    7190:	00000713          	li	a4,0
  do{
    buf[i++] = digits[x % base];
    7194:	0006061b          	sext.w	a2,a2
    7198:	00003517          	auipc	a0,0x3
    719c:	aa050513          	add	a0,a0,-1376 # 9c38 <digits>
    71a0:	00070813          	mv	a6,a4
    71a4:	0017071b          	addw	a4,a4,1
    71a8:	02c5f7bb          	remuw	a5,a1,a2
    71ac:	02079793          	sll	a5,a5,0x20
    71b0:	0207d793          	srl	a5,a5,0x20
    71b4:	00f507b3          	add	a5,a0,a5
    71b8:	0007c783          	lbu	a5,0(a5)
    71bc:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    71c0:	0005879b          	sext.w	a5,a1
    71c4:	02c5d5bb          	divuw	a1,a1,a2
    71c8:	00168693          	add	a3,a3,1
    71cc:	fcc7fae3          	bgeu	a5,a2,71a0 <printint+0x44>
  if(neg)
    71d0:	00088c63          	beqz	a7,71e8 <printint+0x8c>
    buf[i++] = '-';
    71d4:	fd070793          	add	a5,a4,-48
    71d8:	00878733          	add	a4,a5,s0
    71dc:	02d00793          	li	a5,45
    71e0:	fef70823          	sb	a5,-16(a4)
    71e4:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
    71e8:	02e05e63          	blez	a4,7224 <printint+0xc8>
    71ec:	fc040793          	add	a5,s0,-64
    71f0:	00e78933          	add	s2,a5,a4
    71f4:	fff78993          	add	s3,a5,-1
    71f8:	00e989b3          	add	s3,s3,a4
    71fc:	fff7071b          	addw	a4,a4,-1
    7200:	02071713          	sll	a4,a4,0x20
    7204:	02075713          	srl	a4,a4,0x20
    7208:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    720c:	fff94583          	lbu	a1,-1(s2)
    7210:	00048513          	mv	a0,s1
    7214:	00000097          	auipc	ra,0x0
    7218:	f14080e7          	jalr	-236(ra) # 7128 <putc>
  while(--i >= 0)
    721c:	fff90913          	add	s2,s2,-1
    7220:	ff3916e3          	bne	s2,s3,720c <printint+0xb0>
}
    7224:	03813083          	ld	ra,56(sp)
    7228:	03013403          	ld	s0,48(sp)
    722c:	02813483          	ld	s1,40(sp)
    7230:	02013903          	ld	s2,32(sp)
    7234:	01813983          	ld	s3,24(sp)
    7238:	04010113          	add	sp,sp,64
    723c:	00008067          	ret
    x = -xx;
    7240:	40b005bb          	negw	a1,a1
    neg = 1;
    7244:	00100893          	li	a7,1
    x = -xx;
    7248:	f45ff06f          	j	718c <printint+0x30>

000000000000724c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    724c:	fb010113          	add	sp,sp,-80
    7250:	04113423          	sd	ra,72(sp)
    7254:	04813023          	sd	s0,64(sp)
    7258:	02913c23          	sd	s1,56(sp)
    725c:	03213823          	sd	s2,48(sp)
    7260:	03313423          	sd	s3,40(sp)
    7264:	03413023          	sd	s4,32(sp)
    7268:	01513c23          	sd	s5,24(sp)
    726c:	01613823          	sd	s6,16(sp)
    7270:	01713423          	sd	s7,8(sp)
    7274:	01813023          	sd	s8,0(sp)
    7278:	05010413          	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    727c:	0005c903          	lbu	s2,0(a1)
    7280:	20090e63          	beqz	s2,749c <vprintf+0x250>
    7284:	00050a93          	mv	s5,a0
    7288:	00060b93          	mv	s7,a2
    728c:	00158493          	add	s1,a1,1
  state = 0;
    7290:	00000993          	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    7294:	02500a13          	li	s4,37
    7298:	01500b13          	li	s6,21
    729c:	0280006f          	j	72c4 <vprintf+0x78>
        putc(fd, c);
    72a0:	00090593          	mv	a1,s2
    72a4:	000a8513          	mv	a0,s5
    72a8:	00000097          	auipc	ra,0x0
    72ac:	e80080e7          	jalr	-384(ra) # 7128 <putc>
    72b0:	0080006f          	j	72b8 <vprintf+0x6c>
    } else if(state == '%'){
    72b4:	03498063          	beq	s3,s4,72d4 <vprintf+0x88>
  for(i = 0; fmt[i]; i++){
    72b8:	00148493          	add	s1,s1,1
    72bc:	fff4c903          	lbu	s2,-1(s1)
    72c0:	1c090e63          	beqz	s2,749c <vprintf+0x250>
    if(state == 0){
    72c4:	fe0998e3          	bnez	s3,72b4 <vprintf+0x68>
      if(c == '%'){
    72c8:	fd491ce3          	bne	s2,s4,72a0 <vprintf+0x54>
        state = '%';
    72cc:	000a0993          	mv	s3,s4
    72d0:	fe9ff06f          	j	72b8 <vprintf+0x6c>
      if(c == 'd'){
    72d4:	17490e63          	beq	s2,s4,7450 <vprintf+0x204>
    72d8:	f9d9079b          	addw	a5,s2,-99
    72dc:	0ff7f793          	zext.b	a5,a5
    72e0:	18fb6463          	bltu	s6,a5,7468 <vprintf+0x21c>
    72e4:	f9d9079b          	addw	a5,s2,-99
    72e8:	0ff7f713          	zext.b	a4,a5
    72ec:	16eb6e63          	bltu	s6,a4,7468 <vprintf+0x21c>
    72f0:	00271793          	sll	a5,a4,0x2
    72f4:	00003717          	auipc	a4,0x3
    72f8:	8ec70713          	add	a4,a4,-1812 # 9be0 <malloc+0x25c8>
    72fc:	00e787b3          	add	a5,a5,a4
    7300:	0007a783          	lw	a5,0(a5)
    7304:	00e787b3          	add	a5,a5,a4
    7308:	00078067          	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    730c:	008b8913          	add	s2,s7,8
    7310:	00100693          	li	a3,1
    7314:	00a00613          	li	a2,10
    7318:	000ba583          	lw	a1,0(s7)
    731c:	000a8513          	mv	a0,s5
    7320:	00000097          	auipc	ra,0x0
    7324:	e3c080e7          	jalr	-452(ra) # 715c <printint>
    7328:	00090b93          	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    732c:	00000993          	li	s3,0
    7330:	f89ff06f          	j	72b8 <vprintf+0x6c>
        printint(fd, va_arg(ap, uint64), 10, 0);
    7334:	008b8913          	add	s2,s7,8
    7338:	00000693          	li	a3,0
    733c:	00a00613          	li	a2,10
    7340:	000ba583          	lw	a1,0(s7)
    7344:	000a8513          	mv	a0,s5
    7348:	00000097          	auipc	ra,0x0
    734c:	e14080e7          	jalr	-492(ra) # 715c <printint>
    7350:	00090b93          	mv	s7,s2
      state = 0;
    7354:	00000993          	li	s3,0
    7358:	f61ff06f          	j	72b8 <vprintf+0x6c>
        printint(fd, va_arg(ap, int), 16, 0);
    735c:	008b8913          	add	s2,s7,8
    7360:	00000693          	li	a3,0
    7364:	01000613          	li	a2,16
    7368:	000ba583          	lw	a1,0(s7)
    736c:	000a8513          	mv	a0,s5
    7370:	00000097          	auipc	ra,0x0
    7374:	dec080e7          	jalr	-532(ra) # 715c <printint>
    7378:	00090b93          	mv	s7,s2
      state = 0;
    737c:	00000993          	li	s3,0
    7380:	f39ff06f          	j	72b8 <vprintf+0x6c>
        printptr(fd, va_arg(ap, uint64));
    7384:	008b8c13          	add	s8,s7,8
    7388:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    738c:	03000593          	li	a1,48
    7390:	000a8513          	mv	a0,s5
    7394:	00000097          	auipc	ra,0x0
    7398:	d94080e7          	jalr	-620(ra) # 7128 <putc>
  putc(fd, 'x');
    739c:	07800593          	li	a1,120
    73a0:	000a8513          	mv	a0,s5
    73a4:	00000097          	auipc	ra,0x0
    73a8:	d84080e7          	jalr	-636(ra) # 7128 <putc>
    73ac:	01000913          	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    73b0:	00003b97          	auipc	s7,0x3
    73b4:	888b8b93          	add	s7,s7,-1912 # 9c38 <digits>
    73b8:	03c9d793          	srl	a5,s3,0x3c
    73bc:	00fb87b3          	add	a5,s7,a5
    73c0:	0007c583          	lbu	a1,0(a5)
    73c4:	000a8513          	mv	a0,s5
    73c8:	00000097          	auipc	ra,0x0
    73cc:	d60080e7          	jalr	-672(ra) # 7128 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    73d0:	00499993          	sll	s3,s3,0x4
    73d4:	fff9091b          	addw	s2,s2,-1
    73d8:	fe0910e3          	bnez	s2,73b8 <vprintf+0x16c>
        printptr(fd, va_arg(ap, uint64));
    73dc:	000c0b93          	mv	s7,s8
      state = 0;
    73e0:	00000993          	li	s3,0
    73e4:	ed5ff06f          	j	72b8 <vprintf+0x6c>
        s = va_arg(ap, char*);
    73e8:	008b8993          	add	s3,s7,8
    73ec:	000bb903          	ld	s2,0(s7)
        if(s == 0)
    73f0:	02090863          	beqz	s2,7420 <vprintf+0x1d4>
        while(*s != 0){
    73f4:	00094583          	lbu	a1,0(s2)
    73f8:	08058c63          	beqz	a1,7490 <vprintf+0x244>
          putc(fd, *s);
    73fc:	000a8513          	mv	a0,s5
    7400:	00000097          	auipc	ra,0x0
    7404:	d28080e7          	jalr	-728(ra) # 7128 <putc>
          s++;
    7408:	00190913          	add	s2,s2,1
        while(*s != 0){
    740c:	00094583          	lbu	a1,0(s2)
    7410:	fe0596e3          	bnez	a1,73fc <vprintf+0x1b0>
        s = va_arg(ap, char*);
    7414:	00098b93          	mv	s7,s3
      state = 0;
    7418:	00000993          	li	s3,0
    741c:	e9dff06f          	j	72b8 <vprintf+0x6c>
          s = "(null)";
    7420:	00002917          	auipc	s2,0x2
    7424:	7b890913          	add	s2,s2,1976 # 9bd8 <malloc+0x25c0>
        while(*s != 0){
    7428:	02800593          	li	a1,40
    742c:	fd1ff06f          	j	73fc <vprintf+0x1b0>
        putc(fd, va_arg(ap, uint));
    7430:	008b8913          	add	s2,s7,8
    7434:	000bc583          	lbu	a1,0(s7)
    7438:	000a8513          	mv	a0,s5
    743c:	00000097          	auipc	ra,0x0
    7440:	cec080e7          	jalr	-788(ra) # 7128 <putc>
    7444:	00090b93          	mv	s7,s2
      state = 0;
    7448:	00000993          	li	s3,0
    744c:	e6dff06f          	j	72b8 <vprintf+0x6c>
        putc(fd, c);
    7450:	02500593          	li	a1,37
    7454:	000a8513          	mv	a0,s5
    7458:	00000097          	auipc	ra,0x0
    745c:	cd0080e7          	jalr	-816(ra) # 7128 <putc>
      state = 0;
    7460:	00000993          	li	s3,0
    7464:	e55ff06f          	j	72b8 <vprintf+0x6c>
        putc(fd, '%');
    7468:	02500593          	li	a1,37
    746c:	000a8513          	mv	a0,s5
    7470:	00000097          	auipc	ra,0x0
    7474:	cb8080e7          	jalr	-840(ra) # 7128 <putc>
        putc(fd, c);
    7478:	00090593          	mv	a1,s2
    747c:	000a8513          	mv	a0,s5
    7480:	00000097          	auipc	ra,0x0
    7484:	ca8080e7          	jalr	-856(ra) # 7128 <putc>
      state = 0;
    7488:	00000993          	li	s3,0
    748c:	e2dff06f          	j	72b8 <vprintf+0x6c>
        s = va_arg(ap, char*);
    7490:	00098b93          	mv	s7,s3
      state = 0;
    7494:	00000993          	li	s3,0
    7498:	e21ff06f          	j	72b8 <vprintf+0x6c>
    }
  }
}
    749c:	04813083          	ld	ra,72(sp)
    74a0:	04013403          	ld	s0,64(sp)
    74a4:	03813483          	ld	s1,56(sp)
    74a8:	03013903          	ld	s2,48(sp)
    74ac:	02813983          	ld	s3,40(sp)
    74b0:	02013a03          	ld	s4,32(sp)
    74b4:	01813a83          	ld	s5,24(sp)
    74b8:	01013b03          	ld	s6,16(sp)
    74bc:	00813b83          	ld	s7,8(sp)
    74c0:	00013c03          	ld	s8,0(sp)
    74c4:	05010113          	add	sp,sp,80
    74c8:	00008067          	ret

00000000000074cc <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    74cc:	fb010113          	add	sp,sp,-80
    74d0:	00113c23          	sd	ra,24(sp)
    74d4:	00813823          	sd	s0,16(sp)
    74d8:	02010413          	add	s0,sp,32
    74dc:	00c43023          	sd	a2,0(s0)
    74e0:	00d43423          	sd	a3,8(s0)
    74e4:	00e43823          	sd	a4,16(s0)
    74e8:	00f43c23          	sd	a5,24(s0)
    74ec:	03043023          	sd	a6,32(s0)
    74f0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    74f4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    74f8:	00040613          	mv	a2,s0
    74fc:	00000097          	auipc	ra,0x0
    7500:	d50080e7          	jalr	-688(ra) # 724c <vprintf>
}
    7504:	01813083          	ld	ra,24(sp)
    7508:	01013403          	ld	s0,16(sp)
    750c:	05010113          	add	sp,sp,80
    7510:	00008067          	ret

0000000000007514 <printf>:

void
printf(const char *fmt, ...)
{
    7514:	fa010113          	add	sp,sp,-96
    7518:	00113c23          	sd	ra,24(sp)
    751c:	00813823          	sd	s0,16(sp)
    7520:	02010413          	add	s0,sp,32
    7524:	00b43423          	sd	a1,8(s0)
    7528:	00c43823          	sd	a2,16(s0)
    752c:	00d43c23          	sd	a3,24(s0)
    7530:	02e43023          	sd	a4,32(s0)
    7534:	02f43423          	sd	a5,40(s0)
    7538:	03043823          	sd	a6,48(s0)
    753c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    7540:	00840613          	add	a2,s0,8
    7544:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    7548:	00050593          	mv	a1,a0
    754c:	00100513          	li	a0,1
    7550:	00000097          	auipc	ra,0x0
    7554:	cfc080e7          	jalr	-772(ra) # 724c <vprintf>
}
    7558:	01813083          	ld	ra,24(sp)
    755c:	01013403          	ld	s0,16(sp)
    7560:	06010113          	add	sp,sp,96
    7564:	00008067          	ret

0000000000007568 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    7568:	ff010113          	add	sp,sp,-16
    756c:	00813423          	sd	s0,8(sp)
    7570:	01010413          	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    7574:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    7578:	00003797          	auipc	a5,0x3
    757c:	ed87b783          	ld	a5,-296(a5) # a450 <freep>
    7580:	0400006f          	j	75c0 <free+0x58>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    7584:	00862703          	lw	a4,8(a2)
    7588:	00b7073b          	addw	a4,a4,a1
    758c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    7590:	0007b703          	ld	a4,0(a5)
    7594:	00073603          	ld	a2,0(a4)
    7598:	0500006f          	j	75e8 <free+0x80>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    759c:	ff852703          	lw	a4,-8(a0)
    75a0:	00c7073b          	addw	a4,a4,a2
    75a4:	00e7a423          	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    75a8:	ff053683          	ld	a3,-16(a0)
    75ac:	0540006f          	j	7600 <free+0x98>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    75b0:	0007b703          	ld	a4,0(a5)
    75b4:	00e7e463          	bltu	a5,a4,75bc <free+0x54>
    75b8:	00e6ec63          	bltu	a3,a4,75d0 <free+0x68>
{
    75bc:	00070793          	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    75c0:	fed7f8e3          	bgeu	a5,a3,75b0 <free+0x48>
    75c4:	0007b703          	ld	a4,0(a5)
    75c8:	00e6e463          	bltu	a3,a4,75d0 <free+0x68>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    75cc:	fee7e8e3          	bltu	a5,a4,75bc <free+0x54>
  if(bp + bp->s.size == p->s.ptr){
    75d0:	ff852583          	lw	a1,-8(a0)
    75d4:	0007b603          	ld	a2,0(a5)
    75d8:	02059813          	sll	a6,a1,0x20
    75dc:	01c85713          	srl	a4,a6,0x1c
    75e0:	00e68733          	add	a4,a3,a4
    75e4:	fae600e3          	beq	a2,a4,7584 <free+0x1c>
    bp->s.ptr = p->s.ptr->s.ptr;
    75e8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    75ec:	0087a603          	lw	a2,8(a5)
    75f0:	02061593          	sll	a1,a2,0x20
    75f4:	01c5d713          	srl	a4,a1,0x1c
    75f8:	00e78733          	add	a4,a5,a4
    75fc:	fae680e3          	beq	a3,a4,759c <free+0x34>
    p->s.ptr = bp->s.ptr;
    7600:	00d7b023          	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    7604:	00003717          	auipc	a4,0x3
    7608:	e4f73623          	sd	a5,-436(a4) # a450 <freep>
}
    760c:	00813403          	ld	s0,8(sp)
    7610:	01010113          	add	sp,sp,16
    7614:	00008067          	ret

0000000000007618 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    7618:	fc010113          	add	sp,sp,-64
    761c:	02113c23          	sd	ra,56(sp)
    7620:	02813823          	sd	s0,48(sp)
    7624:	02913423          	sd	s1,40(sp)
    7628:	03213023          	sd	s2,32(sp)
    762c:	01313c23          	sd	s3,24(sp)
    7630:	01413823          	sd	s4,16(sp)
    7634:	01513423          	sd	s5,8(sp)
    7638:	01613023          	sd	s6,0(sp)
    763c:	04010413          	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    7640:	02051493          	sll	s1,a0,0x20
    7644:	0204d493          	srl	s1,s1,0x20
    7648:	00f48493          	add	s1,s1,15
    764c:	0044d493          	srl	s1,s1,0x4
    7650:	0014899b          	addw	s3,s1,1
    7654:	00148493          	add	s1,s1,1
  if((prevp = freep) == 0){
    7658:	00003517          	auipc	a0,0x3
    765c:	df853503          	ld	a0,-520(a0) # a450 <freep>
    7660:	02050e63          	beqz	a0,769c <malloc+0x84>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    7664:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
    7668:	0087a703          	lw	a4,8(a5)
    766c:	04977663          	bgeu	a4,s1,76b8 <malloc+0xa0>
  if(nu < 4096)
    7670:	00098a13          	mv	s4,s3
    7674:	0009871b          	sext.w	a4,s3
    7678:	000016b7          	lui	a3,0x1
    767c:	00d77463          	bgeu	a4,a3,7684 <malloc+0x6c>
    7680:	00001a37          	lui	s4,0x1
    7684:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    7688:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    768c:	00003917          	auipc	s2,0x3
    7690:	dc490913          	add	s2,s2,-572 # a450 <freep>
  if(p == (char*)-1)
    7694:	fff00a93          	li	s5,-1
    7698:	0a00006f          	j	7738 <malloc+0x120>
    base.s.ptr = freep = prevp = &base;
    769c:	00009797          	auipc	a5,0x9
    76a0:	5dc78793          	add	a5,a5,1500 # 10c78 <base>
    76a4:	00003717          	auipc	a4,0x3
    76a8:	daf73623          	sd	a5,-596(a4) # a450 <freep>
    76ac:	00f7b023          	sd	a5,0(a5)
    base.s.size = 0;
    76b0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    76b4:	fbdff06f          	j	7670 <malloc+0x58>
      if(p->s.size == nunits)
    76b8:	04e48863          	beq	s1,a4,7708 <malloc+0xf0>
        p->s.size -= nunits;
    76bc:	4137073b          	subw	a4,a4,s3
    76c0:	00e7a423          	sw	a4,8(a5)
        p += p->s.size;
    76c4:	02071693          	sll	a3,a4,0x20
    76c8:	01c6d713          	srl	a4,a3,0x1c
    76cc:	00e787b3          	add	a5,a5,a4
        p->s.size = nunits;
    76d0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    76d4:	00003717          	auipc	a4,0x3
    76d8:	d6a73e23          	sd	a0,-644(a4) # a450 <freep>
      return (void*)(p + 1);
    76dc:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    76e0:	03813083          	ld	ra,56(sp)
    76e4:	03013403          	ld	s0,48(sp)
    76e8:	02813483          	ld	s1,40(sp)
    76ec:	02013903          	ld	s2,32(sp)
    76f0:	01813983          	ld	s3,24(sp)
    76f4:	01013a03          	ld	s4,16(sp)
    76f8:	00813a83          	ld	s5,8(sp)
    76fc:	00013b03          	ld	s6,0(sp)
    7700:	04010113          	add	sp,sp,64
    7704:	00008067          	ret
        prevp->s.ptr = p->s.ptr;
    7708:	0007b703          	ld	a4,0(a5)
    770c:	00e53023          	sd	a4,0(a0)
    7710:	fc5ff06f          	j	76d4 <malloc+0xbc>
  hp->s.size = nu;
    7714:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    7718:	01050513          	add	a0,a0,16
    771c:	00000097          	auipc	ra,0x0
    7720:	e4c080e7          	jalr	-436(ra) # 7568 <free>
  return freep;
    7724:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    7728:	fa050ce3          	beqz	a0,76e0 <malloc+0xc8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    772c:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
    7730:	0087a703          	lw	a4,8(a5)
    7734:	f89772e3          	bgeu	a4,s1,76b8 <malloc+0xa0>
    if(p == freep)
    7738:	00093703          	ld	a4,0(s2)
    773c:	00078513          	mv	a0,a5
    7740:	fef716e3          	bne	a4,a5,772c <malloc+0x114>
  p = sbrk(nu * sizeof(Header));
    7744:	000a0513          	mv	a0,s4
    7748:	00000097          	auipc	ra,0x0
    774c:	9bc080e7          	jalr	-1604(ra) # 7104 <sbrk>
  if(p == (char*)-1)
    7750:	fd5512e3          	bne	a0,s5,7714 <malloc+0xfc>
        return 0;
    7754:	00000513          	li	a0,0
    7758:	f89ff06f          	j	76e0 <malloc+0xc8>
