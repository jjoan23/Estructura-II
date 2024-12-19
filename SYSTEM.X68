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

            MOVEM.L D0-D3,-(A7)

            ; READ FIRST PART
            MOVE.B  #19,D0
            MOVE.L  #KBDLEFT<<24|KBDUP<<16|KBDRIGHT<<8|KBDDOWN,D1
            TRAP    #15
            
            ; CONVERT TO DESIRED FORMAT
            MOVE.W  #3,D3
.LOOP       LSL.L   #8,D1
            ROXL.B  #1,D2
            DBRA.W  D3,.LOOP
            
            ; COMPUTE KBDEDGE
            MOVE.B  (KBDVAL),D0
            NOT.B   D0
            AND.B   D2,D0
            MOVE.B  D0,(KBDEDGE)
            
            ; STORE KBDVAL
            MOVE.B  D2,(KBDVAL)
            
            MOVEM.L (A7)+,D0-D3

            RTE


*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
