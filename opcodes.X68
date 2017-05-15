*-------------------------------------------------------
* Decoding opcodes
* D0: Trap task
* D3: DO NOT CHANGE. Stores original instruction bits. 
* D5: Temp stores instruction bits for decoding
*
* A0: Jump table
* A1: Stores the string of the decoded instruction

* TODO: -register shift
*       -Error handling
*       -code0000
*       -code0110
*       -testing  
*-------------------------------------------------------
;example     EQU     %0011101000001001
;example     EQU     %0100001000000101
;example     EQU     %0100001111111001
;example     EQU     %0100110010111000
example     EQU     %1011001000000000

            ORG     $1000

            INCLUDE 'display.X68'            
            INCLUDE 'ea.X68'
            
START:            

*========Loop through instructions here
         
            MOVE.W  #example,D3     ; move instruction
            MOVE.L  #12,D2          ; move shift num
            MOVE.W  D3,D5           ; move to d5 to decode
            
            LSR.L   D2,D5           ; shift temp
            MULU    #6,D5           ; multiply temp
            LEA     JMP_TABLE,A0    ; load table          
            JSR     00(A0,D5)       ; jump to table            

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
code0000    STOP    #$2700

*========================================
* 0001- MOVE.B
*========================================
code0001    LEA     DISP_MOVE,A1        * display MOVE
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_BYTE,A1        * display byte
            MOVE.B  #14,D0
            TRAP    #15
    
            LEA     DISP_TAB,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            JSR     GET_SRC             * decode ea
            LEA     DISP_COM,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            JSR     GET_DEST
            RTS
            
*========================================
* 0010- MOVE.L
*========================================            
code0010    LEA     DISP_MOVE,A1
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_LONG,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     DISP_TAB,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            JSR     GET_SRC             * decode ea
            LEA     DISP_COM,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            JSR     GET_DEST
            RTS
            
*========================================
* 0011- MOVE.W
*========================================               
code0011    LEA     DISP_MOVE,A1
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_WORD,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     DISP_TAB,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            JSR     GET_SRC             * decode ea
            LEA     DISP_COM,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            JSR     GET_DEST
            RTS
            
*========================================
* 0100- MOVEM/CLR/LEA/DIVU.L/JSR/RTS
*========================================      
code0100    LEA     FOUR_TABLE,A2 *load table
            CLR.L   D5       * clear register
            MOVE.W  D3,D5    * move instruction
            LSL.W   #4,D5    * remove left 4 bits
            LSR.W   #8,D5   * gets bits
            LSR.W   #4,D5   * gets bits
            MULU    #6,D5    * form offset
            JSR     0(A2,D5) * decode next level
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
four0000    STOP        #$2700

*========================================
* LEA <ea>,A0
*========================================
four0001    LEA     DISP_LEA,A1
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
            
            LEA     REG_0,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            RTS
        
*========================================
* CLR <ea>
*========================================            
four0010    LEA     DISP_CLR,A1
            MOVE.B  #14,D0
            TRAP    #15
            ; get size            
            
            LEA     DISP_TAB,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            JSR     GET_SRC
            RTS
      
*========================================
* LEA <ea>,A1
*========================================               
four0011    LEA     DISP_LEA,A1
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
            
            LEA     REG_1,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            RTS
   
*========================================
* Not used
*========================================      
four0100    STOP        #$2700

*========================================
* LEA <ea>,A2
*========================================
four0101    LEA     DISP_LEA,A1
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
            
            LEA     REG_2,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            RTS
   
*========================================
* Not used
*========================================
four0110    STOP        #$2700

*========================================
* LEA <ea>,A3
*========================================
four0111    LEA     DISP_LEA,A1
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
            
            LEA     REG_3,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            RTS
   
*========================================
* MOVEM- register to memory
*========================================
four1000    LEA     DISP_MOVEM,A1
            MOVE.B  #14,D0
            TRAP    #15
            ; get size
            
            JSR     GET_SRC
            RTS
   
*========================================
* LEA <ea>,A4
*========================================
four1001    LEA     DISP_LEA,A1
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
            
            LEA     REG_4,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            RTS
   
*========================================
* Not used
*========================================
four1010    STOP        #$2700

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
four1100    CLR.L   D5          * clear register
            MOVE.W  D3,D5       * move instruction
            LSL.W   #8,D5       * shift to cancel out first left byte
            LSR.W   #8,D5       * shift to get 2 bits
            LSR.W   #6,D5
            CMPI.B  #01,D5
            BEQ     DEC_DIVU    * skip to divu.l
            
            LEA     DISP_MOVEM,A1
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_TAB,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            JSR     GET_SRC
            RTS
   
