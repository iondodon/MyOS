[BITS 16]
org 7C00h

section .text
	global _start

_start:
	call Message
	call MainLoop
ret

MainLoop:
	call ReadAndCheckKey
	call MainLoop
ret

Message:
	mov AX, 1301h
	mov BH, 00h
	mov BL, 03h 	;blue
	mov DH, 00h
	mov DL, 00h
	mov CX, loadingLen
	mov BP, loading
	int 10h
	call NewLine

	call GetCursorPosition
	mov AX, 1301h
	mov BH, 00h
	mov BL, 03h
	mov CX, instrLen
	mov BP, instr
	int 10h
	call NewLine
ret

GetCursorPosition:
	mov AH, 03H
	mov BH, 00h
	int 10h
ret

NewLine:
    mov AH, 0eH
    mov AL, 0aH
    int 10H
    mov AL, 0dH
    int 10H
ret

ReadAndCheckKey:
	mov AH, 00h
	int 16h
	cmp AH, 1ch
	je LoadWellcome
ret

LoadWellcome:
	xor AX, AX      ; We want a segment of 0 for DS for this question
	mov DS, AX      ;     Set AX to appropriate segment value for your situation
	mov BX, 5000h   ; Stack segment can be any usable memory

	cli            ; Disable interrupts to circumvent bug on early 8088 CPUs
	mov ss,bx      ; Top of the stack @ 0x80000.
	mov sp,ax      ; Set SP=0 so the bottom of stack will be just below 0x90000
	sti            ; Re-enable interrupts
	cld

	; desen 49, 11, 1
	; kernel 50, 1, 0
	mov AH, 02h    ; Read sectors from drive
    mov AL, 4      ; Read AL sectors
    mov CH, 49      ; Cylinder 0
    mov CL, 11    ; Sector CL
    mov DL, 0	   ; drive number
	mov DH, 1      ; Head 0
	
    mov BX, 5000h
    mov ES, BX
    xor BX, BX

    int 13h

	;start Wellcome -- this jump
	jmp 5000h:0000h
ret

section .data
	loading db 'Loading...'
	loadingLen equ $-loading

	instr db 'Press Enter to go to Wellcome page then again Enter go start the Kernel.'
	instrLen equ $-instr