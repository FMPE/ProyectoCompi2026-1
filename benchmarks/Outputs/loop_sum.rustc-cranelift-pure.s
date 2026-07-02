# Desensamblado (objdump -d) del staticlib de Cranelift, filtrado a la
# funcion pura 'loop_sum_kernel' (no_mangle). cg_clif genera codigo maquina
# directo; no soporta --emit=asm.

0000000000000000 <loop_sum_kernel>:
   0:	push   %rbp
   1:	mov    %rsp,%rbp
   4:	sub    $0x10,%rsp
   8:	xor    %ecx,%ecx
   a:	mov    %rcx,%rax
   d:	cmp    $0x3e8,%ecx
  13:	jl     22 <loop_sum_kernel+0x22>
  19:	add    $0x10,%rsp
  1d:	mov    %rbp,%rsp
  20:	pop    %rbp
  21:	ret
  22:	lea    0x1(%rcx),%edx
  25:	cmp    %ecx,%edx
  27:	jl     4a <loop_sum_kernel+0x4a>
  2d:	lea    0x4(%rsp),%rdx
  32:	mov    %ecx,0x4(%rsp)
  36:	movl   $0x1,(%rsp)
  3d:	add    $0x1,%ecx
  43:	add    (%rdx),%eax
  45:	jmp    d <loop_sum_kernel+0xd>
  4a:	ud2
