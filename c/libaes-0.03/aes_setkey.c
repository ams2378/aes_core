/* $Id: aes_setkey.c,v 1.4 2002/01/15 18:12:42 cvs Exp $ */

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
 * - this file contains aes set_blk & set_key functions and
 *   supporting declarations only. 
 * - moved context to be first argument
 *
 */

#include <sys/types.h>
#include "aes.h"
#include "aes_options.h"

#if !defined(AES_BLOCK_SIZE)

t_name(rval) c_name(set_blk)(t_name(ctx), *cx, const t_name(word) n_bytes)
{
#if !defined(FIXED_TABLES)
    if(!(cx->sflg & 0x08)) { gen_tabs(); cx->sflg = 0x08; }
#endif

    if((n_bytes & 7) || n_bytes < 16 || n_bytes > 32) 
    {     
        return (n_bytes ? cx->sflg &= ~0x07, aes_bad : (t_name(rval))(nc << 2));
    }

    cx->sflg = cx->sflg & ~0x07 | 0x04;
    nc = n_bytes >> 2;
    return aes_good;
}

#endif

#if (defined(ONE_TABLE) || defined(FOUR_TABLES)) && !defined(AES_ENCRYPT_ONLY) 

void c_name(convert_key)(t_name(ctx) *cx)
{   t_name(word)    i;
    dec_imvars
    for(i = nc; i < nc * cx->Nrnd; ++i)
        cx->d_key[i] = inv_mcol(cx->d_key[i]);
}


#define ff(x)   inv_mcol(x)

#else

#define c_name(convert_key)(x)
#define ff(x)   (x)
#undef  dec_imvars
#define dec_imvars

#endif

 /*
   Initialise the key schedule from the user supplied key. The key
   length is now specified in bytes - 16, 24 or 32 as appropriate.
   This corresponds to bit lengths of 128, 192 and 256 bits, and
   to Nk values of 4, 6 and 8 respectively.

   The following macros implement a single cycle in the key 
   schedule generation process. The number of cycles needed 
   for each nc and nk value is:
 
    nk =      4  5  6  7  8
    -----------------------
    nc = 4   10  9  8  7  7
    nc = 5   14 11 10  9  9
    nc = 6   19 15 12 11 11
    nc = 7   21 19 16 13 14
    nc = 8   29 23 19 17 14
 */

#define ke4(k,i) \
{   k[4*(i)+4] = ss[0] ^= ls_box(ss[3],3) ^ rcon_tab[i]; k[4*(i)+5] = ss[1] ^= ss[0]; \
    k[4*(i)+6] = ss[2] ^= ss[1]; k[4*(i)+7] = ss[3] ^= ss[2]; \
}
#define kel4(k,i) \
{   k[4*(i)+4] = ss[0] ^= ls_box(ss[3],3) ^ rcon_tab[i]; k[4*(i)+5] = ss[1] ^= ss[0]; \
    k[4*(i)+6] = ss[2] ^= ss[1]; k[4*(i)+7] = ss[3] ^= ss[2]; \
}

#define ke6(k,i) \
{   k[6*(i)+ 6] = ss[0] ^= ls_box(ss[5],3) ^ rcon_tab[i]; k[6*(i)+ 7] = ss[1] ^= ss[0]; \
    k[6*(i)+ 8] = ss[2] ^= ss[1]; k[6*(i)+ 9] = ss[3] ^= ss[2]; \
    k[6*(i)+10] = ss[4] ^= ss[3]; k[6*(i)+11] = ss[5] ^= ss[4]; \
}
#define kel6(k,i) \
{   k[6*(i)+ 6] = ss[0] ^= ls_box(ss[5],3) ^ rcon_tab[i]; k[6*(i)+ 7] = ss[1] ^= ss[0]; \
    k[6*(i)+ 8] = ss[2] ^= ss[1]; k[6*(i)+ 9] = ss[3] ^= ss[2]; \
}

