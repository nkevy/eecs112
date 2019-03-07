`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/07/2018 10:10:33 PM
// Design Name: 
// Module Name: Datapath
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

module Datapath #(
    parameter PC_W = 9, // Program Counter
    parameter INS_W = 32, // Instruction Width
    parameter RF_ADDRESS = 5, // Register File Address
    parameter DATA_W = 32, // Data WriteData
    parameter DM_ADDRESS = 9, // Data Memory Address
    parameter DM_OFFSET = 2, // Toggles half word & byte selection
    parameter ALU_CC_W = 5 // ALU Control Code Width
    )(
    input logic clk , reset , // global clock
                              // reset , sets the PC to zero
    RegWrite , MemtoReg ,     // Register file writing enable   // Memory or ALU MUX
    ALUsrc , MemWrite ,       // Register file or Immediate MUX // Memroy Writing Enable
    MemRead ,                 // Memroy Reading Enable
    Branch,                   //branch (conditional instructions)
    AUIPC,
    PCtoReg,                  //sel to control pc+4 to write back if JALR is 1
    input logic [ ALU_CC_W -1:0] ALU_CC, // ALU Control Code ( input of the ALU )
    output logic [6:0] opcode,
    output logic [6:0] Funct7,
    output logic [2:0] Funct3,
    output logic [DATA_W-1:0] WB_Data //ALU_Result
    );

logic [PC_W-1:0] PC, PCPlus4, PCBranch, PCnext;
logic [INS_W-1:0] Instr;
logic [DATA_W-1:0] Result;
logic [DATA_W-1:0] PC_Reg;
logic [DATA_W-1:0] ALUorMem;
logic [DATA_W-1:0] Reg1, Reg2;
logic [DATA_W-1:0] ReadData;
logic [DATA_W-1:0] SrcA, SrcB, ALUResult;
logic [DATA_W-1:0] ExtImm;
logic [DATA_W-1:0] shift_left_ExtImm;
logic ALUZero,PCsel;

//Branch 
assign shift_left_ExtImm = ExtImm << 1;
assign PCsel = (Branch && ALUZero);

// next PC
    adder #(9) pcadd (PC, 9'b100, PCPlus4);
    adder #(9) pc_b_add (PC, shift_left_ExtImm[9:1], PCBranch);
    mux2  #(9) mpc (PCPlus4, PCBranch, PCsel, PCnext);
    flopr #(9) pcreg(clk, reset, PCnext, PC);
    
    assign PC_Reg = {23'b0,PCPlus4};
    

 //Instruction memory
    instructionmemory instr_mem (PC, Instr);
    
    assign opcode = Instr[6:0];
    assign Funct7 = Instr[31:25];
    assign Funct3 = Instr[14:12];
      
// //Register File
    RegFile rf(clk, reset, RegWrite, Instr[11:7], Instr[19:15], Instr[24:20],
            Result, Reg1, Reg2);
            
    mux2 #(32) resmux(ALUResult, ReadData, MemtoReg, ALUorMem);
    //jalr mux bellow
    mux2 #(32) jalrmux(ALUorMem, PC_Reg, PCtoReg, Result);
           
//// sign extend
    imm_Gen Ext_Imm (Instr,ExtImm);

//// ALU
    mux2 #(32) srcbmux(Reg2, ExtImm,  ALUsrc, SrcB);
    mux2 #(32) srcamux(Reg1, {21'b0,PC}, AUIPC, SrcA);
    alu alu_module(SrcA, SrcB, ALU_CC, ALUResult, ALUZero);

    assign WB_Data = Result;
    
    
////// Data memory 
	datamemory data_mem (clk,Funct3, MemRead, MemWrite, ALUResult[DM_ADDRESS-1:0], Reg2, ReadData);
     
endmodule