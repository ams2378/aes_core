/**
testbench for aes_top 

**/


// GENERATE INPUT PACKET
class AES_transaction;
	int reset_density;
	
	function new(int rst_d);
		reset_density = rst_d;
	endfunction


	//packet variables
	bit rst;
	int text_in[4];
	int key_in [4];
	bit ld_in;
	bit mode_in;

	constraint density_dist {
		rst dist {0:/100-reset_density, 1:/reset_density};
	}
	
	function gen_rand();
		// random function from c code
	
	endfunction;

endclass


//GENERATE RESULTS FROM GOLDEN MODEL
class AES_test;
	bit reset_in;

	int text_in[4];
	int key_in[4];
	bit ld_in;
	bit mode_in;

	int text_out[4];
	bit done_out;
	
	function golden_result;
		//golden model
        	//encrypt_128_key_expand_inline_no_branch(text_out, key_in);
		
		
		//call c code
	endfunction
endclass


//
class AES_checker;
	bit pass;

	function bit check_result (	int dut_text_o [4], bit dut_done,
					int bench_text_o[4], bit bench_done);

		bit text_passed = (dut_text_o == bench_text_o);
		bit done_passed = (dut_done == bench== done);
	
		bit passed = (text_passed & done_passed);
		pass = passed;

		if (passed)	begin
	        	if(verbose) $display("%t : pass \n", $realtime);
		end
		else begin
			if ( !text_passed & verbose ) begin
		        	$display("%t : error in text_o \n", $realtime);
            			$display("dut value: %d", dut_text_o);
            			$display("bench value: %d", bench_text_o);
			end
			if ( !done_passed & verbose) begin
			        $display("%t : error in done bit \n", $realtime);
            			$display("dut value: %d", dut_done);
            			$display("bench value: %d", bench_done);
			end
				$exit();
		end
        	return passed;
	
	endfunction

endclass



class AES_env;
	int cycle = 0;
	int max_transactions = 1000;
	int warmup_time = 10;
	bit verbose = 1;

	int reset_density;

	function configure(string filename);
		int file, value, chars_returned;
		string param;

		file = $fopen(filename, "r");
		while(!$feof(file)) begin
			chars_returned = $fscanf(file, "%s %d", param, value);
			if ("RESET_DENSITY" == param) begin
				reset_density = value;
			end
			else begin
				$display("Never heard of a: %s", param);
				$exit;
			end
		end
	endfunction
endclass


program tb (ifc.bench ds);
	AES_transaction packet;
	AES_checker checker;
	AES_test test;
	AES_env env;
	int cycle;

	task do_cycle;
		env.cycle++;
		cycle = env.cycle;
		packet.gen_rand();

	//passing data to golden model;
	test.reset_i 	<=	packet.rst;
	test.text_in  	<= 	packet.text_in;
	test.key_in	<= 	packet.key_in;
	test.mode_in	<=	packet.mode_in;
	test.ld_in	<= 	packet.ld_in;
	

	//passing data to dut
	ds.cb.rst	<=	packet.rst;
	ds.cb.text_i	<=  	packet.text_in;
	ds.cb.key_i	<= 	packet.key_in;
	ds.cb.ld_i	<= 	packet.ld_in;
	ds.cb.mode_i	<=	packet.mode_in;	

	@(ds.cb);
	test.golden_result();
	
	endtask

	initial begin
		test = new();
		checker = new();
		env = new();
		env.configure("config.txt");
		packet = new(env.reset_density);

		repeat (env.warmup_time) begin
			do_cycle();
		end
		
		packet= new(env.reset_density);
		
		repeat(env.max_transcations) begin
			do_cycle();
			checker.check_result(ds.cb.text_o, ds.cb.done_o,test.text_out, test.done_out);
		end
		if (checker.pass == 1)
			$display("TEST PASSED!");
		
	end
endprogram
