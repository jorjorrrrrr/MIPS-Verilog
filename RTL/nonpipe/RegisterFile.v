// ======================================================================
//
// Module Name  : Register File
// Function Descriptions:
//  1. Always read 2 data
//  2. When wen is set to 1, the value at address waddr is overwritten
//      by wdata
// 
// Author       : jorjor
// Created Date : 2025.03.18
//
// ======================================================================

`timescale 1ns/100ps


module RegisterFile (
    input           clk,        // Clock Source
    input           rst,        // Active high async reset
    input           wen,        // Active high write enable
    input   [31:0]  wdata,      // Write data
    input   [4:0]   waddr,      // Write address
    input   [4:0]   raddr0,     // Read address 0
    input   [4:0]   raddr1,     // Read address 1
    output  [31:0]  rdata0,     // Read data 0
    output  [31:0]  rdata1      // Read data 1
);

reg [31:0] register [0:31];

assign rdata0 = register[raddr0];
assign rdata1 = register[raddr1];

always @(posedge clk or posedge rst) begin
    if (rst) begin
        register[0] <= 32'b0;
        register[1] <= 32'b0;
        register[2] <= 32'b0;
        register[3] <= 32'b0;
        register[4] <= 32'b0;
        register[5] <= 32'b0;
        register[6] <= 32'b0;
        register[7] <= 32'b0;
        register[8] <= 32'b0;
        register[9] <= 32'b0;
        register[10] <= 32'b0;
        register[11] <= 32'b0;
        register[12] <= 32'b0;
        register[13] <= 32'b0;
        register[14] <= 32'b0;
        register[15] <= 32'b0;
        register[16] <= 32'b0;
        register[17] <= 32'b0;
        register[18] <= 32'b0;
        register[19] <= 32'b0;
        register[20] <= 32'b0;
        register[21] <= 32'b0;
        register[22] <= 32'b0;
        register[23] <= 32'b0;
        register[24] <= 32'b0;
        register[25] <= 32'b0;
        register[26] <= 32'b0;
        register[27] <= 32'b0;
        register[28] <= 32'b0;
        register[29] <= 32'b0;
        register[30] <= 32'b0;
        register[31] <= 32'b0;
    end
    else begin
        if (wen && (waddr != 5'd0)) begin
            register[waddr] <= wdata; 
        end
    end
end

endmodule

