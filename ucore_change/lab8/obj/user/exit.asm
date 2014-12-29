
obj/__user_exit.out:     file format elf32-tradlittlemips


Disassembly of section .text:

00800020 <__panic>:
#include <stdio.h>
#include <ulib.h>
#include <error.h>

void
__panic(const char *file, int line, const char *fmt, ...) {
  800020:	27bdffd8 	addiu	sp,sp,-40
  800024:	afbf0024 	sw	ra,36(sp)
  800028:	afbe0020 	sw	s8,32(sp)
  80002c:	03a0f021 	move	s8,sp
  800030:	afc40028 	sw	a0,40(s8)
  800034:	afc5002c 	sw	a1,44(s8)
  800038:	afc70034 	sw	a3,52(s8)
  80003c:	afc60030 	sw	a2,48(s8)
    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  800040:	27c20034 	addiu	v0,s8,52
  800044:	afc20018 	sw	v0,24(s8)
    cprintf("user panic at %s:%d:\n    ", file, line);
  800048:	3c020080 	lui	v0,0x80
  80004c:	24443050 	addiu	a0,v0,12368
  800050:	8fc50028 	lw	a1,40(s8)
  800054:	8fc6002c 	lw	a2,44(s8)
  800058:	0c2003a9 	jal	800ea4 <cprintf>
  80005c:	00000000 	nop
    vcprintf(fmt, ap);
  800060:	8fc20018 	lw	v0,24(s8)
  800064:	8fc40030 	lw	a0,48(s8)
  800068:	00402821 	move	a1,v0
  80006c:	0c200390 	jal	800e40 <vcprintf>
  800070:	00000000 	nop
    cprintf("\n");
  800074:	3c020080 	lui	v0,0x80
  800078:	2444306c 	addiu	a0,v0,12396
  80007c:	0c2003a9 	jal	800ea4 <cprintf>
  800080:	00000000 	nop
    va_end(ap);
    exit(-E_PANIC);
  800084:	2404fff6 	li	a0,-10
  800088:	0c2001d4 	jal	800750 <exit>
  80008c:	00000000 	nop

00800090 <__warn>:
}

void
__warn(const char *file, int line, const char *fmt, ...) {
  800090:	27bdffd8 	addiu	sp,sp,-40
  800094:	afbf0024 	sw	ra,36(sp)
  800098:	afbe0020 	sw	s8,32(sp)
  80009c:	03a0f021 	move	s8,sp
  8000a0:	afc40028 	sw	a0,40(s8)
  8000a4:	afc5002c 	sw	a1,44(s8)
  8000a8:	afc70034 	sw	a3,52(s8)
  8000ac:	afc60030 	sw	a2,48(s8)
    va_list ap;
    va_start(ap, fmt);
  8000b0:	27c20034 	addiu	v0,s8,52
  8000b4:	afc20018 	sw	v0,24(s8)
    cprintf("user warning at %s:%d:\n    ", file, line);
  8000b8:	3c020080 	lui	v0,0x80
  8000bc:	24443070 	addiu	a0,v0,12400
  8000c0:	8fc50028 	lw	a1,40(s8)
  8000c4:	8fc6002c 	lw	a2,44(s8)
  8000c8:	0c2003a9 	jal	800ea4 <cprintf>
  8000cc:	00000000 	nop
    vcprintf(fmt, ap);
  8000d0:	8fc20018 	lw	v0,24(s8)
  8000d4:	8fc40030 	lw	a0,48(s8)
  8000d8:	00402821 	move	a1,v0
  8000dc:	0c200390 	jal	800e40 <vcprintf>
  8000e0:	00000000 	nop
    cprintf("\n");
  8000e4:	3c020080 	lui	v0,0x80
  8000e8:	2444306c 	addiu	a0,v0,12396
  8000ec:	0c2003a9 	jal	800ea4 <cprintf>
  8000f0:	00000000 	nop
    va_end(ap);
}
  8000f4:	03c0e821 	move	sp,s8
  8000f8:	8fbf0024 	lw	ra,36(sp)
  8000fc:	8fbe0020 	lw	s8,32(sp)
  800100:	27bd0028 	addiu	sp,sp,40
  800104:	03e00008 	jr	ra
  800108:	00000000 	nop
  80010c:	00000000 	nop

00800110 <syscall>:
#define MAX_ARGS            5

uint32_t do_syscall(uint32_t arg0, uint32_t arg1, uint32_t arg2, uint32_t arg3, uint32_t arg4, uint32_t num);

