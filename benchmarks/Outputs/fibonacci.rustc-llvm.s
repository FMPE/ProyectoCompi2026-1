	.file	"fibonacci.ce77e83f187bd750-cgu.0"
	.section	.text._ZN3std2rt10lang_start17hab9c947f011132faE,"ax",@progbits
	.hidden	_ZN3std2rt10lang_start17hab9c947f011132faE
	.globl	_ZN3std2rt10lang_start17hab9c947f011132faE
	.p2align	4
	.type	_ZN3std2rt10lang_start17hab9c947f011132faE,@function
_ZN3std2rt10lang_start17hab9c947f011132faE:
	.cfi_startproc
	pushq	%rax
	.cfi_def_cfa_offset 16
	movl	%ecx, %eax
	movq	%rdx, %rcx
	movq	%rsi, %rdx
	movq	%rdi, (%rsp)
	movq	%rsp, %rdi
	leaq	.Lanon.ce7a49ed4384f08234815f3ba1ed404b.0(%rip), %rsi
	movzbl	%al, %r8d
	callq	*_RNvNtCs3JBboNF8E1m_3std2rt19lang_start_internal@GOTPCREL(%rip)
	popq	%rcx
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end0:
	.size	_ZN3std2rt10lang_start17hab9c947f011132faE, .Lfunc_end0-_ZN3std2rt10lang_start17hab9c947f011132faE
	.cfi_endproc

	.section	".text._ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17h818173bf1d2f4e79E","ax",@progbits
	.p2align	4
	.type	_ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17h818173bf1d2f4e79E,@function
_ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17h818173bf1d2f4e79E:
	.cfi_startproc
	pushq	%rax
	.cfi_def_cfa_offset 16
	movq	(%rdi), %rdi
	callq	_ZN3std3sys9backtrace28__rust_begin_short_backtrace17h4d85e18f78d60014E
	callq	_ZN54_$LT$$LP$$RP$$u20$as$u20$std..process..Termination$GT$6report17h9c6ae390fe16476dE
	movzbl	%al, %eax
	popq	%rcx
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end1:
	.size	_ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17h818173bf1d2f4e79E, .Lfunc_end1-_ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17h818173bf1d2f4e79E
	.cfi_endproc

	.section	.text._ZN3std3sys9backtrace28__rust_begin_short_backtrace17h4d85e18f78d60014E,"ax",@progbits
	.p2align	4
	.type	_ZN3std3sys9backtrace28__rust_begin_short_backtrace17h4d85e18f78d60014E,@function
_ZN3std3sys9backtrace28__rust_begin_short_backtrace17h4d85e18f78d60014E:
	.cfi_startproc
	pushq	%rax
	.cfi_def_cfa_offset 16
	callq	_ZN4core3ops8function6FnOnce9call_once17hdc188d6ebf76da65E
	#APP
	#NO_APP
	popq	%rax
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end2:
	.size	_ZN3std3sys9backtrace28__rust_begin_short_backtrace17h4d85e18f78d60014E, .Lfunc_end2-_ZN3std3sys9backtrace28__rust_begin_short_backtrace17h4d85e18f78d60014E
	.cfi_endproc

	.section	.text._ZN4core3fmt2rt8Argument11new_display17h8b4bdfdfdb09e8c7E,"ax",@progbits
	.p2align	4
	.type	_ZN4core3fmt2rt8Argument11new_display17h8b4bdfdfdb09e8c7E,@function
_ZN4core3fmt2rt8Argument11new_display17h8b4bdfdfdb09e8c7E:
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
	.size	_ZN4core3fmt2rt8Argument11new_display17h8b4bdfdfdb09e8c7E, .Lfunc_end3-_ZN4core3fmt2rt8Argument11new_display17h8b4bdfdfdb09e8c7E
	.cfi_endproc

	.section	.text._ZN4core3fmt9Arguments3new17h16dd8aefb2dcfec5E,"ax",@progbits
	.p2align	4
	.type	_ZN4core3fmt9Arguments3new17h16dd8aefb2dcfec5E,@function
_ZN4core3fmt9Arguments3new17h16dd8aefb2dcfec5E:
	.cfi_startproc
	movq	%rsi, %rdx
	movq	%rdi, %rax
	retq
