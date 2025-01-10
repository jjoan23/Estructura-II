; ----------------------------------------------------------------------------
; CONSTANTES DEL JUEGO
; ----------------------------------------------------------------------------
   
; --- CONSTANTES DE LA MANZANA -----------------------------------------------

MNZWIDTH    EQU     20	; Anchura de la manzana
MNZHEIGH    EQU     20                      ; Altura de la manzana
MNZPCOL     EQU     $0000AAFF               ; Color contorno de la manzana
MNZFCOL     EQU     $000000FF               ; Color relleno de la manzana

; --- CONSTANTES DE LA SERPIENTE ---------------------------------------------

CBZVEL      EQU     20                      ; Velocidad de la cabeza
SGMWIDTH    EQU     20                      ; Anchura de un segmento
SGMHEIGH    EQU     20                      ; Altura de un segmento
SGMPCOL     EQU     $0000FF00               ; Color controrno de segmento
SGMFCOL     EQU     $0000AA00               ; Color relleno de segmento
COLWIDTH    EQU     10                      ; Anchura de la cola
COLHEIGH    EQU     10                      ; Altura de la cola
COLPCOL     EQU     $0000FF00               ; Color contorno de la cola
COLFCOL     EQU     $0000AA00               ; Color relleno de la cola
CBZWIDTH    EQU     20                      ; Anchura de la cabeza
CBZHEIGH    EQU     20                      ; Altura de la cabeza
CBZPCOL     EQU     $0000FF00               ; Color contorno de la cabeza
CBZFCOL     EQU     $0000AA00               ; Color relleno de la cabeza
OJOWIDTH    EQU     10                      ; Anchura ojo de serpiente
OJOHEIGH    EQU     10                      ; Altura ojo de serpiente
OJOPCOL     EQU     $00000000               ; Color contorno del ojo
OJOFCOL     EQU     $00FFFFFF               ; Color relleno del ojo

; --- CONSTANTES MARCADOR ----------------------------------------------------

PNTSFCOL    EQU     $00000000               ; Color fondo marcador
PNTSTEXT    EQU     0101                    ; Coordenadas del marcador

; --- CONSTANTES RELACIONADAS CON LOS ESTADOS --------------------------------

STANONE     EQU     -1                      ; Número de estado no existente
ISCMAXTM    EQU     500                     ; Ciclos de espera de la intro
INSMAXTM    EQU     500                     ; Ciclos de espera de las instr








*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
