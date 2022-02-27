module UltraTop(

	input clkPb,
	input FPGAclk,
	output reg synchOut,
	output serOut,
	input startSeq, 
	input SwitchIn,
	input button1,
	output LED3,
	output LED4
	
	);
	

wire notSerIn, notstartSeq, notclkPb; //1 means button is not pressed, need to invert input of button
assign notstartSeq = !startSeq;
assign notclkPb = !clkPb;
assign notbutton1 = !button1;
logic serIn;
reg [25:0] slowdowncounter;
reg clk_out;

Top uu1(.clkPb(synchOut), .serIn(serIn), .rst(notstartSeq), .serOut(serOut), .FPGAclk(counter));
    
always@(posedge FPGAclk or posedge notstartSeq) begin // 50MHz clock is too fast...slow it down to 1 second
	if (notstartSeq == 1'b1) begin 
		slowdowncounter <= 0;
		clk_out <= 0;
		LED4 <= 0;
	end else begin
		slowdowncounter <= slowdowncounter + 1;
		if (slowdowncounter == 50_000_000)begin
			slowdowncounter <= 0;
			clk_out <= ~clk_out;
			LED4 <= ~LED4;
		end
	end
end 

always@(posedge slowdowncounter) begin //clkb for  
if(notclkPb == 1)begin
	synchOut <= 1'b1;
	serIn <= SwitchIn;
	LED3 <= SwitchIn; 
end else synchOut <= 1'b0;
end


endmodule