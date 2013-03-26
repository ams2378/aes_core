//aes top
//include both aes_cipher_top and aes_inv_cipher_top
`timescale 1ns/1ps 

module aes_top(ifc.dut d);

wire		ld_t;
wire [127:0]	text_t;
wire [127:0]	key_t;
wire		done_t;

	aes_input_buffer inbuffer (
			.clk(d.clk),
			.rst(d.rst),
			.ld_i(d.ld),
			.text_in(d.text_in),
			.key_in(d.key),
			.done_i(done_t),

			.text_o(text_t),
			.key_o(key_t),
			.ld_o(ld_t)
			);


	aes_cipher_top cipher (
			.clk(d.clk),	
			.rst(d.rst),
			.ld(ld_t),
			.key(key_t),
			.text_in(text_t),

		//	.ld(d.ld),
		//	.key(d.key),
		//	.text_in(d.text_in),

			.text_out(d.text_out),
			.done(done_t),
			.sa00(d.sa00),
			.sa01(d.sa01),
			.sa02(d.sa02),
			.sa03(d.sa03),
			.sa10(d.sa10),
			.sa11(d.sa11),
			.sa12(d.sa12),
			.sa13(d.sa13),
			.sa20(d.sa20),
			.sa21(d.sa21),
			.sa22(d.sa22),
			.sa23(d.sa23),
			.sa30(d.sa30),
			.sa31(d.sa31),
			.sa32(d.sa32),
			.sa33(d.sa33),

			.text_in_r(d.text_in_r),
			.w0(d.w0),
			.w1(d.w1),
			.w2(d.w2),
			.w3(d.w3),

			.sa00_next(d.sa00_next),
			.sa01_next(d.sa01_next),
			.sa02_next(d.sa02_next),
			.sa03_next(d.sa03_next),
			.sa10_next(d.sa10_next),
			.sa11_next(d.sa11_next),
			.sa12_next(d.sa12_next),
			.sa13_next(d.sa13_next),
			.sa20_next(d.sa20_next),
			.sa21_next(d.sa21_next),
			.sa22_next(d.sa22_next),
			.sa23_next(d.sa23_next),
			.sa30_next(d.sa30_next),
			.sa31_next(d.sa31_next),
			.sa32_next(d.sa32_next),
			.sa33_next(d.sa33_next),
			.ld_r(d.ld_r),
			.dcnt(d.dcnt)
			);

assign d.done	=	done_t;

endmodule