static inline int
syscall(int num, ...) {
  800110:	27bdffb8 	addiu	sp,sp,-72
  800114:	afbf0044 	sw	ra,68(sp)
  800118:	afbe0040 	sw	s8,64(sp)
  80011c:	03a0f021 	move	s8,sp
  800120:	afc5004c 	sw	a1,76(s8)
  800124:	afc60050 	sw	a2,80(s8)
  800128:	afc70054 	sw	a3,84(s8)
  80012c:	afc40048 	sw	a0,72(s8)
    va_list ap;
    va_start(ap, num);
  800130:	27c2004c 	addiu	v0,s8,76
  800134:	afc20028 	sw	v0,40(s8)
    uint32_t a[MAX_ARGS];
    int i, ret;
    for (i = 0; i < MAX_ARGS; i ++) {
  800138:	afc00020 	sw	zero,32(s8)
  80013c:	0820005d 	j	800174 <syscall+0x64>
  800140:	00000000 	nop
        a[i] = va_arg(ap, uint32_t);
  800144:	8fc20028 	lw	v0,40(s8)
  800148:	24430004 	addiu	v1,v0,4
  80014c:	afc30028 	sw	v1,40(s8)
  800150:	8c430000 	lw	v1,0(v0)
  800154:	8fc20020 	lw	v0,32(s8)
  800158:	00021080 	sll	v0,v0,0x2
  80015c:	27c40020 	addiu	a0,s8,32
  800160:	00821021 	addu	v0,a0,v0
  800164:	ac43000c 	sw	v1,12(v0)
syscall(int num, ...) {
    va_list ap;
    va_start(ap, num);
    uint32_t a[MAX_ARGS];
    int i, ret;
    for (i = 0; i < MAX_ARGS; i ++) {
  800168:	8fc20020 	lw	v0,32(s8)
  80016c:	24420001 	addiu	v0,v0,1
  800170:	afc20020 	sw	v0,32(s8)
  800174:	8fc20020 	lw	v0,32(s8)
  800178:	28420005 	slti	v0,v0,5
  80017c:	1440fff1 	bnez	v0,800144 <syscall+0x34>
  800180:	00000000 	nop
        a[i] = va_arg(ap, uint32_t);
    }
    va_end(ap);

    ret = do_syscall(a[0], a[1], a[2], a[3], a[4], num);
  800184:	8fc4002c 	lw	a0,44(s8)
  800188:	8fc50030 	lw	a1,48(s8)
  80018c:	8fc30034 	lw	v1,52(s8)
  800190:	8fc20038 	lw	v0,56(s8)
  800194:	8fc7003c 	lw	a3,60(s8)
  800198:	8fc60048 	lw	a2,72(s8)
  80019c:	afa70010 	sw	a3,16(sp)
  8001a0:	afa60014 	sw	a2,20(sp)
  8001a4:	00603021 	move	a2,v1
  8001a8:	00403821 	move	a3,v0
  8001ac:	0c20028c 	jal	800a30 <do_syscall>
  8001b0:	00000000 	nop
  8001b4:	afc20024 	sw	v0,36(s8)
    return ret;
  8001b8:	8fc20024 	lw	v0,36(s8)
}
  8001bc:	03c0e821 	move	sp,s8
  8001c0:	8fbf0044 	lw	ra,68(sp)
  8001c4:	8fbe0040 	lw	s8,64(sp)
  8001c8:	27bd0048 	addiu	sp,sp,72
  8001cc:	03e00008 	jr	ra
  8001d0:	00000000 	nop

008001d4 <sys_exit>:

int
sys_exit(int error_code) {
  8001d4:	27bdffe0 	addiu	sp,sp,-32
  8001d8:	afbf001c 	sw	ra,28(sp)
  8001dc:	afbe0018 	sw	s8,24(sp)
  8001e0:	03a0f021 	move	s8,sp
  8001e4:	afc40020 	sw	a0,32(s8)
    return syscall(SYS_exit, error_code);
  8001e8:	24040001 	li	a0,1
  8001ec:	8fc50020 	lw	a1,32(s8)
  8001f0:	0c200044 	jal	800110 <syscall>
  8001f4:	00000000 	nop
}
  8001f8:	03c0e821 	move	sp,s8
  8001fc:	8fbf001c 	lw	ra,28(sp)
  800200:	8fbe0018 	lw	s8,24(sp)
  800204:	27bd0020 	addiu	sp,sp,32
  800208:	03e00008 	jr	ra
  80020c:	00000000 	nop

00800210 <sys_fork>:

int
sys_fork(void) {
  800210:	27bdffe0 	addiu	sp,sp,-32
  800214:	afbf001c 	sw	ra,28(sp)
  800218:	afbe0018 	sw	s8,24(sp)
  80021c:	03a0f021 	move	s8,sp
    return syscall(SYS_fork);
  800220:	24040002 	li	a0,2
  800224:	0c200044 	jal	800110 <syscall>
  800228:	00000000 	nop
}
  80022c:	03c0e821 	move	sp,s8
  800230:	8fbf001c 	lw	ra,28(sp)
  800234:	8fbe0018 	lw	s8,24(sp)
  800238:	27bd0020 	addiu	sp,sp,32
  80023c:	03e00008 	jr	ra
  800240:	00000000 	nop

00800244 <sys_wait>:

int
sys_wait(int pid, int *store) {
  800244:	27bdffe0 	addiu	sp,sp,-32
  800248:	afbf001c 	sw	ra,28(sp)
  80024c:	afbe0018 	sw	s8,24(sp)
  800250:	03a0f021 	move	s8,sp
  800254:	afc40020 	sw	a0,32(s8)
  800258:	afc50024 	sw	a1,36(s8)
    return syscall(SYS_wait, pid, store);
  80025c:	24040003 	li	a0,3
  800260:	8fc50020 	lw	a1,32(s8)
  800264:	8fc60024 	lw	a2,36(s8)
  800268:	0c200044 	jal	800110 <syscall>
  80026c:	00000000 	nop
}
  800270:	03c0e821 	move	sp,s8
  800274:	8fbf001c 	lw	ra,28(sp)
  800278:	8fbe0018 	lw	s8,24(sp)
  80027c:	27bd0020 	addiu	sp,sp,32
  800280:	03e00008 	jr	ra
  800284:	00000000 	nop

00800288 <sys_yield>:

int
sys_yield(void) {
  800288:	27bdffe0 	addiu	sp,sp,-32
  80028c:	afbf001c 	sw	ra,28(sp)
  800290:	afbe0018 	sw	s8,24(sp)
  800294:	03a0f021 	move	s8,sp
    return syscall(SYS_yield);
  800298:	2404000a 	li	a0,10
  80029c:	0c200044 	jal	800110 <syscall>
  8002a0:	00000000 	nop
}
  8002a4:	03c0e821 	move	sp,s8
  8002a8:	8fbf001c 	lw	ra,28(sp)
  8002ac:	8fbe0018 	lw	s8,24(sp)
  8002b0:	27bd0020 	addiu	sp,sp,32
  8002b4:	03e00008 	jr	ra
  8002b8:	00000000 	nop

008002bc <sys_kill>:

int
sys_kill(int pid) {
  8002bc:	27bdffe0 	addiu	sp,sp,-32
  8002c0:	afbf001c 	sw	ra,28(sp)
  8002c4:	afbe0018 	sw	s8,24(sp)
  8002c8:	03a0f021 	move	s8,sp
  8002cc:	afc40020 	sw	a0,32(s8)
    return syscall(SYS_kill, pid);
  8002d0:	2404000c 	li	a0,12
  8002d4:	8fc50020 	lw	a1,32(s8)
  8002d8:	0c200044 	jal	800110 <syscall>
  8002dc:	00000000 	nop
}
  8002e0:	03c0e821 	move	sp,s8
  8002e4:	8fbf001c 	lw	ra,28(sp)
  8002e8:	8fbe0018 	lw	s8,24(sp)
  8002ec:	27bd0020 	addiu	sp,sp,32
  8002f0:	03e00008 	jr	ra
  8002f4:	00000000 	nop

008002f8 <sys_getpid>:

int
sys_getpid(void) {
  8002f8:	27bdffe0 	addiu	sp,sp,-32
  8002fc:	afbf001c 	sw	ra,28(sp)
  800300:	afbe0018 	sw	s8,24(sp)
  800304:	03a0f021 	move	s8,sp
    return syscall(SYS_getpid);
  800308:	24040012 	li	a0,18
  80030c:	0c200044 	jal	800110 <syscall>
  800310:	00000000 	nop
}
  800314:	03c0e821 	move	sp,s8
  800318:	8fbf001c 	lw	ra,28(sp)
  80031c:	8fbe0018 	lw	s8,24(sp)
  800320:	27bd0020 	addiu	sp,sp,32
  800324:	03e00008 	jr	ra
  800328:	00000000 	nop

0080032c <sys_putc>:

int
sys_putc(int c) {
  80032c:	27bdffe0 	addiu	sp,sp,-32
  800330:	afbf001c 	sw	ra,28(sp)
  800334:	afbe0018 	sw	s8,24(sp)
  800338:	03a0f021 	move	s8,sp
  80033c:	afc40020 	sw	a0,32(s8)
    return syscall(SYS_putc, c);
  800340:	2404001e 	li	a0,30
  800344:	8fc50020 	lw	a1,32(s8)
  800348:	0c200044 	jal	800110 <syscall>
  80034c:	00000000 	nop
}
  800350:	03c0e821 	move	sp,s8
  800354:	8fbf001c 	lw	ra,28(sp)
  800358:	8fbe0018 	lw	s8,24(sp)
  80035c:	27bd0020 	addiu	sp,sp,32
  800360:	03e00008 	jr	ra
  800364:	00000000 	nop

00800368 <sys_pgdir>:

int
sys_pgdir(void) {
  800368:	27bdffe0 	addiu	sp,sp,-32
  80036c:	afbf001c 	sw	ra,28(sp)
  800370:	afbe0018 	sw	s8,24(sp)
  800374:	03a0f021 	move	s8,sp
    return syscall(SYS_pgdir);
  800378:	2404001f 	li	a0,31
  80037c:	0c200044 	jal	800110 <syscall>
  800380:	00000000 	nop
}
  800384:	03c0e821 	move	sp,s8
  800388:	8fbf001c 	lw	ra,28(sp)
  80038c:	8fbe0018 	lw	s8,24(sp)
  800390:	27bd0020 	addiu	sp,sp,32
  800394:	03e00008 	jr	ra
  800398:	00000000 	nop

0080039c <sys_lab6_set_priority>:

void
sys_lab6_set_priority(uint32_t priority)
{
  80039c:	27bdffe0 	addiu	sp,sp,-32
  8003a0:	afbf001c 	sw	ra,28(sp)
  8003a4:	afbe0018 	sw	s8,24(sp)
  8003a8:	03a0f021 	move	s8,sp
  8003ac:	afc40020 	sw	a0,32(s8)
    syscall(SYS_lab6_set_priority, priority);
  8003b0:	240400ff 	li	a0,255
  8003b4:	8fc50020 	lw	a1,32(s8)
  8003b8:	0c200044 	jal	800110 <syscall>
  8003bc:	00000000 	nop
}
  8003c0:	03c0e821 	move	sp,s8
  8003c4:	8fbf001c 	lw	ra,28(sp)
  8003c8:	8fbe0018 	lw	s8,24(sp)
  8003cc:	27bd0020 	addiu	sp,sp,32
  8003d0:	03e00008 	jr	ra
  8003d4:	00000000 	nop

008003d8 <sys_sleep>:

int
sys_sleep(unsigned int time) {
  8003d8:	27bdffe0 	addiu	sp,sp,-32
  8003dc:	afbf001c 	sw	ra,28(sp)
  8003e0:	afbe0018 	sw	s8,24(sp)
  8003e4:	03a0f021 	move	s8,sp
  8003e8:	afc40020 	sw	a0,32(s8)
    return syscall(SYS_sleep, time);
  8003ec:	2404000b 	li	a0,11
  8003f0:	8fc50020 	lw	a1,32(s8)
  8003f4:	0c200044 	jal	800110 <syscall>
  8003f8:	00000000 	nop
}
  8003fc:	03c0e821 	move	sp,s8
  800400:	8fbf001c 	lw	ra,28(sp)
  800404:	8fbe0018 	lw	s8,24(sp)
  800408:	27bd0020 	addiu	sp,sp,32
  80040c:	03e00008 	jr	ra
  800410:	00000000 	nop

00800414 <sys_gettime>:

int
sys_gettime(void) {
  800414:	27bdffe0 	addiu	sp,sp,-32
  800418:	afbf001c 	sw	ra,28(sp)
  80041c:	afbe0018 	sw	s8,24(sp)
  800420:	03a0f021 	move	s8,sp
    return syscall(SYS_gettime);
  800424:	24040011 	li	a0,17
  800428:	0c200044 	jal	800110 <syscall>
  80042c:	00000000 	nop
}
  800430:	03c0e821 	move	sp,s8
  800434:	8fbf001c 	lw	ra,28(sp)
  800438:	8fbe0018 	lw	s8,24(sp)
  80043c:	27bd0020 	addiu	sp,sp,32
  800440:	03e00008 	jr	ra
  800444:	00000000 	nop

00800448 <sys_exec>:

int
sys_exec(const char *name, int argc, const char **argv) {
  800448:	27bdffe0 	addiu	sp,sp,-32
  80044c:	afbf001c 	sw	ra,28(sp)
  800450:	afbe0018 	sw	s8,24(sp)
  800454:	03a0f021 	move	s8,sp
  800458:	afc40020 	sw	a0,32(s8)
  80045c:	afc50024 	sw	a1,36(s8)
  800460:	afc60028 	sw	a2,40(s8)
    return syscall(SYS_exec, name, argc, argv);
  800464:	24040004 	li	a0,4
  800468:	8fc50020 	lw	a1,32(s8)
  80046c:	8fc60024 	lw	a2,36(s8)
  800470:	8fc70028 	lw	a3,40(s8)
  800474:	0c200044 	jal	800110 <syscall>
  800478:	00000000 	nop
}
  80047c:	03c0e821 	move	sp,s8
  800480:	8fbf001c 	lw	ra,28(sp)
  800484:	8fbe0018 	lw	s8,24(sp)
  800488:	27bd0020 	addiu	sp,sp,32
  80048c:	03e00008 	jr	ra
  800490:	00000000 	nop

00800494 <sys_open>:

int
sys_open(const char *path, uint32_t open_flags) {
  800494:	27bdffe0 	addiu	sp,sp,-32
  800498:	afbf001c 	sw	ra,28(sp)
  80049c:	afbe0018 	sw	s8,24(sp)
  8004a0:	03a0f021 	move	s8,sp
  8004a4:	afc40020 	sw	a0,32(s8)
  8004a8:	afc50024 	sw	a1,36(s8)
    return syscall(SYS_open, path, open_flags);
  8004ac:	24040064 	li	a0,100
  8004b0:	8fc50020 	lw	a1,32(s8)
  8004b4:	8fc60024 	lw	a2,36(s8)
  8004b8:	0c200044 	jal	800110 <syscall>
  8004bc:	00000000 	nop
}
  8004c0:	03c0e821 	move	sp,s8
  8004c4:	8fbf001c 	lw	ra,28(sp)
  8004c8:	8fbe0018 	lw	s8,24(sp)
  8004cc:	27bd0020 	addiu	sp,sp,32
  8004d0:	03e00008 	jr	ra
  8004d4:	00000000 	nop

008004d8 <sys_close>:

int
sys_close(int fd) {
  8004d8:	27bdffe0 	addiu	sp,sp,-32
  8004dc:	afbf001c 	sw	ra,28(sp)
  8004e0:	afbe0018 	sw	s8,24(sp)
  8004e4:	03a0f021 	move	s8,sp
  8004e8:	afc40020 	sw	a0,32(s8)
    return syscall(SYS_close, fd);
  8004ec:	24040065 	li	a0,101
  8004f0:	8fc50020 	lw	a1,32(s8)
  8004f4:	0c200044 	jal	800110 <syscall>
  8004f8:	00000000 	nop
}
  8004fc:	03c0e821 	move	sp,s8
  800500:	8fbf001c 	lw	ra,28(sp)
  800504:	8fbe0018 	lw	s8,24(sp)
  800508:	27bd0020 	addiu	sp,sp,32
  80050c:	03e00008 	jr	ra
  800510:	00000000 	nop

00800514 <sys_read>:

int
sys_read(int fd, void *base, size_t len) {
  800514:	27bdffe0 	addiu	sp,sp,-32
  800518:	afbf001c 	sw	ra,28(sp)
  80051c:	afbe0018 	sw	s8,24(sp)
  800520:	03a0f021 	move	s8,sp
  800524:	afc40020 	sw	a0,32(s8)
  800528:	afc50024 	sw	a1,36(s8)
  80052c:	afc60028 	sw	a2,40(s8)
    return syscall(SYS_read, fd, base, len);
  800530:	24040066 	li	a0,102
  800534:	8fc50020 	lw	a1,32(s8)
  800538:	8fc60024 	lw	a2,36(s8)
  80053c:	8fc70028 	lw	a3,40(s8)
  800540:	0c200044 	jal	800110 <syscall>
  800544:	00000000 	nop
}
  800548:	03c0e821 	move	sp,s8
  80054c:	8fbf001c 	lw	ra,28(sp)
  800550:	8fbe0018 	lw	s8,24(sp)
  800554:	27bd0020 	addiu	sp,sp,32
  800558:	03e00008 	jr	ra
  80055c:	00000000 	nop

00800560 <sys_write>:

int
sys_write(int fd, void *base, size_t len) {
  800560:	27bdffe0 	addiu	sp,sp,-32
  800564:	afbf001c 	sw	ra,28(sp)
  800568:	afbe0018 	sw	s8,24(sp)
  80056c:	03a0f021 	move	s8,sp
  800570:	afc40020 	sw	a0,32(s8)
  800574:	afc50024 	sw	a1,36(s8)
  800578:	afc60028 	sw	a2,40(s8)
    return syscall(SYS_write, fd, base, len);
  80057c:	24040067 	li	a0,103
  800580:	8fc50020 	lw	a1,32(s8)
  800584:	8fc60024 	lw	a2,36(s8)
  800588:	8fc70028 	lw	a3,40(s8)
  80058c:	0c200044 	jal	800110 <syscall>
  800590:	00000000 	nop
}
  800594:	03c0e821 	move	sp,s8
  800598:	8fbf001c 	lw	ra,28(sp)
  80059c:	8fbe0018 	lw	s8,24(sp)
  8005a0:	27bd0020 	addiu	sp,sp,32
  8005a4:	03e00008 	jr	ra
  8005a8:	00000000 	nop

008005ac <sys_seek>:

int
sys_seek(int fd, off_t pos, int whence) {
  8005ac:	27bdffe0 	addiu	sp,sp,-32
  8005b0:	afbf001c 	sw	ra,28(sp)
  8005b4:	afbe0018 	sw	s8,24(sp)
  8005b8:	03a0f021 	move	s8,sp
  8005bc:	afc40020 	sw	a0,32(s8)
  8005c0:	afc50024 	sw	a1,36(s8)
  8005c4:	afc60028 	sw	a2,40(s8)
    return syscall(SYS_seek, fd, pos, whence);
  8005c8:	24040068 	li	a0,104
  8005cc:	8fc50020 	lw	a1,32(s8)
  8005d0:	8fc60024 	lw	a2,36(s8)
  8005d4:	8fc70028 	lw	a3,40(s8)
  8005d8:	0c200044 	jal	800110 <syscall>
  8005dc:	00000000 	nop
}
  8005e0:	03c0e821 	move	sp,s8
  8005e4:	8fbf001c 	lw	ra,28(sp)
  8005e8:	8fbe0018 	lw	s8,24(sp)
  8005ec:	27bd0020 	addiu	sp,sp,32
  8005f0:	03e00008 	jr	ra
  8005f4:	00000000 	nop

008005f8 <sys_fstat>:

int
sys_fstat(int fd, struct stat *stat) {
  8005f8:	27bdffe0 	addiu	sp,sp,-32
  8005fc:	afbf001c 	sw	ra,28(sp)
  800600:	afbe0018 	sw	s8,24(sp)
  800604:	03a0f021 	move	s8,sp
  800608:	afc40020 	sw	a0,32(s8)
  80060c:	afc50024 	sw	a1,36(s8)
    return syscall(SYS_fstat, fd, stat);
  800610:	2404006e 	li	a0,110
  800614:	8fc50020 	lw	a1,32(s8)
  800618:	8fc60024 	lw	a2,36(s8)
  80061c:	0c200044 	jal	800110 <syscall>
  800620:	00000000 	nop
}
  800624:	03c0e821 	move	sp,s8
  800628:	8fbf001c 	lw	ra,28(sp)
  80062c:	8fbe0018 	lw	s8,24(sp)
  800630:	27bd0020 	addiu	sp,sp,32
  800634:	03e00008 	jr	ra
  800638:	00000000 	nop

0080063c <sys_fsync>:

int
sys_fsync(int fd) {
  80063c:	27bdffe0 	addiu	sp,sp,-32
  800640:	afbf001c 	sw	ra,28(sp)
  800644:	afbe0018 	sw	s8,24(sp)
  800648:	03a0f021 	move	s8,sp
  80064c:	afc40020 	sw	a0,32(s8)
    return syscall(SYS_fsync, fd);
  800650:	2404006f 	li	a0,111
  800654:	8fc50020 	lw	a1,32(s8)
  800658:	0c200044 	jal	800110 <syscall>
  80065c:	00000000 	nop
}
  800660:	03c0e821 	move	sp,s8
  800664:	8fbf001c 	lw	ra,28(sp)
  800668:	8fbe0018 	lw	s8,24(sp)
  80066c:	27bd0020 	addiu	sp,sp,32
  800670:	03e00008 	jr	ra
  800674:	00000000 	nop

00800678 <sys_getcwd>:

int
sys_getcwd(char *buffer, size_t len) {
  800678:	27bdffe0 	addiu	sp,sp,-32
  80067c:	afbf001c 	sw	ra,28(sp)
  800680:	afbe0018 	sw	s8,24(sp)
  800684:	03a0f021 	move	s8,sp
  800688:	afc40020 	sw	a0,32(s8)
  80068c:	afc50024 	sw	a1,36(s8)
    return syscall(SYS_getcwd, buffer, len);
  800690:	24040079 	li	a0,121
  800694:	8fc50020 	lw	a1,32(s8)
  800698:	8fc60024 	lw	a2,36(s8)
  80069c:	0c200044 	jal	800110 <syscall>
  8006a0:	00000000 	nop
}
  8006a4:	03c0e821 	move	sp,s8
  8006a8:	8fbf001c 	lw	ra,28(sp)
  8006ac:	8fbe0018 	lw	s8,24(sp)
  8006b0:	27bd0020 	addiu	sp,sp,32
  8006b4:	03e00008 	jr	ra
  8006b8:	00000000 	nop

008006bc <sys_getdirentry>:

int
sys_getdirentry(int fd, struct dirent *dirent) {
  8006bc:	27bdffe0 	addiu	sp,sp,-32
  8006c0:	afbf001c 	sw	ra,28(sp)
  8006c4:	afbe0018 	sw	s8,24(sp)
  8006c8:	03a0f021 	move	s8,sp
  8006cc:	afc40020 	sw	a0,32(s8)
  8006d0:	afc50024 	sw	a1,36(s8)
    return syscall(SYS_getdirentry, fd, dirent);
  8006d4:	24040080 	li	a0,128
  8006d8:	8fc50020 	lw	a1,32(s8)
  8006dc:	8fc60024 	lw	a2,36(s8)
  8006e0:	0c200044 	jal	800110 <syscall>
  8006e4:	00000000 	nop
}
  8006e8:	03c0e821 	move	sp,s8
  8006ec:	8fbf001c 	lw	ra,28(sp)
  8006f0:	8fbe0018 	lw	s8,24(sp)
  8006f4:	27bd0020 	addiu	sp,sp,32
  8006f8:	03e00008 	jr	ra
  8006fc:	00000000 	nop

00800700 <sys_dup>:

int
sys_dup(int fd1, int fd2) {
  800700:	27bdffe0 	addiu	sp,sp,-32
  800704:	afbf001c 	sw	ra,28(sp)
  800708:	afbe0018 	sw	s8,24(sp)
  80070c:	03a0f021 	move	s8,sp
  800710:	afc40020 	sw	a0,32(s8)
  800714:	afc50024 	sw	a1,36(s8)
    return syscall(SYS_dup, fd1, fd2);
  800718:	24040082 	li	a0,130
  80071c:	8fc50020 	lw	a1,32(s8)
  800720:	8fc60024 	lw	a2,36(s8)
  800724:	0c200044 	jal	800110 <syscall>
  800728:	00000000 	nop
}
  80072c:	03c0e821 	move	sp,s8
  800730:	8fbf001c 	lw	ra,28(sp)
  800734:	8fbe0018 	lw	s8,24(sp)
  800738:	27bd0020 	addiu	sp,sp,32
  80073c:	03e00008 	jr	ra
  800740:	00000000 	nop
	...

00800750 <exit>:
#include <ulib.h>
#include <stat.h>
#include <string.h>

void
exit(int error_code) {
  800750:	27bdffe0 	addiu	sp,sp,-32
  800754:	afbf001c 	sw	ra,28(sp)
  800758:	afbe0018 	sw	s8,24(sp)
  80075c:	03a0f021 	move	s8,sp
  800760:	afc40020 	sw	a0,32(s8)
    sys_exit(error_code);
  800764:	8fc40020 	lw	a0,32(s8)
  800768:	0c200075 	jal	8001d4 <sys_exit>
  80076c:	00000000 	nop
    cprintf("BUG: exit failed.\n");
  800770:	3c020080 	lui	v0,0x80
  800774:	24443090 	addiu	a0,v0,12432
  800778:	0c2003a9 	jal	800ea4 <cprintf>
  80077c:	00000000 	nop
    while (1);
  800780:	082001e0 	j	800780 <exit+0x30>
  800784:	00000000 	nop

00800788 <fork>:
}

int
fork(void) {
  800788:	27bdffe0 	addiu	sp,sp,-32
  80078c:	afbf001c 	sw	ra,28(sp)
  800790:	afbe0018 	sw	s8,24(sp)
  800794:	03a0f021 	move	s8,sp
    return sys_fork();
  800798:	0c200084 	jal	800210 <sys_fork>
  80079c:	00000000 	nop
}
  8007a0:	03c0e821 	move	sp,s8
  8007a4:	8fbf001c 	lw	ra,28(sp)
  8007a8:	8fbe0018 	lw	s8,24(sp)
  8007ac:	27bd0020 	addiu	sp,sp,32
  8007b0:	03e00008 	jr	ra
  8007b4:	00000000 	nop

008007b8 <wait>:

int
wait(void) {
  8007b8:	27bdffe0 	addiu	sp,sp,-32
  8007bc:	afbf001c 	sw	ra,28(sp)
  8007c0:	afbe0018 	sw	s8,24(sp)
  8007c4:	03a0f021 	move	s8,sp
    return sys_wait(0, NULL);
  8007c8:	00002021 	move	a0,zero
  8007cc:	00002821 	move	a1,zero
  8007d0:	0c200091 	jal	800244 <sys_wait>
  8007d4:	00000000 	nop
}
  8007d8:	03c0e821 	move	sp,s8
  8007dc:	8fbf001c 	lw	ra,28(sp)
  8007e0:	8fbe0018 	lw	s8,24(sp)
  8007e4:	27bd0020 	addiu	sp,sp,32
  8007e8:	03e00008 	jr	ra
  8007ec:	00000000 	nop

008007f0 <waitpid>:

int
waitpid(int pid, int *store) {
  8007f0:	27bdffe0 	addiu	sp,sp,-32
  8007f4:	afbf001c 	sw	ra,28(sp)
  8007f8:	afbe0018 	sw	s8,24(sp)
  8007fc:	03a0f021 	move	s8,sp
  800800:	afc40020 	sw	a0,32(s8)
  800804:	afc50024 	sw	a1,36(s8)
    return sys_wait(pid, store);
  800808:	8fc40020 	lw	a0,32(s8)
  80080c:	8fc50024 	lw	a1,36(s8)
  800810:	0c200091 	jal	800244 <sys_wait>
  800814:	00000000 	nop
}
  800818:	03c0e821 	move	sp,s8
  80081c:	8fbf001c 	lw	ra,28(sp)
  800820:	8fbe0018 	lw	s8,24(sp)
  800824:	27bd0020 	addiu	sp,sp,32
  800828:	03e00008 	jr	ra
  80082c:	00000000 	nop

00800830 <yield>:

void
yield(void) {
  800830:	27bdffe0 	addiu	sp,sp,-32
  800834:	afbf001c 	sw	ra,28(sp)
  800838:	afbe0018 	sw	s8,24(sp)
  80083c:	03a0f021 	move	s8,sp
    sys_yield();
  800840:	0c2000a2 	jal	800288 <sys_yield>
  800844:	00000000 	nop
}
  800848:	03c0e821 	move	sp,s8
  80084c:	8fbf001c 	lw	ra,28(sp)
  800850:	8fbe0018 	lw	s8,24(sp)
  800854:	27bd0020 	addiu	sp,sp,32
  800858:	03e00008 	jr	ra
  80085c:	00000000 	nop

00800860 <kill>:

int
kill(int pid) {
  800860:	27bdffe0 	addiu	sp,sp,-32
  800864:	afbf001c 	sw	ra,28(sp)
  800868:	afbe0018 	sw	s8,24(sp)
  80086c:	03a0f021 	move	s8,sp
  800870:	afc40020 	sw	a0,32(s8)
    return sys_kill(pid);
  800874:	8fc40020 	lw	a0,32(s8)
  800878:	0c2000af 	jal	8002bc <sys_kill>
  80087c:	00000000 	nop
}
  800880:	03c0e821 	move	sp,s8
  800884:	8fbf001c 	lw	ra,28(sp)
  800888:	8fbe0018 	lw	s8,24(sp)
  80088c:	27bd0020 	addiu	sp,sp,32
  800890:	03e00008 	jr	ra
  800894:	00000000 	nop

00800898 <getpid>:

int
getpid(void) {
  800898:	27bdffe0 	addiu	sp,sp,-32
  80089c:	afbf001c 	sw	ra,28(sp)
  8008a0:	afbe0018 	sw	s8,24(sp)
  8008a4:	03a0f021 	move	s8,sp
    return sys_getpid();
  8008a8:	0c2000be 	jal	8002f8 <sys_getpid>
  8008ac:	00000000 	nop
}
  8008b0:	03c0e821 	move	sp,s8
  8008b4:	8fbf001c 	lw	ra,28(sp)
  8008b8:	8fbe0018 	lw	s8,24(sp)
  8008bc:	27bd0020 	addiu	sp,sp,32
  8008c0:	03e00008 	jr	ra
  8008c4:	00000000 	nop

008008c8 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  8008c8:	27bdffe0 	addiu	sp,sp,-32
  8008cc:	afbf001c 	sw	ra,28(sp)
  8008d0:	afbe0018 	sw	s8,24(sp)
  8008d4:	03a0f021 	move	s8,sp
    sys_pgdir();
  8008d8:	0c2000da 	jal	800368 <sys_pgdir>
  8008dc:	00000000 	nop
}
  8008e0:	03c0e821 	move	sp,s8
  8008e4:	8fbf001c 	lw	ra,28(sp)
  8008e8:	8fbe0018 	lw	s8,24(sp)
  8008ec:	27bd0020 	addiu	sp,sp,32
  8008f0:	03e00008 	jr	ra
  8008f4:	00000000 	nop

008008f8 <lab6_set_priority>:

void
lab6_set_priority(uint32_t priority)
{
  8008f8:	27bdffe0 	addiu	sp,sp,-32
  8008fc:	afbf001c 	sw	ra,28(sp)
  800900:	afbe0018 	sw	s8,24(sp)
  800904:	03a0f021 	move	s8,sp
  800908:	afc40020 	sw	a0,32(s8)
    sys_lab6_set_priority(priority);
  80090c:	8fc40020 	lw	a0,32(s8)
  800910:	0c2000e7 	jal	80039c <sys_lab6_set_priority>
  800914:	00000000 	nop
}
  800918:	03c0e821 	move	sp,s8
  80091c:	8fbf001c 	lw	ra,28(sp)
  800920:	8fbe0018 	lw	s8,24(sp)
  800924:	27bd0020 	addiu	sp,sp,32
  800928:	03e00008 	jr	ra
  80092c:	00000000 	nop

00800930 <sleep>:

int
sleep(unsigned int time) {
  800930:	27bdffe0 	addiu	sp,sp,-32
  800934:	afbf001c 	sw	ra,28(sp)
  800938:	afbe0018 	sw	s8,24(sp)
  80093c:	03a0f021 	move	s8,sp
  800940:	afc40020 	sw	a0,32(s8)
    return sys_sleep(time);
  800944:	8fc40020 	lw	a0,32(s8)
  800948:	0c2000f6 	jal	8003d8 <sys_sleep>
  80094c:	00000000 	nop
}
  800950:	03c0e821 	move	sp,s8
  800954:	8fbf001c 	lw	ra,28(sp)
  800958:	8fbe0018 	lw	s8,24(sp)
  80095c:	27bd0020 	addiu	sp,sp,32
  800960:	03e00008 	jr	ra
  800964:	00000000 	nop

00800968 <gettime_msec>:

unsigned int
gettime_msec(void) {
  800968:	27bdffe0 	addiu	sp,sp,-32
  80096c:	afbf001c 	sw	ra,28(sp)
  800970:	afbe0018 	sw	s8,24(sp)
  800974:	03a0f021 	move	s8,sp
    return (unsigned int)sys_gettime();
  800978:	0c200105 	jal	800414 <sys_gettime>
  80097c:	00000000 	nop
}
  800980:	03c0e821 	move	sp,s8
  800984:	8fbf001c 	lw	ra,28(sp)
  800988:	8fbe0018 	lw	s8,24(sp)
  80098c:	27bd0020 	addiu	sp,sp,32
  800990:	03e00008 	jr	ra
  800994:	00000000 	nop

00800998 <__exec>:

int
__exec(const char *name, const char **argv) {
  800998:	27bdffd8 	addiu	sp,sp,-40
  80099c:	afbf0024 	sw	ra,36(sp)
  8009a0:	afbe0020 	sw	s8,32(sp)
  8009a4:	03a0f021 	move	s8,sp
  8009a8:	afc40028 	sw	a0,40(s8)
  8009ac:	afc5002c 	sw	a1,44(s8)
    int argc = 0;
  8009b0:	afc00018 	sw	zero,24(s8)
    while (argv[argc] != NULL) {
  8009b4:	08200272 	j	8009c8 <__exec+0x30>
  8009b8:	00000000 	nop
        argc ++;
  8009bc:	8fc20018 	lw	v0,24(s8)
  8009c0:	24420001 	addiu	v0,v0,1
  8009c4:	afc20018 	sw	v0,24(s8)
}

int
__exec(const char *name, const char **argv) {
    int argc = 0;
    while (argv[argc] != NULL) {
  8009c8:	8fc20018 	lw	v0,24(s8)
  8009cc:	00021080 	sll	v0,v0,0x2
  8009d0:	8fc3002c 	lw	v1,44(s8)
  8009d4:	00621021 	addu	v0,v1,v0
  8009d8:	8c420000 	lw	v0,0(v0)
  8009dc:	1440fff7 	bnez	v0,8009bc <__exec+0x24>
  8009e0:	00000000 	nop
        argc ++;
    }
    return sys_exec(name, argc, argv);
  8009e4:	8fc40028 	lw	a0,40(s8)
  8009e8:	8fc50018 	lw	a1,24(s8)
  8009ec:	8fc6002c 	lw	a2,44(s8)
  8009f0:	0c200112 	jal	800448 <sys_exec>
  8009f4:	00000000 	nop
}
  8009f8:	03c0e821 	move	sp,s8
  8009fc:	8fbf0024 	lw	ra,36(sp)
  800a00:	8fbe0020 	lw	s8,32(sp)
  800a04:	27bd0028 	addiu	sp,sp,40
  800a08:	03e00008 	jr	ra
  800a0c:	00000000 	nop

00800a10 <_start>:
.text
.globl _start
_start:
    # load argc and argv
    # pass through load_icode
    addiu   $sp, $sp, -0x10
  800a10:	27bdfff0 0c20051c 00000000 08200287     ...'.. ....... .
	...

00800a30 <do_syscall>:
.text
.globl do_syscall
do_syscall:
    lw      $v1, 0x10($sp)
  800a30:	8fa30010 8fa20014 0000000c 03e00008     ................
	...

00800a50 <open>:
#include <stat.h>
#include <error.h>
#include <unistd.h>

int
open(const char *path, uint32_t open_flags) {
  800a50:	27bdffe0 	addiu	sp,sp,-32
  800a54:	afbf001c 	sw	ra,28(sp)
  800a58:	afbe0018 	sw	s8,24(sp)
  800a5c:	03a0f021 	move	s8,sp
  800a60:	afc40020 	sw	a0,32(s8)
  800a64:	afc50024 	sw	a1,36(s8)
    return sys_open(path, open_flags);
  800a68:	8fc40020 	lw	a0,32(s8)
  800a6c:	8fc50024 	lw	a1,36(s8)
  800a70:	0c200125 	jal	800494 <sys_open>
  800a74:	00000000 	nop
}
  800a78:	03c0e821 	move	sp,s8
  800a7c:	8fbf001c 	lw	ra,28(sp)
  800a80:	8fbe0018 	lw	s8,24(sp)
  800a84:	27bd0020 	addiu	sp,sp,32
  800a88:	03e00008 	jr	ra
  800a8c:	00000000 	nop

00800a90 <close>:

int
close(int fd) {
  800a90:	27bdffe0 	addiu	sp,sp,-32
  800a94:	afbf001c 	sw	ra,28(sp)
  800a98:	afbe0018 	sw	s8,24(sp)
  800a9c:	03a0f021 	move	s8,sp
  800aa0:	afc40020 	sw	a0,32(s8)
    return sys_close(fd);
  800aa4:	8fc40020 	lw	a0,32(s8)
  800aa8:	0c200136 	jal	8004d8 <sys_close>
  800aac:	00000000 	nop
}
  800ab0:	03c0e821 	move	sp,s8
  800ab4:	8fbf001c 	lw	ra,28(sp)
  800ab8:	8fbe0018 	lw	s8,24(sp)
  800abc:	27bd0020 	addiu	sp,sp,32
  800ac0:	03e00008 	jr	ra
  800ac4:	00000000 	nop

00800ac8 <read>:

int
read(int fd, void *base, size_t len) {
  800ac8:	27bdffe0 	addiu	sp,sp,-32
  800acc:	afbf001c 	sw	ra,28(sp)
  800ad0:	afbe0018 	sw	s8,24(sp)
  800ad4:	03a0f021 	move	s8,sp
  800ad8:	afc40020 	sw	a0,32(s8)
  800adc:	afc50024 	sw	a1,36(s8)
  800ae0:	afc60028 	sw	a2,40(s8)
    return sys_read(fd, base, len);
  800ae4:	8fc40020 	lw	a0,32(s8)
  800ae8:	8fc50024 	lw	a1,36(s8)
  800aec:	8fc60028 	lw	a2,40(s8)
  800af0:	0c200145 	jal	800514 <sys_read>
  800af4:	00000000 	nop
}
  800af8:	03c0e821 	move	sp,s8
  800afc:	8fbf001c 	lw	ra,28(sp)
  800b00:	8fbe0018 	lw	s8,24(sp)
  800b04:	27bd0020 	addiu	sp,sp,32
  800b08:	03e00008 	jr	ra
  800b0c:	00000000 	nop

00800b10 <write>:

int
write(int fd, void *base, size_t len) {
  800b10:	27bdffe0 	addiu	sp,sp,-32
  800b14:	afbf001c 	sw	ra,28(sp)
  800b18:	afbe0018 	sw	s8,24(sp)
  800b1c:	03a0f021 	move	s8,sp
  800b20:	afc40020 	sw	a0,32(s8)
  800b24:	afc50024 	sw	a1,36(s8)
  800b28:	afc60028 	sw	a2,40(s8)
    return sys_write(fd, base, len);
  800b2c:	8fc40020 	lw	a0,32(s8)
  800b30:	8fc50024 	lw	a1,36(s8)
  800b34:	8fc60028 	lw	a2,40(s8)
  800b38:	0c200158 	jal	800560 <sys_write>
  800b3c:	00000000 	nop
}
  800b40:	03c0e821 	move	sp,s8
  800b44:	8fbf001c 	lw	ra,28(sp)
  800b48:	8fbe0018 	lw	s8,24(sp)
  800b4c:	27bd0020 	addiu	sp,sp,32
  800b50:	03e00008 	jr	ra
  800b54:	00000000 	nop

00800b58 <seek>:

int
seek(int fd, off_t pos, int whence) {
  800b58:	27bdffe0 	addiu	sp,sp,-32
  800b5c:	afbf001c 	sw	ra,28(sp)
  800b60:	afbe0018 	sw	s8,24(sp)
  800b64:	03a0f021 	move	s8,sp
  800b68:	afc40020 	sw	a0,32(s8)
  800b6c:	afc50024 	sw	a1,36(s8)
  800b70:	afc60028 	sw	a2,40(s8)
    return sys_seek(fd, pos, whence);
  800b74:	8fc40020 	lw	a0,32(s8)
  800b78:	8fc50024 	lw	a1,36(s8)
  800b7c:	8fc60028 	lw	a2,40(s8)
  800b80:	0c20016b 	jal	8005ac <sys_seek>
  800b84:	00000000 	nop
}
  800b88:	03c0e821 	move	sp,s8
  800b8c:	8fbf001c 	lw	ra,28(sp)
  800b90:	8fbe0018 	lw	s8,24(sp)
  800b94:	27bd0020 	addiu	sp,sp,32
  800b98:	03e00008 	jr	ra
  800b9c:	00000000 	nop

00800ba0 <fstat>:

int
fstat(int fd, struct stat *stat) {
  800ba0:	27bdffe0 	addiu	sp,sp,-32
  800ba4:	afbf001c 	sw	ra,28(sp)
  800ba8:	afbe0018 	sw	s8,24(sp)
  800bac:	03a0f021 	move	s8,sp
  800bb0:	afc40020 	sw	a0,32(s8)
  800bb4:	afc50024 	sw	a1,36(s8)
    return sys_fstat(fd, stat);
  800bb8:	8fc40020 	lw	a0,32(s8)
  800bbc:	8fc50024 	lw	a1,36(s8)
  800bc0:	0c20017e 	jal	8005f8 <sys_fstat>
  800bc4:	00000000 	nop
}
  800bc8:	03c0e821 	move	sp,s8
  800bcc:	8fbf001c 	lw	ra,28(sp)
  800bd0:	8fbe0018 	lw	s8,24(sp)
  800bd4:	27bd0020 	addiu	sp,sp,32
  800bd8:	03e00008 	jr	ra
  800bdc:	00000000 	nop

00800be0 <fsync>:

int
fsync(int fd) {
  800be0:	27bdffe0 	addiu	sp,sp,-32
  800be4:	afbf001c 	sw	ra,28(sp)
  800be8:	afbe0018 	sw	s8,24(sp)
  800bec:	03a0f021 	move	s8,sp
  800bf0:	afc40020 	sw	a0,32(s8)
    return sys_fsync(fd);
  800bf4:	8fc40020 	lw	a0,32(s8)
  800bf8:	0c20018f 	jal	80063c <sys_fsync>
  800bfc:	00000000 	nop
}
  800c00:	03c0e821 	move	sp,s8
  800c04:	8fbf001c 	lw	ra,28(sp)
  800c08:	8fbe0018 	lw	s8,24(sp)
  800c0c:	27bd0020 	addiu	sp,sp,32
  800c10:	03e00008 	jr	ra
  800c14:	00000000 	nop

00800c18 <dup2>:

int
dup2(int fd1, int fd2) {
  800c18:	27bdffe0 	addiu	sp,sp,-32
  800c1c:	afbf001c 	sw	ra,28(sp)
  800c20:	afbe0018 	sw	s8,24(sp)
  800c24:	03a0f021 	move	s8,sp
  800c28:	afc40020 	sw	a0,32(s8)
  800c2c:	afc50024 	sw	a1,36(s8)
    return sys_dup(fd1, fd2);
  800c30:	8fc40020 	lw	a0,32(s8)
  800c34:	8fc50024 	lw	a1,36(s8)
  800c38:	0c2001c0 	jal	800700 <sys_dup>
  800c3c:	00000000 	nop
}
  800c40:	03c0e821 	move	sp,s8
  800c44:	8fbf001c 	lw	ra,28(sp)
  800c48:	8fbe0018 	lw	s8,24(sp)
  800c4c:	27bd0020 	addiu	sp,sp,32
  800c50:	03e00008 	jr	ra
  800c54:	00000000 	nop

00800c58 <transmode>:

static char
transmode(struct stat *stat) {
  800c58:	27bdffe8 	addiu	sp,sp,-24
  800c5c:	afbe0014 	sw	s8,20(sp)
  800c60:	03a0f021 	move	s8,sp
  800c64:	afc40018 	sw	a0,24(s8)
    uint32_t mode = stat->st_mode;
  800c68:	8fc20018 	lw	v0,24(s8)
  800c6c:	8c420000 	lw	v0,0(v0)
  800c70:	afc20008 	sw	v0,8(s8)
    if (S_ISREG(mode)) return 'r';
  800c74:	8fc20008 	lw	v0,8(s8)
  800c78:	30437000 	andi	v1,v0,0x7000
  800c7c:	24021000 	li	v0,4096
  800c80:	14620004 	bne	v1,v0,800c94 <transmode+0x3c>
  800c84:	00000000 	nop
  800c88:	24020072 	li	v0,114
  800c8c:	08200346 	j	800d18 <transmode+0xc0>
  800c90:	00000000 	nop
    if (S_ISDIR(mode)) return 'd';
  800c94:	8fc20008 	lw	v0,8(s8)
  800c98:	30437000 	andi	v1,v0,0x7000
  800c9c:	24022000 	li	v0,8192
  800ca0:	14620004 	bne	v1,v0,800cb4 <transmode+0x5c>
  800ca4:	00000000 	nop
  800ca8:	24020064 	li	v0,100
  800cac:	08200346 	j	800d18 <transmode+0xc0>
  800cb0:	00000000 	nop
    if (S_ISLNK(mode)) return 'l';
  800cb4:	8fc20008 	lw	v0,8(s8)
  800cb8:	30437000 	andi	v1,v0,0x7000
  800cbc:	24023000 	li	v0,12288
  800cc0:	14620004 	bne	v1,v0,800cd4 <transmode+0x7c>
  800cc4:	00000000 	nop
  800cc8:	2402006c 	li	v0,108
  800ccc:	08200346 	j	800d18 <transmode+0xc0>
  800cd0:	00000000 	nop
    if (S_ISCHR(mode)) return 'c';
  800cd4:	8fc20008 	lw	v0,8(s8)
  800cd8:	30437000 	andi	v1,v0,0x7000
  800cdc:	24024000 	li	v0,16384
  800ce0:	14620004 	bne	v1,v0,800cf4 <transmode+0x9c>
  800ce4:	00000000 	nop
  800ce8:	24020063 	li	v0,99
  800cec:	08200346 	j	800d18 <transmode+0xc0>
  800cf0:	00000000 	nop
    if (S_ISBLK(mode)) return 'b';
  800cf4:	8fc20008 	lw	v0,8(s8)
  800cf8:	30437000 	andi	v1,v0,0x7000
  800cfc:	24025000 	li	v0,20480
  800d00:	14620004 	bne	v1,v0,800d14 <transmode+0xbc>
  800d04:	00000000 	nop
  800d08:	24020062 	li	v0,98
  800d0c:	08200346 	j	800d18 <transmode+0xc0>
  800d10:	00000000 	nop
    return '-';
  800d14:	2402002d 	li	v0,45
}
  800d18:	03c0e821 	move	sp,s8
  800d1c:	8fbe0014 	lw	s8,20(sp)
  800d20:	27bd0018 	addiu	sp,sp,24
  800d24:	03e00008 	jr	ra
  800d28:	00000000 	nop

00800d2c <print_stat>:

void
print_stat(const char *name, int fd, struct stat *stat) {
  800d2c:	27bdffe0 	addiu	sp,sp,-32
  800d30:	afbf001c 	sw	ra,28(sp)
  800d34:	afbe0018 	sw	s8,24(sp)
  800d38:	03a0f021 	move	s8,sp
  800d3c:	afc40020 	sw	a0,32(s8)
  800d40:	afc50024 	sw	a1,36(s8)
  800d44:	afc60028 	sw	a2,40(s8)
    cprintf("[%03d] %s\n", fd, name);
  800d48:	3c020080 	lui	v0,0x80
  800d4c:	244430b0 	addiu	a0,v0,12464
  800d50:	8fc50024 	lw	a1,36(s8)
  800d54:	8fc60020 	lw	a2,32(s8)
  800d58:	0c2003a9 	jal	800ea4 <cprintf>
  800d5c:	00000000 	nop
    cprintf("    mode    : %c\n", transmode(stat));
  800d60:	8fc40028 	lw	a0,40(s8)
  800d64:	0c200316 	jal	800c58 <transmode>
  800d68:	00000000 	nop
  800d6c:	3c030080 	lui	v1,0x80
  800d70:	246430bc 	addiu	a0,v1,12476
  800d74:	00402821 	move	a1,v0
  800d78:	0c2003a9 	jal	800ea4 <cprintf>
  800d7c:	00000000 	nop
    cprintf("    links   : %lu\n", stat->st_nlinks);
  800d80:	8fc20028 	lw	v0,40(s8)
  800d84:	8c420004 	lw	v0,4(v0)
  800d88:	3c030080 	lui	v1,0x80
  800d8c:	246430d0 	addiu	a0,v1,12496
  800d90:	00402821 	move	a1,v0
  800d94:	0c2003a9 	jal	800ea4 <cprintf>
  800d98:	00000000 	nop
    cprintf("    blocks  : %lu\n", stat->st_blocks);
  800d9c:	8fc20028 	lw	v0,40(s8)
  800da0:	8c420008 	lw	v0,8(v0)
  800da4:	3c030080 	lui	v1,0x80
  800da8:	246430e4 	addiu	a0,v1,12516
  800dac:	00402821 	move	a1,v0
  800db0:	0c2003a9 	jal	800ea4 <cprintf>
  800db4:	00000000 	nop
    cprintf("    size    : %lu\n", stat->st_size);
  800db8:	8fc20028 	lw	v0,40(s8)
  800dbc:	8c42000c 	lw	v0,12(v0)
  800dc0:	3c030080 	lui	v1,0x80
  800dc4:	246430f8 	addiu	a0,v1,12536
  800dc8:	00402821 	move	a1,v0
  800dcc:	0c2003a9 	jal	800ea4 <cprintf>
  800dd0:	00000000 	nop
}
  800dd4:	03c0e821 	move	sp,s8
  800dd8:	8fbf001c 	lw	ra,28(sp)
  800ddc:	8fbe0018 	lw	s8,24(sp)
  800de0:	27bd0020 	addiu	sp,sp,32
  800de4:	03e00008 	jr	ra
  800de8:	00000000 	nop
  800dec:	00000000 	nop

00800df0 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  800df0:	27bdffe0 	addiu	sp,sp,-32
  800df4:	afbf001c 	sw	ra,28(sp)
  800df8:	afbe0018 	sw	s8,24(sp)
  800dfc:	03a0f021 	move	s8,sp
  800e00:	afc40020 	sw	a0,32(s8)
  800e04:	afc50024 	sw	a1,36(s8)
    sys_putc(c);
  800e08:	8fc40020 	lw	a0,32(s8)
  800e0c:	0c2000cb 	jal	80032c <sys_putc>
  800e10:	00000000 	nop
    (*cnt) ++;
  800e14:	8fc20024 	lw	v0,36(s8)
  800e18:	8c420000 	lw	v0,0(v0)
  800e1c:	24430001 	addiu	v1,v0,1
  800e20:	8fc20024 	lw	v0,36(s8)
  800e24:	ac430000 	sw	v1,0(v0)
}
  800e28:	03c0e821 	move	sp,s8
  800e2c:	8fbf001c 	lw	ra,28(sp)
  800e30:	8fbe0018 	lw	s8,24(sp)
  800e34:	27bd0020 	addiu	sp,sp,32
  800e38:	03e00008 	jr	ra
  800e3c:	00000000 	nop

00800e40 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  800e40:	27bdffd0 	addiu	sp,sp,-48
  800e44:	afbf002c 	sw	ra,44(sp)
  800e48:	afbe0028 	sw	s8,40(sp)
  800e4c:	03a0f021 	move	s8,sp
  800e50:	afc40030 	sw	a0,48(s8)
  800e54:	afc50034 	sw	a1,52(s8)
    int cnt = 0;
  800e58:	afc00020 	sw	zero,32(s8)
    vprintfmt((void*)cputch, NO_FD, &cnt, fmt, ap);
  800e5c:	8fc20034 	lw	v0,52(s8)
  800e60:	afa20010 	sw	v0,16(sp)
  800e64:	3c020080 	lui	v0,0x80
  800e68:	24440df0 	addiu	a0,v0,3568
  800e6c:	3c02ffff 	lui	v0,0xffff
  800e70:	34456ad9 	ori	a1,v0,0x6ad9
  800e74:	27c20020 	addiu	v0,s8,32
  800e78:	00403021 	move	a2,v0
  800e7c:	8fc70030 	lw	a3,48(s8)
  800e80:	0c200943 	jal	80250c <vprintfmt>
  800e84:	00000000 	nop
    return cnt;
  800e88:	8fc20020 	lw	v0,32(s8)
}
  800e8c:	03c0e821 	move	sp,s8
  800e90:	8fbf002c 	lw	ra,44(sp)
  800e94:	8fbe0028 	lw	s8,40(sp)
  800e98:	27bd0030 	addiu	sp,sp,48
  800e9c:	03e00008 	jr	ra
  800ea0:	00000000 	nop

