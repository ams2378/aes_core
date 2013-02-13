#include "aes.h"


int main(){


	struct AES_KEY myKey;

	const unsigned char *myKey = 'hellothisiskey';

	if (AES_set_encrypt_key (key, 128, &myKey) != 0) {
		printf("not good");
	} 

	const unsigned char *myIn = 'thisismessage';
	unsigned char *myOut;
	
	AES_encrypt((const unsigned char *)myIn, myOut, (const AES_KEY *)&myKey);


}
