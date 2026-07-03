.data
print_fmt: .string "%ld \n"
print_float_fmt: .string "%f \n"
print_str_fmt: .string "%s\n"
.text
.globl loop_sum_kernel
loop_sum_kernel:
 pushq %rbp
 movq %rsp, %rbp
 subq $96, %rsp
 movq $0, %rax
 movl %eax, -8(%rbp)
 movq $0, %rax
 movq %rax, -16(%rbp)
.L_for_begin_0:
 movq $1000, %rax
 movq $1000, %rcx
 movq -16(%rbp), %rax
 cmpq %rcx, %rax
 jge .L_for_end_1
 movq -16(%rbp), %rax
 pushq %rax
 movl -8(%rbp), %eax
 popq %rcx
 addq %rcx, %rax
 movl %eax, -8(%rbp)
 movq -16(%rbp), %rax
 incq %rax
 movq %rax, -16(%rbp)
 jmp .L_for_begin_0
.L_for_end_1:
 movl -8(%rbp), %eax
 jmp .L_return_loop_sum_kernel
 movq $0, %rax
.L_return_loop_sum_kernel:
 leave
 ret
.globl main
main:
 pushq %rbp
 movq %rsp, %rbp
 subq $80, %rsp
 call loop_sum_kernel
 movq %rax, %rsi
 leaq print_fmt(%rip), %rdi
 movl $0, %eax
 call printf@PLT
 movq $0, %rax
.L_return_main:
 leave
 ret
.section .note.GNU-stack,"",@progbits