00800ea4 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  800ea4:	27bdffd8 	addiu	sp,sp,-40
  800ea8:	afbf0024 	sw	ra,36(sp)
  800eac:	afbe0020 	sw	s8,32(sp)
  800eb0:	03a0f021 	move	s8,sp
  800eb4:	afc5002c 	sw	a1,44(s8)
  800eb8:	afc60030 	sw	a2,48(s8)
  800ebc:	afc70034 	sw	a3,52(s8)
  800ec0:	afc40028 	sw	a0,40(s8)
    va_list ap;

    va_start(ap, fmt);
  800ec4:	27c2002c 	addiu	v0,s8,44
  800ec8:	afc2001c 	sw	v0,28(s8)
    int cnt = vcprintf(fmt, ap);
  800ecc:	8fc2001c 	lw	v0,28(s8)
  800ed0:	8fc40028 	lw	a0,40(s8)
  800ed4:	00402821 	move	a1,v0
  800ed8:	0c200390 	jal	800e40 <vcprintf>
  800edc:	00000000 	nop
  800ee0:	afc20018 	sw	v0,24(s8)
    va_end(ap);

    return cnt;
  800ee4:	8fc20018 	lw	v0,24(s8)
}
  800ee8:	03c0e821 	move	sp,s8
  800eec:	8fbf0024 	lw	ra,36(sp)
  800ef0:	8fbe0020 	lw	s8,32(sp)
  800ef4:	27bd0028 	addiu	sp,sp,40
  800ef8:	03e00008 	jr	ra
  800efc:	00000000 	nop

00800f00 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  800f00:	27bdffd8 	addiu	sp,sp,-40
  800f04:	afbf0024 	sw	ra,36(sp)
  800f08:	afbe0020 	sw	s8,32(sp)
  800f0c:	03a0f021 	move	s8,sp
  800f10:	afc40028 	sw	a0,40(s8)
    int cnt = 0;
  800f14:	afc0001c 	sw	zero,28(s8)
    char c;
    while ((c = *str ++) != '\0') {
  800f18:	082003ce 	j	800f38 <cputs+0x38>
  800f1c:	00000000 	nop
        cputch(c, &cnt);
  800f20:	83c30018 	lb	v1,24(s8)
  800f24:	27c2001c 	addiu	v0,s8,28
  800f28:	00602021 	move	a0,v1
  800f2c:	00402821 	move	a1,v0
  800f30:	0c20037c 	jal	800df0 <cputch>
  800f34:	00000000 	nop
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  800f38:	8fc20028 	lw	v0,40(s8)
  800f3c:	24430001 	addiu	v1,v0,1
  800f40:	afc30028 	sw	v1,40(s8)
  800f44:	90420000 	lbu	v0,0(v0)
  800f48:	a3c20018 	sb	v0,24(s8)
  800f4c:	83c20018 	lb	v0,24(s8)
  800f50:	1440fff3 	bnez	v0,800f20 <cputs+0x20>
  800f54:	00000000 	nop
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  800f58:	27c2001c 	addiu	v0,s8,28
  800f5c:	2404000a 	li	a0,10
  800f60:	00402821 	move	a1,v0
  800f64:	0c20037c 	jal	800df0 <cputch>
  800f68:	00000000 	nop
    return cnt;
  800f6c:	8fc2001c 	lw	v0,28(s8)
}
  800f70:	03c0e821 	move	sp,s8
  800f74:	8fbf0024 	lw	ra,36(sp)
  800f78:	8fbe0020 	lw	s8,32(sp)
  800f7c:	27bd0028 	addiu	sp,sp,40
  800f80:	03e00008 	jr	ra
  800f84:	00000000 	nop

00800f88 <fputch>:


static void
fputch(char c, int *cnt, int fd) {
  800f88:	27bdffe0 	addiu	sp,sp,-32
  800f8c:	afbf001c 	sw	ra,28(sp)
  800f90:	afbe0018 	sw	s8,24(sp)
  800f94:	03a0f021 	move	s8,sp
  800f98:	00801021 	move	v0,a0
  800f9c:	afc50024 	sw	a1,36(s8)
  800fa0:	afc60028 	sw	a2,40(s8)
  800fa4:	a3c20020 	sb	v0,32(s8)
    write(fd, &c, sizeof(char));
  800fa8:	8fc40028 	lw	a0,40(s8)
  800fac:	27c50020 	addiu	a1,s8,32
  800fb0:	24060001 	li	a2,1
  800fb4:	0c2002c4 	jal	800b10 <write>
  800fb8:	00000000 	nop
    (*cnt) ++;
  800fbc:	8fc20024 	lw	v0,36(s8)
  800fc0:	8c420000 	lw	v0,0(v0)
  800fc4:	24430001 	addiu	v1,v0,1
  800fc8:	8fc20024 	lw	v0,36(s8)
  800fcc:	ac430000 	sw	v1,0(v0)
}
  800fd0:	03c0e821 	move	sp,s8
  800fd4:	8fbf001c 	lw	ra,28(sp)
  800fd8:	8fbe0018 	lw	s8,24(sp)
  800fdc:	27bd0020 	addiu	sp,sp,32
  800fe0:	03e00008 	jr	ra
  800fe4:	00000000 	nop

00800fe8 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap) {
  800fe8:	27bdffd0 	addiu	sp,sp,-48
  800fec:	afbf002c 	sw	ra,44(sp)
  800ff0:	afbe0028 	sw	s8,40(sp)
  800ff4:	03a0f021 	move	s8,sp
  800ff8:	afc40030 	sw	a0,48(s8)
  800ffc:	afc50034 	sw	a1,52(s8)
  801000:	afc60038 	sw	a2,56(s8)
    int cnt = 0;
  801004:	afc00020 	sw	zero,32(s8)
    vprintfmt((void*)fputch, fd, &cnt, fmt, ap);
  801008:	8fc20038 	lw	v0,56(s8)
  80100c:	afa20010 	sw	v0,16(sp)
  801010:	3c020080 	lui	v0,0x80
  801014:	24440f88 	addiu	a0,v0,3976
  801018:	8fc50030 	lw	a1,48(s8)
  80101c:	27c20020 	addiu	v0,s8,32
  801020:	00403021 	move	a2,v0
  801024:	8fc70034 	lw	a3,52(s8)
  801028:	0c200943 	jal	80250c <vprintfmt>
  80102c:	00000000 	nop
    return cnt;
  801030:	8fc20020 	lw	v0,32(s8)
}
  801034:	03c0e821 	move	sp,s8
  801038:	8fbf002c 	lw	ra,44(sp)
  80103c:	8fbe0028 	lw	s8,40(sp)
  801040:	27bd0030 	addiu	sp,sp,48
  801044:	03e00008 	jr	ra
  801048:	00000000 	nop

0080104c <fprintf>:

int
fprintf(int fd, const char *fmt, ...) {
  80104c:	27bdffd8 	addiu	sp,sp,-40
  801050:	afbf0024 	sw	ra,36(sp)
  801054:	afbe0020 	sw	s8,32(sp)
  801058:	03a0f021 	move	s8,sp
  80105c:	afc40028 	sw	a0,40(s8)
  801060:	afc60030 	sw	a2,48(s8)
  801064:	afc70034 	sw	a3,52(s8)
  801068:	afc5002c 	sw	a1,44(s8)
    va_list ap;

    va_start(ap, fmt);
  80106c:	27c20030 	addiu	v0,s8,48
  801070:	afc2001c 	sw	v0,28(s8)
    int cnt = vfprintf(fd, fmt, ap);
  801074:	8fc2001c 	lw	v0,28(s8)
  801078:	8fc40028 	lw	a0,40(s8)
  80107c:	8fc5002c 	lw	a1,44(s8)
  801080:	00403021 	move	a2,v0
  801084:	0c2003fa 	jal	800fe8 <vfprintf>
  801088:	00000000 	nop
  80108c:	afc20018 	sw	v0,24(s8)
    va_end(ap);

    return cnt;
  801090:	8fc20018 	lw	v0,24(s8)
}
  801094:	03c0e821 	move	sp,s8
  801098:	8fbf0024 	lw	ra,36(sp)
  80109c:	8fbe0020 	lw	s8,32(sp)
  8010a0:	27bd0028 	addiu	sp,sp,40
  8010a4:	03e00008 	jr	ra
  8010a8:	00000000 	nop
  8010ac:	00000000 	nop

008010b0 <_Alloc>:
#include <defs.h>
#include <stdio.h>
#include <ulib.h>

int _Alloc(int n) {
  8010b0:	27bdfff8 	addiu	sp,sp,-8
  8010b4:	afbe0004 	sw	s8,4(sp)
  8010b8:	03a0f021 	move	s8,sp
  8010bc:	afc40008 	sw	a0,8(s8)
    return 0;
  8010c0:	00001021 	move	v0,zero
}
  8010c4:	03c0e821 	move	sp,s8
  8010c8:	8fbe0004 	lw	s8,4(sp)
  8010cc:	27bd0008 	addiu	sp,sp,8
  8010d0:	03e00008 	jr	ra
  8010d4:	00000000 	nop

008010d8 <_PrintInt>:
void _PrintInt(int x) {
  8010d8:	27bdffe0 	addiu	sp,sp,-32
  8010dc:	afbf001c 	sw	ra,28(sp)
  8010e0:	afbe0018 	sw	s8,24(sp)
  8010e4:	03a0f021 	move	s8,sp
  8010e8:	afc40020 	sw	a0,32(s8)
    cprintf("%d", x);
  8010ec:	3c020080 	lui	v0,0x80
  8010f0:	24443110 	addiu	a0,v0,12560
  8010f4:	8fc50020 	lw	a1,32(s8)
  8010f8:	0c2003a9 	jal	800ea4 <cprintf>
  8010fc:	00000000 	nop
}
  801100:	03c0e821 	move	sp,s8
  801104:	8fbf001c 	lw	ra,28(sp)
  801108:	8fbe0018 	lw	s8,24(sp)
  80110c:	27bd0020 	addiu	sp,sp,32
  801110:	03e00008 	jr	ra
  801114:	00000000 	nop

00801118 <_PrintChar>:
void _PrintChar(char x) {
  801118:	27bdffe0 	addiu	sp,sp,-32
  80111c:	afbf001c 	sw	ra,28(sp)
  801120:	afbe0018 	sw	s8,24(sp)
  801124:	03a0f021 	move	s8,sp
  801128:	00801021 	move	v0,a0
  80112c:	a3c20020 	sb	v0,32(s8)
    cprintf("%c", x);
  801130:	83c20020 	lb	v0,32(s8)
  801134:	3c030080 	lui	v1,0x80
  801138:	24643114 	addiu	a0,v1,12564
  80113c:	00402821 	move	a1,v0
  801140:	0c2003a9 	jal	800ea4 <cprintf>
  801144:	00000000 	nop
}
  801148:	03c0e821 	move	sp,s8
  80114c:	8fbf001c 	lw	ra,28(sp)
  801150:	8fbe0018 	lw	s8,24(sp)
  801154:	27bd0020 	addiu	sp,sp,32
  801158:	03e00008 	jr	ra
  80115c:	00000000 	nop

00801160 <_PrintString>:
void _PrintString(const char* x) {
  801160:	27bdffe0 	addiu	sp,sp,-32
  801164:	afbf001c 	sw	ra,28(sp)
  801168:	afbe0018 	sw	s8,24(sp)
  80116c:	03a0f021 	move	s8,sp
  801170:	afc40020 	sw	a0,32(s8)
    cprintf("%s", x);
  801174:	3c020080 	lui	v0,0x80
  801178:	24443118 	addiu	a0,v0,12568
  80117c:	8fc50020 	lw	a1,32(s8)
  801180:	0c2003a9 	jal	800ea4 <cprintf>
  801184:	00000000 	nop
}
  801188:	03c0e821 	move	sp,s8
  80118c:	8fbf001c 	lw	ra,28(sp)
  801190:	8fbe0018 	lw	s8,24(sp)
  801194:	27bd0020 	addiu	sp,sp,32
  801198:	03e00008 	jr	ra
  80119c:	00000000 	nop

008011a0 <_PrintBool>:
void _PrintBool(bool x) {
  8011a0:	27bdffe0 	addiu	sp,sp,-32
  8011a4:	afbf001c 	sw	ra,28(sp)
  8011a8:	afbe0018 	sw	s8,24(sp)
  8011ac:	03a0f021 	move	s8,sp
  8011b0:	afc40020 	sw	a0,32(s8)
    if (x)
  8011b4:	8fc20020 	lw	v0,32(s8)
  8011b8:	10400007 	beqz	v0,8011d8 <_PrintBool+0x38>
  8011bc:	00000000 	nop
        cprintf("true");
  8011c0:	3c020080 	lui	v0,0x80
  8011c4:	2444311c 	addiu	a0,v0,12572
  8011c8:	0c2003a9 	jal	800ea4 <cprintf>
  8011cc:	00000000 	nop
  8011d0:	0820047a 	j	8011e8 <_PrintBool+0x48>
  8011d4:	00000000 	nop
    else
        cprintf("false");
  8011d8:	3c020080 	lui	v0,0x80
  8011dc:	24443124 	addiu	a0,v0,12580
  8011e0:	0c2003a9 	jal	800ea4 <cprintf>
  8011e4:	00000000 	nop
}
  8011e8:	03c0e821 	move	sp,s8
  8011ec:	8fbf001c 	lw	ra,28(sp)
  8011f0:	8fbe0018 	lw	s8,24(sp)
  8011f4:	27bd0020 	addiu	sp,sp,32
  8011f8:	03e00008 	jr	ra
  8011fc:	00000000 	nop

