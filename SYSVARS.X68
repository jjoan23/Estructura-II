; ----------------------------------------------------------------------------
; VARIABLES DEL SISTEMA
; ----------------------------------------------------------------------------

; --- VARIABLES DE LA MATRIZ -------------------------------------------------

ESTDCLDS    DS.B    TCELDAS   ; 0=vacío,1=cola,2=Segmento,3=cabeza,4=manzana    
ESTDCBZ     DS.B    1         ; 0=derecha,1=arriba,2=izquierda,3=abajo

; --- VARIABLES DE TECLADO ---------------------------------------------------

KBDVAL      DS.B    1
KBDEDGE     DS.B    1         ; KEY EDGE
LASTKEY     DS.L    1                       

;--- VARIABLES RELACIONADAS CON LA TEMPORIZACIÓN DE INTERRUPCIONES -----------
            
SCRINTCT    DS.B    1         ; Contador de interrupción
SCRCYCCT    DS.B    1         ; Contador de ciclo
            DS.W    0

















*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
