#include <defs.h>
#include <mmu.h>
#include <memlayout.h>
#include <clock.h>
#include <trap.h>
#include <stdio.h>
#include <assert.h>
#include <console.h>
#include <vmm.h>
#include <swap.h>
#include <tlb.h>
#include <kdebug.h>
#include <unistd.h>
#include <syscall.h>
#include <error.h>
#include <sched.h>
#include <sync.h>
#include <proc.h>
#include <ri.h>

#define TICK_NUM 128

static void print_ticks() {
    cprintf("%d ticks\n",TICK_NUM);
}

uint32_t kstack_sp;

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
     /* LAB1 2011011278 : STEP 2 */
     /* (1) Where are the entry addrs of each Interrupt Service Routine (ISR)?
      *     All ISR's entry addrs are stored in __vectors. where is uintptr_t __vectors[] ?
      *     __vectors[] is in kern/trap/vector.S which is produced by tools/vector.c
      *     (try "make" command in lab1, then you will find vector.S in kern/trap DIR)
      *     You can use  "extern uintptr_t __vectors[];" to define this extern variable which will be used later.
      * (2) Now you should setup the entries of ISR in Interrupt Description Table (IDT).
      *     Can you see idt[256] in this file? Yes, it's IDT! you can use SETGATE macro to setup each item of IDT
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern char __alltraps[];
    *(uint32_t*)EXC_ENTRY = ((uint32_t)__alltraps >> 2) ^ 0x28000000;
    *(uint32_t*)EXC_ENTRY2 = ((uint32_t)__alltraps >> 2) ^ 0x28000000;
     /* LAB5 2011011278 */ 
     //you should update your lab1 code (just add ONE or TWO lines of code), let user app to use syscall to get the service of ucore
     //so you should setup the syscall interrupt gate in here
}

static const char *
trapname(int trapno) {
    static const char * const excnames[] = {
        [EXC_INT] "Unmasked HW or SW Interrupt",
        [EXC_TLBM] "Store to TLB Page with D=0",
        [EXC_TLBL] "Fetch/Load TLB Miss/Invalid",
        [EXC_TLBS] "Store TLB Miss/Invalid",
        [EXC_ADEL] "Unaligned/unprivileged Fetch/Load",
        [EXC_ADES] "Unaligned/unprivileged Store",
        [EXC_SYS] "SYSCALL",
        [EXC_RI] "Reserved Instruction",
        [EXC_CPU] "Disabled Coprocessor Instruction",
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
        return excnames[trapno];
    }
    return "(unknown trap)";
}

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
    return ((tf->tf_Status & 0x00000010) == 0);
}

void
print_trapframe(struct trapframe *tf) {
    cprintf("trapframe at %p\n", tf);
    print_regs(&tf->tf_regs);
    cprintf("  LO           0x----%08x\n", tf->tf_LO);
    cprintf("  HI           0x----%08x\n", tf->tf_HI);
    cprintf("  Status       0x----%08x\n", tf->tf_Status);
    cprintf("  Cause        0x----%08x\n", tf->tf_Cause);
    cprintf("  EPC          0x----%08x\n", tf->tf_EPC);
    cprintf("  BadVAddr     0x----%08x\n", tf->tf_BadVAddr);

    cprintf("  Exception    %s\n", trapname((tf->tf_Cause & 0x0000007c) >> 2));
}

void
print_regs(struct pushregs *regs) {
    cprintf("  ra  0x%08x\n", regs->ra);
}

static volatile int in_swap_tick_event = 0;
extern struct mm_struct *check_mm_struct;

static void
trap_dispatch(struct trapframe *tf) {
    char c;

    int ret;

    switch ((tf->tf_Cause & 0x0000007c) >> 2) {
    case EXC_TLBL:
    case EXC_TLBS:
        if ((ret = tlb_miss_handler(tf)) != 0) {
            print_trapframe(tf);
            panic("handle TLB Miss failed. %e\n", ret);
        }
        break;
    case EXC_SYS:
        syscall();
        break;
    case EXC_INT:
        switch ((tf->tf_Cause & tf->tf_Status & 0x0000ff00) >> 8) {
        case (1 << IRQ_TIMER):
#if 0
    LAB3 : If some page replacement algorithm(such as CLOCK PRA) need tick to change the priority of pages,
    then you can add code here.
#endif
            /* LAB1 2011011278 : STEP 3 */
            /* handle the timer interrupt */
            /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
             * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
             * (3) Too Simple? Yes, I think so!
             */
            ticks++;
            if (ticks % TICK_NUM == 0) {
                // print_ticks();
                current -> need_resched = 1;
            }
            /* LAB5 2011011278 */
            /* you should upate you lab1 code (just add ONE or TWO lines of code):
             *    Every TICK_NUM cycle, you should set current process's current->need_resched = 1
             */
            /* LAB6 2011011278 */
            /* IMPORTANT FUNCTIONS:
	         * run_timer_list
	         *----------------------
	         * you should update your lab5 code (just add ONE or TWO lines of code):
             *    Every tick, you should update the system time, iterate the timers, and trigger the timers which are end to call scheduler.
             *    You can use one funcitons to finish all these things.
             */
            run_timer_list();
            clock_intr();
            break;
        case (1 << IRQ_COM1):
            // There are user level shell in LAB8, so we need change COM/KBD interrupt processing.
            {
                // cprintf("serial [%03d] %c\n", c, c);
                extern void dev_stdin_write(char c);
                while ((c = cons_getc()) != 0)
                    dev_stdin_write(c);
            }
            break;
        default:
            print_trapframe(tf);
            panic("unknown int.\n");
        }
        break;
    case EXC_RI:
        if ((ret = ri_handler(tf)) != 0) {
            print_trapframe(tf);
            if (current != NULL)
                do_exit(-E_KILLED);
            panic("unexpected RI in kernel.\n");
        }
        break;
    //LAB1 CHALLENGE 1 : 2011011278 you should modify below codes.
    default:
        print_trapframe(tf);
        if (current != NULL) {
            cprintf("unhandled trap.\n");
            do_exit(-E_KILLED);
        }
        // in kernel, it must be a mistake
        panic("unexpected trap in kernel.\n");

    }
}

/* *
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
    // dispatch based on what type of trap occurred
    // used for previous projects
    if (current == NULL) {
        trap_dispatch(tf);
    }
    else {
        // keep a trapframe chain in stack
        struct trapframe *otf = current->tf;
        current->tf = tf;

        bool in_kernel = trap_in_kernel(tf);

        trap_dispatch(tf);

        current->tf = otf;
        if (!in_kernel) {
            if (current->flags & PF_EXITING) {
                do_exit(-E_KILLED);
            }
            if (current->need_resched) {
                schedule();
            }
        }
    }
}
