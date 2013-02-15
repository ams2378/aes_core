/**
* @filename  		interface.sv 
*
* @brief     		The file defines the interfaces for test becnh and dut
* @authors   		Dechhin Lama <ddl2126@columbia.edu>
*			
* @modified by		Adil Sadik <ams2378@columbia.edu>
*  	 
*/

interface ifc (input bit clk);
    logic ld_i;
    logic [127:0] key_i;
    logic [127:0] text_i;
    logic mode_i; //encryption or decryption

    logic done_o;
    logic [127:0] text_o;
   
    logic rst;

    clocking cb @(posedge clk);
        default output #1;
       
	output rst;
	
	output ld_i;
	output key_i;
	output text_i;
	output mode_i;

	input done_o;
	input text_o;
    endclocking

    modport dut (
	input clk,
	input rst,
	
	input key_i;
	input text_i;
	input ld_i;
	input mode_i;

	output text_o;
	output done_o; 
	);

    modport bench (clocking cb);
endinterface
