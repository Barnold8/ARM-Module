		B main

width	DEFW 12
test 	DEFB "TEST",0

		ALIGN
main	
; You will need to insert any setup code to 
; execute before the loop here
		MOV R0, #0
		MOV R1, #0	
		MOV R2, #0	; Clean registers to avoid software bugs
		MOV R3, #0
		MOV R4, #0
		MOV R5, #0
		B readChar
loop	
;		Print character
	
		
		LDR R3, width 


readChar	

		SWI 1		

		CMP R0, #10
		BLEQ ReturnKey 
		ADD R1, R1, #1

		CMP R1, R3
		BLGE newline
		BL print

		CMP R0, #'#'
		BNE loop

		SWI 2

newline

		MOV R4, LR ; Allows to branch back to main loop without missing pointer to PC
		
		CMP R0, #32 ; If last char was a space
		BLEQ Space

		BX  R4
	
ReturnKey

		MOV R1, #0
		MOV R0, #10

		SWI 0

		B loop

Space
		
		CMP R1, R3 ; if last char of width is space, print space
		MOV R0, #32
		SWI 0
		MOV R0, #10
		SWI 0
		MOV R1, #0
		MOV R2, #1

		BX LR


print
		MOV R5, LR
		CMP R2, #1
		BEQ skip

		SWI 0
		BX R5

skip 
		MOV r2, #0
		BX R5

