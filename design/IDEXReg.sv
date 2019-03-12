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
module IDEXReg#(
    parameter DATA_W = 32,
    parameter R_NUM = 17
    )(
    input logic clk,
    input logic rst,
    input logic Pause,
    input logic pc2reg,
    input logic ALUsrc,
    input logic m2Reg,
    input logic rgWrite,
    input logic mRead,
    input logic mWrite,
    input logic Branch,
    input logic [DATA_W-1:0] pc_reg,
    input logic AUIPC,
    input logic [8:0] PC,
    input logic [2:0] funct3,
    input logic [6:0] funct7,
    input logic [6:0] Opcode,
    input logic [4:0] Operation,
    input logic [DATA_W-1:0] SrcA,
    input logic [DATA_W-1:0] SrcB,
    input logic [DATA_W-1:0] inst_in,
    output logic ALUsrc_o,
    output logic m2Reg_o,
    output logic rgWrite_o,
    output logic mRead_o,
    output logic mWrite_o,
    output logic Branch_o,
    output logic PC2Reg_o,
    output logic AUIPC_o,
    output logic[8:0] PC_o,
    output logic [2:0] func3_o,
    output logic [6:0] func7_o,
    output logic [6:0] Opcode_o,
    output logic [4:0] Operation_o,
    output logic [DATA_W-1:0] SrcA_o,
    output logic [DATA_W-1:0] SrcB_o,
    output logic [DATA_W-1:0] inst_o,
    output logic [DATA_W-1:0] pc_reg_o
    );
    integer i;
    logic [R_NUM-1:0][DATA_W-1:0] mem;
    always @(negedge clk) begin
        if (rst==1'b0 && Pause==1'b0)begin
            mem[0] <= {31'b0,ALUsrc};
            mem[1] <= {31'b0,m2Reg};
            mem[2] <= {31'b0,rgWrite};
            mem[3] <= {31'b0,mRead};
            mem[4] <= {31'b0,mWrite};
            mem[5] <= {31'b0,Branch};
            mem[6] <= {31'b0,pc2reg};
            mem[7] <= {31'b0,AUIPC};
            mem[8] <= {23'b0,PC};
            mem[9] <= {29'b0,funct3};
            mem[10] <= {25'b0,funct7};
            mem[11] <= {25'b0,Opcode};
            mem[12] <= {27'b0,Operation};
            mem[13] <= SrcA;
            mem[14] <= SrcB;
            mem[15] <=inst_in;
            mem[16] <=pc_reg;
        end
        if (rst==1'b1) begin
        for(i=0;i<R_NUM;i++)
            mem[i]<=0;
        end
    end
    assign ALUsrc_o = mem[0][0];
    assign m2Reg_o = mem[1][0];
    assign rgWrite_o = mem[2][0];
    assign mRead_o = mem[3][0];
    assign mWrite_o = mem[4][0];
    assign Branch_o = mem[5][0];
    assign PC2Reg_o = mem[6][0];
    assign AUIPC_o = mem[7][0];
    assign PC_o = mem[8][9:0];
    assign func3_o = mem[9][2:0];
    assign func7_o = mem[10][6:0];
    assign Opcode_o = mem[11][6:0];
    assign Operation_o = mem[12][4:0];
    assign SrcA_o = mem[13];
    assign SrcB_o = mem[14];
    assign inst_o = mem[15];
    assign pc_reg_o = mem[16];
endmodule