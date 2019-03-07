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
    input logic [DATA_W-1:0] inst_in,
    input logic [PC_W-1:0] ipc,
    output logic [DATA_W-1:0] inst_out,
    output logic [PC_W-1:0] opc
    );
    integer i;
    logic [1:0] mem [DATA_W:0];
    always @(negedge clk) begin
        if (rst==1'b0 && Pause==1'b0)begin
            mem[0]<=inst_in;
            mem[1][PC_W-1:0]<=ipc;
        end
        else if (rst==1'b1)
        for(i=0;i<2;i++)
            mem[i]<=0;
    end
    assign inst_out = mem[0];
    assign opc = mem[1][PC_W-1:0];
endmodule
