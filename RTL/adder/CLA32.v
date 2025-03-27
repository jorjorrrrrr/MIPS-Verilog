// ======================================================================
//
// Module Name  : 32-bit Cascaded Carry Lookahead Adder (CLA32)
// Function Description:
//   {cout, sum[31:0]} = a[31:0] + b[31:0] + cin
//   Less Delay, More Area
//
// Author       : jorjor
// Created Date : 2025.03.21
//
// ======================================================================

module CLA32 (
    input   [31:0] a,  
    input   [31:0] b,  
    input          cin,
    output  [31:0] sum,
    output         cout
);

wire c8, c16, c24; 

CLA8 u_CLA_0_7 (
    .a      (a[7:0]),  
    .b      (b[7:0]),  
    .cin    (cin),
    .sum    (sum[7:0]),
    .cout   (c8)
);

CLA8 u_CLA_8_15 (
    .a      (a[15:8]),  
    .b      (b[15:8]),  
    .cin    (c8),
    .sum    (sum[15:8]),
    .cout   (c16)
);

CLA8 u_CLA_16_23 (
    .a      (a[23:16]),  
    .b      (b[23:16]),  
    .cin    (c16),
    .sum    (sum[23:16]),
    .cout   (c24)
);

CLA8 u_CLA_24_31 (
    .a      (a[31:24]),  
    .b      (b[31:24]),  
    .cin    (c24),
    .sum    (sum[31:24]),
    .cout   (cout)
);

endmodule

module CLA8 (
    input   [7:0]  a,  
    input   [7:0]  b,  
    input          cin,
    output  [7:0]  sum,
    output         cout
);

wire [7:0] g;
wire [7:0] p;
wire [7:0] c;

// Carry Lookahead Generator (CLG)
generate
    genvar i;
    for (i = 0; i <= 7; i=i+1) begin : block_CLG
        assign g[i] = a[i] & b[i];
        assign p[i] = a[i] | b[i];
    end
endgenerate

assign c[0] = (g[0]) | 
                (p[0] & cin);
assign c[1] = (g[1]) | 
                (p[1] & g[0]) | 
                (p[1] & p[0] & cin);
assign c[2] = (g[2]) | 
                (p[2] & g[1]) | 
                (p[2] & p[1] & g[0]) | 
                (p[2] & p[1] & p[0] & cin);
assign c[3] = (g[3]) | 
                (p[3] & g[2]) | 
                (p[3] & p[2] & g[1]) | 
                (p[3] & p[2] & p[1] & g[0]) | 
                (p[3] & p[2] & p[1] & p[0] & cin);
assign c[4] = (g[4]) | 
                (p[4] & g[3]) | 
                (p[4] & p[3] & g[2]) | 
                (p[4] & p[3] & p[2] & g[1]) | 
                (p[4] & p[3] & p[2] & p[1] & g[0]) | 
                (p[4] & p[3] & p[2] & p[1] & p[0] & cin);
assign c[5] = (g[5]) |
                (p[5] & g[4]) | 
                (p[5] & p[4] & g[3]) | 
                (p[5] & p[4] & p[3] & g[2]) | 
                (p[5] & p[4] & p[3] & p[2] & g[1]) | 
                (p[5] & p[4] & p[3] & p[2] & p[1] & g[0]) | 
                (p[5] & p[4] & p[3] & p[2] & p[1] & p[0] & cin);
assign c[6] = (g[6]) |
                (p[6] & g[5]) |
                (p[6] & p[5] & g[4]) | 
                (p[6] & p[5] & p[4] & g[3]) | 
                (p[6] & p[5] & p[4] & p[3] & g[2]) | 
                (p[6] & p[5] & p[4] & p[3] & p[2] & g[1]) | 
                (p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & g[0]) | 
                (p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & p[0] & cin);
assign c[7] = (g[7]) |
                (p[7] & g[6]) |
                (p[7] & p[6] & g[5]) |
                (p[7] & p[6] & p[5] & g[4]) | 
                (p[7] & p[6] & p[5] & p[4] & g[3]) | 
                (p[7] & p[6] & p[5] & p[4] & p[3] & g[2]) | 
                (p[7] & p[6] & p[5] & p[4] & p[3] & p[2] & g[1]) | 
                (p[7] & p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & g[0]) | 
                (p[7] & p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & p[0] & cin);
//

generate
    genvar j;
    for (j = 1; j <= 7; j=j+1) begin : block_FA_1_7
        FA u_FA_1_7 (
            .a      (a[j]),
            .b      (b[j]),
            .cin    (c[j-1]),
            .sum    (sum[j]),
            .cout   ()
        );
    end
    FA u_FA_0 (
        .a      (a[0]),
        .b      (b[0]),
        .cin    (cin),
        .sum    (sum[0]),
        .cout   ()
    );
endgenerate

assign cout = c[7];

endmodule

module CLA4 (
    input   [3:0]  a,  
    input   [3:0]  b,  
    input          cin,
    output  [3:0]  sum,
    output         cout
);

wire [3:0] g;
wire [3:0] p;
wire [3:0] c;

// Carry Lookahead Generator (CLG)
generate
    genvar i;
    for (i = 0; i <= 3; i=i+1) begin : block_CLG
        assign g[i] = a[i] & b[i];
        assign p[i] = a[i] | b[i];
    end
endgenerate

assign c[0] = (g[0]) | 
                (p[0] & cin);
assign c[1] = (g[1]) | 
                (p[1] & g[0]) | 
                (p[1] & p[0] & cin);
assign c[2] = (g[2]) | 
                (p[2] & g[1]) | 
                (p[2] & p[1] & g[0]) | 
                (p[2] & p[1] & p[0] & cin);
assign c[3] = (g[3]) | 
                (p[3] & g[2]) | 
                (p[3] & p[2] & g[1]) | 
                (p[3] & p[2] & p[1] & g[0]) | 
                (p[3] & p[2] & p[1] & p[0] & cin);
//

generate
    genvar j;
    for (j = 1; j <= 3; j=j+1) begin : block_FA_1_3
        FA u_FA_1_3 (
            .a      (a[j]),
            .b      (b[j]),
            .cin    (c[j-1]),
            .sum    (sum[j]),
            .cout   ()
        );
    end
    FA u_FA_0 (
        .a      (a[0]),
        .b      (b[0]),
        .cin    (cin),
        .sum    (sum[0]),
        .cout   ()
    );
endgenerate

assign cout = c[3];

endmodule

