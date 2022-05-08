.data
str1:       .string "GCD value of "

str2:       .string " and "

str3:       .string " is "

argument1:       .word 4

argument2:       .word 8

endl:       .string "\n"

.text
main:
        lw      a1,argument2
        lw      a0,argument1 
        jal     ra, gcd 
        
        lw      a1,argument1
        lw      a2,argument2
        jal     ra, printResult 

        li      a0, 10
        ecall

gcd:
        addi    sp,sp,-48
        sw      ra,44(sp)
        sw      s0,40(sp)
        addi    s0,sp,48
        sw      a0,-36(s0)
        sw      a1,-40(s0)
        lw      a5,-40(s0)
        bnez    a5,L4 
        lw      a5,-36(s0)
        jal     ra,L5 

L4:
        lw      a4,-36(s0)
        lw      a5,-40(s0)
        rem     a5,a4,a5
        mv      a1, a5
        lw      a0,-40(s0)
        jal     ra, gcd
        mv      a5,a0

L5:
        mv      a0,a5
        lw      ra,44(sp)
        lw      s0,40(sp)
        addi    sp,sp,48
        ret

# expects:
# a0: Value which factorial number was computed from
# a1: Factorial result
printResult:
        mv       t0, a0
        mv       t1, a1
        mv       t2, a2

        la       a1, str1
        li       a0, 4
        ecall

        mv       a1, t1
        li       a0, 1
        ecall

        la       a1, str2
        li       a0, 4
        ecall

        mv       a1, t2
        li       a0, 1
        ecall

        la       a1, str3
        li       a0, 4
        ecall

        mv       a1, t0
        li       a0, 1
        ecall
        ret