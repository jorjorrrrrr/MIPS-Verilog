.data
    pass_msg:    .asciiz " pass\n"
    fail_msg:     .asciiz " fail\n"
    allpass_msg:   .asciiz "        ____________________\n       |                    |\n       |     ALL  PASS!      |\n       |____________________|\n            \\  ||  /\n             \\ || /\n              \\||/\n         /\\_/\\  ||\n        ( o.o ) ||\n        (> ^ <)//\n"
    tryagain_msg:  .asciiz "        ____________________\n       |                    |\n       |     TRY  AGAIN!     |\n       |____________________|\n            \\  ||  /\n             \\ || /\n              \\||/\n         /\\_/\\  ||\n        ( o.o ) ||\n        (> ^ <)//\n"  
    test1:       .asciiz "[Test1]"
    test2:       .asciiz "[Test2]"
    test3:       .asciiz "[Test3]"
    and_str:     .asciiz "and"
    addu_str:    .asciiz "addu"
    addi_str:    .asciiz "addi"
    addiu_str:   .asciiz "addiu"
    andi_str:    .asciiz "andi"
    nor_str:     .asciiz "nor"
    or_str:      .asciiz "or"
    ori_str:     .asciiz "ori"
    sll_str:     .asciiz "sll"
    sra_str:     .asciiz "sra"
    srl_str:     .asciiz "srl"
    sub_str:     .asciiz "sub"
    subu_str:    .asciiz "subu"
    xor_str:     .asciiz "xor"
    xori_str:    .asciiz "xori"
    slt_str:     .asciiz "slt"
    sltu_str:    .asciiz "sltu"
    sltiu_str:   .asciiz "sltiu"
    beq_str:     .asciiz "beq"
    bne_str:     .asciiz "bne"
    j_str:       .asciiz "j"
    lui_str:     .asciiz "lui"
    lw_str:      .asciiz "lw"
    lb_str:      .asciiz "lb"
    lbu_str:     .asciiz "lbu"
    lh_str:      .asciiz "lh"
    lhu_str:     .asciiz "lhu"
    sw_str:      .asciiz "sw"
    sb_str:      .asciiz "sb"
    sh_str:      .asciiz "sh"
    mult_str:    .asciiz "mult"
    multu_str:   .asciiz "multu"
    div_str:     .asciiz "div"
    divu_str:    .asciiz "divu"
    mflo_str:    .asciiz "mflo"
    mfhi_str:    .asciiz "mfhi"
    mem:         .word 0x1234, 0x5678, 0x9ABC

.text
main:
    li $t0, 0
    li $t1, 0
    li $t2, 0
    li $t3, 0

    # === Test AND ===
    # Test 1: 0xF0F0 & 0x0F0F = 0x0000
    li $t1, 0xF0F0
    li $t2, 0x0F0F
    and $t0, $t1, $t2
    beq $t0, $zero, and_pass1
    la $a0, and_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
and_pass1:
    la $a0, and_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, pass_msg
    jal print_str
and_next1:
    
    # Test 2: 0xFFFF & 0xFFFF = 0xFFFF
    li $t1, 0xFFFF
    li $t2, 0xFFFF
    and $t0, $t1, $t2
    li $t3, 0xFFFF
    beq $t0, $t3, and_pass2
    la $a0, and_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
and_pass2:
    la $a0, and_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, pass_msg
    jal print_str
and_next2:
    
    # Test 3: 0xAAAA & 0x5555 = 0x0000
    li $t1, 0xAAAA
    li $t2, 0x5555
    and $t0, $t1, $t2
    beq $t0, $zero, and_pass3
    la $a0, and_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
and_pass3:
    la $a0, and_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, pass_msg 
    jal print_str
and_next3:

    # === Test ADDU ===
    # Test 0xFFFF + 1 = 0x10000
    li $t1, 0xFFFF
    li $t2, 1
    addu $t0, $t1, $t2
    li $t3, 0x10000
    beq $t0, $t3, addu_pass1
    la $a0, addu_str
    jal print_str
    la $a0, test1
    jal print_str
    la $0, fail_msg
    jal print_str
    j try_again
addu_pass1:
    la $a0, addu_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, pass_msg
    jal print_str
addu_next1:
    
    # Test 2: 0xFFFF + 1 = 0x10000
    li $t1, 0xFFFF
    li $t2, 1
    addu $t0, $t1, $t2
    li $t3, 0x10000
    beq $t0, $t3, addu_pass2
    la $a0, addu_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
addu_pass2:
    la $a0, addu_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, pass_msg
    jal print_str
addu_next2:
    
    # Test 3: 0 + 0 = 0
    li $t1, 0
    li $t2, 0
    addu $t0, $t1, $t2
    beq $t0, $zero, addu_pass3
    la $a0, addu_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
addu_pass3:
    la $a0, addu_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, pass_msg
    jal print_str
