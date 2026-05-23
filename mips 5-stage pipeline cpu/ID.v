`timescale 1ns / 1ps
module ID(ID_PC_plus_4, ID_instruction, ID_EX_register_rs, ID_EX_register_rt, ID_EX_register_rd,
          ID_imm_ext, ID_EX_PC_plus_4, ID_EX_register_rt_mux,t1, ID_shamt);
    input  [31:0] ID_PC_plus_4;          // 來自 IF/ID 暫存器的 PC+4
    input  [31:0] ID_instruction;        // 來自 IF/ID 暫存器的instruction

    output [4:0]  ID_EX_register_rs;     // 解碼出的 rs 暫存器
    output [4:0]  ID_EX_register_rt;     // 解碼出的 rt 暫存器
    output [4:0]  ID_EX_register_rd;     // 解碼出的 rd 暫存器
    output [4:0]  ID_EX_register_rt_mux; // 傳遞 rt 編號供後續 EX 階段 MUX 選擇目標暫存器
    output reg [31:0] ID_imm_ext;        // 擴充後的 32-bit 立即數
    output [31:0] ID_EX_PC_plus_4;       // 傳遞給下一個管線級的 PC+4
    output [4:0]  ID_shamt;              // 解碼出的 shamt
    output [31:0] t1;                    // 提早計算好的 Branch 跳轉目標位址
    wire [15:0] imm16;                   // 擷取指令中的 16-bit 立即數
    wire [31:0] temp;                    // 儲存擴充後的立即數，準備用於位址計算
    wire [31:0] extout;                  // 將擴充後的立即數左移兩位 (Branch Offset)
    assign ID_EX_PC_plus_4 = ID_PC_plus_4; // 直接將 PC+4 往後傳遞
    // 擷取指令的低 16 位元作為立即數
    assign imm16 = ID_instruction[15:0];
    always @(*) begin
        // 判斷 Opcode 是否為 ORI (001101)(I結尾邏輯指令要零擴展)
        if (ID_instruction[31:26] == 6'b001101) begin
            // 如果是 ORI，執行 Zero-extend (高位補 16 個 0)
            ID_imm_ext = {16'b0, imm16};
        end 
        else begin
            // 如果是其他指令 (如 ADDI, LW, SW)，執行 Sign-extend (補符號位)
            ID_imm_ext = {{16{imm16[15]}}, imm16};
        end
    end
    assign temp = ID_imm_ext[31:0];
    assign ID_EX_register_rs     = ID_instruction[25:21];
    assign ID_EX_register_rt     = ID_instruction[20:16];
    assign ID_EX_register_rt_mux = ID_instruction[20:16];
    assign ID_EX_register_rd     = ID_instruction[15:11];
    assign ID_shamt = ID_instruction[10:6];
    //  分支跳轉目標位址計算 (Branch Address Calculation)
    assign extout = temp[31:0] << 2;     // 左移 2 位 (offset) 乘以 4
    assign t1 = ID_PC_plus_4 + extout;   // 計算 Branch 目標：PC+4 加上位移量
endmodule