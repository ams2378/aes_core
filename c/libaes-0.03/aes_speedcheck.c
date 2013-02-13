/*
 * $Id: aes_speedcheck.c,v 1.4 2002/01/15 17:19:13 cvs Exp $
 *
 * Basic timing loop tests for AES
 * Written rather non-portably for a linux implementation using
 * sigalarm
 */

#include <stdio.h>
#include <sys/types.h>
#include <sys/times.h>
#include <signal.h>

#include "aes.h"

/* Run each timing loop test for this many seconds */
#define RUN_FOR_TIME 10

#define HZ 100.0

#define START 0
#define STOP 1

#define timing_loop(func,label,var) \
	run = 1;\
	printf("Running %s for %d seconds\n", label, RUN_FOR_TIME);\
	alarm(RUN_FOR_TIME);\
	do_timer(START);\
	for (count=0; (run); count+=4) {\
		func;\
		func;\
		func;\
		func;\
	}\
	tm = do_timer(STOP);\
	var = ((double) count)/tm;\
	printf("%ld %s loops in %.2f seconds (%.1f/sec)\n", count, label, tm, var);



int run = 0;

void sig_endloop(int sig)
{
	signal(SIGALRM, sig_endloop);
	run = 0;
}



double do_timer(int startstop)
{
	static struct tms tstart,tstop;
	double ret;

	if (startstop == START) {
		times(&tstart);
		return(0);
	} else {
		times(&tstop);
		ret= ((double)(tstop.tms_utime - tstart.tms_utime)) / HZ;
		return((ret == 0.0)?1e-9:ret);
	}
}



char * fmt_scaled(double size) {
	static char ret[20];
	char *suffix="";

	if (size >= 1024.0) {
		size /= 1024.0;
		suffix="K";
	}
	if (size >= 1024.0) {
		size /= 1024.0;
		suffix="M";
	}
	if (size >= 1024.0) {
		size /= 1024.0;
		suffix="G";
	}
	sprintf(ret, "%.2f%s", size, suffix);
	return(ret);
}



int main(int argc, char **argv)
{
	long count;
	unsigned char in[16], out[16], key[32];
	aes_ctx ctx;
	double tm, setkeys, encrypts, decrypts;
	int keylen = 16;

	if (argc == 2) {
		if (!strcmp(argv[1], "128"))
			keylen = 16;
		else if (!strcmp(argv[1], "192"))
			keylen = 24;
		else if (!strcmp(argv[1], "256"))
			keylen = 32;
	}

	printf("Running speed tests with %d bit AES key\n", keylen*8);
	signal(SIGALRM, sig_endloop);

#if defined(AES_ENCRYPT_ONLY)
	timing_loop(aes_set_key(&ctx, key, keylen, aes_enc),"aes_set_key(encrypt)", setkeys);
#elsif defined(AES_DECRYPT_ONLY)
	timing_loop(aes_set_key(&ctx, key, keylen, aes_dec),"aes_set_key(decrypt)", setkeys);
#else
	timing_loop(aes_set_key(&ctx, key, keylen, aes_both),"aes_set_key(both)", setkeys);
#endif

#if !defined(AES_DECRYPT_ONLY)
	timing_loop(aes_encrypt(&ctx, in, out),"aes_encrypt()", encrypts);
#endif
#if !defined(AES_ENCRYPT_ONLY)
	timing_loop(aes_decrypt(&ctx, in, out),"aes_decrypt()", decrypts);
#endif

#if !defined(AES_DECRYPT_ONLY)
	printf("encrypt %sB/sec\n", fmt_scaled(encrypts*16.0));
#endif
#if !defined(AES_ENCRYPT_ONLY)
	printf("decrypt %sB/sec\n", fmt_scaled(decrypts*16.0));
#endif
	exit(0);
}


/*
 * Local variables:
 *  c-indent-level: 4
 *  c-basic-offset: 4
 *  tab-width: 4
 * End:
 */
