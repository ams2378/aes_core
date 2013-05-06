/////////////////////////////////////////////////////////////////////
////                                                             ////
////  AES Key Expand Block (for 128 bit keys)                    ////
////                                                             ////
////                                                             ////
////  Author: Rudolf Usselmann                                   ////
////          rudi@asics.ws                                      ////
////                                                             ////
////                                                             ////
////  Downloaded from: http://www.opencores.org/cores/aes_core/  ////
////                                                             ////
/////////////////////////////////////////////////////////////////////
////                                                             ////
//// Copyright (C) 2000-2002 Rudolf Usselmann                    ////
////                         www.asics.ws                        ////
////                         rudi@asics.ws                       ////
////                                                             ////
//// This source file may be used and distributed without        ////
//// restriction provided that this copyright statement is not   ////
//// removed from the file and that any derivative work contains ////
//// the original copyright notice and the associated disclaimer.////
////                                                             ////
////     THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY     ////
//// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED   ////
//// TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS   ////
//// FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL THE AUTHOR      ////
//// OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,         ////
//// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES    ////
//// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE   ////
//// GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR        ////
//// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF  ////
//// LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT  ////
//// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT  ////
//// OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE         ////
//// POSSIBILITY OF SUCH DAMAGE.                                 ////
////                                                             ////
/////////////////////////////////////////////////////////////////////

//  CVS Log
//
//  $Id: aes_key_expand_128.v,v 1.1.1.1 2002-11-09 11:22:38 rudi Exp $
//
//  $Date: 2002-11-09 11:22:38 $
//  $Revision: 1.1.1.1 $
//  $Author: rudi $
//  $Locker:  $
//  $State: Exp $
//
// Change History:
//               $Log: not supported by cvs2svn $
//
//
//
//
//

//`include "timescale.v"

`timescale 1ns/1ps


module aes_key_expand_128_wddl (clk, kld, key, wo_0, wo_1, wo_2, wo_3, wo_0_n, wo_1_n, wo_2_n, wo_3_n );
input		clk;
input		kld;
input	[127:0]	key;

output	[31:0]	wo_0, wo_1, wo_2, wo_3;
output  [31:0]  wo_0_n, wo_1_n, wo_2_n, wo_3_n;

reg	[31:0]	w[3:0];
wire	[31:0]	tmp_w;
wire	[31:0]	subword;
wire	[31:0]	rcon;

reg	[31:0]	w_n[3:0];
wire	[31:0]	tmp_w_n;
wire	[31:0]	subword_n;
wire	[31:0]	rcon_n;


///WDDL XORS/////////////////
//
wire [31:0] w_0;
wire [31:0] NOT_w_0;
wire [31:0] w_1;
wire [31:0] NOT_w_1;
wire [31:0] w_2;
wire [31:0] NOT_w_2;
wire [31:0] w_3; 
wire [31:0]NOT_w_3;




assign wo_0 = w[0];
assign wo_1 = w[1];
assign wo_2 = w[2];
assign wo_3 = w[3];

assign wo_0_n = w_n[0];
assign wo_1_n = w_n[1];
assign wo_2_n = w_n[2];
assign wo_3_n = w_n[3];


always @(posedge clk)	w[0] <= #1 kld ? key[127:096] : w_0;
always @(posedge clk)	w_n[0] <= #1 kld ? ~key[127:096] : NOT_w_0;

always @(posedge clk)	w[1] <= #1 kld ? key[095:064] : w_1;
always @(posedge clk)	w[1] <= #1 kld ? ~key[095:064] : NOT_w_1;

always @(posedge clk)	w[2] <= #1 kld ? key[063:032] : w_2;
always @(posedge clk)	w[2] <= #1 kld ? ~key[063:032] : NOT_w_2;

always @(posedge clk)	w[3] <= #1 kld ? key[031:000] : w_3;
always @(posedge clk)	w[3] <= #1 kld ? ~key[031:000] : NOT_w_3;


wddl_xor3 #(32)    XOR_W0
(
 .d0_p_in ( w[0] )
,.d0_n_in ( w_n[0]  )
,.d1_p_in ( subword )
,.d1_n_in ( subword_n )
,.d2_p_in ( rcon    )
,.d2_n_in ( rcon_n )
,.d_p_out ( w_0 )
,.d_n_out ( NOT_w_0 )
);

wddl_xor4 #(32)    XOR_W1
(
 .d0_p_in ( w[0] )
,.d0_n_in ( w_n[0]  )
,.d1_p_in ( w[1] )
,.d1_n_in ( w_n[1] )
,.d2_p_in ( subword    )
,.d2_n_in ( subword_n )
,.d3_p_in ( rcon )
,.d3_n_in ( rcon_n) 
,.d_p_out ( w_1 )
,.d_n_out ( NOT_w_1 )
);

wddl_xor5 #(32)    XOR_W2
(
 .d0_p_in ( w[0] )
,.d0_n_in ( w_n[0]  )
,.d1_p_in ( w[2] )
,.d1_n_in ( w_n[2] )
,.d2_p_in ( w[1]    )
,.d2_n_in ( w_n[1] )
,.d3_p_in ( subword )
,.d3_n_in ( subword_n)
,.d4_p_in ( rcon )
,.d4_n_in ( rcon_n )
,.d_p_out ( w_2 )
,.d_n_out ( NOT_w_2 )
);

wddl_xor6 #(32)    XOR_W3
(
 .d0_p_in ( w[0] )
,.d0_n_in ( w_n[0]  )
,.d1_p_in ( w[3] )
,.d1_n_in ( w_n[3] )
,.d2_p_in ( w[2]   )
,.d2_n_in ( w_n[2] )
,.d3_p_in ( w[1] )
,.d3_n_in ( w_n[1] )
,.d4_p_in ( subword )
,.d4_n_in ( subword_n )
,.d5_p_in ( rcon )
,.d5_n_in ( rcon_n) 
,.d_p_out ( w_3  )
,.d_n_out ( NOT_w_3 )
);

///////////////////////////////////////
//

assign tmp_w = w[3];
assign tmp_w_n = w_n[3];



aes_sbox_wddl u0(	.a(tmp_w[23:16]),	.a_n(tmp_w_n[23:16]), .d(subword[31:24]), .d_n(subword_n[31:24]) );
aes_sbox_wddl u1(	.a(tmp_w[15:08]),	.a_n(tmp_w_n[15:08]), .d(subword[23:16]), .d_n(subword_n[23:16]) );
aes_sbox_wddl u2(	.a(tmp_w[07:00]),	.a_n(tmp_w_n[07:00]), .d(subword[15:08]), .d_n(subword_n[15:08]) );
aes_sbox_wddl u3(	.a(tmp_w[31:24]),	.a_n(tmp_w_n[31:24]), .d(subword[07:00]), .d_n(subword_n[07:00]) );



aes_rcon_wddl r0(	.clk(clk), .kld(kld), .out(rcon), .out_n(rcon_n)); 
endmodule

