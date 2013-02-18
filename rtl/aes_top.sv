//aes top
//include both aes_cipher_top and aes_inv_cipher_top
`timescale 1ns/1ps 

module aes_top(ifc.dut d);



	aes_cipher_top cipher (
			.clk(d.clk),	
			.rst(d.rst),
			.ld(d.ld),
			.key(d.key),
			.text_in(d.text_in),
			.text_out(d.text_out),
			.done(d.done)
			);


	aes_inv_cipher_top dcipher (
			.clk(d.clk),	
			.rst(d.rst),
			.ld(d.ld),
			.kld(d.kld),
			.key(d.key),
			.text_in(d.text_in),
			.text_out(d.text_out),
			.done(d.done),
			.kdone(d.kdone)
			);



endmodule

/*
module aes_inv_cipher_top(input		clk,
			  input		rst,
			  input		ld_i, 
			  input 	mode_i,
			  input 	[127:0]	key_i,
		 	  input	        [127:0]	text_in,
			  output	done_o,
			  output	[127:0]	text_out
			);

	aes_cipher_top cipher (
			.clk(clk),	
			.rst(rst),
			.ld(ld_i),
			.key(key_i),
			.text_in(text_in),
			.text_out(text_out),
			.done(done_o)
			);

	aes_inv_cipher_top decipher (
			.clk(clk),	
			.rst(rst),
			.ld(0),
			.key(key_i),
			.text_in(text_in),
			.text_out(text_out),
			.done(done_o)
			);

endmodule

	

*/

