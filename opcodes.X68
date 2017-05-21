*-------------------------------------------------------
* Decoding opcodes
* D0: Trap task
* D3: DO NOT CHANGE. Stores original instruction bits. 
* D5: Temp stores instruction bits for decoding
*
* A1: Stores the string of the decoded instruction
* A2: Jump table
* A5: Stores starting memory address

* TODO: -Error handling
*       -code0000
*       -code0110
*       -testing  
*-------------------------------------------------------
;example     EQU     %0011110000001011   ; MOVE.W  A3,D6
;example     EQU     %0100001000000101   ; CLR.B  D5
;example     EQU     %1000011001000101   ; OR  D5,D3 
;example     EQU     %0101100100000000   ; SUBQ.B  #4,D0
;example     EQU     %0111101000000100   ; MOVEQ.L  #4,D5
;example     EQU     %1000100011010101   ; DIVU.W  (A5),D4
;example     EQU     %1001001010000000   ; SUB.L  D0,D1
;example     EQU     %1001100001100010   ; SUB.W  -(A2),D4
;example     EQU     %1011011010001100   ; CMP.L  A4,D3
;example     EQU     %1100011000000011   ; AND.B  D3,D3
;example     EQU     %1100010111011001   ; MULS.W  (A1)+,D2 
;example     EQU     %1101011001001011   ; ADD.W  A3,D3
;example     EQU     %1101010111000011   ; ADDA.L  D3,A2
;example     EQU     %1110011100101101   ; LSL.B  D3,D5
;example     EQU     %1110011100001101   ; LSL.B  #3,D5
;example     EQU     %1110011101001101   ; LSL.W  #3,D5
;example     EQU     %1110000011010001   ; ASR.W  (A1)
;example     EQU     %1110010001111101   ; ROR.W  D2,D5
;example     EQU     %0011001001000011   ; MOVEA.W  D3,A1
;example     EQU     %0011100000111100   ; MOVE.W  #$10FF,D4
;example     EQU     %0010100000111001   ; MOVE.L  $1000FFFF,D4
;example     EQU     %0011100000111000   ; MOVE.W  $10FF,D4
;example     EQU     %0011000111111000   ; MOVE.W  $10FF,$10FF
;example     EQU     %0010100000111100   ; MOVE.L #$10000000,D4
;word        EQU     $10000000 ; address test


;            ORG     $1000
;            INCLUDE 'display.X68'            
;            INCLUDE 'ea.X68'
            
;START:      
            
*========Loop through instructions here
;            MOVE.W  #example,$1000  ; testing example TODO: remove when loop implemented
;            MOVE.L  #word,$1002
;            MOVE.W  #$1000,A5       ; testing example TODO: remove when loop implemented
            
LOOP        ADDI.B  #1,NUM_LINE
            CMPI.B  #20,NUM_LINE
            BEQ     PAUSE_OUT
            
            MOVE.W  (A5),D3         ; read instruction from mem and move to register
            
            JSR     PRINT_ADDRESS
            LEA     DISP_TAB,A1
            MOVE.B  #14,D0
            TRAP    #15
            MOVE.W  #12,D2          ; move shift num
            MOVE.W  D3,D5           ; move to d5 to decode
            
            LSR.L   D2,D5           ; shift temp
            MULU    #6,D5           ; multiply temp
            LEA     JMP_TABLE,A2    ; load table          
            JSR     0(A2,D5)        ; jump to table
            
            ADDA.W  #2,A5           ; move to next instruction
            
            LEA     NEW_LINE,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            BRA     LOOP

*========================================
* Jump table
*========================================
JMP_TABLE   JMP     code0000        ; Bit manipulation/Immediate
            JMP     code0001        ; MOVE.B
            JMP     code0010        ; MOVE.L
            JMP     code0011        ; MOVE.W        
            JMP     code0100        ; MOVEM/CLR/LEA/DIVU.L/JSR/RTS
            JMP     code0101        ; SUBQ
            JMP     code0110        ; Bcc
            JMP     code0111        ; MOVEQ
            JMP     code1000        ; OR/DIVU.W
            JMP     code1001        ; SUB
            JMP     code1010        ; Unassigned
            JMP     code1011        ; CMP
            JMP     code1100        ; AND/MULS
            JMP     code1101        ; ADD/ADDA
            JMP     code1110        ; LSd/ASd/ROd
            JMP     code1111        ; Special/Reserved


*========================================
* 0000- Bit manipulation/Immediate
*========================================
code0000    RTS

*========================================
* 0001- MOVE.B
*========================================
code0001    LEA     DISP_MOVE,A1        * display MOVE
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_BYTE,A1        * display byte
            MOVE.B  #14,D0
            TRAP    #15
            
            MOVE.B  #0,SIZE             * set SIZE to byte
            
            LEA     DISP_TAB,A1         * display tab
            MOVE.B  #14,D0
            TRAP    #15
            
            JSR     GET_SRC             * decode src ea
            
            LEA     DISP_COM,A1         * display comma
            MOVE.B  #14,D0
            TRAP    #15
            
            JSR     GET_DEST            * decode dest ea
            
            RTS
            
*========================================
* 0010- MOVE.L
*========================================            
code0010    JSR     GET_OPMODE
            CMPI.B  #%001,D5     
            BEQ     IS_MOVEA
            
            MOVE.B  #2,SIZE             * set SIZE to L             
            
            LEA     DISP_MOVE,A1        * display MOVE
            MOVE.B  #14,D0
            TRAP    #15

