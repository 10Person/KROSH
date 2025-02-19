org 0x7C00	; Moves the file origin to the place where the BIOS starts to look for an OS.
bits 16		; Sets compiler mode to 16 bits, as x86 starts like that.

		; Start of program
main:
	hlt	; Halts the code

.halt		; Makes the halting infinite.
	jmp .halt


times 510-($-$$) db 0	; I forgot lol. I think its supposed to like find the end of the current sector.
dw 0AA55h		; Changes the required bytes to the required values to make this count as an OS for BIOS.
