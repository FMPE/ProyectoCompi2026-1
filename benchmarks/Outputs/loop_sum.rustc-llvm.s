	.file	"loop_sum.621b35551b9eeb44-cgu.0"
	.section	.text._ZN3std2rt10lang_start17hb97162bccb5dd815E,"ax",@progbits
	.hidden	_ZN3std2rt10lang_start17hb97162bccb5dd815E
	.globl	_ZN3std2rt10lang_start17hb97162bccb5dd815E
	.p2align	4
	.type	_ZN3std2rt10lang_start17hb97162bccb5dd815E,@function
_ZN3std2rt10lang_start17hb97162bccb5dd815E:
	.cfi_startproc
	pushq	%rax
	.cfi_def_cfa_offset 16
	movl	%ecx, %eax
	movq	%rdx, %rcx
	movq	%rsi, %rdx
	movq	%rdi, (%rsp)
	movq	%rsp, %rdi
	leaq	.Lanon.5c825456d79c55130b5e246078ef4170.0(%rip), %rsi
	movzbl	%al, %r8d
	callq	*_RNvNtCs3JBboNF8E1m_3std2rt19lang_start_internal@GOTPCREL(%rip)
	popq	%rcx
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end0:
	.size	_ZN3std2rt10lang_start17hb97162bccb5dd815E, .Lfunc_end0-_ZN3std2rt10lang_start17hb97162bccb5dd815E
	.cfi_endproc

	.section	".text._ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17h5cdf34b9eb5e7097E","ax",@progbits
	.p2align	4
	.type	_ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17h5cdf34b9eb5e7097E,@function
_ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17h5cdf34b9eb5e7097E:
	.cfi_startproc
	pushq	%rax
	.cfi_def_cfa_offset 16
	movq	(%rdi), %rdi
	callq	_ZN3std3sys9backtrace28__rust_begin_short_backtrace17hba0944bb2bcd5661E
	callq	_ZN54_$LT$$LP$$RP$$u20$as$u20$std..process..Termination$GT$6report17h8e158d65860cf338E
	movzbl	%al, %eax
	popq	%rcx
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end1:
	.size	_ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17h5cdf34b9eb5e7097E, .Lfunc_end1-_ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17h5cdf34b9eb5e7097E
	.cfi_endproc

	.section	.text._ZN3std3sys9backtrace28__rust_begin_short_backtrace17hba0944bb2bcd5661E,"ax",@progbits
	.p2align	4
	.type	_ZN3std3sys9backtrace28__rust_begin_short_backtrace17hba0944bb2bcd5661E,@function
_ZN3std3sys9backtrace28__rust_begin_short_backtrace17hba0944bb2bcd5661E:
	.cfi_startproc
	pushq	%rax
	.cfi_def_cfa_offset 16
	callq	_ZN4core3ops8function6FnOnce9call_once17hb5b25c0babb48ad6E
	#APP
	#NO_APP
	popq	%rax
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end2:
	.size	_ZN3std3sys9backtrace28__rust_begin_short_backtrace17hba0944bb2bcd5661E, .Lfunc_end2-_ZN3std3sys9backtrace28__rust_begin_short_backtrace17hba0944bb2bcd5661E
	.cfi_endproc

	.section	".text._ZN47_$LT$i32$u20$as$u20$core..iter..range..Step$GT$17forward_unchecked17hfa87307b6f0aa4feE","ax",@progbits
	.p2align	4
	.type	_ZN47_$LT$i32$u20$as$u20$core..iter..range..Step$GT$17forward_unchecked17hfa87307b6f0aa4feE,@function
_ZN47_$LT$i32$u20$as$u20$core..iter..range..Step$GT$17forward_unchecked17hfa87307b6f0aa4feE:
	.cfi_startproc
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	movl	%esi, %ecx
	addl	%ecx, %edi
	movl	%edi, 12(%rsp)
	seto	%al
	cmpl	$0, %ecx
	setl	%cl
	xorb	%cl, %al
	testb	$1, %al
	jne	.LBB3_2
	movl	12(%rsp), %eax
	movl	%eax, 20(%rsp)
	movl	$1, 16(%rsp)
	movl	20(%rsp), %eax
	addq	$24, %rsp
	.cfi_def_cfa_offset 8
	retq
