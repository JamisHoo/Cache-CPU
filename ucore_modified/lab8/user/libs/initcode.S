.text
.globl _start
_start:
    # load argc and argv
    # pass through load_icode
    addiu   $sp, $sp, -0x10

    # move down the esp register
    # since it may cause page fault in backtrace
    # addiu   $sp, $sp, -0x20

    # call user-program function
    jal     umain
1:  j       1b

