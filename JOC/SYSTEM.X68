*-----------------------------------------------------------------------------
* SISTEMA
*-----------------------------------------------------------------------------
 
; ----------------------------------------------------------------------------
SYSINIT
; Inicia el sistema
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ----------------------------------------------------------------------------
            
            MOVE.L  #SCRPLOT,($80+SCRUPTN*4)
            MOVE.L  #KBDUPD,($80+KBDUPTN*4)
            MOVE.L  #SNDPLAY,($80+SNDPLTN*4)
            MOVE.L  #SCRTIM,($60+SCRINTN*4)
            
            JSR     SCRINIT	; Inicializamos las interrupciones
            JSR     KBDINIT
            JSR     SNDINIT
            
            MOVE.W  SR,-(A7)
            ANDI.W  #$D8FF,(A7)	; Pasamos a modo usuario
            
            RTE
            
; ----------------------------------------------------------------------------
SNDINIT
; Inicializa el sonido del sistema
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
            TRAP    #15	; Inicializamos los sonidos
            ADDQ.B  #1,D1
            BRA     .LOOP
            
.DONE       MOVEM.L (A7)+,D0-D1/A0-A1
            RTS
            
.SNDEAT     DC.B    'SND/EAT.wav',0
.SNDGMOV    DC.B    'SND/GAMEOVER.wav',0
.SNDLIST    DC.L    .SNDEAT,.SNDGMOV,0
            
; ----------------------------------------------------------------------------
SNDPLAY
; Play sonido
; INPUT    : D7 sonido ID
; OUTPUT   : NONE
; MODIFIES : NONE
; ----------------------------------------------------------------------------            
            
            MOVEM.W D0-D1,-(A7)
            
            MOVE.B  #72,D0	; Hacemos sonar el sonido
            MOVE.B  D7,D1
            TRAP    #15
            
            MOVEM.W (A7)+,D0-D1
            RTE
             
            
; ----------------------------------------------------------------------------
SCRINIT
; Inicializa la pantalla
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ----------------------------------------------------------------------------

            MOVEM.L D0-D1,-(A7)

            ; Establece la resolución de la pantalla
            MOVE.B  #33,D0
            MOVE.L  #PANWIDTH<<16|PANHEIGH,D1
            TRAP    #15
            
            ; Establece modo ventana
            MOVE.L  #1,D1
            TRAP    #15
            
            ; Limpia la pantalla
            MOVE.B  #11,D0
            MOVE.W  #$FF00,D1
            TRAP    #15
            
            ; Habilita doble buffer
            MOVE.B  #92,D0
            MOVE.B  #17,D1
            TRAP    #15
            
            ; Habilita la temporización de las interrupciones
            MOVE.B  #32,D0
            MOVE.B  #6,D1
            MOVE.B  #$80|SCRINTN,D2
            MOVE.L  #1000/SCRFPS,D3        ; Ponemos los FPS segun SCRFPS
            TRAP    #15
            
            ; Limpia el contador de interrupciones
            CLR.W   (SCRINTCT)
            
            MOVEM.L (A7)+,D0-D1
            
            RTS    
            
; ------------------------------------------------------------------------------
SCRTIM
; Rutina de servicio de interrupción temporizada
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            ADDQ.B  #1,(SCRINTCT)
            ADDQ.B  #1,(SCRCYCCT)	; Actualizamos timer
            RTE
            

; ------------------------------------------------------------------------------
SCRPLOT
; Actualiza el doble buffer
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------

            MOVEM.W D0-D1,-(A7)
            
            ; Cambia los buffers
            MOVE.B  #94,D0
            TRAP    #15
            
            ; Limpia el buffer escondido
            MOVE.B  #11,D0
            MOVE.W  #$FF00,D1
            TRAP    #15
            
            MOVEM.W (A7)+,D0-D1
            
            RTE
        
; ----------------------------------------------------------------------------
KBDINIT
; Inicializa el teclado
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ----------------------------------------------------------------------------

            CLR.B   (KBDVAL)
            CLR.B   (KBDEDGE)             ; Reseteamos los valores del teclado
            RTS

; ----------------------------------------------------------------------------
KBDUPD
; Actualiza la info del teclado
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ----------------------------------------------------------------------------

            MOVEM.L D0-D1,-(A7)

            ; Lee el estado del teclado
            MOVE.B  #19,D0
            MOVE.L  #KBDLEFT<<24|KBDUP<<16|KBDRIGHT<<8|KBDDOWN,D1
            TRAP    #15	; Lee las teclas y guarda en D1
            
            MOVE.L  D1,(KBDEDGE)

            CMP.L   #$000000FF,D1
            BEQ     DWN
            CMP.L   #$0000FF00,D1
            BEQ     DER
            CMP.L   #$00FF0000,D1
            BEQ     ARR
            CMP.L   #$FF000000,D1
            BEQ     IZQ

            ; Si no hay pulsaciones, mantiene el estado
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
