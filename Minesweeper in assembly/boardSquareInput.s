        B test_BoardSquareInput

tprompt  DEFB "Enter square to reveal: ",0
tmesg    DEFB "You entered the index ",0

    ALIGN
test_BoardSquareInput
        ADR R0, tprompt
        BL boardSquareInput

        MOV R1, R0
        ADR R0, tmesg
        SWI 3
        MOV R0,R1
        SWI 4
        MOV R0,#10
        SWI 0
        SWI 2


; boardSquareInput -- read board position from keyboard
; Input:  R0 ---> prompt string address
; Ouptut: R0 <--- index



boardSquareInput


       MOV R13, #0x10000 ; stack base address
       STMFD R13!, {R4}
       STMFD R13!, {R5}
       STMFD R13!, {R6}
       MOV R4 ,#0
    

printPrompt

       SWI 3
       MOV R3, R0
       B takeInput

printPromptAgain
       MOV R4 ,#0
       MOV R0, R3
       SWI 3
       MOV R3, R0

takeInput 

       ADD R4, R4, #1 ;This is used as a loop counter so i can avoid testing the pushed R4 from the start of the prog as valid data
       MOV R0, #0
     

       SWI 1
       MOV R2, R0
       STMFD R13!, {R0}

       SWI 0
       CMP R0, #10
       BNE takeInput  

process ;10/ENTER seems to be included here so I need to avoid processing that since it isnt even a valid char to begin with

        SUB R4, R4, #1
        
        LDMFD R13!, {R0}

        CMP R0, #10                     ;; need to work a way how to calculate a cell number to return given the numbers input by the user
        BEQ IGN_CHAR

        CMP R0, #','
        BEQ IGN_CHAR

        CMP R0, #'8'
        BGT printPromptAgain

        CMP R0, #'1'
        BLT printPromptAgain

        CMP R4, #0
        MOVEQ R5, R0

        CMP R4, #2
        MOVEQ R6, R0

IGN_CHAR

        CMP R4, #0
        BGT process


endProcess

       ;ADR R0, wmesg
       ;SWI 3


       SUB R5,R5, #48   ;Convert ascii chars to their actual decimal representative 
       SUB R6,R6, #48

                        ;My own formula I made (8xC - (8-R))
       MOV R0, #8
       MUL R1, R5, R0
       MOV R2, R0
       SUB R2, R2, R6
       SUB R1, R1, R2
       SUB R1, R1, #1 ; this was needed for some reason

       ;ADR R0, dmesg
       ;SWI 3


       MOV R0, R1

       LDMFD R13!,{R4}
       LDMFD R13!,{R5}
       LDMFD R13!,{R6}

      
       BX LR



; Test subroutines to run when a certain test is met within code
TEST

        MOV R0, #77
        SWI 0
        SWI 0
        SWI 0
        SWI 0
        SWI 0
        SWI 0
        SWI 0

        LDMFD R13!,{R4}
        LDMFD R13!,{R5}
        LDMFD R13!,{R6}
        B printPromptAgain

OUTBOUNDTESTA

        MOV R0, #88
        SWI 0
        SWI 0
        SWI 0
        SWI 0
        SWI 0
        SWI 0
        SWI 0

        LDMFD R13!,{R4}
       LDMFD R13!,{R5}
       LDMFD R13!,{R6}
        SWI 2

OUTBOUNDTESTB

        MOV R0, #99
        SWI 0
        SWI 0
        SWI 0
        SWI 0
        SWI 0
        SWI 0
        SWI 0


        MOV R0,#10
        SWI 0 
        SWI 0

        MOV R0, #'9'
        SWI 4


        MOV R0,#10
        SWI 0 
        SWI 0

        MOV R0, #'0'
        SWI 4

        LDMFD R13!,{R4}
       LDMFD R13!,{R5}
       LDMFD R13!,{R6}
        SWI 2