DEC_DIVU    LEA     DISP_DIVU,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     DISP_LONG,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     DISP_TAB,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            JSR     GET_SRC
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
four1110    CMPI.W  #$4E75,D3   * RTS
            BEQ     DEC_RTS
            
            LEA     DISP_JSR,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     DISP_TAB,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            JSR     GET_SRC
            RTS

DEC_RTS     LEA     DISP_RTS,A1
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
            JSR     GET_SIZE    * get size
            CMPI.B  #00,D5      * byte
            BEQ     SUBQ_B
            CMPI.B  #01,D5      * word
            BEQ     SUBQ_W
            CMPI.B  #10,D5      * long
            BEQ     SUBQ_L        
            
            ; err check
            STOP    #$2700
   
SUBQ_B      LEA     DISP_BYTE,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     DISP_TAB,A1
            MOVE.B  #14,D0
            TRAP    #15            
            
            JSR     GET_SRC
            RTS
           
SUBQ_W      LEA     DISP_WORD,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     DISP_TAB,A1
            MOVE.B  #14,D0
            TRAP    #15            
            
            JSR     GET_SRC
            RTS
            
SUBQ_L      LEA     DISP_LONG,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     DISP_TAB,A1
            MOVE.B  #14,D0
            TRAP    #15            
            
            JSR     GET_SRC
            RTS
            
*========================================
* 0110- Bcc <label>
*========================================
code0110    STOP    #$2700

*========================================
* 0111- MOVEQ
*========================================
code0111    LEA     DISP_MOVEQ,A1
            MOVE.B  #14,D0
            TRAP    #15
            ; decode ea
            STOP    #$2700

*========================================
* 1000- OR/DIVU.W
*========================================
code1000    CLR     D5       * clear register
            MOVE.W  D3,D5    * move instruction
            LSL.W   #7,D5    * isolate bits 6-8
            LSR.W   #8,D5
            LSR.W   #5,D5
            CMPI.B  #$2,D5
            BEQ     DEC_DIVUW
            ; err check
            STOP    #$2700
            
            LEA     DISP_OR,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     DISP_TAB,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            JSR     GET_SRC
            RTS
            ;get register
   
DEC_DIVUW   LEA     DISP_DIVU,A1
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_WORD,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     DISP_TAB,A1
            MOVE.B  #14,D0
            TRAP    #15
                        
            ; get register
            
            JSR     GET_SRC
            RTS           
*========================================
* 1001- SUB
*========================================
code1001    LEA     DISP_SUB,A1
            MOVE.B  #14,D0
            TRAP    #15
            ; decode ea
               
*========================================
* 1010- Unassigned
*========================================
code1010    STOP        #$2700      

*========================================
* 1011- CMP
*========================================
code1011    CLR.L   D5
            MOVE.W  D3,D5     * move instruction
            LSL.W   #7,D5     * isolate bits 6-8
            LSR.W   #8,D5
            LSR.W   #5,D5
            
            LEA     DISP_CLR,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            CMPI.B  #$0,D5    * get opmode
            BEQ     ele000
            CMPI.B  #$1,D5
            BEQ     ele001
            CMPI.B  #$2,D5
            BEQ     ele010
            
            ; not supported, go to err here
            STOP    #$2700 
            
*========================================
* 1011 CMP opmodes
*========================================              
ele000      LEA     DISP_BYTE,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     DISP_TAB,A1
            MOVE.B  #14,D0
            TRAP    #15

            ; get register
            
            JSR     GET_SRC
            RTS
                              
ele001      LEA     DISP_WORD,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     DISP_TAB,A1
            MOVE.B  #14,D0
            TRAP    #15

            ; get register
            
            JSR     GET_SRC
            RTS

ele010      LEA     DISP_LONG,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     DISP_TAB,A1
            MOVE.B  #14,D0
            TRAP    #15

            ; get register
            
            JSR     GET_SRC
            RTS
               
*========================================
* 1100- AND/MULS
*======================================== 
code1100    CLR     D5      * clear register
            MOVE.W  D3,D5   * move instruction
            LSL.W   #8,D5   * shift to cancel out first left byte
            LSR.W   #8,D5   * shift to get 2 bits
            LSR.W   #6,D5
            CMPI.B  #$3,D5  * MULS
            BEQ     DEC_MULS
            STOP    #$2700
   
            LEA     DISP_AND,A1
            MOVE.B  #14,D0
            TRAP    #15
            CMPI.B  #$0,D5
            BEQ     AND_B
            CMPI.B  #$1,D5
            BEQ     AND_W       
            CMPI.B  #$2,D5
            BEQ     AND_L
            ; err check, not b,w,l
            STOP    #$2700
               
AND_B       LEA     DISP_BYTE,A1
            MOVE.B  #14,D0
            TRAP    #15
            ; decode ea
            STOP    #$2700
             
