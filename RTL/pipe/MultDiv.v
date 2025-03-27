// ======================================================================
//
// Module Name  : Multiplication/Division Processor
// Function Descriptions:
//
//
// Author       : jorjor
// Created Date : 2025.03.20
//
// ======================================================================

`timescale 1ns/100ps


module MultDiv (
    input       [31:0]  a,          // Data in A
    input       [31:0]  b,          // Data in B
    input               is_mult,    // 1 -> mult, 0 -> div
    input               is_unsigned,// 1 -> unsigned, 0 -> signed
    output reg  [63:0]  result      // Multiplication/Division result
);

wire signed [31:0] a_s;
wire signed [31:0] b_s;
wire        [63:0] mult;
wire        [63:0] multu;
wire        [63:0] div;
wire        [63:0] divu;

assign a_s = a;
assign b_s = b;
wire signed [63:0] a_s2 = {a, 32'b0};

assign mult = a_s * b_s;
assign multu = a * b;

assign div[31:0] = a_s / b_s;
assign div[63:32] = a_s - ($signed(div[31:0]) * b_s);
assign divu[31:0] = a / b;
assign divu[63:32] = a - (divu[31:0] * b);

always @(*) begin
    case({is_mult, is_unsigned})
        2'b00   : result = div; 
        2'b01   : result = divu; 
        2'b10   : result = mult; 
        default : result = multu; 
    endcase
end

endmodule
