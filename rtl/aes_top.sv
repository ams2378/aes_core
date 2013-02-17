//aes top
//include both aes_cipher_top and aes_inv_cipher_top
`timescale 1ns/1ps 

module aes_top(ifc.dut d);
    logic load_e;
    logic load_d;
    logic keyload;


    always_comb begin
        unique if (d.mode == '0 && d.ld == '1) begin
            load_e = '1;
            load_d = '0;
            keyload = '0;
        end else if (d.mode == '0 && d.ld == '1) begin 
            load_e = '0;
            load_d = '1;
            keyload = '1;
        end else begin
            load_e = '0;
            load_d = '0;
            keyload = '0;
        end
    end

    aes_cipher_top cipher (
		.clk(d.clk),	
	    .rst(d.rst),
	    .ld(load_e),
	    .key(d.key),
	    .text_in(d.text_in),
	    .text_out(d.text_out),
	    .done(d.done)
	);
    
    aes_inv_cipher_top decipher (
        .clk(d.clk),	
	    .rst(d.rst),
	    .ld(load_d),
        .kld(keyload),
	    .key(d.key),
	    .text_in(d.text_in),
	    .text_out(d.text_out),
    	.done(d.done)
	);


endmodule







/*
*
    *  unique if (d.mode == '0)
        	aes_cipher_top cipher (
		    	.clk(d.clk),	
			    .rst(d.rst),
			    .ld(d.ld),
			    .key(d.key),
			    .text_in(d.text_in),
			    .text_out(d.text_out),
			    .done(d.done)
			);
        else
            aes_inv_cipher_top decipher (
			    .clk(d.clk),	
			    .rst(d.rst),
			    .ld(d.ld),
                .kld(d.ld),
			    .key(d.key),
			    .text_in(d.text_in),
			    .text_out(d.text_out),
		    	.done(d.done)
			);

    *
    *
    *
module aes_inv_cipher_top(input		clk,
			  input		rst,
			  input		ld_i, 
			  input 	mode_i,
			  input 	[127:0]	key_i,
		 	  input	        [127:0]	text_in,
			  output	done_o,
			  output	[127:0]	text_out
			);

	aes_cipher_top cipher (
			.clk(clk),	
			.rst(rst),
			.ld(ld_i),
			.key(key_i),
			.text_in(text_in),
			.text_out(text_out),
			.done(done_o)
			);

	aes_inv_cipher_top decipher (
			.clk(clk),	
			.rst(rst),
			.ld(0),
			.key(key_i),
			.text_in(text_in),
			.text_out(text_out),
			.done(done_o)
			);

endmodule

	

*/