.LBB3_2:
	.cfi_def_cfa_offset 32
	movl	.Lanon.5c825456d79c55130b5e246078ef4170.1(%rip), %ecx
	movl	.Lanon.5c825456d79c55130b5e246078ef4170.1+4(%rip), %eax
	movl	%ecx, 16(%rsp)
	movl	%eax, 20(%rsp)
	leaq	.Lanon.5c825456d79c55130b5e246078ef4170.3(%rip), %rdi
	callq	_ZN4core4hint21unreachable_unchecked18precondition_check17hefd69658f677da14E
	ud2
.Lfunc_end3:
	.size	_ZN47_$LT$i32$u20$as$u20$core..iter..range..Step$GT$17forward_unchecked17hfa87307b6f0aa4feE, .Lfunc_end3-_ZN47_$LT$i32$u20$as$u20$core..iter..range..Step$GT$17forward_unchecked17hfa87307b6f0aa4feE
	.cfi_endproc

	.section	.text._ZN4core10intrinsics9cold_path17hd6ad6821f8ff4b61E,"ax",@progbits
	.p2align	4
	.type	_ZN4core10intrinsics9cold_path17hd6ad6821f8ff4b61E,@function
_ZN4core10intrinsics9cold_path17hd6ad6821f8ff4b61E:
	.cfi_startproc
	retq
.Lfunc_end4:
	.size	_ZN4core10intrinsics9cold_path17hd6ad6821f8ff4b61E, .Lfunc_end4-_ZN4core10intrinsics9cold_path17hd6ad6821f8ff4b61E
	.cfi_endproc

	.section	.text._ZN4core3fmt2rt8Argument11new_display17h2a49edc74238e0d9E,"ax",@progbits
	.p2align	4
	.type	_ZN4core3fmt2rt8Argument11new_display17h2a49edc74238e0d9E,@function
_ZN4core3fmt2rt8Argument11new_display17h2a49edc74238e0d9E:
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
.Lfunc_end5:
	.size	_ZN4core3fmt2rt8Argument11new_display17h2a49edc74238e0d9E, .Lfunc_end5-_ZN4core3fmt2rt8Argument11new_display17h2a49edc74238e0d9E
	.cfi_endproc

	.section	.text._ZN4core3fmt9Arguments3new17h17da825339018411E,"ax",@progbits
	.p2align	4
	.type	_ZN4core3fmt9Arguments3new17h17da825339018411E,@function
_ZN4core3fmt9Arguments3new17h17da825339018411E:
	.cfi_startproc
	movq	%rsi, %rdx
	movq	%rdi, %rax
	retq
.Lfunc_end6:
	.size	_ZN4core3fmt9Arguments3new17h17da825339018411E, .Lfunc_end6-_ZN4core3fmt9Arguments3new17h17da825339018411E
	.cfi_endproc

	.section	".text._ZN4core3ops8function6FnOnce40call_once$u7b$$u7b$vtable.shim$u7d$$u7d$17h2ab83b71a49479d6E","ax",@progbits
	.p2align	4
	.type	_ZN4core3ops8function6FnOnce40call_once$u7b$$u7b$vtable.shim$u7d$$u7d$17h2ab83b71a49479d6E,@function
_ZN4core3ops8function6FnOnce40call_once$u7b$$u7b$vtable.shim$u7d$$u7d$17h2ab83b71a49479d6E:
	.cfi_startproc
	pushq	%rax
	.cfi_def_cfa_offset 16
	movq	(%rdi), %rdi
	callq	_ZN4core3ops8function6FnOnce9call_once17h8090cf27cdb8f00bE
	popq	%rcx
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end7:
	.size	_ZN4core3ops8function6FnOnce40call_once$u7b$$u7b$vtable.shim$u7d$$u7d$17h2ab83b71a49479d6E, .Lfunc_end7-_ZN4core3ops8function6FnOnce40call_once$u7b$$u7b$vtable.shim$u7d$$u7d$17h2ab83b71a49479d6E
	.cfi_endproc

	.section	.text._ZN4core3ops8function6FnOnce9call_once17h8090cf27cdb8f00bE,"ax",@progbits
	.p2align	4
	.type	_ZN4core3ops8function6FnOnce9call_once17h8090cf27cdb8f00bE,@function
