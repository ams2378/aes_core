/* $Id: aestab.h,v 1.1 2002/01/13 13:23:20 cvs Exp $ */

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
 * - This file is as received other than this comment, the
 *   first Id comment, and changing one C++ comment to C style
 *
 */

#if defined(FIXED_TABLES)

#define sb_data(w) \
    w(63), w(7c), w(77), w(7b), w(f2), w(6b), w(6f), w(c5),\
    w(30), w(01), w(67), w(2b), w(fe), w(d7), w(ab), w(76),\
    w(ca), w(82), w(c9), w(7d), w(fa), w(59), w(47), w(f0),\
    w(ad), w(d4), w(a2), w(af), w(9c), w(a4), w(72), w(c0),\
    w(b7), w(fd), w(93), w(26), w(36), w(3f), w(f7), w(cc),\
    w(34), w(a5), w(e5), w(f1), w(71), w(d8), w(31), w(15),\
    w(04), w(c7), w(23), w(c3), w(18), w(96), w(05), w(9a),\
    w(07), w(12), w(80), w(e2), w(eb), w(27), w(b2), w(75),\
    w(09), w(83), w(2c), w(1a), w(1b), w(6e), w(5a), w(a0),\
    w(52), w(3b), w(d6), w(b3), w(29), w(e3), w(2f), w(84),\
    w(53), w(d1), w(00), w(ed), w(20), w(fc), w(b1), w(5b),\
    w(6a), w(cb), w(be), w(39), w(4a), w(4c), w(58), w(cf),\
    w(d0), w(ef), w(aa), w(fb), w(43), w(4d), w(33), w(85),\
    w(45), w(f9), w(02), w(7f), w(50), w(3c), w(9f), w(a8),\
    w(51), w(a3), w(40), w(8f), w(92), w(9d), w(38), w(f5),\
    w(bc), w(b6), w(da), w(21), w(10), w(ff), w(f3), w(d2),\
    w(cd), w(0c), w(13), w(ec), w(5f), w(97), w(44), w(17),\
    w(c4), w(a7), w(7e), w(3d), w(64), w(5d), w(19), w(73),\
    w(60), w(81), w(4f), w(dc), w(22), w(2a), w(90), w(88),\
    w(46), w(ee), w(b8), w(14), w(de), w(5e), w(0b), w(db),\
    w(e0), w(32), w(3a), w(0a), w(49), w(06), w(24), w(5c),\
    w(c2), w(d3), w(ac), w(62), w(91), w(95), w(e4), w(79),\
    w(e7), w(c8), w(37), w(6d), w(8d), w(d5), w(4e), w(a9),\
    w(6c), w(56), w(f4), w(ea), w(65), w(7a), w(ae), w(08),\
    w(ba), w(78), w(25), w(2e), w(1c), w(a6), w(b4), w(c6),\
    w(e8), w(dd), w(74), w(1f), w(4b), w(bd), w(8b), w(8a),\
    w(70), w(3e), w(b5), w(66), w(48), w(03), w(f6), w(0e),\
    w(61), w(35), w(57), w(b9), w(86), w(c1), w(1d), w(9e),\
    w(e1), w(f8), w(98), w(11), w(69), w(d9), w(8e), w(94),\
    w(9b), w(1e), w(87), w(e9), w(ce), w(55), w(28), w(df),\
    w(8c), w(a1), w(89), w(0d), w(bf), w(e6), w(42), w(68),\
    w(41), w(99), w(2d), w(0f), w(b0), w(54), w(bb), w(16)

