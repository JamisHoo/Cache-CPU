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
          addiu $sp, $sp, -32           
          sw $a0, 4($fp)                
          sw $a1, 8($fp)                
          sw $a2, 12($fp)               
          sw $a3, 16($fp)               
_L16:                                   
          la      $t0, _global_addr     
          li      $t0, 0                
          move    $t1, $t0              
          sw      $t1, -12($fp)         
_L17:                                   
          li      $t0, 10               
          lw      $t1, -12($fp)         
          slt     $t2, $t1, $t0         
          sw      $t1, -12($fp)         
          beqz    $t2, _L19             
_L18:                                   
          lw      $t0, -12($fp)         
          move    $a0, $t0              
          sw      $t0, -12($fp)         
          jal     _get                  
          move    $t1, $v0              
          lw      $t0, -12($fp)         
          move    $a0, $t1              
          sw      $t0, -12($fp)         
          jal     _PrintInt             
          lw      $t0, -12($fp)         
          la      $t1, _STRING0         
          move    $a0, $t1              
          sw      $t0, -12($fp)         
          jal     _PrintString          
          lw      $t0, -12($fp)         
          li      $t1, 1                
          addu    $t2, $t0, $t1         
          move    $t0, $t2              
          sw      $t0, -12($fp)         
          b       _L17                  
_L19:                                   
          move    $v0, $zero            
          move    $sp, $fp              
          lw      $ra, -4($fp)          
          lw      $fp, 0($fp)           
          addu    $sp, $sp, 4           
          jr      $ra                   

_get:                                   # function entry
          subu $sp, $sp, 4              
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -32           
          sw $a0, 4($fp)                
          sw $a1, 8($fp)                
          sw $a2, 12($fp)               
          sw $a3, 16($fp)               
_L20:                                   
          la      $t0, _global_addr     
          li      $t0, 2                
          lw      $t1, 4($fp)           
          slt     $t2, $t1, $t0         
          sw      $t1, 4($fp)           
          beqz    $t2, _L22             
_L21:                                   
          li      $t0, 1                
          move    $v0, $t0              
          move    $sp, $fp              
          lw      $ra, -4($fp)          
          lw      $fp, 0($fp)           
          addu    $sp, $sp, 4           
          jr      $ra                   
_L22:                                   
          li      $t0, 1                
          lw      $t1, 4($fp)           
          subu    $t2, $t1, $t0         
          move    $a0, $t2              
          sw      $t1, 4($fp)           
          jal     _get                  
          move    $t0, $v0              
          lw      $t1, 4($fp)           
          li      $t2, 2                
          subu    $t3, $t1, $t2         
          move    $a0, $t3              
          sw      $t1, 4($fp)           
          sw      $t0, -12($fp)         
          jal     _get                  
          move    $t2, $v0              
          lw      $t1, 4($fp)           
          lw      $t0, -12($fp)         
          addu    $t3, $t0, $t2         
          sw      $t1, 4($fp)           
          move    $v0, $t3              
          move    $sp, $fp              
          lw      $ra, -4($fp)          
          lw      $fp, 0($fp)           
          addu    $sp, $sp, 4           
          jr      $ra                   




          .data                         
_STRING0:
          .asciiz "\n"                  
