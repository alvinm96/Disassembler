*-------------------------------------------------------
* Decoding opcodes
* D3: DO NOT CHANGE. Stores original instruction bits. 
* D5: Temp stores instruction bits for decoding
*
* A0: Jump table
* A2: Stores the string of the decoded instruction
*
* TODO: -register shift
*       -Error handling
*       -code0000
*       -testing
*       -fix 0101    
*-------------------------------------------------------
example     EQU     %0100001100000000

            ORG     $400        

START:
            MOVE.W  #example,D3 ; move instruction
            MOVE.L  #12,D2      ; move shift num
            MOVE.W  D3,D5       ; move to d5 to decode
            
            LSR.L   D2,D5       ; shift temp
            MULU    #6,D5       ; multiply temp
            LEA     JMP_TABLE,A0            
            JSR     00(A0,D5)
               
              
                 
*========================================
* Jump table
*========================================
JMP_TABLE   JMP     code0000
            JMP     code0001  
            JMP     code0010 
            JMP     code0011 
            JMP     code0100
            JMP     code0101
            JMP     code0110 
            JMP     code0111 
            JMP     code1000 
            JMP     code1001 
            JMP     code1010 
            JMP     code1011  
            JMP     code1100  
            JMP     code1101 
            JMP     code1110    
            JMP     code1111    


*========================================
* 0000- Bit manipulation/Immediate
*========================================
code0000       STOP        #$2700

*========================================
* 0001- MOVE.B
*========================================
code0001    MOVE.B  #'M',(A2)+  * load M
            MOVE.B  #'O',(A2)+  * load O
            MOVE.B  #'V',(A2)+  * load V
            MOVE.B  #'E',(A2)+  * load E
            MOVE.B  #'.',(A2)+  * load .
            MOVE.B  #'B',(A2)+  * load B
            MOVE.B  #' ',(A2)+  * load space
            MOVE.B  #' ',(A2)+  * load space
            ;decode ea
            STOP    #$2700

*========================================
* 0010- MOVE.L
*========================================            
code0010    MOVE.B  #'M',(A2)+  * load M
            MOVE.B  #'O',(A2)+  * load O
            MOVE.B  #'V',(A2)+  * load V
            MOVE.B  #'E',(A2)+  * load E
            MOVE.B  #'.',(A2)+  * load .
            MOVE.B  #'L',(A2)+  * load L
            MOVE.B  #' ',(A2)+  * load space
            MOVE.B  #' ',(A2)+  * load space
            ;decode ea
            STOP    #$2700
            
*========================================
* 0011- MOVE.W
*========================================               
code0011    MOVE.B  #'M',(A2)+  * load M
            MOVE.B  #'O',(A2)+  * load O
            MOVE.B  #'V',(A2)+  * load V
            MOVE.B  #'E',(A2)+  * load E
            MOVE.B  #'.',(A2)+  * load .
            MOVE.B  #'W',(A2)+  * load W
            MOVE.B  #' ',(A2)+  * load space
            MOVE.B  #' ',(A2)+  * load space
            ;decode ea
            STOP    #$2700
            
*========================================
* 0100- MOVEM/CLR/LEA/DIVU.L/JSR/RTS
*========================================      
code0100    LEA     FOUR_TABLE,A0 *load table
            CLR.L   D5       * clear register
            MOVE.W  D3,D5    * move instruction
            LSL.W   #4,D5    * remove left 4 bits
            LSR.W   #8,D5   * gets bits
            LSR.W   #4,D5   * gets bits
            MULU    #6,D5    * form offset
            JSR     0(A0,D5) * decode next level
            
            STOP    #$2700
            
*========================================
* 0100 Jump table
* MOVEM/CLR/LEA/DIVU.L/JSR/RTS
*========================================
FOUR_TABLE
            JSR     four0000    *Not used
            JSR     four0001    *LEA <ea>,A0
            JSR     four0010    *CLR
            JSR     four0011    *LEA <ea>,A1
            JSR     four0100    *Not used
            JSR     four0101    *LEA <ea>,A2
            JSR     four0110    *Not used
            JSR     four0111    *LEA <ea>,A3
            JSR     four1000    *MOVEM- register to memory
            JSR     four1001    *LEA <ea>,A4
            JSR     four1010    *Not used
            JSR     four1011    *LEA <ea>,A5
            JSR     four1100    *MOVEM- memory to register/DIVU.L/MULS.L
            JSR     four1101    *LEA <ea>,A6
            JSR     four1110    *JSR/RTS
            JSR     four1111    *LEA <ea>,A7

