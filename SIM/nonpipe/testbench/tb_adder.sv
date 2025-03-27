`timescale 1ns/100ps
`define cycle 10.0

`define MAX_LOOP 1000000

module tb_adder;

reg          clk;
reg  [31:0] a;     
reg  [31:0] b;     
reg         cin;
wire [31:0] sum;
wire        cout;
reg  [31:0] ans_sum;
reg         ans_cout;

integer i;
integer err;
integer count;

`ifdef RCA32
    initial begin
        $display("=========================================");
        $display("============= Testing RCA32 =============");
        $display("=========================================");
    end
    RCA32 U1 (
        .a    (a),          
        .b    (b),          
        .cin  (cin),
        .sum  (sum),
        .cout (cout)      
    );
`elsif CLA32
    initial begin
        $display("=========================================");
        $display("============= Testing CLA32 =============");
        $display("=========================================");
    end
    CLA32 U1 (
        .a    (a),          
        .b    (b),          
        .cin  (cin),
        .sum  (sum),
        .cout (cout)      
    );
`elsif MCLA32
    initial begin
        $display("=========================================");
        $display("============= Testing MCLA32 ============");
        $display("=========================================");
    end
    MCLA32 U1 (
        .a    (a),          
        .b    (b),          
        .cin  (cin),
        .sum  (sum),
        .cout (cout)      
    );
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
  
    for (i = 0; i < 1000; i=i+1) begin
        a = $random;
        b = $random;
        cin = $random;
        {ans_cout, ans_sum} = a + b + cin;
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
        if ({cout, sum} === {ans_cout, ans_sum}) begin
            $display("PASS  ! a = %10d, b = %10d, cin = %b, {cout, sum} = %11d", a, b, cin, {cout, sum});
        end
        else begin
            $display("ERROR ! a = %10d, b = %10d, cin = %b, {cout, sum} = %11d (expect = %11d)", a, b, cin, {cout, sum}, {ans_cout, ans_sum});
            err = err + 1;
        end
    end
endtask

endmodule