_ZN4core3ops8function6FnOnce9call_once17h8090cf27cdb8f00bE:
.Lfunc_begin0:
	.cfi_startproc
	.cfi_personality 155, DW.ref.rust_eh_personality
	.cfi_lsda 27, .Lexception0
	subq	$40, %rsp
	.cfi_def_cfa_offset 48
	movq	%rdi, 8(%rsp)
.Ltmp0:
	leaq	8(%rsp), %rdi
	callq	_ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17h5cdf34b9eb5e7097E
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
	.size	_ZN4core3ops8function6FnOnce9call_once17h8090cf27cdb8f00bE, .Lfunc_end8-_ZN4core3ops8function6FnOnce9call_once17h8090cf27cdb8f00bE
	.cfi_endproc
	.section	.gcc_except_table._ZN4core3ops8function6FnOnce9call_once17h8090cf27cdb8f00bE,"a",@progbits
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

	.section	.text._ZN4core3ops8function6FnOnce9call_once17hb5b25c0babb48ad6E,"ax",@progbits
	.p2align	4
	.type	_ZN4core3ops8function6FnOnce9call_once17hb5b25c0babb48ad6E,@function
_ZN4core3ops8function6FnOnce9call_once17hb5b25c0babb48ad6E:
	.cfi_startproc
	pushq	%rax
	.cfi_def_cfa_offset 16
	callq	*%rdi
	popq	%rax
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end9:
	.size	_ZN4core3ops8function6FnOnce9call_once17hb5b25c0babb48ad6E, .Lfunc_end9-_ZN4core3ops8function6FnOnce9call_once17hb5b25c0babb48ad6E
	.cfi_endproc

	.section	.text._ZN4core4hint21unreachable_unchecked18precondition_check17hefd69658f677da14E,"ax",@progbits
	.p2align	4
	.type	_ZN4core4hint21unreachable_unchecked18precondition_check17hefd69658f677da14E,@function
_ZN4core4hint21unreachable_unchecked18precondition_check17hefd69658f677da14E:
	.cfi_startproc
	pushq	%rax
	.cfi_def_cfa_offset 16
	movq	%rdi, %rcx
	leaq	.Lanon.5c825456d79c55130b5e246078ef4170.4(%rip), %rdi
	movl	$399, %esi
	xorl	%edx, %edx
	callq	*_RNvNtCs3BFokC4QLxY_4core9panicking18panic_nounwind_fmt@GOTPCREL(%rip)
.Lfunc_end10:
	.size	_ZN4core4hint21unreachable_unchecked18precondition_check17hefd69658f677da14E, .Lfunc_end10-_ZN4core4hint21unreachable_unchecked18precondition_check17hefd69658f677da14E
	.cfi_endproc

	.section	".text._ZN4core4iter5range101_$LT$impl$u20$core..iter..traits..iterator..Iterator$u20$for$u20$core..ops..range..Range$LT$A$GT$$GT$4next17ha3e0145446b92c76E","ax",@progbits
	.p2align	4
	.type	_ZN4core4iter5range101_$LT$impl$u20$core..iter..traits..iterator..Iterator$u20$for$u20$core..ops..range..Range$LT$A$GT$$GT$4next17ha3e0145446b92c76E,@function
_ZN4core4iter5range101_$LT$impl$u20$core..iter..traits..iterator..Iterator$u20$for$u20$core..ops..range..Range$LT$A$GT$$GT$4next17ha3e0145446b92c76E:
	.cfi_startproc
	pushq	%rax
	.cfi_def_cfa_offset 16
	callq	_ZN89_$LT$core..ops..range..Range$LT$T$GT$$u20$as$u20$core..iter..range..RangeIteratorImpl$GT$9spec_next17hd435b6a61f1d701aE
	popq	%rcx
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end11:
	.size	_ZN4core4iter5range101_$LT$impl$u20$core..iter..traits..iterator..Iterator$u20$for$u20$core..ops..range..Range$LT$A$GT$$GT$4next17ha3e0145446b92c76E, .Lfunc_end11-_ZN4core4iter5range101_$LT$impl$u20$core..iter..traits..iterator..Iterator$u20$for$u20$core..ops..range..Range$LT$A$GT$$GT$4next17ha3e0145446b92c76E
	.cfi_endproc

	.section	".text._ZN54_$LT$$LP$$RP$$u20$as$u20$std..process..Termination$GT$6report17h8e158d65860cf338E","ax",@progbits
	.p2align	4
	.type	_ZN54_$LT$$LP$$RP$$u20$as$u20$std..process..Termination$GT$6report17h8e158d65860cf338E,@function
