`timescale 1ns / 1ps
module ctrl(instruction,RegDst,RegWr,nPC_sel,ALUctr,MemtoReg,MemWr,ALUSrc,j_sel,stall,MemRead,bne);
input stall;
input [31:0]instruction;
output reg [1:0]nPC_sel;
output reg RegDst,RegWr,MemtoReg,MemWr,ALUSrc,j_sel,MemRead;
output reg [3:0] ALUctr;
output reg bne;
always@(*)begin
    nPC_sel=2'b00;
    RegDst=1'b0;
    RegWr=1'b0;
    ALUctr=4'b0000;
    MemtoReg=1'b0;
    MemWr=1'b0;
    ALUSrc=1'b0;
    j_sel=1'b0;
    MemRead=1'b0;
    bne=1'b0;
if(!stall) begin
    nPC_sel = 2'b00;
    //R-type ADD SUB OR
    if(instruction[31:26]==6'b000000)//opcode
      begin
    //ADD
    if (instruction[5:0]==6'b100000)//function
    begin
    nPC_sel=2'b00;//pc+4
    RegDst=1'b1;//
    RegWr=1'b1;
    ALUctr=4'b0000;
    MemtoReg=1'b0;
    MemWr=1'b0;
    ALUSrc=1'b0; 
    j_sel=1'b0;
    MemRead=1'b0;
    bne=1'b0;
    end
    //SUB
    else if(instruction[5:0]==6'b100010)
    begin 
    nPC_sel=2'b00;
    RegDst=1'b1;
    RegWr=1'b1;
    ALUctr=4'b0001;
    MemtoReg=1'b0;
    MemWr=1'b0;
    ALUSrc=1'b0;
    j_sel=1'b0;
    MemRead=1'b0;
    bne=1'b0;
    end
    //AND
    else if(instruction[5:0]==6'b100100)
    begin
    nPC_sel=2'b00;//pc+4
    RegDst=1'b1;//
    RegWr=1'b1;
    ALUctr=4'b0011;
    MemtoReg=1'b0;
    MemWr=1'b0;
    ALUSrc=1'b0; 
    j_sel=1'b0;
    MemRead=1'b0;
    bne=1'b0;
    end
    //OR
    else if(instruction[5:0]==6'b100101)
    begin
    nPC_sel=2'b00;//pc+4
    RegDst=1'b1;//
    RegWr=1'b1;
    ALUctr=4'b0010;
    MemtoReg=1'b0;
    MemWr=1'b0;
    ALUSrc=1'b0; 
    j_sel=1'b0;
    MemRead=1'b0;
    bne=1'b0;
    end
    //SLT
    else if(instruction[5:0]==6'b101010)
    begin
    nPC_sel=2'b00;//pc+4
    RegDst=1'b1;//
    RegWr=1'b1;
    ALUctr=4'b0110;
    MemtoReg=1'b0;
    MemWr=1'b0;
    ALUSrc=1'b0; 
    j_sel=1'b0;
    MemRead=1'b0;
    bne=1'b0;
    end
    //SLL
    else if(instruction[5:0]==6'b000000)
    begin
    nPC_sel=2'b00;//pc+4
    RegDst=1'b1;//
    RegWr=1'b1;
    ALUctr=4'b0111;
    MemtoReg=1'b0;
    MemWr=1'b0;
    ALUSrc=1'b0; 
    j_sel=1'b0;
    MemRead=1'b0;
    bne=1'b0;
    end
    //SLTU
    else if(instruction[5:0]==6'b101011)
    begin
    nPC_sel=2'b00;//pc+4
    RegDst=1'b1;//
    RegWr=1'b1;
    ALUctr=4'b0101;
    MemtoReg=1'b0;
    MemWr=1'b0;
    ALUSrc=1'b0; 
    j_sel=1'b0;
    MemRead=1'b0;
    bne=1'b0;
    end
    //NOR
    else if(instruction[5:0]==6'b100111)
    begin
    nPC_sel=2'b00;//pc+4
    RegDst=1'b1;//
    RegWr=1'b1;
    ALUctr=4'b0100;
    MemtoReg=1'b0;
    MemWr=1'b0;
    ALUSrc=1'b0; 
    j_sel=1'b0;
    MemRead=1'b0;
    bne=1'b0;
    end
    //XOR
    else if(instruction[5:0]==6'b100110)
    begin
    nPC_sel=2'b00;//pc+4
    RegDst=1'b1;//
    RegWr=1'b1;
    ALUctr=4'b1000;
    MemtoReg=1'b0;
    MemWr=1'b0;
    ALUSrc=1'b0; 
    j_sel=1'b0;
    MemRead=1'b0;
    bne=1'b0;
    end
    end
// ADDI
else if(instruction[31:26] == 6'b001000) begin 
    nPC_sel = 2'b00;
    RegDst = 1'b0;
    RegWr = 1'b1;
    ALUctr = 4'b0000;
    MemtoReg = 1'b0;
    MemWr = 1'b0;
    ALUSrc = 1'b1;
    j_sel = 1'b0;
    MemRead = 1'b0;
    bne=1'b0;
end
//LW
else if(instruction[31:26]==6'b100011)
    begin 
    nPC_sel=2'b00;
    RegDst=1'b0;
    RegWr=1'b1;
    ALUctr=4'b0000;
    MemtoReg=1'b1;
    MemWr=1'b0;
    ALUSrc=1'b1;
    j_sel=1'b0;
    MemRead=1'b1;
    bne=1'b0;
    end 
//SW
else if(instruction[31:26]==6'b101011)
    begin 
    nPC_sel=2'b00;
    RegDst=1'b0;
    RegWr=1'b0;
    ALUctr=4'b0000;
    MemtoReg=1'b0;
    MemWr=1'b1;
    ALUSrc=1'b1;
    j_sel=1'b0;
    MemRead=1'b0;
    bne=1'b0;
    end 
//BEQ
else if(instruction[31:26]==6'b000100)
    begin 
    nPC_sel=2'b01;
    RegDst=1'b0;
    RegWr=1'b0;
    ALUctr=4'b0001;
    MemtoReg=1'b0;
    MemWr=1'b0;
    ALUSrc=1'b0;
    j_sel=1'b0;
    MemRead=1'b0;
    bne=1'b0;
    end
//BNE
else if(instruction[31:26]==6'b000101)
    begin 
    nPC_sel=2'b01;
    RegDst=1'b0;
    RegWr=1'b0;
    ALUctr=4'b0001;
    MemtoReg=1'b0;
    MemWr=1'b0;
    ALUSrc=1'b0;
    j_sel=1'b0;
    MemRead=1'b0;
    bne=1'b1;
    end 
//J
else if(instruction[31:26]==6'b000010)
    begin 
    nPC_sel=2'b10;
    RegDst=1'b0;
    RegWr=1'b0;
    ALUctr=4'b0000;
    MemtoReg=1'b0;
    MemWr=1'b0;
    ALUSrc=1'b0;
    j_sel=1'b1;
    MemRead=1'b0;
    bne=1'b0;
    end 
// LUI 
else if(instruction[31:26] == 6'b001111) begin
    nPC_sel = 2'b00;
    RegDst = 1'b0;
    RegWr = 1'b1;     
    ALUctr = 4'b1001;   
    MemtoReg = 1'b0;  
    MemWr = 1'b0;
    ALUSrc = 1'b1;    
    j_sel = 1'b0;
    MemRead = 1'b0;
    bne=1'b0;
    end
// ORI
else if(instruction[31:26] == 6'b001101) begin
    nPC_sel = 2'b00;
    RegDst = 1'b0;
    RegWr = 1'b1; 
    ALUctr = 4'b0010; 
    MemtoReg = 1'b0;
    MemWr = 1'b0;
    ALUSrc = 1'b1; 
    j_sel = 1'b0;
    MemRead = 1'b0;
    bne=1'b0;
    end
end
end
endmodule
