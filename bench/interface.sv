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
    logic ld;
    logic [127:0] key;
    logic [127:0] text_in;

    logic done;
    logic [127:0] text_out;

logic	[7:0]	sa00, sa01, sa02, sa03;
logic	[7:0]	sa10, sa11, sa12, sa13;
logic	[7:0]	sa20, sa21, sa22, sa23;
logic	[7:0]	sa30, sa31, sa32, sa33;
logic	[7:0]	sa00_sub, sa01_sub, sa02_sub, sa03_sub;
logic	[7:0]	sa10_sub, sa11_sub, sa12_sub, sa13_sub;
logic	[7:0]	sa20_sub, sa21_sub, sa22_sub, sa23_sub;
logic	[7:0]	sa30_sub, sa31_sub, sa32_sub, sa33_sub;

    logic rst;

    clocking cb @(posedge clk);
//        default output #1;

       	output rst;	
	output ld;
	output key;
	output text_in;

	input done;
	input text_out;
	input		sa00, sa01, sa02, sa03;
	input		sa10, sa11, sa12, sa13;
	input		sa20, sa21, sa22, sa23;
	input		sa30, sa31, sa32, sa33;
	input		sa00_sub, sa01_sub, sa02_sub, sa03_sub;
	input		sa10_sub, sa11_sub, sa12_sub, sa13_sub;
	input		sa20_sub, sa21_sub, sa22_sub, sa23_sub;
	input		sa30_sub, sa31_sub, sa32_sub, sa33_sub;
    endclocking

    modport dut (

	input clk,
	input rst,
	
	input key,
	input text_in,
	input ld,

	output text_out,
	output done,

	output		sa00, sa01, sa02, sa03,
	output		sa10, sa11, sa12, sa13,
	output		sa20, sa21, sa22, sa23,
	output		sa30, sa31, sa32, sa33,
	output		sa00_sub, sa01_sub, sa02_sub, sa03_sub,
	output		sa10_sub, sa11_sub, sa12_sub, sa13_sub,
	output		sa20_sub, sa21_sub, sa22_sub, sa23_sub,
	output		sa30_sub, sa31_sub, sa32_sub, sa33_sub



	);

    modport bench (clocking cb);
endinterface
