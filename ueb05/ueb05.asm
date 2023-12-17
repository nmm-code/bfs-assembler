GLOBAL _start

EXTERN printf

SECTION .stack

SECTION .data 
	erg dq 0.0
	n EQU 10000000	    
	s1 db 'pi = %f',10,0

SECTION .text

kreis:
;Berechnung von pi
;in:rcx = Anzahl der Wiederholung
;out:rax

	push rbp
	mov rbp,rsp	;enter 24,0
	sub rsp,24
	
	push rcx
	
	mov qword[rbp-8],0
	mov qword[rbp-16],1
	mov qword[rbp-24],4

finit
	fld qword[rbp-8]

schleife:

	fld1
	fild qword[rbp-16]
	fdiv
	fadd
	
;nenner hochzaehlen
	add qword[rbp-16],2
	
;Zwischen add und sub wechseln
	fld1
	fild qword[rbp-16]
	fdiv
	fsub

	add qword[rbp-16],2
	
loop schleife
;4
	fild qword[rbp-24]

	fmul

	fst qword[rbp-8]
;rax
	mov rax,qword[rbp-8]
	pop rcx	
	
	mov rsp,rbp	
	pop rbp		;leave

ret


easypi:
;Berechnung von pi in einfach...
;out:rax
	push rbp
	mov rbp,rsp
	sub rsp,8
	 
finit
	fldpi
	fstp qword[rbp-8]
	mov rax,qword[rbp-8]

	mov rsp,rbp
	pop rbp
ret 




_start:
;Start des Programms

	mov rcx,n								;wiederholung der schleife
call kreis										;berechnung der Kreiszahl Pi 
	mov qword[erg],rax			;ergebnis auf rax

	mov rdi,s1
	mov rax,1
	movsd xmm0,[erg]
call printf					

call easypi									;berechnung der Kreiszahl Pi 
	mov qword[erg],rax		    ;ergebnis in rax

	mov rdi,s1				
	mov rax,1
	movsd xmm0,[erg]
call printf

mov rax,60
xor rdi,rdi
SYSCALL
