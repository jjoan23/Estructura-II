; ----------------------------------------------------------------------------
; PANTALLA INTRO
; ----------------------------------------------------------------------------

; ----------------------------------------------------------------------------
ISCINIT
; Inicializa la pantalla INTRO
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : ISCTIMER
; ----------------------------------------------------------------------------

            CLR.W   (ISCTIMER)
            
            RTS

; ----------------------------------------------------------------------------
ISCUPD
; Actualiza la pantalla INTRO
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : STANEXT, ISCTIMER
; ----------------------------------------------------------------------------

            MOVEM.L D0-D5,-(A7)
            
            MOVE.W  #$0107,D1               ; Habilita IRQ
            MOVE.W  #60,D0
            TRAP    #15
            
.MAINLOOP            
            MOVE.B  #0,D1	; Lee el estado actual del ratón
            MOVE.   #61,D0
            TRAP    #15
            
            MOVE.L  D1,D2                   ; Guarda las coordenadas en D2
            ANDI.B  #1,D0                   ; Comprueba el click izquierdo
            TST     D0
            BEQ     .CONT
            
            ; Miramos si se ha pulsado el texto correspondiente
            MOVE.L  #$108,D3                 ; (640-112)/2=264 -> Coordenada x
            MOVE.L  #$19,D4                  ; Coordenada Y del texto
            
            MOVE.L  D2,D5                   ; Coordenada Y del ratón
            ANDI.L  #$0000FFFF,D5
            CMP.L   D4,D5
            BLT     .CONT                   ; Si Y < Texto

            MOVE.L  D2,D5                   ; Coordenada X del ratón
            ANDI.L  #$FFFF,D5               ; Extrae X (bits bajos)
            CMP.L   D3,D5
            BLT     .CONT                   ; Si X < Texto
            
            ; Si el click está dentro del area de texto
            MOVE.W  #2,(STANEXT)            ; Iniciar el juego
            BRA     .DONE            
            
.CONT       

            MOVE.B  #19,D0                  ; Detecta las teclas
            MOVE.L  #'P',D1                 ; Código ASCII de la tecla P
            TRAP    #15
            BTST.L  #0,D1                   ; Verifica si la tecla P pulsada
            BEQ     .END                    ; Si no está presionada, continua
            MOVE.W  #4,(STANEXT)            ; Cambia STANEXT a 4 si se pulsa P
.END            
            ADDQ.W  #1,(ISCTIMER)
            CMP.W   #ISCMAXTM,(ISCTIMER)
            BLT     .DONE
            MOVE.W  #1,(STANEXT)
            
.DONE       
            MOVEM.L (A7)+,D0-D5
            RTS

; ----------------------------------------------------------------------------
ISCPLOT
; Dibuja la pantalla de INTRO
; INPUT    : NONE
; OUTPUT   : Pantalla de INTRO
; MODIFIES : NONE
; ----------------------------------------------------------------------------
            MOVEM.L D0-D1/A0,-(A7)
                        
            CLR.L   D1
            MOVE.B  #81,D0
            TRAP    #15
            
            LEA     .TXT1,A0
            MOVE.B  #10,D0
            JSR     UTLPRINT
            
            BTST.B  #4,(SCRCYCCT)
            BEQ     .DONE
            
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
