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
            MOVE.W  D0,-(A7)
            MOVE.W  D3,D0
            JSR     CNVICOOR
            MOVE.L  D1,-(A7)
            
            MOVE.B  #80,D0
            MOVE.L  #SGMPCOL,D1            ; PONEMOS EL COLOR DE DIBUJADO AL COLOR DEL CONTORNO DEL SEGMENTO
            TRAP    #15
            
            MOVE.B  #81,D0
            MOVE.L  #SGMFCOL,D1            ; PONEMOS EL COLOR DE DIBUJADO AL COLOR DEL RELLENO DEL SEGMENTO
            TRAP    #15
            
            MOVE.B  #87,D0
            MOVE.L  (A7)+,D1
            MOVE.W  D3,-(A7)
            MOVE.W  D1,D3
            ADD.W   #SIZECLDA,D3
            MOVE.W  D2,D4                    ; DIBUJAMOS EL CUADRADO
            ADD.W   #SIZECLDA,D4
            TRAP    #15                     
                        
            MOVE.W  (A7)+,D3  
            MOVE.W  (A7)+,D0


            RTS






*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
