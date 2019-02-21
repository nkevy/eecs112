`timescale 1ns / 1ps

module tb_top;


//clock and reset signal declaration
  logic tb_clk, reset;
  logic [31:0] tb_WB_Data;
  
  
  sequence sr1;
      !reset ##2 (tb_WB_Data == 32'h2);
  endsequence
  
  property pr1;
      @(posedge tb_clk) !reset |->sr1;
  endproperty
  
  reqRe:assert property(pr1) $display("PASS"); else
                             $display("FAIL");
    //clock generation
  always #10 tb_clk = ~tb_clk;
  
  //reset Generation
  initial begin
    tb_clk = 0;
    reset = 1;
    #25 reset =0;
  end
  
  
  riscv riscV(
      .clk(tb_clk),
      .reset(reset),
      .WB_Data(tb_WB_Data)      
     );

  initial begin
    $readmemb("inst.bin", riscV.dp.instr_mem.Inst_mem);
    assert(riscV.dp.instr_mem.Inst_mem == 32'h300093) $display ("Found Instruction");
        else $error("Wrong Instruction");
    #2500;
    $finish;
   end
endmodule