CONT_MOVEL  LEA     DISP_LONG,A1        * display long
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     DISP_TAB,A1         * display tab
            MOVE.B  #14,D0
            TRAP    #15
            
            JSR     GET_SRC             * decode src ea
            
            LEA     DISP_COM,A1         * display comma
            MOVE.B  #14,D0
            TRAP    #15
            
            JSR     GET_DEST            * decode dest ea
            RTS
            
*========================================
* 0011- MOVE.W
*========================================               
code0011    JSR     GET_OPMODE
            CMPI.B  #%001,D5     
            BEQ     IS_MOVEA
            
            MOVE.B  #1,SIZE             * set SIZE to W             
                     
            LEA     DISP_MOVE,A1        * display MOVE
            MOVE.B  #14,D0
            TRAP    #15
            
CONT_MOVEW  LEA     DISP_WORD,A1        * display word
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     DISP_TAB,A1         * display tab
            MOVE.B  #14,D0
            TRAP    #15
            
            JSR     GET_SRC             * decode src ea
            
            LEA     DISP_COM,A1         * display comma
            MOVE.B  #14,D0
            TRAP    #15
            
            JSR     GET_DEST            * display dest ea 
            
            RTS           

IS_MOVEA    LEA     DISP_MOVEA,A1        * display MOVE
            MOVE.B  #14,D0
            TRAP    #15
            JMP     CONT_MOVEW
           
*========================================
* 0100- MOVEM/CLR/LEA/DIVU.L/JSR/RTS
*========================================      
code0100    CMPI.W  #$4E71,D3
            BEQ     IS_NOP
            LEA     FOUR_TABLE,A2       * load table
            CLR.L   D5                  * clear register
            MOVE.W  D3,D5               * move instruction
            LSL.W   #4,D5               * remove left 4 bits
            LSR.W   #8,D5               * gets bits
            LSR.W   #4,D5               * gets bits
            MULU    #6,D5               * form offset
            JSR     0(A2,D5)            * decode next level
            RTS

IS_NOP      LEA     DISP_NOP,A1
            MOVE.B  #14,D0
            TRAP    #15
            RTS            
            
*========================================
* 0100 Jump table
* MOVEM/CLR/LEA/DIVU.L/JSR/RTS
*========================================
FOUR_TABLE
            JMP     four0000    *Not used
            JMP     four0001    *LEA <ea>,A0
            JMP     four0010    *CLR
            JMP     four0011    *LEA <ea>,A1
            JMP     four0100    *Not used
            JMP     four0101    *LEA <ea>,A2
            JMP     four0110    *Not used
            JMP     four0111    *LEA <ea>,A3
            JMP     four1000    *MOVEM- register to memory
            JMP     four1001    *LEA <ea>,A4
            JMP     four1010    *Not used
            JMP     four1011    *LEA <ea>,A5
            JMP     four1100    *MOVEM- memory to register/DIVU.L/MULS.L
            JMP     four1101    *LEA <ea>,A6
            JMP     four1110    *JSR/RTS
            JMP     four1111    *LEA <ea>,A7

*========================================
* Not used
*========================================
four0000    RTS

*========================================
* LEA <ea>,A0
*========================================
four0001    LEA     DISP_LEA,A1         * display LEA
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     DISP_TAB,A1         * display tab
            MOVE.B  #14,D0
            TRAP    #15
            
            JSR     GET_SRC             * decode ea
            
            LEA     DISP_COM,A1         * display comma
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     DISP_AN,A1          * display A
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     REG_0,A1            * display register 0
            MOVE.B  #14,D0
            TRAP    #15
            
            RTS
        
*========================================
* CLR <ea>
*========================================            
four0010    LEA     DISP_CLR,A1         * display CLR
            MOVE.B  #14,D0
            TRAP    #15
            
            JSR     GET_SIZE            * gets size and store in D5
            CMPI.B  #%00,D5             * byte op
            BEQ     CLR_B
            CMPI.B  #%01,D5             * word op
            BEQ     CLR_W
            CMPI.B  #%10,D5             * long op
            BEQ     CLR_L

CLR_B       LEA     DISP_BYTE,A1
            MOVE.B  #14,D0
            TRAP    #15

            LEA     DISP_TAB,A1         * display tab
            MOVE.B  #14,D0
            TRAP    #15
            
            JSR     GET_SRC             * decode ea
            RTS            

CLR_W       LEA     DISP_WORD,A1
            MOVE.B  #14,D0
            TRAP    #15

            LEA     DISP_TAB,A1         * display tab
            MOVE.B  #14,D0
            TRAP    #15
            
            JSR     GET_SRC             * decode ea
            RTS
            
CLR_L       LEA     DISP_LONG,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     DISP_TAB,A1         * display tab
            MOVE.B  #14,D0
            TRAP    #15
            
            JSR     GET_SRC             * decode ea
            RTS  
   
*========================================
* LEA <ea>,A1
*========================================               
four0011    LEA     DISP_LEA,A1         * display LEA
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     DISP_TAB,A1         * display tab
            MOVE.B  #14,D0
            TRAP    #15
            
            JSR     GET_SRC             * decode ea
            
            LEA     DISP_COM,A1         * display comma
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     DISP_AN,A1          * display A
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     REG_1,A1            * display register 1
            MOVE.B  #14,D0
            TRAP    #15
            
            RTS
   
