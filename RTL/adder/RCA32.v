// ======================================================================
//
// Module Name  : 32-bit Ripple Carry Adder (RCA32)
// Function Description:
//   {cout, sum[31:0]} = a[31:0] + b[31:0] + cin
//   More Delay, Less Area
//
// Author       : jorjor
// Created Date : 2025.03.21
//
// ======================================================================

`timescale 1ns/100ps

module RCA32 (
    input   [31:0] a,  
    input   [31:0] b,  
    input          cin,
    output  [31:0] sum,
    output         cout
);

wire [30:0] c;

FA u_FA_0 (
    .a      (a[0]),
    .b      (b[0]),
    .cin    (cin),
    .sum    (sum[0]),
    .cout   (c[0])
);

generate
    genvar i;
    for (i = 1; i <= 30; i=i+1) begin : block_FA_1_30
        FA u_FA_1_30 (
            .a      (a[i]),
            .b      (b[i]),
            .cin    (c[i-1]),
            .sum    (sum[i]),
            .cout   (c[i])
        );
    end
endgenerate

FA u_FA_31 (
    .a      (a[31]),
    .b      (b[31]),
    .cin    (c[30]),
    .sum    (sum[31]),
    .cout   (cout)
);

endmodule
