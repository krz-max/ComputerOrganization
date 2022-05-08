.data
endl: .string "\n"
spc: .string " "
str1: .string "Array: "
str2: .string "Sorted: "
Size: .word 10
arr:
    .word 5
    .word 3
    .word 6
    .word 7
    .word 31
    .word 23
    .word 43
    .word 12
    .word 45
    .word 1

.text
main:
    # printf("%s\n",str1);
    la a1, str1
    li a0, 4
    ecall
    
    la a1, endl
    li a0, 4
    ecall

    # initialize array
    jal ra, printArray

    # sort array
    jal ra, sortArray
    
    la a1, str2
    li a0, 4
    ecall

    # initialize array
    jal ra, printArray
    
    li a0, 10
    ecall

printArray:
    la t0, arr
    lw t1, Size
    slli t2, t1, 2
    add t2, t0, t2
    
    loop_iterateArray:
        lw t3, 0(t0)
        addi a0, x0, 1
        addi a1, t3, 0
        ecall
        
        la a1, spc
        li a0, 4
        ecall
        
        addi t0, t0, 4
        bltu t0, t2, loop_iterateArray

    la a1, endl
    li a0, 4
    ecall
    ret

sortArray:
    la t0, arr
    lw s2, Size
    slli t2, s2, 2
    add t2, t0, t2

    mv s0, zero
    loop_sortArray1:
        slt t3, s0, s2
        beq t3, zero, exit1
        addi s1, s0, -1
        loop_sortArray2:
            slt t3, s1, zero
            bne t3, zero, exit2
            slli t3, s1, 2
            add t3, t0, t3
            lw t4, 0(t3)
            lw t5, 4(t3)
            slt t6, t4, t5
            bne t6, zero, exit2
            sw t5, 0(t3)
            sw t4, 4(t3)
            addi s1, s1, -1
            j loop_sortArray2
        exit2:
            addi s0, s0, 1
            j loop_sortArray1
    exit1:
    ret