; print Buzz every 4th number
; if buzz is called 4 times, print fourth buzzS

		B main

n		DEFW 	25
buzz	DEFB "Buzz",0
fourth	DEFB "Fourth " ,0

		ALIGN

main	
		LDR R2, n 	; load n into R2
		MOV R1, #1	; start loop counter with 1?
		MOV R3, #0

loop	

		AND R0, R1, #3	
		CMP R0, #0
		BLNE printNum
		BLEQ Buzz

		ADD R1, R1, #1
		
		CMP R1, R2
		BLE loop

		SWI 2


printNum

	MOV R0, R1
	SWI 4

	MOV R0, #10
	SWI 0

	BX LR


FourthBuzz

	ADRL R0, fourth
	SWI 3
	MOV R3, #0

	ADRL R0, buzz
	SWI 3

	MOV R0, #10
	SWI 0

	BX R5
	
Buzz

	ADD R3, R3, #1
	MOV R5, LR

	CMP R3, #4
	BEQ FourthBuzz

	ADRL R0, buzz
	SWI 3

	MOV R0, #10
	SWI 0

	BX R5
