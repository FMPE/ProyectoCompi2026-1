# Desensamblado (objdump -d) del binario de Cranelift, filtrado
# a las funciones del usuario (main + crate). cg_clif genera
# codigo maquina directo; no soporta --emit=asm.

0000000000015389 <main>:
   15389:	push   %rbp
   1538a:	mov    %rsp,%rbp
   1538d:	mov    %rdi,%r9
   15390:	xor    %ecx,%ecx
   15392:	mov    0x40f17(%rip),%rdi        # 562b0 <_DYNAMIC+0x250>
   15399:	mov    %rsi,%rdx
   1539c:	mov    %r9,%rsi
   1539f:	call   15428 <_RINvNtCse6CrLDo09wl_3std2rt10lang_startuECs5r4hCsr37xw_6matrix>
   153a4:	mov    %rbp,%rsp
   153a7:	pop    %rbp
   153a8:	ret


00000000000153a9 <_RINvMNtNtCs71d6MpIv4UP_4core3fmt2rtNtB3_8Argument11new_displaylECs5r4hCsr37xw_6matrix>:
   153a9:	push   %rbp
   153aa:	mov    %rsp,%rbp
   153ad:	sub    $0x20,%rsp
   153b1:	mov    %rsi,(%rsp)
   153b5:	mov    (%rsp),%r9
   153b9:	mov    %r9,0x18(%rsp)
   153be:	mov    0x40ef3(%rip),%r10        # 562b8 <_DYNAMIC+0x258>
   153c5:	mov    0x18(%rsp),%r11
   153ca:	mov    %r11,0x8(%rsp)
   153cf:	mov    %r10,0x10(%rsp)
   153d4:	mov    0x8(%rsp),%rax
   153d9:	mov    0x10(%rsp),%rcx
   153de:	mov    %rax,(%rdi)
   153e1:	mov    %rcx,0x8(%rdi)
   153e5:	mov    %rdi,%rax
   153e8:	add    $0x20,%rsp
   153ec:	mov    %rbp,%rsp
   153ef:	pop    %rbp
   153f0:	ret


00000000000153f1 <_RINvMs2_NtCs71d6MpIv4UP_4core3fmtNtB6_9Arguments3newKj4_Kj1_ECs5r4hCsr37xw_6matrix>:
   153f1:	push   %rbp
   153f2:	mov    %rsp,%rbp
   153f5:	sub    $0x20,%rsp
   153f9:	mov    %rdi,0x10(%rsp)
   153fe:	mov    %rsi,0x18(%rsp)
   15403:	mov    0x10(%rsp),%r9
   15408:	mov    %r9,(%rsp)
   1540c:	mov    0x18(%rsp),%r10
   15411:	mov    %r10,0x8(%rsp)
   15416:	mov    (%rsp),%rax
   1541a:	mov    0x8(%rsp),%rdx
   1541f:	add    $0x20,%rsp
   15423:	mov    %rbp,%rsp
   15426:	pop    %rbp
   15427:	ret


0000000000015428 <_RINvNtCse6CrLDo09wl_3std2rt10lang_startuECs5r4hCsr37xw_6matrix>:
   15428:	push   %rbp
   15429:	mov    %rsp,%rbp
   1542c:	sub    $0x10,%rsp
   15430:	mov    %rsi,%rax
   15433:	mov    %rdi,(%rsp)
   15437:	lea    (%rsp),%rdi
   1543b:	mov    0x416de(%rip),%rsi        # 56b20 <_DYNAMIC+0xac0>
   15442:	mov    0x40e77(%rip),%r10        # 562c0 <_DYNAMIC+0x260>
   15449:	mov    %rcx,%r8
   1544c:	mov    %rdx,%rcx
   1544f:	mov    %rax,%rdx
   15452:	call   *%r10
   15455:	add    $0x10,%rsp
   15459:	mov    %rbp,%rsp
   1545c:	pop    %rbp
   1545d:	ret


000000000001545e <_RINvNtNtCse6CrLDo09wl_3std3sys9backtrace28___rust_begin_short_backtraceFEuuECs5r4hCsr37xw_6matrix>:
   1545e:	push   %rbp
   1545f:	mov    %rsp,%rbp
   15462:	call   15755 <_RNvYFEuINtNtNtCs71d6MpIv4UP_4core3ops8function6FnOnceuE9call_onceCs5r4hCsr37xw_6matrix>
   15467:	mov    %rbp,%rsp
   1546a:	pop    %rbp
   1546b:	ret


