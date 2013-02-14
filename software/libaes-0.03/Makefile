# $Id: Makefile,v 1.8 2002/01/15 17:19:13 cvs Exp $
ifndef CFLAGS
CFLAGS=-O3 -g -fomit-frame-pointer $(EXTRA_CFLAGS)
endif
## Pick your encrypt function
#AES_ENC=aes_crypt.o		# Standard C implementation
## Various assembler forms
AES_ENC=asm/aesx86-elf.o	# Works on linux
#AES_ENC=asm/aesx86-sol.o	# Solaris x86
#AES_ENC=asm/aesx86-out.o	# a.out implementation
#AES_ENC=asm/aesx86-bsdi.o	# BSDI 
##
PERL=perl
BASELIBOBJ=aes_tables.o aes_setkey.o  cbc_aes.o
LIBOBJ=$(AES_ENC) $(BASELIBOBJ)
LIBOBJSET=aes_crypt.o $(BASELIBOBJ)
BLIB=libaes.a

$(BLIB): $(LIBOBJ)
	/bin/rm -f $(BLIB)
	ar cr $(BLIB) $(LIBOBJ)
	-if test -s /bin/ranlib; then /bin/ranlib $(BLIB); \
	else if test -s /usr/bin/ranlib; then /usr/bin/ranlib $(BLIB); \
	else exit 0; fi; fi

test:			aes_vector_test aes_speedcheck
			echo && \
			./aes_vector_test test_vectors/*.txt && \
			echo && \
			./aes_speedcheck

aes_vector_test:	aes_vector_test.o $(BLIB)
aes_speedcheck:		aes_speedcheck.o $(BLIB)

clean:
			rm -f *.[oa] core asm/*.o asm/*.cpp

$(LIBOBJSET):		aes.h aes_options.h

# elf
asm/aesx86-elf.o:	asm/aesx86unix.cpp
			$(CPP) -DELF -x c $^ | as -o $@

# solaris
asm/aesx86-sol.s:	asm/aesx86unix.cpp
			$(CC) -DSOL -x c $^ | sed 's/^#.*//' > $@

# a.out
asm/aesx86-aout.o:	asm/aesx86unix.cpp
			$(CPP) -DOUT -x c $^ | as -o $@

# bsdi
asm/aesx86-bsdi.o:	asm/aesx86unix.cpp
			$(CPP) -DBSDI -x c $^ | as -o $@

asm/aesx86unix.cpp:	asm/aes-586.pl asm/perlasm/x86asm.pl asm/perlasm/cbc.pl
	(cd asm; $(PERL) aes-586.pl cpp $(PROCESSOR) >aesx86unix.cpp)
