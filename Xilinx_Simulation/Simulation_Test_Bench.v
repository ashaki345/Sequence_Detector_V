`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/22/2021 08:34:01 PM
// Design Name: 
// Module Name: Top_Test
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Top_Test();

reg In;
reg clk;
reg rst;
wire Out;
int p;
longint i;

Top uut(.serIn(In), .clk(clk), .rst(rst), .serOut(Out));

//Detect Sequence//
initial begin
clk = 0;
rst = 0;
In =1'bz;
#10
rst = 1;
#10
rst = 0;
#10
In = 1'b0;
#10
In = 1'b1;
#10
In = 1'b1;
#10
In = 1'b1;
#10
In = 1'b1;
#10
In = 1'b0;
#10
In = 1'b1;

//Sequence Detected
#10
In = 1'b0;
#10
for(i = 0; i <= 1024; i = i +1)begin 
    #7
    In = $urandom_range(1,0);
    end


end

always # 5 clk = ~clk;



endmodule