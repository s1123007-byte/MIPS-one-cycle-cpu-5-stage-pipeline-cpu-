`timescale 1ns / 1ps
module mips_pipeline(clk, rst);
    input clk, rst;
    // --- IF 階段 ---
    wire [31:0] IF_instruction;
    wire [31:0] ID_instruction;
    wire [31:0] IF_PC_plus_4;
    wire PCWrite;           // 來自 Hazard Unit，決定要不要暫停 PC (1-bit)
    wire [1:0] nPC_sel;     // 來自 Control Unit/Branch 邏輯，決定下一筆 PC (2-bit)
    wire zero;              // 來自 ALU 的比較結果 (1-bit)
    wire [31:0] t1;         // 來自 EX 階段算好的 Branch 目標地址 (32-bit)
    wire [31:0] jump_target = {ID_PC_plus_4[31:28], ID_instruction[25:0], 2'b00};     // Jump 的目標 (26-bit)
    wire flush;
    wire bne;
    IF ifu(.clk(clk),.rst(rst),.PCWrite(PCWrite),.IF_instruction(IF_instruction),
            .IF_PC_plus_4(IF_PC_plus_4),.nPC_sel(nPC_sel),.t1(t1),.zero(zero),.jump_target(jump_target),.flush(flush),.bne(bne));
    //IF_ID
    wire [31:0] ID_PC_plus_4;
    wire IF_ID_Write;
    IF_ID if_id (.clk(clk),.rst(rst),.IF_instruction(IF_instruction),.IF_PC_plus_4(IF_PC_plus_4),
                 .ID_instruction(ID_instruction),.ID_PC_plus_4(ID_PC_plus_4),.IF_ID_Write(IF_ID_Write),.flush(flush));
    // --- ID 階段 ---
    wire [3:0] ID_ALUctr;
    wire ID_RegDst,ID_RegWr,ID_MemtoReg,ID_MemWr,ID_ALUSrc,j_sel,ID_MemRead;
    wire stall;
    ctrl id_ctrl(.stall(stall),.instruction(ID_instruction),.ALUctr(ID_ALUctr),.nPC_sel(nPC_sel),.RegDst(ID_RegDst),.RegWr(ID_RegWr),
                 .MemtoReg(ID_MemtoReg),.MemWr(ID_MemWr),.ALUSrc(ID_ALUSrc),.j_sel(j_sel),.MemRead(ID_MemRead),.bne(bne));
    wire [31:0] read_data1,read_data2;
    wire WB_RegWr;
    wire [4:0] WB_write_reg;
    wire [31:0] WB_write_data;    
    wire [4:0]read_reg1,read_reg2;
    register_file id_register_file(.clk(clk), .rst(rst),.read_reg1(ID_instruction[25:21]),.read_reg2(ID_instruction[20:16]),
    .read_data1(read_data1),.read_data2(read_data2),.WB_write_reg(WB_write_reg),.WB_write_data(WB_write_data),.WB_RegWr(WB_RegWr));
    wire [4:0] ID_EX_register_rs;
    wire [4:0] ID_EX_register_rt;
    wire [4:0] ID_EX_register_rd;
    wire [4:0] ID_EX_register_rt_mux;
    wire [31:0] ID_imm_ext;
    wire [31:0] ID_EX_PC_plus_4;
    wire[4:0]ID_shamt;
    ID id(.ID_PC_plus_4(ID_PC_plus_4),.ID_instruction(ID_instruction),.ID_EX_register_rs(ID_EX_register_rs),.ID_EX_register_rt(ID_EX_register_rt),
    .ID_EX_register_rd(ID_EX_register_rd),.ID_EX_register_rt_mux(ID_EX_register_rt_mux), .ID_imm_ext(ID_imm_ext),
    .ID_EX_PC_plus_4(ID_EX_PC_plus_4),.t1(t1),.ID_shamt(ID_shamt));
    wire [4:0] EX_register_rt_mux;
    wire EX_MemRead;
    wire [4:0] IF_ID_register_rs,IF_ID_register_rt;
    hazard_detection id_hazard_detection(.EX_register_rt_mux(EX_register_rt_mux),.IF_ID_register_rs(ID_instruction[25:21]),
    .IF_ID_register_rt(ID_instruction[20:16]),.EX_MemRead(EX_MemRead),.PCWrite(PCWrite),.IF_ID_Write(IF_ID_Write),.stall(stall));
    //ID_EX
    wire [3:0] EX_ALUctr;
    wire EX_RegDst, EX_RegWr, EX_MemtoReg, EX_MemWr, EX_ALUSrc;
    wire [31:0] EX_imm_ext;
    wire [31:0] EX_read_data1, EX_read_data2;
    wire [4:0] EX_register_rs, EX_register_rt_forward, EX_register_rd;
    wire[4:0]EX_shamt;
    ID_EX id_ex(.clk(clk),.rst(rst),.ID_ALUctr(ID_ALUctr),.ID_RegWr(ID_RegWr),.ID_MemtoReg(ID_MemtoReg),.ID_MemWr(ID_MemWr), 
                .ID_ALUSrc(ID_ALUSrc),.ID_RegDst(ID_RegDst),.ID_MemRead(ID_MemRead),.ID_EX_PC_plus_4(ID_EX_PC_plus_4),
                .read_data1(read_data1),.read_data2(read_data2),.ID_imm_ext(ID_imm_ext),.ID_EX_register_rs(ID_EX_register_rs),
                .ID_EX_register_rt(ID_EX_register_rt),.ID_EX_register_rd(ID_EX_register_rd),.ID_EX_register_rt_mux(ID_EX_register_rt_mux),
                .EX_ALUctr(EX_ALUctr),.EX_RegDst(EX_RegDst),.EX_RegWr(EX_RegWr),.EX_MemtoReg(EX_MemtoReg),.EX_MemWr(EX_MemWr), 
                .EX_ALUSrc(EX_ALUSrc),.EX_MemRead(EX_MemRead),.EX_imm_ext(EX_imm_ext),.EX_read_data1(EX_read_data1),
                .EX_read_data2(EX_read_data2),.EX_register_rs(EX_register_rs),.EX_register_rt_forward(EX_register_rt_forward),
                .EX_register_rd(EX_register_rd),.EX_register_rt_mux(EX_register_rt_mux),.EX_shamt(EX_shamt),.ID_shamt(ID_shamt));
    // --- EX 階段 ---
    wire [4:0] MEM_rd,WB_rd;
    wire MEM_RegWr;
    wire [1:0] ForwardA, ForwardB;
    wire [31:0] MEM_ALUout;
    wire [31:0] alu_in1, alu_in2;
    wire [31:0] EX_write_data;
    EX_forwarding ex_forwarding(.EX_register_rs(EX_register_rs),.EX_register_rt_forward(EX_register_rt_forward),.MEM_rd(MEM_rd),
                               .WB_rd(WB_write_reg),.MEM_RegWr(MEM_RegWr),.WB_RegWr(WB_RegWr),.ForwardA(ForwardA),.ForwardB(ForwardB));
    EX_mux ex_mux(.EX_read_data1(EX_read_data1),.EX_read_data2(EX_read_data2),.MEM_ALUout(MEM_ALUout),.WB_write_data(WB_write_data),
                  .EX_imm_ext(EX_imm_ext),.ForwardA(ForwardA),.ForwardB(ForwardB),.EX_ALUSrc(EX_ALUSrc),.alu_in1(alu_in1),
                  .alu_in2(alu_in2),.EX_write_data(EX_write_data));
    wire [31:0] EX_ALUout;
    EX_alu ex_alu (.alu_in1(alu_in1),.alu_in2(alu_in2),.EX_ALUctr(EX_ALUctr),.EX_ALUout(EX_ALUout),.EX_shamt(EX_shamt));
    wire [4:0]  EX_rd;
    EX ex(.EX_RegDst(EX_RegDst),.EX_register_rd(EX_register_rd),.EX_register_rt_mux(EX_register_rt_mux),.EX_rd(EX_rd));
    // EX/DM
    wire MEM_MemtoReg, MEM_MemWr, MEM_MemRead;
    wire [31:0] MEM_write_data;
    EX_DM ex_dm(.clk(clk),.rst(rst),.EX_rd(EX_rd),.EX_write_data(EX_write_data),.EX_ALUout(EX_ALUout),.EX_RegWr(EX_RegWr),
                .EX_MemtoReg(EX_MemtoReg),.EX_MemWr(EX_MemWr),.EX_MemRead(EX_MemRead),.MEM_RegWr(MEM_RegWr),.MEM_MemtoReg(MEM_MemtoReg),
                .MEM_MemWr(MEM_MemWr),.MEM_MemRead(MEM_MemRead),.MEM_ALUout(MEM_ALUout),.MEM_write_data(MEM_write_data),.MEM_rd(MEM_rd));
    // ---MEM 階段---
    wire [31:0] MEM_read_data;
    wire [4:0]  MEM_WB_rd;
    wire [31:0] MEM_address;
    DM dm(.clk(clk),.rst(rst),.MEM_MemWr(MEM_MemWr),.MEM_MemRead(MEM_MemRead),.MEM_ALUout(MEM_ALUout),.MEM_write_data(MEM_write_data),
          .MEM_rd(MEM_rd),.MEM_read_data(MEM_read_data),.MEM_WB_rd(MEM_WB_rd),.MEM_address(MEM_address));
    //DM/WB
    wire [31:0] WB_read_data;
    wire [31:0] WB_address; // 即 WB 階段的 ALUout
    wire WB_MemtoReg;
    DM_WB dm_wb(.clk(clk), .rst(rst),.MEM_RegWr(MEM_RegWr),.MEM_MemtoReg(MEM_MemtoReg),.MEM_read_data(MEM_read_data),
        .MEM_address(MEM_address),.MEM_WB_rd(MEM_WB_rd),.WB_RegWr(WB_RegWr),.WB_MemtoReg(WB_MemtoReg),.WB_read_data(WB_read_data),
        .WB_address(WB_address),.WB_rd(WB_rd));
    // ---WB 階段---
    WB wb(.WB_MemtoReg(WB_MemtoReg),.WB_read_data(WB_read_data),.WB_address(WB_address),.WB_rd(WB_rd),
          .WB_write_data(WB_write_data),.WB_write_reg(WB_write_reg));
//ID 階段專用beq指令Forwarding & Zero 判斷
reg [31:0] cmp_data1;
reg [31:0] cmp_data2;
wire [4:0] id_rs = ID_instruction[25:21];
wire [4:0] id_rt = ID_instruction[20:16];
always @(*) begin
    // 判斷第一個來源rs是否需要從EX或MEM階段抄近路
    if (EX_RegWr && (EX_rd == id_rs) && (id_rs != 5'b0)) begin
        cmp_data1 = EX_ALUout;
    end
    else if (MEM_RegWr && (MEM_WB_rd == id_rs) && (id_rs != 5'b0)) begin
        //補上這裡的判斷：如果是 lw 指令，要抓 read_data
        if (MEM_MemRead)
            cmp_data1 = MEM_read_data;
        else
            cmp_data1 = MEM_ALUout;
    end
    else begin
        cmp_data1 = read_data1; // 都沒有衝突就用暫存器讀出來的原值
    end
    // 判斷第二個來源rt是否需要從 EX 或 MEM 階段抄近路
    if (EX_RegWr && (EX_rd == id_rt) && (id_rt != 5'b0)) begin
        cmp_data2 = EX_ALUout;
    end
    else if (MEM_RegWr && (MEM_WB_rd == id_rt) && (id_rt != 5'b0)) begin
        // ★ 補上這裡的判斷：如果是 lw 指令，要抓 read_data
        if (MEM_MemRead)
            cmp_data2 = MEM_read_data;
        else
            cmp_data2 = MEM_ALUout;
    end
    else begin
        cmp_data2 = read_data2;
    end
end
// 比較兩者是否相等，產生 zero 訊號給 Control Unit (IF 階段的 nPC_sel 切換用)
assign zero = (cmp_data1 == cmp_data2);
endmodule