//////////////////////////////////////////////////////////////////////////////
//
// Name: Jean-Paul Talavera, Joseph Long, Andy Lee
// Class: DD1
// Date: 12/13/2022
// Description: This file contains a 12-bit FSM with coutners to replicate a traffic controller.
//
////////////////////////////////////////////////////////////////////////////////



module project5_digital_design(clock, reset, carew, LightOut);
	
	input         clock, reset, carew;
	output [5:0] LightOut;
	
	reg [5:0] fsm_state;
	reg pressed;
	reg [25:0] count;
	reg [25:0] count2;
	reg NS, EW;
	parameter [5:0] GNS = 6'b100001, YNS  = 6'b010001, GEW = 6'b001100;
	parameter [5:0] YEW = 6'b001010, ALLRED = 6'b001001;


// This block sets the fsm state	
/*
If reset is 1, We STAY in the GNS state else we continue
If we are in the GNS state and CAREW or KEY 0 is pressed, 
we continue on to the YNS state else we stay in GNS. 
If we are in the YNS state, we always move to the GEW state next.
If we are in GEW state, if rest or KEY 1 is pressed, we continue 
to YEW sate. at YEW state we always go to GNS state. 
*/
	initial count = 26'b0;
	always@(posedge clock or negedge reset) begin
		if(reset == 1'b0)
			fsm_state <= GNS;
		else begin
				case(carew)
					1'b0: 
						pressed = pressed;
					1'b1: 	
						pressed = 1;
			
					default: pressed = 1'bx;
				endcase

				case(fsm_state)
					GNS: begin
						if (pressed == 1'b1) begin
							count <= count + 1;
							if (count == 26'b11111111111111111111111111) begin
								fsm_state <= YNS;
								pressed <= 0;
								count <= 0;
							   NS <= 1;
							end
						end
					end

					YNS:begin
						count = count + 1;
						if (count == 26'b11111111111111111111111111) begin
							fsm_state <= ALLRED;
							pressed <= 0;
							count <= 0;
						end
					end

					GEW:begin
						count = count + 1;
						count2 = count2;
						if (count == 26'b11111111111111111111111111) begin
							fsm_state <= GEW;
							count <= 0;
							pressed <= 0;
							count2 <= count2 + 1'b1;
							EW <= 1;
						end
						else if (count2 == 26'b00000000000000000000010000)begin
							count2 <= 0;
							fsm_state <= YEW;
							pressed <= 0;
						end
					end

					YEW:begin
						count = count + 1;
						if (count == 26'b11111111111111111111111111) begin
							fsm_state <= ALLRED;
							pressed <= 0;
							count <= 0;
						end
					end
					
					ALLRED:begin
						count = count + 1;
						if (count == 26'b11111111111111111111111111) begin
							fsm_state <= ALLRED;
							count <= 0;
							pressed <= 0;
							count2 <= count2 + 1'b1;
						end
						else if(count2 == 26'b00000000000000000000000010)begin
							if(NS == 1'b1)begin
								NS <= 0;
								count2 <= 0;
								fsm_state <= GEW;
							end
							else if(EW == 1'b1)begin
								EW <= 0;
								count2 <= 0;
								fsm_state <= GNS;
							end
						end
					end

					default: fsm_state <= 6'bx;
				endcase
		end
		
		
	end

	assign LightOut = fsm_state; // assing our output to the fsm state

endmodule
