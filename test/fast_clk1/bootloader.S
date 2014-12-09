    #   $s0 : FLASH_START_ADDR
    addiu $s0, $zero, 0xbe
    sll $s0, $s0, 24

    #   $s1 : NUMBER_OF_INSTR
    lw $s1, 0($s0)
    lw $s2, 4($s0)
    sll $s2, $s2, 16
    or $s1, $s1, $s2
    addiu $s0, $s0, 8

    #   $s2 : RAM_START_ADDR
    addiu $s2, $zero, 0x8
    sll $s2, $s2, 28

load_one_ins:
    
    lw $s3, 0($s0)
    lw $s4, 4($s0)
    sll $s4, $s4, 16
    or $s3, $s3, $s4

    sw $s3, 0($s2)

    addiu $s2, $s2, 4
    addiu $s0, $s0, 8
    addiu $s1, $s1, -1

    bgtz $s1, load_one_ins

load_end:
    addiu $s2, $zero, 0x8
    sll $s2, $s2, 28
    jr $s2
