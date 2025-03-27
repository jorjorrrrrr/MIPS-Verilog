// ======================================================================
//
// Module Name  : Data Memory
// 
// Author       : jorjor
// Created Date : 2025.03.18
//
// ======================================================================

// synopsys translate_off
`timescale 1ns/100ps

`define BYTE_TYPE 2'b00
`define HALF_TYPE 2'b01
`define WORD_TYPE 2'b10

module DataMemory (
    input               clk,    // Clock Source
    input               wen,    // Active high write enable
    input       [1:0]   rwtype, // Write/Read type 
    input       [31:0]  addr,   // Write/Read address
    input       [31:0]  wdata,  // Write data
    input               sign_extend,
    output reg  [31:0]  rdata   // Read data
);

localparam DEPTH = 1024;
integer i;

//reg [31:0] mem [32'h4004000:32'h4004000+DEPTH-1];
reg [31:0] mem [32'h4004000:32'h7fff_ffff];

always@(*) begin
    case(rwtype)
        `BYTE_TYPE : begin
            case(addr[1:0])
                2'b00   : rdata = {{24{sign_extend & mem[addr>>2][ 7]}}, mem[addr>>2][7:0]};
                2'b01   : rdata = {{24{sign_extend & mem[addr>>2][15]}}, mem[addr>>2][15:8]};
                2'b10   : rdata = {{24{sign_extend & mem[addr>>2][23]}}, mem[addr>>2][23:16]};
                default : rdata = {{24{sign_extend & mem[addr>>2][31]}}, mem[addr>>2][31:24]};
            endcase
        end
        `HALF_TYPE : begin
            if (addr[1:0] == 2'b00) begin
                rdata = {{16{sign_extend & mem[addr>>2][15]}}, mem[addr>>2][15:0]};
            end
            else begin  // addr[1:0] == 2'b10
                rdata = {{16{sign_extend & mem[addr>>2][31]}}, mem[addr>>2][31:16]};
            end
        end
        //`WORD_TYPE : rdata = mem[addr>>2];
        default    : rdata = mem[addr>>2];
    endcase
end

always @(posedge clk) begin
    if (wen) begin
        if (rwtype == `BYTE_TYPE) begin
            mem[addr>>2][7:0]   <= wdata[7:0];
            case(addr[1:0])
                2'b00   : mem[addr>>2][7:0] <= wdata[7:0];
                2'b01   : mem[addr>>2][15:8] <= wdata[7:0]; 
                2'b10   : mem[addr>>2][23:16] <= wdata[7:0]; 
                default : mem[addr>>2][31:24] <= wdata[7:0]; 
            endcase
        end
        else if (rwtype == `HALF_TYPE) begin
            if (addr[1:0] == 2'b00) begin
                mem[addr>>2][15:0] <= wdata[15:0];
            end
            else begin  // addr[1:0] == 2'b10
                mem[addr>>2][31:16] <= wdata[15:0];
            end
        end
        else if (rwtype == `WORD_TYPE) begin
            mem[addr>>2] <= wdata;
        end
    end
end
// synopsys translate_on

endmodule

