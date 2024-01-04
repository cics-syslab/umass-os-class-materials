
user/_sh:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <getcmd>:
  exit(0);
}

int
getcmd(char *buf, int nbuf)
{
       0:	fe010113          	add	sp,sp,-32
       4:	00113c23          	sd	ra,24(sp)
       8:	00813823          	sd	s0,16(sp)
       c:	00913423          	sd	s1,8(sp)
      10:	01213023          	sd	s2,0(sp)
      14:	02010413          	add	s0,sp,32
      18:	00050493          	mv	s1,a0
      1c:	00058913          	mv	s2,a1
  write(2, "$ ", 2);
      20:	00200613          	li	a2,2
      24:	00002597          	auipc	a1,0x2
      28:	adc58593          	add	a1,a1,-1316 # 1b00 <malloc+0x150>
      2c:	00200513          	li	a0,2
      30:	00001097          	auipc	ra,0x1
      34:	3d0080e7          	jalr	976(ra) # 1400 <write>
  memset(buf, 0, nbuf);
      38:	00090613          	mv	a2,s2
      3c:	00000593          	li	a1,0
      40:	00048513          	mv	a0,s1
      44:	00001097          	auipc	ra,0x1
      48:	078080e7          	jalr	120(ra) # 10bc <memset>
  gets(buf, nbuf);
      4c:	00090593          	mv	a1,s2
      50:	00048513          	mv	a0,s1
      54:	00001097          	auipc	ra,0x1
      58:	0dc080e7          	jalr	220(ra) # 1130 <gets>
  if(buf[0] == 0) // EOF
      5c:	0004c503          	lbu	a0,0(s1)
      60:	00153513          	seqz	a0,a0
    return -1;
  return 0;
}
      64:	40a00533          	neg	a0,a0
      68:	01813083          	ld	ra,24(sp)
      6c:	01013403          	ld	s0,16(sp)
      70:	00813483          	ld	s1,8(sp)
      74:	00013903          	ld	s2,0(sp)
      78:	02010113          	add	sp,sp,32
      7c:	00008067          	ret

0000000000000080 <panic>:
  exit(0);
}

void
panic(char *s)
{
      80:	ff010113          	add	sp,sp,-16
      84:	00113423          	sd	ra,8(sp)
      88:	00813023          	sd	s0,0(sp)
      8c:	01010413          	add	s0,sp,16
      90:	00050613          	mv	a2,a0
  fprintf(2, "%s\n", s);
      94:	00002597          	auipc	a1,0x2
      98:	a7458593          	add	a1,a1,-1420 # 1b08 <malloc+0x158>
      9c:	00200513          	li	a0,2
      a0:	00001097          	auipc	ra,0x1
      a4:	7c4080e7          	jalr	1988(ra) # 1864 <fprintf>
  exit(1);
      a8:	00100513          	li	a0,1
      ac:	00001097          	auipc	ra,0x1
      b0:	324080e7          	jalr	804(ra) # 13d0 <exit>

00000000000000b4 <fork1>:
}

int
fork1(void)
{
      b4:	ff010113          	add	sp,sp,-16
      b8:	00113423          	sd	ra,8(sp)
      bc:	00813023          	sd	s0,0(sp)
      c0:	01010413          	add	s0,sp,16
  int pid;

  pid = fork();
      c4:	00001097          	auipc	ra,0x1
      c8:	300080e7          	jalr	768(ra) # 13c4 <fork>
  if(pid == -1)
      cc:	fff00793          	li	a5,-1
      d0:	00f50a63          	beq	a0,a5,e4 <fork1+0x30>
    panic("fork");
  return pid;
}
      d4:	00813083          	ld	ra,8(sp)
      d8:	00013403          	ld	s0,0(sp)
      dc:	01010113          	add	sp,sp,16
      e0:	00008067          	ret
    panic("fork");
      e4:	00002517          	auipc	a0,0x2
      e8:	a2c50513          	add	a0,a0,-1492 # 1b10 <malloc+0x160>
      ec:	00000097          	auipc	ra,0x0
      f0:	f94080e7          	jalr	-108(ra) # 80 <panic>

