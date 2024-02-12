%include "constants.inc"

section .rodata
    sockaddr:
        istruc sockaddr_in
            at .family, dw AF_INET
            at .port, db 0x1f, 0x90 ; 8080
            at .addr, db 127, 0, 0, 1 ; 127.0.0.1
        iend

section .bss
    socket_fd resd 1 ; Socket file descriptor

section .text
    global _start

_start:
    ; Create socket
    mov rax, SYS_SOCKET ; sys_socket(AF_INET, SOCK_STREAM, TCP)
    mov rdi, AF_INET
    mov rsi, SOCK_STREAM
    mov rdx, TCP
    syscall

    mov [socket_fd], eax ; Move socket file descriptor

    ; Bind socket
    mov rax, SYS_BIND ; sys_bind(socket_fd, sockaddr, sockaddr_size)
    mov edi, [socket_fd]
    mov rsi, sockaddr
    mov rdx, 16 ; Size of sockaddr
    syscall
    
    cmp rax, 0 ; Check for error
    jne .exit

    ; Listen
    mov rax, SYS_LISTEN ; sys_listen(socket_fd, backlog)
    mov edi, [socket_fd]
    mov rsi, 128 ; Max clients
    syscall

    ;TODO: Accept connection

.exit:
    ; Close Socket
    mov rax, SYS_CLOSE ; sys_close(socket_fd)
    mov edi, [socket_fd]
    syscall

    ; Exit
    mov rax, SYS_EXIT ; sys_exit(OK)
    mov rdi, OK
    syscall
