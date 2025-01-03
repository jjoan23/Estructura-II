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

; --- VARIABLES DEL MARCADOR -------------------------------------------------

JGOPNTS     DS.W    1                       ; PUNTUACIÓN DEL JUEGO
JGOTIM      DS.W    1                       ; TEMPORIZADOR DEL JUEGO

; --- INTRO STATE RELATED VARIABLES ------------------------------------------

ISCTIMER    DS.W    1                       ; INTRO TIMER

; --- INSTRUCTIONS  STATE RELATED VARIABLES ----------------------------------
INSTIMER    DS.W    1                       ;INTRUCTIONS TIMER

; -- GAME OVER STATE RELATED VARIABLES ---------------------------------------

GOVTIMER    DS.W    1

; --- VARIABLES RELACIONADAS CON LOS ESTADOS ---------------------------------

STACUR      DS.W    1                       ; ESTADO ACTUAL
STANEXT     DS.W    1                       ; ESTADO SIGUIENTE

; --- VARIABLES PARA LEER/ESCRIBIR ARCHIVOS ----------------------------------

FILEID      DS.L    1                       ; ID DEL ARCHIVO
BFFLEC      DS.B    1                       ; BUFFER PARA LEER ARCHIVO
ASCBFF	DS.B	10	; BUFFER PARA CONVERTIR A ASCII
	DS.W	0





















*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
