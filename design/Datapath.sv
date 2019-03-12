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
//feilds
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
logic ALUZero,PCsel,Pause;
//hazard detect


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
//split instr
    assign opcode = Instr[6:0];
    assign Funct7 = Instr[31:25];
    assign Funct3 = Instr[14:12];
    
//pipline reg 1
    logic [DATA_W-1:0] ifdInst,pc_reg_r1;
    logic [PC_W-1:0] ifdPC;
    logic pc2reg_r1;
    IFIDReg #(32,9)r0(clk,reset,Pause,PCtoReg,PC_Reg,Instr,PC,pc2reg_r1,ifdInst,ifdPC,pc_reg_r1);

// //Register File
    logic rgWrite_r4;
    RegFile rf(clk, reset, rgWrite_r4, ifdInst[11:7], ifdInst[19:15], ifdInst[24:20],
            Result, Reg1, Reg2);
            
//// pipeline reg 2
    logic ALUsrc_r2,m2Reg_r2,RegWrite_r2,MemRead_r2,MemWrite_r2,Branch_r2,pc2reg_r2,AUIPC_r2;
    logic [PC_W-1:0] pc_r2;
    logic [2:0]funct3_r2;
    logic [6:0]funct7_r2;
    logic [6:0]opcode_r2;
    logic [4:0]Operation_r2;
    logic [DATA_W-1:0] SrcA_r2;
    logic [DATA_W-1:0] SrcB_r2;
    logic [DATA_W-1:0] Inst_r2;
    logic [DATA_W-1:0] pc_reg_r2;
    IDEXReg #(32,17)r1(clk,reset,Pause,pc2reg_r1,ALUsrc,MemtoReg,RegWrite,MemRead,MemWrite,
        Branch,PC_Reg,AUIPC,ifdPC,Funct3,Funct7,opcode,ALU_CC,Reg1,Reg2,ifdInst,
        ALUsrc_r2,m2Reg_r2,RegWrite_r2,MemRead_r2,MemWrite_r2,Branch_r2,pc2reg_r2,AUIPC_r2,
        pc_r2,funct3_r2,funct7_r2,opcode_r2,Operation_r2,SrcA_r2,SrcB_r2,Inst_r2,pc_reg_r2);
//end reg 2

//// sign extend
    imm_Gen Ext_Imm (Inst_r2,ExtImm);

//// ALU
   logic [DATA_W-1:0] result_r3, A_Result, B_Result, EX_MEM_rd_reg, MEM_WB_rd_reg;
   logic [1:0] forwardA, forwardB;
   logic EX_MEM_regWrite, MEM_WB_regWrite;

    mux2 #(32) srcbmux(SrcB_r2, ExtImm,  ALUsrc_r2, SrcB);
    mux2 #(32) srcamux(SrcA_r2, {23'b0,pc_r2}, AUIPC_r2, SrcA);
    mux3 #(32) a_mux(SrcA, Result, result_r3,forwardA, A_Result);
    mux3 #(32) b_mux(SrcB, Result, result_r3,forwardB, B_Result);
    alu alu_module(A_Result, B_Result, Operation_r2, ALUResult, ALUZero);
    
    assign WB_Data = Result;
    
////pipeline reg3
    logic m2Reg_r3, rgWrite_r3, mRead_r3, mWrite_r3, Branch_r3, AUIPC_r3,pc2reg_r3;
    logic [2:0] funct3_r3;
    logic [4:0] rd_r3;
    logic [DATA_W-1:0] SrcB_r3, Result_r3, pc_reg_r3;
    EXMEMReg #(32,12) r2(clk,reset,pc_reg_r2,pc2reg_r2,Inst_r2[11:7],m2Reg_r2,RegWrite_r2,MemRead_r2,MemWrite_r2,Branch_r2,AUIPC_r2,funct3_r2,B_Result,ALUResult,
        rd_r3,m2Reg_r3, rgWrite_r3, mRead_r3, mWrite_r3, Branch_r3, AUIPC_r3,funct3_r3,SrcB_r3,Result_r3,pc_reg_r3,pc2reg_r3);
//end reg3

    


////// Data memory 
	datamemory data_mem (clk,funct3_r3,mRead_r3,mWrite_r3, Result_r3[DM_ADDRESS-1:0], SrcB_r3, ReadData);

////pipeline reg 4
    logic m2Reg_r4,pc2reg_r4;
    logic [4:0] rd_r4;
    logic [DATA_W-1:0] ReadData_r4;
    logic [DATA_W-1:0] ALUResult_r4;
    logic [DATA_W-1:0] pc_reg_r4;
    MEMWBReg #(32,8) r4(clk,reset,pc_reg_r3,pc2reg_r3,m2Reg_r3,rgWrite_r3,ReadData,rd_r3,Result_r3,
        m2Reg_r4,rgWrite_r4,rd_r4,pc_reg_r4,pc2reg_r4,ReadData_r4,ALUResult_r4);
////end reg 4

forward_unit#(5) f_unit(ifdInst[19:15],ifdInst[24:20],Inst_r2[11:7] , rd_r3,  rgWrite_r3, rgWrite_r4, forwardA, forwardB); 
hazard_unit#(5) h_unit(ifdInst[19:15], ifdInst[24:20],Inst_r2[11:7], MemRead_r2, Pause); 
//// final mux
    mux2 #(32) resmux(ALUResult_r4, ReadData_r4, m2Reg_r4, ALUorMem);
//// jalr mux bellow
////need to find pc to reg bit --------------bellow
    mux2 #(32) jalrmux(ALUorMem, pc_reg_r4, pc2reg_r4, Result);
endmodule