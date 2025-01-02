*-----------------------------------------------------------
* MANEJO DEL MARCADOR
*-----------------------------------------------------------
   
; ------------------------------------------------------------------------------
SCOINIT
; INICIALIZAR MARCADOR.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            CLR.W   (JGOPNTS)
            CLR.W   (JGOTIM)
            MOVE.W  #150,(JGOTIM)
            RTS
            
; ------------------------------------------------------------------------------
SCOUPD
; ACTUALIZAR MARCADOR.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            
            MOVEM.L D0,-(A7)
            
            ;Incrementa el marcador
            MOVE.W  (JGOPNTS),D0
            ADD.W  #10,D0
            MOVE.W  D0,(JGOPNTS)
            
            MOVEM.L (A7)+,D0

            RTS
            
; ------------------------------------------------------------------------------
SCOPLOT
; DIBUJAR MARCADOR.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
           MOVEM.L  D0-D1/A1,-(A7)
           ; SET COLOR DE FONDO
           MOVE.B   #81,D0
           MOVE.L   #COLFND,D1
           TRAP     #15
         
           ; PONEMOS EN LA ESQUINA EL APUNTADOR
           CLR.W    D1
           MOVE.B   #11,D0
           TRAP     #15
           ; DIBUJAR LINEA DE PUNTUACIÓN
            LEA     .TXT1,A1
            CLR.L   D1
            MOVE.W  (JGOPNTS),D1
            MOVE.B  #17,D0
            TRAP    #15
            
           ; BAJAMOS UNA LÍNEA 
           MOVE.W   #1,D1
           MOVE.B   #11,D0
           TRAP     #15
            ; DIBUJAR LINEA DE TIEMPO
            LEA     .TXT2,A1
            CLR.L   D1
            MOVE.W  (JGOTIM),D1
            MOVE.B  #17,D0
            TRAP    #15

            
            MOVEM.L (A7)+,D0-D1/A1
            RTS


.TXT1       DC.B    'PUNTOS : ',0
.TXT2       DC.B    'TIEMPO : ',0
            DS.W    0






*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