.Lfunc_end4:
	.size	_ZN4core3fmt9Arguments3new17h16dd8aefb2dcfec5E, .Lfunc_end4-_ZN4core3fmt9Arguments3new17h16dd8aefb2dcfec5E
	.cfi_endproc

	.section	".text._ZN4core3ops8function6FnOnce40call_once$u7b$$u7b$vtable.shim$u7d$$u7d$17hd96a18a65ba89aa2E","ax",@progbits
	.p2align	4
	.type	_ZN4core3ops8function6FnOnce40call_once$u7b$$u7b$vtable.shim$u7d$$u7d$17hd96a18a65ba89aa2E,@function
_ZN4core3ops8function6FnOnce40call_once$u7b$$u7b$vtable.shim$u7d$$u7d$17hd96a18a65ba89aa2E:
	.cfi_startproc
	pushq	%rax
	.cfi_def_cfa_offset 16
	movq	(%rdi), %rdi
	callq	_ZN4core3ops8function6FnOnce9call_once17h3ec48736136e7c71E
	popq	%rcx
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end5:
	.size	_ZN4core3ops8function6FnOnce40call_once$u7b$$u7b$vtable.shim$u7d$$u7d$17hd96a18a65ba89aa2E, .Lfunc_end5-_ZN4core3ops8function6FnOnce40call_once$u7b$$u7b$vtable.shim$u7d$$u7d$17hd96a18a65ba89aa2E
	.cfi_endproc

	.section	.text._ZN4core3ops8function6FnOnce9call_once17h3ec48736136e7c71E,"ax",@progbits
	.p2align	4
	.type	_ZN4core3ops8function6FnOnce9call_once17h3ec48736136e7c71E,@function
_ZN4core3ops8function6FnOnce9call_once17h3ec48736136e7c71E:
.Lfunc_begin0:
	.cfi_startproc
	.cfi_personality 155, DW.ref.rust_eh_personality
	.cfi_lsda 27, .Lexception0
	subq	$40, %rsp
	.cfi_def_cfa_offset 48
	movq	%rdi, 8(%rsp)
.Ltmp0:
	leaq	8(%rsp), %rdi
	callq	_ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17h818173bf1d2f4e79E
.Ltmp1:
	movl	%eax, 4(%rsp)
	jmp	.LBB6_3
.LBB6_1:
	movq	24(%rsp), %rdi
	callq	_Unwind_Resume@PLT
.LBB6_2:
.Ltmp2:
	movq	%rax, %rcx
	movl	%edx, %eax
	movq	%rcx, 24(%rsp)
	movl	%eax, 32(%rsp)
	jmp	.LBB6_1
.LBB6_3:
	movl	4(%rsp), %eax
	addq	$40, %rsp
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end6:
	.size	_ZN4core3ops8function6FnOnce9call_once17h3ec48736136e7c71E, .Lfunc_end6-_ZN4core3ops8function6FnOnce9call_once17h3ec48736136e7c71E
	.cfi_endproc
	.section	.gcc_except_table._ZN4core3ops8function6FnOnce9call_once17h3ec48736136e7c71E,"a",@progbits
	.p2align	2, 0x0
GCC_except_table6:
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
	.uleb128 .Lfunc_end6-.Ltmp1
	.byte	0
	.byte	0
.Lcst_end0:
	.p2align	2, 0x0

	.section	.text._ZN4core3ops8function6FnOnce9call_once17hdc188d6ebf76da65E,"ax",@progbits
	.p2align	4
	.type	_ZN4core3ops8function6FnOnce9call_once17hdc188d6ebf76da65E,@function
_ZN4core3ops8function6FnOnce9call_once17hdc188d6ebf76da65E:
	.cfi_startproc
	pushq	%rax
	.cfi_def_cfa_offset 16
	callq	*%rdi
	popq	%rax
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end7:
	.size	_ZN4core3ops8function6FnOnce9call_once17hdc188d6ebf76da65E, .Lfunc_end7-_ZN4core3ops8function6FnOnce9call_once17hdc188d6ebf76da65E
	.cfi_endproc

	.section	".text._ZN54_$LT$$LP$$RP$$u20$as$u20$std..process..Termination$GT$6report17h9c6ae390fe16476dE","ax",@progbits
	.p2align	4
	.type	_ZN54_$LT$$LP$$RP$$u20$as$u20$std..process..Termination$GT$6report17h9c6ae390fe16476dE,@function
_ZN54_$LT$$LP$$RP$$u20$as$u20$std..process..Termination$GT$6report17h9c6ae390fe16476dE:
	.cfi_startproc
	xorl	%eax, %eax
	retq