*========================================
* Not used
*========================================
four0000    STOP        #$2700

*========================================
* LEA <ea>,A0
*========================================
four0001    MOVE.B  #'L',(A2)+  * load L
            MOVE.B  #'E',(A2)+  * load E
            MOVE.B  #'A',(A2)+  * load A
            MOVE.B  #' ',(A2)+  * load space
            MOVE.B  #' ',(A2)+  * load space
            ; decode ea
            STOP    #$2700
        
*========================================
* CLR <ea>
*========================================            
four0010    MOVE.B  #'C',(A2)+  * load C
            MOVE.B  #'L',(A2)+  * load L
            MOVE.B  #'R',(A2)+  * load R
            MOVE.B  #' ',(A2)+  * load space
            MOVE.B  #' ',(A2)+  * load space
            ; decode ea
            STOP    #$2700
   
*========================================
* LEA <ea>,A1
*========================================               
four0011    MOVE.B  #'L',(A2)+  * load L
            MOVE.B  #'E',(A2)+  * load E
            MOVE.B  #'A',(A2)+  * load A
            MOVE.B  #' ',(A2)+  * load space
            MOVE.B  #' ',(A2)+  * load space
            ;decode ea
            STOP    #$2700
   
*========================================
* Not used
*========================================      
four0100    STOP        #$2700

*========================================
* LEA <ea>,A2
*========================================
four0101    MOVE.B  #'L',(A2)+  * load L
            MOVE.B  #'E',(A2)+  * load E
            MOVE.B  #'A',(A2)+  * load A
            ;decode ea
            STOP    #$2700
   
*========================================
* Not used
*========================================
four0110    STOP        #$2700

*========================================
* LEA <ea>,A3
*========================================
four0111    MOVE.B  #'L',(A2)+  * load L
            MOVE.B  #'E',(A2)+  * load E
            MOVE.B  #'A',(A2)+  * load A
            MOVE.B  #' ',(A2)+  * load space
            MOVE.B  #' ',(A2)+  * load space
            ;decode ea
            STOP    #$2700
   
*========================================
* MOVEM- register to memory
*========================================
four1000    MOVE.B  #'M',(A2)+  * load M
            MOVE.B  #'O',(A2)+  * load O
            MOVE.B  #'V',(A2)+  * load V
            MOVE.B  #'E',(A2)+  * load E
            MOVE.B  #'M',(A2)+  * load M
            MOVE.B  #' ',(A2)+  * load space
            MOVE.B  #' ',(A2)+  * load space
            ;decode ea
            STOP    #$2700
   
*========================================
* LEA <ea>,A4
*========================================
four1001    MOVE.B  #'L',(A2)+  * load L
            MOVE.B  #'E',(A2)+  * load E
            MOVE.B  #'A',(A2)+  * load A
            MOVE.B  #' ',(A2)+  * load space
            MOVE.B  #' ',(A2)+  * load space
            ;decode ea
            STOP    #$2700
   
*========================================
* Not used
*========================================
four1010    STOP        #$2700

*========================================
* LEA <ea>,A5
*========================================
four1011    MOVE.B  #'L',(A2)+  * load L
            MOVE.B  #'E',(A2)+  * load E
            MOVE.B  #'A',(A2)+  * load A
            MOVE.B  #' ',(A2)+  * load space
            MOVE.B  #' ',(A2)+  * load space
            ;decode ea
            STOP    #$2700
   
