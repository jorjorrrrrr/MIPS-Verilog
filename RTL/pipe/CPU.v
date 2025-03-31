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
    output  overflow,
    output  syscall
);

// ======================================================
// The signals of Program Counter
wire        branch; // generated after alu calculation
wire        jump;
wire        jump_reg;
wire [31:0] target_reg_address;
wire [31:0] pc_plus_4;
wire [31:0] pc_plus_4_imm;
wire [31:0] pc_next;
// ======================================================
// The signals for IF/ID stage
reg  [31:0] pc_plus_4_ID;
// ======================================================
// The signals of Instruction Memory
wire [31:0] inst;
// For decoding instruction
//wire [5:0]  op;
wire [4:0]  rs;
wire [4:0]  rt;
wire [4:0]  rd;
wire [4:0]  shamt;
//wire [5:0]  funct;
wire [15:0] imm;
wire [25:0] target_address;
// ======================================================
// The signal of Hazard Detection Unit
wire        PC_hold;
wire        IM_hold;
wire        ID_EX_clr;
// ======================================================
// The signals of Control Unit
wire [2:0]  cu_sel_rf_wdata;
wire [4:0]  cu_rf_waddr;
wire        cu_rf_wen;
wire [5:0]  cu_alu_op;
wire [1:0]  cu_sel_alu_b;    // Selection for ALU input b
wire        cu_dm_ren;
wire        cu_dm_wen;
wire [1:0]  cu_dm_type;
wire        cu_dm_sign_extend;
wire        cu_md_is_mult;
wire        cu_md_is_unsigned;
wire        cu_lhr_is_mult;
wire        cu_lhr_wen;
wire        cu_lhr_ren;
wire        cu_lhr_is_hi;
wire        cu_branch_beq;
wire        cu_branch_bne;
wire        cu_jump;
wire        cu_jump_reg;
wire        cu_syscall;
// ======================================================
// The signals of Register File
wire [2:0]  sel_rf_wdata;   // controlled by Control Unit
wire [1:0]  sel_rf_waddr;   // controlled by Control Unit 
wire        rf_wen;         // controlled by Control Unit
reg  [31:0] rf_wdata;
wire [4:0]  rf_waddr;
wire [4:0]  rf_raddr0;
wire [4:0]  rf_raddr1;
wire [31:0] rf_a;
wire [31:0] rf_b;
// ======================================================
// The signals of Forward Unit
wire [1:0]  sel_rf_a;
wire [1:0]  sel_rf_b;
reg  [31:0] rf_a_f; // rf_a after forwarding
reg  [31:0] rf_b_f; // rf_b after forwarding
// ======================================================
// The signals of ID/EX Register
wire [9:0]  ID_EX_ex;
wire [12:0] ID_EX_mem;
wire [9:0]  ID_EX_wb;
// ======================================================
// The signals for ID/EX stage
reg  [4:0]  rs_EX;
reg  [4:0]  rt_EX;
reg  [4:0]  rd_EX;
reg  [4:0]  shamt_EX;
reg  [15:0] imm_EX;
reg  [25:0] target_address_EX;
reg  [31:0] rf_a_EX;
reg  [31:0] rf_b_EX;
reg  [4:0]  rf_raddr0_EX;
reg  [4:0]  rf_raddr1_EX;
reg  [31:0] pc_plus_4_EX;
// EX control
wire [5:0]  alu_op_EX;
wire [1:0]  sel_alu_b_EX;
wire        md_is_mult_EX;
wire        md_is_unsigned_EX;
// MEM control
wire        dm_ren_EX;
// WB control
wire [2:0]  sel_rf_wdata_EX;
wire [4:0]  rf_waddr_EX;
wire        rf_wen_EX;
wire        syscall_EX;