*========================================
* Not used
*========================================      
four0100    RTS

*========================================
* LEA <ea>,A2
*========================================
four0101    LEA     DISP_LEA,A1         * display LEA
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     DISP_TAB,A1         * display tab
            MOVE.B  #14,D0
            TRAP    #15
            
            JSR     GET_SRC             * decode ea
            
            LEA     DISP_COM,A1         * display comma
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     DISP_AN,A1          * display A
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     REG_2,A1            * display register 2
            MOVE.B  #14,D0
            TRAP    #15
            
            RTS
   
*========================================
* Not used
*========================================
four0110    RTS

*========================================
* LEA <ea>,A3
*========================================
four0111    LEA     DISP_LEA,A1         * display LEA
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     DISP_TAB,A1         * display tab
            MOVE.B  #14,D0
            TRAP    #15
            
            JSR     GET_SRC             * decode ea
            
            LEA     DISP_COM,A1         * display comma
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     DISP_AN,A1          * display A
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     REG_3,A1            * display register 3
            MOVE.B  #14,D0
            TRAP    #15
            
            RTS
   
*========================================
* MOVEM- register to memory
*========================================
four1000    LEA     DISP_MOVEM,A1       * display MOVEM
            MOVE.B  #14,D0
            TRAP    #15
            
            JSR     GET_SIZE_ONE        * get size and store in D5
            CMPI.B  #$0,D5              * word op
            BEQ     MOVEM_W
            CMPI.B  #$1,D5              * long op
            BEQ     MOVEM_L

MOVEM_L     LEA     DISP_LONG,A1        * display long
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     DISP_TAB,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            JSR     GET_SRC             * decode ea
            RTS            
            
MOVEM_W     LEA     DISP_WORD,A1        * display word
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     DISP_TAB,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            JSR     GET_SRC             * decode ea
            RTS             
   
*========================================
* LEA <ea>,A4
*========================================
four1001    LEA     DISP_LEA,A1         * display LEA
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     DISP_TAB,A1         * display tab
            MOVE.B  #14,D0
            TRAP    #15
            
            JSR     GET_SRC             * decode ea
            
            LEA     DISP_COM,A1         * display comma
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     DISP_AN,A1          * display A
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     REG_4,A1            * display register 4
            MOVE.B  #14,D0
            TRAP    #15
            
            RTS
   
*========================================
* Not used
*========================================
four1010    RTS

*========================================
* LEA <ea>,A5
*========================================
four1011    LEA     DISP_LEA,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     DISP_TAB,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            JSR     GET_SRC
            
            LEA     DISP_COM,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     DISP_AN,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     REG_5,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            RTS
   
*========================================
* MOVEM- memory to register/DIVU.L
*========================================
four1100    CLR.L   D5                  * clear register
            MOVE.W  D3,D5               * move instruction
            LSL.W   #8,D5               * shift to cancel out first left byte
            LSR.W   #8,D5               * shift to get 2 bits
            LSR.W   #6,D5
            CMPI.B  #01,D5
            BEQ     DEC_DIVU            * skip to divu.l
            
            LEA     DISP_MOVEM,A1       * display MOVEM
            MOVE.B  #14,D0
            TRAP    #15
           
            JSR     GET_SIZE_ONE        * get size and store in D5
            CMPI.B  #$0,D5              * word op
            BEQ     MOVEM_W
            CMPI.B  #$1,D5              * long op
            BEQ     MOVEM_L
            
DEC_DIVU    LEA     DISP_DIVU,A1        * display DIVU
            MOVE.B  #14,D0              
            TRAP    #15
            
            LEA     DISP_LONG,A1        * display long
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     DISP_TAB,A1         * display tab
            MOVE.B  #14,D0
            TRAP    #15
            
            JSR     GET_SRC             * decode ea
            RTS
            
*========================================
* LEA <ea>,A6
*========================================
four1101    LEA     DISP_LEA,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     DISP_TAB,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            JSR     GET_SRC
            
            LEA     DISP_COM,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     DISP_AN,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     REG_6,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            RTS
   
*========================================
* JSR/RTS
*========================================
four1110    CMPI.W  #$4E75,D3           * RTS
            BEQ     DEC_RTS
            
            LEA     DISP_JSR,A1         * display JSR
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     DISP_TAB,A1         * display tab
            MOVE.B  #14,D0
            TRAP    #15

            
            JSR     GET_SRC             * decode ea
            RTS

DEC_RTS     LEA     DISP_RTS,A1         * display RTS
            MOVE.B  #14,D0
            TRAP    #15
            RTS
            
*========================================
* LEA <ea>,A7
*========================================
four1111    LEA     DISP_LEA,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     DISP_TAB,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            JSR     GET_SRC
            
            LEA     DISP_COM,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     DISP_AN,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     REG_7,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            RTS  
            
*========================================
* 0101- SUBQ
*========================================
code0101    LEA     DISP_SUBQ,A1
            MOVE.B  #14,D0
            TRAP    #15
            JSR     GET_SIZE            * get size
            CMPI.B  #00,D5              * byte
            BEQ     SUBQ_B
            CMPI.B  #01,D5              * word
            BEQ     SUBQ_W
            CMPI.B  #10,D5              * long
            BEQ     SUBQ_L        
            
            ; TODO: err check
            RTS
   
