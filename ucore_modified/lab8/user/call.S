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
          addiu $sp, $sp, -44           
          sw $a0, 4($fp)                
          sw $a1, 8($fp)                
          sw $a2, 12($fp)               
          sw $a3, 16($fp)               
_L13:                                   
          la      $t0, _global_addr     
          li      $t0, 3                
          li      $t1, 4                
          li      $t2, 5                
          li      $t3, 6                
          li      $t4, 7                
          move    $a0, $t0              
          move    $a1, $t1              
          move    $a2, $t2              
          move    $a3, $t3              
          sw      $t4, 16($sp)          
          jal     _test                 
          move    $v0, $zero            
          move    $sp, $fp              
          lw      $ra, -4($fp)          
          lw      $fp, 0($fp)           
          addu    $sp, $sp, 4           
          jr      $ra                   

_test:                                  # function entry
          subu $sp, $sp, 4              
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -28           
          sw $a0, 4($fp)                
          sw $a1, 8($fp)                
          sw $a2, 12($fp)               
          sw $a3, 16($fp)               
_L14:                                   
          la      $t0, _global_addr     
          lw      $t0, 4($fp)           
          move    $a0, $t0              
          sw      $t0, 4($fp)           
          jal     _PrintInt             
          lw      $t0, 4($fp)           
          lw      $t1, 8($fp)           
          move    $a0, $t1              
          sw      $t0, 4($fp)           
          sw      $t1, 8($fp)           
          jal     _PrintInt             
          lw      $t0, 4($fp)           
          lw      $t1, 8($fp)           
          lw      $t2, 12($fp)          
          move    $a0, $t2              
          sw      $t0, 4($fp)           
          sw      $t1, 8($fp)           
          sw      $t2, 12($fp)          
          jal     _PrintInt             
          lw      $t0, 4($fp)           
          lw      $t1, 8($fp)           
          lw      $t2, 12($fp)          
          lw      $t3, 16($fp)          
          move    $a0, $t3              
          sw      $t0, 4($fp)           
          sw      $t1, 8($fp)           
          sw      $t2, 12($fp)          
          sw      $t3, 16($fp)          
          jal     _PrintInt             
          lw      $t0, 4($fp)           
          lw      $t1, 8($fp)           
          lw      $t2, 12($fp)          
          lw      $t3, 16($fp)          
          lw      $t4, 20($fp)          
          move    $a0, $t4              
          sw      $t0, 4($fp)           
          sw      $t1, 8($fp)           
          sw      $t2, 12($fp)          
          sw      $t3, 16($fp)          
          sw      $t4, 20($fp)          
          jal     _PrintInt             
          lw      $t0, 4($fp)           
          lw      $t1, 8($fp)           
          lw      $t2, 12($fp)          
          lw      $t3, 16($fp)          
          lw      $t4, 20($fp)          
          sw      $t0, 4($fp)           
          sw      $t1, 8($fp)           
          sw      $t2, 12($fp)          
          sw      $t3, 16($fp)          
          sw      $t4, 20($fp)          
          move    $v0, $zero            
          move    $sp, $fp              
          lw      $ra, -4($fp)          
          lw      $fp, 0($fp)           
          addu    $sp, $sp, 4           
          jr      $ra                   




          .data                         
