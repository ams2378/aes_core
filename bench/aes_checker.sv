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
				$display ("**********  PASSED ***********" );	
		end else if ( !done_passed ) begin
			        $display("%t : error in done bit \n", $realtime);
            			$display("dut value: %d", dut_done);
            			$display("bench value: %d", bench_done);

				$exit();
		end

		if (text_passed ) begin 
				$display ("**********  PASSED ***********");	
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
				$display ("**********  PASSED ***********");	
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

