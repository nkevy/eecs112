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
    parameter R_NUM = 8
    )(
    input logic clk,
    input logic rst,
    input logic [DATA_W-1:0] pc_reg,
    input logic pc2reg,
    input logic m2Reg,
    input logic rgWrite,
    input logic [DATA_W-1:0] Result,
    input logic [4:0] rd,
    input logic [DATA_W-1:0] ALUResult,
    output logic m2Reg_o,
    output logic rgWrite_o,
    output logic [4:0] rd_o,
    output logic [DATA_W-1:0] pc_reg_o,
    output logic pc2reg_o,
    output logic [DATA_W-1:0] Result_o,
    output logic [DATA_W-1:0] ALUResult_o
    );
    integer i;
    logic [R_NUM-1:0][DATA_W-1:0] mem;
    always@(negedge clk)begin
        if (rst==1'b0)begin
            mem[0]<={31'b0,m2Reg};
            mem[1]<={31'b0,rgWrite};
            mem[2]<=Result;
            mem[3]<={27'b0,rd};
            mem[4]<=ALUResult;
            mem[5]<={31'b0,pc_reg};
            mem[6]<=pc_reg;
            mem[7]<={31'b0,pc2reg};
        end
        else if (rst==1'b1)
        for(i=0;i<R_NUM;i++)
            mem[i]<=0;
    end
    assign m2Reg_o = mem[0][0];
    assign rgWrite_o = mem[1][0];
    assign Result_o = mem[2];
    assign rd_o = mem[3][4:0];
    assign ALUResult_o = mem[4];
    assign pc_reg_o = mem[6];
    assign pc2reg_o = mem[7][0];
endmodule