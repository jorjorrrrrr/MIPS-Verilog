`timescale 1ns/100ps
`define cycle 10.0

`define MAX_LOOP 1000000

module tb_alu;

reg          clk;
reg  [31:0]  a;          // Data in A
reg  [31:0]  b;          // Data in B
reg  [3:0]   ALUop;      // ALU control
wire         zero;       // Zero Detection
wire         overflow;   // Overflow Detection
wire [31:0]  result;     // ALU result
reg  [31:0]  ans;
reg          ans_cout;

integer i;
integer err;
integer count;

ArthimeticLogicUnit U1 (
    .a          (a),          
    .b          (b),          
    .ALUop      (ALUop),      
    .zero       (zero),       
    .overflow   (overflow),   
    .result     (result)      
);

initial begin
    $timeformat(-9, 1, " ns", 9); //Display time in nanoseconds
    $dumpvars;
	$fsdbDumpvars;
	//$fsdbDumpMDA;
end


initial begin
    clk = 1'b0;
    forever begin
        #(`cycle/2) clk = ~clk;
    end
end

// Function Descriptions:
//  -----------------
//  ALUop  |  Function
//  0000   |  and 
//  0001   |  or 
//  0010   |  add 
//  0110   |  subtract 
//  0111   |  set-on-less-than 
//  1100   |  nor

initial begin
    $display("========================================");
    $display("              Start Simulation          ");
    $display("========================================");
    #(`cycle * 2);
    err = 0;
    count = 0;
   
    // testing and
    a = 77;
    b = 33;
    ALUop = 4'b0000;
    ans = a & b;
    #(`cycle);
    verify;
    
    // testing or
    a = 77;
    b = 33;
    ALUop = 4'b0001;
    ans = a | b;
    #(`cycle);
    verify;
    
    // testing add
    a = 77;
    b = 33;
    ALUop = 4'b0010;
    ans = a + b;
    #(`cycle);
    verify;
    
    // testing subtract
    a = 77;
    b = 33;
    ALUop = 4'b0110;
    ans = a - b;
    #(`cycle);
    verify;
    
    // testing set-on-less-than
    a = 77;
    b = 33;
    ALUop = 4'b0111;
    ans = (a < b);
    #(`cycle);
    verify;
    
    // testing set-on-less-than
    a = 33;
    b = 77;
    ALUop = 4'b0111;
    ans = (a < b);
    #(`cycle);
    verify;
    
    // testing nor
    a = 77;
    b = 33;
    ALUop = 4'b1100;
    ans = ~(a | b);
    #(`cycle);
    verify;
    
    // testing overflow
    a = 32'h7FFFFFFF;
    b = 32'h00000001;
    ALUop = 4'b0010;
    {ans_cout, ans} = a + b;
    #(`cycle);
    verify;
    
    // testing overflow
    a = 32'h80000000;
    b = 32'h00000001;
    ALUop = 4'b0110;
    {ans_cout, ans} = a - b;
    #(`cycle);
    verify;

    #(`cycle);
    $finish;
end

// Watchdog Timer
always @(posedge clk) begin
    if (count >= `MAX_LOOP) begin
        $display("============================================================================");
        $display("\n (T_T) FAIL!! Something is wrong. Please check your code.\n");
        $display("============================================================================");
        $finish;
    end
    else begin
        count <= count + 1;
    end
end

task verify;
    begin
        if (result === ans) begin
            $display("PASS ! a = %0d, b = %0d, ALUop = %4b, result = %0d, zero = %0d, overflow = %0d", 
                        a, b, ALUop, result, zero, overflow);
        end
        else begin
            $display("ERROR ! a = %0d, b = %0d, ALUop = %4b, result = %0d (expect = %0d), zero = %0d, overflow = %0d", 
                        a, b, ALUop, result, ans, zero, overflow);
        end
    end
endtask

task verify_overflow;
    begin
        if (result === ans && overflow == ans_cout) begin
            $display("PASS ! a = %0d, b = %0d, ALUop = %4b, result = %0d, zero = %0d, overflow = %0d", 
                        a, b, ALUop, result, zero, overflow);
        end
        else begin
            $display("ERROR ! a = %0d, b = %0d, ALUop = %4b, result = %0d (expect = %0d), zero = %0d, overflow = %0d (expect = %0d)", 
                        a, b, ALUop, result, ans, zero, overflow, ans_cout);
        end
    end
endtask

endmodule
