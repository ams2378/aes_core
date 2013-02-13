/* $Id: aes_options.h,v 1.3 2002/01/11 18:13:27 cvs Exp $ */

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
 * - this file contains the AES compile options and
 *   supporting declarations needed to build libaes (not use it).
 * - content taken from the original aes.h and aes.c
 *
 */


#ifndef _AES_OPTIONS_H
#define _AES_OPTIONS_H

/*
   1. OPERATION
 
   These source code files implement the AES algorithm Rijndael designed by
   Joan Daemen and Vincent Rijmen. The version in aes.c is designed for 
   block and key sizes of 128, 192 and 256 bits (16, 24 and 32 bytes) while 
   that in aespp.c provides for block and keys sizes of 128, 160, 192, 224 
   and 256 bits (16, 20, 24, 28 and 32 bytes).  This file is a common header 
   file for these two implementations and for aesref.c, which is a reference 
   implementation.
   
   This version is designed for flexibility and speed using operations on
   32-bit words rather than operations on bytes.  It provides aes_both fixed 
   and  dynamic block and key lengths and can also run with either big or 
   little endian internal byte order (see aes.h).  It inputs block and key 
   lengths in bytes with the legal values being  16, 24 and 32 for aes.c and 
   16, 20, 24, 28 and 32 for aespp.c
 
   2. THE CIPHER INTERFACE

   byte                 (an unsigned 8-bit type)
   word                 (an unsigned 32-bit type)
   rval:                (a signed 16 bit type for function return values)
        aes_good            (value != 0, a good return)
        aes_bad             (value == 0, an error return)
   enum mode:           (encryption direction)
        aes_enc             (set the key for encryption)
        aes_dec             (set the key for decryption)
        aes_both            (set the key for aes_both)
   class or struct ctx  (structure for the cipher context)

   A facility exists to allow these type names and the following C subroutine 
   names to be modified with specified prefixes to avoid naming conflicts. 

   C subroutine calls:

   rval set_blk(const word block_length, ctx *cx)  (variable block size)
   rval set_key(const byte key[], const word key_length,
                   const enum mode direction, ctx *cx)
   rval encrypt(const byte input_blk[], byte output_blk[], const ctx *cx)
   rval decrypt(const byte input_blk[], byte output_blk[], const ctx *cx)

   IMPORTANT NOTE: If you are using this C interface and your compiler does 
   not set the memory used for objects to zero before use, you will need to 
   ensure that cx.sflg is set to zero before using the C subroutine calls.

   C++ aes class subroutines:

   rval set_blk(const word block_length)  (variable block size)
   rval set_key(const byte key[], const word key_length,
                   const mode direction)
   rval encrypt(const byte input_blk[], byte output_blk[]) const
   rval decrypt(const byte input_blk[], byte output_blk[]) const

   The block length inputs to set_block and set_key are in numbers of
   BYTES, not bits.  The calls to subroutines must be made in the above 
   order but multiple calls can be made without repeating earlier calls
   if their parameters have not changed. If the cipher block length is
   variable but set_blk has not been called before cipher operations a
   value of 16 is assumed (that is, the AES block size). In contrast to 
   earlier versions the block and key length parameters are now checked
   for correctness and the encryption and decryption routines check to 
   ensure that an appropriate key has been set before they are called.

   3. BYTE ORDER WITHIN 32 BIT WORDS

   The fundamental data processing units in Rijndael are 8-bit bytes. The 
   input, the output and the key input are all enumerated arrays of bytes 
   in which bytes are numbered starting at zero and increasing to one less
   than the number of bytes in the array in question.  When these inputs 
   and outputs are considered as bit sequences, the n'th byte contains 
   bits 8n to 8n+7 of the sequence with the lower numbered bit mapped to 
   the least significant bit within the  byte (i.e. that having a numeric 
   value of 1).  
   
   However, Rijndael can be implemented more efficiently using 32-bit words 
   to process 4 bytes at a time provided that the order of bytes within such 
   words is specified. This order is called big-endian if the lowest numbered
   bytes in words have the highest numeric significance and little-endian if 
   the opposite applies. This code can work in either order irrespective of 
   the order used by the machine on which it runs.  The internal byte order 
   used is set by defining INTERNAL_BYTE_ORDER whereas the external order for 
   all inputs and outputs is assumed to be the order of the machine on which 
   the code is running as set by PLATFORM_BYTE_ORDER.  The only purpose of 
   the latter is to determine if a byte order change is needed immediately 
   after input and immediately before output to account for the use of a 
   different internal byte order within the algorithm.  

#define INTERNAL_BYTE_ORDER AES_LITTLE_ENDIAN
#define PLATFORM_BYTE_ORDER AES_LITTLE_ENDIAN

   In some situations specifying a byte order that differs from that of the 
   platform may cause memory alignment problems. The PACKED_IO option is 
   available to overcome such problems if they arise. When PACKED_IO is 
   defined, byte arrays at the cipher interfaces are converted into 32 bit 
   words without assuming that byte arrays can be addressed as if they were
   arrays of 32-bit words. Otherwise it is assumed that byte arrays can be 
   addressed as 32-bit word arrays without causing problems.

#define PACKED_IO

   6. CONFIGURATION OPTIONS (see also aes.c)

   a. define AES_BLOCK_SIZE to set the cipher block size (16, 24 or 32) or
      leave this undefined for dynamically variable block size (this will
      result in much slower code).
   b. set AES_IN_CPP to use the code from C++ rather than C
   c. set AES_DLL if AES (Rijndael) is to be compiled to a DLL
   d. set INTERNAL_BYTE_ORDER to one of the above constants to set the
      internal byte order (the order used within the algorithm code)
   e. set PALTFORM_BYTE_ORDER to one of the above constants to set the byte
      order used at the external interfaces for the input, output and key
      byte arrays.

   a.  Define UNROLL for full loop unrolling in encryption and decryption.
   b.  Define PARTIAL_UNROLL to unroll two loops in encryption and decryption.
   c.  Define FIXED_TABLES for compiled rather than dynamic tables.
   d.  Define FF_TABLES to use tables for field multiplies and inverses.
   e.  Define ARRAYS to use arrays to hold the local state block. If this
       is not defined, individually declared 32-bit words are used.
   f.  Define FAST_VARIABLE if a high speed variable block implementation
       is needed (essentially three separate fixed block size code sequences)
   g.  Define either ONE_TABLE or FOUR_TABLES for a fast table driven 
       version using 1 table (2 kbytes of table space) or 4 tables (8
       kbytes of table space) for higher speed.
   h.  Define either ONE_LR_TABLE or FOUR_LR_TABLES for a further speed 
       increase by using tables for the last rounds but with more table
       space (2 or 8 kbytes extra).
   i.  If neither ONE_TABLE nor FOUR_TABLES is defined, a compact but 
       slower version is provided.
   j.  If fast decryption key scheduling is needed define ONE_IM_TABLE
       or FOUR_IM_TABLES for higher speed (2 or 8 kbytes extra).

   IMPORTANT NOTE: AES_BLOCK_SIZE is in BYTES: 16, 24, 32 or undefined for aes.c
   and 16, 20, 24, 28, 32 or undefined for aespp.c.  If left undefined a 
   slower version providing variable block length is compiled   

#define AES_BLOCK_SIZE  16

   Define AES_IN_CPP if you intend to use the AES C++ class rather than the
   C code directly.

#define AES_IN_CPP

   Define AES_DLL if you wish to compile the code to produce a Windows DLL

#define AES_DLL

   In C code a prefix can be added to the names of cipher subroutines that 
   are normally 'set_blk', 'set_key', 'encrypt' and 'decrypt'.  Hence if 
   AES_NAME_PREFIX is defined its value will be prefixed to each name so that,
   for example:

#define AES_NAME_PREFIX aes_

   will change these subroutine names to: 'aes_set_blk', 'aes_set_key', 
   'aes_encrypt' and 'aes_decrypt'.
 
   In C++ the class subroutine names will be not be prefixed but the C++ code
   will make use of calls to C subroutines using the prefixed names. In this 
   case if a prefix is not defined by the user, a prefix of 'aes_' is used.

   In both C and C++ a prefix can be added to the defined type names: 'byte', 
   'word', 'rval', 'mode' and (in C only) to the structure name 'ctx'. Hence 
   if AES_TYPE_PREFIX is defined its value will be prefixed to each name so that,
   for example:
    
#define AES_TYPE_PREFIX aes_

   will change these names to 'aes_byte', 'aes_word', 'aes_rval', 'aes_mode'
   and 'aes_ctx'.

   define ENCRYPT_ONLY if decryption is not required
   define DECRYPT_ONLY if encryption is not required

#define ENCRYPT_ONLY
#define DECRYPT_ONLY

   define AES_DUAL_KEY_SCHEDULE if both encryption and decryption are required for the
   same key (this allocates separate memory for both the encryption and decryption 
   key schedules). Note that the assembler version requires a dual key schedule.

#define AES_DUAL_KEY_SCHEDULE


   3. USE OF DEFINES
  
   NOTE: some combinations of the following defines are disabled below.

   UNROLL or PARTIAL_UNROLL control the extent to which loops are unrolled
   in the main encryption and decryption routines. UNROLL does a complete
   unroll while PARTIAL_UNROLL uses a loop with two rounds in it.
 
#define UNROLL
#define PARTIAL_UNROLL
 
   If FIXED_TABLES is defined, the tables are comipled statically into the 
   code, otherwise they are computed once when the code is first used.
 
#define FIXED_TABLES
 
   If FF_TABLES is defined faster finite field arithmetic is performed by 
   using tables.
 
#define FF_TABLES

   If ARRAYS is defined the state variables for encryption are defined as
   arrays, otherwise they are defined as individual variables. The latter
   is useful on machines where these variables can be mapped to registers. 
 
#define ARRAYS

   If FAST_VARIABLE is defined with variable block length, faster but larger
   code is used for encryption and decryption.

#define FAST_VARIABLE

   This code uses three sets of tables, each of which can be a single table
   or four sub-tables to gain a further speed advantage.

   The defines ONE_TABLE and FOUR_TABLES control the use of tables in the 
   main encryption rounds and have the greatest impact on speed.  If neither
   is defined, tables are not used and the resulting code is then very slow.
   Defining ONE_TABLE gives a substantial speed increase using 2 kbytes of 
   table space; FOUR_TABLES gives a further speed increase but uses 8 kbytes
   of table space.
   
#define ONE_TABLE
#define FOUR_TABLES

   The defines ONE_LR_TABLE and FOUR_LR_TABLES apply to the last round only
   and their impact on speed is hence less. It is unlikely to be sensible to
   apply these options unless the correspnding option above is also used.    

#define ONE_LR_TABLE
#define FOUR_LR_TABLES

   The ONE_IM_TABLE and FOUR_IM_TABLES options use tables to speed up the 
   generation of the decryption key schedule. This will only be useful in
   limited situations where decryption speed with frequent re-keying is
   needed.

#define ONE_IM_TABLE
#define FOUR_IM_TABLES

 */

