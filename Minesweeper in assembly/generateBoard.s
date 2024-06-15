        B test_generateBoard


; Our board 
; 0, represents an empty space
; 1-8 represents the number of bombs around us
; 66 represents there is a bomb at this location
; No more than 8 bombs
testGenboard   
        DEFW  1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
tgbBoardMask
        DEFW  0,0,0,0,0, 0,0, 0,0,0,0,0,0,0, 0,0,0,0,0,0, 0,0,0,0, 0, 0,0,0,0,0,0,0,0,0,0, 0, 0,0,0,0,0, 0,0, 0,0,0,0,0,0,0, 0,0,0,0,0,0, 0,0,0,0, 0, 0,0,0

        ALIGN
test_generateBoard
        MOV R13, #0x10000
	ADR R0, testGenboard 
        BL generateBoard

        ADR R0, testGenboard 
        ADR R1, tgbBoardMask
        BL printMaskedBoard

        SWI 2


; generateBoard
; Input R0 -- array to generate board in
generateBoard
; Insert your implementation here


PopulateMines ;Randu DOES always return a random number. Well, pseudoRandom

        STMFD R13!, {R14} ; THIS WORKS NOW, WE CAN CONTINUE WITH THE PROGRAM
        STMFD R13!, {R4}
        STMFD R13!, {R5}
        MOV R4, #0
        MOV R5, R0

mineLOOP

        ADD R4, R4, #1
        BL randu

        
        MOV R0, R0 ASR #8 ; shift R0 right by 8 bits
        AND R0, R0, #0x3f ; take the modulo by 64


        MOV R1, #-1
        LDR R2, [R5,R0]
        CMP R2, R1
        BEQ SkipMine

StoreMine
        STR R1, [R5,R0]
        B FinishMine
SkipMine
        
        SUB R4, R4 ,#1

FinishMine
        CMP R4, #8
        BLT mineLOOP

        LDMFD R13!, {R4}


CalculateBoard

        ;VARS USED: y, x, board, p , q. Sum of vars = 5
        ; VARS INDEX: R1 = y | R2 = x | R5 = board| 

        MOV R1, #1 ; y
        MOV R3, #0

        ;LOOP THROUGH EACH OF THE ITEMS IN THE BOARD ARRAY, IF IT IS -1, THEN CALCULATE NEIGHBOURS

Yloop
        ;for(y = 1; y < 7; y++){
                
                
                MOV R2, #1 ; X
Xloop
                ;for(x = 1; x < 7; x++){
                
                        
                        ;if(board[y*8+x] == -1){ // Found a mine, so increment all the cells around me

                                ;Setting up board[y*8+x]the big nums Are the mines
                                
                                STMFD R13!, {R4}

                                MOV R3, #4        ; new X (x in retrospect to byte position)              
                                MUL R3, R3, R2


                                MOV R4, #4        ; new Y (y in retrospect to byte position)
                                MUL R4, R4, R1

                                ;board[y*8+x]

                                MOV R0, #8

                                MUL R4, R4, R0
                                ADD R4, R4, R3

                                LDR R0, [R5, R4]
                                SWI 4
                                LDMFD R13!, {R4}

                                ;---------------------
IncCells
                                ;for(p = y-1; p <= y+1; p++){

                                        ;for(q = x-1; q <= x+1; q++){

                                        ; // IF not a mine, increment
                                        ;if(board[p*8+q] != -1){board[p*8+q] = board[p*8+q] +1; 
                                        ;}}}}}}
SkipCells
 

                        SWI 4
                        MOV R0, #32
                        SWI 0
                        ADD R2, R2, #1
                        CMP R2, #7
                        BLT Xloop

                MOV R0, #10
                SWI 0
                ADD R1, R1, #1
                CMP R1, #7
                BLT Yloop
                SWI 2

BCKTOMAIN

        LDMFD R13!, {R5}
        LDMFD R13!, {R14}
        MOV PC, R14


; DO NOT CHANGE ANYTHING AFTER THIS POINT...
; randu -- Generates a random number
; Input: None
; Ouptut: R0 -> Random number
randu   LDR R2,mult
        MVN R1,#0x80000000
        LDR R0,seed
        MUL R0,R2,R0
        AND R0,R0,R1
        STR R0,seed
        MOV PC, R14

        ALIGN
seed    DEFW    0xC0FFEE
mult    DEFW    65539

        ALIGN
        include printMaskedBoard.s
        ALIGN
        SWI 2
