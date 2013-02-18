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

    logic kld;
    logic kdone;
    logic done;
    logic [127:0] text_out;
   
    logic rst;

    clocking cb @(posedge clk);
//        default output #1;

       	output rst;	
	output ld;
	output key;
	output text_in;
	output kld;

	input kdone;
	input done;
	input text_out;
    endclocking

    modport dut (

	input clk,
	input rst,
	
	input key,
	input text_in,
	input ld,
	input kld,

	output kdone,
	output text_out,
	output done
	);

    modport bench (clocking cb);
endinterface
