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
            MOVEM.W D1-D2,-(A7)
            
            MOVE.W  COLPOSX,D1
            MOVE.W  COLPOSY,D2
            JSR     CINDMTRZ
            JSR     RSTCLD 
            
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
            MOVE.L  #COLPCOL,D1            ; PONEMOS EL COLOR DE DIBUJADO AL COLOR DEL CONTORNO DE LA COLA
            TRAP    #15
            
            MOVE.B  #81,D0
            MOVE.L  #COLFCOL,D1            ; PONEMOS EL COLOR DE DIBUJADO AL COLOR DEL RELLENO DE LA COLA
            TRAP    #15
            
            MOVE.B  #87,D0
            MOVE.L  (A7)+,D1
            MOVE.W  D3,-(A7)
            MOVE.W  D1,D3
            ADD.W   #SIZECLDA,D3
            MOVE.W  D2,D4                    
            ADD.W   #SIZECLDA,D4
            TRAP    #15                    ; DIBUJAMOS EL CUADRADO 
                        
            MOVE.W  (A7)+,D3  
            MOVE.W  (A7)+,D0

            RTS








*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
