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
            INCLUDE 'LIB/UTLCODE.X68'
            INCLUDE 'HEADSRP.X68'
            INCLUDE 'SEGSRP.X68'
            INCLUDE 'TAILSRP.X68'
            INCLUDE 'APPLE.X68'
            INCLUDE 'SCORE.X68'
            INCLUDE 'MATRIZ.X68'
START:
                
;INIZIALIZACIÓN---------------------------------------------------------------

            JSR     SYSINIT
            JSR     UTLINIT
            JSR     MTZINIT
            JSR     HEADINIT                
            JSR     SEGINIT
            JSR     TAILINIT
            JSR     SCOINIT
            JSR     APPLEINIT
            

.LOOP

;---ACTUALIZAR----------------------------------------------------------------
            
            JSR     TAILUPD 
            JSR     SEGUPD 
            JSR     HEADUPD
            *JSR     APPLEUPD  
            JSR     MTZUPD          
            
                          

;LEER INPUTS------------------------------------------------------------------

;ACTUALIZAR LÓGICAS DEL JUEGO-------------------------------------------------

;---SINCRONIZACIÓN------------------------------------------------------------
            ; THE FOLLOWING SYNC STRATEGY IS ****WRONG****
            MOVE.B  #23,D0
            MOVE.L  #1,D1
            TRAP    #15


;---DIBUJAR-------------------------------------------------------------------
             JSR     HEADPLOT
             JSR     SEGPLOT
             JSR     TAILPLOT
             JSR     APPLEPLOT
             JSR     MTZPLOT
            
            TRAP    #0                      ; ACTUALIZA DOBLE BUFFER


            BRA     .LOOP

            SIMHALT
            
            INCLUDE 'VARS.X68'
            INCLUDE 'LIB/UTLVARS.X68'
            INCLUDE 'SYSVARS.X68'
    
    
            END    START        



*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
