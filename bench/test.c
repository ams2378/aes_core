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

word ctext[4];
word state[4];
word key[8];

word get_text(int i){
	return state[i];
}

word get_key(int i){

	return key[i];
}

void rebuild_text(word t_state, int i) {
	state[i] = t_state;

	#ifdef print
    	printf (" rebuilt text received in C :%d\n", t_state);
    	printf (" rebuilt text in C :%d%d%d%d\n", state[0], state[1], state[2], state[3]);

	printf ("text is \n");
	print_verilog_hex(state, 128);
	printf ("\n");
	#endif	
}

void rebuild_key(word t_key, int i) {
	key[i] = t_key;
	
	#ifdef print
    	printf (" rebuilt key received in C :%d\n", t_key);
    	printf (" rebuilt key in C :%d%d%d%d\n", key[0], key[1], key[2], key[3]);

	printf ("key is \n");
	print_verilog_hex(key, 128);
	printf ("\n");
	#endif
}

void generate_ciphertext(int rst){
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
	encrypt_128_key_expand_inline_no_branch(state, key);
			
	ctext[0] = state[0];
	ctext[1] = state[1];
	ctext[2] = state[2];
	ctext[3] = state[3];
/*
	printf("Encrypted text in C: ");
	print_verilog_hex(ctext, 128);
	printf("\n");
*/
}

word get_ciphertext(int i){
	return ctext[i];
}


void read_text(){

	print_verilog_hex(state, 128);
}

word rand_word() {
    word w = 0;
    int i;
    for(i=0; i<4; i++) {
        word x = rand() & 255;
        w = (w << 8) | x;
    }
    return w;
}

void rand_word_array(word w[], int bit_num) {
    int word_num = bit_num / 32;
    int i;
    for(i=0; i<word_num; i++)
        w[i] = rand_word();
}

void print_verilog_hex_76(word w[], int bit_num) {
    int byte_num = bit_num / 8;
    int i;
    byte *b = (byte *)w;
    printf("%d'h", bit_num);
    for(i=byte_num-1; i>= 0; i--)
//    for(i=0; i<byte_num; i++)
        printf("%02x", b[i]);
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
    byte *o = (byte *)x;
    for (i=0; i<16; i++) {
	n[i] = o[15-i];
    } 
}


void rearrange_key() {
    int i;
    byte *n = (byte *)key;
    word x[4];
    x[0] = key[0]; x[1] = key[1]; x[2] = key[2]; x[3] = key[3];
    byte *o = (byte *)x;
    for (i=0; i<16; i++) {
	n[i] = o[15-i];
   }    
}


void rearrange_cipher() {
    int i;
    byte *n = (byte *)ctext;
    word x[4];
    x[0] = ctext[0]; x[1] = ctext[1]; x[2] = ctext[2]; x[3] = ctext[3];
    byte *o = (byte *)x;
    for (i=0; i<16; i++) {
	n[i] = o[15-i];
   }    
} 
 
