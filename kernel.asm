[BITS 16]
org 0000h

mov ax, cs
mov ds, ax

section .text
    global _start

_start:
	;set text video mode
	mov AH, 00h
	mov AL, 02h
	int 10h

	; to clear the keyboard buffer
	; there is an Enter which comes from welcome
	call readkey

	call printcmdsymb
    call mainloop
ret


mainloop:
	call readkey
	call checkkey
	jmp mainloop
ret


checkkey:
    ;check if Enter has been pressed
	cmp AH, 1cH
    je checkkey_enter

	;check if bksp has been pressed
	cmp AH, 0eH
	je checkkey_bksp

	;check if up key has been pressed
	cmp AH, 48H
	je checkkey_fin

    ;check if right key has been pressed
    cmp AH, 4dH
    je checkkey_fin

    ;check if down key has been pressed
    cmp AH, 50H
    je checkkey_scrollup

    ;check if left key has been pressed
    cmp AH, 4bH
    je checkkey_fin

	;check if 256'th char has been reached
	mov DL, [cmdlen]
	cmp DL, 0xFF
	je checkkey_fin

	call printchar
	call savechar
	jmp checkkey_fin

	checkkey_bksp:
		call bksp
		jmp checkkey_fin

	checkkey_enter:
    	call enter
		jmp checkkey_fin

	checkkey_scrollup:
		call ScrollUp
		jmp checkkey_fin

	checkkey_fin:
ret


enter:
	mov byte [wasClear], 0
	call newline
	call CheckCMD
	cmp byte [wasClear], 1
	je enter_skip_new_line
	call newline
	enter_skip_new_line:
	call printcmdsymb
ret


PrintUnknownCMD:
	mov AH, 0eh
	mov BL, 0

	mov AL, "c"
	int 10h
	mov AL, "o"
	int 10h
	mov AL, "m"
	int 10h
	mov AL, "m"
	int 10h
	mov AL, "a"
	int 10h
	mov AL, "n"
	int 10h
	mov AL, "d"
	int 10h
	mov AL, " "
	int 10h

	mov CL, 0
	mov BX, cmd
	PrintUnknowkCMD_loop:
		mov AL, [BX]
		int 10H
		inc BX
		inc CL
		cmp CL, byte [cmdlen]
		jne PrintUnknowkCMD_loop


	mov AL, " "
	int 10h
	mov AL, "u"
	int 10h
	mov AL, "n"
	int 10h
	mov AL, "k"
	int 10h
	mov AL, "n"
	int 10h
	mov AL, "o"
	int 10h
	mov AL, "w"
	int 10h
	mov AL, "n"
	int 10h
ret


CheckCMD:
	cmp byte [cmdlen], 0
	je CheckCMD_fin
	mov byte [known], 0

	call CheckAbout
	cmp byte [known], 1
	je CheckCMD_fin

	call CheckAscii
	cmp byte [known], 1
	je CheckCMD_fin

	call CheckHelp
	cmp byte [known], 1
	je CheckCMD_fin

	call CheckClear
	cmp byte [known], 1
	je CheckCMD_fin

	call CheckReboot
	cmp byte [known], 1
	je CheckCMD_fin

	call CheckBeep
	cmp byte [known], 1
	je CheckCMD_fin

	call CheckWriteFLP
	cmp byte [known], 1
	je CheckCMD_fin

	call CheckReadFLP
	cmp byte [known], 1
	je CheckCMD_fin

	call CheckChrono
	cmp byte [known], 1
	je CheckCMD_fin

	call CheckFib
	cmp byte [known], 1
	je CheckCMD_fin

	call CheckDraw
	cmp byte [known], 1
	je CheckCMD_fin

	;if not recognized print "unknown command"
	mov AH, 1
	cmp AH, [known]
	je CheckCMD_fin
	call PrintUnknownCMD
	
	CheckCMD_fin:
	mov byte [cmdlen], 00H     ;reset cmdlen to 0
