`timescale 1ns/1ps

class aes_transaction;
	int unsigned text[4];
	int unsigned key[4];
	bit rst;
	bit ld;


endclass



program tb (ifc.bench ds);

	import "DPI-C" function void rebuild_text ( input int  txt, input int i);
	import "DPI-C" function void rebuild_key ( input int  ky , input int i);
	import "DPI-C" function void generate_ciphertext (int i);
	import "DPI-C" function int signed get_ciphertext (input int i);
	import "DPI-C" function void generate_key_text();
	import "DPI-C" function int signed get_text (input int i);
	import "DPI-C" function int signed get_key (input int i);

	
	aes_transaction t;
	
	int unsigned ctext[4];
	
	
	task do_cycle;
		$display("\n");
		$display("\n");
		$display("***********************START*************************");
		$display("\n");

		generate_key_text();
		
		t.text[0] = get_text(0);
		t.text[1] = get_text(1);
		t.text[2] = get_text(2);
		t.text[3] = get_text(3);

		t.key[0] = get_key(0);
		t.key[1] = get_key(1);
		t.key[2] = get_key(2);
		t.key[3] = get_key(3);
			
		t.rst= '1;
		t.ld = '1;
	
		//print key and text received in SV.
		$display("Received key in SV: %h%h%h%h", t.key[3], t.key[2], t.key[1], t.key[0]);
		$display("Received text in SV: %h%h%h%h", t.text[3], t.text[2], t.text[1], t.text[0]);
		

		//send text/key to dut
		ds.cb.ld		<= 	t.ld;
		ds.cb.rst		<= 	t.rst;	
		ds.cb.text_in[31:0] 	<= 	t.text[0];
		ds.cb.text_in[63:32]	<= 	t.text[1]; 
		ds.cb.text_in[95:64 ]	<= 	t.text[2]; 		
		ds.cb.text_in[127:96]	<= 	t.text[3]; 		

		ds.cb.key[31:0] 	<= 	t.key[0];
		ds.cb.key[63:32]	<= 	t.key[1]; 		
		ds.cb.key[95:64 ]	<= 	t.key[2]; 		
		ds.cb.key[127:96]	<= 	t.key[3]; 			


		//send text/key to c model
		rebuild_text(t.text[0], 0);
		rebuild_text(t.text[1], 1);
		rebuild_text(t.text[2], 2);
		rebuild_text(t.text[3], 3);

		rebuild_key(t.key[0], 0);
		rebuild_key(t.key[1], 1);
		rebuild_key(t.key[2], 2);
		rebuild_key(t.key[3], 3);
	
		generate_ciphertext(t.rst);
		
		//get ciphered text from C	
		ctext[0] = get_ciphertext(0);
		ctext[1] = get_ciphertext(1);
		ctext[2] = get_ciphertext(2);
		ctext[3] = get_ciphertext(3);	

		$display("Receieved Encrypted Text is SV: %h%h%h%h", ctext[3], ctext[2], ctext[1], ctext[0]);

		$display("\n");
                $display("\n");
                $display("***********************STOP*************************");
		$display("\n");
		$display("\n");
	endtask

	
	initial begin
		t = new();
		
		repeat(1) begin
			do_cycle();
		
		end
	end
endprogram


 