#define UNROLL
#undef PARTIAL_UNROLL
#define FIXED_TABLES
#define FF_TABLES
#define ARRAYS
#define FAST_VARIABLE

#undef ONE_TABLE
#undef ONE_LR_TABLE
#undef ONE_IM_TABLE
#define FOUR_TABLES
#define FOUR_LR_TABLES
#define FOUR_IM_TABLES

 /*
   In this implementation the columns of the state array are each held in
   32-bit words. The state array can be held in various ways: in an array
   of words, in a number of individual word variables or in a number of 
   processor registers. The following define maps a variable name x and
   a column number c to the way the state array variable is to be held.
 */

#if defined(ARRAYS)
#define s(x,c) x[c]
#else
#define s(x,c) x##c
#endif

#if defined(AES_BLOCK_SIZE) && (AES_BLOCK_SIZE == 20 || AES_BLOCK_SIZE == 28)
#error an illegal block size has been specified
#endif  

#if defined(UNROLL) && defined (PARTIAL_UNROLL)
#error aes_both UNROLL and PARTIAL_UNROLL are defined
#endif

#if defined(ONE_TABLE) && defined (FOUR_TABLES)
#error aes_both ONE_TABLE and FOUR_TABLES are defined
#endif

#if defined(ONE_LR_TABLE) && defined (FOUR_LR_TABLES)
#error aes_both ONE_LR_TABLE and FOUR_LR_TABLES are defined
#endif

