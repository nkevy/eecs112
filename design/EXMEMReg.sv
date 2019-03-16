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
    parameter PC_W = 9,
    parameter R_NUM = 13
    )(
    input logic clk,
    input logic rst,
    input logic [DATA_W-1:0] pc_reg,
    input logic pc2reg,
    input logic [DATA_W-1:0] Inst_i,
    input logic m2Reg,
    input logic rgWrite,
    input logic mRead,
    input logic mWrite,
    input logic Branch,
    input logic AUIPC,
    input logic [2:0] funct3,
    input logic [DATA_W-1:0] SrcB,
    input logic [DATA_W-1:0] Result,
    input logic [PC_W-1:0] pc_in,
    output logic m2Reg_o,
    output logic rgWrite_o,
    output logic mRead_o,
    output logic mWrite_o,
    output logic Branch_o,
    output logic AUIPC_o,
    output logic [2:0] funct3_o,
    output logic [DATA_W-1:0] SrcB_o,
    output logic [DATA_W-1:0] Result_o,
    output logic [DATA_W-1:0] pc_reg_o,
    output logic pc2reg_o,
    output logic[DATA_W-1:0] Inst_o,
    output logic[PC_W-1:0]pc_o
    );
    integer i;
    logic [R_NUM-1:0][DATA_W-1:0] mem;
    always @(negedge clk) begin
        if(rst==1'b0)begin
            mem[0] <= {31'b0,m2Reg};
            mem[1] <= {31'b0,rgWrite};
            mem[2] <= {31'b0,mRead};
            mem[3] <= {31'b0,mWrite};
            mem[4] <= {31'b0,Branch};
            mem[5] <= {31'b0,AUIPC};
            mem[6] <= {29'b0,funct3};
            mem[7] <= SrcB[DATA_W-1:0];
            mem[8] <= Result;
            mem[9] <= Inst_i;
            mem[10]<= pc_reg;
            mem[11]<= {31'b0,pc2reg};
            mem[12] <= {23'b0,pc_in};
        end
        else if (rst==1'b1)
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
    assign SrcB_o = mem[7][DATA_W-1:0];
    assign Result_o = mem[8];
    assign pc_reg_o = mem[10];
    assign pc2reg_o = mem[11][0];
    assign Inst_o = mem[9];
    assign pc_o = mem[12][PC_W-1:0];
endmodule