SUBQ_B      LEA     DISP_BYTE,A1        * display byte
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     DISP_TAB,A1         * display tab
            MOVE.B  #14,D0
            TRAP    #15            
            
            JSR     GET_911             * get data
            JSR     DISP_REG            * print data
            LEA     DISP_COM,A1         * display comma
            MOVE.B  #14,D0
            TRAP    #15
            JSR     GET_SRC             * decode ea
            RTS
           
SUBQ_W      LEA     DISP_WORD,A1        * display word
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     DISP_TAB,A1         * display tab
            MOVE.B  #14,D0
            TRAP    #15            
            
            JSR     GET_911             * get data
            JSR     DISP_REG            * print data
            LEA     DISP_COM,A1         * display comma
            MOVE.B  #14,D0
            TRAP    #15
            JSR     GET_SRC             * decode ea
            RTS
            
SUBQ_L      LEA     DISP_LONG,A1        * display long
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     DISP_TAB,A1         * display tab
            MOVE.B  #14,D0
            TRAP    #15            
            
            JSR     GET_911             * get data
            JSR     DISP_REG            * print data
            LEA     DISP_COM,A1         * display comma
            MOVE.B  #14,D0
            TRAP    #15
            JSR     GET_SRC             * decode ea
            RTS
            
*========================================
* 0110- Bcc <label>
*========================================
code0110    RTS

*========================================
* 0111- MOVEQ
*========================================
code0111    LEA     DISP_MOVEQ,A1
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_LONG,A1
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_TAB,A1
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_PS,A1
            MOVE.B  #14,D0
            TRAP    #15
            JSR     GET_07              * display data
            LEA     DISP_COM,A1         * display comma
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_DN,A1          * dislay D
            MOVE.B  #14,D0
            TRAP    #15
            JSR     GET_911             * get register
            JSR     DISP_REG
            RTS

*========================================
* 1000- OR/DIVU.W
*========================================
code1000    CLR     D5       * clear register
            MOVE.B  D3,D5    * move instruction
            LSR.W   #6,D5
            CMPI.B  #%11,D5
            BEQ     DEC_DIVUW
            ; TODO: err check
                       
            LEA     DISP_OR,A1          * display OR
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     DISP_TAB,A1         * display tab
            MOVE.B  #14,D0
            TRAP    #15
            
            JSR     GET_SRC             * decode ea
            
            LEA     DISP_COM,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            ; TODO: Fix???
            LEA     DISP_DN,A1
            MOVE.B  #14,D0
            TRAP    #15
       
            JSR     GET_911
            JSR     DISP_REG
            RTS
            
   
DEC_DIVUW   MOVE.B  #1,SIZE             * set SIZE to W  
            LEA     DISP_DIVU,A1        * display DIVU
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_WORD,A1        * display word
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     DISP_TAB,A1         * display tab
            MOVE.B  #14,D0
            TRAP    #15
            
            JSR     GET_SRC             * decode ea
            
            LEA     DISP_COM,A1         * display tab
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_DN,A1         * display tab
            MOVE.B  #14,D0
            TRAP    #15
            JSR     GET_911
            JSR     DISP_REG
            RTS   
        
*========================================
* 1001- SUB
*========================================
code1001    LEA     DISP_SUB,A1
            MOVE.B  #14,D0
            TRAP    #15

            JSR     GET_OPMODE      
            LEA     SUB_TABLE,A1    * load table
            MULU    #6,D5           * offset
            JSR     0(A1,D5)        * jump
            RTS

SUB_TABLE   JMP     SUB000
            JMP     SUB001
            JMP     SUB010
            JMP     SUB011
            JMP     SUB100
            JMP     SUB101
            JMP     SUB110

*========================================
* SUB.B  <ea>,Dn
*========================================
SUB000      MOVE.B  #0,SIZE         * set SIZE to B  
            LEA     DISP_BYTE,A1    * display byte
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_TAB,A1     * display tab
            MOVE.B  #14,D0
            TRAP    #15
            
            JSR     GET_SRC         * ea
            LEA     DISP_COM,A1     * display comma
            MOVE.B  #14,D0
            TRAP    #15                
            LEA     DISP_DN,A1      * display D
            MOVE.B  #14,D0
            TRAP    #15
            JSR     GET_911         * get register
            JSR     DISP_REG
            RTS

*========================================
* SUB.W  <ea>,Dn
*========================================            
SUB001      MOVE.B  #1,SIZE         * set SIZE to W  
            LEA     DISP_WORD,A1    * display byte
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_TAB,A1     * display tab
            MOVE.B  #14,D0
            TRAP    #15
            
            JSR     GET_SRC         * ea
            LEA     DISP_COM,A1     * display comma
            MOVE.B  #14,D0
            TRAP    #15                
            LEA     DISP_DN,A1      * display D
            MOVE.B  #14,D0
            TRAP    #15
            JSR     GET_911         * get register
            JSR     DISP_REG
            RTS

*========================================
* SUB.L  <ea>,Dn
*========================================            
SUB010      MOVE.B  #2,SIZE         * set SIZE to L
            LEA     DISP_LONG,A1    * display byte
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_TAB,A1     * display tab
            MOVE.B  #14,D0
            TRAP    #15
            
            JSR     GET_SRC         * ea
            LEA     DISP_COM,A1     * display comma
            MOVE.B  #14,D0
            TRAP    #15                
            LEA     DISP_DN,A1      * display D
            MOVE.B  #14,D0
            TRAP    #15
            JSR     GET_911         * get register
            JSR     DISP_REG
            RTS

