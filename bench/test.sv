`timescale 1ns/1ps

class aes_transaction;
	rand int 	unsigned text[4];
	rand int 	unsigned key[4];
	bit 		rst;
	rand bit	ld;
	int		done;
	int		status;

	constraint ld_status {
		(status == 1) -> (ld == 0);
	}

endclass



program tb (ifc.bench ds);

	import "DPI-C" function void rebuild_text ( input int  txt, input int i);
	import "DPI-C" function void rebuild_key ( input int  ky , input int i);
	import "DPI-C" function void generate_ciphertext ();
	import "DPI-C" function int signed get_ciphertext (input int i);
	import "DPI-C" function int signed get_text (input int i);
	import "DPI-C" function int signed get_key (input int i);

	import "DPI-C" function void read_text();
	import "DPI-C" function void rearrange_text();
	import "DPI-C" function void rearrange_key();
	import "DPI-C" function void rearrange_cipher();
	import "DPI-C" function void send_ld_rst( int i, int j );
	import "DPI-C" function int get_done();
	import "DPI-C" function int get_status();

	aes_transaction t;
	int en_ce_stat = 0;
	int unsigned ctext[4];

	int temp = 0;			// temporary
	
	task do_cycle;

		$display("\n");
		$display("\n");
		$display("***********************START*************************");
		$display("\n");

		t.randomize();

		t.rst= '1;		// temporary
		
		$display ("TIME IS :: ", $realtime );	
		$display ("ld and rst is : %b%b ", t.ld, t.rst );	
		$display ("status is : %d ", t.status );	
		$display("Generated key in SV: %h%h%h%h", t.key[3], t.key[2], t.key[1], t.key[0]);
		$display("Generated text in SV: %h%h%h%h", t.text[3], t.text[2], t.text[1], t.text[0]);
		

		//send text/key to dut and software
/*
	if (t.ld == 1) begin
		t.status 		= 	1;
	end 
*/

		ds.cb.rst		<= 	t.rst;	
		ds.cb.ld		<= 	t.ld;
		ds.cb.text_in[31:0] 	<= 	t.text[0];
		ds.cb.text_in[63:32]	<= 	t.text[1]; 
		ds.cb.text_in[95:64 ]	<= 	t.text[2]; 		
		ds.cb.text_in[127:96]	<= 	t.text[3]; 		

		ds.cb.key[31:0] 	<= 	t.key[0];
		ds.cb.key[63:32]	<= 	t.key[1]; 		
		ds.cb.key[95:64 ]	<= 	t.key[2]; 		
		ds.cb.key[127:96]	<= 	t.key[3]; 			


		send_ld_rst (t.ld, t.rst);
		rebuild_text(t.text[0], 0);
		rebuild_text(t.text[1], 1);
		rebuild_text(t.text[2], 2);
		rebuild_text(t.text[3], 3);
		rearrange_text();
	
		rebuild_key(t.key[0], 0);
		rebuild_key(t.key[1], 1);
		rebuild_key(t.key[2], 2);
		rebuild_key(t.key[3], 3);
		rearrange_key();
		
		generate_ciphertext();
		
		rearrange_cipher();
		ctext[0] = get_ciphertext(0);
		ctext[1] = get_ciphertext(1);
		ctext[2] = get_ciphertext(2);
		ctext[3] = get_ciphertext(3);
		t.done   = get_done();
		t.status = get_status();	

		$display("Receieved Encrypted Text is SV: %h%h%h%h", ctext[3], ctext[2], ctext[1], ctext[0]);

                $display("\n");
                $display("***********************STOP*************************");
		$display("\n");
	endtask

	
	initial begin
		t = new();
		
		repeat(20) begin
			do_cycle();
		
		end
	end
endprogram


 

