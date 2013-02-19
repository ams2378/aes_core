`timescale 1ns/1ps

class aes_transaction;
	rand int 	unsigned text[4];
	rand int 	unsigned key[4];
	rand bit 	rst;
	rand bit	ld;
	bit		done;
	int		status;

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

/*
class aes_env;
    int cycle = 0;
    int max_transactions = 1000;
    int warmup_time = 10;
    bit verbose = 1;

    int reset_density, search_density, read_density, write_density;

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
            else if("TRANSACTIONS" == param) begin
                max_transactions = value;
            end
	    else if("RESET_DENSITY" == param) begin
	    	reset_density = value;
	    end
	    else if("SEARCH_DENSITY" == param) begin
		search_density = value;
	    end
	    else if("READ_DENSITY" == param) begin
		read_density = value;
	    end
	    else if("WRITE_DENSITY" == param) begin
		write_density = value;
	    end
	    else if("VERBOSE" == param) begin
		verbose = value;
	    end
            else begin
                $display("Never heard of a: %s", param);
                $exit();
            end
        end
    endfunction
endclass
*/

class aes_checker;
	bit pass;
	integer f;

	function void check_result (int dut_text_0, int dut_text_1, int dut_text_2, int dut_text_3, int dut_done, 
				   int unsigned bench_text_o[], int bench_done, int status, int rst_chk);

		int verbose = 1;
		bit text_passed;
		bit done_passed;


	if (status == 13 ) begin
 
		text_passed = (dut_text_0 == bench_text_o[0]) && (dut_text_1 == bench_text_o[1]) &&
		    	      (dut_text_2 == bench_text_o[2]) && (dut_text_3 == bench_text_o[3]);
	 	done_passed = (dut_done == bench_done);

		if (done_passed) begin 
				$display ("********** DONE PASSED ***********" );	
		end else if ( !done_passed & verbose) begin
			        $display("%t : error in done bit \n", $realtime);
            			$display("dut value: %d", dut_done);
            			$display("bench value: %d", bench_done);

				$exit();
		end

		if (text_passed ) begin 
				$display ("********** TEXT PASSED ***********");	
		end else if ( !text_passed & verbose ) begin
		        	$display("%t : error in text_o \n", $realtime);
            			$display("dut value || dut done: %h%h%h%h %d", dut_text_3, dut_text_2, dut_text_1, dut_text_0, dut_done);
            			$display("bench value || bench_done: %h%h%h%h", bench_text_o[3], bench_text_o[2], bench_text_o[1], bench_text_o[0], bench_done);

				$exit();
		end

	end else if (status < 13 || status == 0) begin

		done_passed = (dut_done == bench_done);
		text_passed = 1;

		if (done_passed) begin 
				$display ("********** DONE PASSED ***********");	
		end else if ( !done_passed & verbose) begin
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
	int en_ce_stat = 0;
	int unsigned ctext[4];
	int rst_chk;

	integer f;


	int verbose = 0;

	task do_cycle;

		t.randomize();
		
//		t.rst= '1;		// temporary

	if (verbose) begin

		$display("\n");
		$display("\n");
		$display(" %t ***********************START*************************  ", $realtime);
		$display("\n");
		$display ("SV: TIME IS :: ", $realtime );	
		$display ("SV: ld and rst is : %b%b ", t.ld, t.rst );	
		$display ("SV: status is : %d ", t.status );	
		$display("SV: Generated key: %h%h%h%h", t.key[3], t.key[2], t.key[1], t.key[0]);
		$display("SV: Generated text: %h%h%h%h", t.text[3], t.text[2], t.text[1], t.text[0]);

	end
		//send text/key to dut and software

		if (t.rst == 0) begin
			rst_chk 	= 	1;
		end else
			rst_chk		=	0; 


	
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

		$fdisplay (f, "------------- Simulation Time ----------------- %t", $realtime );
		$fdisplay (f, "Inputs :");
		$fdisplay (f, "rst : %b", t.rst );
		$fdisplay (f, "Key load : %b ", t.ld);
		$fdisplay (f, "KEY: %h%h%h%h", t.key[3], t.key[2], t.key[1], t.key[0]);
		$fdisplay (f, "TEXT: %h%h%h%h", t.text[3], t.text[2], t.text[1], t.text[0]);

		
		$fdisplay (f, "Inputs to sbox : ");
		$fdisplay (f, "S00 S01 S02 S03 : %h %h %h %h", ds.cb.sa00, ds.cb.sa01, ds.cb.sa02, ds.cb.sa03);
		$fdisplay (f, "S10 S11 S12 S13 : %h %h %h %h", ds.cb.sa10, ds.cb.sa11, ds.cb.sa12, ds.cb.sa13);
		$fdisplay (f, "S20 S21 S22 S23 : %h %h %h %h", ds.cb.sa20, ds.cb.sa21, ds.cb.sa22, ds.cb.sa23);
		$fdisplay (f, "S30 S31 S32 S33 : %h %h %h %h", ds.cb.sa30, ds.cb.sa31, ds.cb.sa32, ds.cb.sa33);

		$fdisplay (f, "Outputs from sbox : ");
		$fdisplay (f, "S00_SUB S01_SUB S02_SUB S03_SUB : %h %h %h %h", ds.cb.sa00_sub, ds.cb.sa01_sub, ds.cb.sa02_sub, ds.cb.sa03_sub);
		$fdisplay (f, "S10_SUB S11_SUB S12_SUB S13_SUB : %h %h %h %h", ds.cb.sa10_sub, ds.cb.sa11_sub, ds.cb.sa12_sub, ds.cb.sa13_sub);
		$fdisplay (f, "S20_SUB S21_SUB S22_SUB S23_SUB : %h %h %h %h", ds.cb.sa20_sub, ds.cb.sa21_sub, ds.cb.sa22_sub, ds.cb.sa23_sub);
		$fdisplay (f, "S30_SUB S31_SUB S32_SUB S33_SUB : %h %h %h %h", ds.cb.sa30_sub, ds.cb.sa31_sub, ds.cb.sa32_sub, ds.cb.sa33_sub);

		$fdisplay (f, "Final Outputs:");
		$fdisplay (f, "Status is: %d ", t.status);
		$fdisplay (f, " DUT Done : %b", ds.cb.done);
		$fdisplay (f, "Result from DUT : %h%h%h%h ", ds.cb.text_out[127:96], ds.cb.text_out[95:64], ds.cb.text_out[63:32], ds.cb.text_out[31:0]);

	if (verbose) begin

		$display("SV: Receieved Encrypted Text: %h%h%h%h", ctext[3], ctext[2], ctext[1], ctext[0]);
		$display("SV: Done is : %d", t.done);

         	$display("DUT: Cipher out: %h%h%h%h", ds.cb.text_out[127:96], ds.cb.text_out[95:64], ds.cb.text_out[63:32], ds.cb.text_out[31:0]);
		$display ("DUT: Done out : %d", ds.cb.done);

                $display("\n");
		$display("\n");

	end


			checker.check_result(ds.cb.text_out[31:0],  ds.cb.text_out[63:32], ds.cb.text_out[95:64],  
				    ds.cb.text_out[127:96], ds.cb.done, ctext, t.done, t.status, rst_chk);


	@(ds.cb);

//		$fdisplay (f, " GoldenModel Done : %b", t.done);
//		$fdisplay (f, "Result from GoldenModel : %h%h%h%h ", ctext[3], ctext[2], ctext[1], ctext[0]);

	endtask


	initial begin
		t = new( 20, 100 );
		checker = new();


		repeat (3) begin
			do_cycle();
		end


		f = $fopen ("log.txt");
		t = new( 50, 100 );

		repeat(50) begin
			do_cycle();
//			checker.check_result(ds.cb.text_out[31:0],  ds.cb.text_out[63:32], ds.cb.text_out[95:64],  
//				    ds.cb.text_out[127:96], ds.cb.done, ctext, t.done, t.status, rst_chk);

//			checker.print_log ( t.key[3], t.key[2], t.key[1], t.key[0], t.text[3], t.text[2], t.text[1], t.text[0] );

		end
	end
endprogram


