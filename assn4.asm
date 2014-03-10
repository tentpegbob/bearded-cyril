; 14 February 2014
; nasm -f elf32 -g assn4.asm
; ld -o assn4 assn4.o dns.o

; run the program on the command line with
; ./assn4 http://<url>
; Example: ./assn4 http://www.google.com/nothere.html

; Debugging commands for easy copy and paste:::
; gdb ./assn4 -x gdbout
; strace ./assn4 http://www.google.com
; valgrind -v --leak-check=full ./assn4 http://www.google.com

; This program retrieves the content of a specified
; URL and saves it to a file named after the last component
; of the URL unless it is the root address (such as
; www.bob.com). An example would be www.nps.edu/foo.html
; the resulting content would be save in a file called foo.html
; otherwise it is saved in a file call index.html.

SECTION .text 	; Section containing code

global _start 			 ; Entry Point

;prototype unsigned int resolv (cont char *hostName);
;returns network byte ordered IP address of the named host
extern resolv				; provides host name resolution

; parameters: argc, argv
_start:

	push ebp
	mov ebp, esp

	mov eax, [ebp+12]		;grab argv[1]
	push eax		;push argv[1] to find length
	call fn_strlen
	pop ebx

	cld
	mov esi, [ebp+12]		;copies argv[1]
	lea edi, [temp]		;into temp for parsing
	mov ecx, eax		;function
	rep movsb

	call fn_parseHttpReq ;breaks off http and splts domain/resource

	push dword Host
	call resolv		;calls external dns resolver
	mov [NetOrder], eax		;contains host byte order

	call fn_openSocket		;create a new tcp (stream) socket
	call fn_openConnect		; make a connection on a  socket

	call fn_craftHttp		;minmal HTTP request to retrieve document
	call fn_read		;read the socket

	call fn_open		;open a file to write HTML to
	call fn_write		;write HTML to file
	call fn_close		;close file

	pop ebp
	mov esp, ebp
	push word 0
	call fn_exit		;exit program

;====================================
;============Functions Here=============
;====================================
; receives parse (string, length)
fn_parseHttpReq:
	push ebx
	push esi
	push edi

	mov ebx, temp
		.HTTPdrop:		;drops http:// from argv
  		movzx eax, byte [ebx]		;move 1st byte into ecx
  		inc ebx		; go to next byte
  		cmp eax, 0x2f		;checks for  " / "
			jnz .HTTPdrop		;if you dont find a / keep looping
	inc ebx		;drops second " / "

	;moves everything after HTTP:// into the url string
	mov esi, ebx      ; put address into the source index
	lea edi, [URLaddress]            ; put address into the destination index
		.url:
			mov al, [esi]            ; copy byte at address in esi to al
			inc esi                  ; increment address in esi
			mov [edi], al            ; copy byte in al to address in edi
			inc edi                  ; increment address in edi
			cmp al, 0            ; see if its an ascii zero
			jne .url            ; jump back and read next byte if not

	mov ebx, URLaddress
	;put resource filename into temp
		.SlashLoop:
			movzx eax, byte [ebx]		;move 1st byte into ecx
			inc ebx
			cmp eax, 0		;checks for 0
			jz .SlashDone
			cmp eax, 0x2F		;checks for  /
			jnz .SlashLoop		;if you dont find a / keep looping
			mov [temp], ebx      ; put address into the source index
		.SlashDone:

	;copy temp string into resource
	cmp byte [ebx],  0		;check and see if there is no resource
	jz .skipResource
	mov esi, [temp]      ; put address into the source index
	lea edi, [Resource]            ; put address into the destination index
		.resource:
			mov al, [esi]            ; copy byte at address in esi to al
			inc esi                  ; increment address in esi
			mov [edi], al            ; copy byte in al to address in edi
			inc edi                  ; increment address in edi
			cmp al, 0            ; see if its an ascii zero
			jne .resource            ; jump back and read next byte if not
		.skipResource:

	;moves domain name into host string
	lea esi, [URLaddress]      ; put address into the source index
	lea edi, [Host]            ; put address into the destination index
		.host:
			mov al, [esi]            ; copy byte at address in esi to al
			inc esi                  ; increment address in esi
			mov [edi], al            ; copy byte in al to address in edi
			inc edi                  ; increment address in edi
			cmp al, 0
			jz .done
			cmp al, 0x2F            ; see if its an ascii /
			jne .host            ; jump back and read next byte if not
		.done:
		dec edi
		mov [edi], byte 0x0		;null terminate host string

	pop edi
	pop esi
	pop ebx
	ret

; socket(AF_INET, SOCK_STREAM, 0)
fn_openSocket:
	push ebp
	mov ebp, esp

	push dword 0
	push dword 1 ; SOCK_STREAM
	push dword 2 ; AF_INET
	mov ecx, esp
	mov ebx, 1 ; sys_socket
	mov eax, 0x66 ; sys_socketcall
	int 0x80 ; fd returned in eax
	mov esi, eax

	mov esp, ebp
	pop ebp
	ret

; connect(int socket, const struct sockaddr *address, socklen_t address_len)
; connect (fd, sockaddr, 16)
fn_openConnect:	;make a connection on a  socket
	push ebp
	mov ebp, esp

	;initialize sockaddr
	push dword [NetOrder]		;network byte order of web address
	push word 0x5000 ;port 80 in network byte order
	push word 2		;af_inet
	mov edx, esp

	push 0x10	;length
	push edx		; sockaddr
	push esi		; sockfd

	mov ecx, esp	;connect args
	mov ebx, 3 ; sys_connect
	mov eax, 0x66 ; sys_socketcall
	int 0x80 ; error/success returned in eax

	mov esp, ebp
	pop ebp
	ret

