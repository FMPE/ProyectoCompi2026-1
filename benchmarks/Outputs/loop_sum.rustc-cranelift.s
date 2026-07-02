# Desensamblado (objdump -d) del binario de Cranelift, filtrado
# a las funciones del usuario (main + crate). cg_clif genera
# codigo maquina directo; no soporta --emit=asm.

00000000000154d9 <main>:
   154d9:	push   %rbp
   154da:	mov    %rsp,%rbp
   154dd:	mov    %rdi,%r9
   154e0:	xor    %ecx,%ecx
   154e2:	mov    0x40f4f(%rip),%rdi        # 56438 <_DYNAMIC+0x250>
   154e9:	mov    %rsi,%rdx
   154ec:	mov    %r9,%rsi
   154ef:	call   15578 <_RINvNtCse6CrLDo09wl_3std2rt10lang_startuECs9eTaobl00dh_8loop_sum>
   154f4:	mov    %rbp,%rsp
   154f7:	pop    %rbp
   154f8:	ret


00000000000154f9 <_RINvMNtNtCs71d6MpIv4UP_4core3fmt2rtNtB3_8Argument11new_displaylECs9eTaobl00dh_8loop_sum>:
   154f9:	push   %rbp
   154fa:	mov    %rsp,%rbp
   154fd:	sub    $0x20,%rsp
   15501:	mov    %rsi,(%rsp)
   15505:	mov    (%rsp),%r9
   15509:	mov    %r9,0x18(%rsp)
   1550e:	mov    0x40f2b(%rip),%r10        # 56440 <_DYNAMIC+0x258>
   15515:	mov    0x18(%rsp),%r11
   1551a:	mov    %r11,0x8(%rsp)
   1551f:	mov    %r10,0x10(%rsp)
   15524:	mov    0x8(%rsp),%rax
   15529:	mov    0x10(%rsp),%rcx
   1552e:	mov    %rax,(%rdi)
   15531:	mov    %rcx,0x8(%rdi)
   15535:	mov    %rdi,%rax
   15538:	add    $0x20,%rsp
   1553c:	mov    %rbp,%rsp
   1553f:	pop    %rbp
   15540:	ret


0000000000015541 <_RINvMs2_NtCs71d6MpIv4UP_4core3fmtNtB6_9Arguments3newKj4_Kj1_ECs9eTaobl00dh_8loop_sum>:
   15541:	push   %rbp
   15542:	mov    %rsp,%rbp
   15545:	sub    $0x20,%rsp
   15549:	mov    %rdi,0x10(%rsp)
   1554e:	mov    %rsi,0x18(%rsp)
   15553:	mov    0x10(%rsp),%r9
   15558:	mov    %r9,(%rsp)
   1555c:	mov    0x18(%rsp),%r10
   15561:	mov    %r10,0x8(%rsp)
   15566:	mov    (%rsp),%rax
   1556a:	mov    0x8(%rsp),%rdx
   1556f:	add    $0x20,%rsp
   15573:	mov    %rbp,%rsp
   15576:	pop    %rbp
   15577:	ret


0000000000015578 <_RINvNtCse6CrLDo09wl_3std2rt10lang_startuECs9eTaobl00dh_8loop_sum>:
   15578:	push   %rbp
   15579:	mov    %rsp,%rbp
   1557c:	sub    $0x10,%rsp
   15580:	mov    %rsi,%rax
   15583:	mov    %rdi,(%rsp)
   15587:	lea    (%rsp),%rdi
   1558b:	mov    0x41716(%rip),%rsi        # 56ca8 <_DYNAMIC+0xac0>
   15592:	mov    0x40eaf(%rip),%r10        # 56448 <_DYNAMIC+0x260>
   15599:	mov    %rcx,%r8
   1559c:	mov    %rdx,%rcx
   1559f:	mov    %rax,%rdx
   155a2:	call   *%r10
   155a5:	add    $0x10,%rsp
   155a9:	mov    %rbp,%rsp
   155ac:	pop    %rbp
   155ad:	ret


00000000000155ae <_RINvNtNtCse6CrLDo09wl_3std3sys9backtrace28___rust_begin_short_backtraceFEuuECs9eTaobl00dh_8loop_sum>:
   155ae:	push   %rbp
   155af:	mov    %rsp,%rbp
   155b2:	call   15953 <_RNvYFEuINtNtNtCs71d6MpIv4UP_4core3ops8function6FnOnceuE9call_onceCs9eTaobl00dh_8loop_sum>
   155b7:	mov    %rbp,%rsp
   155ba:	pop    %rbp
   155bb:	ret


