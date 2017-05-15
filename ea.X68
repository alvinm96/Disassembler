*-----------------------------------------------------------
* Decode effective addresses
* D3: DO NOT CHANGE. Stores original instruction bits.
* D4: Mode
* D5: Register
*
* A0: Jump table
* A1: Stores the string of the decoded instruction
*-----------------------------------------------------------
example     EQU     %0100001100111111
    
            ORG     $1000
START:
            MOVE.W  #example,D3
            
EAMOVE      MOVE.W  D3,D4       ; move instruction
            MOVE.B  #10,D2      ; get mode
            LSL.W   D2,D4
            MOVE.B  #13,D2
            LSR.W   D2,D4

            MOVE.W  D3,D6
            LSL.W   D2,D6
            LSR.W   D2,D6
            
CHECK_MODE  CMPI.B  #%000,D4    ; Dn
            BEQ     MODE_DN
            CMPI.B  #%001,D4
            BEQ     MODE_AN
            CMPI.B  #%010
            BEQ     MODE_ANI
            CMPI.B  #%011
            BEQ     MODE_ANII
            CMPI.B  #%100
            BEQ     MODE_DN
            CMPI.B  #%111
            BEQ     MODE_DN
            ; err check
            
*========================================
* Data Register Direct
*========================================
MODE_DN     LEA     DISP_DN,A1
            MOVE.B  #14,D0
            TRAP    #15
            
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


*========================================
* Display constants
* TODO: Move to another file
*========================================
DISP_DN         DC.B    'D',0   ; data register
DISP_AN         DC.B    'A',0   ; address register
DISP_DS         DC.B    '$',0   ; dolla sign
DISP_PS         DC.B    '#',0   ; pound sign
DISP_OP         DC.B    '(',0   ; open parenthesis 
DISP_CP         DC.B    ')',0   ; closed paranthesis
DISP_DEC        DC.B    '-',0   ; decrement
DISP_INC        DC.B    '+',0   ; increment  
DISP_COM        DC.B    ',',0   ; comma
            
REG_0           DC.B    '0',0           
REG_1           DC.B    '1',0  
REG_2           DC.B    '2',0  
REG_3           DC.B    '3',0  
REG_4           DC.B    '4',0  
REG_5           DC.B    '5',0  
REG_6           DC.B    '6',0  
REG_7           DC.B    '7',0            
            
            END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
