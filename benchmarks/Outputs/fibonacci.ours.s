.data
print_fmt: .string "%ld \n"
print_float_fmt: .string "%f \n"
print_str_fmt: .string "%s\n"
.text
.globl fib
fib:
 pushq %rbp
 movq %rsp, %rbp
 subq $88, %rsp
 movq %rdi, -8(%rbp)
 movl -8(%rbp), %eax
 pushq %rax
 movq $1, %rax
 movq %rax, %rcx
 popq %rax
 cmpq %rcx, %rax
 movq $0, %rax
 setle %al
 movzbq %al, %rax
 testq %rax, %rax
 je .L_else_0
 movl -8(%rbp), %eax
 jmp .L_return_fib
 jmp .L_endif_1
.L_else_0:
.L_endif_1:
 movl -8(%rbp), %eax
 decq %rax
 movq %rax, %rdi
 call fib
 pushq %rax
 movl -8(%rbp), %eax
 subq $2, %rax
 movq %rax, %rdi
 call fib
 movq %rax, %rcx
 popq %rax
 addq %rcx, %rax
 jmp .L_return_fib
 movq $0, %rax
.L_return_fib:
 leave
 ret
.globl main
main:
 pushq %rbp
 movq %rsp, %rbp
 subq $88, %rsp
 movq $10, %rax
 movq %rax, %rdi
 call fib
 movl %eax, -8(%rbp)
 movl -8(%rbp), %eax
 movq %rax, %rsi
 leaq print_fmt(%rip), %rdi
 movl $0, %eax
 call printf@PLT
 movq $0, %rax
.L_return_main:
 leave
 ret
.section .note.GNU-stack,"",@progbits
