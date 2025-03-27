####################################################
# Pattern 3 : Load-Store (LW)
# load $t1 from mem[4]
# load $t2 from mem[8]
# $t3 = $t1 & $t2 = 1234 5670
# $t4 = $t1 | $t2 = 9ABC DEF8
# $t5 = $t4 - $t3 = 8888 8888
# $t6 = $t4 + $t3 = ACF1 3568
# $t7 = $t5 ^ $t6 = 2479 BDE0
# store $t7 to mem[12]
# load $s1 from mem[12]
# $s0 = $s1 ^ $t0
# if ($s0 != $zero){ print(try_again); end; }
# 
# if ($s0 == $t0){ print(try_again);}
# else{ print(all_pass);}
# end;
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
	la  $t7, mem
	lw  $t0, 0($t7)
	
	# calculation
    lw  $t1, 4($t7)
    lw  $t2, 8($t7)
    
    and $t3, $t1, $t2
    or  $t4, $t1, $t2
    
    sub $t5, $t4, $t3
    add $t6, $t4, $t3
    
    xor $t7, $t5, $t6
    
    # store $t7 to mem[12]
    la  $t1, mem
	sw  $t7, 12($t1)
	# load $s1 to mem[12]
	lw  $s1, 12($t1)
    
    # compare with answer [($t0 == $s1) -> ($s0 = 0)]
    xor $s0, $s1, $t0

all_pass:
	la $a0, allpass_msg   
	jal print_str
	j end
    
try_again:
	la $a0, tryagain_msg
	jal print_str
    
end:
    li $v0, 10
    syscall
    
print_str:
    li $v0, 4
    syscall
    jr $ra