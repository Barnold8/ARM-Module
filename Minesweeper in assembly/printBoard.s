        B test_printBoard

; Our board 
; 0, represents an empty space
; 1-8 represents the number of bombs around us
; 66 represents there is a bomb at this location
; No more than 8 bombs
tpb_board   DEFW  1,-1, 1, 0, 0, 1,-1,-1, 1, 1, 1, 0, 0, 1, 3,-1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1,-1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1,-1, 1, 0, 0, 1, 1, 2, 2, 2, 1, 0, 0, 1,-1, 2,-1, 1, 0, 0, 0



        ALIGN
test_printBoard    
        ADR R0, tpb_board
        BL printBoard
        SWI 2

; printBoard -- print the board 
; Input: R0 <-- Address of board
printBoard
; Insert your implementation here

MOV R2, R0
MOV R1, #1
MOV R0, #32
SWI 0
MOV R3, #0
SWI 0
SWI 0
MOV R13, #0x10000 ; stack base address


topRow

        MOV R0, #32
        SWI 0
        SWI 0


        MOV R0, R1
        SWI 4
        
        MOV R0, #32
        SWI 0
        SWI 0

        ADD R1,R1,#1

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
        
        

PrintTableRow ; sub-sub routine within RowAdd

        MOV R0, #32
        SWI 0
        SWI 0

        LDR R0, [R2,R3]
        
        CMP R0, #-1
        MOVEQ R0, #77
        SWIEQ 0

        CMP R0, #0
        MOVEQ R0, #32
        SWIEQ 0


        CMP R0, #32
        SWILT 4
        


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

        BX LR

   
