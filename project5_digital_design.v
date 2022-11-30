////////////////////////////////////////////////////////////////////////////////
// Filename:    
// Author:      
// Date:        11 november 2022
// Version:     1
// Description: A 12-bit synchronous FSM as a starting point for Project 4.
 
module fsm12bit(clock, reset, enable, check, mode, direction, value, outputValue);
	
	input         clock, reset, enable, check, mode, direction;
	input [3:0]   value;
	output [11:0] outputValue;
	
		
	reg [11:0] fsm_state;
	
	
	reg[11:0]next_fsm_state;
	
	reg [2:0] modeType;
	
	always @(posedge clock or negedge reset) begin
	modeType <= {check,mode,direction};
	
// If a negative edge occured on clear, then clear must equal 0.
// Since the effect of the clear occurs in the absence of a clock pulse, the reset is ASYNCHRONOUS.
// Release clear to permit synchronous behavior of the counter.

		if(reset == 1'b0)
			fsm_state <= 12'b0; //12'b0

// If clear is not 0 but this always block is executing anyway, there must have been a positive clock edge.
// On each positive clock edge, determine a new FSM state based on the enable value.

// Keep the same FSM value if the enable signal is not active.

		else if(enable == 1'b0) 
			fsm_state <= fsm_state;

// Otherwise, update the FSM state based on the FSM state and the values of check, mode, direction, and value.
		else begin
			casex({check,mode,direction})
				 3'b0xx:
					fsm_state <= 12'b010110001000; //588 pid
				 3'b100:
					fsm_state <= fsm_state - {8'b00000000, value};
				 3'b101:
				   fsm_state <= fsm_state + {8'b00000000, value};
				 3'b110:
					fsm_state <= fsm_state >> 1;
				 3'b111:
					fsm_state <= fsm_state << 1;
		 endcase
	end
end

// OUTPUT MACHINE	
	assign outputValue = fsm_state; 
endmodule
