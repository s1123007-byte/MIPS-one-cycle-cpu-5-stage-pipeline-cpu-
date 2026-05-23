`timescale 1ns / 1ps
module gpr(RegWr, ra, rb, rw, busW, clk, rst, busA, busB, Data_in);
    // 定義輸入輸出埠
    input clk, rst, RegWr;
    input [31:0] busW;          // 寫入暫存器的資料 (來自 ALU 或 Memory)
    input [4:0] ra, rb, rw;     // ra, rb 為讀取位址；rw 為寫入位址 (5-bit 可定址 32 個暫存器)
    output [31:0] busA, busB;   // 讀取出的資料
    output [31:0] Data_in;      // 傳給 Data Memory 的資料
    
    // 內部存儲與計數變數
    reg [31:0] regi [31:0];     // 定義 32 個 32-bit 的暫存器空間 (Register File)
    integer i;

    // --- 組合邏輯部分 (讀取) ---
    assign #2 busA = regi[ra];     // 根據 ra 位址非同步輸出暫存器數值
    assign #2 busB = regi[rb];     // 根據 rb 位址非同步輸出暫存器數值
    assign Data_in = busB;      // 將讀取出的 busB 同步導向 Data Memory (供 SW 指令使用)

    // --- 時序邏輯部分 (寫入與重置) ---
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // 清0：當 rst 為1時，將 32 個暫存器全部清零
            for (i = 0; i < 32; i = i + 1) begin
                regi[i] <= 32'd0; 
            end
        end 
        else begin
            // 正常運作：在時脈正緣且 RegWr =1時進行寫入
            if (RegWr) begin
                regi[rw] <= busW;   // 將 busW 的資料寫入指定的 rw 暫存器 (Write Port)
                regi[0]  <= 0;      // 硬體強制規定：MIPS $0 暫存器內容必須恆為 0，不可被修改
            end
        end
    end
endmodule