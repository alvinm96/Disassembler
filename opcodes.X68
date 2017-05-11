*-------------------------------------------------------
* Decoding opcodes
* D3: Stores original instruction bits
* D5: Stores instruction bits for decoding
*
* A0: Jump table
* A2: Stores the string of the decoded instruction
*
* TODO: -Error handling
*       -code0000
*       -testing    
*-------------------------------------------------------

example EQU     %1101111001100001
shift   EQU     12
        ORG     $1000
        
START
        LEA     JMP_TABLE,A0
        CLR.L   D0
        MOVE.W  #example,D0
        MOVE.B  #shift,D1
        LSR.W   D1,D0
        MULU    #6,D0
        JSR     0(A0,D0)

*========================================
* Jump table
*========================================
JMP_TABLE   JMP     code0000    *Bit manipulation/MOVEP/Immediate
        JMP     code0001    *MOVE.B
        JMP     code0010    *MOVE.L
        JMP     code0011    *MOVE.W
        JMP     code0100    *MOVEM/CLR/LEA/DIVU.L/JSR/RTS
        JMP     code0101    *ADDQ/SUBQ
        JMP     code0110    *BSR/Bcc
        JMP     code0111    *MOVEQ
        JMP     code1000    *OR/DIV
        JMP     code1001    *SUB/SUBX
        JMP     code1010    *Unassigned
        JMP     code1011    *CMP
        JMP     code1100    *AND/MUL/ABCD/EXG
        JMP     code1101    *ADD/ADDA/ADDX
        JMP     code1110    *LSd/ASd/ROd
        JMP     code1111    *Special/Reserved

*========================================
* 0000- Bit manipulation/Immediate
*========================================
code0000       STOP        #$2700

*========================================
* 0001- MOVE.B
*========================================
code0001       MOVE.B  #'M',(A2)+  * load M
               MOVE.B  #'O',(A2)+  * load O
               MOVE.B  #'V',(A2)+  * load V
               MOVE.B  #'E',(A2)+  * load E
               MOVE.B  #'.',(A2)+  * load .
               MOVE.B  #'B',(A2)+  * load B
               MOVE.B  #' ',(A2)+  * load space
               MOVE.B  #' ',(A2)+  * load space
               ;decode ea
               
*========================================
* 0010- MOVE.L
*========================================            
code0010       MOVE.B  #'M',(A2)+  * load M
               MOVE.B  #'O',(A2)+  * load O
               MOVE.B  #'V',(A2)+  * load V
               MOVE.B  #'E',(A2)+  * load E
               MOVE.B  #'.',(A2)+  * load .
               MOVE.B  #'L',(A2)+  * load L
               MOVE.B  #' ',(A2)+  * load space
               MOVE.B  #' ',(A2)+  * load space
               ;decode ea
               
*========================================
* 0011- MOVE.W
*========================================               
code0011       MOVE.B  #'M',(A2)+  * load M
               MOVE.B  #'O',(A2)+  * load O
               MOVE.B  #'V',(A2)+  * load V
               MOVE.B  #'E',(A2)+  * load E
               MOVE.B  #'.',(A2)+  * load .
               MOVE.B  #'W',(A2)+  * load W
               MOVE.B  #' ',(A2)+  * load space
               MOVE.B  #' ',(A2)+  * load space
               ;decode ea
               
*========================================
* 0100- MOVEM/CLR/LEA/DIVU.L/JSR/RTS
*========================================      
code0100       LEA     FOUR_TABLE,A0 *load table
               CLR.L   D5       * clear register
               MOVE.W  D3,D5    * move instruction
               LSL.W   #4,D5    * remove left 4 bits
               LSR.W   #8,D5   * gets bits
               LSR.W   #4,D5   * gets bits
               MULU    #6,D5    * form offset
               JSR     0(A0,D5) * decode next level
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
four0000       STOP        #$2700

*========================================
* LEA <ea>,A0
*========================================
four0001       MOVE.B  #'L',(A2)+  * load L
               MOVE.B  #'E',(A2)+  * load E
               MOVE.B  #'A',(A2)+  * load A
               MOVE.B  #' ',(A2)+  * load space
               MOVE.B  #' ',(A2)+  * load space
               ; decode ea        
*========================================
* CLR <ea>
*========================================            
four0010       MOVE.B  #'C',(A2)+  * load C
               MOVE.B  #'L',(A2)+  * load L
               MOVE.B  #'R',(A2)+  * load R
               MOVE.B  #' ',(A2)+  * load space
               MOVE.B  #' ',(A2)+  * load space
               ; decode ea
               