000000000001546c <_RNCINvNtCse6CrLDo09wl_3std2rt10lang_startuE0Cs5r4hCsr37xw_6matrix>:
   1546c:	push   %rbp
   1546d:	mov    %rsp,%rbp
   15470:	sub    $0x10,%rsp
   15474:	mov    (%rdi),%rdi
   15477:	call   1545e <_RINvNtNtCse6CrLDo09wl_3std3sys9backtrace28___rust_begin_short_backtraceFEuuECs5r4hCsr37xw_6matrix>
   1547c:	call   15730 <_RNvXsU_NtCse6CrLDo09wl_3std7processuNtB5_11Termination6reportCs5r4hCsr37xw_6matrix>
   15481:	mov    %al,(%rsp)
   15484:	lea    (%rsp),%r10
   15488:	movzbl (%r10),%eax
   1548c:	add    $0x10,%rsp
   15490:	mov    %rbp,%rsp
   15493:	pop    %rbp
   15494:	ret


0000000000015495 <_RNSNvYNCINvNtCse6CrLDo09wl_3std2rt10lang_startuE0INtNtNtCs71d6MpIv4UP_4core3ops8function6FnOnceuE9call_once6vtableCs5r4hCsr37xw_6matrix>:
   15495:	push   %rbp
   15496:	mov    %rsp,%rbp
   15499:	mov    (%rdi),%rdi
   1549c:	call   15760 <_RNvYNCINvNtCse6CrLDo09wl_3std2rt10lang_startuE0INtNtNtCs71d6MpIv4UP_4core3ops8function6FnOnceuE9call_onceCs5r4hCsr37xw_6matrix>
   154a1:	mov    %rbp,%rsp
   154a4:	pop    %rbp
   154a5:	ret
   154a6:	int3
   154a7:	int3


