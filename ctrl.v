`timescale 1ns / 1ps
module ctrl(instruction, RegDst, RegWr, ExtOp, nPC_sel, ALUctr, MemtoReg, MemWr, ALUSrc, bne);
    input [31:0] instruction;
    output reg [1:0] ExtOp, nPC_sel;
    output reg RegDst, RegWr, MemtoReg, MemWr, ALUSrc, bne;
    output reg [3:0] ALUctr;

    // --- 訊號初始清零 ---
    initial begin
        nPC_sel  = 0;
        RegDst   = 0;
        RegWr    = 0;
        ExtOp    = 0;
        ALUctr   = 0;
        MemtoReg = 0;
        MemWr    = 0;
        ALUSrc   = 0;
        bne      = 1'b0;
    end

    always @(*) begin
        // --- R-type 指令判定 (Opcode 為 000000) ---
        if (instruction[31:26] == 6'b000000) begin
            // ADD (加法)
            if (instruction[5:0] == 6'b100000) begin
                nPC_sel=2'b00; RegDst=1'b1; RegWr=1'b1; ExtOp=2'b00; ALUctr=4'b0000;
                MemtoReg=1'b0; MemWr=1'b0; ALUSrc=1'b0; bne=1'b0;
            end
            // SUB (減法)
            else if (instruction[5:0] == 6'b100010) begin 
                nPC_sel=2'b00; RegDst=1'b1; RegWr=1'b1; ExtOp=2'b00; ALUctr=4'b0001;
                MemtoReg=1'b0; MemWr=1'b0; ALUSrc=1'b0; bne=1'b0;
            end
            // AND
            else if (instruction[5:0] == 6'b100100) begin
                nPC_sel=2'b00; RegDst=1'b1; RegWr=1'b1; ExtOp=2'b00; ALUctr=4'b0011;
                MemtoReg=1'b0; MemWr=1'b0; ALUSrc=1'b0; bne=1'b0;
            end
            // OR
            else if (instruction[5:0] == 6'b100101) begin
                nPC_sel=2'b00; RegDst=1'b1; RegWr=1'b1; ExtOp=2'b00; ALUctr=4'b0010;
                MemtoReg=1'b0; MemWr=1'b0; ALUSrc=1'b0; bne=1'b0;
            end
            // SLT (小於則輸出1)
            else if (instruction[5:0] == 6'b101010) begin
                nPC_sel=2'b00; RegDst=1'b1; RegWr=1'b1; ExtOp=2'b00; ALUctr=4'b0110;
                MemtoReg=1'b0; MemWr=1'b0; ALUSrc=1'b0; bne=1'b0;
            end
            // SLL (邏輯左移)
            else if (instruction[5:0] == 6'b000000) begin
                nPC_sel=2'b00; RegDst=1'b1; RegWr=1'b1; ExtOp=2'b00; ALUctr=4'b0111;
                MemtoReg=1'b0; MemWr=1'b0; ALUSrc=1'b0; bne=1'b0;
            end
            // SLTU (無符號小於則輸出1)
            else if (instruction[5:0] == 6'b101011) begin
                nPC_sel=2'b00; RegDst=1'b1; RegWr=1'b1; ExtOp=2'b00; ALUctr=4'b0101;
                MemtoReg=1'b0; MemWr=1'b0; ALUSrc=1'b0; bne=1'b0;
            end
            // NOR (反OR)
            else if (instruction[5:0] == 6'b100111) begin
                nPC_sel=2'b00; RegDst=1'b1; RegWr=1'b1; ExtOp=2'b00; ALUctr=4'b0100;
                MemtoReg=1'b0; MemWr=1'b0; ALUSrc=1'b0; bne=1'b0;
            end
            // XOR (相同0不同1)
            else if (instruction[5:0] == 6'b100110) begin
                nPC_sel=2'b00; RegDst=1'b1; RegWr=1'b1; ExtOp=2'b00; ALUctr=4'b1000;
                MemtoReg=1'b0; MemWr=1'b0; ALUSrc=1'b0; bne=1'b0;
            end
        end

        // --- I-type 與 J-type 指令判定 ---
        // ORI (立即值的OR)
        else if (instruction[31:26] == 6'b001101) begin 
            nPC_sel=2'b00; RegDst=1'b0; RegWr=1'b1; ExtOp=2'b00; ALUctr=4'b0010;
            MemtoReg=1'b0; MemWr=1'b0; ALUSrc=1'b1; bne=1'b0;
        end 
        // LW (讀取)
        else if (instruction[31:26] == 6'b100011) begin 
            nPC_sel=2'b00; RegDst=1'b0; RegWr=1'b1; ExtOp=2'b01; ALUctr=4'b0000;
            MemtoReg=1'b1; MemWr=1'b0; ALUSrc=1'b1; bne=1'b0;
        end 
        // SW (存入)
        else if (instruction[31:26] == 6'b101011) begin 
            nPC_sel=2'b00; RegDst=1'b0; RegWr=1'b0; ExtOp=2'b01; ALUctr=4'b0000;
            MemtoReg=1'b0; MemWr=1'b1; ALUSrc=1'b1; bne=1'b0;
        end 
        // BEQ (相等則分支跳躍)
        else if (instruction[31:26] == 6'b000100) begin 
            nPC_sel=2'b01; RegDst=1'b0; RegWr=1'b0; ExtOp=2'b01; ALUctr=4'b0001;
            MemtoReg=1'b0; MemWr=1'b0; ALUSrc=1'b0; bne=1'b0;
        end  
        // BNE (不相等則分支跳躍)
        else if (instruction[31:26] == 6'b000101) begin 
            nPC_sel=2'b01; RegDst=1'b0; RegWr=1'b0; ExtOp=2'b01; ALUctr=4'b0001;
            MemtoReg=1'b0; MemWr=1'b0; ALUSrc=1'b0; bne=1'b1;
        end  
        // LUI (載入高位立即值)
        else if (instruction[31:26] == 6'b001111) begin 
            nPC_sel=2'b00; RegDst=1'b0; RegWr=1'b1; ExtOp=2'b10; ALUctr=4'b0010;
            MemtoReg=1'b0; MemWr=1'b0; ALUSrc=1'b1; bne=1'b0;
        end  
        // J (跳躍)
        else if (instruction[31:26] == 6'b000010) begin 
            nPC_sel=2'b10; RegDst=1'b0; RegWr=1'b0; ExtOp=2'b00; ALUctr=4'b0000;
            MemtoReg=1'b0; MemWr=1'b0; ALUSrc=1'b0; bne=1'b0;
        end  
        // ADDI (立即值加法)
        else if (instruction[31:26] == 6'b001000) begin 
            nPC_sel=2'b00; RegDst=1'b0; RegWr=1'b1; ExtOp=2'b01; ALUctr=4'b0000;
            MemtoReg=1'b0; MemWr=1'b0; ALUSrc=1'b1; bne=1'b0;
        end
    end
endmodule