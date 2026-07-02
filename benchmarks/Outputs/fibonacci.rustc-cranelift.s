# Desensamblado (objdump -d) del binario de Cranelift, filtrado
# a las funciones del usuario (main + crate). cg_clif genera
# codigo maquina directo; no soporta --emit=asm.

0000000000015329 <main>:
   15329:	push   %rbp
   1532a:	mov    %rsp,%rbp
   1532d:	mov    %rdi,%r9
   15330:	xor    %ecx,%ecx
   15332:	mov    0x40db7(%rip),%rdi        # 560f0 <_DYNAMIC+0x250>
   15339:	mov    %rsi,%rdx
   1533c:	mov    %r9,%rsi
   1533f:	call   153c8 <_RINvNtCse6CrLDo09wl_3std2rt10lang_startuECs2k8n3yZfhVx_9fibonacci>
   15344:	mov    %rbp,%rsp
   15347:	pop    %rbp
   15348:	ret


0000000000015349 <_RINvMNtNtCs71d6MpIv4UP_4core3fmt2rtNtB3_8Argument11new_displaylECs2k8n3yZfhVx_9fibonacci>:
   15349:	push   %rbp
   1534a:	mov    %rsp,%rbp
   1534d:	sub    $0x20,%rsp
   15351:	mov    %rsi,(%rsp)
   15355:	mov    (%rsp),%r9
   15359:	mov    %r9,0x18(%rsp)
   1535e:	mov    0x40d93(%rip),%r10        # 560f8 <_DYNAMIC+0x258>
   15365:	mov    0x18(%rsp),%r11
   1536a:	mov    %r11,0x8(%rsp)
   1536f:	mov    %r10,0x10(%rsp)
   15374:	mov    0x8(%rsp),%rax
   15379:	mov    0x10(%rsp),%rcx
   1537e:	mov    %rax,(%rdi)
   15381:	mov    %rcx,0x8(%rdi)
   15385:	mov    %rdi,%rax
   15388:	add    $0x20,%rsp
   1538c:	mov    %rbp,%rsp
   1538f:	pop    %rbp
   15390:	ret


0000000000015391 <_RINvMs2_NtCs71d6MpIv4UP_4core3fmtNtB6_9Arguments3newKj4_Kj1_ECs2k8n3yZfhVx_9fibonacci>:
   15391:	push   %rbp
   15392:	mov    %rsp,%rbp
   15395:	sub    $0x20,%rsp
   15399:	mov    %rdi,0x10(%rsp)
   1539e:	mov    %rsi,0x18(%rsp)
   153a3:	mov    0x10(%rsp),%r9
   153a8:	mov    %r9,(%rsp)
   153ac:	mov    0x18(%rsp),%r10
   153b1:	mov    %r10,0x8(%rsp)
   153b6:	mov    (%rsp),%rax
   153ba:	mov    0x8(%rsp),%rdx
   153bf:	add    $0x20,%rsp
   153c3:	mov    %rbp,%rsp
   153c6:	pop    %rbp
   153c7:	ret


00000000000153c8 <_RINvNtCse6CrLDo09wl_3std2rt10lang_startuECs2k8n3yZfhVx_9fibonacci>:
   153c8:	push   %rbp
   153c9:	mov    %rsp,%rbp
   153cc:	sub    $0x10,%rsp
   153d0:	mov    %rsi,%rax
   153d3:	mov    %rdi,(%rsp)
   153d7:	lea    (%rsp),%rdi
   153db:	mov    0x41586(%rip),%rsi        # 56968 <_DYNAMIC+0xac8>
   153e2:	mov    0x40d17(%rip),%r10        # 56100 <_DYNAMIC+0x260>
   153e9:	mov    %rcx,%r8
   153ec:	mov    %rdx,%rcx
   153ef:	mov    %rax,%rdx
   153f2:	call   *%r10
   153f5:	add    $0x10,%rsp
   153f9:	mov    %rbp,%rsp
   153fc:	pop    %rbp
   153fd:	ret


00000000000153fe <_RINvNtNtCse6CrLDo09wl_3std3sys9backtrace28___rust_begin_short_backtraceFEuuECs2k8n3yZfhVx_9fibonacci>:
   153fe:	push   %rbp
   153ff:	mov    %rsp,%rbp
   15402:	call   155dd <_RNvYFEuINtNtNtCs71d6MpIv4UP_4core3ops8function6FnOnceuE9call_onceCs2k8n3yZfhVx_9fibonacci>
   15407:	mov    %rbp,%rsp
   1540a:	pop    %rbp
   1540b:	ret


