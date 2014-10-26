#ifndef __KERN_MM_VMM_H__
#define __KERN_MM_VMM_H__

#include <defs.h>
#include <list.h>
#include <memlayout.h>
#include <atomic.h>
#include <sync.h>
#include <proc.h>
#include <sem.h>

//关于vmm部分各种结构体功能、结构的形象说明，见lab3.pdf page5

//pre define
struct mm_struct;

// the virtual continuous memory area(vma)
struct vma_struct {                                                         //虚拟地址，程序请求的一大快连续的虚拟地址
    struct mm_struct *vm_mm; // the set of vma using the same PDT           //指向更高层次的一个抽象
    uintptr_t vm_start;      //	start addr of vma	                        //虚拟地址的开头和结尾
    uintptr_t vm_end;        // end addr of vma
    uint32_t vm_flags;       // flags of vma
    list_entry_t list_link;  // linear list link which sorted by start addr of vma      //链表结构
};

#define le2vma(le, member)                  \
    to_struct((le), struct vma_struct, member)

#define VM_READ                 0x00000001
#define VM_WRITE                0x00000002
#define VM_EXEC                 0x00000004
#define VM_STACK                0x00000008


// the control struct for a set of vma using the same PDT
struct mm_struct {
    list_entry_t mmap_list;        // linear list link which sorted by start addr of vma
    struct vma_struct *mmap_cache; // current accessed vma, used for speed purpose          //刚才用过的那一个vma-struct结构
    pde_t *pgdir;                  // the PDT of these vma
    int map_count;                 // the count of these vma
	void *sm_priv;				   // the private data for swap manager
	atomic_t mm_count;
	semaphore_t mm_sem;
	int locked_by;

};

struct vma_struct *find_vma(struct mm_struct *mm, uintptr_t addr);
struct vma_struct *vma_create(uintptr_t vm_start, uintptr_t vm_end, uint32_t vm_flags);
void insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma);

struct mm_struct *mm_create(void);
void mm_destroy(struct mm_struct *mm);

void vmm_init(void);

int do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr);

extern volatile unsigned int pgfault_num;
extern struct mm_struct *check_mm_struct;

bool user_mem_check(struct mm_struct *mm, uintptr_t start, size_t len, bool write);
bool copy_from_user(struct mm_struct *mm, void *dst, const void *src, size_t len, bool writable);
bool copy_to_user(struct mm_struct *mm, void *dst, const void *src, size_t len);

int mm_unmap(struct mm_struct *mm, uintptr_t addr, size_t len);
int dup_mmap(struct mm_struct *to, struct mm_struct *from);
void exit_mmap(struct mm_struct *mm);
uintptr_t get_unmapped_area(struct mm_struct *mm, size_t len);
int mm_brk(struct mm_struct *mm, uintptr_t addr, size_t len);

static inline int
mm_count(struct mm_struct *mm) {
    return atomic_read(&(mm->mm_count));
}

static inline void
set_mm_count(struct mm_struct *mm, int val) {
    atomic_set(&(mm->mm_count), val);
}

static inline int
mm_count_inc(struct mm_struct *mm) {
    return atomic_add_return(&(mm->mm_count), 1);
}

static inline int
mm_count_dec(struct mm_struct *mm) {
    return atomic_sub_return(&(mm->mm_count), 1);
}

static inline void
lock_mm(struct mm_struct *mm) {
    if (mm != NULL) {
        down(&(mm->mm_sem));
        if (current != NULL) {
            mm->locked_by = current->pid;
        }
    }
}

static inline void
unlock_mm(struct mm_struct *mm) {
    if (mm != NULL) {
        up(&(mm->mm_sem));
        mm->locked_by = 0;
    }
}

#endif /* !__KERN_MM_VMM_H__ */

