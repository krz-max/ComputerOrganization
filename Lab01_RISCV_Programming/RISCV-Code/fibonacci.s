.data
str1:
        .string "th number in the Fibonacci sequence is "
argument:
        .word 7

.text
main:
        lw      a0,argument
        call    Fibonacci

        mv      a1, a0
        lw      a0, argument
        call    printResult

        li a0, 10
        ecall

printResult:
        mv       t0, a0
        mv       t1, a1

        mv       a1, t0
        li       a0, 1
        ecall

        la       a1, str1
        li       a0, 4
        ecall
        
        mv       a1, t1
        li       a0, 1
        ecall

        ret

Fibonacci:
        addi    sp,sp,-32
        sw      ra,28(sp)
        sw      s0,24(sp)
        sw      s1,20(sp)
        addi    s0,sp,32
        sw      a0,-20(s0)
        lw      a5,-20(s0)
        bnez    a5,.L4
        li      a5,0
        j       .L5
.L4:
        lw      a4,-20(s0)
        li      a5,1
        bne     a4,a5,.L6
        li      a5,1
        j       .L5
.L6:
        lw      a5,-20(s0)
        addi    a5,a5,-1
        mv      a0,a5
        call    Fibonacci
        mv      s1,a0
        lw      a5,-20(s0)
        addi    a5,a5,-2
        mv      a0,a5
        call    Fibonacci
        mv      a5,a0
        add     a5,s1,a5
.L5:
        mv      a0,a5
        lw      ra,28(sp)
        lw      s0,24(sp)
        lw      s1,20(sp)
        addi    sp,sp,32
        jr      ra