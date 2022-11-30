// This is the clk from a previous project



`timescale 1 ns / 1 ps

module clk(enable, clk_out);
	parameter PERIOD = 50;		// The default period of the clock
	input enable;				// Allow clk_out to "run" when asserted
	output clk_out;				// Controlled clock out

	reg clk_out;					// Declare clk_out as a reg

	// Set initial value for clk_out on power-up
	initial clk_out = 0;

	// Produce controlled free-running clock
	always
	begin
		#(PERIOD/2) if (enable == 1) 
			clk_out = ~clk_out;
	end
endmodule