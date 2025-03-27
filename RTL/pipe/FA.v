// ======================================================================
//
// Module Name  : Full Adder
// Function Descriptions:
//  {cout, sum} = a + b + cin
// 
// Author       : jorjor
// Created Date : 2025.03.18
//
// ======================================================================

`timescale 1ns/100ps


module FA (
    input   a,
    input   b,
    input   cin,
    output  sum,
    output  cout
);

wire sum_ab, cout_ab;
wire sum_ab_cin, cout_ab_cin;

HA u_HA_a_b (
    .a      (a),
    .b      (b),
    .sum    (sum_ab),
    .cout   (cout_ab)
);

HA u_HA_ab_cin (
    .a      (sum_ab),
    .b      (cin),
    .sum    (sum_ab_cin),
    .cout   (cout_ab_cin)
);

assign sum = sum_ab_cin;
assign cout = cout_ab | cout_ab_cin;

endmodule
