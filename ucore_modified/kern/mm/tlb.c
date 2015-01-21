#include <tlb.h>
#include <stdio.h>
#include <assert.h>
#include <pmm.h>
#include <vmm.h>
#include <mips32s.h>
#include <proc.h>
#include <error.h>

pde_t* cur_pgdir = NULL;

void tlb_write(uint8_t idx, uint32_t hi, uint32_t lo0, uint32_t lo1);
// TLB replacment algorithm specific functions
uint8_t tlb_get_empty(uint32_t hi);
void tlb_init_callback(void);
void tlb_half_add_callback(uint8_t idx);
void tlb_half_del_callback(uint8_t idx);
void tlb_del_callback(uint8_t idx);

void
tlb_init(void) {
    uint8_t i;
    for (i = 0; i < TLBN; i++)
        tlb_write(i, ENTRYHI_INVALID, ENTRYLO_INVALID, ENTRYLO_INVALID);
    tlb_init_callback();
}

int
tlb_miss_handler(struct trapframe* tf) {
    uintptr_t la = tf->tf_BadVAddr;
    // cprintf("TLB Miss at 0x%08x, PC: 0x%08x.\n", la, tf->tf_EPC);
    // look up in pgdir & do_pgfault
    assert(cur_pgdir != NULL);
    pte_t* ptep = get_pte(cur_pgdir, la, 0);
    if (ptep == NULL || (*ptep & PTE_P) == 0) {
        struct mm_struct* mm;
        if (check_mm_struct != NULL) {
            assert(current == idleproc);
            mm = check_mm_struct; 
        } else {
            if (current == NULL)
                panic("unhandled page fault.\n");
            mm = current->mm;
        }
        assert(mm != NULL);
        assert(mm->pgdir == cur_pgdir);
        uint32_t error_code = 0;
        if (((tf->tf_Cause>>2)&0x1f) == EXC_TLBS)
            error_code |= 0x2;
        if (do_pgfault(mm, error_code, la) != 0) {
            print_trapframe(tf);
            if (current == NULL) {
                panic("handled pgfault failed.\n");
            } else {
                if (trap_in_kernel(tf))
                    panic("handle pgfault failed in kernel mode.\n");
                cprintf("killed by kernel...\n");
                // panic("handle user mode pgfault failed.\n");
                do_exit(-E_KILLED);
            }
        }
        ptep = get_pte(cur_pgdir, la, 0);
    }
    // check for paired entry
    uint8_t idx;
    uint32_t lo[2];
    pte_t* ptep2 = get_pte(cur_pgdir, TLBPAIR(la), 0);
    lo[TLBLO(la)] = ENTRYLO(*ptep);
    if (ptep2 != NULL && (*ptep2 & TLB_P)) {
        lo[TLBLO(TLBPAIR(la))] = ENTRYLO(*ptep2);
        idx = TLBIDX(*ptep2);
        tlb_half_add_callback(idx);
    } else {
        lo[TLBLO(TLBPAIR(la))] = ENTRYLO_INVALID;
        idx = tlb_get_empty(la & 0xffffe000);
    }
    tlb_write(idx, la & 0xffffe000, lo[0], lo[1]);
    *ptep = (*ptep & 0xfffff0ff) | (idx << 8) | TLB_P;
    return 0;
}

void
load_pgdir(pde_t* pgdir){
    cur_pgdir = pgdir;
    tlb_init();
}

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
    if (pgdir != cur_pgdir)
        return;
    pte_t* ptep = get_pte(pgdir, la, 0);
    if (ptep == NULL || (*ptep & TLB_P) == 0)
        return;
    // cprintf("TLB Cleared at 0x%08x.\n", la);
    uint8_t idx = TLBIDX(*ptep);
    uint32_t lo[2], hi = ENTRYHI_INVALID;
    lo[TLBLO(la)] = ENTRYLO_INVALID;
    pte_t* ptep2 = get_pte(pgdir, TLBPAIR(la), 0);
    if (ptep2 != NULL && (*ptep2 & TLB_P)) {
        lo[TLBLO(TLBPAIR(la))] = ENTRYLO(*ptep2);
        hi = la & 0xffffe000;
        tlb_half_del_callback(idx);
    } else {
        lo[TLBLO(TLBPAIR(la))] = ENTRYLO_INVALID;
        tlb_del_callback(idx);
    }
    tlb_write(idx, hi, lo[0], lo[1]);
    *ptep &= ~TLB_P;
}

uint8_t tlb_algo_empty[TLBN];
uint8_t tlb_algo_n;
uint32_t tlb_algo_hi[TLBN];
uint8_t tlb_algo_ptr = 0;
void tlb_init_callback(void) {
    uint8_t i;
    for (i = 0; i < TLBN; i++) {
        tlb_algo_empty[i] = i;
    }
    tlb_algo_n = TLBN;
}
uint8_t tlb_get_empty(uint32_t hi) {
    uint8_t idx;
    if (tlb_algo_n > 0)
        idx = tlb_algo_empty[--tlb_algo_n];
    else {
        idx = tlb_algo_ptr++;
        tlb_algo_ptr %= TLBN;
        uint32_t hi0 = tlb_algo_hi[idx];
        pte_t* ptep = get_pte(cur_pgdir, hi0, 0);
        if (ptep != NULL)
            *ptep &= ~TLB_P;
        ptep = get_pte(cur_pgdir, TLBPAIR(hi0), 0);
        if (ptep != NULL)
            *ptep &= ~TLB_P;
    }
    tlb_algo_hi[idx] = hi;
    return idx;
}
void tlb_half_add_callback(uint8_t idx){}
void tlb_half_del_callback(uint8_t idx){}
void tlb_del_callback(uint8_t idx){
    tlb_algo_empty[tlb_algo_n++] = idx;
}

void tlb_write(uint8_t idx, uint32_t hi, uint32_t lo0, uint32_t lo1) {
    // tlb_print("^^^^^ Before");
    mtc0(CP0_Index, idx);
    mtc0(CP0_EntryHi, hi);
    mtc0(CP0_EntryLo0, lo0);
    mtc0(CP0_EntryLo1, lo1);
    tlbwi();
    // tlb_print("===== After");
}

void tlb_print(const char* prompt) {
    cprintf("%s TLB Dump:\n", prompt);
    uint8_t i;
    for (i = 0; i < TLBN; i++) {
        mtc0(CP0_Index, i);
        asm volatile ("tlbr");
        uint32_t hi = mfc0(CP0_EntryHi);
        uint32_t lo0 = mfc0(CP0_EntryLo0);
        uint32_t lo1 = mfc0(CP0_EntryLo1);
        if ((lo0 & 0x4) | (lo1 & 0x4)) {
            cprintf("%2d: 0x%08x -> (0x%08x, 0x%08x)\n", i, hi, lo0, lo1);
            cprintf("    0x%08x -> 0x%08x %c %c\n", hi&0xffffe000, (lo0<<6)&0xfffff000, (lo0&0x4)?'D':'_', (lo0&0x2)?'V':'_');
            cprintf("    0x%08x -> 0x%08x %c %c\n", (hi&0xffffe000)^0x1000, (lo1<<6)&0xfffff000, (lo1&0x4)?'D':'_', (lo1&0x2)?'V':'_');
        }
    }
}
