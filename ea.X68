*-----------------------------------------------------------
* Decode effective addresses
* D3: DO NOT CHANGE. Stores original instruction bits.
* D5: Mode
* D6: Register
*
* A0: Jump table
* A1: Stores the string of the decoded instruction
*-----------------------------------------------------------                           

*========================================
* Decodes source bits
* Decodes EA
* Bits 0-5
*========================================
GET_SRC     LEA     MODE_TABLE,A2   ; load mode jump table
            JSR     GET_02          ; get register for bits 0-2
            MOVE.B  D5,D6           ; move register value to D6
            JSR     GET_35          ; jump to store mode bits 3-5 in D5
            MULU    #6,D5           ; offset mode
            JSR     0(A2,D5)        ; jump to mode
            RTS

*========================================
* Decodes destination bits
* Bits 6-11
*======================================== 
GET_DEST    LEA     MODE_TABLE,A2   ; load mode jump table       
            JSR     GET_911         ; get register
            MOVE.B  D5,D6           ; move register value to D6
            JSR     GET_OPMODE      ; get mode
            MULU    #6,D5           ; offset mode
            JSR     0(A2,D5)        ; jump to mode
            RTS
            
*========================================
* Mode Jump Table
*========================================
MODE_TABLE  JMP     MODE_000
            JMP     MODE_001
            JMP     MODE_010
            JMP     MODE_011
            JMP     MODE_100
            JMP     MODE_101
            JMP     MODE_110
            JMP     MODE_111            

*========================================
* Dn
*========================================
MODE_000    CMPI.B  #0,D6               ; check if register is greater than 0
            BLT     INV_REG
            CMPI.B  #7,D6               ; check if register is less than 7
            BGT     INV_REG
            LEA     DISP_DN,A1          ; display D
            MOVE.B  #14,D0
            TRAP    #15
            MOVE.B  D6,D5
            JSR     DISP_REG
            RTS
            
*========================================
* An
*========================================     
MODE_001    CMPI.B  #0,D6               ; check if register is greater than 0
            BLT     INV_REG
            CMPI.B  #7,D6               ; check if register is less than 7
            BGT     INV_REG
            LEA     DISP_AN,A1          ; display A
            MOVE.B  #14,D0
            TRAP    #15
            MOVE.B  D6,D5
            JSR     DISP_REG
            RTS

*========================================
* (An)
*========================================
MODE_010    CMPI.B  #0,D6       ; check if register is greater than 0
            BLT     INV_REG
            CMPI.B  #7,D6       ; check if register is less than 7
            BGT     INV_REG
            LEA     DISP_OP,A1  ; display (
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_AN,A1  ; display A
            MOVE.B  #14,D0
            TRAP    #15
            
            MOVE.B  D6,D5
            JSR     DISP_REG

            LEA     DISP_CP,A1  ; display )
            MOVE.B  #14,D0
            TRAP    #15
                
            RTS

*========================================
* (An)+
*========================================
MODE_011    CMPI.B  #0,D6       ; check if register is greater than 0
            BLT     INV_REG
            CMPI.B  #7,D6       ; check if register is less than 7
            BGT     INV_REG
            LEA     DISP_OP,A1  ; display (
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_AN,A1  ; display A
            MOVE.B  #14,D0
            TRAP    #15
            MOVE.B  D6,D5
            JSR     DISP_REG
            LEA     DISP_CP,A1  ; display )
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_INC,A1 ; display +
            MOVE.B  #14,D0
            TRAP    #15
            RTS

*========================================
* -(An)
*========================================
MODE_100    CMPI.B  #0,D6       ; check if register is greater than 0
            BLT     INV_REG
            CMPI.B  #7,D6       ; check if register is less than 7
            BGT     INV_REG
            LEA     DISP_DEC,A1 ; display -
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_OP,A1  ; display (
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_AN,A1  ; display A
            MOVE.B  #14,D0
            TRAP    #15
            MOVE.B  D6,D5
            JSR     DISP_REG
            LEA     DISP_CP,A1  ; display )
            MOVE.B  #14,D0
            TRAP    #15
            RTS

*========================================
* (D16,An)
*========================================
MODE_101    RTS

*========================================
* (D8,An,Xn)
*========================================
MODE_110    RTS

*========================================
* Immediate Data/Absolute Word/Absolute Long
*========================================
MODE_111    CMPI.W  #%000,D6    ; register value 000
            BEQ     MODE_AWA
            CMPI.W  #%001,D6    ; register value 001
            BEQ     MODE_ALA
            CMPI.W  #%100,D6    ; register value 000
            BEQ     MODE_IMM
            ;TODO: err
                                 
*========================================
* Absolute Word Address
*========================================
MODE_AWA    CLR     D0
            LEA     DISP_DS,A1      * print $
            MOVE.B  #14,D0
            TRAP    #15        
            ADDA.W  #2,A5           * move address to read next word                       
           
            JSR     PRINT_HEX   
            
            RTS  

