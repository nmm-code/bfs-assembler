GLOBAL _start
SECTION .text

_start:
mov al,4
mov rcx,50

schleife:
mov r8b,al
mov r9b,al

shl r8b,1
xor r9b,r8b

shl r8b,2
xor r9b,r8b

shl r8b,2
xor r9b,r8b

rcl r9b,1
rcl al,1

loop schleife

mov rax,60
mov rdi,0
SYSCALL