00000000000155bc <_RNCINvNtCse6CrLDo09wl_3std2rt10lang_startuE0Cs9eTaobl00dh_8loop_sum>:
   155bc:	push   %rbp
   155bd:	mov    %rsp,%rbp
   155c0:	sub    $0x10,%rsp
   155c4:	mov    (%rdi),%rdi
   155c7:	call   155ae <_RINvNtNtCse6CrLDo09wl_3std3sys9backtrace28___rust_begin_short_backtraceFEuuECs9eTaobl00dh_8loop_sum>
   155cc:	call   1592e <_RNvXsU_NtCse6CrLDo09wl_3std7processuNtB5_11Termination6reportCs9eTaobl00dh_8loop_sum>
   155d1:	mov    %al,(%rsp)
   155d4:	lea    (%rsp),%r10
   155d8:	movzbl (%r10),%eax
   155dc:	add    $0x10,%rsp
   155e0:	mov    %rbp,%rsp
   155e3:	pop    %rbp
   155e4:	ret


00000000000155e5 <_RNSNvYNCINvNtCse6CrLDo09wl_3std2rt10lang_startuE0INtNtNtCs71d6MpIv4UP_4core3ops8function6FnOnceuE9call_once6vtableCs9eTaobl00dh_8loop_sum>:
   155e5:	push   %rbp
   155e6:	mov    %rsp,%rbp
   155e9:	mov    (%rdi),%rdi
   155ec:	call   1595e <_RNvYNCINvNtCse6CrLDo09wl_3std2rt10lang_startuE0INtNtNtCs71d6MpIv4UP_4core3ops8function6FnOnceuE9call_onceCs9eTaobl00dh_8loop_sum>
   155f1:	mov    %rbp,%rsp
   155f4:	pop    %rbp
   155f5:	ret
   155f6:	int3
   155f7:	int3


00000000000155f8 <_RNvCs9eTaobl00dh_8loop_sum15loop_sum_kernel>:
   155f8:	push   %rbp
   155f9:	mov    %rsp,%rbp
   155fc:	sub    $0x30,%rsp
   15600:	mov    %rbx,0x20(%rsp)
   15605:	xor    %eax,%eax
   15607:	mov    %rax,%rbx
   1560a:	movl   $0x0,0x8(%rsp)
   15612:	movl   $0x3e8,0xc(%rsp)
   1561a:	mov    0x8(%rsp),%edi
   1561e:	mov    0xc(%rsp),%esi
   15622:	call   157d8 <_RNvXNtNtNtCs71d6MpIv4UP_4core4iter6traits7collectINtNtNtB8_3ops5range5RangelENtB2_12IntoIterator9into_iterCs9eTaobl00dh_8loop_sum>
   15627:	mov    %eax,(%rsp)
   1562a:	mov    %edx,0x4(%rsp)
   1562e:	mov    (%rsp),%ecx
   15631:	mov    0x4(%rsp),%edx
   15635:	mov    %ecx,0x10(%rsp)
   15639:	mov    %edx,0x14(%rsp)
   1563d:	lea    0x10(%rsp),%rdi
   15642:	call   158a8 <_RNvXs4_NtNtCs71d6MpIv4UP_4core4iter5rangeINtNtNtB9_3ops5range5RangelENtNtNtB7_6traits8iterator8Iterator4nextCs9eTaobl00dh_8loop_sum>
   15647:	mov    %eax,0x18(%rsp)
   1564b:	mov    %edx,0x1c(%rsp)
   1564f:	mov    0x18(%rsp),%eax
   15653:	mov    %eax,%ecx
   15655:	cmp    0x7c(%rip),%rcx        # 156d8 <_RNvCs9eTaobl00dh_8loop_sum15loop_sum_kernel+0xe0>
   1565c:	ja     156d6 <_RNvCs9eTaobl00dh_8loop_sum15loop_sum_kernel+0xde>
   15662:	mov    $0x2,%edx
   15667:	mov    %ecx,%ecx
   15669:	cmp    %edx,%ecx
   1566b:	cmovb  %ecx,%edx
   1566e:	lea    0x9(%rip),%rcx        # 1567e <_RNvCs9eTaobl00dh_8loop_sum15loop_sum_kernel+0x86>
   15675:	movslq (%rcx,%rdx,4),%rax
   15679:	add    %rax,%rcx
   1567c:	jmp    *%rcx
   1567e:	xor    %al,(%rax)
   15680:	add    %al,(%rax)
   15682:	or     $0x0,%al
   15684:	add    %al,(%rax)
   15686:	pop    %rax
   15687:	add    %al,(%rax)
   15689:	add    %cl,0x481c2454(%rbx)
   1568f:	mov    %ebx,%eax
   15691:	lea    (%rax,%rdx,1),%ecx
   15694:	shr    $0x1f,%edx
   15697:	cmp    %eax,%ecx
   15699:	setl   %al
   1569c:	xor    %eax,%edx
   1569e:	test   %dl,%dl
   156a0:	jne    156c4 <_RNvCs9eTaobl00dh_8loop_sum15loop_sum_kernel+0xcc>
   156a6:	mov    %rcx,%rbx
   156a9:	jmp    1563d <_RNvCs9eTaobl00dh_8loop_sum15loop_sum_kernel+0x45>
   156ae:	mov    %rbx,%rax
   156b1:	mov    0x20(%rsp),%rbx
   156b6:	add    $0x30,%rsp
   156ba:	mov    %rbp,%rsp
   156bd:	pop    %rbp
   156be:	ret
   156bf:	jmp    156d6 <_RNvCs9eTaobl00dh_8loop_sum15loop_sum_kernel+0xde>
   156c4:	mov    0x415e5(%rip),%rdi        # 56cb0 <_DYNAMIC+0xac8>
   156cb:	mov    0x40d7e(%rip),%rax        # 56450 <_DYNAMIC+0x268>
   156d2:	call   *%rax
   156d4:	ud2
   156d6:	ud2
   156d8:	(bad)
   156d9:	(bad)
   156da:	(bad)
   156db:	incl   (%rax)
   156dd:	add    %al,(%rax)
	...


