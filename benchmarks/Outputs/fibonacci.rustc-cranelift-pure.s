# Desensamblado (objdump -d) del staticlib de Cranelift, filtrado a la
# funcion pura 'fib' (no_mangle). cg_clif genera codigo maquina
# directo; no soporta --emit=asm.

0000000000000000 <fib>:
   0:	push   %rbp
   1:	mov    %rsp,%rbp
   4:	sub    $0x10,%rsp
   8:	mov    %r12,(%rsp)
   c:	mov    %r13,0x8(%rsp)
  11:	mov    %rdi,%r12
  14:	mov    %r12,%rdi
  17:	cmp    $0x1,%edi
  1a:	jle    50 <fib+0x50>
  20:	mov    %r12,%rdi
  23:	sub    $0x1,%edi
  26:	call   2b <fib+0x2b>
  2b:	mov    %rax,%r13
  2e:	mov    %r12,%rdi
  31:	sub    $0x2,%edi
  34:	call   39 <fib+0x39>
  39:	mov    %r13,%rcx
  3c:	add    %ecx,%eax
  3e:	mov    (%rsp),%r12
  42:	mov    0x8(%rsp),%r13
  47:	add    $0x10,%rsp
  4b:	mov    %rbp,%rsp
  4e:	pop    %rbp
  4f:	ret
  50:	mov    %r12,%rax
  53:	mov    (%rsp),%r12
  57:	mov    0x8(%rsp),%r13
  5c:	add    $0x10,%rsp
  60:	mov    %rbp,%rsp
  63:	pop    %rbp
  64:	ret
