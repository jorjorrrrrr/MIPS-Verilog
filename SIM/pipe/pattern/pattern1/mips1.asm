####################################################
# Pattern 1 : Arithmetic Operation (without Bne, Jump and Print Str)
# $t1 = 0x12345678
# $t2 = 0x9abcdef0
# $t3 = $t1 & $t2 = 1234 5670
# $t4 = $t1 | $t2 = 9ABC DEF8
# $t5 = $t4 - $t3 = 8888 8888
# $t6 = $t4 + $t3 = ACF1 3568
# result : $t7 = $t5 ^ $t6 = 2479 BDE0
#################################################

.data
    pass_msg:    .asciiz " pass\n"
    fail_msg:     .asciiz " fail\n"
    allpass_msg:   .asciiz "        ____________________\n       |                    |\n       |     ALL  PASS!      |\n       |____________________|\n            \\  ||  /\n             \\ || /\n              \\||/\n         /\\_/\\  ||\n        ( o.o ) ||\n        (> ^ <)//\n"
    tryagain_msg:  .asciiz "        ____________________\n       |                    |\n       |     TRY  AGAIN!     |\n       |____________________|\n            \\  ||  /\n             \\ || /\n              \\||/\n         /\\_/\\  ||\n        ( o.o ) ||\n        (> ^ <)//\n"  
    mem:         .word 0x2479BDE0, 0x12345678, 0x9abcdef0
    
    
.text
.globl main

main:
	# load answer answer
	lui $at, 0x2479
	ori $t0, $at, 0xBDE0
	
	# calculation
    lui $at, 0x1234
    ori $t1, $at, 0x5678
    lui $at, 0x9abc
    ori $t2, $at, 0xdef0
    
    and $t3, $t1, $t2
    or  $t4, $t1, $t2
    
    sub $t5, $t4, $t3
    add $t6, $t4, $t3
    
    xor $t7, $t5, $t6
    
    # compare with answer [($t0 == $t7) -> ($s0 = 0)]
    xor $s0, $t7, $t0
    
	# finish
    li $v0, 10
    syscall

#all_pass:
#	la $a0, allpass_msg
#    jal print_str
#    j end
#    
#try_again:
#	la $a0, tryagain_msg
#    jal print_str
#    
#end:
#    li $v0, 10
#    syscall
#    
#print_str:
#    li $v0, 4
#    syscall
#    jr $ra