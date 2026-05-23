`timescale 1ns / 1ps
module EX_DM(clk,rst,EX_rd,EX_write_data,EX_ALUout,EX_RegWr,EX_MemtoReg,EX_MemWr,EX_MemRead,
MEM_RegWr, MEM_MemtoReg, MEM_MemWr, MEM_MemRead,MEM_ALUout,MEM_write_data,MEM_rd);
input clk, rst;
input [4:0] EX_rd;
input[31:0] EX_write_data;
input[31:0]EX_ALUout;
input EX_RegWr;
input EX_MemtoReg;
input EX_MemWr;
input EX_MemRead;
output reg MEM_RegWr, MEM_MemtoReg, MEM_MemWr, MEM_MemRead;
output reg [31:0] MEM_ALUout;
output reg [31:0] MEM_write_data;
output reg [4:0] MEM_rd;
always @(posedge clk or posedge rst) begin
        if (rst) begin
            //重置時所有訊號清零
            MEM_RegWr <= 1'b0;
            MEM_MemtoReg <= 1'b0;
            MEM_MemWr <= 1'b0;
            MEM_MemRead <= 1'b0;
            MEM_ALUout <= 32'b0;
            MEM_write_data <= 32'b0;
            MEM_rd <= 5'b0;
        end 
        else begin
            //正常執行：把 EX 的值存進 MEM 暫存器
            MEM_RegWr <= EX_RegWr;
            MEM_MemtoReg <= EX_MemtoReg;
            MEM_MemWr <= EX_MemWr;
            MEM_MemRead <= EX_MemRead;
            MEM_ALUout <= EX_ALUout;
            MEM_write_data <= EX_write_data;
            MEM_rd <= EX_rd;
        end
    end
endmodule