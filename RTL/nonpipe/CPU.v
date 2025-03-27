// ======================================================================
//
// Module Name  : CPU
// 
// Author       : jorjor
// Created Date : 2025.03.18
//
// ======================================================================

`timescale 1ns/100ps


module CPU (
    input   clk,        // Clock Source
    input   rst,        // Active high async reset
    output  overflow
);

// ======================================================
// For decoding instruction
wire [5:0] op;
wire [4:0] rs;
wire [4:0] rt;
wire [4:0] rd;
wire [4:0] shamt;
wire [5:0] funct;
wire [15:0] immediate;
wire [25:0] target_address;
// ======================================================
// The signals of Program Counter
wire [31:0] target_reg_address;
wire [31:0] pc_plus_4;
wire [31:0] pc_plus_4_imm;
wire [31:0] pc_next;
// ======================================================
// The signals of Instruction Memory
wire [31:0] inst;
// ======================================================
// The signals of Register File
//wire        rf_wen; // controlled by Control Unit
reg  [31:0] rf_wdata;
reg  [4:0]  rf_waddr;
wire [4:0]  rf_raddr0;
wire [4:0]  rf_raddr1;
wire [31:0] rf_a;
wire [31:0] rf_b;
// ======================================================
// The signals of Arithmetic Logic Unit
wire [31:0] alu_a;
reg  [31:0] alu_b;
wire        alu_zero; 
wire        alu_overflow;
wire [31:0] alu_result; 
// ======================================================
// The signals of Data memory
wire [31:0] dm_addr; 
wire [31:0] dm_wdata;
wire [31:0] dm_rdata; 
//wire        dm_wen; // controlled by Control Unit
//wire [1:0]  dm_type; // controlled by Control Unit
//wire        dm_sign_extend; // controlled by Control Unit
wire [31:0] dm_data;
// ======================================================
// The signals of Multiplication/Division Processor
wire [31:0] md_a;
wire [31:0] md_b;
//wire        md_is_mult; // controlled by Control Unit
//wire        md_is_unsigned; // controlled by Control Unit
wire [63:0] md_result;
// ======================================================
// The signals of Lo/Hi Register
wire [63:0] lhr_p;
wire        lhr_is_mult;
//wire        lhr_wen; // controlled by Control Unit
//wire        lhr_ren; // controlled by Control Unit
//wire        lhr_is_hi; // controlled by Control Unit
wire [31:0] lhr_rdata;
// ======================================================
// The signals of Control Unit
wire [2:0]  sel_rf_wdata;       // Selection for wdata of Register File
wire [1:0]  sel_rf_waddr;
wire        rf_wen;
wire [5:0]  alu_op;
wire [1:0]  sel_alu_b;    // Selection for ALU input b
wire        dm_wen;
wire [1:0]  dm_type;
wire        dm_sign_extend;
wire        md_is_mult;
wire        md_is_unsigned;
wire        lhr_wen;
wire        lhr_ren;
wire        lhr_is_hi;
wire        branch;
wire        jump;
wire        jump_reg;


// ******************************************************
// ** Decode Instruction ** //
// R-type : op || rs || rt || rd || shamt || funct
// example. add rd, rs, rt
assign op = inst[31:26];
assign rs = inst[25:21];
assign rt = inst[20:16];
assign rd = inst[15:11];
assign shamt = inst[10:6];
assign funct = inst[5:0];

// I-type : op || rs || rt || immediate
// exmaple. lw rt, rs, imm
// example. addi rt, rs, imm
//assign op = inst[31:26];
//assign rs = inst[25:21];
//assign rt = inst[20:16];
assign immediate = inst[15:0];

// J-type : op || target address
// example. j target
//assign op = inst[31:26];
assign target_address = inst[25:0];


// ******************************************************
// ** Program Counter ** //
assign pc_plus_4 = pc_next + 32'd4;
assign pc_plus_4_imm = pc_plus_4 + {{14{immediate[15]}}, immediate[15:0], 2'b00};
assign target_reg_address = rf_a;

ProgramCounter u_PC (
    // input
    .clk            (clk),  
    .rst            (rst),
    .jump           (jump),
    .jump_reg       (jump_reg),
    .branch         (branch),
    .pc_plus_4      (pc_plus_4),
    .pc_plus_4_imm  (pc_plus_4_imm),
    .tar_addr       (target_address),
    .tar_reg_addr   (target_reg_address),
    // output
    .pc_next        (pc_next)
);


// ******************************************************
// ** Instruction Memory ** //
InstructionMemory u_IM (
    // input
    .clk    (clk), 
    .addr   (pc_next),
    // output
    .inst   (inst) 
);

// ******************************************************
// ** Register File ** //
always @(*) begin
    case(sel_rf_wdata)
        3'b000  : rf_wdata = dm_data;            // Load data from Data Memory
        3'b001  : rf_wdata = {immediate, 16'b0}; // Load data from immediate
        3'b010  : rf_wdata = pc_plus_4;          // Load data to $ra
        3'b011  : rf_wdata = lhr_rdata;          // Load data from Lo/Hi Register
        default : rf_wdata = alu_result;         // Load alu result
    endcase
end

always @(*) begin
    case(sel_rf_waddr)
        2'b00   : rf_waddr = rd;    // R-type
        2'b01   : rf_waddr = 5'd31; // `JAL
        default : rf_waddr = rt;    // I-type
    endcase