#define isb_data(w) \
    w(52), w(09), w(6a), w(d5), w(30), w(36), w(a5), w(38),\
    w(bf), w(40), w(a3), w(9e), w(81), w(f3), w(d7), w(fb),\
    w(7c), w(e3), w(39), w(82), w(9b), w(2f), w(ff), w(87),\
    w(34), w(8e), w(43), w(44), w(c4), w(de), w(e9), w(cb),\
    w(54), w(7b), w(94), w(32), w(a6), w(c2), w(23), w(3d),\
    w(ee), w(4c), w(95), w(0b), w(42), w(fa), w(c3), w(4e),\
    w(08), w(2e), w(a1), w(66), w(28), w(d9), w(24), w(b2),\
    w(76), w(5b), w(a2), w(49), w(6d), w(8b), w(d1), w(25),\
    w(72), w(f8), w(f6), w(64), w(86), w(68), w(98), w(16),\
    w(d4), w(a4), w(5c), w(cc), w(5d), w(65), w(b6), w(92),\
    w(6c), w(70), w(48), w(50), w(fd), w(ed), w(b9), w(da),\
    w(5e), w(15), w(46), w(57), w(a7), w(8d), w(9d), w(84),\
    w(90), w(d8), w(ab), w(00), w(8c), w(bc), w(d3), w(0a),\
    w(f7), w(e4), w(58), w(05), w(b8), w(b3), w(45), w(06),\
    w(d0), w(2c), w(1e), w(8f), w(ca), w(3f), w(0f), w(02),\
    w(c1), w(af), w(bd), w(03), w(01), w(13), w(8a), w(6b),\
    w(3a), w(91), w(11), w(41), w(4f), w(67), w(dc), w(ea),\
    w(97), w(f2), w(cf), w(ce), w(f0), w(b4), w(e6), w(73),\
    w(96), w(ac), w(74), w(22), w(e7), w(ad), w(35), w(85),\
    w(e2), w(f9), w(37), w(e8), w(1c), w(75), w(df), w(6e),\
    w(47), w(f1), w(1a), w(71), w(1d), w(29), w(c5), w(89),\
    w(6f), w(b7), w(62), w(0e), w(aa), w(18), w(be), w(1b),\
    w(fc), w(56), w(3e), w(4b), w(c6), w(d2), w(79), w(20),\
    w(9a), w(db), w(c0), w(fe), w(78), w(cd), w(5a), w(f4),\
    w(1f), w(dd), w(a8), w(33), w(88), w(07), w(c7), w(31),\
    w(b1), w(12), w(10), w(59), w(27), w(80), w(ec), w(5f),\
    w(60), w(51), w(7f), w(a9), w(19), w(b5), w(4a), w(0d),\
    w(2d), w(e5), w(7a), w(9f), w(93), w(c9), w(9c), w(ef),\
    w(a0), w(e0), w(3b), w(4d), w(ae), w(2a), w(f5), w(b0),\
    w(c8), w(eb), w(bb), w(3c), w(83), w(53), w(99), w(61),\
    w(17), w(2b), w(04), w(7e), w(ba), w(77), w(d6), w(26),\
    w(e1), w(69), w(14), w(63), w(55), w(21), w(0c), w(7d),

