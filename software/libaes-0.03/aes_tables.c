/* $Id: aes_tables.c,v 1.4 2002/01/15 18:12:42 cvs Exp $ */

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
 * - this file contains the code to generate the aes
 *   tables - either statically or dynamically
 *
 */


#include <sys/types.h>
#include "aes.h"
#include "aes_options.h"

/* the finite field modular polynomial and elements */

#define ff_poly 0x011b
#define ff_hi   0x80

/* multiply four bytes in GF(2^8) by 'x' {02} in parallel */

#define m1  0x80808080
#define m2  0x7f7f7f7f
#define m3  0x0000001b
#define FFmulX(x)  ((((x) & m2) << 1) ^ ((((x) & m1) >> 7) * m3))

 /* 
   The following defines provide alternative definitions of FFmulX that might
   give improved performance if a fast 32-bit multiply is not available. Note
   that a temporary variable u needs to be defined where FFmulX is used.

#define FFmulX(x) (u = (x) & m1, u |= (u >> 1), ((x) & m2) << 1) ^ ((u >> 3) | (u >> 6)) 
#define m4  0x1b1b1b1b
#define FFmulX(x) (u = (x) & m1, ((x) & m2) << 1) ^ ((u - (u >> 7)) & m4) 

 */

#if defined(FIXED_TABLES)

#include "aestab.h"

#else

static t_name(word)  rcon_tab[AES_RC_LENGTH];

#if !defined(AES_DECRYPT_ONLY)

#if defined(ONE_TABLE)
static t_name(word)  ft_tab[256];
#elif defined(FOUR_TABLES)
static t_name(word)  ft_tab[4][256];
#else
static t_name(byte)  s_box[256];
#define SBOX
#endif

#if defined(ONE_LR_TABLE)
static t_name(word)  fl_tab[256];
#elif defined(FOUR_LR_TABLES)
static t_name(word)  fl_tab[4][256];
#elif !defined(SBOX)
static t_name(byte)  s_box[256];
#define SBOX
#endif

#endif

#if !defined(AES_ENCRYPT_ONLY)

#if defined(ONE_TABLE)
static t_name(word)  it_tab[256];
#elif defined(FOUR_TABLES)
static t_name(word)  it_tab[4][256];
#else
static t_name(byte)  inv_s_box[256];
#define ISBOX
#endif

#if defined(ONE_LR_TABLE)
static t_name(word)  il_tab[256];
#elif defined(FOUR_LR_TABLES)
static t_name(word)  il_tab[4][256];
#elif !defined(ISBOX)
static t_name(byte)  inv_s_box[256];
#define ISBOX
#endif

#if defined(AES_DECRYPT_ONLY)
#if defined(ONE_LR_TABLE)
static t_name(word)  fl_tab[256];
#elif defined(FOUR_LR_TABLES)
static t_name(word)  fl_tab[4][256];
#elif !defined(SBOX)
static t_name(byte)  s_box[256];
#define SBOX
#endif
#endif

#endif

#if defined(ONE_FM_TABLE)
t_name(word)  fm_tab[256];
#elif defined(FOUR_FM_TABLES)
t_name(word)  fm_tab[4][256];
#endif

#if defined(ONE_IM_TABLE)
t_name(word)  im_tab[256];
#elif defined(FOUR_IM_TABLES)
t_name(word)  im_tab[4][256];
#endif

#if !defined(FF_TABLES)

/*
   Generate the tables for the dynamic table option

   It will generally be sensible to use tables to compute finite 
   field multiplies and inverses but where memory is scarse this 
   code might sometimes be better.

   return 2 ^ (n - 1) where n is the bit number of the highest bit
   set in x with x in the range 1 < x < 0x00000200.   This form is
   used so that locals within FFinv can be bytes rather than words
*/

static t_name(byte) hibit(const t_name(word) x)
{   t_name(byte) r = (t_name(byte))((x >> 1) | (x >> 2));
    
    r |= (r >> 2);
    r |= (r >> 4);
    return (r + 1) >> 1;
}

/* return the inverse of the finite field element x */

static t_name(byte) FFinv(const t_name(byte) x)
{   t_name(byte)    p1 = x, p2 = 0x1b, n1 = hibit(x), n2 = 0x80, v1 = 1, v2 = 0;

    if(x < 2) return x;

    for(;;)
    {
        if(!n1) return v1;

        while(n2 >= n1)
        {   
            n2 /= n1; p2 ^= p1 * n2; v2 ^= v1 * n2; n2 = hibit(p2);
        }
        
        if(!n2) return v2;

        while(n1 >= n2)
        {   
            n1 /= n2; p1 ^= p2 * n1; v1 ^= v2 * n1; n1 = hibit(p1);
        }
    }
}

/* define the finite field multiplies required for Rijndael */

#define FFmul02(x)  ((((x) & 0x7f) << 1) ^ ((x) & 0x80 ? 0x1b : 0))
#define FFmul03(x)  ((x) ^ FFmul02(x))
#define FFmul09(x)  ((x) ^ FFmul02(FFmul02(FFmul02(x))))
#define FFmul0b(x)  ((x) ^ FFmul02((x) ^ FFmul02(FFmul02(x))))
#define FFmul0d(x)  ((x) ^ FFmul02(FFmul02((x) ^ FFmul02(x))))
#define FFmul0e(x)  FFmul02((x) ^ FFmul02((x) ^ FFmul02(x)))

