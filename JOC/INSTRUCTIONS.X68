; ----------------------------------------------------------------------------
; PANTALLA DE INSTRUCCIONES
; ----------------------------------------------------------------------------

; ----------------------------------------------------------------------------
INSINIT
; Inicializa la pantalla de instrucciones
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : INSTIMER
; ----------------------------------------------------------------------------

            CLR.W   (INSTIMER)	; Reseteamos el timer
            RTS

; ----------------------------------------------------------------------------
INSUPD
; Actualiza la pantalla de instrucciones
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : INSTIMER, STANEXT
; ----------------------------------------------------------------------------

            ADDQ.W  #1,(INSTIMER)
            CMP.W   #INSMAXTM,(INSTIMER)
            BLT     .DONE
            CLR.W   (STANEXT)
.DONE
            RTS

; ----------------------------------------------------------------------------
INSPLOT
; Dibujado de la pantalla de instrucciones
; INPUT    : NONE
; OUTPUT   : Pantalla de instrucciones
; MODIFIES : NONE
; ----------------------------------------------------------------------------

            MOVEM.L D0-D1/A0-A1,-(A7)
                        
            MOVE.B  #11,D0
            LEA     .TXTLST,A1
.LOOP       MOVE.L  (A1)+,D1
            BEQ     .DONE
            MOVE.L  D1,A0
            JSR     UTLPRINT
            BRA     .LOOP
            
.DONE       MOVEM.L (A7)+,D0-D1/A0-A1
            RTS
            
.TXT1       DC.B    'WELCOME TO THE GAME OF SNAKE TIMER 68000!',0
.TXT2       DC.B    'YOUR GOAL IN THIS GAME IS TO EAT AS MUCH APPLES AS THE TIMER ALLOWS YOU',0
.TXT3       DC.B    'EACH APPLE EATEN INCREASES THE TIME YOU CAN PLAY',0
.TXT4       DC.B    'TO THIS END, MOVE THE SNAKE WITH THE ARROWS',0
.TXT5       DC.B    'HOW TO DO IT? YOU MAY ASK.',0
.TXT6       DC.B    'IT IS EASY: JUST USE THE UP, DOWN, LEFT, RIGHT KEYS TO MOVE THE SNAKE',0
.TXT7       DC.B    'BE CAREFUL WITH THE WALLS! TRY NOT TO HIT THEM.',0
.TXTLST     DC.L    .TXT1,.TXT2,.TXT3,.TXT4,.TXT5,.TXT6,.TXT7,0
















*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~0~
*~Tab size~4~
