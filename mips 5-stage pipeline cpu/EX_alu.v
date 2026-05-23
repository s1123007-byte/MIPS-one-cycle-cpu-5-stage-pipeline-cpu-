`timescale 1ns / 1ps
module EX_alu(alu_in1,alu_in2,EX_ALUctr,EX_ALUout,EX_shamt);
input [31:0] alu_in1;
input [31:0] alu_in2;
input [3:0] EX_ALUctr;//alu控制訊號
input[4:0] EX_shamt;
output reg[31:0]EX_ALUout;
parameter ADD =4'b0000 ;//parameter作用是定義參數
parameter SUB =4'b0001 ;
parameter OR =4'b0010 ;
parameter AND =4'b0011;
parameter LUI =4'b1001;
parameter NOR =4'b0100;
parameter SLTU =4'b0101;
parameter SLT  = 4'b0110;
parameter SLL  = 4'b0111;
parameter XOR = 4'b1000;

//three conditions
always@(*)begin
case(EX_ALUctr)
    ADD:begin 
        EX_ALUout =  alu_in1 + alu_in2;// add
    end
    SUB:begin
        EX_ALUout =  alu_in1 - alu_in2;// sub
    end
    AND:begin
        EX_ALUout =  alu_in1 & alu_in2; // and
    end
    OR:begin 
       EX_ALUout =  alu_in1 | alu_in2; // or
    end
    LUI:begin
     EX_ALUout = {alu_in2[15:0], 16'b0};
    end
    NOR:begin
        EX_ALUout = ~(alu_in1 | alu_in2);
    end
    SLTU:begin
            if (alu_in1 < alu_in2) 
            EX_ALUout = 32'b1;
            else
                EX_ALUout = 32'b0;
        end
    SLT: begin // 有符號比較，一定要加 $signed
            if ($signed(alu_in1) < $signed(alu_in2)) 
            EX_ALUout = 32'b1;
            else                               
            EX_ALUout = 32'b0;
        end
    SLL: begin  
        EX_ALUout = alu_in2 << EX_shamt;
        end
    XOR:begin
        EX_ALUout = alu_in1 ^ alu_in2;
    end
    default:begin
        EX_ALUout = 32'b0;
    end
endcase
end
endmodule
