# Desensamblado (objdump -d) del staticlib de Cranelift, filtrado a la
# funcion pura 'matrix_kernel' (no_mangle). cg_clif genera codigo maquina
# directo; no soporta --emit=asm.

0000000000000000 <matrix_kernel>:
   0:	push   %rbp
   1:	mov    %rsp,%rbp
   4:	sub    $0x40,%rsp
   8:	xor    %rcx,%rcx
   b:	lea    0x28(%rsp),%rax
  10:	cmp    $0x3,%rcx
  14:	je     2d <matrix_kernel+0x2d>
  1a:	movl   $0x0,(%rax,%rcx,4)
  21:	add    $0x1,%rcx
  28:	jmp    10 <matrix_kernel+0x10>
  2d:	xor    %r11,%r11
  30:	lea    (%rsp),%rax
  34:	cmp    $0x3,%r11
  38:	je     65 <matrix_kernel+0x65>
  3e:	mov    0x28(%rsp),%ecx
  42:	mov    0x2c(%rsp),%edx
  46:	mov    0x30(%rsp),%esi
  4a:	imul   $0xc,%r11,%rdi
  4e:	mov    %ecx,(%rax,%rdi,1)
  51:	mov    %edx,0x4(%rax,%rdi,1)
  55:	mov    %esi,0x8(%rax,%rdi,1)
  59:	add    $0x1,%r11
  60:	jmp    34 <matrix_kernel+0x34>
  65:	xor    %ecx,%ecx
  67:	cmp    $0x3,%ecx
  6a:	jl     7c <matrix_kernel+0x7c>
  70:	mov    0x10(%rax),%eax
  73:	add    $0x40,%rsp
  77:	mov    %rbp,%rsp
  7a:	pop    %rbp
  7b:	ret
  7c:	xor    %edx,%edx
  7e:	cmp    $0x3,%edx
  81:	jl     92 <matrix_kernel+0x92>
  87:	add    $0x1,%ecx
  8d:	jmp    67 <matrix_kernel+0x67>
  92:	movslq %ecx,%rdi
  95:	cmp    $0x3,%rdi
  99:	jae    c8 <matrix_kernel+0xc8>
  9f:	mov    %rdi,%r8
  a2:	movslq %edx,%rdi
  a5:	cmp    $0x3,%rdi
  a9:	jae    df <matrix_kernel+0xdf>
  af:	lea    (%rcx,%rdx,1),%esi
  b2:	imul   $0xc,%r8,%r8
  b6:	add    %rax,%r8
  b9:	mov    %esi,(%r8,%rdi,4)
  bd:	add    $0x1,%edx
  c3:	jmp    7e <matrix_kernel+0x7e>
  c8:	mov    $0x3,%esi
  cd:	mov    0x0(%rip),%rdx        # d4 <matrix_kernel+0xd4>
  d4:	mov    0x0(%rip),%rax        # db <matrix_kernel+0xdb>
  db:	call   *%rax
  dd:	ud2
  df:	mov    $0x3,%esi
  e4:	mov    0x0(%rip),%rdx        # eb <matrix_kernel+0xeb>
  eb:	mov    0x0(%rip),%rax        # f2 <matrix_kernel+0xf2>
  f2:	call   *%rax
  f4:	ud2
