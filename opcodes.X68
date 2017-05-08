GET_SIZE
        MOVE.B  D3,D5       * move instruction for shifting
        LSR.B   #6,D5       * move size to LSB
        RTS

*========================================
* Jump table
*========================================
JMP_TABLE
        JMP     code0000    *Bit manipulation/MOVEP/Immediate
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
        JMP     code1110    *Shift/Rotate
        JMP     code1111    *Special/Reserved

*========================================
* Jump table
*========================================
code0000       STOP        #$2700

*========================================
* MOVE.B
*========================================
code0001       MOVE.B  #'M',(A2)+  * load M
               MOVE.B  #'O',(A2)+  * load O
               MOVE.B  #'V',(A2)+  * load V
               MOVE.B  #'E',(A2)+  * load E
               MOVE.B  #'.',(A2)+  * load .
               MOVE.B  #'B',(A2)+  * load B
               MOVE.B  #' ',(A2)+  * load space
               MOVE.B  #' ',(A2)+  * load space
               
*========================================
* MOVE.L
*========================================            
code0010       MOVE.B  #'M',(A2)+  * load M
               MOVE.B  #'O',(A2)+  * load O
               MOVE.B  #'V',(A2)+  * load V
               MOVE.B  #'E',(A2)+  * load E
               MOVE.B  #'.',(A2)+  * load .
               MOVE.B  #'L',(A2)+  * load L
               MOVE.B  #' ',(A2)+  * load space
               MOVE.B  #' ',(A2)+  * load space

*========================================
* MOVE.W
*========================================               
code0011       MOVE.B  #'M',(A2)+  * load M
               MOVE.B  #'O',(A2)+  * load O
               MOVE.B  #'V',(A2)+  * load V
               MOVE.B  #'E',(A2)+  * load E
               MOVE.B  #'.',(A2)+  * load .
               MOVE.B  #'W',(A2)+  * load W
               MOVE.B  #' ',(A2)+  * load space
               MOVE.B  #' ',(A2)+  * load space
         
*========================================
* MOVEM/CLR/LEA/DIVU.L/JSR/RTS
*========================================      
code0100       STOP        #$2700

*========================================
* SUBQ
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

*========================================
* BSR/BRA/Bcc
*========================================
code0110       STOP        #$2700

*========================================
* MOVEQ
*========================================
code0111       STOP        #$2700

*========================================
* OR/DIV/SBCD
*========================================
code1000       STOP        #$2700

*========================================
* SUB/SUBX
*========================================
code1001       STOP        #$2700

*========================================
* Unassigned
*========================================
code1010       STOP        #$2700

*========================================
* NOP
*========================================
_NOP    MOVE.B  #'N',(A2)+  * load N
        MOVE.B  #'O',(A2)+  * load O
        MOVE.B  #'P',(A2)+  * load P
        
*========================================
* MOVEA
*========================================        
_MOVEA  MOVE.B  #'M',(A2)+  * load M
        MOVE.B  #'O',(A2)+  * load O
        MOVE.B  #'V',(A2)+  * load V
        MOVE.B  #'E',(A2)+  * load E
        MOVE.B  #'A',(A2)+  * load A
        MOVE.B  #'.',(A2)+  * load .
        JSR     GET_SIZE    * get size
        CMPI.B  #%11,D3     * word operation
        MOVE.B  #'W',(A2)+  * load W
        CMPI.B  #%10,D3     * long operation
        MOVE.B  #'L',(A2)+  * load L             
        
*========================================
* MOVEQ
*========================================
_MOVEQ  MOVE.B  #'M',(A2)+  * load M
        MOVE.B  #'O',(A2)+  * load O
        MOVE.B  #'V',(A2)+  * load V
        MOVE.B  #'E',(A2)+  * load E
        MOVE.B  #'Q',(A2)+  * load Q

*========================================
* MOVEM
*========================================        
_MOVEM  MOVE.B  #'M',(A2)+  * load M
        MOVE.B  #'O',(A2)+  * load O
        MOVE.B  #'V',(A2)+  * load V
        MOVE.B  #'E',(A2)+  * load E
        MOVE.B  #'M',(A2)+  * load M
        MOVE.B  #'.',(A2)+  * load .
        JSR     GET_SIZE    * get size
        CMPI.B  #%0,D3      * word operation
        MOVE.B  #'W',(A2)+  * load W
        CMPI.B  #%1,D3      * long operation
        MOVE.B  #'L',(A2)+  * load L

*========================================
* ADD
*========================================
_ADD    MOVE.B  #'A',(A2)+  * load A
        MOVE.B  #'D',(A2)+  * load D
        MOVE.B  #'D',(A2)+  * load D
        MOVE.B  #'.',(A2)+  * load .

*========================================
* ADDA
*========================================
_ADDA   MOVE.B  #'A',(A2)+  * load A
        MOVE.B  #'D',(A2)+  * load D
        MOVE.B  #'D',(A2)+  * load D
        MOVE.B  #'A',(A2)+  * load A
        MOVE.B  #'.',(A2)+  * load .

*========================================
* ADDI
*========================================
_ADDI   MOVE.B  #'A',(A2)+  * load A
        MOVE.B  #'D',(A2)+  * load D
        MOVE.B  #'D',(A2)+  * load D
        MOVE.B  #'I',(A2)+  * load I
        MOVE.B  #'.',(A2)+  * load .
        JSR     GET_SIZE    * get size
        CMPI.B  #%00,D3     * byte operation
        MOVE.B  #'B',(A2)+  * load B
        CMPI.B  #%01,D3     * word operation
        MOVE.B  #'W',(A2)+  * load W
        CMPI.B  #%10,D3     * long operation
        MOVE.B  #'L',(A2)+  * load L        
   
*========================================
* ADDQ
*========================================
_ADDQ   MOVE.B  #'A',(A2)+  * load A
        MOVE.B  #'D',(A2)+  * load D
        MOVE.B  #'D',(A2)+  * load D
        MOVE.B  #'Q',(A2)+  * load Q
        MOVE.B  #'.',(A2)+  * load .
        JSR     GET_SIZE    * get size
        CMPI.B  #%00,D3     * byte operation
        MOVE.B  #'B',(A2)+  * load B
        CMPI.B  #%01,D3     * word operation
        MOVE.B  #'W',(A2)+  * load W
        CMPI.B  #%10,D3     * long operation
        MOVE.B  #'L',(A2)+  * load L        
        


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