ret


CheckAbout:
	cmp byte [cmdlen], 5
	jne CheckAbout_fin

	mov BX, cmd
	cmp byte [BX], "a"
	jne CheckAbout_fin
	inc BX
	cmp byte [BX], "b"
	jne CheckAbout_fin
	inc BX
	cmp byte [BX], "o"
	jne CheckAbout_fin
	inc BX
	cmp byte [BX], "u"
	jne CheckAbout_fin
	inc BX
	cmp byte [BX], "t"
	jne CheckAbout_fin

	call PerformAbout
	CheckAbout_fin:
ret


CheckAscii:
	cmp byte [cmdlen], 5
	jne CheckAscii_fin

	mov BX, cmd
	cmp byte [BX], "a"
	jne CheckAscii_fin
	inc BX
	cmp byte [BX], "s"
	jne CheckAscii_fin
	inc BX
	cmp byte [BX], "c"
	jne CheckAscii_fin
	inc BX
	cmp byte [BX], "i"
	jne CheckAscii_fin
	inc BX
	cmp byte [BX], "i"
	jne CheckAscii_fin

	call PerformAscii
	CheckAscii_fin:	
ret


CheckHelp:
	cmp byte [cmdlen], 4
	jne CheckHelp_fin

	mov BX, cmd
	cmp byte [BX], "h"
	jne CheckHelp_fin
	inc BX
	cmp byte [BX], "e"
	jne CheckHelp_fin
	inc BX
	cmp byte [BX], "l"
	jne CheckHelp_fin
	inc BX
	cmp byte [BX], "p"
	jne CheckHelp_fin

	call PerformHelp
	CheckHelp_fin:
ret


CheckClear:
	cmp byte [cmdlen], 5
	jne CheckClear_fin

	mov BX, cmd
	cmp byte [BX], "c"
	jne CheckClear_fin
	inc BX
	cmp byte [BX], "l"
	jne CheckClear_fin
	inc BX
	cmp byte [BX], "e"
	jne CheckClear_fin
	inc BX
	cmp byte [BX], "a"
	jne CheckClear_fin
	inc BX
	cmp byte [BX], "r"
	jne CheckClear_fin

	call PerformClear
	CheckClear_fin:
ret


CheckReboot:
	cmp byte [cmdlen], 6
	jne CheckReboot_fin

	mov BX, cmd
	cmp byte [BX], "r"
	jne CheckReboot_fin
	inc BX
	cmp byte [BX], "e"
	jne CheckReboot_fin
	inc BX
	cmp byte [BX], "b"
	jne CheckReboot_fin
	inc BX
	cmp byte [BX], "o"
	jne CheckReboot_fin
	inc BX
	cmp byte [BX], "o"
	jne CheckReboot_fin
	inc BX
	cmp byte [BX], "t"
	jne CheckReboot_fin

	call PerformReboot
	CheckReboot_fin:
ret


CheckBeep:
	cmp byte [cmdlen], 4
	jne CheckBeep_fin

	mov BX, cmd
	cmp byte [BX], "b"
	jne CheckBeep_fin
	inc BX
	cmp byte [BX], "e"
	jne CheckBeep_fin
	inc BX
	cmp byte [BX], "e"
	jne CheckBeep_fin
	inc BX
	cmp byte [BX], "p"
	jne CheckBeep_fin

	call PerformBeep
	CheckBeep_fin:
ret


CheckWriteFLP:
	mov BX, cmd

	cmp byte [BX], "w"
	jne CheckWriteFLP_fin
	inc BX
	cmp byte [BX], "r"
	jne CheckWriteFLP_fin
	inc BX
	cmp byte [BX], "i"
	jne CheckWriteFLP_fin
	inc BX
	cmp byte [BX], "t"
	jne CheckWriteFLP_fin
	inc BX
	cmp byte [BX], "e"
	jne CheckWriteFLP_fin
	inc BX
	cmp byte [BX], "f"
	jne CheckWriteFLP_fin
	inc BX
	cmp byte [BX], "l"
	jne CheckWriteFLP_fin
	inc BX
	cmp byte [BX], "p"
	jne CheckWriteFLP_fin

	call PerformWriteFLP
	CheckWriteFLP_fin:
