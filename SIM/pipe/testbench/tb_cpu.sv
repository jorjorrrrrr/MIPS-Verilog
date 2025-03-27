`timescale 1ns/100ps
`define cycle 10.0

`include "../../RTL/def/def_inst_type.v"

`define MAX_CYCLE 100000000

`ifdef P1
    `define INST_PATH "./pattern/pattern1/instruction.hex"
    `define DATA_PATH "./pattern/pattern1/memory.hex"
    string start_msg = "    Pattern 1 : Arithmetic Operation                           ";
`elsif P2
    `define INST_PATH "./pattern/pattern2/instruction.hex"
    `define DATA_PATH "./pattern/pattern2/memory.hex"
    string start_msg = "    Pattern 2 : Arithmetic Operation (with Jump and Print Str) ";
`elsif P3
    `define INST_PATH "./pattern/pattern3/instruction.hex"
    `define DATA_PATH "./pattern/pattern3/memory.hex"
    string start_msg = "    Pattern 3 : Load-Store (LW)                                ";
`elsif P4
    `define INST_PATH "./pattern/pattern4/instruction.hex"
    `define DATA_PATH "./pattern/pattern4/memory.hex"
    string start_msg = "    Pattern 4 : If-else (Bne, Beq)                             ";
`elsif P5
    `define INST_PATH "./pattern/pattern5/instruction.hex"
    `define DATA_PATH "./pattern/pattern5/memory.hex"
    string start_msg = "    Pattern 5 : For-loop                                       ";
`elsif P6
    `define INST_PATH "./pattern/pattern6/instruction.hex"
    `define DATA_PATH "./pattern/pattern6/memory.hex"
    string start_msg = "    Pattern 6 : Factorial                                      ";
`elsif P7
    `define INST_PATH "./pattern/pattern7/instruction.hex"
    `define DATA_PATH "./pattern/pattern7/memory.hex"
    string start_msg = "    Pattern 7 : Fibonacci                                      ";
`elsif P8
    `define INST_PATH "./pattern/pattern8/instruction.hex"
    `define DATA_PATH "./pattern/pattern8/memory.hex"
    string start_msg = "    Pattern 8 : BubbleSort                                     ";
`else
    `define INST_PATH "./pattern/pattern_all/instruction.hex"
    `define DATA_PATH "./pattern/pattern_all/memory.hex"
    string start_msg = "    Pattern : Testing all instruction                          ";
`endif

// Register File
`define zero U1.u_RF.register[0]
`define at   U1.u_RF.register[1]
`define v0   U1.u_RF.register[2]
`define v1   U1.u_RF.register[3]
`define a0   U1.u_RF.register[4]
`define a1   U1.u_RF.register[5]
`define a2   U1.u_RF.register[6]
`define a3   U1.u_RF.register[7]
`define t0   U1.u_RF.register[8]
`define t1   U1.u_RF.register[9]
`define t2   U1.u_RF.register[10]
`define t3   U1.u_RF.register[11]
`define t4   U1.u_RF.register[12]
`define t5   U1.u_RF.register[13]
`define t6   U1.u_RF.register[14]
`define t7   U1.u_RF.register[15]
`define s0   U1.u_RF.register[16]
`define s1   U1.u_RF.register[17]
`define s2   U1.u_RF.register[18]
`define s3   U1.u_RF.register[19]
`define s4   U1.u_RF.register[20]
`define s5   U1.u_RF.register[21]
`define s6   U1.u_RF.register[22]
`define s7   U1.u_RF.register[23]
`define t8   U1.u_RF.register[24]
`define t9   U1.u_RF.register[25]
`define k0   U1.u_RF.register[26]
`define k1   U1.u_RF.register[27]
`define gp   U1.u_RF.register[28]
`define sp   U1.u_RF.register[29]
`define fp   U1.u_RF.register[30]
`define ra   U1.u_RF.register[31]

`define pc   (U1.pc_next)

`define data_memory   U1.u_DM.mem

// MIPS System Calls
`define print_int       32'd1
`define print_float     32'd2
`define print_double    32'd3
`define print_string    32'd4
`define exit            32'd10

module tb_cpu;

reg     clk;
reg     rst;
wire    overflow;

integer i;
integer err;

int str_queue[$];
string str;

CPU U1 (
    .clk      (clk),
    .rst      (rst),
    .overflow (overflow)
);

initial begin
    $timeformat(-9, 1, " ns", 9); //Display time in nanoseconds
`ifdef FSDB
    $dumpvars;
	$fsdbDumpvars;
	$fsdbDumpMDA;
`endif
end

initial begin
    clk = 1'b0;
    forever begin
        #(`cycle/2) clk = ~clk;
    end
end

initial begin
    rst = 1'b0; 
    #(`cycle*2);
    rst = 1'b1; 
    #(`cycle);
    rst = 1'b0; 
end

initial begin
    $readmemh(`INST_PATH, U1.u_IM.mem);
    $readmemh(`DATA_PATH, U1.u_DM.mem);
end

