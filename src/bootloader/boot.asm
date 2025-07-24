org 0x7C00	; Moves the file origin to the place where the BIOS starts to look for an OS.
bits 16		; Sets compiler mode to 16 bits, as x86 starts like that.

%define ENDL 0x0D, 0x0A

;Fat12 header
jmp short start
nop

bdb_oem:					db 'MSWIN4.1'	;8 bytes
bdb_bytes_per_sector:		dw 512
bdb_sectors_per_cluster: 	db 1
bdb_reserved_sectors:		dw 1
bdb_fat_count:				db 2
bdb_dir_enteries_count:		dw 0E0h
bdb_total_sectors:			dw 2880			; 2880 * 512 = 1.44mb
bdb_media_descriptor_type:	db 0F0h			; F0 = 3.5 inch floppy diskette.
bdb_sectors_per_fat:		dw 9
bdb_sectors_per_track:		dw 18
bdb_heads:					dw 2
bdb_hidden_sectors:			dd 0
bdb_large_sector_count:		dd 0

;extended boot record
ebr_drive_number:			db 0 			; 0x00 floppy, 0x80 hdd
							db 0 			; reserved
ebr_signature:				db 28h
ebr_volume_id:				db 12h, 34h, 56h, 78h	; optional serial # (copied directly from vid)
ebr_volume_label:			db 'KROS-H     '		; 11 bytes, padded w/spaces
ebr_system_id:				db 'FAT12   '			; 8 bytes

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
