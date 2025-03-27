####################################################
# Pattern 6 : Recursive (Factorial)
# 
# int fact (int n) {
# 	if (n < 0) 	return 1;
#	else		return n * fact(n-1);
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
	pattern1:       .word 0x00000003, 0x00000006
	pattern2:       .word 0x00000004, 0x00000018
	pattern3:       .word 0x00000005, 0x00000078
	pattern4:       .word 0x00000006, 0x000002d0
	pattern5:       .word 0x00000007, 0x000013b0
	pattern6:       .word 0x00000008, 0x00009d80
	pattern7:       .word 0x00000009, 0x00058980
	pattern8:       .word 0x0000000a, 0x00375f00
	pattern9:       .word 0x0000000b, 0x02611500
	pattern10:      .word 0x0000000c, 0x1c8cfc00

.text
.globl main
.globl fact_func

main:
	# pattern 1
	la, $t0, pattern1
	lw, $a0, 0($t0)	# n
	lw, $a1, 4($t0)	# sum
	la, $a2, test1_msg
	jal fact_func
	jal verify
	
	# pattern 2
	la, $t0, pattern2
	lw, $a0, 0($t0)	# n
	lw, $a1, 4($t0)	# sum
	la, $a2, test2_msg
	jal fact_func
	jal verify
	
	# pattern 3
	la, $t0, pattern3
	lw, $a0, 0($t0)	# n
	lw, $a1, 4($t0)	# sum
	la, $a2, test3_msg
	jal fact_func
	jal verify
	
	# pattern 4
	la, $t0, pattern4
	lw, $a0, 0($t0)	# n
	lw, $a1, 4($t0)	# sum
	la, $a2, test4_msg
	jal fact_func
	jal verify
	
	# pattern 5
	la, $t0, pattern5
	lw, $a0, 0($t0)	# n
	lw, $a1, 4($t0)	# sum
	la, $a2, test5_msg
	jal fact_func
	jal verify
	
	# pattern 6
	la, $t0, pattern6
	lw, $a0, 0($t0)	# n
	lw, $a1, 4($t0)	# sum
	la, $a2, test6_msg
	jal fact_func
	jal verify
	
	# pattern 7
	la, $t0, pattern7
	lw, $a0, 0($t0)	# n
	lw, $a1, 4($t0)	# sum
	la, $a2, test7_msg
	jal fact_func
	jal verify
	
	# pattern 8
	la, $t0, pattern8
	lw, $a0, 0($t0)	# n
	lw, $a1, 4($t0)	# sum
	la, $a2, test8_msg
	jal fact_func
	jal verify
	
	# pattern 9
	la, $t0, pattern9
	lw, $a0, 0($t0)	# n
	lw, $a1, 4($t0)	# sum
	la, $a2, test9_msg
	jal fact_func
	jal verify
	
	# pattern 10
	la, $t0, pattern10
	lw, $a0, 0($t0)	# n
	lw, $a1, 4($t0)	# sum
	la, $a2, test10_msg
	jal fact_func
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
    # if ($a0 != $a1) jump to try_again
    bne  $a0, $a1, try_again  
	addi $sp, $sp, -4  	# Allocate stack space
    sw   $ra, 0($sp)   	# store $ra
    add  $a0, $a2, $zero
	jal  print_str
	lw   $ra, 0($sp)   	# load $ra
	addi $sp, $sp, 4  	# pop an item from stack
    jr $ra	

########################################################################
fact_func:
	addi $sp, $sp, -4  	# Allocate stack space
    sw   $ra, 0($sp)   	# store $ra
    jal  fact     		# call fact
    move $a0, $v0      	# store fact(n) to $t0
	lw   $ra, 0($sp)   	# load $ra
	addi $sp, $sp, 4  	# pop an item from stack
	jr   $ra

# Function fact(n)
# argument: $a0 (n)
# return: 	$v0 (fact(n))
fact:
    addi $sp, $sp, -8	# adjust stack for 2 items
    sw   $ra, 4($sp)   	# save return address
    sw   $a0, 0($sp)   	# save argument
	slti $t0, $a0, 1	# test for n < 1
	beq	 $t0, $zero, L1
	addi $v0, $zero, 1	# if so, result is 1
	addi $sp, $sp, 8	# 	pop 2 item from stack
	jr 	 $ra			# 	and return
L1:
	addi $a0, $a0, -1	# else decrement n
	jal fact			# recursive call
    lw   $ra, 4($sp)   	# load return address
    lw   $a0, 0($sp)   	# load argument
	addi $sp, $sp, 8	# pop 2 items from stack
	mult $a0, $v0		# multiply
	mflo $v0			# and get result
	jr	 $ra
 
########################################################################1
