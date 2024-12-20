*-----------------------------------------------------------------------------
* SISTEMA
*-----------------------------------------------------------------------------
 
 
SYSINIT
; INICIA EL  SISTEMA
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ----------------------------------------------------------------------------
            JSR     SCRINIT
            
            MOVE.L  #SCRPLOT,($80)
            MOVE.L  #KBDUPD,($84)
            
            MOVE.W  SR,-(A7)
            ANDI.W  #$DFFF,(A7)
            
            RTE
            
; ------------------------------------------------------------------------------
SCRINIT
; INIT SCREEN. SET SCREEN RESOLUTION, SET WINDOWED MODE, CLEAR SCREEN,
; ENABLE DOUBLE BUFFER.
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------

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
            
            MOVEM.L (A7)+,D0-D1
            
            RTS    

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

            MOVEM.L D0-D3,-(A7)

            ; LEE ESTADO DEL TECLADO
            MOVE.B  #19,D0
            MOVE.L  #KBDLEFT<<24|KBDUP<<16|KBDRIGHT<<8|KBDDOWN,D1
            TRAP    #15                  ; Lee las teclas y guarda en D1

            ; CONVERT TO DESIRED FORMAT
            MOVE.W  #3,D3
.LOOP       LSL.L   #8,D1
            ROXL.B  #1,D2
            DBRA.W  D3,.LOOP

            ; PROCESA FLANCOS ASCENDENTES
            MOVE.B  (KBDEDGE),D0         ; Estado anterior
            NOT.B   D0                   ; Invertir bits (teclas no presionadas)
            AND.B   D2,D0                ; Detectar flancos ascendentes
            MOVE.B  D0,(KBDEDGE)         ; Almacena los flancos en KBDEDGE
            
            ; STORE KBDEDGE
            MOVE.B  D2,(KBDEDGE)

*            ; ACTUALIZA EL ESTADO DE LA DIRECCIÓN
*            CLR.W   D0
*            MOVE.B  (KBDEDGE),D0         ; Lee teclas con flanco ascendente
*
*            ; Detecta pulsaciones y actualiza ESTDCBZ
*            CMP.L   #$000000FF,D0        ; Tecla ABAJO
*            BEQ     DWN
*            CMP.L   #$0000FF00,D0        ; Tecla DERECHA
*            BEQ     DER
*            CMP.L   #$00FF0000,D0        ; Tecla ARRIBA
*            BEQ     ARR
*            CMP.L   #$FF000000,D0        ; Tecla IZQUIERDA
*            BEQ     IZQ
*            
*            ; Si no hay pulsaciones, mantener estado
*            BRA     CONTINU
*
*DER:        MOVE.W  #0,ESTDCBZ           ; Actualiza estado a DERECHA
*            BRA     CONTINU
*            
*ARR:        MOVE.W  #1,ESTDCBZ           ; Actualiza estado a ARRIBA
*            BRA     CONTINU
*
*IZQ:        MOVE.W  #2,ESTDCBZ           ; Actualiza estado a IZQUIERDA
*            BRA     CONTINU                    
*
*DWN:        MOVE.W  #3,ESTDCBZ           ; Actualiza estado a ABAJO
*            BRA     CONTINU
*
*CONTINU:
            MOVEM.L (A7)+,D0-D3
            RTE



; CODIGO ANTERIOR

*            MOVEM.L D0-D3,-(A7)
*
*            ; READ FIRST PART
*            MOVE.B  #19,D0
*            MOVE.L  #KBDLEFT<<24|KBDUP<<16|KBDRIGHT<<8|KBDDOWN,D1
*            TRAP    #15
*            
*            MOVE.L  D1,(KBDEDGE)
*          
*            ; CONVERT TO DESIRED FORMAT
*            MOVE.W  #3,D3
*.LOOP       LSL.L   #8,D1
*            ROXL.B  #1,D2
*            DBRA.W  D3,.LOOP
*            
*            ; COMPUTE KBDEDGE
*            MOVE.B  (KBDVAL),D0
*            NOT.B   D0
*            AND.B   D2,D0
*            MOVE.B  D0,(KBDEDGE)
*            
*            ; STORE KBDVAL
*            MOVE.B  D2,(KBDVAL)
*            
*            CLR.W   D0
*            MOVE.L  (KBDEDGE),D0
*            CMP.L   #$000000FF,D0
*            BEQ     DWN
*            CMP.L   #$0000FF00,D0
*            BEQ     DER
*            CMP.L   #$00FF0000,D0
*            BEQ     ARR
*            CMP.L   #$FF000000,D0
*            BEQ     IZQ
*            
*DER:        MOVE.W  #0,ESTDCBZ
*            BRA     CONTINU
*            
*ARR:        MOVE.W  #1,ESTDCBZ
*            BRA     CONTINU
*
*IZQ:        MOVE.W  #2,ESTDCBZ
*            BRA     CONTINU                    
*
*DWN:        MOVE.W  #3,ESTDCBZ
*            BRA     CONTINU
*
*
*    
*CONTINU:
*            
*            MOVEM.L (A7)+,D0-D3
*
*            RTE
















*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
