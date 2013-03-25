//aes top
//include both aes_cipher_top and aes_inv_cipher_top
`timescale 1ns/1ps 

module aes_top(ifc.dut d);
    logic ld_e;
    logic ld_d;
    logic kld_d;

    wire[127:0] text_out_e;
    logic done_e;
    wire[127:0] text_out_d;
    logic done_d;
    
    always_comb begin
        //encryption mode
        if (d.mode == 1'b0) begin
            ld_e = d.ld;
            ld_d = 0;
            kld_d = 0;
        end 
        //decryption mode
        else begin
            ld_e = 0;
            ld_d = d.ld;
            kld_d = d.kld;
        end
    end

	aes_cipher_top cipher (
			.clk(d.clk),	
			.rst(d.rst),
			.ld(ld_e),
			.key(d.key),
			.text_in(d.text_in),
			.text_out(text_out_e),
			.done(done_e)
			);

    aes_inv_cipher_top decipher(
        .clk(d.clk),
        .rst(d.rst),
        .kld(kld_d),
        .ld(ld_d),
        .done(done_d),
        .key(d.key),
        .text_in(d.text_in),
        .text_out(text_out_d)
        );

    always_comb begin
        if (done_e) begin
            assign d.text_out = text_out_e;
            assign d.done = done_e;
        end
        else if (done_d) begin
            assign d.text_out = text_out_d;
            assign d.done = done_d;
        end
    end


endmodule
