.data
print_fmt: .string "%ld \n"
print_float_fmt: .string "%f \n"
print_str_fmt: .string "%s\n"
.text
.globl inc
inc:
 pushq %rbp
 movq %rsp, %rbp
 subq $88, %rsp
 movq %rdi, -8(%rbp)
 movq -8(%rbp), %rax
 pushq %rax
 movq -8(%rbp), %rax
 movl (%rax), %eax
 cltq
 incq %rax
 popq %rdi
 movl %eax, (%rdi)
 movq $0, %rax
.L_return_inc:
 leave
 ret
.globl main
main:
 pushq %rbp
 movq %rsp, %rbp
 subq $120, %rsp
 movq $10, %rax
 movl %eax, -8(%rbp)
 leaq -8(%rbp), %rax
 movq %rax, -16(%rbp)
 movq -16(%rbp), %rax
 movl (%rax), %eax
 cltq
 movl %eax, -24(%rbp)
 movl -24(%rbp), %eax
 movq %rax, %rsi
 leaq print_fmt(%rip), %rdi
 movl $0, %eax
 call printf@PLT
 movq $5, %rax
 movl %eax, -32(%rbp)
 leaq -32(%rbp), %rax
 movq %rax, -40(%rbp)
 movq -40(%rbp), %rax
 pushq %rax
 movq $20, %rax
 popq %rdi
 movl %eax, (%rdi)
 movl -32(%rbp), %eax
 movq %rax, %rsi
 leaq print_fmt(%rip), %rdi
 movl $0, %eax
 call printf@PLT
 leaq -32(%rbp), %rax
 movq %rax, %rdi
 call inc
 movl -32(%rbp), %eax
 movq %rax, %rsi
 leaq print_fmt(%rip), %rdi
 movl $0, %eax
 call printf@PLT
 movq $0, %rax
.L_return_main:
 leave
 ret
.section .note.GNU-stack,"",@progbits
