`timescale 1ns / 1ps
module IF(PCWrite,nPC_sel,clk,rst,IF_instruction,IF_PC_plus_4,t1,zero,flush,jump_target,bne);
input clk,rst;                  
input zero;                     //用於判斷分支是否成立
input PCWrite;                  // PC 寫入控制 (1: 正常更新, 0: 暫停更新/Stall)
input[1:0]nPC_sel;              // 下一個 PC 來源選擇 (01: Branch, 10: Jump, 其他: PC+4)
input bne;                      // BNE 指令控制訊號 (1: 當前為 BNE, 0: 當前為 BEQ)
input[31:0]t1;                  // 分支跳躍目標位址
input[31:0] jump_target;        // 跳轉目標位址
output[31:0]IF_instruction;     // 輸出當前讀取的 32-bit 指令
output[31:0]IF_PC_plus_4;       // 輸出當前 PC + 4 的數值給下一級
output reg flush;               // 流水線清空訊號(Control Hazard Flush)

//定義內部訊號
reg [31:0]pc;                   
reg[31:0]pcnew;                 // 下一個暫存 PC 值
reg[7:0]im[1023:0];             // 指令記憶體 (Instruction Memory)大小為1KB
wire[31:0]t0;                   // PC + 4 的結果

// 指令拼接：將 4 個連續的 8-bit Byte 拼接成一個完整的 32-bit 指令輸出
assign IF_instruction={im[pc[9:0]],im[pc[9:0]+1],im[pc[9:0]+2],im[pc[9:0]+3]};
assign t0=pc+4;     

always@(*)//(*)代表即時運算
begin
    flush = 1'b0;               // 預設狀態下，清除訊號為 0
    pcnew = t0;                 // 預設下一個 PC 為 PC + 4
    
    if(nPC_sel==2'b10)begin
        pcnew=jump_target;      // 觸發 Jump 跳轉機制，更新 PC 位址
        flush = 1'b1;           // 發生無條件跳轉，flush變1清除流水線中預抓的指令
    end
    else if(nPC_sel==2'b01)begin//分支跳躍
        // 分支成立條件：(bne=0且zero=1) 或 (bne=1且zero=0)
        if ((bne == 0 && zero == 1) || (bne == 1 && zero == 0)) begin
            pcnew = t1;         // 分支滿足條件，PC 更新為分支目標位址 (Offset)
            flush = 1'b1;       // 分支成功跳轉，flush變1清除流水線中預抓的指令
        end
    end
end

//set IF_pc_plus_4
assign IF_PC_plus_4=pc+4;       // 將 PC + 4 送往下一級流水線暫存器

//reset,clk
always@(posedge clk,posedge rst)//上升(0->1)時動作
begin
    if(rst) begin
        pc<=32'h0000_3000;      // 系統重置時，PC 初始化至 MIPS 定義之起始位址 0x3000
    end
    else if(PCWrite) begin
        pc<=pcnew;              // 當PCWrite=1，載入計算好的下一個 PC 值
    end
    else begin
        pc <= pc;               // 若 PCWrite=0(發生 Stall)，PC 維持原值不變
    end
end
endmodule