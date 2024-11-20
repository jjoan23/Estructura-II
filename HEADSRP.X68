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
            ADD.W   #CBZVEL,CBZPOSX         ;AUMENTAMOS LA POSICIÓN DE LA SERPIENTE (FALTA MIRAR HACIA DONDE APUNTA LA CABEZA)
            RTS
            
; ------------------------------------------------------------------------------
HEADPLOT
; DIBUJAR CABEZA.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            MOVEM.L D0-D4,-(A7)

            ; SET COLOR DEL CONTORNO CABEZA
            MOVE.B  #80,D0
            MOVE.L  #CBZPCOL,D1
            TRAP    #15
            
            ; SET COLOR DEL RELLENO CABEZA
            MOVE.B  #81,D0
            MOVE.L  #CBZFCOL,D1
            TRAP    #15
            
            ; DEFINIR COORDENADAS CABEZA GRANDE
            MOVE.W  (CBZPOSX),D1
            SUB.W   #CBZWIDTH/2,D1
            MOVE.W  D1,D3
            ADD.W   #CBZWIDTH,D3
            MOVE.W  (CBZPOSY),D2
            SUB.W   #CBZHEIGH/2,D2
            MOVE.W  D2,D4
            ADD.W   #CBZHEIGH,D4
            
            ; DIBUJAR CABEZA
            MOVE.B  #87,D0
            TRAP    #15
            
            ; SET COLOR DEL CONTORNO CABEZA
            MOVE.B  #80,D0
            MOVE.L  #OJOPCOL,D1
            TRAP    #15
            
            ; SET COLOR DEL RELLENO CABEZA
            MOVE.B  #81,D0
            MOVE.L  #OJOFCOL,D1
            TRAP    #15
            ; DEFINIR COORDENADAS OJO
            MOVE.W  (CBZPOSX),D1
            SUB.W   #OJOWIDTH/2,D1
            MOVE.W  D1,D3
            ADD.W   #OJOWIDTH,D3
            MOVE.W  (CBZPOSY),D2
            SUB.W   #OJOHEIGH/2,D2
            MOVE.W  D2,D4
            ADD.W   #OJOHEIGH,D4
            
            ; DIBUJAR OJO
            MOVE.B  #88,D0
            TRAP    #15
            
            ; DEFINIR COORDEANDAS IRIS
            MOVE.W  (CBZPOSX),D1
            MOVE.W  (CBZPOSY),D2
            
            ; DIBUJAR IRIS
            MOVE.B  #82,D0
            TRAP    #15
            
            MOVEM.L (A7)+,D0-D4

            RTS







*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