#define ke8(k,i) \
{   k[8*(i)+ 8] = ss[0] ^= ls_box(ss[7],3) ^ rcon_tab[i]; k[8*(i)+ 9] = ss[1] ^= ss[0]; \
    k[8*(i)+10] = ss[2] ^= ss[1]; k[8*(i)+11] = ss[3] ^= ss[2]; \
    k[8*(i)+12] = ss[4] ^= ls_box(ss[3],0); k[8*(i)+13] = ss[5] ^= ss[4]; \
    k[8*(i)+14] = ss[6] ^= ss[5]; k[8*(i)+15] = ss[7] ^= ss[6]; \
}
#define kel8(k,i) \
{   k[8*(i)+ 8] = ss[0] ^= ls_box(ss[7],3) ^ rcon_tab[i]; k[8*(i)+ 9] = ss[1] ^= ss[0]; \
    k[8*(i)+10] = ss[2] ^= ss[1]; k[8*(i)+11] = ss[3] ^= ss[2]; \
}

#if 1
#define kdf4(k,i) \
{   ss[0] = ss[0] ^ ss[2] ^ ss[1] ^ ss[3]; ss[1] = ss[1] ^ ss[3]; ss[2] = ss[2] ^ ss[3]; ss[3] = ss[3]; \
	ss[4] = ls_box(ss[(i+3) % 4], 3) ^ rcon_tab[i]; ss[i % 4] ^= ss[4]; \
	ss[4] ^= k[4*(i)];   k[4*(i)+4] = ff(ss[4]); ss[4] ^= k[4*(i)+1]; k[4*(i)+5] = ff(ss[4]); \
    ss[4] ^= k[4*(i)+2]; k[4*(i)+6] = ff(ss[4]); ss[4] ^= k[4*(i)+3]; k[4*(i)+7] = ff(ss[4]); \
}
#define kd4(k,i) \
{	ss[4] = ls_box(ss[(i+3) % 4], 3) ^ rcon_tab[i]; ss[i % 4] ^= ss[4]; ss[4] = ff(ss[4]); \
	k[4*(i)+4] = ss[4] ^= k[4*(i)]; k[4*(i)+5] = ss[4] ^= k[4*(i)+1]; \
    k[4*(i)+6] = ss[4] ^= k[4*(i)+2]; k[4*(i)+7] = ss[4] ^= k[4*(i)+3]; \
}
#define kdl4(k,i) \
{	ss[4] = ls_box(ss[(i+3) % 4], 3) ^ rcon_tab[i]; ss[i % 4] ^= ss[4]; \
	k[4*(i)+4] = (ss[0] ^= ss[1]) ^ ss[2] ^ ss[3]; k[4*(i)+5] = ss[1] ^ ss[3]; \
    k[4*(i)+6] = ss[0]; k[4*(i)+7] = ss[1]; \
}
#else
#define kdf4(k,i) \
{   ss[0] ^= ls_box(ss[3],3) ^ rcon_tab[i]; k[4*(i)+ 4] = ff(ss[0]); ss[1] ^= ss[0]; k[4*(i)+ 5] = ff(ss[1]); \
    ss[2] ^= ss[1]; k[4*(i)+ 6] = ff(ss[2]); ss[3] ^= ss[2]; k[4*(i)+ 7] = ff(ss[3]); \
}
#define kd4(k,i) \
{   ss[4] = ls_box(ss[3],3) ^ rcon_tab[i]; \
    ss[0] ^= ss[4]; ss[4] = ff(ss[4]); k[4*(i)+ 4] = ss[4] ^= k[4*(i)]; \
    ss[1] ^= ss[0]; k[4*(i)+ 5] = ss[4] ^= k[4*(i)+ 1]; \
    ss[2] ^= ss[1]; k[4*(i)+ 6] = ss[4] ^= k[4*(i)+ 2]; \
    ss[3] ^= ss[2]; k[4*(i)+ 7] = ss[4] ^= k[4*(i)+ 3]; \
}
#define kdl4(k,i) \
{   ss[0] ^= ls_box(ss[3],3) ^ con_tab[i]; k[4*(i)+ 4] = ss[0]; ss[1] ^= ss[0]; k[4*(i)+ 5] = ss[1]; \
    ss[2] ^= ss[1]; k[4*(i)+ 6] = ss[2]; ss[3] ^= ss[2]; k[4*(i)+ 7] = ss[3]; \
}
#endif

