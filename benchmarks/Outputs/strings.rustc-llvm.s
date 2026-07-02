	.file	"strings.7f436d09218939e1-cgu.0"
	.section	.text._ZN3std2rt10lang_start17h926695e5ea8692f8E,"ax",@progbits
	.hidden	_ZN3std2rt10lang_start17h926695e5ea8692f8E
	.globl	_ZN3std2rt10lang_start17h926695e5ea8692f8E
	.p2align	4
	.type	_ZN3std2rt10lang_start17h926695e5ea8692f8E,@function
_ZN3std2rt10lang_start17h926695e5ea8692f8E:
	.cfi_startproc
	pushq	%rax
	.cfi_def_cfa_offset 16
	movl	%ecx, %eax
	movq	%rdx, %rcx
	movq	%rsi, %rdx
	movq	%rdi, (%rsp)
	movq	%rsp, %rdi
	leaq	.Lanon.02663c547ef69660c9fd334ed4bf5988.0(%rip), %rsi
	movzbl	%al, %r8d
	callq	*_RNvNtCs3JBboNF8E1m_3std2rt19lang_start_internal@GOTPCREL(%rip)
	popq	%rcx
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end0:
	.size	_ZN3std2rt10lang_start17h926695e5ea8692f8E, .Lfunc_end0-_ZN3std2rt10lang_start17h926695e5ea8692f8E
	.cfi_endproc

	.section	".text._ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17h6764bf152e0dd929E","ax",@progbits
	.p2align	4
	.type	_ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17h6764bf152e0dd929E,@function
_ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17h6764bf152e0dd929E:
	.cfi_startproc
	pushq	%rax
	.cfi_def_cfa_offset 16
	movq	(%rdi), %rdi
	callq	_ZN3std3sys9backtrace28__rust_begin_short_backtrace17hfe269e9cf672a625E
	callq	_ZN54_$LT$$LP$$RP$$u20$as$u20$std..process..Termination$GT$6report17hdc3753b11b23aacdE
	movzbl	%al, %eax
	popq	%rcx
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end1:
	.size	_ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17h6764bf152e0dd929E, .Lfunc_end1-_ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17h6764bf152e0dd929E
	.cfi_endproc

	.section	.text._ZN3std3sys9backtrace28__rust_begin_short_backtrace17hfe269e9cf672a625E,"ax",@progbits
	.p2align	4
	.type	_ZN3std3sys9backtrace28__rust_begin_short_backtrace17hfe269e9cf672a625E,@function
_ZN3std3sys9backtrace28__rust_begin_short_backtrace17hfe269e9cf672a625E:
	.cfi_startproc
	pushq	%rax
	.cfi_def_cfa_offset 16
	callq	_ZN4core3ops8function6FnOnce9call_once17h50335036244083d8E
	#APP
	#NO_APP
	popq	%rax
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end2:
	.size	_ZN3std3sys9backtrace28__rust_begin_short_backtrace17hfe269e9cf672a625E, .Lfunc_end2-_ZN3std3sys9backtrace28__rust_begin_short_backtrace17hfe269e9cf672a625E
	.cfi_endproc

	.section	.text._ZN4core3fmt2rt8Argument11new_display17h7cc24c1995a54ad2E,"ax",@progbits
	.p2align	4
	.type	_ZN4core3fmt2rt8Argument11new_display17h7cc24c1995a54ad2E,@function
_ZN4core3fmt2rt8Argument11new_display17h7cc24c1995a54ad2E:
	.cfi_startproc
	movq	%rdi, %rax
	movq	%rsi, -16(%rsp)
	movq	_RNvXs1i_NtCs3BFokC4QLxY_4core3fmtReNtB6_7Display3fmtCs43NoKGl62Ug_14rustc_demangle@GOTPCREL(%rip), %rcx
	movq	%rcx, -8(%rsp)
	movq	-16(%rsp), %rcx
	movq	%rcx, (%rdi)
	movq	-8(%rsp), %rcx
	movq	%rcx, 8(%rdi)
	retq
.Lfunc_end3:
	.size	_ZN4core3fmt2rt8Argument11new_display17h7cc24c1995a54ad2E, .Lfunc_end3-_ZN4core3fmt2rt8Argument11new_display17h7cc24c1995a54ad2E
	.cfi_endproc

	.section	.text._ZN4core3fmt2rt8Argument11new_display17h7d1f39d07fb630faE,"ax",@progbits
	.p2align	4
	.type	_ZN4core3fmt2rt8Argument11new_display17h7d1f39d07fb630faE,@function
_ZN4core3fmt2rt8Argument11new_display17h7d1f39d07fb630faE:
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
.Lfunc_end4:
	.size	_ZN4core3fmt2rt8Argument11new_display17h7d1f39d07fb630faE, .Lfunc_end4-_ZN4core3fmt2rt8Argument11new_display17h7d1f39d07fb630faE
	.cfi_endproc

	.section	.text._ZN4core3fmt9Arguments3new17hece25b4af574bb90E,"ax",@progbits
	.p2align	4
	.type	_ZN4core3fmt9Arguments3new17hece25b4af574bb90E,@function
