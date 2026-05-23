`timescale 1ns / 1ps
module alu(busA, busB, ALUctr, zero, ALU_out, Addr, shamt);
    input  [31:0] busA, busB;    // 來自暫存器或立即數的 32-bit 運算元
    input  [3:0]  ALUctr;       // 由 Control Unit 產生的 ALU 控制訊號
    output        zero;         // 用於分支指令
    output [31:0] Addr;         // 輸出運算結果作為記憶體位址
    output reg [31:0] ALU_out;  // 運算結果
    input  [4:0]  shamt;        // 位移量 (Shift Amount)，來自指令碼第 6-10 位

    // --- 定義 ALU 控制訊號參數 (Parameter) ---
    parameter ADD  = 4'b0000;   // 加法
    parameter SUB  = 4'b0001;   // 減法
    parameter OR   = 4'b0010;   // 邏輯OR
    parameter AND  = 4'b0011;   // 邏輯AND
    parameter NOR  = 4'b0100;   // 邏輯NOR
    parameter SLTU = 4'b0101;   // 無符號小於則輸出1
    parameter SLT  = 4'b0110;   // 有符號小於則輸出1
    parameter SLL  = 4'b0111;   // 邏輯左移
    parameter XOR  = 4'b1000;   // 邏輯XOR

    // --- 組合邏輯運算核心 ---
    always@(*) begin
        case(ALUctr)
            ADD: begin
                ALU_out = busA + busB;
            end    
            SUB: begin
                ALU_out = busA - busB;
            end
            OR: begin  // 位元邏輯或：兩者任一為 1 則結果為 1
                ALU_out = busA | busB;
            end
            AND: begin // 位元邏輯與：兩者皆為 1 則結果為 1
                ALU_out = busA & busB;
            end
            NOR: begin // 位元邏輯反OR
                ALU_out = ~(busA | busB);
            end
            SLTU: begin // 無符號數值比較
                if (busA < busB) 
                    ALU_out = 32'b1;
                else
                    ALU_out = 32'b0;
            end
            SLT: begin // 有符號數值比較：使用 $signed Verilog 就會按照 2 的補數 (2's Complement) 來處理，正確識別第一位是正號還是負號。
                if ($signed(busA) < $signed(busB)) 
                    ALU_out = 32'b1;
                else                               
                    ALU_out = 32'b0;
            end
            SLL: begin // 位移運算：將 busB 的內容左移 shamt 位
                ALU_out = busB << shamt;
            end
            XOR: begin // 位元邏輯兩者不同則為 1
                ALU_out = busA ^ busB;//^相同為 0，不同為 1
            end
            default: begin // 失敗輸出0
                ALU_out = 32'b0;
            end
        endcase
    end

    // 當 ALU 運算結果為 0 時，zero 訊號設為 1 (常用於 BEQ 指令判斷)
    assign zero = (ALU_out == 32'b0);
    
    // 將 ALU 運算結果直接對應至 Addr 輸出 (常用於 LW/SW 位址計算)
    assign #1 Addr = ALU_out;

endmodule