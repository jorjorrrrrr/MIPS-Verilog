####################################################
# Pattern 7 : Recursive (Fabonacci)
# 
# int fabonacci (int n) {
# 	if (n == 0) 		return 0;
# 	else if (n == 1) 	return 1;
#	else				return fabonacci(n-2) + fabonacci(n-1);
# }

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
	pattern1:       .word 0x0000000e, 0x00000179
	pattern2:       .word 0x0000000f, 0x00000262
	pattern3:       .word 0x00000010, 0x000003db
	pattern4:       .word 0x00000011, 0x0000063d
	pattern5:       .word 0x00000012, 0x00000a18
	pattern6:       .word 0x00000013, 0x00001055
	pattern7:       .word 0x00000014, 0x00001a6d
	pattern8:       .word 0x00000015, 0x00002ac2
	pattern9:       .word 0x00000016, 0x0000452f
	pattern10:      .word 0x00000017, 0x00006ff1

.text
.globl main
.globl fibonacci_func

main:
	# pattern 1
	la, $t0, pattern1
	lw, $a0, 0($t0)	# n
	lw, $a1, 4($t0)	# sum
	la, $a2, test1_msg
	jal fibonacci_func
	jal verify
	
	# pattern 2
	la, $t0, pattern2
	lw, $a0, 0($t0)	# n
	lw, $a1, 4($t0)	# sum
	la, $a2, test2_msg
	jal fibonacci_func
	jal verify
	
	# pattern 3
	la, $t0, pattern3
	lw, $a0, 0($t0)	# n
	lw, $a1, 4($t0)	# sum
	la, $a2, test3_msg
	jal fibonacci_func
	jal verify
	
	# pattern 4
	la, $t0, pattern4
	lw, $a0, 0($t0)	# n
	lw, $a1, 4($t0)	# sum
	la, $a2, test4_msg
	jal fibonacci_func
	jal verify
	
	# pattern 5
	la, $t0, pattern5
	lw, $a0, 0($t0)	# n
	lw, $a1, 4($t0)	# sum
	la, $a2, test5_msg
	jal fibonacci_func
	jal verify
	
	# pattern 6
	la, $t0, pattern6
	lw, $a0, 0($t0)	# n
	lw, $a1, 4($t0)	# sum
	la, $a2, test6_msg
	jal fibonacci_func
	jal verify
	
	# pattern 7
	la, $t0, pattern7
	lw, $a0, 0($t0)	# n
	lw, $a1, 4($t0)	# sum
	la, $a2, test7_msg
	jal fibonacci_func
	jal verify
	
	# pattern 8
	la, $t0, pattern8
	lw, $a0, 0($t0)	# n
	lw, $a1, 4($t0)	# sum
	la, $a2, test8_msg
	jal fibonacci_func
	jal verify
	
	# pattern 9
	la, $t0, pattern9
	lw, $a0, 0($t0)	# n
	lw, $a1, 4($t0)	# sum
	la, $a2, test9_msg
	jal fibonacci_func
	jal verify
	
	# pattern 10
	la, $t0, pattern10
	lw, $a0, 0($t0)	# n
	lw, $a1, 4($t0)	# sum
	la, $a2, test10_msg
	jal fibonacci_func
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
fibonacci_func:
	addi $sp, $sp, -4  	# Allocate stack space
    sw   $ra, 0($sp)   	# store $ra
    jal  fibonacci     	# call Fibonacci(n)
    move $a0, $v0      	# store Fibonacci(n) to $t0
	lw   $ra, 0($sp)   	# load $ra
	addi $sp, $sp, 4  	# pop an item from stack
	jr   $ra

# Function fibonacci(n)
# argument: $a0 (n)
# return: 	$v0 (fibonacci(n))
fibonacci:
    addi $sp, $sp, -12	# adjust stack for 3 items
    sw   $ra, 8($sp)   	# save return address
    sw   $a0, 4($sp)   	# save argument
	#sw   ?, 0($sp)   	# reserved
	
	slti $t0, $a0, 2	# test for n < 2
	beq	 $t0, $zero, L1

	# consider n == 0 or n == 1
	bne	 $a0, $zero, return_one # if n == 1, then return one
return_zero:
	addi $v0, $zero, 0	# set $v0 to 0
	j	 return

return_one:
	addi $v0, $zero, 1	# set $v0 to 1

return:
	addi $sp, $sp, 12	# pop 3 item from stack
	jr 	 $ra			# and return

L1:
	addi $a0, $a0, -1	# n - 1
	jal fibonacci		# recursive call
	sw   $v0, 0($sp) 	# store fibonacci(n-1) result to 0($sp)

    lw   $a0, 4($sp)   	# restore n
	addi $a0, $a0, -2	# n - 2
	jal fibonacci		# recursive call

	# calculate result
	lw   $t1, 0($sp)   	# load fibonacci(n-1) result
	add $v0, $t1, $v0 	# return fibonacci(n-1) + fibonacci(n-2)

	lw   $ra, 8($sp)   	# load return address
	addi $sp, $sp, 12	# pop 2 items from stack
	jr	 $ra
 
########################################################################1
