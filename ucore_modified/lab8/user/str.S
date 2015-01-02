          .data                         
          .align 2                      
_global_addr:
          .space 0                      



          .text                         
_lengthOf:                              # function entry
          subu $sp, $sp, 4              
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -32           
          sw $a0, 4($fp)                
          sw $a1, 8($fp)                
          sw $a2, 12($fp)               
          sw $a3, 16($fp)               
_L25:                                   
          la      $t0, _global_addr     
          li      $t0, 0                
          move    $t1, $t0              
          sw      $t1, -12($fp)         
_L26:                                   
          li      $t0, 0                
          lw      $t1, -12($fp)         
          slt     $t2, $t1, $t0         
          sw      $t1, -12($fp)         
          beqz    $t2, _L28             
_L27:                                   
          la      $t0, _STRING0         
          move    $a0, $t0              
          jal     _PrintString          
          jal     _Halt                 
_L28:                                   
          li      $t0, 1                
          lw      $t1, -12($fp)         
          mult    $t1, $t0              
          mflo    $t2                   
          lw      $t0, 4($fp)           
          addu    $t3, $t0, $t2         
          lb      $t2, 0($t3)           
          li      $t3, 0                
          sne     $t4, $t2, $t3         
          sw      $t0, 4($fp)           
          sw      $t1, -12($fp)         
          beqz    $t4, _L30             
_L29:                                   
          li      $t0, 1                
          lw      $t1, -12($fp)         
          addu    $t2, $t1, $t0         
          move    $t1, $t2              
          sw      $t1, -12($fp)         
          b       _L26                  
_L30:                                   
          lw      $t0, -12($fp)         
          move    $v0, $t0              
          move    $sp, $fp              
          lw      $ra, -4($fp)          
          lw      $fp, 0($fp)           
          addu    $sp, $sp, 4           
          jr      $ra                   

_strcmp:                                # function entry
          subu $sp, $sp, 4              
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -40           
          sw $a0, 4($fp)                
          sw $a1, 8($fp)                
          sw $a2, 12($fp)               
          sw $a3, 16($fp)               
_L31:                                   
          la      $t0, _global_addr     
          lw      $t0, 4($fp)           
          move    $a0, $t0              
          sw      $t0, 4($fp)           
          jal     _lengthOf             
          move    $t1, $v0              
          lw      $t0, 4($fp)           
          lw      $t2, 8($fp)           
          move    $a0, $t2              
          sw      $t0, 4($fp)           
          sw      $t1, -12($fp)         
          sw      $t2, 8($fp)           
          jal     _lengthOf             
          move    $t3, $v0              
          lw      $t0, 4($fp)           
          lw      $t1, -12($fp)         
          lw      $t2, 8($fp)           
          sne     $t4, $t1, $t3         
          sw      $t0, 4($fp)           
          sw      $t2, 8($fp)           
          beqz    $t4, _L33             
_L32:                                   
          li      $t0, 0                
          move    $v0, $t0              
          move    $sp, $fp              
          lw      $ra, -4($fp)          
          lw      $fp, 0($fp)           
          addu    $sp, $sp, 4           
          jr      $ra                   
_L33:                                   
          li      $t0, 0                
          move    $t1, $t0              
          sw      $t1, -16($fp)         
_L34:                                   
          li      $t0, 0                
          lw      $t1, -16($fp)         
          slt     $t2, $t1, $t0         
          sw      $t1, -16($fp)         
          beqz    $t2, _L36             
_L35:                                   
          la      $t0, _STRING0         
          move    $a0, $t0              
          jal     _PrintString          
          jal     _Halt                 
_L36:                                   
          li      $t0, 1                
          lw      $t1, -16($fp)         
          mult    $t1, $t0              
          mflo    $t2                   
          lw      $t0, 4($fp)           
          addu    $t3, $t0, $t2         
          lb      $t2, 0($t3)           
          li      $t3, 0                
          sne     $t4, $t2, $t3         
          sw      $t0, 4($fp)           
          sw      $t1, -16($fp)         
          beqz    $t4, _L44             
_L37:                                   
          li      $t0, 0                
          lw      $t1, -16($fp)         
          slt     $t2, $t1, $t0         
          sw      $t1, -16($fp)         
          beqz    $t2, _L39             
_L38:                                   
          la      $t0, _STRING0         
          move    $a0, $t0              
          jal     _PrintString          
          jal     _Halt                 
_L39:                                   
          li      $t0, 1                
          lw      $t1, -16($fp)         
          mult    $t1, $t0              
          mflo    $t2                   
          lw      $t0, 4($fp)           
          addu    $t3, $t0, $t2         
          lb      $t2, 0($t3)           
          li      $t3, 0                
          slt     $t4, $t1, $t3         
          sw      $t0, 4($fp)           
          sw      $t1, -16($fp)         
          sw      $t2, -20($fp)         
          beqz    $t4, _L41             
