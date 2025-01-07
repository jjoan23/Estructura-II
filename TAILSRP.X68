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
            MOVE.W  #(PANHEIGH/2),(COLPOSY)	; Ponemos la cola después del segundo segmento
            
            RTS
            
            
; ------------------------------------------------------------------------------
TAILUPD
; ACTUALIZAR COLA.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            MOVEM.W D1-D2,-(A7)
            
            		; Marca la posición actual de la cola como vacía
            MOVE.W  (COLPOSX),D1
            MOVE.W  (COLPOSY),D2
            JSR     CINDMTRZ
            JSR     MCLDVCIA

            		; Actualiza la posición de la cola para seguir al último segmento
            MOVE.W  (SGMPOSX2),(COLPOSX)
            MOVE.W  (SGMPOSY2),(COLPOSY)    ; Marcamos la coordenada del segmento 2 como la cola
            
            		; Marca la nueva posición como cola
            MOVE.W  (COLPOSX),D1
            MOVE.W  (COLPOSY),D2
            JSR     CINDMTRZ
            JSR     COLOCPD

FINUPD
            MOVEM.W (A7)+,D1-D2
            RTS
            
; ------------------------------------------------------------------------------
TAILPLOT
; DIBUJAR COLA
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------

            MOVE.W  D0,-(A7)
            MOVE.W  D3,D0
            JSR     CNVICOOR
            MOVE.L  D1,-(A7)
            
            MOVE.B  #80,D0
            MOVE.L  #COLPCOL,D1            ; Ponemos el color de dibujado a COLPCOL
            TRAP    #15
            
            MOVE.B  #81,D0
            MOVE.L  #COLFCOL,D1            ; Ponemos el color de dibujado a COLFCOL
            TRAP    #15
            
            MOVE.B  #87,D0
            MOVE.L  (A7)+,D1
            MOVE.W  D3,-(A7)
            MOVE.W  D1,D3
            ADD.W   #SIZECLDA,D3
            MOVE.W  D2,D4                    
            ADD.W   #SIZECLDA,D4
            TRAP    #15                    ; Dibujamos el cuadrado 
                        
            MOVE.W  (A7)+,D3  
            MOVE.W  (A7)+,D0

            RTS



*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
