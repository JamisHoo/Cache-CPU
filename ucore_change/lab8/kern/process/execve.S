#include <unistd.h>
.text
.globl kernel_execve
kernel_execve:
    move    $s4, $ra
    move    $s5, $fp
    move    $a2, $a1
    # count argc
    move    $a1, $zero
    move    $t0, $a2
1:
    lw      $t1, 0($t0)
    beq     $t1, $zero, 2f
    addiu   $t0, $t0, 4
    addiu   $a1, $a1, 1
    j       1b
2:
    # syscall
    li      $v0, SYS_exec
    syscall
    # ret
    move    $ra, $s4
    move    $fp, $s5
    jr      $ra