initial begin
    $display("==============================================================");
    $display("%s", start_msg);
    $display("==============================================================");
    @(negedge rst);
    #(`cycle);
    //$display("(pc = %0d) mem[0] = %8h", `pc, `data_memory[32'h4004000+0]);
    //$display("(pc = %0d) mem[1] = %8h", `pc, `data_memory[32'h4004000+1]);
    //$display("(pc = %0d) mem[2] = %8h", `pc, `data_memory[32'h4004000+2]);
    //$display("(pc = %0d) mem[3] = %8h", `pc, `data_memory[32'h4004000+3]);
    //$display("(pc = %0d) mem[4] = %8h", `pc, `data_memory[32'h4004000+4]);
    //while(1) begin
    //    $display("-------------------");
    //    $display("(pc = %0d)", `pc);
    //    $display("t0 = %0h", `t0);
    //    $display("t1 = %0h", `t1);
    //    $display("t2 = %0h", `t2);
    //    $display("t3 = %0h", `t3);
    //    $display("s0 = %0h", `s0);
    //    $display("s1 = %0h", `s1);
    //    $display("s2 = %0h", `s2);
    //    $display("s3 = %0h", `s3);
    //    $display("s4 = %0h", `s4);
    //    $display("s5 = %0h", `s5);
    //    $display("s6 = %0h", `s6);
    //    $display("s7 = %0h", `s7);
    //    $display("a0 = %0h", `a0);
    //    #(`cycle);
    //end
    //#(`cycle);
    //$finish;
end

always @(negedge clk) begin
    if (U1.u_CU.inst_type == `SYSCALL) begin
        case(`v0)
            `print_int    : $write("%d", `a0);  
            //`print_float  : $write("%d");
            //`print_double : $write("%d");
            `print_string : begin
                for (int index = `a0; ; index++) begin : loop
                    if (index[1:0] == 2'b11) begin
                        if (`data_memory[index>>2][31:24] === 8'h00) break;
                        else str_queue.push_back(`data_memory[index>>2][31:24]);
                    end
                    else if (index[1:0] == 2'b10) begin
                        if (`data_memory[index>>2][23:16] === 8'h00) break;
                        else str_queue.push_back(`data_memory[index>>2][23:16]);
                    end
                    else if (index[1:0] == 2'b01) begin
                        if (`data_memory[index>>2][15:8] === 8'h00) break;
                        else str_queue.push_back(`data_memory[index>>2][15:8]);
                    end
                    else if (index[1:0] == 2'b00) begin
                        if (`data_memory[index>>2][7:0] === 8'h00) break;
                        else str_queue.push_back(`data_memory[index>>2][7:0]);
                    end
                end
                str = "";
                foreach (str_queue[i]) begin
                    str = {str, $sformatf("%c", str_queue[i])};
                end

                $write("%s", str);
                
                str_queue.delete();
            end
            `exit         : begin 
                $display("Program End."); 
                
                `ifdef PRINT
                    $display("\n=================== Register File ==================="); 
                    $display("t0 = %8h, t1 = %8h, t2 = %8h, t3 = %8h, ", `t0, `t1, `t2, `t3);
                    $display("t4 = %8h, t5 = %8h, t6 = %8h, t7 = %8h, ", `t4, `t5, `t6, `t7);
                    $display("s0 = %8h, s1 = %8h, s2 = %8h, s3 = %8h, ", `s0, `s1, `s2, `s3);
                    $display("s4 = %8h, s5 = %8h, s6 = %8h, s7 = %8h, ", `s4, `s5, `s6, `s7);
                    $display("a0 = %8h, a1 = %8h, a2 = %8h, a3 = %8h, ", `a0, `a1, `a2, `a3);
                `endif    

                $finish; 
            end
            default       : $display("Invalid System Call");
        endcase
    end
end

// Watchdog Timer
initial begin
    #(`MAX_CYCLE);
    $display("============================================================================");
    $display("\n (T_T) FAIL!! Something is wrong. Please check your code.\n");
    $display("============================================================================");
    $finish;
end

//task verify;
//    begin
//        if (result === ans) begin
//            $display("PASS ! a = %0d, b = %0d, ALUop = %4b, result = %0d, zero = %0d, overflow = %0d", 
//                        a, b, ALUop, result, zero, overflow);
//        end
//        else begin
//            $display("ERROR ! a = %0d, b = %0d, ALUop = %4b, result = %0d (expect = %0d), zero = %0d, overflow = %0d", 
//                        a, b, ALUop, result, ans, zero, overflow);
//        end
//    end
//endtask
//
//task verify_overflow;
//    begin
//        if (result === ans && overflow == ans_cout) begin
//            $display("PASS ! a = %0d, b = %0d, ALUop = %4b, result = %0d, zero = %0d, overflow = %0d", 
//                        a, b, ALUop, result, zero, overflow);
//        end
//        else begin
//            $display("ERROR ! a = %0d, b = %0d, ALUop = %4b, result = %0d (expect = %0d), zero = %0d, overflow = %0d (expect = %0d)", 
//                        a, b, ALUop, result, ans, zero, overflow, ans_cout);
//        end
//    end
//endtask

endmodule