end

assign rf_raddr0 = rs;
assign rf_raddr1 = rt;

RegisterFile u_RF (
    // input
    .clk    (clk),   
    .rst    (rst),   
    .wen    (rf_wen),   
    .wdata  (rf_wdata), 
    .waddr  (rf_waddr), 
    .raddr0 (rf_raddr0),
    .raddr1 (rf_raddr1),
    // output
    .rdata0 (rf_a),
    .rdata1 (rf_b)
);

// ******************************************************
// ** Arthimetic Logic Unit ** //
assign alu_a = (sel_alu_b == 2'b10) ? rf_b : rf_a;
always @(*) begin
    case(sel_alu_b)
        2'b00 : alu_b = {16'b0, immediate};
        2'b01 : alu_b = {{16{immediate[15]}}, immediate};
        2'b10 : alu_b = {27'b0, shamt};
        default : alu_b = rf_b;
    endcase
end

ArthimeticLogicUnit u_ALU (
    // input
    .a          (alu_a),       
    .b          (alu_b),       
    .ALUop      (alu_op),   
    // output
    .zero       (alu_zero),    
    .overflow   (alu_overflow),
    .result     (alu_result)   
);

// ******************************************************
// ** Data Memory ** //
assign dm_addr = alu_result;
// TODO : temporarily ignore input/output swap
//assign dm_wdata = {rf_b[7:0], rf_b[15:8], rf_b[23:16], rf_b[31:24]};                // input_swap
//assign dm_data = {dm_rdata[7:0], dm_rdata[15:8], dm_rdata[23:16], dm_rdata[31:24]}; // output_swap
assign dm_wdata = rf_b;
assign dm_data = dm_rdata;

DataMemory u_DM (
    // input
    .clk        (clk),   
    .wen        (dm_wen),
    .rwtype     (dm_type),
    .addr       (dm_addr),   
    .wdata      (dm_wdata),  
    .sign_extend(dm_sign_extend),
    // output
    .rdata      (dm_rdata) 
);

// ******************************************************
// ** Multiplication/Division Processor ** //
assign md_a = rf_a;
assign md_b = rf_b;

MultDiv u_MD (
    // input
    .a          (md_a),          
    .b          (md_b),          
    .is_mult    (md_is_mult),    
    .is_unsigned(md_is_unsigned),
    // output
    .result     (md_result)
);

// ******************************************************
// ** Lo/Hi Register ** //
assign lhr_p = md_result;
assign lhr_is_mult = md_is_mult;

LoHiRegister u_LHR (
    // input
    .clk    (clk),
    .rst    (rst),
    .p      (lhr_p),      
    .is_mult(lhr_is_mult),
    .wen    (lhr_wen),    
    .ren    (lhr_ren),    
    .is_hi  (lhr_is_hi),  
    // output
    .rdata  (lhr_rdata)   
);

// ******************************************************
// ** Control Unit ** //
ControlUnit u_CU (
    // input
    .op             (op),
    .funct          (funct),
    .alu_zero       (alu_zero),
    .alu_overflow   (alu_overflow),
    // output
    .sel_rf_wdata   (sel_rf_wdata),       // Selection for wdata of Register File
    .sel_rf_waddr   (sel_rf_waddr),
    .rf_wen         (rf_wen),
    .alu_op         (alu_op),
    .sel_alu_b      (sel_alu_b),        // Selection for ALU input b
    .dm_wen         (dm_wen),
    .dm_type        (dm_type),
    .dm_sign_extend (dm_sign_extend),
    .md_is_mult     (md_is_mult),    
    .md_is_unsigned (md_is_unsigned),
    .lhr_wen        (lhr_wen),    
    .lhr_ren        (lhr_ren),    
    .lhr_is_hi      (lhr_is_hi),
    .branch         (branch),
    .jump           (jump),
    .jump_reg       (jump_reg),
    .overflow       (overflow)
);

endmodule

