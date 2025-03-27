// ======================================================================
//
// Module Name  : Lo/Hi Register
// Function Descriptions:
//
//
// Author       : jorjor
// Created Date : 2025.03.20
//
// ======================================================================

`timescale 1ns/100ps


module LoHiRegister (
    input               clk,
    input               rst,
    input       [63:0]  p,      // Data in (Product/Division result)
    input               is_mult,// 1 -> mult, 0 -> div
    input               wen,    // Active high write enable
    input               ren,    // Active high read enable
    input               is_hi,  // 1 -> read Hi. 0 -> read_Lo
    output reg  [31:0]  rdata   // Read data out
);

reg [31:0] Lo;
reg [31:0] Hi;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        Lo <= 32'b0;
        Hi <= 32'b0;
    end
    else if (wen) begin
        // mult -> {High, Low} or div -> {remainder, quotient} 
        {Hi, Lo} <= p;
    end
end

always @(*) begin
    case({ren, is_hi})
        2'b10   : rdata = Lo;
        2'b11   : rdata = Hi;
        default : rdata = 32'b0;
    endcase
end

endmodule
