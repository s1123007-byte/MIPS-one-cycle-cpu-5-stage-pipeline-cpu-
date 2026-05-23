`timescale 1ns / 1ps
module EX(EX_RegDst, EX_rd, EX_register_rd, EX_register_rt_mux);
    input [4:0] EX_register_rd;     //rd
    input [4:0] EX_register_rt_mux; //rt目標暫存器
    input       EX_RegDst;          // 控制訊號：決定目標暫存器 (1: rd, 0: rt)
    output reg [4:0] EX_rd;         // 最終選擇要寫入的目標暫存器
    always@(*) begin
        if(EX_RegDst) 
            EX_rd = EX_register_rd;     // 當 EX_RegDst 為 1，選擇寫入 rd
        else 
            EX_rd = EX_register_rt_mux; // 當 EX_RegDst 為 0，選擇寫入 rt
    end

endmodule