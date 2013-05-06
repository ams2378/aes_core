`timescale 1ns/1ps

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

	aes_checker checker;
	aes_transaction t;
	aes_env env;
//	msb	randkeys;


	int en_ce_stat = 0;
	int unsigned ctext[4];
	int rst_chk;

	integer f, g, start, p, k;
	integer v = 1;
	integer en_num = 1;
	string s;
	string dir = "logs";
	int rand_key_cntrl = 1;
	int w;	
	int bitchange;


//	bit[119:0] temp_key = 120'hfac3501987124a34bc7dff761a309c;
//	bit[119:0] temp_key = 120'hf04193bd83c6bc82ad5b2b65140618; 
//	bit[127:0] temp_key = 127'h20f04193bd83c6bc82ad5b2b65140618; 
	bit[127:0] temp_key = 127'h21f04193bd83c6bc82ad5b2b65140618; 

	bit [7:0]  msbs = 8'h00;
	bit [7:0]  temp_sa00;


	covergroup cg_reset;
		coverpoint t.rst;
	endgroup

	covergroup cg_ld;
		coverpoint t.ld;
	endgroup

	covergroup cg_text;
		coverpoint t.text[0];
	endgroup

	covergroup cg_key;
		coverpoint t.key[0];
	endgroup

	cg_reset 	cov_rst;
	cg_ld 		cov_ld;
	cg_text 	cov_text;
	cg_key 		cov_key;

	int verbose = 0;

	task do_cycle;

		t.randomize();

	//	if (en_num == 600 && msbs <256) begin
	//	msbs = msbs + 1;
	//		en_num = 1;
	//	end

		msbs = env.incr_msb;

		if ( t.ld == 1 && t.rst == 1) begin 
			start =  1;
		end

		if (t.const_key == 1) begin
		//	t.key = {msbs, temp_key}; 
			t.key = temp_key;
		end
		
		//send text/key to dut and software

		if (t.rst == 0) begin
			rst_chk 	= 	1;
		end else
			rst_chk		=	0; 
	
		ds.cb.rst		<= 	t.rst;	
		ds.cb.ld		<= 	t.ld;
		ds.cb.key[31:0] 	<= 	t.key[31:0];
		ds.cb.key[63:32]	<= 	t.key[63:32]; 		
		ds.cb.key[95:64 ]	<= 	t.key[95:64]; 		
		ds.cb.key[127:96]	<= 	t.key[127:96]; 			
		ds.cb.text_in[31:0] 	<= 	t.text[0];
		ds.cb.text_in[63:32]	<= 	t.text[1]; 
		ds.cb.text_in[95:64 ]	<= 	t.text[2]; 		
		ds.cb.text_in[127:96]	<= 	t.text[3]; 		

		send_ld_rst (t.ld, t.rst);
		rebuild_text(t.text[0], 0);
		rebuild_text(t.text[1], 1);
		rebuild_text(t.text[2], 2);
		rebuild_text(t.text[3], 3);
		rearrange_text();

		rebuild_key(t.key[31:0], 0);
		rebuild_key(t.key[63:32], 1);
		rebuild_key(t.key[95:64], 2);
		rebuild_key(t.key[127:96], 3);
		rearrange_key();

		generate_ciphertext();

		rearrange_cipher();
		ctext[0] = get_ciphertext(0);
		ctext[1] = get_ciphertext(1);
		ctext[2] = get_ciphertext(2);
		ctext[3] = get_ciphertext(3);
		t.status = get_status();	
		t.done   = get_done();


		$fdisplay (f,"------------- Simulation Time ----------------- %t", $realtime );

		if ( t.ld == 1 && t.rst == 1) begin 
		$fdisplay (f,"Encryption Number : %0d" , en_num);
		$fdisplay (p,"Encryption Number : %0d" , en_num);
		$fdisplay (p,"TEXT: %h%h%h%h", t.text[3], t.text[2], t.text[1], t.text[0]);
		$fdisplay (p,"KEY: %h%h%h%h", t.key[127:96], t.key[95:64], t.key[63:32], t.key[31:0]);
		end

		$fdisplay (f,"KEY: %h%h%h%h", t.key[127:96], t.key[95:64], t.key[63:32], t.key[31:0]);
		$fdisplay (f,"TEXT: %h%h%h%h", t.text[3], t.text[2], t.text[1], t.text[0]);

		if (start == 1) begin
		$fdisplay (g,"Encryption Number : %0d" , en_num);
		$fdisplay (g,"KEY: %h%h%h%h", t.key[127:96], t.key[95:64], t.key[63:32], t.key[31:0]);
		$fdisplay (g,"TEXT: %h%h%h%h", t.text[3], t.text[2], t.text[1], t.text[0]);
		start = 0;
		end

		$fdisplay (f,"DUT Done : %b", ds.cb.done);
		$fdisplay (f,"GoldenModel Done : %b", t.done);
		$fdisplay (f,"Result from GoldenModel : %h%h%h%h ", ctext[3], ctext[2], ctext[1], ctext[0]);	
		$fdisplay (f,"Result from DUT : %h%h%h%h ", ds.cb.text_out[127:96], ds.cb.text_out[95:64], ds.cb.text_out[63:32], ds.cb.text_out[31:0]);

		if (ds.cb.done == 1) begin
		$fdisplay (g,"Result GoldenModel : %h%h%h%h ", ctext[3], ctext[2], ctext[1], ctext[0]);	
		$fdisplay (g,"Result DUT : %h%h%h%h ", ds.cb.text_out[127:96], ds.cb.text_out[95:64], ds.cb.text_out[63:32], ds.cb.text_out[31:0]);
		end

		
	//	$display (" calling checker from test with status : %d  @ runtime %t ", t.status, $realtime); 

		checker.check_result(ds.cb.text_out[31:0],  ds.cb.text_out[63:32], ds.cb.text_out[95:64],  
				     ds.cb.text_out[127:96], ds.cb.done, ctext, t.done, t.status, rst_chk);

		if ( t.ld == 1 && t.rst == 1) begin 
			en_num = en_num + 1;
		end

	@(ds.cb);

	endtask


	initial begin

		checker = new();
		env = new();
		env.configure("configure.txt");

		t = new( 60, env.warmup_rst );
		cov_rst = new();
		cov_ld = new();
		cov_text = new();
		cov_key = new();
		
		/* warm up */

		w = 1;
		repeat (env.warmup) begin
			do_cycle();
		end
		w = 0;

//		s = $sformatf("/log_%0d.txt", v);		
//		f = $fopen ({dir, s});


		k = $fopen ("keys.txt", "a");
		f = $fopen ("log_1.txt", "a");
		g = $fopen ("log_2.txt", "a");
		p = $fopen ("power.txt", "a");

//		f = $fopena ("log_1.txt");
//		g = $fopena ("log_2.txt");
//		p = $fopena ("power.txt");

		t = new( env.ld_density, env.reset_density );

		if (env.single_key == 1) begin 
			t.const_key = 1; 
		end

		repeat(env.max_transactions) begin
			do_cycle();
			cov_rst.sample();
			cov_ld.sample();
			cov_text.sample();
			cov_key.sample();
		end
	cov_rst.stop();
	cov_ld.stop();
	cov_text.stop();
	cov_key.stop();

	$display("RST	: Instance coverage is %e",cov_rst.get_coverage());
	$display("LD	: Instance coverage is %e",cov_ld.get_coverage());
	$display("TEXT	: Instance coverage is %e",cov_text.get_coverage());
	$display("KEY	: Instance coverage is %e",cov_key.get_coverage());

	end


endmodule
