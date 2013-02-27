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

	int en_ce_stat = 0;
	int unsigned ctext[4];
	int rst_chk;

	integer f;

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


		if (t.const_key == 1) begin
			t.key = 128'h20f04193bd83c6bc82ad5b2b65140618; 
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
		t.done   = get_done();
		t.status = get_status();	

		$fdisplay (f, "\n");

		$fdisplay (f, "------------- Simulation Time ----------------- %t", $realtime );
		$fdisplay (f, "Inputs :");
		$fdisplay (f, "-----------------");
		$fdisplay (f, "rst : %b", t.rst );
		$fdisplay (f, "Key load : %b ", t.ld);
	//	$fdisplay (f, "KEY: %h%h%h%h", t.key[3], t.key[2], t.key[1], t.key[0]);
		$fdisplay (f, "KEY: %h%h%h%h", t.key[127:96], t.key[95:64], t.key[63:32], t.key[31:0]);
		$fdisplay (f, "TEXT: %h%h%h%h", t.text[3], t.text[2], t.text[1], t.text[0]);
		
		$fdisplay (f, "Inputs to sbox : ");
		$fdisplay (f, "------------------");
		$fdisplay (f, "S00 S01 S02 S03 : %b %b %b %b", ds.cb.sa00, ds.cb.sa01, ds.cb.sa02, ds.cb.sa03);
		$fdisplay (f, "S10 S11 S12 S13 : %b %b %b %b", ds.cb.sa10, ds.cb.sa11, ds.cb.sa12, ds.cb.sa13);
		$fdisplay (f, "S20 S21 S22 S23 : %b %b %b %b", ds.cb.sa20, ds.cb.sa21, ds.cb.sa22, ds.cb.sa23);
		$fdisplay (f, "S30 S31 S32 S33 : %b %b %b %b", ds.cb.sa30, ds.cb.sa31, ds.cb.sa32, ds.cb.sa33);

		$fdisplay (f, "Outputs from sbox : ");
		$fdisplay (f, "--------------------");
		$fdisplay (f, "S00_SUB S01_SUB S02_SUB S03_SUB : %b %b %b %b", ds.cb.sa00_sub, ds.cb.sa01_sub, ds.cb.sa02_sub, ds.cb.sa03_sub);
		$fdisplay (f, "S10_SUB S11_SUB S12_SUB S13_SUB : %b %b %b %b", ds.cb.sa10_sub, ds.cb.sa11_sub, ds.cb.sa12_sub, ds.cb.sa13_sub);
		$fdisplay (f, "S20_SUB S21_SUB S22_SUB S23_SUB : %b %b %b %b", ds.cb.sa20_sub, ds.cb.sa21_sub, ds.cb.sa22_sub, ds.cb.sa23_sub);
		$fdisplay (f, "S30_SUB S31_SUB S32_SUB S33_SUB : %b %b %b %b", ds.cb.sa30_sub, ds.cb.sa31_sub, ds.cb.sa32_sub, ds.cb.sa33_sub);

		$fdisplay (f, "Final Outputs:");
		$fdisplay (f, "--------------------");
		$fdisplay (f, "DUT Done : %b", ds.cb.done);
		$fdisplay (f, "GoldenModel Done : %b", t.done);
		$fdisplay (f, "Result from GoldenModel : %h%h%h%h ", ctext[3], ctext[2], ctext[1], ctext[0]);	
		$fdisplay (f, "Result from DUT : %h%h%h%h ", ds.cb.text_out[127:96], ds.cb.text_out[95:64], ds.cb.text_out[63:32], ds.cb.text_out[31:0]);

		checker.check_result(ds.cb.text_out[31:0],  ds.cb.text_out[63:32], ds.cb.text_out[95:64],  
				     ds.cb.text_out[127:96], ds.cb.done, ctext, t.done, t.status, rst_chk);


	@(ds.cb);

	endtask


	initial begin

		f = $fopen ("log.txt");
		checker = new();
		env = new();
		env.configure("configure.txt");

		t = new( 60, env.warmup_rst );
		cov_rst = new();
		cov_ld = new();
		cov_text = new();
		cov_key = new();
		
		/* warm up */
		repeat (env.warmup) begin
			do_cycle();
		end

		t = new( env.ld_density, env.reset_density );

		if (env.single_key == 1) begin 
			t.const_key = 1; 
		end

		$fdisplay (f, " VALIDATON SUITE FOR AES CORE - ELEN 6321");

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


endprogram


