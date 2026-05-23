`timescale 1ns / 1ps
module dm(Data_in, clk, Addr, MemWr, Data_out, rst);

    // --- 輸入/輸出定義 ---
    input [31:0] Data_in, Addr;  // Data_in: 寫入資料; Addr: 記憶體位址
    input clk, rst, MemWr;       // clk: 時脈; rst: 重置; MemWr: 記憶體寫入致能
    output [31:0] Data_out;      // Data_out: 讀出的 32-bit 資料

    // --- 記憶體空間與指標 ---
    reg [7:0] DataMem[1023:0];   // 定義 1024 格 8-bit 的儲存單元
    wire [9:0] pointer;          // 內部指標
    assign pointer = Addr[9:0];  // 取位址的低 10 位作為索引指標 (對應 1024 格空間)

    // --- 寫入與重置邏輯 ---
    integer i;
    always @(negedge clk or posedge rst) begin
        if (rst) begin
            // 清0：當 rst=1時，清空所有記憶體內容
            for(i = 0; i < 1024; i = i + 1)
                DataMem[i] = 0;  // 將 1024 個 Byte 全部清零
        end
        else begin
            // 寫入邏輯 (Store Word)：在時脈負緣且 MemWr=1 時執行
            if(MemWr == 1) begin
                // 將 32-bit 輸入拆分為四個 8-bit 分別存入連續位址
                DataMem[pointer]     <= Data_in[31:24]; // 存入最高位元組
                DataMem[pointer+1]   <= Data_in[23:16];
                DataMem[pointer+2]   <= Data_in[15:8];
                DataMem[pointer+3]   <= Data_in[7:0];   // 存入最低位元組
            end
        end
    end

    // --- 讀取邏輯 (Load Word)：組合邏輯輸出 ---
    // 非同步讀取：將四個連續位址的 8-bit 資料重新拼接回一個 32-bit 字組
    assign #2 Data_out = { DataMem[pointer], DataMem[pointer+1], DataMem[pointer+2], DataMem[pointer+3] };

endmodule