// ======================================================
// The signals of Arithmetic Logic Unit
wire [31:0] alu_a;
reg  [31:0] alu_b;
wire [5:0]  alu_op;
wire [1:0]  sel_alu_b;      // Selection for ALU input b
wire        alu_zero; 
wire        alu_overflow;
wire [31:0] alu_result; 
// ======================================================
// The signals of Multiplication/Division Processor
wire [31:0] md_a;
wire [31:0] md_b;
wire        md_is_mult;     // controlled by Control Unit
wire        md_is_unsigned; // controlled by Control Unit
wire [63:0] md_result;
// ======================================================
// The signals of EX/MEM Register
wire [12:0] EX_MEM_mem;
wire [9:0]  EX_MEM_wb;
// ======================================================
// The signals for EX/MEM stage
reg  [4:0]  rs_MEM;
reg  [4:0]  rt_MEM;
reg  [4:0]  rd_MEM;
reg  [15:0] imm_MEM;
reg  [25:0] target_address_MEM;
reg  [31:0] rf_b_MEM;
reg  [31:0] pc_plus_4_MEM;
reg  [31:0] pc_plus_4_imm_MEM;
reg  [31:0] target_reg_address_MEM;
reg         alu_overflow_MEM;
reg         alu_zero_MEM; 
reg  [31:0] alu_result_MEM;
reg  [63:0] md_result_MEM;
// MEM control
wire        branch_beq_MEM;
wire        branch_bne_MEM;
wire        jump_MEM;
wire        jump_reg_MEM;
wire        dm_ren_MEM;
wire        dm_wen_MEM;
wire [1:0]  dm_type_MEM;
wire        dm_sign_extend_MEM;
wire        lhr_is_mult_MEM;
wire        lhr_wen_MEM;
wire        lhr_ren_MEM;
wire        lhr_is_hi_MEM;
// WB control
wire [2:0]  sel_rf_wdata_MEM;
wire [4:0]  rf_waddr_MEM;
wire        rf_wen_MEM;
wire        syscall_MEM;

// ======================================================
// The signals of Data memory
wire [31:0] dm_addr; 
wire [31:0] dm_wdata;
wire [31:0] dm_rdata; 
wire        dm_ren;         // controlled by Control Unit
wire        dm_wen;         // controlled by Control Unit
wire [1:0]  dm_type;        // controlled by Control Unit
wire        dm_sign_extend; // controlled by Control Unit
wire [31:0] dm_data;
// ======================================================
// The signals of Lo/Hi Register
wire [63:0] lhr_p;
wire        lhr_is_mult;
wire        lhr_wen;        // controlled by Control Unit
wire        lhr_ren;        // controlled by Control Unit
wire        lhr_is_hi;      // controlled by Control Unit
wire [31:0] lhr_rdata;
// ======================================================
// The signals of MEM/WB Register
wire [9:0]  MEM_WB_wb;
// ======================================================
// The signals for MEM/WB stage
reg  [4:0]  rt_WB;
reg  [4:0]  rd_WB;
reg  [15:0] imm_WB;
reg  [31:0] pc_plus_4_WB;
reg  [31:0] alu_result_WB;
reg  [31:0] dm_data_WB;
reg  [31:0] lhr_rdata_WB;
// WB control
wire [2:0]  sel_rf_wdata_WB;
wire [4:0]  rf_waddr_WB;
wire        rf_wen_WB;
wire        syscall_WB;


// ******************************************************
// ** Program Counter ** //

// ########################## //
// ## operated at WB stage ## //
//assign pc_plus_4_imm = pc_plus_4 + {{14{imm[15]}}, imm[15:0], 2'b00};
//assign target_reg_address = rf_a;
// ########################## //

assign pc_plus_4 = pc_next + 32'd4;

