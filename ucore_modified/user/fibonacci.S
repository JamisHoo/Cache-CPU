          .text                         
          .globl main                   

          .data                         
          .align 2                      
_Fib:                                   # virtual table
          .word 0                       # parent
          .word _STRING0                # class name
          .word _Fib.fib                

          .data                         
          .align 2                      
_Main:                                  # virtual table
          .word 0                       # parent
          .word _STRING1                # class name



          .text                         
_Fib_New:                               # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -16           
_L18:                                   
          li    $t0, 4                  
          sw    $t0, 4($sp)             
          jal   decaf_Alloc             
          move  $t0, $v0                
          la    $t1, _Fib               
          sw    $t1, 0($t0)             
          move  $v0, $t0                
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     

_Main_New:                              # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -16           
_L19:                                   
          li    $t0, 4                  
          sw    $t0, 4($sp)             
          jal   decaf_Alloc             
          move  $t0, $v0                
          la    $t1, _Main              
          sw    $t1, 0($t0)             
          move  $v0, $t0                
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     

_Fib.fib:                               # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -24           
_L20:                                   
          li    $t0, 2                  
          lw    $t1, 8($fp)             
          slt   $t2, $t1, $t0           
          sw    $t1, 8($fp)             
          beqz  $t2, _L22               
_L21:                                   
          lw    $t0, 8($fp)             
          move  $v0, $t0                
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
_L22:                                   
          li    $t0, 1                  
          lw    $t1, 8($fp)             
          subu  $t2, $t1, $t0           
          lw    $t0, 4($fp)             
          sw    $t0, 4($sp)             
          sw    $t2, 8($sp)             
          lw    $t2, 0($t0)             
          lw    $t3, 8($t2)             
          sw    $t0, 4($fp)             
          sw    $t1, 8($fp)             
          jalr  $t3                     
          move  $t2, $v0                
          lw    $t0, 4($fp)             
          lw    $t1, 8($fp)             
          li    $t3, 2                  
          subu  $t4, $t1, $t3           
          sw    $t0, 4($sp)             
          sw    $t4, 8($sp)             
          lw    $t3, 0($t0)             
          lw    $t4, 8($t3)             
          sw    $t0, 4($fp)             
          sw    $t1, 8($fp)             
          sw    $t2, -8($fp)            
          jalr  $t4                     
          move  $t3, $v0                
          lw    $t0, 4($fp)             
          lw    $t1, 8($fp)             
          lw    $t2, -8($fp)            
          addu  $t4, $t2, $t3           
          sw    $t0, 4($fp)             
          sw    $t1, 8($fp)             
          move  $v0, $t4                
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     

main:                                   # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -28           
_L23:                                   
          jal   _Fib_New                
          move  $t0, $v0                
          move  $t1, $t0                
          li    $t0, 0                  
          move  $t2, $t0                
          sw    $t1, -8($fp)            
          sw    $t2, -12($fp)           
_L25:                                   
          li    $t0, 25                 
          lw    $t1, -12($fp)           
          slt   $t2, $t1, $t0           
          sw    $t1, -12($fp)           
          beqz  $t2, _L27               
_L26:                                   
          la    $t0, _STRING2           
          sw    $t0, 4($sp)             
          jal   decaf_PrintString       
          lw    $t0, -12($fp)           
          sw    $t0, 4($sp)             
          sw    $t0, -12($fp)           
          jal   decaf_PrintInt          
          lw    $t0, -12($fp)           
          la    $t1, _STRING3           
          sw    $t1, 4($sp)             
          sw    $t0, -12($fp)           
          jal   decaf_PrintString       
          lw    $t0, -12($fp)           
          lw    $t1, -8($fp)            
          sw    $t1, 4($sp)             
          sw    $t0, 8($sp)             
          lw    $t2, 0($t1)             
          lw    $t3, 8($t2)             
          sw    $t1, -8($fp)            
          sw    $t0, -12($fp)           
          jalr  $t3                     
          move  $t2, $v0                
          lw    $t1, -8($fp)            
          lw    $t0, -12($fp)           
          sw    $t2, 4($sp)             
          sw    $t1, -8($fp)            
          sw    $t0, -12($fp)           
          jal   decaf_PrintInt          
          lw    $t1, -8($fp)            
          lw    $t0, -12($fp)           
          la    $t2, _STRING4           
          sw    $t2, 4($sp)             
          sw    $t1, -8($fp)            
          sw    $t0, -12($fp)           
          jal   decaf_PrintString       
          lw    $t1, -8($fp)            
          lw    $t0, -12($fp)           
          sw    $t1, -8($fp)            
          sw    $t0, -12($fp)           
_L24:                                   
          li    $t0, 1                  
          lw    $t1, -12($fp)           
          addu  $t2, $t1, $t0           
          move  $t1, $t2                
          sw    $t1, -12($fp)           
          b     _L25                    
_L27:                                   
          move $v0, $zero               
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     




          .data                         
_STRING1:
          .asciiz "Main"                
_STRING0:
          .asciiz "Fib"                 
_STRING2:
          .asciiz "fib("                
_STRING4:
          .asciiz "\n"                  
_STRING3:
          .asciiz ") == "               