00801200 <_Halt>:
void __noreturn _Halt(void) {
  801200:	27bdffe0 	addiu	sp,sp,-32
  801204:	afbf001c 	sw	ra,28(sp)
  801208:	afbe0018 	sw	s8,24(sp)
  80120c:	03a0f021 	move	s8,sp
    exit(0);
  801210:	00002021 	move	a0,zero
  801214:	0c2001d4 	jal	800750 <exit>
  801218:	00000000 	nop
  80121c:	00000000 	nop

00801220 <opendir>:
#include <error.h>
#include <unistd.h>

DIR dir, *dirp=&dir;
DIR *
opendir(const char *path) {
  801220:	27bdffc0 	addiu	sp,sp,-64
  801224:	afbf003c 	sw	ra,60(sp)
  801228:	afbe0038 	sw	s8,56(sp)
  80122c:	afb00034 	sw	s0,52(sp)
  801230:	03a0f021 	move	s8,sp
  801234:	afc40040 	sw	a0,64(s8)

    if ((dirp->fd = open(path, O_RDONLY)) < 0) {
  801238:	3c020080 	lui	v0,0x80
  80123c:	8c504000 	lw	s0,16384(v0)
  801240:	8fc40040 	lw	a0,64(s8)
  801244:	00002821 	move	a1,zero
  801248:	0c200294 	jal	800a50 <open>
  80124c:	00000000 	nop
  801250:	ae020000 	sw	v0,0(s0)
  801254:	8e020000 	lw	v0,0(s0)
  801258:	04410003 	bgez	v0,801268 <opendir+0x48>
  80125c:	00000000 	nop
        goto failed;
  801260:	082004b2 	j	8012c8 <opendir+0xa8>
  801264:	00000000 	nop
    }
    struct stat __stat, *stat = &__stat;
  801268:	27c2001c 	addiu	v0,s8,28
  80126c:	afc20018 	sw	v0,24(s8)
    if (fstat(dirp->fd, stat) != 0 || !S_ISDIR(stat->st_mode)) {
  801270:	3c020080 	lui	v0,0x80
  801274:	8c424000 	lw	v0,16384(v0)
  801278:	8c420000 	lw	v0,0(v0)
  80127c:	00402021 	move	a0,v0
  801280:	8fc50018 	lw	a1,24(s8)
  801284:	0c2002e8 	jal	800ba0 <fstat>
  801288:	00000000 	nop
  80128c:	1440000e 	bnez	v0,8012c8 <opendir+0xa8>
  801290:	00000000 	nop
  801294:	8fc20018 	lw	v0,24(s8)
  801298:	8c420000 	lw	v0,0(v0)
  80129c:	30437000 	andi	v1,v0,0x7000
  8012a0:	24022000 	li	v0,8192
  8012a4:	14620008 	bne	v1,v0,8012c8 <opendir+0xa8>
  8012a8:	00000000 	nop
        goto failed;
    }
    dirp->dirent.offset = 0;
  8012ac:	3c020080 	lui	v0,0x80
  8012b0:	8c424000 	lw	v0,16384(v0)
  8012b4:	ac400004 	sw	zero,4(v0)
    return dirp;
  8012b8:	3c020080 	lui	v0,0x80
  8012bc:	8c424000 	lw	v0,16384(v0)
  8012c0:	082004b3 	j	8012cc <opendir+0xac>
  8012c4:	00000000 	nop

failed:
    return NULL;
  8012c8:	00001021 	move	v0,zero
}
  8012cc:	03c0e821 	move	sp,s8
  8012d0:	8fbf003c 	lw	ra,60(sp)
  8012d4:	8fbe0038 	lw	s8,56(sp)
  8012d8:	8fb00034 	lw	s0,52(sp)
  8012dc:	27bd0040 	addiu	sp,sp,64
  8012e0:	03e00008 	jr	ra
  8012e4:	00000000 	nop

008012e8 <readdir>:

struct dirent *
readdir(DIR *dirp) {
  8012e8:	27bdffe0 	addiu	sp,sp,-32
  8012ec:	afbf001c 	sw	ra,28(sp)
  8012f0:	afbe0018 	sw	s8,24(sp)
  8012f4:	03a0f021 	move	s8,sp
  8012f8:	afc40020 	sw	a0,32(s8)
    if (sys_getdirentry(dirp->fd, &(dirp->dirent)) == 0) {
  8012fc:	8fc20020 	lw	v0,32(s8)
  801300:	8c430000 	lw	v1,0(v0)
  801304:	8fc20020 	lw	v0,32(s8)
  801308:	24420004 	addiu	v0,v0,4
  80130c:	00602021 	move	a0,v1
  801310:	00402821 	move	a1,v0
  801314:	0c2001af 	jal	8006bc <sys_getdirentry>
  801318:	00000000 	nop
  80131c:	14400005 	bnez	v0,801334 <readdir+0x4c>
  801320:	00000000 	nop
        return &(dirp->dirent);
  801324:	8fc20020 	lw	v0,32(s8)
  801328:	24420004 	addiu	v0,v0,4
  80132c:	082004ce 	j	801338 <readdir+0x50>
  801330:	00000000 	nop
    }
    return NULL;
  801334:	00001021 	move	v0,zero
}
  801338:	03c0e821 	move	sp,s8
  80133c:	8fbf001c 	lw	ra,28(sp)
  801340:	8fbe0018 	lw	s8,24(sp)
  801344:	27bd0020 	addiu	sp,sp,32
  801348:	03e00008 	jr	ra
  80134c:	00000000 	nop

00801350 <closedir>:

void
closedir(DIR *dirp) {
  801350:	27bdffe0 	addiu	sp,sp,-32
  801354:	afbf001c 	sw	ra,28(sp)
  801358:	afbe0018 	sw	s8,24(sp)
  80135c:	03a0f021 	move	s8,sp
  801360:	afc40020 	sw	a0,32(s8)
    close(dirp->fd);
  801364:	8fc20020 	lw	v0,32(s8)
  801368:	8c420000 	lw	v0,0(v0)
  80136c:	00402021 	move	a0,v0
  801370:	0c2002a4 	jal	800a90 <close>
  801374:	00000000 	nop
}
  801378:	03c0e821 	move	sp,s8
  80137c:	8fbf001c 	lw	ra,28(sp)
  801380:	8fbe0018 	lw	s8,24(sp)
  801384:	27bd0020 	addiu	sp,sp,32
  801388:	03e00008 	jr	ra
  80138c:	00000000 	nop

00801390 <getcwd>:

int
getcwd(char *buffer, size_t len) {
  801390:	27bdffe0 	addiu	sp,sp,-32
  801394:	afbf001c 	sw	ra,28(sp)
  801398:	afbe0018 	sw	s8,24(sp)
  80139c:	03a0f021 	move	s8,sp
  8013a0:	afc40020 	sw	a0,32(s8)
  8013a4:	afc50024 	sw	a1,36(s8)
    return sys_getcwd(buffer, len);
  8013a8:	8fc40020 	lw	a0,32(s8)
  8013ac:	8fc50024 	lw	a1,36(s8)
  8013b0:	0c20019e 	jal	800678 <sys_getcwd>
  8013b4:	00000000 	nop
}
  8013b8:	03c0e821 	move	sp,s8
  8013bc:	8fbf001c 	lw	ra,28(sp)
  8013c0:	8fbe0018 	lw	s8,24(sp)
  8013c4:	27bd0020 	addiu	sp,sp,32
  8013c8:	03e00008 	jr	ra
  8013cc:	00000000 	nop

008013d0 <initfd>:
#include <stat.h>

int main(int argc, char *argv[]);

static int
initfd(int fd2, const char *path, uint32_t open_flags) {
  8013d0:	27bdffd8 	addiu	sp,sp,-40
  8013d4:	afbf0024 	sw	ra,36(sp)
  8013d8:	afbe0020 	sw	s8,32(sp)
  8013dc:	03a0f021 	move	s8,sp
  8013e0:	afc40028 	sw	a0,40(s8)
  8013e4:	afc5002c 	sw	a1,44(s8)
  8013e8:	afc60030 	sw	a2,48(s8)
    int fd1, ret;
    if ((fd1 = open(path, open_flags)) < 0) {
  8013ec:	8fc4002c 	lw	a0,44(s8)
  8013f0:	8fc50030 	lw	a1,48(s8)
  8013f4:	0c200294 	jal	800a50 <open>
  8013f8:	00000000 	nop
  8013fc:	afc2001c 	sw	v0,28(s8)
  801400:	8fc2001c 	lw	v0,28(s8)
  801404:	04410004 	bgez	v0,801418 <initfd+0x48>
  801408:	00000000 	nop
        return fd1;
  80140c:	8fc2001c 	lw	v0,28(s8)
  801410:	08200516 	j	801458 <initfd+0x88>
  801414:	00000000 	nop
    }
    if (fd1 != fd2) {
  801418:	8fc3001c 	lw	v1,28(s8)
  80141c:	8fc20028 	lw	v0,40(s8)
  801420:	1062000c 	beq	v1,v0,801454 <initfd+0x84>
  801424:	00000000 	nop
        close(fd2);
  801428:	8fc40028 	lw	a0,40(s8)
  80142c:	0c2002a4 	jal	800a90 <close>
  801430:	00000000 	nop
        ret = dup2(fd1, fd2);
  801434:	8fc4001c 	lw	a0,28(s8)
  801438:	8fc50028 	lw	a1,40(s8)
  80143c:	0c200306 	jal	800c18 <dup2>
  801440:	00000000 	nop
  801444:	afc20018 	sw	v0,24(s8)
        close(fd1);
  801448:	8fc4001c 	lw	a0,28(s8)
  80144c:	0c2002a4 	jal	800a90 <close>
  801450:	00000000 	nop
    }
    return ret;
  801454:	8fc20018 	lw	v0,24(s8)
}
  801458:	03c0e821 	move	sp,s8
  80145c:	8fbf0024 	lw	ra,36(sp)
  801460:	8fbe0020 	lw	s8,32(sp)
  801464:	27bd0028 	addiu	sp,sp,40
  801468:	03e00008 	jr	ra
  80146c:	00000000 	nop

00801470 <umain>:

void
umain(int argc, char *argv[]) {
  801470:	27bdffd8 	addiu	sp,sp,-40
  801474:	afbf0024 	sw	ra,36(sp)
  801478:	afbe0020 	sw	s8,32(sp)
  80147c:	03a0f021 	move	s8,sp
  801480:	afc40028 	sw	a0,40(s8)
  801484:	afc5002c 	sw	a1,44(s8)
    int fd;
    if ((fd = initfd(0, "stdin:", O_RDONLY)) < 0) {
  801488:	00002021 	move	a0,zero
  80148c:	3c020080 	lui	v0,0x80
  801490:	24453130 	addiu	a1,v0,12592
  801494:	00003021 	move	a2,zero
  801498:	0c2004f4 	jal	8013d0 <initfd>
  80149c:	00000000 	nop
  8014a0:	afc20018 	sw	v0,24(s8)
  8014a4:	8fc20018 	lw	v0,24(s8)
  8014a8:	04410009 	bgez	v0,8014d0 <umain+0x60>
  8014ac:	00000000 	nop
        warn("open <stdin> failed: %e.\n", fd);
  8014b0:	3c020080 	lui	v0,0x80
  8014b4:	24443138 	addiu	a0,v0,12600
  8014b8:	2405001a 	li	a1,26
  8014bc:	3c020080 	lui	v0,0x80
  8014c0:	2446314c 	addiu	a2,v0,12620
  8014c4:	8fc70018 	lw	a3,24(s8)
  8014c8:	0c200024 	jal	800090 <__warn>
  8014cc:	00000000 	nop
    }
    if ((fd = initfd(1, "stdout:", O_WRONLY)) < 0) {
  8014d0:	24040001 	li	a0,1
  8014d4:	3c020080 	lui	v0,0x80
  8014d8:	24453168 	addiu	a1,v0,12648
  8014dc:	24060001 	li	a2,1
  8014e0:	0c2004f4 	jal	8013d0 <initfd>
  8014e4:	00000000 	nop
  8014e8:	afc20018 	sw	v0,24(s8)
  8014ec:	8fc20018 	lw	v0,24(s8)
  8014f0:	04410009 	bgez	v0,801518 <umain+0xa8>
  8014f4:	00000000 	nop
        warn("open <stdout> failed: %e.\n", fd);
  8014f8:	3c020080 	lui	v0,0x80
  8014fc:	24443138 	addiu	a0,v0,12600
  801500:	2405001d 	li	a1,29
  801504:	3c020080 	lui	v0,0x80
  801508:	24463170 	addiu	a2,v0,12656
  80150c:	8fc70018 	lw	a3,24(s8)
  801510:	0c200024 	jal	800090 <__warn>
  801514:	00000000 	nop
    }
    int ret = main(argc, argv);
  801518:	8fc40028 	lw	a0,40(s8)
  80151c:	8fc5002c 	lw	a1,44(s8)
  801520:	0c200ba0 	jal	802e80 <main>
  801524:	00000000 	nop
  801528:	afc2001c 	sw	v0,28(s8)
    exit(ret);
  80152c:	8fc4001c 	lw	a0,28(s8)
  801530:	0c2001d4 	jal	800750 <exit>
  801534:	00000000 	nop
	...

00801540 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  801540:	27bdffe8 	addiu	sp,sp,-24
  801544:	afbe0014 	sw	s8,20(sp)
  801548:	03a0f021 	move	s8,sp
  80154c:	afc40018 	sw	a0,24(s8)
    size_t cnt = 0;
  801550:	afc00008 	sw	zero,8(s8)
    while (*s ++ != '\0') {
  801554:	0820055a 	j	801568 <strlen+0x28>
  801558:	00000000 	nop
        cnt ++;
  80155c:	8fc20008 	lw	v0,8(s8)
  801560:	24420001 	addiu	v0,v0,1
  801564:	afc20008 	sw	v0,8(s8)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  801568:	8fc20018 	lw	v0,24(s8)
  80156c:	24430001 	addiu	v1,v0,1
  801570:	afc30018 	sw	v1,24(s8)
  801574:	80420000 	lb	v0,0(v0)
  801578:	1440fff8 	bnez	v0,80155c <strlen+0x1c>
  80157c:	00000000 	nop
        cnt ++;
    }
    return cnt;
  801580:	8fc20008 	lw	v0,8(s8)
}
  801584:	03c0e821 	move	sp,s8
  801588:	8fbe0014 	lw	s8,20(sp)
  80158c:	27bd0018 	addiu	sp,sp,24
  801590:	03e00008 	jr	ra
  801594:	00000000 	nop

00801598 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  801598:	27bdffe8 	addiu	sp,sp,-24
  80159c:	afbe0014 	sw	s8,20(sp)
  8015a0:	03a0f021 	move	s8,sp
  8015a4:	afc40018 	sw	a0,24(s8)
  8015a8:	afc5001c 	sw	a1,28(s8)
    size_t cnt = 0;
  8015ac:	afc00008 	sw	zero,8(s8)
    while (cnt < len && *s ++ != '\0') {
  8015b0:	08200571 	j	8015c4 <strnlen+0x2c>
  8015b4:	00000000 	nop
        cnt ++;
  8015b8:	8fc20008 	lw	v0,8(s8)
  8015bc:	24420001 	addiu	v0,v0,1
  8015c0:	afc20008 	sw	v0,8(s8)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  8015c4:	8fc30008 	lw	v1,8(s8)
  8015c8:	8fc2001c 	lw	v0,28(s8)
  8015cc:	0062102b 	sltu	v0,v1,v0
  8015d0:	10400007 	beqz	v0,8015f0 <strnlen+0x58>
  8015d4:	00000000 	nop
  8015d8:	8fc20018 	lw	v0,24(s8)
  8015dc:	24430001 	addiu	v1,v0,1
  8015e0:	afc30018 	sw	v1,24(s8)
  8015e4:	80420000 	lb	v0,0(v0)
  8015e8:	1440fff3 	bnez	v0,8015b8 <strnlen+0x20>
  8015ec:	00000000 	nop
        cnt ++;
    }
    return cnt;
  8015f0:	8fc20008 	lw	v0,8(s8)
}
  8015f4:	03c0e821 	move	sp,s8
  8015f8:	8fbe0014 	lw	s8,20(sp)
  8015fc:	27bd0018 	addiu	sp,sp,24
  801600:	03e00008 	jr	ra
  801604:	00000000 	nop

00801608 <strcat>:
 * @dst:    pointer to the @dst array, which should be large enough to contain the concatenated
 *          resulting string.
 * @src:    string to be appended, this should not overlap @dst
 * */
char *
strcat(char *dst, const char *src) {
  801608:	27bdffe0 	addiu	sp,sp,-32
  80160c:	afbf001c 	sw	ra,28(sp)
  801610:	afbe0018 	sw	s8,24(sp)
  801614:	03a0f021 	move	s8,sp
  801618:	afc40020 	sw	a0,32(s8)
  80161c:	afc50024 	sw	a1,36(s8)
    return strcpy(dst + strlen(dst), src);
  801620:	8fc40020 	lw	a0,32(s8)
  801624:	0c200550 	jal	801540 <strlen>
  801628:	00000000 	nop
  80162c:	8fc30020 	lw	v1,32(s8)
  801630:	00621021 	addu	v0,v1,v0
  801634:	00402021 	move	a0,v0
  801638:	8fc50024 	lw	a1,36(s8)
  80163c:	0c200597 	jal	80165c <strcpy>
  801640:	00000000 	nop
}
  801644:	03c0e821 	move	sp,s8
  801648:	8fbf001c 	lw	ra,28(sp)
  80164c:	8fbe0018 	lw	s8,24(sp)
  801650:	27bd0020 	addiu	sp,sp,32
  801654:	03e00008 	jr	ra
  801658:	00000000 	nop

0080165c <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  80165c:	27bdffe8 	addiu	sp,sp,-24
  801660:	afbe0014 	sw	s8,20(sp)
  801664:	03a0f021 	move	s8,sp
  801668:	afc40018 	sw	a0,24(s8)
  80166c:	afc5001c 	sw	a1,28(s8)
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
#else
    char *p = dst;
  801670:	8fc20018 	lw	v0,24(s8)
  801674:	afc20008 	sw	v0,8(s8)
    while ((*p ++ = *src ++) != '\0')
  801678:	00000000 	nop
  80167c:	8fc20008 	lw	v0,8(s8)
  801680:	24430001 	addiu	v1,v0,1
  801684:	afc30008 	sw	v1,8(s8)
  801688:	8fc3001c 	lw	v1,28(s8)
  80168c:	24640001 	addiu	a0,v1,1
  801690:	afc4001c 	sw	a0,28(s8)
  801694:	80630000 	lb	v1,0(v1)
  801698:	a0430000 	sb	v1,0(v0)
  80169c:	80420000 	lb	v0,0(v0)
  8016a0:	1440fff6 	bnez	v0,80167c <strcpy+0x20>
  8016a4:	00000000 	nop
        /* nothing */;
    return dst;
  8016a8:	8fc20018 	lw	v0,24(s8)
#endif /* __HAVE_ARCH_STRCPY */
}
  8016ac:	03c0e821 	move	sp,s8
  8016b0:	8fbe0014 	lw	s8,20(sp)
  8016b4:	27bd0018 	addiu	sp,sp,24
  8016b8:	03e00008 	jr	ra
  8016bc:	00000000 	nop

008016c0 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  8016c0:	27bdffe8 	addiu	sp,sp,-24
  8016c4:	afbe0014 	sw	s8,20(sp)
  8016c8:	03a0f021 	move	s8,sp
  8016cc:	afc40018 	sw	a0,24(s8)
  8016d0:	afc5001c 	sw	a1,28(s8)
  8016d4:	afc60020 	sw	a2,32(s8)
    char *p = dst;
  8016d8:	8fc20018 	lw	v0,24(s8)
  8016dc:	afc20008 	sw	v0,8(s8)
    while (len > 0) {
  8016e0:	082005cb 	j	80172c <strncpy+0x6c>
  8016e4:	00000000 	nop
        if ((*p = *src) != '\0') {
  8016e8:	8fc2001c 	lw	v0,28(s8)
  8016ec:	80430000 	lb	v1,0(v0)
  8016f0:	8fc20008 	lw	v0,8(s8)
  8016f4:	a0430000 	sb	v1,0(v0)
  8016f8:	8fc20008 	lw	v0,8(s8)
  8016fc:	80420000 	lb	v0,0(v0)
  801700:	10400004 	beqz	v0,801714 <strncpy+0x54>
  801704:	00000000 	nop
            src ++;
  801708:	8fc2001c 	lw	v0,28(s8)
  80170c:	24420001 	addiu	v0,v0,1
  801710:	afc2001c 	sw	v0,28(s8)
        }
        p ++, len --;
  801714:	8fc20008 	lw	v0,8(s8)
  801718:	24420001 	addiu	v0,v0,1
  80171c:	afc20008 	sw	v0,8(s8)
  801720:	8fc20020 	lw	v0,32(s8)
  801724:	2442ffff 	addiu	v0,v0,-1
  801728:	afc20020 	sw	v0,32(s8)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  80172c:	8fc20020 	lw	v0,32(s8)
  801730:	1440ffed 	bnez	v0,8016e8 <strncpy+0x28>
  801734:	00000000 	nop
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  801738:	8fc20018 	lw	v0,24(s8)
}
  80173c:	03c0e821 	move	sp,s8
  801740:	8fbe0014 	lw	s8,20(sp)
  801744:	27bd0018 	addiu	sp,sp,24
  801748:	03e00008 	jr	ra
  80174c:	00000000 	nop

00801750 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  801750:	27bdfff8 	addiu	sp,sp,-8
  801754:	afbe0004 	sw	s8,4(sp)
  801758:	03a0f021 	move	s8,sp
  80175c:	afc40008 	sw	a0,8(s8)
  801760:	afc5000c 	sw	a1,12(s8)
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
  801764:	082005e1 	j	801784 <strcmp+0x34>
  801768:	00000000 	nop
        s1 ++, s2 ++;
  80176c:	8fc20008 	lw	v0,8(s8)
  801770:	24420001 	addiu	v0,v0,1
  801774:	afc20008 	sw	v0,8(s8)
  801778:	8fc2000c 	lw	v0,12(s8)
  80177c:	24420001 	addiu	v0,v0,1
  801780:	afc2000c 	sw	v0,12(s8)
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
  801784:	8fc20008 	lw	v0,8(s8)
  801788:	80420000 	lb	v0,0(v0)
  80178c:	10400007 	beqz	v0,8017ac <strcmp+0x5c>
  801790:	00000000 	nop
  801794:	8fc20008 	lw	v0,8(s8)
  801798:	80430000 	lb	v1,0(v0)
  80179c:	8fc2000c 	lw	v0,12(s8)
  8017a0:	80420000 	lb	v0,0(v0)
  8017a4:	1062fff1 	beq	v1,v0,80176c <strcmp+0x1c>
  8017a8:	00000000 	nop
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
  8017ac:	8fc20008 	lw	v0,8(s8)
  8017b0:	80420000 	lb	v0,0(v0)
  8017b4:	304200ff 	andi	v0,v0,0xff
  8017b8:	00401821 	move	v1,v0
  8017bc:	8fc2000c 	lw	v0,12(s8)
  8017c0:	80420000 	lb	v0,0(v0)
  8017c4:	304200ff 	andi	v0,v0,0xff
  8017c8:	00621023 	subu	v0,v1,v0
#endif /* __HAVE_ARCH_STRCMP */
}
  8017cc:	03c0e821 	move	sp,s8
  8017d0:	8fbe0004 	lw	s8,4(sp)
  8017d4:	27bd0008 	addiu	sp,sp,8
  8017d8:	03e00008 	jr	ra
  8017dc:	00000000 	nop