00000000000156e0 <_RNvCs9eTaobl00dh_8loop_sum4main>:
   156e0:	push   %rbp
   156e1:	mov    %rsp,%rbp
   156e4:	sub    $0x40,%rsp
   156e8:	call   155f8 <_RNvCs9eTaobl00dh_8loop_sum15loop_sum_kernel>
   156ed:	mov    %eax,0x18(%rsp)
   156f1:	lea    0x18(%rsp),%rax
   156f6:	mov    %rax,0x10(%rsp)
   156fb:	mov    0x10(%rsp),%rsi
   15700:	lea    0x30(%rsp),%rdi
   15705:	call   154f9 <_RINvMNtNtCs71d6MpIv4UP_4core3fmt2rtNtB3_8Argument11new_displaylECs9eTaobl00dh_8loop_sum>
   1570a:	imul   $0x0,0x4e(%rip),%rax        # 15760 <_RNvCs9eTaobl00dh_8loop_sum4main+0x80>
   15712:	lea    0x20(%rsp),%rcx
   15717:	mov    0x30(%rsp),%rdx
   1571c:	mov    0x38(%rsp),%rsi
   15721:	mov    %rdx,(%rcx,%rax,1)
   15725:	mov    %rsi,0x8(%rcx,%rax,1)
   1572a:	mov    0x41587(%rip),%rdi        # 56cb8 <_DYNAMIC+0xad0>
   15731:	lea    0x20(%rsp),%rsi
   15736:	call   15541 <_RINvMs2_NtCs71d6MpIv4UP_4core3fmtNtB6_9Arguments3newKj4_Kj1_ECs9eTaobl00dh_8loop_sum>
   1573b:	mov    %rax,(%rsp)
   1573f:	mov    %rdx,0x8(%rsp)
   15744:	mov    (%rsp),%rdi
   15748:	mov    0x8(%rsp),%rsi
   1574d:	mov    0x40d04(%rip),%rax        # 56458 <_DYNAMIC+0x270>
   15754:	call   *%rax
   15756:	add    $0x40,%rsp
   1575a:	mov    %rbp,%rsp
   1575d:	pop    %rbp
   1575e:	ret
   1575f:	add    %dl,(%rax)
   15761:	add    %al,(%rax)
   15763:	add    %al,(%rax)
   15765:	add    %al,(%rax)
	...