ret


CheckReadFLP:
	mov BX, cmd

	cmp byte [BX], "r"
	jne CheckReadFLP_fin
	inc BX
	cmp byte [BX], "e"
	jne CheckReadFLP_fin
	inc BX
	cmp byte [BX], "a"
	jne CheckReadFLP_fin
	inc BX
	cmp byte [BX], "d"
	jne CheckReadFLP_fin
	inc BX
	cmp byte [BX], "f"
	jne CheckReadFLP_fin
	inc BX
	cmp byte [BX], "l"
	jne CheckReadFLP_fin
	inc BX
	cmp byte [BX], "p"
	jne CheckReadFLP_fin

	call PerformReadFLP
	CheckReadFLP_fin:
ret


CheckChrono:
	mov BX, cmd

	cmp byte [BX], "c"
	jne CheckChrono_fin
	inc BX
	cmp byte [BX], "h"
	jne CheckChrono_fin
	inc BX
	cmp byte [BX], "r"
	jne CheckChrono_fin
	inc BX
	cmp byte [BX], "o"
	jne CheckChrono_fin
	inc BX
	cmp byte [BX], "n"
	jne CheckChrono_fin
	inc BX
	cmp byte [BX], "o"
	jne CheckChrono_fin

	call PerformChrono
	CheckChrono_fin:
ret


CheckFib:
	mov BX, cmd

	cmp byte [BX], "f"
	jne CheckFib_fin
	inc BX
	cmp byte [BX], "i"
	jne CheckFib_fin
	inc BX
	cmp byte [BX], "b"
	jne CheckFib_fin
	inc BX
	cmp byte [BX], " "
	jne CheckFib_fin

	call PerformFib
	CheckFib_fin:
ret


CheckDraw:
	mov BX, cmd

	cmp byte [BX], "d"
	jne CheckDraw_fin
	inc BX
	cmp byte [BX], "r"
	jne CheckDraw_fin
	inc BX
	cmp byte [BX], "a"
	jne CheckDraw_fin
	inc BX
	cmp byte [BX], "w"
	jne CheckDraw_fin

	call PerformDraw
	CheckDraw_fin:
ret


PerformWriteFLP:
	call ParseHeadTrackSectorDriveSize

	cmp byte [badHead], 1
	je PerformWriteFLP_fin
	cmp byte [badTrack], 1
	je PerformWriteFLP_fin
	cmp byte [badSector], 1
	je PerformWriteFLP_fin
	cmp byte [badDrive], 1
	je PerformWriteFLP_fin
	cmp byte [badSize], 1
	je PerformWriteFLP_fin

	call GetText
	call ConvertSizeToSectors

	; append # if the inserted string is shorter than specified size
	mov AX, word [textDataLen]
	sub AX, word [size]
	jns size_not_greather
		mov AX, word [size]
		mov SI, textData
		add SI, word [textDataLen]
		loop_append_dellar:
			mov byte [SI], "#"
			inc word [textDataLen]	
			inc SI
			cmp word [textDataLen], AX 
			jne loop_append_dellar
	size_not_greather:

	; write on floppy disk - takes data from ES:BX
	mov AH, 03H
	mov AL, byte [sectorCount]
	mov CH, byte [track]
	mov CL, byte [sector]
	mov DL, byte [drive]
	mov DH, byte [head]
	mov BX, textData
	int 13h

	PerformWriteFLP_fin:
	mov byte [known], 1
ret


