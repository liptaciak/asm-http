SYS_SOCKET equ 41
SYS_BIND equ 49

struc sockaddr_in
    .family: resw 1
    .port: resw 1
    .addr: resd 1
    resb 8
endstruc

SYS_LISTEN equ 50

SYS_CLOSE equ 3
SYS_EXIT equ 60

OK equ 0

SOCK_STREAM equ 1
AF_INET equ 2
TCP equ 6