_L40:                                   
          la      $t0, _STRING0         
          move    $a0, $t0              
          jal     _PrintString          
          jal     _Halt                 
_L41:                                   
          li      $t0, 1                
          lw      $t1, -16($fp)         
          mult    $t1, $t0              
          mflo    $t2                   
          lw      $t0, 8($fp)           
          addu    $t3, $t0, $t2         
          lb      $t2, 0($t3)           
          lw      $t3, -20($fp)         
          sne     $t4, $t3, $t2         
          sw      $t0, 8($fp)           
          sw      $t1, -16($fp)         
          beqz    $t4, _L43             
_L42:                                   
          li      $t0, 0                
          move    $v0, $t0              
          move    $sp, $fp              
          lw      $ra, -4($fp)          
          lw      $fp, 0($fp)           
          addu    $sp, $sp, 4           
          jr      $ra                   
_L43:                                   
          li      $t0, 1                
          lw      $t1, -16($fp)         
          addu    $t2, $t1, $t0         
          move    $t1, $t2              
          sw      $t1, -16($fp)         
          b       _L34                  
_L44:                                   
          li      $t0, 1                
          move    $v0, $t0              
          move    $sp, $fp              
          lw      $ra, -4($fp)          
          lw      $fp, 0($fp)           
          addu    $sp, $sp, 4           
          jr      $ra                   

_printCompareString:                    # function entry
          subu $sp, $sp, 4              
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -32           
          sw $a0, 4($fp)                
          sw $a1, 8($fp)                
          sw $a2, 12($fp)               
          sw $a3, 16($fp)               
_L45:                                   
          la      $t0, _global_addr     
          la      $t0, _STRING1         
          move    $a0, $t0              
          jal     _PrintString          
          lw      $t0, 4($fp)           
          move    $a0, $t0              
          sw      $t0, 4($fp)           
          jal     _PrintString          
          lw      $t0, 4($fp)           
          la      $t1, _STRING2         
          move    $a0, $t1              
          sw      $t0, 4($fp)           
          jal     _PrintString          
          lw      $t0, 4($fp)           
          lw      $t1, 8($fp)           
          move    $a0, $t1              
          sw      $t0, 4($fp)           
          sw      $t1, 8($fp)           
          jal     _PrintString          
          lw      $t0, 4($fp)           
          lw      $t1, 8($fp)           
          la      $t2, _STRING3         
          move    $a0, $t2              
          sw      $t0, 4($fp)           
          sw      $t1, 8($fp)           
          jal     _PrintString          
          lw      $t0, 4($fp)           
          lw      $t1, 8($fp)           
          move    $a0, $t0              
          move    $a1, $t1              
          sw      $t0, 4($fp)           
          sw      $t1, 8($fp)           
          jal     _strcmp               
          move    $t2, $v0              
          lw      $t0, 4($fp)           
          lw      $t1, 8($fp)           
          move    $a0, $t2              
          sw      $t0, 4($fp)           
          sw      $t1, 8($fp)           
          jal     _PrintBool            
          lw      $t0, 4($fp)           
          lw      $t1, 8($fp)           
          la      $t2, _STRING4         
          move    $a0, $t2              
          sw      $t0, 4($fp)           
          sw      $t1, 8($fp)           
          jal     _PrintString          
          lw      $t0, 4($fp)           
          lw      $t1, 8($fp)           
          sw      $t0, 4($fp)           
          sw      $t1, 8($fp)           
          move    $v0, $zero            
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
_L46:                                   
          la      $t0, _global_addr     
          la      $t0, _STRING5         
          la      $t1, _STRING6         
          move    $a0, $t0              
          move    $a1, $t1              
          jal     _printCompareString   
          la      $t0, _STRING7         
          la      $t1, _STRING8         
          move    $a0, $t0              
          move    $a1, $t1              
          jal     _printCompareString   
          la      $t0, _STRING9         
          la      $t1, _STRING9         
          move    $a0, $t0              
          move    $a1, $t1              
          jal     _printCompareString   
          move    $v0, $zero            
          move    $sp, $fp              
          lw      $ra, -4($fp)          
          lw      $fp, 0($fp)           
          addu    $sp, $sp, 4           
          jr      $ra                   




          .data                         
_STRING1:
          .asciiz "\""                  
_STRING0:
          .asciiz "Decaf runtime error: Array subscript out of bounds\n"
_STRING5:
          .asciiz "Jobs"                
_STRING3:
          .asciiz "\": "                
_STRING7:
          .asciiz "case sensitive"      
_STRING2:
          .asciiz "\" and \""           
_STRING8:
          .asciiz "CASE SENSITIVE"      
_STRING4:
          .asciiz "\n"                  
_STRING6:
          .asciiz "Gates"               
_STRING9:
          .asciiz "Hello"               
