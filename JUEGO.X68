*-----------------------------------------------------------
* Title      : JUEGO
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
    INCLUDE 'CONST.X68'
    INCLUDE 'SYSCONST.X68'
    INCLUDE 'SYSTEM.X68'
START:                  
;INIZIALIZACIÓN---------------------------------------------
            JSR     SYSINIT

.LOOP

;---ACTUALIZAR----------------------------------------------

;LEER INPUTS------------------------------------------------

;ACTUALIZAR LÓGICAS DEL JUEGO-------------------------------

;---SINCRONIZACIÓN------------------------------------------

;---DIBUJAR-------------------------------------------------


            BRA     .LOOP

    SIMHALT            
    INCLUDE 'VARS.X68'
    INCLUDE 'SYSVARS.X68'
    
    
    END    START        



*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
