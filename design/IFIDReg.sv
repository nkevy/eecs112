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
    parameter PC_W = 9,
    parameter SIZE = 12
    )(
    input logic clk,
    input logic rst,
    input logic Pause,
    input logic PCsel,
    input logic AluSrc,
    input logic m2reg,
    input logic rgWrite, 
    input logic Branch,
    input logic AUIPC,
    input logic [4:0] Operation,
    input logic pc2reg,
    input logic [DATA_W-1:0] PC_Reg,
    input logic [DATA_W-1:0] inst_in,
    input logic [PC_W-1:0] ipc,
    input logic MemRead,
    input logic MemWrite,
    output logic AluSrc_o,
    output logic MemRead_o,
    output logic MemWrite_o,
    output logic pc2reg_o,
    output logic [DATA_W-1:0] inst_out,
    output logic [PC_W-1:0] opc,
    output logic [DATA_W-1:0] PC_Reg_o,
    output logic [4:0] Operation_o,
    output logic m2reg_o,
    output logic rgWrite_o,
    output logic Branch_o,
    output logic AUIPC_o
    );
    integer i;
    logic [11:0][DATA_W-1:0] mem ;
    always @(negedge clk) begin
        if (rst==1'b0 && Pause==1'b0 && PCsel != 2'b01)begin
            mem[0]<=inst_in;
            mem[1]<={23'b0,ipc};
            mem[2]<=PC_Reg;
            mem[3]<={31'b0,pc2reg};
            mem[4]<={31'b0,MemRead};
            mem[5]<={31'b0,MemWrite};
            mem[6]<={31'b0,AluSrc};
            mem[7]<={27'b0,Operation};
            mem[8]<={31'b0,m2reg};
            mem[9]<={31'b0,rgWrite};
            mem[10]<={31'b0,Branch};
            mem[11]<={31'b0,AUIPC_o};
        end
        else if ((rst==1'b1) || (PCsel == 2'b01))
        for(i=0;i<SIZE;i++)
            mem[i]<=0;
    end
    //for branch to erase reg as soon as branch is known 
    //always @(posedge clk)begin
    //    if(rst==1'b0 && PCsel==2'b01)
    //    for(i=0;i<SIZE;i++)
    //        mem[i]<=0;
    //end
    assign inst_out = mem[0];
    assign opc = mem[1][7:0];
    assign PC_Reg_o = mem[2];
    assign pc2reg_o = mem[3][0];
    assign MemRead_o = mem[4][0];
    assign MemWrite_o = mem[5][0];
    assign AluSrc_o = mem[6][0];
    assign Operation_o = mem[7][4:0];
    assign m2reg_o = mem[8][0];
    assign rgWrite_o = mem[9][0];
    assign Branch_o = mem[10][0];
    assign AUIPC_o = mem[11][0];
endmodule
