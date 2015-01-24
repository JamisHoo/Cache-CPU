# added by Hao Sun

.globl  decaf_PrintString,  decaf_PrintInt, decaf_PrintBool, decaf_Halt, decaf_ReadLine, decaf_ReadInteger, decaf_Alloc, decaf_Div, decaf_Rem

decaf_PrintString:
lw $a0, 4($sp)
j _PrintString

decaf_PrintInt:
lw $a0, 4($sp)
j _PrintInt

decaf_PrintBool:
lw $a0, 4($sp)
j _PrintBool

decaf_Halt:
j _Halt

decaf_ReadLine:
j _ReadLine

decaf_ReadInteger:
j _ReadInteger

decaf_Alloc:
lw $a0, 4($sp)
j _Alloc

decaf_Div:
lw $a0, 4($sp)
lw $a1, 8($sp)
j _Div

decaf_Rem:
lw $a0, 4($sp)
lw $a1, 8($sp)
j _Rem
