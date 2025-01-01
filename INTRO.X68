; ==============================================================================
; INTRO SCREEN
; ==============================================================================

; ------------------------------------------------------------------------------
ISCINIT
; INTRO SCREEN INIT
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------

            CLR.W   (ISCTIMER)
            
            RTS

; ------------------------------------------------------------------------------
ISCUPD
; INTRO SCREEN UPDATE
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------

            MOVEM.L D0-D5,-(A7)
            
            MOVE.W  #$0107,D1               ;HABILITAR IRQ
            MOVE.W  #60,D0
            TRAP    #15
            
.MAINLOOP            
            MOVE.B  #0,D1                   ;LEER ESTADO ACTUAL RATON
            MOVE.   #61,D0
            TRAP    #15
            
            MOVE.L  D1,D2                   ;GUARDAR COORDENADAS RATON EN D2
            ANDI.B  #1,D0                   ;COMPROBAR click izquierdo
            TST     D0
            BEQ     .CONT
            
            ;MIRAMOS SI SE HA PULSADO EN EL TEXTO CORRESPONDIENTE
            MOVE.L  #$108,D3                 ;(640 - 112) / 2 = 264 PIXELES -> COORDENADA X
            MOVE.L  #$19,D4                  ;COORDENADA Y DEL TEXTO 25
            
            MOVE.L  D2,D5                   ;COORDENADA Y RATON
            ANDI.L  #$0000FFFF,D5
            CMP.L   D4,D5
            BLT     .CONT                   ;SI Y < TEXTO

            MOVE.L  D2,D5                   ;COORDENADA X RATON
            ANDI.L  #$FFFF,D5               ;EXTRAER X (BITS BAJOS)
            CMP.L   D3,D5
            BLT     .CONT                   ;SI X < TEXTO
            
            ;SI EL CLICK ESTA DENTRO DEL AREA DEL TEXTO
            MOVE.W  #2,(STANEXT)            ; SI COINCIDE INICIAR JUEGO
            BRA     .DONE            
            
.CONT       
            ADDQ.W  #1,(ISCTIMER)
            CMP.W   #ISCMAXTM,(ISCTIMER)
            BLT     .DONE
            MOVE.W  #1,(STANEXT)
            
.DONE       
            MOVEM.L (A7)+,D0-D5
            RTS

; ------------------------------------------------------------------------------
ISCPLOT
; INTRO SCREEN PLOT
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            MOVEM.L D0-D1/A0,-(A7)
            
            ;JSR     FONPLOT
            
            CLR.L   D1
            MOVE.B  #81,D0
            TRAP    #15
            
            LEA     .TXT1,A0
            MOVE.B  #10,D0
            JSR     UTLPRINT
            
            BTST.B  #4,(SCRCYCCT)
            BEQ     .DONE
            
            LEA     .TXT2,A0
            MOVE.B  #25,D0
            JSR     UTLPRINT
            
.DONE       MOVEM.L (A7)+,D0-D1/A0

            RTS
            
.TXT1       DC.B    'SNAKE TIMER 68000',0
.TXT2       DC.B    'PRESS TO START',0
            DS.W    0















*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~0~
*~Tab size~4~
