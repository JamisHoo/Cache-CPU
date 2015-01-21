#include <swap.h>
#include <swapfs.h>
#include <mmu.h>
#include <pmm.h>
#include <assert.h>

#define SWAPFS_BASE     0xbe400000
#define SWAPFS_SIZE     0x00400000

#define BLOCKSIZE       0x00020000
#define BLOCKBASE(addr) ((addr) & 0xff7e0000)
#define BLOCKOFF(addr)  ((addr) & 0x0001f000)
#define FLAGS(entry)    ((entry) & 0x6)

static uintptr_t clean_block = SWAPFS_BASE;

void swapfs_clean(uintptr_t base);

void
swapfs_init(void) {
    max_swap_offset = SWAPFS_SIZE / PGSIZE;
    swapfs_clean(clean_block);
}

int
swapfs_read(swap_entry_t entry, struct Page *page) {
    /*
    uint32_t* src = (uint32_t*)PTE_ADDR(entry);
    uint32_t* end = (uint32_t*)((uintptr_t)src + PGSIZE);
    uint32_t* dst = (uint32_t*)page2kva(page);
    for (; src < end; src++, dst++)
        *dst = *src;
    */
    return 0;
}

int
swapfs_write(swap_entry_t* entry, struct Page *page) {
    // pick a empty page, eg No. 0b00001 page in No. 1 block
    uint32_t* empty = (uint32_t*)0xbe421000;
    /*
    uint32_t* empty_end = (uint32_t*)((uintptr_t)empty + PGSIZE);
    uint32_t* src = (uint32_t*)BLOCKBASE((uintptr_t)empty);
    uint32_t* end = (uint32_t*)((uintptr_t)src + BLOCKSIZE);
    uint32_t* dst = (uint32_t*)clean_block;
    uint32_t* p = (uint32_t*)page2kva(page);
    for (; src < end; src++, dst++)
        if (empty <= src && src < empty_end) {
            *dst = *p;
            p++;
        } else
            *dst = *src;
    */
    assert(entry != NULL);
    *entry = clean_block | BLOCKOFF((uintptr_t)empty) | FLAGS(*entry);
    swapfs_clean(BLOCKBASE((uintptr_t)empty));
    clean_block = BLOCKBASE((uintptr_t)empty);
    return 0;
}

void swapfs_clean(uintptr_t base) {
    assert(BLOCKBASE(base) == base);
    // *(uint32_t*)base = 0xffffffff;
}
