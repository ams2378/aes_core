/* $Id: aes.h,v 1.6 2002/01/15 18:12:42 cvs Exp $ */

 /*
   -------------------------------------------------------------------------
   Copyright (c) 2001, Dr Brian Gladman <brg@gladman.uk.net>, Worcester, UK.
   All rights reserved.
   
   TERMS

   Redistribution and use in source and binary forms, with or without 
   modification, are permitted subject to the following conditions:

   1. Redistributions of source code must retain the above copyright 
      notice, this list of conditions and the following disclaimer. 

   2. Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the 
      documentation and/or other materials provided with the distribution. 

   3. The copyright holder's name must not be used to endorse or promote 
      any products derived from this software without his specific prior 
      written permission. 

   This software is provided 'as is' with no express or implied warranties 
   of correctness or fitness for purpose.
   -------------------------------------------------------------------------

 */


/*
 * Sections modified by:-
 *	Nigel Metheringham <Nigel.Metheringham@pobox.com>
 *
 * - Base code received from Brian Gladman on 10 Jan 2002
 * - this file much shortened to only contain declarations of interest
 *   to code *using* AES rather than compiling it.
 * - moved context to be first argument
 */

#ifndef _AES_H
#define _AES_H

/*
 * Using fixed block size
 */
#define AES_BLOCK_SIZE  16
#define AES_DUAL_KEY_SCHEDULE   /* NOTE: the assembler version (aes.asm) requires this */

/* Define these if your apps and library need to only go one way - will break
 * the assembler version of the code.
 */
#undef  AES_ENCRYPT_ONLY
#undef  AES_DECRYPT_ONLY

#if defined(AES_ENCRYPT_ONLY) || defined(AES_DECRYPT_ONLY)
#undef AES_DUAL_KEY_SCHEDULE
#endif

#define AES_TYPE_PREFIX aes_
#define AES_NAME_PREFIX aes_

/* 
 * Facilities to add prefixes to type names and C subroutine names.
 * Because the token pasting operator '##' does not expand macro
 * arguments before use a second layer of invocation is needed to
 * obtain this by using con_hi to provide for the expansion of the
 * arguments before con_lo is then invoked.
 */

#define con_lo(x,y) x##y
#define con_hi(x,y) con_lo(x,y)

#if defined(AES_TYPE_PREFIX)
#define t_name(x)   con_hi(AES_TYPE_PREFIX,x)
#else
#define t_name(x)   x
#endif

#if defined(AES_NAME_PREFIX)
#define c_name(x)   con_hi(AES_NAME_PREFIX,x)
#else
#define c_name(x)   x
#endif

#if defined(__cplusplus)
extern "C"
{
#endif

typedef u_int8_t    t_name(byte);   /* must be an 8-bit storage unit */
typedef u_int32_t   t_name(word);   /* must be a 32-bit storage unit */
typedef short       t_name(rval);   /* function return value         */

#define aes_bad     0
#define aes_good    1

enum t_name(mode)     { t_name(enc)  =  1,  /* set if encryption is needed */
                        t_name(dec)  =  2,  /* set if decryption is needed */
#if defined(AES_DUAL_KEY_SCHEDULE)
                        t_name(both) =  3   /* set if both are needed      */
#endif
                      };


#if !defined(AES_BLOCK_SIZE)
#define AES_RC_LENGTH    29
#define AES_KS_LENGTH   128
#else
#define AES_RC_LENGTH   5 * AES_BLOCK_SIZE / 4 - (AES_BLOCK_SIZE == 16 ? 10 : 11)
#define AES_KS_LENGTH   4 * AES_BLOCK_SIZE
#endif

typedef struct
{
#if defined(AES_DUAL_KEY_SCHEDULE)
    t_name(word)    e_key[AES_KS_LENGTH];   /* the encryption key schedule                */
    t_name(word)    d_key[AES_KS_LENGTH];   /* the decryption key schedule                */
#else
    t_name(word)    k_sch[AES_KS_LENGTH];   /* the encryption key schedule                */
#endif
    t_name(word)    Nkey;               /* the number of words in the key input block */
    t_name(word)    Nrnd;               /* the number of cipher rounds                */
#if !defined(AES_BLOCK_SIZE)
    t_name(word)    Ncol;               /* the number of columns in the cipher state  */
#endif
    t_name(byte)    sflg;               /* encrypt, decrypt or aes_both               */
} t_name(ctx);

#if !defined(AES_DUAL_KEY_SCHEDULE)
#define e_key   k_sch
#define d_key   k_sch
#endif

/* some older code uses aes_context so put a cleanup define */
#define aes_context t_name(ctx)

t_name(rval) c_name(set_key)(t_name(ctx) *cx, const t_name(byte) key[], const t_name(word) n_bytes, const enum t_name(mode) f);
t_name(rval) c_name(encrypt)(t_name(ctx) *cx, const t_name(byte) in_blk[], t_name(byte) out_blk[]);
t_name(rval) c_name(decrypt)(t_name(ctx) *cx, const t_name(byte) in_blk[], t_name(byte) out_blk[]);
t_name(rval) c_name(set_blk)(t_name(ctx) *cx, const t_name(word) n_bytes);

#if defined(__cplusplus)
}
#endif

#endif