#if defined(ONE_IM_TABLE) && defined (FOUR_IM_TABLES)
#error aes_both ONE_IM_TABLE and FOUR_IM_TABLES are defined
#endif

 /*
   The number of key schedule words for different block and key lengths
   (allowing for the method of computation which requires the length to 
   be a multiple of the key length):

   Key Schedule    key length (bytes)
   Length          16  20  24  28  32
                ---------------------
   block     16 |  44  60  54  56  64
   length    20 |  60  60  66  70  80
   (bytes)   24 |  80  80  78  84  96
             28 | 100 100 102  98 112
             32 | 120 120 120 126 120

   Rcon Table      key length (bytes)
   Length          16  20  24  28  32
                ---------------------
   block     16 |  10   9   8   7   7
   length    20 |  14  11  10   9   9
   (bytes)   24 |  19  15  12  11  11
             28 |  24  19  16  13  13
             32 |  29  23  19  17  14
   
   The following values assume that the key length will be variable and may
   be of maximum length (32 bytes). 

   Nk = number_of_key_bytes / 4
   Nc = number_of_columns_in_state / 4
   Nr = number of encryption/decryption rounds
   Rc = number of elements in rcon table
   Ks = number of 32-bit words in key schedule
 */

#define Nr(Nk,Nc)   ((Nk > Nc ? Nk : Nc) + 6)
#define Rc(Nk,Nc)   ((Nb * (Nr(Nk,Nc) + 1) - 1) / Nk)   
#define Ks(Nk,Nc)   (Nk * (Rc(Nk,Nc) + 1))

