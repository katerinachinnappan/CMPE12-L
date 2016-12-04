/*Katerina Chinnappan
 kachinna
 Lab 6
 MIPS: String->Decimal->Binary*/
    
#include <WProgram.h>

#include <xc.h>
/* define all global symbols here */
.global main
.global read
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

    
    
    LA $a0,WelcomeMessage
    JAL puts
    NOP
    
    
    
    /* your code goes underneath this */
    start:
    and $t9, $t9, 0 /*int = 0*/
    and $t2, $t2, 0 /*flag = 0*/
    nop
    
    input:
    la $a0, inNumericString /*load the string into $a0*/
    li $t9, 0 /*product*/
    
    read:
    lb $t0, ($a0)

    nop
    
    read_input:
    beq $t0, $zero, flag /*if char == \0*/
    nop
    beq $t0, 45, flag_go_back_input /*if char == '-' go to this procedure*/
    nop
    li $t4, -48 /*load -48*/
    add $t0, $t0, $t4/*subtract 48*/
    mul $t9, $t9, 10/*multiply by 10*/
    add $t9, $t9, $t0/*int = int * 10 + digit*/
    addiu $a0, $a0, 1/*increment a0*/
    lb $t0, ($a0) /*load the next char in a0*/
    b read_input/*repead process (unconditional)*/
    nop
    
    flag_go_back_input:
    add $t2, $t2, 1/*flag == 1*/
    addiu $a0, $a0, 1/*increment a0*/
    lb $t0, ($a0)/*load next char from a0*/
    b read_input/*repeat process (unconditional)*/
    nop
    
    flag:
    sub $t2, $t2, 1 /*flag == 1 (negative)*/
    beqz $t2, twos_complement /*if flag == 1, invert */
    nop
    la $a1, outBinaryString /*load the output string into a1*/
    b binary /*jump to binary */
    nop
    
    twos_complement:
    nor $t9, $t9, $zero /*invert */
    add $t9, $t9, 1 /*add 1*/
    
    
    li $t7, 0 /*counter starts at 0*/
    la $a1, outBinaryString /*load output binary string*/
    
    binary:
    beq $t7, 32, finish /*if counter == 32, done, end program*/
    nop
    la $t8, 0b10000000000000000000000000000000 /*load the mask */
    srl $t8, $t8, $t7 /*shift to the right using counter*/
    and $t0, $t9, $t8 /*digit = int AND mask*/
    beq $t0, 0, print_zero /*if digit == 0, print 0*/
    nop
    b print_one /*if digit == 1, print 1*/
    
    
    print_zero:
    li $t6, 48 /*load ascii of 0*/
    sb $t6, ($a1)/*store lsb of t6 into a1(output string)*/
    addi $a1, $a1, 1 /*increment output string*/
    addi $t7, $t7, 1 /*increment counter*/
    b binary /*go back to binary*/
    nop
    
    print_one:
    li $t5, 49/*load ascii of 1*/
    sb $t5, ($a1)/*store lsc of t5 into a1(output string)*/
    addi $a1, $a1, 1/*incrment output string*/
    addi $t7, $t7, 1/*increment counter*/
    b binary/*go back to binary*/
    nop
    
    finish:
    nop/* doneeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee*/
 
    /* your code goes above this */

    LA $a0,DecimalMessage
    JAL puts
    NOP
    LA $a0,inNumericString
    JAL puts
    NOP
    LA $a0,BinaryMessage
    JAL puts
    NOP
    LA $a0,outBinaryString
    JAL puts
    NOP
    
    

endProgram:
    J endProgram
    NOP
.end main




.data
WelcomeMessage: .asciiz "Welcome to the converter \n"
DecimalMessage: .asciiz "The decimal number is: "
BinaryMessage: .asciiz "The binary number is: "
    
inNumericString: .asciiz "15" 
outBinaryString: .asciiz "zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz"