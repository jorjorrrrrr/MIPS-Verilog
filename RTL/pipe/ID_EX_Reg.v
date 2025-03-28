// ======================================================================
//
// Module Name  : ID/EX Register
// 
// Author       : jorjor
// Created Date : 2025.03.18
//
// ======================================================================

`timescale 1ns/100ps

module ID_EX_Reg (
    input           clk,
    input           rst,
    input           clr,
    input   [9:0]   cu_ex,
    input   [10:0]  cu_mem,
    input   [6:0]   cu_wb,
    output  [9:0]   ID_EX_ex,
    output  [10:0]  ID_EX_mem,
    output  [6:0]   ID_EX_wb
);

reg [9:0]   ex_reg;
reg [10:0]  mem_reg;
reg [6:0]   wb_reg;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        ex_reg  <= 10'b0;
        mem_reg <= 11'b0;
        wb_reg  <= 7'b0;
    end
    else if (clr) begin
        ex_reg  <= 10'b0;
        mem_reg <= 11'b0;
        wb_reg  <= 7'b0;
    end
    else begin
        ex_reg  <= cu_ex;
        mem_reg <= cu_mem;
        wb_reg  <= cu_wb;
    end
end

assign ID_EX_ex  = ex_reg;
assign ID_EX_mem = mem_reg;
assign ID_EX_wb  = wb_reg;

//reg  [5:0]  alu_op;
//reg  [1:0]  sel_alu_b;
//wire        md_is_mult;
//wire        md_is_unsigned;
//// MEM
//wire        branch_beq;
//wire        branch_bne;
//wire        jump;
//wire        jump_reg;
//wire        dm_wen;
//reg  [1:0]  dm_type;
//wire        dm_sign_extend;
//wire        lhr_wen;
//wire        lhr_ren;
//wire        lhr_is_hi;
//// WB
//reg  [2:0]  sel_rf_wdata;
//reg  [1:0]  sel_rf_waddr;
//wire        rf_wen;
//wire        syscall;

endmodule
