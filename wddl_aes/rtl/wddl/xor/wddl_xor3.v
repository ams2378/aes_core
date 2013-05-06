module  wddl_xor3
(
 d0_p_in
,d0_n_in
,d1_p_in
,d1_n_in
,d2_p_in
,d2_n_in
,d_p_out
,d_n_out
);

parameter WIDTH      = 1;

input   [WIDTH-1 : 0]   d0_p_in, d0_n_in;
input   [WIDTH-1 : 0]   d1_p_in, d1_n_in;
input   [WIDTH-1 : 0]   d2_p_in, d2_n_in;
output  [WIDTH-1 : 0]   d_p_out, d_n_out;

wire    [WIDTH-1 : 0]   dt_p_w, dt_n_w;


wddl_xor2 #(WIDTH)    U_XOR_T
(
 .d0_p_in   ( d0_p_in   )
,.d0_n_in   ( d0_n_in   )
,.d1_p_in   ( d1_p_in   )
,.d1_n_in   ( d1_n_in   )
,.d_p_out   ( dt_p_w    )
,.d_n_out   ( dt_n_w    )
);

wddl_xor2 #(WIDTH)    U_XOR
(
 .d0_p_in   ( dt_p_w    )
,.d0_n_in   ( dt_n_w    )
,.d1_p_in   ( d2_p_in   )
,.d1_n_in   ( d2_n_in   )
,.d_p_out   ( d_p_out   )
,.d_n_out   ( d_n_out   )
);


endmodule

