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

word state[4];
word key[8];

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

void generate_ciphertext(){
    	encrypt_128_key_expand_inline_no_branch(state, key);

    printf (" in C ciphertext is :%d%d%d%d\n", state[0], state[1], state[2], state[3]);
#ifdef print
	printf ("ciphertext is \n");
	print_verilog_hex(state, 128);
	printf ("\n");
	
#endif
}

word get_ciphertext(int i){

#ifdef print
	printf ("sent cipher : %d\n", state[i]);

#endif
	return state[i];
}

void print_verilog_hex(word w[], int bit_num) {
    int byte_num = bit_num / 8;
    int i;
    byte *b = (byte *)w;
    printf("%d'h", bit_num);
    for(i=0; i<byte_num; i++)
        printf("%02x", b[i]);
}

