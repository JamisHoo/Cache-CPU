#include <defs.h>
#include <asm/mipsregs.h>
#include <clock.h>
#include <trap.h>
#include <thumips.h>
#include <thumips_tlb.h>
#include <stdio.h>
#include <mmu.h>
#include <pmm.h>
#include <memlayout.h>
#include <glue_pgmap.h>
#include <assert.h>
#include <console.h>
#include <kdebug.h>
#include <error.h>
#include <syscall.h>
#include <proc.h>

#define TICK_NUM 100

#define GET_CAUSE_EXCODE(x)   ( ((x) & CAUSEF_EXCCODE) >> CAUSEB_EXCCODE)

static void print_ticks() {
    PRINT_HEX("%d ticks\n",TICK_NUM);
}



static const char *
trapname(int trapno) {
    static const char * const excnames[] = {
        "Interrupt",
        "TLB Modify",
        "TLB miss on load",
        "TLB miss on store",
        "Address error on load",
        "Address error on store",
        "Bus error on instruction fetch",
        "Bus error on data load or store",
        "Syscall",
        "Breakpoint",
        "Reserved (illegal) instruction",
        "Coprocessor unusable",
        "Arithmetic overflow",
    };
    if(trapno <= 12)
      return excnames[trapno];
    else
      return "Unknown";
}

bool
trap_in_kernel(struct trapframe *tf) {
  return !(tf->tf_status & KSU_USER);       //是不是在kernel区域出现的异常呢?
}


void print_regs(struct pushregs *regs)
{
  int i;
  for (i = 0; i < 30; i++) {
    kprintf(" $");
    printbase10(i+1);
    kprintf("\t: ");
    printhex(regs->reg_r[i]);
    kputchar('\n');
  }
}

void
print_trapframe(struct trapframe *tf) {
    PRINT_HEX("trapframe at ", tf);
    print_regs(&tf->tf_regs);
    PRINT_HEX(" $ra\t: ", tf->tf_ra);
    PRINT_HEX(" BadVA\t: ", tf->tf_vaddr);
    PRINT_HEX(" Status\t: ", tf->tf_status);
    PRINT_HEX(" Cause\t: ", tf->tf_cause);
    PRINT_HEX(" EPC\t: ", tf->tf_epc);
    if (!trap_in_kernel(tf)) {
      kprintf("Trap in usermode: ");
    }else{
      kprintf("Trap in kernel: ");
    }
    kprintf(trapname(GET_CAUSE_EXCODE(tf->tf_cause)));
    kputchar('\n');
    
    /*
    int i;
    for (i = 0; i < 20; ++i) {
        int *addr = (int*)(tf->tf_epc + i * 4);
        kprintf("0x%08x=0x%08x\n", addr, *addr);
    }
    */
}

//处理外部中断
static void interrupt_handler(struct trapframe *tf)
{
  extern clock_int_handler(void*);
  extern serial_int_handler(void*);
  extern keyboard_int_handler();
  int i;
  for(i=0;i<8;i++){                         //CAUSE寄存器一共8个IP位，确定是哪一位出了中断？
                                            //CAUSEB_IP = 8 相关说明见include/asm/mipsreg.h
    if(tf->tf_cause & (1<<(CAUSEB_IP+i))){  //具体异常位说明，参见include/thumips.h
      switch(i){
        case TIMER0_IRQ:                    //TIMER0_IRQ = 7
          clock_int_handler(NULL);          //driver/clock.c
          break;
        case COM1_IRQ:                      //COM1_IRQ = 4
          //kprintf("COM1_IRQ!\n");
          serial_int_handler(NULL);         //driver/console.c
          break;
        case KEYBOARD_IRQ:                  //KEYBOARD_IRQ = 6
          //kprintf("KEYBOARD\n");
          keyboard_int_handler();           //driver/console.c
          break;
        default:
          print_trapframe(tf);
          panic("Unknown interrupt!");
      }
    }
  }

}

extern pde_t *current_pgdir;



static inline int get_error_code(int write, pte_t *pte)
{
  int r = 0;
  if(pte!=NULL && ptep_present(pte))
    r |= 0x01;
  if(write)
    r |= 0x02;
  return r;
}