AND_W       LEA     DISP_WORD,A1
            MOVE.B  #14,D0
            TRAP    #15
            ; decode ea
            STOP    #$2700
               
AND_L       LEA     DISP_LONG,A1
            MOVE.B  #14,D0
            TRAP    #15
            ; decode ea
            STOP    #$2700
               
DEC_MULS    LEA     DISP_MULS,A1
            MOVE.B  #14,D0
            TRAP    #15
            STOP    #$2700
               
*========================================
* 1101- ADD/ADDA
*========================================              
code1101    CLR     D5
            MOVE.W  D3,D5
            LSL.W   #8,D5     * isolate bits 6-8
            LSR.W   #8,D5
            LSR.W   #6,D5
            CMPI.B  #$0,D5    * opmode x00
            BEQ     ADD_B
            CMPI.B  #$1,D5    * opmode x01
            BEQ     ADD_W
            CMPI.B  #$2,D5    * opmode x10
            BEQ     ADD_L
            CMPI.B  #$3,D5    * opmode 011
            BEQ     ADDA_W
            CMPI.B  #$7,D5    * opmode 111
            BEQ     ADDA_L
            ; err check
            STOP    #$2700            
 
ADD_B       LEA     DISP_ADD,A1
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_BYTE,A1
            MOVE.B  #14,D0
            TRAP    #15
            ; decode ea
            STOP    #$2700
               
ADD_W       LEA     DISP_ADD,A1
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_WORD,A1
            MOVE.B  #14,D0
            TRAP    #15
            ; decode ea
            STOP    #$2700
               
ADD_L       LEA     DISP_ADD,A1
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_LONG,A1
            MOVE.B  #14,D0
            TRAP    #15
            ; decode ea
            STOP    #$2700
               
ADDA_W      LEA     DISP_ADDA,A1
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_WORD,A1
            MOVE.B  #14,D0
            TRAP    #15
            ; decode ea
            STOP    #$2700
               
ADDA_L      LEA     DISP_ADDA,A1
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_LONG,A1
            MOVE.B  #14,D0
            TRAP    #15
            ; decode ea
            STOP    #$2700

*========================================
* 1110- LSL/LSR/ASR/ASL/ROL/ROR
*========================================
code1110    LSL.W   #8,D5        * isolate bits 6-7
            LSR.W   #8,D5
            LSR.W   #6,D5
            CMPI.B  #$3,D5       * is a memory shift/rotate
            BEQ     MEM_SHIFT   
            ; register shift
            STOP    #$2700
               
MEM_SHIFT   CLR     D5
            MOVE.W  D3,D5
            LSL.W   #4,D5
            LSR.W   #8,D5
            LSR.W   #4,D5
            CMPI.B  #$2,D5       * LSR
            BEQ     MS_LSR
            CMPI.B  #$3,D5       * LSL
            BEQ     MS_LSL
            CMPI.B  #$0,D5       * ASR
            BEQ     MS_ASR
            CMPI.B  #$1,D5       * ASL
            BEQ     MS_ASL
            CMPI.B  #$6,D5       * ROR
            BEQ     MS_ROR
            CMPI.B  #$7,D5       * ROL
            BEQ     MS_ROL
            ; err check
            STOP    #$2700               

*========================================
* LSR memory shift
*========================================
MS_LSR      LEA     DISP_LSR,A1
            MOVE.B  #14,D0
            TRAP    #15
            ; decode ea
            STOP    #$2700

*========================================
* LSL memory shift
*========================================               
MS_LSL      LEA     DISP_LSL,A1
            MOVE.B  #14,D0
            TRAP    #15
            ; decode ea
            STOP    #$2700
             
*========================================
* ASR memory shift
*========================================  
MS_ASR      LEA     DISP_ASR,A1
            MOVE.B  #14,D0
            TRAP    #15
            ; decode ea
            STOP    #$2700

*========================================
* ASL memory shift
*========================================               
MS_ASL      LEA     DISP_ASR,A1
            MOVE.B  #14,D0
            TRAP    #15
            ; decode ea
            STOP    #$2700
               
*========================================
* ROR memory shift
*========================================               
MS_ROR      LEA     DISP_ROR,A1
            MOVE.B  #14,D0
            TRAP    #15
            ; decode ea
            STOP    #$2700

*========================================
* ROL memory shift
*========================================               
MS_ROL      LEA     DISP_ROL,A1
            MOVE.B  #14,D0
            TRAP    #15
            ; decode ea
            STOP    #$2700
                
*========================================
* 1111- Special/Reserved
*========================================
code1111    STOP    #$2700


GET_SIZE    MOVE.B  D3,D5       * move instruction for shifting
            LSR.B   #6,D5       * move size to LSB
            RTS   
            
            END     START




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
