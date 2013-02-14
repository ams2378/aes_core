/*
 * 	Heavily inspired in loop_AES
 */
#include <linux/types.h>
#define CBC_IMPL_BLK16(name, ctx_type, addr_type, enc_func, dec_func) \
int name(ctx_type *ctx, unsigned char * in, unsigned char * out, int ilen, unsigned char * iv, int encrypt) { \
	int ret=ilen, pos; \
	u_int32_t *iv_i; \
	if ((ilen) % 16) return 0; \
	if (encrypt) { \
		pos=0; \
		while(pos<ilen) { \
			if (pos==0) \
				iv_i=(u_int32_t*) iv; \
			else \
				iv_i=(u_int32_t*) (out-16); \
			*((u_int32_t *)(&out[ 0])) = iv_i[0]^*((u_int32_t *)(&in[ 0])); \
			*((u_int32_t *)(&out[ 4])) = iv_i[1]^*((u_int32_t *)(&in[ 4])); \
			*((u_int32_t *)(&out[ 8])) = iv_i[2]^*((u_int32_t *)(&in[ 8])); \
			*((u_int32_t *)(&out[12])) = iv_i[3]^*((u_int32_t *)(&in[12])); \
			enc_func(ctx, (addr_type) out, (addr_type) out); \
			in+=16; \
			out+=16; \
			pos+=16; \
		} \
	} else { \
		pos=ilen-16; \
		in+=pos; \
		out+=pos; \
		while(pos>=0) { \
			dec_func(ctx, (addr_type) in, (addr_type) out); \
			if (pos==0) \
				iv_i=(u_int32_t*) (iv); \
			else \
				iv_i=(u_int32_t*) (in-16); \
			*((u_int32_t *)(&out[ 0])) ^= iv_i[0]; \
			*((u_int32_t *)(&out[ 4])) ^= iv_i[1]; \
			*((u_int32_t *)(&out[ 8])) ^= iv_i[2]; \
			*((u_int32_t *)(&out[12])) ^= iv_i[3]; \
			in-=16; \
			out-=16; \
			pos-=16; \
		} \
	} \
	return ret; \
} 
#define CBC_IMPL_BLK8(name, ctx_type, addr_type,  enc_func, dec_func) \
int name(ctx_type *ctx, unsigned char * in, unsigned char * out, int ilen, unsigned char * iv, int encrypt) { \
	int ret=ilen, pos; \
	u_int32_t *iv_i; \
	if ((ilen) % 8) return 0; \
	if (encrypt) { \
		pos=0; \
		while(pos<ilen) { \
			if (pos==0) \
				iv_i=(u_int32_t*) iv; \
			else \
				iv_i=(u_int32_t*) (out-8); \
			*((u_int32_t *)(&out[ 0])) = iv_i[0]^*((u_int32_t *)(&in[ 0])); \
			*((u_int32_t *)(&out[ 4])) = iv_i[1]^*((u_int32_t *)(&in[ 4])); \
			enc_func(ctx, (addr_type)out, (addr_type)out); \
			in+=8; \
			out+=8; \
			pos+=8; \
		} \
	} else { \
		pos=ilen-8; \
		in+=pos; \
		out+=pos; \
		while(pos>=0) { \
			dec_func(ctx, (addr_type)in, (addr_type)out); \
			if (pos==0) \
				iv_i=(u_int32_t*) (iv); \
			else \
				iv_i=(u_int32_t*) (in-8); \
			*((u_int32_t *)(&out[ 0])) ^= iv_i[0]; \
			*((u_int32_t *)(&out[ 4])) ^= iv_i[1]; \
			in-=8; \
			out-=8; \
			pos-=8; \
		} \
	} \
	return ret; \
} 
#define CBC_DECL(name, ctx_type) \
int name(ctx_type *ctx, unsigned char * in, unsigned char * out, int ilen, unsigned char * iv, int encrypt)
/*
Eg.:
CBC_IMPL_BLK16(AES_cbc_encrypt, aes_context, caddr_t, aes_encrypt, aes_decrypt);
CBC_DECL(AES_cbc_encrypt, aes_context);
*/
