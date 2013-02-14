#include <stdlib.h>
#include "aes.h"
<<<<<<< HEAD
#include <stdio.h>


int main(){


//	AES_KEY myKey;

	AES_KEY myAESkey;

//	AES_KEY *p = &AES_KEY;

	const unsigned char *myPasswd = "ellothisisksey";
	const unsigned char *myIn = "thisismessageasd";
	unsigned char *myOut;

	
	AES_set_encrypt_key((const unsigned char *)myPasswd, 128, &myAESkey);

	AES_encrypt((const unsigned char *)myIn, myOut, (const AES_KEY *)&myAESkey);


	printf ("result is : %s", myOut );
//	printf ("round is : %d", myAESkey.rounds );

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

=======
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
>>>>>>> e7d512ead35655cb42f2c145213a26979a5ee97e
