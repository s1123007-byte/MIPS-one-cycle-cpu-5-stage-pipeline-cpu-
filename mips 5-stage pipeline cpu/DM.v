`timescale 1ns / 1ps
module DM(clk,rst,MEM_MemWr,MEM_MemRead,MEM_ALUout,MEM_write_data,MEM_read_data,MEM_rd,MEM_WB_rd,MEM_address);
    input clk,rst;
    input MEM_MemWr;
    input MEM_MemRead;
    input [31:0] MEM_ALUout;      // ALU 算出來的記憶體地址
    input [31:0] MEM_write_data;
    input [4:0] MEM_rd;  //目標暫存器
    output reg [31:0] MEM_read_data;  // 讀出來給 lw 用的資料
    output [4:0] MEM_WB_rd;
    output[31:0] MEM_address;
    reg [7:0] DataMem [1023:0];//DataMemory大小為1KB
    wire [9:0] pointer;
    assign pointer=MEM_ALUout[9:0];//2^10=1024因此擷取 ALU 運算結果的後 10 bits 即可決定 1KB 內的存取位置
    integer i;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            //當 rst 為 1 時，將記憶體全數清零
            for(i=0; i<1024; i=i+1) begin
                DataMem[i] <= 8'b0;
            end
        end
        else if (MEM_MemWr) begin
            // 正常工作模式：當遇到 clk 上升沿且 MemWr 為 1 時寫入資料
            DataMem[pointer]   <= MEM_write_data[31:24];
            DataMem[pointer+1] <= MEM_write_data[23:16];
            DataMem[pointer+2] <= MEM_write_data[15:8];
            DataMem[pointer+3] <= MEM_write_data[7:0];
        end
    end
    always @(*) begin
        if (MEM_MemRead) begin
            MEM_read_data  <= #2 { DataMem[pointer], DataMem[pointer+1], DataMem[pointer+2], DataMem[pointer+3]};
        end
        else begin
        // 如果不是讀取指令，就輸出全 0，避免雜訊
        MEM_read_data <= #2  32'b0;
        end
    end
assign MEM_WB_rd = MEM_rd;
assign #1 MEM_address = MEM_ALUout;
endmodule