addu_next3:

    # === Test ADDI ===
    # Test 1: 5 + 3 = 8
    li $t1, 5
    addi $t0, $t1, 3
    li $t3, 8
    beq $t0, $t3, addi_pass1
    la $a0, addi_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
addi_pass1:
    la $a0, addi_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, pass_msg
    jal print_str
addi_next1:
    
    # Test 2: 0xFFFF + 1 = 0x10000
    li $t1, 0xFFFF
    addi $t0, $t1, 1
    li $t3, 0x10000
    beq $t0, $t3, addi_pass2
    la $a0, addi_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
addi_pass2:
    la $a0, addi_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, pass_msg
    jal print_str
addi_next2:
    
    # Test 3: 0 + (-1) = -1
    li $t1, 0
    addi $t0, $t1, -1
    li $t3, -1
    beq $t0, $t3, addi_pass3
    la $a0, addi_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
addi_pass3:
    la $a0, addi_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, pass_msg
    jal print_str
addi_next3:

    # === Test ADDIU ===
    # Test 1: 5 + 3

    li $t1, 5
    addiu $t0, $t1, 3
    li $t3, 8
    beq $t0, $t3, addiu_pass1
    la $a0, addiu_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
addiu_pass1:
    la $a0, addiu_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, pass_msg
    jal print_str
addiu_next1:
    
    # Test 2: 0xFFFF + 1 = 0x10000
    li $t1, 0xFFFF
    addiu $t0, $t1, 1
    li $t3, 0x10000
    beq $t0, $t3, addiu_pass2
    la $a0, addiu_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
addiu_pass2:
    la $a0, addiu_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, pass_msg
    jal print_str
addiu_next2:
    
    # Test 3: 0 + (-1) = -1
    li $t1, 0
    addiu $t0, $t1, -1
    li $t3, -1
    beq $t0, $t3, addiu_pass3
    la $a0, addiu_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
addiu_pass3:
    la $a0, addiu_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, pass_msg
    jal print_str
addiu_next3:

    # === Test ANDI ===
    # Test 1: 0xF0F0 & 0x0F0F = 0x0000
    li $t1, 0xF0F0
    andi $t0, $t1, 0x0F0F
    beq $t0, $zero, andi_pass1
    la $a0, andi_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
andi_pass1:
    la $a0, andi_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, pass_msg
    jal print_str
andi_next1:
    
    # Test 2: 0xFFFF & 0xFFFF = 0xFFFF
    li $t1, 0xFFFF
    andi $t0, $t1, 0xFFFF
    li $t3, 0xFFFF
    beq $t0, $t3, andi_pass2
    la $a0, andi_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
andi_pass2:
    la $a0, andi_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, pass_msg
    jal print_str
andi_next2:
    
    # Test 3: 0xAAAA & 0x5555 = 0x0000
    li $t1, 0xAAAA
    andi $t0, $t1, 0x5555
    beq $t0, $zero, andi_pass3
    la $a0, andi_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
andi_pass3:
    la $a0, andi_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, pass_msg
    jal print_str
andi_next3:

    # === Test NOR ===
    # Test 1: ~(0xF0F0 | 0x0F0F) = 0xFFFF0000
    li $t1, 0xF0F0
    li $t2, 0x0F0F
    nor $t0, $t1, $t2
    li $t3, 0xFFFF0000
    beq $t0, $t3, nor_pass1
    la $a0, nor_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
nor_pass1:
    la $a0, nor_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, pass_msg
    jal print_str
nor_next1:
    
    # Test 2: ~(0x0000 | 0x0000) = 0xFFFFFFFF
    li $t1, 0
    li $t2, 0
    nor $t0, $t1, $t2
    li $t3, -1
    beq $t0, $t3, nor_pass2
    la $a0, nor_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
nor_pass2:
    la $a0, nor_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, pass_msg
    jal print_str
nor_next2:
    
    # Test 3: ~(0xFFFFAAAA | 0x00005555) = 0x0000
    lui $t1, 0xFFFF
    ori $t1, 0xAAAA
    li $t2, 0x5555
    nor $t0, $t1, $t2
    beq $t0, $zero, nor_pass3
    la $a0, nor_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
nor_pass3:
    la $a0, nor_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, pass_msg
    jal print_str
nor_next3:

    # === Test OR ===
    # Test 1: 0xF0F0 | 0x0F0F = 0xFFFF
    li $t1, 0xF0F0
    li $t2, 0x0F0F
    or $t0, $t1, $t2
    li $t3, 0xFFFF
    beq $t0, $t3, or_pass1
    la $a0, or_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
or_pass1:
    la $a0, or_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, pass_msg
    jal print_str
or_next1:
    
    # Test 2: 0x0000 | 0x0000 = 0x0000
    li $t1, 0
    li $t2, 0
    or $t0, $t1, $t2
    beq $t0, $zero, or_pass2
    la $a0, or_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
or_pass2:
    la $a0, or_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, pass_msg
    jal print_str
