; ----------------------------------------------------------------------------
; PANTALLA GAME OVER
; ----------------------------------------------------------------------------

; ----------------------------------------------------------------------------
GOVINIT
; Inicializa la pantalla GAME OVER
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : GOVTIMER
; ----------------------------------------------------------------------------

            CLR.W  (GOVTIMER)
            RTS

; ----------------------------------------------------------------------------
GOVUPD
; Actualiza la pantalla GAME OVER
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : STANEXT y GOVTIMER
; ----------------------------------------------------------------------------
            MOVEM.L D0-D1,-(A7)
            
            MOVE.B  #19,D0                  ; Detecta la tecla S
            MOVE.L  #'S',D1                 
            TRAP    #15
            BTST.L  #0,D1                   ; Verifica si la tecla se pulsa
            BEQ     .CONT                   ; Si no está presionada, continua
            CLR.W   (STANEXT)               ; Cambia STANEXT a 0

.CONT
            ADDQ.W  #1,(GOVTIMER)
            CMP.W   #500,(GOVTIMER)
            BLT     .DONE
            CLR.W   (STANEXT)
.DONE
	MOVEM.L	(A7)+,D0-D1
            
            RTS
            
; ----------------------------------------------------------------------------
GOVPLOT
; Dibuja la pantalla GAME OVER
; INPUT    : NONE
; OUTPUT   : Pantalla GAME OVER
; MODIFIES : NONE
; ----------------------------------------------------------------------------
            MOVEM.L D0-D1/A0,-(A7)

            CLR.L   D1
            MOVE.B  #81,D0
            TRAP    #15

            LEA     .TXT1,A0
            MOVE.B  #10,D0
            JSR     UTLPRINT

            LEA     .TXT2,A0
            MOVE.B  #20,D0
            JSR     UTLPRINT

.DONE       MOVEM.L (A7)+,D0-D1/A0

            RTS

.TXT1       DC.B    'GAME OVER',0
.TXT2       DC.B    'WAIT TO RETURN TO MAIN PAGE OR PRESS KEY S',0
            DS.W    0






















*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~0~
*~Tab size~4~
