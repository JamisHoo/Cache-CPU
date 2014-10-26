#include <defs.h>
#include <stdio.h>
#include <string.h>
#include <console.h>
#include <kdebug.h>
#include <picirq.h>
#include <trap.h>
#include <clock.h>
#include <intr.h>
#include <pmm.h>
#include <vmm.h>
#include <proc.h>
#include <thumips_tlb.h>
#include <sched.h>

void setup_exception_vector()
{
  //for QEMU sim
  extern unsigned char __exception_vector, __exception_vector_end;
  memcpy((unsigned int*)0xBFC00000, &__exception_vector,
      &__exception_vector_end - &__exception_vector);
}

void __noreturn
kern_init(void) {
    //setup_exception_vector();
    tlb_invalidate_all();
    
    /*
    unsigned base = 0xBE000000;
    int i, j;
    for (j = 10; j < 24; ++j) {
        kprintf("\nj=%d\n\n\n", j);
    for (i = 0; i < 10; ++i) {
        int *addr = (int*)(base + i * 4 + (1 << j));
        kprintf("0x%08x=0x%04x\n", addr, (*addr)&0xFFFF);
    }
    }
    */

    pic_init();                 // init interrupt controller
    cons_init();                // init the console
    clock_init();               // init clock interrupt
//    panic("init");
    check_initrd();

    const char *message = "(THU.CST) os is loading ...\n\n";
    kprintf(message);

    print_kerninfo();

#if 0
    kprintf("EX\n");
    __asm__ volatile("syscall");
    kprintf("EX RET\n");
#endif

    pmm_init();                 // init physical memory management

    vmm_init();                 // init virtual memory management
    sched_init();
    proc_init();                // init process table

    ide_init();
    fs_init();

    intr_enable();              // enable irq interrupt
    //*(int*)(0x00124) = 0x432;
    //asm volatile("divu $1, $1, $1");
    cpu_idle();
}

