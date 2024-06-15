

		B main
table	DEFW	13
is		DEFB 	" is ",0

		ALIGN

times
        LDR R2, table ; loads data out of mem to R2

        MOV R0, R3 ; put times in r0 register
        SWI 4

        MOV R0, #120    ; store 120 -> x in r0 register
        SWI 0                  ; print char 

        MOV R0, R2      ; print actual result
        SWI 4

        ADR R0, is      ; print is string
        SWI 3

        MOV R0,R1 ; moves data from R2 to R0
        SWI 4 ;PRINT

        MOV R0, #10 ;This prints newline
        SWI 0 ;This prints char

        ADD R1, R1, R2 ; Add 13 to r1 register
        ADD R3, R3, #1 ; ADD 1 to r3 register

        LDR R4, table

        CMP R3, R4
        BLE times
        BGE stop_protocol

stop_protocol

        SWI 2

main

        ;RESET REGISTER MEM

        MOV R0, #0
        MOV R1, #0
        MOV R2, #0
        MOV R3, #0

        B times
     
        SWI 2

        