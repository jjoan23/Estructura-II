*-----------------------------------------------------------------------------
* Title      : MAIN
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------------------------

            ORG    $1000
            
            INCLUDE 'CONST.X68'
            INCLUDE 'SYSCONST.X68'
            INCLUDE 'SYSTEM.X68'
            INCLUDE 'HEADSRP.X68'
            INCLUDE 'SEGSRP.X68'
            INCLUDE 'TAILSRP.X68'
            INCLUDE 'APPLE.X68'
            INCLUDE 'SCORE.X68'
START:
                
;INIZIALIZACIÓN---------------------------------------------------------------

            JSR     SYSINIT
            JSR     HEADINIT                
            JSR     SEGINIT
            JSR     TAILINIT
            JSR     APPLEINIT
            JSR     SCOINIT

.LOOP

;---ACTUALIZAR----------------------------------------------------------------
            JSR     HEADUPD
            JSR     SEGUPD
            JSR     TAILUPD                 

;LEER INPUTS------------------------------------------------------------------

;ACTUALIZAR LÓGICAS DEL JUEGO-------------------------------------------------

;---SINCRONIZACIÓN------------------------------------------------------------

;---DIBUJAR-------------------------------------------------------------------
            JSR     HEADPLOT
            JSR     SEGPLOT
            JSR     TAILPLOT
            BRA     .LOOP

            SIMHALT
            
            INCLUDE 'VARS.X68'
            INCLUDE 'SYSVARS.X68'
    
    
            END    START        






*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
