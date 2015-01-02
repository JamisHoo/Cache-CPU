#ifndef __KERN_MM_TLB_H__
#define __KERN_MM_TLB_H__

#include <defs.h>
#include <mmu.h>
#include <trap.h>
#include <memlayout.h>

/*
    PTE Format
    ==========
    31       12  11      8    7    6      3  2       0
    +---------+--+-------+----+----+------+--+-------+
    phy page no  tlb index  TLB_P  reserved  PTE_U&W&P
*/

#define TLBN            0x10

#define TLBIDX(pte)     (((pte)>>8)&0xf)
#define TLB_P           0x80

#define TLBPAIR(la)     ((la)^0x1000)
#define TLBLO(la)       (PPN(la)&1)

#define ENTRYLO_AUX(pfn, d) (((pfn)<<6)|(2<<3)|((d)<<2)|0x3)
#define ENTRYLO(pte) ENTRYLO_AUX(PPN(pte), ((pte)>>1)&1)
#define ENTRYLO_INVALID 0x00000000
#define ENTRYHI_INVALID 0x80000000

void tlb_init(void);
int tlb_miss_handler(struct trapframe* tf);

void load_pgdir(pde_t* pgdir);
void tlb_invalidate(pde_t *pgdir, uintptr_t la);

void tlb_print(const char* prompt);

#endif /* !__KERN_MM_TLB_H__ */