enum t_name(constant) { Nrow =  4,  /* the number of rows in the cipher state       */
                        Mcol =  8,  /* maximum number of columns in the state       */
#if defined(AES_BLOCK_SIZE)             /* set up a statically defined block size       */
                        Ncol =  AES_BLOCK_SIZE / 4,  
                        Shr0 =  0,  /* the cyclic shift values for rows 0, 1, 2 & 3 */
                        Shr1 =  1,  
                        Shr2 =  AES_BLOCK_SIZE == 32 ? 3 : 2,
                        Shr3 =  AES_BLOCK_SIZE == 32 ? 4 : 3
#endif 
                      };

 /*
   upr(x,n): rotates bytes within words by n positions, moving bytes 
   to higher index positions with wrap around into low positions
   ups(x,n): moves bytes by n positions to higher index positions in 
   words but without wrap around
   bval(x,n): extracts a byte from a word
 */

#if (INTERNAL_BYTE_ORDER == AES_LITTLE_ENDIAN)

#define upr(x,n)        (((x) << 8 * (n)) | ((x) >> (32 - 8 * (n))))
#define ups(x,n)        ((x) << 8 * (n))
#define bval(x,n)       ((t_name(byte))((x) >> 8 * (n)))
#define byte_swap(x)    (upr(x,1) & 0x00ff00ff | upr(x,3) & 0xff00ff00)
#define bytes2word(b0, b1, b2, b3)  \
        ((t_name(word))(b3) << 24 | (t_name(word))(b2) << 16 | (t_name(word))(b1) << 8 | (b0))
#else

#define upr(x,n)        (((x) >> 8 * (n)) | ((x) << (32 - 8 * (n))))
#define ups(x,n)        ((x) >> 8 * (n)))
#define bval(x,n)       ((t_name(byte))((x) >> 24 - 8 * (n)))
#define byte_swap(x)    (upr(x,3) & 0x00ff00ff | upr(x,1) & 0xff00ff00)
#define bytes2word(b0, b1, b2, b3)  \
        ((t_name(word))(b0) << 24 | (t_name(word))(b1) << 16 | (t_name(word))(b2) << 8 | (b3))
#endif


#if defined(PACKED_IO)

#define word_in(x)      bytes2word((x)[0], (x)[1], (x)[2], (x)[3])
#define word_out(x,v)   { (x)[0] = bval(v,0); (x)[1] = bval(v,1);   \
                          (x)[2] = bval(v,2); (x)[3] = bval(v,3);   }

#elif (INTERNAL_BYTE_ORDER == PLATFORM_BYTE_ORDER)

#define word_in(x)      *(t_name(word)*)(x)
#define word_out(x,v)   *(t_name(word)*)(x) = (v)

#else

#define word_in(x)      byte_swap(*(t_name(word)*)(x))
#define word_out(x,v)   *(t_name(word)*)(x) = byte_swap(v)

#endif

#define no_table(x,box,vf,rf,c) bytes2word( \
    box[bval(vf(x,0,c),rf(0,c))], \
    box[bval(vf(x,1,c),rf(1,c))], \
    box[bval(vf(x,2,c),rf(2,c))], \
    box[bval(vf(x,3,c),rf(3,c))])

