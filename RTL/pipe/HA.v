// ======================================================================
//
// Module Name  : Half Adder
// Function Descriptions:
//  {cout, sum} = a + b 
// 
// Author       : jorjor
// Created Date : 2025.03.18
//
// ======================================================================

`timescale 1ns/100ps


module HA (
    input   a,
    input   b,
    output  sum,
    output  cout
);

assign sum = a ^ b;
assign cout = a & b;

endmodule
