*-----------------------------------------------------------------------------
* Title      : MAIN
* Written by : Maria Kupriyenko Chupaida y Joan Jiménez Rigo
* Date       : 10/1/2025
* Description: SNAKE TIMER GAME
*-----------------------------------------------------------------------------

            ORG    $1000
            
            INCLUDE 'CONST.X68'
            INCLUDE 'SYSCONST.X68'
            INCLUDE 'SYSTEM.X68'
            INCLUDE 'LIB/UTLCODE.X68'
            INCLUDE 'LIB/UTLCONST.X68'
            INCLUDE 'HEADSRP.X68'
            INCLUDE 'SEGSRP.X68'
            INCLUDE 'TAILSRP.X68'
            INCLUDE 'APPLE.X68'
            INCLUDE 'SCORE.X68'
            INCLUDE 'GAME.X68'
            INCLUDE 'MATRIZ.X68'
            INCLUDE 'INTRO.X68'
            INCLUDE 'INSTRUCTIONS.X68'
            INCLUDE 'GAMEOVER.X68'
            INCLUDE 'TABLE.X68'
            INCLUDE 'STATES.X68'
            
            
START:
                
; --- INIZIALIZACIÓN ---------------------------------------------------------

            ORI.W   #$0700,SR
            JSR     SYSINIT
            JSR     UTLINIT
            JSR     STAINIT


.LOOP

; --- ACTUALIZAR -------------------------------------------------------------

; LEER DISPOSITIVOS DE ENTRADA

            TRAP    #KBDUPTN

; ACTUALIZAR LÓGICA DEL JUEGO

            JSR     STAUPD
            
; --- SINCRONIZACIÓN ---------------------------------------------------------
            
.WINT       TST.B   (SCRINTCT)
            BEQ     .WINT   
            CLR.B   (SCRINTCT)         


; --- DIBUJAR ----------------------------------------------------------------
            
            JSR     STAPLOT            
            TRAP    #SCRUPTN                      ; ACTUALIZAR DOBLE BUFFER


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
