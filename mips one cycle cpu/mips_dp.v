`timescale 1ns / 1ps
module mips_dp(clk,rst,RegDst,RegWr,ExtOp,nPC_sel,ALUctr,MemtoReg,MemWr,ALUSrc,Instruction,bne);
input clk,rst;
input [1:0]ExtOp,nPC_sel;
input[3:0]ALUctr;
input ALUSrc,MemWr,MemtoReg,RegDst,RegWr;
wire [31:0]instruction;
wire [31:0]busA,busB,busW,Mux_ALUSrc_out,imm32,ALU_out,Addr,Data_in,Data_out;
wire zero;
wire [4:0]rw;
wire [25:0]jValue;
wire [4:0] shamt;
input bne;

output [31:0]Instruction;
assign Instruction[31:0]=instruction[31:0];
//connect all component
ifu IFU(.nPC_sel(nPC_sel),.zero(zero),.clk(clk),.rst(rst),.instruction(instruction),.jValue(instruction[25:0]),.bne(bne));
ext EXT(.imm16(instruction[15:0]),.imm32(imm32),.ExtOp(ExtOp));
alu ALU(.busA(busA),.busB(Mux_ALUSrc_out),.ALUctr(ALUctr),.zero(zero),.ALU_out(ALU_out),.Addr(Addr),.shamt(instruction[10:6]));
mux_RegDst MUX_RegDst(.rt(instruction[20:16]),.rd(instruction[15:11]),.rw(rw),.RegDst(RegDst));
mux Mux_ALUSrc(.a0(busB),.a1(imm32),.op(ALUSrc),.out(Mux_ALUSrc_out));
mux Mux_MemtoReg(.a0(ALU_out),.a1(Data_out),.op(MemtoReg),.out(busW));
gpr GPR(.RegWr(RegWr),.ra(instruction[25:21]),.rb(instruction[20:16]),.rw(rw),
.busW(busW),.clk(clk),.rst(rst),.busA(busA),.busB(busB),.Data_in(Data_in));
dm DM(.Data_in(Data_in),.clk(clk),.Addr(Addr),.MemWr(MemWr),.Data_out(Data_out),.rst(rst));

endmodule