PerformReadFLP:
	call ParseHeadTrackSectorDriveSize

	cmp byte [badHead], 1
	je PerformReadFLP_fin
	cmp byte [badTrack], 1
	je PerformReadFLP_fin
	cmp byte [badSector], 1
	je PerformReadFLP_fin
	cmp byte [badDrive], 1
	je PerformReadFLP_fin
	cmp byte [badSize], 1
	je PerformReadFLP_fin

	call ConvertSizeToSectors

	; read from floppy disk - result in ES:BX
	mov AH, 02H
	mov AL, byte [sectorCount]
	mov CH, byte [track]
	mov CL, byte [sector]
	mov DL, byte [drive]
	mov DH, byte [head]

	mov BX, textData
    ; mov ES, BX
    ; xor BX, BX

	int 13h

	; print text data on th sreen
	mov CX, 0
	mov AH, 0eh
	mov SI, BX
	mov BX, 0
	print_data_loop:
		mov AL, [SI]
		mov BL, 0
		int 10h

		inc SI
		inc CX
		cmp CX, word [size]
		jne print_data_loop


	PerformReadFLP_fin:
	mov byte [known], 1
ret


PerformAbout:
	mov byte [known], 1
	
	; read from floppy disk - result in ES:BX
	mov AH, 02H
	mov AL, 1
	mov CH, 51 ; track
	mov CL, 4  ; sector
	mov DL, 0
	mov DH, 0

	mov BX, textData
    ; mov ES, BX
    ; xor BX, BX

	int 13h

	; print text data on th sreen
	mov CX, 0
	mov AH, 0eh
	mov SI, BX
	mov BX, 0
	about_loop:
		mov AL, [SI]
		mov BL, 0
		int 10h

		inc SI
		inc CX
		cmp CX, 100
		jne about_loop
ret


PerformAscii:
	mov byte [known], 1

	mov byte [s], 48
	mov byte [z], 48
	mov byte [u], 48
	mov CL, 0

	mov AH, 0eh
	mov BL, 0

	jmp skip_updateSZU
	updateSZU:
		inc byte [u]
		cmp byte [u], 58
		je incZ
		jmp updateSZU_fin
		incZ:
			mov byte [u], 48
			inc byte [z]
			cmp byte [z], 58
			je incS
			jmp updateSZU_fin
			incS:
				mov byte [z], 48
				inc byte [s]

		updateSZU_fin:
	ret

	skip_updateSZU:
	loop_chars:
		mov AH, 0eh
		mov AL, byte [s]
		int 10H
		mov AL, byte [z]
		int 10H
		mov AL, byte [u]
		int 10H
		mov AL, "="
		int 10H

		; put char
		cmp CL, 10
		je spaceInstead
		mov AL, CL
		int 10H
		jmp notSpaceInstead
		spaceInstead:
			mov AL, " "
			int 10H
		notSpaceInstead:


		call updateSZU

		inc CL
		mov AH, 0
		mov AL, CL
		mov byte [chrOnLine], 13
		div byte [chrOnLine]
		cmp AH, 0
		je twoSpaces
		jmp skipTwoSpaces
		twoSpaces:
			call newline
		skipTwoSpaces:

		mov AH, 0eh
		mov AL, " "
		int 10H

		cmp CL, 255
		jne loop_chars
	
ret

PerformHelp:
	mov byte [known], 1

	call GetCursorPosition
	mov AX, 1301h
	mov BH, 00h
	mov BL, 03h
	mov CX, abTextLen
	mov BP, abText
	int 10h
ret


PerformClear:
	mov byte [known], 1
	mov byte [wasClear], 1

	; mov AH, 06H
	; mov AL, 00H
	; mov BH, 07H
	; mov CH, 24
	; mov CL, 79
	; mov DX, 0000H
	; int 10H

	;set text video mode
	mov AH, 00h
	mov AL, 02h
	int 10h
ret


PerformReboot:
	mov byte [known], 1
	int 19h
