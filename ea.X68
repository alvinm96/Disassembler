*-----------------------------------------------------------
* Decode effective addresses
* D3: DO NOT CHANGE. Stores original instruction bits.
* D4: Mode
* D6: Register
*
* A0: Jump table
* A1: Stores the string of the decoded instruction
*-----------------------------------------------------------                        
EAMOVE      MOVE.W  D3,D4       ; move instruction for src mode
            MOVE.B  #10,D2      ; get mode
            LSL.W   D2,D4
            MOVE.B  #13,D2
            LSR.W   D2,D4 
            
            MOVE.W  D3,D6       ; move instruction for src register
            LSL.W   D2,D6       ; get register
            LSR.W   D2,D6
            JSR     CHECK_MODE
            
            MOVE.W  D3,D4       ; move instruction for dest mode
            LSL.W   #4,D4
            LSR.W   #8,D4
            LSR.W   #1,D4
            
            MOVE.W  D3,D6       ; move instruction for dest register
            LSL.W   #7,D6
            LSR.W   #6,D6
            JSR     CHECK_MODE
            
CHECK_MODE  CMPI.B  #%000,D4    ; Dn
            BEQ     MODE_DN
            CMPI.B  #%001,D4
            BEQ     MODE_AN
            CMPI.B  #%010,D4
            BEQ     MODE_ANI
            CMPI.B  #%011,D4
            BEQ     MODE_ANII
            CMPI.B  #%100,D4
            BEQ     MODE_ANII
            CMPI.B  #%111,D4
            BEQ     MODE_ANII
            ; err check
            RTS

*========================================
* Data Register Direct
*========================================
MODE_DN     LEA     DISP_TAB,A1
            MOVE.B  #14,D0
            TRAP    #15
            LEA     DISP_DN,A1
            MOVE.B  #14,D0
            TRAP    #15
            MOVE.B  D6,D1       ; get register
            EXT.L   D1
            MOVE.B  #3,D0
            TRAP    #15
            LEA     DISP_COM,A1
            MOVE.B  #14,D0
            TRAP    #15
            RTS
*========================================
* Address Register Direct
*========================================     
MODE_AN

*========================================
* Address Register Indirect
*========================================
MODE_ANI

*========================================
* Address Register Indirect with Post incremement 
*========================================
MODE_ANII   

*========================================
* Address Register Indirect with Pre decremement 
*========================================
MODE_ANID

*========================================
* Immediate Data
*========================================   
MODE_IMM

*========================================
* Absolute Long Address
*========================================
MODE_ALA

*========================================
* Absolute Word Address
*========================================
MODE_AWA          
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
