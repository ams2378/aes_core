module  wddl_xor2
(
 clk
,ld_r
,text_in
,d0_p_in	//	w_i	
,d0_n_in	//	w_i inverted
,d1_p_in	//	sa_i	
,d1_n_in	//	sa_i inverter
,d_p_out	//	sa_o
,d_n_out	//	sa_o inverted
);

parameter WIDTH      = 1;

input   [WIDTH-1 : 0]   d0_p_in, d0_n_in;
input   [WIDTH-1 : 0]   d1_p_in, d1_n_in;
output  [WIDTH-1 : 0]   d_p_out, d_n_out;


always @(posedge clk) begin

 	d_p_out <= (d0_n_in & d1_p_in) | (d0_p_in & d1_n_in);
assign  d_n_out = (d0_p_in | d1_n_in) & (d0_n_in | d1_p_in);


end

endmodule

