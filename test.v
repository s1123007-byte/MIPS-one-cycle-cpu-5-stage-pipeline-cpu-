`timescale 1ns / 1ps
module test;
reg clk,rst;
mips launch(.clk(clk),.rst(rst));

initial begin
    $dumpfile("test.vcd");
    $dumpvars(0,test);
rst=0;
clk=1;
#1 rst=1;
#3 rst=0; 
$readmemh("code.txt",launch.MAIN.IFU.im);
#5000 $finish;
end

always
#3.05 clk=~clk;
endmodule