*========================================
* MOVEM- memory to register/DIVU.L
*========================================
four1100    CLR.L   D5       * clear register
            MOVE.W  D3,D5    * move instruction
            LSL.W   #8,D5   * shift to cancel out first left byte
            LSR.W   #8,D5   * shift to get 2 bits
            LSR.W   #6,D5
            CMPI.B  #01,D5
            BEQ     DEC_DIVU * skip to divu.l
            ; err check
            STOP    #$2700
            
            MOVE.B  #'M',(A2)+  * load M
            MOVE.B  #'O',(A2)+  * load O
            MOVE.B  #'V',(A2)+  * load V
            MOVE.B  #'E',(A2)+  * load E
            MOVE.B  #'M',(A2)+  * load M
            MOVE.B  #' ',(A2)+  * load space
            MOVE.B  #' ',(A2)+  * load space
            ;decode ea
            STOP    #$2700
   
DEC_DIVU    MOVE.B  #'D',(A2)+  * load D
            MOVE.B  #'I',(A2)+  * load I
            MOVE.B  #'V',(A2)+  * load V
            MOVE.B  #'U',(A2)+  * load U                     
            MOVE.B  #'.',(A2)+  * load .
            MOVE.B  #'L',(A2)+  * load L
            MOVE.B  #' ',(A2)+  * load space
            MOVE.B  #' ',(A2)+  * load space
            ;decode ea
            STOP    #$2700
            
*========================================
* LEA <ea>,A6
*========================================
four1101    MOVE.B  #'L',(A2)+  * load L
            MOVE.B  #'E',(A2)+  * load E
            MOVE.B  #'A',(A2)+  * load A
            MOVE.B  #' ',(A2)+  * load space
            MOVE.B  #' ',(A2)+  * load space
            ;decode ea
            STOP    #$2700
   
*========================================
* JSR/RTS
*========================================
four1110    CMPI.W  #$4E75,D3   * RTS
            BEQ     DEC_RTS
            ; err check
            STOP    #$2700
            
            MOVE.B  #'J',(A2)+  * load J
            MOVE.B  #'S',(A2)+  * load S
            MOVE.B  #'R',(A2)+  * load R
            MOVE.B  #' ',(A2)+  * load space
            MOVE.B  #' ',(A2)+  * load space
            ; find ea
            STOP    #$2700

DEC_RTS     MOVE.B  #'R',(A2)+  * load R
            MOVE.B  #'T',(A2)+  * load T
            MOVE.B  #'S',(A2)+  * load S
            STOP    #$2700
            
*========================================
* LEA <ea>,A7
*========================================
four1111    MOVE.B  #'L',(A2)+  * load L
            MOVE.B  #'E',(A2)+  * load E
            MOVE.B  #'A',(A2)+  * load A
            MOVE.B  #' ',(A2)+  * load space
            MOVE.B  #' ',(A2)+  * load space
            ;decode ea
            STOP    #$2700   
            
*========================================
* 0101- SUBQ
* TODO: FIX
*========================================
code0101    MOVE.B  #'S',(A2)+  * load S
            MOVE.B  #'U',(A2)+  * load U
            MOVE.B  #'B',(A2)+  * load B
            MOVE.B  #'Q',(A2)+  * load Q
            MOVE.B  #'.',(A2)+  * load .
            JSR     GET_SIZE    * get size
            CMPI.B  #00,D5      * byte
            MOVE.B  #'B',(A2)+  * load B
            CMPI.B  #01,D5      * word
            MOVE.B  #'W',(A2)+  * load W
            CMPI.B  #10,D5      * long
            MOVE.B  #'L',(A2)+  * load L
            MOVE.B  #' ',(A2)+  * load space
            MOVE.B  #' ',(A2)+  * load space
            ; decode ea
            STOP    #$2700
   
*========================================
* 0110- Bcc <label>
*========================================
code0110    STOP    #$2700

*========================================
* 0111- MOVEQ
*========================================
code0111    MOVE.B  #'M',(A2)+  * load M
            MOVE.B  #'O',(A2)+  * load O
            MOVE.B  #'V',(A2)+  * load V
            MOVE.B  #'E',(A2)+  * load E
            MOVE.B  #'Q',(A2)+  * load Q
            MOVE.B  #' ',(A2)+  * load space
            MOVE.B  #' ',(A2)+  * load space
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
            
            MOVE.B  #'O',(A2)+   * load O
            MOVE.B  #'R',(A2)+   * load R
            MOVE.B  #' ',(A2)+   * load space
            MOVE.B  #' ',(A2)+   * load space
            ; decode ea
            STOP    #$2700
   
