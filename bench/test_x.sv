`timescale 1ns/1ps 

class aes_transaction;
	rand int  	text[4];
	rand int  	key[4];
	bit  		ld;				//temp edit
	bit		rst;				//temp edit
	int		done;
	int		status;

	constraint ld_status {
		(status !=0) -> (ld == 0);
	}

function void set_encrypt_status (int s);
	
//	$display ("set encrypt stat get called");
	
	if (s == 1) begin
		status = 1;
	end else begin	
		status = 0;
	end
endfunction

function int get_encrypt_status;
//	$display ("STATUS is : %d", status);
	return status;
endfunction

function int get_encrypt_done (int t);
	int ret;
	if (t == 13) begin
	//	status = 0;
		ret = 1;
	end else begin
		status = 1;
	//	ret = 0;
	end
	return ret; 

endfunction

endclass

class aes_checker;
	bit pass;

	function void check_result ( int dut_text_0, int dut_text_1, int dut_text_2,
 				   int dut_text_3, int dut_done, int bench_text_o[], int bench_done);

		int verbose = 1;
		bit text_passed = (dut_text_0 == bench_text_o[0]) && (dut_text_1 == bench_text_o[1]) &&
			    	  (dut_text_2 == bench_text_o[2]) && (dut_text_3 == bench_text_o[3]);

		bit done_passed = (dut_done == bench_done);
	
		bit passed = (text_passed & done_passed);
		pass = passed;
		

		if (text_passed) begin $display ("********** TEXT PASSED ***********");	end;


		if (passed)	begin
	        	 if(verbose) $display("%t : pass \n", $realtime);
            		$display("dut value || dut done: %h%h%h%h %d", dut_text_3, dut_text_2, dut_text_1, dut_text_0, dut_done);
            		$display("bench value || bench_done: %h%h%h%h", bench_text_o[3], bench_text_o[2], bench_text_o[1], bench_text_o[0], bench_done);
		end
		else begin
			if ( !text_passed & verbose ) begin
		        	$display("%t : error in text_o \n", $realtime);
            		$display("dut value || dut done: %h%h%h%h %d", dut_text_3, dut_text_2, dut_text_1, dut_text_0, dut_done);
            		$display("bench value || bench_done: %h%h%h%h", bench_text_o[3], bench_text_o[2], bench_text_o[1], bench_text_o[0], bench_done);
			end
			if ( !done_passed & verbose) begin
			        $display("%t : error in done bit \n", $realtime);
            			$display("dut value: %d", dut_done);
            			$display("bench value: %d", bench_done);
			end
			//	$exit();
		end

	endfunction

endclass
/*
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
*/
program tb (ifc.bench ds);

	import "DPI-C" function void rebuild_text ( input int  txt, input int i);
	import "DPI-C" function void rebuild_key ( input int  ky , input int i);
	import "DPI-C" function void generate_ciphertext (int i);
	import "DPI-C" function int signed get_ciphertext (input int i);
	import "DPI-C" function int  get_done (input int i);

	aes_transaction t;
	aes_checker checker;
	int signed  ctext[4];
	bit id_t = '1;
	int cycle;
	int check;
	int temp = 0;

	int t2 = 0;

	task do_cycle;
//		env.cycle++;
//		cycle = env.cycle;

	t.randomize();

	if (t2 == 3) begin				//get rid of	
		t.ld = '1;
	end else begin
		t.ld = '0;
	end							

	t.rst = '1;					// upto that

	//	$display ("SV: at temp , t2 and t.id at time: %d %d %b", temp,t2, t.ld, $time);
	
	if ( (t.ld == 1) && (temp == 0) )	begin 
		t.set_encrypt_status (t.ld);		
		ds.cb.ld	<= 	'1;	

		$display ("$$$$$   DUT INPUT TEXT : %h%h%h%h", t.text[3], t.text[2], t.text[1], t.text[0]);
		$display ("$$$$$   DUT INPUT KEY: %h%h%h%h", t.key[3], t.key[2], t.key[1], t.key[0]);
		temp = 1;
	end else begin
		ds.cb.ld	<= 	'0;	
	end

		ds.cb.rst		<= 	t.rst;	
		ds.cb.text_in[31:0] 	<= 	t.text[3];
		ds.cb.text_in[63:32]	<= 	t.text[2]; 
		ds.cb.text_in[95:64 ]	<= 	t.text[1]; 		
		ds.cb.text_in[127:96]	<= 	t.text[0]; 		

		ds.cb.key[31:0] 	<= 	t.key[3];
		ds.cb.key[63:32]	<= 	t.key[2]; 		
		ds.cb.key[95:64 ]	<= 	t.key[1]; 		
		ds.cb.key[127:96]	<= 	t.key[0]; 	

	if (temp == 1) begin

		$display ("$$$$$ BENCH INPUT TEXT : %h%h%h%h", t.text[3], t.text[2], t.text[1], t.text[0]);

		rebuild_text(t.text[0], 0);
		rebuild_text(t.text[1], 1);
		rebuild_text(t.text[2], 2);
		rebuild_text(t.text[3], 3);

		rebuild_key(t.key[0], 0);
		rebuild_key(t.key[1], 1);
		rebuild_key(t.key[2], 2);
		rebuild_key(t.key[3], 3);

		generate_ciphertext ( t.rst );

		ctext[0] = get_ciphertext(0);
		ctext[1] = get_ciphertext(1);
		ctext[2] = get_ciphertext(2);
		ctext[3] = get_ciphertext(3);
	end

		$display ("SV: at TEMP round : %d", temp);
		$display("SV: cipher text :%h%h%h%h", ctext[3], ctext[2], ctext[1], ctext[0] );
 //          	$display("SV: dut value: %d%d%d%d", ds.cb.text_out[31:0], ds.cb.text_out[63:32], 
//							ds.cb.text_out[95:64], ds.cb.text_out[127:96]);

	if (t.rst == 0 || temp == 13 || t2 == 3) begin
		temp = 0;	
	end 	
//		t.done = t.get_encrypt_done(temp);

	if (temp == 13) begin
		t.done = 1;
		t.status = 0;
	end

	if (t.get_encrypt_status()) begin

//	$display ("get encrypt stat get called");
		temp = temp + 1;
	end

	t2 = t2 + 1;

	@(ds.cb);
	endtask

	initial begin
	//	test = new();
		checker = new();
	//	env = new();
	//	env.configure("config.txt");
	//	packet = new(env.reset_density);

		t = new();
	//	repeat (env.warmup_time) begin
	//		do_cycle();
	//	end
		
	//	packet= new(env.reset_density);
		
	//	repeat(env.max_transcations) begin
		repeat(20) begin
			do_cycle();
			    checker.check_result(ds.cb.text_out[31:0],  ds.cb.text_out[63:32] ,
					ds.cb.text_out[95:64],  ds.cb.text_out[127:96], ds.cb.done, ctext, t.done);
		end
	end
endprogram