ProgramCounter u_PC (
    // input
    .clk            (clk),  
    .rst            (rst),
    .hold           (PC_hold),  // eliminate data hazard (stall method)
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
    .rst    (rst),
    .clr    (clr),
    .hold   (IM_hold),  // eliminate data hazard (stall method)
    .addr   (pc_next),
    // output
    .inst   (inst) 
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        pc_plus_4_ID <= 32'b0;
    end
    else begin
        pc_plus_4_ID <= pc_plus_4;
    end
end

// ----------------------------------------------------------------------------------------- //
// ----------------------------------------------------------------------------------------- //
// -------------------------------------- IF/ID stage -------------------------------------- //
// ----------------------------------------------------------------------------------------- //
// ----------------------------------------------------------------------------------------- //

// ** Decode Instruction ** //
// R-type : op || rs || rt || rd || shamt || funct
// example. add rd, rs, rt
//assign op = inst[31:26];
assign rs = inst[25:21];
assign rt = inst[20:16];
assign rd = inst[15:11];
assign shamt = inst[10:6];
//assign funct = inst[5:0];

// I-type : op || rs || rt || imm
// exmaple. lw rt, rs, imm
// example. addi rt, rs, imm
//assign op = inst[31:26];
//assign rs = inst[25:21];
//assign rt = inst[20:16];
assign imm = inst[15:0];

// J-type : op || target address
// example. j target
//assign op = inst[31:26];
assign target_address = inst[25:0];

// ******************************************************
// ** Hazard Detection Unit ** //
HazardDetectionUnit u_HDU (
    // input
    .rs_ID      (rs),
    .rt_ID      (rt),
    .dm_ren_EX  (dm_ren_EX), 
    .rt_EX      (rt_EX),
    // output 
    .PC_hold    (PC_hold),
    .IM_hold    (IM_hold),
    .ID_EX_clr  (ID_EX_clr)
);

assign equal    = ~|(rf_a_f ^ rf_b_f);
assign branch   = (equal & cu_branch_beq) | (~equal & cu_branch_bne); // used for Program Counter
assign jump     = cu_jump;
assign jump_reg = cu_jump_reg;

assign pc_plus_4_imm = pc_plus_4_ID + {{14{imm[15]}}, imm[15:0], 2'b00};
assign target_reg_address = rf_a_f;

assign clr = branch | jump | jump_reg;

// ******************************************************
// ** Control Unit ** //
ControlUnit u_CU (
    // input
    .inst           (inst),
    // output
    .sel_rf_wdata   (cu_sel_rf_wdata),       // Selection for wdata of Register File
    .rf_waddr       (cu_rf_waddr),
    .rf_wen         (cu_rf_wen),
    .alu_op         (cu_alu_op),
    .sel_alu_b      (cu_sel_alu_b),        // Selection for ALU input b
    .dm_ren         (cu_dm_ren),
    .dm_wen         (cu_dm_wen),
    .dm_type        (cu_dm_type),
    .dm_sign_extend (cu_dm_sign_extend),
    .md_is_mult     (cu_md_is_mult),    
    .md_is_unsigned (cu_md_is_unsigned),
    .lhr_is_mult    (cu_lhr_is_mult),
    .lhr_wen        (cu_lhr_wen),    
    .lhr_ren        (cu_lhr_ren),    
    .lhr_is_hi      (cu_lhr_is_hi),
    .branch_beq     (cu_branch_beq),
    .branch_bne     (cu_branch_bne),
    .jump           (cu_jump),
    .jump_reg       (cu_jump_reg),
    .syscall        (cu_syscall)
);

// ******************************************************
// ** Register File ** //

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
    .rdata0 (rf_a), // register out
    .rdata1 (rf_b)  // register out
);

// ******************************************************
// ** Forward Unit ** //
ForwardUnit u_FU (
    // input
    .rf_raddr0_ID   (rf_raddr0),
    .rf_raddr1_ID   (rf_raddr1),
    .rf_wen_EX      (rf_wen_EX),
    .rf_waddr_EX    (rf_waddr_EX),
    .rf_wen_MEM     (rf_wen_MEM),
    .rf_waddr_MEM   (rf_waddr_MEM),
    .rf_wen_WB      (rf_wen_WB),
    .rf_waddr_WB    (rf_waddr_WB),
    // output
    .sel_rf_a       (sel_rf_a),
    .sel_rf_b       (sel_rf_b)
);

// ** Forwarding the data ** //
always @(*) begin
    if (rf_raddr0 == 5'b0) begin    // If raddr == $zero, force it to zero
        rf_a_f = 32'b0;
    end
    else begin
        case(sel_rf_a)
            2'b01   : begin                 // from EX
                case(sel_rf_wdata_EX)
                    3'b001  : rf_a_f = {imm_EX, 16'b0};     // Load data from imm
                    3'b010  : rf_a_f = pc_plus_4_EX;        // Load data to $ra
                    default : rf_a_f = alu_result;          // Load alu result
                endcase
            end
            2'b10   : begin                 // from MEM
                case(sel_rf_wdata_MEM)
                    3'b000  : rf_a_f = dm_data;             // Load data from Data Memory
                    3'b001  : rf_a_f = {imm_MEM, 16'b0};    // Load data from imm
                    3'b010  : rf_a_f = pc_plus_4_MEM;       // Load data to $ra
                    3'b011  : rf_a_f = lhr_rdata;           // Load data from Lo/Hi Register
                    default : rf_a_f = alu_result_MEM;      // Load alu result
                endcase
            end
            2'b11   : rf_a_f = rf_wdata;    // from WB
            default : rf_a_f = rf_a;     // original
        endcase
    end
