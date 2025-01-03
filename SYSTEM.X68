*-----------------------------------------------------------------------------
* SISTEMA
*-----------------------------------------------------------------------------
 
 
SYSINIT
; INICIA EL  SISTEMA
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ----------------------------------------------------------------------------
            
            MOVE.L  #SCRPLOT,($80+SCRUPTN*4)
            MOVE.L  #KBDUPD,($80+KBDUPTN*4)
            MOVE.L  #SNDPLAY,($80+SNDPLTN*4)
            MOVE.L  #SCRTIM,($60+SCRINTN*4)
            
            JSR     SCRINIT
            JSR     KBDINIT
            JSR     SNDINIT
            
            MOVE.W  SR,-(A7)
            ANDI.W  #$D8FF,(A7)
            
            RTE
            
; ----------------------------------------------------------------------------
SNDINIT
; SOUND SYSTEM INIT
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ----------------------------------------------------------------------------

            MOVEM.L D0-D1/A0-A1,-(A7)

            CLR.B   D1
            LEA     .SNDLIST,A0
.LOOP       MOVE.L  (A0)+,D0
            BEQ     .DONE
            MOVE.L  D0,A1
            MOVE.B  #71,D0
            TRAP    #15
            ADDQ.B  #1,D1
            BRA     .LOOP
            
.DONE       MOVEM.L (A7)+,D0-D1/A0-A1
            RTS
            
.SNDEAT     DC.B    'SND/EAT.wav',0
.SNDGMOV    DC.B    'SND/GAMEOVER.wav',0
.SNDLIST    DC.L    .SNDEAT,.SNDGMOV,0
            
; ----------------------------------------------------------------------------
SNDPLAY
; PLAY SOUND
; INPUT    : D7 SOUND ID
; OUTPUT   : NONE
; MODIFIES : NONE
; ----------------------------------------------------------------------------            
            
            MOVEM.W D0-D1,-(A7)
            
            MOVE.B  #72,D0
            MOVE.B  D7,D1
            TRAP    #15
            
            MOVEM.W (A7)+,D0-D1
            RTE
             
            
; ----------------------------------------------------------------------------
SCRINIT
; INIT SCREEN. SET SCREEN RESOLUTION, SET WINDOWED MODE, CLEAR SCREEN,
; ENABLE DOUBLE BUFFER, ENABLED TIMED INTERRUPT.
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ----------------------------------------------------------------------------

            MOVEM.L D0-D1,-(A7)

            ; SET SCREEN RESOLUTION
            MOVE.B  #33,D0
            MOVE.L  #PANWIDTH<<16|PANHEIGH,D1
            TRAP    #15
            
            ; SET WINDOWED MODE
            MOVE.L  #1,D1
            TRAP    #15
            
            ; CLEAR SCREEN
            MOVE.B  #11,D0
            MOVE.W  #$FF00,D1
            TRAP    #15
            
            ; ENABLE DOUBLE BUFFER
            MOVE.B  #92,D0
            MOVE.B  #17,D1
            TRAP    #15
            
            ; ENABLE TIMED INTERRUPT
            MOVE.B  #32,D0
            MOVE.B  #6,D1
            MOVE.B  #$80|SCRINTN,D2
            MOVE.L  #1000/SCRFPS,D3                  ; CON 20 SE CONSIUGUEN 50 FPS
            TRAP    #15
            
            ; CLEAR INTERRUPT COUNTER
            CLR.W   (SCRINTCT)
            
            MOVEM.L (A7)+,D0-D1
            
            RTS    
            
; ------------------------------------------------------------------------------
SCRTIM
; TIMED INTERRUPT SERVICE ROUTINE
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            ADDQ.B  #1,(SCRINTCT)
            ADDQ.B  #1,(SCRCYCCT)
            RTE
            

; ------------------------------------------------------------------------------
SCRPLOT
; UPDATES DOUBLE BUFFER
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------

            MOVEM.W D0-D1,-(A7)
            
            ; SWITCH BUFFERS
            MOVE.B  #94,D0
            TRAP    #15
            
            ; CLEAR HIDDEN BUFFER
            MOVE.B  #11,D0
            MOVE.W  #$FF00,D1
            TRAP    #15
            
            MOVEM.W (A7)+,D0-D1
            
            RTE
        
; ------------------------------------------------------------------------------
KBDINIT
; INIT KEYBOARD
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------

            CLR.B   (KBDVAL)
            CLR.B   (KBDEDGE)
            RTS

; ------------------------------------------------------------------------------
KBDUPD
; UPDATE KEYBOARD INFO.  
; 7 -> PAUSE
; 6 -> FIRE 3
; 5 -> FIRE 2
; 4 -> FIRE 1
; 3 -> DOWN
; 2 -> RIGHT
; 1 -> UP
; 0 -> LEFT
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------

            MOVEM.L D0-D1,-(A7)

            ; LEE ESTADO DEL TECLADO
            MOVE.B  #19,D0
            MOVE.L  #KBDLEFT<<24|KBDUP<<16|KBDRIGHT<<8|KBDDOWN,D1
            TRAP    #15                  ; Lee las teclas y guarda en D1
            
            MOVE.L  D1,(KBDEDGE)

            CMP.L   #$000000FF,D1
            BEQ     DWN
            CMP.L   #$0000FF00,D1
            BEQ     DER
            CMP.L   #$00FF0000,D1
            BEQ     ARR
            CMP.L   #$FF000000,D1
            BEQ     IZQ

            ; Si no hay pulsaciones, mantener estado
            BRA     CONTINU

DER:        MOVE.W  #0,(ESTDCBZ)           ; Actualiza estado a DERECHA
            BRA     CONTINU
            
ARR:        MOVE.W  #1,(ESTDCBZ)           ; Actualiza estado a ARRIBA
            BRA     CONTINU

IZQ:        MOVE.W  #2,(ESTDCBZ)           ; Actualiza estado a IZQUIERDA
            BRA     CONTINU                    

DWN:        MOVE.W  #3,(ESTDCBZ)           ; Actualiza estado a ABAJO

CONTINU:
            MOVEM.L (A7)+,D0-D1
            RTE
 
*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
