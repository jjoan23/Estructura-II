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

*            LEA     .TSTSTR,A0
*            MOVE.B  #5,D0
*            JSR     UTLPRINT
*            LEA     .STR2,A0
*            JSR     UTLPRINT
            
            TRAP    #SCRUPTN                      ; ACTUALIZA DOBLE BUFFER


            BRA     .LOOP

            SIMHALT
            
*.TSTSTR     DC.B    'THIS IS THE TEST STRING TO BE CENTEREED',0
*.STR2       DC.B    'HOLA MUNDO',0

            INCLUDE 'VARS.X68'
            INCLUDE 'LIB/UTLVARS.X68'
            INCLUDE 'SYSVARS.X68'
    
    
            END    START        












































*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
