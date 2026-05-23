module mips(clk,rst);
input clk,rst;
wire [1:0]ExtOp,nPC_sel;
wire [3:0]ALUctr;
wire ALUSrc,MemWr,MemtoReg,RegDst,RegWr;
wire [31:0]instruction;
wire bne;

ctrl CU(.instruction(instruction),.RegDst(RegDst),.RegWr(RegWr),
.ExtOp(ExtOp),.nPC_sel(nPC_sel),.ALUctr(ALUctr),.MemtoReg(MemtoReg),.MemWr(MemWr),.ALUSrc(ALUSrc),.bne(bne));
mips_dp MAIN(.clk(clk),.rst(rst),.RegDst(RegDst),.RegWr(RegWr),
.ExtOp(ExtOp),.nPC_sel(nPC_sel),.ALUctr(ALUctr),.MemtoReg(MemtoReg),.MemWr(MemWr),.ALUSrc(ALUSrc),.Instruction(instruction),.bne(bne));
endmodule