008017e0 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  8017e0:	27bdfff8 	addiu	sp,sp,-8
  8017e4:	afbe0004 	sw	s8,4(sp)
  8017e8:	03a0f021 	move	s8,sp
  8017ec:	afc40008 	sw	a0,8(s8)
  8017f0:	afc5000c 	sw	a1,12(s8)
  8017f4:	afc60010 	sw	a2,16(s8)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  8017f8:	08200609 	j	801824 <strncmp+0x44>
  8017fc:	00000000 	nop
        n --, s1 ++, s2 ++;
  801800:	8fc20010 	lw	v0,16(s8)
  801804:	2442ffff 	addiu	v0,v0,-1
  801808:	afc20010 	sw	v0,16(s8)
  80180c:	8fc20008 	lw	v0,8(s8)
  801810:	24420001 	addiu	v0,v0,1
  801814:	afc20008 	sw	v0,8(s8)
  801818:	8fc2000c 	lw	v0,12(s8)
  80181c:	24420001 	addiu	v0,v0,1
  801820:	afc2000c 	sw	v0,12(s8)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  801824:	8fc20010 	lw	v0,16(s8)
  801828:	1040000b 	beqz	v0,801858 <strncmp+0x78>
  80182c:	00000000 	nop
  801830:	8fc20008 	lw	v0,8(s8)
  801834:	80420000 	lb	v0,0(v0)
  801838:	10400007 	beqz	v0,801858 <strncmp+0x78>
  80183c:	00000000 	nop
  801840:	8fc20008 	lw	v0,8(s8)
  801844:	80430000 	lb	v1,0(v0)
  801848:	8fc2000c 	lw	v0,12(s8)
  80184c:	80420000 	lb	v0,0(v0)
  801850:	1062ffeb 	beq	v1,v0,801800 <strncmp+0x20>
  801854:	00000000 	nop
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  801858:	8fc20010 	lw	v0,16(s8)
  80185c:	1040000b 	beqz	v0,80188c <strncmp+0xac>
  801860:	00000000 	nop
  801864:	8fc20008 	lw	v0,8(s8)
  801868:	80420000 	lb	v0,0(v0)
  80186c:	304200ff 	andi	v0,v0,0xff
  801870:	00401821 	move	v1,v0
  801874:	8fc2000c 	lw	v0,12(s8)
  801878:	80420000 	lb	v0,0(v0)
  80187c:	304200ff 	andi	v0,v0,0xff
  801880:	00621023 	subu	v0,v1,v0
  801884:	08200624 	j	801890 <strncmp+0xb0>
  801888:	00000000 	nop
  80188c:	00001021 	move	v0,zero
}
  801890:	03c0e821 	move	sp,s8
  801894:	8fbe0004 	lw	s8,4(sp)
  801898:	27bd0008 	addiu	sp,sp,8
  80189c:	03e00008 	jr	ra
  8018a0:	00000000 	nop

008018a4 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  8018a4:	27bdfff8 	addiu	sp,sp,-8
  8018a8:	afbe0004 	sw	s8,4(sp)
  8018ac:	03a0f021 	move	s8,sp
  8018b0:	afc40008 	sw	a0,8(s8)
  8018b4:	00a01021 	move	v0,a1
  8018b8:	a3c2000c 	sb	v0,12(s8)
    while (*s != '\0') {
  8018bc:	0820063c 	j	8018f0 <strchr+0x4c>
  8018c0:	00000000 	nop
        if (*s == c) {
  8018c4:	8fc20008 	lw	v0,8(s8)
  8018c8:	80420000 	lb	v0,0(v0)
  8018cc:	83c3000c 	lb	v1,12(s8)
  8018d0:	14620004 	bne	v1,v0,8018e4 <strchr+0x40>
  8018d4:	00000000 	nop
            return (char *)s;
  8018d8:	8fc20008 	lw	v0,8(s8)
  8018dc:	08200641 	j	801904 <strchr+0x60>
  8018e0:	00000000 	nop
        }
        s ++;
  8018e4:	8fc20008 	lw	v0,8(s8)
  8018e8:	24420001 	addiu	v0,v0,1
  8018ec:	afc20008 	sw	v0,8(s8)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  8018f0:	8fc20008 	lw	v0,8(s8)
  8018f4:	80420000 	lb	v0,0(v0)
  8018f8:	1440fff2 	bnez	v0,8018c4 <strchr+0x20>
  8018fc:	00000000 	nop
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  801900:	00001021 	move	v0,zero
}
  801904:	03c0e821 	move	sp,s8
  801908:	8fbe0004 	lw	s8,4(sp)
  80190c:	27bd0008 	addiu	sp,sp,8
  801910:	03e00008 	jr	ra
  801914:	00000000 	nop

00801918 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  801918:	27bdfff8 	addiu	sp,sp,-8
  80191c:	afbe0004 	sw	s8,4(sp)
  801920:	03a0f021 	move	s8,sp
  801924:	afc40008 	sw	a0,8(s8)
  801928:	00a01021 	move	v0,a1
  80192c:	a3c2000c 	sb	v0,12(s8)
    while (*s != '\0') {
  801930:	08200658 	j	801960 <strfind+0x48>
  801934:	00000000 	nop
        if (*s == c) {
  801938:	8fc20008 	lw	v0,8(s8)
  80193c:	80420000 	lb	v0,0(v0)
  801940:	83c3000c 	lb	v1,12(s8)
  801944:	14620003 	bne	v1,v0,801954 <strfind+0x3c>
  801948:	00000000 	nop
            break;
  80194c:	0820065c 	j	801970 <strfind+0x58>
  801950:	00000000 	nop
        }
        s ++;
  801954:	8fc20008 	lw	v0,8(s8)
  801958:	24420001 	addiu	v0,v0,1
  80195c:	afc20008 	sw	v0,8(s8)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  801960:	8fc20008 	lw	v0,8(s8)
  801964:	80420000 	lb	v0,0(v0)
  801968:	1440fff3 	bnez	v0,801938 <strfind+0x20>
  80196c:	00000000 	nop
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  801970:	8fc20008 	lw	v0,8(s8)
}
  801974:	03c0e821 	move	sp,s8
  801978:	8fbe0004 	lw	s8,4(sp)
  80197c:	27bd0008 	addiu	sp,sp,8
  801980:	03e00008 	jr	ra
  801984:	00000000 	nop

00801988 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  801988:	27bdffe0 	addiu	sp,sp,-32
  80198c:	afbe001c 	sw	s8,28(sp)
  801990:	03a0f021 	move	s8,sp
  801994:	afc40020 	sw	a0,32(s8)
  801998:	afc50024 	sw	a1,36(s8)
  80199c:	afc60028 	sw	a2,40(s8)
    int neg = 0;
  8019a0:	afc00008 	sw	zero,8(s8)
    long val = 0;
  8019a4:	afc0000c 	sw	zero,12(s8)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  8019a8:	0820066f 	j	8019bc <strtol+0x34>
  8019ac:	00000000 	nop
        s ++;
  8019b0:	8fc20020 	lw	v0,32(s8)
  8019b4:	24420001 	addiu	v0,v0,1
  8019b8:	afc20020 	sw	v0,32(s8)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  8019bc:	8fc20020 	lw	v0,32(s8)
  8019c0:	80430000 	lb	v1,0(v0)
  8019c4:	24020020 	li	v0,32
  8019c8:	1062fff9 	beq	v1,v0,8019b0 <strtol+0x28>
  8019cc:	00000000 	nop
  8019d0:	8fc20020 	lw	v0,32(s8)
  8019d4:	80430000 	lb	v1,0(v0)
  8019d8:	24020009 	li	v0,9
  8019dc:	1062fff4 	beq	v1,v0,8019b0 <strtol+0x28>
  8019e0:	00000000 	nop
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  8019e4:	8fc20020 	lw	v0,32(s8)
  8019e8:	80430000 	lb	v1,0(v0)
  8019ec:	2402002b 	li	v0,43
  8019f0:	14620006 	bne	v1,v0,801a0c <strtol+0x84>
  8019f4:	00000000 	nop
        s ++;
  8019f8:	8fc20020 	lw	v0,32(s8)
  8019fc:	24420001 	addiu	v0,v0,1
  801a00:	afc20020 	sw	v0,32(s8)
  801a04:	0820068d 	j	801a34 <strtol+0xac>
  801a08:	00000000 	nop
    }
    else if (*s == '-') {
  801a0c:	8fc20020 	lw	v0,32(s8)
  801a10:	80430000 	lb	v1,0(v0)
  801a14:	2402002d 	li	v0,45
  801a18:	14620006 	bne	v1,v0,801a34 <strtol+0xac>
  801a1c:	00000000 	nop
        s ++, neg = 1;
  801a20:	8fc20020 	lw	v0,32(s8)
  801a24:	24420001 	addiu	v0,v0,1
  801a28:	afc20020 	sw	v0,32(s8)
  801a2c:	24020001 	li	v0,1
  801a30:	afc20008 	sw	v0,8(s8)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  801a34:	8fc20028 	lw	v0,40(s8)
  801a38:	10400005 	beqz	v0,801a50 <strtol+0xc8>
  801a3c:	00000000 	nop
  801a40:	8fc30028 	lw	v1,40(s8)
  801a44:	24020010 	li	v0,16
  801a48:	14620013 	bne	v1,v0,801a98 <strtol+0x110>
  801a4c:	00000000 	nop
  801a50:	8fc20020 	lw	v0,32(s8)
  801a54:	80430000 	lb	v1,0(v0)
  801a58:	24020030 	li	v0,48
  801a5c:	1462000e 	bne	v1,v0,801a98 <strtol+0x110>
  801a60:	00000000 	nop
  801a64:	8fc20020 	lw	v0,32(s8)
  801a68:	24420001 	addiu	v0,v0,1
  801a6c:	80430000 	lb	v1,0(v0)
  801a70:	24020078 	li	v0,120
  801a74:	14620008 	bne	v1,v0,801a98 <strtol+0x110>
  801a78:	00000000 	nop
        s += 2, base = 16;
  801a7c:	8fc20020 	lw	v0,32(s8)
  801a80:	24420002 	addiu	v0,v0,2
  801a84:	afc20020 	sw	v0,32(s8)
  801a88:	24020010 	li	v0,16
  801a8c:	afc20028 	sw	v0,40(s8)
  801a90:	082006ba 	j	801ae8 <strtol+0x160>
  801a94:	00000000 	nop
    }
    else if (base == 0 && s[0] == '0') {
  801a98:	8fc20028 	lw	v0,40(s8)
  801a9c:	1440000d 	bnez	v0,801ad4 <strtol+0x14c>
  801aa0:	00000000 	nop
  801aa4:	8fc20020 	lw	v0,32(s8)
  801aa8:	80430000 	lb	v1,0(v0)
  801aac:	24020030 	li	v0,48
  801ab0:	14620008 	bne	v1,v0,801ad4 <strtol+0x14c>
  801ab4:	00000000 	nop
        s ++, base = 8;
  801ab8:	8fc20020 	lw	v0,32(s8)
  801abc:	24420001 	addiu	v0,v0,1
  801ac0:	afc20020 	sw	v0,32(s8)
  801ac4:	24020008 	li	v0,8
  801ac8:	afc20028 	sw	v0,40(s8)
  801acc:	082006ba 	j	801ae8 <strtol+0x160>
  801ad0:	00000000 	nop
    }
    else if (base == 0) {
  801ad4:	8fc20028 	lw	v0,40(s8)
  801ad8:	14400003 	bnez	v0,801ae8 <strtol+0x160>
  801adc:	00000000 	nop
        base = 10;
  801ae0:	2402000a 	li	v0,10
  801ae4:	afc20028 	sw	v0,40(s8)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  801ae8:	8fc20020 	lw	v0,32(s8)
  801aec:	80420000 	lb	v0,0(v0)
  801af0:	28420030 	slti	v0,v0,48
  801af4:	1440000c 	bnez	v0,801b28 <strtol+0x1a0>
  801af8:	00000000 	nop
  801afc:	8fc20020 	lw	v0,32(s8)
  801b00:	80420000 	lb	v0,0(v0)
  801b04:	2842003a 	slti	v0,v0,58
  801b08:	10400007 	beqz	v0,801b28 <strtol+0x1a0>
  801b0c:	00000000 	nop
            dig = *s - '0';
  801b10:	8fc20020 	lw	v0,32(s8)
  801b14:	80420000 	lb	v0,0(v0)
  801b18:	2442ffd0 	addiu	v0,v0,-48
  801b1c:	afc20010 	sw	v0,16(s8)
  801b20:	082006e8 	j	801ba0 <strtol+0x218>
  801b24:	00000000 	nop
        }
        else if (*s >= 'a' && *s <= 'z') {
  801b28:	8fc20020 	lw	v0,32(s8)
  801b2c:	80420000 	lb	v0,0(v0)
  801b30:	28420061 	slti	v0,v0,97
  801b34:	1440000c 	bnez	v0,801b68 <strtol+0x1e0>
  801b38:	00000000 	nop
  801b3c:	8fc20020 	lw	v0,32(s8)
  801b40:	80420000 	lb	v0,0(v0)
  801b44:	2842007b 	slti	v0,v0,123
  801b48:	10400007 	beqz	v0,801b68 <strtol+0x1e0>
  801b4c:	00000000 	nop
            dig = *s - 'a' + 10;
  801b50:	8fc20020 	lw	v0,32(s8)
  801b54:	80420000 	lb	v0,0(v0)
  801b58:	2442ffa9 	addiu	v0,v0,-87
  801b5c:	afc20010 	sw	v0,16(s8)
  801b60:	082006e8 	j	801ba0 <strtol+0x218>
  801b64:	00000000 	nop
        }
        else if (*s >= 'A' && *s <= 'Z') {
  801b68:	8fc20020 	lw	v0,32(s8)
  801b6c:	80420000 	lb	v0,0(v0)
  801b70:	28420041 	slti	v0,v0,65
  801b74:	1440001d 	bnez	v0,801bec <strtol+0x264>
  801b78:	00000000 	nop
  801b7c:	8fc20020 	lw	v0,32(s8)
  801b80:	80420000 	lb	v0,0(v0)
  801b84:	2842005b 	slti	v0,v0,91
  801b88:	10400018 	beqz	v0,801bec <strtol+0x264>
  801b8c:	00000000 	nop
            dig = *s - 'A' + 10;
  801b90:	8fc20020 	lw	v0,32(s8)
  801b94:	80420000 	lb	v0,0(v0)
  801b98:	2442ffc9 	addiu	v0,v0,-55
  801b9c:	afc20010 	sw	v0,16(s8)
        }
        else {
            break;
        }
        if (dig >= base) {
  801ba0:	8fc30010 	lw	v1,16(s8)
  801ba4:	8fc20028 	lw	v0,40(s8)
  801ba8:	0062102a 	slt	v0,v1,v0
  801bac:	14400003 	bnez	v0,801bbc <strtol+0x234>
  801bb0:	00000000 	nop
            break;
  801bb4:	082006fb 	j	801bec <strtol+0x264>
  801bb8:	00000000 	nop
        }
        s ++, val = (val * base) + dig;
  801bbc:	8fc20020 	lw	v0,32(s8)
  801bc0:	24420001 	addiu	v0,v0,1
  801bc4:	afc20020 	sw	v0,32(s8)
  801bc8:	8fc3000c 	lw	v1,12(s8)
  801bcc:	8fc20028 	lw	v0,40(s8)
  801bd0:	00620018 	mult	v1,v0
  801bd4:	8fc20010 	lw	v0,16(s8)
  801bd8:	00001812 	mflo	v1
  801bdc:	00621021 	addu	v0,v1,v0
  801be0:	afc2000c 	sw	v0,12(s8)
        // we don't properly detect overflow!
    }
  801be4:	082006ba 	j	801ae8 <strtol+0x160>
  801be8:	00000000 	nop

    if (endptr) {
  801bec:	8fc20024 	lw	v0,36(s8)
  801bf0:	10400004 	beqz	v0,801c04 <strtol+0x27c>
  801bf4:	00000000 	nop
        *endptr = (char *) s;
  801bf8:	8fc20024 	lw	v0,36(s8)
  801bfc:	8fc30020 	lw	v1,32(s8)
  801c00:	ac430000 	sw	v1,0(v0)
    }
    return (neg ? -val : val);
  801c04:	8fc20008 	lw	v0,8(s8)
  801c08:	10400005 	beqz	v0,801c20 <strtol+0x298>
  801c0c:	00000000 	nop
  801c10:	8fc2000c 	lw	v0,12(s8)
  801c14:	00021023 	negu	v0,v0
  801c18:	08200709 	j	801c24 <strtol+0x29c>
  801c1c:	00000000 	nop
  801c20:	8fc2000c 	lw	v0,12(s8)
}
  801c24:	03c0e821 	move	sp,s8
  801c28:	8fbe001c 	lw	s8,28(sp)
  801c2c:	27bd0020 	addiu	sp,sp,32
  801c30:	03e00008 	jr	ra
  801c34:	00000000 	nop

00801c38 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  801c38:	27bdffe8 	addiu	sp,sp,-24
  801c3c:	afbe0014 	sw	s8,20(sp)
  801c40:	03a0f021 	move	s8,sp
  801c44:	afc40018 	sw	a0,24(s8)
  801c48:	00a01021 	move	v0,a1
  801c4c:	afc60020 	sw	a2,32(s8)
  801c50:	a3c2001c 	sb	v0,28(s8)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
  801c54:	8fc20018 	lw	v0,24(s8)
  801c58:	afc20008 	sw	v0,8(s8)
    while (n -- > 0) {
  801c5c:	0820071e 	j	801c78 <memset+0x40>
  801c60:	00000000 	nop
        *p ++ = c;
  801c64:	8fc20008 	lw	v0,8(s8)
  801c68:	24430001 	addiu	v1,v0,1
  801c6c:	afc30008 	sw	v1,8(s8)
  801c70:	93c3001c 	lbu	v1,28(s8)
  801c74:	a0430000 	sb	v1,0(v0)
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
  801c78:	8fc20020 	lw	v0,32(s8)
  801c7c:	2443ffff 	addiu	v1,v0,-1
  801c80:	afc30020 	sw	v1,32(s8)
  801c84:	1440fff7 	bnez	v0,801c64 <memset+0x2c>
  801c88:	00000000 	nop
        *p ++ = c;
    }
    return s;
  801c8c:	8fc20018 	lw	v0,24(s8)
#endif /* __HAVE_ARCH_MEMSET */
}
  801c90:	03c0e821 	move	sp,s8
  801c94:	8fbe0014 	lw	s8,20(sp)
  801c98:	27bd0018 	addiu	sp,sp,24
  801c9c:	03e00008 	jr	ra
  801ca0:	00000000 	nop

