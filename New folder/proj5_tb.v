

`timescale 1 ns/1 ns
module proj5_tb();
	reg reset, carew, clock;
	
	wire tb_clk;
	wire [5:0] LightOut;


	project5_digital_design U1(tb_clk, reset, carew, LightOut);
	clk #(20) C1 (clock,tb_clk);

	initial
	begin
		clock = 1;
		reset = 1;
		carew = 1;
		#100;
		reset = 0;
		#5;
		carew = 0;
	end

endmodule