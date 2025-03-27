// Arithmetic and Logical Instructions
`define ADD	    6'b100000	// ArithLog	    $d = $s + $t
`define ADDU	6'b100001	// ArithLog	    $d = $s + $t
`define ADDI	6'b001000	// ArithLogI	$t = $s + SE(i)
`define ADDIU	6'b001001	// ArithLogI	$t = $s + SE(i)
`define AND	    6'b100100	// ArithLog	    $d = $s & $t
`define ANDI	6'b001100	// ArithLogI	$t = $s & ZE(i)
`define DIV	    6'b011010	// DivMult	    lo = $s / $t; hi = $s % $t
`define DIVU	6'b011011	// DivMult	    lo = $s / $t; hi = $s % $t
`define MULT	6'b011000	// DivMult	    hi:lo = $s * $t
`define MULTU	6'b011001	// DivMult	    hi:lo = $s * $t
`define NOR	    6'b100111	// ArithLog	    $d = ~($s | $t)
`define OR	    6'b100101	// ArithLog	    $d = $s | $t
`define ORI	    6'b001101	// ArithLogI	$t = $s | ZE(i)
`define SLL	    6'b000000	// Shift	    $d = $t << a
//`define SLLV	6'b000100	// ShiftV	    $d = $t << $s
`define SRA	    6'b000011	// Shift	    $d = $t >> a
//`define SRAV	6'b000111	// ShiftV	    $d = $t >> $s
`define SRL	    6'b000010	// Shift	    $d = $t >>> a
//`define SRLV	6'b000110	// ShiftV	    $d = $t >>> $s
`define SUB	    6'b100010	// ArithLog	    $d = $s - $t
`define SUBU	6'b100011	// ArithLog	    $d = $s - $t
`define XOR	    6'b100110	// ArithLog	    $d = $s ^ $t
`define XORI	6'b001110	// ArithLogI	$d = $s ^ ZE(i)

// Constant-manipulating Instructions
//`define LHI	    6'b011001	// LoadI	    HH ($t) = i
//`define LLO	    6'b011000	// LoadI	    LH ($t) = i

// Comparison Instructions
`define SLT	    6'b101010	// ArithLog	    $d = ($s < $t)
`define SLTU	6'b101011	// ArithLog	    $d = ($s < $t)
`define SLTI	6'b001010	// ArithLogI	$t = ($s < SE(i))
`define SLTIU	6'b001011	// ArithLogI	$t = ($s < SE(i))

// Branch Instructions
`define BEQ 	6'b000100	// Branch	    if ($s == $t) pc += i << 2
//`define BGTZ	6'b000111	// BranchZ	    if ($s > 0) pc += i << 2
//`define BLEZ	6'b000110	// BranchZ	    if ($s <= 0) pc += i << 2
`define BNE	    6'b000101	// Branch	    if ($s != $t) pc += i << 2

// Jump Instructions
`define J	    6'b000010	// Jump	        pc += i << 2
`define JAL	    6'b000011	// Jump	        $31 = pc; pc += i << 2
//`define JALR	6'b001001	// JumpR	    $31 = pc; pc = $s
`define JR	    6'b001000	// JumpR	    pc = $s

// Load Instructions
`define LB	    6'b100000	// LoadStore	$t = SE (MEM [$s + i]:1)
`define LBU	    6'b100100	// LoadStore	$t = ZE (MEM [$s + i]:1)
`define LH	    6'b100001	// LoadStore	$t = SE (MEM [$s + i]:2)
`define LHU	    6'b100101	// LoadStore	$t = ZE (MEM [$s + i]:2)
`define LUI     6'b001111   // LoadStore    $t[15:0] = i
`define LW	    6'b100011	// LoadStore	$t = MEM [$s + i]:4

// Store Instructions
`define SB	    6'b101000	// LoadStore	MEM [$s + i]:1 = LB ($t)
`define SH	    6'b101001	// LoadStore	MEM [$s + i]:2 = LH ($t)
`define SW	    6'b101011	// LoadStore	MEM [$s + i]:4 = $t

// Data movement Instructions
`define MFHI	6'b010000	// MoveFrom	    $d = hi
`define MFLO	6'b010010	// MoveFrom	    $d = lo
//`define MTHI	6'b010001	// MoveTo	    hi = $s
//`define MTLO	6'b010011	// MoveTo	    lo = $s

// Exception and Interrupt Instructions
//`define TRAP	6'b011010	// Trap
