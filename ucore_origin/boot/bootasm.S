/* 
  Bootloader for MIPS32S
  Chen Yuheng
  2012/07/16
 */

#define FLASH_START 0xBE000000
#define ELF_MAGIC 0x464C457F          #这个什么意思？

#注意Flash是16字节的，所以每次往32位的内存里面load的时候，都需要两次操作，还要做一次OR
#注意函数中的off是用byte来计数的


#Flash中的内容到底是什么？否则不好解读这段代码？
#尤其是后面的28,44,24，相应的Flash地址中到底有什么？

/* off = offset from s0 */
/* load a 32bit word from Flash, 
 * off is byte-addressed */

#自定义函数
#dst = FLASH[ Flash_Start + offset<<1 + 4] | FLASH[ Flash_Start + offset<<1]
#define LOAD_WORD_I(dst, off) \
  la $t7, ((off) << 1); \
  addu $t7, $s0, $t7; \
  lw dst, 0($t7); \
  lw $t7, 4($t7); \
  sll $t7, $t7, 16; \
  or dst, dst, $t7

#dst = FLASH[ Flash_Start + (base + off)<< 1 + 4] | FLASH[ Flash_Start + (base + off)<< 1 ]
#define LOAD_WORD_R(dst, off, base) \
  addiu $t7, base, off;\
  sll  $t7, $t7, 1; \ 
  addu $t7, $s0, $t7; \
  lw dst, 0($t7); \
  lw $t7, 4($t7); \
  sll $t7, $t7, 16; \
  or dst, dst, $t7;
   
#assume file base == FLASH_START

.set noreorder
.set noat
.globl __start
__start:
  nop
  b load_elf                  #bootloader的主函数就是把elf文件load进来
  nop

load_elf:
  #addr of elfheader, s0
  la $s0, FLASH_START         
  #e_magic
  LOAD_WORD_I($t1, 0)
  la $t0, ELF_MAGIC                   #Flash起始标记，和贾开的工具配套
  beq $t0, $t1, 1f
  nop
  b bad
  nop
1:
  #e_phoff
  LOAD_WORD_I($s1, 28)        #这个似乎是flash中指令的起点
  #e_phnum
  LOAD_WORD_I($s2, 44)
  andi $s2, $s2, 0xFFFF       #这个似乎是flash中文件的总指令数

  #e_entry
  LOAD_WORD_I($s3, 24)        #这里load了kernel的入口点到$s3，之后有用

next_sec:
  #s1, addr proghdr
  #s4, p_va
  LOAD_WORD_R($s4, 8, $s1)
  #s5, p_filesz
  LOAD_WORD_R($s5, 16, $s1)
  #s6, p_offset
  LOAD_WORD_R($s6, 4, $s1)

  beq  $s4, $zero, 3f
  nop
  beq  $s5, $zero, 3f
  nop

#copy from file_base+p_offset to p_va
copy_sec:
  LOAD_WORD_R($t0, 0, $s6)
  sw $t0, 0($s4)
  addiu $s6, $s6, 4
  addiu $s4, $s4, 4
  addiu $s5, $s5, -4
  bgtz  $s5, copy_sec
  nop

3:
  addiu $s1, $s1, 32
  addiu $s2, $s2, -1
  bgtz  $s2, next_sec
  nop

done:
#jump to kernel
  jr $s3
  nop
  b .
  nop

bad:
  b bad 
  nop

