/**
 * @filename		aes_addroundkey.sv 
 *
 * @brief     	        xor for addroundkey operation  	
 *
 * @author		Adil Sadik <sadik.adil@gmail.com> 
 *
 * @dependencies	none	
 */


module aes_xor_wddl ( clk, ld_r, text_in, text_in_n , w_i, w_i_n , sa_i, sa_i_n , sa_o, sa_o_n);

input		clk;
input		ld_r;	

input [7:0] 	text_in;
input [7:0] 	w_i;
input [7:0] 	sa_i;
output[7:0] 	sa_o;

reg[7:0]    	sa_o;

input [7:0] 	text_in_n;
input [7:0] 	w_i_n;
input [7:0] 	sa_i_n;
output[7:0] 	sa_o_n;

reg[7:0]    	sa_o_n;

reg[7:0] text_in_XOR_w_i;
reg[7:0] NOT_text_in_XOR_w_i;


always @ (posedge clk) begin
	sa_o <= #1 ld_r ? text_in_XOR_w_i : sa_i;
    sa_o_n <= #1 ld_r ? NOT_text_in_XOR_w_i : sa_i_n;
end


//wddl xor

wddl_xor2 #(8)  custom_XOR(
 .d0_p_in ( text_in )
,.d0_n_in ( text_in_n  )
,.d1_p_in ( w_i )
,.d1_n_in ( w_i_n )
,.d_p_out ( text_in_XOR_w_i)
,.d_n_out ( NOT_text_in_XOR_w_i)
);



endmodule