_ZN4core3fmt9Arguments3new17hece25b4af574bb90E:
	.cfi_startproc
	movq	%rsi, %rdx
	movq	%rdi, %rax
	retq
.Lfunc_end5:
	.size	_ZN4core3fmt9Arguments3new17hece25b4af574bb90E, .Lfunc_end5-_ZN4core3fmt9Arguments3new17hece25b4af574bb90E
	.cfi_endproc

	.section	".text._ZN4core3ops8function6FnOnce40call_once$u7b$$u7b$vtable.shim$u7d$$u7d$17h066bd311a633cdc9E","ax",@progbits
	.p2align	4
	.type	_ZN4core3ops8function6FnOnce40call_once$u7b$$u7b$vtable.shim$u7d$$u7d$17h066bd311a633cdc9E,@function
_ZN4core3ops8function6FnOnce40call_once$u7b$$u7b$vtable.shim$u7d$$u7d$17h066bd311a633cdc9E:
	.cfi_startproc
	pushq	%rax
	.cfi_def_cfa_offset 16
	movq	(%rdi), %rdi
	callq	_ZN4core3ops8function6FnOnce9call_once17hc831c8e386900b5aE
	popq	%rcx
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end6:
	.size	_ZN4core3ops8function6FnOnce40call_once$u7b$$u7b$vtable.shim$u7d$$u7d$17h066bd311a633cdc9E, .Lfunc_end6-_ZN4core3ops8function6FnOnce40call_once$u7b$$u7b$vtable.shim$u7d$$u7d$17h066bd311a633cdc9E
	.cfi_endproc

	.section	.text._ZN4core3ops8function6FnOnce9call_once17h50335036244083d8E,"ax",@progbits
	.p2align	4
	.type	_ZN4core3ops8function6FnOnce9call_once17h50335036244083d8E,@function
_ZN4core3ops8function6FnOnce9call_once17h50335036244083d8E:
	.cfi_startproc
	pushq	%rax
	.cfi_def_cfa_offset 16
	callq	*%rdi
	popq	%rax
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end7:
	.size	_ZN4core3ops8function6FnOnce9call_once17h50335036244083d8E, .Lfunc_end7-_ZN4core3ops8function6FnOnce9call_once17h50335036244083d8E
	.cfi_endproc

	.section	.text._ZN4core3ops8function6FnOnce9call_once17hc831c8e386900b5aE,"ax",@progbits
	.p2align	4
	.type	_ZN4core3ops8function6FnOnce9call_once17hc831c8e386900b5aE,@function
_ZN4core3ops8function6FnOnce9call_once17hc831c8e386900b5aE:
.Lfunc_begin0:
	.cfi_startproc
	.cfi_personality 155, DW.ref.rust_eh_personality
	.cfi_lsda 27, .Lexception0
	subq	$40, %rsp
	.cfi_def_cfa_offset 48
	movq	%rdi, 8(%rsp)
.Ltmp0:
	leaq	8(%rsp), %rdi
	callq	_ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17h6764bf152e0dd929E
.Ltmp1:
	movl	%eax, 4(%rsp)
	jmp	.LBB8_3
.LBB8_1:
	movq	24(%rsp), %rdi
	callq	_Unwind_Resume@PLT
.LBB8_2:
.Ltmp2:
	movq	%rax, %rcx
	movl	%edx, %eax
	movq	%rcx, 24(%rsp)
	movl	%eax, 32(%rsp)
	jmp	.LBB8_1
.LBB8_3:
	movl	4(%rsp), %eax
	addq	$40, %rsp
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end8:
	.size	_ZN4core3ops8function6FnOnce9call_once17hc831c8e386900b5aE, .Lfunc_end8-_ZN4core3ops8function6FnOnce9call_once17hc831c8e386900b5aE
	.cfi_endproc
	.section	.gcc_except_table._ZN4core3ops8function6FnOnce9call_once17hc831c8e386900b5aE,"a",@progbits
	.p2align	2, 0x0
GCC_except_table8:
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
	.uleb128 .Lfunc_end8-.Ltmp1
	.byte	0
	.byte	0
.Lcst_end0:
	.p2align	2, 0x0

	.section	".text._ZN54_$LT$$LP$$RP$$u20$as$u20$std..process..Termination$GT$6report17hdc3753b11b23aacdE","ax",@progbits
	.p2align	4
	.type	_ZN54_$LT$$LP$$RP$$u20$as$u20$std..process..Termination$GT$6report17hdc3753b11b23aacdE,@function
_ZN54_$LT$$LP$$RP$$u20$as$u20$std..process..Termination$GT$6report17hdc3753b11b23aacdE:
	.cfi_startproc
	xorl	%eax, %eax
	retq
