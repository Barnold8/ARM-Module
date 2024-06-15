		B main

verses 	DEFW	4gut 
; r1 = men
; r2 = sub loop men

; numbers


; Insert any strings here
mow DEFB " men went to mow",0
mowman DEFB " man went to mow",0
Wmow DEFB "Went to mow a meadow",0
men DEFB " men ",0
menC DEFB " men, ",0
Spot DEFB " man and his dog, Spot",0


		ALIGN



comString ; This is num men, num men, num man and his dog

	MOV R0, R1 ; Prints amount of men
	MOV R2, R1 ; reset R2 to latest global men
	SWI 4

	ADR R0, mow ; mow string
	SWI 3

	MOV R0, #10 ; newline
	SWI 0

	; get amount of men into register 

	MOV R0, R2 ;put comma men into R0 for decrement loop
	CMP R0, #0 ;compare them, if theyre 
	BGT printMen
	BLT preEnd

printMen ; this does the actual processing of the comma string

	SWI 4 ; print comma men

	ADR R0, menC ; "print men," 
	SWI 3

	SUB R2, R2, #1 ; take one man off comma men (r2)
	MOV R0, R2  ; store new r2 in r0

	CMP R0, #1 ;compare r0 to number  (man and his dog)
	BGT printMen ; if its greater than number, start this subroutine again
	BLE dog ;'else', start dog subroutine


dog 

	MOV R2,R0 ;print last man
	SWI 4

	ADR R0, Spot ; and his dog spot,
	SWI 3

	MOV R0, #10 ; newline
	SWI 0

	ADR R0, Wmow ; went to mow a meadow
	SWI 3

	MOV R0, #10 ; newline
	SWI 0

	MOV R0, #10 ;  newline
	SWI 0

	SUB R1, R1, #1 ; subtract global men

	CMP R1, #1
	BGT comString
	B preEnd

end

	MOV R0, R1
	SWI 4

	ADR R0, mowman
	SWI 3

	MOV R0, #10
	SWI 0

	ADR R3, Wmow
	MOV R0, R3 ; STUPID WORKAROUNDGIT
	SWI 3

	MOV R0, #10
	SWI 0

	MOV R0, R1
	SWI 4

	ADR R0, Spot
	SWI 3

	MOV R0, #10
	SWI 0

	MOV R0, R3
	SWI 3

	SWI 2


preEnd

	CMP R1, #1 ;  compare global men to 1
	BGT comString ; if men are greater than 1, start 

	B end
	



main
	; Register setup
	LDR R1, verses
	LDR R2, verses
	
	B comString

	SWI 2