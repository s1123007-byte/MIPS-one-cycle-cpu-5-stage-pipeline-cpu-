`timescale 1ns / 1ps
//定義輸入輸出
module ifu(nPC_sel,zero,clk,rst,instruction,jValue,bne);
    input clk,rst;
    input[1:0]nPC_sel;  //'00'pc+4,'01'beq,bne'10'j指令
    input zero;         //當zero=1時pc+4+offset*4 zero=0時pc+4
    input[25:0]jValue;  //跳轉目標位址跳轉目標位址
    output [31:0]instruction; //我們給的指令
    input bne;

//定義內部訊號
    reg [31:0]pc;       //reg定義可暫時儲存的東西(always中會寫到的就要用reg)
    reg[7:0]im[1023:0]; //instruction memory大小:1KB
    reg[31:0]pcnew;     //pc更新的值
    wire[31:0]temp,t0,t1; //wire定義不會記憶的東西像線一樣(assign中會寫到的就要用wire)
    wire[15:0]imm16;    //立即數(offset)
    wire[31:0]extout;   //offset*4
    wire[31:0]jump_target; //跳轉目標位址

//give instruction a value
    assign instruction={im[pc[9:0]],im[pc[9:0]+1],im[pc[9:0]+2],im[pc[9:0]+3]};
    //從instruction memory中取值
    assign imm16=instruction[15:0];
    //I-type 指令格式| opcode | rs | rt | immediate |
    
//set extout value
    assign temp={{16{imm16[15]}},imm16}; //把imm16從16位改成32位由於運算都為32位
    assign extout=temp[31:0]<<2;         //左移2位=(offset)*4
    assign jump_target={t0[31:28],jValue[25:0],2'b00}; //跳轉位址pc | instruction[25:0] | 00(由於pc一次是+4所以最後兩位都會是0)

//set pcnew
    assign t0=pc+4; //正常取值
    assign t1=pc+4+extout; //branch
    
    always@(*) //(*)代表即時運算
    begin
        if(nPC_sel==2'b00) begin //正常情況
            pcnew=t0; //正常取值
        end
        else if(nPC_sel==2'b10) begin //jump指令
            pcnew=jump_target; //跳轉
        end
        else if(nPC_sel==2'b01) begin //branch指令
            if ((bne == 0 && zero == 1) || (bne == 1 && zero == 0)) begin
                pcnew = t1; //beq指令:zero=1且bne=0 bne指令:zero=0且bne=1
            end
            else begin
            pcnew=t0; //其他情況=>pc+4
            end
        end
    end

//reset,clk
    always@(posedge clk,posedge rst) //上升(0->1)時動作
    begin
        if(rst) pc=32'h0000_3000; //初始值設定00003000
        else    pc<=pcnew;        //更新PC
    end
endmodule