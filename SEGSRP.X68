*-----------------------------------------------------------
* MANEJO DEL SEGMENTO DE LA SERPIENTE
*-----------------------------------------------------------

; ------------------------------------------------------------------------------
SEGINIT
; INICIALIZAR SEGMENTO.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            MOVE.W  #(PANWIDTH/2)-CBZWIDTH,(SGMPOSX)
            MOVE.W  #PANHEIGH/2,(SGMPOSY)
            RTS
            
; ------------------------------------------------------------------------------
SEGUPD
; ACTUALIZAR SEGMENTO.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            ADD.W   #CBZVEL,SGMPOSX
            RTS
            
; ------------------------------------------------------------------------------
SEGPLOT
; DIBUJAR SEGMENTO.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            MOVEM.L D0-D4,-(A7)

            ; SET COLOR DEL CONTORNO
            MOVE.B  #80,D0
            MOVE.L  #SGMPCOL,D1
            TRAP    #15
            
            ; SET COLOR DEL RELLENO
            MOVE.B  #81,D0
            MOVE.L  #SGMFCOL,D1
            TRAP    #15
            
            ; DEFINIR COORDENADAS
            MOVE.W  (SGMPOSX),D1
            SUB.W   #SGMWIDTH/2,D1
            MOVE.W  D1,D3
            ADD.W   #SGMWIDTH,D3
            MOVE.W  (SGMPOSY),D2
            SUB.W   #SGMHEIGH/2,D2
            MOVE.W  D2,D4
            ADD.W   #SGMHEIGH,D4
            
            ; DIBUJAR RECTANGULO
            MOVE.B  #87,D0
            TRAP    #15
            
            MOVEM.L (A7)+,D0-D4

            RTS





*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
