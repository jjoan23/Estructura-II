; ----------------------------------------------------------------------------
; MATRIZ
; ----------------------------------------------------------------------------

;-----------------------------------------------------------------------------
MTZINIT
; INICIALIZA LA MATRIZ, AL PRINCIPIO ESTÁ VACÍA
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : Variable ESTCLDS que contiene el estado de las celdas
; ----------------------------------------------------------------------------
            
            MOVEM.W D0/A0,-(A7)
            
            LEA ESTDCLDS, A0       ; Apunta al inicio de ESTDCLDS
            MOVE.W #TCELDAS, D0    ; Número total de celdas

CLNCLDS:
            CLR.B (A0)+            ; Coloca 0 en cada celda
            SUBI.W #1, D0          ; Decrementa el contador de celdas
            BNE CLNCLDS            ; Repite hasta que esten vacías
            
            MOVEM.W (A7)+,D0/A0

            RTS

;-----------------------------------------------------------------------------
CINDMTRZ
; CALCULA EL ÍNDICE DE UNA CELDA
; INPUT    : D1 = coordenada X pantalla, D2 = coordenada Y pantalla
; OUTPUT   : D0 = índice de la celda en ESTDCLDS
; MODIFIES : NONE
; ----------------------------------------------------------------------------

            MOVEM.W D0-D3,-(A7)

            ; Divide X por TCELDAS
            LSR.W #8, D1           ; D1 = X / 256
            LSR.W #2, D1           ; D1 = X / 1024 (256 * 4)
            MOVE.W D1, D3           ; Copia D1 a D3 para dividir por 3
DIV3X:      SUBQ.W #3, D3           ; Resta 3
            ADDQ.W #1, D1           ; Cuenta cuántas veces restamos
            BPL DIV3_X              ; Repite mientras sea positivo

            ; Divide Y por TCELDAS
            LSR.W #8, D2           ; D2 = Y / 256
            LSR.W #2, D2           ; D2 = Y / 1024
            MOVE.W D2, D3           ; Copia D2 a D3 para dividir por 3
DIV3Y:      SUBQ.W #3, D3           ; Resta 3
            ADDQ.W #1, D2           ; Cuenta cuántas veces restamos
            BPL DIV3_Y              ; Repite mientras sea positivo

            ; Calcula el índice
            MOVE.W D2, D0           ; D0 = Y_CELDA
            ASL.W #6, D0            ; D0 = Y_CELDA * NUMCLMNS (64 = 2^6)
            ADD.W D1, D0            ; D0 = Y_CELDA * NUMCLMNS + X_CELDA

            MOVEM.W (A7)+,D0-D3


            RTS
            
;-----------------------------------------------------------------------------
MCLDOCPD
; MARCA UNA CELDA COMO OCUPADA
; INPUT    : D0 = índice de la celda en ESTDCLDS
; OUTPUT   : NONE
; MODIFIES : Estado de la celda en la variable ESTDCLDS
; ----------------------------------------------------------------------------

            MOVEM.W A0,-(A7)

            LEA ESTDCLDS, A0                ; Dirección de la matriz en A0
            MOVE.B #1, (A0, D0.W)           ; Marca la celda como ocupada
            
            MOVEM.W (A7)+,A0
            
            RTS
            
;-----------------------------------------------------------------------------
MCLDVCIA
; MARCA UNA CELDA COMO VACÍA
; INPUT    : D0 = índice de la celda en ESTDCLDS
; OUTPUT   : NONE
; MODIFIES : Estado de la celda en la variable ESTDCLDS
; ----------------------------------------------------------------------------

            MOVEM.W A0,-(A7)

            LEA ESTDCLDS, A0                ; Direccion de la matriz en A0
            MOVE.B #0, (A0, D0.W)           ; Marca la celda como vacía
            
            MOVEM.W (A7)+,A0
            
            RTS

;-----------------------------------------------------------------------------
CNVICOOR
; Convierte un índice de celda a coordenadas de pantalla (X, Y)
; INPUT    : D0 = índice de la celda en ESTADO_CELDAS
; OUTPUT   : D1 = coordenada X, D2 = coordenada Y
; MODIFIES : NONE
; ----------------------------------------------------------------------------

            MOVEM.W D0-D2,-(A7)

            MOVE.W D0, D2        ; Copia el índice a D2 para calcular la fila
            LSR #6, D2           ; D2 = índice / NUM_COLUMNAS
            MOVE.W D0, D1        ; Índice a D1 para calcular la columna
            AND.W #$3F, D1       ; D1 = índice % NUM_COLUMNAS
            LSL #4, D1           ; D1 = columna * TAMANO_CELDA
            LSL #4, D2           ; D2 = fila * TAMANO_CELDA

            MOVEM.W (A7)+,D0-D2

            RTS



*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~0~
*~Tab size~4~
