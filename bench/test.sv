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
		$fdisplay (f, "KEY: %h%h%h%h", t.key[127:96], t.key[95:64], t.key[63:32], t.key[31:0]);
		$fdisplay (f, "TEXT: %h%h%h%h", t.text[3], t.text[2], t.text[1], t.text[0]);
		
		$fdisplay (f, "Inputs to sbox : ");
		$fdisplay (f, "------------------");
		$fdisplay (f, "a_S00 : %b %b %b %b %b %b %b %b", ds.cb.sa00[7], ds.cb.sa00[6], ds.cb.sa00[5], ds.cb.sa00[4],
								 ds.cb.sa00[3],ds.cb.sa00[2],ds.cb.sa00[1],ds.cb.sa00[0]);
		$fdisplay (f, "a_S01 : %b ", ds.cb.sa01);
		$fdisplay (f, "a_S02 : %b ", ds.cb.sa02);
		$fdisplay (f, "a_S03 : %b ", ds.cb.sa03);

		$fdisplay (f, "a_S10 : %b ", ds.cb.sa10);
		$fdisplay (f, "a_S11 : %b ", ds.cb.sa11);
		$fdisplay (f, "a_S12 : %b ", ds.cb.sa12);
		$fdisplay (f, "a_S13 : %b ", ds.cb.sa13);

		$fdisplay (f, "a_S20 : %b ", ds.cb.sa20);
		$fdisplay (f, "a_S21 : %b ", ds.cb.sa21);
		$fdisplay (f, "a_S22 : %b ", ds.cb.sa22);
		$fdisplay (f, "a_S23 : %b ", ds.cb.sa23);

		$fdisplay (f, "a_S30 : %b ", ds.cb.sa30);
		$fdisplay (f, "a_S31 : %b ", ds.cb.sa31);
		$fdisplay (f, "a_S32 : %b ", ds.cb.sa32);
		$fdisplay (f, "a_S33 : %b ", ds.cb.sa33);


		$fdisplay (f, "Outputs from sbox : ");
		$fdisplay (f, "------------------");
		$fdisplay (f, "d_S00_SUB : %b ", ds.cb.sa00_sub);
		$fdisplay (f, "d_S01_SUB : %b ", ds.cb.sa01_sub);
		$fdisplay (f, "d_S02_SUB : %b ", ds.cb.sa02_sub);
		$fdisplay (f, "d_S03_SUB : %b ", ds.cb.sa03_sub);

		$fdisplay (f, "d_S10_SUB : %b ", ds.cb.sa10_sub);
		$fdisplay (f, "d_S11_SUB : %b ", ds.cb.sa11_sub);
		$fdisplay (f, "d_S12_SUB : %b ", ds.cb.sa12_sub);
		$fdisplay (f, "d_S13_SUB : %b ", ds.cb.sa13_sub);

		$fdisplay (f, "d_S20_SUB : %b ", ds.cb.sa20_sub);
		$fdisplay (f, "d_S21_SUB : %b ", ds.cb.sa21_sub);
		$fdisplay (f, "d_S22_SUB : %b ", ds.cb.sa22_sub);
		$fdisplay (f, "d_S23_SUB : %b ", ds.cb.sa23_sub);

		$fdisplay (f, "d_S30_SUB : %b ", ds.cb.sa30_sub);
		$fdisplay (f, "d_S31_SUB : %b ", ds.cb.sa31_sub);
		$fdisplay (f, "d_S32_SUB : %b ", ds.cb.sa32_sub);
		$fdisplay (f, "d_S33_SUB : %b ", ds.cb.sa33_sub);

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