DEC_DIVUW   MOVE.B  #'D',(A2)+   * load D
            MOVE.B  #'I',(A2)+   * load I
            MOVE.B  #'V',(A2)+   * load V
            MOVE.B  #'U',(A2)+   * load U
            MOVE.B  #'.',(A2)+   * load .
            MOVE.B  #'W',(A2)+   * load W
            MOVE.B  #' ',(A2)+   * load space
            MOVE.B  #' ',(A2)+   * load space
            ; decode ea
            STOP    #$2700                
           
*========================================
* 1001- SUB
*========================================
code1001    MOVE.B  #'S',(A2)+   * load S
            MOVE.B  #'U',(A2)+   * load U
            MOVE.B  #'B',(A2)+   * load B
            ; decode ea
               
*========================================
* 1010- Unassigned
*========================================
code1010    STOP        #$2700      

*========================================
* 1011- CMP
*========================================
code1011    LEA     ELE_TABLE,A0 *load table
            CLR.L   D5
            MOVE.W  D3,D5     * move instruction
            LSL.W   #7,D5     * isolate bits 6-8
            LSR.W   #8,D5
            LSR.W   #5,D5
            MOVE.B  #'C',(A2)+   * load C
            MOVE.B  #'M',(A2)+   * load M
            MOVE.B  #'P',(A2)+   * load P
            
            CMPI.B  #$0,D5
            BEQ     ele000
            CMPI.B  #$1,D5
            BEQ     ele001
            CMPI.B  #$2,D5
            BEQ     ele010
            ; not supported, go to err here
            STOP    #$2700 
            
*========================================
* 1011 Jump table
* CMP
*========================================              
ELE_TABLE     
            JSR    ele000
            JSR    ele001
            JSR    ele010

ele000      MOVE.B  #'C',(A2)+   * load C
            MOVE.B  #'M',(A2)+   * load M
            MOVE.B  #'P',(A2)+   * load P
            MOVE.B  #'.',(A2)+   * load .
            MOVE.B  #'B',(A2)+   * load B
            ; decode ea
            STOP    #$2700
                              
ele001      MOVE.B  #'C',(A2)+   * load C
            MOVE.B  #'M',(A2)+   * load M
            MOVE.B  #'P',(A2)+   * load P
            MOVE.B  #'.',(A2)+   * load .
            MOVE.B  #'W',(A2)+   * load W
            ; decode ea
            STOP    #$2700

ele010      MOVE.B  #'C',(A2)+   * load C
            MOVE.B  #'M',(A2)+   * load M
            MOVE.B  #'P',(A2)+   * load P
            MOVE.B  #'.',(A2)+   * load .
            MOVE.B  #'L',(A2)+   * load L
            ; decode ea
            STOP    #$2700
               
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
   
            MOVE.B  #'A',(A2)+   * load A
            MOVE.B  #'N',(A2)+   * load N
            MOVE.B  #'D',(A2)+   * load D
            MOVE.B  #'.',(A2)+   * load .
            CMPI.B  #$0,D5
            BEQ     AND_B
            CMPI.B  #$1,D5
            BEQ     AND_W       
            CMPI.B  #$2,D5
            BEQ     AND_L
            ; err check, not b,w,l
            STOP    #$2700
               
AND_B       MOVE.B  #'B',(A2)+   * load B
            MOVE.B  #' ',(A2)+   * load space
            MOVE.B  #' ',(A2)+   * load space
            ; decode ea
            STOP    #$2700
             
AND_W       MOVE.B  #'W',(A2)+   * load W
            MOVE.B  #' ',(A2)+   * load space
            MOVE.B  #' ',(A2)+   * load space
            ; decode ea
            STOP    #$2700
               
AND_L       MOVE.B  #'L',(A2)+   * load L
            MOVE.B  #' ',(A2)+   * load space
            MOVE.B  #' ',(A2)+   * load space
            ; decode ea
            STOP    #$2700
               
DEC_MULS    MOVE.B  #'M',(A2)+   * load M
            MOVE.B  #'U',(A2)+   * load U
            MOVE.B  #'L',(A2)+   * load L
            MOVE.B  #'S',(A2)+   * load S
            MOVE.B  #'.',(A2)+   * load .
            MOVE.B  #' ',(A2)+   * load space
            MOVE.B  #' ',(A2)+   * load space
            STOP    #$2700
               
