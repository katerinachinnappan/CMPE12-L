/*Katerina Chinnappan
kachinna
Lab5
Part2
     */
#include <WProgram.h>
#include <xc.h>
/* define all global symbols here */
.global main
    

.text
.set noreorder

.ent main
main:
    /* this code blocks sets up the ability to print, do not alter it */
    ADDIU $v0,$zero,1
    LA $t0,__XC_UART
    SW $v0,0($t0)
    LA $t0,U1MODE
    LW $v0,0($t0)
    ORI $v0,$v0,0b1000
    SW $v0,0($t0)
    LA $t0,U1BRG
    ADDIU $v0,$zero,12
    SW $v0,0($t0)
    
 
    LA $a0,HelloWorld
    JAL puts
    NOP
    
/* your code goes underneath this */
/*In order to input the LED (buttons and switch) we need to set the 0-7
 registers all to 1. 255 in binary 11111111 and in hex 0xFF will do the trick.
 So I am setting TRISECLR and PORTECLR to 0xFF
*/
 lw $t8, input
 andi $t1, $t1, 0/*clear temp register $t1*/
 add $t1, $t1, $t8/*add 11111111 to $t1*/
 sw $t1, TRISECLR
 sw $t1, PORTECLR
 andi $t1, $t1, 0
 add $t1, $t1, $t8
 sw $t1, PORTESET

 /*set TRISD*/
 add $t1, $t1, $t8
 sw $t1, TRISDSET
 
 /*clear $t8 for later use*/
andi $t8, $t8, 0
 
/*speed*/        
li   $a0, 0x0800

lw $t2,PORTD
/*same as in part1, in order to be able to turn on the switches, we have to get bits
8, 9, 10, 11 from PORTD by shifting right by 8*/
srl $t2,$t2,8/*shift to the right by 8 to get to the first 4 leds*/
andi $t2, $t2, 15/*0000 1111 (LED1-LED4), sw1-sw4*/

addi $t2,$t2,1
mul $a0, $t2, $a0

/*load the values into the registers*/
lw $t3, led1
lw $t8, led8
lw $t9, led1_led8

/*SHIFIT LEFT*/
left_shift:
sw $t9, PORTECLR/*clear porte*/
sw $t3, PORTESET/*set porte*/
sll $t3,$t3,1/*shift to the left by 1*/

nop /*end of let_shift*/
/*temp register to compare later in for loop*/ 
lw $t7, zero

/*for(i = 0; i < speedDelay; i ++)*/
mydelay:
beq $a0, $t7, mydelay_end/*if a0 == t7, if equals 0, go to finish delat, else proceed, exit foor loop*/
addi $t7, $t7, 1/*otherwise, increment*/
b mydelay/*call mydelay until i = speedDelay*/
nop /*end of mydelay*/

mydelay_end:    
/*end delay*/
bne $t3,$t8,left_shift/*if t3 != t8, shifted t3 != 1000 0000, go back to left shift otherwise start right shift*/
nop/*end of mydelay_end*/

lw $t8,led1/*load 0000 0001 into t8 for comparison (global)*/

/*RIGHT SHIFT*/  
/*as soon as t3 == 1000 0000, this means that led8 is on and now shift to the right*/
right_shift:
sw $t9, PORTECLR/*clear porte*/
sw $t3, PORTESET/*set porte*/
srl $t3,$t3,1/*shift to the right by 1*/
     
nop /*end of right shift*/
/*temp register to compare later in for loop*/ 
lw $t7, zero
    
/*for(i = 0; i < speedDelay; i ++)*/
mydelay2:
beq $a0, $t7, mydelay2_end/*if a0 == t7, if equals 0, go to finish delat, else proceed, exit foor loop*/
addi $t7, $t7, 1/*otherwise, increment*/
b mydelay2/*call mydelay until i = speedDelay*/
nop /*end of mydelay2*/
    
mydelay2_end:    
/*end delay*/
bne $t3,$t8,right_shift/*if t3 != t8, shifted t3 != 0000 0001, go back to left shift otherwise start right shift*/
nop /*end of mydelay2_end*/

    
.end main
    
 .data
HelloWorld: .asciiz "Welcome! Uno32 connection succefful!!\n"
input:      .word   0xFF
led1:       .word   0b00000001
led8:       .word   0b10000000
led1_led8:  .word   0b11111111
zero:       .word   0