.Lfunc_end8:
	.size	_ZN54_$LT$$LP$$RP$$u20$as$u20$std..process..Termination$GT$6report17h9c6ae390fe16476dE, .Lfunc_end8-_ZN54_$LT$$LP$$RP$$u20$as$u20$std..process..Termination$GT$6report17h9c6ae390fe16476dE
	.cfi_endproc

	.section	.text._ZN9fibonacci3fib17h701ee4c76d676afcE,"ax",@progbits
	.p2align	4
	.type	_ZN9fibonacci3fib17h701ee4c76d676afcE,@function
_ZN9fibonacci3fib17h701ee4c76d676afcE:
	.cfi_startproc
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	movl	%edi, 16(%rsp)
	cmpl	$1, %edi
	jle	.LBB9_2
	movl	16(%rsp), %eax
	decl	%eax
	movl	%eax, 12(%rsp)
	seto	%al
	jo	.LBB9_4
	jmp	.LBB9_3
.LBB9_2:
	movl	16(%rsp), %eax
	movl	%eax, 20(%rsp)
	jmp	.LBB9_9
.LBB9_3:
	movl	12(%rsp), %edi
	callq	_ZN9fibonacci3fib17h701ee4c76d676afcE
	movl	%eax, %ecx
	movl	16(%rsp), %eax
	movl	%ecx, 4(%rsp)
	subl	$2, %eax
	movl	%eax, 8(%rsp)
	seto	%al
	jo	.LBB9_6
	jmp	.LBB9_5
.LBB9_4:
	leaq	.Lanon.ce7a49ed4384f08234815f3ba1ed404b.2(%rip), %rdi
	callq	*_RNvNtNtCs3BFokC4QLxY_4core9panicking11panic_const24panic_const_sub_overflow@GOTPCREL(%rip)
.LBB9_5:
	movl	8(%rsp), %edi
	callq	_ZN9fibonacci3fib17h701ee4c76d676afcE
	movl	%eax, %ecx
	movl	4(%rsp), %eax
	addl	%ecx, %eax
	movl	%eax, (%rsp)
	seto	%al
	jo	.LBB9_8
	jmp	.LBB9_7
.LBB9_6:
	leaq	.Lanon.ce7a49ed4384f08234815f3ba1ed404b.3(%rip), %rdi
	callq	*_RNvNtNtCs3BFokC4QLxY_4core9panicking11panic_const24panic_const_sub_overflow@GOTPCREL(%rip)
.LBB9_7:
	movl	(%rsp), %eax
	movl	%eax, 20(%rsp)
	jmp	.LBB9_9
.LBB9_8:
	leaq	.Lanon.ce7a49ed4384f08234815f3ba1ed404b.4(%rip), %rdi
	callq	*_RNvNtNtCs3BFokC4QLxY_4core9panicking11panic_const24panic_const_add_overflow@GOTPCREL(%rip)
.LBB9_9:
	movl	20(%rsp), %eax
	addq	$24, %rsp
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end9:
	.size	_ZN9fibonacci3fib17h701ee4c76d676afcE, .Lfunc_end9-_ZN9fibonacci3fib17h701ee4c76d676afcE
	.cfi_endproc

	.section	.text._ZN9fibonacci4main17hb3d71d3da53ec9a9E,"ax",@progbits
	.hidden	_ZN9fibonacci4main17hb3d71d3da53ec9a9E
	.globl	_ZN9fibonacci4main17hb3d71d3da53ec9a9E
	.p2align	4
	.type	_ZN9fibonacci4main17hb3d71d3da53ec9a9E,@function
