`timescale 1ns / 1ps
module EX_forwarding(EX_register_rs,EX_register_rt_forward,MEM_rd,WB_rd,MEM_RegWr,WB_RegWr,ForwardA,ForwardB);
    input [4:0]EX_register_rt_forward;
    input [4:0]EX_register_rs;
    input [4:0]MEM_rd;
    input [4:0] WB_rd;
    input MEM_RegWr;
    input WB_RegWr;
    output reg [1:0] ForwardA;
    output reg [1:0] ForwardB;

    always @(*) begin
    // 1. 預設不轉發 (走原路)
    ForwardA = 2'b00;
    ForwardB = 2'b00;

    //情況 1：MEM 階段資料forward
    if (MEM_RegWr && (MEM_rd != 5'b0)) begin
        // 如果前一條指令的rd是我現在要用的rs
        if (MEM_rd == EX_register_rs) begin
            ForwardA = 2'b10; // 結果：ForwardA 設為2從MEM把資料forward
        end
        // 如果前一條指令的rd是我現在要用的rt
        if (MEM_rd == EX_register_rt_forward) begin
            ForwardB = 2'b10; // 結果：ForwardB 設為2從MEM把資料forward
        end
    end

    //情況 2：WB階段資料forward
    if (WB_RegWr && (WB_rd != 5'b0)) begin
        // 判斷 rs：MEM階段沒有forward時才forward WB
        if (WB_rd == EX_register_rs && ForwardA == 2'b00) begin
            ForwardA = 2'b01; // 結果：ForwardA設為從WB把資料forward
        end
        
        // 判斷 rt
        if (WB_rd == EX_register_rt_forward && ForwardB == 2'b00) begin
            ForwardB = 2'b01;
        end
    end
end
endmodule