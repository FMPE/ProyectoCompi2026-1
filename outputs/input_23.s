.data
print_fmt: .string "%ld \n"
print_float_fmt: .string "%f \n"
print_str_fmt: .string "%s\n"
.text
.globl main
main:
 pushq %rbp
 movq %rsp, %rbp
 subq $112, %rsp
 movq $7, %rax
 movq $7, %rsi
 movq $3, %rax
 movq $3, %rdi
 call max__i32
 movl %eax, -8(%rbp)
 movq $50, %rax
 movq $50, %rsi
 movq $100, %rax
 movq $100, %rdi
 call max__i32
 movl %eax, -16(%rbp)
 movq $2000000, %rax
 movq $2000000, %rsi
 movq $1000000, %rax
 movq $1000000, %rdi
 call max__i64
 movq %rax, -24(%rbp)
 movq $20, %rax
 movq $20, %rsi
 movq $10, %rax
 movq $10, %rdi
 call add__i32
 movl %eax, -32(%rbp)
 movl -8(%rbp), %eax
 movq %rax, %rsi
 leaq print_fmt(%rip), %rdi
 movl $0, %eax
 call printf@PLT
 movl -16(%rbp), %eax
 movq %rax, %rsi
 leaq print_fmt(%rip), %rdi
 movl $0, %eax
 call printf@PLT
 movq -24(%rbp), %rax
 movq %rax, %rsi
 leaq print_fmt(%rip), %rdi
 movl $0, %eax
 call printf@PLT
 movl -32(%rbp), %eax
 movq %rax, %rsi
 leaq print_fmt(%rip), %rdi
 movl $0, %eax
 call printf@PLT
 movq $0, %rax
.L_return_main:
 leave
 ret
.globl max__i32
max__i32:
 pushq %rbp
 movq %rsp, %rbp
 subq $96, %rsp
 movq %rdi, -8(%rbp)
 movq %rsi, -16(%rbp)
 movl -16(%rbp), %eax
 pushq %rax
 movl -8(%rbp), %eax
 popq %rcx
 cmpq %rcx, %rax
 movq $0, %rax
 setg %al
 movzbq %al, %rax
 testq %rax, %rax
 je .L_else_0
 movl -8(%rbp), %eax
 jmp .L_return_max__i32
 jmp .L_endif_1
.L_else_0:
.L_endif_1:
 movl -16(%rbp), %eax
 jmp .L_return_max__i32
 movq $0, %rax
.L_return_max__i32:
 leave
 ret
.globl max__i64
max__i64:
 pushq %rbp
 movq %rsp, %rbp
 subq $96, %rsp
 movq %rdi, -8(%rbp)
 movq %rsi, -16(%rbp)
 movq -16(%rbp), %rax
 pushq %rax
 movq -8(%rbp), %rax
 popq %rcx
 cmpq %rcx, %rax
 movq $0, %rax
 setg %al
 movzbq %al, %rax
 testq %rax, %rax
 je .L_else_2
 movq -8(%rbp), %rax
 jmp .L_return_max__i64
 jmp .L_endif_3
.L_else_2:
.L_endif_3:
 movq -16(%rbp), %rax
 jmp .L_return_max__i64
 movq $0, %rax
.L_return_max__i64:
 leave
 ret
.globl add__i32
add__i32:
 pushq %rbp
 movq %rsp, %rbp
 subq $96, %rsp
 movq %rdi, -8(%rbp)
 movq %rsi, -16(%rbp)
 movl -16(%rbp), %eax
 pushq %rax
 movl -8(%rbp), %eax
 popq %rcx
 addq %rcx, %rax
 jmp .L_return_add__i32
 movq $0, %rax
.L_return_add__i32:
 leave
 ret
.section .note.GNU-stack,"",@progbits
