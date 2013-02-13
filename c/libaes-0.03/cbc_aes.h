/* $Id: cbc_aes.h,v 1.2 2002/01/04 10:48:15 cvs Exp $
 *
 * Glue header */
#include "aes.h"
int AES_set_key(aes_context *aes_ctx, caddr_t key, int keysize);
int AES_cbc_encrypt(aes_context *ctx, unsigned char * in, unsigned char * out, int ilen, unsigned char * iv, int encrypt);