ret


PerformBeep:
	mov byte [known], 1

	mov AL, 0b6H
	out 43H, AL
	mov AL, 0d0H
	out 42H, AL

	in AL, 61H
	or AL, 03H
	out 61H, AL

	mov CX, 0007H
	mov DX, 0a120H
	mov AH, 86H
	int 15H

	in AL, 61H
	and AL, 0fcH
	out 61H, AL

	; mov AH, 0eH
	; mov AL, 07H
	; int 10h
ret


PerformChrono:
	mov byte [known], 1

	mov byte [drawStopped], 0
	mov byte [number], 0
	loop_chrono:
		call PerformClear
		call PrintNumber
		call Delay
		inc byte [number]

		mov AH, 01h 
		int 16h

		cmp AH, 1cH
		jne SkipSetStopDraw
		mov byte [drawStopped], 1
		SkipSetStopDraw:
		

		cmp byte [drawStopped], 1
		jne loop_chrono

	call PerformClear
ret


PerformFib:
	mov byte [known], 1

	mov BX, cmd
	performFib_find_space:
		inc BX
		cmp byte [BX], " "
		jne performFib_find_space
	mov byte [ten], 10

	; parse fibnmb
	mov AX, 0
	mov byte [fibnmb], 0
	inc BX
	loop_fibnmb:
		mul byte [ten]
		mov DL, byte [BX]
		sub DL, 48
		add AL, DL
		inc BX
		cmp byte [BX], ":"
		jne loop_fibnmb
	mov byte [fibnmb], AL

	cmp byte [fibnmb], 1
	jne PerformFib_skip1
	mov AL, 49
	call printchar
	jmp PerformFib_fin
	PerformFib_skip1:

	cmp byte [fibnmb], 2
	jne PerformFib_skip2
	mov AL, "1"
	call printchar
	mov AL, " "
	call printchar
	mov AL, "1"
	call printchar
	jmp PerformFib_fin
	PerformFib_skip2:

	mov AL, "1"
	call printchar
	mov AL, " "
	call printchar
	mov AL, "1"
	call printchar
	mov AL, " "
	call printchar
	mov byte [fiba], 1
	mov byte [fibb], 1
	mov CL, 2
	loop_fib:
		inc CL

		mov DH, byte [fiba]
		add DH, byte [fibb]
		mov byte [fibc], DH
		mov byte [number], DH
		call PrintNumber
		mov AL, " "
		call printchar
		mov DH, byte [fibb]
		mov byte [fiba], DH
		mov DH, byte [fibc]
		mov byte [fibb], DH

		cmp CL, byte [fibnmb]
		jne loop_fib


	PerformFib_fin:
ret


PerformDraw:
	mov byte [known], 1
	

	cli            ; Disable interrupts to circumvent bug on early 8088 CPUs
	mov ss,bx      ; Top of the stack @ 0x80000.
	mov sp,ax      ; Set SP=0 so the bottom of stack will be just below 0x90000
	sti            ; Re-enable interrupts
	cld

	jmp 5000h:0000h
ret


