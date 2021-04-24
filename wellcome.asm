[BITS 16]
org 0000h

mov ax, cs
mov ds, ax

section .text
	global _start

_start:
	;set svga video mode 800x600  16 colors
	mov AX, 4F02h
	mov BX, 0102h
	int 10h

	mov word [speed], 1
	mov word [deltaX], 0 ;	deltaX and deltaY
	mov word [deltaY], 0 ;	used to change the position of UTM
	
	call MainLoop
ret

Delay:
	mov AH, 86h
	mov CX, 0000h
	mov DX, 9480h
	int 15h
ret

ClearScreen:
	mov word [color], 0
	mov byte [black], 1
	call DrawUTM
ret

DrawUTM:
	mov word [x0], 10
	mov word [y0], 140
	mov word [x1], 300
	mov word [y1], 120
	call plotLine

	mov word [x0], 250
	mov word [y0], 50
	mov word [x1], 220
	mov word [y1], 10
	call plotLine

	mov word [x0], 250
	mov word [y0], 50
	mov word [x1], 280
	mov word [y1], 10
	call plotLine

	mov word [x0], 150
	mov word [y0], 27
	mov word [x1], 180
	mov word [y1], 30
	call plotLine

	mov word [x0], 100
	mov word [y0], 30
	mov word [x1], 130
	mov word [y1], 27
	call plotLine
	
	mov word [x0], 250
	mov word [y0], 80
	mov word [x1], 220
	mov word [y1], 40
	call plotLine

	mov word [x0], 250
	mov word [y0], 80
	mov word [x1], 280
	mov word [y1], 40
	call plotLine

	mov word [x0], 10
	mov word [y0], 100
	mov word [x1], 20
	mov word [y1], 110
	call plotLine

	mov word [x0], 30
	mov word [y0], 10
	mov word [x1], 10
	mov word [y1], 15
	call plotLine

	mov word [x0], 70
	mov word [y0], 110
	mov word [x1], 80
	mov word [y1], 100
	call plotLine

	mov word [x0], 60
	mov word [y0], 10
	mov word [x1], 80
	mov word [y1], 15
	call plotLine

	mov word [x0], 280
	mov word [y0], 110
	mov word [x1], 280
	mov word [y1], 40
	call plotLine

	mov word [x0], 30
	mov word [y0], 10
	mov word [x1], 30
	mov word [y1], 100
	call plotLine

	mov word [x0], 10
	mov word [y0], 15
	mov word [x1], 10
	mov word [y1], 100
	call plotLine

	mov word [x0], 20
	mov word [y0], 110
	mov word [x1], 70
	mov word [y1], 110
	call plotLine

	mov word [x0], 80
	mov word [y0], 100
	mov word [x1], 80
	mov word [y1], 15
	call plotLine

	mov word [x0], 60
	mov word [y0], 10
	mov word [x1], 60
	mov word [y1], 100
	call plotLine

	mov word [x0], 30
	mov word [y0], 100
	mov word [x1], 60
	mov word [y1], 100
	call plotLine

	mov word [x0], 100
	mov word [y0], 10
	mov word [x1], 100
	mov word [y1], 30
	call plotLine

	mov word [x0], 130
	mov word [y0], 110
	mov word [x1], 130
	mov word [y1], 27
	call plotLine

	mov word [x0], 130
	mov word [y0], 110
	mov word [x1], 150
	mov word [y1], 110
	call plotLine

	mov word [x0], 150
	mov word [y0], 27
	mov word [x1], 150
	mov word [y1], 110
	call plotLine

	mov word [x0], 180
	mov word [y0], 10
	mov word [x1], 180
	mov word [y1], 30
	call plotLine

	mov word [x0], 180
	mov word [y0], 10
	mov word [x1], 100
	mov word [y1], 10
	call plotLine

	mov word [x0], 200
	mov word [y0], 10
	mov word [x1], 200
	mov word [y1], 110
	call plotLine
	
	mov word [x0], 220
	mov word [y0], 110
	mov word [x1], 200
	mov word [y1], 110
	call plotLine

	mov word [x0], 220
	mov word [y0], 110
	mov word [x1], 220
	mov word [y1], 40
	call plotLine

	mov word [x0], 280
	mov word [y0], 110
	mov word [x1], 300
	mov word [y1], 110
	call plotLine

	mov word [x0], 300
	mov word [y0], 10
	mov word [x1], 300
	mov word [y1], 110
	call plotLine

	mov word [x0], 300
	mov word [y0], 10
	mov word [x1], 280
	mov word [y1], 10
	call plotLine

	mov word [x0], 200
	mov word [y0], 10
	mov word [x1], 220
	mov word [y1], 10
	call plotLine
