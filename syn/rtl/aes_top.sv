/**
 * @filename		aes_top.sv 
 *
 * @brief     	        top file   	
 *
 * @author		Adil Sadik <sadik.adil@gmail.com> 
 *
 * @dependencies	none	
 */

`timescale 1ns/1ps 

module aes_top(

	input		clk;
	input 		ld;
	input 		rst;
	input [31:0] 	key;
	input [31:0] 	text_in;
	
	ouput 		done;
	output [31:0] 	text_out
	);

wire		ld_t;
wire [127:0]	text_t;
wire [127:0]	text_t2;
wire [127:0]	key_t;
wire		done_t;

	aes_input_buffer inbuffer (
			.clk(clk),
			.rst(rst),
			.ld_i(ld),
			.text_in(text_in),
			.key_in(key),
			.done_i(done_t),

			.text_o(text_t),
			.key_o(key_t),
			.ld_o(ld_t)
			);

	aes_output_buffer outbuffer (
			.clk(clk),
			.rst(rst),
			.done_i(done_t),
			.text_in(text_t2),
			.text_o(text_out),
			.done_o(done)
			);

	aes_cipher_top cipher (
			.clk(clk),	
			.rst(rst),
			.ld(ld_t),
			.key(key_t),
			.text_in(text_t),
			.text_out(text_t2),
			.done(done_t),
			);

endmodule