static int
pgfault_handler(struct trapframe *tf, uint32_t addr, uint32_t error_code) {
#if 0
    extern struct mm_struct *check_mm_struct;
    if (check_mm_struct != NULL) {
        return do_pgfault(check_mm_struct, error_code, addr);
    }
    panic("unhandled page fault.\n");
#endif
  extern struct mm_struct *check_mm_struct;
  if(check_mm_struct !=NULL) { //used for test check_swap
    //print_pgfault(tf);
  }
  struct mm_struct *mm;
  if (check_mm_struct != NULL) {
    assert(current == idleproc);
    mm = check_mm_struct;
  }
  else {
    if (current == NULL) {
      print_trapframe(tf);
      //print_pgfault(tf);
      panic("unhandled page fault.\n");
    }
    mm = current->mm;
  }
  return do_pgfault(mm, error_code, addr);
}

//TLB异常的处理方式
/* use software emulated X86 pgfault */
static void handle_tlbmiss(struct trapframe* tf, int write)
{
#if 0
  if(!trap_in_kernel(tf)){
    print_trapframe(tf);
    while(1);
  }
#endif

  static int entercnt = 0;
  entercnt ++;
  //kprintf("## enter handle_tlbmiss %d times\n", entercnt);
  int in_kernel = trap_in_kernel(tf);
  assert(current_pgdir != NULL);
  //print_trapframe(tf);
  uint32_t badaddr = tf->tf_vaddr;        //异常出现的地址是那个？
  int ret = 0;
                                          //以下代码涉及到 kern/mm/pmm.c; kern/mm/mmu.h; kern/include/glue_pgmap.h
                                          //一些类型定义pte_t之类的，可以参考memlayout.h
  pte_t *pte = get_pte(current_pgdir, tf->tf_vaddr, 0);
  if(pte==NULL || ptep_invalid(pte)){   //PTE miss, pgfault
    //panic("unimpl");
    //TODO
    //tlb will not be refill in do_pgfault,
    //so a vmm pgfault will trigger 2 exception
    //permission check in tlb miss
    ret = pgfault_handler(tf, badaddr, get_error_code(write, pte));
  }else{ //tlb miss only, reload it
    /* refill two slot */
    /* check permission */
    if(in_kernel){
      tlb_refill(badaddr, pte); 
    //kprintf("## refill K\n");
      return;
    }else{
      if(!ptep_u_read(pte)){
        ret = -1;
        goto exit;
      }
      if(write && !ptep_u_write(pte)){
        ret = -2;
        goto exit;
      }
    //kprintf("## refill U %d %08x\n", write, badaddr);
      tlb_refill(badaddr, pte);
      return ;
    }
  }

exit:
  if(ret){
    print_trapframe(tf);
    if(in_kernel){
      panic("unhandled pgfault");
    }else{
      do_exit(-E_KILLED);
    }
  }
  return ;
}

//异常的真正处理函数
static void
trap_dispatch(struct trapframe *tf) {
  int code = GET_CAUSE_EXCODE(tf->tf_cause);    //什么异常？
  switch(code){
    case EX_IRQ:                          //INTERRUPT
      interrupt_handler(tf);
      break;
    case EX_TLBL:                         //Load的时候出现TLB缺失
      handle_tlbmiss(tf, 0);
      break;
    case EX_TLBS:                         //Store的时候出现TLB缺失
      handle_tlbmiss(tf, 1);
      break;
    case EX_RI:
      print_trapframe(tf);                //异常的指令，可能是超出了指令集的
      panic("hey man! Do NOT use that insn!");
      break;
    case EX_SYS:                          //系统调用
      //print_trapframe(tf);
      tf->tf_epc += 4;
      syscall();                          //见syscall/syscall.c
      break;
      /* alignment error or access kernel
       * address space in user mode */

    case EX_ADEL:                         //地址异常，Load阶段的，没有4对齐
    case EX_ADES:                         //地址异常，Store阶段的
      if(trap_in_kernel(tf)){
        print_trapframe(tf);
        panic("Alignment Error");         //如果是在kernel出现的异常似乎还能正常运行
      }else{
        print_trapframe(tf);
        do_exit(-E_KILLED);               //如果在user space出现不对齐异常直接kill？
      }
      break;
    default:
      print_trapframe(tf);
      panic("Unhandled Exception");
  }

}


/*
 * General trap (exception) handling function for mips.
 * This is called by the assembly-language exception handler once
 * the trapframe has been set up.
 */
  void
mips_trap(struct trapframe *tf)
{//kprintf("mips_trap:epc=0x%x cause=%x badvaddr=0x%08x\n", tf->tf_epc, (tf->tf_cause >> 2) & 0x1F, tf->tf_vaddr);
  // dispatch based on what type of trap occurred
  // used for previous projects
  if (current == NULL) {
    trap_dispatch(tf);            //真正的处理函数
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

