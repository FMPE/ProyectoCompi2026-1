	.file	"fibonacci.c"
	.text
	.p2align 4
	.globl	fib
	.type	fib, @function
fib:
.LFB23:
	.cfi_startproc
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	movl	%edi, %r14d
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$104, %rsp
	.cfi_def_cfa_offset 160
	cmpl	$1, %edi
	jle	.L37
	leal	-1(%rdi), %edx
	movl	%edi, %ebx
	xorl	%ebp, %ebp
	movl	%edx, %eax
	andl	$-2, %eax
	subl	%eax, %ebx
	movl	%edx, %eax
	movl	%ebx, %r13d
	movl	%ebp, %ebx
	movl	%edi, %ebp
	cmpl	%r13d, %ebp
	je	.L48
.L3:
	subl	$2, %ebp
	movl	%eax, %r14d
	xorl	%r15d, %r15d
	movl	%r13d, %esi
	movl	%ebp, %edx
	movl	%ebx, 36(%rsp)
	movl	%r15d, %r13d
	movl	%esi, %r15d
	andl	$-2, %edx
	subl	%edx, %r14d
	movl	%r14d, %ebx
.L9:
	leal	-1(%rax), %ecx
	movl	%ecx, %edx
	cmpl	%ebx, %eax
	je	.L49
.L6:
	subl	$2, %eax
	movl	%edx, %esi
	xorl	%r12d, %r12d
	movl	%ebp, %r14d
	movl	%eax, %ecx
	movl	%eax, 40(%rsp)
	andl	$-2, %ecx
	subl	%ecx, %esi
	movl	%esi, 64(%rsp)
.L13:
	leal	-1(%rdx), %ecx
	movl	%ecx, %r8d
	cmpl	%edx, 64(%rsp)
	je	.L50
	leal	-2(%rdx), %ecx
	movl	%r8d, %eax
	movl	%ebx, 48(%rsp)
	xorl	%ebp, %ebp
	movl	%ecx, %edx
	movl	%ecx, 52(%rsp)
	andl	$-2, %edx
	movl	%r12d, 44(%rsp)
	movl	%r14d, %r12d
	movl	%ebp, %r14d
	subl	%edx, %eax
	movl	%r15d, %ebp
	movl	%r13d, %r15d
	movl	%eax, 60(%rsp)
.L17:
	leal	-1(%r8), %edx
	movl	%edx, %r11d
	cmpl	%r8d, 60(%rsp)
	je	.L51
	subl	$2, %r8d
	movl	%r11d, %ebx
	movl	%r14d, %ecx
	xorl	%r13d, %r13d
	movl	%r8d, %edx
	movl	%r8d, 56(%rsp)
	movl	%r15d, %esi
	andl	$-2, %edx
	subl	%edx, %ebx
	movl	%ebp, %edx
	movl	%ebx, %r14d
	movl	%r12d, %ebx
.L21:
	leal	-1(%r11), %edi
	movl	%edi, %eax
	cmpl	%r11d, %r14d
	je	.L52
.L18:
	leal	-2(%r11), %r12d
	movl	%eax, %r10d
	xorl	%r15d, %r15d
	movl	%r12d, %edi
	movl	%r12d, 4(%rsp)
	andl	$-2, %edi
	subl	%edi, %r10d
	movl	%r10d, 12(%rsp)
	.p2align 4,,10
	.p2align 3
.L25:
	leal	-1(%rax), %edi
	movl	%edi, %ebp
	cmpl	%eax, 12(%rsp)
	je	.L53
	leal	-2(%rax), %r11d
	leal	-5(%rax), %r9d
	leal	-3(%rax), %r12d
	leal	-4(%rax), %r8d
	movl	%r11d, %eax
	andl	$-2, %eax
	movl	%r8d, %r10d
	subl	%eax, %edi
	xorl	%eax, %eax
	movl	%edi, 28(%rsp)
	movl	%r9d, %edi
	movl	%r12d, %r9d
.L29:
	movl	28(%rsp), %r8d
	cmpl	%r8d, %ebp
	je	.L54
	movl	%r9d, %r8d
	leal	-4(%rbp), %r12d
	movl	%esi, 16(%rsp)
	movl	%edi, %esi
	andl	$-2, %r8d
	movl	%ecx, 20(%rsp)
	movl	%eax, %ecx
	subl	%r8d, %r12d
	movl	%r10d, %r8d
	movl	%edx, 24(%rsp)
	andl	$-2, %r8d
	movl	%r12d, 8(%rsp)
	leal	-6(%rbp), %r12d
	subl	%r8d, %r12d
	movl	$0, (%rsp)
	movl	%ebx, %r8d
	movl	%r12d, 32(%rsp)
	movl	%edi, %r12d
	leal	2(%r12), %edx
	cmpl	%r12d, 8(%rsp)
	je	.L55
.L35:
	xorl	%ebx, %ebx
.L30:
	leal	-1(%rdx), %edi
	movl	%r11d, 92(%rsp)
	movl	%r8d, 88(%rsp)
	movl	%r9d, 84(%rsp)
	movl	%esi, 80(%rsp)
	movl	%r10d, 76(%rsp)
	movl	%ecx, 72(%rsp)
	movl	%edx, 68(%rsp)
	call	fib
	movl	68(%rsp), %edx
	movl	72(%rsp), %ecx
	addl	%eax, %ebx
	movl	76(%rsp), %r10d
	movl	80(%rsp), %esi
	subl	$2, %edx
	movl	84(%rsp), %r9d
	movl	88(%rsp), %r8d
	cmpl	$1, %edx
	movl	92(%rsp), %r11d
	jg	.L30
	movl	%r12d, %eax
	andl	$1, %eax
	addl	%ebx, %eax
	addl	%eax, (%rsp)
	leal	-2(%r12), %eax
	cmpl	%eax, 32(%rsp)
	je	.L32
	movl	%eax, %r12d
	leal	2(%r12), %edx
	cmpl	%r12d, 8(%rsp)
	jne	.L35