or_next2:
    
    # Test 3: 0xAAAA | 0x5555 = 0xFFFF
    li $t1, 0xAAAA
    li $t2, 0x5555
    or $t0, $t1, $t2
    li $t3, 0xFFFF
    beq $t0, $t3, or_pass3
    la $a0, or_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
or_pass3:
    la $a0, or_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, pass_msg
    jal print_str
or_next3:

    # === Test ORI ===
    # Test 1: 0xF0F0 | 0x0F0F = 0xFFFF
    li $t1, 0xF0F0
    ori $t0, $t1, 0x0F0F
    li $t3, 0xFFFF
    beq $t0, $t3, ori_pass1
    la $a0, ori_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
ori_pass1:
    la $a0, ori_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, pass_msg
    jal print_str
ori_next1:
    
    # Test 2: 0x0000 | 0x0000 = 0x0000
    li $t1, 0
    ori $t0, $t1, 0x0000
    beq $t0, $zero, ori_pass2
    la $a0, ori_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
ori_pass2:
    la $a0, ori_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, pass_msg
    jal print_str
ori_next2:
    
    # Test 3: 0xAAAA | 0x5555 = 0xFFFF
    li $t1, 0xAAAA
    ori $t0, $t1, 0x5555
    li $t3, 0xFFFF
    beq $t0, $t3, ori_pass3
    la $a0, ori_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
ori_pass3:
    la $a0, ori_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, pass_msg
    jal print_str
ori_next3:
#####
    # === Test SLL ===
    # Test 1: 0x0001 << 4 = 0x0010
    li $t1, 0x0001
    li $t2, 4
    sll $t0, $t1, 4
    li $t3, 0x0010
    beq $t0, $t3, sll_pass1
    la $a0, sll_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
sll_pass1:
    la $a0, sll_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, pass_msg
    jal print_str
sll_next1:

    # Test 2: 0x000F << 2 = 0x003C
    li $t1, 0x000F
    li $t2, 2
    sll $t0, $t1, 2
    li $t3, 0x003C
    beq $t0, $t3, sll_pass2
    la $a0, sll_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
sll_pass2:
    la $a0, sll_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, pass_msg
    jal print_str
sll_next2:

    # Test 3: 0x00AA << 1 = 0x0154
    li $t1, 0x00AA
    sll $t0, $t1, 1
    li $t3, 0x0154
    beq $t0, $t3, sll_pass3
    la $a0, sll_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
sll_pass3:
    la $a0, sll_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, pass_msg
    jal print_str

# === Test SRA ===
sra_tests:
    # Test 1: 0x80000000 >> 2 (arithmetic) = 0xE0000000
    li $t1, 0x80000000
    sra $t0, $t1, 2
    li $t3, 0xE0000000
    beq $t0, $t3, sra_pass1
    la $a0, sra_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
sra_pass1:
    la $a0, sra_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, pass_msg
    jal print_str
sra_next1:

    # Test 2: 0xFFFF0000 >> 4 (arithmetic) = 0xFFFFF000
    li $t1, 0xFFFF0000
    sra $t0, $t1, 4
    li $t3, 0xFFFFF000
    beq $t0, $t3, sra_pass2
    la $a0, sra_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
sra_pass2:
    la $a0, sra_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, pass_msg
    jal print_str
sra_next2:

    # Test 3: 0xFFFFFFF0 >> 1 = 0xFFFFFFF8
    li $t1, 0xFFFFFFF0
    sra $t0, $t1, 1
    li $t3, 0xFFFFFFF8
    beq $t0, $t3, sra_pass3
    la $a0, sra_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
sra_pass3:
    la $a0, sra_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, pass_msg
    jal print_str

# === Test SRL ===
srl_tests:
    # Test 1: 0xF0000000 >> 4 = 0x0F000000
    li $t1, 0xF0000000
    srl $t0, $t1, 4
    li $t3, 0x0F000000
    beq $t0, $t3, srl_pass1
    la $a0, srl_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
srl_pass1:
    la $a0, srl_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, pass_msg
    jal print_str
srl_next1:

    # Test 2: 0xAAAAAAAA >> 1 = 0x55555555
    li $t1, 0xAAAAAAAA
    srl $t0, $t1, 1
    li $t3, 0x55555555
    beq $t0, $t3, srl_pass2
    la $a0, srl_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
srl_pass2:
    la $a0, srl_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, pass_msg
    jal print_str
srl_next2:

    # Test 3: 0xFF00FF00 >> 8 = 0x00FF00FF
    li $t1, 0xFF00FF00
    srl $t0, $t1, 8
    li $t3, 0x00FF00FF
    beq $t0, $t3, srl_pass3
    la $a0, srl_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
srl_pass3:
    la $a0, srl_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, pass_msg
    jal print_str
#####
    # === Test SUB ===
    # Test 1: 5 - 3 = 2
    li $t1, 5
    li $t2, 3
    sub $t0, $t1, $t2
    li $t3, 2
    beq $t0, $t3, sub_pass1
    la $a0, sub_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
sub_pass1:
    la $a0, sub_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, pass_msg
    jal print_str