000000000001540c <_RNCINvNtCse6CrLDo09wl_3std2rt10lang_startuE0Cs2k8n3yZfhVx_9fibonacci>:
   1540c:	push   %rbp
   1540d:	mov    %rsp,%rbp
   15410:	sub    $0x10,%rsp
   15414:	mov    (%rdi),%rdi
   15417:	call   153fe <_RINvNtNtCse6CrLDo09wl_3std3sys9backtrace28___rust_begin_short_backtraceFEuuECs2k8n3yZfhVx_9fibonacci>
   1541c:	call   155b8 <_RNvXsU_NtCse6CrLDo09wl_3std7processuNtB5_11Termination6reportCs2k8n3yZfhVx_9fibonacci>
   15421:	mov    %al,(%rsp)
   15424:	lea    (%rsp),%r10
   15428:	movzbl (%r10),%eax
   1542c:	add    $0x10,%rsp
   15430:	mov    %rbp,%rsp
   15433:	pop    %rbp
   15434:	ret


0000000000015435 <_RNSNvYNCINvNtCse6CrLDo09wl_3std2rt10lang_startuE0INtNtNtCs71d6MpIv4UP_4core3ops8function6FnOnceuE9call_once6vtableCs2k8n3yZfhVx_9fibonacci>:
   15435:	push   %rbp
   15436:	mov    %rsp,%rbp
   15439:	mov    (%rdi),%rdi
   1543c:	call   155e8 <_RNvYNCINvNtCse6CrLDo09wl_3std2rt10lang_startuE0INtNtNtCs71d6MpIv4UP_4core3ops8function6FnOnceuE9call_onceCs2k8n3yZfhVx_9fibonacci>
   15441:	mov    %rbp,%rsp
   15444:	pop    %rbp
   15445:	ret


0000000000015446 <_RNvCs2k8n3yZfhVx_9fibonacci3fib>:
   15446:	push   %rbp
   15447:	mov    %rsp,%rbp
   1544a:	sub    $0x10,%rsp
   1544e:	mov    %rbx,(%rsp)
   15452:	mov    %r12,0x8(%rsp)
   15457:	cmp    $0x1,%edi
   1545a:	jle    154dd <_RNvCs2k8n3yZfhVx_9fibonacci3fib+0x97>
   15460:	mov    $0x1,%ecx
   15465:	mov    %rdi,%rax
   15468:	sub    $0x1,%eax
   1546b:	shr    $0x1f,%ecx
   1546e:	cmp    %edi,%eax
   15470:	mov    %rdi,%rbx
   15473:	setg   %dl
   15476:	xor    %edx,%ecx
   15478:	test   %cl,%cl
   1547a:	jne    15516 <_RNvCs2k8n3yZfhVx_9fibonacci3fib+0xd0>
   15480:	mov    %rax,%rdi
   15483:	call   15446 <_RNvCs2k8n3yZfhVx_9fibonacci3fib>
   15488:	mov    %rax,%r12
   1548b:	mov    $0x2,%eax
   15490:	mov    %rbx,%rcx
   15493:	mov    %rcx,%rdi
   15496:	sub    $0x2,%edi
   15499:	shr    $0x1f,%eax
   1549c:	cmp    %ecx,%edi
   1549e:	setg   %cl
   154a1:	xor    %ecx,%eax
   154a3:	test   %al,%al
   154a5:	jne    15504 <_RNvCs2k8n3yZfhVx_9fibonacci3fib+0xbe>
   154ab:	call   15446 <_RNvCs2k8n3yZfhVx_9fibonacci3fib>
   154b0:	mov    %r12,%rdx
   154b3:	lea    (%rdx,%rax,1),%ecx
   154b6:	shr    $0x1f,%eax
   154b9:	cmp    %edx,%ecx
   154bb:	setl   %dl
   154be:	xor    %edx,%eax
   154c0:	test   %al,%al
   154c2:	jne    154f2 <_RNvCs2k8n3yZfhVx_9fibonacci3fib+0xac>
   154c8:	mov    %rcx,%rax
   154cb:	mov    (%rsp),%rbx
   154cf:	mov    0x8(%rsp),%r12
   154d4:	add    $0x10,%rsp
   154d8:	mov    %rbp,%rsp
   154db:	pop    %rbp
   154dc:	ret
   154dd:	mov    %rdi,%rax
   154e0:	mov    (%rsp),%rbx
   154e4:	mov    0x8(%rsp),%r12
   154e9:	add    $0x10,%rsp
   154ed:	mov    %rbp,%rsp
   154f0:	pop    %rbp
   154f1:	ret
   154f2:	mov    0x41487(%rip),%rdi        # 56980 <_DYNAMIC+0xae0>
   154f9:	mov    0x40c10(%rip),%rax        # 56110 <_DYNAMIC+0x270>
   15500:	call   *%rax
   15502:	ud2
   15504:	mov    0x4146d(%rip),%rdi        # 56978 <_DYNAMIC+0xad8>
   1550b:	mov    0x40bf6(%rip),%rax        # 56108 <_DYNAMIC+0x268>
   15512:	call   *%rax
   15514:	ud2
   15516:	mov    0x41453(%rip),%rdi        # 56970 <_DYNAMIC+0xad0>
   1551d:	mov    0x40be4(%rip),%rax        # 56108 <_DYNAMIC+0x268>
   15524:	call   *%rax
   15526:	ud2


