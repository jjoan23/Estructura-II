; ----------------------------------------------------------------------------
; CONSTANTES DEL SISTEMA
; ----------------------------------------------------------------------------

; --- CONSTANTES DE LA PANTALLA ----------------------------------------------

PANWIDTH    EQU     640                     ; Ancho de la pantalla
PANHEIGH    EQU     480                     ; Altura de la pantalla
COLFND      EQU     $90EE90                 ; Color fondo de la pantalla
SCRFPS      EQU     50

; --- CONSTANTES DE LA MATRIZ ------------------------------------------------

SIZECLDA    EQU     20                      ; Tamaño de una celda en pixeles
NUMCLMNS    EQU     32                      ; Columnas de celdas
NUMFILAS    EQU     24                      ; Filas de celdas
TCELDAS     EQU     768                     ; Total de celdas

; --- CÓDIGOS DE TECLADO -----------------------------------------------------

KBDLEFT     EQU     $25
KBDUP       EQU     $26
KBDRIGHT    EQU     $27
KBDDOWN     EQU     $28

; --- IDENTIFICADORES DE SONIDO ----------------------------------------------

SNDEAT      EQU     0
SNDGMOV     EQU     1

; --- NÚMEROS DE TRAP --------------------------------------------------------

SCRUPTN     EQU     0                       ; Actualización de pantalla
KBDUPTN     EQU     1                       ; Número de trap del teclado
SNDPLTN     EQU     2                       ; Número de trap del sonido

; --- NÚMEROS DE INTERRUPCIÓN ------------------------------------------------

SCRINTN     EQU     1     










*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
