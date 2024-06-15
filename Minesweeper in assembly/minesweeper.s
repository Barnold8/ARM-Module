; DO NOT MODIFY THIS FILE
; BUT FEEL FREE TO STUDY HOW IT WORKS
; AND TO USE IT TO TEST YOUR SUBROUTINES
        B main

; Our board 
; 0, represents an empty space
; 1-8 represents the number of bombs around us
; -1 represents there is a bomb at this location
; No more than 8 bombs
board   DEFW  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
boardMask
        DEFW -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1

prompt  DEFB "Enter square to reveal: ",0
already DEFB "That square has already been revealed...\n", 0
loseMsg DEFB "You stepped on a mine, you lose!\n",0
winMsg  DEFB "You successfully uncovered all the squares while avoiding the mines...\n",0

        ALIGN
main    MOV R13, #0x10000
        ADR R0, board 
        ADR R1, boardMask
        MOV R2, #0
        MOV R3, #-1
        MOV R4, #63
fl      STR R2, [R0, R4 LSL #2]
        STR R3, [R1, R4 LSL #2]
        SUB R4, R4, #1
        CMP R4, #0
        BGE fl
        BL generateBoard

        ADR R4, boardMask
        ADR R5, board
        MOV R7, #64
mLoop   BL cls
        MOV R1, R4
        MOV R0, R5
        BL printMaskedBoard
        MOV R0, #10
        SWI 0
        SWI 0
reread  ADR R0, prompt
        BL boardSquareInput
        MOV R1,R0
        LDR R0, [R4, R1 LSL #2]

        CMP R0, #0
        BNE processSquare
        MOV R0, #10
        SWI 0

        ADRL R0, already
        SWI 3
        B reread
processSquare
        MOV R0,#0
        STR R0,[R4, R1 LSL #2]
        SUB R7,R7,#1
        CMP R7, #8
        BEQ win
        LDR R0, [R5, R1 LSL #2]
        CMP R0, #-1
        BEQ lose
        B mLoop

win     ADR R0, winMsg
        SWI 3
        SWI 2
lose    ADRL R0, loseMsg
        SWI 3
        SWI 2

exit    SWI 2
        SWI 2      

;; cls : Clear the screen
cls     MOV R1,#20*40
        MOV R0,#8
clsLoop SWI 0
        SUBS R1,R1,#1
        BGE clsLoop
        MOV PC,R14

        ALIGN
; boardSquareInput
        include boardSquareInput.s
        ALIGN
        SWI 2

;        ALIGN
; printMaskedBoard
;        include printMaskedBoard.s
;        ALIGN
;        SWI 2

        ALIGN
; generateBoard -- which includes printMaskedBoard
        include generateBoard.s
        ALIGN
        SWI 2