GetText:
	jmp skip_GetText_Checkkey
	GetText_Checkkey:
		;check if Enter has been pressed
		cmp AH, 1cH
		je GetText_Checkkey_Enter

		;check if bksp has been pressed
		cmp AH, 0eH
		je GetText_Checkkey_GetText_bksp

		;check if up key has been pressed
		cmp AH, 48H
		je GetText_Checkkey_fin

		;check if right key has been pressed
		cmp AH, 4dH
		je GetText_Checkkey_fin

		;check if down key has been pressed
		cmp AH, 50H
		je GetText_Checkkey_fin

		;check if left key has been pressed
		cmp AH, 4bH
		je GetText_Checkkey_fin

		call printchar
		call AppendToText
		jmp GetText_Checkkey_fin

		GetText_Checkkey_GetText_bksp:
			call GetText_bksp
			jmp GetText_Checkkey_fin

		GetText_Checkkey_Enter:
			call GetText_Enter
			jmp GetText_Checkkey_fin

		GetText_Checkkey_fin:
	ret
	skip_GetText_Checkkey:


	jmp skip_AppendToText
	AppendToText:
		;put char in memory using textDataLen position
		mov BX, textData
		mov DX, word [textDataLen]
		mov DH, 00H
		add BX, DX
		mov [BX], AL

		;increment textDataLen and CL
		inc word [textDataLen]
	ret
	skip_AppendToText:


	jmp skip_GetText_Enter
	GetText_Enter:
		mov byte [gotText], 1
	ret
	skip_GetText_Enter:


	jmp skip_GetText_bksp
	GetText_bksp:
		;decrement textDataLen
		cmp word [textDataLen], 0
		je GetText_bksp_fin
		dec word [textDataLen]

		call cursorback			;moves the cursot back
		call putspace			;put a space where the cursor is located

		GetText_bksp_fin:
	ret
	skip_GetText_bksp:


	mov byte [gotText], 0
	mov word [textDataLen], 0
	get_text_loop:
		call readkey
		call GetText_Checkkey
		cmp byte [gotText], 0
		je get_text_loop
ret


ParseHeadTrackSectorDriveSize:
	mov BX, cmd
	find_space:
		inc BX
		cmp byte [BX], " "
		jne find_space
	mov byte [ten], 10

	mov byte [badHead], 0
	mov byte [badTrack], 0
	mov byte [badSector], 0
	mov byte [badDrive], 0
	mov byte [badSize], 0

	; parse head number
	mov AX, 0
	mov byte [head], 0
	inc BX
	loop_head:
		mul byte [ten]
		mov DL, byte [BX]
		sub DL, 48
		add AL, DL
		inc BX
		cmp byte [BX], ","
		jne loop_head
	mov byte [head], AL

	cmp byte [head], 1
	jg badHeadJmp

	; parse track number
	mov AX, 0
	mov byte [track], 0
	inc BX
	loop_track:
		mul byte [ten]
		mov DL, byte [BX]
		sub DL, 48
		add AL, DL
		inc BX
		cmp byte [BX], ","
		jne loop_track
	mov byte [track], AL

	cmp byte [track], 79
	jg badTrackJmp

	; parse sector number
	mov AX, 0
	mov byte [sector], 0
	inc BX
	loop_sector:
		mul byte [ten]
		mov DL, byte [BX]
		sub DL, 48
		add AL, DL
		inc BX
		cmp byte [BX], ","
		jne loop_sector
	mov byte [sector], AL

	cmp byte [sector], 18
	jg badSectorJmp

	; parse drive number
	mov AX, 0
	mov byte [drive], 0
	inc BX
	loop_drive:
		mul byte [ten]
		mov DL, byte [BX]
		sub DL, 48
		add AL, DL
		inc BX
		cmp byte [BX], "|"
		jne loop_drive
	mov byte [drive], AL

	cmp byte [drive], 1
	jg badDriveJmp

	; parse size number
	mov AX, 0
	mov word [size], 0
	inc BX
	loop_size:
		mul byte [ten]
		mov DH, 0
		mov DL, byte [BX]
		sub DL, 48
		add AX, DX
		inc BX
		cmp byte [BX], ":"
		jne loop_size
	mov word [size], AX

	cmp word [size], 6000
	jg badSizeJmp


	jmp goodParameters
	badHeadJmp:
	mov byte [badHead], 1
		mov AH, 03H
		mov BH, 00h
		int 10h
		mov AX, 1301h
		mov BH, 00h
		mov BL, 4
		mov DL, 0
		mov CX, badHeadTextLen
		mov BP, badHeadText
		int 10h
	jmp goodParameters

	badTrackJmp:
		mov byte [badTrack], 1
		mov AH, 03H
		mov BH, 00h
		int 10h
		mov AX, 1301h
		mov BH, 00h
		mov BL, 4
		mov DL, 0
		mov CX, badTrackTextLen
		mov BP, badTrackText
		int 10h
	jmp goodParameters

	badSectorJmp:
	mov byte [badSector], 1
		mov AH, 03H
		mov BH, 00h
		int 10h
		mov AX, 1301h
		mov BH, 00h
		mov BL, 4
		mov DL, 0
		mov CX, badSectorTextLen
		mov BP, badSectorText
		int 10h
	jmp goodParameters

	badDriveJmp:
	mov byte [badDrive], 1
		mov AH, 03H
		mov BH, 00h
		int 10h
		mov AX, 1301h
		mov BH, 00h
		mov BL, 4
		mov DL, 0
		mov CX, badDriveTextLen
		mov BP, badDriveText
		int 10h
	jmp goodParameters

	badSizeJmp:
	mov byte [badSize], 1
		mov AH, 03H
		mov BH, 00h
		int 10h
		mov AX, 1301h
		mov BH, 00h
		mov BL, 4
		mov DL, 0
		mov CX, badSizeTextLen
		mov BP, badSizeText
		int 10h
	
	goodParameters:
