`timescale 1ns / 1ps

module ledblink(clk, Y);
input clk;
output Y;

reg [25:0]counter=26'b0;
reg temp=1'b0;

always@(posedge clk)
begin
	if(counter>50000000)
	begin
		temp<=!temp;
		counter<=26'd0;
	end
	else
		counter<=counter+1'b1;
end
assign Y=temp;
endmodule