_ZN9fibonacci4main17hb3d71d3da53ec9a9E:
	.cfi_startproc
	subq	$40, %rsp
	.cfi_def_cfa_offset 48
	movl	$10, %edi
	callq	_ZN9fibonacci3fib17h701ee4c76d676afcE
	movl	%eax, 4(%rsp)
	leaq	24(%rsp), %rdi
	leaq	4(%rsp), %rsi
	callq	_ZN4core3fmt2rt8Argument11new_display17h8b4bdfdfdb09e8c7E
	movq	24(%rsp), %rax
	movq	%rax, 8(%rsp)
	movq	32(%rsp), %rax
	movq	%rax, 16(%rsp)
	leaq	.Lanon.ce7a49ed4384f08234815f3ba1ed404b.5(%rip), %rdi
	leaq	8(%rsp), %rsi
	callq	_ZN4core3fmt9Arguments3new17h16dd8aefb2dcfec5E
	movq	%rax, %rdi
	movq	%rdx, %rsi
	callq	*_RNvNtNtCs3JBboNF8E1m_3std2io5stdio6__print@GOTPCREL(%rip)
	addq	$40, %rsp
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end10:
	.size	_ZN9fibonacci4main17hb3d71d3da53ec9a9E, .Lfunc_end10-_ZN9fibonacci4main17hb3d71d3da53ec9a9E
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
	leaq	_ZN9fibonacci4main17hb3d71d3da53ec9a9E(%rip), %rdi
	xorl	%ecx, %ecx
	callq	_ZN3std2rt10lang_start17hab9c947f011132faE
	popq	%rcx
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end11:
	.size	main, .Lfunc_end11-main
	.cfi_endproc

	.type	.Lanon.ce7a49ed4384f08234815f3ba1ed404b.0,@object
	.section	.data.rel.ro..Lanon.ce7a49ed4384f08234815f3ba1ed404b.0,"aw",@progbits
	.p2align	3, 0x0
.Lanon.ce7a49ed4384f08234815f3ba1ed404b.0:
	.asciz	"\000\000\000\000\000\000\000\000\b\000\000\000\000\000\000\000\b\000\000\000\000\000\000"
	.quad	_ZN4core3ops8function6FnOnce40call_once$u7b$$u7b$vtable.shim$u7d$$u7d$17hd96a18a65ba89aa2E
	.quad	_ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17h818173bf1d2f4e79E
	.quad	_ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17h818173bf1d2f4e79E
	.size	.Lanon.ce7a49ed4384f08234815f3ba1ed404b.0, 48

	.type	.Lanon.ce7a49ed4384f08234815f3ba1ed404b.1,@object
	.section	.rodata.str1.1,"aMS",@progbits,1
.Lanon.ce7a49ed4384f08234815f3ba1ed404b.1:
	.asciz	"/mnt/d/UTEC/Compiladores/2026-1/Proyecto2/benchmarks/programs/fibonacci.rs"
	.size	.Lanon.ce7a49ed4384f08234815f3ba1ed404b.1, 75

	.type	.Lanon.ce7a49ed4384f08234815f3ba1ed404b.2,@object
	.section	.data.rel.ro..Lanon.ce7a49ed4384f08234815f3ba1ed404b.2,"aw",@progbits
	.p2align	3, 0x0
.Lanon.ce7a49ed4384f08234815f3ba1ed404b.2:
	.quad	.Lanon.ce7a49ed4384f08234815f3ba1ed404b.1
	.asciz	"J\000\000\000\000\000\000\000\003\000\000\000\020\000\000"
	.size	.Lanon.ce7a49ed4384f08234815f3ba1ed404b.2, 24

	.type	.Lanon.ce7a49ed4384f08234815f3ba1ed404b.3,@object
	.section	.data.rel.ro..Lanon.ce7a49ed4384f08234815f3ba1ed404b.3,"aw",@progbits
	.p2align	3, 0x0
.Lanon.ce7a49ed4384f08234815f3ba1ed404b.3:
	.quad	.Lanon.ce7a49ed4384f08234815f3ba1ed404b.1
	.asciz	"J\000\000\000\000\000\000\000\003\000\000\000\035\000\000"
	.size	.Lanon.ce7a49ed4384f08234815f3ba1ed404b.3, 24

	.type	.Lanon.ce7a49ed4384f08234815f3ba1ed404b.4,@object
	.section	.data.rel.ro..Lanon.ce7a49ed4384f08234815f3ba1ed404b.4,"aw",@progbits
	.p2align	3, 0x0
.Lanon.ce7a49ed4384f08234815f3ba1ed404b.4:
	.quad	.Lanon.ce7a49ed4384f08234815f3ba1ed404b.1
	.asciz	"J\000\000\000\000\000\000\000\003\000\000\000\f\000\000"
	.size	.Lanon.ce7a49ed4384f08234815f3ba1ed404b.4, 24

	.type	.Lanon.ce7a49ed4384f08234815f3ba1ed404b.5,@object
	.section	.rodata.str1.1,"aMS",@progbits,1
.Lanon.ce7a49ed4384f08234815f3ba1ed404b.5:
	.asciz	"\300\001\n"
	.size	.Lanon.ce7a49ed4384f08234815f3ba1ed404b.5, 4

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
