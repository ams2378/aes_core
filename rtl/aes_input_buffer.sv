/**
 * @filename		aes_input_buffer.sv 
 *
 * @brief     	        input buffer for text and key  	
 *
 * @author		Adil Sadik <sadik.adil@gmail.com> 
 *
 * @dependencies	none	
 */


module aes_input_buffer ( clk, rst, ld_i, text_in, done_i, key_in, text_o, key_o, ld_o );

input		clk;
input		rst;
input		ld_i;	
input		done_i;	
input [31:0] 	text_in;
input [31:0] 	key_in;

output [127:0]	text_o;
output [127:0]	key_o;
output		ld_o;

/* state variable */
parameter 			state0 = 3'b000;
parameter			state1 = 3'b001;
parameter			state2 = 3'b010;
parameter 			state3 = 3'b011;
parameter 			state4 = 3'b011;

reg [2:0]			state;
reg [2:0]			next_state;


reg [127:0]			text_o;
reg [127:0]			key_o;
reg				ld_o;

always @(posedge clk) begin
	if (!rst)		state <= state0;
	else			state <= next_state;
end

always @(state or done_i or ld ) begin
	
	if (!rst) begin
		text_o 	= '0;
		key_o 	= '0;
		ld_o	= '0;
	end
	
	case(state) 
	
		state0: begin 			
				if (ld_i == 1) begin
					key_o [31:0] = key_in;
					text_o[31:0] = text_in;
					ld_o 	   = 0;
					next_state = state1;
				end else begin						
					next_state = state0;
				end
		end
		state1: begin
					key_o [63:32] = key_in;
					text_o[63:32] = text_in;
					ld_o 	   = 0;
					next_state = state2;
		end
		state2: begin
					key_o [95:64] = key_in;
					text_o[95:64] = text_in;
					ld_o 	    = 0;
					next_state = state3;
		end
		state3:	begin
					key_o [127:96] = key_in;
					text_o[127:96] = text_in;
					ld_o 	     = 1;
					next_state = state4;
		end	
		state4:	begin
				if (done_i != 1) begin
					ld_o 	   = 0;
					next_state = state4;
				end else if (done_i == 1) begin
					ld_o 	   = 0;
					next_state = state0;
				end
		end	
	endcase
end
/*
assign 	text_o 			= 	text;
assign 	key_o	 		= 	key;
assign 	ld_o 			= 	ld;
*/
endmodule

