#include <defs.h>
#include <thumips.h>
#include <stdio.h>
#include <string.h>
#include <mmu.h>
#include <memlayout.h>
#include <pmm.h>
#include <buddy_pmm.h>
#include <sync.h>
#include <error.h>


                                                  //pmm是有关物理内存的管理部分

// virtual address of physicall page array
struct Page *pages;
// amount of physical memory (in pages)
size_t npage = 0;

// virtual address of boot-time page directory
pde_t *boot_pgdir = NULL;

/* this is our emulated "CR3" */
pde_t *current_pgdir = NULL;

// physical address of boot-time page directory
uintptr_t boot_cr3;

// physical memory management
const struct pmm_manager *pmm_manager;

static void check_alloc_page(void);
static void check_pgdir(void);
static void check_boot_pgdir(void);

void lcr3(uintptr_t cr3)
{
  current_pgdir = (pde_t*)cr3;
}

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
    pmm_manager = &buddy_pmm_manager;
    kprintf("memory management: ");
      kprintf(pmm_manager->name);
      kprintf("\n");
    pmm_manager->init();
}

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
    pmm_manager->init_memmap(base, n);
}

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
    struct Page *page;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        page = pmm_manager->alloc_pages(n);
    }
    local_intr_restore(intr_flag);
    return page;
}

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
    }
    local_intr_restore(intr_flag);
}

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        ret = pmm_manager->nr_free_pages();
    }
    local_intr_restore(intr_flag);
    return ret;
}

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  uint32_t maxpa;
  int i;

  //panic("unimpl");
  kprintf("memory map:\n");
  kprintf("    [");
  printhex(KERNBASE);
  kprintf(", ");
  printhex(KERNTOP);
  kprintf("]\n\n");

  maxpa = KERNTOP;
  npage = KMEMSIZE >> PGSHIFT;

 // end address of kernel
  extern char end[];
  // put page structure table at the end of kernel
  pages = (struct Page *)ROUNDUP_2N((void *)end, PGSHIFT); 

  for(i=0; i < npage; i++){
    SetPageReserved(pages + i);
  }

  uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  PRINT_HEX("freemem start at: ", freemem);

  uint32_t mbegin = ROUNDUP_2N(freemem, PGSHIFT);
  uint32_t mend = ROUNDDOWN_2N(KERNTOP, PGSHIFT);
  assert( mbegin < mend );
  init_memmap(pa2page(mbegin), (mend - mbegin) >> PGSHIFT );
  PRINT_HEX("free pages: ", (mend-mbegin)>>PGSHIFT);
  PRINT_HEX("## ", sizeof(struct Page));
}

static void
enable_paging(void) {
  /* nothing */
}

//boot_map_segment - setup&enable the paging mechanism
// parameters
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP_2N(size + PGOFF(la), PGSHIFT) >> PGSHIFT;
    la = ROUNDDOWN_2N(la, PGSHIFT);
    pa = ROUNDDOWN_2N(pa, PGSHIFT);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
    struct Page *p = alloc_page();
    if (p == NULL) {
        panic("boot_alloc_page failed.\n");
    }
    return page2kva(p);
}

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
    
    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
    memset(boot_pgdir, 0, PGSIZE);
    boot_cr3 = PADDR(boot_pgdir);
    current_pgdir = boot_pgdir;

    check_pgdir();

    enable_paging();

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();

    memset(boot_pgdir, 0, PGSIZE);
    print_pgdir();

  	kmalloc_init();
}

//get_pte - get pte and return the kernel virtual address of this pte for la
//        - if the PT contians this pte didn't exist, alloc a page for PT
// parameter:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
	/* LAB2 exercise2: 2009010989
	 *
	 * if you need to visit a physical address, please use KADDR()
	 * please read pmm.h for useful macros
	 */
	// YOU want comment, HERE is comment
	pde_t *pdep = NULL; // find page directory entry
  	pdep = pgdir + PDX(la);
  
	if ( ((*pdep)&PTE_P) == 0 ) { // check if entry is not present
		// check if creating is needed, then alloc page for page table
    if(!create) return NULL;
		// CAUTION: this page is used for page table, not for common data page
		// set page reference
    struct Page* new_pte = alloc_page();
    if(!new_pte) return NULL;
    page_ref_inc(new_pte); 
		uintptr_t pa = (uintptr_t)page2kva(new_pte); // get linear address of page
		// clear page content using memset
    memset((void*)pa, 0, PGSIZE);
    //kprintf("@@@ %x\n", pa);
		// set page directory entry's permission
    *pdep = PADDR(pa);
    (*pdep) |= (PTE_U|PTE_P|PTE_W);
	}
  pte_t *ret = (pte_t*)KADDR((uintptr_t)((pte_t*)(PDE_ADDR(*pdep))+PTX(la)));

  //kprintf("@@GET_PTE %x %x %x\n", *pdep, ret, *ret);
	return  ret;// return page table entry
}

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
    pte_t *ptep = get_pte(pgdir, la, 0);
    if (ptep_store != NULL) {
        *ptep_store = ptep;
    }
    if (ptep != NULL && *ptep & PTE_P) {
        return pa2page(*ptep);
    }
    return NULL;
}

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
	if (ptep && (*ptep & PTE_P)) { // check if page directory is present
		struct Page *page = pte2page(*ptep); // find corresponding page to pte
		// decrease page reference
    page_ref_dec(page);
		// and free it when reach 0
    if(page_ref(page) == 0){
       free_page(page);
    }
		// clear page directory entry
    *ptep = 0;
	}
		// flush tlb
  tlb_invalidate_all();
}

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
    pte_t *ptep = get_pte(pgdir, la, 0);
    if (ptep != NULL) {
        page_remove_pte(pgdir, la, ptep);
    }
}