sub_next1:
    
    # Test 2: 0 - 1 = -1
    li $t1, 0
    li $t2, 1
    sub $t0, $t1, $t2
    li $t3, -1
    beq $t0, $t3, sub_pass2
    la $a0, sub_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
sub_pass2:
    la $a0, sub_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, pass_msg
    jal print_str
sub_next2:
    
    # Test 3: 0xFFFF - 0xFFFE = 1
    li $t1, 0xFFFF
    li $t2, 0xFFFE
    sub $t0, $t1, $t2
    li $t3, 1
    beq $t0, $t3, sub_pass3
    la $a0, sub_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
sub_pass3:
    la $a0, sub_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, pass_msg
    jal print_str
sub_next3:

    # === Test SUBU ===
    # Test 1: 5 - 3 = 2
    li $t1, 5
    li $t2, 3
    subu $t0, $t1, $t2
    li $t3, 2
    beq $t0, $t3, subu_pass1
    la $a0, subu_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
subu_pass1:
    la $a0, subu_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, pass_msg
    jal print_str
subu_next1:
    
    # Test 2: 0 - 1 = 0xFFFFFFFF
    li $t1, 0
    li $t2, 1
    subu $t0, $t1, $t2
    li $t3, -1
    beq $t0, $t3, subu_pass2
    la $a0, subu_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
subu_pass2:
    la $a0, subu_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, pass_msg
    jal print_str
subu_next2:
    
    # Test 3: 0xFFFF - 0xFFFE = 1
    li $t1, 0xFFFF
    li $t2, 0xFFFE
    subu $t0, $t1, $t2
    li $t3, 1
    beq $t0, $t3, subu_pass3
    la $a0, subu_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
subu_pass3:
    la $a0, subu_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, pass_msg
    jal print_str
subu_next3:

    # === Test XOR ===
    # Test 1: 0xF0F0 ^ 0x0F0F = 0xFFFF
    li $t1, 0xF0F0
    li $t2, 0x0F0F
    xor $t0, $t1, $t2
    li $t3, 0xFFFF
    beq $t0, $t3, xor_pass1
    la $a0, xor_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
xor_pass1:
    la $a0, xor_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, pass_msg
    jal print_str
xor_next1:
    
    # Test 2: 0xAAAA ^ 0xAAAA = 0x0000
    li $t1, 0xAAAA
    li $t2, 0xAAAA
    xor $t0, $t1, $t2
    beq $t0, $zero, xor_pass2
    la $a0, xor_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
xor_pass2:
    la $a0, xor_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, pass_msg
    jal print_str
xor_next2:
    
    # Test 3: 0x0000 ^ 0xFFFF = 0xFFFF
    li $t1, 0
    li $t2, 0xFFFF
    xor $t0, $t1, $t2
    li $t3, 0xFFFF
    beq $t0, $t3, xor_pass3
    la $a0, xor_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
xor_pass3:
    la $a0, xor_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, pass_msg
    jal print_str
xor_next3:

    # === Test XORI ===
    # Test 1: 0xF0F0 ^ 0x0F0F = 0xFFFF
    li $t1, 0xF0F0
    xori $t0, $t1, 0x0F0F
    li $t3, 0xFFFF
    beq $t0, $t3, xori_pass1
    la $a0, xori_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
xori_pass1:
    la $a0, xori_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, pass_msg
    jal print_str
xori_next1:
    
    # Test 2: 0xAAAA ^ 0xAAAA = 0x0000
    li $t1, 0xAAAA
    xori $t0, $t1, 0xAAAA
    beq $t0, $zero, xori_pass2
    la $a0, xori_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
xori_pass2:
    la $a0, xori_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, pass_msg
    jal print_str
xori_next2:
    
    # Test 3: 0x0000 ^ 0xFFFF = 0xFFFF
    li $t1, 0
    xori $t0, $t1, 0xFFFF
    li $t3, 0xFFFF
    beq $t0, $t3, xori_pass3
    la $a0, xori_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
xori_pass3:
    la $a0, xori_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, pass_msg
    jal print_str
xori_next3:

    # === Test SLT ===
    # Test 1: 5 < 10 = 1
    li $t1, 5
    li $t2, 10
    slt $t0, $t1, $t2
    li $t3, 1
    beq $t0, $t3, slt_pass1
    la $a0, slt_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
slt_pass1:
    la $a0, slt_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, pass_msg
    jal print_str
slt_next1:
    
    # Test 2: 10 < 5 = 0
    li $t1, 10
    li $t2, 5
    slt $t0, $t1, $t2
    beq $t0, $zero, slt_pass2
    la $a0, slt_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
slt_pass2:
    la $a0, slt_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, pass_msg
    jal print_str
slt_next2:
    
    # Test 3: -1 < 1 = 1
    li $t1, -1
    li $t2, 1
    slt $t0, $t1, $t2
    li $t3, 1
    beq $t0, $t3, slt_pass3
    la $a0, slt_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
