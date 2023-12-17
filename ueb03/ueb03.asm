GLOBAL _start

SECTION .data

z1 db 'Ein Lagerregal? NIE!',0
laenge EQU ($-z1)
z2 times laenge db 0

SECTION .text

_start:
mov rcx,laenge
;Prüfen auf zeichen und Großschreibung
for:
mov al,[z1+rcx]

cmp al,'z'         			
ja out
					
cmp al,'A'			
jb out

cmp al,'Z'			
jb in 					
					
cmp al,'a'			
jb out

;Konvertieren zu großbuchstabe
in:					
cmp al,'Z'			
ja else				
jmp then
else:				
sub al,32			
then:				
out:

mov byte[z1+rcx],al	
loop for

;Sonderzeichen weg
mov rcx,laenge

mov r15,0

for2:
mov al,[z1+rcx-1]	
					
cmp al,'Z'			
ja spring			
					
cmp al,'A'			
jb spring			
					
mov byte[z2+r15],al	
Add r15,1			
spring:				
					
loop for2			

;überprüfung auf palindromeigenschaft
mov rcx,r15
mov r14,0

for3:
mov al,[z2+rcx-1]

mov bl,[z2+r14]
add r14,1

cmp al,bl
jne raus

loop for3

mov rax,1

jmp  true
raus:
mov rax,0
true:
	
mov rax,60
xor rdi,rdi
SYSCALL
