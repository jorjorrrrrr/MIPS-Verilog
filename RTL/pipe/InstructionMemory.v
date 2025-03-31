// ======================================================================
//
// Module Name  : Instruction Memory
// Function Descriptions:
//  1. Initialize memory via loading instruction.dat
//  2. Each instruction is fetched according to PC 
// 
// Author       : jorjor
// Created Date : 2025.03.18
//
// ======================================================================

`timescale 1ns/100ps


module InstructionMemory (
    input           clk,    // Clock Source
    input           rst,
    input           clr,
    input           hold,   // eliminate data hazard (stall method)
    input   [31:0]  addr,   // Read address (4 Giga btye)
    output  [31:0]  inst    // Instruction
);

localparam DEPTH = (1 << 12);

reg [31:0] mem [0:DEPTH-1];
reg [31:0] inst_reg;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        inst_reg <= 32'b0;
    end
    else begin
        if (clr) begin
            inst_reg <= 32'b0;
        end
        else if (hold) begin
            inst_reg <= inst_reg;
        end
        else begin
            inst_reg <= mem[addr[13:2]];
        end
    end
end

assign inst = inst_reg;
//assign inst = mem[addr[13:2]];

endmodule