.Lfunc_end9:
	.size	_ZN54_$LT$$LP$$RP$$u20$as$u20$std..process..Termination$GT$6report17hdc3753b11b23aacdE, .Lfunc_end9-_ZN54_$LT$$LP$$RP$$u20$as$u20$std..process..Termination$GT$6report17hdc3753b11b23aacdE
	.cfi_endproc

	.section	.text._ZN7strings4main17h0a4ac7a4024a05a5E,"ax",@progbits
	.hidden	_ZN7strings4main17h0a4ac7a4024a05a5E
	.globl	_ZN7strings4main17h0a4ac7a4024a05a5E
	.p2align	4
	.type	_ZN7strings4main17h0a4ac7a4024a05a5E,@function
_ZN7strings4main17h0a4ac7a4024a05a5E:
	.cfi_startproc
	subq	$88, %rsp
	.cfi_def_cfa_offset 96
	leaq	.Lanon.02663c547ef69660c9fd334ed4bf5988.1(%rip), %rax
	movq	%rax, (%rsp)
	movq	$12, 8(%rsp)
	movl	$42, 20(%rsp)
	leaq	40(%rsp), %rdi
	leaq	20(%rsp), %rsi
	callq	_ZN4core3fmt2rt8Argument11new_display17h7d1f39d07fb630faE
	movq	40(%rsp), %rax
	movq	%rax, 24(%rsp)
	movq	48(%rsp), %rax
	movq	%rax, 32(%rsp)
	leaq	.Lanon.02663c547ef69660c9fd334ed4bf5988.2(%rip), %rdi
	leaq	24(%rsp), %rsi
	callq	_ZN4core3fmt9Arguments3new17hece25b4af574bb90E
	movq	%rax, %rdi
	movq	%rdx, %rsi
	callq	*_RNvNtNtCs3JBboNF8E1m_3std2io5stdio6__print@GOTPCREL(%rip)
	leaq	72(%rsp), %rdi
	movq	%rsp, %rsi
	callq	_ZN4core3fmt2rt8Argument11new_display17h7cc24c1995a54ad2E
	movq	72(%rsp), %rax
	movq	%rax, 56(%rsp)
	movq	80(%rsp), %rax
	movq	%rax, 64(%rsp)
	leaq	.Lanon.02663c547ef69660c9fd334ed4bf5988.2(%rip), %rdi
	leaq	56(%rsp), %rsi
	callq	_ZN4core3fmt9Arguments3new17hece25b4af574bb90E
	movq	%rax, %rdi
	movq	%rdx, %rsi
	callq	*_RNvNtNtCs3JBboNF8E1m_3std2io5stdio6__print@GOTPCREL(%rip)
	addq	$88, %rsp
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end10:
	.size	_ZN7strings4main17h0a4ac7a4024a05a5E, .Lfunc_end10-_ZN7strings4main17h0a4ac7a4024a05a5E
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
	leaq	_ZN7strings4main17h0a4ac7a4024a05a5E(%rip), %rdi
	xorl	%ecx, %ecx
	callq	_ZN3std2rt10lang_start17h926695e5ea8692f8E
	popq	%rcx
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end11:
	.size	main, .Lfunc_end11-main
	.cfi_endproc

	.type	.Lanon.02663c547ef69660c9fd334ed4bf5988.0,@object
	.section	.data.rel.ro..Lanon.02663c547ef69660c9fd334ed4bf5988.0,"aw",@progbits
	.p2align	3, 0x0
.Lanon.02663c547ef69660c9fd334ed4bf5988.0:
	.asciz	"\000\000\000\000\000\000\000\000\b\000\000\000\000\000\000\000\b\000\000\000\000\000\000"
	.quad	_ZN4core3ops8function6FnOnce40call_once$u7b$$u7b$vtable.shim$u7d$$u7d$17h066bd311a633cdc9E
	.quad	_ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17h6764bf152e0dd929E
	.quad	_ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17h6764bf152e0dd929E
	.size	.Lanon.02663c547ef69660c9fd334ed4bf5988.0, 48

	.type	.Lanon.02663c547ef69660c9fd334ed4bf5988.1,@object
	.section	.rodata..Lanon.02663c547ef69660c9fd334ed4bf5988.1,"a",@progbits
.Lanon.02663c547ef69660c9fd334ed4bf5988.1:
	.ascii	"Benchmark OK"
	.size	.Lanon.02663c547ef69660c9fd334ed4bf5988.1, 12

	.type	.Lanon.02663c547ef69660c9fd334ed4bf5988.2,@object
	.section	.rodata.str1.1,"aMS",@progbits,1
.Lanon.02663c547ef69660c9fd334ed4bf5988.2:
	.asciz	"\300\001\n"
	.size	.Lanon.02663c547ef69660c9fd334ed4bf5988.2, 4

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
