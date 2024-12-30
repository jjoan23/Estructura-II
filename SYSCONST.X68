; ----------------------------------------------------------------------------
; CONSTANTES DEL SISTEMA
; ----------------------------------------------------------------------------

; ---CONSTANTES DE LA PANTALLA------------------------------------------------

PANWIDTH    EQU     640                     ; ANCHO DE LA PANTALLA
PANHEIGH    EQU     480                     ; ALTURA DE LA PANTALLA
COLFND      EQU     $90EE90                 ; COLOR DEL FONDO DE LA PANTALLA
SCRFPS      EQU     50

; ---CONSTANTES DE LA MATRIZ--------------------------------------------------

SIZECLDA    EQU     20                      ; TAMAÑO DE CADA CELDA EN PIXELES
NUMCLMNS    EQU     32                      ; COLUMNAS DE CELDAS (640/10)
NUMFILAS    EQU     24                      ; FILAS DE CELDAS (480/10)
TCELDAS     EQU     768                     ; TOTAL DE CELDAS (64 * 48)

; ---CÓDIGOS DE TECLADO-------------------------------------------------------

KBDLEFT     EQU     $25
KBDUP       EQU     $26
KBDRIGHT    EQU     $27
KBDDOWN     EQU     $28

; --- IDENTIFICADORES DE SONIDO ----------------------------------------------

SNDEAT      EQU     0
SNDGMOV     EQU     1

; --- NÚMEROS DE TRAP --------------------------------------------------------

SCRUPTN     EQU     0                       ; SCREEN UPDATE TRAP NUMBER
KBDUPTN     EQU     1                       ; KEYBOARD TRAP NUMBER
SNDPLTN     EQU     2                       ; SOUND TRAP NUMBER

; --- NÚMEROS DE INTERRUPCIÓN ------------------------------------------------

SCRINTN     EQU     1     






*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
