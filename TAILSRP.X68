*-----------------------------------------------------------
* MANEJO DE LA COLA DE LA SERPIENTE
*-----------------------------------------------------------
   
; ------------------------------------------------------------------------------
TAILINIT
; INICIALIZAR COLA.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            MOVE.W  #(PANWIDTH/2)-CBZWIDTH-SGMWIDTH+(COLWIDTH/2),(COLPOSX)
            MOVE.W  #(PANHEIGH/2),(COLPOSY)
            RTS
            
            
; ------------------------------------------------------------------------------
TAILUPD
; ACTUALIZAR COLA.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            ADD.W   #CBZVEL,COLPOSX
            RTS
            
; ------------------------------------------------------------------------------
TAILPLOT
; DIBUJAR COLA.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            MOVEM.L D0-D4,-(A7)

            ; SET COLOR DEL CONTORNO
            MOVE.B  #80,D0
            MOVE.L  #COLPCOL,D1
            TRAP    #15
            
            ; SET COLOR DEL RELLENO
            MOVE.B  #81,D0
            MOVE.L  #COLFCOL,D1
            TRAP    #15
            
            ; DEFINIR COORDENADAS
            MOVE.W  (COLPOSX),D1
            SUB.W   #COLWIDTH/2,D1
            MOVE.W  D1,D3
            ADD.W   #COLWIDTH,D3
            MOVE.W  (COLPOSY),D2
            SUB.W   #COLHEIGH/2,D2
            MOVE.W  D2,D4
            ADD.W   #COLHEIGH,D4
            
            ; DIBUJAR RECTANGULO
            MOVE.B  #87,D0
            TRAP    #15
            
            MOVEM.L (A7)+,D0-D4

            RTS




*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
