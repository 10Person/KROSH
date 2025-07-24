org 0x7C00	; Moves the file origin to the place where the BIOS starts to look for an OS.
bits 16		; Sets compiler mode to 16 bits, as x86 starts like that.

%define ENDL 0x0D, 0x0A

		; Start of program
start: 
	jmp main


; Prints string to screen ending in null.
; Params: ds:si points to string
puts:
	; save registers that'l be modified.
	push si
	push ax

.loop:
	lodsb	; loads the next char in al
	or al, al	; verify if null

	
	jz .done


	mov ah, 0x0e
	mov bh, 0
	int 0x10

	jmp .loop	
	
.done:
	pop ax 
	pop si
	ret 	; Return from func.

; Interrupt: processor stops to handle the signal. 1. Exception. (Fault.) 2. Hardware. 3. Software through INT, numbered 0-255. 10h is VIDEO


main:
	; Set up data segments.
	mov ax, 0; No writing to ds/es directly
	mov ds, ax
	mov es, ax

	; Setup stack
	mov ss, ax
	mov sp, 0x7c00 ; Stack grows down. (FIFO w/ push/pop) Also saves return address of functions. (SP is current pos of stack)
	
	mov si, msg_hello
	call puts	; calls func to print.
	
	hlt	; Halts the code

.halt:		; Makes the halting infinite.
	jmp .halt


msg_hello: db  'Hello, World!', ENDL, 0
	

times 510-($-$$) db 0	; I forgot lol. I think its supposed to like find the end of the current sector.
dw 0AA55h		; Changes the required bytes to the required values to make this count as an OS for BIOS.
