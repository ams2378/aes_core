/**
 * @filename		aes_top.sv 
 *
 * @brief     	        top file   	
 *
 * @author		Adil Sadik <sadik.adil@gmail.com> 
 *
 * @dependencies	none	
 */

`timescale 1ns/1ps 

module aes_top(

	input		clk,
	input 		ld,
	input 		rst,
	input [31:0] 	key,
	input [31:0] 	text_in,
	input		kld,
	input		mode,
	
	output 		done,
	output [31:0] 	text_out
	);

wire		ld_t;
wire [127:0]	text_t;
wire [127:0]	text_t2;
wire [127:0]	key_t;
wire		done_t;
wire		kld_d;
wire		ld_e;
wire		ld_d;

    always @(*) begin
        //encryption mode
        if (mode == 1'b0) begin
            ld_e = ld_t;
            ld_d = 0;
            kld_d = 0;
        end 
        //decryption mode
        else begin
            ld_e = 0;
            ld_d = ld_t;
            kld_d = kld;
        end
    end

	aes_input_buffer inbuffer (
			.clk(clk),
			.rst(rst),
			.ld_i(ld),
			.text_in(text_in),
			.key_in(key),
			.done_i(done_t),

			.text_o(text_t),
			.key_o(key_t),
			.ld_o(ld_t)
			);

	aes_output_buffer outbuffer (
			.clk(clk),
			.rst(rst),
			.done_i(done_t),
			.text_in(text_t2),
			.text_o(text_out),
			.done_o(done)
			);

	aes_cipher_top cipher (
			.clk(clk),	
			.rst(rst),
			.ld(ld_e),
			.key(key_t),
			.text_in(text_t),
			.text_out(text_t2),
			.done(done_t)
			);

   	 aes_inv_cipher_top decipher(
        		.clk(clk),
        		.rst(rst),
        		.kld(kld_d),
        		.ld(ld_d),
        		.done(done_t),
        		.key(key_t),
        		.text_in(text_t),
        		.text_out(text_t2)
        );

endmodule
