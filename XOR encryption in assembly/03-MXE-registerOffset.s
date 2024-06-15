		B main

msg		DEFB 	"Gentleman, ladies, may I have your attention please? Well, you've heard the backroom boys, "
		DEFB	"now it's about time for my turn. C Day, that is Computer Day, will be next Monday, July the 16th, "
		DEFB	"that is in four days time. Now on that date all the computer systems in this country, and subsequently "
		DEFB	"in the whole world will come under the control of this central computer which we call WOTAN.",0

encMsg	DEFB	31,46,37,44,40,51,59,46,61,44,52,37,124,47,37,47,40,57,49,47,124,61,46,57,124,62,61,47,57,56,124,51,50,124
		DEFB	49,61,40,52,57,49,61,40,53,63,61,48,124,44,46,51,62,48,57,49,47,124,47,51,124,63,51,49,44,48,57,36,124,40
		DEFB	52,57,37,124,63,61,50,50,51,40,124,62,57,124,47,51,48,42,57,56,124,43,53,40,52,51,41,40,124,61,124
		DEFB	55,57,37,114,0
		ALIGN

msgSize	DEFW	385
encSize	DEFW	103
encKey	DEFW	92
msgKey	DEFW	63
Counter DEFW	0
	

;REGISTER_CLEAN

;		MOV R0, #0
;		MOV R1, #0
;		MOV R2, #0
;		MOV R3, #0
;		MOV R4, #0
;		MOV R5, #0
;		MOV R6, #0
;		MOV R7, #0
;		MOV R8, #0
;		MOV R9, #0
;		MOV R10, #0

;		BX LR


main ; G = 71

		;BL REGISTER_CLEAN
	
		ADR R1, encMsg
		LDR R3, encSize
		LDR R2, encKey
		MOV R4, #0

		;Print first char lol oops
		LDR R0, [R1,R4]
		EOR R0,R0,R2
		SWI 0
		SUB R3,R3,#1
		
		;-----------------------
		BL crypt

		SWI 2



crypt
	;while msgSize != 0, do thing

	
	LDRB R0, [R1,R4] ; Load current char in R0

	;CMP R0, #0
	;SWIEQ 2

	CMP R0, #0
	BEQ ignore
	CMP R0, R2
	BEQ ignore

	EOR R0,R0,R2

ignore
	STRB R0, [R1,R4]
	SUB R3,R3,#1
	ADD R4,R4,#1
	CMP R0, #0
	BEQ END

	SWI 0

	CMP R3, #0
	BGT crypt


	BX LR


END

	; MOV R0, #10
	; ADR R3, msg
	; LDR R1, msgSize
	; LDR R2, msgKey
	; ADD R4,R4, #1
	; SUB R1,R1,#1 ; Remove null terminator char


	SWI 2

;STEVES COMMENTS:

; Modify the above to use encMsg, encSize, and encKey to check whether your program decrypts correctly

; Insert the ARM code to call you crypt procedure here

; Print out the (en|de)cyrpted message

;; R0 <- address of message to encode
;; R1 <- size of message in bytes
;; R2 <- key (between 0 and 255)



;Basis for encryption/decryption 


; EOR R0, R5,R2	
; SWI 0	
; MOV R5, R0
; EOR R0, R5,R2	
; SWI 0	