00801ca4 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  801ca4:	27bdffe8 	addiu	sp,sp,-24
  801ca8:	afbe0014 	sw	s8,20(sp)
  801cac:	03a0f021 	move	s8,sp
  801cb0:	afc40018 	sw	a0,24(s8)
  801cb4:	afc5001c 	sw	a1,28(s8)
  801cb8:	afc60020 	sw	a2,32(s8)
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
#else
    const char *s = src;
  801cbc:	8fc2001c 	lw	v0,28(s8)
  801cc0:	afc20008 	sw	v0,8(s8)
    char *d = dst;
  801cc4:	8fc20018 	lw	v0,24(s8)
  801cc8:	afc2000c 	sw	v0,12(s8)
    if (s < d && s + n > d) {
  801ccc:	8fc30008 	lw	v1,8(s8)
  801cd0:	8fc2000c 	lw	v0,12(s8)
  801cd4:	0062102b 	sltu	v0,v1,v0
  801cd8:	10400023 	beqz	v0,801d68 <memmove+0xc4>
  801cdc:	00000000 	nop
  801ce0:	8fc30008 	lw	v1,8(s8)
  801ce4:	8fc20020 	lw	v0,32(s8)
  801ce8:	00621821 	addu	v1,v1,v0
  801cec:	8fc2000c 	lw	v0,12(s8)
  801cf0:	0043102b 	sltu	v0,v0,v1
  801cf4:	1040001c 	beqz	v0,801d68 <memmove+0xc4>
  801cf8:	00000000 	nop
        s += n, d += n;
  801cfc:	8fc30008 	lw	v1,8(s8)
  801d00:	8fc20020 	lw	v0,32(s8)
  801d04:	00621021 	addu	v0,v1,v0
  801d08:	afc20008 	sw	v0,8(s8)
  801d0c:	8fc3000c 	lw	v1,12(s8)
  801d10:	8fc20020 	lw	v0,32(s8)
  801d14:	00621021 	addu	v0,v1,v0
  801d18:	afc2000c 	sw	v0,12(s8)
        while (n -- > 0) {
  801d1c:	08200753 	j	801d4c <memmove+0xa8>
  801d20:	00000000 	nop
            *-- d = *-- s;
  801d24:	8fc2000c 	lw	v0,12(s8)
  801d28:	2442ffff 	addiu	v0,v0,-1
  801d2c:	afc2000c 	sw	v0,12(s8)
  801d30:	8fc20008 	lw	v0,8(s8)
  801d34:	2442ffff 	addiu	v0,v0,-1
  801d38:	afc20008 	sw	v0,8(s8)
  801d3c:	8fc20008 	lw	v0,8(s8)
  801d40:	80430000 	lb	v1,0(v0)
  801d44:	8fc2000c 	lw	v0,12(s8)
  801d48:	a0430000 	sb	v1,0(v0)
#else
    const char *s = src;
    char *d = dst;
    if (s < d && s + n > d) {
        s += n, d += n;
        while (n -- > 0) {
  801d4c:	8fc20020 	lw	v0,32(s8)
  801d50:	2443ffff 	addiu	v1,v0,-1
  801d54:	afc30020 	sw	v1,32(s8)
  801d58:	1440fff2 	bnez	v0,801d24 <memmove+0x80>
  801d5c:	00000000 	nop
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
#else
    const char *s = src;
    char *d = dst;
    if (s < d && s + n > d) {
  801d60:	08200769 	j	801da4 <memmove+0x100>
  801d64:	00000000 	nop
        s += n, d += n;
        while (n -- > 0) {
            *-- d = *-- s;
        }
    } else {
        while (n -- > 0) {
  801d68:	08200764 	j	801d90 <memmove+0xec>
  801d6c:	00000000 	nop
            *d ++ = *s ++;
  801d70:	8fc2000c 	lw	v0,12(s8)
  801d74:	24430001 	addiu	v1,v0,1
  801d78:	afc3000c 	sw	v1,12(s8)
  801d7c:	8fc30008 	lw	v1,8(s8)
  801d80:	24640001 	addiu	a0,v1,1
  801d84:	afc40008 	sw	a0,8(s8)
  801d88:	80630000 	lb	v1,0(v1)
  801d8c:	a0430000 	sb	v1,0(v0)
        s += n, d += n;
        while (n -- > 0) {
            *-- d = *-- s;
        }
    } else {
        while (n -- > 0) {
  801d90:	8fc20020 	lw	v0,32(s8)
  801d94:	2443ffff 	addiu	v1,v0,-1
  801d98:	afc30020 	sw	v1,32(s8)
  801d9c:	1440fff4 	bnez	v0,801d70 <memmove+0xcc>
  801da0:	00000000 	nop
            *d ++ = *s ++;
        }
    }
    return dst;
  801da4:	8fc20018 	lw	v0,24(s8)
#endif /* __HAVE_ARCH_MEMMOVE */
}
  801da8:	03c0e821 	move	sp,s8
  801dac:	8fbe0014 	lw	s8,20(sp)
  801db0:	27bd0018 	addiu	sp,sp,24
  801db4:	03e00008 	jr	ra
  801db8:	00000000 	nop

00801dbc <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  801dbc:	27bdffe8 	addiu	sp,sp,-24
  801dc0:	afbe0014 	sw	s8,20(sp)
  801dc4:	03a0f021 	move	s8,sp
  801dc8:	afc40018 	sw	a0,24(s8)
  801dcc:	afc5001c 	sw	a1,28(s8)
  801dd0:	afc60020 	sw	a2,32(s8)
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
#else
    const char *s = src;
  801dd4:	8fc2001c 	lw	v0,28(s8)
  801dd8:	afc20008 	sw	v0,8(s8)
    char *d = dst;
  801ddc:	8fc20018 	lw	v0,24(s8)
  801de0:	afc2000c 	sw	v0,12(s8)
    while (n -- > 0) {
  801de4:	08200783 	j	801e0c <memcpy+0x50>
  801de8:	00000000 	nop
        *d ++ = *s ++;
  801dec:	8fc2000c 	lw	v0,12(s8)
  801df0:	24430001 	addiu	v1,v0,1
  801df4:	afc3000c 	sw	v1,12(s8)
  801df8:	8fc30008 	lw	v1,8(s8)
  801dfc:	24640001 	addiu	a0,v1,1
  801e00:	afc40008 	sw	a0,8(s8)
  801e04:	80630000 	lb	v1,0(v1)
  801e08:	a0430000 	sb	v1,0(v0)
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
#else
    const char *s = src;
    char *d = dst;
    while (n -- > 0) {
  801e0c:	8fc20020 	lw	v0,32(s8)
  801e10:	2443ffff 	addiu	v1,v0,-1
  801e14:	afc30020 	sw	v1,32(s8)
  801e18:	1440fff4 	bnez	v0,801dec <memcpy+0x30>
  801e1c:	00000000 	nop
        *d ++ = *s ++;
    }
    return dst;
  801e20:	8fc20018 	lw	v0,24(s8)
#endif /* __HAVE_ARCH_MEMCPY */
}
  801e24:	03c0e821 	move	sp,s8
  801e28:	8fbe0014 	lw	s8,20(sp)
  801e2c:	27bd0018 	addiu	sp,sp,24
  801e30:	03e00008 	jr	ra
  801e34:	00000000 	nop

00801e38 <memcpy_flash>:
 * Copy from flash to RAM
 * Try to solve the problem that flash only has 16 bits valid data
 * Otherwise, change the implementation of flash access in VHDL
 * */
void *
memcpy_flash(void *dst, const void *src, size_t n) {
  801e38:	27bdffe8 	addiu	sp,sp,-24
  801e3c:	afbe0014 	sw	s8,20(sp)
  801e40:	03a0f021 	move	s8,sp
  801e44:	afc40018 	sw	a0,24(s8)
  801e48:	afc5001c 	sw	a1,28(s8)
  801e4c:	afc60020 	sw	a2,32(s8)
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
#else
    const char *s = src;
  801e50:	8fc2001c 	lw	v0,28(s8)
  801e54:	afc20008 	sw	v0,8(s8)
    char *d = dst;
  801e58:	8fc20018 	lw	v0,24(s8)
  801e5c:	afc2000c 	sw	v0,12(s8)
    while (n > 0) {
  801e60:	082007b0 	j	801ec0 <memcpy_flash+0x88>
  801e64:	00000000 	nop
        *d ++ = *s ++;
  801e68:	8fc2000c 	lw	v0,12(s8)
  801e6c:	24430001 	addiu	v1,v0,1
  801e70:	afc3000c 	sw	v1,12(s8)
  801e74:	8fc30008 	lw	v1,8(s8)
  801e78:	24640001 	addiu	a0,v1,1
  801e7c:	afc40008 	sw	a0,8(s8)
  801e80:	80630000 	lb	v1,0(v1)
  801e84:	a0430000 	sb	v1,0(v0)
        *d ++ = *s ++;
  801e88:	8fc2000c 	lw	v0,12(s8)
  801e8c:	24430001 	addiu	v1,v0,1
  801e90:	afc3000c 	sw	v1,12(s8)
  801e94:	8fc30008 	lw	v1,8(s8)
  801e98:	24640001 	addiu	a0,v1,1
  801e9c:	afc40008 	sw	a0,8(s8)
  801ea0:	80630000 	lb	v1,0(v1)
  801ea4:	a0430000 	sb	v1,0(v0)
        s = s + 2;
  801ea8:	8fc20008 	lw	v0,8(s8)
  801eac:	24420002 	addiu	v0,v0,2
  801eb0:	afc20008 	sw	v0,8(s8)
        n = n - 2;
  801eb4:	8fc20020 	lw	v0,32(s8)
  801eb8:	2442fffe 	addiu	v0,v0,-2
  801ebc:	afc20020 	sw	v0,32(s8)
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
#else
    const char *s = src;
    char *d = dst;
    while (n > 0) {
  801ec0:	8fc20020 	lw	v0,32(s8)
  801ec4:	1440ffe8 	bnez	v0,801e68 <memcpy_flash+0x30>
  801ec8:	00000000 	nop
        *d ++ = *s ++;
        *d ++ = *s ++;
        s = s + 2;
        n = n - 2;
    }
    return dst;
  801ecc:	8fc20018 	lw	v0,24(s8)
#endif /* __HAVE_ARCH_MEMCPY */
}
  801ed0:	03c0e821 	move	sp,s8
  801ed4:	8fbe0014 	lw	s8,20(sp)
  801ed8:	27bd0018 	addiu	sp,sp,24
  801edc:	03e00008 	jr	ra
  801ee0:	00000000 	nop

00801ee4 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  801ee4:	27bdffe8 	addiu	sp,sp,-24
  801ee8:	afbe0014 	sw	s8,20(sp)
  801eec:	03a0f021 	move	s8,sp
  801ef0:	afc40018 	sw	a0,24(s8)
  801ef4:	afc5001c 	sw	a1,28(s8)
  801ef8:	afc60020 	sw	a2,32(s8)
    const char *s1 = (const char *)v1;
  801efc:	8fc20018 	lw	v0,24(s8)
  801f00:	afc20008 	sw	v0,8(s8)
    const char *s2 = (const char *)v2;
  801f04:	8fc2001c 	lw	v0,28(s8)
  801f08:	afc2000c 	sw	v0,12(s8)
    while (n -- > 0) {
  801f0c:	082007db 	j	801f6c <memcmp+0x88>
  801f10:	00000000 	nop
        if (*s1 != *s2) {
  801f14:	8fc20008 	lw	v0,8(s8)
  801f18:	80430000 	lb	v1,0(v0)
  801f1c:	8fc2000c 	lw	v0,12(s8)
  801f20:	80420000 	lb	v0,0(v0)
  801f24:	1062000b 	beq	v1,v0,801f54 <memcmp+0x70>
  801f28:	00000000 	nop
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  801f2c:	8fc20008 	lw	v0,8(s8)
  801f30:	80420000 	lb	v0,0(v0)
  801f34:	304200ff 	andi	v0,v0,0xff
  801f38:	00401821 	move	v1,v0
  801f3c:	8fc2000c 	lw	v0,12(s8)
  801f40:	80420000 	lb	v0,0(v0)
  801f44:	304200ff 	andi	v0,v0,0xff
  801f48:	00621023 	subu	v0,v1,v0
  801f4c:	082007e1 	j	801f84 <memcmp+0xa0>
  801f50:	00000000 	nop
        }
        s1 ++, s2 ++;
  801f54:	8fc20008 	lw	v0,8(s8)
  801f58:	24420001 	addiu	v0,v0,1
  801f5c:	afc20008 	sw	v0,8(s8)
  801f60:	8fc2000c 	lw	v0,12(s8)
  801f64:	24420001 	addiu	v0,v0,1
  801f68:	afc2000c 	sw	v0,12(s8)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  801f6c:	8fc20020 	lw	v0,32(s8)
  801f70:	2443ffff 	addiu	v1,v0,-1
  801f74:	afc30020 	sw	v1,32(s8)
  801f78:	1440ffe6 	bnez	v0,801f14 <memcmp+0x30>
  801f7c:	00000000 	nop
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  801f80:	00001021 	move	v0,zero
}
  801f84:	03c0e821 	move	sp,s8
  801f88:	8fbe0014 	lw	s8,20(sp)
  801f8c:	27bd0018 	addiu	sp,sp,24
  801f90:	03e00008 	jr	ra
  801f94:	00000000 	nop
	...

00801fa0 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*, int), int fd, void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  801fa0:	27bdffb0 	addiu	sp,sp,-80
  801fa4:	afbf004c 	sw	ra,76(sp)
  801fa8:	afbe0048 	sw	s8,72(sp)
  801fac:	03a0f021 	move	s8,sp
  801fb0:	afc40050 	sw	a0,80(s8)
  801fb4:	afc50054 	sw	a1,84(s8)
  801fb8:	afc60058 	sw	a2,88(s8)
    unsigned long long result = num;
  801fbc:	8fc40060 	lw	a0,96(s8)
  801fc0:	8fc50064 	lw	a1,100(s8)
  801fc4:	00800013 	mtlo	a0
  801fc8:	00a00011 	mthi	a1
  801fcc:	00002012 	mflo	a0
  801fd0:	00002810 	mfhi	a1
  801fd4:	afc40030 	sw	a0,48(s8)
  801fd8:	afc50034 	sw	a1,52(s8)
    unsigned mod = do_div(result, base);
  801fdc:	8fc50068 	lw	a1,104(s8)
  801fe0:	2404000a 	li	a0,10
  801fe4:	14a40040 	bne	a1,a0,8020e8 <printnum+0x148>
  801fe8:	00000000 	nop
  801fec:	8fc40034 	lw	a0,52(s8)
  801ff0:	000427c0 	sll	a0,a0,0x1f
  801ff4:	8fc50030 	lw	a1,48(s8)
  801ff8:	00055042 	srl	t2,a1,0x1
  801ffc:	008a5025 	or	t2,a0,t2
  802000:	8fc40034 	lw	a0,52(s8)
  802004:	00045842 	srl	t3,a0,0x1
  802008:	01402821 	move	a1,t2
  80200c:	8fc40034 	lw	a0,52(s8)
  802010:	00042780 	sll	a0,a0,0x1e
  802014:	8fc60030 	lw	a2,48(s8)
  802018:	00064082 	srl	t0,a2,0x2
  80201c:	00884025 	or	t0,a0,t0
  802020:	8fc40034 	lw	a0,52(s8)
  802024:	00044882 	srl	t1,a0,0x2
  802028:	01002021 	move	a0,t0
  80202c:	00a42021 	addu	a0,a1,a0
  802030:	afc4003c 	sw	a0,60(s8)
  802034:	8fc4003c 	lw	a0,60(s8)
  802038:	00042102 	srl	a0,a0,0x4
  80203c:	8fc5003c 	lw	a1,60(s8)
  802040:	00a42021 	addu	a0,a1,a0
  802044:	afc4003c 	sw	a0,60(s8)
  802048:	8fc4003c 	lw	a0,60(s8)
  80204c:	00042202 	srl	a0,a0,0x8
  802050:	8fc5003c 	lw	a1,60(s8)
  802054:	00a42021 	addu	a0,a1,a0
  802058:	afc4003c 	sw	a0,60(s8)
  80205c:	8fc4003c 	lw	a0,60(s8)
  802060:	00042402 	srl	a0,a0,0x10
  802064:	8fc5003c 	lw	a1,60(s8)
  802068:	00a42021 	addu	a0,a1,a0
  80206c:	afc4003c 	sw	a0,60(s8)
  802070:	8fc4003c 	lw	a0,60(s8)
  802074:	000420c2 	srl	a0,a0,0x3
  802078:	afc4003c 	sw	a0,60(s8)
  80207c:	8fc50030 	lw	a1,48(s8)
  802080:	8fc4003c 	lw	a0,60(s8)
  802084:	00043080 	sll	a2,a0,0x2
  802088:	8fc4003c 	lw	a0,60(s8)
  80208c:	00c42021 	addu	a0,a2,a0
  802090:	00042040 	sll	a0,a0,0x1
  802094:	00a42023 	subu	a0,a1,a0
  802098:	afc40038 	sw	a0,56(s8)
  80209c:	8fc40038 	lw	a0,56(s8)
  8020a0:	24840006 	addiu	a0,a0,6
  8020a4:	00042102 	srl	a0,a0,0x4
  8020a8:	8fc5003c 	lw	a1,60(s8)
  8020ac:	00a42021 	addu	a0,a1,a0
  8020b0:	afc4003c 	sw	a0,60(s8)
  8020b4:	8fc50030 	lw	a1,48(s8)
  8020b8:	8fc4003c 	lw	a0,60(s8)
  8020bc:	00043080 	sll	a2,a0,0x2
  8020c0:	8fc4003c 	lw	a0,60(s8)
  8020c4:	00c42021 	addu	a0,a2,a0
  8020c8:	00042040 	sll	a0,a0,0x1
  8020cc:	00a42023 	subu	a0,a1,a0
  8020d0:	afc40038 	sw	a0,56(s8)
  8020d4:	8fc4003c 	lw	a0,60(s8)
  8020d8:	afc40030 	sw	a0,48(s8)
  8020dc:	afc00034 	sw	zero,52(s8)
  8020e0:	0820087c 	j	8021f0 <printnum+0x250>
  8020e4:	00000000 	nop
  8020e8:	8fc50068 	lw	a1,104(s8)
  8020ec:	24040010 	li	a0,16
  8020f0:	14a4000f 	bne	a1,a0,802130 <printnum+0x190>
  8020f4:	00000000 	nop
  8020f8:	8fc40030 	lw	a0,48(s8)
  8020fc:	3084000f 	andi	a0,a0,0xf
  802100:	afc40038 	sw	a0,56(s8)
  802104:	8fc40034 	lw	a0,52(s8)
  802108:	00042700 	sll	a0,a0,0x1c
  80210c:	8fc50030 	lw	a1,48(s8)
  802110:	00052902 	srl	a1,a1,0x4
  802114:	00a42025 	or	a0,a1,a0
  802118:	afc40030 	sw	a0,48(s8)
  80211c:	8fc40034 	lw	a0,52(s8)
  802120:	00042102 	srl	a0,a0,0x4
  802124:	afc40034 	sw	a0,52(s8)
  802128:	0820087c 	j	8021f0 <printnum+0x250>
  80212c:	00000000 	nop
  802130:	8fc50068 	lw	a1,104(s8)
  802134:	24040008 	li	a0,8
  802138:	14a4000f 	bne	a1,a0,802178 <printnum+0x1d8>
  80213c:	00000000 	nop
  802140:	8fc40030 	lw	a0,48(s8)
  802144:	30840007 	andi	a0,a0,0x7
  802148:	afc40038 	sw	a0,56(s8)
  80214c:	8fc40034 	lw	a0,52(s8)
  802150:	00042740 	sll	a0,a0,0x1d
  802154:	8fc50030 	lw	a1,48(s8)
  802158:	000528c2 	srl	a1,a1,0x3
  80215c:	00a42025 	or	a0,a1,a0
  802160:	afc40030 	sw	a0,48(s8)
  802164:	8fc40034 	lw	a0,52(s8)
  802168:	000420c2 	srl	a0,a0,0x3
  80216c:	afc40034 	sw	a0,52(s8)
  802170:	0820087c 	j	8021f0 <printnum+0x250>
  802174:	00000000 	nop
  802178:	8fc50068 	lw	a1,104(s8)
  80217c:	3c048000 	lui	a0,0x8000
  802180:	14a40011 	bne	a1,a0,8021c8 <printnum+0x228>
  802184:	00000000 	nop
  802188:	8fc50030 	lw	a1,48(s8)
  80218c:	3c047fff 	lui	a0,0x7fff
  802190:	3484ffff 	ori	a0,a0,0xffff
  802194:	00a42024 	and	a0,a1,a0
  802198:	afc40038 	sw	a0,56(s8)
  80219c:	8fc40034 	lw	a0,52(s8)
  8021a0:	00042040 	sll	a0,a0,0x1
  8021a4:	8fc50030 	lw	a1,48(s8)
  8021a8:	00052fc2 	srl	a1,a1,0x1f
  8021ac:	00a42025 	or	a0,a1,a0
  8021b0:	afc40030 	sw	a0,48(s8)
  8021b4:	8fc40034 	lw	a0,52(s8)
  8021b8:	000427c2 	srl	a0,a0,0x1f
  8021bc:	afc40034 	sw	a0,52(s8)
  8021c0:	0820087c 	j	8021f0 <printnum+0x250>
  8021c4:	00000000 	nop
  8021c8:	24040003 	li	a0,3
  8021cc:	afc40038 	sw	a0,56(s8)
  8021d0:	24040001 	li	a0,1
  8021d4:	00002821 	move	a1,zero
  8021d8:	00800013 	mtlo	a0
  8021dc:	00a00011 	mthi	a1
  8021e0:	00002012 	mflo	a0
  8021e4:	00002810 	mfhi	a1
  8021e8:	afc40030 	sw	a0,48(s8)
  8021ec:	afc50034 	sw	a1,52(s8)
  8021f0:	8fc40038 	lw	a0,56(s8)
  8021f4:	afc40040 	sw	a0,64(s8)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  8021f8:	8fc40068 	lw	a0,104(s8)
  8021fc:	00801021 	move	v0,a0
  802200:	00001821 	move	v1,zero
  802204:	8fc40064 	lw	a0,100(s8)
  802208:	0083202b 	sltu	a0,a0,v1
  80220c:	14800026 	bnez	a0,8022a8 <printnum+0x308>
  802210:	00000000 	nop
  802214:	8fc50064 	lw	a1,100(s8)
  802218:	00602021 	move	a0,v1
  80221c:	14a40005 	bne	a1,a0,802234 <printnum+0x294>
  802220:	00000000 	nop
  802224:	8fc40060 	lw	a0,96(s8)
  802228:	0082102b 	sltu	v0,a0,v0
  80222c:	1440001e 	bnez	v0,8022a8 <printnum+0x308>
  802230:	00000000 	nop
        printnum(putch, fd, putdat, result, base, width - 1, padc);
  802234:	8fc2006c 	lw	v0,108(s8)
  802238:	2442ffff 	addiu	v0,v0,-1
  80223c:	8fc40030 	lw	a0,48(s8)
  802240:	8fc50034 	lw	a1,52(s8)
  802244:	00800013 	mtlo	a0
  802248:	00a00011 	mthi	a1
  80224c:	00002012 	mflo	a0
  802250:	00002810 	mfhi	a1
  802254:	afa40010 	sw	a0,16(sp)
  802258:	afa50014 	sw	a1,20(sp)
  80225c:	8fc30068 	lw	v1,104(s8)
  802260:	afa30018 	sw	v1,24(sp)
  802264:	afa2001c 	sw	v0,28(sp)
  802268:	8fc20070 	lw	v0,112(s8)
  80226c:	afa20020 	sw	v0,32(sp)
  802270:	8fc40050 	lw	a0,80(s8)
  802274:	8fc50054 	lw	a1,84(s8)
  802278:	8fc60058 	lw	a2,88(s8)
  80227c:	0c2007e8 	jal	801fa0 <printnum>
  802280:	00000000 	nop
  802284:	082008b0 	j	8022c0 <printnum+0x320>
  802288:	00000000 	nop
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat, fd);
  80228c:	8fc20050 	lw	v0,80(s8)
  802290:	8fc40070 	lw	a0,112(s8)
  802294:	8fc50058 	lw	a1,88(s8)
  802298:	8fc60054 	lw	a2,84(s8)
  80229c:	0040c821 	move	t9,v0
  8022a0:	0320f809 	jalr	t9
  8022a4:	00000000 	nop
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, fd, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  8022a8:	8fc2006c 	lw	v0,108(s8)
  8022ac:	2442ffff 	addiu	v0,v0,-1
  8022b0:	afc2006c 	sw	v0,108(s8)
  8022b4:	8fc2006c 	lw	v0,108(s8)
  8022b8:	1c40fff4 	bgtz	v0,80228c <printnum+0x2ec>
  8022bc:	00000000 	nop
            putch(padc, putdat, fd);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat, fd);
  8022c0:	3c020080 	lui	v0,0x80
  8022c4:	244333a0 	addiu	v1,v0,13216
  8022c8:	8fc20040 	lw	v0,64(s8)
  8022cc:	00621021 	addu	v0,v1,v0
  8022d0:	80420000 	lb	v0,0(v0)
  8022d4:	00401821 	move	v1,v0
  8022d8:	8fc20050 	lw	v0,80(s8)
  8022dc:	00602021 	move	a0,v1
  8022e0:	8fc50058 	lw	a1,88(s8)
  8022e4:	8fc60054 	lw	a2,84(s8)
  8022e8:	0040c821 	move	t9,v0
  8022ec:	0320f809 	jalr	t9
  8022f0:	00000000 	nop
}
  8022f4:	03c0e821 	move	sp,s8
  8022f8:	8fbf004c 	lw	ra,76(sp)
  8022fc:	8fbe0048 	lw	s8,72(sp)
  802300:	27bd0050 	addiu	sp,sp,80
  802304:	03e00008 	jr	ra
  802308:	00000000 	nop

0080230c <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  80230c:	27bdfff8 	addiu	sp,sp,-8
  802310:	afbe0004 	sw	s8,4(sp)
  802314:	03a0f021 	move	s8,sp
  802318:	afc40008 	sw	a0,8(s8)
  80231c:	afc5000c 	sw	a1,12(s8)
    if (lflag >= 2) {
  802320:	8fc4000c 	lw	a0,12(s8)
  802324:	28840002 	slti	a0,a0,2
  802328:	1480000d 	bnez	a0,802360 <getuint+0x54>
  80232c:	00000000 	nop
        return va_arg(*ap, unsigned long long);
  802330:	8fc20008 	lw	v0,8(s8)
  802334:	8c420000 	lw	v0,0(v0)
  802338:	24430007 	addiu	v1,v0,7
  80233c:	2402fff8 	li	v0,-8
  802340:	00621024 	and	v0,v1,v0
  802344:	24440008 	addiu	a0,v0,8
  802348:	8fc30008 	lw	v1,8(s8)
  80234c:	ac640000 	sw	a0,0(v1)
  802350:	8c430004 	lw	v1,4(v0)
  802354:	8c420000 	lw	v0,0(v0)
  802358:	082008ed 	j	8023b4 <getuint+0xa8>
  80235c:	00000000 	nop
    }
    else if (lflag) {
  802360:	8fc4000c 	lw	a0,12(s8)
  802364:	1080000b 	beqz	a0,802394 <getuint+0x88>
  802368:	00000000 	nop
        return va_arg(*ap, unsigned long);
  80236c:	8fc40008 	lw	a0,8(s8)
  802370:	8c840000 	lw	a0,0(a0)
  802374:	24860004 	addiu	a2,a0,4
  802378:	8fc50008 	lw	a1,8(s8)
  80237c:	aca60000 	sw	a2,0(a1)
  802380:	8c840000 	lw	a0,0(a0)
  802384:	00801021 	move	v0,a0
  802388:	00001821 	move	v1,zero
  80238c:	082008ed 	j	8023b4 <getuint+0xa8>
  802390:	00000000 	nop
    }
    else {
        return va_arg(*ap, unsigned int);
  802394:	8fc40008 	lw	a0,8(s8)
  802398:	8c840000 	lw	a0,0(a0)
  80239c:	24860004 	addiu	a2,a0,4
  8023a0:	8fc50008 	lw	a1,8(s8)
  8023a4:	aca60000 	sw	a2,0(a1)
  8023a8:	8c840000 	lw	a0,0(a0)
  8023ac:	00801021 	move	v0,a0
  8023b0:	00001821 	move	v1,zero
  8023b4:	00400013 	mtlo	v0
  8023b8:	00600011 	mthi	v1
    }
}
  8023bc:	00001012 	mflo	v0
  8023c0:	00001810 	mfhi	v1
  8023c4:	03c0e821 	move	sp,s8
  8023c8:	8fbe0004 	lw	s8,4(sp)
  8023cc:	27bd0008 	addiu	sp,sp,8
  8023d0:	03e00008 	jr	ra
  8023d4:	00000000 	nop

