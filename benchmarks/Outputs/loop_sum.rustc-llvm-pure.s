	.file	"loop_sum_pure.b66c6a0fd9ea9e63-cgu.0"
	.section	.text.loop_sum_kernel,"ax",@progbits
	.globl	loop_sum_kernel
	.p2align	4
	.type	loop_sum_kernel,@function
loop_sum_kernel:
	.cfi_startproc
	movl	$499500, %eax
	retq
.Lfunc_end0:
	.size	loop_sum_kernel, .Lfunc_end0-loop_sum_kernel
	.cfi_endproc

	.ident	"rustc version 1.96.1 (31fca3adb 2026-06-26)"
	.section	".note.GNU-stack","",@progbits
