; ----------------------------------------------------------------------------
; VARIABLES DEL JUEGO
; ----------------------------------------------------------------------------

; --- VARIABLES DE LA MANZANA ------------------------------------------------

MNZPOSX     DS.W    1                       ; COORDENADA X DE LA MANZANA
MNZPOSY     DS.W    1                       ; COORDENADA Y DE LA MANZANA

; --- VARIABLES DE LA SERPIENTE ----------------------------------------------

CBZPOSX     DS.W    1                       ; COORDENADA X CABEZA
CBZPOSY     DS.W    1                       ; COORDENADA Y CABEZA
CBZVELX     DS.W    1                       ; VELOCIDAD X CABEZA
CBZVELY     DS.W    1                       ; VELOCIDAD Y CABEZA
COLPOSX     DS.W    1                       ; COORDENADA X COLA
COLPOSY     DS.W    1                       ; COORDENADA Y COLA
SGMPOSX     DS.W    1                       ; COORDENADA X SEGMENTO
SGMPOSY     DS.W    1                       ; COORDENADA Y SEGMENTO
TRZPLOT     DS.B    1                       ; NÚMERO DE TROZOS A DIBUJAR

*MAXSEG      EQU     100                      ;TAMAÑO MAXIMO DE LA SERPIENTE
*SEGMENTS    DS.W    MAXSEG*2           ;ALMACENA POSICIONES X,Y DE LOS SEGMENTOS
*SEGCOUNT    DS.W    1                       ;CANTIDAD DE SEGMENTOS

*NUMSGMS     DS.W    1           ; Número de segmentos de la serpiente
*LASTCOLX    DS.W    1           ; Última posición X de la cola
*LASTCOLY    DS.W    1           ; Última posición Y de la cola
*
*COLSEGSX    DS.W    100        ; Máximo 100 segmentos, coordenadas X
*COLSEGSY    DS.W    100        ; Máximo 100 segmentos, coordenadas Y
*COLSIZE     DS.W    1          ; Tamaño actual de la cola


; --- VARIABLES DEL MARCADOR -------------------------------------------------

JGOPNTS     DS.W    1                       ; PUNTUACIÓN DEL JUEGO









*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
