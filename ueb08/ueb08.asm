global _start

section .stack

section .data
	Breite  equ 1920
	Hoehe equ 1080	
	pix equ Breite*Hoehe	
	siz equ pix*4 
	
	bildBreite equ 100	
	pixbild equ bildBreite*bildBreite	
	sizbild equ pixbild*4
	
	filename db '/dev/fb0',0
	bild db 'ueb08_img.data',0
	
section .text

_start:
	; Datei öffnen:
	mov rax,2
	mov rdi,filename
	mov rsi,2
	mov rdx,0
	syscall
	
	;Datei mappen:
	mov r8,rax
	mov rax,9 ;mmap
	mov rdi,0
	mov rsi,siz
	mov rdx,3
	mov r10,1
	mov r9,0
	syscall
	mov r12,rax
	
	
	;Bild öffnen:
	mov rax,2
	mov rdi,bild
	mov rsi,0
	mov rdx,0
	syscall
	
	;Bild mappen:
	mov r8,rax
	mov rax,9 ;mmap
	mov rdi,0
	mov rsi,sizbild
	mov rdx,1
	mov r10,1
	mov r9,0
	syscall
	
	xor rdi,rdi	
	xor r15,r15
	mov rcx,pixbild
	
	add rdi,(Breite-bildBreite)*2	;Center
	
	startloop:
	xor r9,r9

	mov bl,[rax]
	add r9b,bl
	shl r9d,8

	mov bl,[rax+1]
	add r9b,bl
	shl r9d,8

	mov bl,[rax+2]
	add r9b,bl
	shl r9d,8
	
	mov dword[R12+RDI],r9d
	add rax,3					
	add rdi,4
	inc r15
	
	cmp r15,bildBreite
	jne weiter	
	add rdi,(Breite-bildBreite)*4	;Zeilenumbruch
	xor r15,r15
	weiter:
	
	loop startloop
	
	mov rax,60  
	mov rdi,0   
	syscall