#define mm_data(w) \
	w(00), w(01), w(02), w(03), w(04), w(05), w(06), w(07),\
	w(08), w(09), w(0a), w(0b), w(0c), w(0d), w(0e), w(0f),\
	w(10), w(11), w(12), w(13), w(14), w(15), w(16), w(17),\
	w(18), w(19), w(1a), w(1b), w(1c), w(1d), w(1e), w(1f),\
	w(20), w(21), w(22), w(23), w(24), w(25), w(26), w(27),\
	w(28), w(29), w(2a), w(2b), w(2c), w(2d), w(2e), w(2f),\
	w(30), w(31), w(32), w(33), w(34), w(35), w(36), w(37),\
	w(38), w(39), w(3a), w(3b), w(3c), w(3d), w(3e), w(3f),\
	w(40), w(41), w(42), w(43), w(44), w(45), w(46), w(47),\
	w(48), w(49), w(4a), w(4b), w(4c), w(4d), w(4e), w(4f),\
	w(50), w(51), w(52), w(53), w(54), w(55), w(56), w(57),\
	w(58), w(59), w(5a), w(5b), w(5c), w(5d), w(5e), w(5f),\
	w(60), w(61), w(62), w(63), w(64), w(65), w(66), w(67),\
	w(68), w(69), w(6a), w(6b), w(6c), w(6d), w(6e), w(6f),\
	w(70), w(71), w(72), w(73), w(74), w(75), w(76), w(77),\
	w(78), w(79), w(7a), w(7b), w(7c), w(7d), w(7e), w(7f),\
	w(80), w(81), w(82), w(83), w(84), w(85), w(86), w(87),\
	w(88), w(89), w(8a), w(8b), w(8c), w(8d), w(8e), w(8f),\
	w(90), w(91), w(92), w(93), w(94), w(95), w(96), w(97),\
	w(98), w(99), w(9a), w(9b), w(9c), w(9d), w(9e), w(9f),\
	w(a0), w(a1), w(a2), w(a3), w(a4), w(a5), w(a6), w(a7),\
	w(a8), w(a9), w(aa), w(ab), w(ac), w(ad), w(ae), w(af),\
	w(b0), w(b1), w(b2), w(b3), w(b4), w(b5), w(b6), w(b7),\
	w(b8), w(b9), w(ba), w(bb), w(bc), w(bd), w(be), w(bf),\
	w(c0), w(c1), w(c2), w(c3), w(c4), w(c5), w(c6), w(c7),\
	w(c8), w(c9), w(ca), w(cb), w(cc), w(cd), w(ce), w(cf),\
	w(d0), w(d1), w(d2), w(d3), w(d4), w(d5), w(d6), w(d7),\
	w(d8), w(d9), w(da), w(db), w(dc), w(dd), w(de), w(df),\
	w(e0), w(e1), w(e2), w(e3), w(e4), w(e5), w(e6), w(e7),\
	w(e8), w(e9), w(ea), w(eb), w(ec), w(ed), w(ee), w(ef),\
	w(f0), w(f1), w(f2), w(f3), w(f4), w(f5), w(f6), w(f7),\
	w(f8), w(f9), w(fa), w(fb), w(fc), w(fd), w(fe), w(ff)

#define hx(p)	((unsigned char)0x##p)

#define f2(p)  ((((p) & 0x7f) << 1) ^ ((p) & 0x80 ? 0x1b : 0))
#define f3(p)  ((p) ^ f2(p))
#define f9(p)  ((p) ^ f2(f2(f2(p))))
#define fb(p)  ((p) ^ f2((p) ^ f2(f2(p))))
#define fd(p)  ((p) ^ f2(f2((p) ^ f2(p))))
#define fe(p)  f2((p) ^ f2((p) ^ f2(p)))

 /*
   These defines are used to ensure tables are generated in the 
   right format depending on the internal byte order required
 */

#define w0(p)	bytes2word(hx(p), 0, 0, 0)
#define w1(p)	bytes2word(0, hx(p), 0, 0)
#define w2(p)	bytes2word(0, 0, hx(p), 0)
#define w3(p)	bytes2word(0, 0, 0, hx(p))

 /*
   Number of elements required in this table for different
   block and key lengths is:

   Rcon Table      key length (bytes)
   Length          16  20  24  28  32
                ---------------------
   block     16 |  10   9   8   7   7
   length    20 |  14  11  10   9   9
   (bytes)   24 |  19  15  12  11  11
             28 |  24  19  16  13  13
             32 |  29  23  19  17  14

   this table can be a table of bytes if the key schedule
   code is adjusted accordingly
 */

const t_name(word) rcon_tab[29] =
{
    w0(01), w0(02), w0(04), w0(08),
    w0(10), w0(20), w0(40), w0(80),
    w0(1b), w0(36), w0(6c), w0(d8),
    w0(ab), w0(4d), w0(9a), w0(2f),
    w0(5e), w0(bc), w0(63), w0(c6),
    w0(97), w0(35), w0(6a), w0(d4),
    w0(b3), w0(7d), w0(fa), w0(ef),
    w0(c5)
};

#if 0

#define iw(p)	bytes2word(fe(hx(p)), f9(hx(p)), fd(hx(p)), fb(hx(p)))
const t_name(word) ircn_tab[29] =
{
    iw(01), iw(02), iw(04), iw(08),
    iw(10), iw(20), iw(40), iw(80),
    iw(1b), iw(36), iw(6c), iw(d8),
    iw(ab), iw(4d), iw(9a), iw(2f),
    iw(5e), iw(bc), iw(63), iw(c6),
    iw(97), iw(35), iw(6a), iw(d4),
    iw(b3), iw(7d), iw(fa), iw(ef),
    iw(c5)
};