#else

#define FFinv(x)    ((x) ? pow[255 - log[x]]: 0)

#define FFmul02(x) (x ? pow[log[x] + 0x19] : 0)
#define FFmul03(x) (x ? pow[log[x] + 0x01] : 0)
#define FFmul09(x) (x ? pow[log[x] + 0xc7] : 0)
#define FFmul0b(x) (x ? pow[log[x] + 0x68] : 0)
#define FFmul0d(x) (x ? pow[log[x] + 0xee] : 0)
#define FFmul0e(x) (x ? pow[log[x] + 0xdf] : 0)

#endif

/* The forward and inverse affine transformations used in the S-box */

#define fwd_affine(x) \
    (w = (t_name(word))x, w ^= (w<<1)^(w<<2)^(w<<3)^(w<<4), 0x63^(t_name(byte))(w^(w>>8)))

#define inv_affine(x) \
    (w = (t_name(word))x, w = (w<<1)^(w<<3)^(w<<6), 0x05^(t_name(byte))(w^(w>>8)))

static void gen_tabs(void)
{   t_name(word)  i, w;

#if defined(FF_TABLES)

    t_name(byte)  pow[512], log[256];

    /*
       log and power tables for GF(2^8) finite field with
       0x011b as modular polynomial - the simplest primitive
       root is 0x03, used here to generate the tables
    */

    i = 0; w = 1; 
    do
    {   
        pow[i] = (t_name(byte))w;
        pow[i + 255] = (t_name(byte))w;
        log[w] = (t_name(byte))i++;
        w ^=  (w << 1) ^ (w & ff_hi ? ff_poly : 0);
    }
    while (w != 1);

#endif

    for(i = 0, w = 1; i < AES_RC_LENGTH; ++i)
    {
        rcon_tab[i] = bytes2word(w, 0, 0, 0);
        w = (w << 1) ^ (w & ff_hi ? ff_poly : 0);
    }

    for(i = 0; i < 256; ++i)
    {   t_name(byte)    b;

        b = fwd_affine(FFinv((t_name(byte))i));
        w = bytes2word(FFmul02(b), b, b, FFmul03(b));

#if defined(ONE_FM_TABLE)       /* tables for the mix column operation */
        fm_tab[b] = w;          /* (not currently used) */
#elif defined(FOUR_FM_TABLES)
        fm_tab[0][b] = w;
        fm_tab[1][b] = upr(w,1);
        fm_tab[2][b] = upr(w,2);
        fm_tab[3][b] = upr(w,3);
#endif

#if !defined(AES_DECRYPT_ONLY)
#if defined(SBOX)
        s_box[i] = b;
#endif
#if defined(ONE_TABLE)          /* tables for a normal encryption round */
        ft_tab[i] = w;
#elif defined(FOUR_TABLES)
        ft_tab[0][i] = w;
        ft_tab[1][i] = upr(w,1);
        ft_tab[2][i] = upr(w,2);
        ft_tab[3][i] = upr(w,3);
#endif
#endif
        w = bytes2word(b, 0, 0, 0);
#if defined(ONE_LR_TABLE)       /* tables for last encryption round (may also
				 * be used in the decryption key schedule) */
        fl_tab[i] = w;
#elif defined(FOUR_LR_TABLES)
        fl_tab[0][i] = w;
        fl_tab[1][i] = upr(w,1);
        fl_tab[2][i] = upr(w,2);
        fl_tab[3][i] = upr(w,3);
#endif

        b = FFinv(inv_affine((t_name(byte))i));
        w = bytes2word(FFmul0e(b), FFmul09(b), FFmul0d(b), FFmul0b(b));

#if defined(ONE_IM_TABLE)       /* tables for the inverse mix column operation */
        im_tab[b] = w;
#elif defined(FOUR_IM_TABLES)
        im_tab[0][b] = w;
        im_tab[1][b] = upr(w,1);
        im_tab[2][b] = upr(w,2);
        im_tab[3][b] = upr(w,3);
#endif

#if !defined(AES_ENCRYPT_ONLY)
#if defined(ISBOX)
        inv_s_box[i] = b;
#endif
#if defined(ONE_TABLE)          /* tables for a normal decryption round */
        it_tab[i] = w;
#elif defined(FOUR_TABLES)
        it_tab[0][i] = w;
        it_tab[1][i] = upr(w,1);
        it_tab[2][i] = upr(w,2);
        it_tab[3][i] = upr(w,3);
#endif
        w = bytes2word(b, 0, 0, 0);
#if defined(ONE_LR_TABLE)           /* tables for last decryption round */
        il_tab[i] = w;
#elif defined(FOUR_LR_TABLES)
        il_tab[0][i] = w;
        il_tab[1][i] = upr(w,1);
        il_tab[2][i] = upr(w,2);
        il_tab[3][i] = upr(w,3);
#endif
#endif
    }
}

#endif
