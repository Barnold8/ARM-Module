            B test_printMaskedBoard
;https://developer.arm.com/documentation/dui0068/b/Writing-ARM-and-Thumb-Assembly-Language/Load-and-store-multiple-register-instructions/Implementing-stacks-with-LDM-and-STM
; Our board 
; 0, represents an empty space
; 1-8 represents the number of bombs around us
; -1 represents there is a bomb at this location
; No more than 8 bombs
pmbBoard
        DEFW  1,-1, 1, 0, 0, 1,-1,-1, 1, 1, 1, 0, 0, 1, 3,-1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1,-1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1,-1, 1, 0, 0, 1, 1, 2, 2, 2, 1, 0, 0, 1,-1, 2,-1, 1, 0, 0, 0
pmbBoardMask
        DEFW  0,-1,-1,-1,-1, 0,-1, 0,-1,-1,-1,-1,-1,-1, 0,-1,-1,-1,-1,-1, 0,-1,-1,-1, 0, 0,-1,-1,-1,-1,-1,-1,-1,-1,-1, 0, 0,-1,-1,-1,-1, 0,-1, 0,-1,-1,-1,-1,-1,-1, 0,-1,-1,-1,-1,-1, 0,-1,-1,-1, 0, 0,-1,-1

        ALIGN

; printMaskedBoard -- print the board with only the squares visible when boardMask contains zero
; Input: R0 <-- Address of board
;        R1 <-- Address of board Mask


test_printMaskedBoard
        ADR R0, pmbBoard 
        ADR R1, pmbBoardMask
        BL printMaskedBoard
        SWI 2


; printBoard -- print the board 
; Input: R0 <-- Address of board
printMaskedBoard   
; Insert your implementation here

MOV R13, #0x10000 ; stack base address

STMFD R13!, {R4}
STMFD R13!, {R5}

MOV R4, R0
MOV R5, R1

MOV R0, #32

SWI 0
SWI 0
SWI 0
MOV R3, #0

MOV R1, #1

topRow

        MOV R0, #32
        SWI 0
        SWI 0

        MOV R0, R1
        SWI 4
        
        MOV R0, #32
        SWI 0
        SWI 0

        ADD R1, R1, #1

        CMP R1,#9
        BNE topRow
        MOV R1, #1 ; reset R0 after its use

RowAdd
      
        MOV R0, #10
        SWI 0
        SWI 0

        MOV R0, R1
        SWI 4
        MOV R0, #32
        SWI 0
        SWI 0  

PrintTableRow ; sub-sub routine within RowAdd | ;0 = show value | !0 = show | R2 is used for addressing tables

        MOV R0, #32
        SWI 0
        SWI 0

        LDR R0, [R5,R3] ; THIS SHOULD BE THE MASKED BOARD ARRAY
        CMP R0, #0
        BEQ PRINTVALUE


        MOV R0, #35
        SWI 0
        B Skip




PRINTVALUE      ; THIS NEEDS TO BE LOOKED AT 
        

        
        LDR R0, [R4,R3]
        
        CMP R0, #0
        MOVEQ R0 , #32 
        SWIEQ 0

        CMP R0, #-1
        MOVEQ R0 , #77
        SWIEQ 0

        CMP R0, #32
        SWILT 4

  



Skip

        MOV R0, #32
        SWI 0
        SWI 0

        ADD R3, R3, #4

        AND R0, R3, #31
        CMP R0, #0
        
        BNE PrintTableRow


RowAdd_pt_two ; end section of row add
        


        

        CMP R1,#8
        ADD R1,R1,#1
        BNE RowAdd
        
        LDMFD R13!, {R5}
        LDMFD R13!, {R4}

        BX LR

   
