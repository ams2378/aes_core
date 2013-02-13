#include <stdlib.h>
#include "aes.h"
//#include <iostream>

int main(){

	AES_KEY *myKey;

	const unsigned char key = 'xiskexxxxxxxxxxy';
//	const unsigned char *key;

	if (AES_set_encrypt_key (key, 128, &myKey) != 0) {
		printf("not good");
//		cout << "not good" << endl; 
	} 
	
	const unsigned char *myIn = 'rrrrrrrrrressage';
	unsigned char *myOut;
	
	AES_encrypt( *myIn, myOut, (const AES_KEY *)&myKey);
	printf ("encrypted code: %u", myOut);

//	cout << myOut << endl; 

}