_ZN54_$LT$$LP$$RP$$u20$as$u20$std..process..Termination$GT$6report17h8e158d65860cf338E:
	.cfi_startproc
	xorl	%eax, %eax
	retq
.Lfunc_end12:
	.size	_ZN54_$LT$$LP$$RP$$u20$as$u20$std..process..Termination$GT$6report17h8e158d65860cf338E, .Lfunc_end12-_ZN54_$LT$$LP$$RP$$u20$as$u20$std..process..Termination$GT$6report17h8e158d65860cf338E
	.cfi_endproc

	.section	".text._ZN63_$LT$I$u20$as$u20$core..iter..traits..collect..IntoIterator$GT$9into_iter17h9d6b4f2f21a81c00E","ax",@progbits
	.p2align	4
	.type	_ZN63_$LT$I$u20$as$u20$core..iter..traits..collect..IntoIterator$GT$9into_iter17h9d6b4f2f21a81c00E,@function
_ZN63_$LT$I$u20$as$u20$core..iter..traits..collect..IntoIterator$GT$9into_iter17h9d6b4f2f21a81c00E:
	.cfi_startproc
	movl	%esi, %edx
	movl	%edi, %eax
	retq
.Lfunc_end13:
	.size	_ZN63_$LT$I$u20$as$u20$core..iter..traits..collect..IntoIterator$GT$9into_iter17h9d6b4f2f21a81c00E, .Lfunc_end13-_ZN63_$LT$I$u20$as$u20$core..iter..traits..collect..IntoIterator$GT$9into_iter17h9d6b4f2f21a81c00E
	.cfi_endproc

	.section	".text._ZN89_$LT$core..ops..range..Range$LT$T$GT$$u20$as$u20$core..iter..range..RangeIteratorImpl$GT$9spec_next17hd435b6a61f1d701aE","ax",@progbits
	.p2align	4
	.type	_ZN89_$LT$core..ops..range..Range$LT$T$GT$$u20$as$u20$core..iter..range..RangeIteratorImpl$GT$9spec_next17hd435b6a61f1d701aE,@function
_ZN89_$LT$core..ops..range..Range$LT$T$GT$$u20$as$u20$core..iter..range..RangeIteratorImpl$GT$9spec_next17hd435b6a61f1d701aE:
	.cfi_startproc
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	movq	%rdi, 8(%rsp)
	movl	(%rdi), %eax
	cmpl	4(%rdi), %eax
	jl	.LBB14_2
	movl	$0, 16(%rsp)
	jmp	.LBB14_3
.LBB14_2:
	movq	8(%rsp), %rax
	movl	(%rax), %edi
	movl	%edi, 4(%rsp)
	movl	$1, %esi
	callq	_ZN47_$LT$i32$u20$as$u20$core..iter..range..Step$GT$17forward_unchecked17hfa87307b6f0aa4feE
	movq	8(%rsp), %rcx
	movl	%eax, %edx
	movl	4(%rsp), %eax
	movl	%edx, (%rcx)
	movl	%eax, 20(%rsp)
	movl	$1, 16(%rsp)
.LBB14_3:
	movl	16(%rsp), %eax
	movl	20(%rsp), %edx
	addq	$24, %rsp
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end14:
	.size	_ZN89_$LT$core..ops..range..Range$LT$T$GT$$u20$as$u20$core..iter..range..RangeIteratorImpl$GT$9spec_next17hd435b6a61f1d701aE, .Lfunc_end14-_ZN89_$LT$core..ops..range..Range$LT$T$GT$$u20$as$u20$core..iter..range..RangeIteratorImpl$GT$9spec_next17hd435b6a61f1d701aE
	.cfi_endproc

	.section	.text._ZN8loop_sum15loop_sum_kernel17h06afd02cdbea9a07E,"ax",@progbits
	.p2align	4
	.type	_ZN8loop_sum15loop_sum_kernel17h06afd02cdbea9a07E,@function
