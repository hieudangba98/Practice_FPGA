`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Renesas Design VietNam Co. Ltd(RVC)
// Engineer: Hieu Ba Dang
// 
// Create Date:    8:22:18 03/28/2021 
// Design Name: 
// Module Name:    Ex_1 (Exercise 1)
// Project Name: 
//////////////////////////////////////////////////////////////////////////////////
module Ex_1(
	input clk,
	input reset_n,
	input flick,
	output [15:0]Y
);

parameter ST0=0;
parameter ST1=1;
parameter ST2=2;
parameter ST3=3;
parameter ST4=4;
parameter ST5=5;
parameter ST6=6;

reg [2:0]state;
reg [2:0]next_state;

reg [15:0]LED=16'd0;

assign Y[15:0]=LED[15:0];

always@(posedge clk or negedge reset_n) begin
	if(!reset_n)
		state<=3'd0;
	else
		state<=next_state;
end

always@(state or flick or Y) begin
	case(state)
	ST0: begin
		if(!flick) begin
			next_state=ST0;
		end
		else begin 
			next_state=ST1;
		end
	end
	ST1: begin
		if(Y!=16'h7fff) begin
			next_state=ST1;
		end
		else begin
			next_state=ST2;
		end
	end
	ST2: begin
		if(Y!=16'b0000_0000_0011_1111) begin
			next_state=ST2;
		end
		else begin
			next_state=ST3;
		end
	end
	ST3: begin
		if(Y!=16'b0000_0001_1111_1111) begin
			next_state=ST3;
		end
		else begin
			next_state=ST4;
		end
	end
	ST4: begin
		if(Y!=16'b0000_0000_0000_0001) begin
			next_state=ST4;
		end
		else begin
			next_state=ST5;
		end
	end
	ST5: begin
		if(Y!=16'b0000_0000_0001_1111) begin
			next_state=ST5;
		end
		else begin
			next_state=ST6;
		end
	end
	ST6: begin
		if(Y!=16'b0000_0000_0000_0001) begin
			next_state=ST6;
		end
		else begin
			next_state=ST0;
		end
	end
	default: begin next_state=ST0; end
	endcase
end

always@(posedge clk or negedge reset_n) begin
	if(!reset_n)
		LED<=16'd0;
	else begin
		case(state)
		ST0: begin
			LED<=16'h0000;
		end
		ST1: begin
			LED<=LED<<1;
			LED[0]<=1'b1;
		end
		ST2: begin
			if(flick&&Y!=16'b0000_0000_0011_1111)
				LED<=16'hffff;
			else
				LED<=LED>>1;
		end
		ST3: begin
			LED<=LED<<1;
			LED[0]<=1'b1;
		end
		ST4: begin
			if(flick&&Y!=16'b0000_0000_0011_1111)
				LED<=16'b0000_0001_1111_1111;
			else
				LED<=LED>>1;
		end
		ST5: begin
			LED<=LED<<1;
			LED[0]<=1'b1;
		end
		ST6: begin
			LED<=LED>>1;
		end
		default: LED<=16'h0000;
		endcase
	end
end

endmodule