0000000000015768 <_RNvNvNtCs71d6MpIv4UP_4core4hint21unreachable_unchecked18precondition_checkCs9eTaobl00dh_8loop_sum>:
   15768:	push   %rbp
   15769:	mov    %rsp,%rbp
   1576c:	sub    $0x30,%rsp
   15770:	mov    %rdi,%r8
   15773:	mov    0x41546(%rip),%rax        # 56cc0 <_DYNAMIC+0xad8>
   1577a:	mov    %rax,(%rsp)
   1577e:	movq   $0xc7,0x8(%rsp)
   15787:	mov    (%rsp),%rax
   1578b:	mov    0x8(%rsp),%rcx
   15790:	mov    %rax,0x20(%rsp)
   15795:	mov    $0xc7,%eax
   1579a:	shl    $1,%rax
   1579d:	or     $0x1,%rax
   157a1:	mov    %rax,0x28(%rsp)
   157a6:	mov    0x20(%rsp),%rax
   157ab:	mov    %rax,0x10(%rsp)
   157b0:	mov    0x28(%rsp),%rax
   157b5:	mov    %rax,0x18(%rsp)
   157ba:	xor    %eax,%eax
   157bc:	mov    0x10(%rsp),%rdi
   157c1:	mov    0x18(%rsp),%rsi
   157c6:	movzbq %al,%rdx
   157ca:	mov    0x40c8f(%rip),%rax        # 56460 <_DYNAMIC+0x278>
   157d1:	mov    %r8,%rcx
   157d4:	call   *%rax
   157d6:	ud2


00000000000157d8 <_RNvXNtNtNtCs71d6MpIv4UP_4core4iter6traits7collectINtNtNtB8_3ops5range5RangelENtB2_12IntoIterator9into_iterCs9eTaobl00dh_8loop_sum>:
   157d8:	push   %rbp
   157d9:	mov    %rsp,%rbp
   157dc:	sub    $0x10,%rsp
   157e0:	mov    %edi,0x8(%rsp)
   157e4:	mov    %esi,0xc(%rsp)
   157e8:	mov    0x8(%rsp),%r9d
   157ed:	mov    0xc(%rsp),%r10d
   157f2:	mov    %r9d,(%rsp)
   157f6:	mov    %r10d,0x4(%rsp)
   157fb:	mov    (%rsp),%eax
   157fe:	mov    0x4(%rsp),%edx
   15802:	add    $0x10,%rsp
   15806:	mov    %rbp,%rsp
   15809:	pop    %rbp
   1580a:	ret


0000000000015820 <_RNvXs3_NtNtCs71d6MpIv4UP_4core4iter5rangeINtNtNtB9_3ops5range5RangelENtB5_17RangeIteratorImpl9spec_nextCs9eTaobl00dh_8loop_sum>:
   15820:	push   %rbp
   15821:	mov    %rsp,%rbp
   15824:	sub    $0x20,%rsp
   15828:	mov    %rbx,0x10(%rsp)
   1582d:	mov    %rdi,0x8(%rsp)
   15832:	mov    0x8(%rsp),%rdi
   15837:	lea    0x8(%rsp),%rax
   1583c:	mov    $0x4,%esi
   15841:	add    (%rax),%rsi
   15844:	call   1580b <_RNvXs1c_NtNtCs71d6MpIv4UP_4core3cmp5implslNtB8_10PartialOrd2lt>
   15849:	test   %al,%al
   1584b:	jne    1586d <_RNvXs3_NtNtCs71d6MpIv4UP_4core4iter5rangeINtNtNtB9_3ops5range5RangelENtB5_17RangeIteratorImpl9spec_nextCs9eTaobl00dh_8loop_sum+0x4d>
   15851:	movl   $0x0,(%rsp)
   15858:	mov    (%rsp),%eax
   1585b:	mov    0x4(%rsp),%edx
   1585f:	mov    0x10(%rsp),%rbx
   15864:	add    $0x20,%rsp
   15868:	mov    %rbp,%rsp
   1586b:	pop    %rbp
   1586c:	ret
   1586d:	mov    0x8(%rsp),%rax
   15872:	mov    (%rax),%ebx
   15874:	mov    $0x1,%esi
   15879:	mov    %rbx,%rdi
   1587c:	call   158cc <_RNvXsI_NtNtCs71d6MpIv4UP_4core4iter5rangelNtB5_4Step17forward_uncheckedCs9eTaobl00dh_8loop_sum>
   15881:	mov    0x8(%rsp),%rcx
   15886:	mov    %eax,(%rcx)
   15888:	mov    %ebx,0x4(%rsp)
   1588c:	movl   $0x1,(%rsp)
   15893:	mov    (%rsp),%eax
   15896:	mov    0x4(%rsp),%edx
   1589a:	mov    0x10(%rsp),%rbx
   1589f:	add    $0x20,%rsp
   158a3:	mov    %rbp,%rsp
   158a6:	pop    %rbp
   158a7:	ret


