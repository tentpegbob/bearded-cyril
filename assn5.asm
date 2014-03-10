; Date: 28 February 2014

; nasm -f elf32 -g assn5.asm
; ld -o assn5 assn5.o

; run the program on the command line with
; ./assn5

; Debugging commands for easy copy and paste:::
; gdb ./assn5 -x gdbout
; strace ./assn5
; valgrind -v --leak-check=full ./assn5

; This program emulates a shell but does not handle
; pipes or an other redirections (ie. |, <, >, etc.) pending
; any updates ...

SECTION .text 	; Section containing code

global _start 			 ; Entry Point

_start:

	.top:
	call fn_prompt
	call fn_readInput

	;check and see if the user entered "quit"
	mov eax, QuitProg		;loads initialized data for "quit"
	push eax
	lea eax, [InputBuff]
	push  eax
	call fn_strcmp		;returns 0 if user entered "quit"
	cmp eax, 0
	je .done
		add esp, 8		;clears off the two push statements
		mov eax, 2		;sys_fork
		int 0x80		;PID for parent returned in EAX
		cmp eax, 0		;comparison to identify child and parent threads
		jz .child		;child is in 0, parent is in 1, eax holds value for PID of parent

	.parent:
		mov edx, 0
		mov ecx, 0		;wait()
		mov ebx, eax		;PID of parent process
		mov eax, 7		;sys_waitpid
		int 0x80
		jmp .top		;parent returns to keep shell open

	.child:		;int execve(const char *filename, char *const argv[], char *const envp[])
		call fn_parseCmd
		lea edx, [esp+12]		;envp[]
		lea ecx, [CommandArgs]		;argv[]
		mov ebx, Command		;command ie. /bin/ls
		mov eax, 11		;sys_execve
		int 0x80
		cmp eax, 0		;was execve successful?
		jl fn_error		;if it wasn't print an error message and kill child
		;otherwise kill child anyways

	.done:
		push word 0
		call fn_exit		;exit program

;====================================
;============Functions Here=============
;====================================

;function parses out the various elements of the command line
;entry as follows: <command> <command args>
fn_parseCmd:
	;null terminates, replaces spaces with null, and moves
	;command argument pointers into CommandArgs
	lea edx, [InputBuff]	;loads input buffer from stdin
	push edx	;save for later with fn_strlen
	mov ecx, 1	;starts the command args pointer at 1 and
                      ;not 0 so that the command file itself can go
                      ;into the 0 position

	.startloop:
		cmp byte [edx], 0xA		;looks for \n from stdin entry
		je .finishedArgs
			cmp byte [edx], 0x20
			jne .stillLooking4Spaces
			mov byte [edx], 0x00		;replace 0x20 with 0x00
			inc edx		;gets ready to load the argument
			mov [CommandArgs+4*ecx], edx		;pointer to argument
			inc ecx		;moves to next position in CommandArgs
		.stillLooking4Spaces:
			inc edx
		jmp .startloop
	.finishedArgs:
	mov byte [edx], 0x0	;replaces \n with 0x0

	call fn_strlen		;find strlen of input saved from line:74
	mov ecx, eax		;move length into ecx for rep movsb

	;creates the binary file entry for execve and also saves
	;it into CommandArgs[0]
	lea edi, [Command]
	pop esi
	cmp byte [esi], 0x2F		;is there a slash?
	jz .doNotPrepend
	cmp byte [esi], 0x2E		;is there a "."?
	jz .doNotPrepend
		mov [edi], dword '/bin'
		add edi, 4
		mov byte [edi], '/'
		inc edi
	.doNotPrepend:
	rep movsb
	lea edi, [Command]
	mov [CommandArgs+0], edi
	ret

;writes $ to the prompt
fn_prompt:
	mov eax, 4 		;sys_write
	mov ebx, 1 		;stdout
	mov ecx, Prompt
	mov edx, PromptLen
	int 0x80
	ret

;writes error to the prompt if binary file isn't found
fn_error:

	;offsets the command prior to writing to stdout
	lea esi, [Command]
	;add esi, 5		;gets rid of the /bin/ for stdout
	cmp byte [esi], 0x0		;avoid printing just blank error
	je .skip		; statements because the user had no input
	push esi
	call fn_strlen		; finds length for rep movsb
	mov ecx, eax
	pop esi
	lea edi, [ErrorMsg]		;load buffer for Error Message
	rep movsb		;fill up ErrorMsg

	lea esi, [Error]		;initialized command not found entry
	mov ecx, ErrorLen
	rep movsb		;fill up ErrorMsg

	lea edi, [ErrorMsg]
	push edi
	call fn_strlen		;find total length of Error Message for stdout

	mov edx, eax
	mov eax, 4 		;sys_write
	mov ebx, 1 		;stdout
	mov ecx, ErrorMsg
	;mov edx, ErrorMsgLen
	int 0x80
	.skip:
	push word 0
	call fn_exit

;reads input from stdin
fn_readInput:
	mov eax, 3 				; sys_read
	mov ebx, 0 				; 0: Standard Input
	mov ecx, InputBuff 	; Pass offset of the buffer
	mov edx, InputBuffLen 	; Pass number of bytes to read
	int 0x80
	ret

; terminate the calling program with exit code
; Function parameters: int rc
fn_exit:
	mov ebx, [esp+4]			; return code
	mov eax, 1				; sys_exit
	int 0x80

; return 0 if str1 and str2 are equal and 1 if they are not
; function paremeters:  char *str1,  char *str2
fn_strcmp:
	push esi							; preserve esi - no clobber
	push edi							; preserve edi - no clobber

	mov esi, [esp+12]   ; *str1
	mov edi, [esp+16]   ; *str2
	push edi
	call fn_strlen
	pop edi
	mov ecx, eax
	cld
	rep cmpsb
	cmp ecx, 0
	jnz .notEqual
	mov eax, 0
	jmp .exit
	
.notEqual:
	mov eax, 1
	jmp .exit

.exit:
	pop edi				;restore edi
	pop esi				;restore esi
	ret

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
	;dec ecx		;don't count the null character
	mov eax, ecx		;put length in eax field for ret
	pop edi			;restore edi
	ret

;====================================
;============Functions Stop=============
;====================================

section .data
; 0xD -> Carriage Return 0xA -> Line Feed
Prompt db "$ ", 0
PromptLen equ $ - Prompt
Error db ": command not found", 0xA, 0 ; used for <prog>: command not found
ErrorLen equ $ - Error
QuitProg db "exit", 0

section .bss
InputBuff: RESB 255
InputBuffLen equ $ - InputBuff
Command: RESB 100
CommandArgs: RESB 100
ErrorMsg RESB 100
