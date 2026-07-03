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
 movq $10, %rax
 movl %eax, -8(%rbp)
 movq $5, %rax
 movl %eax, -16(%rbp)
 movl -8(%rbp), %eax
 pushq %rax
 movl -16(%rbp), %eax
 popq %rcx
 addq %rcx, %rax
 movl %eax, -32(%rbp)
 movq $41, %rax
 movl %eax, -24(%rbp)
 movl -24(%rbp), %eax
 incq %rax
 movl %eax, -40(%rbp)
 movq $7, %rax
 movl %eax, -48(%rbp)
 movl -32(%rbp), %eax
 movl %eax, -16(%rbp)
 movl -8(%rbp), %eax
 pushq %rax
 movl -16(%rbp), %eax
 popq %rcx
 addq %rcx, %rax
 movl %eax, -56(%rbp)
 movl -32(%rbp), %eax
 movq %rax, %rsi
 leaq print_fmt(%rip), %rdi
 movl $0, %eax
 call printf@PLT
 movl -40(%rbp), %eax
 movq %rax, %rsi
 leaq print_fmt(%rip), %rdi
 movl $0, %eax
 call printf@PLT
 movl -48(%rbp), %eax
 movq %rax, %rsi
 leaq print_fmt(%rip), %rdi
 movl $0, %eax
 call printf@PLT
 movl -56(%rbp), %eax
 movq %rax, %rsi
 leaq print_fmt(%rip), %rdi
 movl $0, %eax
 call printf@PLT
 movq $0, %rax
.L_return_main:
 leave
 ret
.section .note.GNU-stack,"",@progbits
