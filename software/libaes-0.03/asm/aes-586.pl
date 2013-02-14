#!/usr/bin/perl
#
#	$Id: aes-586.pl,v 1.7 2002/01/15 17:19:13 cvs Exp $
#
# AES/Rijndael pentium (with optional mmx) implementation
#
#
# This code is a translation (to perlasm) of Brian Gladman's
# assembly code, which was released with the following License and notes.
#
#
#; Copyright (c) 2001, Dr Brian Gladman <brg@gladman.uk.net>, Worcester, UK.
#; All rights reserved.
#;   
#; TERMS
#;
#;  Redistribution and use in source and binary forms, with or without 
#;  modification, are permitted subject to the following conditions:
#;
#;  1. Redistributions of source code must retain the above copyright 
#;     notice, this list of conditions and the following disclaimer.
#;
#;  2. Redistributions in binary form must reproduce the above copyright
#;     notice, this list of conditions and the following disclaimer in the 
#;     documentation and/or other materials provided with the distribution.
#;
#;  3. The copyright holder's name must not be used to endorse or promote 
#;     any products derived from this software without his specific prior
#;     written permission. 
#;
#;  This software is provided 'as is' with no express or implied warranties 
#;  of correctness or fitness for purpose.
#
#; An AES (Rijndael) implementation for the Pentium MMX family using the NASM
#; assembler <http://www.web-sites.co.uk/nasm/>. This version only implements
#; the standard AES block length (128 bits, 16 bytes) with the same interface
#; as that used in my C/C++ implementation.   This code does not preserve the
#; eax, ecx or edx registers or the artihmetic status flags. However, the ebx, 
#; esi, edi, and ebp registers are preserved across calls.    If this code is 
#; used with compiled code the compiler's register saving and use conventions 
#; will need to be checked (it is consistent with Microsoft VC++).
#
#; NOTE: This code uses a dual key schedule (set DUAL_KEY_SCHEDULE in aes.h).
#

push(@INC, "perlasm", "../../perlasm");
require "x86asm.pl";
require "cbc.pl";



#
# code generation options
#
my $mmx = 0;			# use MMX (new method does not gain here)
my $check = 0;			# do checks for keys schedules existing



#
# register usage allocation
#
use constant ctx_r => 'ebp';
use constant inblk_r => 'ecx';
use constant r0 => 'eax';
use constant r1 => 'ebx';
use constant r2 => 'ecx';	# overlap with inblk_r
use constant r3 => 'edx';
use constant r4 => 'esi';
use constant r5 => 'edi';
use constant r6 => 'ebp';	# overlap with ctx_r

#
# offsets in context structure
#
use constant ekey => 0;
use constant dkey => 256;
use constant nkey => 512;
use constant nrnd => 516;
use constant sflg => 520;

use constant tlen => 1024;

#
# parameters to encrypt/decrypt calls
#
use constant inblk_param	=> 1;
use constant outblk_param	=> 2;
use constant ctx_param 		=> 0;



#; These macros implement either MMX or stack based local variables
sub save{
    my($idx, $reg) = @_;

    if ($mmx) {
	&movd(sprintf('mm%d', $idx), $reg);
    } else {
	&mov(&DWP(4 * $idx, 'esp', "", 0), $reg);
    }
}

sub restore{
    my($reg, $idx) = @_;

    if ($mmx) {
	&movd($reg, sprintf('mm%d', $idx));

    } else {
	&mov($reg, &DWP(4 * $idx, 'esp', "", 0));
    }
}



