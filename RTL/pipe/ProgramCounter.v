// ======================================================================
//
// Module Name  : Program Counter
// Function Descriptions:
//  1. Always plus 4 for fetching instructions
// 
// Author       : jorjor
// Created Date : 2025.03.18
//
// ======================================================================

`timescale 1ns/100ps


module ProgramCounter (
    input           clk,          // Clock Source
    input           rst,          // Active high async reset
    input           branch,       // Branch enable 
    input           jump,         // j or jal
    input           jump_reg,     // jr
    input   [31:0]  pc_plus_4,    // PC <= PC + 4
    input   [31:0]  pc_plus_4_imm,// PC <= PC + 4 + (imm*4)
    input   [25:0]  tar_addr,     // Target address
    input   [31:0]  tar_reg_addr, // Target address from register file
    output  [31:0]  pc_next       // Next PC
);

reg  [31:0] pc_reg;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        pc_reg <= 32'b0;
    end
    else begin
        if (jump_reg) begin
            pc_reg <= tar_reg_addr;
        end
        else if (jump) begin
            pc_reg <= {pc_next[31:28], 6'b0, tar_addr[19:0], 2'b0};
            // Offical Version: pc_reg = {pc_next[31:28], target_addr, 2'b0};
        end
        else if (branch) begin
            pc_reg <= pc_plus_4_imm;
        end
        else begin
            pc_reg <= pc_plus_4;
        end
    end
end

assign pc_next = pc_reg;

endmodule

