# Desensamblado (objdump -d) del binario de Cranelift, filtrado
# a las funciones del usuario (main + crate). cg_clif genera
# codigo maquina directo; no soporta --emit=asm.

00000000000151f9 <main>:
   151f9:	push   %rbp
   151fa:	mov    %rsp,%rbp
   151fd:	mov    %rdi,%r9
   15200:	xor    %ecx,%ecx
   15202:	mov    0x3fd2f(%rip),%rdi        # 54f38 <_DYNAMIC+0x250>
   15209:	mov    %rsi,%rdx
   1520c:	mov    %r9,%rsi
   1520f:	call   152e0 <_RINvNtCse6CrLDo09wl_3std2rt10lang_startuECs6mx43gcQQa9_7strings>
   15214:	mov    %rbp,%rsp
   15217:	pop    %rbp
   15218:	ret


0000000000015219 <_RINvMNtNtCs71d6MpIv4UP_4core3fmt2rtNtB3_8Argument11new_displayReECs6mx43gcQQa9_7strings>:
   15219:	push   %rbp
   1521a:	mov    %rsp,%rbp
   1521d:	sub    $0x20,%rsp
   15221:	mov    %rsi,(%rsp)
   15225:	mov    (%rsp),%r9
   15229:	mov    %r9,0x18(%rsp)
   1522e:	mov    0x3fd0b(%rip),%r10        # 54f40 <_DYNAMIC+0x258>
   15235:	mov    0x18(%rsp),%r11
   1523a:	mov    %r11,0x8(%rsp)
   1523f:	mov    %r10,0x10(%rsp)
   15244:	mov    0x8(%rsp),%rax
   15249:	mov    0x10(%rsp),%rcx
   1524e:	mov    %rax,(%rdi)
   15251:	mov    %rcx,0x8(%rdi)
   15255:	mov    %rdi,%rax
   15258:	add    $0x20,%rsp
   1525c:	mov    %rbp,%rsp
   1525f:	pop    %rbp
   15260:	ret


0000000000015261 <_RINvMNtNtCs71d6MpIv4UP_4core3fmt2rtNtB3_8Argument11new_displaylECs6mx43gcQQa9_7strings>:
   15261:	push   %rbp
   15262:	mov    %rsp,%rbp
   15265:	sub    $0x20,%rsp
   15269:	mov    %rsi,(%rsp)
   1526d:	mov    (%rsp),%r9
   15271:	mov    %r9,0x18(%rsp)
   15276:	mov    0x3fccb(%rip),%r10        # 54f48 <_DYNAMIC+0x260>
   1527d:	mov    0x18(%rsp),%r11
   15282:	mov    %r11,0x8(%rsp)
   15287:	mov    %r10,0x10(%rsp)
   1528c:	mov    0x8(%rsp),%rax
   15291:	mov    0x10(%rsp),%rcx
   15296:	mov    %rax,(%rdi)
   15299:	mov    %rcx,0x8(%rdi)
   1529d:	mov    %rdi,%rax
   152a0:	add    $0x20,%rsp
   152a4:	mov    %rbp,%rsp
   152a7:	pop    %rbp
   152a8:	ret


00000000000152a9 <_RINvMs2_NtCs71d6MpIv4UP_4core3fmtNtB6_9Arguments3newKj4_Kj1_ECs6mx43gcQQa9_7strings>:
   152a9:	push   %rbp
   152aa:	mov    %rsp,%rbp
   152ad:	sub    $0x20,%rsp
   152b1:	mov    %rdi,0x10(%rsp)
   152b6:	mov    %rsi,0x18(%rsp)
   152bb:	mov    0x10(%rsp),%r9
   152c0:	mov    %r9,(%rsp)
   152c4:	mov    0x18(%rsp),%r10
   152c9:	mov    %r10,0x8(%rsp)
   152ce:	mov    (%rsp),%rax
   152d2:	mov    0x8(%rsp),%rdx
   152d7:	add    $0x20,%rsp
   152db:	mov    %rbp,%rsp
   152de:	pop    %rbp
   152df:	ret