00000000000154a8 <_RNvCs5r4hCsr37xw_6matrix13matrix_kernel>:
   154a8:	push   %rbp
   154a9:	mov    %rsp,%rbp
   154ac:	sub    $0x40,%rsp
   154b0:	xor    %rcx,%rcx
   154b3:	cmp    $0x3,%rcx
   154b7:	je     154da <_RNvCs5r4hCsr37xw_6matrix13matrix_kernel+0x32>
   154bd:	imul   $0x4,%rcx,%r9
   154c1:	lea    0x28(%rsp),%r10
   154c6:	movl   $0x0,(%r10,%r9,1)
   154ce:	add    $0x1,%rcx
   154d5:	jmp    154b3 <_RNvCs5r4hCsr37xw_6matrix13matrix_kernel+0xb>
   154da:	xor    %rax,%rax
   154dd:	cmp    $0x3,%rax
   154e1:	je     15514 <_RNvCs5r4hCsr37xw_6matrix13matrix_kernel+0x6c>
   154e7:	imul   $0xc,%rax,%rcx
   154eb:	lea    (%rsp),%rdx
   154ef:	mov    0x28(%rsp),%esi
   154f3:	mov    0x2c(%rsp),%edi
   154f7:	mov    0x30(%rsp),%r8d
   154fc:	mov    %esi,(%rdx,%rcx,1)
   154ff:	mov    %edi,0x4(%rdx,%rcx,1)
   15503:	mov    %r8d,0x8(%rdx,%rcx,1)
   15508:	add    $0x1,%rax
   1550f:	jmp    154dd <_RNvCs5r4hCsr37xw_6matrix13matrix_kernel+0x35>
   15514:	xor    %eax,%eax
   15516:	cmp    $0x3,%eax
   15519:	jl     1556a <_RNvCs5r4hCsr37xw_6matrix13matrix_kernel+0xc2>
   1551f:	mov    $0x1,%edi
   15524:	mov    $0x3,%eax
   15529:	cmp    $0x1,%rax
   1552d:	jbe    15603 <_RNvCs5r4hCsr37xw_6matrix13matrix_kernel+0x15b>
   15533:	mov    $0x1,%edi
   15538:	mov    $0x3,%eax
   1553d:	cmp    $0x1,%rax
   15541:	jbe    1561a <_RNvCs5r4hCsr37xw_6matrix13matrix_kernel+0x172>
   15547:	imul   $0x1,0x149(%rip),%rax        # 15698 <_RNvCs5r4hCsr37xw_6matrix13matrix_kernel+0x1f0>
   1554f:	lea    (%rsp),%rcx
   15553:	add    %rcx,%rax
   15556:	imul   $0x1,0x142(%rip),%rcx        # 156a0 <_RNvCs5r4hCsr37xw_6matrix13matrix_kernel+0x1f8>
   1555e:	mov    (%rax,%rcx,1),%eax
   15561:	add    $0x40,%rsp
   15565:	mov    %rbp,%rsp
   15568:	pop    %rbp
   15569:	ret
   1556a:	xor    %ecx,%ecx
   1556c:	cmp    $0x3,%ecx
   1556f:	jl     15597 <_RNvCs5r4hCsr37xw_6matrix13matrix_kernel+0xef>
   15575:	mov    $0x1,%edx
   1557a:	lea    0x1(%rax),%ecx
   1557d:	shr    $0x1f,%edx
   15580:	cmp    %eax,%ecx
   15582:	setl   %al
   15585:	xor    %eax,%edx
   15587:	test   %dl,%dl
   15589:	jne    15631 <_RNvCs5r4hCsr37xw_6matrix13matrix_kernel+0x189>
   1558f:	mov    %rcx,%rax
   15592:	jmp    15516 <_RNvCs5r4hCsr37xw_6matrix13matrix_kernel+0x6e>
   15597:	lea    (%rax,%rcx,1),%edx
   1559a:	mov    %rcx,%rsi
   1559d:	shr    $0x1f,%esi
   155a0:	cmp    %eax,%edx
   155a2:	setl   %dil
   155a6:	xor    %edi,%esi
   155a8:	test   %sil,%sil
   155ab:	jne    15683 <_RNvCs5r4hCsr37xw_6matrix13matrix_kernel+0x1db>
   155b1:	movslq %eax,%rdi
   155b4:	cmp    $0x3,%rdi
   155b8:	jae    15643 <_RNvCs5r4hCsr37xw_6matrix13matrix_kernel+0x19b>
   155be:	mov    %rdi,%rsi
   155c1:	movslq %ecx,%rdi
   155c4:	cmp    $0x3,%rdi
   155c8:	jae    1565a <_RNvCs5r4hCsr37xw_6matrix13matrix_kernel+0x1b2>
   155ce:	imul   $0xc,%rsi,%rsi
   155d2:	lea    (%rsp),%r8
   155d6:	add    %r8,%rsi
   155d9:	imul   $0x4,%rdi,%rdi
   155dd:	mov    %edx,(%rsi,%rdi,1)
   155e0:	mov    $0x1,%esi
   155e5:	lea    0x1(%rcx),%edx
   155e8:	shr    $0x1f,%esi
   155eb:	cmp    %ecx,%edx
   155ed:	setl   %cl
   155f0:	xor    %ecx,%esi
   155f2:	test   %sil,%sil
   155f5:	jne    15671 <_RNvCs5r4hCsr37xw_6matrix13matrix_kernel+0x1c9>
   155fb:	mov    %rdx,%rcx
   155fe:	jmp    1556c <_RNvCs5r4hCsr37xw_6matrix13matrix_kernel+0xc4>
   15603:	mov    $0x3,%esi
   15608:	mov    0x41541(%rip),%rdx        # 56b50 <_DYNAMIC+0xaf0>
   1560f:	mov    0x40cba(%rip),%rax        # 562d0 <_DYNAMIC+0x270>
   15616:	call   *%rax
   15618:	ud2
   1561a:	mov    $0x3,%esi
   1561f:	mov    0x41532(%rip),%rdx        # 56b58 <_DYNAMIC+0xaf8>
   15626:	mov    0x40ca3(%rip),%rax        # 562d0 <_DYNAMIC+0x270>
   1562d:	call   *%rax
   1562f:	ud2
   15631:	mov    0x41510(%rip),%rdi        # 56b48 <_DYNAMIC+0xae8>
   15638:	mov    0x40c89(%rip),%rax        # 562c8 <_DYNAMIC+0x268>
   1563f:	call   *%rax
   15641:	ud2
   15643:	mov    $0x3,%esi
   15648:	mov    0x414e1(%rip),%rdx        # 56b30 <_DYNAMIC+0xad0>
   1564f:	mov    0x40c7a(%rip),%rax        # 562d0 <_DYNAMIC+0x270>
   15656:	call   *%rax
   15658:	ud2
   1565a:	mov    $0x3,%esi
   1565f:	mov    0x414d2(%rip),%rdx        # 56b38 <_DYNAMIC+0xad8>
   15666:	mov    0x40c63(%rip),%rax        # 562d0 <_DYNAMIC+0x270>
   1566d:	call   *%rax
   1566f:	ud2
   15671:	mov    0x414c8(%rip),%rdi        # 56b40 <_DYNAMIC+0xae0>
   15678:	mov    0x40c49(%rip),%rax        # 562c8 <_DYNAMIC+0x268>
   1567f:	call   *%rax
   15681:	ud2
   15683:	mov    0x4149e(%rip),%rdi        # 56b28 <_DYNAMIC+0xac8>
   1568a:	mov    0x40c37(%rip),%rax        # 562c8 <_DYNAMIC+0x268>
   15691:	call   *%rax
   15693:	ud2
   15695:	add    %al,(%rax)
   15697:	add    %cl,(%rax,%rax,1)
   1569a:	add    %al,(%rax)
   1569c:	add    %al,(%rax)
   1569e:	add    %al,(%rax)
   156a0:	add    $0x0,%al
   156a2:	add    %al,(%rax)
   156a4:	add    %al,(%rax)
	...


