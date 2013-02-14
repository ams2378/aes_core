#include <stdlib.h>
#include "aes.h"
#include <stdio.h>

#include <iostream>

using namespace std;

int main(){


	AES_KEY myKey;

	const unsigned char *key = "ellothisisksey";

	if (AES_set_encrypt_key (key, 128, &myKey) != 0) {
//		printf("not good");
	} 

//	printf ("key is : %s", myKey );

	cout << myKey.rounds << endl;

/*	const unsigned char *myIn = "thisismessage";
	unsigned char *myOut;
	
	AES_encrypt((const unsigned char *)myIn, myOut, (const AES_KEY *)&myKey);

*/
}
