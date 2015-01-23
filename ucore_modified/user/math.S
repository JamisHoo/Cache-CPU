          .text                         
          .globl main                   

          .data                         
          .align 2                      
_Math:                                  # virtual table
          .word 0                       # parent
          .word _STRING0                # class name

          .data                         
          .align 2                      
_Main:                                  # virtual table
          .word 0                       # parent
          .word _STRING1                # class name



          .text                         
_Math_New:                              # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -16           
_L30:                                   
          li    $t0, 4                  
          sw    $t0, 4($sp)             
          jal   decaf_Alloc             
          move  $t0, $v0                
          la    $t1, _Math              
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
_L31:                                   
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

_Math.abs:                              # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -12           
_L32:                                   
          li    $t0, 0                  
          lw    $t1, 4($fp)             
          sge   $t2, $t1, $t0           
          sw    $t1, 4($fp)             
          beqz  $t2, _L34               
_L33:                                   
          lw    $t0, 4($fp)             
          move  $v0, $t0                
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
_L34:                                   
          lw    $t0, 4($fp)             
          negu  $t1, $t0                
          sw    $t0, 4($fp)             
          move  $v0, $t1                
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     

_Math.pow:                              # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -20           
_L36:                                   
          li    $t0, 1                  
          move  $t1, $t0                
          li    $t0, 0                  
          move  $t2, $t0                
          sw    $t2, -8($fp)            
          sw    $t1, -12($fp)           
_L38:                                   
          lw    $t0, -8($fp)            
          lw    $t1, 8($fp)             
          slt   $t2, $t0, $t1           
          sw    $t0, -8($fp)            
          sw    $t1, 8($fp)             
          beqz  $t2, _L40               
_L39:                                   
          lw    $t0, 4($fp)             
          lw    $t2, -12($fp)           
          mult  $t2, $t0                
          mflo  $t1                     
          move  $t2, $t1                
          sw    $t0, 4($fp)             
          sw    $t2, -12($fp)           
_L37:                                   
          li    $t0, 1                  
          lw    $t1, -8($fp)            
          addu  $t2, $t1, $t0           
          move  $t1, $t2                
          sw    $t1, -8($fp)            
          b     _L38                    
_L40:                                   
          lw    $t0, -12($fp)           
          move  $v0, $t0                
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     

_Math.log:                              # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -24           
_L41:                                   
          li    $t0, 1                  
          lw    $t1, 4($fp)             
          slt   $t2, $t1, $t0           
          sw    $t1, 4($fp)             
          beqz  $t2, _L43               
_L42:                                   
          li    $t0, 1                  
          negu  $t1, $t0                
          move  $v0, $t1                
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
_L43:                                   
          li    $t0, 0                  
          move  $t1, $t0                
          sw    $t1, -8($fp)            
_L44:                                   
          li    $t0, 1                  
          lw    $t1, 4($fp)             
          sgt   $t2, $t1, $t0           
          sw    $t1, 4($fp)             
          beqz  $t2, _L46               
_L45:                                   
          li    $t0, 1                  
          lw    $t1, -8($fp)            
          addu  $t2, $t1, $t0           
          move  $t1, $t2                
          li    $t0, 2                  
          lw    $t2, 4($fp)             
          sw    $t2, 4($sp)             
          sw    $t0, 8($sp)             
          sw    $t1, -8($fp)            
          jal   decaf_Div               
          move  $t0, $v0                
          lw    $t1, -8($fp)            
          move  $t2, $t0                
          sw    $t2, 4($fp)             
          sw    $t1, -8($fp)            
          b     _L44                    
_L46:                                   
          lw    $t0, -8($fp)            
          move  $v0, $t0                
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     

_Math.max:                              # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -12           
_L47:                                   
          lw    $t0, 4($fp)             
          lw    $t1, 8($fp)             
          sgt   $t2, $t0, $t1           
          sw    $t0, 4($fp)             
          sw    $t1, 8($fp)             
          beqz  $t2, _L49               
_L48:                                   
          lw    $t0, 4($fp)             
          move  $v0, $t0                
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
_L49:                                   
          lw    $t0, 8($fp)             
          move  $v0, $t0                
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     

_Math.min:                              # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -12           
_L51:                                   
          lw    $t0, 4($fp)             
          lw    $t1, 8($fp)             
          slt   $t2, $t0, $t1           
          sw    $t0, 4($fp)             
          sw    $t1, 8($fp)             
          beqz  $t2, _L53               
_L52:                                   
          lw    $t0, 4($fp)             
          move  $v0, $t0                
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
_L53:                                   
          lw    $t0, 8($fp)             
          move  $v0, $t0                
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     

main:                                   # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -20           
_L55:                                   
          li    $t0, 1                  
          negu  $t1, $t0                
          sw    $t1, 4($sp)             
          jal   _Math.abs               
          move  $t0, $v0                
          sw    $t0, 4($sp)             
          jal   decaf_PrintInt          
          la    $t0, _STRING2           
          sw    $t0, 4($sp)             
          jal   decaf_PrintString       
          li    $t0, 2                  
          li    $t1, 3                  
          sw    $t0, 4($sp)             
          sw    $t1, 8($sp)             
          jal   _Math.pow               
          move  $t0, $v0                
          sw    $t0, 4($sp)             
          jal   decaf_PrintInt          
          la    $t0, _STRING2           
          sw    $t0, 4($sp)             
          jal   decaf_PrintString       
          li    $t0, 16                 
          sw    $t0, 4($sp)             
          jal   _Math.log               
          move  $t0, $v0                
          sw    $t0, 4($sp)             
          jal   decaf_PrintInt          
          la    $t0, _STRING2           
          sw    $t0, 4($sp)             
          jal   decaf_PrintString       
          li    $t0, 1                  
          li    $t1, 2                  
          sw    $t0, 4($sp)             
          sw    $t1, 8($sp)             
          jal   _Math.max               
          move  $t0, $v0                
          sw    $t0, 4($sp)             
          jal   decaf_PrintInt          
          la    $t0, _STRING2           
          sw    $t0, 4($sp)             
          jal   decaf_PrintString       
          li    $t0, 1                  
          li    $t1, 2                  
          sw    $t0, 4($sp)             
          sw    $t1, 8($sp)             
          jal   _Math.min               
          move  $t0, $v0                
          sw    $t0, 4($sp)             
          jal   decaf_PrintInt          
          la    $t0, _STRING2           
          sw    $t0, 4($sp)             
          jal   decaf_PrintString       
          move $v0, $zero               
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     




          .data                         
_STRING1:
          .asciiz "Main"                
_STRING0:
          .asciiz "Math"                
_STRING2:
          .asciiz "\n"                  