ret

MainLoop:
	call ReadAndCheckKey

	; by increasing deltaX and deltaY
	; UTM moves down-right
	inc word [deltaX]
	inc word [deltaX]
	inc word [deltaY]
	inc word [deltaY]

	mov byte [black], 0
	call DrawUTM

	call Delay

	call ClearScreen
	
	jmp MainLoop
ret

ReadAndCheckKey:	; used to jump to Kernel when animation is dissabled
	mov AH, 01h 
	int 16h

	cmp AH, 1ch		; check is Enter has been pressed
	je LoadKernel	; jump to LoadKernel when Enter is pressed

	jmp RACK_fin
	LoadKernel:
		xor AX, AX      ; We want a segment of 0 for DS for this question
		mov DS, AX      ;     Set AX to appropriate segment value for your situation
		mov BX, 8000h   ; Stack segment can be any usable memory

		cli            ; Disable interrupts to circumvent bug on early 8088 CPUs
		mov ss,bx      ; Top of the stack @ 0x80000.
		mov sp,ax      ; Set SP=0 so the bottom of stack will be just below 0x90000
		sti            ; Re-enable interrupts
		cld

		mov AH, 02h    ; Read sectors from drive
		mov AL, 7      ; Read AL sectors
		mov CH, 50      ; Cylinder 0
		mov CL, 1      ; Sector CL
		mov DL, 0	   ; drive number
		mov DH, 0      ; Head 0
		
		mov BX, 8000h  ; Kernel will be loaded 
		mov ES, bx
		xor BX, bx	   ; clear BX

		int 13h

		;start Kernel
		jmp 8000h:0000h
	RACK_fin:
ret

drawHorizontal:
	mov word [drawn], 1  ; remember that the iamge has been drawn

	mov AX, word [x0]
	mov BX, word [x1]
	cmp AX, BX
	jle dHskip

	; reverse (x0, y0) and (x1, y1) when x0 > x1
	mov AX, word [x0]
   	mov BX, word [y0]
    mov CX, word [x1]
    mov DX, word [y1]
    mov word [x0], CX
    mov word [y0], DX
	mov word [x1], AX
	mov word [y1], BX

	dHskip:

	mov CX, word [x0]
	mov DX, word [y0]
	dH_loop:
		call putPixel
		inc CX
		cmp CX, word [x1]
		jle dH_loop
ret

drawVertical:
	mov word [drawn], 1 ; remember image has been drawn

	mov AX, word [y0]
	mov BX, word [y1]
	cmp AX, BX
	jle dVskip

	; reverse (x0, y0) and (x1, y1) when y0 > y1
	mov AX, word [x0]
   	mov BX, word [y0]
    mov CX, word [x1]
    mov DX, word [y1]
    mov word [x0], CX
    mov word [y0], DX
	mov word [x1], AX
	mov word [y1], BX

	dVskip:

	mov CX, word [x0]
	mov DX, word [y0]
	dV_loop:
		call putPixel
		inc DX
		cmp DX, word [y1]
		jle dV_loop
ret

calcAbsY:
	; absolute value of y0 - y1
	mov AX, word [y1]
	sub AX, word [y0]
	jns calcAbsY_fin
	mov AX, word [y0]
	sub AX, word [y1]
	calcAbsY_fin:
	mov word [difY], AX
ret

calcAbsX:
	; absolute value of x0 - x1
	mov AX, word [x1]
	sub AX, word [x0]
	jns calcAbsX_fin
	mov AX, word [x0]
	sub AX, word [x1]
	calcAbsX_fin:
	mov word [difX], AX
ret

