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
            
            MOVE.W  #$0107,D1               ;Habilitar IRQ
            MOVE.W  #60,D0
            TRAP    #15
            
.MAINLOOP            
            MOVE.B  #0,D1	; Leer estado actual del ratón
            MOVE.   #61,D0
            TRAP    #15
            
            MOVE.L  D1,D2                   ; Guardar coordenadas en D2
            ANDI.B  #1,D0                   ; Comprobar click izquierdo
            TST     D0
            BEQ     .CONT
            
            ; Miramos si se ha pulsado el texto correspondiente
            MOVE.L  #$108,D3                 ; (640 - 112) / 2 = 264 PIXELES -> COORDENADA X
            MOVE.L  #$19,D4                  ; Coordenada Y del texto 25
            
            MOVE.L  D2,D5                   ; Coordenada Y del ratón
            ANDI.L  #$0000FFFF,D5
            CMP.L   D4,D5
            BLT     .CONT                   ; Si Y < TEXTO

            MOVE.L  D2,D5                   ; Coordenada X del ratón
            ANDI.L  #$FFFF,D5               ; Extraer X (bits bajos)
            CMP.L   D3,D5
            BLT     .CONT                   ; Si X < TEXTO
            
            ; Si el click está dentro del area de texto
            MOVE.W  #2,(STANEXT)            ; Si coincide iniciar juego
            BRA     .DONE            
            
.CONT       

            MOVE.B  #19,D0                  ; Detectar teclas
            MOVE.L  #'P',D1                 ; Código ASCII de la tecla P
            TRAP    #15
            BTST.L  #0,D1                   ; Verificar si la tecla P está presionada
            BEQ     .END                    ; Si no está presionada, continuar
            MOVE.W  #4,(STANEXT)            ; Cambiar STANEXT a 4 si la tecla P está presionada
.END            
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
                        
            CLR.L   D1
            MOVE.B  #81,D0
            TRAP    #15
            
            LEA     .TXT1,A0
            MOVE.B  #10,D0
            JSR     UTLPRINT
            
            BTST.B  #4,(SCRCYCCT)
            BEQ     .DONE	; Dibujamos la pantalla de introducción
            
            LEA     .TXT2,A0
            MOVE.B  #23,D0
            JSR     UTLPRINT
            
            LEA     .TXT3,A0
            JSR     UTLPRINT
            
.DONE       MOVEM.L (A7)+,D0-D1/A0

            RTS
            
.TXT1       DC.B    'SNAKE TIMER 68000',0
.TXT2       DC.B    'CLICK HERE TO START',0
.TXT3       DC.B    'PRESS KEY P TO SEE SCORE TABLE',0
            DS.W    0

















*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~0~
*~Tab size~4~
