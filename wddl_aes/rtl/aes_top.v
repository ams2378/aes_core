//aes top
//include both aes_cipher_top and aes_inv_cipher_top
`timescale 1ns/1ps 

module aes_top(ifc.dut d);

	aes_cipher_top_wddl cipher(
		.clk(d.clk),
		.rst(d.rst),
		.ld(d.ld),
		.done(d.done),
		.key(d.key),
		.text_in(d.text_in),
		.text_out(d.text_out)
	);


/*
	aes_addroundkey_wddl addround (
		.clk(d.clk),
		.ld_r(d.ld_r),

 .text_in_r(d.text_in_r),
 .text_in_r_n(d.text_in_r_n),

 .w0(d.w0),  .w1(d.w1),  .w2(d.w2),  .w3(d.w3),
 .w0_n(d.w0_n),  .w1_n(d.w1_n), .w2_n(d.w2_n),  .w3_n(d.w3_n),

 .sa00(d.sa00),  .sa01(d.sa01), .sa02(d.sa02), .sa03(d.sa03),
.sa10(d.sa10), .sa11(d.sa11), .sa12(d.sa12), .sa13(d.sa13),
.sa20(d.sa20), .sa21(d.sa21), .sa22(d.sa22), .sa23(d.sa23),
.sa30(d.sa30), .sa31(d.sa31), .sa32(d.sa32), .sa33(d.sa33),

.sa00_n(d.sa00_n), .sa01_n(d.sa01_n), .sa02_n(d.sa02_n), .sa03_n(d.sa03_n),
.sa10_n(d.sa10_n), .sa11_n(d.sa11_n), .sa12_n(d.sa12_n), .sa13_n(d.sa13_n),
.sa20_n(d.sa20_n), .sa21_n(d.sa21_n), .sa22_n(d.sa22_n), .sa23_n(d.sa23_n),
.sa30_n(d.sa30_n), .sa31_n(d.sa31_n), .sa32_n(d.sa32_n), .sa33_n(d.sa33_n),

 .sa00_next(d.sa00_next),  .sa01_next(d.sa01_next),  .sa02_next(d.sa02_next),  .sa03_next(d.sa03_next),
 .sa10_next(d.sa10_next),  .sa11_next(d.sa11_next),  .sa12_next(d.sa12_next),  .sa13_next(d.sa13_next),
 .sa20_next(d.sa20_next),  .sa21_next(d.sa21_next),  .sa22_next(d.sa22_next),  .sa23_next(d.sa23_next),
 .sa30_next(d.sa30_next),  .sa31_next(d.sa31_next),  .sa32_next(d.sa32_next),  .sa33_next(d.sa33_next),

 .sa00_next_n(d.sa00_next_n),  .sa01_next_n(d.sa01_next_n),  .sa02_next_n(d.sa02_next_n),  .sa03_next_n(d.sa03_next_n),
 .sa10_next_n(d.sa10_next_n),  .sa11_next_n(d.sa11_next_n),  .sa12_next_n(d.sa12_next_n),  .sa13_next_n(d.sa13_next_n),
 .sa20_next_n(d.sa20_next_n),  .sa21_next_n(d.sa21_next_n),  .sa22_next_n(d.sa22_next_n),  .sa23_next_n(d.sa23_next_n),
 .sa30_next_n(d.sa30_next_n),  .sa31_next_n(d.sa31_next_n),  .sa32_next_n(d.sa32_next_n),  .sa33_next_n(d.sa33_next_n)

	);
*/
endmodule