drawObliqueLow:
	; second case: abs(x) > abs(y)
	mov word [drawn], 1   ; remember that line has been ploted

	mov AX, word [x0]
	mov BX, word [x1]
	cmp AX, BX
	jle dOskip

	; reverse (x0, y0) and (x1, y1) when x0 > x1
	mov AX, word [x0]
   	mov BX, word [y0]
    mov CX, word [x1]
    mov DX, word [y1]
    mov word [x0], CX
    mov word [y0], DX
	mov word [x1], AX
	mov word [y1], BX

	dOskip:
		call calcAbsX
		call calcAbsY

		;dx = x1 - x0
		;dy = y1 - y0
		;for x from x0 to x1 {
		;	y = y0 + dy * (x - x0) / dx
		;	plot(x, y)
		;}
		mov CX, word [x0]
		dOLoop:
			mov AX, CX

			mov BX, word [x0]
			sub AX, BX

			mov BX, word [difY]
			imul BX

			mov BX, word [difX]
			mov DX, 0
			idiv BX

			mov BX, word [y0]
			cmp BX, word [y1]
			jg decAX
			add AX, BX
			jmp dO_skip_sub
			decAX:
				sub BX, AX
				mov AX, BX
			dO_skip_sub:

			mov DX, AX
			call putPixel
			
			inc CX
			mov BX, word [x1]
			cmp CX, BX
			jle dOLoop
ret

drawObliqueHigh:
	mov word [drawn], 1

	mov AX, word [y0]
	mov BX, word [y1]
	cmp AX, BX
	jle dOHskip

	; reverse (x0, y0) and (x1, y1) when y0 > y1
	mov AX, word [x0]
   	mov BX, word [y0]
    mov CX, word [x1]
    mov DX, word [y1]
    mov word [x0], CX
    mov word [y0], DX
	mov word [x1], AX
	mov word [y1], BX
	
	dOHskip:
		call calcAbsX
		call calcAbsY

		;dx = x1 - x0
		;dy = y1 - y0
		;for y from y0 to y1 {
		;	x = x0 + dx * (y - y0) / dy
		;	plot(x, y)
		;}
		mov AX, word [y0]
		mov [y], AX
		dOHLoop:
			mov AX, word [y]

			mov BX, word [y0]
			sub AX, BX

			mov BX, word [difX]
			imul BX

			mov BX, word [difY]
			idiv BX

			mov BX, word [x0]
			cmp BX, word [x1]
			jg dOHdecAX
			add AX, BX
			jmp dOH_skip_sub
			dOHdecAX:
				sub BX, AX
				mov AX, BX
			dOH_skip_sub:

			mov DX, word [y]
			mov CX, AX
			call putPixel
			
			inc word [y]
			mov BX, word [y1]
			cmp word [y], BX
			jle dOHLoop
ret

plotLine:
	mov AX, word [y0]
	mov BX, word [y1]
	cmp AX, BX			; check if it is a horizontal line
	je drawHorizontal

	mov AX, word [x0]
	mov BX, word [x1]
	cmp AX, BX			; check if it is a vertical line
	je drawVertical

	mov AX, 1
	cmp AX, word [drawn] 
	je plotLine_ploted	; if line has been drawn by one of the cases above
		
		; calculate abs(x0-x1) and abs(y0-y1)
		call calcAbsX
		call calcAbsY
		; if line is not drawn then it is oblique
		mov AX, word [difX]
		mov BX, word [difY]
		cmp AX, BX			
		jle plotLine_high	; check first case: abs(x) <= abs(y)
		call drawObliqueLow ; second case: abs(x) > abs(y)
		jmp plotLine_ploted
		plotLine_high:
			call drawObliqueHigh

	plotLine_ploted:
	mov word [drawn], 0		; uncheck ploted, to be used for the next line
ret

putPixel:
	cmp byte [black], 1
	je skipIncColor

	inc word [itterator]
	mov AX, word [itterator]
	mov BH, 5
	div BH
	cmp AH, 00h
	je incColor
	jmp skipIncColor

	incColor:
	inc word [color]
	skipIncColor:

	cmp word [itterator], 200
	je resetItterator
	jmp skipResetItterator
	resetItterator:
	mov word [itterator], 0
	skipResetItterator:

	mov AH, 0Ch
	mov AL, byte [color]
	mov BH, 0
	
	; CX and DX already set
	; deltaX and deltaY used to change shift the image
	add CX, word [deltaX]
	add DX, word [deltaY]
	
	int 10h

	sub CX, word [deltaX]
	sub DX, word [deltaY]
ret

section .data
	x0 DW 0
	y0 DW 0
	x1 DW 0
	y1 DW 0

	difX DW 0
	difY DW 0

	drawn DW 0

	x DW 0
	y DW 0

	color DB 0
	speed DW 0

	deltaX DW 0
	deltaY DW 0

	itterator DW 0

	black DB 0

	videom db 'SVGA 800x600'
	videomLen equ $-videom