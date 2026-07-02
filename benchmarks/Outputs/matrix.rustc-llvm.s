	.file	"matrix.7c455854eba01855-cgu.0"
	.section	.text._ZN3std2rt10lang_start17ha671827d9f6898aaE,"ax",@progbits
	.hidden	_ZN3std2rt10lang_start17ha671827d9f6898aaE
	.globl	_ZN3std2rt10lang_start17ha671827d9f6898aaE
	.p2align	4
	.type	_ZN3std2rt10lang_start17ha671827d9f6898aaE,@function
_ZN3std2rt10lang_start17ha671827d9f6898aaE:
	.cfi_startproc
	pushq	%rax
	.cfi_def_cfa_offset 16
	movl	%ecx, %eax
	movq	%rdx, %rcx
	movq	%rsi, %rdx
	movq	%rdi, (%rsp)
	movq	%rsp, %rdi
	leaq	.Lanon.003fac4c3e14b66300ca78915279e334.0(%rip), %rsi
	movzbl	%al, %r8d
	callq	*_RNvNtCs3JBboNF8E1m_3std2rt19lang_start_internal@GOTPCREL(%rip)
	popq	%rcx
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end0:
	.size	_ZN3std2rt10lang_start17ha671827d9f6898aaE, .Lfunc_end0-_ZN3std2rt10lang_start17ha671827d9f6898aaE
	.cfi_endproc

	.section	".text._ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17h4dacd4751bc04a7fE","ax",@progbits
	.p2align	4
	.type	_ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17h4dacd4751bc04a7fE,@function
_ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17h4dacd4751bc04a7fE:
	.cfi_startproc
	pushq	%rax
	.cfi_def_cfa_offset 16
	movq	(%rdi), %rdi
	callq	_ZN3std3sys9backtrace28__rust_begin_short_backtrace17h0e06d1c596a21f6dE
	callq	_ZN54_$LT$$LP$$RP$$u20$as$u20$std..process..Termination$GT$6report17h2bc06671d7d50dcbE
	movzbl	%al, %eax
	popq	%rcx
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end1:
	.size	_ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17h4dacd4751bc04a7fE, .Lfunc_end1-_ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17h4dacd4751bc04a7fE
	.cfi_endproc

	.section	.text._ZN3std3sys9backtrace28__rust_begin_short_backtrace17h0e06d1c596a21f6dE,"ax",@progbits
	.p2align	4
	.type	_ZN3std3sys9backtrace28__rust_begin_short_backtrace17h0e06d1c596a21f6dE,@function
_ZN3std3sys9backtrace28__rust_begin_short_backtrace17h0e06d1c596a21f6dE:
	.cfi_startproc
	pushq	%rax
	.cfi_def_cfa_offset 16
	callq	_ZN4core3ops8function6FnOnce9call_once17h4a9fe28ac7836c8dE
	#APP
	#NO_APP
	popq	%rax
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end2:
	.size	_ZN3std3sys9backtrace28__rust_begin_short_backtrace17h0e06d1c596a21f6dE, .Lfunc_end2-_ZN3std3sys9backtrace28__rust_begin_short_backtrace17h0e06d1c596a21f6dE
	.cfi_endproc

	.section	.text._ZN4core3fmt2rt8Argument11new_display17h35f1c1d936ff72baE,"ax",@progbits
	.p2align	4
	.type	_ZN4core3fmt2rt8Argument11new_display17h35f1c1d936ff72baE,@function
_ZN4core3fmt2rt8Argument11new_display17h35f1c1d936ff72baE:
	.cfi_startproc
	movq	%rdi, %rax
	movq	%rsi, -16(%rsp)
	movq	_RNvXs9_NtNtNtCs3BFokC4QLxY_4core3fmt3num3implNtB9_7Display3fmt@GOTPCREL(%rip), %rcx
	movq	%rcx, -8(%rsp)
	movq	-16(%rsp), %rcx
	movq	%rcx, (%rdi)
	movq	-8(%rsp), %rcx
	movq	%rcx, 8(%rdi)
	retq
.Lfunc_end3:
	.size	_ZN4core3fmt2rt8Argument11new_display17h35f1c1d936ff72baE, .Lfunc_end3-_ZN4core3fmt2rt8Argument11new_display17h35f1c1d936ff72baE
	.cfi_endproc

	.section	.text._ZN4core3fmt9Arguments3new17he5ec56e287a05772E,"ax",@progbits
	.p2align	4
	.type	_ZN4core3fmt9Arguments3new17he5ec56e287a05772E,@function
