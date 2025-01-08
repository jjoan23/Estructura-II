; ----------------------------------------------------------------------------
; GESTIÓN DEL ESTADO DEL JUEGO
; ----------------------------------------------------------------------------

; ----------------------------------------------------------------------------
STAINIT
; Inicializa el gestor de estado
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; ----------------------------------------------------------------------------
            MOVE.W  #STANONE,(STACUR)
            CLR.W   (STANEXT)	; Inicamos en estado 0
            RTS

; ----------------------------------------------------------------------------
STAUPD
; Realiza la inicialización y actualización del estado si es necesario
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; ----------------------------------------------------------------------------
            MOVEM.L D0/A0,-(A7)
            
            CLR.L   D0
            MOVE.W  (STANEXT),D0
            CMP.W   (STACUR),D0
            BEQ     .DOUPD
            MOVE.W  D0,(STACUR)
            LSL.L   #2,D0
            MOVE.L  D0,A0
            MOVE.L  .INITBL(A0),A0
            JSR     (A0)
.DOUPD      CLR.L   D0
            MOVE.W  (STACUR),D0
            LSL.L   #2,D0
            MOVE.L  D0,A0
            MOVE.L  .UPDTBL(A0),A0
            JSR     (A0)
            
            MOVEM.L (A7)+,D0/A0
            RTS
            
.INITBL     DC.L    ISCINIT,INSINIT,GAMINIT,GOVINIT,TABINIT
.UPDTBL     DC.L    ISCUPD,INSUPD,GAMUPD,GOVUPD,TABUPD

; ----------------------------------------------------------------------------
STAPLOT
; Realiza el dibujado del estado
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; ----------------------------------------------------------------------------
            MOVEM.L D0/A0,-(A7)
            CLR.L   D0
            MOVE.W  (STACUR),D0
            LSL.L   #2,D0
            MOVE.L  D0,A0
            MOVE.L  .PLTTBL(A0),A0
            JSR     (A0)
            MOVEM.L (A7)+,D0/A0
            RTS
            
.PLTTBL     DC.L    ISCPLOT,INSPLOT,GAMPLOT,GOVPLOT,TABPLOT

; ----------------------------------------------------------------------------
STAEMPTY
; Subrutina vacía para casos donde no hay nada que hacer
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; NOTE     - JUST A PLACEHOLDER. NOTHING TO DO.
; ----------------------------------------------------------------------------
            RTS















*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~0~
*~Tab size~4~
