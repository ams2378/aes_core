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

	integer f, g, start, p;
	integer v = 1;
	integer en_num = 1;
	string s;
	string dir = "logs";
	int rand_key_cntrl = 1;
	int w;	
	int bitchange;


	bit[119:0] temp_key = 120'hf04193bd83c6bc82ad5b2b65140618; 
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

		if (en_num == 11 && msbs <256) begin
		//	msbs = msbs + 1;
			en_num = 1;
		end

		msbs = env.incr_msb;

		if ( t.ld == 1 && t.rst == 1) begin 
			start =  1;
		end

		if (t.const_key == 1) begin
			t.key = {msbs, temp_key}; 
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

	/*	power prediction starts here */

		$fdisplay (f," #### temp_sa00 %h", temp_sa00);
		$fdisplay (f," #### ds.cb.sa00 %h", ds.cb.sa00);

	
		if (ds.cb.dcnt == 4'hb) begin
			temp_sa00 = temp_sa00 ^ ds.cb.sa00;
			bitchange = $countones (temp_sa00);	
			$fdisplay (p,"Encryption Number : %0d" , en_num-1);
			$fdisplay (p,"Round : %d" , ds.cb.dcnt);
			$fdisplay (p,"Bit change: : %d" , bitchange);
		end

		if ( t.ld == 1 && t.rst == 1) begin 
		$fdisplay (f,"Encryption Number : %0d" , en_num);
		end

//		$fdisplay (f,"Inputs :");
//		$fdisplay (f,"-----------------");
//		$fdisplay (f,"rst : %b", t.rst );
//		$fdisplay (f,"Key load : %b ", t.ld);
//		$fdisplay (f,"Inputs to roundkey : ");

		$fdisplay (f,"KEY: %h%h%h%h", t.key[127:96], t.key[95:64], t.key[63:32], t.key[31:0]);
		$fdisplay (f,"TEXT: %h%h%h%h", t.text[3], t.text[2], t.text[1], t.text[0]);

		if (start == 1) begin
		$fdisplay (g,"Encryption Number : %0d" , en_num);
		$fdisplay (g,"KEY: %h%h%h%h", t.key[127:96], t.key[95:64], t.key[63:32], t.key[31:0]);
		$fdisplay (g,"TEXT: %h%h%h%h", t.text[3], t.text[2], t.text[1], t.text[0]);
		start = 0;
		end

		$fdisplay (f,"ROUND : %d ", ds.cb.dcnt);

		$fdisplay (f, "sa00_textin : %h ", ds.cb.text_in_r[127:120]);
		$fdisplay (f, "sa00_w_i  : %h ", ds.cb.w0[31:24]);
		$fdisplay (f, "sa00_sa_i : %h ", ds.cb.sa00_next);
		$fdisplay (f, "sa00_sa_o : %h ", ds.cb.sa00);
		$fdisplay (f, "sa00_ld_r : %b ", ds.cb.ld_r);

		$fdisplay (f, "sa01_textin : %h ", ds.cb.text_in_r[095:088]);
		$fdisplay (f, "sa01_w_i  : %h ", ds.cb.w1[31:24]);
		$fdisplay (f, "sa01_sa_i : %h ", ds.cb.sa01_next);
		$fdisplay (f, "sa01_sa_o : %h ", ds.cb.sa01);
		$fdisplay (f, "sa01_ld_r : %b ", ds.cb.ld_r);

		$fdisplay (f, "sa02_textin : %h ", ds.cb.text_in_r[063:056]);
		$fdisplay (f, "sa02_w_i  : %h ", ds.cb.w2[31:24]);
		$fdisplay (f, "sa02_sa_i : %h ", ds.cb.sa02_next);
		$fdisplay (f, "sa02_sa_o : %h ", ds.cb.sa02);
		$fdisplay (f, "sa02_ld_r : %b ", ds.cb.ld_r);

		$fdisplay (f, "sa03_textin : %h ", ds.cb.text_in_r[031:024]);
		$fdisplay (f, "sa03_w_i  : %h ", ds.cb.w3[31:24]);
		$fdisplay (f, "sa03_sa_i : %h ", ds.cb.sa03_next);
		$fdisplay (f, "sa03_sa_o : %h ", ds.cb.sa03);
		$fdisplay (f, "sa03_ld_r : %b ", ds.cb.ld_r);

		$fdisplay (f, "sa10_textin : %h ", ds.cb.text_in_r[119:112]);
		$fdisplay (f, "sa10_w_i  : %h ", ds.cb.w0[23:16]);
		$fdisplay (f, "sa10_sa_i : %h ", ds.cb.sa10_next);
		$fdisplay (f, "sa10_sa_o : %h ", ds.cb.sa10);
		$fdisplay (f, "sa10_ld_r : %b ", ds.cb.ld_r);

		$fdisplay (f, "sa11_textin : %h ", ds.cb.text_in_r[087:080]);
		$fdisplay (f, "sa11_w_i  : %h ", ds.cb.w1[23:16]);
		$fdisplay (f, "sa11_sa_i : %h ", ds.cb.sa11_next);
		$fdisplay (f, "sa11_sa_o : %h ", ds.cb.sa11);
		$fdisplay (f, "sa11_ld_r : %b ", ds.cb.ld_r);

		$fdisplay (f, "sa12_textin : %h ", ds.cb.text_in_r[055:048]);
		$fdisplay (f, "sa12_w_i  : %h ", ds.cb.w2[23:16]);
		$fdisplay (f, "sa12_sa_i : %h ", ds.cb.sa12_next);
		$fdisplay (f, "sa12_sa_o : %h ", ds.cb.sa12);
		$fdisplay (f, "sa12_ld_r : %b ", ds.cb.ld_r);

		$fdisplay (f, "sa13_textin : %h ", ds.cb.text_in_r[023:016]);
		$fdisplay (f, "sa13_w_i  : %h ", ds.cb.w3[23:16]);
		$fdisplay (f, "sa13_sa_i : %h ", ds.cb.sa13_next);
		$fdisplay (f, "sa13_sa_o : %h ", ds.cb.sa13);
		$fdisplay (f, "sa13_ld_r : %b ", ds.cb.ld_r);

		$fdisplay (f, "sa20_textin : %h ", ds.cb.text_in_r[111:104]);
		$fdisplay (f, "sa20_w_i  : %h ", ds.cb.w0[15:8]);
		$fdisplay (f, "sa20_sa_i : %h ", ds.cb.sa20_next);
		$fdisplay (f, "sa20_sa_o : %h ", ds.cb.sa20);
		$fdisplay (f, "sa20_ld_r : %b ", ds.cb.ld_r);

		$fdisplay (f, "sa21_textin : %h ", ds.cb.text_in_r[079:072]);
		$fdisplay (f, "sa21_w_i  : %h ", ds.cb.w1[15:8]);
		$fdisplay (f, "sa21_sa_i : %h ", ds.cb.sa21_next);
		$fdisplay (f, "sa21_sa_o : %h ", ds.cb.sa21);
		$fdisplay (f, "sa21_ld_r : %b ", ds.cb.ld_r);

		$fdisplay (f, "sa22_textin : %h ", ds.cb.text_in_r[047:040]);
		$fdisplay (f, "sa22_w_i  : %h ", ds.cb.w2[15:8]);
		$fdisplay (f, "sa22_sa_i : %h ", ds.cb.sa22_next);
		$fdisplay (f, "sa22_sa_o : %h ", ds.cb.sa22);
		$fdisplay (f, "sa22_ld_r : %b ", ds.cb.ld_r);

		$fdisplay (f, "sa23_textin : %h ", ds.cb.text_in_r[015:008]);
		$fdisplay (f, "sa23_w_i  : %h ", ds.cb.w3[15:8]);
		$fdisplay (f, "sa23_sa_i : %h ", ds.cb.sa23_next);
		$fdisplay (f, "sa23_sa_o : %h ", ds.cb.sa23);
		$fdisplay (f, "sa23_ld_r : %b ", ds.cb.ld_r);

		$fdisplay (f, "sa30_textin : %h ", ds.cb.text_in_r[103:096]);
		$fdisplay (f, "sa30_w_i  : %h ", ds.cb.w0[7:0]);
		$fdisplay (f, "sa30_sa_i : %h ", ds.cb.sa30_next);
		$fdisplay (f, "sa30_sa_o : %h ", ds.cb.sa30);
		$fdisplay (f, "sa30_ld_r : %b ", ds.cb.ld_r);

		$fdisplay (f, "sa31_textin : %h ", ds.cb.text_in_r[071:064]);
		$fdisplay (f, "sa31_w_i  : %h ", ds.cb.w1[7:0]);
		$fdisplay (f, "sa31_sa_i : %h ", ds.cb.sa31_next);
		$fdisplay (f, "sa31_sa_o : %h ", ds.cb.sa31);
		$fdisplay (f, "sa31_ld_r : %b ", ds.cb.ld_r);

		$fdisplay (f, "sa32_textin : %h ", ds.cb.text_in_r[039:032]);
		$fdisplay (f, "sa32_w_i  : %h ", ds.cb.w2[7:0]);
		$fdisplay (f, "sa32_sa_i : %h ", ds.cb.sa32_next);
		$fdisplay (f, "sa32_sa_o : %h ", ds.cb.sa32);
		$fdisplay (f, "sa32_ld_r : %b ", ds.cb.ld_r);

		$fdisplay (f, "sa33_textin : %h ", ds.cb.text_in_r[007:000]);
		$fdisplay (f, "sa33_w_i  : %h ", ds.cb.w3[7:0]);
		$fdisplay (f, "sa33_sa_i : %h ", ds.cb.sa33_next);
		$fdisplay (f, "sa33_sa_o : %h ", ds.cb.sa33);
		$fdisplay (f, "sa33_ld_r : %b ", ds.cb.ld_r);


/*		$fdisplay (f,"Final Outputs:");
		$fdisplay (f,"--------------------");
*/
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

		temp_sa00 = ds.cb.sa00;	

			

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

/*		s = $sformatf("/log_%0d.txt", v);		
		f = $fopen ({dir, s});
*/

		f = $fopen ("log_1.txt", "a");
		g = $fopen ("log_2.txt", "a");
		p = $fopen ("power.txt", "a");
/*
		f = $fopena ("log_1.txt");
		g = $fopena ("log_2.txt");
		p = $fopena ("power.txt");
*/
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


