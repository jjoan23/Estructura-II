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
                
; --- INIZIALIZACIÓN ---------------------------------------------------------

            ORI.W   #$0700,SR
            JSR     SYSINIT
            JSR     UTLINIT
            JSR     KBDINIT
            JSR     MTZINIT
            JSR     HEADINIT                
            JSR     SEGINIT
            JSR     TAILINIT
            JSR     SCOINIT
            JSR     APPLEINIT
            

.LOOP

; --- ACTUALIZAR -------------------------------------------------------------

; LEER DISPOSITIVOS DE ENTRADA

            TRAP    #1

; ACTUALIZAR LÓGICA DEL JUEGO
            
            JSR     TAILUPD
            JSR     SEGUPD
            JSR     HEADUPD
            JSR     MTZUPD
            
; --- SINCRONIZACIÓN ---------------------------------------------------------
            
.WINT       TST.B   (SCRINTCT)
            BEQ     .WINT   
            CLR.B   (SCRINTCT)         


;---DIBUJAR-------------------------------------------------------------------
             JSR    HEADPLOT
             JSR    SEGPLOT
             JSR    TAILPLOT
             JSR    APPLEPLOT
             JSR    MTZPLOT
             JSR    SCOPLOT
            
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
