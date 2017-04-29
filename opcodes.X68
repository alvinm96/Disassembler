getSize

*----------------------------------------
* NOP
*----------------------------------------
_NOP    MOVE.B  #'N',(A2)+  * load N
        MOVE.B  #'O',(A2)+  * load O
        MOVE.B  #'P',(A2)+  * load P
        
*----------------------------------------
* MOVE Data from source to destination
*----------------------------------------
_MOVE   MOVE.B  #'M',(A2)+  * load M
        MOVE.B  #'O',(A2)+  * load O
        MOVE.B  #'V',(A2)+  * load V
        MOVE.B  #'E',(A2)+  * load E
        MOVE.B  #'.',(A2)+  * load .
        JSR     getSize     * get size
        CMPI.B  #%01,D3     * byte operation
        MOVE.B  #'B',(A2)+  * load B
        CMPI.B  #%11,D3     * word operation
        MOVE.B  #'W',(A2)+  * load W
        CMPI.B  #%10,D3     * long operation
        MOVE.B  #'L',(A2)+  * load L
*----------------------------------------
* MOVEA
*----------------------------------------        
_MOVEA  MOVE.B  #'M',(A2)+  * load M
        MOVE.B  #'O',(A2)+  * load O
        MOVE.B  #'V',(A2)+  * load V
        MOVE.B  #'E',(A2)+  * load E
        MOVE.B  #'A',(A2)+  * load A
        MOVE.B  #'.',(A2)+  * load .
        JSR     getSize     * get size
        CMPI.B  #%11,D3     * word operation
        MOVE.B  #'W',(A2)+  * load W
        CMPI.B  #%10,D3     * long operation
        MOVE.B  #'L',(A2)+  * load L             
        
*----------------------------------------
* MOVEQ
*----------------------------------------        
_MOVEQ  MOVE.B  #'M',(A2)+  * load M
        MOVE.B  #'O',(A2)+  * load O
        MOVE.B  #'V',(A2)+  * load V
        MOVE.B  #'E',(A2)+  * load E
        MOVE.B  #'Q',(A2)+  * load Q

*----------------------------------------
* MOVEM
*----------------------------------------        
_MOVEM  MOVE.B  #'M',(A2)+  * load M
        MOVE.B  #'O',(A2)+  * load O
        MOVE.B  #'V',(A2)+  * load V
        MOVE.B  #'E',(A2)+  * load E
        MOVE.B  #'M',(A2)+  * load M
        MOVE.B  #'.',(A2)+  * load .
        JSR     getSize     * get size
        CMPI.B  #%0,D3      * word operation
        MOVE.B  #'W',(A2)+  * load W
        CMPI.B  #%1,D3      * long operation
        MOVE.B  #'L',(A2)+  * load L

*----------------------------------------
* ADD
*----------------------------------------
_ADD    MOVE.B  #'A',(A2)+  * load A
        MOVE.B  #'D',(A2)+  * load D
        MOVE.B  #'D',(A2)+  * load D
        MOVE.B  #'.',(A2)+  * load .

*----------------------------------------
* ADDA
*----------------------------------------
_ADDA   MOVE.B  #'A',(A2)+  * load A
        MOVE.B  #'D',(A2)+  * load D
        MOVE.B  #'D',(A2)+  * load D
        MOVE.B  #'A',(A2)+  * load A
        MOVE.B  #'.',(A2)+  * load .

*----------------------------------------
* ADDI
*----------------------------------------
_ADDI   MOVE.B  #'A',(A2)+  * load A
        MOVE.B  #'D',(A2)+  * load D
        MOVE.B  #'D',(A2)+  * load D
        MOVE.B  #'I',(A2)+  * load I
        MOVE.B  #'.',(A2)+  * load .
        JSR     getSize     * get size
        CMPI.B  #%00,D3     * byte operation
        MOVE.B  #'B',(A2)+  * load B
        CMPI.B  #%01,D3     * word operation
        MOVE.B  #'W',(A2)+  * load W
        CMPI.B  #%10,D3     * long operation
        MOVE.B  #'L',(A2)+  * load L        
   
*----------------------------------------
* ADDQ
*----------------------------------------     
_ADDQ   MOVE.B  #'A',(A2)+  * load A
        MOVE.B  #'D',(A2)+  * load D
        MOVE.B  #'D',(A2)+  * load D
        MOVE.B  #'Q',(A2)+  * load Q
        MOVE.B  #'.',(A2)+  * load .
        JSR     getSize     * get size
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