_ZN4core3fmt9Arguments3new17he5ec56e287a05772E:
	.cfi_startproc
	movq	%rsi, %rdx
	movq	%rdi, %rax
	retq
.Lfunc_end4:
	.size	_ZN4core3fmt9Arguments3new17he5ec56e287a05772E, .Lfunc_end4-_ZN4core3fmt9Arguments3new17he5ec56e287a05772E
	.cfi_endproc

	.section	".text._ZN4core3ops8function6FnOnce40call_once$u7b$$u7b$vtable.shim$u7d$$u7d$17h191a2c08f779ddbcE","ax",@progbits
	.p2align	4
	.type	_ZN4core3ops8function6FnOnce40call_once$u7b$$u7b$vtable.shim$u7d$$u7d$17h191a2c08f779ddbcE,@function
_ZN4core3ops8function6FnOnce40call_once$u7b$$u7b$vtable.shim$u7d$$u7d$17h191a2c08f779ddbcE:
	.cfi_startproc
	pushq	%rax
	.cfi_def_cfa_offset 16
	movq	(%rdi), %rdi
	callq	_ZN4core3ops8function6FnOnce9call_once17hf09fb54eb8e3c9ccE
	popq	%rcx
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end5:
	.size	_ZN4core3ops8function6FnOnce40call_once$u7b$$u7b$vtable.shim$u7d$$u7d$17h191a2c08f779ddbcE, .Lfunc_end5-_ZN4core3ops8function6FnOnce40call_once$u7b$$u7b$vtable.shim$u7d$$u7d$17h191a2c08f779ddbcE
	.cfi_endproc

	.section	.text._ZN4core3ops8function6FnOnce9call_once17h4a9fe28ac7836c8dE,"ax",@progbits
	.p2align	4
	.type	_ZN4core3ops8function6FnOnce9call_once17h4a9fe28ac7836c8dE,@function
_ZN4core3ops8function6FnOnce9call_once17h4a9fe28ac7836c8dE:
	.cfi_startproc
	pushq	%rax
	.cfi_def_cfa_offset 16
	callq	*%rdi
	popq	%rax
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end6:
	.size	_ZN4core3ops8function6FnOnce9call_once17h4a9fe28ac7836c8dE, .Lfunc_end6-_ZN4core3ops8function6FnOnce9call_once17h4a9fe28ac7836c8dE
	.cfi_endproc

	.section	.text._ZN4core3ops8function6FnOnce9call_once17hf09fb54eb8e3c9ccE,"ax",@progbits
	.p2align	4
	.type	_ZN4core3ops8function6FnOnce9call_once17hf09fb54eb8e3c9ccE,@function
_ZN4core3ops8function6FnOnce9call_once17hf09fb54eb8e3c9ccE:
.Lfunc_begin0:
	.cfi_startproc
	.cfi_personality 155, DW.ref.rust_eh_personality
	.cfi_lsda 27, .Lexception0
	subq	$40, %rsp
	.cfi_def_cfa_offset 48
	movq	%rdi, 8(%rsp)
.Ltmp0:
	leaq	8(%rsp), %rdi
	callq	_ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17h4dacd4751bc04a7fE
.Ltmp1:
	movl	%eax, 4(%rsp)
	jmp	.LBB7_3
.LBB7_1:
	movq	24(%rsp), %rdi
	callq	_Unwind_Resume@PLT
.LBB7_2:
.Ltmp2:
	movq	%rax, %rcx
	movl	%edx, %eax
	movq	%rcx, 24(%rsp)
	movl	%eax, 32(%rsp)
	jmp	.LBB7_1
.LBB7_3:
	movl	4(%rsp), %eax
	addq	$40, %rsp
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end7:
	.size	_ZN4core3ops8function6FnOnce9call_once17hf09fb54eb8e3c9ccE, .Lfunc_end7-_ZN4core3ops8function6FnOnce9call_once17hf09fb54eb8e3c9ccE
	.cfi_endproc
	.section	.gcc_except_table._ZN4core3ops8function6FnOnce9call_once17hf09fb54eb8e3c9ccE,"a",@progbits
	.p2align	2, 0x0
