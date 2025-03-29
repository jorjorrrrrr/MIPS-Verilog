// ======================================================================
//
// Module Name  : MEM/WB Register
// 
// Author       : jorjor
// Created Date : 2025.03.28
//
// ======================================================================

`timescale 1ns/100ps

module MEM_WB_Reg (
    input           clk,
    input           rst,
    input   [9:0]   EX_MEM_wb,
    output  [9:0]   MEM_WB_wb
);

reg [9:0]  wb_r;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        wb_r  <= 10'b0;
    end
    else begin
        wb_r  <= EX_MEM_wb;
    end
end

assign MEM_WB_wb  = wb_r;

endmodule