ret


ConvertSizeToSectors:
	mov DX, 0
	mov AX, word [size]
	mov CX, 512
	div CX
	mov word [sectorCount], AX
	cmp DX, 0
	je ConvertSizeToSectors_fin
		inc word [sectorCount]
	ConvertSizeToSectors_fin:
ret


GetCursorPosition:
    mov AH, 03H
    mov BH, 00h
    int 10h
ret


printchar:
    ;TTY
    mov AH, 0eH
    ;in AL there alredy is the types char
    int 10H
ret


savechar:
	;put char in memory using cmdlen position
	mov BX, cmd
	mov DX, [cmdlen]
	mov DH, 00H
	add BX, DX
	mov [BX], AL

    ;increment cmdlen and CL
    mov CL, [cmdlen]
    inc CL
    mov [cmdlen], CL
ret


bksp:
	;decrement cmdlen
	cmp byte [cmdlen], 00H
	je bksp_fin
	mov CL, [cmdlen]
	dec CL
	mov [cmdlen], CL

	call cursorback			;moves the cursot back
	call putspace			;put a space where the cursor is located

	bksp_fin:
ret


cursorback:
    ;get cursor position
    mov AH, 03H
    mov BH, 0
    int 10H

	dec DL
	cmp DL, -01H
	je cursorback_up
	jmp cursorback_fin

	cursorback_up:
		dec DH
		mov DL, 4FH

	cursorback_fin:
    ;set cursor position
    mov AH, 02H
    mov BH, 0
    int 10H
ret


putspace:
	mov AH, 0aH
    mov AL, ' '
    mov BH, 0
    mov CX, 1
    int 10H
ret


printcmd:
	mov AH, 0eH
	mov AL, 'C'
	int 10H
	mov AL, 'M'
	int 10H
	mov AL, 'D'
	int 10H
	mov AL, '='
	int 10H
	mov AL, '"'
	int 10H

	mov CL, 00H
	mov AH, 0eH 			;set TTY
	mov BX, cmd

	cmp byte [cmdlen], 00H
	je printcmd_fin

	printcmd_loop:
		mov AL, [BX]
		int 10H
		inc BX
		inc CL
		cmp CL, [cmdlen]
		jne printcmd_loop
	
	printcmd_fin:

	mov AL, '"'
	int 10H

	mov [cmdlen], byte 00H     ;reset cmdlen to 0
ret


printcmdsymb:
    mov AH, 0eH
    mov AL, '$'
    int 10H
    mov AL, '>'
    int 10H
ret


ScrollUp:
	mov AH, 06H
	mov AL, 1
	mov BH, 01H
	mov CH, 24
	mov CL, 79
	mov DH, 0
	mov DL, 0
	int 10h