00000000000000f4 <runcmd>:
{
      f4:	fd010113          	add	sp,sp,-48
      f8:	02113423          	sd	ra,40(sp)
      fc:	02813023          	sd	s0,32(sp)
     100:	00913c23          	sd	s1,24(sp)
     104:	03010413          	add	s0,sp,48
  if(cmd == 0)
     108:	02050a63          	beqz	a0,13c <runcmd+0x48>
     10c:	00050493          	mv	s1,a0
  switch(cmd->type){
     110:	00052703          	lw	a4,0(a0)
     114:	00500793          	li	a5,5
     118:	02e7e863          	bltu	a5,a4,148 <runcmd+0x54>
     11c:	00056783          	lwu	a5,0(a0)
     120:	00279793          	sll	a5,a5,0x2
     124:	00002717          	auipc	a4,0x2
     128:	aec70713          	add	a4,a4,-1300 # 1c10 <malloc+0x260>
     12c:	00e787b3          	add	a5,a5,a4
     130:	0007a783          	lw	a5,0(a5)
     134:	00e787b3          	add	a5,a5,a4
     138:	00078067          	jr	a5
    exit(1);
     13c:	00100513          	li	a0,1
     140:	00001097          	auipc	ra,0x1
     144:	290080e7          	jalr	656(ra) # 13d0 <exit>
    panic("runcmd");
     148:	00002517          	auipc	a0,0x2
     14c:	9d050513          	add	a0,a0,-1584 # 1b18 <malloc+0x168>
     150:	00000097          	auipc	ra,0x0
     154:	f30080e7          	jalr	-208(ra) # 80 <panic>
    if(ecmd->argv[0] == 0)
     158:	00853503          	ld	a0,8(a0)
     15c:	02050a63          	beqz	a0,190 <runcmd+0x9c>
    exec(ecmd->argv[0], ecmd->argv);
     160:	00848593          	add	a1,s1,8
     164:	00001097          	auipc	ra,0x1
     168:	2c0080e7          	jalr	704(ra) # 1424 <exec>
    fprintf(2, "exec %s failed\n", ecmd->argv[0]);
     16c:	0084b603          	ld	a2,8(s1)
     170:	00002597          	auipc	a1,0x2
     174:	9b058593          	add	a1,a1,-1616 # 1b20 <malloc+0x170>
     178:	00200513          	li	a0,2
     17c:	00001097          	auipc	ra,0x1
     180:	6e8080e7          	jalr	1768(ra) # 1864 <fprintf>
  exit(0);
     184:	00000513          	li	a0,0
     188:	00001097          	auipc	ra,0x1
     18c:	248080e7          	jalr	584(ra) # 13d0 <exit>
      exit(1);
     190:	00100513          	li	a0,1
     194:	00001097          	auipc	ra,0x1
     198:	23c080e7          	jalr	572(ra) # 13d0 <exit>
    close(rcmd->fd);
     19c:	02452503          	lw	a0,36(a0)
     1a0:	00001097          	auipc	ra,0x1
     1a4:	26c080e7          	jalr	620(ra) # 140c <close>
    if(open(rcmd->file, rcmd->mode) < 0){
     1a8:	0204a583          	lw	a1,32(s1)
     1ac:	0104b503          	ld	a0,16(s1)
     1b0:	00001097          	auipc	ra,0x1
     1b4:	280080e7          	jalr	640(ra) # 1430 <open>
     1b8:	00054863          	bltz	a0,1c8 <runcmd+0xd4>
    runcmd(rcmd->cmd);
     1bc:	0084b503          	ld	a0,8(s1)
     1c0:	00000097          	auipc	ra,0x0
     1c4:	f34080e7          	jalr	-204(ra) # f4 <runcmd>
      fprintf(2, "open %s failed\n", rcmd->file);
     1c8:	0104b603          	ld	a2,16(s1)
     1cc:	00002597          	auipc	a1,0x2
     1d0:	96458593          	add	a1,a1,-1692 # 1b30 <malloc+0x180>
     1d4:	00200513          	li	a0,2
     1d8:	00001097          	auipc	ra,0x1
     1dc:	68c080e7          	jalr	1676(ra) # 1864 <fprintf>
      exit(1);
     1e0:	00100513          	li	a0,1
     1e4:	00001097          	auipc	ra,0x1
     1e8:	1ec080e7          	jalr	492(ra) # 13d0 <exit>
    if(fork1() == 0)
     1ec:	00000097          	auipc	ra,0x0
     1f0:	ec8080e7          	jalr	-312(ra) # b4 <fork1>
     1f4:	00051863          	bnez	a0,204 <runcmd+0x110>
      runcmd(lcmd->left);
     1f8:	0084b503          	ld	a0,8(s1)
     1fc:	00000097          	auipc	ra,0x0
     200:	ef8080e7          	jalr	-264(ra) # f4 <runcmd>
    wait(0);
     204:	00000513          	li	a0,0
     208:	00001097          	auipc	ra,0x1
     20c:	1d4080e7          	jalr	468(ra) # 13dc <wait>
    runcmd(lcmd->right);
     210:	0104b503          	ld	a0,16(s1)
     214:	00000097          	auipc	ra,0x0
     218:	ee0080e7          	jalr	-288(ra) # f4 <runcmd>
    if(pipe(p) < 0)
     21c:	fd840513          	add	a0,s0,-40
     220:	00001097          	auipc	ra,0x1
     224:	1c8080e7          	jalr	456(ra) # 13e8 <pipe>
     228:	04054663          	bltz	a0,274 <runcmd+0x180>
    if(fork1() == 0){
     22c:	00000097          	auipc	ra,0x0
     230:	e88080e7          	jalr	-376(ra) # b4 <fork1>
     234:	04051863          	bnez	a0,284 <runcmd+0x190>
      close(1);
     238:	00100513          	li	a0,1
     23c:	00001097          	auipc	ra,0x1
     240:	1d0080e7          	jalr	464(ra) # 140c <close>
      dup(p[1]);
     244:	fdc42503          	lw	a0,-36(s0)
     248:	00001097          	auipc	ra,0x1
     24c:	23c080e7          	jalr	572(ra) # 1484 <dup>
      close(p[0]);
     250:	fd842503          	lw	a0,-40(s0)
     254:	00001097          	auipc	ra,0x1
     258:	1b8080e7          	jalr	440(ra) # 140c <close>
      close(p[1]);
     25c:	fdc42503          	lw	a0,-36(s0)
     260:	00001097          	auipc	ra,0x1
     264:	1ac080e7          	jalr	428(ra) # 140c <close>
      runcmd(pcmd->left);
     268:	0084b503          	ld	a0,8(s1)
     26c:	00000097          	auipc	ra,0x0
     270:	e88080e7          	jalr	-376(ra) # f4 <runcmd>
      panic("pipe");
     274:	00002517          	auipc	a0,0x2
     278:	8cc50513          	add	a0,a0,-1844 # 1b40 <malloc+0x190>
     27c:	00000097          	auipc	ra,0x0
     280:	e04080e7          	jalr	-508(ra) # 80 <panic>
    if(fork1() == 0){
     284:	00000097          	auipc	ra,0x0
     288:	e30080e7          	jalr	-464(ra) # b4 <fork1>
     28c:	02051e63          	bnez	a0,2c8 <runcmd+0x1d4>
      close(0);
     290:	00001097          	auipc	ra,0x1
     294:	17c080e7          	jalr	380(ra) # 140c <close>
      dup(p[0]);
     298:	fd842503          	lw	a0,-40(s0)
     29c:	00001097          	auipc	ra,0x1
     2a0:	1e8080e7          	jalr	488(ra) # 1484 <dup>
      close(p[0]);
     2a4:	fd842503          	lw	a0,-40(s0)
     2a8:	00001097          	auipc	ra,0x1
     2ac:	164080e7          	jalr	356(ra) # 140c <close>
      close(p[1]);
     2b0:	fdc42503          	lw	a0,-36(s0)
     2b4:	00001097          	auipc	ra,0x1
     2b8:	158080e7          	jalr	344(ra) # 140c <close>
      runcmd(pcmd->right);
     2bc:	0104b503          	ld	a0,16(s1)
     2c0:	00000097          	auipc	ra,0x0
     2c4:	e34080e7          	jalr	-460(ra) # f4 <runcmd>
    close(p[0]);
     2c8:	fd842503          	lw	a0,-40(s0)
     2cc:	00001097          	auipc	ra,0x1
     2d0:	140080e7          	jalr	320(ra) # 140c <close>
    close(p[1]);
     2d4:	fdc42503          	lw	a0,-36(s0)
     2d8:	00001097          	auipc	ra,0x1
     2dc:	134080e7          	jalr	308(ra) # 140c <close>
    wait(0);
     2e0:	00000513          	li	a0,0
     2e4:	00001097          	auipc	ra,0x1
     2e8:	0f8080e7          	jalr	248(ra) # 13dc <wait>
    wait(0);
     2ec:	00000513          	li	a0,0
     2f0:	00001097          	auipc	ra,0x1
     2f4:	0ec080e7          	jalr	236(ra) # 13dc <wait>
    break;
     2f8:	e8dff06f          	j	184 <runcmd+0x90>
    if(fork1() == 0)
     2fc:	00000097          	auipc	ra,0x0
     300:	db8080e7          	jalr	-584(ra) # b4 <fork1>
     304:	e80510e3          	bnez	a0,184 <runcmd+0x90>
      runcmd(bcmd->cmd);
     308:	0084b503          	ld	a0,8(s1)
     30c:	00000097          	auipc	ra,0x0
     310:	de8080e7          	jalr	-536(ra) # f4 <runcmd>

0000000000000314 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     314:	fe010113          	add	sp,sp,-32
     318:	00113c23          	sd	ra,24(sp)
     31c:	00813823          	sd	s0,16(sp)
     320:	00913423          	sd	s1,8(sp)
     324:	02010413          	add	s0,sp,32
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     328:	0a800513          	li	a0,168
     32c:	00001097          	auipc	ra,0x1
     330:	684080e7          	jalr	1668(ra) # 19b0 <malloc>
     334:	00050493          	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     338:	0a800613          	li	a2,168
     33c:	00000593          	li	a1,0
     340:	00001097          	auipc	ra,0x1
     344:	d7c080e7          	jalr	-644(ra) # 10bc <memset>
  cmd->type = EXEC;
     348:	00100793          	li	a5,1
     34c:	00f4a023          	sw	a5,0(s1)
  return (struct cmd*)cmd;
}
     350:	00048513          	mv	a0,s1
     354:	01813083          	ld	ra,24(sp)
     358:	01013403          	ld	s0,16(sp)
     35c:	00813483          	ld	s1,8(sp)
     360:	02010113          	add	sp,sp,32
     364:	00008067          	ret

0000000000000368 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     368:	fc010113          	add	sp,sp,-64
     36c:	02113c23          	sd	ra,56(sp)
     370:	02813823          	sd	s0,48(sp)
     374:	02913423          	sd	s1,40(sp)
     378:	03213023          	sd	s2,32(sp)
     37c:	01313c23          	sd	s3,24(sp)
     380:	01413823          	sd	s4,16(sp)
     384:	01513423          	sd	s5,8(sp)
     388:	01613023          	sd	s6,0(sp)
     38c:	04010413          	add	s0,sp,64
     390:	00050b13          	mv	s6,a0
     394:	00058a93          	mv	s5,a1
     398:	00060a13          	mv	s4,a2
     39c:	00068993          	mv	s3,a3
     3a0:	00070913          	mv	s2,a4
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3a4:	02800513          	li	a0,40
     3a8:	00001097          	auipc	ra,0x1
     3ac:	608080e7          	jalr	1544(ra) # 19b0 <malloc>
     3b0:	00050493          	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     3b4:	02800613          	li	a2,40
     3b8:	00000593          	li	a1,0
     3bc:	00001097          	auipc	ra,0x1
     3c0:	d00080e7          	jalr	-768(ra) # 10bc <memset>
  cmd->type = REDIR;
     3c4:	00200793          	li	a5,2
     3c8:	00f4a023          	sw	a5,0(s1)
  cmd->cmd = subcmd;
     3cc:	0164b423          	sd	s6,8(s1)
  cmd->file = file;
     3d0:	0154b823          	sd	s5,16(s1)
  cmd->efile = efile;
     3d4:	0144bc23          	sd	s4,24(s1)
  cmd->mode = mode;
     3d8:	0334a023          	sw	s3,32(s1)
  cmd->fd = fd;
     3dc:	0324a223          	sw	s2,36(s1)
  return (struct cmd*)cmd;
}
     3e0:	00048513          	mv	a0,s1
     3e4:	03813083          	ld	ra,56(sp)
     3e8:	03013403          	ld	s0,48(sp)
     3ec:	02813483          	ld	s1,40(sp)
     3f0:	02013903          	ld	s2,32(sp)
     3f4:	01813983          	ld	s3,24(sp)
     3f8:	01013a03          	ld	s4,16(sp)
     3fc:	00813a83          	ld	s5,8(sp)
     400:	00013b03          	ld	s6,0(sp)
     404:	04010113          	add	sp,sp,64
     408:	00008067          	ret

000000000000040c <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     40c:	fd010113          	add	sp,sp,-48
     410:	02113423          	sd	ra,40(sp)
     414:	02813023          	sd	s0,32(sp)
     418:	00913c23          	sd	s1,24(sp)
     41c:	01213823          	sd	s2,16(sp)
     420:	01313423          	sd	s3,8(sp)
     424:	03010413          	add	s0,sp,48
     428:	00050993          	mv	s3,a0
     42c:	00058913          	mv	s2,a1
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     430:	01800513          	li	a0,24
     434:	00001097          	auipc	ra,0x1
     438:	57c080e7          	jalr	1404(ra) # 19b0 <malloc>
     43c:	00050493          	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     440:	01800613          	li	a2,24
     444:	00000593          	li	a1,0
     448:	00001097          	auipc	ra,0x1
     44c:	c74080e7          	jalr	-908(ra) # 10bc <memset>
  cmd->type = PIPE;
     450:	00300793          	li	a5,3
     454:	00f4a023          	sw	a5,0(s1)
  cmd->left = left;
     458:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     45c:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     460:	00048513          	mv	a0,s1
     464:	02813083          	ld	ra,40(sp)
     468:	02013403          	ld	s0,32(sp)
     46c:	01813483          	ld	s1,24(sp)
     470:	01013903          	ld	s2,16(sp)
     474:	00813983          	ld	s3,8(sp)
     478:	03010113          	add	sp,sp,48
     47c:	00008067          	ret

0000000000000480 <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     480:	fd010113          	add	sp,sp,-48
     484:	02113423          	sd	ra,40(sp)
     488:	02813023          	sd	s0,32(sp)
     48c:	00913c23          	sd	s1,24(sp)
     490:	01213823          	sd	s2,16(sp)
     494:	01313423          	sd	s3,8(sp)
     498:	03010413          	add	s0,sp,48
     49c:	00050993          	mv	s3,a0
     4a0:	00058913          	mv	s2,a1
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     4a4:	01800513          	li	a0,24
     4a8:	00001097          	auipc	ra,0x1
     4ac:	508080e7          	jalr	1288(ra) # 19b0 <malloc>
     4b0:	00050493          	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     4b4:	01800613          	li	a2,24
     4b8:	00000593          	li	a1,0
     4bc:	00001097          	auipc	ra,0x1
     4c0:	c00080e7          	jalr	-1024(ra) # 10bc <memset>
  cmd->type = LIST;
     4c4:	00400793          	li	a5,4
     4c8:	00f4a023          	sw	a5,0(s1)
  cmd->left = left;
     4cc:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     4d0:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     4d4:	00048513          	mv	a0,s1
     4d8:	02813083          	ld	ra,40(sp)
     4dc:	02013403          	ld	s0,32(sp)
     4e0:	01813483          	ld	s1,24(sp)
     4e4:	01013903          	ld	s2,16(sp)
     4e8:	00813983          	ld	s3,8(sp)
     4ec:	03010113          	add	sp,sp,48
     4f0:	00008067          	ret

00000000000004f4 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     4f4:	fe010113          	add	sp,sp,-32
     4f8:	00113c23          	sd	ra,24(sp)
     4fc:	00813823          	sd	s0,16(sp)
     500:	00913423          	sd	s1,8(sp)
     504:	01213023          	sd	s2,0(sp)
     508:	02010413          	add	s0,sp,32
     50c:	00050913          	mv	s2,a0
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     510:	01000513          	li	a0,16
     514:	00001097          	auipc	ra,0x1
     518:	49c080e7          	jalr	1180(ra) # 19b0 <malloc>
     51c:	00050493          	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     520:	01000613          	li	a2,16
     524:	00000593          	li	a1,0
     528:	00001097          	auipc	ra,0x1
     52c:	b94080e7          	jalr	-1132(ra) # 10bc <memset>
  cmd->type = BACK;
     530:	00500793          	li	a5,5
     534:	00f4a023          	sw	a5,0(s1)
  cmd->cmd = subcmd;
     538:	0124b423          	sd	s2,8(s1)
  return (struct cmd*)cmd;
}
     53c:	00048513          	mv	a0,s1
     540:	01813083          	ld	ra,24(sp)
     544:	01013403          	ld	s0,16(sp)
     548:	00813483          	ld	s1,8(sp)
     54c:	00013903          	ld	s2,0(sp)
     550:	02010113          	add	sp,sp,32
     554:	00008067          	ret

0000000000000558 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     558:	fc010113          	add	sp,sp,-64
     55c:	02113c23          	sd	ra,56(sp)
     560:	02813823          	sd	s0,48(sp)
     564:	02913423          	sd	s1,40(sp)
     568:	03213023          	sd	s2,32(sp)
     56c:	01313c23          	sd	s3,24(sp)
     570:	01413823          	sd	s4,16(sp)
     574:	01513423          	sd	s5,8(sp)
     578:	01613023          	sd	s6,0(sp)
     57c:	04010413          	add	s0,sp,64
     580:	00050a13          	mv	s4,a0
     584:	00058913          	mv	s2,a1
     588:	00060a93          	mv	s5,a2
     58c:	00068b13          	mv	s6,a3
  char *s;
  int ret;

  s = *ps;
     590:	00053483          	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     594:	00002997          	auipc	s3,0x2
     598:	a7498993          	add	s3,s3,-1420 # 2008 <whitespace>
     59c:	02b4f263          	bgeu	s1,a1,5c0 <gettoken+0x68>
     5a0:	0004c583          	lbu	a1,0(s1)
     5a4:	00098513          	mv	a0,s3
     5a8:	00001097          	auipc	ra,0x1
     5ac:	b4c080e7          	jalr	-1204(ra) # 10f4 <strchr>
     5b0:	00050863          	beqz	a0,5c0 <gettoken+0x68>
    s++;
     5b4:	00148493          	add	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     5b8:	fe9914e3          	bne	s2,s1,5a0 <gettoken+0x48>
    s++;
     5bc:	00090493          	mv	s1,s2
  if(q)
     5c0:	000a8463          	beqz	s5,5c8 <gettoken+0x70>
    *q = s;
     5c4:	009ab023          	sd	s1,0(s5)
  ret = *s;
     5c8:	0004c783          	lbu	a5,0(s1)
     5cc:	00078a9b          	sext.w	s5,a5
  switch(*s){
     5d0:	03c00713          	li	a4,60
     5d4:	08f76863          	bltu	a4,a5,664 <gettoken+0x10c>
     5d8:	03a00713          	li	a4,58
     5dc:	02f76063          	bltu	a4,a5,5fc <gettoken+0xa4>
     5e0:	02078063          	beqz	a5,600 <gettoken+0xa8>
     5e4:	02600713          	li	a4,38
     5e8:	00e78a63          	beq	a5,a4,5fc <gettoken+0xa4>
     5ec:	fd87879b          	addw	a5,a5,-40
     5f0:	0ff7f793          	zext.b	a5,a5
     5f4:	00100713          	li	a4,1
     5f8:	0af76063          	bltu	a4,a5,698 <gettoken+0x140>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     5fc:	00148493          	add	s1,s1,1
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     600:	000b0463          	beqz	s6,608 <gettoken+0xb0>
    *eq = s;
     604:	009b3023          	sd	s1,0(s6)

  while(s < es && strchr(whitespace, *s))
     608:	00002997          	auipc	s3,0x2
     60c:	a0098993          	add	s3,s3,-1536 # 2008 <whitespace>
     610:	0324f263          	bgeu	s1,s2,634 <gettoken+0xdc>
     614:	0004c583          	lbu	a1,0(s1)
     618:	00098513          	mv	a0,s3
     61c:	00001097          	auipc	ra,0x1
     620:	ad8080e7          	jalr	-1320(ra) # 10f4 <strchr>
     624:	00050863          	beqz	a0,634 <gettoken+0xdc>
    s++;
     628:	00148493          	add	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     62c:	fe9914e3          	bne	s2,s1,614 <gettoken+0xbc>
    s++;
     630:	00090493          	mv	s1,s2
  *ps = s;
     634:	009a3023          	sd	s1,0(s4)
  return ret;
}
     638:	000a8513          	mv	a0,s5
     63c:	03813083          	ld	ra,56(sp)
     640:	03013403          	ld	s0,48(sp)
     644:	02813483          	ld	s1,40(sp)
     648:	02013903          	ld	s2,32(sp)
     64c:	01813983          	ld	s3,24(sp)
     650:	01013a03          	ld	s4,16(sp)
     654:	00813a83          	ld	s5,8(sp)
     658:	00013b03          	ld	s6,0(sp)
     65c:	04010113          	add	sp,sp,64
     660:	00008067          	ret
  switch(*s){
     664:	03e00713          	li	a4,62
     668:	02e79463          	bne	a5,a4,690 <gettoken+0x138>
    s++;
     66c:	00148693          	add	a3,s1,1
    if(*s == '>'){
     670:	0014c703          	lbu	a4,1(s1)
     674:	03e00793          	li	a5,62
      s++;
     678:	00248493          	add	s1,s1,2
      ret = '+';
     67c:	02b00a93          	li	s5,43
    if(*s == '>'){
     680:	f8f700e3          	beq	a4,a5,600 <gettoken+0xa8>
    s++;
     684:	00068493          	mv	s1,a3
  ret = *s;
     688:	03e00a93          	li	s5,62
     68c:	f75ff06f          	j	600 <gettoken+0xa8>
  switch(*s){
     690:	07c00713          	li	a4,124
     694:	f6e784e3          	beq	a5,a4,5fc <gettoken+0xa4>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     698:	00002997          	auipc	s3,0x2
     69c:	97098993          	add	s3,s3,-1680 # 2008 <whitespace>
     6a0:	00002a97          	auipc	s5,0x2
     6a4:	960a8a93          	add	s5,s5,-1696 # 2000 <symbols>
     6a8:	0524fa63          	bgeu	s1,s2,6fc <gettoken+0x1a4>
     6ac:	0004c583          	lbu	a1,0(s1)
     6b0:	00098513          	mv	a0,s3
     6b4:	00001097          	auipc	ra,0x1
     6b8:	a40080e7          	jalr	-1472(ra) # 10f4 <strchr>
     6bc:	02051c63          	bnez	a0,6f4 <gettoken+0x19c>
     6c0:	0004c583          	lbu	a1,0(s1)
     6c4:	000a8513          	mv	a0,s5
     6c8:	00001097          	auipc	ra,0x1
     6cc:	a2c080e7          	jalr	-1492(ra) # 10f4 <strchr>
     6d0:	00051e63          	bnez	a0,6ec <gettoken+0x194>
      s++;
     6d4:	00148493          	add	s1,s1,1
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     6d8:	fc991ae3          	bne	s2,s1,6ac <gettoken+0x154>
      s++;
     6dc:	00090493          	mv	s1,s2
    ret = 'a';
     6e0:	06100a93          	li	s5,97
  if(eq)
     6e4:	f20b10e3          	bnez	s6,604 <gettoken+0xac>
     6e8:	f4dff06f          	j	634 <gettoken+0xdc>
    ret = 'a';
     6ec:	06100a93          	li	s5,97
     6f0:	f11ff06f          	j	600 <gettoken+0xa8>
     6f4:	06100a93          	li	s5,97
     6f8:	f09ff06f          	j	600 <gettoken+0xa8>
     6fc:	06100a93          	li	s5,97
  if(eq)
     700:	f00b12e3          	bnez	s6,604 <gettoken+0xac>
     704:	f31ff06f          	j	634 <gettoken+0xdc>

0000000000000708 <peek>:

int
peek(char **ps, char *es, char *toks)
{
     708:	fc010113          	add	sp,sp,-64
     70c:	02113c23          	sd	ra,56(sp)
     710:	02813823          	sd	s0,48(sp)
     714:	02913423          	sd	s1,40(sp)
     718:	03213023          	sd	s2,32(sp)
     71c:	01313c23          	sd	s3,24(sp)
     720:	01413823          	sd	s4,16(sp)
     724:	01513423          	sd	s5,8(sp)
     728:	04010413          	add	s0,sp,64
     72c:	00050a13          	mv	s4,a0
     730:	00058913          	mv	s2,a1
     734:	00060a93          	mv	s5,a2
  char *s;

  s = *ps;
     738:	00053483          	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     73c:	00002997          	auipc	s3,0x2
     740:	8cc98993          	add	s3,s3,-1844 # 2008 <whitespace>
     744:	02b4f263          	bgeu	s1,a1,768 <peek+0x60>
     748:	0004c583          	lbu	a1,0(s1)
     74c:	00098513          	mv	a0,s3
     750:	00001097          	auipc	ra,0x1
     754:	9a4080e7          	jalr	-1628(ra) # 10f4 <strchr>
     758:	00050863          	beqz	a0,768 <peek+0x60>
    s++;
     75c:	00148493          	add	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     760:	fe9914e3          	bne	s2,s1,748 <peek+0x40>
    s++;
     764:	00090493          	mv	s1,s2
  *ps = s;
     768:	009a3023          	sd	s1,0(s4)
  return *s && strchr(toks, *s);
     76c:	0004c583          	lbu	a1,0(s1)
     770:	00000513          	li	a0,0
     774:	02059463          	bnez	a1,79c <peek+0x94>
}
     778:	03813083          	ld	ra,56(sp)
     77c:	03013403          	ld	s0,48(sp)
     780:	02813483          	ld	s1,40(sp)
     784:	02013903          	ld	s2,32(sp)
     788:	01813983          	ld	s3,24(sp)
     78c:	01013a03          	ld	s4,16(sp)
     790:	00813a83          	ld	s5,8(sp)
     794:	04010113          	add	sp,sp,64
     798:	00008067          	ret
  return *s && strchr(toks, *s);
     79c:	000a8513          	mv	a0,s5
     7a0:	00001097          	auipc	ra,0x1
     7a4:	954080e7          	jalr	-1708(ra) # 10f4 <strchr>
     7a8:	00a03533          	snez	a0,a0
     7ac:	fcdff06f          	j	778 <peek+0x70>

00000000000007b0 <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     7b0:	f9010113          	add	sp,sp,-112
     7b4:	06113423          	sd	ra,104(sp)
     7b8:	06813023          	sd	s0,96(sp)
     7bc:	04913c23          	sd	s1,88(sp)
     7c0:	05213823          	sd	s2,80(sp)
     7c4:	05313423          	sd	s3,72(sp)
     7c8:	05413023          	sd	s4,64(sp)
     7cc:	03513c23          	sd	s5,56(sp)
     7d0:	03613823          	sd	s6,48(sp)
     7d4:	03713423          	sd	s7,40(sp)
     7d8:	03813023          	sd	s8,32(sp)
     7dc:	01913c23          	sd	s9,24(sp)
     7e0:	07010413          	add	s0,sp,112
     7e4:	00050a13          	mv	s4,a0
     7e8:	00058993          	mv	s3,a1
     7ec:	00060913          	mv	s2,a2
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     7f0:	00001b97          	auipc	s7,0x1
     7f4:	378b8b93          	add	s7,s7,888 # 1b68 <malloc+0x1b8>
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
     7f8:	06100c13          	li	s8,97
      panic("missing file for redirection");
    switch(tok){
     7fc:	03c00c93          	li	s9,60
  while(peek(ps, es, "<>")){
     800:	0340006f          	j	834 <parseredirs+0x84>
      panic("missing file for redirection");
     804:	00001517          	auipc	a0,0x1
     808:	34450513          	add	a0,a0,836 # 1b48 <malloc+0x198>
     80c:	00000097          	auipc	ra,0x0
     810:	874080e7          	jalr	-1932(ra) # 80 <panic>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     814:	00000713          	li	a4,0
     818:	00000693          	li	a3,0
     81c:	f9043603          	ld	a2,-112(s0)
     820:	f9843583          	ld	a1,-104(s0)
     824:	000a0513          	mv	a0,s4
     828:	00000097          	auipc	ra,0x0
     82c:	b40080e7          	jalr	-1216(ra) # 368 <redircmd>
     830:	00050a13          	mv	s4,a0
    switch(tok){
     834:	03e00b13          	li	s6,62
     838:	02b00a93          	li	s5,43
  while(peek(ps, es, "<>")){
     83c:	000b8613          	mv	a2,s7
     840:	00090593          	mv	a1,s2
     844:	00098513          	mv	a0,s3
     848:	00000097          	auipc	ra,0x0
     84c:	ec0080e7          	jalr	-320(ra) # 708 <peek>
     850:	08050863          	beqz	a0,8e0 <parseredirs+0x130>
    tok = gettoken(ps, es, 0, 0);
     854:	00000693          	li	a3,0
     858:	00000613          	li	a2,0
     85c:	00090593          	mv	a1,s2
     860:	00098513          	mv	a0,s3
     864:	00000097          	auipc	ra,0x0
     868:	cf4080e7          	jalr	-780(ra) # 558 <gettoken>
     86c:	00050493          	mv	s1,a0
    if(gettoken(ps, es, &q, &eq) != 'a')
     870:	f9040693          	add	a3,s0,-112
     874:	f9840613          	add	a2,s0,-104
     878:	00090593          	mv	a1,s2
     87c:	00098513          	mv	a0,s3
     880:	00000097          	auipc	ra,0x0
     884:	cd8080e7          	jalr	-808(ra) # 558 <gettoken>
     888:	f7851ee3          	bne	a0,s8,804 <parseredirs+0x54>
    switch(tok){
     88c:	f99484e3          	beq	s1,s9,814 <parseredirs+0x64>
     890:	03648663          	beq	s1,s6,8bc <parseredirs+0x10c>
     894:	fb5494e3          	bne	s1,s5,83c <parseredirs+0x8c>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     898:	00100713          	li	a4,1
     89c:	20100693          	li	a3,513
     8a0:	f9043603          	ld	a2,-112(s0)
     8a4:	f9843583          	ld	a1,-104(s0)
     8a8:	000a0513          	mv	a0,s4
     8ac:	00000097          	auipc	ra,0x0
     8b0:	abc080e7          	jalr	-1348(ra) # 368 <redircmd>
     8b4:	00050a13          	mv	s4,a0
      break;
     8b8:	f7dff06f          	j	834 <parseredirs+0x84>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
     8bc:	00100713          	li	a4,1
     8c0:	60100693          	li	a3,1537
     8c4:	f9043603          	ld	a2,-112(s0)
     8c8:	f9843583          	ld	a1,-104(s0)
     8cc:	000a0513          	mv	a0,s4
     8d0:	00000097          	auipc	ra,0x0
     8d4:	a98080e7          	jalr	-1384(ra) # 368 <redircmd>
     8d8:	00050a13          	mv	s4,a0
      break;
     8dc:	f59ff06f          	j	834 <parseredirs+0x84>
    }
  }
  return cmd;
}
     8e0:	000a0513          	mv	a0,s4
     8e4:	06813083          	ld	ra,104(sp)
     8e8:	06013403          	ld	s0,96(sp)
     8ec:	05813483          	ld	s1,88(sp)
     8f0:	05013903          	ld	s2,80(sp)
     8f4:	04813983          	ld	s3,72(sp)
     8f8:	04013a03          	ld	s4,64(sp)
     8fc:	03813a83          	ld	s5,56(sp)
     900:	03013b03          	ld	s6,48(sp)
     904:	02813b83          	ld	s7,40(sp)
     908:	02013c03          	ld	s8,32(sp)
     90c:	01813c83          	ld	s9,24(sp)
     910:	07010113          	add	sp,sp,112
     914:	00008067          	ret

0000000000000918 <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     918:	f9010113          	add	sp,sp,-112
     91c:	06113423          	sd	ra,104(sp)
     920:	06813023          	sd	s0,96(sp)
     924:	04913c23          	sd	s1,88(sp)
     928:	05213823          	sd	s2,80(sp)
     92c:	05313423          	sd	s3,72(sp)
     930:	05413023          	sd	s4,64(sp)
     934:	03513c23          	sd	s5,56(sp)
     938:	03613823          	sd	s6,48(sp)
     93c:	03713423          	sd	s7,40(sp)
     940:	03813023          	sd	s8,32(sp)
     944:	01913c23          	sd	s9,24(sp)
     948:	07010413          	add	s0,sp,112
     94c:	00050a13          	mv	s4,a0
     950:	00058a93          	mv	s5,a1
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     954:	00001617          	auipc	a2,0x1
     958:	21c60613          	add	a2,a2,540 # 1b70 <malloc+0x1c0>
     95c:	00000097          	auipc	ra,0x0
     960:	dac080e7          	jalr	-596(ra) # 708 <peek>
     964:	04051063          	bnez	a0,9a4 <parseexec+0x8c>
     968:	00050993          	mv	s3,a0
    return parseblock(ps, es);

  ret = execcmd();
     96c:	00000097          	auipc	ra,0x0
     970:	9a8080e7          	jalr	-1624(ra) # 314 <execcmd>
     974:	00050c13          	mv	s8,a0
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     978:	000a8613          	mv	a2,s5
     97c:	000a0593          	mv	a1,s4
     980:	00000097          	auipc	ra,0x0
     984:	e30080e7          	jalr	-464(ra) # 7b0 <parseredirs>
     988:	00050493          	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     98c:	008c0913          	add	s2,s8,8
     990:	00001b17          	auipc	s6,0x1
     994:	200b0b13          	add	s6,s6,512 # 1b90 <malloc+0x1e0>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
    if(tok != 'a')
     998:	06100c93          	li	s9,97
      panic("syntax");
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
     99c:	00a00b93          	li	s7,10
  while(!peek(ps, es, "|)&;")){
     9a0:	0780006f          	j	a18 <parseexec+0x100>
    return parseblock(ps, es);
     9a4:	000a8593          	mv	a1,s5
     9a8:	000a0513          	mv	a0,s4
     9ac:	00000097          	auipc	ra,0x0
     9b0:	290080e7          	jalr	656(ra) # c3c <parseblock>
     9b4:	00050493          	mv	s1,a0
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     9b8:	00048513          	mv	a0,s1
     9bc:	06813083          	ld	ra,104(sp)
     9c0:	06013403          	ld	s0,96(sp)
     9c4:	05813483          	ld	s1,88(sp)
     9c8:	05013903          	ld	s2,80(sp)
     9cc:	04813983          	ld	s3,72(sp)
     9d0:	04013a03          	ld	s4,64(sp)
     9d4:	03813a83          	ld	s5,56(sp)
     9d8:	03013b03          	ld	s6,48(sp)
     9dc:	02813b83          	ld	s7,40(sp)
     9e0:	02013c03          	ld	s8,32(sp)
     9e4:	01813c83          	ld	s9,24(sp)
     9e8:	07010113          	add	sp,sp,112
     9ec:	00008067          	ret
      panic("syntax");
     9f0:	00001517          	auipc	a0,0x1
     9f4:	18850513          	add	a0,a0,392 # 1b78 <malloc+0x1c8>
     9f8:	fffff097          	auipc	ra,0xfffff
     9fc:	688080e7          	jalr	1672(ra) # 80 <panic>
    ret = parseredirs(ret, ps, es);
     a00:	000a8613          	mv	a2,s5
     a04:	000a0593          	mv	a1,s4
     a08:	00048513          	mv	a0,s1
     a0c:	00000097          	auipc	ra,0x0
     a10:	da4080e7          	jalr	-604(ra) # 7b0 <parseredirs>
     a14:	00050493          	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     a18:	000b0613          	mv	a2,s6
     a1c:	000a8593          	mv	a1,s5
     a20:	000a0513          	mv	a0,s4
     a24:	00000097          	auipc	ra,0x0
     a28:	ce4080e7          	jalr	-796(ra) # 708 <peek>
     a2c:	04051863          	bnez	a0,a7c <parseexec+0x164>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     a30:	f9040693          	add	a3,s0,-112
     a34:	f9840613          	add	a2,s0,-104
     a38:	000a8593          	mv	a1,s5
     a3c:	000a0513          	mv	a0,s4
     a40:	00000097          	auipc	ra,0x0
     a44:	b18080e7          	jalr	-1256(ra) # 558 <gettoken>
     a48:	02050a63          	beqz	a0,a7c <parseexec+0x164>
    if(tok != 'a')
     a4c:	fb9512e3          	bne	a0,s9,9f0 <parseexec+0xd8>
    cmd->argv[argc] = q;
     a50:	f9843783          	ld	a5,-104(s0)
     a54:	00f93023          	sd	a5,0(s2)
    cmd->eargv[argc] = eq;
     a58:	f9043783          	ld	a5,-112(s0)
     a5c:	04f93823          	sd	a5,80(s2)
    argc++;
     a60:	0019899b          	addw	s3,s3,1
    if(argc >= MAXARGS)
     a64:	00890913          	add	s2,s2,8
     a68:	f9799ce3          	bne	s3,s7,a00 <parseexec+0xe8>
      panic("too many args");
     a6c:	00001517          	auipc	a0,0x1
     a70:	11450513          	add	a0,a0,276 # 1b80 <malloc+0x1d0>
     a74:	fffff097          	auipc	ra,0xfffff
     a78:	60c080e7          	jalr	1548(ra) # 80 <panic>
  cmd->argv[argc] = 0;
     a7c:	00399993          	sll	s3,s3,0x3
     a80:	013c0c33          	add	s8,s8,s3
     a84:	000c3423          	sd	zero,8(s8)
  cmd->eargv[argc] = 0;
     a88:	040c3c23          	sd	zero,88(s8)
  return ret;
     a8c:	f2dff06f          	j	9b8 <parseexec+0xa0>

0000000000000a90 <parsepipe>:
{
     a90:	fd010113          	add	sp,sp,-48
     a94:	02113423          	sd	ra,40(sp)
     a98:	02813023          	sd	s0,32(sp)
     a9c:	00913c23          	sd	s1,24(sp)
     aa0:	01213823          	sd	s2,16(sp)
     aa4:	01313423          	sd	s3,8(sp)
     aa8:	03010413          	add	s0,sp,48
     aac:	00050913          	mv	s2,a0
     ab0:	00058993          	mv	s3,a1
  cmd = parseexec(ps, es);
     ab4:	00000097          	auipc	ra,0x0
     ab8:	e64080e7          	jalr	-412(ra) # 918 <parseexec>
     abc:	00050493          	mv	s1,a0
  if(peek(ps, es, "|")){
     ac0:	00001617          	auipc	a2,0x1
     ac4:	0d860613          	add	a2,a2,216 # 1b98 <malloc+0x1e8>
     ac8:	00098593          	mv	a1,s3
     acc:	00090513          	mv	a0,s2
     ad0:	00000097          	auipc	ra,0x0
     ad4:	c38080e7          	jalr	-968(ra) # 708 <peek>
     ad8:	02051263          	bnez	a0,afc <parsepipe+0x6c>
}
     adc:	00048513          	mv	a0,s1
     ae0:	02813083          	ld	ra,40(sp)
     ae4:	02013403          	ld	s0,32(sp)
     ae8:	01813483          	ld	s1,24(sp)
     aec:	01013903          	ld	s2,16(sp)
     af0:	00813983          	ld	s3,8(sp)
     af4:	03010113          	add	sp,sp,48
     af8:	00008067          	ret
    gettoken(ps, es, 0, 0);
     afc:	00000693          	li	a3,0
     b00:	00000613          	li	a2,0
     b04:	00098593          	mv	a1,s3
     b08:	00090513          	mv	a0,s2
     b0c:	00000097          	auipc	ra,0x0
     b10:	a4c080e7          	jalr	-1460(ra) # 558 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     b14:	00098593          	mv	a1,s3
     b18:	00090513          	mv	a0,s2
     b1c:	00000097          	auipc	ra,0x0
     b20:	f74080e7          	jalr	-140(ra) # a90 <parsepipe>
     b24:	00050593          	mv	a1,a0
     b28:	00048513          	mv	a0,s1
     b2c:	00000097          	auipc	ra,0x0
     b30:	8e0080e7          	jalr	-1824(ra) # 40c <pipecmd>
     b34:	00050493          	mv	s1,a0
  return cmd;
     b38:	fa5ff06f          	j	adc <parsepipe+0x4c>

0000000000000b3c <parseline>:
{
     b3c:	fd010113          	add	sp,sp,-48
     b40:	02113423          	sd	ra,40(sp)
     b44:	02813023          	sd	s0,32(sp)
     b48:	00913c23          	sd	s1,24(sp)
     b4c:	01213823          	sd	s2,16(sp)
     b50:	01313423          	sd	s3,8(sp)
     b54:	01413023          	sd	s4,0(sp)
     b58:	03010413          	add	s0,sp,48
     b5c:	00050913          	mv	s2,a0
     b60:	00058993          	mv	s3,a1
  cmd = parsepipe(ps, es);
     b64:	00000097          	auipc	ra,0x0
     b68:	f2c080e7          	jalr	-212(ra) # a90 <parsepipe>
     b6c:	00050493          	mv	s1,a0
  while(peek(ps, es, "&")){
     b70:	00001a17          	auipc	s4,0x1
     b74:	030a0a13          	add	s4,s4,48 # 1ba0 <malloc+0x1f0>
     b78:	02c0006f          	j	ba4 <parseline+0x68>
    gettoken(ps, es, 0, 0);
     b7c:	00000693          	li	a3,0
     b80:	00000613          	li	a2,0
     b84:	00098593          	mv	a1,s3
     b88:	00090513          	mv	a0,s2
     b8c:	00000097          	auipc	ra,0x0
     b90:	9cc080e7          	jalr	-1588(ra) # 558 <gettoken>
    cmd = backcmd(cmd);
     b94:	00048513          	mv	a0,s1
     b98:	00000097          	auipc	ra,0x0
     b9c:	95c080e7          	jalr	-1700(ra) # 4f4 <backcmd>
     ba0:	00050493          	mv	s1,a0
  while(peek(ps, es, "&")){
     ba4:	000a0613          	mv	a2,s4
     ba8:	00098593          	mv	a1,s3
     bac:	00090513          	mv	a0,s2
     bb0:	00000097          	auipc	ra,0x0
     bb4:	b58080e7          	jalr	-1192(ra) # 708 <peek>
     bb8:	fc0512e3          	bnez	a0,b7c <parseline+0x40>
  if(peek(ps, es, ";")){
     bbc:	00001617          	auipc	a2,0x1
     bc0:	fec60613          	add	a2,a2,-20 # 1ba8 <malloc+0x1f8>
     bc4:	00098593          	mv	a1,s3
     bc8:	00090513          	mv	a0,s2
     bcc:	00000097          	auipc	ra,0x0
     bd0:	b3c080e7          	jalr	-1220(ra) # 708 <peek>
     bd4:	02051463          	bnez	a0,bfc <parseline+0xc0>
}
     bd8:	00048513          	mv	a0,s1
     bdc:	02813083          	ld	ra,40(sp)
     be0:	02013403          	ld	s0,32(sp)
     be4:	01813483          	ld	s1,24(sp)
     be8:	01013903          	ld	s2,16(sp)
     bec:	00813983          	ld	s3,8(sp)
     bf0:	00013a03          	ld	s4,0(sp)
     bf4:	03010113          	add	sp,sp,48
     bf8:	00008067          	ret
    gettoken(ps, es, 0, 0);
     bfc:	00000693          	li	a3,0
     c00:	00000613          	li	a2,0
     c04:	00098593          	mv	a1,s3
     c08:	00090513          	mv	a0,s2
     c0c:	00000097          	auipc	ra,0x0
     c10:	94c080e7          	jalr	-1716(ra) # 558 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     c14:	00098593          	mv	a1,s3
     c18:	00090513          	mv	a0,s2
     c1c:	00000097          	auipc	ra,0x0
     c20:	f20080e7          	jalr	-224(ra) # b3c <parseline>
     c24:	00050593          	mv	a1,a0
     c28:	00048513          	mv	a0,s1
     c2c:	00000097          	auipc	ra,0x0
     c30:	854080e7          	jalr	-1964(ra) # 480 <listcmd>
     c34:	00050493          	mv	s1,a0
  return cmd;
     c38:	fa1ff06f          	j	bd8 <parseline+0x9c>

0000000000000c3c <parseblock>:
{
     c3c:	fd010113          	add	sp,sp,-48
     c40:	02113423          	sd	ra,40(sp)
     c44:	02813023          	sd	s0,32(sp)
     c48:	00913c23          	sd	s1,24(sp)
     c4c:	01213823          	sd	s2,16(sp)
     c50:	01313423          	sd	s3,8(sp)
     c54:	03010413          	add	s0,sp,48
     c58:	00050493          	mv	s1,a0
     c5c:	00058913          	mv	s2,a1
  if(!peek(ps, es, "("))
     c60:	00001617          	auipc	a2,0x1
     c64:	f1060613          	add	a2,a2,-240 # 1b70 <malloc+0x1c0>
     c68:	00000097          	auipc	ra,0x0
     c6c:	aa0080e7          	jalr	-1376(ra) # 708 <peek>
     c70:	08050a63          	beqz	a0,d04 <parseblock+0xc8>
  gettoken(ps, es, 0, 0);
     c74:	00000693          	li	a3,0
     c78:	00000613          	li	a2,0
     c7c:	00090593          	mv	a1,s2
     c80:	00048513          	mv	a0,s1
     c84:	00000097          	auipc	ra,0x0
     c88:	8d4080e7          	jalr	-1836(ra) # 558 <gettoken>
  cmd = parseline(ps, es);
     c8c:	00090593          	mv	a1,s2
     c90:	00048513          	mv	a0,s1
     c94:	00000097          	auipc	ra,0x0
     c98:	ea8080e7          	jalr	-344(ra) # b3c <parseline>
     c9c:	00050993          	mv	s3,a0
  if(!peek(ps, es, ")"))
     ca0:	00001617          	auipc	a2,0x1
     ca4:	f2060613          	add	a2,a2,-224 # 1bc0 <malloc+0x210>
     ca8:	00090593          	mv	a1,s2
     cac:	00048513          	mv	a0,s1
     cb0:	00000097          	auipc	ra,0x0
     cb4:	a58080e7          	jalr	-1448(ra) # 708 <peek>
     cb8:	04050e63          	beqz	a0,d14 <parseblock+0xd8>
  gettoken(ps, es, 0, 0);
     cbc:	00000693          	li	a3,0
     cc0:	00000613          	li	a2,0
     cc4:	00090593          	mv	a1,s2
     cc8:	00048513          	mv	a0,s1
     ccc:	00000097          	auipc	ra,0x0
     cd0:	88c080e7          	jalr	-1908(ra) # 558 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     cd4:	00090613          	mv	a2,s2
     cd8:	00048593          	mv	a1,s1
     cdc:	00098513          	mv	a0,s3
     ce0:	00000097          	auipc	ra,0x0
     ce4:	ad0080e7          	jalr	-1328(ra) # 7b0 <parseredirs>
}
     ce8:	02813083          	ld	ra,40(sp)
     cec:	02013403          	ld	s0,32(sp)
     cf0:	01813483          	ld	s1,24(sp)
     cf4:	01013903          	ld	s2,16(sp)
     cf8:	00813983          	ld	s3,8(sp)
     cfc:	03010113          	add	sp,sp,48
     d00:	00008067          	ret
    panic("parseblock");
     d04:	00001517          	auipc	a0,0x1
     d08:	eac50513          	add	a0,a0,-340 # 1bb0 <malloc+0x200>
     d0c:	fffff097          	auipc	ra,0xfffff
     d10:	374080e7          	jalr	884(ra) # 80 <panic>
    panic("syntax - missing )");
     d14:	00001517          	auipc	a0,0x1
     d18:	eb450513          	add	a0,a0,-332 # 1bc8 <malloc+0x218>
     d1c:	fffff097          	auipc	ra,0xfffff
     d20:	364080e7          	jalr	868(ra) # 80 <panic>

0000000000000d24 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     d24:	fe010113          	add	sp,sp,-32
     d28:	00113c23          	sd	ra,24(sp)
     d2c:	00813823          	sd	s0,16(sp)
     d30:	00913423          	sd	s1,8(sp)
     d34:	02010413          	add	s0,sp,32
     d38:	00050493          	mv	s1,a0
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     d3c:	06050463          	beqz	a0,da4 <nulterminate+0x80>
    return 0;

  switch(cmd->type){
     d40:	00052703          	lw	a4,0(a0)
     d44:	00500793          	li	a5,5
     d48:	04e7ee63          	bltu	a5,a4,da4 <nulterminate+0x80>
     d4c:	00056783          	lwu	a5,0(a0)
     d50:	00279793          	sll	a5,a5,0x2
     d54:	00001717          	auipc	a4,0x1
     d58:	ed470713          	add	a4,a4,-300 # 1c28 <malloc+0x278>
     d5c:	00e787b3          	add	a5,a5,a4
     d60:	0007a783          	lw	a5,0(a5)
     d64:	00e787b3          	add	a5,a5,a4
     d68:	00078067          	jr	a5
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     d6c:	00853783          	ld	a5,8(a0)
     d70:	02078a63          	beqz	a5,da4 <nulterminate+0x80>
     d74:	01050793          	add	a5,a0,16
      *ecmd->eargv[i] = 0;
     d78:	0487b703          	ld	a4,72(a5)
     d7c:	00070023          	sb	zero,0(a4)
    for(i=0; ecmd->argv[i]; i++)
     d80:	00878793          	add	a5,a5,8
     d84:	ff87b703          	ld	a4,-8(a5)
     d88:	fe0718e3          	bnez	a4,d78 <nulterminate+0x54>
     d8c:	0180006f          	j	da4 <nulterminate+0x80>
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
     d90:	00853503          	ld	a0,8(a0)
     d94:	00000097          	auipc	ra,0x0
     d98:	f90080e7          	jalr	-112(ra) # d24 <nulterminate>
    *rcmd->efile = 0;
     d9c:	0184b783          	ld	a5,24(s1)
     da0:	00078023          	sb	zero,0(a5)
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     da4:	00048513          	mv	a0,s1
     da8:	01813083          	ld	ra,24(sp)
     dac:	01013403          	ld	s0,16(sp)
     db0:	00813483          	ld	s1,8(sp)
     db4:	02010113          	add	sp,sp,32
     db8:	00008067          	ret
    nulterminate(pcmd->left);
     dbc:	00853503          	ld	a0,8(a0)
     dc0:	00000097          	auipc	ra,0x0
     dc4:	f64080e7          	jalr	-156(ra) # d24 <nulterminate>
    nulterminate(pcmd->right);
     dc8:	0104b503          	ld	a0,16(s1)
     dcc:	00000097          	auipc	ra,0x0
     dd0:	f58080e7          	jalr	-168(ra) # d24 <nulterminate>
    break;
     dd4:	fd1ff06f          	j	da4 <nulterminate+0x80>
    nulterminate(lcmd->left);
     dd8:	00853503          	ld	a0,8(a0)
     ddc:	00000097          	auipc	ra,0x0
     de0:	f48080e7          	jalr	-184(ra) # d24 <nulterminate>
    nulterminate(lcmd->right);
     de4:	0104b503          	ld	a0,16(s1)
     de8:	00000097          	auipc	ra,0x0
     dec:	f3c080e7          	jalr	-196(ra) # d24 <nulterminate>
    break;
     df0:	fb5ff06f          	j	da4 <nulterminate+0x80>
    nulterminate(bcmd->cmd);
     df4:	00853503          	ld	a0,8(a0)
     df8:	00000097          	auipc	ra,0x0
     dfc:	f2c080e7          	jalr	-212(ra) # d24 <nulterminate>
    break;
     e00:	fa5ff06f          	j	da4 <nulterminate+0x80>

0000000000000e04 <parsecmd>:
{
     e04:	fd010113          	add	sp,sp,-48
     e08:	02113423          	sd	ra,40(sp)
     e0c:	02813023          	sd	s0,32(sp)
     e10:	00913c23          	sd	s1,24(sp)
     e14:	01213823          	sd	s2,16(sp)
     e18:	03010413          	add	s0,sp,48
     e1c:	fca43c23          	sd	a0,-40(s0)
  es = s + strlen(s);
     e20:	00050493          	mv	s1,a0
     e24:	00000097          	auipc	ra,0x0
     e28:	250080e7          	jalr	592(ra) # 1074 <strlen>
     e2c:	02051513          	sll	a0,a0,0x20
     e30:	02055513          	srl	a0,a0,0x20
     e34:	00a484b3          	add	s1,s1,a0
  cmd = parseline(&s, es);
     e38:	00048593          	mv	a1,s1
     e3c:	fd840513          	add	a0,s0,-40
     e40:	00000097          	auipc	ra,0x0
     e44:	cfc080e7          	jalr	-772(ra) # b3c <parseline>
     e48:	00050913          	mv	s2,a0
  peek(&s, es, "");
     e4c:	00001617          	auipc	a2,0x1
     e50:	d9460613          	add	a2,a2,-620 # 1be0 <malloc+0x230>
     e54:	00048593          	mv	a1,s1
     e58:	fd840513          	add	a0,s0,-40
     e5c:	00000097          	auipc	ra,0x0
     e60:	8ac080e7          	jalr	-1876(ra) # 708 <peek>
  if(s != es){
     e64:	fd843603          	ld	a2,-40(s0)
     e68:	02961663          	bne	a2,s1,e94 <parsecmd+0x90>
  nulterminate(cmd);
     e6c:	00090513          	mv	a0,s2
     e70:	00000097          	auipc	ra,0x0
     e74:	eb4080e7          	jalr	-332(ra) # d24 <nulterminate>
}
     e78:	00090513          	mv	a0,s2
     e7c:	02813083          	ld	ra,40(sp)
     e80:	02013403          	ld	s0,32(sp)
     e84:	01813483          	ld	s1,24(sp)
     e88:	01013903          	ld	s2,16(sp)
     e8c:	03010113          	add	sp,sp,48
     e90:	00008067          	ret
    fprintf(2, "leftovers: %s\n", s);
     e94:	00001597          	auipc	a1,0x1
     e98:	d5458593          	add	a1,a1,-684 # 1be8 <malloc+0x238>
     e9c:	00200513          	li	a0,2
     ea0:	00001097          	auipc	ra,0x1
     ea4:	9c4080e7          	jalr	-1596(ra) # 1864 <fprintf>
    panic("syntax");
     ea8:	00001517          	auipc	a0,0x1
     eac:	cd050513          	add	a0,a0,-816 # 1b78 <malloc+0x1c8>
     eb0:	fffff097          	auipc	ra,0xfffff
     eb4:	1d0080e7          	jalr	464(ra) # 80 <panic>

0000000000000eb8 <main>:
{
     eb8:	fd010113          	add	sp,sp,-48
     ebc:	02113423          	sd	ra,40(sp)
     ec0:	02813023          	sd	s0,32(sp)
     ec4:	00913c23          	sd	s1,24(sp)
     ec8:	01213823          	sd	s2,16(sp)
     ecc:	01313423          	sd	s3,8(sp)
     ed0:	01413023          	sd	s4,0(sp)
     ed4:	03010413          	add	s0,sp,48
  while((fd = open("console", O_RDWR)) >= 0){
     ed8:	00001497          	auipc	s1,0x1
     edc:	d2048493          	add	s1,s1,-736 # 1bf8 <malloc+0x248>
     ee0:	00200593          	li	a1,2
     ee4:	00048513          	mv	a0,s1
     ee8:	00000097          	auipc	ra,0x0
     eec:	548080e7          	jalr	1352(ra) # 1430 <open>
     ef0:	00054a63          	bltz	a0,f04 <main+0x4c>
    if(fd >= 3){
     ef4:	00200793          	li	a5,2
     ef8:	fea7d4e3          	bge	a5,a0,ee0 <main+0x28>
      close(fd);
     efc:	00000097          	auipc	ra,0x0
     f00:	510080e7          	jalr	1296(ra) # 140c <close>
  while(getcmd(buf, sizeof(buf)) >= 0){
     f04:	00001497          	auipc	s1,0x1
     f08:	11c48493          	add	s1,s1,284 # 2020 <buf.0>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     f0c:	06300913          	li	s2,99
     f10:	02000993          	li	s3,32
     f14:	01c0006f          	j	f30 <main+0x78>
    if(fork1() == 0)
     f18:	fffff097          	auipc	ra,0xfffff
     f1c:	19c080e7          	jalr	412(ra) # b4 <fork1>
     f20:	08050e63          	beqz	a0,fbc <main+0x104>
    wait(0);
     f24:	00000513          	li	a0,0
     f28:	00000097          	auipc	ra,0x0
     f2c:	4b4080e7          	jalr	1204(ra) # 13dc <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
     f30:	06400593          	li	a1,100
     f34:	00048513          	mv	a0,s1
     f38:	fffff097          	auipc	ra,0xfffff
     f3c:	0c8080e7          	jalr	200(ra) # 0 <getcmd>
     f40:	08054a63          	bltz	a0,fd4 <main+0x11c>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     f44:	0004c783          	lbu	a5,0(s1)
     f48:	fd2798e3          	bne	a5,s2,f18 <main+0x60>
     f4c:	0014c703          	lbu	a4,1(s1)
     f50:	06400793          	li	a5,100
     f54:	fcf712e3          	bne	a4,a5,f18 <main+0x60>
     f58:	0024c783          	lbu	a5,2(s1)
     f5c:	fb379ee3          	bne	a5,s3,f18 <main+0x60>
      buf[strlen(buf)-1] = 0;  // chop \n
     f60:	00001a17          	auipc	s4,0x1
     f64:	0c0a0a13          	add	s4,s4,192 # 2020 <buf.0>
     f68:	000a0513          	mv	a0,s4
     f6c:	00000097          	auipc	ra,0x0
     f70:	108080e7          	jalr	264(ra) # 1074 <strlen>
     f74:	fff5079b          	addw	a5,a0,-1
     f78:	02079793          	sll	a5,a5,0x20
     f7c:	0207d793          	srl	a5,a5,0x20
     f80:	00fa0a33          	add	s4,s4,a5
     f84:	000a0023          	sb	zero,0(s4)
      if(chdir(buf+3) < 0)
     f88:	00001517          	auipc	a0,0x1
     f8c:	09b50513          	add	a0,a0,155 # 2023 <buf.0+0x3>
     f90:	00000097          	auipc	ra,0x0
     f94:	4e8080e7          	jalr	1256(ra) # 1478 <chdir>
     f98:	f8055ce3          	bgez	a0,f30 <main+0x78>
        fprintf(2, "cannot cd %s\n", buf+3);
     f9c:	00001617          	auipc	a2,0x1
     fa0:	08760613          	add	a2,a2,135 # 2023 <buf.0+0x3>
     fa4:	00001597          	auipc	a1,0x1
     fa8:	c5c58593          	add	a1,a1,-932 # 1c00 <malloc+0x250>
     fac:	00200513          	li	a0,2
     fb0:	00001097          	auipc	ra,0x1
     fb4:	8b4080e7          	jalr	-1868(ra) # 1864 <fprintf>
     fb8:	f79ff06f          	j	f30 <main+0x78>
      runcmd(parsecmd(buf));
     fbc:	00001517          	auipc	a0,0x1
     fc0:	06450513          	add	a0,a0,100 # 2020 <buf.0>
     fc4:	00000097          	auipc	ra,0x0
     fc8:	e40080e7          	jalr	-448(ra) # e04 <parsecmd>
     fcc:	fffff097          	auipc	ra,0xfffff
     fd0:	128080e7          	jalr	296(ra) # f4 <runcmd>
  exit(0);
     fd4:	00000513          	li	a0,0
     fd8:	00000097          	auipc	ra,0x0
     fdc:	3f8080e7          	jalr	1016(ra) # 13d0 <exit>

0000000000000fe0 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
     fe0:	ff010113          	add	sp,sp,-16
     fe4:	00113423          	sd	ra,8(sp)
     fe8:	00813023          	sd	s0,0(sp)
     fec:	01010413          	add	s0,sp,16
  extern int main();
  main();
     ff0:	00000097          	auipc	ra,0x0
     ff4:	ec8080e7          	jalr	-312(ra) # eb8 <main>
  exit(0);
     ff8:	00000513          	li	a0,0
     ffc:	00000097          	auipc	ra,0x0
    1000:	3d4080e7          	jalr	980(ra) # 13d0 <exit>

0000000000001004 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    1004:	ff010113          	add	sp,sp,-16
    1008:	00813423          	sd	s0,8(sp)
    100c:	01010413          	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    1010:	00050793          	mv	a5,a0
    1014:	00158593          	add	a1,a1,1
    1018:	00178793          	add	a5,a5,1
    101c:	fff5c703          	lbu	a4,-1(a1)
    1020:	fee78fa3          	sb	a4,-1(a5)
    1024:	fe0718e3          	bnez	a4,1014 <strcpy+0x10>
    ;
  return os;
}
    1028:	00813403          	ld	s0,8(sp)
    102c:	01010113          	add	sp,sp,16
    1030:	00008067          	ret

0000000000001034 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1034:	ff010113          	add	sp,sp,-16
    1038:	00813423          	sd	s0,8(sp)
    103c:	01010413          	add	s0,sp,16
  while(*p && *p == *q)
    1040:	00054783          	lbu	a5,0(a0)
    1044:	00078e63          	beqz	a5,1060 <strcmp+0x2c>
    1048:	0005c703          	lbu	a4,0(a1)
    104c:	00f71a63          	bne	a4,a5,1060 <strcmp+0x2c>
    p++, q++;
    1050:	00150513          	add	a0,a0,1
    1054:	00158593          	add	a1,a1,1
  while(*p && *p == *q)
    1058:	00054783          	lbu	a5,0(a0)
    105c:	fe0796e3          	bnez	a5,1048 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
    1060:	0005c503          	lbu	a0,0(a1)
}
    1064:	40a7853b          	subw	a0,a5,a0
    1068:	00813403          	ld	s0,8(sp)
    106c:	01010113          	add	sp,sp,16
    1070:	00008067          	ret

0000000000001074 <strlen>:

uint
strlen(const char *s)
{
    1074:	ff010113          	add	sp,sp,-16
    1078:	00813423          	sd	s0,8(sp)
    107c:	01010413          	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    1080:	00054783          	lbu	a5,0(a0)
    1084:	02078863          	beqz	a5,10b4 <strlen+0x40>
    1088:	00150513          	add	a0,a0,1
    108c:	00050793          	mv	a5,a0
    1090:	00078693          	mv	a3,a5
    1094:	00178793          	add	a5,a5,1
    1098:	fff7c703          	lbu	a4,-1(a5)
    109c:	fe071ae3          	bnez	a4,1090 <strlen+0x1c>
    10a0:	40a6853b          	subw	a0,a3,a0
    10a4:	0015051b          	addw	a0,a0,1
    ;
  return n;
}
    10a8:	00813403          	ld	s0,8(sp)
    10ac:	01010113          	add	sp,sp,16
    10b0:	00008067          	ret
  for(n = 0; s[n]; n++)
    10b4:	00000513          	li	a0,0
    10b8:	ff1ff06f          	j	10a8 <strlen+0x34>

00000000000010bc <memset>:

void*
memset(void *dst, int c, uint n)
{
    10bc:	ff010113          	add	sp,sp,-16
    10c0:	00813423          	sd	s0,8(sp)
    10c4:	01010413          	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    10c8:	02060063          	beqz	a2,10e8 <memset+0x2c>
    10cc:	00050793          	mv	a5,a0
    10d0:	02061613          	sll	a2,a2,0x20
    10d4:	02065613          	srl	a2,a2,0x20
    10d8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    10dc:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    10e0:	00178793          	add	a5,a5,1
    10e4:	fee79ce3          	bne	a5,a4,10dc <memset+0x20>
  }
  return dst;
}
    10e8:	00813403          	ld	s0,8(sp)
    10ec:	01010113          	add	sp,sp,16
    10f0:	00008067          	ret

00000000000010f4 <strchr>:

char*
strchr(const char *s, char c)
{
    10f4:	ff010113          	add	sp,sp,-16
    10f8:	00813423          	sd	s0,8(sp)
    10fc:	01010413          	add	s0,sp,16
  for(; *s; s++)
    1100:	00054783          	lbu	a5,0(a0)
    1104:	02078263          	beqz	a5,1128 <strchr+0x34>
    if(*s == c)
    1108:	00f58a63          	beq	a1,a5,111c <strchr+0x28>
  for(; *s; s++)
    110c:	00150513          	add	a0,a0,1
    1110:	00054783          	lbu	a5,0(a0)
    1114:	fe079ae3          	bnez	a5,1108 <strchr+0x14>
      return (char*)s;
  return 0;
    1118:	00000513          	li	a0,0
}
    111c:	00813403          	ld	s0,8(sp)
    1120:	01010113          	add	sp,sp,16
    1124:	00008067          	ret
  return 0;
    1128:	00000513          	li	a0,0
    112c:	ff1ff06f          	j	111c <strchr+0x28>

0000000000001130 <gets>:

char*
gets(char *buf, int max)
{
    1130:	fa010113          	add	sp,sp,-96
    1134:	04113c23          	sd	ra,88(sp)
    1138:	04813823          	sd	s0,80(sp)
    113c:	04913423          	sd	s1,72(sp)
    1140:	05213023          	sd	s2,64(sp)
    1144:	03313c23          	sd	s3,56(sp)
    1148:	03413823          	sd	s4,48(sp)
    114c:	03513423          	sd	s5,40(sp)
    1150:	03613023          	sd	s6,32(sp)
    1154:	01713c23          	sd	s7,24(sp)
    1158:	06010413          	add	s0,sp,96
    115c:	00050b93          	mv	s7,a0
    1160:	00058a13          	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1164:	00050913          	mv	s2,a0
    1168:	00000493          	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    116c:	00a00a93          	li	s5,10
    1170:	00d00b13          	li	s6,13
  for(i=0; i+1 < max; ){
    1174:	00048993          	mv	s3,s1
    1178:	0014849b          	addw	s1,s1,1
    117c:	0344de63          	bge	s1,s4,11b8 <gets+0x88>
    cc = read(0, &c, 1);
    1180:	00100613          	li	a2,1
    1184:	faf40593          	add	a1,s0,-81
    1188:	00000513          	li	a0,0
    118c:	00000097          	auipc	ra,0x0
    1190:	268080e7          	jalr	616(ra) # 13f4 <read>
    if(cc < 1)
    1194:	02a05263          	blez	a0,11b8 <gets+0x88>
    buf[i++] = c;
    1198:	faf44783          	lbu	a5,-81(s0)
    119c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    11a0:	01578a63          	beq	a5,s5,11b4 <gets+0x84>
    11a4:	00190913          	add	s2,s2,1
    11a8:	fd6796e3          	bne	a5,s6,1174 <gets+0x44>
  for(i=0; i+1 < max; ){
    11ac:	00048993          	mv	s3,s1
    11b0:	0080006f          	j	11b8 <gets+0x88>
    11b4:	00048993          	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    11b8:	013b89b3          	add	s3,s7,s3
    11bc:	00098023          	sb	zero,0(s3)
  return buf;
}
    11c0:	000b8513          	mv	a0,s7
    11c4:	05813083          	ld	ra,88(sp)
    11c8:	05013403          	ld	s0,80(sp)
    11cc:	04813483          	ld	s1,72(sp)
    11d0:	04013903          	ld	s2,64(sp)
    11d4:	03813983          	ld	s3,56(sp)
    11d8:	03013a03          	ld	s4,48(sp)
    11dc:	02813a83          	ld	s5,40(sp)
    11e0:	02013b03          	ld	s6,32(sp)
    11e4:	01813b83          	ld	s7,24(sp)
    11e8:	06010113          	add	sp,sp,96
    11ec:	00008067          	ret

00000000000011f0 <stat>:

int
stat(const char *n, struct stat *st)
{
    11f0:	fe010113          	add	sp,sp,-32
    11f4:	00113c23          	sd	ra,24(sp)
    11f8:	00813823          	sd	s0,16(sp)
    11fc:	00913423          	sd	s1,8(sp)
    1200:	01213023          	sd	s2,0(sp)
    1204:	02010413          	add	s0,sp,32
    1208:	00058913          	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    120c:	00000593          	li	a1,0
    1210:	00000097          	auipc	ra,0x0
    1214:	220080e7          	jalr	544(ra) # 1430 <open>
  if(fd < 0)
    1218:	04054063          	bltz	a0,1258 <stat+0x68>
    121c:	00050493          	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    1220:	00090593          	mv	a1,s2
    1224:	00000097          	auipc	ra,0x0
    1228:	230080e7          	jalr	560(ra) # 1454 <fstat>
    122c:	00050913          	mv	s2,a0
  close(fd);
    1230:	00048513          	mv	a0,s1
    1234:	00000097          	auipc	ra,0x0
    1238:	1d8080e7          	jalr	472(ra) # 140c <close>
  return r;
}
    123c:	00090513          	mv	a0,s2
    1240:	01813083          	ld	ra,24(sp)
    1244:	01013403          	ld	s0,16(sp)
    1248:	00813483          	ld	s1,8(sp)
    124c:	00013903          	ld	s2,0(sp)
    1250:	02010113          	add	sp,sp,32
    1254:	00008067          	ret
    return -1;
    1258:	fff00913          	li	s2,-1
    125c:	fe1ff06f          	j	123c <stat+0x4c>

0000000000001260 <atoi>:

int
atoi(const char *s)
{
    1260:	ff010113          	add	sp,sp,-16
    1264:	00813423          	sd	s0,8(sp)
    1268:	01010413          	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    126c:	00054683          	lbu	a3,0(a0)
    1270:	fd06879b          	addw	a5,a3,-48
    1274:	0ff7f793          	zext.b	a5,a5
    1278:	00900613          	li	a2,9
    127c:	04f66063          	bltu	a2,a5,12bc <atoi+0x5c>
    1280:	00050713          	mv	a4,a0
  n = 0;
    1284:	00000513          	li	a0,0
    n = n*10 + *s++ - '0';
    1288:	00170713          	add	a4,a4,1
    128c:	0025179b          	sllw	a5,a0,0x2
    1290:	00a787bb          	addw	a5,a5,a0
    1294:	0017979b          	sllw	a5,a5,0x1
    1298:	00d787bb          	addw	a5,a5,a3
    129c:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    12a0:	00074683          	lbu	a3,0(a4)
    12a4:	fd06879b          	addw	a5,a3,-48
    12a8:	0ff7f793          	zext.b	a5,a5
    12ac:	fcf67ee3          	bgeu	a2,a5,1288 <atoi+0x28>
  return n;
}
    12b0:	00813403          	ld	s0,8(sp)
    12b4:	01010113          	add	sp,sp,16
    12b8:	00008067          	ret
  n = 0;
    12bc:	00000513          	li	a0,0
    12c0:	ff1ff06f          	j	12b0 <atoi+0x50>

00000000000012c4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    12c4:	ff010113          	add	sp,sp,-16
    12c8:	00813423          	sd	s0,8(sp)
    12cc:	01010413          	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    12d0:	02b57c63          	bgeu	a0,a1,1308 <memmove+0x44>
    while(n-- > 0)
    12d4:	02c05463          	blez	a2,12fc <memmove+0x38>
    12d8:	02061613          	sll	a2,a2,0x20
    12dc:	02065613          	srl	a2,a2,0x20
    12e0:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    12e4:	00050713          	mv	a4,a0
      *dst++ = *src++;
    12e8:	00158593          	add	a1,a1,1
    12ec:	00170713          	add	a4,a4,1
    12f0:	fff5c683          	lbu	a3,-1(a1)
    12f4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    12f8:	fee798e3          	bne	a5,a4,12e8 <memmove+0x24>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    12fc:	00813403          	ld	s0,8(sp)
    1300:	01010113          	add	sp,sp,16
    1304:	00008067          	ret
    dst += n;
    1308:	00c50733          	add	a4,a0,a2
    src += n;
    130c:	00c585b3          	add	a1,a1,a2
    while(n-- > 0)
    1310:	fec056e3          	blez	a2,12fc <memmove+0x38>
    1314:	fff6079b          	addw	a5,a2,-1
    1318:	02079793          	sll	a5,a5,0x20
    131c:	0207d793          	srl	a5,a5,0x20
    1320:	fff7c793          	not	a5,a5
    1324:	00f707b3          	add	a5,a4,a5
      *--dst = *--src;
    1328:	fff58593          	add	a1,a1,-1
    132c:	fff70713          	add	a4,a4,-1
    1330:	0005c683          	lbu	a3,0(a1)
    1334:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    1338:	fee798e3          	bne	a5,a4,1328 <memmove+0x64>
    133c:	fc1ff06f          	j	12fc <memmove+0x38>

0000000000001340 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    1340:	ff010113          	add	sp,sp,-16
    1344:	00813423          	sd	s0,8(sp)
    1348:	01010413          	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    134c:	04060463          	beqz	a2,1394 <memcmp+0x54>
    1350:	fff6069b          	addw	a3,a2,-1
    1354:	02069693          	sll	a3,a3,0x20
    1358:	0206d693          	srl	a3,a3,0x20
    135c:	00168693          	add	a3,a3,1
    1360:	00d506b3          	add	a3,a0,a3
    if (*p1 != *p2) {
    1364:	00054783          	lbu	a5,0(a0)
    1368:	0005c703          	lbu	a4,0(a1)
    136c:	00e79c63          	bne	a5,a4,1384 <memcmp+0x44>
      return *p1 - *p2;
    }
    p1++;
    1370:	00150513          	add	a0,a0,1
    p2++;
    1374:	00158593          	add	a1,a1,1
  while (n-- > 0) {
    1378:	fed516e3          	bne	a0,a3,1364 <memcmp+0x24>
  }
  return 0;
    137c:	00000513          	li	a0,0
    1380:	0080006f          	j	1388 <memcmp+0x48>
      return *p1 - *p2;
    1384:	40e7853b          	subw	a0,a5,a4
}
    1388:	00813403          	ld	s0,8(sp)
    138c:	01010113          	add	sp,sp,16
    1390:	00008067          	ret
  return 0;
    1394:	00000513          	li	a0,0
    1398:	ff1ff06f          	j	1388 <memcmp+0x48>

000000000000139c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    139c:	ff010113          	add	sp,sp,-16
    13a0:	00113423          	sd	ra,8(sp)
    13a4:	00813023          	sd	s0,0(sp)
    13a8:	01010413          	add	s0,sp,16
  return memmove(dst, src, n);
    13ac:	00000097          	auipc	ra,0x0
    13b0:	f18080e7          	jalr	-232(ra) # 12c4 <memmove>
}
    13b4:	00813083          	ld	ra,8(sp)
    13b8:	00013403          	ld	s0,0(sp)
    13bc:	01010113          	add	sp,sp,16
    13c0:	00008067          	ret

00000000000013c4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    13c4:	00100893          	li	a7,1
 ecall
    13c8:	00000073          	ecall
 ret
    13cc:	00008067          	ret

00000000000013d0 <exit>:
.global exit
exit:
 li a7, SYS_exit
    13d0:	00200893          	li	a7,2
 ecall
    13d4:	00000073          	ecall
 ret
    13d8:	00008067          	ret

00000000000013dc <wait>:
.global wait
wait:
 li a7, SYS_wait
    13dc:	00300893          	li	a7,3
 ecall
    13e0:	00000073          	ecall
 ret
    13e4:	00008067          	ret

00000000000013e8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    13e8:	00400893          	li	a7,4
 ecall
    13ec:	00000073          	ecall
 ret
    13f0:	00008067          	ret

00000000000013f4 <read>:
.global read
read:
 li a7, SYS_read
    13f4:	00500893          	li	a7,5
 ecall
    13f8:	00000073          	ecall
 ret
    13fc:	00008067          	ret

0000000000001400 <write>:
.global write
write:
 li a7, SYS_write
    1400:	01000893          	li	a7,16
 ecall
    1404:	00000073          	ecall
 ret
    1408:	00008067          	ret

000000000000140c <close>:
.global close
close:
 li a7, SYS_close
    140c:	01500893          	li	a7,21
 ecall
    1410:	00000073          	ecall
 ret
    1414:	00008067          	ret

0000000000001418 <kill>:
.global kill
kill:
 li a7, SYS_kill
    1418:	00600893          	li	a7,6
 ecall
    141c:	00000073          	ecall
 ret
    1420:	00008067          	ret

0000000000001424 <exec>:
.global exec
exec:
 li a7, SYS_exec
    1424:	00700893          	li	a7,7
 ecall
    1428:	00000073          	ecall
 ret
    142c:	00008067          	ret

0000000000001430 <open>:
.global open
open:
 li a7, SYS_open
    1430:	00f00893          	li	a7,15
 ecall
    1434:	00000073          	ecall
 ret
    1438:	00008067          	ret

000000000000143c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    143c:	01100893          	li	a7,17
 ecall
    1440:	00000073          	ecall
 ret
    1444:	00008067          	ret

0000000000001448 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    1448:	01200893          	li	a7,18
 ecall
    144c:	00000073          	ecall
 ret
    1450:	00008067          	ret

0000000000001454 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    1454:	00800893          	li	a7,8
 ecall
    1458:	00000073          	ecall
 ret
    145c:	00008067          	ret

0000000000001460 <link>:
.global link
link:
 li a7, SYS_link
    1460:	01300893          	li	a7,19
 ecall
    1464:	00000073          	ecall
 ret
    1468:	00008067          	ret

000000000000146c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    146c:	01400893          	li	a7,20
 ecall
    1470:	00000073          	ecall
 ret
    1474:	00008067          	ret

0000000000001478 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    1478:	00900893          	li	a7,9
 ecall
    147c:	00000073          	ecall
 ret
    1480:	00008067          	ret

0000000000001484 <dup>:
.global dup
dup:
 li a7, SYS_dup
    1484:	00a00893          	li	a7,10
 ecall
    1488:	00000073          	ecall
 ret
    148c:	00008067          	ret

0000000000001490 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    1490:	00b00893          	li	a7,11
 ecall
    1494:	00000073          	ecall
 ret
    1498:	00008067          	ret

000000000000149c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    149c:	00c00893          	li	a7,12
 ecall
    14a0:	00000073          	ecall
 ret
    14a4:	00008067          	ret

00000000000014a8 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    14a8:	00d00893          	li	a7,13
 ecall
    14ac:	00000073          	ecall
 ret
    14b0:	00008067          	ret

00000000000014b4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    14b4:	00e00893          	li	a7,14
 ecall
    14b8:	00000073          	ecall
 ret
    14bc:	00008067          	ret

00000000000014c0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    14c0:	fe010113          	add	sp,sp,-32
    14c4:	00113c23          	sd	ra,24(sp)
    14c8:	00813823          	sd	s0,16(sp)
    14cc:	02010413          	add	s0,sp,32
    14d0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    14d4:	00100613          	li	a2,1
    14d8:	fef40593          	add	a1,s0,-17
    14dc:	00000097          	auipc	ra,0x0
    14e0:	f24080e7          	jalr	-220(ra) # 1400 <write>
}
    14e4:	01813083          	ld	ra,24(sp)
    14e8:	01013403          	ld	s0,16(sp)
    14ec:	02010113          	add	sp,sp,32
    14f0:	00008067          	ret

00000000000014f4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    14f4:	fc010113          	add	sp,sp,-64
    14f8:	02113c23          	sd	ra,56(sp)
    14fc:	02813823          	sd	s0,48(sp)
    1500:	02913423          	sd	s1,40(sp)
    1504:	03213023          	sd	s2,32(sp)
    1508:	01313c23          	sd	s3,24(sp)
    150c:	04010413          	add	s0,sp,64
    1510:	00050493          	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    1514:	00068463          	beqz	a3,151c <printint+0x28>
    1518:	0c05c063          	bltz	a1,15d8 <printint+0xe4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    151c:	0005859b          	sext.w	a1,a1
  neg = 0;
    1520:	00000893          	li	a7,0
    1524:	fc040693          	add	a3,s0,-64
  }

  i = 0;
    1528:	00000713          	li	a4,0
  do{
    buf[i++] = digits[x % base];
    152c:	0006061b          	sext.w	a2,a2
    1530:	00000517          	auipc	a0,0x0
    1534:	77050513          	add	a0,a0,1904 # 1ca0 <digits>
    1538:	00070813          	mv	a6,a4
    153c:	0017071b          	addw	a4,a4,1
    1540:	02c5f7bb          	remuw	a5,a1,a2
    1544:	02079793          	sll	a5,a5,0x20
    1548:	0207d793          	srl	a5,a5,0x20
    154c:	00f507b3          	add	a5,a0,a5
    1550:	0007c783          	lbu	a5,0(a5)
    1554:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    1558:	0005879b          	sext.w	a5,a1
    155c:	02c5d5bb          	divuw	a1,a1,a2
    1560:	00168693          	add	a3,a3,1
    1564:	fcc7fae3          	bgeu	a5,a2,1538 <printint+0x44>
  if(neg)
    1568:	00088c63          	beqz	a7,1580 <printint+0x8c>
    buf[i++] = '-';
    156c:	fd070793          	add	a5,a4,-48
    1570:	00878733          	add	a4,a5,s0
    1574:	02d00793          	li	a5,45
    1578:	fef70823          	sb	a5,-16(a4)
    157c:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
    1580:	02e05e63          	blez	a4,15bc <printint+0xc8>
    1584:	fc040793          	add	a5,s0,-64
    1588:	00e78933          	add	s2,a5,a4
    158c:	fff78993          	add	s3,a5,-1
    1590:	00e989b3          	add	s3,s3,a4
    1594:	fff7071b          	addw	a4,a4,-1
    1598:	02071713          	sll	a4,a4,0x20
    159c:	02075713          	srl	a4,a4,0x20
    15a0:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    15a4:	fff94583          	lbu	a1,-1(s2)
    15a8:	00048513          	mv	a0,s1
    15ac:	00000097          	auipc	ra,0x0
    15b0:	f14080e7          	jalr	-236(ra) # 14c0 <putc>
  while(--i >= 0)
    15b4:	fff90913          	add	s2,s2,-1
    15b8:	ff3916e3          	bne	s2,s3,15a4 <printint+0xb0>
}
    15bc:	03813083          	ld	ra,56(sp)
    15c0:	03013403          	ld	s0,48(sp)
    15c4:	02813483          	ld	s1,40(sp)
    15c8:	02013903          	ld	s2,32(sp)
    15cc:	01813983          	ld	s3,24(sp)
    15d0:	04010113          	add	sp,sp,64
    15d4:	00008067          	ret
    x = -xx;
    15d8:	40b005bb          	negw	a1,a1
    neg = 1;
    15dc:	00100893          	li	a7,1
    x = -xx;
    15e0:	f45ff06f          	j	1524 <printint+0x30>

00000000000015e4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    15e4:	fb010113          	add	sp,sp,-80
    15e8:	04113423          	sd	ra,72(sp)
    15ec:	04813023          	sd	s0,64(sp)
    15f0:	02913c23          	sd	s1,56(sp)
    15f4:	03213823          	sd	s2,48(sp)
    15f8:	03313423          	sd	s3,40(sp)
    15fc:	03413023          	sd	s4,32(sp)
    1600:	01513c23          	sd	s5,24(sp)
    1604:	01613823          	sd	s6,16(sp)
    1608:	01713423          	sd	s7,8(sp)
    160c:	01813023          	sd	s8,0(sp)
    1610:	05010413          	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    1614:	0005c903          	lbu	s2,0(a1)
    1618:	20090e63          	beqz	s2,1834 <vprintf+0x250>
    161c:	00050a93          	mv	s5,a0
    1620:	00060b93          	mv	s7,a2
    1624:	00158493          	add	s1,a1,1
  state = 0;
    1628:	00000993          	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    162c:	02500a13          	li	s4,37
    1630:	01500b13          	li	s6,21
    1634:	0280006f          	j	165c <vprintf+0x78>
        putc(fd, c);
    1638:	00090593          	mv	a1,s2
    163c:	000a8513          	mv	a0,s5
    1640:	00000097          	auipc	ra,0x0
    1644:	e80080e7          	jalr	-384(ra) # 14c0 <putc>
    1648:	0080006f          	j	1650 <vprintf+0x6c>
    } else if(state == '%'){
    164c:	03498063          	beq	s3,s4,166c <vprintf+0x88>
  for(i = 0; fmt[i]; i++){
    1650:	00148493          	add	s1,s1,1
    1654:	fff4c903          	lbu	s2,-1(s1)
    1658:	1c090e63          	beqz	s2,1834 <vprintf+0x250>
    if(state == 0){
    165c:	fe0998e3          	bnez	s3,164c <vprintf+0x68>
      if(c == '%'){
    1660:	fd491ce3          	bne	s2,s4,1638 <vprintf+0x54>
        state = '%';
    1664:	000a0993          	mv	s3,s4
    1668:	fe9ff06f          	j	1650 <vprintf+0x6c>
      if(c == 'd'){
    166c:	17490e63          	beq	s2,s4,17e8 <vprintf+0x204>
    1670:	f9d9079b          	addw	a5,s2,-99
    1674:	0ff7f793          	zext.b	a5,a5
    1678:	18fb6463          	bltu	s6,a5,1800 <vprintf+0x21c>
    167c:	f9d9079b          	addw	a5,s2,-99
    1680:	0ff7f713          	zext.b	a4,a5
    1684:	16eb6e63          	bltu	s6,a4,1800 <vprintf+0x21c>
    1688:	00271793          	sll	a5,a4,0x2
    168c:	00000717          	auipc	a4,0x0
    1690:	5bc70713          	add	a4,a4,1468 # 1c48 <malloc+0x298>
    1694:	00e787b3          	add	a5,a5,a4
    1698:	0007a783          	lw	a5,0(a5)
    169c:	00e787b3          	add	a5,a5,a4
    16a0:	00078067          	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    16a4:	008b8913          	add	s2,s7,8
    16a8:	00100693          	li	a3,1
    16ac:	00a00613          	li	a2,10
    16b0:	000ba583          	lw	a1,0(s7)
    16b4:	000a8513          	mv	a0,s5
    16b8:	00000097          	auipc	ra,0x0
    16bc:	e3c080e7          	jalr	-452(ra) # 14f4 <printint>
    16c0:	00090b93          	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    16c4:	00000993          	li	s3,0
    16c8:	f89ff06f          	j	1650 <vprintf+0x6c>
        printint(fd, va_arg(ap, uint64), 10, 0);
    16cc:	008b8913          	add	s2,s7,8
    16d0:	00000693          	li	a3,0
    16d4:	00a00613          	li	a2,10
    16d8:	000ba583          	lw	a1,0(s7)
    16dc:	000a8513          	mv	a0,s5
    16e0:	00000097          	auipc	ra,0x0
    16e4:	e14080e7          	jalr	-492(ra) # 14f4 <printint>
    16e8:	00090b93          	mv	s7,s2
      state = 0;
    16ec:	00000993          	li	s3,0
    16f0:	f61ff06f          	j	1650 <vprintf+0x6c>
        printint(fd, va_arg(ap, int), 16, 0);
    16f4:	008b8913          	add	s2,s7,8
    16f8:	00000693          	li	a3,0
    16fc:	01000613          	li	a2,16
    1700:	000ba583          	lw	a1,0(s7)
    1704:	000a8513          	mv	a0,s5
    1708:	00000097          	auipc	ra,0x0
    170c:	dec080e7          	jalr	-532(ra) # 14f4 <printint>
    1710:	00090b93          	mv	s7,s2
      state = 0;
    1714:	00000993          	li	s3,0
    1718:	f39ff06f          	j	1650 <vprintf+0x6c>
        printptr(fd, va_arg(ap, uint64));
    171c:	008b8c13          	add	s8,s7,8
    1720:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    1724:	03000593          	li	a1,48
    1728:	000a8513          	mv	a0,s5
    172c:	00000097          	auipc	ra,0x0
    1730:	d94080e7          	jalr	-620(ra) # 14c0 <putc>
  putc(fd, 'x');
    1734:	07800593          	li	a1,120
    1738:	000a8513          	mv	a0,s5
    173c:	00000097          	auipc	ra,0x0
    1740:	d84080e7          	jalr	-636(ra) # 14c0 <putc>
    1744:	01000913          	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1748:	00000b97          	auipc	s7,0x0
    174c:	558b8b93          	add	s7,s7,1368 # 1ca0 <digits>
    1750:	03c9d793          	srl	a5,s3,0x3c
    1754:	00fb87b3          	add	a5,s7,a5
    1758:	0007c583          	lbu	a1,0(a5)
    175c:	000a8513          	mv	a0,s5
    1760:	00000097          	auipc	ra,0x0
    1764:	d60080e7          	jalr	-672(ra) # 14c0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1768:	00499993          	sll	s3,s3,0x4
    176c:	fff9091b          	addw	s2,s2,-1
    1770:	fe0910e3          	bnez	s2,1750 <vprintf+0x16c>
        printptr(fd, va_arg(ap, uint64));
    1774:	000c0b93          	mv	s7,s8
      state = 0;
    1778:	00000993          	li	s3,0
    177c:	ed5ff06f          	j	1650 <vprintf+0x6c>
        s = va_arg(ap, char*);
    1780:	008b8993          	add	s3,s7,8
    1784:	000bb903          	ld	s2,0(s7)
        if(s == 0)
    1788:	02090863          	beqz	s2,17b8 <vprintf+0x1d4>
        while(*s != 0){
    178c:	00094583          	lbu	a1,0(s2)
    1790:	08058c63          	beqz	a1,1828 <vprintf+0x244>
          putc(fd, *s);
    1794:	000a8513          	mv	a0,s5
    1798:	00000097          	auipc	ra,0x0
    179c:	d28080e7          	jalr	-728(ra) # 14c0 <putc>
          s++;
    17a0:	00190913          	add	s2,s2,1
        while(*s != 0){
    17a4:	00094583          	lbu	a1,0(s2)
    17a8:	fe0596e3          	bnez	a1,1794 <vprintf+0x1b0>
        s = va_arg(ap, char*);
    17ac:	00098b93          	mv	s7,s3
      state = 0;
    17b0:	00000993          	li	s3,0
    17b4:	e9dff06f          	j	1650 <vprintf+0x6c>
          s = "(null)";
    17b8:	00000917          	auipc	s2,0x0
    17bc:	48890913          	add	s2,s2,1160 # 1c40 <malloc+0x290>
        while(*s != 0){
    17c0:	02800593          	li	a1,40
    17c4:	fd1ff06f          	j	1794 <vprintf+0x1b0>
        putc(fd, va_arg(ap, uint));
    17c8:	008b8913          	add	s2,s7,8
    17cc:	000bc583          	lbu	a1,0(s7)
    17d0:	000a8513          	mv	a0,s5
    17d4:	00000097          	auipc	ra,0x0
    17d8:	cec080e7          	jalr	-788(ra) # 14c0 <putc>
    17dc:	00090b93          	mv	s7,s2
      state = 0;
    17e0:	00000993          	li	s3,0
    17e4:	e6dff06f          	j	1650 <vprintf+0x6c>
        putc(fd, c);
    17e8:	02500593          	li	a1,37
    17ec:	000a8513          	mv	a0,s5
    17f0:	00000097          	auipc	ra,0x0
    17f4:	cd0080e7          	jalr	-816(ra) # 14c0 <putc>
      state = 0;
    17f8:	00000993          	li	s3,0
    17fc:	e55ff06f          	j	1650 <vprintf+0x6c>
        putc(fd, '%');
    1800:	02500593          	li	a1,37
    1804:	000a8513          	mv	a0,s5
    1808:	00000097          	auipc	ra,0x0
    180c:	cb8080e7          	jalr	-840(ra) # 14c0 <putc>
        putc(fd, c);
    1810:	00090593          	mv	a1,s2
    1814:	000a8513          	mv	a0,s5
    1818:	00000097          	auipc	ra,0x0
    181c:	ca8080e7          	jalr	-856(ra) # 14c0 <putc>
      state = 0;
    1820:	00000993          	li	s3,0
    1824:	e2dff06f          	j	1650 <vprintf+0x6c>
        s = va_arg(ap, char*);
    1828:	00098b93          	mv	s7,s3
      state = 0;
    182c:	00000993          	li	s3,0
    1830:	e21ff06f          	j	1650 <vprintf+0x6c>
    }
  }
}
    1834:	04813083          	ld	ra,72(sp)
    1838:	04013403          	ld	s0,64(sp)
    183c:	03813483          	ld	s1,56(sp)
    1840:	03013903          	ld	s2,48(sp)
    1844:	02813983          	ld	s3,40(sp)
    1848:	02013a03          	ld	s4,32(sp)
    184c:	01813a83          	ld	s5,24(sp)
    1850:	01013b03          	ld	s6,16(sp)
    1854:	00813b83          	ld	s7,8(sp)
    1858:	00013c03          	ld	s8,0(sp)
    185c:	05010113          	add	sp,sp,80
    1860:	00008067          	ret

0000000000001864 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1864:	fb010113          	add	sp,sp,-80
    1868:	00113c23          	sd	ra,24(sp)
    186c:	00813823          	sd	s0,16(sp)
    1870:	02010413          	add	s0,sp,32
    1874:	00c43023          	sd	a2,0(s0)
    1878:	00d43423          	sd	a3,8(s0)
    187c:	00e43823          	sd	a4,16(s0)
    1880:	00f43c23          	sd	a5,24(s0)
    1884:	03043023          	sd	a6,32(s0)
    1888:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    188c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1890:	00040613          	mv	a2,s0
    1894:	00000097          	auipc	ra,0x0
    1898:	d50080e7          	jalr	-688(ra) # 15e4 <vprintf>
}
    189c:	01813083          	ld	ra,24(sp)
    18a0:	01013403          	ld	s0,16(sp)
    18a4:	05010113          	add	sp,sp,80
    18a8:	00008067          	ret

00000000000018ac <printf>:

void
printf(const char *fmt, ...)
{
    18ac:	fa010113          	add	sp,sp,-96
    18b0:	00113c23          	sd	ra,24(sp)
    18b4:	00813823          	sd	s0,16(sp)
    18b8:	02010413          	add	s0,sp,32
    18bc:	00b43423          	sd	a1,8(s0)
    18c0:	00c43823          	sd	a2,16(s0)
    18c4:	00d43c23          	sd	a3,24(s0)
    18c8:	02e43023          	sd	a4,32(s0)
    18cc:	02f43423          	sd	a5,40(s0)
    18d0:	03043823          	sd	a6,48(s0)
    18d4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    18d8:	00840613          	add	a2,s0,8
    18dc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    18e0:	00050593          	mv	a1,a0
    18e4:	00100513          	li	a0,1
    18e8:	00000097          	auipc	ra,0x0
    18ec:	cfc080e7          	jalr	-772(ra) # 15e4 <vprintf>
}
    18f0:	01813083          	ld	ra,24(sp)
    18f4:	01013403          	ld	s0,16(sp)
    18f8:	06010113          	add	sp,sp,96
    18fc:	00008067          	ret

0000000000001900 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1900:	ff010113          	add	sp,sp,-16
    1904:	00813423          	sd	s0,8(sp)
    1908:	01010413          	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    190c:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1910:	00000797          	auipc	a5,0x0
    1914:	7007b783          	ld	a5,1792(a5) # 2010 <freep>
    1918:	0400006f          	j	1958 <free+0x58>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    191c:	00862703          	lw	a4,8(a2)
    1920:	00b7073b          	addw	a4,a4,a1
    1924:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1928:	0007b703          	ld	a4,0(a5)
    192c:	00073603          	ld	a2,0(a4)
    1930:	0500006f          	j	1980 <free+0x80>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    1934:	ff852703          	lw	a4,-8(a0)
    1938:	00c7073b          	addw	a4,a4,a2
    193c:	00e7a423          	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    1940:	ff053683          	ld	a3,-16(a0)
    1944:	0540006f          	j	1998 <free+0x98>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1948:	0007b703          	ld	a4,0(a5)
    194c:	00e7e463          	bltu	a5,a4,1954 <free+0x54>
    1950:	00e6ec63          	bltu	a3,a4,1968 <free+0x68>
{
    1954:	00070793          	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1958:	fed7f8e3          	bgeu	a5,a3,1948 <free+0x48>
    195c:	0007b703          	ld	a4,0(a5)
    1960:	00e6e463          	bltu	a3,a4,1968 <free+0x68>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1964:	fee7e8e3          	bltu	a5,a4,1954 <free+0x54>
  if(bp + bp->s.size == p->s.ptr){
    1968:	ff852583          	lw	a1,-8(a0)
    196c:	0007b603          	ld	a2,0(a5)
    1970:	02059813          	sll	a6,a1,0x20
    1974:	01c85713          	srl	a4,a6,0x1c
    1978:	00e68733          	add	a4,a3,a4
    197c:	fae600e3          	beq	a2,a4,191c <free+0x1c>
    bp->s.ptr = p->s.ptr->s.ptr;
    1980:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    1984:	0087a603          	lw	a2,8(a5)
    1988:	02061593          	sll	a1,a2,0x20
    198c:	01c5d713          	srl	a4,a1,0x1c
    1990:	00e78733          	add	a4,a5,a4
    1994:	fae680e3          	beq	a3,a4,1934 <free+0x34>
    p->s.ptr = bp->s.ptr;
    1998:	00d7b023          	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    199c:	00000717          	auipc	a4,0x0
    19a0:	66f73a23          	sd	a5,1652(a4) # 2010 <freep>
}
    19a4:	00813403          	ld	s0,8(sp)
    19a8:	01010113          	add	sp,sp,16
    19ac:	00008067          	ret

00000000000019b0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    19b0:	fc010113          	add	sp,sp,-64
    19b4:	02113c23          	sd	ra,56(sp)
    19b8:	02813823          	sd	s0,48(sp)
    19bc:	02913423          	sd	s1,40(sp)
    19c0:	03213023          	sd	s2,32(sp)
    19c4:	01313c23          	sd	s3,24(sp)
    19c8:	01413823          	sd	s4,16(sp)
    19cc:	01513423          	sd	s5,8(sp)
    19d0:	01613023          	sd	s6,0(sp)
    19d4:	04010413          	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    19d8:	02051493          	sll	s1,a0,0x20
    19dc:	0204d493          	srl	s1,s1,0x20
    19e0:	00f48493          	add	s1,s1,15
    19e4:	0044d493          	srl	s1,s1,0x4
    19e8:	0014899b          	addw	s3,s1,1
    19ec:	00148493          	add	s1,s1,1
  if((prevp = freep) == 0){
    19f0:	00000517          	auipc	a0,0x0
    19f4:	62053503          	ld	a0,1568(a0) # 2010 <freep>
    19f8:	02050e63          	beqz	a0,1a34 <malloc+0x84>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    19fc:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1a00:	0087a703          	lw	a4,8(a5)
    1a04:	04977663          	bgeu	a4,s1,1a50 <malloc+0xa0>
  if(nu < 4096)
    1a08:	00098a13          	mv	s4,s3
    1a0c:	0009871b          	sext.w	a4,s3
    1a10:	000016b7          	lui	a3,0x1
    1a14:	00d77463          	bgeu	a4,a3,1a1c <malloc+0x6c>
    1a18:	00001a37          	lui	s4,0x1
    1a1c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1a20:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1a24:	00000917          	auipc	s2,0x0
    1a28:	5ec90913          	add	s2,s2,1516 # 2010 <freep>
  if(p == (char*)-1)
    1a2c:	fff00a93          	li	s5,-1
    1a30:	0a00006f          	j	1ad0 <malloc+0x120>
    base.s.ptr = freep = prevp = &base;
    1a34:	00000797          	auipc	a5,0x0
    1a38:	65478793          	add	a5,a5,1620 # 2088 <base>
    1a3c:	00000717          	auipc	a4,0x0
    1a40:	5cf73a23          	sd	a5,1492(a4) # 2010 <freep>
    1a44:	00f7b023          	sd	a5,0(a5)
    base.s.size = 0;
    1a48:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1a4c:	fbdff06f          	j	1a08 <malloc+0x58>
      if(p->s.size == nunits)
    1a50:	04e48863          	beq	s1,a4,1aa0 <malloc+0xf0>
        p->s.size -= nunits;
    1a54:	4137073b          	subw	a4,a4,s3
    1a58:	00e7a423          	sw	a4,8(a5)
        p += p->s.size;
    1a5c:	02071693          	sll	a3,a4,0x20
    1a60:	01c6d713          	srl	a4,a3,0x1c
    1a64:	00e787b3          	add	a5,a5,a4
        p->s.size = nunits;
    1a68:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1a6c:	00000717          	auipc	a4,0x0
    1a70:	5aa73223          	sd	a0,1444(a4) # 2010 <freep>
      return (void*)(p + 1);
    1a74:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    1a78:	03813083          	ld	ra,56(sp)
    1a7c:	03013403          	ld	s0,48(sp)
    1a80:	02813483          	ld	s1,40(sp)
    1a84:	02013903          	ld	s2,32(sp)
    1a88:	01813983          	ld	s3,24(sp)
    1a8c:	01013a03          	ld	s4,16(sp)
    1a90:	00813a83          	ld	s5,8(sp)
    1a94:	00013b03          	ld	s6,0(sp)
    1a98:	04010113          	add	sp,sp,64
    1a9c:	00008067          	ret
        prevp->s.ptr = p->s.ptr;
    1aa0:	0007b703          	ld	a4,0(a5)
    1aa4:	00e53023          	sd	a4,0(a0)
    1aa8:	fc5ff06f          	j	1a6c <malloc+0xbc>
  hp->s.size = nu;
    1aac:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    1ab0:	01050513          	add	a0,a0,16
    1ab4:	00000097          	auipc	ra,0x0
    1ab8:	e4c080e7          	jalr	-436(ra) # 1900 <free>
  return freep;
    1abc:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    1ac0:	fa050ce3          	beqz	a0,1a78 <malloc+0xc8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1ac4:	00053783          	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1ac8:	0087a703          	lw	a4,8(a5)
    1acc:	f89772e3          	bgeu	a4,s1,1a50 <malloc+0xa0>
    if(p == freep)
    1ad0:	00093703          	ld	a4,0(s2)
    1ad4:	00078513          	mv	a0,a5
    1ad8:	fef716e3          	bne	a4,a5,1ac4 <malloc+0x114>
  p = sbrk(nu * sizeof(Header));
    1adc:	000a0513          	mv	a0,s4
    1ae0:	00000097          	auipc	ra,0x0
    1ae4:	9bc080e7          	jalr	-1604(ra) # 149c <sbrk>
  if(p == (char*)-1)
    1ae8:	fd5512e3          	bne	a0,s5,1aac <malloc+0xfc>
        return 0;
    1aec:	00000513          	li	a0,0
    1af0:	f89ff06f          	j	1a78 <malloc+0xc8>