#endif

#define u0(p)	bytes2word(f2(hx(p)), hx(p), hx(p), f3(hx(p)))
#define u1(p)	bytes2word(f3(hx(p)), f2(hx(p)), hx(p), hx(p))
#define u2(p)	bytes2word(hx(p), f3(hx(p)), f2(hx(p)), hx(p))
#define u3(p)	bytes2word(hx(p), hx(p), f3(hx(p)), f2(hx(p)))

#define v0(p)	bytes2word(fe(hx(p)), f9(hx(p)), fd(hx(p)), fb(hx(p)))
#define v1(p)	bytes2word(fb(hx(p)), fe(hx(p)), f9(hx(p)), fd(hx(p)))
#define v2(p)	bytes2word(fd(hx(p)), fb(hx(p)), fe(hx(p)), f9(hx(p)))
#define v3(p)	bytes2word(f9(hx(p)), fd(hx(p)), fb(hx(p)), fe(hx(p)))

#if !defined(AES_DECRYPT_ONLY)

#if defined(ONE_TABLE)
const t_name(word) ft_tab[256] =
    { sb_data(u0) };
#elif defined(FOUR_TABLES)
const t_name(word) ft_tab[4][256] =
	{ { sb_data(u0) }, { sb_data(u1) }, { sb_data(u2) }, { sb_data(u3) } };
#else
const t_name(byte) s_box[256] =
{	sb_data(hx) };
#define SBOX
#endif
#if defined(ONE_LR_TABLE)
const t_name(word) fl_tab[256] =
    { sb_data(w0) };
#elif defined(FOUR_LR_TABLES)
const t_name(word) fl_tab[4][256] =
	{ { sb_data(w0) }, { sb_data(w1) }, { sb_data(w2) }, { sb_data(w3) } };
#elif !defined(SBOX)
const t_name(byte) s_box[256] =
{	sb_data(hx) };
#define SBOX
#endif

#endif

#if !defined(AES_ENCRYPT_ONLY)

#if defined(ONE_TABLE)
const t_name(word) it_tab[256] =
    { isb_data(v0) };
#elif defined(FOUR_TABLES)
const t_name(word) it_tab[4][256] =
	{ { isb_data(v0) }, { isb_data(v1) }, { isb_data(v2) }, { isb_data(v3) } };
#else
const t_name(byte) inv_s_box[256] =
{	isb_data(hx) };
#define ISBOX
#endif

#if defined(ONE_LR_TABLE)
const t_name(word) il_tab[256] =
    { isb_data(w0) };
#elif defined(FOUR_LR_TABLES)
const t_name(word) il_tab[4][256] =
	{ { isb_data(w0) }, { isb_data(w1) }, { isb_data(w2) }, { isb_data(w3) } };
#elif !defined(ISBOX)
const t_name(byte) inv_s_box[256] =
{	isb_data(hx) };
#define ISBOX
#endif

#if defined(AES_DECRYPT_ONLY)
#if defined(ONE_LR_TABLE)
const t_name(word) fl_tab[256] =
    { sb_data(w0) };
#elif defined(FOUR_LR_TABLES)
const t_name(word) fl_tab[4][256] =
	{ { sb_data(w0) }, { sb_data(w1) }, { sb_data(w2) }, { sb_data(w3) } };
#elif !defined(SBOX)
const t_name(byte) s_box[256] =
{	sb_data(hx) };
#define ISBOX
#endif
#endif

#endif

#if defined(ONE_IM_TABLE)
const t_name(word) im_tab[256] =
    { mm_data(v0) };
#elif defined(FOUR_IM_TABLES)
const t_name(word) im_tab[4][256] =
	{ { mm_data(v0) }, { mm_data(v1) }, { mm_data(v2) }, { mm_data(v3) } };
#endif

#endif /* FIXED_TABLES */
