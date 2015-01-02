#ifndef __KERN_TRAP_TRAP_H__
#define __KERN_TRAP_TRAP_H__

#include <defs.h>

#define EXC_ENTRY       0x80000180
#define EXC_ENTRY2      0x80000000

/* Trap Numbers */
#define EXC_INT                  0
#define EXC_TLBM                 1
#define EXC_TLBL                 2
#define EXC_TLBS                 3
#define EXC_ADEL                 4
#define EXC_ADES                 5
#ifndef EXC_SYS
#define EXC_SYS                  8
#endif
#define EXC_RI                  10
#define EXC_CPU                 11

/* Hardware IRQ numbers. */
#define IRQ_TIMER                7
#define IRQ_COM1                 2

struct pushregs {
    uint32_t zero;
    uint32_t at;
    uint32_t v0, v1;
    uint32_t a0, a1, a2, a3;
    uint32_t t0, t1, t2, t3, t4, t5, t6, t7;
    uint32_t s0, s1, s2, s3, s4, s5, s6, s7;
    uint32_t t8, t9;
    uint32_t k0, k1;
    uint32_t gp;
    uint32_t sp;
    uint32_t fp;
    uint32_t ra;
};

struct trapframe {
    struct pushregs tf_regs;
    uint32_t tf_Status;
    uint32_t tf_Cause;
    uint32_t tf_EPC;
    uint32_t tf_BadVAddr;
    uint32_t tf_LO;
    uint32_t tf_HI;
}/* __attribute__((packed))*/;

void idt_init(void);
void print_trapframe(struct trapframe *tf);
void print_regs(struct pushregs *regs);
bool trap_in_kernel(struct trapframe *tf);

#endif /* !__KERN_TRAP_TRAP_H__ */