#define kdf6(k,i) \
{   ss[0] ^= ls_box(ss[5],3) ^ rcon_tab[i]; k[6*(i)+ 6] = ff(ss[0]); ss[1] ^= ss[0]; k[6*(i)+ 7] = ff(ss[1]); \
    ss[2] ^= ss[1]; k[6*(i)+ 8] = ff(ss[2]); ss[3] ^= ss[2]; k[6*(i)+ 9] = ff(ss[3]); \
    ss[4] ^= ss[3]; k[6*(i)+10] = ff(ss[4]); ss[5] ^= ss[4]; k[6*(i)+11] = ff(ss[5]); \
}
#define kd6(k,i) \
{   ss[6] = ls_box(ss[5],3) ^ rcon_tab[i]; \
    ss[0] ^= ss[6]; ss[6] = ff(ss[6]); k[6*(i)+ 6] = ss[6] ^= k[6*(i)]; \
    ss[1] ^= ss[0]; k[6*(i)+ 7] = ss[6] ^= k[6*(i)+ 1]; \
    ss[2] ^= ss[1]; k[6*(i)+ 8] = ss[6] ^= k[6*(i)+ 2]; \
    ss[3] ^= ss[2]; k[6*(i)+ 9] = ss[6] ^= k[6*(i)+ 3]; \
    ss[4] ^= ss[3]; k[6*(i)+10] = ss[6] ^= k[6*(i)+ 4]; \
    ss[5] ^= ss[4]; k[6*(i)+11] = ss[6] ^= k[6*(i)+ 5]; \
}
#define kdl6(k,i) \
{   ss[0] ^= ls_box(ss[5],3) ^ rcon_tab[i]; k[6*(i)+ 6] = ss[0]; ss[1] ^= ss[0]; k[6*(i)+ 7] = ss[1]; \
    ss[2] ^= ss[1]; k[6*(i)+ 8] = ss[2]; ss[3] ^= ss[2]; k[6*(i)+ 9] = ss[3]; \
}

#define kdf8(k,i) \
{   ss[0] ^= ls_box(ss[7],3) ^ rcon_tab[i]; k[8*(i)+ 8] = ff(ss[0]); ss[1] ^= ss[0]; k[8*(i)+ 9] = ff(ss[1]); \
    ss[2] ^= ss[1]; k[8*(i)+10] = ff(ss[2]); ss[3] ^= ss[2]; k[8*(i)+11] = ff(ss[3]); \
    ss[4] ^= ls_box(ss[3],0); k[8*(i)+12] = ff(ss[4]); ss[5] ^= ss[4]; k[8*(i)+13] = ff(ss[5]); \
    ss[6] ^= ss[5]; k[8*(i)+14] = ff(ss[6]); ss[7] ^= ss[6]; k[8*(i)+15] = ff(ss[7]); \
}
#define kd8(k,i) \
{   t_name(word) g = ls_box(ss[7],3) ^ rcon_tab[i]; \
    ss[0] ^= g; g = ff(g); k[8*(i)+ 8] = g ^= k[8*(i)]; \
    ss[1] ^= ss[0]; k[8*(i)+ 9] = g ^= k[8*(i)+ 1]; \
    ss[2] ^= ss[1]; k[8*(i)+10] = g ^= k[8*(i)+ 2]; \
    ss[3] ^= ss[2]; k[8*(i)+11] = g ^= k[8*(i)+ 3]; \
    g = ls_box(ss[3],0); \
    ss[4] ^= g; g = ff(g); k[8*(i)+12] = g ^= k[8*(i)+ 4]; \
    ss[5] ^= ss[4]; k[8*(i)+13] = g ^= k[8*(i)+ 5]; \
    ss[6] ^= ss[5]; k[8*(i)+14] = g ^= k[8*(i)+ 6]; \
    ss[7] ^= ss[6]; k[8*(i)+15] = g ^= k[8*(i)+ 7]; \
}
#define kdl8(k,i) \
{   ss[0] ^= ls_box(ss[7],3) ^ rcon_tab[i]; k[8*(i)+ 8] = ss[0]; ss[1] ^= ss[0]; k[8*(i)+ 9] = ss[1]; \
    ss[2] ^= ss[1]; k[8*(i)+10] = ss[2]; ss[3] ^= ss[2]; k[8*(i)+11] = ss[3]; \
}