*========================================
* 1101- ADD/ADDA
*========================================              
code1101    MOVE.B  #'A',(A2)+   * load A
            MOVE.B  #'D',(A2)+   * load D
            MOVE.B  #'D',(A2)+   * load D
               
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
 
ADD_B       MOVE.B  #'.',(A2)+   * load .
            MOVE.B  #'B',(A2)+   * load B
            MOVE.B  #' ',(A2)+   * load space
            MOVE.B  #' ',(A2)+   * load space
            ; decode ea
            STOP    #$2700
               
ADD_W       MOVE.B  #'.',(A2)+   * load .
            MOVE.B  #'W',(A2)+   * load W
            MOVE.B  #' ',(A2)+   * load space
            MOVE.B  #' ',(A2)+   * load space
            ; decode ea
            STOP    #$2700
               
ADD_L       MOVE.B  #'.',(A2)+   * load .
            MOVE.B  #'L',(A2)+   * load L
            MOVE.B  #' ',(A2)+   * load space
            MOVE.B  #' ',(A2)+   * load space
            ; decode ea
            STOP    #$2700
               
ADDA_W      MOVE.B  #'A',(A2)+   * load A
            MOVE.B  #'.',(A2)+   * load .
            MOVE.B  #'W',(A2)+   * load B
            MOVE.B  #' ',(A2)+   * load space
            MOVE.B  #' ',(A2)+   * load space
            ; decode ea
            STOP    #$2700
               
ADDA_L      MOVE.B  #'A',(A2)+   * load A
            MOVE.B  #'.',(A2)+   * load .
            MOVE.B  #'L',(A2)+   * load L
            MOVE.B  #' ',(A2)+   * load space
            MOVE.B  #' ',(A2)+   * load space
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
MS_LSR      MOVE.B  #'L',(A2)+
            MOVE.B  #'S',(A2)+
            MOVE.B  #'R',(A2)+
            MOVE.B  #' ',(A2)+
            MOVE.B  #' ',(A2)+
            ; decode ea
            STOP    #$2700

*========================================
* LSL memory shift
*========================================               
MS_LSL      MOVE.B  #'L',(A2)+
            MOVE.B  #'S',(A2)+
            MOVE.B  #'L',(A2)+
            MOVE.B  #' ',(A2)+
            MOVE.B  #' ',(A2)+
            ; decode ea
            STOP    #$2700
             
*========================================
* ASR memory shift
*========================================  
MS_ASR      MOVE.B  #'A',(A2)+
            MOVE.B  #'S',(A2)+
            MOVE.B  #'R',(A2)+
            MOVE.B  #' ',(A2)+
            MOVE.B  #' ',(A2)+
            ; decode ea
            STOP    #$2700

*========================================
* ASL memory shift
*========================================               
MS_ASL      MOVE.B  #'A',(A2)+
            MOVE.B  #'S',(A2)+
            MOVE.B  #'L',(A2)+
            MOVE.B  #' ',(A2)+
            MOVE.B  #' ',(A2)+
            ; decode ea
            STOP    #$2700
               
*========================================
* ROR memory shift
*========================================               
MS_ROR      MOVE.B  #'R',(A2)+
            MOVE.B  #'O',(A2)+
            MOVE.B  #'R',(A2)+
            MOVE.B  #' ',(A2)+
            MOVE.B  #' ',(A2)+
            ; decode ea
            STOP    #$2700

*========================================
* ROL memory shift
*========================================               
MS_ROL      MOVE.B  #'R',(A2)+
            MOVE.B  #'O',(A2)+
            MOVE.B  #'L',(A2)+
            MOVE.B  #' ',(A2)+
            MOVE.B  #' ',(A2)+
            ; decode ea
            STOP    #$2700

*========================================
* 1111- Special/Reserved
*========================================
code1111    STOP    #$2700


GET_SIZE    MOVE.B  D3,D5       * move instruction for shifting
            LSR.B   #6,D5       * move size to LSB
            RTS   
            
            END     $400




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
