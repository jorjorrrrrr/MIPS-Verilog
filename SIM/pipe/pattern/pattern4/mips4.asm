####################################################
# Pattern 4 : If-else (Bne, Beq)
# 
# if ($t1 <= $t2) $t4 = $t1 + $t2;
# else $t4 = $t1 - $t2;
# 
# if ($t4 != $t3){ print(try_again); end; }
# else {next_pattern}
#
#################################################

.data
    pass_msg:    	.asciiz " pass\n"
    fail_msg:     	.asciiz " fail\n"
    allpass_msg:   	.asciiz "        ____________________\n       |                    |\n       |     ALL  PASS!      |\n       |____________________|\n            \\  ||  /\n             \\ || /\n              \\||/\n         /\\_/\\  ||\n        ( o.o ) ||\n        (> ^ <)//\n"
    tryagain_msg:  	.asciiz "        ____________________\n       |                    |\n       |     TRY  AGAIN!     |\n       |____________________|\n            \\  ||  /\n             \\ || /\n              \\||/\n         /\\_/\\  ||\n        ( o.o ) ||\n        (> ^ <)//\n"  
	pattern1:       .word 0x39f8ff90, 0x3d8ebea5, 0x7787be35
	pattern2:       .word 0x288a6a5a, 0x39e35f27, 0x626dc981
	pattern3:       .word 0x379bbeb7, 0x22cede35, 0x14cce082
	pattern4:       .word 0x31ade5f6, 0x350124f2, 0x66af0ae8
	pattern5:       .word 0x24101ea5, 0x201be99b, 0x3f4350a
	pattern6:       .word 0x30af6f05, 0x30bd5730, 0x616cc635
	pattern7:       .word 0x20044b87, 0x29ba6ce1, 0x49beb868
	pattern8:       .word 0x3f49c0c1, 0x2414964b, 0x1b352a76
	pattern9:       .word 0x3ba5fa46, 0x36309a49, 0x5755ffd
	pattern10:      .word 0x248d87b6, 0x36e9b7fe, 0x5b773fb4
    
.text
.globl main
.globl if_func

main:
	# pattern 1
	la, $t0, pattern1
	lw, $a0, 0($t0)	# a
	lw, $a1, 4($t0)	# b
	lw, $a2, 8($t0)	# answer
	jal if_func
	
	# pattern 2
	la, $t0, pattern2
	lw, $a0, 0($t0)	# a
	lw, $a1, 4($t0)	# b
	lw, $a2, 8($t0)	# answer
	jal if_func
	
	# pattern 3
	la, $t0, pattern3
	lw, $a0, 0($t0)	# a
	lw, $a1, 4($t0)	# b
	lw, $a2, 8($t0)	# answer
	jal if_func
	
	# pattern 4
	la, $t0, pattern4
	lw, $a0, 0($t0)	# a
	lw, $a1, 4($t0)	# b
	lw, $a2, 8($t0)	# answer
	jal if_func
	
	# pattern 5
	la, $t0, pattern5
	lw, $a0, 0($t0)	# a
	lw, $a1, 4($t0)	# b
	lw, $a2, 8($t0)	# answer
	jal if_func
	
	# pattern 6
	la, $t0, pattern6
	lw, $a0, 0($t0)	# a
	lw, $a1, 4($t0)	# b
	lw, $a2, 8($t0)	# answer
	jal if_func
	
	# pattern 7
	la, $t0, pattern7
	lw, $a0, 0($t0)	# a
	lw, $a1, 4($t0)	# b
	lw, $a2, 8($t0)	# answer
	jal if_func
	
	# pattern 8
	la, $t0, pattern8
	lw, $a0, 0($t0)	# a
	lw, $a1, 4($t0)	# b
	lw, $a2, 8($t0)	# answer
	jal if_func
	
	# pattern 9
	la, $t0, pattern9
	lw, $a0, 0($t0)	# a
	lw, $a1, 4($t0)	# b
	lw, $a2, 8($t0)	# answer
	jal if_func
	
	# pattern 10
	la, $t0, pattern10
	lw, $a0, 0($t0)	# a
	lw, $a1, 4($t0)	# b
	lw, $a2, 8($t0)	# answer
	jal if_func
	
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

########################################################################
if_func:
    # if ($a0 <= $a1)
    slt  $t1, $a1, $a0   # $t1 = 1 if $a1 < $a0 (meaning $a0 > $a1)
    bne  $t1, $zero, else  # if $a0 > $a1，jump to else branch

if_body:
    add  $t2, $a0, $a1   # $t2 = $a0 + $a1
    j    check_condition

else:
    sub  $t2, $a0, $a1   # $t2 = $a0 - $a1

check_condition:
    # if ($t2 != $a3) jump to try_again
    bne  $t2, $a2, try_again  
    jr $ra
########################################################################