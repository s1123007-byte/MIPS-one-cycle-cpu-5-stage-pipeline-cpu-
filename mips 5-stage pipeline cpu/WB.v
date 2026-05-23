`timescale 1ns / 1ps
module WB(WB_MemtoReg,WB_read_data,WB_address,WB_write_data,WB_write_reg,WB_rd);
    input WB_MemtoReg;           // 來自 DM_WB 的控制訊號
    input [31:0] WB_read_data;   // 從 Data Memory 讀出的資料 (給 lw 用)
    input [31:0] WB_address;      // ALU 算出的運算結果 (給 add, sub 等 R-type 用)
    input [4:0]  WB_rd;
    output reg [31:0] WB_write_data; //準備寫回 Register File 的資料
    output [4:0] WB_write_reg;
    always @(*) begin
        if (WB_MemtoReg) begin
            // 如果是 lw 指令，選擇記憶體讀出的資料
            WB_write_data = WB_read_data;
        end 
        else begin
            // 如果是 R-type 指令，選擇 ALU 算出的資料
            WB_write_data = WB_address;
        end
    end
assign WB_write_reg = WB_rd;

endmodule