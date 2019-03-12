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
module IFIDReg#(
    parameter DATA_W = 32,
    parameter PC_W = 9
    )(
    input logic clk,
    input logic rst,
    input logic Pause,
    input logic pc2reg,
    input logic [DATA_W-1:0] PC_Reg,
    input logic [DATA_W-1:0] inst_in,
    input logic [PC_W-1:0] ipc,
    output logic pc2reg_o,
    output logic [DATA_W-1:0] inst_out,
    output logic [PC_W-1:0] opc,
    output logic [DATA_W-1:0] PC_Reg_o
    );
    integer i;
    logic [3:0][DATA_W-1:0] mem ;
    always @(negedge clk) begin
        if (rst==1'b0 && Pause==1'b0)begin
            mem[0]<=inst_in;
            mem[1]<={23'b0,ipc};
            mem[2]<=PC_Reg;
            mem[3]<={31'b0,pc2reg};
        end
        else if (rst==1'b1)
        for(i=0;i<2;i++)
            mem[i]<=0;
    end
    assign inst_out = mem[0];
    assign opc = mem[1][7:0];
    assign PC_Reg_o = mem[2];
    assign pc2reg_o = mem[3][0];
endmodule
