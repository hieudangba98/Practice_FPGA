`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: Renesas Design Vietnam Co., Ltd (RVC)
// Engineer: Dang Ba Hieu
//
// Create Date:   08:22:48 03/28/2021
// Design Name:   Ex_1
// Project Name:  Exercise
////////////////////////////////////////////////////////////////////////////////

module tb_Ex_1;

	// Inputs
	reg clk;
	reg rst_n;
	reg flick;

	// Outputs
	wire [15:0] lamp;
	
	// Instantiate the Unit Under Test (UUT)
	Ex_1 bound_flasher(
		.clk(clk), 
		.rst_n(rst_n), 
		.flick(flick), 
		.lamp(lamp)
	);
	initial begin	
		clk = 0;
		forever begin
			#5 clk = !clk;
		end
	end
	
	//Testcase for ST0
	task test_reset_fuction;
		begin
			$display("Test reset and reset when in function");
			#40 rst_n = 1; flick = 1;
			#40 rst_n = 1; flick = 0;
			#200 rst_n = 0; flick = 0;
			#40 rst_n = 1; flick = 0;
			#50;
		end
	endtask
	
	task test_flick_ST0; 
		begin
			$display("Test for all state from state 0");
			#40 rst_n = 1; flick = 1;
			#40 rst_n = 1; flick = 0;
			#600;
		end
	endtask
	
	task test_flick_ST2;
		begin
			$display("Test for flick when state 2");
			rst_n = 1; flick = 1;
			#40 rst_n = 1; flick = 0;
			wait(bound_flasher.state==3'h2) begin
				wait(bound_flasher.lamp_temp==16'h007f) begin
					flick=1;
				end
				#40 flick=0;
			end 
			#500;
		end
	endtask
	
	task test_flick_ST4_each_case;
		begin
			$display("Test for flick when state 4 but for each case");
			rst_n = 1; flick = 1;
			#40 rst_n = 1; flick = 0;
			wait(bound_flasher.state==3'h4) begin
				wait(bound_flasher.lamp_temp==16'h007f) begin
					flick=1;
				end
				#40 flick=0;
			end 
			#500;
			
			rst_n = 1; flick = 1;
			#40 rst_n = 1; flick = 0;
			wait(bound_flasher.state==3'h4) begin
				wait(bound_flasher.lamp_temp==16'h0001) begin
					flick=1;
				end
				#40 flick=0;
			end 
			#600;
			
		end
	endtask
	
	task test_flick_ST4_double_case;
		begin
			$display("Test for flick when state 4 and double case(kick back point when lamp[5] and lamp[0])");
			rst_n = 1; flick = 1;
			#40 rst_n = 1; flick = 0;
			wait(bound_flasher.state==3'h4) begin
				wait(bound_flasher.lamp_temp==16'h007f) begin
					flick=1;
				end
				#40 flick=0;
				 
				wait(bound_flasher.lamp_temp==16'h0001) begin
					flick=1;
				end
				#40 flick=0;
			end 
			#600;
			
		end
	endtask
	initial begin $monitor("Lamp: 16'b%b, State: 3'h%h",lamp,bound_flasher.state); end
	initial begin
		rst_n = 0; flick = 0;
		test_reset_fuction;
		test_flick_ST0;
		test_flick_ST2;
		test_flick_ST4_each_case;
		test_flick_ST4_double_case;
		#100;
		$finish;
	end
	 
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			#1;
			if(bound_flasher.state!=3'h0 || bound_flasher.lamp!=16'h0000) begin
				$display("========> Reset Fail, state=3'h%h,lamp=16'h%h",bound_flasher.state,bound_flasher.lamp);
			end
			else begin
				$display("========> Reset Pass");
			end
		end
		else begin
			if(flick==1'b1 && (bound_flasher.lamp==16'h001f) && bound_flasher.state==3'h2) begin
				#40;
				if(bound_flasher.state!=3'h1) begin
					$display("========> Test Fail, kick_back_point fail, state=3'h%h,lamp=16'h%h",bound_flasher.state,bound_flasher.lamp);
				end
				else begin
					$display("========> Test Pass, kick-back point is ok");
				end
			end
			if(flick==1'b1 && (bound_flasher.lamp==16'h001f || bound_flasher.lamp==16'h0000) && bound_flasher.state==3'h4) begin
				#40;
				if(bound_flasher.state!=3'h3) begin
					$display("========> Test Fail, kick_back_point fail, state=3'h%h,lamp=16'h%h",bound_flasher.state,bound_flasher.lamp);
				end
				else begin
					$display("========> Test Pass, kick-back point is ok");
				end
			end
			if(flick==1'b1 && bound_flasher.state==3'h0) begin
				#40;
				if(bound_flasher.state!=3'h1) begin
					$display("========> Test Fail, kick_back_point fail, state=3'h%h,lamp=16'h%h",bound_flasher.state,bound_flasher.lamp);
				end
				else begin
					$display("========> Test Pass, flick start bounder flash is ok");
				end
			end
		end
	end
endmodule

