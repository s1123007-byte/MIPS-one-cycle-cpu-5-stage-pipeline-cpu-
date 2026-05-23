`timescale 1ns / 1ps
module mux_RegDst(rd, rt, rw, RegDst);
    input [4:0] rd, rt;   // rd: R-type 的目標暫存器位址；rt: I-type 的目標暫存器位址
    input RegDst;         // 來自 Control Unit 的控制訊號
    output reg [4:0] rw;  // 最終決定要寫入的暫存器編號

    always @(*) begin
        if (RegDst) 
            rw = rd;      // 若為 R-type 指令寫入 rd
        else 
            rw = rt;      // 若為 I-type 指令寫入 rt
    end
endmodule