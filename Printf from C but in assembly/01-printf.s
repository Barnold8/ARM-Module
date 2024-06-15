	B main

fs1	DEFB	"%d green %s sitting on a wall%c\n",0
fs2	DEFB	"This is a test containg nothing but a %%\n",0
fs3	DEFB	"%d %d %d %d %d.\n%s!\n\n%s\n",0
bottleString	DEFB "bottles",0
blast	DEFB	"Blast Off!",0
hello	DEFB	"Hello Universe",0
	ALIGN
seq1	DEFW	10,bottleString, '.'
seq2	DEFW	1
seq3	DEFW	5,4,3,2,1,blast,hello

main	ADR R1,fs2		; Feel free to change these to point to the other format specifiers and value sequencei
	ADR R2,seq2

	MOV R0, #0
	MOV R3, #0
	MOV R5, #0

printf 
; You should start your program here
; DO NOT modify any of the code above (other than to try different tests -- the pipeline will run further tests as well.)

	;CMP R10, #32 ;R10 is reserved for a reset flag. if its 32 then reset all registers. Allows for a clean program without messing any register up
	;BEQ reset


	LDRB R0, [R1,R3] ; Load char from memory. R1 is memory location and R3 is its offset
	CMP R0, #0 ;Compare the char to null termination char
	BEQ end ; if it is, go to end subroutine


	CMP R0, #'%'
	BEQ format


	SWI 0	;else, print a char
	ADD R3,R3,#1 ; also add 1 to the index counter

	B printf	


format

;	MOV R4, R0; put % in r4 in case theres no format specifier
	ADD R3, R3, #1 ; add to the pointer offset
	LDRB R0, [R1,R3] ; load the data 

	; Comparison section
	CMP R0, #'d'
	BEQ int_form
	CMP R0, #'s'
	BEQ string_form
	CMP R0, #'c'
	BEQ char_form
	CMP R0, #'%'
	BEQ percent

	; -------------


	;MOV R0, R4 ; because no branches have been made for format specifiers, print the %
	;SWI 0 ; actual print
	ADD R3, R3, #1
	B printf ; back to printf to go over again

int_form

	LDR R0, [R2,R5]
	SWI 4
	MOV R0, #0
	ADD R5,R5,#4 ; Add 4 to R5 to move 4 bytes in memory since we read an integer
	ADD R3, R3, #1
	B printf

string_form

	LDR R0, [R2,R5]
	SWI 3
	MOV R0, #0			;Doesnt count characters to be added to R5 :(
	ADD R5,R5, #4	
	ADD R3, R3, #1
	B printf

char_form
	
	LDRB R0, [R2,R5]
	SWI 0
	MOV R0, #0	
	ADD R3, R3, #1
	B printf

percent

	MOV R0, #'%'
	SWI 0
	ADD R3, R3, #1
	B printf


end
	MOV R10, #32
	SWI 2