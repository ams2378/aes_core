#include <stdlib.h>
#include "aes.h"
#include <stdio.h>


int main(){


//	AES_KEY myKey;

	AES_KEY myAESkey;

//	AES_KEY *p = &AES_KEY;

	const unsigned char *myPasswd = "ellothisisksey";
	const unsigned char *myIn = "thisismessageasd";
	unsigned char *myOut;

	
	AES_set_encrypt_key((const unsigned char *)myPasswd, 128, &myAESkey);

	printf ("round is : %d", myAESkey.rounds );

	AES_encrypt((const unsigned char *)myIn, myOut, (const AES_KEY *)&myAESkey);

	printf ("result is : %s", myOut );
/*
	if (AES_set_encrypt_key (key, 128, &myKey) != 0) {
//		printf("not good");
	} 

	printf ("round is : %d", myKey.rounds );

//	printf ("key is : %lu", myKey.rd_key );

	const unsigned char *myIn = "thisismessageasd";
	unsigned char myOut;

	AES_KEY *p = &myKey;
	
	AES_encrypt(myIn, &myOut, p);

	printf ("result is : %s", myOut );

*/
}

