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



endmodule
