; ----------------------------------------------------------------------------
; VARIABLES DEL SISTEMA
; ----------------------------------------------------------------------------

; --- VARIABLES DE LA MATRIZ -------------------------------------------------

ESTDCLDS    DS.B    TCELDAS                 ; ESTADO DE LAS CELDAS 0=VAC�O  1=COLA   2=SEGMENTO  TRZPLOT=CABEZA  4?=MANZANA    
ESTDCBZ     DS.B    1                       ; 0= DERECHA, 1=ARRIBA, 2=IZQUIERDA, 3=ABAJO

; --- VARIABLES DE TECLADO ---------------------------------------------------

KBDVAL      DS.B    1
KBDEDGE     DS.B    1                       ; KEY EDGE
LASTKEY     DS.L    1                       

;--- TIMED INTERRUPT RELATED VARIABLES ---------------------------------------
            
SCRINTCT    DS.B    1                       ; INTERRUPT COUNTER
SCRCYCCT    DS.B    1                       ;CYCLE COUNTER
            DS.W    0















*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
