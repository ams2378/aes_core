 














	.section	.note.GNU-stack,"",@progbits





































	.text
	.align 16
	.globl mpzero
	
	.type mpzero,@function

mpzero:

	movq %rdi,%rcx
	movq %rsi,%rdi
	xorq %rax,%rax
	rep stosq
	ret

.Lmpzero_size:
	.size mpzero, .Lmpzero_size  - mpzero




	.text
	.align 16
	.globl mpfill
	
	.type mpfill,@function

mpfill:

	movq %rdi,%rcx
	movq %rsi,%rdi
	movq %rdx,%rax
	rep stosq
	ret

.Lmpfill_size:
	.size mpfill, .Lmpfill_size  - mpfill




	.text
	.align 16
	.globl mpeven
	
	.type mpeven,@function

mpeven:

	movq -8(%rsi,%rdi,8),%rax
	notq %rax
	andq $1,%rax
	ret

.Lmpeven_size:
	.size mpeven, .Lmpeven_size  - mpeven




	.text
	.align 16
	.globl mpodd
	
	.type mpodd,@function

mpodd:

	movq -8(%rsi,%rdi,8),%rax
	andq $1,%rax
	ret

.Lmpodd_size:
	.size mpodd, .Lmpodd_size  - mpodd




	.text
	.align 16
	.globl mpaddw
	
	.type mpaddw,@function

mpaddw:

	movq %rdx,%rax
	xorq %rdx,%rdx
	leaq -8(%rsi,%rdi,8),%rsi
	addq %rax,(%rsi)
	decq %rdi
	jz .Lmpaddw_skip
	leaq -8(%rsi),%rsi

	.align 4
.Lmpaddw_loop:
	adcq %rdx,(%rsi)
	leaq -8(%rsi),%rsi
	decq %rdi
	jnz .Lmpaddw_loop
.Lmpaddw_skip:
	sbbq %rax,%rax
	negq %rax
	ret

.Lmpaddw_size:
	.size mpaddw, .Lmpaddw_size  - mpaddw




	.text
	.align 16
	.globl mpsubw
	
	.type mpsubw,@function

mpsubw:

	movq %rdx,%rax
	xorq %rdx,%rdx
	leaq -8(%rsi,%rdi,8),%rsi
	subq %rax,(%rsi)
	decq %rdi
	jz .Lmpsubw_skip
	leaq -8(%rsi),%rsi

	.align 4
.Lmpsubw_loop:
	sbbq %rdx,(%rsi)
	leaq -8(%rsi),%rsi
	decq %rdi
	jnz .Lmpsubw_loop
.Lmpsubw_skip:
	sbbq %rax,%rax
	negq %rax
	ret

.Lmpsubw_size:
	.size mpsubw, .Lmpsubw_size  - mpsubw




	.text
	.align 16
	.globl mpadd
	
	.type mpadd,@function

mpadd:

	xorq %r8,%r8
	decq %rdi

	.align 4
.Lmpadd_loop:
	movq (%rdx,%rdi,8),%rax
	movq (%rsi,%rdi,8),%r8
	adcq %rax,%r8
	movq %r8,(%rsi,%rdi,8)
	decq %rdi
	jns .Lmpadd_loop

	sbbq %rax,%rax
	negq %rax
	ret

.Lmpadd_size:
	.size mpadd, .Lmpadd_size  - mpadd




	.text
	.align 16
	.globl mpsub
	
	.type mpsub,@function

mpsub:

	xorq %r8,%r8
	decq %rdi

	.align 4
.Lmpsub_loop:
	movq (%rdx,%rdi,8),%rax
	movq (%rsi,%rdi,8),%r8
	sbbq %rax,%r8
	movq %r8,(%rsi,%rdi,8)
	decq %rdi
	jns .Lmpsub_loop

	sbbq %rax,%rax
	negq %rax
	ret

.Lmpsub_size:
	.size mpsub, .Lmpsub_size  - mpsub




	.text
	.align 16
	.globl mpdivtwo
	
	.type mpdivtwo,@function

mpdivtwo:

	leaq (%rsi,%rdi,8),%rsi
	negq %rdi
	xorq %rax,%rax

	.align 4
.Lmpdivtwo_loop:
	rcrq $1,(%rsi,%rdi,8)
	inc %rdi
	jnz .Lmpdivtwo_loop

	ret

.Lmpdivtwo_size:
	.size mpdivtwo, .Lmpdivtwo_size  - mpdivtwo




	.text
	.align 16
	.globl mpmultwo
	
	.type mpmultwo,@function

mpmultwo:

	xorq %rdx,%rdx
	decq %rdi

	.align 4
.Lmpmultwo_loop:
	movq (%rsi,%rdi,8),%rax
	adcq %rax,%rax
	movq %rax,(%rsi,%rdi,8)
	decq %rdi
	jns .Lmpmultwo_loop

	sbbq %rax,%rax
	negq %rax
	ret

.Lmpmultwo_size:
	.size mpmultwo, .Lmpmultwo_size  - mpmultwo




	.text
	.align 16
	.globl mpsetmul
	
	.type mpsetmul,@function

mpsetmul:

	movq %rcx,%r8
	movq %rdi,%rcx
	movq %rdx,%rdi

	xorq %rdx,%rdx
	decq %rcx

	.align 4
.Lmpsetmul_loop:
	movq %rdx,%r9
	movq (%rdi,%rcx,8),%rax
	mulq %r8
	addq %r9,%rax
	adcq $0,%rdx
	movq %rax,(%rsi,%rcx,8)
	decq %rcx
	jns .Lmpsetmul_loop

	movq %rdx,%rax

	ret

.Lmpsetmul_size:
	.size mpsetmul, .Lmpsetmul_size  - mpsetmul




	.text
	.align 16
	.globl mpaddmul
	
	.type mpaddmul,@function

mpaddmul:

	movq %rcx,%r8
	movq %rdi,%rcx
	movq %rdx,%rdi

	xorq %rdx,%rdx
	decq %rcx

	.align 4
.Lmpaddmul_loop:
	movq %rdx,%r9
	movq (%rdi,%rcx,8),%rax
	mulq %r8
	addq %r9,%rax
	adcq $0,%rdx
	addq (%rsi,%rcx,8),%rax
	adcq $0,%rdx
	movq %rax,(%rsi,%rcx,8)
	decq %rcx
	jns .Lmpaddmul_loop

	movq %rdx,%rax
	ret

.Lmpaddmul_size:
	.size mpaddmul, .Lmpaddmul_size  - mpaddmul




	.text
	.align 16
	.globl mpaddsqrtrc
	
	.type mpaddsqrtrc,@function

mpaddsqrtrc:

	movq %rdi,%rcx
	movq %rsi,%rdi
	movq %rdx,%rsi

	xorq %r8,%r8
	decq %rcx

	leaq (%rdi,%rcx,8),%rdi 
	leaq (%rdi,%rcx,8),%rdi

	.align 4
.Lmpaddsqrtrc_loop:
	movq (%rsi,%rcx,8),%rax
	mulq %rax
	addq %r8,%rax
	adcq $0,%rdx
	addq %rax,8(%rdi)
	adcq %rdx,0(%rdi)
	sbbq %r8,%r8
	negq %r8
	subq $16,%rdi
	decq %rcx
	jns .Lmpaddsqrtrc_loop

	movq %r8,%rax
	ret

.Lmpaddsqrtrc_size:
	.size mpaddsqrtrc, .Lmpaddsqrtrc_size  - mpaddsqrtrc

