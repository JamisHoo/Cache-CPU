.text
.globl do_syscall
do_syscall:
    lw      $v1, 0x10($sp)
    lw      $v0, 0x14($sp)
    syscall
    jr      $ra
