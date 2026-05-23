`timescale 1ns / 1ps
module test;
reg clk, rst;
mips_pipeline launch (.clk(clk),.rst(rst));
initial begin
        $dumpfile("test.vcd");
        $dumpvars(0, test);
rst=0;
clk=1;
#1 rst=1;
#3 rst=0;         // 解除重置，開始跑程式
$readmemh("code.txt", launch.ifu.im);
#5000 $finish;
end

always
#1.05 clk=~clk;
endmodule