//page_insert - build the map of phy addr of an Page with the linear addr la
// paramemters:
//  pgdir: the kernel virtual base address of PDT
//  page:  the Page which need to map
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
    pte_t *ptep = get_pte(pgdir, la, 1);
    if (ptep == NULL) {
        return -E_NO_MEM;
    }
    page_ref_inc(page);
    if (*ptep & PTE_P) {
        struct Page *p = pte2page(*ptep);
        if (p == page) {
            page_ref_dec(page);
        }
        else {
            page_remove_pte(pgdir, la, ptep);
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
    tlb_invalidate(pgdir, la);
	// kprintf("page_insert: %p -> %p\n", la, pte2tlblow(*ptep));
    return 0;
}

extern int swap_init_ok;
// pgdir_alloc_page - call alloc_page & page_insert functions to 
//                  - allocate a page size memory & setup an addr map
//                  - pa<->la with linear address la and the PDT pgdir
struct Page *
pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
  struct Page *page = alloc_page();
  if (page != NULL) {
    if (page_insert(pgdir, page, la, perm) != 0) {
      free_page(page);
      return NULL;
    }
    if (swap_init_ok){
        panic("No swap!! never reach!!"); 
    }
  }

  return page;
}

static void
check_alloc_page(void) {
  pmm_manager->check();
  kprintf("check_alloc_page() succeeded!\n");
}

static void
check_pgdir(void) {
  assert(npage <= KMEMSIZE / PGSIZE);
  assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  assert(get_page(boot_pgdir, 0x0, NULL) == NULL);

  struct Page *p1, *p2;
  p1 = alloc_page();
  assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);

  pte_t *ptep;
  assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  assert(pa2page(*ptep) == p1);
  assert(page_ref(p1) == 1);

  ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);

  p2 = alloc_page();
  assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  assert(*ptep & PTE_U);
  assert(*ptep & PTE_W);
  assert(boot_pgdir[0] & PTE_U);
  assert(page_ref(p2) == 1);

  assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  assert(page_ref(p1) == 2);
  assert(page_ref(p2) == 0);
  assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  assert(pa2page(*ptep) == p1);
  assert((*ptep & PTE_U) == 0);

  page_remove(boot_pgdir, 0x0);
  assert(page_ref(p1) == 1);
  assert(page_ref(p2) == 0);

  page_remove(boot_pgdir, PGSIZE);
  assert(page_ref(p1) == 0);
  assert(page_ref(p2) == 0);

  assert(page_ref(pa2page(boot_pgdir[0])) == 1);
  free_page(pa2page(boot_pgdir[0]));
  boot_pgdir[0] = 0;

  kprintf("check_pgdir() succeeded!\n");
}

static void
check_boot_pgdir(void) {
  pte_t *ptep;
  int i;
  //assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));

  assert(boot_pgdir[0] == 0);
  struct Page *p;
  p = alloc_page();
  *(int*)(page2kva(p) + 0x100) = 0x1234;
  //printhex(page2kva(p));
  //kprintf("\n");
  //printhex(*(int*)(page2kva(p)+0x100));

  assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  assert(page_ref(p) == 1);
  assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  assert(page_ref(p) == 2);

  //kprintf("\nHERE\n");

  assert(*(int*)0x100 == 0x1234);
  const char *str = "ucore: Hello world!!";
  strcpy((void *)0x100, str);
  assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);

  *(char *)(page2kva(p) + 0x100) = '\0';
  assert(strlen((const char *)0x100) == 0);

  free_page(p);
  free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
  boot_pgdir[0] = 0;
  tlb_invalidate_all();

    kprintf("check_boot_pgdir() succeeded!\n");
}

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
    str[1] = 'r';
    str[2] = (perm & PTE_W) ? 'w' : '-';
    str[3] = '\0';
    return str;
}