*========================================
* Absolute Long Address
*========================================
MODE_ALA    CLR     D0
            LEA     DISP_DS,A1      * print $
            MOVE.B  #14,D0
            TRAP    #15
            ADDA.W  #2,A5           * move address to read next word
            
            JSR     PRINT_HEX   * print first word
            ADDA.W  #2,A5           * move to next address
            JSR     PRINT_HEX   * print second half of word
            
            RTS  

*========================================
* Immediate Data
*========================================   
MODE_IMM    LEA     DISP_PS,A1      * print #
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_DS,A1      * print $
            MOVE.B  #14,D0
            TRAP    #15
                      
            ADDA.W  #2,A5           * move address to read next word
            
            MOVE.B  SIZE,D5
            CMPI.B  #1,D5           * byte = 0; word = 1; long = 2
            BGT     IMM_LONG
            
IMM_WORD    JSR     PRINT_HEX   * print first word   
            RTS

IMM_LONG    JSR     PRINT_HEX  
            ADDA.W  #2,A5           * move to next address
            JSR     PRINT_HEX   * print second half of word   
            RTS
            

*========================================
* Print D5 in hex
*========================================  
PRINT_ADDRESS
            LEA     TABLE_HtoA,A2    * load hex-ascii values
            MOVE.B  #28,D2              * starting displacement    
            MOVE.B  #0,D1               * bits that already been shifted            

PRINT_ADDRESS_LOOP  
            MOVE.L  A5,D5               * move instruction
            LSL.L   D1,D5               * remove bits that been shifted
            LSR.L   D2,D5               * shift to get nibble
            MULU    #2,D5               * offset for ascii values
            LEA     0(A2,D5),A1         * print ascii value
            MOVE.B  #14,D0
            TRAP    #15
            CMP.B   D2,D1               * check if ended
            BEQ     DONE_PRINT          * branch to end
            ADD.W   #4,D1               * add to num bits that have been shifted
            JMP     PRINT_ADDRESS_LOOP  * jump to beginning

*========================================
* Print D5 in hex
*========================================  
PRINT_HEX
            LEA     TABLE_HtoA,A2       * load hex-ascii values
            MOVE.B  #12,D2              * starting displacement    
            MOVE.B  #0,D1               * bits that already been shifted            

PRINT_LOOP  MOVE.W  (A5),D5             * move instruction
            LSL.W   D1,D5               * remove bits that been shifted
            LSR.W   D2,D5               * shift to get nibble
            MULU    #2,D5               * offset for ascii values
            LEA     0(A2,D5),A1         * print ascii value
            MOVE.B  #14,D0
            TRAP    #15
            CMP.B   D2,D1               * check if ended
            BEQ     DONE_PRINT          * branch to end
            ADD.W   #4,D1               * add to num bits that have been shifted
            JMP     PRINT_LOOP          * jump to beginning
            
DONE_PRINT  RTS

*========================================
* Display the number in register D5 in hex
*========================================
DISP_REG    LEA     TABLE_HtoA,A2
            MULU    #2,D5
            LEA     0(A2,D5),A1
            MOVE.B  #14,D0
            TRAP    #15
            RTS
            
*========================================
* Get bits 9-11
*========================================     
GET_911     MOVE.W  D3,D5
            LSL.W   #4,D5
            LSR.W   #8,D5
            LSR.W   #5,D5           
            RTS
            
*========================================
* Get bits 0-7
*========================================  
GET_07      MOVE.B  D3,D5
            JSR     DISP_REG
            RTS

*========================================
* Get bits 3-5
*========================================  
GET_35      MOVE.B  D3,D5
            LSL.B   #2,D5
            LSR.B   #5,D5
            RTS

*========================================
* Get bits 0-2
*========================================  
GET_02      MOVE.B  D3,D5
            LSL.B   #5,D5
            LSR.B   #5,D5
            RTS
           
*========================================
* Get opmode bits 6-8
*======================================== 
GET_OPMODE  MOVE.W  D3,D5           * get opmode
            LSL.W   #7,D5           * isolate bits 6-8
            LSR.W   #8,D5
            LSR.W   #5,D5  
            RTS
            
*========================================
* Check type of mem shift
*========================================     
MEM_SHIFT_TYPE  
            MOVE.W  D3,D5
            LSL.W   #4,D5
            LSR.W   #8,D5
            LSR.W   #5,D5
            RTS

*========================================
* Check type of register shift 4-7
*========================================     
REG_SHIFT_TYPE  
            MOVE.B  D3,D5
            LSR.B   #5,D5
            RTS

*========================================
* Get reg shift type bits 3-4
*========================================              
SHIFT_TYPE  MOVE.B  D3,D5
            LSL.B   #3,D5
            LSR.B   #6,D5
            RTS

*========================================
* Get bits 0-2 for shift register
*========================================                
SHIFT_02    MOVE.B  D3,D5
            LSL.B   #5,D5
            LSR.B   #5,D5
            LEA     DISP_DN,A1
            MOVE.B  #14,D0
            TRAP    #15
            JSR     DISP_REG         
            RTS
            
INV_REG     LEA     MSG_INVREG,A1
            MOVE.B  #14,D0
            TRAP    #15
            RTS







*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
