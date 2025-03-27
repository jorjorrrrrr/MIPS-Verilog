`timescale 1ns/100ps
`define cycle 10.0

`define MAX_LOOP 1000000

module tb_multiplier;

reg         clk;
reg  [31:0] a;     
reg  [31:0] b;     
reg         is_signed;
wire [63:0] p;
reg  [63:0] ans;

integer i;
integer err;
integer count;

`ifdef Wallace32
    initial begin
        $display("=========================================");
        $display("============= Testing 32 =============");
        $display("=========================================");
    end
    WallaceMultiplier32 U1 (
        .a          (a),          
        .b          (b),          
        .is_signed  (is_signed),
        .p          (p)      
    );
//`elsif CLA32
//    initial begin
//        $display("=========================================");
//        $display("============= Testing CLA32 =============");
//        $display("=========================================");
//    end
//    CLA32 U1 (
//        .a    (a),          
//        .b    (b),          
//        .cin  (cin),
//        .sum  (sum),
//        .cout (cout)      
//    );
//`elsif MCLA32
//    initial begin
//        $display("=========================================");
//        $display("============= Testing MCLA32 ============");
//        $display("=========================================");
//    end
//    MCLA32 U1 (
//        .a    (a),          
//        .b    (b),          
//        .cin  (cin),
//        .sum  (sum),
//        .cout (cout)      
//    );
`else
    initial begin
        $display("==========================================");
        $display("============== Invalid Mode ==============");
        $display("==========================================");
        $finish;
    end
`endif

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
// {cout, sum[31:0]} = a[31:0] + b[31:0] + cin;

initial begin
    #(`cycle * 2);
    err = 0;
    count = 0;
  
    for (i = 0; i < 10; i=i+1) begin
        a = $random & 32'hf;
        b = $random & 32'hf;
        is_signed = $random & 1;
        ans = (is_signed) ? $signed(a) * $signed(b) : a * b;
        #(`cycle);
        verify;
    end
    
    if (err == 0) begin
        $display("============================================================================");
        $display("\n \\(^o^)/ CONGRATULATIONS!! All the simulation result is PASS!!!\n");
        $display("============================================================================");
    end
    else begin
        $display("============================================================================");
        $display("\n (T_T) FAIL!! Something is wrong. Please check your code.\n");
        $display("============================================================================");
    end
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
        if (p === ans) begin
            $display("PASS  ! a = %10d, b = %10d, is_signed = %b, p = %11d", a, b, is_signed, p);
        end
        else begin
            $display("ERROR ! a = %10d, b = %10d, is_signed = %b, p = %11d (expect = %11d)", a, b, is_signed, p, ans);
            err = err + 1;
        end
    end
endtask

endmodule
