`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/07/2018 10:23:43 PM
// Design Name: 
// Module Name: alu
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


module alu#(
        parameter DATA_WIDTH = 32,
        parameter OPCODE_LENGTH = 5
        )(
        input logic [DATA_WIDTH-1:0]    SrcA,
        input logic [DATA_WIDTH-1:0]    SrcB,

        input logic [OPCODE_LENGTH-1:0]    Operation,
        output logic[DATA_WIDTH-1:0] ALUResult,
        output logic ALUZero
        );
    
        always_comb
        begin
            ALUResult = 'd0;
            ALUZero = 'd0;
            case(Operation)
            //R-TYPE
            5'b00000:        // AND
                    ALUResult = SrcA & SrcB;
            5'b00001:        //OR
                    ALUResult = SrcA | SrcB;
            5'b00010:        //ADD
                    ALUResult = SrcA + SrcB;
	        5'b00011:        //XOR
	                ALUResult=SrcA^SrcB;
	        5'b00100:        //srl srli
                    ALUResult = SrcA >> SrcB;
            5'b00101:        //sll slli
                    ALUResult = SrcA << SrcB;
            5'b00110:        //Subtract
                    ALUResult = $signed(SrcA) - $signed(SrcB);
            5'b00111:        //sra srai
                    ALUResult = $signed(SrcA) >>> SrcB;
            5'b10001:        //slti slt
                    ALUResult = ($signed(SrcA) < $signed(SrcB))?(32'b0+1'b1):(32'b0);
            5'b10010:        //sltu sltiu
                    ALUResult = (SrcA < SrcB)?(32'b0+1'b1):32'b0;
            //Load STORE
            5'b10011:       //LB, LH, LW, LBU, LHU
                    ALUResult = SrcA + SrcB;
                    
            //JAL
            5'b10100: 
                    ALUZero = 1'b1;
             //FIX EVERYTHING BELOW
             //JALR
            5'b10101: 
            begin
                    ALUZero = 1'b1;
                    ALUResult = (SrcA + $signed(SrcB)) & ({{31{1'b1}},1'b0});
            end
            //LUI
            5'b10110:
                     ALUZero = 1'b1;  
            //AUIPC
            5'b10110:
                     ALUZero = 1'b1;                       
            //FIX EVERYTHING ABOVE                
                    
            //Branch
            5'b01000:        //rs1 == rs2 BEQ
                    ALUZero = ($signed(SrcA) == $signed(SrcB))?1'b1:1'b0;
            5'b01001:        //rs1 != rs2 BNE
                    ALUZero = ($signed(SrcA) != $signed(SrcB))?1'b1:1'b0;
            5'b01010:        //rs1 < rs2 BLT
                    ALUZero = ($signed(SrcA) < $signed(SrcB))?1'b1:1'b0; 
            5'b01011:        //rs1 >= rs2 BGE
                    ALUZero = ($signed(SrcA) >= $signed(SrcB))?1'b1:1'b0; 
            5'b01100:        //rs1 < rs2 BLTU
                    ALUZero = ($unsigned(SrcA) < $unsigned(SrcB))?1'b1:1'b0;   
            5'b01101:        //rs1 >= rs2 BGEU
                    ALUZero = ($unsigned(SrcA) >= $unsigned(SrcB))?1'b1:1'b0;           
            5'b01110:        //rs1 >= rs2 BGEU
                    ALUZero = 1'b1;               
            default:
                    ALUResult = 'b0;
            endcase
        end
endmodule

