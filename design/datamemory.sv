`timescale 1ns / 1ps

module datamemory#(
    parameter DM_ADDRESS = 9 ,
    parameter DATA_W = 32,
    parameter DM_OFFSET = 2, 
    parameter DATA = 8
    )(
    input logic clk,
    input logic [2:0] Funct3,
	input logic MemRead , // comes from control unit
    input logic MemWrite , // Comes from control unit
    input logic [ DM_ADDRESS -1:0] a , // Read / Write address - 9 LSB bits of the ALU output
    input logic [ DATA_W -1:0] wd , // Write Data
    output logic [ DATA_W -1:0] rd // Read Data
    );
    //memory split into 4 sections (512x8) Word = mem3 + mem2 + mem1 + mem0
    logic [DATA-1:0] mem3 [512-1:0];
    logic [DATA-1:0] mem2 [512-1:0];
    logic [DATA-1:0] mem1 [512-1:0];
    logic [DATA-1:0] mem0 [512-1:0];
    logic [DM_OFFSET-1:0] mem_sel;
    assign mem_sel = a[1:0];
    
    always_comb 
    begin
       if(MemRead) begin
            
            //LB
            if(Funct3 == 3'b000)
            begin
                //[7:0] selected
                if(mem_sel == 2'b00)
                    rd = {mem0[a][7]? 24'b111111111111111111111111:24'b0,mem0[a]};
                //[15:8] selected
                if(mem_sel == 2'b01)
                    rd = {mem1[a][7]? 16'b1111111111111111:16'b0 ,mem1[a], 8'b0};
                //[24:16] selected
                if(mem_sel == 2'b10)
                    rd = {mem2[a][7]? 8'b11111111:8'b0 ,mem2[a],  16'b0};
                //[31:25] selected
                if(mem_sel == 2'b11)
                    rd = {mem3[a], 24'b0};
             end
            
            //LH
            if (Funct3 == 3'b001)
            begin
                //[15:0] selected
                if((mem_sel == 2'b00) || (mem_sel == 2'b10))
                    rd = {mem1[a][7]? 16'b1111111111111111:16'b0 ,mem1[a],mem0[a]};
                 //[31:16] selected
                if((mem_sel == 2'b01) || (mem_sel == 2'b11))
                       rd = {mem3[a],mem2[a],16'b0};
            end
                                                       
             //LW
            if (Funct3 == 3'b010)
                rd = {mem3[a],mem2[a],mem1[a],mem0[a]};
            
            //LBU
           if (Funct3 == 3'b100)
           begin
                //[7:0] selected
                if(mem_sel == 2'b00)
                    rd = {24'b0 ,mem0[a]};
                //[15:8] selected
                if(mem_sel == 2'b01)
                    rd = {16'b0 ,mem1[a], 8'b0};
                //[24:16] selected
                if(mem_sel == 2'b10)
                    rd = {8'b0 ,mem2[a],  16'b0};
                //[31:25] selected
                if(mem_sel == 2'b11)
                    rd = {mem3[a], 24'b0};
            end
            //LHU
           if (Funct3 == 3'b101)
           begin
                //[15:0] selected
                if((mem_sel == 2'b00) || (mem_sel == 2'b10))
                    rd = {16'b0 ,mem1[a],mem0[a]};
                //[31:16] selected
                if((mem_sel == 2'b01) || (mem_sel == 2'b11))
                    rd = {mem3[a],mem2[a],16'b0};
           end
            
	end
	end
    
    always @(posedge clk) begin
       if (MemWrite) begin
            //LB
            //SB
            if(Funct3 == 3'b000)
            begin
                //[7:0] selected
                if(mem_sel == 2'b00) 
                    mem0[a] = wd[7:0];
                  
                //[15:8] selected
                if(mem_sel == 2'b01)
                   mem1[a] = wd[7:0];
                  
                //[24:16] selected
                if(mem_sel == 2'b10)
                    mem2[a] = wd[7:0];
                   
                //[31:25] selected
                if(mem_sel == 2'b11) 
                    mem3[a] = wd[7:0];
                         
              end       
            //LH
            if (Funct3 == 3'b001)
            begin
                //[15:0] selected
                if((mem_sel == 2'b00) || (mem_sel == 2'b10)) begin
                    mem0[a] = wd[7:0];
                    mem1[a] = wd[15:8];
                    end
                 //[31:16] selected
                if((mem_sel == 2'b01) || (mem_sel == 2'b11)) begin
                    mem2[a] = wd[7:0];
                    mem3[a] = wd[15:8];                    
                    end
            end                                           
             //LW
            if (Funct3 == 3'b010) begin
                    mem0[a] = wd[7:0];
                    mem1[a] = wd[15:8];
                    mem2[a] = wd[23:16];
                    mem3[a] = wd[31:24];
                           
            end   
    end
    end
    
endmodule

