#include <memlayout.h>
#include <cp0.h>

# idt_init sends all traps here.
.text
.globl __alltraps
__alltraps:
    .set noat

    # switch to kernel stack
    mfc0    $k0, CP0_Status
    andi    $k0, $k0, 0x00000010
    move    $k1, $sp
    beq     $k0, $zero, 1f
    la      $sp, kstack_sp
    lw      $sp, 0($sp)

    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
1:
    addiu   $sp, $sp, -0xa0
    sw      $at, 0x04($sp)
    .set at
    sw      $v0, 0x08($sp)
    sw      $v1, 0x0c($sp)
    sw      $a0, 0x10($sp)
    sw      $a1, 0x14($sp)
    sw      $a2, 0x18($sp)
    sw      $a3, 0x1c($sp)
    sw      $t0, 0x20($sp)
    sw      $t1, 0x24($sp)
    sw      $t2, 0x28($sp)
    sw      $t3, 0x2c($sp)
    sw      $t4, 0x30($sp)
    sw      $t5, 0x34($sp)
    sw      $t6, 0x38($sp)
    sw      $t7, 0x3c($sp)
    sw      $s0, 0x40($sp)
    sw      $s1, 0x44($sp)
    sw      $s2, 0x48($sp)
    sw      $s3, 0x4c($sp)
    sw      $s4, 0x50($sp)
    sw      $s5, 0x54($sp)
    sw      $s6, 0x58($sp)
    sw      $s7, 0x5c($sp)
    sw      $t8, 0x60($sp)
    sw      $t9, 0x64($sp)
    sw      $gp, 0x70($sp)
    sw      $k1, 0x74($sp)
    sw      $fp, 0x78($sp)
    sw      $ra, 0x7c($sp)
    mfc0    $t4, CP0_Status
    sw      $t4, 0x80($sp)
    mfc0    $t5, CP0_Cause
    sw      $t5, 0x84($sp)
    mfc0    $t6, CP0_EPC
    sw      $t6, 0x88($sp)
    mfc0    $t7, CP0_BadVAddr
    sw      $t7, 0x8c($sp)
    mflo    $t0
    sw      $t0, 0x90($sp)
    mfhi    $t0
    sw      $t0, 0x94($sp)

    # exit exception mode
    and     $t4, $t4, 0xffffffec
    mtc0    $t4, CP0_Status

    # push $sp to pass a pointer to the trapframe as an argument to trap()
    move    $a0, $sp
    addiu   $sp, $sp, -0x10
    move    $fp, $sp

    # call trap(tf), where tf=%esp
    jal     trap

    # pop the pushed stack pointer
    move    $sp, $fp
    addiu   $sp, $sp, 0x10

    # return falls through to trapret...
.globl __trapret
__trapret:
    # enter exception mode
    lw      $t0, 0x80($sp)
    mfc0    $t1, CP0_Status
    and     $t1, $t1, 0xffffff00
    or      $t0, $t0, $t1
    mtc0    $t0, CP0_Status

    # restore registers from stack
    lw      $v0, 0x08($sp)
    lw      $v1, 0x0c($sp)
    lw      $a0, 0x10($sp)
    lw      $a1, 0x14($sp)
    lw      $a2, 0x18($sp)
    lw      $a3, 0x1c($sp)
    lw      $t0, 0x20($sp)
    lw      $t1, 0x24($sp)
    lw      $t2, 0x28($sp)
    lw      $t3, 0x2c($sp)
    lw      $t4, 0x30($sp)
    lw      $t5, 0x34($sp)
    lw      $t6, 0x38($sp)
    lw      $t7, 0x3c($sp)
    lw      $s0, 0x40($sp)
    lw      $s1, 0x44($sp)
    lw      $s2, 0x48($sp)
    lw      $s3, 0x4c($sp)
    lw      $s4, 0x50($sp)
    lw      $s5, 0x54($sp)
    lw      $s6, 0x58($sp)
    lw      $s7, 0x5c($sp)
    lw      $t8, 0x60($sp)
    lw      $t9, 0x64($sp)
    lw      $gp, 0x70($sp)
    lw      $k1, 0x74($sp)
    lw      $fp, 0x78($sp)
    lw      $ra, 0x7c($sp)
    lw      $k0, 0x90($sp)
    mtlo    $k0
    lw      $k0, 0x94($sp)
    mthi    $k0
    lw      $k0, 0x88($sp)
    mtc0    $k0, CP0_EPC
    .set noat
    lw      $at, 0x04($sp)
    addiu   $sp, $sp, 0xa0

    # switch stack back
    mfc0    $k0, CP0_Status
    andi    $k0, $k0, 0x00000010
    beq     $k0, $zero, 1f
    move    $sp, $k1
1:
    .set at
    eret

.globl forkrets
forkrets:
    move    $sp, $a0
    j       __trapret
