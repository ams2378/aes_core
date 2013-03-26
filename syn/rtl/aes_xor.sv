/**
 * @filename		aes_addroundkey.sv 
 *
 * @brief     	        xor for addroundkey operation  	
 *
 * @author		Adil Sadik <sadik.adil@gmail.com> 
 *
 * @dependencies	none	
 */


module aes_xor ( clk, ld_r, text_in, w_i, sa_i, sa_o);

input		clk;
input		ld_r;	
input [7:0] 	text_in;
input [7:0] 	w_i;
input [7:0] 	sa_i;
output[7:0] 	sa_o;

reg[7:0]    	sa_o;

always @ (posedge clk) begin
	sa_o <= #1 ld_r ? text_in ^ w_i : sa_i;
end

endmodule
