`timescale 1ns / 1ps
module register_file(clk, rst, WB_RegWr, read_reg1, read_reg2, WB_write_reg,
                     WB_write_data, read_data1, read_data2);
    input clk;
    input rst;
    input WB_RegWr;               // 控制暫存器是否寫入訊號(來自 WB 階段)
    input [4:0] read_reg1;        // rs
    input [4:0] read_reg2;        // rt
    input [4:0] WB_write_reg;     // 目的暫存器(rd 或 rt)
    input [31:0] WB_write_data;   // 準備寫入暫存器的資料
    output reg [31:0] read_data1; // 讀出的資料 1 (對應 read_reg1)
    output reg [31:0] read_data2; // 讀出的資料 2 (對應 read_reg2)
    reg [31:0] regi [31:0];       // 宣告 32 個 32bits 寬度的暫存器
    integer i;                    // 設置變數
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // 系統重置時，將所有 32 個暫存器清零
            for (i = 0; i < 32; i = i + 1) regi[i] <= 32'b0;
        end 
        else if (WB_RegWr && WB_write_reg != 5'd0) begin
            // 正常運作且致能寫入時，將資料寫入指定暫存器 (排除寫入$0)
            regi[WB_write_reg] <= WB_write_data;
        end
        // $0 永遠是 0 (硬體線路強迫接地)
        regi[0] <= 32'b0;
    end
    always @(*) begin
        // 1. 預設情況：直接從暫存器陣列讀取
        read_data1 <= #2 regi[read_reg1];
        // 2. 特殊情況 A：寫入與讀取同時發生在同一地址
        // 如果現在要寫入 (WB_RegWr)，且地址撞到，且不是 $0
        if (WB_RegWr && (read_reg1 == WB_write_reg) && (read_reg1 != 5'd0)) begin
            read_data1 <= #2 WB_write_data;
        end
        // 3. 特殊情況 B：強制 $0 輸出為 0
        if (read_reg1 == 5'd0) begin
            read_data1 <= #2 32'd0;
        end
    end
    always @(*) begin
        // 1. 預設情況：直接從暫存器陣列讀取
        read_data2 <= #2 regi[read_reg2];
        // 2. 特殊情況 A：寫入與讀取同時發生在同一地址
        if (WB_RegWr && (read_reg2 == WB_write_reg) && (read_reg2 != 5'd0)) begin
            read_data2 <= #2 WB_write_data;
        end    
        // 3. 特殊情況 B：強制 $0 輸出為 0
        if (read_reg2 == 5'd0) begin
            read_data2 <= #2 32'd0;
        end
    end

endmodule