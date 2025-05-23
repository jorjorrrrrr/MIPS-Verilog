// ======================================================================
//
// Module Name  : ID/EX Register
// 
// Author       : jorjor
// Created Date : 2025.03.28
//
// ======================================================================

`timescale 1ns/100ps

module ID_EX_Reg (
    input           clk,
    input           rst,
    input           clr,
    // From Control Unit
    input   [2:0]   sel_rf_wdata,
    input   [4:0]   rf_waddr,
    input           rf_wen,
    input   [5:0]   alu_op,
    input   [1:0]   sel_alu_b,
    input           dm_ren,
    input           dm_wen,
    input   [1:0]   dm_type,
    input           dm_sign_extend,
    input           md_is_mult,
    input           md_is_unsigned,
    input           lhr_is_mult,
    input           lhr_wen,
    input           lhr_ren,
    input           lhr_is_hi,
    input           branch_beq,
    input           branch_bne,
    input           jump,
    input           jump_reg,
    input           syscall,
    
    output  [9:0]   ID_EX_ex,
    output  [12:0]  ID_EX_mem,
    output  [9:0]   ID_EX_wb
);

wire [9:0]  ex;
wire [12:0] mem;
wire [9:0]  wb;

reg [9:0]   ex_r;
reg [12:0]  mem_r;
reg [9:0]   wb_r;

// // EX
// [5:0] alu_op;
// [1:0] sel_alu_b;
//       md_is_mult;
//       md_is_unsigned;
// // MEM
//       branch_beq;
//       branch_bne;
//       jump;
//       jump_reg;
//       dm_ren;
//       dm_wen;
// [1:0] dm_type;
//       dm_sign_extend;
//       lhr_is_mult;
//       lhr_wen;
//       lhr_ren;
//       lhr_is_hi;
// // WB
// [2:0] sel_rf_wdata;
// [4:0] rf_waddr;
//       rf_wen;
//       syscall;

assign ex = {alu_op,
                sel_alu_b,
                md_is_mult,
                md_is_unsigned};

assign mem = {branch_beq,
                branch_bne,
                jump,
                jump_reg,
                dm_ren,
                dm_wen,
                dm_type,
                dm_sign_extend,
                lhr_is_mult,
                lhr_wen,
                lhr_ren,
                lhr_is_hi};

assign wb = {sel_rf_wdata,
                rf_waddr,
                rf_wen,
                syscall};

always @(posedge clk or posedge rst) begin
    if (rst) begin
        ex_r  <= 10'b0;
        mem_r <= 13'b0;
        wb_r  <= 10'b0;
    end
    else if (clr) begin
        ex_r  <= 10'b0;
        mem_r <= 13'b0;
        wb_r  <= 10'b0;
    end
    else begin
        ex_r  <= ex;
        mem_r <= mem;
        wb_r  <= wb;
    end
end

assign ID_EX_ex  = ex_r;
assign ID_EX_mem = mem_r;
assign ID_EX_wb  = wb_r;

endmodule
