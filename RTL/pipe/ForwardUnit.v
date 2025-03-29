// ======================================================================
//
// Module Name  : Forward Unit
// 
// Author       : jorjor
// Created Date : 2025.03.29
//
// ======================================================================

`timescale 1ns/100ps

module ForwardUnit (
    // from EX
    input       [4:0] rf_raddr0_EX,   // the address of rf_a
    input       [4:0] rf_raddr1_EX,   // the address of rf_b
    // from MEM
    input             rf_wen_MEM,
    input       [4:0] rf_waddr_MEM,
    // from WB
    input             rf_wen_WB,
    input       [4:0] rf_waddr_WB,
    
    output reg  [1:0] sel_rf_a,
    output reg  [1:0] sel_rf_b
);

// (sel == 2'b00) : input = original
// (sel == 2'b01) : input = from MEM
// (sel == 2'b10) : input = from WB

always @(*) begin
    if (rf_wen_MEM && (rf_raddr0_EX == rf_waddr_MEM)) begin
        sel_rf_a = 2'b01;
    end
    else if (rf_wen_WB && (rf_raddr0_EX == rf_waddr_WB)) begin
        sel_rf_a = 2'b10;
    end
    else begin
        sel_rf_a = 2'b00;
    end
end

always @(*) begin
    if (rf_wen_MEM && (rf_raddr1_EX == rf_waddr_MEM)) begin
        sel_rf_b = 2'b01;
    end
    else if (rf_wen_WB && (rf_raddr1_EX == rf_waddr_WB)) begin
        sel_rf_b = 2'b10;
    end
    else begin
        sel_rf_b = 2'b00;
    end
end

endmodule
