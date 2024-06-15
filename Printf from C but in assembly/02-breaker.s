B main
width    DEFW 12

; Use this buffer to store your words, there's space for words up to 32 bytes long
;
; When you store characters here, it will overwrite the values that already exist.
buffer    DEFB "0123456890123456789012345678901",0 

        ALIGN
main
; You will need to insert any setup code to 
; execute before the loop here
		
                MOV R5, #0 ; reserved for loading width

                ADRL R1, width ; put addr of width into r1
                LDR R7, [r1] ; load the value of width into r5

		MOV R0, #0 ; reserved for chars
		MOV R1, #0 ; reserved for buffer address
		MOV R2, #0 ; reserved for pointer offset
                MOV R3, #0 ; reserved for current line char count
                MOV R4, #0 ; reserved for current word char count
                MOV R5, #0 ; reserved for space count (how many spaced were inputted by the user)
                MOV R6, #0 ; SPACE FLAG - says if a space exists after a word or not
             
                MOV R8, #0
                MOV R9, #0


		ADRL R1, buffer	; put buffer address into R1
                
        B readChar
loop

;        Print character

readChar

        ;memory check ;
        CMP R2,#29
        MOVGE R2, #0
        ;-------------;

        SWI 1
        CMP R0, #'#'
        BEQ end
        CMP R0, #32
        BEQ space ; goto space subroutine
        CMP R0, #10
        BEQ enter
        STRB R0,[R1,R2]	
        ADD R2, R2, #1 ; add to pointer
        ADD R3, R3, #1 ; add to current characters on the current line
        ADD R4, R4, #1 ; add to current chars in word buffer
        ADD R8, R3, #1          ; Add R3 (current char count of current line) to the R4 register where R4 is the current char count of the word being written in buffer
        BNE readChar
        SWI 2

space 

        CMP R4, #0 ; if the char count in buffer is >0 (if theres actually new data there, print a word)
        BGE print_word

        B readChar

enter

        CMP R8, R7              ; Check the current line length against the possible line length

        BGT enter_wordNewLine 

        CMP R6, #1 ; if flag r6 is raised, include a space on print
        BLEQ space_

        MOV R0, #0              ; null termination char appended to string
        STRB R0, [R1, R2]       ; store null termination char at end of string
        ADR R0, buffer          ; Load buffer address into memory
        SWI 3                   ; print string from base address of string
        MOV R2, #0              ; reset pointer offset
        MOV R4, #0              ; Reset current char count for buffer
        MOV R6, #1              ; Raise flag to allow space to be printed before word
        
        MOV R0,#10
        SWI 0

        B readChar


print_word

        CMP R8, R7              ; Check the current line length against the possible line length

        BGT wordNewLine 

        CMP R6, #1 ; if flag r6 is raised, include a space on print
        BLEQ space_

        MOV R0, #0              ; null termination char appended to string
        STRB R0, [R1, R2]       ; store null termination char at end of string
        ADR R0, buffer          ; Load buffer address into memory
        SWI 3                   ; print string from base address of string
        MOV R2, #0              ; reset pointer offset
        MOV R4, #0              ; Reset current char count for buffer
        MOV R6, #1              ; Raise flag to allow space to be printed before word
        
        B readChar
space_ 
        ADD R3, R3, #1          ; Add space to char counter for line 
        MOV R0, #32             ; put space character in R0 register
        SWI 0                   ; print space char
        BX LR                   ; jump back to print_word

newline

        MOV R0, #10
        SWI 0

        B readChar

wordNewLine

        CMP R6, #1 ; if flag r6 is raised, include a space on print
        BLEQ space_

        CMP R10, #1
        MOVEQ R0, #10
        SWIEQ 0

        MOV R0, #0 ; null termination char appended to string
        STRB R0, [R1, R2]
        ADR R0, buffer
        SWI 3
        MOV R2, #0 
        ;MOV R6, #0
        MOV R8, #0
        MOV R3, #0
        MOV R4, #0
        MOV R5, #0

        B readChar

enter_wordNewLine

        CMP R6, #1 ; if flag r6 is raised, include a space on print
        BLEQ space_


        MOV R0, #0 ; null termination char appended to string
        STRB R0, [R1, R2]
        ADR R0, buffer
        SWI 3
        MOV R2, #0 
        ;MOV R6, #0
        MOV R8, #0
        MOV R3, #0
        MOV R4, #0
        MOV R5, #0
        MOV R0, #10
        SWI 0
        MOV R10, #1 

        B readChar

end

        CMP R6, #1 ; if flag r6 is raised, include a space on print
        BLEQ space_

        MOV R0, #0              ; null termination char appended to string
        STRB R0, [R1, R2]
        ADR R0, buffer
        SWI 3
        MOV R2, #0 
       ; ADD R8, R3,R4
        CMP R8, R7             ; this checks the current line length against the possible line length
        MOV R4, #0
        MOV R6, #1
        ;BGE wordNewLineEnd        


        SWI 2


;TODO

; Read width using LDR                                                                  - Done
; Read amount of characters on current line                                             - Done
; Store chars using STRB                                                                - Done                                                           
; Store null termination char at end of current string                                  - Done
; Print string with SWI 3                                                               - Done
; Print newline if the word plus current char count is greater than the width           - Maybe done? idk anymore
; Detect spaces                                                                         - Done
; Detect two spaces in one go                                                           - Done
; Pressing space twice will print a space                                               - Done
; Pressing the RETURN KEY will start text on newline                                    - Done


; First space prints the word, the second, prints a space#



; TwoSpace ; When two spaces are detected, print space
       
;         MOV R5, #0
;          MOV R0, #32
;         SWI 0
        
;         ;ADD R3, R3, #1
;         B loop



;printWord
      
;        CMP R9, #0
;        BEQ readChar

;        MOV R0, #0              ; null termination char appended to string
;        STRB R0, [R1, R2]
;        ADR R0, buffer
;        SWI 3
;        MOV R2, #0 
;        MOV R6, #0
;        ;ADD R6, R6, #1


;        ADD R8, R3,R4
;        CMP R8, R7             ; this checks the current line length against the possible line length
;       ; BGT wordNewLine 
        
;        ;MOV R6, #0    
;      B readChar

;printSpace
;        CMP R9, #0
;        BEQ readChar
;        ; MOV R6, #0
        
;        ; MOV R0, #32
;        ; SWI 0
;        ; B readChar

;        MOV R0, #0              ; null termination char appended to string
;        STRB R0, [R1, R2]
;        ADR R0, buffer
;        SWI 3
;        MOV R2, #0 
        
;        ;ADD R6, R6, #1

;        ADD R8, R3,R4
;        CMP R8, R7             ; this checks the current line length against the possible line length
;        BGT wordNewLine 
        
;        MOV R0, #32
;        SWI 0

;        ;MOV R6, #0
;        B readChar
