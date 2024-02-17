SYS_SOCKET equ 41
SYS_BIND equ 49

struc sockaddr_in
    .family: resw 1
    .port: resw 1
    .addr: resd 1
    resb 8
endstruc

SYS_LISTEN equ 50

start_msg: db "HTTP Server started at 127.0.0.1:8080", 10, 10
start_len: equ $ - start_msg

SYS_ACCEPT equ 43
SYS_WRITE equ 1

header:
        db "HTTP/1.1 200 OK", 10
        db "Content-Type: text/json", 10
        db "Connection: close", 10
        db 10
header_len: equ $ - header

SYS_READ equ 0

SYS_CLOSE equ 3
SYS_EXIT equ 60

OK equ 0

SOCK_STREAM equ 1
AF_INET equ 2
TCP equ 6