GCC_except_table7:
.Lexception0:
	.byte	255
	.byte	255
	.byte	1
	.uleb128 .Lcst_end0-.Lcst_begin0
.Lcst_begin0:
	.uleb128 .Ltmp0-.Lfunc_begin0
	.uleb128 .Ltmp1-.Ltmp0
	.uleb128 .Ltmp2-.Lfunc_begin0
	.byte	0
	.uleb128 .Ltmp1-.Lfunc_begin0
	.uleb128 .Lfunc_end7-.Ltmp1
	.byte	0
	.byte	0
.Lcst_end0:
	.p2align	2, 0x0

	.section	".text._ZN54_$LT$$LP$$RP$$u20$as$u20$std..process..Termination$GT$6report17h2bc06671d7d50dcbE","ax",@progbits
	.p2align	4
	.type	_ZN54_$LT$$LP$$RP$$u20$as$u20$std..process..Termination$GT$6report17h2bc06671d7d50dcbE,@function
_ZN54_$LT$$LP$$RP$$u20$as$u20$std..process..Termination$GT$6report17h2bc06671d7d50dcbE:
	.cfi_startproc
	xorl	%eax, %eax
	retq
.Lfunc_end8:
	.size	_ZN54_$LT$$LP$$RP$$u20$as$u20$std..process..Termination$GT$6report17h2bc06671d7d50dcbE, .Lfunc_end8-_ZN54_$LT$$LP$$RP$$u20$as$u20$std..process..Termination$GT$6report17h2bc06671d7d50dcbE
	.cfi_endproc

	.section	.text._ZN6matrix13matrix_kernel17h3383e53b2015ce92E,"ax",@progbits
	.p2align	4
	.type	_ZN6matrix13matrix_kernel17h3383e53b2015ce92E,@function
_ZN6matrix13matrix_kernel17h3383e53b2015ce92E:
	.cfi_startproc
	subq	$120, %rsp
	.cfi_def_cfa_offset 128
	leaq	100(%rsp), %rdi
	xorl	%esi, %esi
	movl	$12, %edx
	callq	memset@PLT
	leaq	64(%rsp), %rax
	leaq	64(%rsp), %rcx
	addq	$36, %rcx
	movq	%rcx, 48(%rsp)
	movq	%rax, 56(%rsp)
.LBB9_1:
	movq	48(%rsp), %rcx
	movq	56(%rsp), %rax
	movq	%rax, 40(%rsp)
	cmpq	%rcx, %rax
	je	.LBB9_3
	movq	40(%rsp), %rax
	movq	100(%rsp), %rcx
	movq	%rcx, (%rax)
	movl	108(%rsp), %ecx
	movl	%ecx, 8(%rax)
	addq	$12, %rax
	movq	%rax, 56(%rsp)
	jmp	.LBB9_1
.LBB9_3:
	movl	$0, 112(%rsp)
.LBB9_4:
	cmpl	$3, 112(%rsp)
	jl	.LBB9_6
	movl	80(%rsp), %eax
	addq	$120, %rsp
	.cfi_def_cfa_offset 8
	retq
.LBB9_6:
	.cfi_def_cfa_offset 128
	movl	$0, 116(%rsp)
.LBB9_7:
	cmpl	$3, 116(%rsp)
	jl	.LBB9_9
	movl	112(%rsp), %eax
	incl	%eax
	movl	%eax, 36(%rsp)
	seto	%al
	jo	.LBB9_11
	jmp	.LBB9_10
.LBB9_9:
	movl	112(%rsp), %eax
	addl	116(%rsp), %eax
	movl	%eax, 32(%rsp)
	seto	%al
	jo	.LBB9_13
	jmp	.LBB9_12
.LBB9_10:
	movl	36(%rsp), %eax
	movl	%eax, 112(%rsp)
	jmp	.LBB9_4
.LBB9_11:
	leaq	.Lanon.003fac4c3e14b66300ca78915279e334.2(%rip), %rdi
	callq	*_RNvNtNtCs3BFokC4QLxY_4core9panicking11panic_const24panic_const_add_overflow@GOTPCREL(%rip)
.LBB9_12:
	movslq	112(%rsp), %rax
	movq	%rax, 24(%rsp)
	cmpq	$3, %rax
	jb	.LBB9_14
	jmp	.LBB9_15
