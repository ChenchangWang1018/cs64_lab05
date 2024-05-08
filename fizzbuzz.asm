# print_array.asm program
# Don't forget to:
#   make all arguments to any function go in $a0 and/or $a1
#   make all returned values from functions go in $v0

.data
# Data Area.  
# Note that while this is typically only for global immutable data, 
# for SPIM, this also includes mutable data.
# DO NOT MODIFY THIS SECTION
input: 
    .word 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
length:
    .word 15
fizz:   .asciiz "Fizz "
buzz:   .asciiz "Buzz "
fizzbuzz:   .asciiz "FizzBuzz "
space:  .asciiz " "
ack:    .asciiz "\n"


.text
FizzBuzz:
    move $t0 $a0    #arr
    move $t1 $a1    #length

    li $t2 0        #iterater i
    
    loop:
        bge $t2 $t1 return  #exitloop
        sll $t3 $t2 2       #calculate offset
        add $t3 $t3 $t0     #get address of a[i]
        lw $t4 0($t3)       #get value of a[i]

        li $t5 15
        div $t4 $t5
        mfhi $t5
        beq $t5 $zero print_fizzbuzz

        li $t5 5
        div $t4 $t5
        mfhi $t5
        beq $t5 $zero print_buzz

        li $t5 3
        div $t4 $t5
        mfhi $t5
        beq $t5 $zero print_fizz
        
        move $a0 $t4
        li $v0 1
        syscall

        la $a0 space
        li $v0 4
        syscall

        addi $t2 $t2 1
        j loop
    
    j return

    print_fizzbuzz:
        la $a0 fizzbuzz
        li $v0 4
        syscall
        addi $t2 $t2 1
        j loop

    print_buzz:
        la $a0 buzz
        li $v0 4
        syscall
        addi $t2 $t2 1
        j loop

    print_fizz:
        la $a0 fizz
        li $v0 4
        syscall
        addi $t2 $t2 1
        j loop

    return:
        jr $ra


main:
    #DO NOT MODIFY THIS
    la $a0 input
    lw $a1 length
    jal FizzBuzz
    j exit

exit:
    la $a0 ack
    li $v0 4
    syscall
	li $v0 10 
	syscall