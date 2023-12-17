GLOBAL _start
SECTION .text

_start:
mov al,'A'			
mov ah,al

cmp al,'F'			
ja out
					
cmp al,'0'			
jb out

cmp al,'9'			
jb in 					
					
cmp al,'A'			
jb out

in:					
sub ah,$30			
cmp ah,9					
sub ah,7			
then2:				

mov al,ah		
mov rdx,10			

mul al				

mov ah,al		

shl ah,4			
shr ah,4		
shr al,4			

add al,$30			
add ah,$30
			
out:				

mov rax,60
mov rdi,0
SYSCALL