.LBB9_13:
	leaq	.Lanon.003fac4c3e14b66300ca78915279e334.3(%rip), %rdi
	callq	*_RNvNtNtCs3BFokC4QLxY_4core9panicking11panic_const24panic_const_add_overflow@GOTPCREL(%rip)
.LBB9_14:
	movslq	116(%rsp), %rax
	movq	%rax, 16(%rsp)
	cmpq	$3, %rax
	jb	.LBB9_16
	jmp	.LBB9_17
.LBB9_15:
	movq	24(%rsp), %rdi
	movl	$3, %esi
	leaq	.Lanon.003fac4c3e14b66300ca78915279e334.4(%rip), %rdx
	callq	*_RNvNtCs3BFokC4QLxY_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.LBB9_16:
	movq	16(%rsp), %rcx
	movl	32(%rsp), %edx
	movq	24(%rsp), %rsi
	leaq	64(%rsp), %rax
	imulq	$12, %rsi, %rsi
	addq	%rsi, %rax
	movl	%edx, (%rax,%rcx,4)
	movl	116(%rsp), %eax
	incl	%eax
	movl	%eax, 12(%rsp)
	seto	%al
	jo	.LBB9_19
	jmp	.LBB9_18
.LBB9_17:
	movq	16(%rsp), %rdi
	movl	$3, %esi
	leaq	.Lanon.003fac4c3e14b66300ca78915279e334.4(%rip), %rdx
	callq	*_RNvNtCs3BFokC4QLxY_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.LBB9_18:
	movl	12(%rsp), %eax
	movl	%eax, 116(%rsp)
	jmp	.LBB9_7
.LBB9_19:
	leaq	.Lanon.003fac4c3e14b66300ca78915279e334.5(%rip), %rdi
	callq	*_RNvNtNtCs3BFokC4QLxY_4core9panicking11panic_const24panic_const_add_overflow@GOTPCREL(%rip)
.Lfunc_end9:
	.size	_ZN6matrix13matrix_kernel17h3383e53b2015ce92E, .Lfunc_end9-_ZN6matrix13matrix_kernel17h3383e53b2015ce92E
	.cfi_endproc

	.section	.text._ZN6matrix4main17h8138f7241e25bc99E,"ax",@progbits
	.hidden	_ZN6matrix4main17h8138f7241e25bc99E
	.globl	_ZN6matrix4main17h8138f7241e25bc99E
	.p2align	4
	.type	_ZN6matrix4main17h8138f7241e25bc99E,@function
_ZN6matrix4main17h8138f7241e25bc99E:
	.cfi_startproc
	subq	$40, %rsp
	.cfi_def_cfa_offset 48
	callq	_ZN6matrix13matrix_kernel17h3383e53b2015ce92E
	movl	%eax, 4(%rsp)
	leaq	24(%rsp), %rdi
	leaq	4(%rsp), %rsi
	callq	_ZN4core3fmt2rt8Argument11new_display17h35f1c1d936ff72baE
	movq	24(%rsp), %rax
	movq	%rax, 8(%rsp)
	movq	32(%rsp), %rax
	movq	%rax, 16(%rsp)
	leaq	.Lanon.003fac4c3e14b66300ca78915279e334.6(%rip), %rdi
	leaq	8(%rsp), %rsi
	callq	_ZN4core3fmt9Arguments3new17he5ec56e287a05772E
	movq	%rax, %rdi
	movq	%rdx, %rsi
	callq	*_RNvNtNtCs3JBboNF8E1m_3std2io5stdio6__print@GOTPCREL(%rip)
	addq	$40, %rsp
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end10:
	.size	_ZN6matrix4main17h8138f7241e25bc99E, .Lfunc_end10-_ZN6matrix4main17h8138f7241e25bc99E
	.cfi_endproc

	.section	.text.main,"ax",@progbits
	.globl	main
	.p2align	4
	.type	main,@function
main:
	.cfi_startproc
	pushq	%rax
	.cfi_def_cfa_offset 16
	movq	%rsi, %rdx
	movslq	%edi, %rsi
	leaq	_ZN6matrix4main17h8138f7241e25bc99E(%rip), %rdi
	xorl	%ecx, %ecx
	callq	_ZN3std2rt10lang_start17ha671827d9f6898aaE
	popq	%rcx
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end11:
	.size	main, .Lfunc_end11-main
	.cfi_endproc

	.type	.Lanon.003fac4c3e14b66300ca78915279e334.0,@object
	.section	.data.rel.ro..Lanon.003fac4c3e14b66300ca78915279e334.0,"aw",@progbits
	.p2align	3, 0x0