.L55:
	movl	(%rsp), %r12d
	movl	%ecx, %eax
	movl	%esi, %edi
	movl	%r8d, %ebx
	movl	20(%rsp), %ecx
	movl	%edx, %r8d
	movl	16(%rsp), %esi
	movl	24(%rsp), %edx
	addl	%r12d, %r8d
.L31:
	subl	$2, %ebp
	addl	%r8d, %eax
	subl	$2, %r9d
	subl	$2, %edi
	subl	$2, %r10d
	cmpl	$1, %ebp
	jne	.L29
	leal	1(%rax), %r10d
	movl	%r11d, %eax
	addl	%r10d, %r15d
	cmpl	$1, %r11d
	jne	.L25
	movl	4(%rsp), %r12d
	leal	1(%r15), %edi
.L58:
	movl	%r12d, %r11d
	addl	%edi, %r13d
	cmpl	$1, %r12d
	jne	.L21
.L57:
	movl	56(%rsp), %r8d
	movl	%esi, %r15d
	movl	%ecx, %r14d
	movl	%edx, %ebp
	movl	%ebx, %r12d
	leal	1(%r13), %edi
.L19:
	addl	%edi, %r14d
	cmpl	$1, %r8d
	jne	.L17
	movl	%r15d, %r13d
	movl	48(%rsp), %ebx
	movl	%ebp, %r15d
	movl	52(%rsp), %ecx
	movl	%r14d, %ebp
	movl	%r12d, %r14d
	movl	44(%rsp), %r12d
	leal	1(%rbp), %edi
.L15:
	movl	%ecx, %edx
	addl	%edi, %r12d
	cmpl	$1, %ecx
	jne	.L13
	movl	40(%rsp), %eax
	leal	1(%r12), %edx
	movl	%r14d, %ebp
	addl	%edx, %r13d
	cmpl	$1, %eax
	jne	.L9
.L59:
	movl	%r15d, %eax
	movl	36(%rsp), %ebx
	movl	%r13d, %r15d
	movl	%eax, %r13d
	leal	1(%r15), %eax
	addl	%eax, %ebx
	cmpl	$1, %ebp
	jne	.L56
.L38:
	leal	1(%rbx), %r14d
	jmp	.L37
	.p2align 4,,10
	.p2align 3
.L53:
	movl	4(%rsp), %r12d
	addl	%r15d, %edi
	addl	%edi, %r13d
	movl	%r12d, %r11d
	cmpl	$1, %r12d
	je	.L57
	leal	-1(%r11), %edi
	movl	%edi, %eax
	cmpl	%r11d, %r14d
	jne	.L18
.L52:
	movl	56(%rsp), %r8d
	movl	%esi, %r15d
	movl	%ecx, %r14d
	movl	%edx, %ebp
	movl	%ebx, %r12d
	addl	%r13d, %edi
	jmp	.L19
	.p2align 4,,10
	.p2align 3
.L54:
	leal	-1(%rbp,%rax), %r10d
	movl	%r11d, %eax
	addl	%r10d, %r15d
	cmpl	$1, %r11d
	jne	.L25
	movl	4(%rsp), %r12d
	leal	1(%r15), %edi
	jmp	.L58
.L51:
	movl	%r15d, %r13d
	movl	%ebp, %r15d
	movl	%r14d, %ebp
	movl	48(%rsp), %ebx
	movl	%r12d, %r14d
	movl	52(%rsp), %ecx
	movl	44(%rsp), %r12d
	leal	(%rdx,%rbp), %edi
	jmp	.L15
	.p2align 4,,10
	.p2align 3
.L32:
	movl	%r8d, %ebx
	movl	(%rsp), %r8d
	movl	%ecx, %eax
	movl	%esi, %edi
	movl	20(%rsp), %ecx
	movl	16(%rsp), %esi
	movl	24(%rsp), %edx
	leal	1(%r8,%r12), %r8d
	jmp	.L31
.L50:
	movl	40(%rsp), %eax
	leal	(%rcx,%r12), %edx
	movl	%r14d, %ebp
	addl	%edx, %r13d
	cmpl	$1, %eax
	je	.L59
	leal	-1(%rax), %ecx
	movl	%ecx, %edx
	cmpl	%ebx, %eax
	jne	.L6
.L49:
	movl	%r15d, %eax
	movl	36(%rsp), %ebx
	movl	%r13d, %r15d
	movl	%eax, %r13d
	leal	(%rcx,%r15), %eax
	addl	%eax, %ebx
	cmpl	$1, %ebp
	je	.L38
.L56:
	leal	-1(%rbp), %edx
	movl	%edx, %eax
	cmpl	%r13d, %ebp
	jne	.L3
.L48:
	leal	(%rdx,%rbx), %r14d
.L37:
	addq	$104, %rsp
	.cfi_def_cfa_offset 56
	movl	%r14d, %eax
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE23:
	.size	fib, .-fib
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"%d\n"
	.section	.text.startup,"ax",@progbits
	.p2align 4
	.globl	main
	.type	main, @function
main:
.LFB24:
	.cfi_startproc
	endbr64
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movl	$10, %edi
	call	fib
	leaq	.LC0(%rip), %rsi
	movl	$2, %edi
	movl	%eax, %edx
	xorl	%eax, %eax
	call	__printf_chk@PLT
	xorl	%eax, %eax
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE24:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
