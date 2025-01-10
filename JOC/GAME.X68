; ----------------------------------------------------------------------------
; GESTIÓN DEL JUEGO
; ----------------------------------------------------------------------------

; ----------------------------------------------------------------------------
GAMINIT
; Inicializa el juego
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ----------------------------------------------------------------------------
            JSR     MTZINIT
            JSR     HEADINIT
            JSR     SEGINIT
            JSR     TAILINIT
            JSR     SCOINIT
            BRA     APPLEINIT

; ----------------------------------------------------------------------------
GAMUPD
; Actualiza el juego
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : Variables de las subrutinas llamadas
; ----------------------------------------------------------------------------
            JSR     TAILUPD
            JSR     SEGUPD
            JSR     HEADUPD
            BRA     MTZUPD       

; ----------------------------------------------------------------------------
GAMPLOT
; Dibuja el juego
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : Variables de las subrutinas llamadas
; ----------------------------------------------------------------------------
            JSR    HEADPLOT
            JSR    SEGPLOT
            JSR    TAILPLOT
            JSR    APPLEPLOT
            JSR    MTZPLOT
            BRA    SCOPLOT








*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~0~
*~Tab size~4~
