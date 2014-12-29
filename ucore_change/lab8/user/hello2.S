          .data                         
          .align 2                      
_global_addr:
          .space 0                      



          .text                         
.globl main
main:                                   # function entry
          subu $sp, $sp, 4              
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -28           
          sw $a0, 4($fp)                
          sw $a1, 8($fp)                
          sw $a2, 12($fp)               
          sw $a3, 16($fp)               
_L12:                                   
          la      $t0, _global_addr     
          la      $t0, _STRING0         
          move    $a0, $t0              
          jal     _PrintString          
          move    $v0, $zero            
          move    $sp, $fp              
          lw      $ra, -4($fp)          
          lw      $fp, 0($fp)           
          addu    $sp, $sp, 4           
          jr      $ra                   




          .data                         
_STRING0:
          .asciiz "hello"               
