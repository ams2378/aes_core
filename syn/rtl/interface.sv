/**
* @filename  		interface.sv 
*
* @brief     		The file defines the interfaces for test becnh and dut
* @authors   		Dechhin Lama <ddl2126@columbia.edu>
*			
* @modified by		Adil Sadik <ams2378@columbia.edu>
*  	 
*/

`timescale 1ns/1ps 

interface ifc (input bit clk);
logic 		ld;
logic [31:0] 	key;
logic [31:0] 	text_in;

logic 		done;
logic 		ld_r;
logic [31:0] 	text_out;
logic [127:0] 	text_in_r;
logic [31:0] 	w0, w1, w2, w3;
    
logic 	[3:0]  	dcnt;

logic	[7:0]	sa00, sa01, sa02, sa03;
logic	[7:0]	sa10, sa11, sa12, sa13;
logic	[7:0]	sa20, sa21, sa22, sa23;
logic	[7:0]	sa30, sa31, sa32, sa33;
logic	[7:0]	sa00_next, sa01_next, sa02_next, sa03_next;
logic	[7:0]	sa10_next, sa11_next, sa12_next, sa13_next;
logic	[7:0]	sa20_next, sa21_next, sa22_next, sa23_next;
logic	[7:0]	sa30_next, sa31_next, sa32_next, sa33_next;

logic 		rst;

     dut (

	input 		clk,
	input 		rst,
		
	input 		key,
	input 		text_in,
	input 		ld,

	output		text_in_r,
	output		w0, w1, w2, w3,


	output 		text_out,
	output 		done,
	output 		dcnt,
	output		ld_r,

	output		sa00, sa01, sa02, sa03,
	output		sa10, sa11, sa12, sa13,
	output		sa20, sa21, sa22, sa23,
	output		sa30, sa31, sa32, sa33,
	output		sa00_next, sa01_next, sa02_next, sa03_next,
	output		sa10_next, sa11_next, sa12_next, sa13_next,
	output		sa20_next, sa21_next, sa22_next, sa23_next,
	output		sa30_next, sa31_next, sa32_next, sa33_next

	);

endinterface
