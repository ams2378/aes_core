#include <stdio.h>
#include <stdlib.h>


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

/*
void generate_text (){
    rand_word_array(state, 128);
    printf (" generated text in C :%d%d%d%d\n", state[0], state[1], state[2], state[3]);
    return state;
}

word read_text(int i) {

	return state[i];
}

word generate_key(){
    rand_word_array(key, 128);
    return key;
}

*/
void rebuild_text(word t_state, int i) {
	state[i] = t_state;

    printf (" rebuilt text received in C :%d\n", t_state);
    printf (" rebuilt text in C :%d%d%d%d\n", state[0], state[1], state[2], state[3]);
}

void rebuild_key(word t_key, int i) {
	key[i] = t_key;

    printf (" rebuilt key received in C :%d\n", t_key);
    printf (" rebuilt key in C :%d%d%d%d\n", key[0], key[1], key[2], key[3]);
}


void generate_ciphertext(){
    	encrypt_128_key_expand_inline_no_branch(state, key);
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

void print_verilog_hex(word w[], int bit_num) {
    int byte_num = bit_num / 8;
    int i;
    byte *b = (byte *)w;
    printf("%d'h", bit_num);
    for(i=0; i<byte_num; i++)
        printf("%02x", b[i]);
}








