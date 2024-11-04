*-----------------------------------------------------------
* MANEJO DE LA CABEZA DE LA SERPIENTE
*-----------------------------------------------------------

; ------------------------------------------------------------------------------
HEADINIT
; INICIALIZAR CABEZA.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            MOVE.W  #PANWIDTH/2,(CBZPOSX)
            MOVE.W  #PANHEIGH/2,(CBZPOSY)
            RTS
            
; ------------------------------------------------------------------------------
HEADUPD
; ACTUALIZAR CABEZA.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            RTS
            
; ------------------------------------------------------------------------------
HEADPLOT
; DIBUJAR CABEZA.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            MOVEM.L D0-D4,-(A7)

            ; SET COLOR DEL CONTORNO
            MOVE.B  #80,D0
            MOVE.L  #CBZPCOL,D1
            TRAP    #15
            
            ; SET COLOR DEL RELLENO
            MOVE.B  #81,D0
            MOVE.L  #CBZFCOL,D1
            TRAP    #15
            
            ; DEFINIR COORDENADAS
            MOVE.W  (CBZPOSX),D1
            SUB.W   #CBZWIDTH/2,D1
            MOVE.W  D1,D3
            ADD.W   #CBZWIDTH,D3
            MOVE.W  (CBZPOSY),D2
            SUB.W   #CBZHEIGH/2,D2
            MOVE.W  D2,D4
            ADD.W   #CBZHEIGH,D4
            
            ; DIBUJAR RECTANGULO
            MOVE.B  #87,D0
            TRAP    #15
            
            MOVEM.L (A7)+,D0-D4

            RTS





*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
