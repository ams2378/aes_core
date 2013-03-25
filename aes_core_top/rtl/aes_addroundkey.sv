/**
 * @filename		aes_addroundkey.sv 
 *
 * @brief     	        xor for addroundkey operation  	
 *
 * @author		Adil Sadik <sadik.adil@gmail.com> 
 *
 * @dependencies	aes_xor.sv	
 */

module aes_addroundkey (clk, ld_r, text_in_r, w0, w1, w2, w3, 
		sa00, sa01, sa02, sa03,	sa10, sa11, sa12, sa13,
		sa20, sa21, sa22, sa23, sa30, sa31, sa32, sa33,       
		sa00_next, sa01_next, sa02_next, sa03_next,
		sa10_next, sa11_next, sa12_next, sa13_next,
		sa20_next, sa21_next, sa22_next, sa23_next,
		sa30_next, sa31_next, sa32_next, sa33_next);


input		clk;
input		ld_r;
input[127:0]	text_in_r;
input[31:0]	w0, w1, w2, w3;

output	[7:0]	sa00, sa01, sa02, sa03;
output	[7:0]	sa10, sa11, sa12, sa13;
output	[7:0]	sa20, sa21, sa22, sa23;
output	[7:0]	sa30, sa31, sa32, sa33;

input	[7:0]	sa00_next, sa01_next, sa02_next, sa03_next;
input	[7:0]	sa10_next, sa11_next, sa12_next, sa13_next;
input	[7:0]	sa20_next, sa21_next, sa22_next, sa23_next;
input	[7:0]	sa30_next, sa31_next, sa32_next, sa33_next;

aes_xor ux33(.clk(clk), .ld_r (ld_r), .text_in(text_in_r[007:000]), .w_i (w3[07:00]), .sa_i(sa33_next), .sa_o(sa33) );
aes_xor ux23(.clk(clk), .ld_r (ld_r), .text_in(text_in_r[015:008]), .w_i (w3[15:08]), .sa_i(sa23_next), .sa_o(sa23) );
aes_xor ux13(.clk(clk), .ld_r (ld_r), .text_in(text_in_r[023:016]), .w_i (w3[23:16]), .sa_i(sa13_next), .sa_o(sa13) );
aes_xor ux03(.clk(clk), .ld_r (ld_r), .text_in(text_in_r[031:024]), .w_i (w3[31:24]), .sa_i(sa03_next), .sa_o(sa03) );
aes_xor ux32(.clk(clk), .ld_r (ld_r), .text_in(text_in_r[039:032]), .w_i (w2[07:00]), .sa_i(sa32_next), .sa_o(sa32) );
aes_xor ux22(.clk(clk), .ld_r (ld_r), .text_in(text_in_r[047:040]), .w_i (w2[15:08]), .sa_i(sa22_next), .sa_o(sa22) );
aes_xor ux12(.clk(clk), .ld_r (ld_r), .text_in(text_in_r[055:048]), .w_i (w2[23:16]), .sa_i(sa12_next), .sa_o(sa12) );
aes_xor ux02(.clk(clk), .ld_r (ld_r), .text_in(text_in_r[063:056]), .w_i (w2[31:24]), .sa_i(sa02_next), .sa_o(sa02) );
aes_xor ux31(.clk(clk), .ld_r (ld_r), .text_in(text_in_r[071:064]), .w_i (w1[07:00]), .sa_i(sa31_next), .sa_o(sa31) );
aes_xor ux21(.clk(clk), .ld_r (ld_r), .text_in(text_in_r[079:072]), .w_i (w1[15:08]), .sa_i(sa21_next), .sa_o(sa21) );
aes_xor ux11(.clk(clk), .ld_r (ld_r), .text_in(text_in_r[087:080]), .w_i (w1[23:16]), .sa_i(sa11_next), .sa_o(sa11) );
aes_xor ux01(.clk(clk), .ld_r (ld_r), .text_in(text_in_r[095:088]), .w_i (w1[31:24]), .sa_i(sa01_next), .sa_o(sa01) );
aes_xor ux30(.clk(clk), .ld_r (ld_r), .text_in(text_in_r[103:096]), .w_i (w0[07:00]), .sa_i(sa30_next), .sa_o(sa30) );
aes_xor ux20(.clk(clk), .ld_r (ld_r), .text_in(text_in_r[111:104]), .w_i (w0[15:08]), .sa_i(sa20_next), .sa_o(sa20) );
aes_xor ux10(.clk(clk), .ld_r (ld_r), .text_in(text_in_r[119:112]), .w_i (w0[23:16]), .sa_i(sa10_next), .sa_o(sa10) );
aes_xor ux00(.clk(clk), .ld_r (ld_r), .text_in(text_in_r[127:120]), .w_i (w0[31:24]), .sa_i(sa00_next), .sa_o(sa00) );

endmodule
