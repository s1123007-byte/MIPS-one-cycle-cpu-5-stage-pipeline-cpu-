`timescale 1ns / 1ps
module hazard_detection(EX_register_rt_mux, IF_ID_register_rs, IF_ID_register_rt, 
                        EX_MemRead, PCWrite, IF_ID_Write, stall);
    input [4:0] EX_register_rt_mux; // EX 階段指令的目的暫存器rt
    input [4:0] IF_ID_register_rs;  // ID rs
    input [4:0] IF_ID_register_rt;  // ID rt
    input EX_MemRead;               // EX 階段的控制訊號：是否為記憶體讀取(用來判斷是否為 lw 指令)
    output reg PCWrite;             // 控制 PC 是否更新 (0:PC，不抓取新指令)
    output reg IF_ID_Write;         // 控制 IF/ID 管線暫存器是否更新 (0:保留當前解碼中的指令)
    output reg stall;               // 控制 ID 階段的 Control Mux (1: 插入 NOP 氣泡，將控制訊號清零)
    always @(*) begin
        // 檢查是否發生 Load-Use Hazard
        // 條件一：前一條指令 (在 EX 階段) 是一條 lw 指令 (EX_MemRead == 1)
        if (EX_MemRead) begin
            
            // 條件二：判斷 lw 準備寫入的目的地 (EX_register_rt_mux) 
            // 是否剛好等於當前 ID 階段指令需要讀取的來源暫存器 (rs 或 rt)
            if (EX_register_rt_mux == IF_ID_register_rs || EX_register_rt_mux == IF_ID_register_rt) begin
                //衝突發生執行Stall機制
                PCWrite = 1'b0;      // 凍結 PC，不讓它抓下一條指令
                IF_ID_Write = 1'b0;  // 凍結 IF/ID 暫存器，讓當前發生衝突的指令留在 ID 階段等待
                stall = 1'b1;        // 拉高 stall 訊號，控制 Mux 輸出全 0 (NOP) 給 ID/EX 管線暫存器
            end
            else begin
                //雖然前一條是 lw，但彼此沒有衝突，正常執行
                PCWrite = 1'b1;
                IF_ID_Write = 1'b1;
                stall = 1'b0;
            end
        end
        else begin
            //前一條不是 lw 指令
            //交給 Forwarding Unit處理即可，不需要 Stall 管線
            PCWrite = 1'b1;
            IF_ID_Write = 1'b1;
            stall = 1'b0;
        end
    end
    
endmodule