
user/_grind:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <do_rand>:
#include "kernel/riscv.h"

// from FreeBSD.
int
do_rand(unsigned long *ctx)
{
       0:	ff010113          	add	sp,sp,-16
       4:	00813423          	sd	s0,8(sp)
       8:	01010413          	add	s0,sp,16
 * October 1988, p. 1195.
 */
    long hi, lo, x;

    /* Transform to [1, 0x7ffffffe] range. */
    x = (*ctx % 0x7ffffffe) + 1;
       c:	00053783          	ld	a5,0(a0)
      10:	80000737          	lui	a4,0x80000
      14:	ffe74713          	xor	a4,a4,-2
      18:	02e7f7b3          	remu	a5,a5,a4
      1c:	00178793          	add	a5,a5,1
    hi = x / 127773;
    lo = x % 127773;
      20:	0001f6b7          	lui	a3,0x1f
      24:	31d68693          	add	a3,a3,797 # 1f31d <base+0x1cf15>
      28:	02d7e733          	rem	a4,a5,a3
    x = 16807 * lo - 2836 * hi;
      2c:	00004637          	lui	a2,0x4
      30:	1a760613          	add	a2,a2,423 # 41a7 <base+0x1d9f>
      34:	02c70733          	mul	a4,a4,a2
    hi = x / 127773;
      38:	02d7c7b3          	div	a5,a5,a3
    x = 16807 * lo - 2836 * hi;
      3c:	fffff6b7          	lui	a3,0xfffff
      40:	4ec68693          	add	a3,a3,1260 # fffffffffffff4ec <base+0xffffffffffffd0e4>
      44:	02d787b3          	mul	a5,a5,a3
      48:	00f707b3          	add	a5,a4,a5
    if (x < 0)
      4c:	0007ce63          	bltz	a5,68 <do_rand+0x68>
        x += 0x7fffffff;
    /* Transform to [0, 0x7ffffffd] range. */
    x--;
      50:	fff78793          	add	a5,a5,-1
    *ctx = x;
      54:	00f53023          	sd	a5,0(a0)
    return (x);
}
      58:	0007851b          	sext.w	a0,a5
      5c:	00813403          	ld	s0,8(sp)
      60:	01010113          	add	sp,sp,16
      64:	00008067          	ret
        x += 0x7fffffff;
      68:	80000737          	lui	a4,0x80000
      6c:	fff74713          	not	a4,a4
      70:	00e787b3          	add	a5,a5,a4
      74:	fddff06f          	j	50 <do_rand+0x50>

0000000000000078 <rand>:

unsigned long rand_next = 1;

int
rand(void)
{
      78:	ff010113          	add	sp,sp,-16
      7c:	00113423          	sd	ra,8(sp)
      80:	00813023          	sd	s0,0(sp)
      84:	01010413          	add	s0,sp,16
    return (do_rand(&rand_next));
      88:	00002517          	auipc	a0,0x2
      8c:	f7850513          	add	a0,a0,-136 # 2000 <rand_next>
      90:	00000097          	auipc	ra,0x0
      94:	f70080e7          	jalr	-144(ra) # 0 <do_rand>
}
      98:	00813083          	ld	ra,8(sp)
      9c:	00013403          	ld	s0,0(sp)
      a0:	01010113          	add	sp,sp,16
      a4:	00008067          	ret

00000000000000a8 <go>:

void
go(int which_child)
{
      a8:	f9010113          	add	sp,sp,-112
      ac:	06113423          	sd	ra,104(sp)
      b0:	06813023          	sd	s0,96(sp)
      b4:	04913c23          	sd	s1,88(sp)
      b8:	05213823          	sd	s2,80(sp)
      bc:	05313423          	sd	s3,72(sp)
      c0:	05413023          	sd	s4,64(sp)
      c4:	03513c23          	sd	s5,56(sp)
      c8:	03613823          	sd	s6,48(sp)
      cc:	07010413          	add	s0,sp,112
      d0:	00050493          	mv	s1,a0
  int fd = -1;
  static char buf[999];
  char *break0 = sbrk(0);
      d4:	00000513          	li	a0,0
      d8:	00001097          	auipc	ra,0x1
      dc:	124080e7          	jalr	292(ra) # 11fc <sbrk>
      e0:	00050a93          	mv	s5,a0
  uint64 iters = 0;

  mkdir("grindir");
      e4:	00001517          	auipc	a0,0x1
      e8:	77c50513          	add	a0,a0,1916 # 1860 <malloc+0x150>
      ec:	00001097          	auipc	ra,0x1
      f0:	0e0080e7          	jalr	224(ra) # 11cc <mkdir>
  if(chdir("grindir") != 0){
      f4:	00001517          	auipc	a0,0x1
      f8:	76c50513          	add	a0,a0,1900 # 1860 <malloc+0x150>
      fc:	00001097          	auipc	ra,0x1
     100:	0dc080e7          	jalr	220(ra) # 11d8 <chdir>
     104:	02050063          	beqz	a0,124 <go+0x7c>
    printf("grind: chdir grindir failed\n");
     108:	00001517          	auipc	a0,0x1
     10c:	76050513          	add	a0,a0,1888 # 1868 <malloc+0x158>
     110:	00001097          	auipc	ra,0x1
     114:	4fc080e7          	jalr	1276(ra) # 160c <printf>
    exit(1);
     118:	00100513          	li	a0,1
     11c:	00001097          	auipc	ra,0x1
     120:	014080e7          	jalr	20(ra) # 1130 <exit>
  }
  chdir("/");
     124:	00001517          	auipc	a0,0x1
     128:	76450513          	add	a0,a0,1892 # 1888 <malloc+0x178>
     12c:	00001097          	auipc	ra,0x1
     130:	0ac080e7          	jalr	172(ra) # 11d8 <chdir>
     134:	00001997          	auipc	s3,0x1
     138:	76498993          	add	s3,s3,1892 # 1898 <malloc+0x188>
     13c:	00048663          	beqz	s1,148 <go+0xa0>
     140:	00001997          	auipc	s3,0x1
     144:	75098993          	add	s3,s3,1872 # 1890 <malloc+0x180>
  uint64 iters = 0;
     148:	00000493          	li	s1,0
  int fd = -1;
     14c:	fff00a13          	li	s4,-1
     150:	00002917          	auipc	s2,0x2
     154:	9f890913          	add	s2,s2,-1544 # 1b48 <malloc+0x438>
     158:	0200006f          	j	178 <go+0xd0>
    iters++;
    if((iters % 500) == 0)
      write(1, which_child?"B":"A", 1);
    int what = rand() % 23;
    if(what == 1){
      close(open("grindir/../a", O_CREATE|O_RDWR));
     15c:	20200593          	li	a1,514
     160:	00001517          	auipc	a0,0x1
     164:	74050513          	add	a0,a0,1856 # 18a0 <malloc+0x190>
     168:	00001097          	auipc	ra,0x1
     16c:	028080e7          	jalr	40(ra) # 1190 <open>
     170:	00001097          	auipc	ra,0x1
     174:	ffc080e7          	jalr	-4(ra) # 116c <close>
    iters++;
     178:	00148493          	add	s1,s1,1
    if((iters % 500) == 0)
     17c:	1f400793          	li	a5,500
     180:	02f4f7b3          	remu	a5,s1,a5
     184:	00079c63          	bnez	a5,19c <go+0xf4>
      write(1, which_child?"B":"A", 1);
     188:	00100613          	li	a2,1
     18c:	00098593          	mv	a1,s3
     190:	00100513          	li	a0,1
     194:	00001097          	auipc	ra,0x1
     198:	fcc080e7          	jalr	-52(ra) # 1160 <write>
    int what = rand() % 23;
     19c:	00000097          	auipc	ra,0x0
     1a0:	edc080e7          	jalr	-292(ra) # 78 <rand>
     1a4:	01700793          	li	a5,23
     1a8:	02f5653b          	remw	a0,a0,a5
    if(what == 1){
     1ac:	00100793          	li	a5,1
     1b0:	faf506e3          	beq	a0,a5,15c <go+0xb4>
    } else if(what == 2){
     1b4:	01600793          	li	a5,22
     1b8:	fca7e0e3          	bltu	a5,a0,178 <go+0xd0>
     1bc:	00251513          	sll	a0,a0,0x2
     1c0:	01250533          	add	a0,a0,s2
     1c4:	00052783          	lw	a5,0(a0)
     1c8:	012787b3          	add	a5,a5,s2
     1cc:	00078067          	jr	a5
      close(open("grindir/../grindir/../b", O_CREATE|O_RDWR));
     1d0:	20200593          	li	a1,514
     1d4:	00001517          	auipc	a0,0x1
     1d8:	6dc50513          	add	a0,a0,1756 # 18b0 <malloc+0x1a0>
     1dc:	00001097          	auipc	ra,0x1
     1e0:	fb4080e7          	jalr	-76(ra) # 1190 <open>
     1e4:	00001097          	auipc	ra,0x1
     1e8:	f88080e7          	jalr	-120(ra) # 116c <close>
     1ec:	f8dff06f          	j	178 <go+0xd0>
    } else if(what == 3){
      unlink("grindir/../a");
     1f0:	00001517          	auipc	a0,0x1
     1f4:	6b050513          	add	a0,a0,1712 # 18a0 <malloc+0x190>
     1f8:	00001097          	auipc	ra,0x1
     1fc:	fb0080e7          	jalr	-80(ra) # 11a8 <unlink>
     200:	f79ff06f          	j	178 <go+0xd0>
    } else if(what == 4){
      if(chdir("grindir") != 0){
     204:	00001517          	auipc	a0,0x1
     208:	65c50513          	add	a0,a0,1628 # 1860 <malloc+0x150>
     20c:	00001097          	auipc	ra,0x1
     210:	fcc080e7          	jalr	-52(ra) # 11d8 <chdir>
     214:	02051463          	bnez	a0,23c <go+0x194>
        printf("grind: chdir grindir failed\n");
        exit(1);
      }
      unlink("../b");
     218:	00001517          	auipc	a0,0x1
     21c:	6b050513          	add	a0,a0,1712 # 18c8 <malloc+0x1b8>
     220:	00001097          	auipc	ra,0x1
     224:	f88080e7          	jalr	-120(ra) # 11a8 <unlink>
      chdir("/");
     228:	00001517          	auipc	a0,0x1
     22c:	66050513          	add	a0,a0,1632 # 1888 <malloc+0x178>
     230:	00001097          	auipc	ra,0x1
     234:	fa8080e7          	jalr	-88(ra) # 11d8 <chdir>
     238:	f41ff06f          	j	178 <go+0xd0>
        printf("grind: chdir grindir failed\n");
     23c:	00001517          	auipc	a0,0x1
     240:	62c50513          	add	a0,a0,1580 # 1868 <malloc+0x158>
     244:	00001097          	auipc	ra,0x1
     248:	3c8080e7          	jalr	968(ra) # 160c <printf>
        exit(1);
     24c:	00100513          	li	a0,1
     250:	00001097          	auipc	ra,0x1
     254:	ee0080e7          	jalr	-288(ra) # 1130 <exit>
    } else if(what == 5){
      close(fd);
     258:	000a0513          	mv	a0,s4
     25c:	00001097          	auipc	ra,0x1
     260:	f10080e7          	jalr	-240(ra) # 116c <close>
      fd = open("/grindir/../a", O_CREATE|O_RDWR);
     264:	20200593          	li	a1,514
     268:	00001517          	auipc	a0,0x1
     26c:	66850513          	add	a0,a0,1640 # 18d0 <malloc+0x1c0>
     270:	00001097          	auipc	ra,0x1
     274:	f20080e7          	jalr	-224(ra) # 1190 <open>
     278:	00050a13          	mv	s4,a0
     27c:	efdff06f          	j	178 <go+0xd0>
    } else if(what == 6){
      close(fd);
     280:	000a0513          	mv	a0,s4
     284:	00001097          	auipc	ra,0x1
     288:	ee8080e7          	jalr	-280(ra) # 116c <close>
      fd = open("/./grindir/./../b", O_CREATE|O_RDWR);
     28c:	20200593          	li	a1,514
     290:	00001517          	auipc	a0,0x1
     294:	65050513          	add	a0,a0,1616 # 18e0 <malloc+0x1d0>
     298:	00001097          	auipc	ra,0x1
     29c:	ef8080e7          	jalr	-264(ra) # 1190 <open>
     2a0:	00050a13          	mv	s4,a0
     2a4:	ed5ff06f          	j	178 <go+0xd0>
    } else if(what == 7){
      write(fd, buf, sizeof(buf));
     2a8:	3e700613          	li	a2,999
     2ac:	00002597          	auipc	a1,0x2
     2b0:	d7458593          	add	a1,a1,-652 # 2020 <buf.0>
     2b4:	000a0513          	mv	a0,s4
     2b8:	00001097          	auipc	ra,0x1
     2bc:	ea8080e7          	jalr	-344(ra) # 1160 <write>
     2c0:	eb9ff06f          	j	178 <go+0xd0>
    } else if(what == 8){
      read(fd, buf, sizeof(buf));
     2c4:	3e700613          	li	a2,999
     2c8:	00002597          	auipc	a1,0x2
     2cc:	d5858593          	add	a1,a1,-680 # 2020 <buf.0>
     2d0:	000a0513          	mv	a0,s4
     2d4:	00001097          	auipc	ra,0x1
     2d8:	e80080e7          	jalr	-384(ra) # 1154 <read>
     2dc:	e9dff06f          	j	178 <go+0xd0>
    } else if(what == 9){
      mkdir("grindir/../a");
     2e0:	00001517          	auipc	a0,0x1
     2e4:	5c050513          	add	a0,a0,1472 # 18a0 <malloc+0x190>
     2e8:	00001097          	auipc	ra,0x1
     2ec:	ee4080e7          	jalr	-284(ra) # 11cc <mkdir>
      close(open("a/../a/./a", O_CREATE|O_RDWR));
     2f0:	20200593          	li	a1,514
     2f4:	00001517          	auipc	a0,0x1
     2f8:	60450513          	add	a0,a0,1540 # 18f8 <malloc+0x1e8>
     2fc:	00001097          	auipc	ra,0x1
     300:	e94080e7          	jalr	-364(ra) # 1190 <open>
     304:	00001097          	auipc	ra,0x1
     308:	e68080e7          	jalr	-408(ra) # 116c <close>
      unlink("a/a");
     30c:	00001517          	auipc	a0,0x1
     310:	5fc50513          	add	a0,a0,1532 # 1908 <malloc+0x1f8>
     314:	00001097          	auipc	ra,0x1
     318:	e94080e7          	jalr	-364(ra) # 11a8 <unlink>
     31c:	e5dff06f          	j	178 <go+0xd0>
    } else if(what == 10){
      mkdir("/../b");
     320:	00001517          	auipc	a0,0x1
     324:	5f050513          	add	a0,a0,1520 # 1910 <malloc+0x200>
     328:	00001097          	auipc	ra,0x1
     32c:	ea4080e7          	jalr	-348(ra) # 11cc <mkdir>
      close(open("grindir/../b/b", O_CREATE|O_RDWR));
     330:	20200593          	li	a1,514
     334:	00001517          	auipc	a0,0x1
     338:	5e450513          	add	a0,a0,1508 # 1918 <malloc+0x208>
     33c:	00001097          	auipc	ra,0x1
     340:	e54080e7          	jalr	-428(ra) # 1190 <open>
     344:	00001097          	auipc	ra,0x1
     348:	e28080e7          	jalr	-472(ra) # 116c <close>
      unlink("b/b");
     34c:	00001517          	auipc	a0,0x1
     350:	5dc50513          	add	a0,a0,1500 # 1928 <malloc+0x218>
     354:	00001097          	auipc	ra,0x1
     358:	e54080e7          	jalr	-428(ra) # 11a8 <unlink>
     35c:	e1dff06f          	j	178 <go+0xd0>
    } else if(what == 11){
      unlink("b");
     360:	00001517          	auipc	a0,0x1
     364:	59050513          	add	a0,a0,1424 # 18f0 <malloc+0x1e0>
     368:	00001097          	auipc	ra,0x1
     36c:	e40080e7          	jalr	-448(ra) # 11a8 <unlink>
      link("../grindir/./../a", "../b");
     370:	00001597          	auipc	a1,0x1
     374:	55858593          	add	a1,a1,1368 # 18c8 <malloc+0x1b8>
     378:	00001517          	auipc	a0,0x1
     37c:	5b850513          	add	a0,a0,1464 # 1930 <malloc+0x220>
     380:	00001097          	auipc	ra,0x1
     384:	e40080e7          	jalr	-448(ra) # 11c0 <link>
     388:	df1ff06f          	j	178 <go+0xd0>
    } else if(what == 12){
      unlink("../grindir/../a");
     38c:	00001517          	auipc	a0,0x1
     390:	5bc50513          	add	a0,a0,1468 # 1948 <malloc+0x238>
     394:	00001097          	auipc	ra,0x1
     398:	e14080e7          	jalr	-492(ra) # 11a8 <unlink>
      link(".././b", "/grindir/../a");
     39c:	00001597          	auipc	a1,0x1
     3a0:	53458593          	add	a1,a1,1332 # 18d0 <malloc+0x1c0>
     3a4:	00001517          	auipc	a0,0x1
     3a8:	5b450513          	add	a0,a0,1460 # 1958 <malloc+0x248>
     3ac:	00001097          	auipc	ra,0x1
     3b0:	e14080e7          	jalr	-492(ra) # 11c0 <link>
     3b4:	dc5ff06f          	j	178 <go+0xd0>
    } else if(what == 13){
      int pid = fork();
     3b8:	00001097          	auipc	ra,0x1
     3bc:	d6c080e7          	jalr	-660(ra) # 1124 <fork>
      if(pid == 0){
     3c0:	00050c63          	beqz	a0,3d8 <go+0x330>
        exit(0);
      } else if(pid < 0){
     3c4:	00054e63          	bltz	a0,3e0 <go+0x338>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     3c8:	00000513          	li	a0,0
     3cc:	00001097          	auipc	ra,0x1
     3d0:	d70080e7          	jalr	-656(ra) # 113c <wait>
     3d4:	da5ff06f          	j	178 <go+0xd0>
        exit(0);
     3d8:	00001097          	auipc	ra,0x1
     3dc:	d58080e7          	jalr	-680(ra) # 1130 <exit>
        printf("grind: fork failed\n");
     3e0:	00001517          	auipc	a0,0x1
     3e4:	58050513          	add	a0,a0,1408 # 1960 <malloc+0x250>
     3e8:	00001097          	auipc	ra,0x1
     3ec:	224080e7          	jalr	548(ra) # 160c <printf>
        exit(1);
     3f0:	00100513          	li	a0,1
     3f4:	00001097          	auipc	ra,0x1
     3f8:	d3c080e7          	jalr	-708(ra) # 1130 <exit>
    } else if(what == 14){
      int pid = fork();
     3fc:	00001097          	auipc	ra,0x1
     400:	d28080e7          	jalr	-728(ra) # 1124 <fork>
      if(pid == 0){
     404:	00050c63          	beqz	a0,41c <go+0x374>
        fork();
        fork();
        exit(0);
      } else if(pid < 0){
     408:	02054863          	bltz	a0,438 <go+0x390>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     40c:	00000513          	li	a0,0
     410:	00001097          	auipc	ra,0x1
     414:	d2c080e7          	jalr	-724(ra) # 113c <wait>
     418:	d61ff06f          	j	178 <go+0xd0>
        fork();
     41c:	00001097          	auipc	ra,0x1
     420:	d08080e7          	jalr	-760(ra) # 1124 <fork>
        fork();
     424:	00001097          	auipc	ra,0x1
     428:	d00080e7          	jalr	-768(ra) # 1124 <fork>
        exit(0);
     42c:	00000513          	li	a0,0
     430:	00001097          	auipc	ra,0x1
     434:	d00080e7          	jalr	-768(ra) # 1130 <exit>
        printf("grind: fork failed\n");
     438:	00001517          	auipc	a0,0x1
     43c:	52850513          	add	a0,a0,1320 # 1960 <malloc+0x250>
     440:	00001097          	auipc	ra,0x1
     444:	1cc080e7          	jalr	460(ra) # 160c <printf>
        exit(1);
     448:	00100513          	li	a0,1
     44c:	00001097          	auipc	ra,0x1
     450:	ce4080e7          	jalr	-796(ra) # 1130 <exit>
    } else if(what == 15){
      sbrk(6011);
     454:	00001537          	lui	a0,0x1
     458:	77b50513          	add	a0,a0,1915 # 177b <malloc+0x6b>
     45c:	00001097          	auipc	ra,0x1
     460:	da0080e7          	jalr	-608(ra) # 11fc <sbrk>
     464:	d15ff06f          	j	178 <go+0xd0>
    } else if(what == 16){
      if(sbrk(0) > break0)
     468:	00000513          	li	a0,0
     46c:	00001097          	auipc	ra,0x1
     470:	d90080e7          	jalr	-624(ra) # 11fc <sbrk>
     474:	d0aaf2e3          	bgeu	s5,a0,178 <go+0xd0>
        sbrk(-(sbrk(0) - break0));
     478:	00000513          	li	a0,0
     47c:	00001097          	auipc	ra,0x1
     480:	d80080e7          	jalr	-640(ra) # 11fc <sbrk>
     484:	40aa853b          	subw	a0,s5,a0
     488:	00001097          	auipc	ra,0x1
     48c:	d74080e7          	jalr	-652(ra) # 11fc <sbrk>
     490:	ce9ff06f          	j	178 <go+0xd0>
    } else if(what == 17){
      int pid = fork();
     494:	00001097          	auipc	ra,0x1
     498:	c90080e7          	jalr	-880(ra) # 1124 <fork>
     49c:	00050b13          	mv	s6,a0
      if(pid == 0){
     4a0:	02050c63          	beqz	a0,4d8 <go+0x430>
        close(open("a", O_CREATE|O_RDWR));
        exit(0);
      } else if(pid < 0){
     4a4:	04054e63          	bltz	a0,500 <go+0x458>
        printf("grind: fork failed\n");
        exit(1);
      }
      if(chdir("../grindir/..") != 0){
     4a8:	00001517          	auipc	a0,0x1
     4ac:	4d050513          	add	a0,a0,1232 # 1978 <malloc+0x268>
     4b0:	00001097          	auipc	ra,0x1
     4b4:	d28080e7          	jalr	-728(ra) # 11d8 <chdir>
     4b8:	06051263          	bnez	a0,51c <go+0x474>
        printf("grind: chdir failed\n");
        exit(1);
      }
      kill(pid);
     4bc:	000b0513          	mv	a0,s6
     4c0:	00001097          	auipc	ra,0x1
     4c4:	cb8080e7          	jalr	-840(ra) # 1178 <kill>
      wait(0);
     4c8:	00000513          	li	a0,0
     4cc:	00001097          	auipc	ra,0x1
     4d0:	c70080e7          	jalr	-912(ra) # 113c <wait>
     4d4:	ca5ff06f          	j	178 <go+0xd0>
        close(open("a", O_CREATE|O_RDWR));
     4d8:	20200593          	li	a1,514
     4dc:	00001517          	auipc	a0,0x1
     4e0:	46450513          	add	a0,a0,1124 # 1940 <malloc+0x230>
     4e4:	00001097          	auipc	ra,0x1
     4e8:	cac080e7          	jalr	-852(ra) # 1190 <open>
     4ec:	00001097          	auipc	ra,0x1
     4f0:	c80080e7          	jalr	-896(ra) # 116c <close>
        exit(0);
     4f4:	00000513          	li	a0,0
     4f8:	00001097          	auipc	ra,0x1
     4fc:	c38080e7          	jalr	-968(ra) # 1130 <exit>
        printf("grind: fork failed\n");
     500:	00001517          	auipc	a0,0x1
     504:	46050513          	add	a0,a0,1120 # 1960 <malloc+0x250>
     508:	00001097          	auipc	ra,0x1
     50c:	104080e7          	jalr	260(ra) # 160c <printf>
        exit(1);
     510:	00100513          	li	a0,1
     514:	00001097          	auipc	ra,0x1
     518:	c1c080e7          	jalr	-996(ra) # 1130 <exit>
        printf("grind: chdir failed\n");
     51c:	00001517          	auipc	a0,0x1
     520:	46c50513          	add	a0,a0,1132 # 1988 <malloc+0x278>
     524:	00001097          	auipc	ra,0x1
     528:	0e8080e7          	jalr	232(ra) # 160c <printf>
        exit(1);
     52c:	00100513          	li	a0,1
     530:	00001097          	auipc	ra,0x1
     534:	c00080e7          	jalr	-1024(ra) # 1130 <exit>
    } else if(what == 18){
      int pid = fork();
     538:	00001097          	auipc	ra,0x1
     53c:	bec080e7          	jalr	-1044(ra) # 1124 <fork>
      if(pid == 0){
     540:	00050c63          	beqz	a0,558 <go+0x4b0>
        kill(getpid());
        exit(0);
      } else if(pid < 0){
     544:	02054863          	bltz	a0,574 <go+0x4cc>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     548:	00000513          	li	a0,0
     54c:	00001097          	auipc	ra,0x1
     550:	bf0080e7          	jalr	-1040(ra) # 113c <wait>
     554:	c25ff06f          	j	178 <go+0xd0>
        kill(getpid());
     558:	00001097          	auipc	ra,0x1
     55c:	c98080e7          	jalr	-872(ra) # 11f0 <getpid>
     560:	00001097          	auipc	ra,0x1
     564:	c18080e7          	jalr	-1000(ra) # 1178 <kill>
        exit(0);
     568:	00000513          	li	a0,0
     56c:	00001097          	auipc	ra,0x1
     570:	bc4080e7          	jalr	-1084(ra) # 1130 <exit>
        printf("grind: fork failed\n");
     574:	00001517          	auipc	a0,0x1
     578:	3ec50513          	add	a0,a0,1004 # 1960 <malloc+0x250>
     57c:	00001097          	auipc	ra,0x1
     580:	090080e7          	jalr	144(ra) # 160c <printf>
        exit(1);
     584:	00100513          	li	a0,1
     588:	00001097          	auipc	ra,0x1
     58c:	ba8080e7          	jalr	-1112(ra) # 1130 <exit>
    } else if(what == 19){
      int fds[2];
      if(pipe(fds) < 0){
     590:	fa840513          	add	a0,s0,-88
     594:	00001097          	auipc	ra,0x1
     598:	bb4080e7          	jalr	-1100(ra) # 1148 <pipe>
     59c:	02054e63          	bltz	a0,5d8 <go+0x530>
        printf("grind: pipe failed\n");
        exit(1);
      }
      int pid = fork();
     5a0:	00001097          	auipc	ra,0x1
     5a4:	b84080e7          	jalr	-1148(ra) # 1124 <fork>
      if(pid == 0){
     5a8:	04050663          	beqz	a0,5f4 <go+0x54c>
          printf("grind: pipe write failed\n");
        char c;
        if(read(fds[0], &c, 1) != 1)
          printf("grind: pipe read failed\n");
        exit(0);
      } else if(pid < 0){
     5ac:	0c054463          	bltz	a0,674 <go+0x5cc>
        printf("grind: fork failed\n");
        exit(1);
      }
      close(fds[0]);
     5b0:	fa842503          	lw	a0,-88(s0)
     5b4:	00001097          	auipc	ra,0x1
     5b8:	bb8080e7          	jalr	-1096(ra) # 116c <close>
      close(fds[1]);
     5bc:	fac42503          	lw	a0,-84(s0)
     5c0:	00001097          	auipc	ra,0x1
     5c4:	bac080e7          	jalr	-1108(ra) # 116c <close>
      wait(0);
     5c8:	00000513          	li	a0,0
     5cc:	00001097          	auipc	ra,0x1
     5d0:	b70080e7          	jalr	-1168(ra) # 113c <wait>
     5d4:	ba5ff06f          	j	178 <go+0xd0>
        printf("grind: pipe failed\n");
     5d8:	00001517          	auipc	a0,0x1
     5dc:	3c850513          	add	a0,a0,968 # 19a0 <malloc+0x290>
     5e0:	00001097          	auipc	ra,0x1
     5e4:	02c080e7          	jalr	44(ra) # 160c <printf>
        exit(1);
     5e8:	00100513          	li	a0,1
     5ec:	00001097          	auipc	ra,0x1
     5f0:	b44080e7          	jalr	-1212(ra) # 1130 <exit>
        fork();
     5f4:	00001097          	auipc	ra,0x1
     5f8:	b30080e7          	jalr	-1232(ra) # 1124 <fork>
        fork();
     5fc:	00001097          	auipc	ra,0x1
     600:	b28080e7          	jalr	-1240(ra) # 1124 <fork>
        if(write(fds[1], "x", 1) != 1)
     604:	00100613          	li	a2,1
     608:	00001597          	auipc	a1,0x1
     60c:	3b058593          	add	a1,a1,944 # 19b8 <malloc+0x2a8>
     610:	fac42503          	lw	a0,-84(s0)
     614:	00001097          	auipc	ra,0x1
     618:	b4c080e7          	jalr	-1204(ra) # 1160 <write>
     61c:	00100793          	li	a5,1
     620:	02f51663          	bne	a0,a5,64c <go+0x5a4>
        if(read(fds[0], &c, 1) != 1)
     624:	00100613          	li	a2,1
     628:	fa040593          	add	a1,s0,-96
     62c:	fa842503          	lw	a0,-88(s0)
     630:	00001097          	auipc	ra,0x1
     634:	b24080e7          	jalr	-1244(ra) # 1154 <read>
     638:	00100793          	li	a5,1
     63c:	02f51263          	bne	a0,a5,660 <go+0x5b8>
        exit(0);
     640:	00000513          	li	a0,0
     644:	00001097          	auipc	ra,0x1
     648:	aec080e7          	jalr	-1300(ra) # 1130 <exit>
          printf("grind: pipe write failed\n");
     64c:	00001517          	auipc	a0,0x1
     650:	37450513          	add	a0,a0,884 # 19c0 <malloc+0x2b0>
     654:	00001097          	auipc	ra,0x1
     658:	fb8080e7          	jalr	-72(ra) # 160c <printf>
     65c:	fc9ff06f          	j	624 <go+0x57c>
          printf("grind: pipe read failed\n");
     660:	00001517          	auipc	a0,0x1
     664:	38050513          	add	a0,a0,896 # 19e0 <malloc+0x2d0>
     668:	00001097          	auipc	ra,0x1
     66c:	fa4080e7          	jalr	-92(ra) # 160c <printf>
     670:	fd1ff06f          	j	640 <go+0x598>
        printf("grind: fork failed\n");
     674:	00001517          	auipc	a0,0x1
     678:	2ec50513          	add	a0,a0,748 # 1960 <malloc+0x250>
     67c:	00001097          	auipc	ra,0x1
     680:	f90080e7          	jalr	-112(ra) # 160c <printf>
        exit(1);
     684:	00100513          	li	a0,1
     688:	00001097          	auipc	ra,0x1
     68c:	aa8080e7          	jalr	-1368(ra) # 1130 <exit>
    } else if(what == 20){
      int pid = fork();
     690:	00001097          	auipc	ra,0x1
     694:	a94080e7          	jalr	-1388(ra) # 1124 <fork>
      if(pid == 0){
     698:	00050c63          	beqz	a0,6b0 <go+0x608>
        chdir("a");
        unlink("../a");
        fd = open("x", O_CREATE|O_RDWR);
        unlink("x");
        exit(0);
      } else if(pid < 0){
     69c:	08054263          	bltz	a0,720 <go+0x678>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     6a0:	00000513          	li	a0,0
     6a4:	00001097          	auipc	ra,0x1
     6a8:	a98080e7          	jalr	-1384(ra) # 113c <wait>
     6ac:	acdff06f          	j	178 <go+0xd0>
        unlink("a");
     6b0:	00001517          	auipc	a0,0x1
     6b4:	29050513          	add	a0,a0,656 # 1940 <malloc+0x230>
     6b8:	00001097          	auipc	ra,0x1
     6bc:	af0080e7          	jalr	-1296(ra) # 11a8 <unlink>
        mkdir("a");
     6c0:	00001517          	auipc	a0,0x1
     6c4:	28050513          	add	a0,a0,640 # 1940 <malloc+0x230>
     6c8:	00001097          	auipc	ra,0x1
     6cc:	b04080e7          	jalr	-1276(ra) # 11cc <mkdir>
        chdir("a");
     6d0:	00001517          	auipc	a0,0x1
     6d4:	27050513          	add	a0,a0,624 # 1940 <malloc+0x230>
     6d8:	00001097          	auipc	ra,0x1
     6dc:	b00080e7          	jalr	-1280(ra) # 11d8 <chdir>
        unlink("../a");
     6e0:	00001517          	auipc	a0,0x1
     6e4:	1c850513          	add	a0,a0,456 # 18a8 <malloc+0x198>
     6e8:	00001097          	auipc	ra,0x1
     6ec:	ac0080e7          	jalr	-1344(ra) # 11a8 <unlink>
        fd = open("x", O_CREATE|O_RDWR);
     6f0:	20200593          	li	a1,514
     6f4:	00001517          	auipc	a0,0x1
     6f8:	2c450513          	add	a0,a0,708 # 19b8 <malloc+0x2a8>
     6fc:	00001097          	auipc	ra,0x1
     700:	a94080e7          	jalr	-1388(ra) # 1190 <open>
        unlink("x");
     704:	00001517          	auipc	a0,0x1
     708:	2b450513          	add	a0,a0,692 # 19b8 <malloc+0x2a8>
     70c:	00001097          	auipc	ra,0x1
     710:	a9c080e7          	jalr	-1380(ra) # 11a8 <unlink>
        exit(0);
     714:	00000513          	li	a0,0
     718:	00001097          	auipc	ra,0x1
     71c:	a18080e7          	jalr	-1512(ra) # 1130 <exit>
        printf("grind: fork failed\n");
     720:	00001517          	auipc	a0,0x1
     724:	24050513          	add	a0,a0,576 # 1960 <malloc+0x250>
     728:	00001097          	auipc	ra,0x1
     72c:	ee4080e7          	jalr	-284(ra) # 160c <printf>
        exit(1);
     730:	00100513          	li	a0,1
     734:	00001097          	auipc	ra,0x1
     738:	9fc080e7          	jalr	-1540(ra) # 1130 <exit>
    } else if(what == 21){
      unlink("c");
     73c:	00001517          	auipc	a0,0x1
     740:	2c450513          	add	a0,a0,708 # 1a00 <malloc+0x2f0>
     744:	00001097          	auipc	ra,0x1
     748:	a64080e7          	jalr	-1436(ra) # 11a8 <unlink>
      // should always succeed. check that there are free i-nodes,
      // file descriptors, blocks.
      int fd1 = open("c", O_CREATE|O_RDWR);
     74c:	20200593          	li	a1,514
     750:	00001517          	auipc	a0,0x1
     754:	2b050513          	add	a0,a0,688 # 1a00 <malloc+0x2f0>
     758:	00001097          	auipc	ra,0x1
     75c:	a38080e7          	jalr	-1480(ra) # 1190 <open>
     760:	00050b13          	mv	s6,a0
      if(fd1 < 0){
     764:	06054663          	bltz	a0,7d0 <go+0x728>
        printf("grind: create c failed\n");
        exit(1);
      }
      if(write(fd1, "x", 1) != 1){
     768:	00100613          	li	a2,1
     76c:	00001597          	auipc	a1,0x1
     770:	24c58593          	add	a1,a1,588 # 19b8 <malloc+0x2a8>
     774:	00001097          	auipc	ra,0x1
     778:	9ec080e7          	jalr	-1556(ra) # 1160 <write>
     77c:	00100793          	li	a5,1
     780:	06f51663          	bne	a0,a5,7ec <go+0x744>
        printf("grind: write c failed\n");
        exit(1);
      }
      struct stat st;
      if(fstat(fd1, &st) != 0){
     784:	fa840593          	add	a1,s0,-88
     788:	000b0513          	mv	a0,s6
     78c:	00001097          	auipc	ra,0x1
     790:	a28080e7          	jalr	-1496(ra) # 11b4 <fstat>
     794:	06051a63          	bnez	a0,808 <go+0x760>
        printf("grind: fstat failed\n");
        exit(1);
      }
      if(st.size != 1){
     798:	fb843583          	ld	a1,-72(s0)
     79c:	00100793          	li	a5,1
     7a0:	08f59263          	bne	a1,a5,824 <go+0x77c>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
        exit(1);
      }
      if(st.ino > 200){
     7a4:	fac42583          	lw	a1,-84(s0)
     7a8:	0c800793          	li	a5,200
     7ac:	08b7ec63          	bltu	a5,a1,844 <go+0x79c>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
        exit(1);
      }
      close(fd1);
     7b0:	000b0513          	mv	a0,s6
     7b4:	00001097          	auipc	ra,0x1
     7b8:	9b8080e7          	jalr	-1608(ra) # 116c <close>
      unlink("c");
     7bc:	00001517          	auipc	a0,0x1
     7c0:	24450513          	add	a0,a0,580 # 1a00 <malloc+0x2f0>
     7c4:	00001097          	auipc	ra,0x1
     7c8:	9e4080e7          	jalr	-1564(ra) # 11a8 <unlink>
     7cc:	9adff06f          	j	178 <go+0xd0>
        printf("grind: create c failed\n");
     7d0:	00001517          	auipc	a0,0x1
     7d4:	23850513          	add	a0,a0,568 # 1a08 <malloc+0x2f8>
     7d8:	00001097          	auipc	ra,0x1
     7dc:	e34080e7          	jalr	-460(ra) # 160c <printf>
        exit(1);
     7e0:	00100513          	li	a0,1
     7e4:	00001097          	auipc	ra,0x1
     7e8:	94c080e7          	jalr	-1716(ra) # 1130 <exit>
        printf("grind: write c failed\n");
     7ec:	00001517          	auipc	a0,0x1
     7f0:	23450513          	add	a0,a0,564 # 1a20 <malloc+0x310>
     7f4:	00001097          	auipc	ra,0x1
     7f8:	e18080e7          	jalr	-488(ra) # 160c <printf>
        exit(1);
     7fc:	00100513          	li	a0,1
     800:	00001097          	auipc	ra,0x1
     804:	930080e7          	jalr	-1744(ra) # 1130 <exit>
        printf("grind: fstat failed\n");
     808:	00001517          	auipc	a0,0x1
     80c:	23050513          	add	a0,a0,560 # 1a38 <malloc+0x328>
     810:	00001097          	auipc	ra,0x1
     814:	dfc080e7          	jalr	-516(ra) # 160c <printf>
        exit(1);
     818:	00100513          	li	a0,1
     81c:	00001097          	auipc	ra,0x1
     820:	914080e7          	jalr	-1772(ra) # 1130 <exit>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
     824:	0005859b          	sext.w	a1,a1
     828:	00001517          	auipc	a0,0x1
     82c:	22850513          	add	a0,a0,552 # 1a50 <malloc+0x340>
     830:	00001097          	auipc	ra,0x1
     834:	ddc080e7          	jalr	-548(ra) # 160c <printf>
        exit(1);
     838:	00100513          	li	a0,1
     83c:	00001097          	auipc	ra,0x1
     840:	8f4080e7          	jalr	-1804(ra) # 1130 <exit>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
     844:	00001517          	auipc	a0,0x1
     848:	23450513          	add	a0,a0,564 # 1a78 <malloc+0x368>
     84c:	00001097          	auipc	ra,0x1
     850:	dc0080e7          	jalr	-576(ra) # 160c <printf>
        exit(1);
     854:	00100513          	li	a0,1
     858:	00001097          	auipc	ra,0x1
     85c:	8d8080e7          	jalr	-1832(ra) # 1130 <exit>
    } else if(what == 22){
      // echo hi | cat
      int aa[2], bb[2];
      if(pipe(aa) < 0){
     860:	f9840513          	add	a0,s0,-104
     864:	00001097          	auipc	ra,0x1
     868:	8e4080e7          	jalr	-1820(ra) # 1148 <pipe>
     86c:	10054663          	bltz	a0,978 <go+0x8d0>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      if(pipe(bb) < 0){
     870:	fa040513          	add	a0,s0,-96
     874:	00001097          	auipc	ra,0x1
     878:	8d4080e7          	jalr	-1836(ra) # 1148 <pipe>
     87c:	10054e63          	bltz	a0,998 <go+0x8f0>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      int pid1 = fork();
     880:	00001097          	auipc	ra,0x1
     884:	8a4080e7          	jalr	-1884(ra) # 1124 <fork>
      if(pid1 == 0){
     888:	12050863          	beqz	a0,9b8 <go+0x910>
        close(aa[1]);
        char *args[3] = { "echo", "hi", 0 };
        exec("grindir/../echo", args);
        fprintf(2, "grind: echo: not found\n");
        exit(2);
      } else if(pid1 < 0){
     88c:	1e054663          	bltz	a0,a78 <go+0x9d0>
        fprintf(2, "grind: fork failed\n");
        exit(3);
      }
      int pid2 = fork();
     890:	00001097          	auipc	ra,0x1
     894:	894080e7          	jalr	-1900(ra) # 1124 <fork>
      if(pid2 == 0){
     898:	20050063          	beqz	a0,a98 <go+0x9f0>
        close(bb[1]);
        char *args[2] = { "cat", 0 };
        exec("/cat", args);
        fprintf(2, "grind: cat: not found\n");
        exit(6);
      } else if(pid2 < 0){
     89c:	2e054663          	bltz	a0,b88 <go+0xae0>
        fprintf(2, "grind: fork failed\n");
        exit(7);
      }
      close(aa[0]);
     8a0:	f9842503          	lw	a0,-104(s0)
     8a4:	00001097          	auipc	ra,0x1
     8a8:	8c8080e7          	jalr	-1848(ra) # 116c <close>
      close(aa[1]);
     8ac:	f9c42503          	lw	a0,-100(s0)
     8b0:	00001097          	auipc	ra,0x1
     8b4:	8bc080e7          	jalr	-1860(ra) # 116c <close>
      close(bb[1]);
     8b8:	fa442503          	lw	a0,-92(s0)
     8bc:	00001097          	auipc	ra,0x1
     8c0:	8b0080e7          	jalr	-1872(ra) # 116c <close>
      char buf[4] = { 0, 0, 0, 0 };
     8c4:	f8042823          	sw	zero,-112(s0)
      read(bb[0], buf+0, 1);
     8c8:	00100613          	li	a2,1
     8cc:	f9040593          	add	a1,s0,-112
     8d0:	fa042503          	lw	a0,-96(s0)
     8d4:	00001097          	auipc	ra,0x1
     8d8:	880080e7          	jalr	-1920(ra) # 1154 <read>
      read(bb[0], buf+1, 1);
     8dc:	00100613          	li	a2,1
     8e0:	f9140593          	add	a1,s0,-111
     8e4:	fa042503          	lw	a0,-96(s0)
     8e8:	00001097          	auipc	ra,0x1
     8ec:	86c080e7          	jalr	-1940(ra) # 1154 <read>
      read(bb[0], buf+2, 1);
     8f0:	00100613          	li	a2,1
     8f4:	f9240593          	add	a1,s0,-110
     8f8:	fa042503          	lw	a0,-96(s0)
     8fc:	00001097          	auipc	ra,0x1
     900:	858080e7          	jalr	-1960(ra) # 1154 <read>
      close(bb[0]);
     904:	fa042503          	lw	a0,-96(s0)
     908:	00001097          	auipc	ra,0x1
     90c:	864080e7          	jalr	-1948(ra) # 116c <close>
      int st1, st2;
      wait(&st1);
     910:	f9440513          	add	a0,s0,-108
     914:	00001097          	auipc	ra,0x1
     918:	828080e7          	jalr	-2008(ra) # 113c <wait>
      wait(&st2);
     91c:	fa840513          	add	a0,s0,-88
     920:	00001097          	auipc	ra,0x1
     924:	81c080e7          	jalr	-2020(ra) # 113c <wait>
      if(st1 != 0 || st2 != 0 || strcmp(buf, "hi\n") != 0){
     928:	f9442783          	lw	a5,-108(s0)
     92c:	fa842703          	lw	a4,-88(s0)
     930:	00e7e7b3          	or	a5,a5,a4
     934:	00079e63          	bnez	a5,950 <go+0x8a8>
     938:	00001597          	auipc	a1,0x1
     93c:	1e058593          	add	a1,a1,480 # 1b18 <malloc+0x408>
     940:	f9040513          	add	a0,s0,-112
     944:	00000097          	auipc	ra,0x0
     948:	450080e7          	jalr	1104(ra) # d94 <strcmp>
     94c:	820506e3          	beqz	a0,178 <go+0xd0>
        printf("grind: exec pipeline failed %d %d \"%s\"\n", st1, st2, buf);
     950:	f9040693          	add	a3,s0,-112
     954:	fa842603          	lw	a2,-88(s0)
     958:	f9442583          	lw	a1,-108(s0)
     95c:	00001517          	auipc	a0,0x1
     960:	1c450513          	add	a0,a0,452 # 1b20 <malloc+0x410>
     964:	00001097          	auipc	ra,0x1
     968:	ca8080e7          	jalr	-856(ra) # 160c <printf>
        exit(1);
     96c:	00100513          	li	a0,1
     970:	00000097          	auipc	ra,0x0
     974:	7c0080e7          	jalr	1984(ra) # 1130 <exit>
        fprintf(2, "grind: pipe failed\n");
     978:	00001597          	auipc	a1,0x1
     97c:	02858593          	add	a1,a1,40 # 19a0 <malloc+0x290>
     980:	00200513          	li	a0,2
     984:	00001097          	auipc	ra,0x1
     988:	c40080e7          	jalr	-960(ra) # 15c4 <fprintf>
        exit(1);
     98c:	00100513          	li	a0,1
     990:	00000097          	auipc	ra,0x0
     994:	7a0080e7          	jalr	1952(ra) # 1130 <exit>
        fprintf(2, "grind: pipe failed\n");
     998:	00001597          	auipc	a1,0x1
     99c:	00858593          	add	a1,a1,8 # 19a0 <malloc+0x290>
     9a0:	00200513          	li	a0,2
     9a4:	00001097          	auipc	ra,0x1
     9a8:	c20080e7          	jalr	-992(ra) # 15c4 <fprintf>
        exit(1);
     9ac:	00100513          	li	a0,1
     9b0:	00000097          	auipc	ra,0x0
     9b4:	780080e7          	jalr	1920(ra) # 1130 <exit>
        close(bb[0]);
     9b8:	fa042503          	lw	a0,-96(s0)
     9bc:	00000097          	auipc	ra,0x0
     9c0:	7b0080e7          	jalr	1968(ra) # 116c <close>
        close(bb[1]);
     9c4:	fa442503          	lw	a0,-92(s0)
     9c8:	00000097          	auipc	ra,0x0
     9cc:	7a4080e7          	jalr	1956(ra) # 116c <close>
        close(aa[0]);
     9d0:	f9842503          	lw	a0,-104(s0)
     9d4:	00000097          	auipc	ra,0x0
     9d8:	798080e7          	jalr	1944(ra) # 116c <close>
        close(1);
     9dc:	00100513          	li	a0,1
     9e0:	00000097          	auipc	ra,0x0
     9e4:	78c080e7          	jalr	1932(ra) # 116c <close>
        if(dup(aa[1]) != 1){
     9e8:	f9c42503          	lw	a0,-100(s0)
     9ec:	00000097          	auipc	ra,0x0
     9f0:	7f8080e7          	jalr	2040(ra) # 11e4 <dup>
     9f4:	00100793          	li	a5,1
     9f8:	02f50263          	beq	a0,a5,a1c <go+0x974>
          fprintf(2, "grind: dup failed\n");
     9fc:	00001597          	auipc	a1,0x1
     a00:	0a458593          	add	a1,a1,164 # 1aa0 <malloc+0x390>
     a04:	00200513          	li	a0,2
     a08:	00001097          	auipc	ra,0x1
     a0c:	bbc080e7          	jalr	-1092(ra) # 15c4 <fprintf>
          exit(1);
     a10:	00100513          	li	a0,1
     a14:	00000097          	auipc	ra,0x0
     a18:	71c080e7          	jalr	1820(ra) # 1130 <exit>
        close(aa[1]);
     a1c:	f9c42503          	lw	a0,-100(s0)
     a20:	00000097          	auipc	ra,0x0
     a24:	74c080e7          	jalr	1868(ra) # 116c <close>
        char *args[3] = { "echo", "hi", 0 };
     a28:	00001797          	auipc	a5,0x1
     a2c:	09078793          	add	a5,a5,144 # 1ab8 <malloc+0x3a8>
     a30:	faf43423          	sd	a5,-88(s0)
     a34:	00001797          	auipc	a5,0x1
     a38:	08c78793          	add	a5,a5,140 # 1ac0 <malloc+0x3b0>
     a3c:	faf43823          	sd	a5,-80(s0)
     a40:	fa043c23          	sd	zero,-72(s0)
        exec("grindir/../echo", args);
     a44:	fa840593          	add	a1,s0,-88
     a48:	00001517          	auipc	a0,0x1
     a4c:	08050513          	add	a0,a0,128 # 1ac8 <malloc+0x3b8>
     a50:	00000097          	auipc	ra,0x0
     a54:	734080e7          	jalr	1844(ra) # 1184 <exec>
        fprintf(2, "grind: echo: not found\n");
     a58:	00001597          	auipc	a1,0x1
     a5c:	08058593          	add	a1,a1,128 # 1ad8 <malloc+0x3c8>
     a60:	00200513          	li	a0,2
     a64:	00001097          	auipc	ra,0x1
     a68:	b60080e7          	jalr	-1184(ra) # 15c4 <fprintf>
        exit(2);
     a6c:	00200513          	li	a0,2
     a70:	00000097          	auipc	ra,0x0
     a74:	6c0080e7          	jalr	1728(ra) # 1130 <exit>
        fprintf(2, "grind: fork failed\n");
     a78:	00001597          	auipc	a1,0x1
     a7c:	ee858593          	add	a1,a1,-280 # 1960 <malloc+0x250>
     a80:	00200513          	li	a0,2
     a84:	00001097          	auipc	ra,0x1
     a88:	b40080e7          	jalr	-1216(ra) # 15c4 <fprintf>
        exit(3);
     a8c:	00300513          	li	a0,3
     a90:	00000097          	auipc	ra,0x0
     a94:	6a0080e7          	jalr	1696(ra) # 1130 <exit>
        close(aa[1]);
     a98:	f9c42503          	lw	a0,-100(s0)
     a9c:	00000097          	auipc	ra,0x0
     aa0:	6d0080e7          	jalr	1744(ra) # 116c <close>
        close(bb[0]);
     aa4:	fa042503          	lw	a0,-96(s0)
     aa8:	00000097          	auipc	ra,0x0
     aac:	6c4080e7          	jalr	1732(ra) # 116c <close>
        close(0);
     ab0:	00000513          	li	a0,0
     ab4:	00000097          	auipc	ra,0x0
     ab8:	6b8080e7          	jalr	1720(ra) # 116c <close>
        if(dup(aa[0]) != 0){
     abc:	f9842503          	lw	a0,-104(s0)
     ac0:	00000097          	auipc	ra,0x0
     ac4:	724080e7          	jalr	1828(ra) # 11e4 <dup>
     ac8:	02050263          	beqz	a0,aec <go+0xa44>
          fprintf(2, "grind: dup failed\n");
     acc:	00001597          	auipc	a1,0x1
     ad0:	fd458593          	add	a1,a1,-44 # 1aa0 <malloc+0x390>
     ad4:	00200513          	li	a0,2
     ad8:	00001097          	auipc	ra,0x1
     adc:	aec080e7          	jalr	-1300(ra) # 15c4 <fprintf>
          exit(4);
     ae0:	00400513          	li	a0,4
     ae4:	00000097          	auipc	ra,0x0
     ae8:	64c080e7          	jalr	1612(ra) # 1130 <exit>
        close(aa[0]);
     aec:	f9842503          	lw	a0,-104(s0)
     af0:	00000097          	auipc	ra,0x0
     af4:	67c080e7          	jalr	1660(ra) # 116c <close>
        close(1);
     af8:	00100513          	li	a0,1
     afc:	00000097          	auipc	ra,0x0
     b00:	670080e7          	jalr	1648(ra) # 116c <close>
        if(dup(bb[1]) != 1){
     b04:	fa442503          	lw	a0,-92(s0)
     b08:	00000097          	auipc	ra,0x0
     b0c:	6dc080e7          	jalr	1756(ra) # 11e4 <dup>
     b10:	00100793          	li	a5,1
     b14:	02f50263          	beq	a0,a5,b38 <go+0xa90>
          fprintf(2, "grind: dup failed\n");
     b18:	00001597          	auipc	a1,0x1
     b1c:	f8858593          	add	a1,a1,-120 # 1aa0 <malloc+0x390>
     b20:	00200513          	li	a0,2
     b24:	00001097          	auipc	ra,0x1
     b28:	aa0080e7          	jalr	-1376(ra) # 15c4 <fprintf>
          exit(5);
     b2c:	00500513          	li	a0,5
     b30:	00000097          	auipc	ra,0x0
     b34:	600080e7          	jalr	1536(ra) # 1130 <exit>
        close(bb[1]);
     b38:	fa442503          	lw	a0,-92(s0)
     b3c:	00000097          	auipc	ra,0x0
     b40:	630080e7          	jalr	1584(ra) # 116c <close>
        char *args[2] = { "cat", 0 };
     b44:	00001797          	auipc	a5,0x1
     b48:	fac78793          	add	a5,a5,-84 # 1af0 <malloc+0x3e0>
     b4c:	faf43423          	sd	a5,-88(s0)
     b50:	fa043823          	sd	zero,-80(s0)
        exec("/cat", args);
     b54:	fa840593          	add	a1,s0,-88
     b58:	00001517          	auipc	a0,0x1
     b5c:	fa050513          	add	a0,a0,-96 # 1af8 <malloc+0x3e8>
     b60:	00000097          	auipc	ra,0x0
     b64:	624080e7          	jalr	1572(ra) # 1184 <exec>
        fprintf(2, "grind: cat: not found\n");
     b68:	00001597          	auipc	a1,0x1
     b6c:	f9858593          	add	a1,a1,-104 # 1b00 <malloc+0x3f0>
     b70:	00200513          	li	a0,2
     b74:	00001097          	auipc	ra,0x1
     b78:	a50080e7          	jalr	-1456(ra) # 15c4 <fprintf>
        exit(6);
     b7c:	00600513          	li	a0,6
     b80:	00000097          	auipc	ra,0x0
     b84:	5b0080e7          	jalr	1456(ra) # 1130 <exit>
        fprintf(2, "grind: fork failed\n");
     b88:	00001597          	auipc	a1,0x1
     b8c:	dd858593          	add	a1,a1,-552 # 1960 <malloc+0x250>
     b90:	00200513          	li	a0,2
     b94:	00001097          	auipc	ra,0x1
     b98:	a30080e7          	jalr	-1488(ra) # 15c4 <fprintf>
        exit(7);
     b9c:	00700513          	li	a0,7
     ba0:	00000097          	auipc	ra,0x0
     ba4:	590080e7          	jalr	1424(ra) # 1130 <exit>

0000000000000ba8 <iter>:
  }
}

void
iter()
{
     ba8:	fd010113          	add	sp,sp,-48
     bac:	02113423          	sd	ra,40(sp)
     bb0:	02813023          	sd	s0,32(sp)
     bb4:	00913c23          	sd	s1,24(sp)
     bb8:	01213823          	sd	s2,16(sp)
     bbc:	03010413          	add	s0,sp,48
  unlink("a");
     bc0:	00001517          	auipc	a0,0x1
     bc4:	d8050513          	add	a0,a0,-640 # 1940 <malloc+0x230>
     bc8:	00000097          	auipc	ra,0x0
     bcc:	5e0080e7          	jalr	1504(ra) # 11a8 <unlink>
  unlink("b");
     bd0:	00001517          	auipc	a0,0x1
     bd4:	d2050513          	add	a0,a0,-736 # 18f0 <malloc+0x1e0>
     bd8:	00000097          	auipc	ra,0x0
     bdc:	5d0080e7          	jalr	1488(ra) # 11a8 <unlink>
  
  int pid1 = fork();
     be0:	00000097          	auipc	ra,0x0
     be4:	544080e7          	jalr	1348(ra) # 1124 <fork>
  if(pid1 < 0){
     be8:	02054663          	bltz	a0,c14 <iter+0x6c>
     bec:	00050493          	mv	s1,a0
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid1 == 0){
     bf0:	04051063          	bnez	a0,c30 <iter+0x88>
    rand_next ^= 31;
     bf4:	00001717          	auipc	a4,0x1
     bf8:	40c70713          	add	a4,a4,1036 # 2000 <rand_next>
     bfc:	00073783          	ld	a5,0(a4)
     c00:	01f7c793          	xor	a5,a5,31
     c04:	00f73023          	sd	a5,0(a4)
    go(0);
     c08:	00000513          	li	a0,0
     c0c:	fffff097          	auipc	ra,0xfffff
     c10:	49c080e7          	jalr	1180(ra) # a8 <go>
    printf("grind: fork failed\n");
     c14:	00001517          	auipc	a0,0x1
     c18:	d4c50513          	add	a0,a0,-692 # 1960 <malloc+0x250>
     c1c:	00001097          	auipc	ra,0x1
     c20:	9f0080e7          	jalr	-1552(ra) # 160c <printf>
    exit(1);
     c24:	00100513          	li	a0,1
     c28:	00000097          	auipc	ra,0x0
     c2c:	508080e7          	jalr	1288(ra) # 1130 <exit>
    exit(0);
  }

  int pid2 = fork();
     c30:	00000097          	auipc	ra,0x0
     c34:	4f4080e7          	jalr	1268(ra) # 1124 <fork>
     c38:	00050913          	mv	s2,a0
  if(pid2 < 0){
     c3c:	02054863          	bltz	a0,c6c <iter+0xc4>
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid2 == 0){
     c40:	04051463          	bnez	a0,c88 <iter+0xe0>
    rand_next ^= 7177;
     c44:	00001697          	auipc	a3,0x1
     c48:	3bc68693          	add	a3,a3,956 # 2000 <rand_next>
     c4c:	0006b783          	ld	a5,0(a3)
     c50:	00002737          	lui	a4,0x2
     c54:	c0970713          	add	a4,a4,-1015 # 1c09 <digits+0x1>
     c58:	00e7c7b3          	xor	a5,a5,a4
     c5c:	00f6b023          	sd	a5,0(a3)
    go(1);
     c60:	00100513          	li	a0,1
     c64:	fffff097          	auipc	ra,0xfffff
     c68:	444080e7          	jalr	1092(ra) # a8 <go>
    printf("grind: fork failed\n");
     c6c:	00001517          	auipc	a0,0x1
     c70:	cf450513          	add	a0,a0,-780 # 1960 <malloc+0x250>
     c74:	00001097          	auipc	ra,0x1
     c78:	998080e7          	jalr	-1640(ra) # 160c <printf>
    exit(1);
     c7c:	00100513          	li	a0,1
     c80:	00000097          	auipc	ra,0x0
     c84:	4b0080e7          	jalr	1200(ra) # 1130 <exit>
    exit(0);
  }

  int st1 = -1;
     c88:	fff00793          	li	a5,-1
     c8c:	fcf42e23          	sw	a5,-36(s0)
  wait(&st1);
     c90:	fdc40513          	add	a0,s0,-36
     c94:	00000097          	auipc	ra,0x0
     c98:	4a8080e7          	jalr	1192(ra) # 113c <wait>
  if(st1 != 0){
     c9c:	fdc42783          	lw	a5,-36(s0)
     ca0:	02079263          	bnez	a5,cc4 <iter+0x11c>
    kill(pid1);
    kill(pid2);
  }
  int st2 = -1;
     ca4:	fff00793          	li	a5,-1
     ca8:	fcf42c23          	sw	a5,-40(s0)
  wait(&st2);
     cac:	fd840513          	add	a0,s0,-40
     cb0:	00000097          	auipc	ra,0x0
     cb4:	48c080e7          	jalr	1164(ra) # 113c <wait>

  exit(0);
     cb8:	00000513          	li	a0,0
     cbc:	00000097          	auipc	ra,0x0
     cc0:	474080e7          	jalr	1140(ra) # 1130 <exit>
    kill(pid1);
     cc4:	00048513          	mv	a0,s1
     cc8:	00000097          	auipc	ra,0x0
     ccc:	4b0080e7          	jalr	1200(ra) # 1178 <kill>
    kill(pid2);
     cd0:	00090513          	mv	a0,s2
     cd4:	00000097          	auipc	ra,0x0
     cd8:	4a4080e7          	jalr	1188(ra) # 1178 <kill>
     cdc:	fc9ff06f          	j	ca4 <iter+0xfc>

0000000000000ce0 <main>:
}

int
main()
{
     ce0:	fe010113          	add	sp,sp,-32
     ce4:	00113c23          	sd	ra,24(sp)
     ce8:	00813823          	sd	s0,16(sp)
     cec:	00913423          	sd	s1,8(sp)
     cf0:	02010413          	add	s0,sp,32
    }
    if(pid > 0){
      wait(0);
    }
    sleep(20);
    rand_next += 1;
     cf4:	00001497          	auipc	s1,0x1
     cf8:	30c48493          	add	s1,s1,780 # 2000 <rand_next>
     cfc:	0240006f          	j	d20 <main+0x40>
      iter();
     d00:	00000097          	auipc	ra,0x0
     d04:	ea8080e7          	jalr	-344(ra) # ba8 <iter>
    sleep(20);
     d08:	01400513          	li	a0,20
     d0c:	00000097          	auipc	ra,0x0
     d10:	4fc080e7          	jalr	1276(ra) # 1208 <sleep>
    rand_next += 1;
     d14:	0004b783          	ld	a5,0(s1)
     d18:	00178793          	add	a5,a5,1
     d1c:	00f4b023          	sd	a5,0(s1)
    int pid = fork();
     d20:	00000097          	auipc	ra,0x0
     d24:	404080e7          	jalr	1028(ra) # 1124 <fork>
    if(pid == 0){
     d28:	fc050ce3          	beqz	a0,d00 <main+0x20>
    if(pid > 0){
     d2c:	fca05ee3          	blez	a0,d08 <main+0x28>
      wait(0);
     d30:	00000513          	li	a0,0
     d34:	00000097          	auipc	ra,0x0
     d38:	408080e7          	jalr	1032(ra) # 113c <wait>
     d3c:	fcdff06f          	j	d08 <main+0x28>

0000000000000d40 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
     d40:	ff010113          	add	sp,sp,-16
     d44:	00113423          	sd	ra,8(sp)
     d48:	00813023          	sd	s0,0(sp)
     d4c:	01010413          	add	s0,sp,16
  extern int main();
  main();
     d50:	00000097          	auipc	ra,0x0
     d54:	f90080e7          	jalr	-112(ra) # ce0 <main>
  exit(0);
     d58:	00000513          	li	a0,0
     d5c:	00000097          	auipc	ra,0x0
     d60:	3d4080e7          	jalr	980(ra) # 1130 <exit>

0000000000000d64 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     d64:	ff010113          	add	sp,sp,-16
     d68:	00813423          	sd	s0,8(sp)
     d6c:	01010413          	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     d70:	00050793          	mv	a5,a0
     d74:	00158593          	add	a1,a1,1
     d78:	00178793          	add	a5,a5,1
     d7c:	fff5c703          	lbu	a4,-1(a1)
     d80:	fee78fa3          	sb	a4,-1(a5)
     d84:	fe0718e3          	bnez	a4,d74 <strcpy+0x10>
    ;
  return os;
}
     d88:	00813403          	ld	s0,8(sp)
     d8c:	01010113          	add	sp,sp,16
     d90:	00008067          	ret

0000000000000d94 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     d94:	ff010113          	add	sp,sp,-16
     d98:	00813423          	sd	s0,8(sp)
     d9c:	01010413          	add	s0,sp,16
  while(*p && *p == *q)
     da0:	00054783          	lbu	a5,0(a0)
     da4:	00078e63          	beqz	a5,dc0 <strcmp+0x2c>
     da8:	0005c703          	lbu	a4,0(a1)
     dac:	00f71a63          	bne	a4,a5,dc0 <strcmp+0x2c>
    p++, q++;
     db0:	00150513          	add	a0,a0,1
     db4:	00158593          	add	a1,a1,1
  while(*p && *p == *q)
     db8:	00054783          	lbu	a5,0(a0)
     dbc:	fe0796e3          	bnez	a5,da8 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
     dc0:	0005c503          	lbu	a0,0(a1)
}
     dc4:	40a7853b          	subw	a0,a5,a0
     dc8:	00813403          	ld	s0,8(sp)
     dcc:	01010113          	add	sp,sp,16
     dd0:	00008067          	ret

0000000000000dd4 <strlen>:

uint
strlen(const char *s)
{
     dd4:	ff010113          	add	sp,sp,-16
     dd8:	00813423          	sd	s0,8(sp)
     ddc:	01010413          	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     de0:	00054783          	lbu	a5,0(a0)
     de4:	02078863          	beqz	a5,e14 <strlen+0x40>
     de8:	00150513          	add	a0,a0,1
     dec:	00050793          	mv	a5,a0
     df0:	00078693          	mv	a3,a5
     df4:	00178793          	add	a5,a5,1
     df8:	fff7c703          	lbu	a4,-1(a5)
     dfc:	fe071ae3          	bnez	a4,df0 <strlen+0x1c>
     e00:	40a6853b          	subw	a0,a3,a0
     e04:	0015051b          	addw	a0,a0,1
    ;
  return n;
}
     e08:	00813403          	ld	s0,8(sp)
     e0c:	01010113          	add	sp,sp,16
     e10:	00008067          	ret
  for(n = 0; s[n]; n++)
     e14:	00000513          	li	a0,0
     e18:	ff1ff06f          	j	e08 <strlen+0x34>

0000000000000e1c <memset>:

void*
memset(void *dst, int c, uint n)
{
     e1c:	ff010113          	add	sp,sp,-16
     e20:	00813423          	sd	s0,8(sp)
     e24:	01010413          	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     e28:	02060063          	beqz	a2,e48 <memset+0x2c>
     e2c:	00050793          	mv	a5,a0
     e30:	02061613          	sll	a2,a2,0x20
     e34:	02065613          	srl	a2,a2,0x20
     e38:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     e3c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     e40:	00178793          	add	a5,a5,1
     e44:	fee79ce3          	bne	a5,a4,e3c <memset+0x20>
  }
  return dst;
}
     e48:	00813403          	ld	s0,8(sp)
     e4c:	01010113          	add	sp,sp,16
     e50:	00008067          	ret

0000000000000e54 <strchr>:

char*
strchr(const char *s, char c)
{
     e54:	ff010113          	add	sp,sp,-16
     e58:	00813423          	sd	s0,8(sp)
     e5c:	01010413          	add	s0,sp,16
  for(; *s; s++)
     e60:	00054783          	lbu	a5,0(a0)
     e64:	02078263          	beqz	a5,e88 <strchr+0x34>
    if(*s == c)
     e68:	00f58a63          	beq	a1,a5,e7c <strchr+0x28>
  for(; *s; s++)
     e6c:	00150513          	add	a0,a0,1
     e70:	00054783          	lbu	a5,0(a0)
     e74:	fe079ae3          	bnez	a5,e68 <strchr+0x14>
      return (char*)s;
  return 0;
     e78:	00000513          	li	a0,0
}
     e7c:	00813403          	ld	s0,8(sp)
     e80:	01010113          	add	sp,sp,16
     e84:	00008067          	ret
  return 0;
     e88:	00000513          	li	a0,0
     e8c:	ff1ff06f          	j	e7c <strchr+0x28>

0000000000000e90 <gets>:

char*
gets(char *buf, int max)
{
     e90:	fa010113          	add	sp,sp,-96
     e94:	04113c23          	sd	ra,88(sp)
     e98:	04813823          	sd	s0,80(sp)
     e9c:	04913423          	sd	s1,72(sp)
     ea0:	05213023          	sd	s2,64(sp)
     ea4:	03313c23          	sd	s3,56(sp)
     ea8:	03413823          	sd	s4,48(sp)
     eac:	03513423          	sd	s5,40(sp)
     eb0:	03613023          	sd	s6,32(sp)
     eb4:	01713c23          	sd	s7,24(sp)
     eb8:	06010413          	add	s0,sp,96
     ebc:	00050b93          	mv	s7,a0
     ec0:	00058a13          	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     ec4:	00050913          	mv	s2,a0
     ec8:	00000493          	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     ecc:	00a00a93          	li	s5,10
     ed0:	00d00b13          	li	s6,13
  for(i=0; i+1 < max; ){
     ed4:	00048993          	mv	s3,s1
     ed8:	0014849b          	addw	s1,s1,1
     edc:	0344de63          	bge	s1,s4,f18 <gets+0x88>
    cc = read(0, &c, 1);
     ee0:	00100613          	li	a2,1
     ee4:	faf40593          	add	a1,s0,-81
     ee8:	00000513          	li	a0,0
     eec:	00000097          	auipc	ra,0x0
     ef0:	268080e7          	jalr	616(ra) # 1154 <read>
    if(cc < 1)
     ef4:	02a05263          	blez	a0,f18 <gets+0x88>
    buf[i++] = c;
     ef8:	faf44783          	lbu	a5,-81(s0)
     efc:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     f00:	01578a63          	beq	a5,s5,f14 <gets+0x84>
     f04:	00190913          	add	s2,s2,1
     f08:	fd6796e3          	bne	a5,s6,ed4 <gets+0x44>
  for(i=0; i+1 < max; ){
     f0c:	00048993          	mv	s3,s1
     f10:	0080006f          	j	f18 <gets+0x88>
     f14:	00048993          	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     f18:	013b89b3          	add	s3,s7,s3
     f1c:	00098023          	sb	zero,0(s3)
  return buf;
}
     f20:	000b8513          	mv	a0,s7
     f24:	05813083          	ld	ra,88(sp)
     f28:	05013403          	ld	s0,80(sp)
     f2c:	04813483          	ld	s1,72(sp)
     f30:	04013903          	ld	s2,64(sp)
     f34:	03813983          	ld	s3,56(sp)
     f38:	03013a03          	ld	s4,48(sp)
     f3c:	02813a83          	ld	s5,40(sp)
     f40:	02013b03          	ld	s6,32(sp)
     f44:	01813b83          	ld	s7,24(sp)
     f48:	06010113          	add	sp,sp,96
     f4c:	00008067          	ret

0000000000000f50 <stat>:

int
stat(const char *n, struct stat *st)
{
     f50:	fe010113          	add	sp,sp,-32
     f54:	00113c23          	sd	ra,24(sp)
     f58:	00813823          	sd	s0,16(sp)
     f5c:	00913423          	sd	s1,8(sp)
     f60:	01213023          	sd	s2,0(sp)
     f64:	02010413          	add	s0,sp,32
     f68:	00058913          	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     f6c:	00000593          	li	a1,0
     f70:	00000097          	auipc	ra,0x0
     f74:	220080e7          	jalr	544(ra) # 1190 <open>
  if(fd < 0)
     f78:	04054063          	bltz	a0,fb8 <stat+0x68>
     f7c:	00050493          	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     f80:	00090593          	mv	a1,s2
     f84:	00000097          	auipc	ra,0x0
     f88:	230080e7          	jalr	560(ra) # 11b4 <fstat>
     f8c:	00050913          	mv	s2,a0
  close(fd);
     f90:	00048513          	mv	a0,s1
     f94:	00000097          	auipc	ra,0x0
     f98:	1d8080e7          	jalr	472(ra) # 116c <close>
  return r;
}
     f9c:	00090513          	mv	a0,s2
     fa0:	01813083          	ld	ra,24(sp)
     fa4:	01013403          	ld	s0,16(sp)
     fa8:	00813483          	ld	s1,8(sp)
     fac:	00013903          	ld	s2,0(sp)
     fb0:	02010113          	add	sp,sp,32
     fb4:	00008067          	ret
    return -1;
     fb8:	fff00913          	li	s2,-1
     fbc:	fe1ff06f          	j	f9c <stat+0x4c>

0000000000000fc0 <atoi>:

int
atoi(const char *s)
{
     fc0:	ff010113          	add	sp,sp,-16
     fc4:	00813423          	sd	s0,8(sp)
     fc8:	01010413          	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     fcc:	00054683          	lbu	a3,0(a0)
     fd0:	fd06879b          	addw	a5,a3,-48
     fd4:	0ff7f793          	zext.b	a5,a5
     fd8:	00900613          	li	a2,9
     fdc:	04f66063          	bltu	a2,a5,101c <atoi+0x5c>
     fe0:	00050713          	mv	a4,a0
  n = 0;
     fe4:	00000513          	li	a0,0
    n = n*10 + *s++ - '0';
     fe8:	00170713          	add	a4,a4,1
     fec:	0025179b          	sllw	a5,a0,0x2
     ff0:	00a787bb          	addw	a5,a5,a0
     ff4:	0017979b          	sllw	a5,a5,0x1
     ff8:	00d787bb          	addw	a5,a5,a3
     ffc:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    1000:	00074683          	lbu	a3,0(a4)
    1004:	fd06879b          	addw	a5,a3,-48
    1008:	0ff7f793          	zext.b	a5,a5
    100c:	fcf67ee3          	bgeu	a2,a5,fe8 <atoi+0x28>
  return n;
}
    1010:	00813403          	ld	s0,8(sp)
    1014:	01010113          	add	sp,sp,16
    1018:	00008067          	ret
  n = 0;
    101c:	00000513          	li	a0,0
    1020:	ff1ff06f          	j	1010 <atoi+0x50>

0000000000001024 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    1024:	ff010113          	add	sp,sp,-16
    1028:	00813423          	sd	s0,8(sp)
    102c:	01010413          	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    1030:	02b57c63          	bgeu	a0,a1,1068 <memmove+0x44>
    while(n-- > 0)
    1034:	02c05463          	blez	a2,105c <memmove+0x38>
    1038:	02061613          	sll	a2,a2,0x20
    103c:	02065613          	srl	a2,a2,0x20
    1040:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    1044:	00050713          	mv	a4,a0
      *dst++ = *src++;
    1048:	00158593          	add	a1,a1,1
    104c:	00170713          	add	a4,a4,1
    1050:	fff5c683          	lbu	a3,-1(a1)
    1054:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    1058:	fee798e3          	bne	a5,a4,1048 <memmove+0x24>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    105c:	00813403          	ld	s0,8(sp)
    1060:	01010113          	add	sp,sp,16
    1064:	00008067          	ret
    dst += n;
    1068:	00c50733          	add	a4,a0,a2
    src += n;
    106c:	00c585b3          	add	a1,a1,a2
    while(n-- > 0)
    1070:	fec056e3          	blez	a2,105c <memmove+0x38>
    1074:	fff6079b          	addw	a5,a2,-1
    1078:	02079793          	sll	a5,a5,0x20
    107c:	0207d793          	srl	a5,a5,0x20
    1080:	fff7c793          	not	a5,a5
    1084:	00f707b3          	add	a5,a4,a5
      *--dst = *--src;
    1088:	fff58593          	add	a1,a1,-1
    108c:	fff70713          	add	a4,a4,-1
    1090:	0005c683          	lbu	a3,0(a1)
    1094:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    1098:	fee798e3          	bne	a5,a4,1088 <memmove+0x64>
    109c:	fc1ff06f          	j	105c <memmove+0x38>

00000000000010a0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    10a0:	ff010113          	add	sp,sp,-16
    10a4:	00813423          	sd	s0,8(sp)
    10a8:	01010413          	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    10ac:	04060463          	beqz	a2,10f4 <memcmp+0x54>
    10b0:	fff6069b          	addw	a3,a2,-1
    10b4:	02069693          	sll	a3,a3,0x20
    10b8:	0206d693          	srl	a3,a3,0x20
    10bc:	00168693          	add	a3,a3,1
    10c0:	00d506b3          	add	a3,a0,a3
    if (*p1 != *p2) {
    10c4:	00054783          	lbu	a5,0(a0)
    10c8:	0005c703          	lbu	a4,0(a1)
    10cc:	00e79c63          	bne	a5,a4,10e4 <memcmp+0x44>
      return *p1 - *p2;
    }
    p1++;
    10d0:	00150513          	add	a0,a0,1
    p2++;
    10d4:	00158593          	add	a1,a1,1
  while (n-- > 0) {
    10d8:	fed516e3          	bne	a0,a3,10c4 <memcmp+0x24>
  }
  return 0;
    10dc:	00000513          	li	a0,0
    10e0:	0080006f          	j	10e8 <memcmp+0x48>
      return *p1 - *p2;
    10e4:	40e7853b          	subw	a0,a5,a4
}
    10e8:	00813403          	ld	s0,8(sp)
    10ec:	01010113          	add	sp,sp,16
    10f0:	00008067          	ret
  return 0;
    10f4:	00000513          	li	a0,0
    10f8:	ff1ff06f          	j	10e8 <memcmp+0x48>

00000000000010fc <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    10fc:	ff010113          	add	sp,sp,-16
    1100:	00113423          	sd	ra,8(sp)
    1104:	00813023          	sd	s0,0(sp)
    1108:	01010413          	add	s0,sp,16
  return memmove(dst, src, n);
    110c:	00000097          	auipc	ra,0x0
    1110:	f18080e7          	jalr	-232(ra) # 1024 <memmove>
}
    1114:	00813083          	ld	ra,8(sp)
    1118:	00013403          	ld	s0,0(sp)
    111c:	01010113          	add	sp,sp,16
    1120:	00008067          	ret

0000000000001124 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    1124:	00100893          	li	a7,1
 ecall
    1128:	00000073          	ecall
 ret
    112c:	00008067          	ret

0000000000001130 <exit>:
.global exit
exit:
 li a7, SYS_exit
    1130:	00200893          	li	a7,2
 ecall
    1134:	00000073          	ecall
 ret
    1138:	00008067          	ret

000000000000113c <wait>:
.global wait
wait:
 li a7, SYS_wait
    113c:	00300893          	li	a7,3
 ecall
    1140:	00000073          	ecall
 ret
    1144:	00008067          	ret

0000000000001148 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    1148:	00400893          	li	a7,4
 ecall
    114c:	00000073          	ecall
 ret
    1150:	00008067          	ret

0000000000001154 <read>:
.global read
read:
 li a7, SYS_read
    1154:	00500893          	li	a7,5
 ecall
    1158:	00000073          	ecall
 ret
    115c:	00008067          	ret

0000000000001160 <write>:
.global write
write:
 li a7, SYS_write
    1160:	01000893          	li	a7,16
 ecall
    1164:	00000073          	ecall
 ret
    1168:	00008067          	ret

000000000000116c <close>:
.global close
close:
 li a7, SYS_close
    116c:	01500893          	li	a7,21
 ecall
    1170:	00000073          	ecall
 ret
    1174:	00008067          	ret

0000000000001178 <kill>:
.global kill
kill:
 li a7, SYS_kill
    1178:	00600893          	li	a7,6
 ecall
    117c:	00000073          	ecall
 ret
    1180:	00008067          	ret

0000000000001184 <exec>:
.global exec
exec:
 li a7, SYS_exec
    1184:	00700893          	li	a7,7
 ecall
    1188:	00000073          	ecall
 ret
    118c:	00008067          	ret

0000000000001190 <open>:
.global open
open:
 li a7, SYS_open
    1190:	00f00893          	li	a7,15
 ecall
    1194:	00000073          	ecall
 ret
    1198:	00008067          	ret

000000000000119c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    119c:	01100893          	li	a7,17
 ecall
    11a0:	00000073          	ecall
 ret
    11a4:	00008067          	ret

00000000000011a8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    11a8:	01200893          	li	a7,18
 ecall
    11ac:	00000073          	ecall
 ret
    11b0:	00008067          	ret

00000000000011b4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    11b4:	00800893          	li	a7,8
 ecall
    11b8:	00000073          	ecall
 ret
    11bc:	00008067          	ret

00000000000011c0 <link>:
.global link
link:
 li a7, SYS_link
    11c0:	01300893          	li	a7,19
 ecall
    11c4:	00000073          	ecall
 ret
    11c8:	00008067          	ret

00000000000011cc <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    11cc:	01400893          	li	a7,20
 ecall
    11d0:	00000073          	ecall
 ret
    11d4:	00008067          	ret

00000000000011d8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    11d8:	00900893          	li	a7,9
 ecall
    11dc:	00000073          	ecall
 ret
    11e0:	00008067          	ret

00000000000011e4 <dup>:
.global dup
dup:
 li a7, SYS_dup
    11e4:	00a00893          	li	a7,10
 ecall
    11e8:	00000073          	ecall
 ret
    11ec:	00008067          	ret

00000000000011f0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    11f0:	00b00893          	li	a7,11
 ecall
    11f4:	00000073          	ecall
 ret
    11f8:	00008067          	ret

00000000000011fc <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    11fc:	00c00893          	li	a7,12
 ecall
    1200:	00000073          	ecall
 ret
    1204:	00008067          	ret

0000000000001208 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    1208:	00d00893          	li	a7,13
 ecall
    120c:	00000073          	ecall
 ret
    1210:	00008067          	ret

0000000000001214 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    1214:	00e00893          	li	a7,14
 ecall
    1218:	00000073          	ecall
 ret
    121c:	00008067          	ret

0000000000001220 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    1220:	fe010113          	add	sp,sp,-32
    1224:	00113c23          	sd	ra,24(sp)
    1228:	00813823          	sd	s0,16(sp)
    122c:	02010413          	add	s0,sp,32
    1230:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    1234:	00100613          	li	a2,1
    1238:	fef40593          	add	a1,s0,-17
    123c:	00000097          	auipc	ra,0x0
    1240:	f24080e7          	jalr	-220(ra) # 1160 <write>
}
    1244:	01813083          	ld	ra,24(sp)
    1248:	01013403          	ld	s0,16(sp)
    124c:	02010113          	add	sp,sp,32
    1250:	00008067          	ret

0000000000001254 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1254:	fc010113          	add	sp,sp,-64
    1258:	02113c23          	sd	ra,56(sp)
    125c:	02813823          	sd	s0,48(sp)
    1260:	02913423          	sd	s1,40(sp)
    1264:	03213023          	sd	s2,32(sp)
    1268:	01313c23          	sd	s3,24(sp)
    126c:	04010413          	add	s0,sp,64
    1270:	00050493          	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    1274:	00068463          	beqz	a3,127c <printint+0x28>
    1278:	0c05c063          	bltz	a1,1338 <printint+0xe4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    127c:	0005859b          	sext.w	a1,a1
  neg = 0;
    1280:	00000893          	li	a7,0
    1284:	fc040693          	add	a3,s0,-64
  }

  i = 0;
    1288:	00000713          	li	a4,0
  do{
    buf[i++] = digits[x % base];
    128c:	0006061b          	sext.w	a2,a2
    1290:	00001517          	auipc	a0,0x1
    1294:	97850513          	add	a0,a0,-1672 # 1c08 <digits>
    1298:	00070813          	mv	a6,a4
    129c:	0017071b          	addw	a4,a4,1
    12a0:	02c5f7bb          	remuw	a5,a1,a2
    12a4:	02079793          	sll	a5,a5,0x20
    12a8:	0207d793          	srl	a5,a5,0x20
    12ac:	00f507b3          	add	a5,a0,a5
    12b0:	0007c783          	lbu	a5,0(a5)
    12b4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    12b8:	0005879b          	sext.w	a5,a1
    12bc:	02c5d5bb          	divuw	a1,a1,a2
    12c0:	00168693          	add	a3,a3,1
    12c4:	fcc7fae3          	bgeu	a5,a2,1298 <printint+0x44>
  if(neg)
    12c8:	00088c63          	beqz	a7,12e0 <printint+0x8c>
    buf[i++] = '-';
    12cc:	fd070793          	add	a5,a4,-48
    12d0:	00878733          	add	a4,a5,s0
    12d4:	02d00793          	li	a5,45
    12d8:	fef70823          	sb	a5,-16(a4)
    12dc:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
    12e0:	02e05e63          	blez	a4,131c <printint+0xc8>
    12e4:	fc040793          	add	a5,s0,-64
    12e8:	00e78933          	add	s2,a5,a4
    12ec:	fff78993          	add	s3,a5,-1
    12f0:	00e989b3          	add	s3,s3,a4
    12f4:	fff7071b          	addw	a4,a4,-1
    12f8:	02071713          	sll	a4,a4,0x20
    12fc:	02075713          	srl	a4,a4,0x20
    1300:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    1304:	fff94583          	lbu	a1,-1(s2)
    1308:	00048513          	mv	a0,s1
    130c:	00000097          	auipc	ra,0x0
    1310:	f14080e7          	jalr	-236(ra) # 1220 <putc>
  while(--i >= 0)
    1314:	fff90913          	add	s2,s2,-1
    1318:	ff3916e3          	bne	s2,s3,1304 <printint+0xb0>
}
    131c:	03813083          	ld	ra,56(sp)
    1320:	03013403          	ld	s0,48(sp)
    1324:	02813483          	ld	s1,40(sp)
    1328:	02013903          	ld	s2,32(sp)
    132c:	01813983          	ld	s3,24(sp)
    1330:	04010113          	add	sp,sp,64
    1334:	00008067          	ret
    x = -xx;
    1338:	40b005bb          	negw	a1,a1
    neg = 1;
    133c:	00100893          	li	a7,1
    x = -xx;
    1340:	f45ff06f          	j	1284 <printint+0x30>

0000000000001344 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    1344:	fb010113          	add	sp,sp,-80
    1348:	04113423          	sd	ra,72(sp)
    134c:	04813023          	sd	s0,64(sp)
    1350:	02913c23          	sd	s1,56(sp)
    1354:	03213823          	sd	s2,48(sp)
    1358:	03313423          	sd	s3,40(sp)
    135c:	03413023          	sd	s4,32(sp)
    1360:	01513c23          	sd	s5,24(sp)
    1364:	01613823          	sd	s6,16(sp)
    1368:	01713423          	sd	s7,8(sp)
    136c:	01813023          	sd	s8,0(sp)
    1370:	05010413          	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    1374:	0005c903          	lbu	s2,0(a1)
    1378:	20090e63          	beqz	s2,1594 <vprintf+0x250>
    137c:	00050a93          	mv	s5,a0
    1380:	00060b93          	mv	s7,a2
    1384:	00158493          	add	s1,a1,1
  state = 0;
    1388:	00000993          	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    138c:	02500a13          	li	s4,37
    1390:	01500b13          	li	s6,21
    1394:	0280006f          	j	13bc <vprintf+0x78>
        putc(fd, c);
    1398:	00090593          	mv	a1,s2
    139c:	000a8513          	mv	a0,s5
    13a0:	00000097          	auipc	ra,0x0
    13a4:	e80080e7          	jalr	-384(ra) # 1220 <putc>
    13a8:	0080006f          	j	13b0 <vprintf+0x6c>
    } else if(state == '%'){
    13ac:	03498063          	beq	s3,s4,13cc <vprintf+0x88>
  for(i = 0; fmt[i]; i++){
    13b0:	00148493          	add	s1,s1,1
    13b4:	fff4c903          	lbu	s2,-1(s1)
    13b8:	1c090e63          	beqz	s2,1594 <vprintf+0x250>
    if(state == 0){
    13bc:	fe0998e3          	bnez	s3,13ac <vprintf+0x68>
      if(c == '%'){
    13c0:	fd491ce3          	bne	s2,s4,1398 <vprintf+0x54>
        state = '%';
    13c4:	000a0993          	mv	s3,s4
    13c8:	fe9ff06f          	j	13b0 <vprintf+0x6c>
      if(c == 'd'){
    13cc:	17490e63          	beq	s2,s4,1548 <vprintf+0x204>
    13d0:	f9d9079b          	addw	a5,s2,-99
    13d4:	0ff7f793          	zext.b	a5,a5
    13d8:	18fb6463          	bltu	s6,a5,1560 <vprintf+0x21c>
    13dc:	f9d9079b          	addw	a5,s2,-99
    13e0:	0ff7f713          	zext.b	a4,a5
    13e4:	16eb6e63          	bltu	s6,a4,1560 <vprintf+0x21c>
    13e8:	00271793          	sll	a5,a4,0x2
    13ec:	00000717          	auipc	a4,0x0
    13f0:	7c470713          	add	a4,a4,1988 # 1bb0 <malloc+0x4a0>
    13f4:	00e787b3          	add	a5,a5,a4
    13f8:	0007a783          	lw	a5,0(a5)
    13fc:	00e787b3          	add	a5,a5,a4
    1400:	00078067          	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    1404:	008b8913          	add	s2,s7,8
    1408:	00100693          	li	a3,1
    140c:	00a00613          	li	a2,10
    1410:	000ba583          	lw	a1,0(s7)
    1414:	000a8513          	mv	a0,s5
    1418:	00000097          	auipc	ra,0x0
    141c:	e3c080e7          	jalr	-452(ra) # 1254 <printint>
    1420:	00090b93          	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    1424:	00000993          	li	s3,0
    1428:	f89ff06f          	j	13b0 <vprintf+0x6c>
        printint(fd, va_arg(ap, uint64), 10, 0);
    142c:	008b8913          	add	s2,s7,8
    1430:	00000693          	li	a3,0
    1434:	00a00613          	li	a2,10
    1438:	000ba583          	lw	a1,0(s7)
    143c:	000a8513          	mv	a0,s5
    1440:	00000097          	auipc	ra,0x0
    1444:	e14080e7          	jalr	-492(ra) # 1254 <printint>
    1448:	00090b93          	mv	s7,s2
      state = 0;
    144c:	00000993          	li	s3,0
    1450:	f61ff06f          	j	13b0 <vprintf+0x6c>
        printint(fd, va_arg(ap, int), 16, 0);
    1454:	008b8913          	add	s2,s7,8
    1458:	00000693          	li	a3,0
    145c:	01000613          	li	a2,16
    1460:	000ba583          	lw	a1,0(s7)
    1464:	000a8513          	mv	a0,s5
    1468:	00000097          	auipc	ra,0x0
    146c:	dec080e7          	jalr	-532(ra) # 1254 <printint>
    1470:	00090b93          	mv	s7,s2
      state = 0;
    1474:	00000993          	li	s3,0
    1478:	f39ff06f          	j	13b0 <vprintf+0x6c>
        printptr(fd, va_arg(ap, uint64));
    147c:	008b8c13          	add	s8,s7,8
    1480:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    1484:	03000593          	li	a1,48
    1488:	000a8513          	mv	a0,s5
    148c:	00000097          	auipc	ra,0x0
    1490:	d94080e7          	jalr	-620(ra) # 1220 <putc>
  putc(fd, 'x');
    1494:	07800593          	li	a1,120
    1498:	000a8513          	mv	a0,s5
    149c:	00000097          	auipc	ra,0x0
    14a0:	d84080e7          	jalr	-636(ra) # 1220 <putc>
    14a4:	01000913          	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    14a8:	00000b97          	auipc	s7,0x0
    14ac:	760b8b93          	add	s7,s7,1888 # 1c08 <digits>
    14b0:	03c9d793          	srl	a5,s3,0x3c
    14b4:	00fb87b3          	add	a5,s7,a5
    14b8:	0007c583          	lbu	a1,0(a5)
    14bc:	000a8513          	mv	a0,s5
    14c0:	00000097          	auipc	ra,0x0
    14c4:	d60080e7          	jalr	-672(ra) # 1220 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    14c8:	00499993          	sll	s3,s3,0x4
    14cc:	fff9091b          	addw	s2,s2,-1
    14d0:	fe0910e3          	bnez	s2,14b0 <vprintf+0x16c>
        printptr(fd, va_arg(ap, uint64));
    14d4:	000c0b93          	mv	s7,s8
      state = 0;
    14d8:	00000993          	li	s3,0
    14dc:	ed5ff06f          	j	13b0 <vprintf+0x6c>
        s = va_arg(ap, char*);
    14e0:	008b8993          	add	s3,s7,8
    14e4:	000bb903          	ld	s2,0(s7)
        if(s == 0)
    14e8:	02090863          	beqz	s2,1518 <vprintf+0x1d4>
        while(*s != 0){
    14ec:	00094583          	lbu	a1,0(s2)
    14f0:	08058c63          	beqz	a1,1588 <vprintf+0x244>
          putc(fd, *s);
    14f4:	000a8513          	mv	a0,s5
    14f8:	00000097          	auipc	ra,0x0
    14fc:	d28080e7          	jalr	-728(ra) # 1220 <putc>
          s++;
    1500:	00190913          	add	s2,s2,1
        while(*s != 0){
    1504:	00094583          	lbu	a1,0(s2)
    1508:	fe0596e3          	bnez	a1,14f4 <vprintf+0x1b0>
        s = va_arg(ap, char*);
    150c:	00098b93          	mv	s7,s3
      state = 0;
    1510:	00000993          	li	s3,0
    1514:	e9dff06f          	j	13b0 <vprintf+0x6c>
          s = "(null)";
    1518:	00000917          	auipc	s2,0x0
    151c:	69090913          	add	s2,s2,1680 # 1ba8 <malloc+0x498>
        while(*s != 0){
    1520:	02800593          	li	a1,40
    1524:	fd1ff06f          	j	14f4 <vprintf+0x1b0>
        putc(fd, va_arg(ap, uint));
    1528:	008b8913          	add	s2,s7,8
    152c:	000bc583          	lbu	a1,0(s7)
    1530:	000a8513          	mv	a0,s5
    1534:	00000097          	auipc	ra,0x0
    1538:	cec080e7          	jalr	-788(ra) # 1220 <putc>
    153c:	00090b93          	mv	s7,s2
      state = 0;
    1540:	00000993          	li	s3,0
    1544:	e6dff06f          	j	13b0 <vprintf+0x6c>
        putc(fd, c);
    1548:	02500593          	li	a1,37
    154c:	000a8513          	mv	a0,s5
    1550:	00000097          	auipc	ra,0x0
    1554:	cd0080e7          	jalr	-816(ra) # 1220 <putc>
      state = 0;
    1558:	00000993          	li	s3,0
    155c:	e55ff06f          	j	13b0 <vprintf+0x6c>
        putc(fd, '%');
    1560:	02500593          	li	a1,37
    1564:	000a8513          	mv	a0,s5
    1568:	00000097          	auipc	ra,0x0
    156c:	cb8080e7          	jalr	-840(ra) # 1220 <putc>
        putc(fd, c);
    1570:	00090593          	mv	a1,s2
    1574:	000a8513          	mv	a0,s5
    1578:	00000097          	auipc	ra,0x0
    157c:	ca8080e7          	jalr	-856(ra) # 1220 <putc>
      state = 0;
    1580:	00000993          	li	s3,0
    1584:	e2dff06f          	j	13b0 <vprintf+0x6c>
        s = va_arg(ap, char*);
    1588:	00098b93          	mv	s7,s3
      state = 0;
    158c:	00000993          	li	s3,0
    1590:	e21ff06f          	j	13b0 <vprintf+0x6c>
    }
  }
}
    1594:	04813083          	ld	ra,72(sp)
    1598:	04013403          	ld	s0,64(sp)
    159c:	03813483          	ld	s1,56(sp)
    15a0:	03013903          	ld	s2,48(sp)
    15a4:	02813983          	ld	s3,40(sp)
    15a8:	02013a03          	ld	s4,32(sp)
    15ac:	01813a83          	ld	s5,24(sp)
    15b0:	01013b03          	ld	s6,16(sp)
    15b4:	00813b83          	ld	s7,8(sp)
    15b8:	00013c03          	ld	s8,0(sp)
    15bc:	05010113          	add	sp,sp,80
    15c0:	00008067          	ret

00000000000015c4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    15c4:	fb010113          	add	sp,sp,-80
    15c8:	00113c23          	sd	ra,24(sp)
    15cc:	00813823          	sd	s0,16(sp)
    15d0:	02010413          	add	s0,sp,32
    15d4:	00c43023          	sd	a2,0(s0)
    15d8:	00d43423          	sd	a3,8(s0)
    15dc:	00e43823          	sd	a4,16(s0)
    15e0:	00f43c23          	sd	a5,24(s0)
    15e4:	03043023          	sd	a6,32(s0)
    15e8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    15ec:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    15f0:	00040613          	mv	a2,s0
    15f4:	00000097          	auipc	ra,0x0
    15f8:	d50080e7          	jalr	-688(ra) # 1344 <vprintf>
}
    15fc:	01813083          	ld	ra,24(sp)
    1600:	01013403          	ld	s0,16(sp)
    1604:	05010113          	add	sp,sp,80
    1608:	00008067          	ret

000000000000160c <printf>:

void
printf(const char *fmt, ...)
{
    160c:	fa010113          	add	sp,sp,-96
    1610:	00113c23          	sd	ra,24(sp)
    1614:	00813823          	sd	s0,16(sp)
    1618:	02010413          	add	s0,sp,32
    161c:	00b43423          	sd	a1,8(s0)
    1620:	00c43823          	sd	a2,16(s0)
    1624:	00d43c23          	sd	a3,24(s0)
    1628:	02e43023          	sd	a4,32(s0)
    162c:	02f43423          	sd	a5,40(s0)
    1630:	03043823          	sd	a6,48(s0)
    1634:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    1638:	00840613          	add	a2,s0,8
    163c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1640:	00050593          	mv	a1,a0
    1644:	00100513          	li	a0,1
    1648:	00000097          	auipc	ra,0x0
    164c:	cfc080e7          	jalr	-772(ra) # 1344 <vprintf>
}
    1650:	01813083          	ld	ra,24(sp)
    1654:	01013403          	ld	s0,16(sp)
    1658:	06010113          	add	sp,sp,96
    165c:	00008067          	ret

0000000000001660 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1660:	ff010113          	add	sp,sp,-16
    1664:	00813423          	sd	s0,8(sp)
    1668:	01010413          	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    166c:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1670:	00001797          	auipc	a5,0x1
    1674:	9a07b783          	ld	a5,-1632(a5) # 2010 <freep>
    1678:	0400006f          	j	16b8 <free+0x58>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    167c:	00862703          	lw	a4,8(a2)
    1680:	00b7073b          	addw	a4,a4,a1
    1684:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1688:	0007b703          	ld	a4,0(a5)
    168c:	00073603          	ld	a2,0(a4)
    1690:	0500006f          	j	16e0 <free+0x80>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    1694:	ff852703          	lw	a4,-8(a0)
    1698:	00c7073b          	addw	a4,a4,a2
    169c:	00e7a423          	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    16a0:	ff053683          	ld	a3,-16(a0)
    16a4:	0540006f          	j	16f8 <free+0x98>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    16a8:	0007b703          	ld	a4,0(a5)
    16ac:	00e7e463          	bltu	a5,a4,16b4 <free+0x54>
    16b0:	00e6ec63          	bltu	a3,a4,16c8 <free+0x68>
{
    16b4:	00070793          	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    16b8:	fed7f8e3          	bgeu	a5,a3,16a8 <free+0x48>
    16bc:	0007b703          	ld	a4,0(a5)
    16c0:	00e6e463          	bltu	a3,a4,16c8 <free+0x68>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    16c4:	fee7e8e3          	bltu	a5,a4,16b4 <free+0x54>
  if(bp + bp->s.size == p->s.ptr){
    16c8:	ff852583          	lw	a1,-8(a0)
    16cc:	0007b603          	ld	a2,0(a5)
    16d0:	02059813          	sll	a6,a1,0x20
    16d4:	01c85713          	srl	a4,a6,0x1c
    16d8:	00e68733          	add	a4,a3,a4
    16dc:	fae600e3          	beq	a2,a4,167c <free+0x1c>
    bp->s.ptr = p->s.ptr->s.ptr;
    16e0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    16e4:	0087a603          	lw	a2,8(a5)
    16e8:	02061593          	sll	a1,a2,0x20
    16ec:	01c5d713          	srl	a4,a1,0x1c
    16f0:	00e78733          	add	a4,a5,a4
    16f4:	fae680e3          	beq	a3,a4,1694 <free+0x34>
    p->s.ptr = bp->s.ptr;
    16f8:	00d7b023          	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    16fc:	00001717          	auipc	a4,0x1
    1700:	90f73a23          	sd	a5,-1772(a4) # 2010 <freep>
}
    1704:	00813403          	ld	s0,8(sp)
    1708:	01010113          	add	sp,sp,16
    170c:	00008067          	ret

0000000000001710 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1710:	fc010113          	add	sp,sp,-64
    1714:	02113c23          	sd	ra,56(sp)
    1718:	02813823          	sd	s0,48(sp)
    171c:	02913423          	sd	s1,40(sp)
    1720:	03213023          	sd	s2,32(sp)
    1724:	01313c23          	sd	s3,24(sp)
    1728:	01413823          	sd	s4,16(sp)
    172c:	01513423          	sd	s5,8(sp)
    1730:	01613023          	sd	s6,0(sp)
    1734:	04010413          	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1738:	02051493          	sll	s1,a0,0x20
    173c:	0204d493          	srl	s1,s1,0x20
    1740:	00f48493          	add	s1,s1,15
    1744:	0044d493          	srl	s1,s1,0x4
    1748:	0014899b          	addw	s3,s1,1
    174c:	00148493          	add	s1,s1,1
  if((prevp = freep) == 0){
    1750:	00001517          	auipc	a0,0x1
    1754:	8c053503          	ld	a0,-1856(a0) # 2010 <freep>
    1758:	02050e63          	beqz	a0,1794 <malloc+0x84>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    175c:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1760:	0087a703          	lw	a4,8(a5)
    1764:	04977663          	bgeu	a4,s1,17b0 <malloc+0xa0>
  if(nu < 4096)
    1768:	00098a13          	mv	s4,s3
    176c:	0009871b          	sext.w	a4,s3
    1770:	000016b7          	lui	a3,0x1
    1774:	00d77463          	bgeu	a4,a3,177c <malloc+0x6c>
    1778:	00001a37          	lui	s4,0x1
    177c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1780:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1784:	00001917          	auipc	s2,0x1
    1788:	88c90913          	add	s2,s2,-1908 # 2010 <freep>
  if(p == (char*)-1)
    178c:	fff00a93          	li	s5,-1
    1790:	0a00006f          	j	1830 <malloc+0x120>
    base.s.ptr = freep = prevp = &base;
    1794:	00001797          	auipc	a5,0x1
    1798:	c7478793          	add	a5,a5,-908 # 2408 <base>
    179c:	00001717          	auipc	a4,0x1
    17a0:	86f73a23          	sd	a5,-1932(a4) # 2010 <freep>
    17a4:	00f7b023          	sd	a5,0(a5)
    base.s.size = 0;
    17a8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    17ac:	fbdff06f          	j	1768 <malloc+0x58>
      if(p->s.size == nunits)
    17b0:	04e48863          	beq	s1,a4,1800 <malloc+0xf0>
        p->s.size -= nunits;
    17b4:	4137073b          	subw	a4,a4,s3
    17b8:	00e7a423          	sw	a4,8(a5)
        p += p->s.size;
    17bc:	02071693          	sll	a3,a4,0x20
    17c0:	01c6d713          	srl	a4,a3,0x1c
    17c4:	00e787b3          	add	a5,a5,a4
        p->s.size = nunits;
    17c8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    17cc:	00001717          	auipc	a4,0x1
    17d0:	84a73223          	sd	a0,-1980(a4) # 2010 <freep>
      return (void*)(p + 1);
    17d4:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    17d8:	03813083          	ld	ra,56(sp)
    17dc:	03013403          	ld	s0,48(sp)
    17e0:	02813483          	ld	s1,40(sp)
    17e4:	02013903          	ld	s2,32(sp)
    17e8:	01813983          	ld	s3,24(sp)
    17ec:	01013a03          	ld	s4,16(sp)
    17f0:	00813a83          	ld	s5,8(sp)
    17f4:	00013b03          	ld	s6,0(sp)
    17f8:	04010113          	add	sp,sp,64
    17fc:	00008067          	ret
        prevp->s.ptr = p->s.ptr;
    1800:	0007b703          	ld	a4,0(a5)
    1804:	00e53023          	sd	a4,0(a0)
    1808:	fc5ff06f          	j	17cc <malloc+0xbc>
  hp->s.size = nu;
    180c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    1810:	01050513          	add	a0,a0,16
    1814:	00000097          	auipc	ra,0x0
    1818:	e4c080e7          	jalr	-436(ra) # 1660 <free>
  return freep;
    181c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    1820:	fa050ce3          	beqz	a0,17d8 <malloc+0xc8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1824:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1828:	0087a703          	lw	a4,8(a5)
    182c:	f89772e3          	bgeu	a4,s1,17b0 <malloc+0xa0>
    if(p == freep)
    1830:	00093703          	ld	a4,0(s2)
    1834:	00078513          	mv	a0,a5
    1838:	fef716e3          	bne	a4,a5,1824 <malloc+0x114>
  p = sbrk(nu * sizeof(Header));
    183c:	000a0513          	mv	a0,s4
    1840:	00000097          	auipc	ra,0x0
    1844:	9bc080e7          	jalr	-1604(ra) # 11fc <sbrk>
  if(p == (char*)-1)
    1848:	fd5512e3          	bne	a0,s5,180c <malloc+0xfc>
        return 0;
    184c:	00000513          	li	a0,0
    1850:	f89ff06f          	j	17d8 <malloc+0xc8>
