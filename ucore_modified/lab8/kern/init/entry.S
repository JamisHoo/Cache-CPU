.globl kern_entry
kern_entry:
    la      $sp, kern_entry
    jal     kern_init
spin:
    j       spin
