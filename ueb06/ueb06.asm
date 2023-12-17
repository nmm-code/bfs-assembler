GLOBAL _start

EXTERN printf

SECTION .stack

SECTION .data 

	A	db	'HalloPtl'
	Alen EQU $-A
	B	db	'Ptl'
	Blen EQU $-B	
	erg dq 0    
	s1	db 'Position = %i',10,0
	s2	db	'Nicht Drin',10,0
	
SECTION .text

	Pos:
	;Pos Funktion 
	;Ist R15 in R14 enthalten
	;in:R15,R14	
	;out:Rax
	enter 8,0
	push rdi
	push rsi
	push rcx	
	
	cld
	mov qword[rbp-8],Alen				
	
	xor rax,rax			
	mov rcx,Alen		
	
	mov rdi,r14								
	mov al,byte[r15]		
		
	Repne scasb
	
	jnz ende
			
	cmp rcx,0
	je ende
	
	mov rax,rcx
		
	mov rcx,Blen
	
	mov rsi,r15		
	sub rdi,1
							
	repe cmpsb				
	jnz ende
	
	sub qword[rbp-8],rax
	
	mov rax,qword[rbp-8]
	
	jmp END	
	ende:	
	mov rax,0		
	END:
	
	pop rcx
	pop rsi
	pop rdi
	leave	                
	ret	
	
	_start: 		
	mov r14,A
	mov r15,B	
	call Pos
	
	mov qword[erg],rax
	
	cmp rax,0
	je out
	mov rdi,s1				
	mov rax,1
	mov rsi,[erg]
	call printf
	
	jmp raus
	out:	
	mov rdi,s2
	call printf	
	raus:
	
	mov rax,60
	xor rdi,rdi
	SYSCALL
