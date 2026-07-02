	.file	"fibonacci_pure.b4b0f244396f04e4-cgu.0"
	.section	.text.fib,"ax",@progbits
	.globl	fib
	.p2align	4
	.type	fib,@function
fib:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	pushq	%r14
	.cfi_def_cfa_offset 24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset %rbx, -32
	.cfi_offset %r14, -24
	.cfi_offset %r15, -16
	movl	%edi, %r14d
	xorl	%ebx, %ebx
	cmpl	$2, %edi
	jge	.LBB0_2
	movl	%r14d, %ecx
	jmp	.LBB0_4
.LBB0_2:
	xorl	%ebx, %ebx
	movq	fib@GOTPCREL(%rip), %r15
	.p2align	4
.LBB0_3:
	leal	-1(%r14), %edi
	callq	*%r15
	leal	-2(%r14), %ecx
	addl	%eax, %ebx
	cmpl	$3, %r14d
	movl	%ecx, %r14d
	ja	.LBB0_3
.LBB0_4:
	addl	%ecx, %ebx
	movl	%ebx, %eax
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end0:
	.size	fib, .Lfunc_end0-fib
	.cfi_endproc

	.ident	"rustc version 1.96.1 (31fca3adb 2026-06-26)"
	.section	".note.GNU-stack","",@progbits