_ZN8loop_sum15loop_sum_kernel17h06afd02cdbea9a07E:
	.cfi_startproc
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	movl	$0, 4(%rsp)
	xorl	%edi, %edi
	movl	$1000, %esi
	callq	_ZN63_$LT$I$u20$as$u20$core..iter..traits..collect..IntoIterator$GT$9into_iter17h9d6b4f2f21a81c00E
	movl	%eax, 8(%rsp)
	movl	%edx, 12(%rsp)
.LBB15_1:
	leaq	8(%rsp), %rdi
	callq	_ZN4core4iter5range101_$LT$impl$u20$core..iter..traits..iterator..Iterator$u20$for$u20$core..ops..range..Range$LT$A$GT$$GT$4next17ha3e0145446b92c76E
	movl	%eax, 16(%rsp)
	movl	%edx, 20(%rsp)
	movl	16(%rsp), %eax
	testq	$1, %rax
	je	.LBB15_3
	movl	20(%rsp), %eax
	addl	4(%rsp), %eax
	movl	%eax, (%rsp)
	seto	%al
	jo	.LBB15_5
	jmp	.LBB15_4
.LBB15_3:
	movl	4(%rsp), %eax
	addq	$24, %rsp
	.cfi_def_cfa_offset 8
	retq
.LBB15_4:
	.cfi_def_cfa_offset 32
	movl	(%rsp), %eax
	movl	%eax, 4(%rsp)
	jmp	.LBB15_1
.LBB15_5:
	leaq	.Lanon.5c825456d79c55130b5e246078ef4170.6(%rip), %rdi
	callq	*_RNvNtNtCs3BFokC4QLxY_4core9panicking11panic_const24panic_const_add_overflow@GOTPCREL(%rip)
.Lfunc_end15:
	.size	_ZN8loop_sum15loop_sum_kernel17h06afd02cdbea9a07E, .Lfunc_end15-_ZN8loop_sum15loop_sum_kernel17h06afd02cdbea9a07E
	.cfi_endproc

	.section	.text._ZN8loop_sum4main17hf0e5bb41ed104d8fE,"ax",@progbits
	.hidden	_ZN8loop_sum4main17hf0e5bb41ed104d8fE
	.globl	_ZN8loop_sum4main17hf0e5bb41ed104d8fE
	.p2align	4
	.type	_ZN8loop_sum4main17hf0e5bb41ed104d8fE,@function
_ZN8loop_sum4main17hf0e5bb41ed104d8fE:
	.cfi_startproc
	subq	$40, %rsp
	.cfi_def_cfa_offset 48
	callq	_ZN8loop_sum15loop_sum_kernel17h06afd02cdbea9a07E
	movl	%eax, 4(%rsp)
	leaq	24(%rsp), %rdi
	leaq	4(%rsp), %rsi
	callq	_ZN4core3fmt2rt8Argument11new_display17h2a49edc74238e0d9E
	movq	24(%rsp), %rax
	movq	%rax, 8(%rsp)
	movq	32(%rsp), %rax
	movq	%rax, 16(%rsp)
	leaq	.Lanon.5c825456d79c55130b5e246078ef4170.7(%rip), %rdi
	leaq	8(%rsp), %rsi
	callq	_ZN4core3fmt9Arguments3new17h17da825339018411E
	movq	%rax, %rdi
	movq	%rdx, %rsi
	callq	*_RNvNtNtCs3JBboNF8E1m_3std2io5stdio6__print@GOTPCREL(%rip)
	addq	$40, %rsp
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end16:
	.size	_ZN8loop_sum4main17hf0e5bb41ed104d8fE, .Lfunc_end16-_ZN8loop_sum4main17hf0e5bb41ed104d8fE
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
	leaq	_ZN8loop_sum4main17hf0e5bb41ed104d8fE(%rip), %rdi
	xorl	%ecx, %ecx
	callq	_ZN3std2rt10lang_start17hb97162bccb5dd815E
	popq	%rcx
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end17:
	.size	main, .Lfunc_end17-main
	.cfi_endproc

	.type	.Lanon.5c825456d79c55130b5e246078ef4170.0,@object
	.section	.data.rel.ro..Lanon.5c825456d79c55130b5e246078ef4170.0,"aw",@progbits
	.p2align	3, 0x0
