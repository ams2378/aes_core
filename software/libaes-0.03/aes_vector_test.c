/*
 * AES Test Code - applies AES test vectors to the AES library
 *
 * $Id: aes_vector_test.c,v 1.10 2002/01/15 18:12:42 cvs Exp $
 *
 */

#include <stdio.h>
#include <sys/types.h>
#include <string.h>
#include <getopt.h>

#include "aes.h"

#define MAX_STRING_LEN 256



typedef struct {
	char *name;        /* invocation name: "NAME", "NAMECAT", etc */
	int verbose;       /* -1=quiet, 0=normal, 1=verbose */
	int debug;    
	char **infiles;    /* list of filenames */
	int count;         /* number filenames */
} cmdline;

typedef struct {
	int blocksize;
	int keysize;
	int keyok;
	int successes;
	int failures;
	int failed_setkeys;
	int files;
	int skipped_files;
	int skipped_tests;
	int testid;
	char pt[MAX_STRING_LEN];
	char ct[MAX_STRING_LEN];
	char key[MAX_STRING_LEN];
	aes_ctx aes_ctx;
} context;

static struct option longopts[] = {
	{"help",         0, 0, 'h'},
	{"verbose",      0, 0, 'v'},
	{"quiet",        0, 0, 'q'},
	{"debug",        0, 0, 'd'},
	{0, 0, 0, 0}
};

static char *shortopts = "hdqv";

cmdline cmd;