*========================================
* LEA <ea>,A1
*========================================               
four0011       MOVE.B  #'L',(A2)+  * load L
               MOVE.B  #'E',(A2)+  * load E
               MOVE.B  #'A',(A2)+  * load A
               MOVE.B  #' ',(A2)+  * load space
               MOVE.B  #' ',(A2)+  * load space
               ;decode ea
               
*========================================
* Not used
*========================================      
four0100       STOP        #$2700

*========================================
* LEA <ea>,A2
*========================================
four0101       MOVE.B  #'L',(A2)+  * load L
               MOVE.B  #'E',(A2)+  * load E
               MOVE.B  #'A',(A2)+  * load A
               ;decode ea
               
*========================================
* Not used
*========================================
four0110       STOP        #$2700

*========================================
* LEA <ea>,A3
*========================================
four0111       MOVE.B  #'L',(A2)+  * load L
               MOVE.B  #'E',(A2)+  * load E
               MOVE.B  #'A',(A2)+  * load A
               MOVE.B  #' ',(A2)+  * load space
               MOVE.B  #' ',(A2)+  * load space
               ;decode ea
               
*========================================
* MOVEM- register to memory
*========================================
four1000       MOVE.B  #'M',(A2)+  * load M
               MOVE.B  #'O',(A2)+  * load O
               MOVE.B  #'V',(A2)+  * load V
               MOVE.B  #'E',(A2)+  * load E
               MOVE.B  #'M',(A2)+  * load M
               MOVE.B  #' ',(A2)+  * load space
               MOVE.B  #' ',(A2)+  * load space
               ;decode ea
               
*========================================
* LEA <ea>,A4
*========================================
four1001       MOVE.B  #'L',(A2)+  * load L
               MOVE.B  #'E',(A2)+  * load E
               MOVE.B  #'A',(A2)+  * load A
               MOVE.B  #' ',(A2)+  * load space
               MOVE.B  #' ',(A2)+  * load space
               ;decode ea
               
*========================================
* Not used
*========================================
four1010       STOP        #$2700

*========================================
* LEA <ea>,A5
*========================================
four1011       MOVE.B  #'L',(A2)+  * load L
               MOVE.B  #'E',(A2)+  * load E
               MOVE.B  #'A',(A2)+  * load A
               MOVE.B  #' ',(A2)+  * load space
               MOVE.B  #' ',(A2)+  * load space
               ;decode ea
               
*========================================
* MOVEM- memory to register/DIVU.L
*========================================
four1100       LSL.W   #8,D3   * shift to cancel out first left byte
               LSR.W   #8,D3   * shift to get 2 bits
               LSR.W   #6,D3
               CMPI.B  #01,D3
               BEQ     DEC_DIVU * skip to divu.l
               MOVE.B  #'M',(A2)+  * load M
               MOVE.B  #'O',(A2)+  * load O
               MOVE.B  #'V',(A2)+  * load V
               MOVE.B  #'E',(A2)+  * load E
               MOVE.B  #'M',(A2)+  * load M
               MOVE.B  #' ',(A2)+  * load space
               MOVE.B  #' ',(A2)+  * load space
               ;decode ea
               
DEC_DIVU       MOVE.B  #'D',(A2)+  * load D
               MOVE.B  #'I',(A2)+  * load I
               MOVE.B  #'V',(A2)+  * load V
               MOVE.B  #'U',(A2)+  * load U                     
               MOVE.B  #'.',(A2)+  * load .
               MOVE.B  #'L',(A2)+  * load L
               MOVE.B  #' ',(A2)+  * load space
               MOVE.B  #' ',(A2)+  * load space
               ;decode ea
               RTS
               
*========================================
* LEA <ea>,A6
*========================================
four1101       MOVE.B  #'L',(A2)+  * load L
               MOVE.B  #'E',(A2)+  * load E
               MOVE.B  #'A',(A2)+  * load A
               MOVE.B  #' ',(A2)+  * load space
               MOVE.B  #' ',(A2)+  * load space
               ;decode ea
               
*========================================
* JSR/RTS
*========================================
four1110       CMPI.W  #$4E75,D3   * RTS
               BEQ     DEC_RTS
               MOVE.B  #'J',(A2)+  * load J
               MOVE.B  #'S',(A2)+  * load S
               MOVE.B  #'R',(A2)+  * load R
               MOVE.B  #' ',(A2)+  * load space
               MOVE.B  #' ',(A2)+  * load space
               ; find ea
               RTS

DEC_RTS        MOVE.B  #'R',(A2)+  * load R
               MOVE.B  #'T',(A2)+  * load T
               MOVE.B  #'S',(A2)+  * load S
               RTS
