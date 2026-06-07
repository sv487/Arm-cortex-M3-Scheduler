# systick configuration registers
.equ systick_csr, 0xE000E010
.equ systick_rvr, 0xE000E014
.equ systick_cvr , 0xE000E018
.equ systick_calib , 0xE000E01C    // equ is used to define values in assebmly like #define in c
.equ timeout , 0x00ffffff    // 24 bits set to 1

.section .vectors
vector_table:
    .word  0x20000800     // stack pointer
    .word reset_handler +1   // program counter
    .word 0
    .word hardfault_handler +1 
    .org 0x3c          // address of systick hey now go to this address
    .word systick_handler +1    
    .zero 400

    .section .text
    .align 1
    .type reset_handler, %function  // says treat reset_handler like a function


reset_handler:      // program the systick timer
    mov r5 , #0
    ldr r0, = systick_csr
    ldr r1,= systick_rvr
    ldr r2, = systick_cvr
    ldr r3, = timeout

    str r3,[r1]    // take the value of r3 and write whatever r1 is holding which is the value of timeout

    mov r3, #0x0    // clearing the value of r3 register
    str r3, [r2]

    mov r3, #0x7   // writing all ones
    str r3, [r0]

    mov r5 , #0

   b .


.section .text
.type hardfault_handler , %function
hardfault_handler:
    b .

  .section .text
  .align 1
  .type systick_handler , %function
systick_handler:
    push {r4-r7}

    mov r0, r8
    mov r1, r9
    mov r2, r10
    mov r3, r11

    push {r0-r3}

    add r5,r5, #1   // increment r5 by 1
magic:                 // now we are going to change the stackp pointer so the pop operation will be done from another stack

    pop {r0-r3}

    mov r8,r0
    mov r9,r1
    mov r10,r2
    mov r11,r3

    pop {r4-r7}

    bx lr

# tasks

   .section .text
   .p2align 4
   .globl main1
   .type main1, %function

main1 :
    nop
    add r0,r0,#1;
    b main1

   .section .text
   .p2align 4
   .globl main2
   .type main2, %function

main2 :
   nop
   add r1,r1,#2;
   b main2

   .section .text
   .p2align 4
   .globl main3
   .type main3, %function

main3:
   nop
   add r2,r2,#3;
   b main3

  .data
.align 4
stack_1:
    .word 0x14      @ R8
    .word 0x15      @ R9
    .word 0x16      @ R10
    .word 0x17      @ R11
    .word 0x18      @ R4
    .word 0x19      @ R5
    .word 0x1a      @ R6
    .word 0x1b      @ R7
@ ---- hardware frame below ----
    .word 0x10      @ R0
    .word 0x11      @ R1
    .word 0x12      @ R2
    .word 0x13      @ R3
    .word 0x1c      @ R12
    .word 0xFFFFFFF9     @ LR
    .word main1 + 1    @ PC
    .word 0x01000000 @ xPSR
    .zero 64

.align 4
stack_2:
    .word 0x24      @ R8
    .word 0x25      @ R9
    .word 0x26      @ R10
    .word 0x27      @ R11
    .word 0x28      @ R4
    .word 0x29      @ R5
    .word 0x2a      @ R6
    .word 0x2b      @ R7
    .word 0x20      @ R0
    .word 0x21      @ R1
    .word 0x22      @ R2
    .word 0x23      @ R3
    .word 0x2c      @ R12
    .word 0xFFFFFFF9     @ LR
    .word main2 + 1    @ PC
    .word 0x01000000 @ xPSR
    .zero 64

.align 4
stack_3:
    .word 0x34      @ R8
    .word 0x35      @ R9
    .word 0x36      @ R10
    .word 0x37      @ R11
    .word 0x38      @ R4
    .word 0x39      @ R5
    .word 0x3a      @ R6
    .word 0x3b      @ R7
    .word 0x30      @ R0
    .word 0x31      @ R1
    .word 0x32      @ R2
    .word 0x33      @ R3
    .word 0x3c      @ R12
    .word 0xFFFFFFF9     @ LR
    .word main3 + 1    @ PC
    .word 0x01000000 @ xPSR
    .zero 64
