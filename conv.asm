# print_array.asm program
# Don't forget to:
#   make all arguments to any function go in $a0 and/or $a1
#   make all returned values from functions go in $v0

.data
# Data Area.  
# Note that while this is typically only for global immutable data, 
# for SPIM, this also includes mutable data.
input: 
	.word -72 13 -68 27 94 -49 8 37
filter: 
	.word -63 27 44
output: 
	.word 0 0 0 0 0 0
output_length:
	.word 6
ack: .asciiz "\n"
space: .asciiz " "
prompt: .asciiz "print_array"
i_j: .asciiz "i+j="


.text
conv:
	# load addresses into t0, t1, t2
    # input, filter and output respectively
	move $t0 $a0        #input
    move $t1 $a1        #filter
    move $t2 $a2        #output
    
    move $s0 $a3
    li $t3 3            #filt_size
    li $t4 0            #i
    
    outer_loop:

        li $t5 0        #j
        bge $t4 $s0 return
        inner_loop:

            bge $t5 $t3 after_inner
            add $t6 $t5 $t4         #i+j

            sll $t6 $t6 2           #offset of i+j
            add $t6 $t6 $t0         #address of inp[i+j]    
            lw $t7 0($t6)           #inp[i+j]


            sll $t6 $t5 2           #offset of j
            add $t6 $t6 $t1         #address of filt[j]
            lw $t8 0($t6)           #filt[j]

            mul $t7 $t7 $t8         #filt[j]*inp[i+j]

            sll $t6 $t4 2           #offset of i
            add $t6 $t6 $t2         #address of result[i]
            lw $t8 0($t6)           #result[i]
            add $t8 $t8 $t7         #result[i]+inp[i+j]*filt[j]
            sw $t8 0($t6)           #store result[i]
            addi $t5 $t5 1          #increment j
            j inner_loop

        after_inner:
        addi $t4 $t4 1
        j outer_loop

    return:
        jr $ra


main:
    la $a0 input
    la $a1 filter
    la $a2 output
    #Result length
    lw $a3 output_length
    jal conv

    #Loop for printing result
    la $t0 output
    lw $t3 output_length
    sll $t3 $t3 2
    li $t1 0


    print_loop:
        add $t2 $t0 $t1
        lw $a0 0($t2)
        li $v0 1
        syscall
        la $a0 space
        li $v0 4
        syscall
        add $t1 4
        bne $t1 $t3 print_loop
    j exit

exit:
    la $a0 ack
    li $v0 4
    syscall
	li $v0 10 
	syscall

