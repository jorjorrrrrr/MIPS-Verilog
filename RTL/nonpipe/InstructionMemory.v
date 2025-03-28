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
    input   [31:0]  addr,   // Read address (4 Giga btye)
    output  [31:0]  inst    // Instruction
);

localparam DEPTH = (1 << 12);

reg [31:0] mem [0:DEPTH-1];

assign inst = mem[addr[13:2]];

endmodule