*========================================
* Unsupported
*========================================
SUB011      ; err
            RTS

*========================================
* SUB.B  Dn,<ea>
*========================================            
SUB100      MOVE.B  #0,SIZE         * set SIZE to W  
            LEA     DISP_BYTE,A1    * display byte
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_TAB,A1     * display tab
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     DISP_DN,A1      * display D
            MOVE.B  #14,D0
            TRAP    #15
            JSR     GET_911         * get register
            JSR     DISP_REG
            LEA     DISP_COM,A1     * display comma
            MOVE.B  #14,D0
            TRAP    #15
            JSR     GET_SRC         
            RTS

*========================================
* SUB.W  Dn,<ea>
*======================================== 
SUB101      MOVE.B  #1,SIZE         * set SIZE to W  
            LEA     DISP_WORD,A1    * display byte
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     DISP_TAB,A1     * display tab
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     DISP_DN,A1      * display D
            MOVE.B  #14,D0
            TRAP    #15
            JSR     GET_911         * get register
            JSR     DISP_REG
            LEA     DISP_COM,A1     * display comma
            MOVE.B  #14,D0
            TRAP    #15
            JSR     GET_SRC         
            RTS

*========================================
* SUB.L  Dn,<ea>
*======================================== 
SUB110      MOVE.B  #2,SIZE             * set SIZE to W  
            LEA     DISP_LONG,A1    * display byte
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_TAB,A1     * display tab
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     DISP_DN,A1      * display D
            MOVE.B  #14,D0
            TRAP    #15
            JSR     GET_911         * get register
            JSR     DISP_REG
            LEA     DISP_COM,A1     * display comma
            MOVE.B  #14,D0
            TRAP    #15
            JSR     GET_SRC         
            RTS
   
*========================================
* 1010- Unassigned
*========================================
code1010    RTS    

*========================================
* 1011- CMP
*========================================
code1011    LEA     DISP_CMP,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            JSR     GET_OPMODE
            
            LEA     CMP_TABLE,A2
            MULU    #6,D5           * offset
            JSR     0(A2,D5)        * jump
            
            ; not supported, go to err here
            RTS 

*========================================
* CMP table
*======================================== 
CMP_TABLE   JMP     CMP000
            JMP     CMP001
            JMP     CMP010          
  
*========================================
* 1011 CMP opmodes
*========================================              
CMP000      MOVE.B  #0,SIZE             * set SIZE to B  
            LEA     DISP_BYTE,A1        * print .B
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     DISP_TAB,A1         * print tab
            MOVE.B  #14,D0
            TRAP    #15
            
            JSR     GET_SRC             * decode ea
            LEA     DISP_COM,A1         * print comma
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_DN,A1          * print D
            MOVE.B  #14,D0
            TRAP    #15
            JSR     GET_911             * get register
            JSR     DISP_REG            * print register
            RTS
                                    
CMP001      MOVE.B  #1,SIZE             * set SIZE to W  
            LEA     DISP_WORD,A1        * print .W
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     DISP_TAB,A1         * print tab
            MOVE.B  #14,D0
            TRAP    #15

            JSR     GET_SRC             * decode ea
            LEA     DISP_COM,A1         * print comma
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_DN,A1          * print D
            MOVE.B  #14,D0
            TRAP    #15
            JSR     GET_911             * get register
            JSR     DISP_REG            * print register
            RTS

CMP010      MOVE.B  #2,SIZE             * set SIZE to L  
            LEA     DISP_LONG,A1        * print .L
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     DISP_TAB,A1         * print tab
            MOVE.B  #14,D0
            TRAP    #15

            JSR     GET_SRC             * decode ea
            LEA     DISP_COM,A1         * print comma
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_DN,A1          * print D
            MOVE.B  #14,D0
            TRAP    #15
            JSR     GET_911             * get register
            JSR     DISP_REG            * print register
            RTS
               
*========================================
* 1100- AND/MULS
*======================================== 
code1100    JSR     GET_OPMODE          * get opmode
            LEA     TWELVE_TABLE,A2     * load opmode table
            MULU    #6,D5               * offset mode
            JSR     0(A2,D5)            * jump
            RTS
            
*========================================
* 1100- AND/MULS.W table
*======================================== 
TWELVE_TABLE
            JMP     TWE000
            JMP     TWE001
            JMP     TWE010
            JMP     TWE011
            JMP     TWE100
            JMP     TWE101
            JMP     TWE110
            JMP     TWE111
               
*========================================
* AND.B  <ea>^Dn
*======================================== 
TWE000      MOVE.B  #0,SIZE             * set SIZE to B  
            LEA     DISP_AND,A1         * print AND
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_BYTE,A1        * print B
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_TAB,A1         * print tab
            MOVE.B  #14,D0
            TRAP    #15
            JSR     GET_SRC             * decode ea
            LEA     DISP_COM,A1         * print comma
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_DN,A1          * print D
            MOVE.B  #14,D0
            TRAP    #15
            JSR     GET_911             * get register
            JSR     DISP_REG            * print register
            RTS