t_name(rval) c_name(set_key)(t_name(ctx) *cx, const t_name(byte) in_key[], const t_name(word) n_bytes, const enum t_name(mode) f)
{   t_name(word)	ss[8]; 
	dec_imvars

#if !defined(FIXED_TABLES)
    if(!(cx->sflg & 0x08)) { gen_tabs(); cx->sflg = 0x08; }
#endif

#if !defined(AES_BLOCK_SIZE)
    if(!(cx->sflg & 0x04)) c_name(set_blk)(16, cx);
#endif

#if defined(AES_DUAL_KEY_SCHEDULE)
    if(!(f & 3))
#else
    if(!(f & 3) && (f & 3) == 3)
#endif
        return aes_bad;

	cx->sflg = ((cx->sflg & ~0x03) |
#if(AES_ENCRYPT_ONLY)
		1);
#elif(AES_DECRYPT_ONLY)
		2);
#else
		(f & 3));
#endif

#if !defined(AES_DECRYPT_ONLY)

    if((cx->sflg & 1))
    {	
        cx->e_key[0] = ss[0] = word_in(in_key     );
        cx->e_key[1] = ss[1] = word_in(in_key +  4);
        cx->e_key[2] = ss[2] = word_in(in_key +  8);
        cx->e_key[3] = ss[3] = word_in(in_key + 12);

#if defined(UNROLL) && (AES_BLOCK_SIZE == 16)

        switch(n_bytes)
        {
        case 16: ke4(cx->e_key, 0); ke4(cx->e_key, 1); 
                 ke4(cx->e_key, 2); ke4(cx->e_key, 3);
                 ke4(cx->e_key, 4); ke4(cx->e_key, 5); 
                 ke4(cx->e_key, 6); ke4(cx->e_key, 7);
                 ke4(cx->e_key, 8); kel4(cx->e_key, 9); 
                 cx->Nkey = 4; cx->Nrnd = 10; break;
        case 24: cx->e_key[4] = ss[4] = word_in(in_key + 16);
                 cx->e_key[5] = ss[5] = word_in(in_key + 20);
                 ke6(cx->e_key, 0); ke6(cx->e_key, 1); 
                 ke6(cx->e_key, 2); ke6(cx->e_key, 3);
                 ke6(cx->e_key, 4); ke6(cx->e_key, 5); 
                 ke6(cx->e_key, 6); kel6(cx->e_key, 7); 
                 cx->Nkey = 6; cx->Nrnd = 12; break;
        case 32: cx->e_key[4] = ss[4] = word_in(in_key + 16);
                 cx->e_key[5] = ss[5] = word_in(in_key + 20);
                 cx->e_key[6] = ss[6] = word_in(in_key + 24);
                 cx->e_key[7] = ss[7] = word_in(in_key + 28);
                 ke8(cx->e_key, 0); ke8(cx->e_key, 1); 
                 ke8(cx->e_key, 2); ke8(cx->e_key, 3);
                 ke8(cx->e_key, 4); ke8(cx->e_key, 5); 
                 kel8(cx->e_key, 6); 
                 cx->Nkey = 8; cx->Nrnd = 14; break;
        case  0: return (t_name(rval))(cx->Nkey << 2);
        default: cx->sflg &= ~0x03; return aes_bad; 
        }
#else
        {   t_name(word) i, l;
            cx->Nkey = n_bytes >> 2; 
            cx->Nrnd = (cx->Nkey > nc ? cx->Nkey : nc) + 6;
            l = (nc * cx->Nrnd + nc - 1) / cx->Nkey;

            switch(n_bytes)
            {
            case 16: for(i = 0; i < l; ++i)
                         ke4(cx->e_key, i);
                     break;
            case 24: cx->e_key[4] = ss[4] = word_in(in_key + 16);
                     cx->e_key[5] = ss[5] = word_in(in_key + 20);
                     for(i = 0; i < l; ++i)
                         ke6(cx->e_key, i);
                     break;
            case 32: cx->e_key[4] = ss[4] = word_in(in_key + 16);
                     cx->e_key[5] = ss[5] = word_in(in_key + 20);
                     cx->e_key[6] = ss[6] = word_in(in_key + 24);
                     cx->e_key[7] = ss[7] = word_in(in_key + 28);
                     for(i = 0; i < l; ++i)
                         ke8(cx->e_key,  i);
                     break;
            case  0: return (t_name(rval))(cx->Nkey << 2);
            default: cx->sflg &= ~0x03; return aes_bad; 
            }
        }
#endif
    }

