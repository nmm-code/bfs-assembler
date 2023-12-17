GLOBAL _start

SECTION .data

s1 times 25 db 0
laenge_s1 times 10 db 0
s2 times 25 db 0
out_s db 'Ist ein Palindrom',0
out_laenge EQU ($-out_s)
out_ns db 'Ist kein Palindrom',0
out_nlaenge EQU ($-out_ns)

SECTION .stack
 
SECTION .text


eingabe:
;Eingabe des eingabe puffers
;Parameter in:r9											
;Parameter out: rax 
push rcx
push rdi
push rsi
push rdx
push r8
push r10
push r11

mov rax,0
mov rdi,0
mov rsi,r9
mov rdx,laenge_s1
SYSCALL
mov qword[r9+rax-1],0 ;/n entfernen

pop r11
pop r10
pop r8
pop rdx
pop rsi
pop rdi
pop rcx
ret







nurGross:
;Upcase
;Parameter in:r9	
;Paramter  in:r11	leange von string									
;Parameter out:r9
;lokales register out:r10 positions wert
push rcx
push rax

mov rcx,r11
xor r10,r10

for:
mov al,[r9+r10]

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
mov byte[r9+r10],al	
add r10,1
loop for

pop rax
pop rcx

ret






sonderWeg:							
;Sonderzeichen weg
;paramete  in:r10 aktuelle string laenge
;Parameter in:r9											
;Parameter out:r8
;Parameter out:r15 laenge new string 	

push rcx
push rax


mov rcx,r10

mov r15,0
for2:
mov al,[r9+rcx-1]	
					
cmp al,'Z'			
ja spring			
					
cmp al,'A'			
jb spring			
					
mov byte[r8+r15],al	
Add r15,1			
spring:		 					
loop for2	

pop rax
pop rcx

ret





Palindrom:
;Palindrom eigenschaft checken
;Parameter in:r8											
;Parameter out:rax
;lokales register rcx: position rechts
;lokales register r14: position links

push rcx
push r14

mov rcx,r15
mov r14,0

for4:
mov al,[r8+rcx-1]

mov bl,[r8+r14]
add r14,1

cmp al,bl
jne raus

loop for4

mov rax,1

jmp  true
raus:
mov rax,0
true:

pop r14
pop rcx

ret




ausgabe:
;Ausgabe für Palindromeigenschaft
;Parameter in:r9 string für Ausgabe		 
;Parameter in:r10 laenge von string
push rcx
push rdi
push rsi
push rdx
push r8
push r11

mov rax,1
mov rdi,1
mov rsi,r9
mov rdx,r10
SYSCALL

pop r11
pop r8
pop rdx
pop rsi
pop rdi
pop rcx
ret


;Programm start
_start:                    						
xor rax,rax

mov r9,s1
call eingabe
sub rax,1
mov qword[laenge_s1],rax

;Umwandelung in Großbuchstaben
mov r11,[laenge_s1]
call nurGross
;sonderzeichen Entfernt
mov r8,s2
call sonderWeg
;palindrom prüfung start
mov qword[laenge_s1],r15
call Palindrom

;s=Ist ein Palindrom
mov r9,out_s
mov r10,out_laenge									

cmp rax,1
je palin
;s=Ist kein Palindrom
mov r9,out_ns
mov r10,out_nlaenge								

palin:
call ausgabe

mov rax,60
xor rdi,rdi
SYSCALL