00000000000152e0 <_RINvNtCse6CrLDo09wl_3std2rt10lang_startuECs6mx43gcQQa9_7strings>:
   152e0:	push   %rbp
   152e1:	mov    %rsp,%rbp
   152e4:	sub    $0x10,%rsp
   152e8:	mov    %rsi,%rax
   152eb:	mov    %rdi,(%rsp)
   152ef:	lea    (%rsp),%rdi
   152f3:	mov    0x404ae(%rip),%rsi        # 557a8 <_DYNAMIC+0xac0>
   152fa:	mov    0x3fc4f(%rip),%r10        # 54f50 <_DYNAMIC+0x268>
   15301:	mov    %rcx,%r8
   15304:	mov    %rdx,%rcx
   15307:	mov    %rax,%rdx
   1530a:	call   *%r10
   1530d:	add    $0x10,%rsp
   15311:	mov    %rbp,%rsp
   15314:	pop    %rbp
   15315:	ret


0000000000015316 <_RINvNtNtCse6CrLDo09wl_3std3sys9backtrace28___rust_begin_short_backtraceFEuuECs6mx43gcQQa9_7strings>:
   15316:	push   %rbp
   15317:	mov    %rsp,%rbp
   1531a:	call   15495 <_RNvYFEuINtNtNtCs71d6MpIv4UP_4core3ops8function6FnOnceuE9call_onceCs6mx43gcQQa9_7strings>
   1531f:	mov    %rbp,%rsp
   15322:	pop    %rbp
   15323:	ret


0000000000015324 <_RNCINvNtCse6CrLDo09wl_3std2rt10lang_startuE0Cs6mx43gcQQa9_7strings>:
   15324:	push   %rbp
   15325:	mov    %rsp,%rbp
   15328:	sub    $0x10,%rsp
   1532c:	mov    (%rdi),%rdi
   1532f:	call   15316 <_RINvNtNtCse6CrLDo09wl_3std3sys9backtrace28___rust_begin_short_backtraceFEuuECs6mx43gcQQa9_7strings>
   15334:	call   15470 <_RNvXsU_NtCse6CrLDo09wl_3std7processuNtB5_11Termination6reportCs6mx43gcQQa9_7strings>
   15339:	mov    %al,(%rsp)
   1533c:	lea    (%rsp),%r10
   15340:	movzbl (%r10),%eax
   15344:	add    $0x10,%rsp
   15348:	mov    %rbp,%rsp
   1534b:	pop    %rbp
   1534c:	ret


000000000001534d <_RNSNvYNCINvNtCse6CrLDo09wl_3std2rt10lang_startuE0INtNtNtCs71d6MpIv4UP_4core3ops8function6FnOnceuE9call_once6vtableCs6mx43gcQQa9_7strings>:
   1534d:	push   %rbp
   1534e:	mov    %rsp,%rbp
   15351:	mov    (%rdi),%rdi
   15354:	call   154a0 <_RNvYNCINvNtCse6CrLDo09wl_3std2rt10lang_startuE0INtNtNtCs71d6MpIv4UP_4core3ops8function6FnOnceuE9call_onceCs6mx43gcQQa9_7strings>
   15359:	mov    %rbp,%rsp
   1535c:	pop    %rbp
   1535d:	ret
   1535e:	int3
   1535f:	int3


