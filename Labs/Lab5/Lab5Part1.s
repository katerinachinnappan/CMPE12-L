/*Katerina Chinnappan
kachinna
Lab5
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
    
    /* your code goes underneath this */
    LA $a0,HelloWorld
    JAL puts
    NOP

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
 

looping:
  
   /*1111 1111(255) : LED1-LED8
     0000 0001(1)   : LED1
     0000 1111(15)  :LED1-LED4
     1111 0000(240) :LED5-LED8
     */
 
    
   lw $t6, PORTD
   lw $t4, PORTF

   /*Switches 1-4*/ 
    /*In order to be able to turn on the switches, we have to get bits
     8, 9, 10, 11 from PORTD by shifting right by 8*/
    srl $t3, $t6, 8/*shift to the right by 8 to get to the first 4 leds*/
    andi $t5, $t3, 15/*0000 1111 (LED1-LED4)*/
    sw $t5, PORTESET/*store addrss of PORTE in the shifted reg*/
    
    /*Buttons*/
    /*Button 1, PORTF*/
    sll $t0, $t4, 0b00000011   /*shift by 3 to the left to get to the button 1 position*/
    andi $t2, $t0, 0b00010000 /*and immediate store the binary string, the 1 in the string represnets button1, LED5*/
    sw $t2, PORTE           /*store addrss of PORTE in the shifted reg*/
    
    /*Buttons 2-4*/
    andi $t8, $t6, 0b11100000  /*we don't need to shift anymore because we already got button 1*/
                              /*so we add the remaining binary string to PORTD, LED6-LED8*/      
    sw $t8, PORTESET           /*store address of PORTE in $t8*/
    
    j looping
    nop
    
hmm:    J hmm
    NOP
endProgram:
    J endProgram
    NOP
.end main



.data
HelloWorld: .asciiz "Uno32 connection succefful!!\n"
input:      .word   0xFF