*========================================
* AND.W  <ea>^Dn
*========================================             
TWE001      MOVE.B  #1,SIZE             * set SIZE to W  
            LEA     DISP_AND,A1         * print AND
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_WORD,A1        * print W
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_TAB,A1         * print tab
            MOVE.B  #14,D0
            TRAP    #15
            JSR     GET_SRC             * decode ea
            LEA     DISP_COM,A1         * print comma
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_DN,A1          * print D
            MOVE.B  #14,D0
            TRAP    #15
            JSR     GET_911             * get register
            JSR     DISP_REG            * print register
            RTS

*========================================
* AND.L  <ea>^Dn
*========================================             
TWE010      MOVE.B  #2,SIZE             * set SIZE to L  
            LEA     DISP_AND,A1         * print AND
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_LONG,A1        * print L
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_TAB,A1         * print tab
            MOVE.B  #14,D0
            TRAP    #15
            JSR     GET_SRC             * decode ea
            LEA     DISP_COM,A1         * print comma
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_DN,A1          * print D
            MOVE.B  #14,D0
            TRAP    #15
            JSR     GET_911             * get register
            JSR     DISP_REG            * print register
            RTS
            
*========================================
* Not supported
*========================================             
TWE011      ;err
            RTS

*========================================
* AND.B  Dn^<ea>
*========================================             
TWE100      MOVE.B  #0,SIZE             * set SIZE to B  
            LEA     DISP_AND,A1         * print AND
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_BYTE,A1        * print B
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_TAB,A1         * print tab
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_DN,A1          * print D
            MOVE.B  #14,D0
            TRAP    #15
            JSR     GET_911             * get register
            JSR     DISP_REG            * print register
            LEA     DISP_COM,A1         * print comma
            MOVE.B  #14,D0              
            TRAP    #15
            JSR     GET_SRC             * decode ea
            RTS

*========================================
* AND.W  Dn^<ea>
*========================================             
TWE101      MOVE.B  #1,SIZE             * set SIZE to W  
            LEA     DISP_AND,A1         * print AND
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_WORD,A1        * print W
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_TAB,A1         * print tab
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_DN,A1          * print D
            MOVE.B  #14,D0
            TRAP    #15
            JSR     GET_911             * get register
            JSR     DISP_REG            * print register
            LEA     DISP_COM,A1         * print comma
            MOVE.B  #14,D0
            TRAP    #15
            JSR     GET_SRC             * decode ea
            RTS

*========================================
* AND.L  Dn^<ea>
*========================================             
TWE110      MOVE.B  #2,SIZE             * set SIZE to L  
            LEA     DISP_AND,A1         * print AND
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_LONG,A1        * print L
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_TAB,A1         * print tab
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_DN,A1          * print D
            MOVE.B  #14,D0
            TRAP    #15
            JSR     GET_911             * get register
            JSR     DISP_REG            * print register
            LEA     DISP_COM,A1         * print comma
            MOVE.B  #14,D0
            TRAP    #15
            JSR     GET_SRC             * decode ea
            RTS
 
*========================================
* MULS.W
*========================================            
TWE111      MOVE.B  #1,SIZE             * set SIZE to W  
            LEA     DISP_MULS,A1        * print MULS
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_WORD,A1        * print W
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_TAB,A1         * print tab
            MOVE.B  #14,D0
            TRAP    #15
            
            JSR     GET_SRC             * decode ea
            LEA     DISP_COM,A1         * print comma
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_DN,A1          * print D
            MOVE.B  #14,D0
            TRAP    #15
            JSR     GET_911             * get register
            JSR     DISP_REG            * print register
            RTS
               
*========================================
* 1101- ADD/ADDA
*========================================              
code1101    JSR     GET_OPMODE          * get opmode and store in D5
            LEA     THIRTEEN_TABLE,A2   * load table
            MULU    #6,D5               * offset opmode
            JSR     0(A2,D5)            * jump to table
            RTS           

*========================================
* 1101 Table ADD/ADDA
*========================================
THIRTEEN_TABLE   
            JMP     THI000
            JMP     THI001
            JMP     THI010
            JMP     THI011
            JMP     THI100
            JMP     THI101
            JMP     THI110
            JMP     THI111

*========================================
* ADD.B  <ea>,Dn
*======================================== 
THI000      MOVE.B  #0,SIZE             * set SIZE to B  
            LEA     DISP_ADD,A1         * print ADD
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_BYTE,A1        * print B
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_TAB,A1         * print tab
            MOVE.B  #14,D0
            TRAP    #15
            
            JSR     GET_SRC             * decode ea
            LEA     DISP_COM,A1         * print comma
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_DN,A1          * print D
            MOVE.B  #14,D0
            TRAP    #15
            JSR     GET_911             * get register
            JSR     DISP_REG            * print register
            RTS

*========================================
* ADD.W  <ea>,Dn
*========================================             
THI001      MOVE.B  #1,SIZE             * set SIZE to W 
            LEA     DISP_ADD,A1         * print add
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_WORD,A1        * print W
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_TAB,A1         * print tba
            MOVE.B  #14,D0
            TRAP    #15
            
            JSR     GET_SRC             * decode ea
            LEA     DISP_COM,A1         * decode comma
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_DN,A1          * decode D
            MOVE.B  #14,D0
            TRAP    #15
            JSR     GET_911             * get register
            JSR     DISP_REG            * print register
            RTS