slt_pass3:
la $a0, slt_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, pass_msg
    jal print_str
slt_next3:

            # === Test SLTU ===
    # Test 1: 5 < 10 = 1
    li $t1, 5
    li $t2, 10
    sltu $t0, $t1, $t2
    li $t3, 1
    beq $t0, $t3, sltu_pass1
    la $a0, sltu_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
sltu_pass1:
    la $a0, sltu_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, pass_msg
    jal print_str
sltu_next1:
    
    # Test 2: 10 < 5 = 0
    li $t1, 10
    li $t2, 5
    sltu $t0, $t1, $t2
    beq $t0, $zero, sltu_pass2
    la $a0, sltu_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
sltu_pass2:
    la $a0, sltu_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, pass_msg
    jal print_str
sltu_next2:
    
    # Test 3: 0xFFFF < 0x0001 = 0
    li $t1, 0xFFFF
    li $t2, 1
    sltu $t0, $t1, $t2
    beq $t0, $zero, sltu_pass3
    la $a0, sltu_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
sltu_pass3:
    la $a0, sltu_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, pass_msg
    jal print_str
sltu_next3:

    # === Test SLTIU ===
    # Test 1: 5 < 10 = 1
    li $t1, 5
    sltiu $t0, $t1, 10
    li $t3, 1
    beq $t0, $t3, sltiu_pass1
    la $a0, sltiu_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
sltiu_pass1:
    la $a0, sltiu_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, pass_msg
    jal print_str
sltiu_next1:
    
    # Test 2: 10 < 5 = 0
    li $t1, 10
    sltiu $t0, $t1, 5
    beq $t0, $zero, sltiu_pass2
    la $a0, sltiu_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
sltiu_pass2:
    la $a0, sltiu_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, pass_msg
    jal print_str
sltiu_next2:
    
    # Test 3: 0xFFFF < 1 = 0
    li $t1, 0xFFFF
    sltiu $t0, $t1, 1
    beq $t0, $zero, sltiu_pass3
    la $a0, sltiu_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
sltiu_pass3:
    la $a0, sltiu_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, pass_msg
    jal print_str
sltiu_next3:

    # === Test BEQ ===
    # Test 1: 5 == 5, should branch
    li $t1, 5
    li $t2, 5
    beq $t1, $t2, beq_pass1
    la $a0, beq_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
beq_pass1:
    la $a0, beq_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, pass_msg
    jal print_str
beq_next1:
    
    # Test 2: 5 != 6, should not branch
    li $t1, 5
    li $t2, 6
    beq $t1, $t2, beq_fail2
    j beq_pass2
beq_fail2:
    la $a0, beq_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
beq_pass2:
    la $a0, beq_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, pass_msg
    jal print_str
beq_next2:
    
    # Test 3: 0 == 0, should branch
    li $t1, 0
    li $t2, 0
    beq $t1, $t2, beq_pass3
    la $a0, beq_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
beq_pass3:
    la $a0, beq_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, pass_msg
    jal print_str
beq_next3:

    # === Test BNE ===
    # Test 1: 5 != 6, should branch
    li $t1, 5
    li $t2, 6
    bne $t1, $t2, bne_pass1
    la $a0, bne_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
bne_pass1:
    la $a0, bne_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, pass_msg
    jal print_str
bne_next1:
    
    # Test 2: 5 == 5, should not branch
    li $t1, 5
    li $t2, 5
    bne $t1, $t2, bne_fail2
    j bne_pass2
bne_fail2:
    la $a0, bne_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
bne_pass2:
    la $a0, bne_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, pass_msg
    jal print_str
bne_next2:
    
    # Test 3: 0 != -1, should branch
    li $t1, 0
    li $t2, -1
    bne $t1, $t2, bne_pass3
    la $a0, bne_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
bne_pass3:
    la $a0, bne_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, pass_msg
    jal print_str
bne_next3:

    # === Test J ===
    # Test 1: Jump to label
    j j_pass1
    la $a0, j_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
j_pass1:
    la $a0, j_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, pass_msg
    jal print_str
j_next1:
    
    # Test 2: Jump over fail
    j j_pass2
    la $a0, j_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
j_pass2:
    la $a0, j_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, pass_msg
    jal print_str
j_next2:
    
    # Test 3: Jump to end
    j j_pass3
    la $a0, j_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
j_pass3:
    la $a0, j_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, pass_msg
    jal print_str
j_next3:

    # === Test LUI ===
    # Test 1: Load 0x1234 to upper 16 bits
    lui $t0, 0x1234
    li $t3, 0x12340000
    beq $t0, $t3, lui_pass1
    la $a0, lui_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
lui_pass1:
    la $a0, lui_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, pass_msg
    jal print_str
lui_next1:
    
    # Test 2: Load 0xFFFF to upper 16 bits
    lui $t0, 0xFFFF
    li $t3, 0xFFFF0000
    beq $t0, $t3, lui_pass2
    la $a0, lui_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
lui_pass2:
    la $a0, lui_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, pass_msg
    jal print_str