#endif

#if !defined(AES_ENCRYPT_ONLY)

    if(cx->sflg & 2)
    {	
		cx->d_key[0] = ss[0] = word_in(in_key     );
        cx->d_key[1] = ss[1] = word_in(in_key +  4);
        cx->d_key[2] = ss[2] = word_in(in_key +  8);
        cx->d_key[3] = ss[3] = word_in(in_key + 12);

#if (AES_BLOCK_SIZE == 16) && defined(UNROLL)

        switch(n_bytes)
        {
        case 16: kdf4(cx->d_key, 0); kd4(cx->d_key, 1); 
                 kd4(cx->d_key, 2); kd4(cx->d_key, 3);
                 kd4(cx->d_key, 4); kd4(cx->d_key, 5); 
                 kd4(cx->d_key, 6); kd4(cx->d_key, 7);
                 kd4(cx->d_key, 8); kdl4(cx->d_key, 9); 
                 cx->Nkey = 4; cx->Nrnd = 10; break;
        case 24: cx->d_key[4] = ff(ss[4] = word_in(in_key + 16));
                 cx->d_key[5] = ff(ss[5] = word_in(in_key + 20));
                 kdf6(cx->d_key, 0); kd6(cx->d_key, 1); 
                 kd6(cx->d_key, 2); kd6(cx->d_key, 3);
                 kd6(cx->d_key, 4); kd6(cx->d_key, 5); 
                 kd6(cx->d_key, 6); kdl6(cx->d_key, 7); 
                 cx->Nkey = 6; cx->Nrnd = 12; break;
        case 32: cx->d_key[4] = ff(ss[4] = word_in(in_key + 16));
                 cx->d_key[5] = ff(ss[5] = word_in(in_key + 20));
                 cx->d_key[6] = ff(ss[6] = word_in(in_key + 24));
                 cx->d_key[7] = ff(ss[7] = word_in(in_key + 28));
                 kdf8(cx->d_key, 0); kd8(cx->d_key, 1); 
                 kd8(cx->d_key, 2); kd8(cx->d_key, 3);
                 kd8(cx->d_key, 4); kd8(cx->d_key, 5); 
                 kdl8(cx->d_key, 6); 
                 cx->Nkey = 8; cx->Nrnd = 14; break;
        case  0: return (t_name(rval))(cx->Nkey << 2);
        default: cx->sflg &= ~0x03; return aes_bad; 
        }
#else
        {   t_name(word) i, l;
            cx->Nkey = n_bytes >> 2; 
            cx->Nrnd = (cx->Nkey > nc ? cx->Nkey : nc) + 6;
            l = (nc * cx->Nrnd + nc - 1) / cx->Nkey;

            switch(n_bytes)
            {
            case 16: 
					 for(i = 0; i < l; ++i)
                         ke4(cx->d_key, i);
                     break;
            case 24: cx->d_key[4] = ss[4] = word_in(in_key + 16);
                     cx->d_key[5] = ss[5] = word_in(in_key + 20);
                     for(i = 0; i < l; ++i)
                         ke6(cx->d_key, i);
                     break;
            case 32: cx->d_key[4] = ss[4] = word_in(in_key + 16);
                     cx->d_key[5] = ss[5] = word_in(in_key + 20);
                     cx->d_key[6] = ss[6] = word_in(in_key + 24);
                     cx->d_key[7] = ss[7] = word_in(in_key + 28);
                     for(i = 0; i < l; ++i)
                         ke8(cx->d_key,  i);
                     break;
            case  0: return (t_name(rval))(cx->Nkey << 2);
            default: cx->sflg &= ~0x03; return aes_bad; 
            }

            c_name(convert_key)(cx);
        }
#endif
    }

#endif

    return aes_good;
}
