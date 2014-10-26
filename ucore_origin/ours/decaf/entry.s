.globl _Alloc, _PrintInt, _PrintString, main

_Alloc:
lw $a0, 4($sp)
j Alloc

_PrintInt:
lw $a0, 4($sp)
j PrintInt

_PrintString:
lw $a0, 4($sp)
j PrintString

main:
jal decaf_main
li $a0, 0
j exit

# vim: ft=mips