lui_next2:
    
    # Test 3: Load 0x0000 to upper 16 bits
    lui $t0, 0x0000
    beq $t0, $zero, lui_pass3
    la $a0, lui_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
lui_pass3:
    la $a0, lui_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, pass_msg
    jal print_str
lui_next3:

    # === Test LW ===
    # Test 1: Load 0x1234 from mem[0]
    la $t1, mem
    lw $t0, 0($t1)
    li $t3, 0x1234
    beq $t0, $t3, lw_pass1
    la $a0, lw_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
lw_pass1:
    la $a0, lw_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, pass_msg
    jal print_str
lw_next1:
    
    # Test 2: Load 0x5678 from mem[4]
    la $t1, mem
    lw $t0, 4($t1)
    li $t3, 0x5678
    beq $t0, $t3, lw_pass2
    la $a0, lw_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
lw_pass2:
    la $a0, lw_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, pass_msg
    jal print_str
lw_next2:
    
    # Test 3: Load 0x9ABC from mem[8]
    la $t1, mem
    lw $t0, 8($t1)
    li $t3, 0x9ABC
    beq $t0, $t3, lw_pass3
    la $a0, lw_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
lw_pass3:
    la $a0, lw_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, pass_msg
    jal print_str
lw_next3:

    # === Test LB ===
    # Test 1: Load 0x34 from mem[0](0x1234)
    la $t1, mem
    lb $t0, 0($t1)
    li $t3, 0x34
    beq $t0, $t3, lb_pass1
    la $a0, lb_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
lb_pass1:
    la $a0, lb_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, pass_msg
    jal print_str
lb_next1:
    
    # Test 2: Load 0x56 from mem[4](0x5678)
    la $t1, mem
    lb $t0, 5($t1)
    li $t3, 0x56
    beq $t0, $t3, lb_pass2
    la $a0, lb_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
lb_pass2:
    la $a0, lb_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, pass_msg
    jal print_str
lb_next2:
    
    # Modify mem[8] from 0x0000_9ABC to FF654300
    la $t1, mem
    lw $t0, 8($t1)
    nor $t7, $zero, $t0
    sll $t0, $t7, 8 
    sw $t0, 8($t1)
    
    # Test 3: Load 0xFFFFFFFF from mem[8](0xFF654300)
    la $t1, mem
    lb $t0, 11($t1)
    nor $t3, $zero, $zero
    beq $t0, $t3, lb_pass3
    la $a0, lb_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
lb_pass3:
    la $a0, lb_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, pass_msg
    jal print_str
lb_next3:

    # === Test LBU ===
    # Test 1: Load 0x34 from mem[0](0x1234)
    la $t1, mem
    lbu $t0, 0($t1)
    li $t3, 0x34
    beq $t0, $t3, lbu_pass1
    la $a0, lbu_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
lbu_pass1:
    la $a0, lbu_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, pass_msg
    jal print_str
lbu_next1:
    
    # Test 2: Load 0x56 from mem[4](0x5678)
    la $t1, mem
    lbu $t0, 5($t1)
    li $t3, 0x56
    beq $t0, $t3, lbu_pass2
    la $a0, lbu_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
lbu_pass2:
    la $a0, lbu_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, pass_msg
    jal print_str
lbu_next2:
    
    # Test 3: Load 0xFF from mem[8](0xFF654300)
    la $t1, mem
    lbu $t0, 11($t1)
    li $t3, 0xFF
    beq $t0, $t3, lbu_pass3
    la $a0, lbu_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
lbu_pass3:
    la $a0, lbu_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, pass_msg
    jal print_str
lbu_next3:
#####
    # === Test LH ===
    # Test 1: Load 0x1234 from mem[0](0x00001234)
    la $t1, mem
    lh $t0, 0($t1)
    li $t3, 0x1234
    beq $t0, $t3, lh_pass1
    la $a0, lh_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
lh_pass1:
    la $a0, lh_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, pass_msg
    jal print_str
lh_next1:
    
    # Test 2: Load 0xFFFF4300 from mem[8](0xFF654300)
    la $t1, mem
    lh $t0, 8($t1)
    li $t3, 0x4300
    beq $t0, $t3, lh_pass2
    la $a0, lh_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
lh_pass2:
    la $a0, lh_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, pass_msg
    jal print_str
lh_next2:
    
    # Test 3: Load 0xFFFFFF65 from mem[8](0xFF654300)
    la $t1, mem
    lh $t0, 10($t1)
    li $t7, 0XFFFF
    nor $t7, $zero, $t7
    li $t3, 0xFF65
    or $t3, $t3, $t7
    beq $t0, $t3, lh_pass3
    la $a0, lh_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
lh_pass3:
    la $a0, lh_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, pass_msg
    jal print_str
lh_next3:

    # === Test LHU ===
    # Test 1: Load 0x1234 from mem[0](0x00001234)
    la $t1, mem
    lhu $t0, 0($t1)
    li $t3, 0x1234
    beq $t0, $t3, lhu_pass1
    la $a0, lhu_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
