// ======================================================================
//
// Module Name  : Arthimetic Logic Unit
// Function Descriptions:
//  -----------------
//  ALUop[4:0]  |  Function
//     00000    |  and 
//     00001    |  or 
//     00010    |  add 
//     01010    |  subtract 
//     00100    |  xor
//     00101    |  sll
//     00110    |  sra
//     00111    |  srl
//     01011    |  set-on-less-than 
//     11000    |  nor
//
//  ALUop[4] : 0 -> signed; 1 -> unsigned
//
// Author       : jorjor
// Created Date : 2025.03.18
//
// ======================================================================

`timescale 1ns/100ps


module ArthimeticLogicUnit (
    input   [31:0]  a,          // Data in A
    input   [31:0]  b,          // Data in B
    input   [5:0]   ALUop,      // ALU control
    output          zero,       // Zero Detection
    output          overflow,   // Overflow Detection
    output  [31:0]  result      // ALU result
);

wire        sel_inv_a;
wire        sel_inv_b;
wire [2:0]  sel_alu;
wire        sel_slt_xor;

wire is_unsigned;
wire is_subtract;
wire slt;
wire sltu;
wire sltu_or_slt;

wire [31:0] a_sll_b;
wire [31:0] a_sra_b;
wire [31:0] a_srl_b;

wire [31:0] sum;
wire [30:0] cout;

wire overflow_tmp;

assign is_unsigned = ALUop[5];
assign sel_inv_a = ALUop[4];
assign sel_inv_b = ALUop[3];
assign sel_alu = ALUop[2:0];

assign is_subtract = ALUop[3];

// when (is_unsigned == 1'b1) and (signbit of a == signbit of result)
// means a is larger than b
assign sltu = (a[31] ^ slt) & (|sum);
assign sltu_or_slt = (is_unsigned) ? sltu : slt;

assign a_sll_b = (a << b);
assign a_sra_b = (a[31]) ? (a_srl_b | ~(32'hFFFFFFFF >> b)) : a_srl_b;
assign a_srl_b = (a >> b);

ALU u_ALU_0 (
    .a          (a[0]),
    .b          (b[0]),
    .less       (sltu_or_slt),
    .cin        (is_subtract),
    .a_sll_b    (a_sll_b[0]), 
    .a_sra_b    (a_sra_b[0]),
    .a_srl_b    (a_srl_b[0]),
    .sel_inv_a  (sel_inv_a),
    .sel_inv_b  (sel_inv_b),
    .sel_alu    (sel_alu),
    .sum        (sum[0]),
    .cout       (cout[0]),
    .result     (result[0])
);

generate
    genvar i;
    for (i = 1; i <= 30; i=i+1) begin : block_ALU
        ALU u_ALU_1_30 (
            .a          (a[i]),
            .b          (b[i]),
            .less       (1'b0),
            .cin        (cout[i-1]),
            .a_sll_b    (a_sll_b[i]), 
            .a_sra_b    (a_sra_b[i]),
            .a_srl_b    (a_srl_b[i]),
            .sel_inv_a  (sel_inv_a),
            .sel_inv_b  (sel_inv_b),
            .sel_alu    (sel_alu),
            .sum        (sum[i]),
            .cout       (cout[i]),
            .result     (result[i])
        );
    end
endgenerate

ALU_signbit u_ALU_31 (
    .a          (a[31]),
    .b          (b[31]),
    .less       (1'b0),
    .cin        (cout[30]),
    .a_sll_b    (a_sll_b[31]), 
    .a_sra_b    (a_sra_b[31]),
    .a_srl_b    (a_srl_b[31]),
    .sel_inv_a  (sel_inv_a),
    .sel_inv_b  (sel_inv_b),
    .sel_alu    (sel_alu),
    .sum        (sum[31]),
    .result     (result[31]),
    .set        (slt),
    .overflow   (overflow_tmp)
);

assign zero = ~|result;
assign overflow = overflow_tmp & (is_unsigned);

endmodule

module ALU (
    input       a,
    input       b,
    input       less,
    input       cin,
    input       a_sll_b,
    input       a_sra_b,
    input       a_srl_b,
    input       sel_inv_a,
    input       sel_inv_b,
    input [2:0] sel_alu,
    output      sum,
    output      cout,
    output reg  result
);

wire        new_a;
wire        new_b;

wire        a_and_b;
wire        a_or_b;
wire        a_xor_b;
wire        sum_ab;

assign new_a = (sel_inv_a) ? ~a : a; 
assign new_b = (sel_inv_b) ? ~b : b;

assign a_and_b = new_a & new_b;
assign a_or_b  = new_a | new_b;
assign a_xor_b = new_a ^ new_b;

FA u_FA (
    .a      (new_a),
    .b      (new_b),
    .cin    (cin),
    .sum    (sum_ab),
    .cout   (cout)
);

assign sum = sum_ab;

always @(*) begin
    case(sel_alu)
        3'b000  : result = a_and_b;
        3'b001  : result = a_or_b;
        3'b010  : result = sum_ab;
        3'b011  : result = less;
        3'b100  : result = a_xor_b;
        3'b101  : result = a_sll_b;
        3'b110  : result = a_sra_b;
        default : result = a_srl_b; // 3'b111
    endcase
end

endmodule

module ALU_signbit (
    input       a,
    input       b,
    input       less,
    input       cin,
    input       a_sll_b,
    input       a_sra_b,
    input       a_srl_b,
    input       sel_inv_a,
    input       sel_inv_b,
    input [2:0] sel_alu,
    output      sum,
    output reg  result,
    output      set,        // for set-on-less-than
    output      overflow
);

wire        new_a;
wire        new_b;

wire        a_and_b;
wire        a_or_b;
wire        a_xor_b;
wire        sum_ab;
wire        cout;

assign new_a = (sel_inv_a) ? ~a : a; 
assign new_b = (sel_inv_b) ? ~b : b;

assign a_and_b = new_a & new_b;
assign a_or_b = new_a | new_b;
assign a_xor_b = new_a ^ new_b;

FA u_FA (
    .a      (new_a),
    .b      (new_b),
    .cin    (cin),
    .sum    (sum_ab),
    .cout   (cout)
);

assign sum = sum_ab;

always @(*) begin
    case(sel_alu)
        3'b000  : result = a_and_b;
        3'b001  : result = a_or_b;
        3'b010  : result = sum_ab;
        3'b011  : result = less;
        3'b100  : result = a_xor_b;
        3'b101  : result = a_sll_b;
        3'b110  : result = a_sra_b;
        default : result = a_srl_b; // 3'b111
    endcase
end

// signbit = 1 means a < b, then set-on-less-than is 1
assign set = sum_ab;

// Overflow detection
assign overflow = cout ^ cin;

endmodule
