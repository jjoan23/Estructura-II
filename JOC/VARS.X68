; ----------------------------------------------------------------------------
; VARIABLES DEL JUEGO
; ----------------------------------------------------------------------------

; --- VARIABLES DE LA MANZANA ------------------------------------------------

MNZPOSX     DS.W    1                       ; Coordenada x de la manzana
MNZPOSY     DS.W    1                       ; Coordenada y de la manzana

; --- VARIABLES DE LA SERPIENTE ----------------------------------------------

CBZPOSX     DS.W    1                       ; Coordenada x cabeza
CBZPOSY     DS.W    1                       ; Coordenada y cabeza
CBZVELX     DS.W    1                       ; Velocidad x cabeza
CBZVELY     DS.W    1                       ; Velocidad y cabeza
COLPOSX     DS.W    1                       ; Coordenada x cola
COLPOSY     DS.W    1                       ; Coordenada y cola
SGMPOSX     DS.W    1                       ; Coordenada x segmento
SGMPOSY     DS.W    1                       ; Coordenada y segmento
SGMPOSX2    DS.W    1                       ; Coordenada x segmento 2
SGMPOSY2    DS.W    1                       ; Coordenada y segmento 2

; --- VARIABLES DEL MARCADOR -------------------------------------------------

JGOPNTS     DS.W    1                       ; Puntuación del juego
JGOTIM      DS.W    1                       ; Temporizador del juego

; --- VARIABLES DEL ESTADO DE LA INTRO ---------------------------------------

ISCTIMER    DS.W    1                       ; Temporizador intro

; --- VARIABLES DEL ESTADO DE INSTRUCCIONES ----------------------------------

INSTIMER    DS.W    1                       ; Temporizador instrucciones

; -- VARIABLES DEL ESTADO GAME OVER ------------------------------------------

GOVTIMER    DS.W    1                       ; Temporizador GAME OVER

; --- VARIABLES RELACIONADAS CON LOS ESTADOS ---------------------------------

STACUR      DS.W    1                       ; Estado actual
STANEXT     DS.W    1                       ; Estado siguiente

; --- VARIABLES PARA LEER/ESCRIBIR ARCHIVOS ----------------------------------

FILEID      DS.L    1                       ; ID del archivo
BFFLEC      DS.B    1                       ; Buffer para leer el archivo
ASCBFF	DS.B	10	; Buffer para convertir a ASCII
	DS.W	0






















*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