end

always @(*) begin
    if (rf_raddr1 == 5'b0) begin    // If raddr == $zero, force it to zero
        rf_b_f = 32'b0;
    end
    else begin
        case(sel_rf_b)
            2'b01   : begin                 // from EX
                case(sel_rf_wdata_EX)
                    3'b001  : rf_b_f = {imm_EX, 16'b0};     // Load data from imm
                    3'b010  : rf_b_f = pc_plus_4_EX;        // Load data to $ra
                    default : rf_b_f = alu_result;          // Load alu result
                endcase
            end
            2'b10   : begin                 // from MEM
                case(sel_rf_wdata_MEM)
                    3'b000  : rf_b_f = dm_data;             // Load data from Data Memory
                    3'b001  : rf_b_f = {imm_MEM, 16'b0};    // Load data from imm
                    3'b010  : rf_b_f = pc_plus_4_MEM;       // Load data to $ra
                    3'b011  : rf_b_f = lhr_rdata;           // Load data from Lo/Hi Register
                    default : rf_b_f = alu_result_MEM;      // Load alu result
                endcase
            end
            2'b11   : rf_b_f = rf_wdata;    // from WB
            default : rf_b_f = rf_b;     // original
        endcase
    end
end


// ******************************************************
// ** ID/EX Register ** //

ID_EX_Reg u_ID_EX_Reg (
    // input
    .clk            (clk),   
    .rst            (rst),   
    .clr            (ID_EX_clr),   // eliminate data hazard (stall method)
    .sel_rf_wdata   (cu_sel_rf_wdata),
    .rf_waddr       (cu_rf_waddr),
    .rf_wen         (cu_rf_wen),
    .alu_op         (cu_alu_op),
    .sel_alu_b      (cu_sel_alu_b),
    .dm_ren         (cu_dm_ren),
    .dm_wen         (cu_dm_wen),
    .dm_type        (cu_dm_type),
    .dm_sign_extend (cu_dm_sign_extend),
    .md_is_mult     (cu_md_is_mult),    
    .md_is_unsigned (cu_md_is_unsigned),
    .lhr_is_mult    (cu_lhr_is_mult),
    .lhr_wen        (cu_lhr_wen),    
    .lhr_ren        (cu_lhr_ren),    
    .lhr_is_hi      (cu_lhr_is_hi),
    .branch_beq     (cu_branch_beq),
    .branch_bne     (cu_branch_bne),
    .jump           (cu_jump),
    .jump_reg       (cu_jump_reg),
    .syscall        (cu_syscall),
    .ID_EX_ex       (ID_EX_ex),
    .ID_EX_mem      (ID_EX_mem),
    .ID_EX_wb       (ID_EX_wb)
);

// ******************************************************
// ** Pipeline Register ** //

always @(posedge clk or posedge rst) begin
    if (rst) begin
        rs_EX               <= 5'b0;
        rt_EX               <= 5'b0;
        rd_EX               <= 5'b0;
        shamt_EX            <= 5'b0;
        imm_EX              <= 16'b0;
        target_address_EX   <= 26'b0;
        rf_a_EX             <= 32'b0;
        rf_b_EX             <= 32'b0;
        rf_raddr0_EX        <= 5'b0;
        rf_raddr1_EX        <= 5'b0;
        pc_plus_4_EX        <= 32'b0;
    end
    else begin
        rs_EX               <= rs;
        rt_EX               <= rt;
        rd_EX               <= rd;
        shamt_EX            <= shamt;
        imm_EX              <= imm;
        target_address_EX   <= target_address;
        rf_a_EX             <= rf_a_f;
        rf_b_EX             <= rf_b_f;
        rf_raddr0_EX        <= rf_raddr0;
        rf_raddr1_EX        <= rf_raddr1;
        pc_plus_4_EX        <= pc_plus_4_ID;
    end
