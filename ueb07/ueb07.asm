global _start

extern printf
extern malloc

section .stack

section .data
	anzahl equ 15
	laengeknoten equ 16
	einfuegezahlen dq 0,18,16,8,17,1,21
	einfuegezahlenlaenge equ ($-einfuegezahlen)
	loeschzahlen dq 100,0,21,8,1
	loeschzahlenlaenge equ ($-loeschzahlen)

section .text

elementeinfuegen: 
; parameter:
; in/out: r12 - zeiger auf den listenanfang
; in: r13 - einzufuegende zahl
	enter 0,0
	push rax
	push rcx ; wird überschrieben durch malloc
	push rdi

	mov rdi,laengeknoten
	call malloc ; zurück rax: zeiger auf neuen knoten
	mov qword[rax],r13 ; wert in den neuen knoten
	mov qword[rax+8],0 ; next auf nil

	cmp r12,0 ; liste leer?
	je .nil
	mov qword[rax+8],r12 ; sonst next auf vorherigen ersten knoten
  .nil:
	mov r12,rax ; immer: listenanfang auf neuen knoten

  .ende:
	pop rdi
	pop rcx
	pop rax
	leave
	ret 

listeausgeben:
; parameter:
; in: r12 - zeiger auf den listenanfang
	enter 0,0
	push rax ; sonst segmentation fault (printf)
	push rdi
	push rsi
	push r14
	mov r14,r12 ; runpointer 

  .startloop:
	cmp r14,0 ; liste zu ende?
	je .nil 
	mov rdi,formatstring ; für printf
	mov rsi,[r14] ; zahl ausgeben       
  call printf
	mov r14,[r14+8] ; run:=run^.next
	jmp .startloop
  .nil:
	mov rdi,formatstring2
  call printf
	pop r14
	pop rsi
	pop rdi
	pop rax
	leave
	ret
	formatstring db 'zahl = %i',10,0 
	formatstring2 db 'fertig',10,0

elementsortierteinfuegen:
; parameter:
; in/out: r12 - zeiger auf den listenanfang
; in: r13 - einzufügende zahl
	enter 0,0
	push rax
	push rcx ; wird überschrieben durch malloc
	push rdi
	push r14
	push r11
	push r10
	
	mov rdi,laengeknoten
	call malloc 			;zurück rax: zeiger auf neuen knoten
	mov qword[rax],r13 		;wert in den neuen knoten
	mov qword[rax+8],0 		;next auf nil
	
	mov r14,r12				;runpointer
	
  for:
	cmp r14,0 				;liste zuende?
	je nil 					
	mov r10,[r14]
	
	cmp r10,r13	
	ja voreinfg				;anfang anfügen
	
	mov r11,[r14+8]
	
	cmp r11,0 
	je mideinfg				;mitte einfügen
	
	mov r11,[r11]
	
	cmp r11,r13
	ja mideinfg				;letzte Stelle anfügen
				
	mov r14,[r14+8] 	
	jmp for
		
  voreinfg:       
	mov qword[rax+8],r12
	mov r12,rax
	jmp nil
	
  mideinfg:	
	mov r10,r14				
	mov r14,[r14+8]
	mov r11,r14		
			
	mov [r10+8],rax
	mov [rax+8],r11
	
	nil:
	pop r10
	pop r11
	pop r14
	pop rdi
	pop rcx
	pop rax	
	leave
	ret 

elementloeschen:
; parameter:
; in/out: r12 - zeiger auf den listenanfang
; in: r13 - zu löschende zahl
enter 0,0
	push rcx
	push rdi
	push r14
	push r11
	push r10

	mov r14,r12
		
	mov r10,[r14]
	cmp r13,r10	
	ja for1	
	
  vorentf:
	mov r14,[r12+8]
	mov r12,r14			;vorne löschen
	jmp nil1
	
  for1:
	cmp r14,0				
	je nil1
		
	mov r10,[r14+8]
	
	cmp r10,0
	je nil1
	
	mov r11,[r14]
	mov r15,[r10]
	
	cmp r13,r15	
	je midentf			;mitte löschen
	
	mov r14,[r14+8]
	jmp for1
	
  midentf:
	mov r10,r14			;zeigt vor 
	mov r14,[r14+8]
	mov r14,[r14+8]
	mov r11,r14			;zeigt nach
	
	mov [r10+8],r11
	
  nil1:
	pop r10
	pop r11
	pop r14
	pop rdi
	pop rcx
	leave
	ret

_start:
	xor r12,r12 		;r12 zeiger auf den anfang der liste := nil (0)
	mov rcx,anzahl
  bauauf:
	mov r13,rcx 
call elementeinfuegen
	loop bauauf

call listeausgeben
	
	xor rax,rax
  fuegein:
	mov r13,[einfuegezahlen+rax] 
call elementsortierteinfuegen
	add rax,8
	cmp rax,einfuegezahlenlaenge
	jne fuegein

call listeausgeben

	xor rax,rax
  loesch:
	mov r13,[loeschzahlen+rax]
call elementloeschen
	add rax,8
	cmp rax,loeschzahlenlaenge
	jne loesch

call listeausgeben

	mov rcx,anzahl+anzahl
  raus:
	mov r13,rcx 
	
call elementloeschen
	loop raus

call listeausgeben

	mov rax,60  
	mov rdi,0   
	syscall