*========================================
* LEA <ea>,A7
*========================================
four1111       MOVE.B  #'L',(A2)+  * load L
               MOVE.B  #'E',(A2)+  * load E
               MOVE.B  #'A',(A2)+  * load A
               MOVE.B  #' ',(A2)+  * load space
               MOVE.B  #' ',(A2)+  * load space
               ;decode ea
               

*========================================
* 0101- SUBQ
*========================================
code0101       MOVE.B  #'S',(A2)+  * load S
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
               
*========================================
* 0110- Bcc <label>
*========================================
code0110       STOP        #$2700

*========================================
* 0111- MOVEQ
*========================================
code0111       MOVE.B  #'M',(A2)+  * load M
               MOVE.B  #'O',(A2)+  * load O
               MOVE.B  #'V',(A2)+  * load V
               MOVE.B  #'E',(A2)+  * load E
               MOVE.B  #'Q',(A2)+  * load Q
               MOVE.B  #' ',(A2)+  * load space
               MOVE.B  #' ',(A2)+  * load space
               ; decode ea
               
*========================================
* 1000- OR/DIVU.W
*========================================
code1000       MOVE.W  D3,D5    * move instruction
               LSL.W   #7,D5    * isolate bits 6-8
               LSR.W   #8,D5
               LSR.W   #5,D5
               CMPI.B  #$2,D5
               BEQ     DEC_DIVUW
               MOVE.B  #'O',(A2)+   * load O
               MOVE.B  #'R',(A2)+   * load R
               MOVE.B  #' ',(A2)+   * load space
               MOVE.B  #' ',(A2)+   * load space
               ; decode ea
               
DEC_DIVUW      MOVE.B  #'D',(A2)+   * load D
               MOVE.B  #'I',(A2)+   * load I
               MOVE.B  #'V',(A2)+   * load V
               MOVE.B  #'U',(A2)+   * load U
               MOVE.B  #'.',(A2)+   * load .
               MOVE.B  #'W',(A2)+   * load W
               MOVE.B  #' ',(A2)+   * load space
               MOVE.B  #' ',(A2)+   * load space
               ; decode ea
               
*========================================
* 1001- SUB
*========================================
code1001       MOVE.B  #'S',(A2)+   * load S
               MOVE.B  #'U',(A2)+   * load U
               MOVE.B  #'B',(A2)+   * load B
               ; decode ea
               
*========================================
* 1010- Unassigned
*========================================
code1010       STOP        #$2700      

*========================================
* 1011- CMP
*========================================
code1011       LEA     ELE_TABLE,A0 *load table
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
               
               ; not supported, go to err

*========================================
* 1011 Jump table
* CMP
*========================================              
ELE_TABLE     
        JMP    ele000
        JMP    ele001
        JMP    ele010

ele000         MOVE.B  #'C',(A2)+   * load C
               MOVE.B  #'M',(A2)+   * load M
               MOVE.B  #'P',(A2)+   * load P
               MOVE.B  #'.',(A2)+   * load .
               MOVE.B  #'B',(A2)+   * load B
               ; decode ea
               RTS
                              
ele001         MOVE.B  #'C',(A2)+   * load C
               MOVE.B  #'M',(A2)+   * load M
               MOVE.B  #'P',(A2)+   * load P
               MOVE.B  #'.',(A2)+   * load .
               MOVE.B  #'W',(A2)+   * load W
               ; decode ea
               RTS

ele010         MOVE.B  #'C',(A2)+   * load C
               MOVE.B  #'M',(A2)+   * load M
               MOVE.B  #'P',(A2)+   * load P
               MOVE.B  #'.',(A2)+   * load .
               MOVE.B  #'L',(A2)+   * load L
               ; decode ea
               RTS
               
*========================================
* 1100- AND/MULS
*======================================== 
code1100       CLR     D5      * clear register
               MOVE.W  D3,D5   * move instruction
               LSL.W   #8,D5   * shift to cancel out first left byte
               LSR.W   #8,D5   * shift to get 2 bits
               LSR.W   #6,D5
               CMPI.B  #$3,D5  * MULS
               BEQ     DEC_MULS
               
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
               
AND_B          MOVE.B  #'B',(A2)+   * load B
               MOVE.B  #' ',(A2)+   * load space
               MOVE.B  #' ',(A2)+   * load space
               ; decode ea
               RTS
               
AND_W          MOVE.B  #'W',(A2)+   * load W
               MOVE.B  #' ',(A2)+   * load space
               MOVE.B  #' ',(A2)+   * load space
               ; decode ea
               RTS
               
AND_L          MOVE.B  #'L',(A2)+   * load L
               MOVE.B  #' ',(A2)+   * load space
               MOVE.B  #' ',(A2)+   * load space
               ; decode ea
               RTS                               
               
