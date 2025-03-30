// ======================================================================
//
// Module Name  : Hazard Detection Unit
// 
// Author       : jorjor
// Created Date : 2025.03.30
//
// ======================================================================

`timescale 1ns/100ps

module HazardDetectionUnit (
    // from ID
    input   [4:0] rs_ID,
    input   [4:0] rt_ID,
    // from EX
    input         dm_ren_EX, 
    input   [4:0] rt_EX,    // When dm_ren == 1'b1, the read address is rt
    
    output        PC_hold,
    output        IM_hold,
    output        ID_EX_clr
);


assign PC_hold   = dm_ren_EX & ( (rs_ID == rt_EX) | (rt_ID == rt_EX) );
assign IM_hold   = PC_hold;
assign ID_EX_clr = PC_hold;

endmodule