end

// ----------------------------------------------------------------------------------------- //
// ----------------------------------------------------------------------------------------- //
// -------------------------------------- ID/EX stage -------------------------------------- //
// ----------------------------------------------------------------------------------------- //
// ----------------------------------------------------------------------------------------- //
assign {alu_op_EX,
        sel_alu_b_EX,
        md_is_mult_EX,
        md_is_unsigned_EX} = ID_EX_ex;

assign {sel_rf_wdata_EX,
        rf_waddr_EX,
        rf_wen_EX,
        syscall_EX} = ID_EX_wb;

assign dm_ren_EX = ID_EX_mem[8];

// ******************************************************
// ** Arthimetic Logic Unit ** //
assign alu_op    = alu_op_EX;
assign sel_alu_b = sel_alu_b_EX;
assign alu_a     = (sel_alu_b == 2'b10) ? rf_b_EX : rf_a_EX;
always @(*) begin
    case(sel_alu_b)
        2'b00 : alu_b = {16'b0, imm_EX};
        2'b01 : alu_b = {{16{imm_EX[15]}}, imm_EX};
        2'b10 : alu_b = {27'b0, shamt_EX};
        default : alu_b = rf_b_EX;
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
// ** Multiplication/Division Processor ** //
assign md_a           = rf_a_EX;
assign md_b           = rf_b_EX;
assign md_is_mult     = md_is_mult_EX; 
assign md_is_unsigned = md_is_unsigned_EX;

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
// ** EX/MEM Register ** //
EX_MEM_Reg u_EX_MEM_Reg (
    .clk        (clk),
    .rst        (rst),
    .ID_EX_mem  (ID_EX_mem),
    .ID_EX_wb   (ID_EX_wb),
    .EX_MEM_mem (EX_MEM_mem),
    .EX_MEM_wb  (EX_MEM_wb)
);

// ******************************************************
// ** Pipeline Register ** //
//assign pc_plus_4_imm = pc_plus_4_EX + {{14{imm_EX[15]}}, imm_EX[15:0], 2'b00};
//assign target_reg_address = rf_a_EX;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        rs_MEM                  <= 5'b0;
        rt_MEM                  <= 5'b0;
        rd_MEM                  <= 5'b0;
        imm_MEM                 <= 16'b0;
        target_address_MEM      <= 26'b0;
        pc_plus_4_MEM           <= 32'b0;
        pc_plus_4_imm_MEM       <= 32'b0; 
        target_reg_address_MEM  <= 32'b0; 
        rf_b_MEM                <= 32'b0; 
        alu_overflow_MEM        <= 1'b0;
        alu_zero_MEM            <= 1'b0;
        alu_result_MEM          <= 32'b0; 
        md_result_MEM           <= 64'b0; 
    end
    else begin
        rs_MEM                  <= rs_EX;
        rt_MEM                  <= rt_EX;
        rd_MEM                  <= rd_EX;
        imm_MEM                 <= imm_EX;
        target_address_MEM      <= target_address_EX;
        rf_b_MEM                <= rf_b_EX;
        pc_plus_4_MEM           <= pc_plus_4_EX;
        pc_plus_4_imm_MEM       <= pc_plus_4_imm;      
        target_reg_address_MEM  <= target_reg_address;
        alu_overflow_MEM        <= alu_overflow;
        alu_zero_MEM            <= alu_zero;
        alu_result_MEM          <= alu_result;
        md_result_MEM           <= md_result;
    end
end


// ----------------------------------------------------------------------------------------- //
// ----------------------------------------------------------------------------------------- //
// -------------------------------------- EX/MEM stage ------------------------------------- //
// ----------------------------------------------------------------------------------------- //
// ----------------------------------------------------------------------------------------- //
assign {branch_beq_MEM,
        branch_bne_MEM,
        jump_MEM,
        jump_reg_MEM,
        dm_ren_MEM,
        dm_wen_MEM,
        dm_type_MEM,
        dm_sign_extend_MEM,
        lhr_is_mult_MEM,
        lhr_wen_MEM,
        lhr_ren_MEM,
        lhr_is_hi_MEM} = EX_MEM_mem;

