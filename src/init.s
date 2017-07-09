; init.s - simple init written in nasm assembly
; simply mounts some filesystems and runs /bin/sh
; Copyright (C) 2017 Kenneth B. Jensen <kenneth@jensen.cf>
; Software is part of the public domain, and is provided as-is 
; with no warranty of any kind, expressed or otherwise.

; BUILDING:
; $ nasm -f elf64 init.s
; $ ld init.o -o init

BITS 64
CPU X64

section .text
global _start

%macro mount 3
	mov rax, 0x53 ; sys_mkdir
	mov rdi, %1   ; location
	mov rsi, %3   ; mode
	syscall

	mov rax, 0xA5 ; sys_mount
;	mov rdi, 0    ; device name
	mov rsi, %1   ; location
	mov rdx, %2   ; filesystem
;	mov r10, 0    ; flags
;	mov r8,  0    ; data
	syscall
%endmacro

_start:
	mount p_path, p_fs, 755o
	mount s_path, s_fs, 755o
	mount t_path, t_fs, 777o

	mov rax, 0x3B ; sys_execve
	mov rdi, sh_path
	mov rsi, sh_argv
	xor rdx, rdx
	syscall


p_path:
	db "/"
p_fs: 
	db "proc", 0

s_path:
	db "/sys", 0
s_fs:
	db "sysfs", 0

t_path:
	db "/tmp", 0
t_fs:
	db "ramfs", 0

sh_path:
	db "/bin/sh", 0
sh_argv:
	dq sh_path, 0
