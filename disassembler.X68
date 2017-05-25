*-----------------------------------------------------------
* Title      :  Disassembler
* Written by :  Alvin, Max, Youngmin
* Date       :  4/28/17
* Description:  Main for disassembler
*-----------------------------------------------------------
*==================================================
* Data Reg Constants:
*   
* IO PHASE:
*   D0: Stores trap states
*   D1: Stores length of string, updated after hex conversion finishes.
*   D3: Stores hex num
*   D4: Stores temporarily a byte off of the input string in A1

*   A1: Points to the user inputed string
*   A5: Stores starting memory address
*   A6: Stores ending memory address
*===================================================
            INCLUDE 'test.X68'
            INCLUDE 'display.X68'
            INCLUDE 'ea.X68'
            INCLUDE 'opcodes.X68'
            ORG     START
            
*===================================================
* Program execution - Youngmin 5/5/17
*===================================================
            JSR         PROMPT_USR
            JSR         INPUT
            JSR         LOOP
            MOVEA.L     S_PTR, A7        * INIT STACK
            BSR         RESET
            
            
            SIMHALT
*=================================================
* Take user input - Youngmin 5/5/17
*=================================================
PROMPT_USR  LEA         MSG_INTRO,A1    * DISPLAY PROMPT
            MOVE.B      #13,D0
            TRAP        #15
            MOVE.B      #7,NUM_LINE     * INIT COUNTER
            RTS

INPUT       LEA         MSG_START,A1    * REQUEST STARTING ADDRESS
            MOVE.B      #14,D0
            TRAP        #15    
            
            LEA         IO_PROMPT,A1    * TAKE STARTING ADDRESS STORE IN A5
            MOVE.B      #2,D0           
            TRAP        #15
            JSR         ASC_HEX_LOOP
            MOVE.L      D1,A5

            LEA         MSG_END,A1      * REQUEST ENDING ADDRESS
            MOVE.B      #14,D0
            TRAP        #15
            
            LEA         IO_PROMPT,A1    * TAKE ENDING ADDRESS STORE IN A6
            MOVE.B      #2,D0
            TRAP        #15
            JSR         ASC_HEX_LOOP
            MOVE.L      D1,A6
            
            CMP.L       A5,A6           
            BLE         BAD_INPUT       * BRANCH IF ENDING ADDRESS IS LOWER THAN STARTING
            ;MOVE.B      #0,-(sp)        * INIT STACK
            RTS
            
*===================================================
* Convert ASCII to HEX - Youngmin 5/5/17
* Notes: D1 stores string, A1 stores ptr str val
* D3 stores hex num val, D4 is temp var
*===================================================
ASC_HEX_LOOP
            CMP.L       #0,D1
            BLE         END_HEX
            LSL.L       #4,D3
            SUB         #1,D1
            
ASC_HEX
            MOVE.B      (A1)+,D4        * Copy A1 (str val) into D4 and increment A1
            
            CMP.B       #48,D4
            BEQ         x0
            CMP.B       #49,D4
            BEQ         x1       
            CMP.B       #50,D4
            BEQ         x2        
            CMP.B       #51,D4
            BEQ         x3        
            CMP.B       #52,D4
            BEQ         x4
            CMP.B       #53,D4
            BEQ         x5        
            CMP.B       #54,D4
            BEQ         x6        
            CMP.B       #55,D4
            BEQ         x7
            CMP.B       #56,D4
            BEQ         x8        
            CMP.B       #57,D4
            BEQ         x9        
            CMP.B       #65,D4
            BEQ         xA
            CMP.B       #66,D4
            BEQ         xB
            CMP.B       #67,D4
            BEQ         xC
            CMP.B       #68,D4
            BEQ         xD   
            CMP.B       #69,D4
            BEQ         xE       
            CMP.B       #70,D4
            BEQ         xF 
   
            JMP         BAD_INPUT
            
END_HEX     
            MOVE.L      D3, D1
            CLR.L       D4
            CLR.L       D3
            RTS
            
x0          ADDI.L      #$0,D3          * D3 used to store HEX num
            JMP         ASC_HEX_LOOP
x1          ADDI.L      #$1,D3        
            JMP         ASC_HEX_LOOP
x2          ADDI.L      #$2,D3        
            JMP         ASC_HEX_LOOP
x3          ADDI.L      #$3,D3        
            JMP         ASC_HEX_LOOP
x4          ADDI.L      #$4,D3        
            JMP         ASC_HEX_LOOP
x5          ADDI.L      #$5,D3        
            JMP         ASC_HEX_LOOP
x6          ADDI.L      #$6,D3        
            JMP         ASC_HEX_LOOP
x7          ADDI.L      #$7,D3        
            JMP         ASC_HEX_LOOP
x8          ADDI.L      #$8,D3        
            JMP         ASC_HEX_LOOP
x9          ADDI.L      #$9,D3        
            JMP         ASC_HEX_LOOP
xA          ADDI.L      #$A,D3        
            JMP         ASC_HEX_LOOP
xB          ADDI.L      #$B,D3        
            JMP         ASC_HEX_LOOP
xC          ADDI.L      #$C,D3        
            JMP         ASC_HEX_LOOP
xD          ADDI.L      #$D,D3        
            JMP         ASC_HEX_LOOP
xE          ADDI.L      #$E,D3        
            JMP         ASC_HEX_LOOP
xF          ADDI.L      #$F,D3   
            JMP         ASC_HEX_LOOP
            
BAD_INPUT   LEA         MSG_BADADR,A1
            MOVE.B      #13,D0
            TRAP        #15
            JMP         INPUT
                   
*===================================================
* Reset registers
*===================================================
RESET
            CLR.L           D0
            CLR.L           D1
            CLR.L           D2
            CLR.L           D3
            CLR.L           D4
            CLR.L           D6
            CLR.L           D7

            MOVEA.L     #$0,A0
            MOVEA.L     #$0,A1
            MOVEA.L     #$0,A2
            MOVEA.L     #$0,A3
            MOVEA.L     #$0,A4
            RTS

PAUSE_OUT   LEA     MSG_PAUSE,A1
            MOVE.B  #14,D0
            TRAP    #15
            MOVE.B  #5,D0
            TRAP    #15
            MOVE.B  #0,NUM_LINE
            JMP     LOOP
    
            END    START        ; last line of source









*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
