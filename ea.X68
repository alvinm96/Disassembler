*-----------------------------------------------------------
* Decode effective addresses
* D3: DO NOT CHANGE. Stores original instruction bits.
* D4: Mode
* D6: Register
*
* A0: Jump table
* A1: Stores the string of the decoded instruction
*-----------------------------------------------------------                           
GET_SRC     LEA     MODE_TABLE,A0   ; load mode jump table
            MOVE.W  D3,D4           ; move instruction for src mode
            MOVE.B  #10,D2          ; get mode bits (3-5)
            LSL.W   D2,D4
            MOVE.B  #13,D2
            LSR.W   D2,D4 

            MOVE.W  D3,D6           ; move instruction for src register
            LSL.W   D2,D6           ; get register bits (0-2)
            LSR.W   D2,D6
            
            MULU    #6,D4
            JSR     00(A0,D4)       ; jump to table
            RTS
 
GET_DEST    LEA     MODE_TABLE,A0   ; load mode jump table       

            JSR     GET_OPMODE
            
            MULU    #6,D5
            JSR     0(A0,D5)        ; jump to table
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
* Data Register Direct
*========================================
MODE_000    LEA     DISP_DN,A1
            MOVE.B  #14,D0
            TRAP    #15
            JSR     GET_911
            MOVE.B  D5,D1       ; get register
            EXT.L   D1
            MOVE.B  #3,D0
            TRAP    #15
            RTS
            
*========================================
* Address Register Direct
*========================================     
MODE_001    LEA     DISP_AN,A1
            MOVE.B  #14,D0
            TRAP    #15
            MOVE.B  D6,D1       ; get register
            EXT.L   D1
            MOVE.B  #3,D0
            TRAP    #15
            RTS

*========================================
* Address Register Indirect
*========================================
MODE_010    LEA     DISP_OP,A1
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_AN,A1
            MOVE.B  #14,D0
            TRAP    #15
            MOVE.B  D6,D1       ; get register
            EXT.L   D1
            MOVE.B  #3,D0
            TRAP    #15
            LEA     DISP_CP,A1
            MOVE.B  #14,D0
            TRAP    #15
            RTS

*========================================
* Address Register Indirect with Post incremement 
*========================================
MODE_011    LEA     DISP_OP,A1
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_AN,A1
            MOVE.B  #14,D0
            TRAP    #15
            MOVE.B  D6,D1       ; get register
            EXT.L   D1
            MOVE.B  #3,D0
            TRAP    #15
            LEA     DISP_CP,A1
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_INC,A1
            MOVE.B  #14,D0
            TRAP    #15
            RTS

*========================================
* Address Register Indirect with Pre decremement 
*========================================
MODE_100    LEA     DISP_DEC,A1
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_OP,A1
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_AN,A1
            MOVE.B  #14,D0
            TRAP    #15
            MOVE.B  D6,D1       ; get register
            EXT.L   D1
            MOVE.B  #3,D0
            TRAP    #15
            LEA     DISP_CP,A1
            MOVE.B  #14,D0
            TRAP    #15
            RTS

*========================================
* Immediate Data/Absolute Word/Absolute Long
*========================================
MODE_101    STOP    #$2700

*========================================
* Immediate Data/Absolute Word/Absolute Long
*========================================
MODE_110    STOP    #$2700

*========================================
* Immediate Data/Absolute Word/Absolute Long
*========================================
MODE_111    LEA     SEV_TABLE,A0
            MULU    #4,D6
            JSR     0(A0,D6)
            RTS

SEV_TABLE   JMP     MODE_AWA
            JMP     MODE_ALA
            JMP     MODE_IMM
           
            
*========================================
* Absolute Word Address
*========================================
MODE_AWA    LEA     DISP_PS,A1
            TRAP    #15
            LEA     DISP_DS,A1
            TRAP    #15        
            ADDA.W  #2,A5           * move address to read next word
            
            
            MOVE.B  #12,D2          * displacement
            JSR     PRINT_ADDRESS      
            
            RTS  

*========================================
* Absolute Long Address
*========================================
MODE_ALA    CLR     D0
            LEA     DISP_DS,A1      * display dolla sign
            MOVE.B  #14,D0
            TRAP    #15
            
            ADDA.W  #2,A3           * move address to read next word
            
            MOVE.B  #32,D2          * displacement
            JSR     PRINT_ADDRESS     
            
            RTS  

*========================================
* Immediate Data
*========================================   
MODE_IMM    LEA     DISP_PS,A1      * display pound sign
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_DS,A1      * display dolla sign
            MOVE.B  #14,D0
            TRAP    #15
            
            RTS

PRINT_ADDRESS
            LEA     TABLE_HEXCHAR,A2
            MOVE.B  #0,D1           * num to shift

PRINT_LOOP  MOVE.W  (A5),D5         * move instruction
            LSL.W   D1,D5
            LSR.W   D2,D5
            MULU    #2,D5
            LEA     0(A2,D5),A1
            MOVE.B  #14,D0
            TRAP    #15
            CMP.B   D2,D1
            BEQ     DONE_PRINT
            ADD.W   #4,D1
            JMP     PRINT_LOOP
            
DONE_PRINT  RTS

*========================================
* Display the number in register D5 in decimal
*========================================
DISP_REG    MOVE.B  D5,D1       ; get register
            EXT.L   D1
            MOVE.B  #3,D0
            TRAP    #15
            RTS     
            
*========================================
* Display the register number in hex
*========================================
DISP_ADDRESS
            MOVE.L  A5,D5
            JSR     DISP_REG
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
* Print immediate data value (bits 9-11)
*========================================   
DISP_DATA   LEA     DISP_PS,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            JSR     GET_911
            JSR     DISP_REG
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
            

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
