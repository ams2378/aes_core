module  wddl_xor2
(
 d0_p_in
,d0_n_in
,d1_p_in
,d1_n_in
,d_p_out
,d_n_out
);

parameter WIDTH = 1;

input[WIDTH-1:0]   d0_p_in, d0_n_in;
input[WIDTH-1:0]   d1_p_in, d1_n_in;
output[WIDTH-1:0]   d_p_out, d_n_out;


assign  d_p_out = (d0_n_in & d1_p_in) | (d0_p_in & d1_n_in);
assign  d_n_out = (d0_p_in | d1_n_in) & (d0_n_in | d1_p_in);

endmodule

