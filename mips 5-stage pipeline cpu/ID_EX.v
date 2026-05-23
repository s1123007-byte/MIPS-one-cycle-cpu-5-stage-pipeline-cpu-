`timescale 1ns / 1ps
module ID_EX(clk,rst,ID_ALUctr,ID_RegWr,ID_MemtoReg,ID_MemWr,ID_ALUSrc,ID_RegDst,ID_EX_PC_plus_4,read_data1,read_data2,ID_imm_ext,
ID_EX_register_rs,ID_EX_register_rt,ID_EX_register_rd,ID_EX_register_rt_mux,EX_ALUctr,EX_RegDst,EX_RegWr,EX_MemtoReg,EX_MemWr,EX_ALUSrc,
EX_imm_ext,EX_read_data1,EX_read_data2,EX_register_rt_forward,
EX_register_rd,EX_register_rt_mux,EX_register_rs,EX_MemRead,ID_MemRead,ID_shamt,EX_shamt);
input clk,rst;
input [3:0] ID_ALUctr;
input ID_RegDst;
input ID_RegWr;
input ID_MemtoReg;
input ID_MemWr;
input ID_ALUSrc;
input ID_MemRead;
input [31:0]ID_EX_PC_plus_4;
input [31:0] read_data1;
input [31:0] read_data2;
input [31:0]ID_imm_ext;
input[4:0]ID_EX_register_rs;
input[4:0]ID_EX_register_rt;
input[4:0]ID_EX_register_rd;
input[4:0]ID_EX_register_rt_mux;
input[4:0] ID_shamt;
output reg [3:0] EX_ALUctr;
output reg EX_RegDst;
output reg EX_RegWr;
output reg EX_MemtoReg;
output reg EX_MemWr;
output reg EX_ALUSrc;
output reg EX_MemRead;
output reg [31:0]EX_imm_ext;
output reg [31:0] EX_read_data1;
output reg [31:0] EX_read_data2;
output reg[4:0]EX_register_rs;
output reg[4:0]EX_register_rt_forward;
output reg[4:0]EX_register_rd;
output reg[4:0]EX_register_rt_mux;
output reg[4:0] EX_shamt;

    always @(posedge clk,posedge rst) begin
    if (rst) begin
        // --- 1. 控制訊號清零 ---
        EX_ALUctr <= 3'b000;
        EX_RegDst <= 1'b0;
        EX_RegWr <= 1'b0;
        EX_MemtoReg <= 1'b0;
        EX_MemWr <= 1'b0;
        EX_ALUSrc <= 1'b0;
        // --- 2. 資料與編號清零 ---
        EX_imm_ext <= 32'b0;
        EX_read_data1 <= 32'b0;
        EX_read_data2 <= 32'b0;
        EX_register_rs <= 5'b0;
        EX_register_rt_forward <= 5'b0;
        EX_register_rd <= 5'b0;
        EX_register_rt_mux <= 5'b0;
        EX_MemRead <= 1'b0;
        EX_shamt <=5'b0;
    end 
    else begin
        // --- 正常傳遞到 EX 階段 ---
        EX_ALUctr <= ID_ALUctr;
        EX_RegDst <= ID_RegDst;
        EX_RegWr <= ID_RegWr;
        EX_MemtoReg <= ID_MemtoReg;
        EX_MemWr <= ID_MemWr;
        EX_ALUSrc <= ID_ALUSrc;
        EX_imm_ext <= ID_imm_ext;
        EX_read_data1 <= read_data1;
        EX_read_data2 <= read_data2;
        EX_register_rs <= ID_EX_register_rs;
        EX_register_rt_forward <= ID_EX_register_rt; // 給 Forwarding Unit 判斷用
        EX_register_rd <= ID_EX_register_rd;
        EX_register_rt_mux <= ID_EX_register_rt_mux; // 給 RegDst Mux 選擇用
        EX_MemRead <= ID_MemRead;
        EX_shamt <= ID_shamt;
    end
end
endmodule