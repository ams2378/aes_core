#include <tomcrypt.h>
int main(void)
{
unsigned char key[16], IV[16], buffer[512];
symmetric_CTR ctr;
int x, err;
/* register twofish first */
if (register_cipher(&twofish_desc) == -1) {
printf("Error registering cipher.\n");
return -1;
}
/* somehow fill out key and IV */
/* start up CTR mode */
if ((err = ctr_start(
find_cipher("twofish"), /* index of desired cipher */
IV, /* the initial vector */
key, /* the secret key */
16, /* length of secret key (16 bytes) */
0, /* 0 == default # of rounds */
CTR_COUNTER_LITTLE_ENDIAN, /* Little endian counter */
&ctr) /* where to store the CTR state */
) != CRYPT_OK) {
printf("ctr_start error: %s\n", error_to_string(err));
return -1;
}
/* somehow fill buffer than encrypt it */
if ((err = ctr_encrypt( buffer, /* plaintext */
buffer, /* ciphertext */
sizeof(buffer), /* length of plaintext pt */
&ctr) /* CTR state */
) != CRYPT_OK) {
printf("ctr_encrypt error: %s\n", error_to_string(err));
return -1;
}
3.4 Symmetric Modes of Operations 31
/* make use of ciphertext... */
/* now we want to decrypt so let’s use ctr_setiv */
if ((err = ctr_setiv( IV, /* the initial IV we gave to ctr_start */
16, /* the IV is 16 bytes long */
&ctr) /* the ctr state we wish to modify */
) != CRYPT_OK) {
printf("ctr_setiv error: %s\n", error_to_string(err));
return -1;
}
if ((err = ctr_decrypt( buffer, /* ciphertext */
buffer, /* plaintext */
sizeof(buffer), /* length of plaintext */
&ctr) /* CTR state */
) != CRYPT_OK) {
printf("ctr_decrypt error: %s\n", error_to_string(err));
return -1;
}
/* terminate the stream */
if ((err = ctr_done(&ctr)) != CRYPT_OK) {
printf("ctr_done error: %s\n", error_to_string(err));
return -1;
}
/* clear up and return */
zeromem(key, sizeof(key));
zeromem(&ctr, sizeof(ctr));
return 0;
}
