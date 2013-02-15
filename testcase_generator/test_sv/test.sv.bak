class transaction;
	
rand int  text[4];
rand int  key[4];

endclass

program main;

import "DPI-C" function void rebuild_text ( input int  txt, input int i);
import "DPI-C" function void rebuild_key ( input int ky , input int i);
import "DPI-C" function void generate_ciphertext ();
import "DPI-C" function int signed get_ciphertext (input int i);

int tt = 0;
transaction t;
int signed  ctext[4];


initial
	begin

repeat (1) begin

	t = new();
	t.randomize();

	$display ("SV: text sent to C : %d", t.text[0]);
	rebuild_text(t.text[0], 0);
	$display ("SV: text sent to C : %d", t.text[1]);
	rebuild_text(t.text[1], 1);
	$display ("SV: text sent to C : %d", t.text[2]);
	rebuild_text(t.text[2], 2);
	$display ("SV: text sent to C : %d", t.text[3]);
	rebuild_text(t.text [3], 3);

	$display ("SV: key sent to C : %d", t.key[0]);
	rebuild_key(t.key[0], 0);
	$display ("SV: key sent to C : %d", t.key[1]);
	rebuild_key(t.key[1], 1);
	$display ("SV: key sent to C : %d", t.key[2]);
	rebuild_key(t.key[2], 2);
	$display ("SV: key sent to C : %d", t.key[3]);
	rebuild_key(t.key[3], 3);


	$display("SV: randomized key : %d%d%d%d", t.key[0], t.key[1], t.key[2], t.key[3] );
	$display("SV: randomized text : %d%d%d%d", t.text[0], t.text[1], t.text[2], t.text[3] );

	generate_ciphertext ();


	ctext[0] = get_ciphertext(0);
	$display ("received cipher: %d", ctext[0] );
	ctext[1] = get_ciphertext(1);
	$display ("received cipher: %d", ctext[1] );
	ctext[2] = get_ciphertext(2);
	$display ("received cipher: %d", ctext[2] );
	ctext[3] = get_ciphertext(3);
	$display ("received cipher: %d", ctext[3] );



	$display("SV: cipher text : %d%d%d%d", ctext[0], ctext[1], ctext[2], ctext[3] );
	$display("SV: randomized key : %h%h%h%h", t.key[0], t.key[1], t.key[2], t.key[3] );
	$display("SV: randomized text : %h%h%h%h", t.text[0], t.text[1], t.text[2], t.text[3] );
	$display("SV: cipher text : %h%h%h%h", ctext[0], ctext[1], ctext[2], ctext[3] );

	end
end
endprogram


//$display("SV: received key : %h%h%h%h", t.key[0], t.key[1], t.key[2], t.key[3] );
//	$display("SV: randomized text : %b%b%b%b", t.text[0], t.text[1], t.text[2], t.text[3] );
//fromc[0] = generate_ciphertext( t.text[0:3], t.key[0:3]  );


//generate_text();
//fromc[0] = read_text(0);
//fromc[1] = read_text(1);
//fromc[2] = read_text(2);
//fromc[3] = read_text(3);
//$display("SV: received text : %d%d%d%d", fromc[0], fromc[1], fromc[2], fromc[3] );

