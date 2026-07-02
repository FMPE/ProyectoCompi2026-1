.data
print_fmt: .string "%ld \n"
print_float_fmt: .string "%f \n"
print_str_fmt: .string "%s\n"
.text
.globl main
main:
 pushq %rbp
 movq %rsp, %rbp
 subq $136, %rsp
 movq $0, %rax
 movl %eax, -40(%rbp)
 movl %eax, -36(%rbp)
 movl %eax, -32(%rbp)
 movl %eax, -28(%rbp)
 movl %eax, -24(%rbp)
 movl %eax, -20(%rbp)
 movl %eax, -16(%rbp)
 movl %eax, -12(%rbp)
 movl %eax, -8(%rbp)
 movq $0, %rax
 movl %eax, -48(%rbp)
.L_while_begin_0:
 movl -48(%rbp), %eax
 pushq %rax
 movq $3, %rax
 movq %rax, %rcx
 popq %rax
 cmpq %rcx, %rax
 movq $0, %rax
 setl %al
 movzbq %al, %rax
 testq %rax, %rax
 je .L_while_end_1
 movq $0, %rax
 movl %eax, -56(%rbp)
.L_while_begin_2:
 movl -56(%rbp), %eax
 pushq %rax
 movq $3, %rax
 movq %rax, %rcx
 popq %rax
 cmpq %rcx, %rax
 movq $0, %rax
 setl %al
 movzbq %al, %rax
 testq %rax, %rax
 je .L_while_end_3
 leaq -40(%rbp), %rax
 pushq %rax
 movl -56(%rbp), %eax
 movq %rax, %rcx
 popq %rax
 imulq $12, %rcx
 addq %rcx, %rax
 pushq %rax
 movl -48(%rbp), %eax
 movq %rax, %rcx
 popq %rax
 leaq (%rax, %rcx, 4), %rax
 pushq %rax
 movl -48(%rbp), %eax
 pushq %rax
 movl -56(%rbp), %eax
 movq %rax, %rcx
 popq %rax
 addq %rcx, %rax
 popq %rdi
 movl %eax, (%rdi)
 movl -56(%rbp), %eax
 incq %rax
 movl %eax, -56(%rbp)
 jmp .L_while_begin_2
.L_while_end_3:
 movl -48(%rbp), %eax
 incq %rax
 movl %eax, -48(%rbp)
 jmp .L_while_begin_0
.L_while_end_1:
 leaq -40(%rbp), %rax
 pushq %rax
 movq $1, %rax
 movq %rax, %rcx
 popq %rax
 imulq $12, %rcx
 addq %rcx, %rax
 pushq %rax
 movq $1, %rax
 movq %rax, %rcx
 popq %rax
 leaq (%rax, %rcx, 4), %rax
 movl (%rax), %eax
 cltq
 movq %rax, %rsi
 leaq print_fmt(%rip), %rdi
 movl $0, %eax
 call printf@PLT
 movq $0, %rax
.L_return_main:
 leave
 ret
.section .note.GNU-stack,"",@progbits
