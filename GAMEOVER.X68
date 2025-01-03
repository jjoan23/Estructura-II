; ==============================================================================
; GAME OVER SCREEN
; ==============================================================================

; ------------------------------------------------------------------------------
GOVINIT
; GAME OVER SCREEN INIT
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------

            CLR.W  (GOVTIMER)
            RTS

; ------------------------------------------------------------------------------
GOVUPD
; GAME OVER SCREEN UPDATE
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            MOVEM.L D0-D1,-(A7)
            
            MOVE.B  #19,D0                  ; Detectar teclas
            MOVE.L  #'S',D1                 ; C�digo ASCII de la tecla S
            TRAP    #15
            BTST.L  #0,D1                   ; Verificar si la tecla S est� presionada
            BEQ     CONT                    ; Si no est� presionada, continuar

            CLR.W (STANEXT)                 ; Cambiar STANEXT a 0 si la tecla P est� presionada


CONT

            
            
            ADDQ.W  #1,(GOVTIMER)
            CMP.W   #500,(GOVTIMER)
            BLT     .DONE
            CLR.W   (STANEXT)
.DONE

	MOVEM.L	(A7)+,D0-D1
            
            RTS
            
; ------------------------------------------------------------------------------
GOVPLOT
; GAME OVER SCREEN PLOT
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