.Lanon.5c825456d79c55130b5e246078ef4170.0:
	.asciz	"\000\000\000\000\000\000\000\000\b\000\000\000\000\000\000\000\b\000\000\000\000\000\000"
	.quad	_ZN4core3ops8function6FnOnce40call_once$u7b$$u7b$vtable.shim$u7d$$u7d$17h2ab83b71a49479d6E
	.quad	_ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17h5cdf34b9eb5e7097E
	.quad	_ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17h5cdf34b9eb5e7097E
	.size	.Lanon.5c825456d79c55130b5e246078ef4170.0, 48

	.type	.Lanon.5c825456d79c55130b5e246078ef4170.1,@object
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	2, 0x0
.Lanon.5c825456d79c55130b5e246078ef4170.1:
	.zero	4
	.zero	4
	.size	.Lanon.5c825456d79c55130b5e246078ef4170.1, 8

	.type	.Lanon.5c825456d79c55130b5e246078ef4170.2,@object
	.section	.rodata.str1.1,"aMS",@progbits,1
.Lanon.5c825456d79c55130b5e246078ef4170.2:
	.asciz	"/home/franco/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library/core/src/iter/range.rs"
	.size	.Lanon.5c825456d79c55130b5e246078ef4170.2, 116

	.type	.Lanon.5c825456d79c55130b5e246078ef4170.3,@object
	.section	.data.rel.ro..Lanon.5c825456d79c55130b5e246078ef4170.3,"aw",@progbits
	.p2align	3, 0x0
.Lanon.5c825456d79c55130b5e246078ef4170.3:
	.quad	.Lanon.5c825456d79c55130b5e246078ef4170.2
	.asciz	"s\000\000\000\000\000\000\000\266\001\000\000\001\000\000"
	.size	.Lanon.5c825456d79c55130b5e246078ef4170.3, 24

	.type	.Lanon.5c825456d79c55130b5e246078ef4170.4,@object
	.section	.rodata..Lanon.5c825456d79c55130b5e246078ef4170.4,"a",@progbits
.Lanon.5c825456d79c55130b5e246078ef4170.4:
	.ascii	"unsafe precondition(s) violated: hint::unreachable_unchecked must never be reached\n\nThis indicates a bug in the program. This Undefined Behavior check is optional, and cannot be relied on for safety."
	.size	.Lanon.5c825456d79c55130b5e246078ef4170.4, 199

	.type	.Lanon.5c825456d79c55130b5e246078ef4170.5,@object
	.section	.rodata.str1.1,"aMS",@progbits,1
.Lanon.5c825456d79c55130b5e246078ef4170.5:
	.asciz	"/mnt/d/UTEC/Compiladores/2026-1/Proyecto2/benchmarks/programs/loop_sum.rs"
	.size	.Lanon.5c825456d79c55130b5e246078ef4170.5, 74

	.type	.Lanon.5c825456d79c55130b5e246078ef4170.6,@object
	.section	.data.rel.ro..Lanon.5c825456d79c55130b5e246078ef4170.6,"aw",@progbits
	.p2align	3, 0x0
.Lanon.5c825456d79c55130b5e246078ef4170.6:
	.quad	.Lanon.5c825456d79c55130b5e246078ef4170.5
	.asciz	"I\000\000\000\000\000\000\000\004\000\000\000\r\000\000"
	.size	.Lanon.5c825456d79c55130b5e246078ef4170.6, 24

	.type	.Lanon.5c825456d79c55130b5e246078ef4170.7,@object
	.section	.rodata.str1.1,"aMS",@progbits,1
.Lanon.5c825456d79c55130b5e246078ef4170.7:
	.asciz	"\300\001\n"
	.size	.Lanon.5c825456d79c55130b5e246078ef4170.7, 4

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
