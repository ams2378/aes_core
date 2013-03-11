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

	integer f, g, start;
	integer v = 1;
	integer en_num = 1;
	string s;
	string dir = "logs";

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


		if ( t.ld == 1 && t.rst == 1) begin 
			start =  1;
		end

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


	//	if (ds.cb.done == 1) begin v = v + 1; end


		$fdisplay (f,"------------- Simulation Time ----------------- %t", $realtime );



		if ( t.ld == 1 && t.rst == 1) begin 
		$fdisplay (f,"Encryption Number : %0d" , en_num);
		end

		$fdisplay (f,"Inputs :");
		$fdisplay (f,"-----------------");
		$fdisplay (f,"KEY: %h%h%h%h", t.key[127:96], t.key[95:64], t.key[63:32], t.key[31:0]);
		$fdisplay (f,"TEXT: %h%h%h%h", t.text[3], t.text[2], t.text[1], t.text[0]);
		$fdisplay (f,"rst : %b", t.rst );
		$fdisplay (f,"Key load : %b ", t.ld);

		if (start == 1) begin
		$fdisplay (g,"Encryption Number : %0d" , en_num);
		$fdisplay (g,"KEY: %h%h%h%h", t.key[127:96], t.key[95:64], t.key[63:32], t.key[31:0]);
		$fdisplay (g,"TEXT: %h%h%h%h", t.text[3], t.text[2], t.text[1], t.text[0]);
		start = 0;
		end
		
		$fdisplay (f,"Inputs to sbox : ");

		$fdisplay (f,"ROUND : %d ", ds.cb.dcnt);

		$fdisplay (f,"a_S00 : %b %b %b %b %b %b %b %b", ds.cb.sa00[7], ds.cb.sa00[6], ds.cb.sa00[5], ds.cb.sa00[4],
								 ds.cb.sa00[3], ds.cb.sa00[2], ds.cb.sa00[1], ds.cb.sa00[0]);
		$fdisplay (f,"a_S01 : %b %b %b %b %b %b %b %b", ds.cb.sa01[7], ds.cb.sa01[6], ds.cb.sa01[5], ds.cb.sa01[4],
								 ds.cb.sa01[3], ds.cb.sa01[2], ds.cb.sa01[1], ds.cb.sa01[0]);
		$fdisplay (f,"a_S02 : %b %b %b %b %b %b %b %b", ds.cb.sa02[7], ds.cb.sa02[6], ds.cb.sa02[5], ds.cb.sa02[4],
								 ds.cb.sa02[3], ds.cb.sa02[2], ds.cb.sa02[1], ds.cb.sa02[0]);
		$fdisplay (f,"a_S03 : %b %b %b %b %b %b %b %b", ds.cb.sa03[7], ds.cb.sa03[6], ds.cb.sa03[5], ds.cb.sa03[4],
								 ds.cb.sa03[3], ds.cb.sa03[2], ds.cb.sa03[1], ds.cb.sa03[0]);
		$fdisplay (f,"a_S10 : %b %b %b %b %b %b %b %b", ds.cb.sa10[7], ds.cb.sa10[6], ds.cb.sa10[5], ds.cb.sa10[4],
								 ds.cb.sa10[3], ds.cb.sa10[2], ds.cb.sa10[1], ds.cb.sa10[0]);
		$fdisplay (f,"a_S11 : %b %b %b %b %b %b %b %b", ds.cb.sa11[7], ds.cb.sa11[6], ds.cb.sa11[5], ds.cb.sa11[4],
								 ds.cb.sa11[3], ds.cb.sa11[2], ds.cb.sa11[1], ds.cb.sa11[0]);
		$fdisplay (f,"a_S12 : %b %b %b %b %b %b %b %b", ds.cb.sa12[7], ds.cb.sa12[6], ds.cb.sa12[5], ds.cb.sa12[4],
								 ds.cb.sa12[3], ds.cb.sa12[2], ds.cb.sa12[1], ds.cb.sa12[0]);
		$fdisplay (f,"a_S13 : %b %b %b %b %b %b %b %b", ds.cb.sa13[7], ds.cb.sa13[6], ds.cb.sa13[5], ds.cb.sa13[4],
								 ds.cb.sa13[3], ds.cb.sa13[2], ds.cb.sa13[1], ds.cb.sa13[0]);
		$fdisplay (f,"a_S20 : %b %b %b %b %b %b %b %b", ds.cb.sa20[7], ds.cb.sa20[6], ds.cb.sa20[5], ds.cb.sa20[4],
								 ds.cb.sa20[3], ds.cb.sa20[2], ds.cb.sa20[1], ds.cb.sa20[0]);
		$fdisplay (f,"a_S21 : %b %b %b %b %b %b %b %b", ds.cb.sa21[7], ds.cb.sa21[6], ds.cb.sa21[5], ds.cb.sa21[4],
								 ds.cb.sa21[3], ds.cb.sa21[2], ds.cb.sa21[1], ds.cb.sa21[0]);
		$fdisplay (f,"a_S22 : %b %b %b %b %b %b %b %b", ds.cb.sa22[7], ds.cb.sa22[6], ds.cb.sa22[5], ds.cb.sa22[4],
								 ds.cb.sa22[3], ds.cb.sa22[2], ds.cb.sa22[1], ds.cb.sa22[0]);
		$fdisplay (f,"a_S23 : %b %b %b %b %b %b %b %b", ds.cb.sa23[7], ds.cb.sa23[6], ds.cb.sa23[5], ds.cb.sa23[4],
								 ds.cb.sa23[3], ds.cb.sa23[2], ds.cb.sa23[1], ds.cb.sa23[0]);
		$fdisplay (f,"a_S30 : %b %b %b %b %b %b %b %b", ds.cb.sa30[7], ds.cb.sa30[6], ds.cb.sa30[5], ds.cb.sa30[4],
								 ds.cb.sa30[3], ds.cb.sa30[2], ds.cb.sa30[1], ds.cb.sa30[0]);
		$fdisplay (f,"a_S31 : %b %b %b %b %b %b %b %b", ds.cb.sa31[7], ds.cb.sa31[6], ds.cb.sa31[5], ds.cb.sa31[4],
								 ds.cb.sa31[3], ds.cb.sa31[2], ds.cb.sa31[1], ds.cb.sa31[0]);
		$fdisplay (f,"a_S32 : %b %b %b %b %b %b %b %b", ds.cb.sa32[7], ds.cb.sa32[6], ds.cb.sa32[5], ds.cb.sa32[4],
								 ds.cb.sa32[3], ds.cb.sa32[2], ds.cb.sa32[1], ds.cb.sa32[0]);
		$fdisplay (f,"a_S33 : %b %b %b %b %b %b %b %b", ds.cb.sa33[7], ds.cb.sa33[6], ds.cb.sa33[5], ds.cb.sa33[4],
								 ds.cb.sa33[3], ds.cb.sa33[2], ds.cb.sa33[1], ds.cb.sa33[0]);


		$fdisplay (f,"Outputs from sbox : ");
		$fdisplay (f,"------------------");
		$fdisplay (f,"d_S00_sub : %b %b %b %b %b %b %b %b", ds.cb.sa00_sub[7], ds.cb.sa00_sub[6], ds.cb.sa00_sub[5], ds.cb.sa00_sub[4],
								 ds.cb.sa00_sub[3], ds.cb.sa00_sub[2], ds.cb.sa00_sub[1], ds.cb.sa00_sub[0]);
		$fdisplay (f,"d_S01_sub : %b %b %b %b %b %b %b %b", ds.cb.sa01_sub[7], ds.cb.sa01_sub[6], ds.cb.sa01_sub[5], ds.cb.sa01_sub[4],
								 ds.cb.sa01_sub[3], ds.cb.sa01_sub[2], ds.cb.sa01_sub[1], ds.cb.sa01_sub[0]);
		$fdisplay (f,"d_S02_sub : %b %b %b %b %b %b %b %b", ds.cb.sa02_sub[7], ds.cb.sa02_sub[6], ds.cb.sa02_sub[5], ds.cb.sa02_sub[4],
								 ds.cb.sa02_sub[3], ds.cb.sa02_sub[2], ds.cb.sa02_sub[1], ds.cb.sa02_sub[0]);
		$fdisplay (f,"d_S03_sub : %b %b %b %b %b %b %b %b", ds.cb.sa03_sub[7], ds.cb.sa03_sub[6], ds.cb.sa03_sub[5], ds.cb.sa03_sub[4],
								 ds.cb.sa03_sub[3], ds.cb.sa03_sub[2], ds.cb.sa03_sub[1], ds.cb.sa03_sub[0]);
		$fdisplay (f,"d_S10_sub : %b %b %b %b %b %b %b %b", ds.cb.sa10_sub[7], ds.cb.sa10_sub[6], ds.cb.sa10_sub[5], ds.cb.sa10_sub[4],
								 ds.cb.sa10_sub[3], ds.cb.sa10_sub[2], ds.cb.sa10_sub[1], ds.cb.sa10_sub[0]);
		$fdisplay (f,"d_S11_sub : %b %b %b %b %b %b %b %b", ds.cb.sa11_sub[7], ds.cb.sa11_sub[6], ds.cb.sa11_sub[5], ds.cb.sa11_sub[4],
								 ds.cb.sa11_sub[3], ds.cb.sa11_sub[2], ds.cb.sa11_sub[1], ds.cb.sa11_sub[0]);
		$fdisplay (f,"d_S12_sub : %b %b %b %b %b %b %b %b", ds.cb.sa12_sub[7], ds.cb.sa12_sub[6], ds.cb.sa12_sub[5], ds.cb.sa12_sub[4],
								 ds.cb.sa12_sub[3], ds.cb.sa12_sub[2], ds.cb.sa12_sub[1], ds.cb.sa12_sub[0]);
		$fdisplay (f,"d_S13_sub : %b %b %b %b %b %b %b %b", ds.cb.sa13_sub[7], ds.cb.sa13_sub[6], ds.cb.sa13_sub[5], ds.cb.sa13_sub[4],
								 ds.cb.sa13_sub[3], ds.cb.sa13_sub[2], ds.cb.sa13_sub[1], ds.cb.sa13_sub[0]);
		$fdisplay (f,"d_S20_sub : %b %b %b %b %b %b %b %b", ds.cb.sa20_sub[7], ds.cb.sa20_sub[6], ds.cb.sa20_sub[5], ds.cb.sa20_sub[4],
								 ds.cb.sa20_sub[3], ds.cb.sa20_sub[2], ds.cb.sa20_sub[1], ds.cb.sa20_sub[0]);
		$fdisplay (f,"d_S21_sub : %b %b %b %b %b %b %b %b", ds.cb.sa21_sub[7], ds.cb.sa21_sub[6], ds.cb.sa21_sub[5], ds.cb.sa21_sub[4],
								 ds.cb.sa21_sub[3], ds.cb.sa21_sub[2], ds.cb.sa21_sub[1], ds.cb.sa21_sub[0]);
		$fdisplay (f,"d_S22_sub : %b %b %b %b %b %b %b %b", ds.cb.sa22_sub[7], ds.cb.sa22_sub[6], ds.cb.sa22_sub[5], ds.cb.sa22_sub[4],
								 ds.cb.sa22_sub[3], ds.cb.sa22_sub[2], ds.cb.sa22_sub[1], ds.cb.sa22_sub[0]);
		$fdisplay (f,"d_S23_sub : %b %b %b %b %b %b %b %b", ds.cb.sa23_sub[7], ds.cb.sa23_sub[6], ds.cb.sa23_sub[5], ds.cb.sa23_sub[4],
								 ds.cb.sa23_sub[3], ds.cb.sa23_sub[2], ds.cb.sa23_sub[1], ds.cb.sa23_sub[0]);
		$fdisplay (f,"d_S30_sub : %b %b %b %b %b %b %b %b", ds.cb.sa30_sub[7], ds.cb.sa30_sub[6], ds.cb.sa30_sub[5], ds.cb.sa30_sub[4],
								 ds.cb.sa30_sub[3], ds.cb.sa30_sub[2], ds.cb.sa30_sub[1], ds.cb.sa30_sub[0]);
		$fdisplay (f,"d_S31_sub : %b %b %b %b %b %b %b %b", ds.cb.sa31_sub[7], ds.cb.sa31_sub[6], ds.cb.sa31_sub[5], ds.cb.sa31_sub[4],
								 ds.cb.sa31_sub[3], ds.cb.sa31_sub[2], ds.cb.sa31_sub[1], ds.cb.sa31_sub[0]);
		$fdisplay (f,"d_S32_sub : %b %b %b %b %b %b %b %b", ds.cb.sa32_sub[7], ds.cb.sa32_sub[6], ds.cb.sa32_sub[5], ds.cb.sa32_sub[4],
								 ds.cb.sa32_sub[3], ds.cb.sa32_sub[2], ds.cb.sa32_sub[1], ds.cb.sa32_sub[0]);
		$fdisplay (f,"d_S33_sub : %b %b %b %b %b %b %b %b", ds.cb.sa33_sub[7], ds.cb.sa33_sub[6], ds.cb.sa33_sub[5], ds.cb.sa33_sub[4],
								 ds.cb.sa33_sub[3], ds.cb.sa33_sub[2], ds.cb.sa33_sub[1], ds.cb.sa33_sub[0]);

		$fdisplay (f,"Final Outputs:");
		$fdisplay (f,"--------------------");
		$fdisplay (f,"DUT Done : %b", ds.cb.done);
		$fdisplay (f,"GoldenModel Done : %b", t.done);
		$fdisplay (f,"Result from GoldenModel : %h%h%h%h ", ctext[3], ctext[2], ctext[1], ctext[0]);	
		$fdisplay (f,"Result from DUT : %h%h%h%h ", ds.cb.text_out[127:96], ds.cb.text_out[95:64], ds.cb.text_out[63:32], ds.cb.text_out[31:0]);


		
		$display (" calling checker from test with status : %d  @ runtime %t ", status, $realtime);
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
		repeat (env.warmup) begin
			do_cycle();
		end

/*		s = $sformatf("/log_%0d.txt", v);		
		f = $fopen ({dir, s});
*/

		f = $fopen ("log_1.txt");
		g = $fopen ("log_2.txt");

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


endprogram


