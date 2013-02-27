#include <stdio.h>
#include <stdlib.h>

//#define print 0

typedef unsigned char byte;
typedef unsigned int word;

void encrypt_128_key_expand_inline_no_branch(word state[], word key[]);
void encrypt_192_key_expand_inline_no_branch(word state[], word key[]);
void encrypt_256_key_expand_inline_no_branch(word state[], word key[]);

word rand_word();
void rand_word_array(word w[], int bit_num);
void print_verilog_hex(word w[], int bit_num);


int  rst;
int  ld;
int  status = 0;
int  done;
word ctext[4];
word state[4];
word key[8];

int rst_ctrl [2] = {0, 0};
int tmp_rst = 0;


int s_ct = 14;

int get_done() {

	int temp = 0;

	if (status == s_ct) {
		done = 1;
		status = 0;
	}
	else
		done = 0;

	return done;

}

int get_status() {

	return status;
}

void send_ld_rst (int l, int rt) {

	ld = l;

	if (rst == 0 && status != 14 ){
		status = 0;
	} 

	if (status >= 1)
		status = status + 1;

	if (ld == 1)
		status = 1;

	tmp_rst == 1;

	rst = rt;
//	printf (" status and rst : %d%d", status, rst);
}

void rebuild_text(word t_state, int i) {

	if (status == 1)
		state[i] = t_state;
	else
		state[i] = state[i];

	#ifdef print
    	printf (" rebuilt text received in C :%d\n", t_state);
    	printf (" rebuilt text in C :%d%d%d%d\n", state[0], state[1], state[2], state[3]);

	printf ("text is \n");
	print_verilog_hex(state, 128);
	printf ("\n");
	#endif	
}

void rebuild_key(word t_key, int i) {

	if (status == 1)
		key[i] = t_key;
	else 
		key[i] = key[i];	

	#ifdef print
    	printf (" rebuilt key received in C :%d\n", t_key);
    	printf (" rebuilt key in C :%d%d%d%d\n", key[0], key[1], key[2], key[3]);

	printf ("key is \n");
	print_verilog_hex(key, 128);
	printf ("\n");
	#endif
}

void generate_ciphertext(int rst){

	if (status == s_ct && rst != 0)
		encrypt_128_key_expand_inline_no_branch(state, key);

	ctext[0] = state[0];
	ctext[1] = state[1];
	ctext[2] = state[2];
	ctext[3] = state[3];

	//Text and State received in C
/*	printf("\nReceived key in C: ");
	print_verilog_hex(key, 128);
	printf("\n");
	printf("Received state in C: ");
	print_verilog_hex(state, 128);
	printf("\n");

	printf("########ENCRYPTING#########");
	printf("\n");    
*/

/*
	printf("Encrypted text in C: ");
	print_verilog_hex(ctext, 128);
	printf("\n");
*/
}

word get_ciphertext(int i){

	if (rst == 0)
		ctext[i] = 0;

	return ctext[i];
}


void read_text(){

	print_verilog_hex(state, 128);
}

void print_verilog_hex(word w[], int bit_num) {
    int byte_num = bit_num / 8;
    int i;
    byte *b = (byte *)w;
    printf("%d'h", bit_num);
//    for(i=byte_num-1; i>= 0; i--)
    for(i=0; i<byte_num; i++) {
        printf("%02x", b[i]);
    }

}

void rearrange_text() {
    int i;
    byte *n = (byte *)state;
    word x[4];
    x[0] = state[0]; x[1] = state[1]; x[2] = state[2]; x[3] = state[3];

    if (status == 1) {
	    byte *o = (byte *)x;
	    for (i=0; i<16; i++) {
		n[i] = o[15-i];
    	} 
    }
}


void rearrange_key() {
    int i;
    byte *n = (byte *)key;
    word x[4];
    x[0] = key[0]; x[1] = key[1]; x[2] = key[2]; x[3] = key[3];

    if (status == 1) {
	    byte *o = (byte *)x;
	    for (i=0; i<16; i++) {
		n[i] = o[15-i];
   	}    
   }
}

void rearrange_cipher() {

    #ifdef print
    printf ("\n C : status at cipher : %d \n", status);
    #endif
    int i;
    byte *n = (byte *)ctext;
    word x[4];
    x[0] = ctext[0]; x[1] = ctext[1]; x[2] = ctext[2]; x[3] = ctext[3];

    if (status == s_ct) {
	    byte *o = (byte *)x;
	    for (i=0; i<16; i++) {
		n[i] = o[15-i];
	   }    
   }
} 