DEC_MULS       MOVE.B  #'M',(A2)+   * load M
               MOVE.B  #'U',(A2)+   * load U
               MOVE.B  #'L',(A2)+   * load L
               MOVE.B  #'S',(A2)+   * load S
               MOVE.B  #'.',(A2)+   * load .
               MOVE.B  #' ',(A2)+   * load space
               MOVE.B  #' ',(A2)+   * load space
               RTS
               
*========================================
* 1101- ADD/ADDA
*========================================              
code1101       MOVE.B  #'A',(A2)+   * load A
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
               
ADD_B          MOVE.B  #'.',(A2)+   * load .
               MOVE.B  #'B',(A2)+   * load B
               MOVE.B  #' ',(A2)+   * load space
               MOVE.B  #' ',(A2)+   * load space
               ; decode ea
               RTS
               
ADD_W          MOVE.B  #'.',(A2)+   * load .
               MOVE.B  #'W',(A2)+   * load W
               MOVE.B  #' ',(A2)+   * load space
               MOVE.B  #' ',(A2)+   * load space
               ; decode ea
               RTS
               
ADD_L          MOVE.B  #'.',(A2)+   * load .
               MOVE.B  #'L',(A2)+   * load L
               MOVE.B  #' ',(A2)+   * load space
               MOVE.B  #' ',(A2)+   * load space
               ; decode ea
               RTS
               
ADDA_W         MOVE.B  #'A',(A2)+   * load A
               MOVE.B  #'.',(A2)+   * load .
               MOVE.B  #'W',(A2)+   * load B
               MOVE.B  #' ',(A2)+   * load space
               MOVE.B  #' ',(A2)+   * load space
               ; decode ea
               RTS
               
ADDA_L         MOVE.B  #'A',(A2)+   * load A
               MOVE.B  #'.',(A2)+   * load .
               MOVE.B  #'L',(A2)+   * load L
               MOVE.B  #' ',(A2)+   * load space
               MOVE.B  #' ',(A2)+   * load space
               ; decode ea
               RTS

*========================================
* 1110- LSL/LSR/ASR/ASL/ROL/ROR
*========================================
code1110       LSL.W   #8,D5        * isolate bits 6-7
               LSR.W   #8,D5
               LSR.W   #6,D5
               CMPI.B  #$3,D5       * is a memory shift/rotate
               BEQ     MEM_SHIFT   
               ; register shift
               
MEM_SHIFT      CLR     D5
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

*========================================
* LSR memory shift
*========================================
MS_LSR         MOVE.B  #'L',(A2)+
               MOVE.B  #'S',(A2)+
               MOVE.B  #'R',(A2)+
               MOVE.B  #' ',(A2)+
               MOVE.B  #' ',(A2)+
               ; decode ea
               RTS

*========================================
* LSL memory shift
*========================================               
MS_LSL         MOVE.B  #'L',(A2)+
               MOVE.B  #'S',(A2)+
               MOVE.B  #'L',(A2)+
               MOVE.B  #' ',(A2)+
               MOVE.B  #' ',(A2)+
               ; decode ea
               RTS
             
*========================================
* ASR memory shift
*========================================  
MS_ASR         MOVE.B  #'A',(A2)+
               MOVE.B  #'S',(A2)+
               MOVE.B  #'R',(A2)+
               MOVE.B  #' ',(A2)+
               MOVE.B  #' ',(A2)+
               ; decode ea
               RTS

*========================================
* ASL memory shift
*========================================               
MS_ASL         MOVE.B  #'A',(A2)+
               MOVE.B  #'S',(A2)+
               MOVE.B  #'L',(A2)+
               MOVE.B  #' ',(A2)+
               MOVE.B  #' ',(A2)+
               ; decode ea
               RTS
               
*========================================
* ROR memory shift
*========================================               
MS_ROR         MOVE.B  #'R',(A2)+
               MOVE.B  #'O',(A2)+
               MOVE.B  #'R',(A2)+
               MOVE.B  #' ',(A2)+
               MOVE.B  #' ',(A2)+
               ; decode ea
               RTS

*========================================
* ROL memory shift
*========================================               
MS_ROL         MOVE.B  #'R',(A2)+
               MOVE.B  #'O',(A2)+
               MOVE.B  #'L',(A2)+
               MOVE.B  #' ',(A2)+
               MOVE.B  #' ',(A2)+
               ; decode ea
               RTS

*========================================
* 1111- Special/Reserved
*========================================
code1111

GET_SIZE
        MOVE.B  D3,D5       * move instruction for shifting
        LSR.B   #6,D5       * move size to LSB
        RTS

    END     START

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
