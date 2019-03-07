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


module EXMEMReg#(
    parameter DATA_W = 32,
    parameter R_NUM = 9
    )(
    input logic clk,
    input logic rst,
    input logic m2Reg,
    input logic rgWrite,
    input logic mRead,
    input logic mWrite,
    input logic Branch,
    input logic AUIPC,
    input logic [2:0] funct3,
    input logic [DATA_W-1:0] SrcB,
    input logic [DATA_W-1:0] Result,
    output logic m2Reg_o,
    output logic rgWrite_o,
    output logic mRead_o,
    output logic mWrite_o,
    output logic Branch_o,
    output logic AUIPC_o,
    output logic [2:0] funct3_o,
    output logic [DATA_W-1:0] SrcB_o,
    output logic [DATA_W-1:0] Result_o
    );
    integer i;
    logic [R_NUM-1:0] mem [DATA_W-1:0];
    always @(negedge clk) begin
        if(rst==1'b0)begin
            mem[0] <= {31'b0,m2Reg};
            mem[1] <= {31'b0,rgWrite};
            mem[2] <= {31'b0,mRead};
            mem[3] <= {31'b0,mWrite};
            mem[4] <= {31'b0,Branch};
            mem[5] <= {31'b0,AUIPC};
            mem[6] <= {29'b0,funct3};
            mem[7] <= SrcB;
            mem[8] <= Result;
        end
        else if (rst==1'b0)
        for(i=0;i<R_NUM;i++)
            mem[i]<=0;
    end
    assign m2Reg_o = mem[0][0];
    assign rgWrite_o = mem[1][0];
    assign mRead_o = mem[2][0];
    assign mWrite_o = mem[3][0];
    assign Branch_o = mem[4][0];
    assign AUIPC_o = mem[5][0];
    assign funct3_o = mem[6][2:0];
    assign SrcB_o = mem[7];
    assign Result_o = mem[8];
endmodule