lhu_pass1:
    la $a0, lhu_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, pass_msg
    jal print_str
lhu_next1:
    
    # Test 2: Load 0x4300 from mem[8](0xFF654300)
    la $t1, mem
    lhu $t0, 8($t1)
    li $t3, 0x4300
    beq $t0, $t3, lhu_pass2
    la $a0, lhu_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
lhu_pass2:
    la $a0, lhu_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, pass_msg
    jal print_str
lhu_next2:
    
    # Test 3: Load 0xFF65 from mem[8](0xFF654300)
    la $t1, mem
    lhu $t0, 10($t1)
    li $t3, 0xFF65
    beq $t0, $t3, lhu_pass3
    la $a0, lhu_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
lhu_pass3:
    la $a0, lhu_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, pass_msg
    jal print_str
lhu_next3:

    # === Test SW ===
    # Test 1: Store 0xABCD to mem[0], then load back
    la $t1, mem
    li $t2, 0xABCD
    sw $t2, 0($t1)
    lw $t0, 0($t1)
    beq $t0, $t2, sw_pass1
    la $a0, sw_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again

sw_pass1:
    la $a0, sw_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, pass_msg
    jal print_str
sw_next1:
    
    # Test 2: Store 0xEF01 to mem[4], then load back
    la $t1, mem
    li $t2, 0xEF01
    sw $t2, 4($t1)
    lw $t0, 4($t1)
    beq $t0, $t2, sw_pass2
    la $a0, sw_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
sw_pass2:
    la $a0, sw_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, pass_msg
    jal print_str
sw_next2:
    
    # Test 3: Store 0x3456 to mem[8], then load back
    la $t1, mem
    li $t2, 0x3456
    sw $t2, 8($t1)
    lw $t0, 8($t1)
    beq $t0, $t2, sw_pass3
    la $a0, sw_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
sw_pass3:
    la $a0, sw_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, pass_msg
    jal print_str
sw_next3:

    # === Test SB ===
    # Test 1: Store 0xD to mem[0], then load back
    la $t1, mem
    li $t2, 0xD
    sb $t2, 0($t1)
    lbu $t0, 0($t1)
    beq $t0, $t2, sb_pass1
    la $a0, sb_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again

sb_pass1:
    la $a0, sb_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, pass_msg
    jal print_str
sb_next1:
    
    # Test 2: Store 0xE to mem[3], then load back
    la $t1, mem
    li $t2, 0xE
    sb $t2, 3($t1)
    lbu $t0, 3($t1)
    beq $t0, $t2, sb_pass2
    la $a0, sb_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
sb_pass2:
    la $a0, sb_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, pass_msg
    jal print_str
sb_next2:
    
    # Test 3: Store 0xF to mem[6], then load back
    la $t1, mem
    li $t2, 0xF
    sb $t2, 6($t1)
    lbu $t0, 6($t1)
    beq $t0, $t2, sb_pass3
    la $a0, sb_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
sb_pass3:
    la $a0, sb_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, pass_msg
    jal print_str
sb_next3:

    # === Test SH ===
    # Test 1: Store 0xFD to mem[1:0], then load back
    la $t1, mem
    li $t2, 0xFD
    sh $t2, 0($t1)
    lhu $t0, 0($t1)
    beq $t0, $t2, sh_pass1
    la $a0, sh_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again

sh_pass1:
    la $a0, sh_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, pass_msg
    jal print_str
sh_next1:
    
    # Test 2: Store 0xEE to mem[3:2], then load back
    la $t1, mem
    li $t2, 0xEE
    sh $t2, 2($t1)
    lhu $t0, 2($t1)
    beq $t0, $t2, sh_pass2
    la $a0, sh_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
sh_pass2:
    la $a0, sh_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, pass_msg
    jal print_str
sh_next2:
    
    # Test 3: Store 0x1F to mem[7:6], then load back
    la $t1, mem
    li $t2, 0x1F
    sh $t2, 6($t1)
    lhu $t0, 6($t1)
    beq $t0, $t2, sh_pass3
    la $a0, sh_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
sh_pass3:
    la $a0, sh_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, pass_msg
    jal print_str
sh_next3:

    # === Test MULT ===
    # Test 1: 5 * -3 = -15
    li $t1, 5
    li $t2, -3
    mult $t1, $t2
    mflo $t0
    li $t3, -15
    beq $t0, $t3, mult_pass1
    la $a0, mult_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
mult_pass1:
    la $a0, mult_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, pass_msg
    jal print_str
mult_next1:
    # Test 2: -7 * -6 = 42
    li $t1, -7
    li $t2, -6
    mult $t1, $t2
    mflo $t0
    li $t3, 42
    beq $t0, $t3, mult_pass2
    la $a0, mult_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
mult_pass2:
    la $a0, mult_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, pass_msg
    jal print_str
