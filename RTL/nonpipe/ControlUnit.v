// ======================================================================
//
// Module Name  : Control Unit
// Function Descriptions:
//  1. Control overall datapath
// 
// Author       : jorjor
// Created Date : 2025.03.18
//
// ======================================================================

`timescale 1ns/100ps

`include "../../RTL/def/def_data_type.v"
`include "../../RTL/def/def_inst.v"
`include "../../RTL/def/def_inst_type.v"

module ControlUnit (
    input       [5:0]   op,
    input       [5:0]   funct,
    input               alu_zero,           // Zero detection
    input               alu_overflow,       // Overflow detection
    output reg  [2:0]   sel_rf_wdata,       // Selection for wdata of Register File
    output reg  [1:0]   sel_rf_waddr,
    output              rf_wen,
    output reg  [5:0]   alu_op,
    output reg  [1:0]   sel_alu_b,
    output              dm_wen,
    output reg  [1:0]   dm_type,
    output              dm_sign_extend,
    output              md_is_mult,
    output              md_is_unsigned,
    output              lhr_wen,
    output              lhr_ren,
    output              lhr_is_hi,
    output              branch_beq,
    output              branch_bne,
    output              jump,
    output              jump_reg,
    output              syscall
);

reg  [1:0] inst_type;

wire set_load; 
wire set_lui;
wire set_jal;

wire set_imm;
wire zero_extend;
wire set_shamt;

//// Determine the type of instruction and decide the operations ////
always @(*) begin
    if (op == 6'b000000 && funct == 6'b001100) begin
        inst_type = `SYSCALL;
    end
    else if (op == 6'b000000) begin
        inst_type = `R_TYPE;
    end
    else if (op == `J || op == `JAL) begin
        inst_type = `J_TYPE;
    end
    else begin
        inst_type = `I_TYPE;
    end
end

//// Register File ////
assign set_load = (op == `LW)   |
                    (op == `LB)     |
                    (op == `LBU)    |
                    (op == `LH)     |
                    (op == `LHU)
                    ;
assign set_lui = (op == `LUI);
assign set_jal = (op == `JAL);
assign set_mflh = (inst_type == `R_TYPE) & (
                        (funct == `MFHI)     | 
                        (funct == `MFLO)
                    );

