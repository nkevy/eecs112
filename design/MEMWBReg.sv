`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/06/2019 05:35:34 PM
// Design Name: 
// Module Name: IFIDReg
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


module MEMWBReg#(
    parameter DATA_W = 32,
    parameter R_NUM = 3
    )(
    input logic clk,
    input logic rst,
    input logic m2Reg,
    input logic rgWrite,
    input logic Result,
    output logic m2Reg_o,
    output logic rgWrite_o,
    output logic Result_o
    );
    integer i;
    logic [R_NUM-1:0] mem [DATA_W-1:0];
    always@(negedge clk)begin
        if (rst==1'b0)begin
            mem[0]<={31'b0,m2Reg};
            mem[1]<={31'b0,rgWrite};
            mem[2]<=Result;
        end
        else if (rst==1'b1)
        for(i=0;i<R_NUM;i++)
            mem[i]<=0;
    end
    assign m2Reg_o = mem[0][0];
    assign rgWrite_o = mem[1][0];
    assign Result_o = mem[2];
endmodule