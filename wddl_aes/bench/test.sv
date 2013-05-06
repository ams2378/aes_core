`timescale 1ns/1ps


program tb (ifc.bench ds);

	task do_cycle;
/*	
		bit[127:0] key = 128'h20f04193bd83c6bc82ad5b2b65140618; 
		
        ds.cb.ld_r <= '1; 
        ds.cb.text_in_r[127:0] <= '1; 
        ds.cb.text_in_r_n[127:0] <= '0;

        ds.cb.w0[31:0] <= 32'h0F0F0F0F;
        ds.cb.w1[31:0] <= '1;
        ds.cb.w2[31:0] <= '1;
        ds.cb.w3[31:0] <= '1;

        ds.cb.w0_n[31:0] <= 32'hF0F0F0F0;
        ds.cb.w1_n[31:0] <= '0;
        ds.cb.w2_n[31:0] <= '0;
        ds.cb.w3_n[31:0] <= '0;

//        ds.cb.sa00[7:0] <= '1; ds.cb.sa01[7:0] <= '1; ds.cb.sa02[7:0] <= '1; ds.cb.sa03[7:0] <= '1;
//        ds.cb.sa10[7:0] <= '1; ds.cb.sa11[7:0] <= '1; ds.cb.sa12[7:0] <= '1; ds.cb.sa13[7:0] <= '1;
//        ds.cb.sa20[7:0] <= '1; ds.cb.sa21[7:0] <= '1; ds.cb.sa22[7:0] <= '1; ds.cb.sa23[7:0] <= '1;
//        ds.cb.sa30[7:0] <= '1; ds.cb.sa31[7:0] <= '1; ds.cb.sa32[7:0] <= '1; ds.cb.sa33[7:0] <= '1;

//        ds.cb.sa00_n[7:0] <= '0; ds.cb.sa01_n[7:0] <= '0; ds.cb.sa02_n[7:0] <= '0; ds.cb.sa03_n[7:0] <= '0;
//        ds.cb.sa10_n[7:0] <= '0; ds.cb.sa11_n[7:0] <= '0; ds.cb.sa12_n[7:0] <= '0; ds.cb.sa13_n[7:0] <= '0;
//        ds.cb.sa20_n[7:0] <= '0; ds.cb.sa21_n[7:0] <= '0; ds.cb.sa22_n[7:0] <= '0; ds.cb.sa23_n[7:0] <= '0;
//        ds.cb.sa30_n[7:0] <= '0; ds.cb.sa31_n[7:0] <= '0; ds.cb.sa32_n[7:0] <= '0; ds.cb.sa33_n[7:0] <= '0;

        ds.cb.sa00_next[7:0] <= 8'b10101010; ds.cb.sa01_next[7:0] <= '1; ds.cb.sa02_next[7:0] <= '1; ds.cb.sa03_next[7:0] <= '1;
        ds.cb.sa10_next[7:0] <= '1; ds.cb.sa11_next[7:0] <= '1; ds.cb.sa12_next[7:0] <= '1; ds.cb.sa13_next[7:0] <= '1;
        ds.cb.sa20_next[7:0] <= '1; ds.cb.sa21_next[7:0] <= '1; ds.cb.sa22_next[7:0] <= '1; ds.cb.sa23_next[7:0] <= '1;
        ds.cb.sa30_next[7:0] <= '1; ds.cb.sa31_next[7:0] <= '1; ds.cb.sa32_next[7:0] <= '1; ds.cb.sa33_next[7:0] <= '1;


        ds.cb.sa00_next_n[7:0] <= 8'b01010101; ds.cb.sa01_next_n[7:0] <= '0; ds.cb.sa02_next_n[7:0] <= '0; ds.cb.sa03_next_n[7:0] <= '0;
        ds.cb.sa10_next_n[7:0] <= '0; ds.cb.sa11_next_n[7:0] <= '0; ds.cb.sa12_next_n[7:0] <= '0; ds.cb.sa13_next_n[7:0] <= '0;
        ds.cb.sa20_next_n[7:0] <= '0; ds.cb.sa21_next_n[7:0] <= '0; ds.cb.sa22_next_n[7:0] <= '0; ds.cb.sa23_next_n[7:0] <= '0;
        ds.cb.sa30_next_n[7:0] <= '0; ds.cb.sa31_next_n[7:0] <= '0; ds.cb.sa32_next_n[7:0] <= '0; ds.cb.sa33_next_n[7:0] <= '0;

		
		$display ("------------- Simulation Time ----------------- %t", $realtime );


	@(ds.cb);
*/
	endtask


	initial begin
		repeat(100) begin
			do_cycle();
		end
	end


endprogram


