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
            RTS
            
; ------------------------------------------------------------------------------
SCOUPD
; ACTUALIZAR MARCADOR.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
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
           
*           ; SET COLOR DE LAS LETRAS        
*           MOVE.B   #80,D0
*           MOVE.L   #PNTSFCOL,D1
*           TRAP     #15
           
*           ; SET POSICIÓN DE LINEA
*           MOVE.B   #11,D0
*           MOVE.W   #PNTSTEXT,D1
*           TRAP     #15
           
           ; DIBUJAR LINEA DE PUNTUACIÓN
            LEA     .TXT1,A1
            CLR.L   D1
            MOVE.W  (JGOPNTS),D1
            MOVE.B  #17,D0
            TRAP    #15
            
            MOVEM.L (A7)+,D0-D1/A1
            RTS


.TXT1       DC.B    'PUNTOS : ',0


*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
