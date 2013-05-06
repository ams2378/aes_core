/////////////////////////////////////////////////////////////////////
////                                                             ////
////  AES Cipher Top Level                                       ////
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
//  $Id: aes_cipher_top.v,v 1.1.1.1 2002-11-09 11:22:48 rudi Exp $
//
//  $Date: 2002-11-09 11:22:48 $
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


`timescale 1ns/1ps 


module aes_cipher_top_wddl(clk, rst, ld, done, key, text_in, text_out	
		 );		

input		clk, rst;
input		ld;
input	[127:0]	key;
input	[127:0]	text_in;

output		done;
output	[127:0]	text_out;




////////////////////////////////////////////////////////////////////
//
// Local Wires
//

wire	[31:0]	w0, w1, w2, w3;					
reg	[127:0]	text_in_r;
reg	[127:0]	text_out;
reg	[7:0]	sa00, sa01, sa02, sa03;
reg	[7:0]	sa10, sa11, sa12, sa13;
reg	[7:0]	sa20, sa21, sa22, sa23;
reg	[7:0]	sa30, sa31, sa32, sa33;
wire	[7:0]	sa00_next, sa01_next, sa02_next, sa03_next;
wire	[7:0]	sa10_next, sa11_next, sa12_next, sa13_next;
wire	[7:0]	sa20_next, sa21_next, sa22_next, sa23_next;
wire	[7:0]	sa30_next, sa31_next, sa32_next, sa33_next;
wire	[7:0]	sa00_sub, sa01_sub, sa02_sub, sa03_sub;
wire	[7:0]	sa10_sub, sa11_sub, sa12_sub, sa13_sub;
wire	[7:0]	sa20_sub, sa21_sub, sa22_sub, sa23_sub;
wire	[7:0]	sa30_sub, sa31_sub, sa32_sub, sa33_sub;
wire	[7:0]	sa00_sr, sa01_sr, sa02_sr, sa03_sr;
wire	[7:0]	sa10_sr, sa11_sr, sa12_sr, sa13_sr;
wire	[7:0]	sa20_sr, sa21_sr, sa22_sr, sa23_sr;
wire	[7:0]	sa30_sr, sa31_sr, sa32_sr, sa33_sr;
wire	[7:0]	sa00_mc, sa01_mc, sa02_mc, sa03_mc;
wire	[7:0]	sa10_mc, sa11_mc, sa12_mc, sa13_mc;
wire	[7:0]	sa20_mc, sa21_mc, sa22_mc, sa23_mc;
wire	[7:0]	sa30_mc, sa31_mc, sa32_mc, sa33_mc;
reg		done, ld_r;
reg	[3:0]	dcnt;


////////////////////////////////////////////////////////////////////
//
// Complementary Wires
//

wire	[31:0]	w0_n, w1_n, w2_n, w3_n;					
reg	[127:0]	text_in_r_n;
reg	[127:0]	text_out_n;
reg	[7:0]	sa00_n, sa01_n, sa02_n, sa03_n;
reg	[7:0]	sa10_n, sa11_n, sa12_n, sa13_n;
reg	[7:0]	sa20_n, sa21_n, sa22_n, sa23_n;
reg	[7:0]	sa30_n, sa31_n, sa32_n, sa33_n;
wire	[7:0]	sa00_next_n, sa01_next_n, sa02_next_n, sa03_next_n;
wire	[7:0]	sa10_next_n, sa11_next_n, sa12_next_n, sa13_next_n;
wire	[7:0]	sa20_next_n, sa21_next_n, sa22_next_n, sa23_next_n;
wire	[7:0]	sa30_next_n, sa31_next_n, sa32_next_n, sa33_next_n;
wire	[7:0]	sa00_sub_n, sa01_sub_n, sa02_sub_n, sa03_sub_n;
wire	[7:0]	sa10_sub_n, sa11_sub_n, sa12_sub_n, sa13_sub_n;
wire	[7:0]	sa20_sub_n, sa21_sub_n, sa22_sub_n, sa23_sub_n;
wire	[7:0]	sa30_sub_n, sa31_sub_n, sa32_sub_n, sa33_sub_n;
wire	[7:0]	sa00_sr_n, sa01_sr_n, sa02_sr_n, sa03_sr_n;
wire	[7:0]	sa10_sr_n, sa11_sr_n, sa12_sr_n, sa13_sr_n;
wire	[7:0]	sa20_sr_n, sa21_sr_n, sa22_sr_n, sa23_sr_n;
wire	[7:0]	sa30_sr_n, sa31_sr_n, sa32_sr_n, sa33_sr_n;
wire	[7:0]	sa00_mc_n, sa01_mc_n, sa02_mc_n, sa03_mc_n;
wire	[7:0]	sa10_mc_n, sa11_mc_n, sa12_mc_n, sa13_mc_n;
wire	[7:0]	sa20_mc_n, sa21_mc_n, sa22_mc_n, sa23_mc_n;
wire	[7:0]	sa30_mc_n, sa31_mc_n, sa32_mc_n, sa33_mc_n;

//reg		done_n, ld_r_n;
//reg	[3:0]	dcnt_n;



//wires 
//
wire [7:0] sa00_mc_XOR_w0_31_24, NOT_sa00_mc_XOR_w0_31_24;
wire [7:0] sa01_mc_XOR_w1_31_24, NOT_sa01_mc_XOR_w1_31_24;
wire [7:0] sa02_mc_XOR_w2_31_24, NOT_sa02_mc_XOR_w2_31_24;
wire [7:0] sa03_mc_XOR_w3_31_24, NOT_sa03_mc_XOR_w3_31_24;
wire [7:0] sa10_mc_XOR_w0_23_16, NOT_sa10_mc_XOR_w0_23_16;
wire [7:0] sa11_mc_XOR_w1_23_16, NOT_sa11_mc_XOR_w1_23_16;
wire [7:0] sa12_mc_XOR_w2_23_16, NOT_sa12_mc_XOR_w2_23_16;
wire [7:0] sa13_mc_XOR_w3_23_16, NOT_sa13_mc_XOR_w3_23_16;
wire [7:0] sa20_mc_XOR_w0_15_08, NOT_sa20_mc_XOR_w0_15_08;
wire [7:0] sa21_mc_XOR_w1_15_08, NOT_sa21_mc_XOR_w1_15_08;
wire [7:0] sa22_mc_XOR_w2_15_08, NOT_sa22_mc_XOR_w2_15_08;
wire [7:0] sa23_mc_XOR_w3_15_08, NOT_sa23_mc_XOR_w3_15_08;
wire [7:0] sa30_mc_XOR_w0_07_00, NOT_sa30_mc_XOR_w0_07_00;
wire [7:0] sa31_mc_XOR_w1_07_00, NOT_sa31_mc_XOR_w1_07_00;
wire [7:0] sa32_mc_XOR_w2_07_00, NOT_sa32_mc_XOR_w2_07_00;
wire [7:0] sa33_mc_XOR_w3_07_00, NOT_sa33_mc_XOR_w3_07_00;

wire [7:0] sa00_sr_XOR_w0_31_24, NOT_sa00_sr_XOR_w0_31_24;
wire [7:0] sa01_sr_XOR_w1_31_24, NOT_sa01_sr_XOR_w1_31_24;
wire [7:0] sa02_sr_XOR_w2_31_24, NOT_sa02_sr_XOR_w2_31_24;
wire [7:0] sa03_sr_XOR_w3_31_24, NOT_sa03_sr_XOR_w3_31_24;
wire [7:0] sa10_sr_XOR_w0_23_16, NOT_sa10_sr_XOR_w0_23_16;
wire [7:0] sa11_sr_XOR_w1_23_16, NOT_sa11_sr_XOR_w1_23_16;
wire [7:0] sa12_sr_XOR_w2_23_16, NOT_sa12_sr_XOR_w2_23_16;
wire [7:0] sa13_sr_XOR_w3_23_16, NOT_sa13_sr_XOR_w3_23_16;
wire [7:0] sa20_sr_XOR_w0_15_08, NOT_sa20_sr_XOR_w0_15_08;
wire [7:0] sa21_sr_XOR_w1_15_08, NOT_sa21_sr_XOR_w1_15_08;
wire [7:0] sa22_sr_XOR_w2_15_08, NOT_sa22_sr_XOR_w2_15_08;
wire [7:0] sa23_sr_XOR_w3_15_08, NOT_sa23_sr_XOR_w3_15_08;
wire [7:0] sa30_sr_XOR_w0_07_00, NOT_sa30_sr_XOR_w0_07_00;
wire [7:0] sa31_sr_XOR_w1_07_00, NOT_sa31_sr_XOR_w1_07_00;
wire [7:0] sa32_sr_XOR_w2_07_00, NOT_sa32_sr_XOR_w2_07_00;
wire [7:0] sa33_sr_XOR_w3_07_00, NOT_sa33_sr_XOR_w3_07_00;







////////////////////////////////////////////////////////////////////
//
// Misc Logic
//

always @(posedge clk)
	if(!rst)	dcnt <= #1 4'h0;
	else
	if(ld)		dcnt <= #1 4'hb;
	else
	if(|dcnt)	dcnt <= #1 dcnt - 4'h1;

always @(posedge clk) 

	if (rst)	done <= #1 !(|dcnt[3:1]) & dcnt[0] & !ld;
	else		done <= #1 '0;

always @(posedge clk) if(ld) text_in_r <= #1 text_in;
always @(posedge clk) if(ld) text_in_r_n <= #1 ~text_in;

always @(posedge clk) ld_r <= #1 ld;

////////////////////////////////////////////////////////////////////
//
// Initial Permutation (AddRoundKey)
//

aes_addroundkey_wddl u_addroundkey(.clk(clk), .ld_r (ld_r),
            .text_in_r(text_in_r), .text_in_r_n(text_in_r_n), 
            .w0 (w0), .w1(w1), .w2(w2), .w3(w3),
            .w0_n (w0_n), .w1_n(w1_n), .w2_n(w2_n), .w3_n(w3_n),

			.sa00(sa00),
			.sa01(sa01),
			.sa02(sa02),
			.sa03(sa03),
			.sa10(sa10),
			.sa11(sa11),
			.sa12(sa12),
			.sa13(sa13),
			.sa20(sa20),
			.sa21(sa21),
			.sa22(sa22),
			.sa23(sa23),
			.sa30(sa30),
			.sa31(sa31),
			.sa32(sa32),
			.sa33(sa33),

            .sa00_n(sa00_n),
			.sa01_n(sa01_n),
			.sa02_n(sa02_n),
			.sa03_n(sa03_n),
			.sa10_n(sa10_n),
			.sa11_n(sa11_n),
			.sa12_n(sa12_n),
			.sa13_n(sa13_n),
			.sa20_n(sa20_n),
			.sa21_n(sa21_n),
			.sa22_n(sa22_n),
			.sa23_n(sa23_n),
			.sa30_n(sa30_n),
			.sa31_n(sa31_n),
			.sa32_n(sa32_n),
			.sa33_n(sa33_n),

			.sa00_next(sa00_next),
			.sa01_next(sa01_next),
			.sa02_next(sa02_next),
			.sa03_next(sa03_next),
			.sa10_next(sa10_next),
			.sa11_next(sa11_next),
			.sa12_next(sa12_next),
			.sa13_next(sa13_next),
			.sa20_next(sa20_next),
			.sa21_next(sa21_next),
			.sa22_next(sa22_next),
			.sa23_next(sa23_next),
			.sa30_next(sa30_next),
			.sa31_next(sa31_next),
			.sa32_next(sa32_next),
			.sa33_next(sa33_next),

        	.sa00_next_n(sa00_next_n),
			.sa01_next_n(sa01_next_n),
			.sa02_next_n(sa02_next_n),
			.sa03_next_n(sa03_next_n),
			.sa10_next_n(sa10_next_n),
			.sa11_next_n(sa11_next_n),
			.sa12_next_n(sa12_next_n),
			.sa13_next_n(sa13_next_n),
			.sa20_next_n(sa20_next_n),
			.sa21_next_n(sa21_next_n),
			.sa22_next_n(sa22_next_n),
			.sa23_next_n(sa23_next_n),
			.sa30_next_n(sa30_next_n),
			.sa31_next_n(sa31_next_n),
			.sa32_next_n(sa32_next_n),
			.sa33_next_n(sa33_next_n)	);


////////////////////////////////////////////////////////////////////
//
// Round Permutations
//

assign sa00_sr = sa00_sub;
assign sa01_sr = sa01_sub;
assign sa02_sr = sa02_sub;
assign sa03_sr = sa03_sub;
assign sa10_sr = sa11_sub;
assign sa11_sr = sa12_sub;
assign sa12_sr = sa13_sub;
assign sa13_sr = sa10_sub;
assign sa20_sr = sa22_sub;
assign sa21_sr = sa23_sub;
assign sa22_sr = sa20_sub;
assign sa23_sr = sa21_sub;
assign sa30_sr = sa33_sub;
assign sa31_sr = sa30_sub;
assign sa32_sr = sa31_sub;
assign sa33_sr = sa32_sub;

assign sa00_sr_n = sa00_sub_n;
assign sa01_sr_n = sa01_sub_n;
assign sa02_sr_n = sa02_sub_n;
assign sa03_sr_n = sa03_sub_n;
assign sa10_sr_n = sa11_sub_n;
assign sa11_sr_n = sa12_sub_n;
assign sa12_sr_n = sa13_sub_n;
assign sa13_sr_n = sa10_sub_n;
assign sa20_sr_n = sa22_sub_n;
assign sa21_sr_n = sa23_sub_n;
assign sa22_sr_n = sa20_sub_n;
assign sa23_sr_n = sa21_sub_n;
assign sa30_sr_n = sa33_sub_n;
assign sa31_sr_n = sa30_sub_n;
assign sa32_sr_n = sa31_sub_n;
assign sa33_sr_n = sa32_sub_n;

//MIXCOLUMNS**************************
aes_mixcolumns_wddl mixcol_0
(
    .sa0_sr(sa00_sr),
    .sa1_sr(sa10_sr),
    .sa2_sr(sa20_sr),
    .sa3_sr(sa30_sr),
          
    .sa0_sr_n(sa00_sr_n),
    .sa1_sr_n(sa10_sr_n),
    .sa2_sr_n(sa20_sr_n),
    .sa3_sr_n(sa30_sr_n),

    .sa0_mc(sa00_mc),
    .sa1_mc(sa10_mc),
    .sa2_mc(sa20_mc),
    .sa3_mc(sa30_mc),

    .sa0_mc_n(sa00_mc_n),
    .sa1_mc_n(sa10_mc_n),
    .sa2_mc_n(sa20_mc_n),
    .sa3_mc_n(sa30_mc_n)
);

aes_mixcolumns_wddl mixcol_1
(
    .sa0_sr(sa01_sr),
    .sa1_sr(sa11_sr),
    .sa2_sr(sa21_sr),
    .sa3_sr(sa31_sr),
          
    .sa0_sr_n(sa01_sr_n),
    .sa1_sr_n(sa11_sr_n),
    .sa2_sr_n(sa21_sr_n),
    .sa3_sr_n(sa31_sr_n),

    .sa0_mc(sa01_mc),
    .sa1_mc(sa11_mc),
    .sa2_mc(sa21_mc),
    .sa3_mc(sa31_mc),

    .sa0_mc_n(sa01_mc_n),
    .sa1_mc_n(sa11_mc_n),
    .sa2_mc_n(sa21_mc_n),
    .sa3_mc_n(sa31_mc_n)
);

aes_mixcolumns_wddl mixcol_2
(
    .sa0_sr(sa02_sr),
    .sa1_sr(sa12_sr),
    .sa2_sr(sa22_sr),
    .sa3_sr(sa32_sr),
          
    .sa0_sr_n(sa02_sr_n),
    .sa1_sr_n(sa12_sr_n),
    .sa2_sr_n(sa22_sr_n),
    .sa3_sr_n(sa32_sr_n),

    .sa0_mc(sa02_mc),
    .sa1_mc(sa12_mc),
    .sa2_mc(sa22_mc),
    .sa3_mc(sa32_mc),

    .sa0_mc_n(sa02_mc_n),
    .sa1_mc_n(sa12_mc_n),
    .sa2_mc_n(sa22_mc_n),
    .sa3_mc_n(sa32_mc_n)
);

aes_mixcolumns_wddl mixcol_3
(
    .sa0_sr(sa03_sr),
    .sa1_sr(sa13_sr),
    .sa2_sr(sa23_sr),
    .sa3_sr(sa33_sr),
          
    .sa0_sr_n(sa03_sr_n),
    .sa1_sr_n(sa13_sr_n),
    .sa2_sr_n(sa23_sr_n),
    .sa3_sr_n(sa33_sr_n),

    .sa0_mc(sa03_mc),
    .sa1_mc(sa13_mc),
    .sa2_mc(sa23_mc),
    .sa3_mc(sa33_mc),

    .sa0_mc_n(sa03_mc_n),
    .sa1_mc_n(sa13_mc_n),
    .sa2_mc_n(sa23_mc_n),
    .sa3_mc_n(sa33_mc_n)
);


///////////////////////////////////////////////////////////////////
//


assign sa00_next = sa00_mc_XOR_w0_31_24;   //****** 1 ***** 
assign sa00_next_n = NOT_sa00_mc_XOR_w0_31_24;
 assign sa01_next = sa01_mc_XOR_w1_31_24;   //****** 2 ***** 
assign sa01_next_n = NOT_sa01_mc_XOR_w1_31_24;
 assign sa02_next = sa02_mc_XOR_w2_31_24;   //****** 3 ***** 
assign sa02_next_n = NOT_sa02_mc_XOR_w2_31_24;
 assign sa03_next = sa03_mc_XOR_w3_31_24;   //****** 4 ***** 
assign sa03_next_n = NOT_sa03_mc_XOR_w3_31_24;
 assign sa10_next = sa10_mc_XOR_w0_23_16;   //****** 5 ***** 
assign sa10_next_n = NOT_sa10_mc_XOR_w0_23_16;
 assign sa11_next = sa11_mc_XOR_w1_23_16;   //****** 6 ***** 
assign sa11_next_n = NOT_sa11_mc_XOR_w1_23_16;
 assign sa12_next = sa12_mc_XOR_w2_23_16;   //****** 7 ***** 
assign sa12_next_n = NOT_sa12_mc_XOR_w2_23_16;
 assign sa13_next = sa13_mc_XOR_w3_23_16;   //****** 8 ***** 
assign sa13_next_n = NOT_sa13_mc_XOR_w3_23_16;
 assign sa20_next = sa20_mc_XOR_w0_15_08;   //****** 9 ***** 
assign sa20_next_n = NOT_sa20_mc_XOR_w0_15_08;
 assign sa21_next = sa21_mc_XOR_w1_15_08;   //****** 10 ***** 
assign sa21_next_n = NOT_sa21_mc_XOR_w1_15_08;
 assign sa22_next = sa22_mc_XOR_w2_15_08;   //****** 11 ***** 
assign sa22_next_n = NOT_sa22_mc_XOR_w2_15_08;
 assign sa23_next = sa23_mc_XOR_w3_15_08;   //****** 12 ***** 
assign sa23_next_n = NOT_sa23_mc_XOR_w3_15_08;
 assign sa30_next = sa30_mc_XOR_w0_07_00;   //****** 13 ***** 
assign sa30_next_n = NOT_sa30_mc_XOR_w0_07_00;
 assign sa31_next = sa31_mc_XOR_w1_07_00;   //****** 14 ***** 
assign sa31_next_n = NOT_sa31_mc_XOR_w1_07_00;
 assign sa32_next = sa32_mc_XOR_w2_07_00;   //****** 15 ***** 
assign sa32_next_n = NOT_sa32_mc_XOR_w2_07_00;
 assign sa33_next = sa33_mc_XOR_w3_07_00;   //****** 16 ***** 
assign sa33_next_n = NOT_sa33_mc_XOR_w3_07_00;
 
////////////////////////////////////////////////////////////////////
//
// Final text output
//

always @(posedge clk) text_out[127:120] <= #1 sa00_sr_XOR_w0_31_24;   //****** 17 ***** 
always @(posedge clk) text_out_n[127:120] <= #1 NOT_sa00_sr_XOR_w0_31_24;
 always @(posedge clk) text_out[095:088] <= #1 sa01_sr_XOR_w1_31_24;   //****** 18 ***** 
always @(posedge clk) text_out_n[095:088]  <= #1 NOT_sa01_sr_XOR_w1_31_24;
 always @(posedge clk) text_out[063:056] <= #1 sa02_sr_XOR_w2_31_24;   //****** 19 ***** 
always @(posedge clk) text_out_n[063:056]  <= #1  NOT_sa02_sr_XOR_w2_31_24;
 always @(posedge clk) text_out[031:024] <= #1 sa03_sr_XOR_w3_31_24;   //****** 20 ***** 
always @(posedge clk) text_out_n[031:024]  <= #1  NOT_sa03_sr_XOR_w3_31_24;
 always @(posedge clk) text_out[119:112] <= #1 sa10_sr_XOR_w0_23_16;   //****** 21 ***** 
always @(posedge clk) text_out_n[119:112]  <= #1  NOT_sa10_sr_XOR_w0_23_16;
 always @(posedge clk) text_out[087:080] <= #1 sa11_sr_XOR_w1_23_16;   //****** 22 ***** 
always @(posedge clk) text_out_n[087:080]  <= #1  NOT_sa11_sr_XOR_w1_23_16;
 always @(posedge clk) text_out[055:048] <= #1 sa12_sr_XOR_w2_23_16;   //****** 23 ***** 
always @(posedge clk) text_out_n[055:048]  <= #1  NOT_sa12_sr_XOR_w2_23_16;
 always @(posedge clk) text_out[023:016] <= #1 sa13_sr_XOR_w3_23_16;   //****** 24 ***** 
always @(posedge clk) text_out_n[023:016]  <= #1  NOT_sa13_sr_XOR_w3_23_16;
 always @(posedge clk) text_out[111:104] <= #1 sa20_sr_XOR_w0_15_08;   //****** 25 ***** 
always @(posedge clk) text_out_n[111:104]  <= #1  NOT_sa20_sr_XOR_w0_15_08;
 always @(posedge clk) text_out[079:072] <= #1 sa21_sr_XOR_w1_15_08;   //****** 26 ***** 
always @(posedge clk) text_out_n[079:072]  <= #1  NOT_sa21_sr_XOR_w1_15_08;
 always @(posedge clk) text_out[047:040] <= #1 sa22_sr_XOR_w2_15_08;   //****** 27 ***** 
always @(posedge clk) text_out_n[047:040]  <= #1  NOT_sa22_sr_XOR_w2_15_08;
 always @(posedge clk) text_out[015:008] <= #1 sa23_sr_XOR_w3_15_08;   //****** 28 ***** 
always @(posedge clk) text_out_n[015:008]  <= #1  NOT_sa23_sr_XOR_w3_15_08;
 always @(posedge clk) text_out[103:096] <= #1 sa30_sr_XOR_w0_07_00;   //****** 29 ***** 
always @(posedge clk) text_out_n[103:096]  <= #1  NOT_sa30_sr_XOR_w0_07_00;
 always @(posedge clk) text_out[071:064] <= #1 sa31_sr_XOR_w1_07_00;   //****** 30 ***** 
always @(posedge clk) text_out_n[071:064]  <= #1  NOT_sa31_sr_XOR_w1_07_00;
 always @(posedge clk) text_out[039:032] <= #1 sa32_sr_XOR_w2_07_00;   //****** 31 ***** 
always @(posedge clk) text_out_n[039:032]  <= #1  NOT_sa32_sr_XOR_w2_07_00;
 always @(posedge clk) text_out[007:000] <= #1 sa33_sr_XOR_w3_07_00;   //****** 32 ***** 
always @(posedge clk) text_out_n[007:000]  <= #1  NOT_sa33_sr_XOR_w3_07_00;

 
////////////////////////////////////////////////////////////////////
//
// Generic Functions
//

////////////////////////////////////////////////////////////////////
//
// Modules
//

aes_key_expand_128_wddl u0(
	.clk(		clk	),
	.kld(		ld	),
	.key(		key	),
	.wo_0(		w0	),
	.wo_1(		w1	),
	.wo_2(		w2	),
	.wo_3(		w3	),
	.wo_0_n(		w0_n	),
	.wo_1_n(		w1_n	),
	.wo_2_n(		w2_n	),
	.wo_3_n(		w3_n	)
);

//////////SBOX/////////////////////////////////


aes_sbox_wddl us00(	.a(	sa00	), .a_n( sa00_n) , .d(	sa00_sub	) , .d_n(	sa00_sub_n	));
aes_sbox_wddl us01(	.a(	sa01	), .a_n( sa01_n) , .d(	sa01_sub	) , .d_n(	sa01_sub_n	));
aes_sbox_wddl us02(	.a(	sa02	), .a_n( sa02_n) , .d(	sa02_sub	) , .d_n(	sa02_sub_n	));
aes_sbox_wddl us03(	.a(	sa03	), .a_n( sa03_n) , .d(	sa03_sub	) , .d_n(	sa03_sub_n	));
aes_sbox_wddl us10(	.a(	sa10	), .a_n( sa10_n) , .d(	sa10_sub	) , .d_n(	sa10_sub_n	));
aes_sbox_wddl us11(	.a(	sa11	), .a_n( sa11_n) , .d(	sa11_sub	) , .d_n(	sa11_sub_n	));
aes_sbox_wddl us12(	.a(	sa12	), .a_n( sa12_n) , .d(	sa12_sub	) , .d_n(	sa12_sub_n	));
aes_sbox_wddl us13(	.a(	sa13	), .a_n( sa13_n) , .d(	sa13_sub	) , .d_n(	sa13_sub_n	));
aes_sbox_wddl us20(	.a(	sa20	), .a_n( sa20_n) , .d(	sa20_sub	) , .d_n(	sa20_sub_n	));
aes_sbox_wddl us21(	.a(	sa21	), .a_n( sa21_n) , .d(	sa21_sub	) , .d_n(	sa21_sub_n	));
aes_sbox_wddl us22(	.a(	sa22	), .a_n( sa22_n) , .d(	sa22_sub	) , .d_n(	sa22_sub_n	));
aes_sbox_wddl us23(	.a(	sa23	), .a_n( sa23_n) , .d(	sa23_sub	) , .d_n(	sa23_sub_n	));
aes_sbox_wddl us30(	.a(	sa30	), .a_n( sa30_n) , .d(	sa30_sub	) , .d_n(	sa30_sub_n	));
aes_sbox_wddl us31(	.a(	sa31	), .a_n( sa31_n) , .d(	sa31_sub	) , .d_n(	sa31_sub_n	));
aes_sbox_wddl us32(	.a(	sa32	), .a_n( sa32_n) , .d(	sa32_sub	) , .d_n(	sa32_sub_n	));
aes_sbox_wddl us33(	.a(	sa33	), .a_n( sa33_n) , .d(	sa33_sub	) , .d_n(	sa33_sub_n	));



//***************PORT MAPPINGS ********************************
//
//


//***** 1 ******* 

wddl_xor2 #(8)    XOR_1
(
 .d0_p_in ( sa00_mc )
,.d0_n_in ( sa00_mc_n  )
,.d1_p_in ( w0[31:24] )
,.d1_n_in ( w0_n[31:24] )
,.d_p_out ( sa00_mc_XOR_w0_31_24)
,.d_n_out ( NOT_sa00_mc_XOR_w0_31_24)
);

//***** 2 ******* 

wddl_xor2 #(8)    XOR_2
(
 .d0_p_in ( sa01_mc )
,.d0_n_in ( sa01_mc_n  )
,.d1_p_in ( w1[31:24] )
,.d1_n_in ( w1_n[31:24] )
,.d_p_out ( sa01_mc_XOR_w1_31_24)
,.d_n_out ( NOT_sa01_mc_XOR_w1_31_24)
);

//***** 3 ******* 

wddl_xor2 #(8)    XOR_3
(
 .d0_p_in ( sa02_mc )
,.d0_n_in ( sa02_mc_n  )
,.d1_p_in ( w2[31:24] )
,.d1_n_in ( w2_n[31:24] )
,.d_p_out ( sa02_mc_XOR_w2_31_24)
,.d_n_out ( NOT_sa02_mc_XOR_w2_31_24)
);

//***** 4 ******* 

wddl_xor2 #(8)    XOR_4
(
 .d0_p_in ( sa03_mc )
,.d0_n_in ( sa03_mc_n  )
,.d1_p_in ( w3[31:24] )
,.d1_n_in ( w3_n[31:24] )
,.d_p_out ( sa03_mc_XOR_w3_31_24)
,.d_n_out ( NOT_sa03_mc_XOR_w3_31_24)
);

//***** 5 ******* 

wddl_xor2 #(8)    XOR_5
(
 .d0_p_in ( sa10_mc )
,.d0_n_in ( sa10_mc_n  )
,.d1_p_in ( w0[23:16] )
,.d1_n_in ( w0_n[23:16] )
,.d_p_out ( sa10_mc_XOR_w0_23_16)
,.d_n_out ( NOT_sa10_mc_XOR_w0_23_16)
);

//***** 6 ******* 

wddl_xor2 #(8)    XOR_6
(
 .d0_p_in ( sa11_mc )
,.d0_n_in ( sa11_mc_n  )
,.d1_p_in ( w1[23:16] )
,.d1_n_in ( w1_n[23:16] )
,.d_p_out ( sa11_mc_XOR_w1_23_16)
,.d_n_out ( NOT_sa11_mc_XOR_w1_23_16)
);

//***** 7 ******* 

wddl_xor2 #(8)    XOR_7
(
 .d0_p_in ( sa12_mc )
,.d0_n_in ( sa12_mc_n  )
,.d1_p_in ( w2[23:16] )
,.d1_n_in ( w2_n[23:16] )
,.d_p_out ( sa12_mc_XOR_w2_23_16)
,.d_n_out ( NOT_sa12_mc_XOR_w2_23_16)
);

//***** 8 ******* 

wddl_xor2 #(8)    XOR_8
(
 .d0_p_in ( sa13_mc )
,.d0_n_in ( sa13_mc_n  )
,.d1_p_in ( w3[23:16] )
,.d1_n_in ( w3_n[23:16] )
,.d_p_out ( sa13_mc_XOR_w3_23_16)
,.d_n_out ( NOT_sa13_mc_XOR_w3_23_16)
);

//***** 9 ******* 

wddl_xor2 #(8)    XOR_9
(
 .d0_p_in ( sa20_mc )
,.d0_n_in ( sa20_mc_n  )
,.d1_p_in ( w0[15:08] )
,.d1_n_in ( w0_n[15:08] )
,.d_p_out ( sa20_mc_XOR_w0_15_08)
,.d_n_out ( NOT_sa20_mc_XOR_w0_15_08)
);

//***** 10 ******* 

wddl_xor2 #(8)    XOR_10
(
 .d0_p_in ( sa21_mc )
,.d0_n_in ( sa21_mc_n  )
,.d1_p_in ( w1[15:08] )
,.d1_n_in ( w1_n[15:08] )
,.d_p_out ( sa21_mc_XOR_w1_15_08)
,.d_n_out ( NOT_sa21_mc_XOR_w1_15_08)
);

//***** 11 ******* 

wddl_xor2 #(8)    XOR_11
(
 .d0_p_in ( sa22_mc )
,.d0_n_in ( sa22_mc_n  )
,.d1_p_in ( w2[15:08] )
,.d1_n_in ( w2_n[15:08] )
,.d_p_out ( sa22_mc_XOR_w2_15_08)
,.d_n_out ( NOT_sa22_mc_XOR_w2_15_08)
);

//***** 12 ******* 

wddl_xor2 #(8)    XOR_12
(
 .d0_p_in ( sa23_mc )
,.d0_n_in ( sa23_mc_n  )
,.d1_p_in ( w3[15:08] )
,.d1_n_in ( w3_n[15:08] )
,.d_p_out ( sa23_mc_XOR_w3_15_08)
,.d_n_out ( NOT_sa23_mc_XOR_w3_15_08)
);

//***** 13 ******* 

wddl_xor2 #(8)    XOR_13
(
 .d0_p_in ( sa30_mc )
,.d0_n_in ( sa30_mc_n  )
,.d1_p_in ( w0[07:00] )
,.d1_n_in ( w0_n[07:00] )
,.d_p_out ( sa30_mc_XOR_w0_07_00)
,.d_n_out ( NOT_sa30_mc_XOR_w0_07_00)
);

//***** 14 ******* 

wddl_xor2 #(8)    XOR_14
(
 .d0_p_in ( sa31_mc )
,.d0_n_in ( sa31_mc_n  )
,.d1_p_in ( w1[07:00] )
,.d1_n_in ( w1_n[07:00] )
,.d_p_out ( sa31_mc_XOR_w1_07_00)
,.d_n_out ( NOT_sa31_mc_XOR_w1_07_00)
);

//***** 15 ******* 

wddl_xor2 #(8)    XOR_15
(
 .d0_p_in ( sa32_mc )
,.d0_n_in ( sa32_mc_n  )
,.d1_p_in ( w2[07:00] )
,.d1_n_in ( w2_n[07:00] )
,.d_p_out ( sa32_mc_XOR_w2_07_00)
,.d_n_out ( NOT_sa32_mc_XOR_w2_07_00)
);

//***** 16 ******* 

wddl_xor2 #(8)    XOR_16
(
 .d0_p_in ( sa33_mc )
,.d0_n_in ( sa33_mc_n  )
,.d1_p_in ( w3[07:00] )
,.d1_n_in ( w3_n[07:00] )
,.d_p_out ( sa33_mc_XOR_w3_07_00)
,.d_n_out ( NOT_sa33_mc_XOR_w3_07_00)
);

//***** 17 ******* 

wddl_xor2 #(8)    XOR_17
(
 .d0_p_in ( sa00_sr )
,.d0_n_in ( sa00_sr_n  )
,.d1_p_in ( w0[31:24] )
,.d1_n_in ( w0_n[31:24] )
,.d_p_out ( sa00_sr_XOR_w0_31_24)
,.d_n_out ( NOT_sa00_sr_XOR_w0_31_24)
);

//***** 18 ******* 

wddl_xor2 #(8)    XOR_18
(
 .d0_p_in ( sa01_sr )
,.d0_n_in ( sa01_sr_n  )
,.d1_p_in ( w1[31:24] )
,.d1_n_in ( w1_n[31:24] )
,.d_p_out ( sa01_sr_XOR_w1_31_24)
,.d_n_out ( NOT_sa01_sr_XOR_w1_31_24)
);

//***** 19 ******* 

wddl_xor2 #(8)    XOR_19
(
 .d0_p_in ( sa02_sr )
,.d0_n_in ( sa02_sr_n  )
,.d1_p_in ( w2[31:24] )
,.d1_n_in ( w2_n[31:24] )
,.d_p_out ( sa02_sr_XOR_w2_31_24)
,.d_n_out ( NOT_sa02_sr_XOR_w2_31_24)
);

//***** 20 ******* 

wddl_xor2 #(8)    XOR_20
(
 .d0_p_in ( sa03_sr )
,.d0_n_in ( sa03_sr_n  )
,.d1_p_in ( w3[31:24] )
,.d1_n_in ( w3_n[31:24] )
,.d_p_out ( sa03_sr_XOR_w3_31_24)
,.d_n_out ( NOT_sa03_sr_XOR_w3_31_24)
);

//***** 21 ******* 

wddl_xor2 #(8)    XOR_21
(
 .d0_p_in ( sa10_sr )
,.d0_n_in ( sa10_sr_n  )
,.d1_p_in ( w0[23:16] )
,.d1_n_in ( w0_n[23:16] )
,.d_p_out ( sa10_sr_XOR_w0_23_16)
,.d_n_out ( NOT_sa10_sr_XOR_w0_23_16)
);

//***** 22 ******* 

wddl_xor2 #(8)    XOR_22
(
 .d0_p_in ( sa11_sr )
,.d0_n_in ( sa11_sr_n  )
,.d1_p_in ( w1[23:16] )
,.d1_n_in ( w1_n[23:16] )
,.d_p_out ( sa11_sr_XOR_w1_23_16)
,.d_n_out ( NOT_sa11_sr_XOR_w1_23_16)
);

//***** 23 ******* 

wddl_xor2 #(8)    XOR_23
(
 .d0_p_in ( sa12_sr )
,.d0_n_in ( sa12_sr_n  )
,.d1_p_in ( w2[23:16] )
,.d1_n_in ( w2_n[23:16] )
,.d_p_out ( sa12_sr_XOR_w2_23_16)
,.d_n_out ( NOT_sa12_sr_XOR_w2_23_16)
);

//***** 24 ******* 

wddl_xor2 #(8)    XOR_24
(
 .d0_p_in ( sa13_sr )
,.d0_n_in ( sa13_sr_n  )
,.d1_p_in ( w3[23:16] )
,.d1_n_in ( w3_n[23:16] )
,.d_p_out ( sa13_sr_XOR_w3_23_16)
,.d_n_out ( NOT_sa13_sr_XOR_w3_23_16)
);

//***** 25 ******* 

wddl_xor2 #(8)    XOR_25
(
 .d0_p_in ( sa20_sr )
,.d0_n_in ( sa20_sr_n  )
,.d1_p_in ( w0[15:08] )
,.d1_n_in ( w0_n[15:08] )
,.d_p_out ( sa20_sr_XOR_w0_15_08)
,.d_n_out ( NOT_sa20_sr_XOR_w0_15_08)
);

//***** 26 ******* 

wddl_xor2 #(8)    XOR_26
(
 .d0_p_in ( sa21_sr )
,.d0_n_in ( sa21_sr_n  )
,.d1_p_in ( w1[15:08] )
,.d1_n_in ( w1_n[15:08] )
,.d_p_out ( sa21_sr_XOR_w1_15_08)
,.d_n_out ( NOT_sa21_sr_XOR_w1_15_08)
);

//***** 27 ******* 

wddl_xor2 #(8)    XOR_27
(
 .d0_p_in ( sa22_sr )
,.d0_n_in ( sa22_sr_n  )
,.d1_p_in ( w2[15:08] )
,.d1_n_in ( w2_n[15:08] )
,.d_p_out ( sa22_sr_XOR_w2_15_08)
,.d_n_out ( NOT_sa22_sr_XOR_w2_15_08)
);

//***** 28 ******* 

wddl_xor2 #(8)    XOR_28
(
 .d0_p_in ( sa23_sr )
,.d0_n_in ( sa23_sr_n  )
,.d1_p_in ( w3[15:08] )
,.d1_n_in ( w3_n[15:08] )
,.d_p_out ( sa23_sr_XOR_w3_15_08)
,.d_n_out ( NOT_sa23_sr_XOR_w3_15_08)
);

//***** 29 ******* 

wddl_xor2 #(8)    XOR_29
(
 .d0_p_in ( sa30_sr )
,.d0_n_in ( sa30_sr_n  )
,.d1_p_in ( w0[07:00] )
,.d1_n_in ( w0_n[07:00] )
,.d_p_out ( sa30_sr_XOR_w0_07_00)
,.d_n_out ( NOT_sa30_sr_XOR_w0_07_00)
);

//***** 30 ******* 

wddl_xor2 #(8)    XOR_30
(
 .d0_p_in ( sa31_sr )
,.d0_n_in ( sa31_sr_n  )
,.d1_p_in ( w1[07:00] )
,.d1_n_in ( w1_n[07:00] )
,.d_p_out ( sa31_sr_XOR_w1_07_00)
,.d_n_out ( NOT_sa31_sr_XOR_w1_07_00)
);

//***** 31 ******* 

wddl_xor2 #(8)    XOR_31
(
 .d0_p_in ( sa32_sr )
,.d0_n_in ( sa32_sr_n  )
,.d1_p_in ( w2[07:00] )
,.d1_n_in ( w2_n[07:00] )
,.d_p_out ( sa32_sr_XOR_w2_07_00)
,.d_n_out ( NOT_sa32_sr_XOR_w2_07_00)
);

//***** 32 ******* 

wddl_xor2 #(8)    XOR_32
(
 .d0_p_in ( sa33_sr )
,.d0_n_in ( sa33_sr_n  )
,.d1_p_in ( w3[07:00] )
,.d1_n_in ( w3_n[07:00] )
,.d_p_out ( sa33_sr_XOR_w3_07_00)
,.d_n_out ( NOT_sa33_sr_XOR_w3_07_00)
);









endmodule