mult_next2:
    # Test 3: 9 * 0 = 0
    li $t1, 9
    li $t2, 0
    mult $t1, $t2
    mflo $t0
    beq $t0, $zero, mult_pass3
    la $a0, mult_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
mult_pass3:
    la $a0, mult_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, pass_msg
    jal print_str
mult_next3:

    # === Test MULTU ===
    # Test 1: 5 * 3 = 15
    li $t1, 5
    li $t2, 3
    multu $t1, $t2
    mflo $t0
    li $t3, 15
    beq $t0, $t3, multu_pass1
    la $a0, multu_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
multu_pass1:
    la $a0, multu_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, pass_msg
    jal print_str
multu_next1:
    # Test 2: 10 * 20 = 200
    li $t1, 10
    li $t2, 20
    multu $t1, $t2
    mflo $t0
    li $t3, 200
    beq $t0, $t3, multu_pass2
    la $a0, multu_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
multu_pass2:
    la $a0, multu_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, pass_msg
    jal print_str
multu_next2:
    # Test 2: 0xFFFF * 1 = 0xFFFF
    li $t1, 0xFFFF
    li $t2, 1
    multu $t1, $t2
    mflo $t0
    li $t3, 0xFFFF
    beq $t0, $t3, multu_pass3
    la $a0, multu_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
multu_pass3:
    la $a0, multu_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, pass_msg
    jal print_str
multu_next3:
    # === Test DIV ===
    # Test 1: 20 / 5 = 4
    li $t1, 20
    li $t2, 5
    div $t1, $t2
    mflo $t0
    li $t3, 4
    beq $t0, $t3, div_pass1
    la $a0, div_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
div_pass1:
    la $a0, div_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, pass_msg
    jal print_str
div_next1:

    # Test 2: -30 / 6 = -5
    li $t1, -30
    li $t2, 6
    div $t1, $t2
    mflo $t0
    li $t3, -5
    beq $t0, $t3, div_pass2
    la $a0, div_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
div_pass2:
    la $a0, div_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, pass_msg
    jal print_str
div_next2:

    # Test 3: 100 / -10 = -10
    li $t1, 100
    li $t2, -10
    div $t1, $t2
    mflo $t0
    li $t3, -10
    beq $t0, $t3, div_pass3
    la $a0, div_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
div_pass3:
    la $a0, div_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, pass_msg
    jal print_str
div_next3:

    # === Test DIVU ===
    # Test 1: 100 / 10 = 10
    li $t1, 100
    li $t2, 10
    divu $t1, $t2
    mflo $t0
    li $t3, 10
    beq $t0, $t3, divu_pass1
    la $a0, divu_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
divu_pass1:
    la $a0, divu_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, pass_msg
    jal print_str
divu_next1:

    # Test 2: 255 / 15 = 17
    li $t1, 255
    li $t2, 15
    divu $t1, $t2
    mflo $t0
    li $t3, 17
    beq $t0, $t3, divu_pass2
    la $a0, divu_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
divu_pass2:
    la $a0, divu_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, pass_msg
    jal print_str
divu_next2:

    # Test 3: 81 / 9 = 9
    li $t1, 81
    li $t2, 9
    divu $t1, $t2
    mflo $t0
    li $t3, 9
    beq $t0, $t3, divu_pass3
    la $a0, divu_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
divu_pass3:
    la $a0, divu_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, pass_msg
    jal print_str
divu_next3:

    # === Test MFHI ===
    # Test 1: 20 % 6 = 2
    li $t1, 20
    li $t2, 6
    div $t1, $t2
    mfhi $t0
    li $t3, 2
    beq $t0, $t3, mfhi_pass1
    la $a0, mfhi_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
mfhi_pass1:
    la $a0, mfhi_str
    jal print_str
    la $a0, test1
    jal print_str
    la $a0, pass_msg
    jal print_str
mfhi_next1:

    # Test 2: 31 % 7 = 3
    li $t1, 31
    li $t2, 7
    div $t1, $t2
    mfhi $t0
    li $t3, 3
    beq $t0, $t3, mfhi_pass2
    la $a0, mfhi_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
mfhi_pass2:
    la $a0, mfhi_str
    jal print_str
    la $a0, test2
    jal print_str
    la $a0, pass_msg
    jal print_str
mfhi_next2:

    # Test 3: 17 % 5 = 2
    li $t1, 17
    li $t2, 5
    div $t1, $t2
    mfhi $t0
    li $t3, 2
    beq $t0, $t3, mfhi_pass3
    la $a0, mfhi_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, fail_msg
    jal print_str
    j try_again
mfhi_pass3:
    la $a0, mfhi_str
    jal print_str
    la $a0, test3
    jal print_str
    la $a0, pass_msg
    jal print_str
mfhi_next3:
#####
	la $a0, allpass_msg
    jal print_str
    j end
try_again:
	la $a0, tryagain_msg
    jal print_str
end:
    # �{������
    li $v0, 10
    syscall

# === �C�L�Ƶ{�� ===
print_str:
    li $v0, 4
    syscall
    jr $ra
    