0000000000015360 <_RNvCs6mx43gcQQa9_7strings4main>:
   15360:	push   %rbp
   15361:	mov    %rsp,%rbp
   15364:	sub    $0x90,%rsp
   1536b:	mov    0x4043e(%rip),%rax        # 557b0 <_DYNAMIC+0xac8>
   15372:	mov    %rax,(%rsp)
   15376:	movq   $0xc,0x8(%rsp)
   1537f:	movl   $0x2a,0x10(%rsp)
   15387:	lea    0x10(%rsp),%rax
   1538c:	mov    %rax,0x28(%rsp)
   15391:	mov    0x28(%rsp),%rsi
   15396:	lea    0x40(%rsp),%rdi
   1539b:	call   15261 <_RINvMNtNtCs71d6MpIv4UP_4core3fmt2rtNtB3_8Argument11new_displaylECs6mx43gcQQa9_7strings>
   153a0:	imul   $0x0,0xc0(%rip),%rax        # 15468 <_RNvCs6mx43gcQQa9_7strings4main+0x108>
   153a8:	lea    0x30(%rsp),%rcx
   153ad:	mov    0x40(%rsp),%rdx
   153b2:	mov    0x48(%rsp),%rsi
   153b7:	mov    %rdx,(%rcx,%rax,1)
   153bb:	mov    %rsi,0x8(%rcx,%rax,1)
   153c0:	mov    0x403f1(%rip),%rdi        # 557b8 <_DYNAMIC+0xad0>
   153c7:	lea    0x30(%rsp),%rsi
   153cc:	call   152a9 <_RINvMs2_NtCs71d6MpIv4UP_4core3fmtNtB6_9Arguments3newKj4_Kj1_ECs6mx43gcQQa9_7strings>
   153d1:	mov    %rax,0x18(%rsp)
   153d6:	mov    %rdx,0x20(%rsp)
   153db:	mov    0x18(%rsp),%rdi
   153e0:	mov    0x20(%rsp),%rsi
   153e5:	mov    0x3fb6c(%rip),%rax        # 54f58 <_DYNAMIC+0x270>
   153ec:	call   *%rax
   153ee:	lea    (%rsp),%rax
   153f2:	mov    %rax,0x60(%rsp)
   153f7:	mov    0x60(%rsp),%rsi
   153fc:	lea    0x78(%rsp),%rdi
   15401:	call   15219 <_RINvMNtNtCs71d6MpIv4UP_4core3fmt2rtNtB3_8Argument11new_displayReECs6mx43gcQQa9_7strings>
   15406:	imul   $0x0,0x5a(%rip),%rax        # 15468 <_RNvCs6mx43gcQQa9_7strings4main+0x108>
   1540e:	lea    0x68(%rsp),%rcx
   15413:	mov    0x78(%rsp),%rdx
   15418:	mov    0x80(%rsp),%rsi
   15420:	mov    %rdx,(%rcx,%rax,1)
   15424:	mov    %rsi,0x8(%rcx,%rax,1)
   15429:	mov    0x40388(%rip),%rdi        # 557b8 <_DYNAMIC+0xad0>
   15430:	lea    0x68(%rsp),%rsi
   15435:	call   152a9 <_RINvMs2_NtCs71d6MpIv4UP_4core3fmtNtB6_9Arguments3newKj4_Kj1_ECs6mx43gcQQa9_7strings>
   1543a:	mov    %rax,0x50(%rsp)
   1543f:	mov    %rdx,0x58(%rsp)
   15444:	mov    0x50(%rsp),%rdi
   15449:	mov    0x58(%rsp),%rsi
   1544e:	mov    0x3fb03(%rip),%rax        # 54f58 <_DYNAMIC+0x270>
   15455:	call   *%rax
   15457:	add    $0x90,%rsp
   1545e:	mov    %rbp,%rsp
   15461:	pop    %rbp
   15462:	ret
   15463:	add    %al,(%rax)
   15465:	add    %al,(%rax)
   15467:	add    %dl,(%rax)
   15469:	add    %al,(%rax)
   1546b:	add    %al,(%rax)
   1546d:	add    %al,(%rax)
	...


0000000000015470 <_RNvXsU_NtCse6CrLDo09wl_3std7processuNtB5_11Termination6reportCs6mx43gcQQa9_7strings>:
   15470:	push   %rbp
   15471:	mov    %rsp,%rbp
   15474:	sub    $0x10,%rsp
   15478:	movb   $0x0,0x8(%rsp)
   1547d:	movzbq 0x8(%rsp),%rsi
   15483:	mov    %sil,(%rsp)
   15487:	movzbq (%rsp),%rax
   1548c:	add    $0x10,%rsp
   15490:	mov    %rbp,%rsp
   15493:	pop    %rbp
   15494:	ret


0000000000015495 <_RNvYFEuINtNtNtCs71d6MpIv4UP_4core3ops8function6FnOnceuE9call_onceCs6mx43gcQQa9_7strings>:
   15495:	push   %rbp
   15496:	mov    %rsp,%rbp
   15499:	call   *%rdi
   1549b:	mov    %rbp,%rsp
   1549e:	pop    %rbp
   1549f:	ret


00000000000154a0 <_RNvYNCINvNtCse6CrLDo09wl_3std2rt10lang_startuE0INtNtNtCs71d6MpIv4UP_4core3ops8function6FnOnceuE9call_onceCs6mx43gcQQa9_7strings>:
   154a0:	push   %rbp
   154a1:	mov    %rsp,%rbp
   154a4:	sub    $0x10,%rsp
   154a8:	mov    %rdi,(%rsp)
   154ac:	lea    (%rsp),%rdi
   154b0:	call   15324 <_RNCINvNtCse6CrLDo09wl_3std2rt10lang_startuE0Cs6mx43gcQQa9_7strings>
   154b5:	add    $0x10,%rsp
   154b9:	mov    %rbp,%rsp
   154bc:	pop    %rbp
   154bd:	ret