008023d8 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  8023d8:	27bdfff8 	addiu	sp,sp,-8
  8023dc:	afbe0004 	sw	s8,4(sp)
  8023e0:	03a0f021 	move	s8,sp
  8023e4:	afc40008 	sw	a0,8(s8)
  8023e8:	afc5000c 	sw	a1,12(s8)
    if (lflag >= 2) {
  8023ec:	8fc4000c 	lw	a0,12(s8)
  8023f0:	28840002 	slti	a0,a0,2
  8023f4:	1480000d 	bnez	a0,80242c <getint+0x54>
  8023f8:	00000000 	nop
        return va_arg(*ap, long long);
  8023fc:	8fc20008 	lw	v0,8(s8)
  802400:	8c420000 	lw	v0,0(v0)
  802404:	24430007 	addiu	v1,v0,7
  802408:	2402fff8 	li	v0,-8
  80240c:	00621024 	and	v0,v1,v0
  802410:	24440008 	addiu	a0,v0,8
  802414:	8fc30008 	lw	v1,8(s8)
  802418:	ac640000 	sw	a0,0(v1)
  80241c:	8c430004 	lw	v1,4(v0)
  802420:	8c420000 	lw	v0,0(v0)
  802424:	08200922 	j	802488 <getint+0xb0>
  802428:	00000000 	nop
    }
    else if (lflag) {
  80242c:	8fc4000c 	lw	a0,12(s8)
  802430:	1080000c 	beqz	a0,802464 <getint+0x8c>
  802434:	00000000 	nop
        return va_arg(*ap, long);
  802438:	8fc40008 	lw	a0,8(s8)
  80243c:	8c840000 	lw	a0,0(a0)
  802440:	24860004 	addiu	a2,a0,4
  802444:	8fc50008 	lw	a1,8(s8)
  802448:	aca60000 	sw	a2,0(a1)
  80244c:	8c840000 	lw	a0,0(a0)
  802450:	00801021 	move	v0,a0
  802454:	000427c3 	sra	a0,a0,0x1f
  802458:	00801821 	move	v1,a0
  80245c:	08200922 	j	802488 <getint+0xb0>
  802460:	00000000 	nop
    }
    else {
        return va_arg(*ap, int);
  802464:	8fc40008 	lw	a0,8(s8)
  802468:	8c840000 	lw	a0,0(a0)
  80246c:	24860004 	addiu	a2,a0,4
  802470:	8fc50008 	lw	a1,8(s8)
  802474:	aca60000 	sw	a2,0(a1)
  802478:	8c840000 	lw	a0,0(a0)
  80247c:	00801021 	move	v0,a0
  802480:	000427c3 	sra	a0,a0,0x1f
  802484:	00801821 	move	v1,a0
  802488:	00400013 	mtlo	v0
  80248c:	00600011 	mthi	v1
    }
}
  802490:	00001012 	mflo	v0
  802494:	00001810 	mfhi	v1
  802498:	03c0e821 	move	sp,s8
  80249c:	8fbe0004 	lw	s8,4(sp)
  8024a0:	27bd0008 	addiu	sp,sp,8
  8024a4:	03e00008 	jr	ra
  8024a8:	00000000 	nop

008024ac <printfmt>:
 * @fd:         file descriptor
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*, int), int fd, void *putdat, const char *fmt, ...) {
  8024ac:	27bdffd0 	addiu	sp,sp,-48
  8024b0:	afbf002c 	sw	ra,44(sp)
  8024b4:	afbe0028 	sw	s8,40(sp)
  8024b8:	03a0f021 	move	s8,sp
  8024bc:	afc40030 	sw	a0,48(s8)
  8024c0:	afc50034 	sw	a1,52(s8)
  8024c4:	afc60038 	sw	a2,56(s8)
  8024c8:	afc7003c 	sw	a3,60(s8)
    va_list ap;

    va_start(ap, fmt);
  8024cc:	27c20040 	addiu	v0,s8,64
  8024d0:	afc20020 	sw	v0,32(s8)
    vprintfmt(putch, fd, putdat, fmt, ap);
  8024d4:	8fc20020 	lw	v0,32(s8)
  8024d8:	afa20010 	sw	v0,16(sp)
  8024dc:	8fc40030 	lw	a0,48(s8)
  8024e0:	8fc50034 	lw	a1,52(s8)
  8024e4:	8fc60038 	lw	a2,56(s8)
  8024e8:	8fc7003c 	lw	a3,60(s8)
  8024ec:	0c200943 	jal	80250c <vprintfmt>
  8024f0:	00000000 	nop
    va_end(ap);
}
  8024f4:	03c0e821 	move	sp,s8
  8024f8:	8fbf002c 	lw	ra,44(sp)
  8024fc:	8fbe0028 	lw	s8,40(sp)
  802500:	27bd0030 	addiu	sp,sp,48
  802504:	03e00008 	jr	ra
  802508:	00000000 	nop

0080250c <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*, int), int fd, void *putdat, const char *fmt, va_list ap) {
  80250c:	27bdffa0 	addiu	sp,sp,-96
  802510:	afbf005c 	sw	ra,92(sp)
  802514:	afbe0058 	sw	s8,88(sp)
  802518:	afb10054 	sw	s1,84(sp)
  80251c:	afb00050 	sw	s0,80(sp)
  802520:	03a0f021 	move	s8,sp
  802524:	afc40060 	sw	a0,96(s8)
  802528:	afc50064 	sw	a1,100(s8)
  80252c:	afc60068 	sw	a2,104(s8)
  802530:	afc7006c 	sw	a3,108(s8)
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  802534:	0820095a 	j	802568 <vprintfmt+0x5c>
  802538:	00000000 	nop
            if (ch == '\0') {
  80253c:	16000003 	bnez	s0,80254c <vprintfmt+0x40>
  802540:	00000000 	nop
                return;
  802544:	08200aec 	j	802bb0 <vprintfmt+0x6a4>
  802548:	00000000 	nop
            }
            putch(ch, putdat, fd);
  80254c:	8fc20060 	lw	v0,96(s8)
  802550:	02002021 	move	a0,s0
  802554:	8fc50068 	lw	a1,104(s8)
  802558:	8fc60064 	lw	a2,100(s8)
  80255c:	0040c821 	move	t9,v0
  802560:	0320f809 	jalr	t9
  802564:	00000000 	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  802568:	8fc2006c 	lw	v0,108(s8)
  80256c:	24430001 	addiu	v1,v0,1
  802570:	afc3006c 	sw	v1,108(s8)
  802574:	90420000 	lbu	v0,0(v0)
  802578:	00408021 	move	s0,v0
  80257c:	24020025 	li	v0,37
  802580:	1602ffee 	bne	s0,v0,80253c <vprintfmt+0x30>
  802584:	00000000 	nop
            }
            putch(ch, putdat, fd);
        }

        // Process a %-escape sequence
        char padc = ' ';
  802588:	24020020 	li	v0,32
  80258c:	a3c2004c 	sb	v0,76(s8)
        width = precision = -1;
  802590:	2402ffff 	li	v0,-1
  802594:	afc20040 	sw	v0,64(s8)
  802598:	8fc20040 	lw	v0,64(s8)
  80259c:	afc2003c 	sw	v0,60(s8)
        lflag = altflag = 0;
  8025a0:	afc00048 	sw	zero,72(s8)
  8025a4:	8fc20048 	lw	v0,72(s8)
  8025a8:	afc20044 	sw	v0,68(s8)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  8025ac:	8fc2006c 	lw	v0,108(s8)
  8025b0:	24430001 	addiu	v1,v0,1
  8025b4:	afc3006c 	sw	v1,108(s8)
  8025b8:	90420000 	lbu	v0,0(v0)
  8025bc:	00408021 	move	s0,v0
  8025c0:	2602ffdd 	addiu	v0,s0,-35
  8025c4:	2c430056 	sltiu	v1,v0,86
  8025c8:	10600160 	beqz	v1,802b4c <vprintfmt+0x640>
  8025cc:	00000000 	nop
  8025d0:	00021880 	sll	v1,v0,0x2
  8025d4:	3c020080 	lui	v0,0x80
  8025d8:	244233cc 	addiu	v0,v0,13260
  8025dc:	00621021 	addu	v0,v1,v0
  8025e0:	8c420000 	lw	v0,0(v0)
  8025e4:	00400008 	jr	v0
  8025e8:	00000000 	nop

        // flag to pad on the right
        case '-':
            padc = '-';
  8025ec:	2402002d 	li	v0,45
  8025f0:	a3c2004c 	sb	v0,76(s8)
            goto reswitch;
  8025f4:	0820096b 	j	8025ac <vprintfmt+0xa0>
  8025f8:	00000000 	nop

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  8025fc:	24020030 	li	v0,48
  802600:	a3c2004c 	sb	v0,76(s8)
            goto reswitch;
  802604:	0820096b 	j	8025ac <vprintfmt+0xa0>
  802608:	00000000 	nop

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  80260c:	afc00040 	sw	zero,64(s8)
                precision = precision * 10 + ch - '0';
  802610:	8fc20040 	lw	v0,64(s8)
  802614:	00021040 	sll	v0,v0,0x1
  802618:	00021880 	sll	v1,v0,0x2
  80261c:	00431021 	addu	v0,v0,v1
  802620:	00501021 	addu	v0,v0,s0
  802624:	2442ffd0 	addiu	v0,v0,-48
  802628:	afc20040 	sw	v0,64(s8)
                ch = *fmt;
  80262c:	8fc2006c 	lw	v0,108(s8)
  802630:	80420000 	lb	v0,0(v0)
  802634:	00408021 	move	s0,v0
                if (ch < '0' || ch > '9') {
  802638:	2a020030 	slti	v0,s0,48
  80263c:	14400009 	bnez	v0,802664 <vprintfmt+0x158>
  802640:	00000000 	nop
  802644:	2a02003a 	slti	v0,s0,58
  802648:	10400006 	beqz	v0,802664 <vprintfmt+0x158>
  80264c:	00000000 	nop
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  802650:	8fc2006c 	lw	v0,108(s8)
  802654:	24420001 	addiu	v0,v0,1
  802658:	afc2006c 	sw	v0,108(s8)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  80265c:	08200984 	j	802610 <vprintfmt+0x104>
  802660:	00000000 	nop
            goto process_precision;
  802664:	082009ae 	j	8026b8 <vprintfmt+0x1ac>
  802668:	00000000 	nop

        case '*':
            precision = va_arg(ap, int);
  80266c:	8fc20070 	lw	v0,112(s8)
  802670:	24430004 	addiu	v1,v0,4
  802674:	afc30070 	sw	v1,112(s8)
  802678:	8c420000 	lw	v0,0(v0)
  80267c:	afc20040 	sw	v0,64(s8)
            goto process_precision;
  802680:	082009ae 	j	8026b8 <vprintfmt+0x1ac>
  802684:	00000000 	nop

        case '.':
            if (width < 0)
  802688:	8fc2003c 	lw	v0,60(s8)
  80268c:	04410004 	bgez	v0,8026a0 <vprintfmt+0x194>
  802690:	00000000 	nop
                width = 0;
  802694:	afc0003c 	sw	zero,60(s8)
            goto reswitch;
  802698:	0820096b 	j	8025ac <vprintfmt+0xa0>
  80269c:	00000000 	nop
  8026a0:	0820096b 	j	8025ac <vprintfmt+0xa0>
  8026a4:	00000000 	nop

        case '#':
            altflag = 1;
  8026a8:	24020001 	li	v0,1
  8026ac:	afc20048 	sw	v0,72(s8)
            goto reswitch;
  8026b0:	0820096b 	j	8025ac <vprintfmt+0xa0>
  8026b4:	00000000 	nop

        process_precision:
            if (width < 0)
  8026b8:	8fc2003c 	lw	v0,60(s8)
  8026bc:	04410007 	bgez	v0,8026dc <vprintfmt+0x1d0>
  8026c0:	00000000 	nop
                width = precision, precision = -1;
  8026c4:	8fc20040 	lw	v0,64(s8)
  8026c8:	afc2003c 	sw	v0,60(s8)
  8026cc:	2402ffff 	li	v0,-1
  8026d0:	afc20040 	sw	v0,64(s8)
            goto reswitch;
  8026d4:	0820096b 	j	8025ac <vprintfmt+0xa0>
  8026d8:	00000000 	nop
  8026dc:	0820096b 	j	8025ac <vprintfmt+0xa0>
  8026e0:	00000000 	nop

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  8026e4:	8fc20044 	lw	v0,68(s8)
  8026e8:	24420001 	addiu	v0,v0,1
  8026ec:	afc20044 	sw	v0,68(s8)
            goto reswitch;
  8026f0:	0820096b 	j	8025ac <vprintfmt+0xa0>
  8026f4:	00000000 	nop

        // character
        case 'c':
            putch(va_arg(ap, int), putdat, fd);
  8026f8:	8fc20070 	lw	v0,112(s8)
  8026fc:	24430004 	addiu	v1,v0,4
  802700:	afc30070 	sw	v1,112(s8)
  802704:	8c430000 	lw	v1,0(v0)
  802708:	8fc20060 	lw	v0,96(s8)
  80270c:	00602021 	move	a0,v1
  802710:	8fc50068 	lw	a1,104(s8)
  802714:	8fc60064 	lw	a2,100(s8)
  802718:	0040c821 	move	t9,v0
  80271c:	0320f809 	jalr	t9
  802720:	00000000 	nop
            break;
  802724:	08200ae9 	j	802ba4 <vprintfmt+0x698>
  802728:	00000000 	nop

        // error message
        case 'e':
            err = va_arg(ap, int);
  80272c:	8fc20070 	lw	v0,112(s8)
  802730:	24430004 	addiu	v1,v0,4
  802734:	afc30070 	sw	v1,112(s8)
  802738:	8c5f0000 	lw	ra,0(v0)
            if (err < 0) {
  80273c:	07e10002 	bgez	ra,802748 <vprintfmt+0x23c>
  802740:	00000000 	nop
                err = -err;
  802744:	001ff823 	negu	ra,ra
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  802748:	2be20019 	slti	v0,ra,25
  80274c:	10400008 	beqz	v0,802770 <vprintfmt+0x264>
  802750:	00000000 	nop
  802754:	3c020080 	lui	v0,0x80
  802758:	001f1880 	sll	v1,ra,0x2
  80275c:	2442333c 	addiu	v0,v0,13116
  802760:	00621021 	addu	v0,v1,v0
  802764:	8c510000 	lw	s1,0(v0)
  802768:	1620000b 	bnez	s1,802798 <vprintfmt+0x28c>
  80276c:	00000000 	nop
                printfmt(putch, fd, putdat, "error %d", err);
  802770:	afbf0010 	sw	ra,16(sp)
  802774:	8fc40060 	lw	a0,96(s8)
  802778:	8fc50064 	lw	a1,100(s8)
  80277c:	8fc60068 	lw	a2,104(s8)
  802780:	3c020080 	lui	v0,0x80
  802784:	244733b4 	addiu	a3,v0,13236
  802788:	0c20092b 	jal	8024ac <printfmt>
  80278c:	00000000 	nop
            }
            else {
                printfmt(putch, fd, putdat, "%s", p);
            }
            break;
  802790:	08200ae9 	j	802ba4 <vprintfmt+0x698>
  802794:	00000000 	nop
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, fd, putdat, "error %d", err);
            }
            else {
                printfmt(putch, fd, putdat, "%s", p);
  802798:	afb10010 	sw	s1,16(sp)
  80279c:	8fc40060 	lw	a0,96(s8)
  8027a0:	8fc50064 	lw	a1,100(s8)
  8027a4:	8fc60068 	lw	a2,104(s8)
  8027a8:	3c020080 	lui	v0,0x80
  8027ac:	244733c0 	addiu	a3,v0,13248
  8027b0:	0c20092b 	jal	8024ac <printfmt>
  8027b4:	00000000 	nop
            }
            break;
  8027b8:	08200ae9 	j	802ba4 <vprintfmt+0x698>
  8027bc:	00000000 	nop

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  8027c0:	8fc20070 	lw	v0,112(s8)
  8027c4:	24430004 	addiu	v1,v0,4
  8027c8:	afc30070 	sw	v1,112(s8)
  8027cc:	8c510000 	lw	s1,0(v0)
  8027d0:	16200003 	bnez	s1,8027e0 <vprintfmt+0x2d4>
  8027d4:	00000000 	nop
                p = "(null)";
  8027d8:	3c020080 	lui	v0,0x80
  8027dc:	245133c4 	addiu	s1,v0,13252
            }
            if (width > 0 && padc != '-') {
  8027e0:	8fc2003c 	lw	v0,60(s8)
  8027e4:	1840001d 	blez	v0,80285c <vprintfmt+0x350>
  8027e8:	00000000 	nop
  8027ec:	83c3004c 	lb	v1,76(s8)
  8027f0:	2402002d 	li	v0,45
  8027f4:	10620019 	beq	v1,v0,80285c <vprintfmt+0x350>
  8027f8:	00000000 	nop
                for (width -= strnlen(p, precision); width > 0; width --) {
  8027fc:	8fd0003c 	lw	s0,60(s8)
  802800:	8fc20040 	lw	v0,64(s8)
  802804:	02202021 	move	a0,s1
  802808:	00402821 	move	a1,v0
  80280c:	0c200566 	jal	801598 <strnlen>
  802810:	00000000 	nop
  802814:	02021023 	subu	v0,s0,v0
  802818:	afc2003c 	sw	v0,60(s8)
  80281c:	08200a14 	j	802850 <vprintfmt+0x344>
  802820:	00000000 	nop
                    putch(padc, putdat, fd);
  802824:	83c3004c 	lb	v1,76(s8)
  802828:	8fc20060 	lw	v0,96(s8)
  80282c:	00602021 	move	a0,v1
  802830:	8fc50068 	lw	a1,104(s8)
  802834:	8fc60064 	lw	a2,100(s8)
  802838:	0040c821 	move	t9,v0
  80283c:	0320f809 	jalr	t9
  802840:	00000000 	nop
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  802844:	8fc2003c 	lw	v0,60(s8)
  802848:	2442ffff 	addiu	v0,v0,-1
  80284c:	afc2003c 	sw	v0,60(s8)
  802850:	8fc2003c 	lw	v0,60(s8)
  802854:	1c40fff3 	bgtz	v0,802824 <vprintfmt+0x318>
  802858:	00000000 	nop
                    putch(padc, putdat, fd);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80285c:	08200a35 	j	8028d4 <vprintfmt+0x3c8>
  802860:	00000000 	nop
                if (altflag && (ch < ' ' || ch > '~')) {
  802864:	8fc20048 	lw	v0,72(s8)
  802868:	10400010 	beqz	v0,8028ac <vprintfmt+0x3a0>
  80286c:	00000000 	nop
  802870:	2a020020 	slti	v0,s0,32
  802874:	14400004 	bnez	v0,802888 <vprintfmt+0x37c>
  802878:	00000000 	nop
  80287c:	2a02007f 	slti	v0,s0,127
  802880:	1440000a 	bnez	v0,8028ac <vprintfmt+0x3a0>
  802884:	00000000 	nop
                    putch('?', putdat, fd);
  802888:	8fc20060 	lw	v0,96(s8)
  80288c:	2404003f 	li	a0,63
  802890:	8fc50068 	lw	a1,104(s8)
  802894:	8fc60064 	lw	a2,100(s8)
  802898:	0040c821 	move	t9,v0
  80289c:	0320f809 	jalr	t9
  8028a0:	00000000 	nop
  8028a4:	08200a32 	j	8028c8 <vprintfmt+0x3bc>
  8028a8:	00000000 	nop
                }
                else {
                    putch(ch, putdat, fd);
  8028ac:	8fc20060 	lw	v0,96(s8)
  8028b0:	02002021 	move	a0,s0
  8028b4:	8fc50068 	lw	a1,104(s8)
  8028b8:	8fc60064 	lw	a2,100(s8)
  8028bc:	0040c821 	move	t9,v0
  8028c0:	0320f809 	jalr	t9
  8028c4:	00000000 	nop
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat, fd);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8028c8:	8fc2003c 	lw	v0,60(s8)
  8028cc:	2442ffff 	addiu	v0,v0,-1
  8028d0:	afc2003c 	sw	v0,60(s8)
  8028d4:	02201021 	move	v0,s1
  8028d8:	24510001 	addiu	s1,v0,1
  8028dc:	80420000 	lb	v0,0(v0)
  8028e0:	00408021 	move	s0,v0
  8028e4:	1200000a 	beqz	s0,802910 <vprintfmt+0x404>
  8028e8:	00000000 	nop
  8028ec:	8fc20040 	lw	v0,64(s8)
  8028f0:	0440ffdc 	bltz	v0,802864 <vprintfmt+0x358>
  8028f4:	00000000 	nop
  8028f8:	8fc20040 	lw	v0,64(s8)
  8028fc:	2442ffff 	addiu	v0,v0,-1
  802900:	afc20040 	sw	v0,64(s8)
  802904:	8fc20040 	lw	v0,64(s8)
  802908:	0441ffd6 	bgez	v0,802864 <vprintfmt+0x358>
  80290c:	00000000 	nop
                }
                else {
                    putch(ch, putdat, fd);
                }
            }
            for (; width > 0; width --) {
  802910:	08200a50 	j	802940 <vprintfmt+0x434>
  802914:	00000000 	nop
                putch(' ', putdat, fd);
  802918:	8fc20060 	lw	v0,96(s8)
  80291c:	24040020 	li	a0,32
  802920:	8fc50068 	lw	a1,104(s8)
  802924:	8fc60064 	lw	a2,100(s8)
  802928:	0040c821 	move	t9,v0
  80292c:	0320f809 	jalr	t9
  802930:	00000000 	nop
                }
                else {
                    putch(ch, putdat, fd);
                }
            }
            for (; width > 0; width --) {
  802934:	8fc2003c 	lw	v0,60(s8)
  802938:	2442ffff 	addiu	v0,v0,-1
  80293c:	afc2003c 	sw	v0,60(s8)
  802940:	8fc2003c 	lw	v0,60(s8)
  802944:	1c40fff4 	bgtz	v0,802918 <vprintfmt+0x40c>
  802948:	00000000 	nop
                putch(' ', putdat, fd);
            }
            break;
  80294c:	08200ae9 	j	802ba4 <vprintfmt+0x698>
  802950:	00000000 	nop

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  802954:	27c20070 	addiu	v0,s8,112
  802958:	00402021 	move	a0,v0
  80295c:	8fc50044 	lw	a1,68(s8)
  802960:	0c2008f6 	jal	8023d8 <getint>
  802964:	00000000 	nop
  802968:	00400013 	mtlo	v0
  80296c:	00600011 	mthi	v1
  802970:	00001012 	mflo	v0
  802974:	00001810 	mfhi	v1
  802978:	afc20030 	sw	v0,48(s8)
  80297c:	afc30034 	sw	v1,52(s8)
            if ((long long)num < 0) {
  802980:	8fc20030 	lw	v0,48(s8)
  802984:	8fc30034 	lw	v1,52(s8)
  802988:	04610017 	bgez	v1,8029e8 <vprintfmt+0x4dc>
  80298c:	00000000 	nop
                putch('-', putdat, fd);
  802990:	8fc20060 	lw	v0,96(s8)
  802994:	2404002d 	li	a0,45
  802998:	8fc50068 	lw	a1,104(s8)
  80299c:	8fc60064 	lw	a2,100(s8)
  8029a0:	0040c821 	move	t9,v0
  8029a4:	0320f809 	jalr	t9
  8029a8:	00000000 	nop
                num = -(long long)num;
  8029ac:	8fc60030 	lw	a2,48(s8)
  8029b0:	8fc70034 	lw	a3,52(s8)
  8029b4:	00002021 	move	a0,zero
  8029b8:	00002821 	move	a1,zero
  8029bc:	00861023 	subu	v0,a0,a2
  8029c0:	0082402b 	sltu	t0,a0,v0
  8029c4:	00a71823 	subu	v1,a1,a3
  8029c8:	00682023 	subu	a0,v1,t0
  8029cc:	00801821 	move	v1,a0
  8029d0:	00400013 	mtlo	v0
  8029d4:	00600011 	mthi	v1
  8029d8:	00001012 	mflo	v0
  8029dc:	00001810 	mfhi	v1
  8029e0:	afc20030 	sw	v0,48(s8)
  8029e4:	afc30034 	sw	v1,52(s8)
            }
            base = 10;
  8029e8:	2402000a 	li	v0,10
  8029ec:	afc20038 	sw	v0,56(s8)
            goto number;
  8029f0:	08200ab5 	j	802ad4 <vprintfmt+0x5c8>
  8029f4:	00000000 	nop

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  8029f8:	27c20070 	addiu	v0,s8,112
  8029fc:	00402021 	move	a0,v0
  802a00:	8fc50044 	lw	a1,68(s8)
  802a04:	0c2008c3 	jal	80230c <getuint>
  802a08:	00000000 	nop
  802a0c:	afc20030 	sw	v0,48(s8)
  802a10:	afc30034 	sw	v1,52(s8)
            base = 10;
  802a14:	2402000a 	li	v0,10
  802a18:	afc20038 	sw	v0,56(s8)
            goto number;
  802a1c:	08200ab5 	j	802ad4 <vprintfmt+0x5c8>
  802a20:	00000000 	nop

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  802a24:	27c20070 	addiu	v0,s8,112
  802a28:	00402021 	move	a0,v0
  802a2c:	8fc50044 	lw	a1,68(s8)
  802a30:	0c2008c3 	jal	80230c <getuint>
  802a34:	00000000 	nop
  802a38:	afc20030 	sw	v0,48(s8)
  802a3c:	afc30034 	sw	v1,52(s8)
            base = 8;
  802a40:	24020008 	li	v0,8
  802a44:	afc20038 	sw	v0,56(s8)
            goto number;
  802a48:	08200ab5 	j	802ad4 <vprintfmt+0x5c8>
  802a4c:	00000000 	nop

        // pointer
        case 'p':
            putch('0', putdat, fd);
  802a50:	8fc20060 	lw	v0,96(s8)
  802a54:	24040030 	li	a0,48
  802a58:	8fc50068 	lw	a1,104(s8)
  802a5c:	8fc60064 	lw	a2,100(s8)
  802a60:	0040c821 	move	t9,v0
  802a64:	0320f809 	jalr	t9
  802a68:	00000000 	nop
            putch('x', putdat, fd);
  802a6c:	8fc20060 	lw	v0,96(s8)
  802a70:	24040078 	li	a0,120
  802a74:	8fc50068 	lw	a1,104(s8)
  802a78:	8fc60064 	lw	a2,100(s8)
  802a7c:	0040c821 	move	t9,v0
  802a80:	0320f809 	jalr	t9
  802a84:	00000000 	nop
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  802a88:	8fc20070 	lw	v0,112(s8)
  802a8c:	24430004 	addiu	v1,v0,4
  802a90:	afc30070 	sw	v1,112(s8)
  802a94:	8c420000 	lw	v0,0(v0)
  802a98:	afc20030 	sw	v0,48(s8)
  802a9c:	afc00034 	sw	zero,52(s8)
            base = 16;
  802aa0:	24020010 	li	v0,16
  802aa4:	afc20038 	sw	v0,56(s8)
            goto number;
  802aa8:	08200ab5 	j	802ad4 <vprintfmt+0x5c8>
  802aac:	00000000 	nop

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  802ab0:	27c20070 	addiu	v0,s8,112
  802ab4:	00402021 	move	a0,v0
  802ab8:	8fc50044 	lw	a1,68(s8)
  802abc:	0c2008c3 	jal	80230c <getuint>
  802ac0:	00000000 	nop
  802ac4:	afc20030 	sw	v0,48(s8)
  802ac8:	afc30034 	sw	v1,52(s8)
            base = 16;
  802acc:	24020010 	li	v0,16
  802ad0:	afc20038 	sw	v0,56(s8)
        number:
            printnum(putch, fd, putdat, num, base, width, padc);
  802ad4:	8fc30038 	lw	v1,56(s8)
  802ad8:	83c2004c 	lb	v0,76(s8)
  802adc:	8fc40030 	lw	a0,48(s8)
  802ae0:	8fc50034 	lw	a1,52(s8)
  802ae4:	00800013 	mtlo	a0
  802ae8:	00a00011 	mthi	a1
  802aec:	00002012 	mflo	a0
  802af0:	00002810 	mfhi	a1
  802af4:	afa40010 	sw	a0,16(sp)
  802af8:	afa50014 	sw	a1,20(sp)
  802afc:	afa30018 	sw	v1,24(sp)
  802b00:	8fc3003c 	lw	v1,60(s8)
  802b04:	afa3001c 	sw	v1,28(sp)
  802b08:	afa20020 	sw	v0,32(sp)
  802b0c:	8fc40060 	lw	a0,96(s8)
  802b10:	8fc50064 	lw	a1,100(s8)
  802b14:	8fc60068 	lw	a2,104(s8)
  802b18:	0c2007e8 	jal	801fa0 <printnum>
  802b1c:	00000000 	nop
            break;
  802b20:	08200ae9 	j	802ba4 <vprintfmt+0x698>
  802b24:	00000000 	nop

        // escaped '%' character
        case '%':
            putch(ch, putdat, fd);
  802b28:	8fc20060 	lw	v0,96(s8)
  802b2c:	02002021 	move	a0,s0
  802b30:	8fc50068 	lw	a1,104(s8)
  802b34:	8fc60064 	lw	a2,100(s8)
  802b38:	0040c821 	move	t9,v0
  802b3c:	0320f809 	jalr	t9
  802b40:	00000000 	nop
            break;
  802b44:	08200ae9 	j	802ba4 <vprintfmt+0x698>
  802b48:	00000000 	nop

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat, fd);
  802b4c:	8fc20060 	lw	v0,96(s8)
  802b50:	24040025 	li	a0,37
  802b54:	8fc50068 	lw	a1,104(s8)
  802b58:	8fc60064 	lw	a2,100(s8)
  802b5c:	0040c821 	move	t9,v0
  802b60:	0320f809 	jalr	t9
  802b64:	00000000 	nop
            for (fmt --; fmt[-1] != '%'; fmt --)
  802b68:	8fc2006c 	lw	v0,108(s8)
  802b6c:	2442ffff 	addiu	v0,v0,-1
  802b70:	afc2006c 	sw	v0,108(s8)
  802b74:	08200ae2 	j	802b88 <vprintfmt+0x67c>
  802b78:	00000000 	nop
  802b7c:	8fc2006c 	lw	v0,108(s8)
  802b80:	2442ffff 	addiu	v0,v0,-1
  802b84:	afc2006c 	sw	v0,108(s8)
  802b88:	8fc2006c 	lw	v0,108(s8)
  802b8c:	2442ffff 	addiu	v0,v0,-1
  802b90:	80430000 	lb	v1,0(v0)
  802b94:	24020025 	li	v0,37
  802b98:	1462fff8 	bne	v1,v0,802b7c <vprintfmt+0x670>
  802b9c:	00000000 	nop
	...
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  802ba8:	0820095a 	j	802568 <vprintfmt+0x5c>
  802bac:	00000000 	nop
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  802bb0:	03c0e821 	move	sp,s8
  802bb4:	8fbf005c 	lw	ra,92(sp)
  802bb8:	8fbe0058 	lw	s8,88(sp)
  802bbc:	8fb10054 	lw	s1,84(sp)
  802bc0:	8fb00050 	lw	s0,80(sp)
  802bc4:	27bd0060 	addiu	sp,sp,96
  802bc8:	03e00008 	jr	ra
  802bcc:	00000000 	nop

