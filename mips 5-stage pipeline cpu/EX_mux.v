`timescale 1ns / 1ps
module EX_mux(EX_read_data1,EX_read_data2,MEM_ALUout,WB_write_data,EX_imm_ext,ForwardA,ForwardB,EX_ALUSrc,alu_in1,alu_in2,EX_write_data);
    input [31:0] EX_read_data1,EX_read_data2;
    input [31:0] MEM_ALUout, WB_write_data, EX_imm_ext;
    input [1:0] ForwardA, ForwardB;
    input EX_ALUSrc;
    output reg [31:0] alu_in1;
    output reg [31:0] alu_in2;
    output[31:0] EX_write_data;
    reg [31:0] mux2_in; // 內部暫存選好的 rt
    always @(*) begin
        //處理 ALU 第一個輸入
        case(ForwardA)
            2'b00: alu_in1 = EX_read_data1; // 沒衝突，用原始值
            2'b01: alu_in1 = WB_write_data;    //從 WB 拿
            2'b10: alu_in1 = MEM_ALUout;       //從 MEM 拿
            default: alu_in1 = EX_read_data1;
        endcase

        //處理 ALU 第二個輸入
        // 先選 rt 的轉發
        case(ForwardB)
            2'b00: mux2_in = EX_read_data2;
            2'b01: mux2_in = WB_write_data;
            2'b10: mux2_in = MEM_ALUout;
            default: mux2_in = EX_read_data2;
        endcase
        // 再根據 ALUSrc 決定最後進 ALU 的是 rt 還是立即值
        if (EX_ALUSrc) begin
            alu_in2 = EX_imm_ext; // 例如 addi, lw, sw
        end
        else begin
            alu_in2 = mux2_in; // 例如 add, sub (R-type)
        end
    end
    assign EX_write_data = mux2_in;
endmodule