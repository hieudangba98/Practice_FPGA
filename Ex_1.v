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
	input rst_n,
	input flick,
	output [15:0]lamp
);

parameter INIT=0;
parameter UP_0_15=1;
parameter DOWN_15_5=2;
parameter UP_5_10=3;
parameter DOWN_10_0=4;
parameter UP_0_5=5;
parameter DOWN_5_0=6;

reg [2:0]state;
reg [2:0]next_state;

reg [15:0]lamp_temp=16'd0;

assign lamp[15:0]=lamp_temp[15:0];

always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		state<=3'd0;
	else
		state<=next_state;
end

always@(state or flick or lamp) begin
	case(state)
	INIT: begin
		if(!flick) begin
			next_state=INIT;
		end
		else begin 
			next_state=UP_0_15;
		end
	end
	UP_0_15: begin
		if(lamp[15]!=1'b1) begin
			next_state=UP_0_15;
		end
		else begin
			next_state=DOWN_15_5;
		end
	end
	DOWN_15_5: begin
		if(flick==1'b1 && lamp[5]==1'b0 && lamp[4]==1'b1) begin
			next_state=UP_0_15;
		end
		else begin
			if(lamp[5]==1'b0 && lamp[4]==1'b1) begin
				next_state=UP_5_10;
			end
			else begin
				next_state=DOWN_15_5;
			end
		end
	end
	UP_5_10: begin
		if(lamp[10]!=1'b1) begin
			next_state=UP_5_10;
		end
		else begin
			next_state=DOWN_10_0;
		end
	end
	DOWN_10_0: begin
		if(flick==1'b1 && ((lamp[5]==1'b0 & lamp[4]==1'b1 ) ||lamp[0]==1'b0)) begin
			next_state=UP_5_10;
		end
		else begin
			if(lamp[0]!=1'b0) begin
				next_state=DOWN_10_0;
			end
			else begin
				next_state=UP_0_5;
			end
		end
	end
	UP_0_5: begin
		if(lamp[5]!=1'b1) begin
			next_state=UP_0_5;
		end
		else begin
			next_state=DOWN_5_0;
		end
	end
	DOWN_5_0: begin
		if(lamp[0]!=1'b0) begin
			next_state=DOWN_5_0;
		end
		else begin
			next_state=INIT;
		end
	end
	default: begin next_state=INIT; end
	endcase
end

always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		lamp_temp<=16'd0;
	else begin
		case(state)
		INIT: begin
			if(flick)
				lamp_temp<=16'h0001;
			else
				lamp_temp<=16'h0000;
		end
		UP_0_15: begin
			if(lamp[15])
				lamp_temp<=lamp_temp>>1;
			else begin
				lamp_temp<=(lamp_temp<<1)| 16'h0001;
			end
		end
		DOWN_15_5: begin
			if(lamp[5]==0) begin
				lamp_temp<=(lamp_temp<<1)| 16'h0001;
			end
			else begin
				lamp_temp<=lamp_temp>>1;
			end
		end
		UP_5_10: begin
			if(lamp[10])
				lamp_temp<=lamp_temp>>1;
			else begin
				lamp_temp<=(lamp_temp<<1)| 16'h0001;
			end
		end
		DOWN_10_0: begin
			if(lamp[5]==0 && lamp[4]==1) begin
				if(flick) begin
					lamp_temp<=(lamp_temp<<1)| 16'h0001;
				end
				else begin
					lamp_temp<=lamp_temp>>1;
				end
			end
			else begin
				if(lamp[0]==1)
					lamp_temp<=lamp_temp>>1;
				else begin
					lamp_temp<=(lamp_temp<<1)| 16'h0001;
				end
			end
		end
		UP_0_5: begin
			if(lamp[5])
				lamp_temp<=lamp_temp>>1;
			else begin
				lamp_temp<=(lamp_temp<<1)| 16'h0001;
			end
		end
		DOWN_5_0: begin
			lamp_temp<=lamp_temp>>1;
		end
		default: lamp_temp<=16'h0000;
		endcase
	end
end

endmodule
