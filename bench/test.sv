`timescale 1ns/1ps


class aes_env;
    int max_transactions;
    int warmup;
    int warmup_rst;
    bit verbose;
    int reset_density, ld_density, single_key, single_text;

    function configure(string filename);
        int file, value, seed, chars_returned;
        string param;
        file = $fopen(filename, "r");
        while(!$feof(file)) begin
            chars_returned = $fscanf(file, "%s %d", param, value);
            if ("RANDOM_SEED" == param) begin
                seed = value;
                $srandom(seed);
            end
	    else if("RESET_DENSITY" == param) begin
	    	reset_density = value;
	    end
	    else if("LD_DENSITY" == param) begin
		ld_density = value;
	    end
	    else if("VERBOSE" == param) begin
		verbose = value;
	    end
	    else if("WARMUP" == param) begin
		warmup = value;
	    end
	    else if("MAX_TRAN" == param) begin
		max_transactions = value;
	    end
 	    else if("WARMUP_RST" == param) begin
		warmup_rst = value;
	    end
	    else if("SINGLE_KEY" == param) begin
		single_key = value;
	    end
 	    else if("SINGLE_TEXT" == param) begin
		single_text = value;
	    end
           else begin
                $display("Never heard of a: %s", param);
                $exit();
            end
        end
    endfunction

class aes_transaction;

//	rand bit[127:0] text;
	rand bit[127:0] key;

	rand int 	text[4];
//	rand int	key[4];
	rand bit 	rst;
	rand bit	ld;
	bit		done;
	int		status;

	int		const_key;

	int 		ld_density;
	int		rst_density;

	function new (int ld_den, int rst_den);
		ld_density = ld_den;
		rst_density = rst_den;
	endfunction

	constraint density_dist {
		ld dist {0:/100-ld_density, 1:/ld_density};
		rst dist {0:/100-rst_density, 1:/rst_density};
	}

	constraint ld_status {
		(status != 0) -> (ld == 0);
	}

endclass


class aes_checker;
	bit pass;
	integer f;
	int s_ct = 14;

	function void check_result (int dut_text_0, int dut_text_1, int dut_text_2, int dut_text_3, int dut_done, 
				   int unsigned bench_text_o[], int bench_done, int status, int rst_chk);

		int verbose = 0;
		bit text_passed;
		bit done_passed;


	if (status == s_ct ) begin
 
		text_passed = (dut_text_0 == bench_text_o[0]) && (dut_text_1 == bench_text_o[1]) &&
		    	      (dut_text_2 == bench_text_o[2]) && (dut_text_3 == bench_text_o[3]);
	 	done_passed = (dut_done == bench_done);

		if (done_passed) begin 
				$display ("**********  PASSED done *********** @ simtime %t :" , $realtime );	
		end else if ( !done_passed ) begin
			        $display("%t : error in done bit \n", $realtime);
            			$display("dut value: %d", dut_done);
            			$display("bench value: %d", bench_done);
				$exit();
		end

		if (text_passed ) begin 
				$display ("**********  PASSED text *********** @ simtime %t :" , $realtime );	
		end else if ( !text_passed ) begin
		        	$display("%t : error in text_o \n", $realtime);
            			$display("dut value || dut done: %h%h%h%h %d", dut_text_3, dut_text_2, dut_text_1, dut_text_0, dut_done);
            			$display("bench value || bench_done: %h%h%h%h", bench_text_o[3], bench_text_o[2], bench_text_o[1], bench_text_o[0], bench_done);

				$exit();
		end

	end else if (status < s_ct || status == 0) begin

		done_passed = (dut_done == bench_done);
		text_passed = 1;

		if (done_passed) begin 
				$display ("**********  PASSED done *********** @ simtime %t :" , $realtime );	
		end else if ( !done_passed ) begin
			        $display("%t : error in done bit \n", $realtime);
            			$display("dut value: %d", dut_done);
            			$display("bench value: %d", bench_done);

				$exit();
		end

		if (verbose) begin  $display (" %t <<<<<< BYPASSING DATA CHECKER:  DUT OUTPUT NOT READY YET >>>>>>>> ", $realtime); end

	end else begin
		if (verbose) begin $display (" %t <<<<< BYPASSING CHECKER:  DUT OUTPUT NOT READY YET >>>>>> ", $realtime ); end
	end

	endfunction

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
		t.status = get_status();	
		t.done   = get_done();


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
		
		$fdisplay (f,"Inputs to roundkey : ");

		$fdisplay (f,"ROUND : %d ", ds.cb.dcnt);

		$fdisplay (f, "sa33 input text : %h ", ds.cb.text_in_r[007:000]);
		$fdisplay (f, "sa33 input key  : %h ", ds.cb.w3[7:0]);

		$fdisplay (f, "sa23 input text : %h ", ds.cb.text_in_r[015:008]);
		$fdisplay (f, "sa23 input key  : %h ", ds.cb.w3[15:8]);

		$fdisplay (f, "sa13 input text : %h ", ds.cb.text_in_r[023:016]);
		$fdisplay (f, "sa13 input key  : %h ", ds.cb.w3[23:16]);

		$fdisplay (f, "sa03 input text : %h ", ds.cb.text_in_r[031:024]);
		$fdisplay (f, "sa03 input key  : %h ", ds.cb.w3[31:24]);

		$fdisplay (f, "sa32 input text : %h ", ds.cb.text_in_r[039:032]);
		$fdisplay (f, "sa32 input key  : %h ", ds.cb.w2[7:0]);

		$fdisplay (f, "sa22 input text : %h ", ds.cb.text_in_r[047:040]);
		$fdisplay (f, "sa22 input key  : %h ", ds.cb.w2[15:8]);

		$fdisplay (f, "sa12 input text : %h ", ds.cb.text_in_r[055:048]);
		$fdisplay (f, "sa12 input key  : %h ", ds.cb.w2[23:16]);

		$fdisplay (f, "sa02 input text : %h ", ds.cb.text_in_r[063:056]);
		$fdisplay (f, "sa02 input key  : %h ", ds.cb.w2[31:24]);


		$fdisplay (f, "sa31 input text : %h ", ds.cb.text_in_r[071:064]);
		$fdisplay (f, "sa31 input key  : %h ", ds.cb.w1[7:0]);

		$fdisplay (f, "sa21 input text : %h ", ds.cb.text_in_r[079:072]);
		$fdisplay (f, "sa21 input key  : %h ", ds.cb.w1[15:8]);

		$fdisplay (f, "sa11 input text : %h ", ds.cb.text_in_r[087:080]);
		$fdisplay (f, "sa11 input key  : %h ", ds.cb.w1[23:16]);

		$fdisplay (f, "sa01 input text : %h ", ds.cb.text_in_r[095:088]);
		$fdisplay (f, "sa01 input key  : %h ", ds.cb.w1[31:24]);

		$fdisplay (f, "sa30 input text : %h ", ds.cb.text_in_r[103:096]);
		$fdisplay (f, "sa30 input key  : %h ", ds.cb.w0[7:0]);

		$fdisplay (f, "sa20 input text : %h ", ds.cb.text_in_r[111:104]);
		$fdisplay (f, "sa20 input key  : %h ", ds.cb.w0[15:8]);

		$fdisplay (f, "sa10 input text : %h ", ds.cb.text_in_r[119:112]);
		$fdisplay (f, "sa10 input key  : %h ", ds.cb.w0[23:16]);

		$fdisplay (f, "sa00 input text : %h ", ds.cb.text_in_r[129:120]);
		$fdisplay (f, "sa00 input key  : %h ", ds.cb.w0[31:24]);

		$fdisplay (f,"Outputs from roundkey : ");
		$fdisplay (f,"------------------");

		$fdisplay (f,"sa33 : %h ", ds.cb.sa33);
		$fdisplay (f,"sa23 : %h ", ds.cb.sa23);
		$fdisplay (f,"sa13 : %h ", ds.cb.sa13);
		$fdisplay (f,"sa03 : %h ", ds.cb.sa03);


		$fdisplay (f,"sa32 : %h ", ds.cb.sa32);
		$fdisplay (f,"sa22 : %h ", ds.cb.sa22);
		$fdisplay (f,"sa12 : %h ", ds.cb.sa12);
		$fdisplay (f,"sa02 : %h ", ds.cb.sa02);

		$fdisplay (f,"sa31 : %h ", ds.cb.sa31);
		$fdisplay (f,"sa21 : %h ", ds.cb.sa21);
		$fdisplay (f,"sa11 : %h ", ds.cb.sa11);
		$fdisplay (f,"sa01 : %h ", ds.cb.sa01);

		$fdisplay (f,"sa30 : %h ", ds.cb.sa30);
		$fdisplay (f,"sa20 : %h ", ds.cb.sa20);
		$fdisplay (f,"sa10 : %h ", ds.cb.sa10);
		$fdisplay (f,"sa00 : %h ", ds.cb.sa00);

		$fdisplay (f,"Final Outputs:");
		$fdisplay (f,"--------------------");
		$fdisplay (f,"DUT Done : %b", ds.cb.done);
		$fdisplay (f,"GoldenModel Done : %b", t.done);
		$fdisplay (f,"Result from GoldenModel : %h%h%h%h ", ctext[3], ctext[2], ctext[1], ctext[0]);	
		$fdisplay (f,"Result from DUT : %h%h%h%h ", ds.cb.text_out[127:96], ds.cb.text_out[95:64], ds.cb.text_out[63:32], ds.cb.text_out[31:0]);


		
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


