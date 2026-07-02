.data
str_lit_0: .string "Hola mundo\0"
print_fmt: .string "%ld \n"
print_float_fmt: .string "%f \n"
print_str_fmt: .string "%s\n"
.text
.globl main
main:
 pushq %rbp
 movq %rsp, %rbp
 subq $120, %rsp
 movq $5, %rax
 movl %eax, -8(%rbp)
 leaq str_lit_0(%rip), %rax
 movq %rax, -16(%rbp)
 leaq -40(%rbp), %rax
 pushq %rax
 movq $0, %rax
 movq %rax, %rcx
 popq %rax
 imulq $12, %rcx
 addq %rcx, %rax
 pushq %rax
 movq $0, %rax
 movq %rax, %rcx
 popq %rax
 leaq (%rax, %rcx, 4), %rax
 pushq %rax
 movl -8(%rbp), %eax
 addq $10, %rax
 popq %rdi
 movl %eax, (%rdi)
 leaq -40(%rbp), %rax
 pushq %rax
 movq $0, %rax
 movq %rax, %rcx
 popq %rax
 imulq $12, %rcx
 addq %rcx, %rax
 pushq %rax
 movq $0, %rax
 movq %rax, %rcx
 popq %rax
 leaq (%rax, %rcx, 4), %rax
 movl (%rax), %eax
 cltq
 movq %rax, %rsi
 leaq print_fmt(%rip), %rdi
 movl $0, %eax
 call printf@PLT
 movq -16(%rbp), %rax
 movq %rax, %rsi
 leaq print_str_fmt(%rip), %rdi
 movl $0, %eax
 call printf@PLT
 movq $0, %rax
.L_return_main:
 leave
 ret
.section .note.GNU-stack,"",@progbits