void usage()
{
	printf("\
aes_test_vectors - $Id: aes_vector_test.c,v 1.10 2002/01/15 18:12:42 cvs Exp $ - run test vectors through AES library

Usage:
	aes_test_vectors [options] file...

Options:
    -h, --help             print this help message and exit
    -d  --debug            output debug info
    -v, --verbose          print progress information to stderr
    -q, --quiet            run quietly; suppress warnings
");
}



cmdline process_cmdline (int ac, char *av[])
{
	cmdline cmd;
	int c;
	char *p;

	/* set defaults */
	cmd.verbose = 0;
	cmd.debug = 0;
	cmd.infiles = NULL;
	cmd.count = 0;

	/* find the basename with which we were invoked */
	cmd.name = strrchr(av[0], '/');
	cmd.name = cmd.name ? cmd.name+1 : av[0];

	while ((c = getopt_long(ac, av, shortopts, longopts, NULL)) != -1) {
		switch(c) {
		case 'h':
			usage();
			exit(0);
		case 'd':
			cmd.debug = 1;
			break;
		case 'v':
			cmd.verbose = 1;
			break;
		case 'q':
			cmd.verbose = -1;
			break;
		default:
			usage();
			exit(1);
		}
	}
	cmd.infiles = &av[optind];
	cmd.count = ac-optind;

	return cmd;
}



void get_hexstr(char * instr, unsigned char * out)
{
	char hex[3];
	char *eptr;

	while(*instr && isspace(*instr)) 
		instr++;

	while (*instr && isxdigit(*instr)) {
		hex[0] = *instr++;
		if (*instr && isxdigit(*instr))
			hex[1] = *instr++;
		else
			hex[1] = '0';
		hex[2] = 0;
		*out++ = strtol(hex, &eptr, 16);
	}
}



char * hexstring(unsigned char * instr, int len, char * out)
{
	static char vals[] = "0123456789abcdef";
	char *ptr = out;
	int bytes = len / 8;

	while(bytes-- > 0) {
		*ptr++ = vals[((*instr & 0xf0) >> 4)];
		*ptr++ = vals[(*instr++ & 0x0f)];
	}
	*ptr = 0;
	return out;
}



void aes_verify(context *ctx,
				cmdline *cmd)
{
	/* we have key, plaintext and cyphertext here, so
	 * we run it through the crypter and make sure its
	 * as we expect
	 */
	char ct[MAX_STRING_LEN];
	char pt[MAX_STRING_LEN];
	int block_bytes;
	int e_nok, d_nok;			/* whether enc/dec failed and how */

	block_bytes = ctx->blocksize	/ 8;
#if !defined(AES_DECRYPT_ONLY)
	e_nok = (aes_encrypt(&(ctx->aes_ctx), ctx->pt, ct) == aes_good) ? 0 : 2;
	e_nok |= (memcmp(ctx->ct, ct, block_bytes)) ? 1 : 0;
#endif
#if !defined(AES_ENCRYPT_ONLY)
	d_nok = (aes_decrypt(&(ctx->aes_ctx), ctx->ct, pt) == aes_good) ? 0 : 2;
	d_nok |= (memcmp(ctx->pt, pt, block_bytes)) ? 1 : 0;
#endif
	if (cmd->debug) {
		char oa[MAX_STRING_LEN];
		char ob[MAX_STRING_LEN];
		char oc[MAX_STRING_LEN];
		char od[MAX_STRING_LEN];

#if !defined(AES_DECRYPT_ONLY)
		printf(">> encrypt(%s, %s) = %s (%s) %s (%d)\n",
			   hexstring(ctx->pt, ctx->blocksize, oa),
			   hexstring(ctx->key, ctx->keysize, ob),
			   hexstring(ctx->ct, ctx->blocksize, oc),
			   hexstring(ct, ctx->blocksize, od),
			   (!e_nok ? "OK    " : "FAILED"),
			   e_nok);
#endif
#if !defined(AES_ENCRYPT_ONLY)
		printf(">> decrypt(%s, %s) = %s (%s) %s (%d)\n",
			   hexstring(ctx->ct, ctx->blocksize, oa),
			   hexstring(ctx->key, ctx->keysize, ob),
			   hexstring(ctx->pt, ctx->blocksize, oc),
			   hexstring(pt, ctx->blocksize, od),
			   (!d_nok ? "OK    " : "FAILED"),
			   d_nok);
#endif
	}
	if (((e_nok || d_nok) && (cmd->verbose >= 0)) || (cmd->verbose > 0)) {
		printf(" %s file %3d, test %3d encrypt %s decrypt %s\n",
			   ((!e_nok && !d_nok) ? " " : "*"),
			   ctx->files, ctx->testid,
#ifdef AES_DECRYPT_ONLY
			   "UNTESTED",
#else
			   (!e_nok ? "OK    " : "FAILED"),
#endif
#ifdef AES_ENCRYPT_ONLY
			   "UNTESTED",
#else
			   (!d_nok ? "OK    " : "FAILED"));
#endif
	}

#if !defined(AES_DECRYPT_ONLY)
	if (!e_nok)
		ctx->successes++;
	else
		ctx->failures++;
#endif
#if !defined(AES_ENCRYPT_ONLY)
	if (!d_nok)
		ctx->successes++;
	else
		ctx->failures++;
#endif
}



void process_file(context *ctx,
				  cmdline *cmd,
				  char * fn,
				  FILE * inf)
{
	char inbuf[MAX_STRING_LEN];
	char *eptr;
	char *ptr;
	int done_skip = 0;

	ctx->files++;
	while (fgets(inbuf, sizeof(inbuf), inf)) {
		if (!strncmp("BLOCKSIZE=", inbuf, 10)) {
			ctx->blocksize = strtol((inbuf + 10), &eptr, 10);
#ifdef AES_BLOCK_SIZE
			/* Input block size is in bits... so scale */
			if ((ctx->blocksize / 8) != AES_BLOCK_SIZE) {
				if (cmd->verbose > 0)
					printf("AES blocksize of %d is unsupported - vector tests skipped\n",
						   ctx->blocksize);
				ctx->blocksize = 0;
				if (! done_skip++)
					ctx->skipped_files++;
			}
#else
			aes_set_blk(&(ctx->aes_ctx), ctx->blocksize);
#endif
		} else if (!strncmp("KEYSIZE=", inbuf, 8)) {
			ctx->keysize = strtol((inbuf + 8), &eptr, 10);
			/* We only support a few key sizes - check this, ignore others */
			if ((ctx->keysize != 128) &&
				(ctx->keysize != 192) &&
				(ctx->keysize != 256)) {
				if (cmd->verbose > 0)
					printf("AES keysize of %d is unsupported - vector tests skipped\n",
						   ctx->keysize);
				ctx->keysize = 0;
				if (! done_skip++)
					ctx->skipped_files++;
			}
		} else if (!strncmp("TEST=", inbuf, 5)) {
			ctx->testid = strtol((inbuf + 5), &eptr, 10);
		} else if (!strncmp("KEY=", inbuf, 4)) {
			get_hexstr((inbuf + 4), ctx->key);
			/* new key - regenerate key schedule */
			if (ctx->blocksize && ctx->keysize) {
				if (aes_set_key(&(ctx->aes_ctx), 
								ctx->key,
								ctx->keysize/8,
								aes_both) == aes_good)
					ctx->keyok = 1;
				else
					ctx->keyok = 0;
				if (cmd->debug) {
					char ob[1024];

					printf(">> set_key(%s) %s\n",
						   hexstring(ctx->key, ctx->keysize, ob),
						   (ctx->keyok ? "OK    " : "FAILED"));
					printf("   Nkey = %d Nrnd = %d\n",
						   ctx->aes_ctx.Nkey,
						   ctx->aes_ctx.Nrnd);
					printf("   ekey = %s\n",
						   hexstring((char *)ctx->aes_ctx.e_key, 2048, ob));
					printf("   dkey = %s\n",
						   hexstring((char *)ctx->aes_ctx.d_key, 2048, ob));

				}
				if ((!ctx->keyok && (cmd->verbose >= 0)) ||
					(cmd->verbose > 0))
					printf(" %s file %3d, test %3d set_key %s\n",
						   (ctx->keyok ? " " : "*"),
						   ctx->files, ctx->testid,
						   (ctx->keyok ? "OK    " : "FAILED"));
			}
		} else if (!strncmp("PT=", inbuf, 3)) {
			get_hexstr((inbuf + 3), ctx->pt);
		} else if (!strncmp("CT=", inbuf, 3)) {
			get_hexstr((inbuf + 3), ctx->ct);
			/* when we get a new ct we then test it */
			if (ctx->blocksize && ctx->keysize && ctx->keyok)
				aes_verify(ctx, cmd);
			else {
				if (!ctx->blocksize || !ctx->keysize)
					ctx->skipped_tests++;
				else
					ctx->failures++;
			}
		}
		/* If we don't recognise it, we ignore it */
	}
}



int main (int argc, char **argv)
{
	context ctx;
	int idx;

	/* zilch the context out */
	memset(&ctx, 0, sizeof(ctx));

	/* deal with args */
	cmd = process_cmdline(argc, argv);

	/* interate over the input files */
	for (idx = 0; (idx < cmd.count); idx++) {
		FILE *inf;

		inf = fopen(cmd.infiles[idx], "r");
		if (inf == NULL) {
			char msg[256];
			snprintf(msg, sizeof(msg),
					 "%s: unable to open file %s ",
					 cmd.name, cmd.infiles[idx]);
			perror(msg);
			continue;
		}
		process_file(&ctx, &cmd, cmd.infiles[idx], inf);
		fclose(inf);
	}
	if (cmd.verbose >= 0) {
		printf("Test summary - files %d, tests %d OK, %d FAILED\n",
			   (ctx.files - ctx.skipped_files), ctx.successes, ctx.failures);
		if (ctx.skipped_tests)
		printf("\tskipped %d files, %d tests (due to wrong key/block size)\n",
			   ctx.skipped_files, ctx.skipped_tests);
		if ((ctx.successes > 0) && (ctx.failures == 0))
			printf("Conclusion: everything OK for supported block/key sizes\n");
		else
			printf("Conclusion: some problems need resolving\n");
	}
	exit(ctx.failures);
}



/*
 * Local variables:
 *  c-indent-level: 4
 *  c-basic-offset: 4
 *  tab-width: 4
 * End:
 */
