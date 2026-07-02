.data
str_lit_0: .string "Benchmark OK\0"
print_fmt: .string "%ld \n"
print_float_fmt: .string "%f \n"
print_str_fmt: .string "%s\n"
.text
.globl main
main:
 pushq %rbp
 movq %rsp, %rbp
 subq $96, %rsp
 leaq str_lit_0(%rip), %rax
 movq %rax, -8(%rbp)
 movq $42, %rax
 movl %eax, -16(%rbp)
 movl -16(%rbp), %eax
 movq %rax, %rsi
 leaq print_fmt(%rip), %rdi
 movl $0, %eax
 call printf@PLT
 movq -8(%rbp), %rax
 movq %rax, %rsi
 leaq print_str_fmt(%rip), %rdi
 movl $0, %eax
 call printf@PLT
 movq $0, %rax
.L_return_main:
 leave
 ret
.section .note.GNU-stack,"",@progbits