00802bd0 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  802bd0:	27bdfff8 	addiu	sp,sp,-8
  802bd4:	afbe0004 	sw	s8,4(sp)
  802bd8:	03a0f021 	move	s8,sp
  802bdc:	afc40008 	sw	a0,8(s8)
  802be0:	afc5000c 	sw	a1,12(s8)
    b->cnt ++;
  802be4:	8fc2000c 	lw	v0,12(s8)
  802be8:	8c420008 	lw	v0,8(v0)
  802bec:	24430001 	addiu	v1,v0,1
  802bf0:	8fc2000c 	lw	v0,12(s8)
  802bf4:	ac430008 	sw	v1,8(v0)
    if (b->buf < b->ebuf) {
  802bf8:	8fc2000c 	lw	v0,12(s8)
  802bfc:	8c430000 	lw	v1,0(v0)
  802c00:	8fc2000c 	lw	v0,12(s8)
  802c04:	8c420004 	lw	v0,4(v0)
  802c08:	0062102b 	sltu	v0,v1,v0
  802c0c:	1040000a 	beqz	v0,802c38 <sprintputch+0x68>
  802c10:	00000000 	nop
        *b->buf ++ = ch;
  802c14:	8fc2000c 	lw	v0,12(s8)
  802c18:	8c420000 	lw	v0,0(v0)
  802c1c:	24440001 	addiu	a0,v0,1
  802c20:	8fc3000c 	lw	v1,12(s8)
  802c24:	ac640000 	sw	a0,0(v1)
  802c28:	8fc30008 	lw	v1,8(s8)
  802c2c:	00031e00 	sll	v1,v1,0x18
  802c30:	00031e03 	sra	v1,v1,0x18
  802c34:	a0430000 	sb	v1,0(v0)
    }
}
  802c38:	03c0e821 	move	sp,s8
  802c3c:	8fbe0004 	lw	s8,4(sp)
  802c40:	27bd0008 	addiu	sp,sp,8
  802c44:	03e00008 	jr	ra
  802c48:	00000000 	nop

00802c4c <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  802c4c:	27bdffd8 	addiu	sp,sp,-40
  802c50:	afbf0024 	sw	ra,36(sp)
  802c54:	afbe0020 	sw	s8,32(sp)
  802c58:	03a0f021 	move	s8,sp
  802c5c:	afc40028 	sw	a0,40(s8)
  802c60:	afc5002c 	sw	a1,44(s8)
  802c64:	afc70034 	sw	a3,52(s8)
  802c68:	afc60030 	sw	a2,48(s8)
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  802c6c:	27c20034 	addiu	v0,s8,52
  802c70:	afc2001c 	sw	v0,28(s8)
    cnt = vsnprintf(str, size, fmt, ap);
  802c74:	8fc2001c 	lw	v0,28(s8)
  802c78:	8fc40028 	lw	a0,40(s8)
  802c7c:	8fc5002c 	lw	a1,44(s8)
  802c80:	8fc60030 	lw	a2,48(s8)
  802c84:	00403821 	move	a3,v0
  802c88:	0c200b2c 	jal	802cb0 <vsnprintf>
  802c8c:	00000000 	nop
  802c90:	afc20018 	sw	v0,24(s8)
    va_end(ap);
    return cnt;
  802c94:	8fc20018 	lw	v0,24(s8)
}
  802c98:	03c0e821 	move	sp,s8
  802c9c:	8fbf0024 	lw	ra,36(sp)
  802ca0:	8fbe0020 	lw	s8,32(sp)
  802ca4:	27bd0028 	addiu	sp,sp,40
  802ca8:	03e00008 	jr	ra
  802cac:	00000000 	nop

00802cb0 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  802cb0:	27bdffc8 	addiu	sp,sp,-56
  802cb4:	afbf0034 	sw	ra,52(sp)
  802cb8:	afbe0030 	sw	s8,48(sp)
  802cbc:	03a0f021 	move	s8,sp
  802cc0:	afc40038 	sw	a0,56(s8)
  802cc4:	afc5003c 	sw	a1,60(s8)
  802cc8:	afc60040 	sw	a2,64(s8)
  802ccc:	afc70044 	sw	a3,68(s8)
    struct sprintbuf b = {str, str + size - 1, 0};
  802cd0:	8fc20038 	lw	v0,56(s8)
  802cd4:	afc20020 	sw	v0,32(s8)
  802cd8:	8fc2003c 	lw	v0,60(s8)
  802cdc:	2442ffff 	addiu	v0,v0,-1
  802ce0:	8fc30038 	lw	v1,56(s8)
  802ce4:	00621021 	addu	v0,v1,v0
  802ce8:	afc20024 	sw	v0,36(s8)
  802cec:	afc00028 	sw	zero,40(s8)
    if (str == NULL || b.buf > b.ebuf) {
  802cf0:	8fc20038 	lw	v0,56(s8)
  802cf4:	10400006 	beqz	v0,802d10 <vsnprintf+0x60>
  802cf8:	00000000 	nop
  802cfc:	8fc30020 	lw	v1,32(s8)
  802d00:	8fc20024 	lw	v0,36(s8)
  802d04:	0043102b 	sltu	v0,v0,v1
  802d08:	10400004 	beqz	v0,802d1c <vsnprintf+0x6c>
  802d0c:	00000000 	nop
        return -E_INVAL;
  802d10:	2402fffd 	li	v0,-3
  802d14:	08200b55 	j	802d54 <vsnprintf+0xa4>
  802d18:	00000000 	nop
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, NO_FD, &b, fmt, ap);
  802d1c:	8fc20044 	lw	v0,68(s8)
  802d20:	afa20010 	sw	v0,16(sp)
  802d24:	3c020080 	lui	v0,0x80
  802d28:	24442bd0 	addiu	a0,v0,11216
  802d2c:	3c02ffff 	lui	v0,0xffff
  802d30:	34456ad9 	ori	a1,v0,0x6ad9
  802d34:	27c20020 	addiu	v0,s8,32
  802d38:	00403021 	move	a2,v0
  802d3c:	8fc70040 	lw	a3,64(s8)
  802d40:	0c200943 	jal	80250c <vprintfmt>
  802d44:	00000000 	nop
    // null terminate the buffer
    *b.buf = '\0';
  802d48:	8fc20020 	lw	v0,32(s8)
  802d4c:	a0400000 	sb	zero,0(v0)
    return b.cnt;
  802d50:	8fc20028 	lw	v0,40(s8)
}
  802d54:	03c0e821 	move	sp,s8
  802d58:	8fbf0034 	lw	ra,52(sp)
  802d5c:	8fbe0030 	lw	s8,48(sp)
  802d60:	27bd0038 	addiu	sp,sp,56
  802d64:	03e00008 	jr	ra
  802d68:	00000000 	nop
  802d6c:	00000000 	nop

00802d70 <hash32>:
 * @bits:   the number of bits in a return value
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
  802d70:	27bdffe8 	addiu	sp,sp,-24
  802d74:	afbe0014 	sw	s8,20(sp)
  802d78:	03a0f021 	move	s8,sp
  802d7c:	afc40018 	sw	a0,24(s8)
  802d80:	afc5001c 	sw	a1,28(s8)
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
  802d84:	8fc30018 	lw	v1,24(s8)
  802d88:	3c029e37 	lui	v0,0x9e37
  802d8c:	34420001 	ori	v0,v0,0x1
  802d90:	00620018 	mult	v1,v0
  802d94:	00001012 	mflo	v0
  802d98:	afc20008 	sw	v0,8(s8)
    return (hash >> (32 - bits));
  802d9c:	24030020 	li	v1,32
  802da0:	8fc2001c 	lw	v0,28(s8)
  802da4:	00621023 	subu	v0,v1,v0
  802da8:	8fc30008 	lw	v1,8(s8)
  802dac:	00431006 	srlv	v0,v1,v0
}
  802db0:	03c0e821 	move	sp,s8
  802db4:	8fbe0014 	lw	s8,20(sp)
  802db8:	27bd0018 	addiu	sp,sp,24
  802dbc:	03e00008 	jr	ra
  802dc0:	00000000 	nop
	...

00802dd0 <rand>:
 * rand - returns a pseudo-random integer
 *
 * The rand() function return a value in the range [0, RAND_MAX].
 * */
int
rand(void) {
  802dd0:	27bdfff8 	addiu	sp,sp,-8
  802dd4:	afbe0004 	sw	s8,4(sp)
  802dd8:	03a0f021 	move	s8,sp
    /*
    next = (next * 0x5DEECE66DLL + 0xBLL) & ((1LL << 48) - 1);
    unsigned long long result = (next >> 12);
    return (int)do_div(result, RAND_MAX + 1);
    */
    next = (unsigned long)next * 1103515245 + 12345;
  802ddc:	3c040080 	lui	a0,0x80
  802de0:	8c854014 	lw	a1,16404(a0)
  802de4:	8c844010 	lw	a0,16400(a0)
  802de8:	00802821 	move	a1,a0
  802dec:	3c0441c6 	lui	a0,0x41c6
  802df0:	34844e6d 	ori	a0,a0,0x4e6d
  802df4:	00a40018 	mult	a1,a0
  802df8:	00001012 	mflo	v0
  802dfc:	24443039 	addiu	a0,v0,12345
  802e00:	00801021 	move	v0,a0
  802e04:	00001821 	move	v1,zero
  802e08:	3c040080 	lui	a0,0x80
  802e0c:	ac824010 	sw	v0,16400(a0)
  802e10:	ac834014 	sw	v1,16404(a0)
    return ((unsigned long)next % (RAND_MAX+1));
  802e14:	3c020080 	lui	v0,0x80
  802e18:	8c434014 	lw	v1,16404(v0)
  802e1c:	8c424010 	lw	v0,16400(v0)
  802e20:	00401821 	move	v1,v0
  802e24:	3c027fff 	lui	v0,0x7fff
  802e28:	3442ffff 	ori	v0,v0,0xffff
  802e2c:	00621024 	and	v0,v1,v0
}
  802e30:	03c0e821 	move	sp,s8
  802e34:	8fbe0004 	lw	s8,4(sp)
  802e38:	27bd0008 	addiu	sp,sp,8
  802e3c:	03e00008 	jr	ra
  802e40:	00000000 	nop

00802e44 <srand>:
/* *
 * srand - seed the random number generator with the given number
 * @seed:   the required seed number
 * */
void
srand(unsigned int seed) {
  802e44:	27bdfff8 	addiu	sp,sp,-8
  802e48:	afbe0004 	sw	s8,4(sp)
  802e4c:	03a0f021 	move	s8,sp
  802e50:	afc40008 	sw	a0,8(s8)
    next = seed;
  802e54:	8fc40008 	lw	a0,8(s8)
  802e58:	00801021 	move	v0,a0
  802e5c:	00001821 	move	v1,zero
  802e60:	3c040080 	lui	a0,0x80
  802e64:	ac824010 	sw	v0,16400(a0)
  802e68:	ac834014 	sw	v1,16404(a0)
}
  802e6c:	03c0e821 	move	sp,s8
  802e70:	8fbe0004 	lw	s8,4(sp)
  802e74:	27bd0008 	addiu	sp,sp,8
  802e78:	03e00008 	jr	ra
  802e7c:	00000000 	nop

00802e80 <main>:
#include <ulib.h>

int magic = -0x10384;

int
main(void) {
  802e80:	27bdffd8 	addiu	sp,sp,-40
  802e84:	afbf0024 	sw	ra,36(sp)
  802e88:	afbe0020 	sw	s8,32(sp)
  802e8c:	03a0f021 	move	s8,sp
    int pid, code;
    cprintf("I am the parent. Forking the child...\n");
  802e90:	3c020080 	lui	v0,0x80
  802e94:	24443530 	addiu	a0,v0,13616
  802e98:	0c2003a9 	jal	800ea4 <cprintf>
  802e9c:	00000000 	nop
    if ((pid = fork()) == 0) {
  802ea0:	0c2001e2 	jal	800788 <fork>
  802ea4:	00000000 	nop
  802ea8:	afc20018 	sw	v0,24(s8)
  802eac:	8fc20018 	lw	v0,24(s8)
  802eb0:	14400018 	bnez	v0,802f14 <main+0x94>
  802eb4:	00000000 	nop
        cprintf("I am the child.\n");
  802eb8:	3c020080 	lui	v0,0x80
  802ebc:	24443558 	addiu	a0,v0,13656
  802ec0:	0c2003a9 	jal	800ea4 <cprintf>
  802ec4:	00000000 	nop
        yield();
  802ec8:	0c20020c 	jal	800830 <yield>
  802ecc:	00000000 	nop
        yield();
  802ed0:	0c20020c 	jal	800830 <yield>
  802ed4:	00000000 	nop
        yield();
  802ed8:	0c20020c 	jal	800830 <yield>
  802edc:	00000000 	nop
        yield();
  802ee0:	0c20020c 	jal	800830 <yield>
  802ee4:	00000000 	nop
        yield();
  802ee8:	0c20020c 	jal	800830 <yield>
  802eec:	00000000 	nop
        yield();
  802ef0:	0c20020c 	jal	800830 <yield>
  802ef4:	00000000 	nop
        yield();
  802ef8:	0c20020c 	jal	800830 <yield>
  802efc:	00000000 	nop
        exit(magic);
  802f00:	3c020080 	lui	v0,0x80
  802f04:	8c424020 	lw	v0,16416(v0)
  802f08:	00402021 	move	a0,v0
  802f0c:	0c2001d4 	jal	800750 <exit>
  802f10:	00000000 	nop
    }
    else {
        cprintf("I am parent, fork a child pid %d\n",pid);
  802f14:	3c020080 	lui	v0,0x80
  802f18:	2444356c 	addiu	a0,v0,13676
  802f1c:	8fc50018 	lw	a1,24(s8)
  802f20:	0c2003a9 	jal	800ea4 <cprintf>
  802f24:	00000000 	nop
    }
    assert(pid > 0);
  802f28:	8fc20018 	lw	v0,24(s8)
  802f2c:	1c40000a 	bgtz	v0,802f58 <main+0xd8>
  802f30:	00000000 	nop
  802f34:	3c020080 	lui	v0,0x80
  802f38:	24443590 	addiu	a0,v0,13712
  802f3c:	24050018 	li	a1,24
  802f40:	3c020080 	lui	v0,0x80
  802f44:	2446359c 	addiu	a2,v0,13724
  802f48:	3c020080 	lui	v0,0x80
  802f4c:	244735b4 	addiu	a3,v0,13748
  802f50:	0c200008 	jal	800020 <__panic>
  802f54:	00000000 	nop
    cprintf("I am the parent, waiting now..\n");
  802f58:	3c020080 	lui	v0,0x80
  802f5c:	244435bc 	addiu	a0,v0,13756
  802f60:	0c2003a9 	jal	800ea4 <cprintf>
  802f64:	00000000 	nop

    assert(waitpid(pid, &code) == 0 && code == magic);
  802f68:	27c2001c 	addiu	v0,s8,28
  802f6c:	8fc40018 	lw	a0,24(s8)
  802f70:	00402821 	move	a1,v0
  802f74:	0c2001fc 	jal	8007f0 <waitpid>
  802f78:	00000000 	nop
  802f7c:	14400006 	bnez	v0,802f98 <main+0x118>
  802f80:	00000000 	nop
  802f84:	8fc3001c 	lw	v1,28(s8)
  802f88:	3c020080 	lui	v0,0x80
  802f8c:	8c424020 	lw	v0,16416(v0)
  802f90:	1062000a 	beq	v1,v0,802fbc <main+0x13c>
  802f94:	00000000 	nop
  802f98:	3c020080 	lui	v0,0x80
  802f9c:	24443590 	addiu	a0,v0,13712
  802fa0:	2405001b 	li	a1,27
  802fa4:	3c020080 	lui	v0,0x80
  802fa8:	2446359c 	addiu	a2,v0,13724
  802fac:	3c020080 	lui	v0,0x80
  802fb0:	244735dc 	addiu	a3,v0,13788
  802fb4:	0c200008 	jal	800020 <__panic>
  802fb8:	00000000 	nop
    assert(waitpid(pid, &code) != 0 && wait() != 0);
  802fbc:	27c2001c 	addiu	v0,s8,28
  802fc0:	8fc40018 	lw	a0,24(s8)
  802fc4:	00402821 	move	a1,v0
  802fc8:	0c2001fc 	jal	8007f0 <waitpid>
  802fcc:	00000000 	nop
  802fd0:	10400005 	beqz	v0,802fe8 <main+0x168>
  802fd4:	00000000 	nop
  802fd8:	0c2001ee 	jal	8007b8 <wait>
  802fdc:	00000000 	nop
  802fe0:	1440000a 	bnez	v0,80300c <main+0x18c>
  802fe4:	00000000 	nop
  802fe8:	3c020080 	lui	v0,0x80
  802fec:	24443590 	addiu	a0,v0,13712
  802ff0:	2405001c 	li	a1,28
  802ff4:	3c020080 	lui	v0,0x80
  802ff8:	2446359c 	addiu	a2,v0,13724
  802ffc:	3c020080 	lui	v0,0x80
  803000:	24473608 	addiu	a3,v0,13832
  803004:	0c200008 	jal	800020 <__panic>
  803008:	00000000 	nop
    cprintf("waitpid %d ok.\n", pid);
  80300c:	3c020080 	lui	v0,0x80
  803010:	24443630 	addiu	a0,v0,13872
  803014:	8fc50018 	lw	a1,24(s8)
  803018:	0c2003a9 	jal	800ea4 <cprintf>
  80301c:	00000000 	nop

    cprintf("exit pass.\n");
  803020:	3c020080 	lui	v0,0x80
  803024:	24443640 	addiu	a0,v0,13888
  803028:	0c2003a9 	jal	800ea4 <cprintf>
  80302c:	00000000 	nop
    return 0;
  803030:	00001021 	move	v0,zero
}
  803034:	03c0e821 	move	sp,s8
  803038:	8fbf0024 	lw	ra,36(sp)
  80303c:	8fbe0020 	lw	s8,32(sp)
  803040:	27bd0028 	addiu	sp,sp,40
  803044:	03e00008 	jr	ra
  803048:	00000000 	nop
  80304c:	00000000 	nop
