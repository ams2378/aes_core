/**
 * @filename		aes_output_buffer.sv 
 *
 * @brief     	        output buffer for text and key  	
 *
 * @author		Adil Sadik <sadik.adil@gmail.com> 
 *
 * @dependencies	none	
 */

`timescale 1ns/1ps 

module aes_output_buffer ( clk, rst, done_i, text_in, text_o, done_o );

input		clk;
input		rst;
input		done_i;	
input [127:0] 	text_in;

output [32:0]	text_o;
output		done_o;

/* state variable */
parameter 			state0 = 3'b000;
parameter			state1 = 3'b001;
parameter			state2 = 3'b010;
parameter 			state3 = 3'b011;

reg [2:0]			state;
reg [2:0]			next_state;


reg [32:0]			text_o;
reg				done_o;

always @(posedge clk) begin
	if (!rst)		state <= state0;
	else			state <= next_state;
end

always @(state or done_i ) begin
	
	if (!rst) begin
		text_o 	= '0;
		done_o	= '0;
	end
	
	case(state) 
	
		state0: begin 			
				if (done_i == 1) begin
					text_o 	   = text_in[31:0];
					done_o 	   = 1;
					next_state = state1;
				end else begin
					done_o	   = 0;
					text_o	   = '0;						
					next_state = state0;
				end
		end
		state1: begin
					text_o     = text_in[63:32];
					done_o 	   = 1;
					next_state = state2;
		end
		state2: begin
					text_o      = text_in[95:64];
					done_o 	    = 1;
					next_state = state3;
		end
		state3:	begin
					text_o       = text_in[127:96];
					done_o 	     = 1;
					next_state   = state0;
		end	
	endcase
end

endmodule

