#Cache CPU
Cache CPU(CaCPU) is a MIPS32 instruction subset based multiple cycle processor. 
It supports 48 instructions, exception and interrupt handling, 
MMU and TLB and privilege level.
It's implemented mainly in VHDL.
Cache is just our team name, but not stands for the fast memory used by CPU.
A Unix-like tiny OS ucore can run on this processor.
A decaf/Mind cross-compiler can generate code runs on ucore OS.
Both the OS and the compier is included in this project.

## 48 instructions
addi,
addu,
slt,
slti,
sltiu,
sltu,
subu,
mult,
mflo,
mfhi,
mtlo,
mthi,
and,
andi,
lui,
nor,
or,
ori,
xor,
xori,
sll,
sllv,
sra,
srav,
srl,
srlv,
beq,
bgez,
bgtz,
blez,
bltz,
bne,
j,
jal,
jalr,
jr,
lw,
sw,
lb,
lbu,
sb,
syscall,
eret,
mfc0,
mtc0,
tlbwi,
lhu,
nop.

##Decaf/Mind Compiler
Decaf/Mind is a strongly typed, object-oriented language which supports single inheritance.
It's quite similar to C++/Java.

This cross-compiler is implemented in Java, 
and it doesn't support all the features of Decaf/Mind.



