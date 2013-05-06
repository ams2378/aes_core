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

	logic rst;
	logic ld;
	logic [127:0] key;
	logic [127:0] text_in;
	
	logic done;
	logic [127:0] text_out;



    clocking cb @(posedge clk);
//        default output #1;
    
    	output rst;
	output ld;
	output key;
	output text_in;
	
	input text_out;
	input done;

endclocking

    modport dut (
        
input		clk,
input 		rst,
input		ld,
input 		key,
input 		text_in,
output 		text_out,
output		done


	);

  modport bench (clocking cb);














/*
logic		ld_r;

logic [127:0]	text_in_r;
logic [127:0]    text_in_r_n;

logic [31:0]	w0, w1, w2, w3;
logic [31:0] w0_n, w1_n, w2_n, w3_n;

logic	[7:0]	sa00, sa01, sa02, sa03;
logic	[7:0]	sa10, sa11, sa12, sa13;
logic	[7:0]	sa20, sa21, sa22, sa23;
logic	[7:0]	sa30, sa31, sa32, sa33;

logic	[7:0]	sa00_n, sa01_n, sa02_n, sa03_n;
logic	[7:0]	sa10_n, sa11_n, sa12_n, sa13_n;
logic	[7:0]	sa20_n, sa21_n, sa22_n, sa23_n;
logic	[7:0]	sa30_n, sa31_n, sa32_n, sa33_n;

logic	[7:0]	sa00_next, sa01_next, sa02_next, sa03_next;
logic	[7:0]	sa10_next, sa11_next, sa12_next, sa13_next;
logic	[7:0]	sa20_next, sa21_next, sa22_next, sa23_next;
logic	[7:0]	sa30_next, sa31_next, sa32_next, sa33_next;

logic	[7:0]	sa00_next_n, sa01_next_n, sa02_next_n, sa03_next_n;
logic	[7:0]	sa10_next_n, sa11_next_n, sa12_next_n, sa13_next_n;
logic	[7:0]	sa20_next_n, sa21_next_n, sa22_next_n, sa23_next_n;
logic	[7:0]	sa30_next_n, sa31_next_n, sa32_next_n, sa33_next_n;



    clocking cb @(posedge clk);
//        default output #1;
    
output		ld_r;

output text_in_r;
output text_in_r_n;

output w0; output w1; output w2; output  w3;
output w0_n; output w1_n;output w2_n; output w3_n;

input sa00; input sa01; input sa02; input sa03;
input sa10; input sa11; input sa12; input sa13;
input sa20; input sa21; input sa22; input sa23;
input sa30; input sa31; input sa32; input sa33;

input sa00_n; input sa01_n; input sa02_n; input sa03_n;
input sa10_n; input sa11_n; input sa12_n; input sa13_n;
input sa20_n; input sa21_n; input sa22_n; input sa23_n;
input sa30_n; input sa31_n; input sa32_n; input sa33_n;

output sa00_next; output sa01_next; output sa02_next; output sa03_next;
output sa10_next; output sa11_next; output sa12_next; output sa13_next;
output sa20_next; output sa21_next; output sa22_next; output sa23_next;
output sa30_next; output sa31_next; output sa32_next; output sa33_next;

output sa00_next_n; output sa01_next_n; output sa02_next_n; output sa03_next_n;
output sa10_next_n; output sa11_next_n; output sa12_next_n; output sa13_next_n;
output sa20_next_n; output sa21_next_n; output sa22_next_n; output sa23_next_n;
output sa30_next_n; output sa31_next_n; output sa32_next_n; output sa33_next_n;
     


endclocking

    modport dut (
        
input		clk,
input		ld_r,

input text_in_r,
input text_in_r_n,

input w0, input w1, input w2,input  w3,
input w0_n, input w1_n,input w2_n, input w3_n,

output sa00, output sa01, output sa02, output sa03,
output sa10, output sa11, output sa12, output sa13,
output sa20, output sa21, output sa22, output sa23,
output sa30, output sa31, output sa32, output sa33,

output sa00_n, output sa01_n, output sa02_n, output sa03_n,
output sa10_n, output sa11_n, output sa12_n, output sa13_n,
output sa20_n, output sa21_n, output sa22_n, output sa23_n,
output sa30_n, output sa31_n, output sa32_n, output sa33_n,

input sa00_next, input sa01_next, input sa02_next, input sa03_next,
input sa10_next, input sa11_next, input sa12_next, input sa13_next,
input sa20_next, input sa21_next, input sa22_next, input sa23_next,
input sa30_next, input sa31_next, input sa32_next, input sa33_next,

input sa00_next_n, input sa01_next_n, input sa02_next_n, input sa03_next_n,
input sa10_next_n, input sa11_next_n, input sa12_next_n, input sa13_next_n,
input sa20_next_n, input sa21_next_n, input sa22_next_n, input sa23_next_n,
input sa30_next_n, input sa31_next_n, input sa32_next_n, input sa33_next_n


	);

  modport bench (clocking cb);
*/


endinterface