assign {sel_rf_wdata_MEM,
        rf_waddr_MEM,
        rf_wen_MEM,
        syscall_MEM} = EX_MEM_wb;

// ******************************************************
// ** Data Memory ** //
assign dm_ren         = dm_ren_MEM;
assign dm_wen         = dm_wen_MEM;
assign dm_type        = dm_type_MEM;
assign dm_sign_extend = dm_sign_extend_MEM;
assign dm_addr        = alu_result_MEM;
assign dm_wdata       = rf_b_MEM;
assign dm_data        = dm_rdata;
// TODO : temporarily ignore input/output swap
//assign dm_wdata = {rf_b[7:0], rf_b[15:8], rf_b[23:16], rf_b[31:24]};                // input_swap
//assign dm_data = {dm_rdata[7:0], dm_rdata[15:8], dm_rdata[23:16], dm_rdata[31:24]}; // output_swap

DataMemory u_DM (
    // input
    .clk        (clk),   
    .ren        (dm_ren),
    .wen        (dm_wen),
    .rwtype     (dm_type),
    .addr       (dm_addr),   
    .wdata      (dm_wdata),  
    .sign_extend(dm_sign_extend),
    // output
    .rdata      (dm_rdata) 
);

// ******************************************************
// ** Lo/Hi Register ** //
assign lhr_p        = md_result_MEM;
assign lhr_is_mult  = lhr_is_mult_MEM;
assign lhr_wen      = lhr_wen_MEM;   
assign lhr_ren      = lhr_ren_MEM;    
assign lhr_is_hi    = lhr_is_hi_MEM;

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
// ** MEM/WB Register ** //
MEM_WB_Reg u_MEM_WB_Reg (
    .clk        (clk),
    .rst        (rst),
    .EX_MEM_wb  (EX_MEM_wb),
    .MEM_WB_wb  (MEM_WB_wb)
);

// ******************************************************
// ** MEM/WB Register ** //
always @(posedge clk or posedge rst) begin
    if (rst) begin
        rt_WB           <= 5'b0;
        rd_WB           <= 5'b0;
        imm_WB          <= 16'b0;
        pc_plus_4_WB    <= 32'b0;
        alu_result_WB   <= 32'b0; 
        dm_data_WB      <= 32'b0;
        lhr_rdata_WB    <= 32'b0;
    end
    else begin
        rt_WB           <= rt_MEM;
        rd_WB           <= rd_MEM;
        imm_WB          <= imm_MEM;
        pc_plus_4_WB    <= pc_plus_4_MEM;
        alu_result_WB   <= alu_result_MEM;
        dm_data_WB      <= dm_data;
        lhr_rdata_WB    <= lhr_rdata;
    end
end

// ******************************************************
// ** Condition Signals ** //
//assign branch   = (alu_zero_MEM & branch_beq_MEM) | (~alu_zero_MEM & branch_bne_MEM); // used for Program Counter
//assign jump     = jump_MEM;
//assign jump_reg = jump_reg_MEM;

// ----------------------------------------------------------------------------------------- //
// ----------------------------------------------------------------------------------------- //
// -------------------------------------- MEM/WB stage ------------------------------------- //
// ----------------------------------------------------------------------------------------- //
// ----------------------------------------------------------------------------------------- //
assign {sel_rf_wdata_WB,
        rf_waddr_WB,
        rf_wen_WB,
        syscall_WB} = MEM_WB_wb;


assign sel_rf_wdata = sel_rf_wdata_WB;
assign rf_wen       = rf_wen_WB;
assign rf_waddr     = rf_waddr_WB;

always @(*) begin
    case(sel_rf_wdata)
        3'b000  : rf_wdata = dm_data_WB;        // Load data from Data Memory
        3'b001  : rf_wdata = {imm_WB, 16'b0};   // Load data from imm
        3'b010  : rf_wdata = pc_plus_4_WB;      // Load data to $ra
        3'b011  : rf_wdata = lhr_rdata_WB;      // Load data from Lo/Hi Register
        default : rf_wdata = alu_result_WB;     // Load alu result
    endcase
end


// -------------------------------------- Others -------------------------------------- //


//// Overflow Detection ////
assign overflow = alu_overflow;

//// System Call ////
assign syscall  = syscall_WB;

endmodule

