// $Id: cbc_aes.c,v 1.3 2002/01/15 18:12:42 cvs Exp $
#include <sys/types.h>
#include "cbc_aes.h"
#include "cbc_generic.h"
int AES_set_key(aes_context *aes_ctx, caddr_t key, int keysize) {
	aes_set_key(aes_ctx, key, keysize, 0);
	return 0;
}
CBC_IMPL_BLK16(AES_cbc_encrypt, aes_context, unsigned char *, aes_encrypt, aes_decrypt);