0000000000015528 <_RNvCs2k8n3yZfhVx_9fibonacci4main>:
   15528:	push   %rbp
   15529:	mov    %rsp,%rbp
   1552c:	sub    $0x40,%rsp
   15530:	mov    $0xa,%edi
   15535:	call   15446 <_RNvCs2k8n3yZfhVx_9fibonacci3fib>
   1553a:	mov    %eax,(%rsp)
   1553d:	lea    (%rsp),%rax
   15541:	mov    %rax,0x18(%rsp)
   15546:	mov    0x18(%rsp),%rsi
   1554b:	lea    0x30(%rsp),%rdi
   15550:	call   15349 <_RINvMNtNtCs71d6MpIv4UP_4core3fmt2rtNtB3_8Argument11new_displaylECs2k8n3yZfhVx_9fibonacci>
   15555:	imul   $0x0,0x53(%rip),%rax        # 155b0 <_RNvCs2k8n3yZfhVx_9fibonacci4main+0x88>
   1555d:	lea    0x20(%rsp),%rcx
   15562:	mov    0x30(%rsp),%rdx
   15567:	mov    0x38(%rsp),%rsi
   1556c:	mov    %rdx,(%rcx,%rax,1)
   15570:	mov    %rsi,0x8(%rcx,%rax,1)
   15575:	mov    0x4140c(%rip),%rdi        # 56988 <_DYNAMIC+0xae8>
   1557c:	lea    0x20(%rsp),%rsi
   15581:	call   15391 <_RINvMs2_NtCs71d6MpIv4UP_4core3fmtNtB6_9Arguments3newKj4_Kj1_ECs2k8n3yZfhVx_9fibonacci>
   15586:	mov    %rax,0x8(%rsp)
   1558b:	mov    %rdx,0x10(%rsp)
   15590:	mov    0x8(%rsp),%rdi
   15595:	mov    0x10(%rsp),%rsi
   1559a:	mov    0x40b77(%rip),%rax        # 56118 <_DYNAMIC+0x278>
   155a1:	call   *%rax
   155a3:	add    $0x40,%rsp
   155a7:	mov    %rbp,%rsp
   155aa:	pop    %rbp
   155ab:	ret
   155ac:	add    %al,(%rax)
   155ae:	add    %al,(%rax)
   155b0:	adc    %al,(%rax)
   155b2:	add    %al,(%rax)
   155b4:	add    %al,(%rax)
	...


00000000000155b8 <_RNvXsU_NtCse6CrLDo09wl_3std7processuNtB5_11Termination6reportCs2k8n3yZfhVx_9fibonacci>:
   155b8:	push   %rbp
   155b9:	mov    %rsp,%rbp
   155bc:	sub    $0x10,%rsp
   155c0:	movb   $0x0,0x8(%rsp)
   155c5:	movzbq 0x8(%rsp),%rsi
   155cb:	mov    %sil,(%rsp)
   155cf:	movzbq (%rsp),%rax
   155d4:	add    $0x10,%rsp
   155d8:	mov    %rbp,%rsp
   155db:	pop    %rbp
   155dc:	ret


00000000000155dd <_RNvYFEuINtNtNtCs71d6MpIv4UP_4core3ops8function6FnOnceuE9call_onceCs2k8n3yZfhVx_9fibonacci>:
   155dd:	push   %rbp
   155de:	mov    %rsp,%rbp
   155e1:	call   *%rdi
   155e3:	mov    %rbp,%rsp
   155e6:	pop    %rbp
   155e7:	ret


00000000000155e8 <_RNvYNCINvNtCse6CrLDo09wl_3std2rt10lang_startuE0INtNtNtCs71d6MpIv4UP_4core3ops8function6FnOnceuE9call_onceCs2k8n3yZfhVx_9fibonacci>:
   155e8:	push   %rbp
   155e9:	mov    %rsp,%rbp
   155ec:	sub    $0x10,%rsp
   155f0:	mov    %rdi,(%rsp)
   155f4:	lea    (%rsp),%rdi
   155f8:	call   1540c <_RNCINvNtCse6CrLDo09wl_3std2rt10lang_startuE0Cs2k8n3yZfhVx_9fibonacci>
   155fd:	add    $0x10,%rsp
   15601:	mov    %rbp,%rsp
   15604:	pop    %rbp
   15605:	ret