#define one_table(x,op,tab,vf,rf,c) \
 (     tab[bval(vf(x,0,c),rf(0,c))] \
  ^ op(tab[bval(vf(x,1,c),rf(1,c))],1) \
  ^ op(tab[bval(vf(x,2,c),rf(2,c))],2) \
  ^ op(tab[bval(vf(x,3,c),rf(3,c))],3))

#define four_tables(x,tab,vf,rf,c) \
 (  tab[0][bval(vf(x,0,c),rf(0,c))] \
  ^ tab[1][bval(vf(x,1,c),rf(1,c))] \
  ^ tab[2][bval(vf(x,2,c),rf(2,c))] \
  ^ tab[3][bval(vf(x,3,c),rf(3,c))])

#define vf1(x,r,c)  (x)
#define rf1(r,c)    (r)
#define rf2(r,c)    ((r-c)&3)


/* perform forward and inverse column mix operation on four bytes in long word x in */
/* parallel. NOTE: x must be a simple variable, NOT an expression in these macros.  */                                                 

#define dec_fmvars
#if defined(FOUR_FM_TABLES)     /* not currently used */
#define fwd_mcol(x)     four_tables(x,fm_tab,vf1,rf1,0)
#elif defined(ONE_FM_TABLE)     /* not currently used */
#define fwd_mcol(x)     one_table(x,upr,fm_tab,vf1,rf1,0)
#else
#undef  dec_fmvars
#define dec_fmvars      t_name(word) f1, f2;
#define fwd_mcol(x)     (f1 = (x), f2 = FFmulX(f1), f2 ^ upr(f1 ^ f2, 3) ^ upr(f1, 2) ^ upr(f1, 1))
#endif

#define dec_imvars
#if defined(FOUR_IM_TABLES)
#define inv_mcol(x)     four_tables(x,im_tab,vf1,rf1,0)
#elif defined(ONE_IM_TABLE)
#define inv_mcol(x)     one_table(x,upr,im_tab,vf1,rf1,0)
#else
#undef  dec_imvars
#define dec_imvars      t_name(word)    f2, f4, f8, f9;
#define inv_mcol(x) \
    (f9 = (x), f2 = FFmulX(f9), f4 = FFmulX(f2), f8 = FFmulX(f4), f9 ^= f8, \
    f2 ^= f4 ^ f8 ^ upr(f2 ^ f9,3) ^ upr(f4 ^ f9,2) ^ upr(f9,1))
#endif

#if defined(FOUR_LR_TABLES)
#define ls_box(x,c)     four_tables(x,fl_tab,vf1,rf2,c)
#elif defined(ONE_LR_TABLE)
#define ls_box(x,c)     one_table(x,upr,fl_tab,vf1,rf2,c)
#else
#define ls_box(x,c)     no_table(x,s_box,vf1,rf2,c)
#endif

#if defined(AES_BLOCK_SIZE)
#define nc   (Ncol)
#else
#define nc   (cx->Ncol)
#endif

#if defined(ONE_IM_TABLE)
extern const t_name(word) im_tab[256];
#elif defined(FOUR_IM_TABLES)
extern const t_name(word) im_tab[4][256];
#endif

#if defined(FIXED_TABLES)
extern const t_name(word)  rcon_tab[29];
#else
extern const t_name(word)  rcon_tab[AES_RC_LENGTH];
#endif

#if defined(ONE_LR_TABLE)
extern const t_name(word)  fl_tab[256];
#elif defined(FOUR_LR_TABLES)
extern const t_name(word)  fl_tab[4][256];
#endif

#if defined(ONE_TABLE)
extern const t_name(word)  ft_tab[256];
#elif defined(FOUR_TABLES)
extern const t_name(word)  ft_tab[4][256];
#endif

#if defined(ONE_TABLE)
extern const t_name(word)  it_tab[256];
#elif defined(FOUR_TABLES)
extern const t_name(word)  it_tab[4][256];
#endif

#if defined(ONE_LR_TABLE)
extern const t_name(word)  il_tab[256];
#elif defined(FOUR_LR_TABLES)
extern const t_name(word)  il_tab[4][256];
#endif

void c_name(convert_key)(t_name(ctx) *);

#endif
