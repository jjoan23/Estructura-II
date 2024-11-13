*-----------------------------------------------------------
* MANEJO DE LA MANZANA
*-----------------------------------------------------------
   
; ------------------------------------------------------------------------------
APPLEINIT
; INICIALIZAR MANZANA.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            MOVE.W  #30,(MNZPOSX)   ;DE MOMENTO PONGO X E Y ELEGIDAS MANUALMENTE, EN TEORÍA DEBE SER ALEATORIO
            MOVE.W  #30,(MNZPOSY)
            RTS

            
; ------------------------------------------------------------------------------
APPLEUPD
; ACTUALIZAR MANZANA.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            RTS
            
; ------------------------------------------------------------------------------
APPLEPLOT
; DIBUJAR MANZANA.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            MOVEM.L D0-D4,-(A7)

            ; SET COLOR DEL CONTORNO
            MOVE.B  #80,D0
            MOVE.L  #MNZPCOL,D1
            TRAP    #15
            
            ; SET COLOR DEL RELLENO
            MOVE.B  #81,D0
            MOVE.L  #MNZFCOL,D1
            TRAP    #15
            
            ; DEFINIR COORDENADAS
            MOVE.W  (MNZPOSX),D1
            SUB.W   #MNZWIDTH/2,D1
            MOVE.W  D1,D3
            ADD.W   #MNZWIDTH,D3
            MOVE.W  (MNZPOSY),D2
            SUB.W   #MNZHEIGH/2,D2
            MOVE.W  D2,D4
            ADD.W   #MNZHEIGH,D4
            
            ; DIBUJAR CÍRCULO
            MOVE.B  #88,D0
            TRAP    #15
            
            MOVEM.L (A7)+,D0-D4

            RTS
   

*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
