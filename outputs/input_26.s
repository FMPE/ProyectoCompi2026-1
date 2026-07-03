.data
print_fmt: .string "%ld \n"
print_float_fmt: .string "%f \n"
print_str_fmt: .string "%s\n"
.text
.globl cuadrado
cuadrado:
 pushq %rbp
 movq %rsp, %rbp
 subq $88, %rsp
 movq %rdi, -8(%rbp)
 movl -8(%rbp), %eax
 pushq %rax
 movl -8(%rbp), %eax
 popq %rcx
 imulq %rcx, %rax
 jmp .L_return_cuadrado
 movq $0, %rax
.L_return_cuadrado:
 leave
 ret
.globl main
main:
 pushq %rbp
 movq %rsp, %rbp
 subq $120, %rsp
 movq $14, %rax
 movl %eax, -8(%rbp)
 movq $7, %rax
 movl %eax, -16(%rbp)
 movq $3, %rax
 movl %eax, -24(%rbp)
 movl -24(%rbp), %eax
 pushq %rax
 movl -16(%rbp), %eax
 popq %rcx
 imulq %rcx, %rax
 pushq %rax
 movl -24(%rbp), %eax
 pushq %rax
 movl -24(%rbp), %eax
 popq %rcx
 imulq %rcx, %rax
 popq %rcx
 addq %rcx, %rax
 pushq %rax
 movl -16(%rbp), %eax
 popq %rcx
 subq %rcx, %rax
 movl %eax, -32(%rbp)
 movl -16(%rbp), %eax
 movq %rax, %rdi
 call cuadrado
 pushq %rax
 movl -8(%rbp), %eax
 movq %rax, %rcx
 popq %rax
 addq %rcx, %rax
 movl %eax, -40(%rbp)
 movl -8(%rbp), %eax
 movq %rax, %rsi
 leaq print_fmt(%rip), %rdi
 movl $0, %eax
 call printf@PLT
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
 movq $0, %rax
.L_return_main:
 leave
 ret
.section .note.GNU-stack,"",@progbits
