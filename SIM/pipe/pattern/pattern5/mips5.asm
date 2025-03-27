####################################################
# Pattern 5 : For-Loop
# 
# sum = 0;
# for (i = 1, i != n, i=i+1) {
#	sum += i;
# }
# 
# if (sum != ans){ print(try_again); end; }
# else {next_pattern}
#
#################################################

.data
    pass_msg:    	.asciiz " pass\n"
    fail_msg:     	.asciiz " fail\n"
    allpass_msg:   	.asciiz "        ____________________\n       |                    |\n       |     ALL  PASS!      |\n       |____________________|\n            \\  ||  /\n             \\ || /\n              \\||/\n         /\\_/\\  ||\n        ( o.o ) ||\n        (> ^ <)//\n"
    tryagain_msg:  	.asciiz "        ____________________\n       |                    |\n       |     TRY  AGAIN!     |\n       |____________________|\n            \\  ||  /\n             \\ || /\n              \\||/\n         /\\_/\\  ||\n        ( o.o ) ||\n        (> ^ <)//\n"  
	test1_msg:		.asciiz "test1 pass!\n"
	test2_msg:		.asciiz "test2 pass!\n"
	test3_msg:		.asciiz "test3 pass!\n"
	test4_msg:		.asciiz "test4 pass!\n"
	test5_msg:		.asciiz "test5 pass!\n"
	test6_msg:		.asciiz "test6 pass!\n"
	test7_msg:		.asciiz "test7 pass!\n"
	test8_msg:		.asciiz "test8 pass!\n"
	test9_msg:		.asciiz "test9 pass!\n"
	test10_msg:		.asciiz "test10 pass!\n"	
	pattern1:       .word 0x00001035, 0x00835d97
	pattern2:       .word 0x0000669a, 0x148fbd9f
	pattern3:       .word 0x000000e9, 0x00006a7d
	pattern4:       .word 0x00006181, 0x1291b241
	pattern5:       .word 0x00002211, 0x02445399
	pattern6:       .word 0x000027f6, 0x031e842d
	pattern7:       .word 0x00006587, 0x1422195c
	pattern8:       .word 0x00004481, 0x092a86c1
	pattern9:       .word 0x00006402, 0x1388fa03
	pattern10:      .word 0x00003770, 0x0600c438
    
.text
.globl main
.globl forloop_func

main:
	# pattern 1
	la, $t0, pattern1
	lw, $a0, 0($t0)	# n
	lw, $a1, 4($t0)	# sum
	la, $a2, test1_msg
	jal forloop_func
	jal verify
	
	# pattern 2
	la, $t0, pattern2
	lw, $a0, 0($t0)	# n
	lw, $a1, 4($t0)	# sum
	la, $a2, test2_msg
	jal forloop_func
	jal verify
	
	# pattern 3
	la, $t0, pattern3
	lw, $a0, 0($t0)	# n
	lw, $a1, 4($t0)	# sum
	la, $a2, test3_msg
	jal forloop_func
	jal verify
	
	# pattern 4
	la, $t0, pattern4
	lw, $a0, 0($t0)	# n
	lw, $a1, 4($t0)	# sum
	la, $a2, test4_msg
	jal forloop_func
	jal verify
	
	# pattern 5
	la, $t0, pattern5
	lw, $a0, 0($t0)	# n
	lw, $a1, 4($t0)	# sum
	la, $a2, test5_msg
	jal forloop_func
	jal verify
	
	# pattern 6
	la, $t0, pattern6
	lw, $a0, 0($t0)	# n
	lw, $a1, 4($t0)	# sum
	la, $a2, test6_msg
	jal forloop_func
	jal verify
	
	# pattern 7
	la, $t0, pattern7
	lw, $a0, 0($t0)	# n
	lw, $a1, 4($t0)	# sum
	la, $a2, test7_msg
	jal forloop_func
	jal verify
	
	# pattern 8
	la, $t0, pattern8
	lw, $a0, 0($t0)	# n
	lw, $a1, 4($t0)	# sum
	la, $a2, test8_msg
	jal forloop_func
	jal verify
	
	# pattern 9
	la, $t0, pattern9
	lw, $a0, 0($t0)	# n
	lw, $a1, 4($t0)	# sum
	la, $a2, test9_msg
	jal forloop_func
	jal verify
	
	# pattern 10
	la, $t0, pattern10
	lw, $a0, 0($t0)	# n
	lw, $a1, 4($t0)	# sum
	la, $a2, test10_msg
	jal forloop_func
	jal verify

	j all_pass	

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

verify:
    # if ($v0 != $a1) jump to try_again
    bne  $v0, $a1, try_again  
	addi $sp, $sp, -4  	# Allocate stack space
    sw   $ra, 0($sp)   	# store $ra
    add  $a0, $a2, $zero
	jal  print_str
	lw   $ra, 0($sp)   	# load $ra
	addi $sp, $sp, 4  	# pop an item from stack
    jr $ra			

########################################################################
forloop_func:
    li   $t1, 0   # sum = 0
    li   $t2, 1   # i = 1

for_loop:
    add  $t1, $t1, $t2 		# sum += i
    beq  $t2, $a0, return  	# if i == n, jump to verify
    addi $t2, $t2, 1   		# i++
    j	 for_loop

return:
	add  $v0, $t1, $zero	# store result to $v0
	jr	 $ra
    
########################################################################
