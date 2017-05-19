*-------------------------------------------------------
* Display opcodes
*-------------------------------------------------------
CR              EQU     $0D
LF              EQU     $0A

NEW_LINE        DC.B    'HEKKI',CR,LF,0

DISP_NOP        DC.B    'NOP',0
DISP_MOVE       DC.B    'MOVE',0
DISP_MOVEA      DC.B    'MOVEA',0
DISP_MOVEQ      DC.B    'MOVEQ',0
DISP_MOVEM      DC.B    'MOVEM',0
DISP_ADD        DC.B    'ADD',0
DISP_ADDA       DC.B    'ADDA',0
DISP_ADDI       DC.B    'ADDI',0
DISP_ADDQ       DC.B    'ADDQ',0
DISP_SUB        DC.B    'SUB',0
DISP_MULS       DC.B    'MULS',0
DISP_DIVU       DC.B    'DIVU',0
DISP_LEA        DC.B    'LEA',0
DISP_CLR        DC.B    'CLR',0
DISP_AND        DC.B    'AND',0
DISP_OR         DC.B    'OR',0
DISP_LSd        DC.B    'LS',0
DISP_ASd        DC.B    'AS',0
DISP_ROd        DC.B    'RO',0
DISP_CMP        DC.B    'CMP',0
DISP_BCC        DC.B    'BCC',0
DISP_BGT        DC.B    'BGT',0
DISP_BLE        DC.B    'BLE',0
DISP_JSR        DC.B    'JSR',0
DISP_RTS        DC.B    'RTS',0
DISP_SUBQ       DC.B    'SUBQ',0

DISP_BYTE       DC.B    '.B',0
DISP_WORD       DC.B    '.W',0
DISP_LONG       DC.B    '.L',0

DISP_DN         DC.B    'D',0   ; data register
DISP_AN         DC.B    'A',0   ; address register
DISP_DS         DC.B    '$',0   ; dolla sign
DISP_PS         DC.B    '#',0   ; pound sign
DISP_OP         DC.B    '(',0   ; open parenthesis 
DISP_CP         DC.B    ')',0   ; closed paranthesis
DISP_DEC        DC.B    '-',0   ; decrement
DISP_INC        DC.B    '+',0   ; increment  
DISP_COM        DC.B    ',',0   ; comma
DISP_TAB        DC.B    '  ',0  ; tab
DISP_R          DC.B    'R',0   ; R
DISP_L          DC.B    'L',0   ; L
            
REG_0           DC.B    '0',0           
REG_1           DC.B    '1',0  
REG_2           DC.B    '2',0  
REG_3           DC.B    '3',0  
REG_4           DC.B    '4',0  
REG_5           DC.B    '5',0  
REG_6           DC.B    '6',0  
REG_7           DC.B    '7',0



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
