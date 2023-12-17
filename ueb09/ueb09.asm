GLOBAL rinstr,rinstrpos

	rinstrpos:
	; rdi Startpos
	; rsi Hauptstring
	; rdx char
	enter 0,0
	push rcx	;wegen loop
	push r14	;'aktueller' char
	
	mov rax,0
	
	mov rcx,rdi
	for:
	mov r14b,[rsi + rcx]	;bei rcx wert anfangen
	cmp r14,rdx
	je found
	loop for
	
	jmp ende
	
	found:
	mov rax,rcx		
	
	ende:	
	pop r14
	pop rcx
	leave	              
	ret	

	
	rinstr:
	;rdi Hauptstring
	;rsi gesuchter char
	push rdx
	;Parameter Richtig Ordnen für rinstrpos
	mov rdx,rsi		
	mov rsi,rdi		
	mov rdi,0		
	mov dil,[rsi]	;länge vom string
	
	call rinstrpos
	pop rdx
	ret