sub fwd_rnd {
    my($offset,
       $tab) = @_;

    &comment("[fwd_rnd($offset, $tab)]");
    &mov	(r2,	r0);
    &save	(0,	r1);
    &save	(1,	r5);
    &movzx	(r3,	&LB(r0));
    &mov	(r0,	&DWP($offset,	r6, '', 0));
    &mov	(r5,	&DWP($offset+12, r6, '', 0));
    &xor	(r0,	&DWP($tab, '', r3, 4));
    &movzx	(r3,	&HB(r2));
    &shr     	(r2,	16);
    &mov	(r1,	&DWP($offset+4, r6, '', 0));
    &xor	(r5,	&DWP(join('+', tlen,$tab), '', r3, 4));
    &movzx	(r3,	&LB(r2));
    &movzx	(r2,	&HB(r2));
    &xor	(r1,	&DWP(join('+', 3*tlen,$tab), '', r2, 4));
    &mov	(r2,	r4);
    &mov	(r4,	&DWP(join('+', 2*tlen,$tab), '', r3, 4));
    &movzx	(r3,	&LB(r2));
    &xor     	(r4,	&DWP($tab, '', r3, 4));
    &movzx	(r3,	&HB(r2));
    &shr     	(r2,	16);
    &xor     	(r1,	&DWP(join('+', tlen,$tab), '', r3, 4));
    &movzx	(r3,	&LB(r2));
    &movzx	(r2,	&HB(r2));
    &xor	(r0,	&DWP(join('+', 2*tlen,$tab), '', r3, 4));
    restore	(r3,	0);
    &xor	(r5,	&DWP(join('+', 3*tlen,$tab), '', r2, 4));
    &movzx	(r2,	&LB(r3));
    &xor	(r4,	&DWP($offset+8, r6, '', 0));
    &xor	(r1,	&DWP($tab, '', r2, 4));
    &movzx	(r2,	&HB(r3));
    &shr     	(r3,	16);
    &xor	(r0,	&DWP(join('+', tlen,$tab), '', r2, 4));
    &movzx	(r2,	&LB(r3));
    &movzx	(r3,	&HB(r3));
    &xor	(r5,	&DWP(join('+', 2*tlen,$tab), '', r2, 4));
    restore	(r2,	1);
    &xor	(r4,	&DWP(join('+', 3*tlen,$tab), '', r3, 4));
    &movzx	(r3,	&LB(r2));
    &xor	(r5,	&DWP($tab, '', r3, 4));
    &movzx	(r3,	&HB(r2));
    &shr     	(r2,	16);
    &xor	(r4,	&DWP(join('+', tlen,$tab), '', r3, 4));
    &movzx	(r3,	&LB(r2));
    &movzx	(r2,	&HB(r2));
    &xor	(r1,	&DWP(join('+', 2*tlen,$tab), '', r3, 4));
    &xor	(r0,	&DWP(join('+', 3*tlen,$tab), '', r2, 4));
}



sub inv_rnd {
    my($offset,
       $tab) = @_;

    &comment("[inv_rnd($offset, $tab)]");
    &movzx	(r3,	&LB(r0));
    &save	(0,	r1);
    &mov	(r2,	r0);
    &mov	(r0,	&DWP($offset,	r6, '', 0));
    &save	(1,	r5);
    &mov	(r1,	&DWP($offset+4, r6, '', 0));
    &xor	(r0,	&DWP($tab, '', r3, 4));
    &movzx	(r3,	&HB(r2));
    &shr     	(r2,	16);
    &mov	(r5,	&DWP($offset+12, r6, '', 0));
    &xor	(r1,	&DWP(join('+', tlen,$tab), '', r3, 4));
    &movzx	(r3,	&LB(r2));
    &movzx	(r2,	&HB(r2));
    &xor	(r5,	&DWP(join('+', 3*tlen,$tab), '', r2, 4));
    &mov	(r2,	r4);
    &mov	(r4,	&DWP(join('+', 2*tlen,$tab), '', r3, 4));
    &movzx	(r3,	&LB(r2));
    &xor     	(r4,	&DWP($tab, '', r3, 4));
    &movzx	(r3,	&HB(r2));
    &shr     	(r2,	16);
    &xor     	(r5,	&DWP(join('+', tlen,$tab), '', r3, 4));
    &movzx	(r3,	&LB(r2));
    &movzx	(r2,	&HB(r2));
    &xor	(r0,	&DWP(join('+', 2*tlen,$tab), '', r3, 4));
    restore	(r3,	0);
    &xor	(r1,	&DWP(join('+', 3*tlen,$tab), '', r2, 4));
    &movzx	(r2,	&LB(r3));
    &xor	(r4,	&DWP($offset+8, r6, '', 0));
    &xor	(r1,	&DWP($tab, '', r2, 4));
    &movzx	(r2,	&HB(r3));
    &shr     	(r3,	16);
    &xor	(r4,	&DWP(join('+', tlen,$tab), '', r2, 4));
    &movzx	(r2,	&LB(r3));
    &movzx	(r3,	&HB(r3));
    &xor	(r5,	&DWP(join('+', 2*tlen,$tab), '', r2, 4));
    restore	(r2,	1);
    &xor	(r0,	&DWP(join('+', 3*tlen,$tab), '', r3, 4));
    &movzx	(r3,	&LB(r2));
    &xor	(r5,	&DWP($tab, '', r3, 4));
    &movzx	(r3,	&HB(r2));
    &shr     	(r2,	16);
    &xor	(r0,	&DWP(join('+', tlen,$tab), '', r3, 4));
    &movzx	(r3,	&LB(r2));
    &movzx	(r2,	&HB(r2));
    &xor	(r1,	&DWP(join('+', 2*tlen,$tab), '', r3, 4));
    &xor	(r4,	&DWP(join('+', 3*tlen,$tab), '', r2, 4));
}



