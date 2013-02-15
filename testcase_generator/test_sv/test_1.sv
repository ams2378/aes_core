class transaction;
	
rand int  text[4];
rand int  key[4];

endclass

program main;

int unsigned fromc[4];

//int unsigned temp_txt[4];
//int unsigned temp_ky[4];

import "DPI-C" function int unsigned generate_ciphertext ( input int unsigned txt[], input int unsigned ky[]);
import "DPI-C" function int unsigned generate_text ();
import "DPI-C" function void rebuild_text ( input int  txt, input int i);
import "DPI-C" function int unsigned read_text (input int i);

int tt = 0;
transaction t;

initial
	begin

repeat (1) begin

	t = new();
	t.randomize();


	$display ("SV: sent to C : %d", t.text[0]);
	rebuild_text(t.text[0], 0);
	$display ("SV: sent to C : %d", t.text[1]);
	rebuild_text(t.text[1], 1);
	$display ("SV: sent to C : %d", t.text[2]);
	rebuild_text(t.text[2], 2);
	$display ("SV: sent to C : %d", t.text[3]);
	rebuild_text(t.text[3], 3);


	$display("SV: randomized text : %b%b%b%b", t.text[0], t.text[1], t.text[2], t.text[3] );

	$display("SV: randomized text : %d%d%d%d", t.text[0], t.text[1], t.text[2], t.text[3] );
//$display("SV: received key : %h%h%h%h", t.key[0], t.key[1], t.key[2], t.key[3] );

//fromc[0] = generate_ciphertext( t.text[0:3], t.key[0:3]  );


//generate_text();
//fromc[0] = read_text(0);
//fromc[1] = read_text(1);
//fromc[2] = read_text(2);
//fromc[3] = read_text(3);
//$display("SV: received text : %d%d%d%d", fromc[0], fromc[1], fromc[2], fromc[3] );




	end
end
endprogram