*========================================
* ADD.L  <ea>,Dn
*========================================             
THI010      MOVE.B  #2,SIZE             * set SIZE to L  
            LEA     DISP_ADD,A1         * print ADD
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_LONG,A1        * print L
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_TAB,A1         * print tab
            MOVE.B  #14,D0
            TRAP    #15
            
            JSR     GET_SRC             * decode ea
            LEA     DISP_COM,A1         * print comma
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_DN,A1          * print D
            MOVE.B  #14,D0
            TRAP    #15
            JSR     GET_911             * get register
            JSR     DISP_REG            * print register
            RTS

*========================================
* ADDA.W  <ea>,An
*======================================== 
THI011      MOVE.B  #1,SIZE             * set SIZE to W
            LEA     DISP_ADDA,A1        * print ADDA
            MOVE.B  #14,D0             
            TRAP    #15
            LEA     DISP_WORD,A1        * print W
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_TAB,A1         * print tab
            MOVE.B  #14,D0
            TRAP    #15
            
            JSR     GET_SRC             * decode ea
            LEA     DISP_COM,A1         * print comma
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_AN,A1          * print A
            MOVE.B  #14,D0          
            TRAP    #15
            JSR     GET_911             * get register
            JSR     DISP_REG            * print register
            RTS
 
*========================================
* ADD.B  Dn,<ea>
*========================================           
THI100      LEA     DISP_ADD,A1         * print ADD
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_BYTE,A1        * print B
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_TAB,A1         * print tab
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     DISP_DN,A1          * print D
            MOVE.B  #14,D0
            TRAP    #15
            JSR     GET_911             * get register
            JSR     DISP_REG            * print register
            LEA     DISP_COM,A1         * print comma
            MOVE.B  #14,D0      
            TRAP    #15
            JSR     GET_SRC             * decode ea
            RTS

*========================================
* ADD.W  Dn,<ea>
*========================================              
THI101      LEA     DISP_ADD,A1         * print ADD
            MOVE.B  #14,D0              
            TRAP    #15 
            LEA     DISP_WORD,A1        * print W
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_TAB,A1         * print tab
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     DISP_DN,A1          * print D
            MOVE.B  #14,D0
            TRAP    #15
            JSR     GET_911             * get register
            JSR     DISP_REG            * print register
            LEA     DISP_COM,A1         * print comma
            MOVE.B  #14,D0
            TRAP    #15
            JSR     GET_SRC             * decode ea
            RTS

*========================================
* ADD.L  Dn,<ea>
*========================================              
THI110      LEA     DISP_ADD,A1         * print ADD
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_LONG,A1        * print L
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_TAB,A1         * print tab
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     DISP_DN,A1          * print D
            MOVE.B  #14,D0
            TRAP    #15
            JSR     GET_911             * get register
            JSR     DISP_REG            * print register
            LEA     DISP_COM,A1         * print comma
            MOVE.B  #14,D0
            TRAP    #15
            JSR     GET_SRC             * decode ea
            RTS

*========================================
* ADDA.L  <ea>,An
*========================================              
THI111      LEA     DISP_ADDA,A1        * print ADDA
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_LONG,A1        * print L
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_TAB,A1         * print tab
            MOVE.B  #14,D0
            TRAP    #15
            
            JSR     GET_SRC             * decode ea
            LEA     DISP_COM,A1         * print comma
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_AN,A1          * print A
            MOVE.B  #14,D0
            TRAP    #15
            JSR     GET_911             * get register
            JSR     DISP_REG            * print register
            RTS

*========================================
* 1110- LSL/LSR/ASR/ASL/ROL/ROR
*========================================
code1110    JSR     GET_SIZE            * get bits 6-7
            CMPI.B  #%11,D5             * if 11 it is a memory shift
            BEQ     MEM_SHIFT
                                        * register shift
            JSR     SHIFT_TYPE          * get register shift type from bits 3-4
            CMPI.B  #%00,D5             * ASd
            BEQ     REG_ASD
            CMPI.B  #%01,D5             * LSd
            BEQ     REG_LSD
            CMPI.B  #%11,D5             * ROd
            BEQ     REG_ROD
            ; err check
            
*========================================
* Decode for register shift/rotate
*========================================             
REG_SHIFT   JSR     REG_SHIFT_TYPE      * register shift type
            LEA     REG_TABLE,A2        * load register shift table
            MULU    #6,D5               * offset
            JSR     0(A2,D5)            * jump
            RTS

REG_ASD     LEA     DISP_ASD,A1         * print AS
            MOVE.B  #14,D0
            TRAP    #15
            JSR     GET_D               * print direction
            JMP     REG_SHIFT           * decode next level 
            
REG_LSD     LEA     DISP_LSD,A1         * print LS
            MOVE.B  #14,D0
            TRAP    #15
            JSR     GET_D               * print direction
            JMP     REG_SHIFT           * decode next level
            
REG_ROD     LEA     DISP_ROD,A1         * print RO
            MOVE.B  #14,D0
            TRAP    #15
            JSR     GET_D               * print direction
            JMP     REG_SHIFT           * decode next level

REG_TABLE   JMP     REG000
            JMP     REG001
            JMP     REG010
            JMP     REG011
            JMP     REG100
            JMP     REG101

*========================================
* Byte immediate
*========================================
REG000      LEA     DISP_BYTE,A1        * print B
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_TAB,A1         * print tab
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_PS,A1          * print #
            MOVE.B  #14,D0
            TRAP    #15
            JSR     GET_911             * get shift count
            JSR     DISP_REG            * print register
            LEA     DISP_COM,A1         * print comma
            MOVE.B  #14,D0
            TRAP    #15
            JSR     SHIFT_02            * get register
            RTS

