/**
 * @filename		aes_mixcolumns_wddl.sv 
 *
 */

module aes_mixcolumns_wddl (
            sa0_sr,
            sa1_sr,
            sa2_sr,
            sa3_sr,
          
            sa0_sr_n,
            sa1_sr_n,
            sa2_sr_n,
            sa3_sr_n,

            sa0_mc,
            sa1_mc,
            sa2_mc,
            sa3_mc,

            sa0_mc_n,
            sa1_mc_n,
            sa2_mc_n,
            sa3_mc_n
        );

input	[7:0]	sa0_sr, sa1_sr, sa2_sr, sa3_sr;
input	[7:0]	sa0_sr_n, sa1_sr_n, sa2_sr_n, sa3_sr_n;
output	[7:0]	sa0_mc, sa1_mc, sa2_mc, sa3_mc;
output	[7:0]	sa0_mc_n, sa1_mc_n, sa2_mc_n, sa3_mc_n;

wire    [7:0]   xtime_sa0_sr, xtime_sa0_sr_n;
wire    [7:0]   xtime_sa1_sr, xtime_sa1_sr_n;
wire    [7:0]   xtime_sa2_sr, xtime_sa2_sr_n;
wire    [7:0]   xtime_sa3_sr, xtime_sa3_sr_n;

//WDDL 5 XORS


wddl_xor5 #(8)  MIXCOL_31_24
(
    .d0_p_in(xtime_sa0_sr)
,   .d0_n_in(xtime_sa0_sr_n   )
,   .d1_p_in(xtime_sa1_sr   )
,   .d1_n_in(xtime_sa1_sr_n   )
,   .d2_p_in(sa1_sr   )
,   .d2_n_in(sa1_sr_n   )
,   .d3_p_in(sa2_sr   )
,   .d3_n_in(sa2_sr_n   )
,   .d4_p_in(sa3_sr   )
,   .d4_n_in(sa3_sr_n   )
,   .d_p_out(sa0_mc   )
,   .d_n_out(sa0_mc_n   )
);

wddl_xor5 #(8)  MIXCOL_23_16
(
    .d0_p_in(sa0_sr   )
,   .d0_n_in(sa0_sr_n   )
,   .d1_p_in(xtime_sa1_sr   )
,   .d1_n_in(xtime_sa1_sr_n   )
,   .d2_p_in(xtime_sa2_sr   )
,   .d2_n_in(xtime_sa2_sr_n   )
,   .d3_p_in(sa2_sr   )
,   .d3_n_in(sa2_sr_n   )
,   .d4_p_in(sa3_sr   )
,   .d4_n_in(sa3_sr_n   )
,   .d_p_out(sa1_mc   )
,   .d_n_out(sa1_mc_n   )
);

wddl_xor5 #(8)  MIXCOL_15_08
(
    .d0_p_in(sa0_sr   )
,   .d0_n_in(sa0_sr_n   )
,   .d1_p_in(sa1_sr   )
,   .d1_n_in(sa1_sr_n   )
,   .d2_p_in(xtime_sa2_sr   )
,   .d2_n_in(xtime_sa2_sr_n   )
,   .d3_p_in(xtime_sa3_sr   )
,   .d3_n_in(xtime_sa3_sr_n   )
,   .d4_p_in(sa3_sr   )
,   .d4_n_in(sa3_sr_n   )
,   .d_p_out(sa2_mc   )
,   .d_n_out(sa2_mc_n   )
);

wddl_xor5 #(8)  MIXCOL_07_00
(
    .d0_p_in(xtime_sa0_sr   )
,   .d0_n_in(xtime_sa0_sr_n   )
,   .d1_p_in(sa0_sr   )
,   .d1_n_in(sa0_sr_n   )
,   .d2_p_in(sa1_sr   )
,   .d2_n_in(sa1_sr_n   )
,   .d3_p_in(sa2_sr   )
,   .d3_n_in(sa2_sr_n   )
,   .d4_p_in(xtime_sa3_sr   )
,   .d4_n_in(xtime_sa3_sr_n   )
,   .d_p_out(sa3_mc   )
,   .d_n_out(sa3_mc_n   )
);




//WDDL 2 XORS

wddl_xor2 #(8)    XTIME_SA0_SR
(
 .d0_p_in ({sa0_sr[6:0],1'b0} )
,.d0_n_in ({sa0_sr_n[6:0], 1'b0} )
,.d1_p_in (8'h1b&{8{sa0_sr[7]}} )       //NEEDS SOME MODIFICATION FOR COMPLEMENTATRY??? TODO
,.d1_n_in (8'h1b&{8{sa0_sr_n[7]}}   )
,.d_p_out ( xtime_sa0_sr)
,.d_n_out ( xtime_sa0_sr_n)
);

wddl_xor2 #(8)    XTIME_SA1_SR
(
 .d0_p_in ({sa1_sr[6:0],1'b0} )
,.d0_n_in ({sa1_sr_n[6:0], 1'b0} )
,.d1_p_in (8'h1b&{8{sa1_sr[7]}}  )
,.d1_n_in (8'h1b&{8{sa1_sr_n[7]}}   )
,.d_p_out ( xtime_sa1_sr)
,.d_n_out ( xtime_sa1_sr_n)
);

wddl_xor2 #(8)    XTIME_SA2_SR
(
 .d0_p_in ({sa2_sr[6:0],1'b0} )
,.d0_n_in ({sa2_sr_n[6:0], 1'b0} )
,.d1_p_in (8'h1b&{8{sa2_sr[7]}}  )
,.d1_n_in (8'h1b&{8{sa2_sr_n[7]}}   )
,.d_p_out ( xtime_sa2_sr)
,.d_n_out ( xtime_sa2_sr_n)
);

wddl_xor2 #(8)    XTIME_SA3_SR
(
 .d0_p_in ({sa3_sr[6:0],1'b0} )
,.d0_n_in ({sa3_sr_n[6:0], 1'b0} )
,.d1_p_in (8'h1b&{8{sa3_sr[7]}}  )
,.d1_n_in (8'h1b&{8{sa3_sr_n[7]}}   )
,.d_p_out ( xtime_sa3_sr)
,.d_n_out ( xtime_sa3_sr_n)
);





endmodule

