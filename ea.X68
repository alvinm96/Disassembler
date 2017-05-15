*-----------------------------------------------------------
* Decode effective addresses
* D3: DO NOT CHANGE. Stores original instruction bits.
* D4: Mode
* D6: Register
*
* A0: Jump table
* A1: Stores the string of the decoded instruction
*-----------------------------------------------------------                        
EAMOVE      
            
GET_SRC            
            MOVE.W  D3,D4       ; move instruction for src mode
            MOVE.B  #10,D2      ; get mode bits (3-5)
            LSL.W   D2,D4
            MOVE.B  #13,D2
            LSR.W   D2,D4 

            MOVE.W  D3,D6       ; move instruction for src register
            LSL.W   D2,D6       ; get register bits (0-2)
            LSR.W   D2,D6
            JSR     CHECK_MODE
            RTS
 
GET_DEST           
            MOVE.W  D3,D6       ; move instruction for dest register
            LSL.W   #4,D6       ; get register bits (9-11)
            LSR.W   #8,D6
            LSR.W   #5,D6

            MOVE.W  D3,D4       ; move instruction for dest mode
            LSL.W   #7,D4       ; get mode bits (6-8)
            LSR.W   #8,D4
            LSR.W   #4,D4
            JSR     CHECK_MODE
            RTS
            
CHECK_MODE  CMPI.B  #%000,D4    ; Dn
            BEQ     MODE_DN
            CMPI.B  #%001,D4
            BEQ     MODE_AN
            CMPI.B  #%010,D4
            BEQ     MODE_ANI
            CMPI.B  #%011,D4
            BEQ     MODE_ANII
            CMPI.B  #%100,D4
            BEQ     MODE_ANID
            CMPI.B  #%111,D4
            BEQ     MODE_ANII
            ; err check
            RTS

*========================================
* Data Register Direct
*========================================
MODE_DN     LEA     DISP_DN,A1
            MOVE.B  #14,D0
            TRAP    #15
            MOVE.B  D6,D1       ; get register
            EXT.L   D1
            MOVE.B  #3,D0
            TRAP    #15
            RTS
*========================================
* Address Register Direct
*========================================     
MODE_AN     LEA     DISP_AN,A1
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
MODE_ANI    LEA     DISP_OP,A1
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
MODE_ANII   LEA     DISP_OP,A1
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
MODE_ANID   LEA     DISP_DEC,A1
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
* Immediate Data
*========================================   
MODE_IMM    LEA     DISP_PS,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            RTS

*========================================
* Absolute Long Address
*========================================
MODE_ALA    LEA     DISP_DS,A1
            MOVE.B  #14,D0
            TRAP    #15
            RTS

*========================================
* Absolute Word Address
*========================================
MODE_AWA    LEA     DISP_DS,A1
            MOVE.B  #14,D0
            TRAP    #15
            RTS          



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
