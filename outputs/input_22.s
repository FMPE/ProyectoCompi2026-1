.data
print_fmt: .string "%ld \n"
print_float_fmt: .string "%f \n"
print_str_fmt: .string "%s\n"
.text
.globl main
main:
 pushq %rbp
 movq %rsp, %rbp
 subq $120, %rsp
 movq $42, %rax
 subq $16, %rsp
 movq %rax, (%rsp)
 movq $8, %rdi
 call malloc@PLT
 movq (%rsp), %rdx
 addq $16, %rsp
 movq %rdx, (%rax)
 movq %rax, -8(%rbp)
 movq -8(%rbp), %rax
 movq (%rax), %rax
 movq %rax, -16(%rbp)
 movq -16(%rbp), %rax
 movq %rax, %rsi
 leaq print_fmt(%rip), %rdi
 movl $0, %eax
 call printf@PLT
 movq -8(%rbp), %rax
 pushq %rax
 movq $100, %rax
 popq %rdi
 movq %rax, (%rdi)
 movq -8(%rbp), %rax
 movq (%rax), %rax
 movq %rax, %rsi
 leaq print_fmt(%rip), %rdi
 movl $0, %eax
 call printf@PLT
 movq $1000000, %rax
 subq $16, %rsp
 movq %rax, (%rsp)
 movq $8, %rdi
 call malloc@PLT
 movq (%rsp), %rdx
 addq $16, %rsp
 movq %rdx, (%rax)
 movq %rax, -24(%rbp)
 movq -24(%rbp), %rax
 movq (%rax), %rax
 movq %rax, %rsi
 leaq print_fmt(%rip), %rdi
 movl $0, %eax
 call printf@PLT
 movq $0, %rax
 movl %eax, -32(%rbp)
.L_while_begin_0:
 movq $3, %rax
 pushq %rax
 movl -32(%rbp), %eax
 popq %rcx
 cmpq %rcx, %rax
 movq $0, %rax
 setl %al
 movzbq %al, %rax
 testq %rax, %rax
 je .L_while_end_1
 movl -32(%rbp), %eax
 subq $16, %rsp
 movq %rax, (%rsp)
 movq $4, %rdi
 call malloc@PLT
 movq (%rsp), %rdx
 addq $16, %rsp
 movl %edx, (%rax)
 movq %rax, -40(%rbp)
 movq -40(%rbp), %rax
 movl (%rax), %eax
 cltq
 movq %rax, %rsi
 leaq print_fmt(%rip), %rdi
 movl $0, %eax
 call printf@PLT
 movl -32(%rbp), %eax
 incq %rax
 movl %eax, -32(%rbp)
 movq -40(%rbp), %rdi
 call free@PLT
 jmp .L_while_begin_0
.L_while_end_1:
 movq -8(%rbp), %rdi
 call free@PLT
 movq -24(%rbp), %rdi
 call free@PLT
 movq $0, %rax
.L_return_main:
 leave
 ret
.section .note.GNU-stack,"",@progbits
