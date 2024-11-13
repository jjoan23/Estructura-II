*-----------------------------------------------------------------------------
* SISTEMA
*-----------------------------------------------------------------------------
 
 
SYSINIT
; INICIA EL  SISTEMA
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ----------------------------------------------------------------------------
            RTS
 

MTZINIT
; INICIALIZA LA MATRIZ, AL PRINCIPIO ESTÁ VACÍA
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : Variable ESTCLDS que contiene el estado de las celdas
; ----------------------------------------------------------------------------
            
            LEA ESTDCLDS, A0       ; Apunta al inicio de ESTDCLDS
            MOVE.W #TCELDAS, D0    ; Número total de celdas

CLNCLDS:
            CLR.B (A0)+            ; Coloca 0 en cada celda
            SUBI.W #1, D0          ; Decrementa el contador de celdas
            BNE CLNCLDS            ; Repite hasta que esten vacías

            RTS

;-----------------------------------------------------------------------------

CINDMTRZ
; CALCULA EL ÍNDICE DE UNA CELDA
; INPUT    : D1 = coordenada X pantalla, D2 = coordenada Y pantalla
; OUTPUT   : D0 = índice de la celda en ESTDCLDS
; MODIFIES : NONE
; ----------------------------------------------------------------------------

            DIVU #TCELDAS, D1       ; X/TCELDAS: D1 = columna de la celda
            DIVU #TCELDAS, D2       ; Y/TCELDAS: D2 = fila de la celda

            MOVE.W D2, D0           ; D0 = Y_CELDA
            MULU #NUMCLMNS, D0      ; D0 = Y_CELDA * NUMCLMNS
            ADD.W D1, D0            ; D0 = Y_CELDA * NUMCLMNS + X_CELDA

            RTS
            
MCLDOCPD
; MARCA UNA CELDA COMO OCUPADA
; INPUT    : D0 = índice de la celda en ESTDCLDS
; OUTPUT   : NONE
; MODIFIES : Estado de la celda en la variable ESTDCLDS
; ----------------------------------------------------------------------------

            MOVE.B #1, ESTDCLDS(D0) ; Marca la celda como ocupada
            
            RTS
            
MCLDVCIA
; MARCA UNA CELDA COMO VACÍA
; INPUT    : D0 = índice de la celda en ESTDCLDS
; OUTPUT   : NONE
; MODIFIES : Estado de la celda en la variable ESTDCLDS
; ----------------------------------------------------------------------------

            MOVE.B #0, ESTDCLDS(D0) ; Marca la celda como vacía
            
            RTS







*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
