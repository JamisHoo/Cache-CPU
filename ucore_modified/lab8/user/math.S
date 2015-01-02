          .data                         
          .align 2                      
_global_addr:
          .space 0                      



          .text                         
_abs:                                   # function entry
          subu $sp, $sp, 4              
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -24           
          sw $a0, 4($fp)                
          sw $a1, 8($fp)                
          sw $a2, 12($fp)               
          sw $a3, 16($fp)               
_L29:                                   
          la      $t0, _global_addr     
          li      $t0, 0                
          lw      $t1, 4($fp)           
          sge     $t2, $t1, $t0         
          sw      $t1, 4($fp)           
          beqz    $t2, _L31             
_L30:                                   
          lw      $t0, 4($fp)           
          move    $v0, $t0              
          move    $sp, $fp              
          lw      $ra, -4($fp)          
          lw      $fp, 0($fp)           
          addu    $sp, $sp, 4           
          jr      $ra                   
_L31:                                   
          li      $t0, 1                
          lw      $t0, 4($fp)           
          subu    $t1, $zero, $t0       
          sw      $t0, 4($fp)           
          move    $v0, $t1              
          move    $sp, $fp              
          lw      $ra, -4($fp)          
          lw      $fp, 0($fp)           
          addu    $sp, $sp, 4           
          jr      $ra                   

_pow:                                   # function entry
          subu $sp, $sp, 4              
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -32           
          sw $a0, 4($fp)                
          sw $a1, 8($fp)                
          sw $a2, 12($fp)               
          sw $a3, 16($fp)               
_L33:                                   
          la      $t0, _global_addr     
          li      $t0, 1                
          move    $t1, $t0              
          li      $t0, 0                
          move    $t2, $t0              
          sw      $t2, -12($fp)         
          sw      $t1, -16($fp)         
_L35:                                   
          lw      $t0, -12($fp)         
          lw      $t1, 8($fp)           
          slt     $t2, $t0, $t1         
          sw      $t1, 8($fp)           
          sw      $t0, -12($fp)         
          beqz    $t2, _L37             
_L36:                                   
          lw      $t0, -16($fp)         
          lw      $t1, 4($fp)           
          mult    $t0, $t1              
          mflo    $t2                   
          move    $t0, $t2              
          sw      $t1, 4($fp)           
          sw      $t0, -16($fp)         
_L34:                                   
          li      $t0, 1                
          lw      $t1, -12($fp)         
          addu    $t2, $t1, $t0         
          move    $t1, $t2              
          sw      $t1, -12($fp)         
          b       _L35                  
_L37:                                   
          lw      $t0, -16($fp)         
          move    $v0, $t0              
          move    $sp, $fp              
          lw      $ra, -4($fp)          
          lw      $fp, 0($fp)           
          addu    $sp, $sp, 4           
          jr      $ra                   

_log:                                   # function entry
          subu $sp, $sp, 4              
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -28           
          sw $a0, 4($fp)                
          sw $a1, 8($fp)                
          sw $a2, 12($fp)               
          sw $a3, 16($fp)               
_L38:                                   
          la      $t0, _global_addr     
          li      $t0, 1                
          lw      $t1, 4($fp)           
          slt     $t2, $t1, $t0         
          sw      $t1, 4($fp)           
          beqz    $t2, _L40             
_L39:                                   
          li      $t0, 1                
          li      $t1, 1                
          subu    $t1, $zero, $t0       
          move    $v0, $t1              
          move    $sp, $fp              
          lw      $ra, -4($fp)          
          lw      $fp, 0($fp)           
          addu    $sp, $sp, 4           
          jr      $ra                   
_L40:                                   
          li      $t0, 0                
          move    $t1, $t0              
          sw      $t1, -12($fp)         
_L41:                                   
          li      $t0, 1                
          lw      $t1, 4($fp)           
          sgt     $t2, $t1, $t0         
          sw      $t1, 4($fp)           
          beqz    $t2, _L43             
_L42:                                   
          li      $t0, 1                
          li      $t1, 1                
          lw      $t1, -12($fp)         
          addu    $t2, $t1, $t0         
          move    $t1, $t2              
          li      $t0, 2                
          lw      $t2, 4($fp)           
          div     $zero, $t2, $t0       
          mflo    $t3                   
          move    $t2, $t3              
          sw      $t2, 4($fp)           
          sw      $t1, -12($fp)         
          b       _L41                  