always @(*) begin
    case(1'b1)
        set_load: sel_rf_wdata = 3'b000; // Load data from Data Memory
        set_lui : sel_rf_wdata = 3'b001; // Load data from immediate
        set_jal : sel_rf_wdata = 3'b010; // Load data to $ra
        set_mflh: sel_rf_wdata = 3'b011; // Load data from Lo/Hi Register
        default : sel_rf_wdata = 3'b100; // Load alu result
    endcase
end

always @(*) begin
    case(1'b1)
        (inst_type == `R_TYPE)  : sel_rf_waddr = 2'b00; // R-type
        (op == `JAL)            : sel_rf_waddr = 2'b01; // `JAL
        default                 : sel_rf_waddr = 2'b10; // I-type
    endcase
end

assign rf_wen = (inst_type == `R_TYPE)  | 
                (op == `JAL)            | 
                (op == `LW)             | 
                (op == `LB)             |
                (op == `LBU)            |
                (op == `LH)             |
                (op == `LHU)            |
                (op == `LUI)            |
                (op == `ANDI )          | 
                (op == `ORI  )          | 
                (op == `ADDI )          | 
                (op == `ADDIU)          | 
                (op == `XORI )          | 
                (op == `SLTI )          | 
                (op == `SLTIU);

//// ALU ////
always @(*) begin
    if (inst_type == `R_TYPE) begin
        case(funct)
            `AND    : alu_op = 6'b000000;
            `OR     : alu_op = 6'b000001;
            `SLL    : alu_op = 6'b000101;
            `SRA    : alu_op = 6'b000110;
            `SRL    : alu_op = 6'b000111;
            `ADD    : alu_op = 6'b000010;
            `ADDU   : alu_op = 6'b100010;
            `SUB    : alu_op = 6'b001010;
            `SUBU   : alu_op = 6'b101010;
            `XOR    : alu_op = 6'b000100;
            `SLT    : alu_op = 6'b001011;
            `SLTU   : alu_op = 6'b101011;
            `NOR    : alu_op = 6'b011000;
            default : begin
                //if (funct != 6'hC) begin
                //    $display("Invalid ALUop (op=%6b)", op); 
                //    $display("Invalid ALUop (funct=%6b)", funct); 
                //end
                alu_op = 5'b00000;
            end
        endcase
    end
    else begin
        case(op)
            `ANDI   : alu_op = 6'b000000;
            `ORI    : alu_op = 6'b000001;
            `ADDI   : alu_op = 6'b000010;
            `ADDIU  : alu_op = 6'b100010;
            `XORI   : alu_op = 6'b000100;
            `SLTI   : alu_op = 6'b001011;
            `SLTIU  : alu_op = 6'b101011;
            `BEQ    : alu_op = 6'b001010; // check zero signal from ALU
            `BNE    : alu_op = 6'b001010; // check zero signal from ALU
            `LW     : alu_op = 6'b000010; // address add offset
            `LB     : alu_op = 6'b000010; // address add offset
            `LBU    : alu_op = 6'b000010; // address add offset
            `LH     : alu_op = 6'b000010; // address add offset
            `LHU    : alu_op = 6'b000010; // address add offset
            `SW     : alu_op = 6'b000010; // address add offset
            `SB     : alu_op = 6'b000010; // address add offset
            `SH     : alu_op = 6'b000010; // address add offset
            default : begin
                //if (op != `LUI && op != `J && op != `JAL) begin
                //    $display("Invalid ALUop (op=%6b)", op); 
                //end
                alu_op = 5'b00000;
            end
        endcase
    end
end

always @(*) begin
    case(1'b1)
        (set_imm && zero_extend) : sel_alu_b = 2'b00;
        (set_imm)                : sel_alu_b = 2'b01;
        (set_shamt)              : sel_alu_b = 2'b10;
        default                  : sel_alu_b = 2'b11;
    endcase
end

assign set_imm = (inst_type == `I_TYPE) & (
                             (op == `LW)    |
                             (op == `LB)    |
                             (op == `LBU)   |
                             (op == `LH)    |
                             (op == `LHU)   |
                             (op == `SW)    |
                             (op == `SB)    |
                             (op == `SH)    |
                             (op == `ADDI)  |
                             (op == `ADDIU) |
                             (op == `ANDI)  |
                             (op == `ORI)   |
                             (op == `XORI)  |
                             (op == `SLTI)  |
                             (op == `SLTIU)
                         ); 

assign zero_extend = (inst_type == `I_TYPE) & (
                             (op == `ANDI)  | 
                             (op == `ORI)   | 
                             (op == `XORI)
                         );

assign set_shamt = (inst_type == `R_TYPE) & (
                        (funct == `SLL) | 
                        (funct == `SRA) | 
                        (funct == `SRL)
                    );

//// Data Memory ////
assign dm_wen = (op == `SW) | (op == `SB) | (op == `SH);
always @(*) begin
    case(op)
        `LB, `LBU, `SB  : dm_type = `BYTE_TYPE;
        `LH, `LHU, `SH  : dm_type = `HALF_TYPE;
        default         : dm_type = `WORD_TYPE; // `LW or `SW
    endcase
end
assign dm_sign_extend = (op == `LB) || (op == `LH);

//// Multiplication/Division Processor ////
assign md_is_mult = (inst_type == `R_TYPE) & ((funct == `MULT) | (funct == `MULTU));
assign md_is_unsigned = (inst_type == `R_TYPE) & ((funct == `DIVU) | (funct == `MULTU));

//// Lo/Hi Register ////
assign lhr_wen = (inst_type == `R_TYPE) & (
                        (funct == `MULT)    | 
                        (funct == `MULTU)   |
                        (funct == `DIV)     | 
                        (funct == `DIVU)
                    );

assign lhr_ren = (inst_type == `R_TYPE) & (
                        (funct == `MFHI)     | 
                        (funct == `MFLO)
                    );

assign lhr_is_hi = (inst_type == `R_TYPE) & (funct == `MFHI);

//// Branch (BEQ, BNE) ////
assign branch_beq = (op == `BEQ);
assign branch_bne = (op == `BNE);

//// Jump (J, JAL, JR) ////
assign jump = (inst_type == `J_TYPE);
assign jump_reg = (inst_type == `R_TYPE) & (funct == `JR); 

//// System Call ////
assign syscall = (inst_type == `SYSCALL);

endmodule
