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
 
//    logic [7:0]   sbox_a;
//    logic [7:0]	  sbox_b;
  
    logic rst;

    clocking cb @(posedge clk);
//        default output #1;

       	output rst;	
	output ld;
	output key;
	output text_in;

	input done;
	input text_out;
//	input sbox_a;
//	input sbox_b;
    endclocking

    modport dut (

	input clk,
	input rst,
	
	input key,
	input text_in,
	input ld,

	output text_out,
	output done
//	output sbox_a,
//	output sbox_b

	);

    modport bench (clocking cb);
endinterface
