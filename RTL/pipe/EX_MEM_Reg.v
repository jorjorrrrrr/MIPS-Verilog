// ======================================================================
//
// Module Name  : EX/MEM Register
// 
// Author       : jorjor
// Created Date : 2025.03.28
//
// ======================================================================

`timescale 1ns/100ps

module EX_MEM_Reg (
    input           clk,
    input           rst,
    input   [11:0]  ID_EX_mem,
    input   [9:0]   ID_EX_wb,
    output  [11:0]  EX_MEM_mem,
    output  [9:0]   EX_MEM_wb
);

reg [11:0] mem_r;
reg [9:0]  wb_r;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        mem_r <= 11'b0;
        wb_r  <= 7'b0;
    end
    else begin
        mem_r <= ID_EX_mem;
        wb_r  <= ID_EX_wb;
    end
end

assign EX_MEM_mem = mem_r;
assign EX_MEM_wb  = wb_r;

endmodule