_L43:                                   
          lw      $t0, -12($fp)         
          move    $v0, $t0              
          move    $sp, $fp              
          lw      $ra, -4($fp)          
          lw      $fp, 0($fp)           
          addu    $sp, $sp, 4           
          jr      $ra                   

_max:                                   # function entry
          subu $sp, $sp, 4              
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -24           
          sw $a0, 4($fp)                
          sw $a1, 8($fp)                
          sw $a2, 12($fp)               
          sw $a3, 16($fp)               
_L44:                                   
          la      $t0, _global_addr     
          lw      $t0, 4($fp)           
          lw      $t1, 8($fp)           
          sgt     $t2, $t0, $t1         
          sw      $t0, 4($fp)           
          sw      $t1, 8($fp)           
          beqz    $t2, _L46             
_L45:                                   
          lw      $t0, 4($fp)           
          move    $v0, $t0              
          move    $sp, $fp              
          lw      $ra, -4($fp)          
          lw      $fp, 0($fp)           
          addu    $sp, $sp, 4           
          jr      $ra                   
_L46:                                   
          lw      $t0, 8($fp)           
          move    $v0, $t0              
          move    $sp, $fp              
          lw      $ra, -4($fp)          
          lw      $fp, 0($fp)           
          addu    $sp, $sp, 4           
          jr      $ra                   

_min:                                   # function entry
          subu $sp, $sp, 4              
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -24           
          sw $a0, 4($fp)                
          sw $a1, 8($fp)                
          sw $a2, 12($fp)               
          sw $a3, 16($fp)               
_L48:                                   
          la      $t0, _global_addr     
          lw      $t0, 4($fp)           
          lw      $t1, 8($fp)           
          slt     $t2, $t0, $t1         
          sw      $t0, 4($fp)           
          sw      $t1, 8($fp)           
          beqz    $t2, _L50             
_L49:                                   
          lw      $t0, 4($fp)           
          move    $v0, $t0              
          move    $sp, $fp              
          lw      $ra, -4($fp)          
          lw      $fp, 0($fp)           
          addu    $sp, $sp, 4           
          jr      $ra                   
_L50:                                   
          lw      $t0, 8($fp)           
          move    $v0, $t0              
          move    $sp, $fp              
          lw      $ra, -4($fp)          
          lw      $fp, 0($fp)           
          addu    $sp, $sp, 4           
          jr      $ra                   
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
_L52:                                   
          la      $t0, _global_addr     
          li      $t0, 1                
          li      $t1, 1                
          subu    $t1, $zero, $t0       
          move    $a0, $t1              
          jal     _abs                  
          move    $t0, $v0              
          move    $a0, $t0              
          jal     _PrintInt             
          la      $t0, _STRING0         
          move    $a0, $t0              
          jal     _PrintString          
          li      $t0, 2                
          li      $t1, 3                
          move    $a0, $t0              
          move    $a1, $t1              
          jal     _pow                  
          move    $t0, $v0              
          move    $a0, $t0              
          jal     _PrintInt             
          la      $t0, _STRING0         
          move    $a0, $t0              
          jal     _PrintString          
          li      $t0, 16               
          move    $a0, $t0              
          jal     _log                  
          move    $t0, $v0              
          move    $a0, $t0              
          jal     _PrintInt             
          la      $t0, _STRING0         
          move    $a0, $t0              
          jal     _PrintString          
          li      $t0, 1                
          li      $t1, 2                
          move    $a0, $t0              
          move    $a1, $t1              
          jal     _max                  
          move    $t0, $v0              
          move    $a0, $t0              
          jal     _PrintInt             
          la      $t0, _STRING0         
          move    $a0, $t0              
          jal     _PrintString          
          li      $t0, 1                
          li      $t1, 2                
          move    $a0, $t0              
          move    $a1, $t1              
          jal     _min                  
          move    $t0, $v0              
          move    $a0, $t0              
          jal     _PrintInt             
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
          .asciiz "\n"                  
