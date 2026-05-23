`timescale 1ns / 1ps
//定義輸入輸出
module IF_ID(IF_PC_plus_4,ID_PC_plus_4,clk,rst,IF_ID_Write,IF_instruction,ID_instruction,flush);
input flush;
input clk,rst;
input[31:0]IF_PC_plus_4;
input IF_ID_Write;
input[31:0]IF_instruction;
output[31:0]ID_PC_plus_4;
output[31:0]ID_instruction;
//定義內部訊號
reg[31:0]ID_PC_plus_4;
reg[31:0]ID_instruction;

always @(posedge clk,posedge rst) begin
        if (rst) begin
            // 重置時，清空指令與 PC 資訊
            ID_instruction <=32'h0000_0000;
            ID_PC_plus_4 <=32'h0000_3000;
        end
        else if (flush) begin
            // 當發生 Flush（如跳轉成功），將目前抓到的指令變為 NOP (0x0)
            ID_instruction <=32'h0000_0000;
            ID_PC_plus_4 <= ID_PC_plus_4;
        end
        else if (IF_ID_Write) begin
            // 只有在寫入使能開啟時，才更新數值（對應圖中的同步更新）
            ID_instruction <= IF_instruction;
            ID_PC_plus_4 <= IF_PC_plus_4;
        end
        // 如果 IF_ID_Write 為 0，則維持原值（Stall 效果）
    end

endmodule
