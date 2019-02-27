`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/07/2018 10:10:33 PM
// Design Name: 
// Module Name: ALUController
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


module ALUController(
    
    //Input
    input logic Branch,
    input logic Load,
    input logic [2:0] ALUOp,  //7-bit opcode field from the instruction
    input logic [6:0] Funct7, // bits 25 to 31 of the instruction
    input logic [2:0] Funct3, // bits 12 to 14 of the instruction
    
    //Output
    output logic [4:0] Operation //operation selection for ALU
);
 
 assign Operation[0]= //JALR, AUIPC
                      ((Branch == 1'b1) && (ALUOp==3'b101 || ALUOp==3'b111)) ||
			          //branch
			          ((Branch == 1'b1 && ALUOp==3'b001) && (Funct3==3'b001 || Funct3==3'b101 || Funct3==3'b111)) || // for BNE,BGE, BGEU
			          //R-Type                                 //OR              // XOR            //SLL             //SRA                                       //SLT
			          (((ALUOp==3'b010)) &&  (Funct3==3'b110 || Funct3==3'b100 || Funct3==3'b001 || ((Funct3==3'b101) && (Funct7==7'b0100000)) || Funct3==3'b010)) ||

                       //Load                //LB               //LH               //LW                 //LBU                //LHU
                      (((ALUOp==3'b000) ) && ((Funct3==3'b000) || (Funct3==3'b001) || (Funct3==3'b010)  || (Funct3==3'b100)  || (Funct3==3'b101)))
			          ;  
			         
 
 assign Operation[1]=  //LUI, AUIPC
                       ((Branch == 1'b1) && (ALUOp==3'b110 || ALUOp==3'b111)) ||
                       //branch
                       ((Branch == 1'b1 && ALUOp==3'b001) && (Funct3==3'b100 || Funct3==3'b101)) ||// for BLT, BGE
                        //R-Type                                 //ADD & SUB                                                                // XOR         //SRA                                       //SLTU
                       (((ALUOp==3'b010)) &&  ((Funct3==3'b000) || Funct3==3'b100 || ((Funct3==3'b101) && (Funct7==7'b0100000)) || Funct3==3'b011)) || 

                       //Load STORE               //LB               //LH               //LW                 //LBU                //LHU
                      ((ALUOp==3'b000) && ((Funct3==3'b000) || (Funct3==3'b001) || (Funct3==3'b010)  || (Funct3==3'b100)  || (Funct3==3'b101)))
                       ;                  
                       
 assign Operation[2]= 
                        //JAL, JALR, LUI, AUIPC
                      ((Branch == 1'b1) && (ALUOp==3'b100 || ALUOp==3'b101 || ALUOp==3'b110 || ALUOp==3'b111)) ||
		              //branch
		              ((Branch == 1'b1 && ALUOp==3'b001) && (Funct3==3'b110 || Funct3==3'b111)) ||// for BLT, BGE
		               //R-Type                                 //SUB                                    // SRL or SRA      //SLL                                       
                      (((ALUOp==3'b010)) &&  ((Funct3==3'b000 && Funct7==7'b0100000) || Funct3==3'b101 || Funct3==3'b001));
                      
                      //JAL, JALR, LUI, AUIPC
 assign Operation[3]= (Branch == 1'b1) && (ALUOp==3'b001);
 
 assign Operation[4]= 
                      //JAL, JALR, LUI, AUIPC
                      ((Branch == 1'b1) && (ALUOp==3'b100 || ALUOp==3'b101 || ALUOp==3'b110 || ALUOp==3'b111)) ||
                      //R-Type                                //SLT             //SLTU
                      (((ALUOp==3'b010)) &&  (Funct3==3'b010 || Funct3==3'b011)) ||
                      //Load                //LB               //LH               //LW                 //LBU                //LHU
                      ((ALUOp==3'b000)  && ((Funct3==3'b000) || (Funct3==3'b001) || (Funct3==3'b010)  || (Funct3==3'b100)  || (Funct3==3'b101)));
                      
endmodule
