%include "constants.inc"

section .rodata
    sockaddr:
        istruc sockaddr_in
            at .family, dw AF_INET
            at .port, db 0x1f, 0x90 ; 8080
            at .addr, db 127, 0, 0, 1 ; 127.0.0.1
        iend

    ; Message we sent to client (json)
    msg: db `{ "msg": "Hello World!", "code": 200 }`, 10
    msg_len: equ $ - msg

section .bss
    socket_fd resd 1 ; Socket file descriptor
    client_fd resd 1 ; Client file descriptor

    req resb 2048 ; User request

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

    mov rax, SYS_WRITE ; sys_write(1, start_msg, size)
    mov rdi, 1
    mov rsi, start_msg
    mov rdx, start_len
    syscall

.handle:
    ; Accept Connections
    xor rsi, rsi
    xor rdx, rdx

    mov rax, SYS_ACCEPT ; sys_accept(socket_fd)
    mov edi, [socket_fd]
    syscall

    mov [client_fd], eax ; Move client file descriptor

    ; Send header
    mov rax, SYS_WRITE ; sys_write(client_fd, header, size)
    mov edi, [client_fd]
    mov rsi, header
    mov rdx, header_len
    syscall
    
    ; Send message
    mov rax, SYS_WRITE ; sys_write(client_fd, msg, size)
    mov edi, [client_fd]
    mov rsi, msg
    mov rdx, msg_len
    syscall

    cmp rax, 0 ; Check for error
    jl .exit

    ; Log user request
    mov rax, SYS_READ ; sys_read(client_fd, req, size)
    mov edi, [client_fd]
    mov rsi, req
    mov rdx, 2048
    syscall

    mov rax, SYS_WRITE ; sys_write(stdout, log, size)
    mov rdi, 1
    mov rsi, req
    mov rdx, 2048
    syscall
    
    ; Close Client Connection
    mov rax, SYS_CLOSE ; sys_close(client_fd)
    mov edi, [client_fd]
    syscall

    jmp .handle ; Repeat if OK

.exit:
    ; Close Socket
    mov rax, SYS_CLOSE ; sys_close(socket_fd)
    mov edi, [socket_fd]
    syscall

    ; Exit
    mov rax, SYS_EXIT ; sys_exit(OK)
    mov rdi, OK
    syscall