ret

newline:
	mov AH, 0eH
    mov AL, 0aH
    int 10H
    mov AL, 0dH
    int 10H
ret


readkey:
    mov AH, 00H
    int 16H
ret


Delay:
	mov AH, 86h
	mov CX, 0010h
	mov DX, 0000h
	int 15h
ret


PrintNumber:
	mov byte [ten], 10

	mov byte AL, byte [number]
	mov byte [nmbAux], AL

	mov AH, 0
	mov AL, byte [nmbAux]
	div byte [ten]
	mov byte [digitsInMem+5], AH
	mov byte [nmbAux], AL

	mov AH, 0
	mov AL, byte [nmbAux]
	div byte [ten]
	mov byte [digitsInMem+4], AH
	mov byte [nmbAux], AL

	mov AH, 0
	mov AL, byte [nmbAux]
	div byte [ten]
	mov byte [digitsInMem+3], AH
	mov byte [nmbAux], AL

	mov AH, 0
	mov AL, byte [nmbAux]
	div byte [ten]
	mov byte [digitsInMem+2], AH
	mov byte [nmbAux], AL
	

	mov AL, byte [digitsInMem+2]
	add AL, 48
	call printchar

	mov AL, byte [digitsInMem+3]
	add AL, 48
	call printchar

	mov AL, byte [digitsInMem+4]
	add AL, 48
	call printchar

	mov AL, byte [digitsInMem+5]
	add AL, 48
	call printchar

ret


section .data
	aboutMsg DB 'OS v0.00000001 created by Ion Dodon FAF-172'
	aboutMsgLen equ $-aboutMsg

	abText DB "about - about this OS", 0x0d,0x0a, "help - lists all the available commands", 0x0d,0x0a, "clear - clears the screen", 0x0d,0x0a, "reboot - reboots the system",  0x0d,0x0a, "ascii - shows the ascii table",  0x0d,0x0a, "beep - makes a beep sound",  0x0d,0x0a, 0x0d,0x0a, "writeflp head,track,sector,drive|size: - writes text data on floppy disk", 0x0d,0x0a, "readflp head,track,sector,drive|size: - reads text data from floppy disk", 0x0d,0x0a, "head={1,2}, track[0-79], sector=[1-18], drive={0,1}, size<=6000", 0x0d,0x0a, 0x0d,0x0a, "chrono - counts seconds",  0x0d,0x0a, "fib n: - showh first n fibonacci numbers",  0x0d,0x0a, "draw - animated UTM (press enter to stop it)"
	abTextLen equ $-abText

	known DB 0
	wasClear DB 0
	gotText DB 0

	s DB 0
	z DB 0
	u DB 0

	head DB 0
	track DB 0
	sector DB 0
	drive DB 0
	size DW 0
	sectorCount DW 0

	badHead DB 0
	badTrack DB 0
	badSector DB 0
	badDrive DB 0
	badSize DB 0

	badHeadText DB "head should be 0 or 1"
	badHeadTextLen equ $-badHeadText
	badTrackText DB "track should be in the range [0-79]"
	badTrackTextLen equ $-badTrackText
	badSectorText DB "sector should be in the range [1-18]"
	badSectorTextLen equ $-badSectorText
	badDriveText DB "drive should be 0 or 1"
	badDriveTextLen equ $-badDriveText
	badSizeText DB "size should be than 6000, or equal"
	badSizeTextLen equ $-badSizeText

	ten DB 10

	number DB 0
	nmbAux DB 0
	digitsInMem TIMES 10 DB 0

	drawStopped DB 0

	fibnmb DB 0
	fiba DB 0
	fibb DB 0
	fibc DB 0

	chrOnLine DB 13

	cmdlen DB 0
	cmd TIMES 256 DB 0

	textDataLen DW 0
	textData DB 0