//get_pgtable_items - In [left, right] range of PDT or PT, find a continuous linear addr space
//                  - (left_store*X_SIZE~right_store*X_SIZE) for PDT or PT
//                  - X_SIZE=PTSIZE=4M, if PDT; X_SIZE=PGSIZE=4K, if PT
// paramemters:
//  left:        no use ???
//  right:       the high side of table's range
//  start:       the low side of table's range
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
    }
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
            start ++;
        }
        if (right_store != NULL) {
            *right_store = start;
        }
        return perm;
    }
    return 0;
}

#define PRINT_PTE(s0, a0,a1,a2,a3,s1) kprintf(s0);printhex(a0);\
  kprintf(") ");printhex(a1);kprintf("-");printhex(a2);kprintf(" ");\
  printhex(a3);kprintf(" ");kprintf(s1);kprintf("\n");
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  size_t left, right = 0, perm;
    kprintf("-------------------- BEGIN --------------------\n");
  while ((perm = get_pgtable_items(0, NPDEENTRY, right, current_pgdir, &left, &right)) != 0) {
    PRINT_PTE("PDE(", right - left,
        left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
    size_t l, r = 0;

    size_t perm_ref = get_pgtable_items(0, NPTEENTRY, r, (pte_t *) PDE_ADDR(current_pgdir[left]), &l, &r);
    size_t count, count_ref = 0;
    size_t count_ref_l = 0;
    for (count=0; count<right-left; count++) {
      l = r = 0;
      while ((perm = get_pgtable_items(0, NPTEENTRY, r, (pte_t *) PDE_ADDR(current_pgdir[left+count]), &l, &r)) != 0) {
        if (perm != perm_ref || count == right-left-1) {
          size_t total_entries = (count-count_ref-1)*NPTEENTRY + (r - l) + (NPTEENTRY - count_ref_l);
          PRINT_PTE("  |-- PTE(", total_entries, 
              (left+count_ref) * PTSIZE + count_ref_l * PGSIZE, (left+count) * PTSIZE + r * PGSIZE,
              total_entries * PGSIZE, perm2str(perm_ref));
          perm_ref = perm;
          count_ref = count;
          count_ref_l = r;
        }
      }
    }
  }
    kprintf("--------------------- END ---------------------\n");
//    int st = read_c0_status();
//    kprintf("status=0x%x\n", st);
}


void
unmap_range(pde_t *pgdir, uintptr_t start, uintptr_t end) {
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
    assert(USER_ACCESS(start, end));

    do {
        pte_t *ptep = get_pte(pgdir, start, 0);
        if (ptep == NULL) {
            start = ROUNDDOWN_2N(start + PTSIZE, PTSHIFT);
            continue ;
        }
        if (*ptep != 0) {
            page_remove_pte(pgdir, start, ptep);
        }
        start += PGSIZE;
    } while (start != 0 && start < end);
}

void
exit_range(pde_t *pgdir, uintptr_t start, uintptr_t end) {
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
    assert(USER_ACCESS(start, end));

    start = ROUNDDOWN_2N(start, PTSHIFT);
    do {
        int pde_idx = PDX(start);
        if (pgdir[pde_idx] & PTE_P) {
            free_page(pde2page(pgdir[pde_idx]));
            pgdir[pde_idx] = 0;
        }
        start += PTSIZE;
    } while (start != 0 && start < end);
}

int
copy_range(pde_t *to, pde_t *from, uintptr_t start, uintptr_t end, bool share) {
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
    assert(USER_ACCESS(start, end));

    do {
        pte_t *ptep = get_pte(from, start, 0), *nptep;
        if (ptep == NULL) {
            start = ROUNDDOWN_2N(start + PTSIZE, PGSHIFT);
            continue ;
        }
        if (*ptep & PTE_P) {
          if ((nptep = get_pte(to, start, 1)) == NULL) {
            return -E_NO_MEM;
          }
          uint32_t perm = (*ptep & PTE_USER);
          struct Page *page = pte2page(*ptep);
          struct Page *npage=alloc_page();
          assert(page!=NULL);
          assert(npage!=NULL);
          int ret=0;
          //LAB5:EXERCISE2 2009010989
          //replicate content of page to npage, build the map of phy addr of nage with the linear addr start
          memcpy(page2kva(npage), page2kva(page), PGSIZE);
          page_insert(to, npage, start,perm);

          assert(ret == 0);
        }
        start += PGSIZE;
    } while (start != 0 && start < end);
    return 0;
}