.Lanon.003fac4c3e14b66300ca78915279e334.0:
	.asciz	"\000\000\000\000\000\000\000\000\b\000\000\000\000\000\000\000\b\000\000\000\000\000\000"
	.quad	_ZN4core3ops8function6FnOnce40call_once$u7b$$u7b$vtable.shim$u7d$$u7d$17h191a2c08f779ddbcE
	.quad	_ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17h4dacd4751bc04a7fE
	.quad	_ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17h4dacd4751bc04a7fE
	.size	.Lanon.003fac4c3e14b66300ca78915279e334.0, 48

	.type	.Lanon.003fac4c3e14b66300ca78915279e334.1,@object
	.section	.rodata.str1.1,"aMS",@progbits,1
.Lanon.003fac4c3e14b66300ca78915279e334.1:
	.asciz	"/mnt/d/UTEC/Compiladores/2026-1/Proyecto2/benchmarks/programs/matrix.rs"
	.size	.Lanon.003fac4c3e14b66300ca78915279e334.1, 72

	.type	.Lanon.003fac4c3e14b66300ca78915279e334.2,@object
	.section	.data.rel.ro..Lanon.003fac4c3e14b66300ca78915279e334.2,"aw",@progbits
	.p2align	3, 0x0
.Lanon.003fac4c3e14b66300ca78915279e334.2:
	.quad	.Lanon.003fac4c3e14b66300ca78915279e334.1
	.asciz	"G\000\000\000\000\000\000\000\n\000\000\000\r\000\000"
	.size	.Lanon.003fac4c3e14b66300ca78915279e334.2, 24

	.type	.Lanon.003fac4c3e14b66300ca78915279e334.3,@object
	.section	.data.rel.ro..Lanon.003fac4c3e14b66300ca78915279e334.3,"aw",@progbits
	.p2align	3, 0x0
.Lanon.003fac4c3e14b66300ca78915279e334.3:
	.quad	.Lanon.003fac4c3e14b66300ca78915279e334.1
	.asciz	"G\000\000\000\000\000\000\000\007\000\000\000)\000\000"
	.size	.Lanon.003fac4c3e14b66300ca78915279e334.3, 24

	.type	.Lanon.003fac4c3e14b66300ca78915279e334.4,@object
	.section	.data.rel.ro..Lanon.003fac4c3e14b66300ca78915279e334.4,"aw",@progbits
	.p2align	3, 0x0
.Lanon.003fac4c3e14b66300ca78915279e334.4:
	.quad	.Lanon.003fac4c3e14b66300ca78915279e334.1
	.asciz	"G\000\000\000\000\000\000\000\007\000\000\000\r\000\000"
	.size	.Lanon.003fac4c3e14b66300ca78915279e334.4, 24

	.type	.Lanon.003fac4c3e14b66300ca78915279e334.5,@object
	.section	.data.rel.ro..Lanon.003fac4c3e14b66300ca78915279e334.5,"aw",@progbits
	.p2align	3, 0x0
.Lanon.003fac4c3e14b66300ca78915279e334.5:
	.quad	.Lanon.003fac4c3e14b66300ca78915279e334.1
	.asciz	"G\000\000\000\000\000\000\000\b\000\000\000\021\000\000"
	.size	.Lanon.003fac4c3e14b66300ca78915279e334.5, 24

	.type	.Lanon.003fac4c3e14b66300ca78915279e334.6,@object
	.section	.rodata.str1.1,"aMS",@progbits,1
.Lanon.003fac4c3e14b66300ca78915279e334.6:
	.asciz	"\300\001\n"
	.size	.Lanon.003fac4c3e14b66300ca78915279e334.6, 4

	.hidden	DW.ref.rust_eh_personality
	.weak	DW.ref.rust_eh_personality
	.section	.data.DW.ref.rust_eh_personality,"awG",@progbits,DW.ref.rust_eh_personality,comdat
	.p2align	3, 0x0
	.type	DW.ref.rust_eh_personality,@object
	.size	DW.ref.rust_eh_personality, 8
DW.ref.rust_eh_personality:
	.quad	rust_eh_personality
	.ident	"rustc version 1.96.1 (31fca3adb 2026-06-26)"
	.section	".note.GNU-stack","",@progbits