sub do_rnd {
    my($decrypt,
       $offset,
       $last) = @_;

    if ($decrypt) {
	inv_rnd(-$offset,
		($last ? 'il_tab' : 'it_tab'));
    } else {
	fwd_rnd($offset,
		($last ? 'fl_tab' : 'ft_tab'));
    }
}



sub aes_crypt {
    my $name = shift;
    my $decrypt = shift;

    &function_begin($name,"");
    &comment('acquire the context information from param(' . ctx_param . ')');
    &mov(ctx_r, &wparam(ctx_param));
    if ($check) {
	&comment('check ctx encryption/decryption flags');
	&testb(&BP(sflg, ctx_r, "", 0), &BC($decrypt ? 2 : 1));
	&jne(&label('strt'));
	&xor('eax', 'eax');
	&jmp(&label('end'));
    } else {
	&comment('skipping tests that key sched is complete');
    }

    &comment('acquring input block from param(0)');
    &set_label('strt');
    &mov(inblk_r, &wparam(inblk_param));
    &mov(r3, &DWP(nrnd, ctx_r, "", 0));
    if ($decrypt) {
	&comment('table offset is a multiple of 16, hence double lea');
	&lea(r6,  &DWP(dkey+16, ctx_r, r3, 8));
	&lea(r6,  &DWP(0, ctx_r, r3, 8));
    } else {
	&lea(r6,  &DWP(ekey+16, ctx_r, "", 0));
    }

    &comment('load up the four columns');
    &mov(r0, &DWP(0, inblk_r, "", 0));
    &mov(r1, &DWP(4, inblk_r, "", 0));
    &mov(r4, &DWP(8, inblk_r, "", 0));
    &mov(r5, &DWP(12, inblk_r, "", 0));

    &comment('xor in first round key');
    &xor(r0, &DWP(-16, r6, "", 0));
    &xor(r1, &DWP(-12, r6, "", 0));
    &xor(r4, &DWP(-8,  r6, "", 0));
    &xor(r5, &DWP(-4,  r6, "", 0));

    &comment('space for register saves');
    &stack_push(2);

    &comment('increment to next round key');
    if ($decrypt) {
	&mov(ctx_r, &wparam(ctx_param));
	&lea(r6,  &DWP(dkey+4*9*4, ctx_r, '', 0));
	&sub(r3, &BC(10));
	&je(&label('e10_rounds'));
	&sub(r3, &BC(2));
	&je(&label('e12_rounds'));
    } else {
	&sub(r3, &BC(10));
	&je(&label('e10_rounds'));
	&add(r6, &BC(32));
	&sub(r3, &BC(2));
	&je(&label('e12_rounds'));
	&add(r6, &BC(32));
    }
    &set_label('e14_rounds');
    do_rnd($decrypt, -64);
    do_rnd($decrypt, -48);
    &set_label('e12_rounds');
    do_rnd($decrypt, -32);
    do_rnd($decrypt, -16);
    &set_label('e10_rounds');
    do_rnd($decrypt, 0);
    do_rnd($decrypt, 16);
    do_rnd($decrypt, 32);
    do_rnd($decrypt, 48);
    do_rnd($decrypt, 64);
    do_rnd($decrypt, 80);
    do_rnd($decrypt, 96);
    do_rnd($decrypt, 112);
    do_rnd($decrypt, 128);
    do_rnd($decrypt, 144, 1);

    &comment('move results to output block');
    &mov(r6, &wparam(outblk_param));
    &mov(&DWP(12, r6, '', 0), r5);
    &mov(&DWP(8,  r6, '', 0), r4);
    &mov(&DWP(4,  r6, '', 0), r1);
    &mov(&DWP(0,  r6, '', 0), r0);

    # reclaim stack space
    &stack_pop(2);

    &comment('end clean up stuff');
    &mov('eax', 1);
    &set_label('end');
    &function_end($name);
}



# main

&asm_init($ARGV[0],"aes-586.pl",$ARGV[$#ARGV] eq "386");
&external_label(qw[ft_tab
		   fl_tab
		   it_tab
		   il_tab]);
&aes_crypt('aes_encrypt', 0);
&aes_crypt('aes_decrypt', 1);

&asm_finish();
