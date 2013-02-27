
class aes_transaction;

//	rand bit[127:0] text;
//	rand bit[127:0] key;

	rand int 	text[4];
	rand int	key[4];
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

	constraint ld_status {
		(const_key == 1) -> (key == 128'h20f04193bd83c6bc82ad5b2b65140618);
	}

/*	constraint ld_status {
		(const_key == 1) -> (key[1] =2192399147);
	}

	constraint ld_status {
		(const_key == 1) -> (key[2] =3179529916);
	}

	constraint ld_status {
		(const_key == 1) -> (key[3] = 552616339);
	}

*/

endclass