00000000000158a8 <_RNvXs4_NtNtCs71d6MpIv4UP_4core4iter5rangeINtNtNtB9_3ops5range5RangelENtNtNtB7_6traits8iterator8Iterator4nextCs9eTaobl00dh_8loop_sum>:
   158a8:	push   %rbp
   158a9:	mov    %rsp,%rbp
   158ac:	sub    $0x10,%rsp
   158b0:	call   15820 <_RNvXs3_NtNtCs71d6MpIv4UP_4core4iter5rangeINtNtNtB9_3ops5range5RangelENtB5_17RangeIteratorImpl9spec_nextCs9eTaobl00dh_8loop_sum>
   158b5:	mov    %eax,(%rsp)
   158b8:	mov    %edx,0x4(%rsp)
   158bc:	mov    (%rsp),%eax
   158bf:	mov    0x4(%rsp),%edx
   158c3:	add    $0x10,%rsp
   158c7:	mov    %rbp,%rsp
   158ca:	pop    %rbp
   158cb:	ret


00000000000158cc <_RNvXsI_NtNtCs71d6MpIv4UP_4core4iter5rangelNtB5_4Step17forward_uncheckedCs9eTaobl00dh_8loop_sum>:
   158cc:	push   %rbp
   158cd:	mov    %rsp,%rbp
   158d0:	sub    $0x10,%rsp
   158d4:	lea    (%rdi,%rsi,1),%eax
   158d7:	mov    %rsi,%r10
   158da:	shr    $0x1f,%r10d
   158de:	cmp    %edi,%eax
   158e0:	setl   %cl
   158e3:	xor    %ecx,%r10d
   158e6:	shr    $0x1f,%esi
   158e9:	xor    %esi,%r10d
   158ec:	test   %r10b,%r10b
   158ef:	jne    1590d <_RNvXsI_NtNtCs71d6MpIv4UP_4core4iter5rangelNtB5_4Step17forward_uncheckedCs9eTaobl00dh_8loop_sum+0x41>
   158f5:	mov    %eax,0x4(%rsp)
   158f9:	movl   $0x1,(%rsp)
   15900:	mov    0x4(%rsp),%eax
   15904:	add    $0x10,%rsp
   15908:	mov    %rbp,%rsp
   1590b:	pop    %rbp
   1590c:	ret
   1590d:	mov    0x413b4(%rip),%rax        # 56cc8 <_DYNAMIC+0xae0>
   15914:	mov    (%rax),%ecx
   15916:	mov    0x4(%rax),%eax
   15919:	mov    %ecx,(%rsp)
   1591c:	mov    %eax,0x4(%rsp)
   15920:	mov    0x413a9(%rip),%rdi        # 56cd0 <_DYNAMIC+0xae8>
   15927:	call   15768 <_RNvNvNtCs71d6MpIv4UP_4core4hint21unreachable_unchecked18precondition_checkCs9eTaobl00dh_8loop_sum>
   1592c:	ud2


000000000001592e <_RNvXsU_NtCse6CrLDo09wl_3std7processuNtB5_11Termination6reportCs9eTaobl00dh_8loop_sum>:
   1592e:	push   %rbp
   1592f:	mov    %rsp,%rbp
   15932:	sub    $0x10,%rsp
   15936:	movb   $0x0,0x8(%rsp)
   1593b:	movzbq 0x8(%rsp),%rsi
   15941:	mov    %sil,(%rsp)
   15945:	movzbq (%rsp),%rax
   1594a:	add    $0x10,%rsp
   1594e:	mov    %rbp,%rsp
   15951:	pop    %rbp
   15952:	ret


0000000000015953 <_RNvYFEuINtNtNtCs71d6MpIv4UP_4core3ops8function6FnOnceuE9call_onceCs9eTaobl00dh_8loop_sum>:
   15953:	push   %rbp
   15954:	mov    %rsp,%rbp
   15957:	call   *%rdi
   15959:	mov    %rbp,%rsp
   1595c:	pop    %rbp
   1595d:	ret


000000000001595e <_RNvYNCINvNtCse6CrLDo09wl_3std2rt10lang_startuE0INtNtNtCs71d6MpIv4UP_4core3ops8function6FnOnceuE9call_onceCs9eTaobl00dh_8loop_sum>:
   1595e:	push   %rbp
   1595f:	mov    %rsp,%rbp
   15962:	sub    $0x10,%rsp
   15966:	mov    %rdi,(%rsp)
   1596a:	lea    (%rsp),%rdi
   1596e:	call   155bc <_RNCINvNtCse6CrLDo09wl_3std2rt10lang_startuE0Cs9eTaobl00dh_8loop_sum>
   15973:	add    $0x10,%rsp
   15977:	mov    %rbp,%rsp
   1597a:	pop    %rbp
   1597b:	ret
