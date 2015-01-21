.text
.globl switch_to
switch_to:                      # switch_to(from, to)

    # save from's registers
    sw      $ra, 0x00($a0)
    sw      $sp, 0x04($a0)
    sw      $s0, 0x08($a0)
    sw      $s1, 0x0c($a0)
    sw      $s2, 0x10($a0)
    sw      $s3, 0x14($a0)
    sw      $s4, 0x18($a0)
    sw      $s5, 0x1c($a0)
    sw      $s6, 0x20($a0)
    sw      $s7, 0x24($a0)
    sw      $gp, 0x28($a0)
    sw      $fp, 0x2c($a0)

    # restore to's registers
    lw      $ra, 0x00($a1)
    lw      $sp, 0x04($a1)
    lw      $s0, 0x08($a1)
    lw      $s1, 0x0c($a1)
    lw      $s2, 0x10($a1)
    lw      $s3, 0x14($a1)
    lw      $s4, 0x18($a1)
    lw      $s5, 0x1c($a1)
    lw      $s6, 0x20($a1)
    lw      $s7, 0x24($a1)
    lw      $gp, 0x28($a1)
    lw      $fp, 0x2c($a1)

    jr      $ra

