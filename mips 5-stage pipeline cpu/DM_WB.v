`timescale 1ns / 1ps
module DM_WB(clk, rst,MEM_RegWr, MEM_MemtoReg,MEM_read_data, MEM_address, MEM_WB_rd,WB_RegWr, WB_MemtoReg,WB_read_data, WB_address, WB_rd);
    input clk, rst;
    input MEM_RegWr;
    input MEM_MemtoReg;
    input [31:0] MEM_read_data; // 從 Data Memory 讀出的資料
    input [31:0] MEM_address;   // ALU 算出的結果 
    input [4:0]  MEM_WB_rd;     // 目標暫存器編號
    output reg WB_RegWr;
    output reg WB_MemtoReg;
    output reg [31:0] WB_read_data;
    output reg [31:0] WB_address;
    output reg [4:0]  WB_rd;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // 重置時，所有輸出清零
            WB_RegWr     <= 1'b0;
            WB_MemtoReg  <= 1'b0;
            WB_read_data <= 32'b0;
            WB_address    <= 32'b0;
            WB_rd        <= 5'b0;
        end 
        else begin
            // 正常運作時：將 MEM 階段的訊號傳給WB 階段
            WB_RegWr     <= MEM_RegWr;
            WB_MemtoReg  <= MEM_MemtoReg;
            WB_read_data <= MEM_read_data;
            WB_address    <= MEM_address;
            WB_rd        <= MEM_WB_rd;
        end
    end

endmodule