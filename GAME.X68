; ==============================================================================
; GAME MANAGEMENT
; ==============================================================================

; ------------------------------------------------------------------------------
GAMINIT
; INITIALIZES GAME.
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            JSR     MTZINIT
            JSR     HEADINIT
            JSR     SEGINIT	; Inicializar todos los componentes del juego
            JSR     TAILINIT
            JSR     SCOINIT
            BRA     APPLEINIT

; ------------------------------------------------------------------------------
GAMUPD
; UPDATES THE GAME
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            JSR     TAILUPD
            JSR     SEGUPD	; Actualizar componentes del juego
            JSR     HEADUPD
            BRA     MTZUPD       

; ------------------------------------------------------------------------------
GAMPLOT
; PLOTS THE GAME
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            JSR    HEADPLOT
            JSR    SEGPLOT
            JSR    TAILPLOT	; Dibujar componentes del juego
            JSR    APPLEPLOT
            JSR    MTZPLOT
            BRA    SCOPLOT






*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~0~
*~Tab size~4~
