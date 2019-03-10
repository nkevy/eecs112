`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/06/2019 07:22:13 PM
// Design Name: 
// Module Name: hazard_unit
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


module hazard_unit
    #( parameter WIDTH = 5)
    (
    input logic [WIDTH-1:0] IF_ID_reg1,IF_ID_reg2, ID_EX_reg,
    input logic ID_EX_MemRead,
    output logic nop_switch
    );
    
    always_comb
    begin 
    assign nop_switch = 1'b0;
    
    if((ID_EX_MemRead) && ((ID_EX_reg == IF_ID_reg1) || (ID_EX_reg == IF_ID_reg2)))
        assign nop_switch = 1'b1;
    
    end
endmodule
