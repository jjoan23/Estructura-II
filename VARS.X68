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
SGMPOSX2    DS.W    1                       ; COORDENADA X SEGMENTO 2
SGMPOSY2    DS.W    1                       ; COORDENADA Y SEGMENTO 2
SRPVEL      DS.W    1                       ; VELOCIDAD DE LA SERPIENTE

; --- VARIABLES DEL MARCADOR -------------------------------------------------

JGOPNTS     DS.W    1                       ; PUNTUACIÓN DEL JUEGO

; --- INTRO STATE RELATED VARIABLES ------------------------------------------

ISCTIMER    DS.W    1                       ; INTRO TIMER

; --- VARIABLES RELACIONADAS CON LOS ESTADOS ---------------------------------

STACUR      DS.W    1                       ; ESTADO ACTUAL
STANEXT     DS.W    1                       ; ESTADO SIGUIENTE


















*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
