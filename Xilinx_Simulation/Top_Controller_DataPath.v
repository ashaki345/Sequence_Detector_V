`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/22/2021 05:52:54 PM
// Design Name: 
// Module Name: Top
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


module Top(
    input clk,
    input serIn,
    input rst,
    output reg serOut
    );
    

parameter [2:0] S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100, S5 = 4'b101, S6 = 3'b110;
reg [2:0] current_state, next_state;
wire serOutValid;
logic [9:0] counter; //1024 clock cycles
///////////////////////////////////////Register////////////////////////////////////////////////////
always @ (posedge clk or posedge rst)begin
  if (rst) current_state <= S0;
  else
  current_state <= next_state;
  $display("Current state is: %d", current_state);
end
///////////////////////////////////////Register/////////////////////////////////////////////////////

///////////////////////////////////////Sequence Detector///////////////////////////////////////////
always@(current_state, serIn, serOutValid, counter)begin
   case(current_state)
   S0:if (serIn==0) next_state <= S1;  else next_state <= S0;
   S1:if (serIn==1) next_state <= S2;  else next_state <= S1;
   S2:if (serIn==1) next_state <= S3;  else next_state <= S1;
   S3:if (serIn==1) next_state <= S4; else next_state <= S1;
   S4:if (serIn==1) next_state <= S5; else next_state <= S1;
   S5:if (serIn==0) next_state <= S6; else next_state <= S5;
   S6:if (counter == 0) next_state <= S0; else next_state <= S6; //start transmitting clocked input to output
   endcase
end

assign serOutValid = (current_state == S6)? 1: 0; //if in state six, start counter

///////////////////////////1////////////Sequence Detector////////////////////////////////////////////////

///////////////////////////////////////Counter/////////////////////////////////////////////

always@(*)begin
    if(rst) begin
        counter <= 0;
     end else if (serOutValid==1 && clk == 1)begin
        counter <= counter + 1'b1;
            if(counter == 1024) begin
                counter <= 0;
            end
        $display(counter);
       end
end
///////////////////////////////////////Counter/////////////////////////////////////////////


///////////////////////////////////////Transmitter/////////////////////////////////////////////


assign serOut = (counter!=0)? serIn: 1'bz;

///////////////////////////////////////Transmitter/////////////////////////////////////////////

endmodule