; write len bytes from buffer buf to file fd
; return # of bytes written
; ssize_t write(int fd, const void *buf, size_t count)
; sending (fd, crafted HTTP GET Request, HTTPMSG_LEN, 0)
fn_craftHttp:		;minmal HTTP request to retrieve document
	push ebp
	mov ebp, esp
	push ebx
	push edi
	push esi

	cld		; copies the string "GET /" into temp
	mov esi, GETHTTP
	lea edi, [temp]
	mov ecx, GETHTTPLEN
	rep movsb

	lea eax, [Resource]
	push eax
	call fn_strlen
	cmp eax, 0
	jl .noResource
	lea esi, [Resource]
	mov ecx, eax
	rep movsb
	.noResource:
	pop eax

	mov esi, HTTP		; copies the string " HTTP/1.0 0xD 0xA Host: " into temp
	mov ecx, HTTPLEN
	rep movsb

	lea eax, [Host]
	push eax
	call fn_strlen
	lea esi, [Host]
	mov ecx, eax
	rep movsb
	pop eax

	mov esi, GETHTTPEND		;copies  0xD 0xA 0xD 0xA 0 into temp
	mov ecx, GETHTTPENDLEN
	rep movsb

	lea ebx, [temp]			;finds the length of the entire
	push ebx		;GET request
	call fn_strlen		;prior to making system call
	pop ebx

	pop esi		;restore file descriptor
	pop edi

	mov edx, eax	; size_t len
	mov eax, 4		; sys_write
	mov ebx, esi		; int fd
	mov ecx, temp		; char *buffer
	int 0x80

	pop ebx
	mov esp, ebp
	pop ebp
	ret

; write nbytes to the buffer from assiciated fd
; ssize_t write(int fildes, const void *buf, size_t nbyte);
fn_write:
	push ebx
	mov eax, 4		; sys_write
	mov ebx, edi		; int fd
	mov ecx, ReceiveBuffer		; char *buffer
	mov edx, [esp]	; size_t len
	int 0x80
	pop ebx
	ret

; Read len bytes from file fd and place them into buffer
; Function parameters: int fd, char *buf, int len
fn_read:
        push ebx		; preserve - no clobber
        mov eax, 3		; sys_read
        mov ebx, esi		; input from file fd
        mov ecx, ReceiveBuffer		; buffer
        mov edx, ReceiveLen		; length
        int 0x80
        pop ebx					; restore ebx
        mov ebx, eax
        ret

; opens the named file with the supplied flags and mode
; returns the integer file descriptor of the newly opened file
; or -1 if the file can't be opened
; Function parameters: const char *name, int flags, int mode
; reference less /usr/include/asm-generic/fcntl.h for flags
fn_open:
	push ebx							; preserve ebx
	push esi

	lea ebx, [Resource]		;end of URL resource

	cmp byte [ebx], 0x0		; if resource has no entry then it is an index
	jz .index
		push ebx
		call fn_strlen		;check length of resource
		pop ebx
		add ebx, eax		;go to the end of the resource file
		.top:
		  movzx eax, byte [ebx]		;move 1st byte into ecx
		  dec ebx		; go to next byte
		  cmp eax, 0x2f		;checks for the first / from the end
			jnz .top		;if you dont find a / keep looping
		inc ebx		;account for null
		inc ebx		;remove preceding /
		mov [file2open], ebx		;moves resource into file2open
		jmp .skipIndex

	.index:
		lea ebx, [indexFile]
		mov [file2open], ebx		;moves index.html into file2open

	.skipIndex:
		mov eax, 5								; sys_open
		mov ebx, [file2open]			; char *name
		mov ecx, 0o102		; Create, Read/Write
		mov edx, 0o0664		; set permission bits 110 110 100
		int 0x80
		mov edi, eax		;fd for opened file

	pop esi
	pop ebx					; restore stuff
	ret

; close file and returns 0 on success or
; -1 on failure
; Function parameters: int fd
fn_close:
	push ebx		; preserve ebx
	mov eax, 6		; sys_close
	mov ebx, edi		; int fd
	int 0x80
	pop ebx		; restore ebx
	ret

; terminate the calling program with exit code
; Function parameters: int rc
fn_exit:
	mov ebx, [esp+4]			; return code
	mov eax, 1				; sys_exit
	int 0x80

	; return the length of a null terminated str not including the null char
; function parameters: char *str
fn_strlen:
	cld								; clear direction flag
	mov ecx, -1				; set inverse counter
	xor eax, eax			; reset step counter
	push edi						; preserve edi
	mov edi, [esp+8]		; move *str to edi
	repnz scasb					; scan bytes while not zero
	inc ecx							; prepare counter for not operand
	not ecx						;get value for length of *str
	mov eax, ecx		;put length in eax field for ret
	pop edi			;restore edi
	ret

;====================================
;============Functions Stop=============
;====================================

section .data
; 0xD -> Carriage Return 0xA -> Line Feed
indexFile db "index.html", 0

;Constants for crafting HTTP Get request
GETHTTP db 'GET /'
GETHTTPLEN equ $ - GETHTTP
HTTP db ' HTTP/1.0', 0xD, 0xA, 'Host: '
HTTPLEN equ $ - HTTP
GETHTTPEND db 0xD, 0xA, 0xD, 0xA, 0
GETHTTPENDLEN equ $- GETHTTPEND

section .bss
NetOrder: RESD 1
Host: RESB 250
URLaddress: RESB 250
Resource: RESB 250
temp: RESB 250
tempLen equ $ - temp
ReceiveBuffer: RESB 1500
ReceiveLen: equ $ - ReceiveBuffer
file2open: RESB 25
file2openLen: equ $ - file2open
