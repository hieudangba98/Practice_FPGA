`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: Renesas Design Vietnam Co., Ltd (RVC)
// Engineer: Dang Ba Hieu
//
// Create Date:   08:22:48 03/28/2021
// Design Name:   Ex_1
// Module Name:   E:/HOCTAP/IC Design/Logic_design/Renesas/Exercise/tb_Ex_1.v
// Project Name:  Exercise
////////////////////////////////////////////////////////////////////////////////

module tb_Ex_1;

	// Inputs
	reg clk;
	reg reset_n;
	reg flick;

	// Outputs
	wire [15:0] Y;
	
	// Instantiate the Unit Under Test (UUT)
	Ex_1 bounder(
		.clk(clk), 
		.reset_n(reset_n), 
		.flick(flick), 
		.Y(Y)
	);
	initial begin	
		clk = 0;
		forever begin
			#5 clk = !clk;
		end
	end
	initial begin
		// Initialize Inputs
		reset_n = 0; flick = 0;
		
		test_flick_ST4(reset_n, flick);
		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
	//Testcase for ST0
	task test_flick_ST0;
		input reset_n;
		input flick;
		begin
			#40 reset_n = 1; flick = 1;
			#40 reset_n = 1; flick = 0;
			#800;
		end
	endtask
	
	//Testcase for ST2
	task test_flick_ST2;
		input reset_n;
		input flick;
		begin
			reset_n = 1; flick = 1;
			#40 reset_n = 1; flick = 0;
			if(state.bounder==3'h2) begin
				wait(LED.bounder==16'b0000_0000_0011_1111) begin
					flick=1;
				end
				#40 flick=0;
			end
			#800;
		end
	endtask
	
	//Testcase for ST4
   task test_flick_ST4;
		input reset_n;
		input flick;
		begin
			reset_n = 1; flick = 1;
			#40 reset_n = 1; flick = 0;
			if(state.bounder==3'h4) begin
				wait(LED.bounder==16'b0000_0000_0011_1111) begin
					flick=1;
				end
				#40 flick=0;
			end
			#800;
		end
	endtask
endmodule