00000000000156a8 <_RNvCs5r4hCsr37xw_6matrix4main>:
   156a8:	push   %rbp
   156a9:	mov    %rsp,%rbp
   156ac:	sub    $0x40,%rsp
   156b0:	call   154a8 <_RNvCs5r4hCsr37xw_6matrix13matrix_kernel>
   156b5:	mov    %eax,0x18(%rsp)
   156b9:	lea    0x18(%rsp),%rax
   156be:	mov    %rax,0x10(%rsp)
   156c3:	mov    0x10(%rsp),%rsi
   156c8:	lea    0x30(%rsp),%rdi
   156cd:	call   153a9 <_RINvMNtNtCs71d6MpIv4UP_4core3fmt2rtNtB3_8Argument11new_displaylECs5r4hCsr37xw_6matrix>
   156d2:	imul   $0x0,0x4e(%rip),%rax        # 15728 <_RNvCs5r4hCsr37xw_6matrix4main+0x80>
   156da:	lea    0x20(%rsp),%rcx
   156df:	mov    0x30(%rsp),%rdx
   156e4:	mov    0x38(%rsp),%rsi
   156e9:	mov    %rdx,(%rcx,%rax,1)
   156ed:	mov    %rsi,0x8(%rcx,%rax,1)
   156f2:	mov    0x41467(%rip),%rdi        # 56b60 <_DYNAMIC+0xb00>
   156f9:	lea    0x20(%rsp),%rsi
   156fe:	call   153f1 <_RINvMs2_NtCs71d6MpIv4UP_4core3fmtNtB6_9Arguments3newKj4_Kj1_ECs5r4hCsr37xw_6matrix>
   15703:	mov    %rax,(%rsp)
   15707:	mov    %rdx,0x8(%rsp)
   1570c:	mov    (%rsp),%rdi
   15710:	mov    0x8(%rsp),%rsi
   15715:	mov    0x40bbc(%rip),%rax        # 562d8 <_DYNAMIC+0x278>
   1571c:	call   *%rax
   1571e:	add    $0x40,%rsp
   15722:	mov    %rbp,%rsp
   15725:	pop    %rbp
   15726:	ret
   15727:	add    %dl,(%rax)
   15729:	add    %al,(%rax)
   1572b:	add    %al,(%rax)
   1572d:	add    %al,(%rax)
	...


0000000000015730 <_RNvXsU_NtCse6CrLDo09wl_3std7processuNtB5_11Termination6reportCs5r4hCsr37xw_6matrix>:
   15730:	push   %rbp
   15731:	mov    %rsp,%rbp
   15734:	sub    $0x10,%rsp
   15738:	movb   $0x0,0x8(%rsp)
   1573d:	movzbq 0x8(%rsp),%rsi
   15743:	mov    %sil,(%rsp)
   15747:	movzbq (%rsp),%rax
   1574c:	add    $0x10,%rsp
   15750:	mov    %rbp,%rsp
   15753:	pop    %rbp
   15754:	ret


0000000000015755 <_RNvYFEuINtNtNtCs71d6MpIv4UP_4core3ops8function6FnOnceuE9call_onceCs5r4hCsr37xw_6matrix>:
   15755:	push   %rbp
   15756:	mov    %rsp,%rbp
   15759:	call   *%rdi
   1575b:	mov    %rbp,%rsp
   1575e:	pop    %rbp
   1575f:	ret


0000000000015760 <_RNvYNCINvNtCse6CrLDo09wl_3std2rt10lang_startuE0INtNtNtCs71d6MpIv4UP_4core3ops8function6FnOnceuE9call_onceCs5r4hCsr37xw_6matrix>:
   15760:	push   %rbp
   15761:	mov    %rsp,%rbp
   15764:	sub    $0x10,%rsp
   15768:	mov    %rdi,(%rsp)
   1576c:	lea    (%rsp),%rdi
   15770:	call   1546c <_RNCINvNtCse6CrLDo09wl_3std2rt10lang_startuE0Cs5r4hCsr37xw_6matrix>
   15775:	add    $0x10,%rsp
   15779:	mov    %rbp,%rsp
   1577c:	pop    %rbp
   1577d:	ret
