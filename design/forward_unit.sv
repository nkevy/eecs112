`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/06/2019 06:10:32 PM
// Design Name: 
// Module Name: forward_unit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module forward_unit

    #(parameter WIDTH = 32)
    (
    input logic [WIDTH-1:0] rs1, rs2, EX_MEM_reg, MEM_WB_reg,
    input logic EX_MEM_regWrite, MEM_WB_regWrite, 
    output logic [1:0] fowardA, fowardB 
    );
    
    always_comb
    begin
        assign fowardA = 2'b00;
        assign fowardB = 2'b00;
        
        //EX Hazard
        if ((EX_MEM_regWrite) && (EX_MEM_reg != 32'b0) && ( rs1 == EX_MEM_reg))
            assign fowardA = 2'b10;
        if ((EX_MEM_regWrite) && (EX_MEM_reg != 32'b0) && ( rs2 == EX_MEM_reg))
            assign fowardB = 2'b10;    
        
        //MEM Hazard
        if ((MEM_WB_regWrite) && (MEM_WB_reg != 32'b0) && ( rs1 == MEM_WB_reg))
            assign fowardA = 2'b01;
        if ((MEM_WB_regWrite) && (MEM_WB_reg != 32'b0) && ( rs2 == MEM_WB_reg))
            assign fowardB = 2'b01;         
        
    
    end
endmodule
