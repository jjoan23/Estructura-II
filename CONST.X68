; ----------------------------------------------------------------------------
; CONSTANTES DEL JUEGO
; ----------------------------------------------------------------------------
   
; --- CONSTANTES DE LA MANZANA -----------------------------------------------

MNZWIDTH    EQU     20	; ANCHURA DE LA MANZANA 
MNZHEIGH    EQU     20                      ; ALTURA DE LA MANZANA 
MNZPCOL     EQU     $0000AAFF               ; COLOR CONTORNO MANZANA 
MNZFCOL     EQU     $000000FF               ; COLOR RELLENO MANZANA 

; --- CONSTANTES DE LA SERPIENTE ---------------------------------------------

MAXSGM      EQU     1                       ; TAMAÑO MÁXIMO DE SEGMENTOS 
LNGINI      EQU     1                       ; LONGITUD INICIAL SERPIENTE
CBZVEL      EQU     20                      ; VELOCIDAD DE LA CABEZA 
SGMWIDTH    EQU     20                      ; ANCHURA DE UN SEGMENTO
SGMHEIGH    EQU     20                      ; ALTURA DE UN SEGMENTO 
SGMPCOL     EQU     $0000FF00               ; COLOR CONTORNO SEGMENTO 
SGMFCOL     EQU     $0000AA00               ; COLOR RELLENO SEGMENTO
COLWIDTH    EQU     10                      ; ANCHURA DE LA COLA 
COLHEIGH    EQU     10                      ; ALTURA DE LA COLA 
COLPCOL     EQU     $0000FF00               ; COLOR CONTORNO COLA 
COLFCOL     EQU     $0000AA00               ; COLOR RELLENO COLA 
CBZWIDTH    EQU     20                      ; ANCHURA DE LA CABEZA 
CBZHEIGH    EQU     20                      ; ALTURA DE LA CABEZA 
CBZPCOL     EQU     $0000FF00               ; COLOR CONTORNO CABEZA 
CBZFCOL     EQU     $0000AA00               ; COLOR RELLENO CABEZA 
OJOWIDTH    EQU     10                      ; ANCHURA DE OJO DE SERPIENTE
OJOHEIGH    EQU     10                      ; ALTURA DE OJO DE SERPIENTE
OJOPCOL     EQU     $00000000               ; COLOR CONTORNO OJO
OJOFCOL     EQU     $00FFFFFF               ; COLOR RELLENO OJO            

; --- CONSTANTES MARCADOR ----------------------------------------------------

PNTSFCOL    EQU     $00000000               ; COLOR FONDO MARCADOR 
PNTSTEXT    EQU     0101                    ; COORDENADAS DEL MARCADOR 

; --- CONSTANTES RELACIONADAS CON LOS ESTADOS --------------------------------

STANONE     EQU     -1                      ; NÚMERO DE ESTADO NO EXISTENTE
ISCMAXTM    EQU     500                     ;INTRO SCREEN WAITING CYCLES
INSMAXTM    EQU     500                     ;INTRUCTIONS SCREEN WAINTING CYCLES





*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
