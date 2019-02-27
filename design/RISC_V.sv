`timescale 1ns / 1ps

module riscv #(
    parameter DATA_W = 32)
    (input logic clk, reset, // clock and reset signals
    output logic [31:0] WB_Data// The ALU_Result
    );

logic [6:0] opcode;
logic ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, AUIPC, Jal, PCtoReg;

logic [2:0] ALUop;
logic [6:0] Funct7;
logic [2:0] Funct3;
logic [4:0] Operation;

    Controller c(opcode, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, PCtoReg , AUIPC, Jal, ALUop);
    
    ALUController ac(Branch, ALUop, Funct7, Funct3, Operation);

    Datapath dp(clk, reset, RegWrite , MemtoReg, ALUSrc , MemWrite, MemRead, Branch, AUIPC, PCtoReg, Operation, opcode, Funct7, Funct3, WB_Data);
        
endmodule
