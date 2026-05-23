`timescale 1ns / 1ps
module ext(imm16,imm32,ExtOp);
  input [15:0]imm16;
  input [1:0]ExtOp;//決定是要執行哪一個
  output reg[31:0]imm32;

  //set ZERO,SIGN
  parameter ZERO=2'b00;
  parameter SIGN=2'b01;
  parameter LUI=2'b10;

  //two conditions
  always@(*)begin
    case(ExtOp)
      ZERO:imm32={16'b0,imm16};//imm16第一位是0就把前面都補0變成32bits
      SIGN:imm32={{16{imm16[15]}},imm16};//imm16第1位是1就把前面都補1變成32bits
      LUI:imm32={imm16,16'b0};//將imm16提升16位後面全部補0變成32bits    
      endcase
  end
endmodule