*========================================
* Byte register
*========================================
REG001      LEA     DISP_BYTE,A1        * print B
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_TAB,A1         * print tab
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_DN,A1          * print D
            MOVE.B  #14,D0
            TRAP    #15
            JSR     GET_911             * get shift register
            JSR     DISP_REG            * print shift register
            LEA     DISP_COM,A1         * print comma
            MOVE.B  #14,D0
            TRAP    #15
            JSR     SHIFT_02            * get register
            RTS

*========================================
* Word immediate
*========================================
REG010      LEA     DISP_WORD,A1        * print W
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_TAB,A1         * print tab
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_PS,A1          * print #
            MOVE.B  #14,D0
            TRAP    #15
            JSR     GET_911             * get shift count
            JSR     DISP_REG            * print register
            LEA     DISP_COM,A1         * print comma
            MOVE.B  #14,D0
            TRAP    #15
            JSR     SHIFT_02            * get register
            RTS

*========================================
* Word register
*========================================
REG011      LEA     DISP_WORD,A1        * print W
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_TAB,A1         * print tab
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_DN,A1          * print D
            MOVE.B  #14,D0
            TRAP    #15
            JSR     GET_911             * get shift register
            JSR     DISP_REG            * print shift register
            LEA     DISP_COM,A1         * print comma
            MOVE.B  #14,D0
            TRAP    #15
            JSR     SHIFT_02            * get register
            RTS

*========================================
* Long immediate
*========================================
REG100      LEA     DISP_LONG,A1        * print L
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_TAB,A1         * print tab
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_PS,A1          * print #
            MOVE.B  #14,D0
            TRAP    #15
            JSR     GET_911             * get shift count
            JSR     DISP_REG            * print register
            LEA     DISP_COM,A1         * print comma
            MOVE.B  #14,D0
            TRAP    #15
            JSR     SHIFT_02            * print register
            RTS

*========================================
* Long register
*========================================
REG101      LEA     DISP_LONG,A1        * print L
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_TAB,A1         * print tab
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_DN,A1          * print A
            JSR     GET_911             * get register
            JSR     DISP_REG            * print register
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_COM,A1         * print comma
            MOVE.B  #14,D0
            TRAP    #15
            JSR     SHIFT_02            * print register   
            RTS

*========================================
* Decode for memory shift/rotate
*========================================            
MEM_SHIFT   LEA     MEM_TABLE,A2        * load table
            JSR     MEM_SHIFT_TYPE      * shift type
            MULU    #6,D5               * offset
            JSR     0(A2,D5)            * jump
            RTS
            
MEM_TABLE   JMP     MEM000
            JMP     MEM001
            JMP     MEM011
            JMP     MEM100

*========================================
* ASd mem shift
*========================================
MEM000      LEA     DISP_ASd,A1         * print AS
            MOVE.B  #14,D0
            TRAP    #15
            JSR     GET_D               * print direction
            LEA     DISP_WORD,A1        * print W
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     DISP_TAB,A1         * print tab
            MOVE    #14,D0
            TRAP    #15            
            JSR     GET_SRC             * decode ea 
            RTS

*========================================
* LSd mem shift
*========================================
MEM001      LEA     DISP_LSd,A1         * print LS
            MOVE.B  #14,D0
            TRAP    #15
            JSR     GET_D               * print direction
            LEA     DISP_WORD,A1        * print W
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     DISP_TAB,A1         * print tab
            MOVE    #14,D0
            TRAP    #15            
            JSR     GET_SRC             * decode ea
            RTS

*========================================
* Not supported
*========================================
MEM011      ; err
            RTS

*========================================
* ROd mem shift
*========================================
MEM100      LEA     DISP_ROd,A1         * print RO
            MOVE.B  #14,D0
            TRAP    #15
            JSR     GET_D               * print direction
            LEA     DISP_TAB,A1         * print tab
            MOVE    #14,D0
            TRAP    #15            
            JSR     GET_SRC             * decode ea
            RTS
            
*========================================
* Get direction
*========================================
GET_D       MOVE.W  D3,D5               * move instruction
            LSL.W   #7,D5               * get bit 8
            LSR.W   #8,D5
            LSR.W   #7,D5
            CMPI.B  #%0,D5              * 0 right
            BEQ     RIGHT
            CMPI.B  #%1,D5              * 1 left
            BEQ     LEFT
            
RIGHT       LEA     DISP_R,A1           * print R
            MOVE.B  #14,D0
            TRAP    #15
            RTS
            
LEFT        LEA     DISP_L,A1           * print L
            MOVE.B  #14,D0
            TRAP    #15
            RTS      
            
*========================================
* 1111- Special/Reserved
*========================================
code1111    RTS

*========================================
* Gets the size from bits 6-7
*========================================
GET_SIZE    MOVE.B  D3,D5       * move instruction for shifting
            LSR.B   #6,D5       * move size to LSB
            RTS   

*========================================
* Gets the size from bit 6
*========================================
GET_SIZE_ONE
            MOVE.B  D3,D5       * move instruction for shifting
            LSL.B   #2,D5
            LSR.B   #7,D5       * move size to LSB
            RTS

;            END     START












*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
