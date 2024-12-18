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
            
            MOVEM.W D0-D2/A0,-(A7)
            
            LEA ESTDCLDS, A0       ; Apunta al inicio de ESTDCLDS
            MOVE.W #TCELDAS, D0    ; Número total de celdas

CLNCLDS:
            CLR.B (A0)+            ; Coloca 0 en cada celda
            SUBI.W #1, D0          ; Decrementa el contador de celdas
            BNE CLNCLDS            ; Repite hasta que esten vacías
            
            
            MOVE.W  CBZPOSX, D1             ; VEMOS LA POSICION INICIAL DE LA CABEZA             
            MOVE.W  CBZPOSY, D2
            JSR     CINDMTRZ
            JSR     CBZOCPD                 ; MARCAMOS LA POSICIÓN COMO CABEZA
            
            MOVE.W  SGMPOSX, D1
            MOVE.W  SGMPOSY, D2             ; VEMOS LA POSICIÓN INICIAL DEL SEGMENTO
            JSR     CINDMTRZ
            JSR     SGMOCPD                 ; MARCAMOS LA POSICIÓN DEL SEGMENTO
            
            MOVE.W  COLPOSX, D1             ; VEMOS LA POSICIÓN INICIAL DE LA COLA
            MOVE.W  COLPOSY, D2
            JSR     CINDMTRZ
            JSR     COLOCPD                 ; MARCAMOS LA POSICIÓN DE LA COLA
            
            MOVE.W  MNZPOSX, D1             ; VEMOS LA POSICIÓN INICIAL DE LA MANZANA
            MOVE.W  MNZPOSY, D2
            JSR     CINDMTRZ
            JSR     MNZOCPD                 ; MARCAMOS LA POSICIÓN DE LA MANZANA
            
            
            MOVEM.W (A7)+,D0-D2/A0

            RTS

;-----------------------------------------------------------------------------
CINDMTRZ
; CALCULA EL ÍNDICE DE UNA CELDA
; INPUT    : D1 = coordenada X pantalla, D2 = coordenada Y pantalla
; OUTPUT   : D0 = índice de la celda en ESTDCLDS
; MODIFIES : NONE
; ----------------------------------------------------------------------------

             MOVEM.W D1-D3,-(A7)     ; Guarda los registros D1-D3 en la pila

            ; Divide X por SIZECLDA
            MOVE.W  D1, D3          ; Copia X a D3
            CLR.W   D1              ; Inicializa el cociente de X

DIVX:       CMP.W   #SIZECLDA, D3    ; Compara D3 con SIZECLDA
            BLT     ENDDIVX         ; Si D3 < SIZECLDA, salta a ENDDIVX
            SUB.W   #SIZECLDA, D3   ; Resta SIZECLDA de D3
            ADDQ.W  #1, D1          ; Incrementa el cociente de X
            BRA     DIVX            ; Repite el bucle

ENDDIVX:

            ; Divide Y por SIZECLDA
            MOVE.W  D2, D3          ; Copia Y a D3
            CLR.W   D2              ; Inicializa el cociente de Y

DIVY:       CMP.W   #SIZECLDA, D3    ; Compara D3 con SIZECLDA
            BLT     ENDDIVY         ; Si D3 < SIZECLDA, salta a ENDDIVY
            SUB.W   #SIZECLDA, D3   ; Resta SIZECLDA de D3
            ADDQ.W  #1, D2          ; Incrementa el cociente de Y
            BRA     DIVY            ; Repite el bucle

ENDDIVY:

            ; Calcula el índice
            CLR.W   D0
            MOVE.W  D2, D0          ; D0 = Y_CELDA
            ASL.W   #5, D0          ; D0 = Y_CELDA * NUMCLMNS (32 = 2^5)
            ADD.W   D1, D0          ; D0 = Y_CELDA * NUMCLMNS + X_CELDA

            MOVEM.W (A7)+,D1-D3     ; Restaura los registros D1-D3 desde la pila

            RTS  
            
;-----------------------------------------------------------------------------
CBZOCPD
; MARCA UNA CELDA COMO OCUPADA POR LA CABEZA
; INPUT    : D0 = índice de la celda en ESTDCLDS
; OUTPUT   : NONE
; MODIFIES : Estado de la celda en la variable ESTDCLDS
; ----------------------------------------------------------------------------

            MOVEM.W A0,-(A7)

            LEA     ESTDCLDS, A0                ; Dirección de la matriz en A0
            MOVE.B  TRZPLOT, (A0, D0.W)           ; Marca la celda como ocupada
            
            MOVEM.W (A7)+,A0
            
            RTS
            
            
            
;-----------------------------------------------------------------------------
RSTCLD
; RESTA 1 A LA CELDA PASADA POR PARÁMETRO
; INPUT    : D0 = índice de la celda en ESTDCLDS
; OUTPUT   : NONE
; MODIFIES : Estado de la celda en la variable ESTDCLDS
; ----------------------------------------------------------------------------

            MOVEM.W A0,-(A7)

            LEA     ESTDCLDS, A0                ; Dirección de la matriz en A0
            SUBQ.B   #1, (A0, D0.W)           ; Marca la celda como ocupada
            
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
SGMOCPD
; MARCA UNA CELDA COMO OCUPADA POR EL SEGMENTO
; INPUT    : D0 = índice de la celda en ESTDCLDS
; OUTPUT   : NONE
; MODIFIES : Estado de la celda en la variable ESTDCLDS
; ----------------------------------------------------------------------------

            MOVEM.W A0,-(A7)

            LEA ESTDCLDS, A0                ; Dirección de la matriz en A0
            MOVE.B #2, (A0, D0.W)           ; Marca la celda como ocupada
            
            MOVEM.W (A7)+,A0
            
            RTS
            
;-----------------------------------------------------------------------------
COLOCPD
; MARCA UNA CELDA COMO OCUPADA POR LA COLA
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
MNZOCPD
; MARCA UNA CELDA COMO OCUPADA POR LA MANZANA
; INPUT    : D0 = índice de la celda en ESTDCLDS
; OUTPUT   : NONE
; MODIFIES : Estado de la celda en la variable ESTDCLDS
; ----------------------------------------------------------------------------

            MOVEM.W A0,-(A7)

            LEA ESTDCLDS, A0                ; Dirección de la matriz en A0
            MOVE.B #4, (A0, D0.W)           ; Marca la celda como ocupada
            
            MOVEM.W (A7)+,A0
            
            RTS

            
;-----------------------------------------------------------------------------
CNVICOOR
; Convierte un índice de celda a coordenadas de pantalla (X, Y)
; INPUT    : D0 = índice de la celda en ESTADO_CELDAS
; OUTPUT   : D1 = coordenada X, D2 = coordenada Y
; MODIFIES : NONE
; ----------------------------------------------------------------------------

            MOVEM.W D0/D3-D4,-(A7)

            MOVE.W  D0,D2         ; Copia índice a D2 para calcular la fila
            LSR.W   #5,D2         ; D2 = índice / NUM_COLUMNAS (32 = 2^5)
            MOVE.W  D0,D1         ; Copia índice a D1 para calcular la columna
            AND.W   #$1F,D1       ; D1 = índice % NUM_COLUMNAS (31 = 0x1F) (CREO)

            ; Multiplica por TAMAÑO_CELDA = 10
            MOVE.W  #SIZECLDA, D3
            MOVE.W  D1,D4         ; Copia D1 para multiplicar por 10
            CLR.W   D1            ; Inicializa resultado


MULTLOOPX: 
            CMP.W   #0, D4        ; ¿Quedan iteraciones?
            BEQ     ENDMULTX
            ADD.W   D3,D1         ; Suma TAMANO_CELDA (10) repetidamente

            SUBQ.W  #1,D4         ; Cuenta las iteraciones restantes
            BRA     MULTLOOPX     ; Repite mientras no sea 0
ENDMULTX: 
            MOVE.W  D2,D4         ; Copia D2 para multiplicar por 10
            CLR.W   D2            ; Inicializa resultado

MULTLOOPY: 
            CMP.W   #0, D4        ; ¿Quedan iteraciones?
            BEQ     ENDMULTY
            ADD.W   D3,D2         ; Suma TAMANO_CELDA (10) repetidamente
            SUBQ.W  #1,D4         ; Cuenta las iteraciones restantes
            BRA     MULTLOOPY     ; Repite mientras no sea 0
ENDMULTY:
            MOVEM.W (A7)+,D0/D3-D4

            RTS

; ----------------------------------------------------------------------------
CHECKCLD
; INPUT: D0 = índice de la celda
; OUTPUT: D0 = 0 si está vacía, 1 si está ocupada
; MODIFIES: Ninguno
; ----------------------------------------------------------------------------

            LEA     ESTDCLDS, A0    ; Carga la dirección de la matriz ESTDCLDS
            MOVE.B  (A0, D0.W),D1   ; Carga el estado de la celda en D1
            CMP.B   #0, D1          ; Compara si está vacía (0)
            BEQ     CLDFREE         ; Si está vacía
            MOVE.W  #1, D0          ; Si está ocupada, devuelve 1 (ocupada)

            RTS

CLDFREE:
            MOVE.W  #0, D0                 ; Devuelve 0 (libre)

            RTS


;-----------------------------------------------------------------------------
FONPLOT
; DIBUJADO DEL FONDO
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : Variable ESTCLDS que contiene el estado de las celdas
; ----------------------------------------------------------------------------

            MOVE.W  D0,-(A7)
            MOVE.W  D3,D0
            JSR     CNVICOOR
            MOVE.L  D1,-(A7)
            
            MOVE.B  #80,D0
            MOVE.L  #COLFND,D1            ; PONEMOS EL COLOR DE DIBUJADO A COLORFONDO
            TRAP    #15
            
            MOVE.B  #81,D0
            MOVE.L  #COLFND,D1            ; PONEMOS EL COLOR DE DIBUJADO A COLORFONDO
            TRAP    #15
            
            MOVE.B  #87,D0
            MOVE.L  (A7)+,D1
            MOVE.W  D3,-(A7)
            MOVE.W  D1,D3
            ADD.W   #SIZECLDA,D3
            MOVE.W  D2,D4                    ; DIBUJAMOS EL CUADRADO
            ADD.W   #SIZECLDA,D4
            TRAP    #15                     
                        
            MOVE.W  (A7)+,D3  
            MOVE.W  (A7)+,D0
            RTS         



;-----------------------------------------------------------------------------
MTZUPD
; ACTUALIZA LA MATRIZ CASILLA A CASILLA
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : Variable ESTCLDS que contiene el estado de las celdas
; ----------------------------------------------------------------------------


            MOVEM.W D0-D2/A0,-(A7)
            
            LEA ESTDCLDS, A0       ; Apunta al inicio de ESTDCLDS
            MOVE.W #TCELDAS, D0    ; Número total de celdas

.CLNCLDS:
            CLR.B (A0)+            ; Coloca 0 en cada celda
            SUBI.W #1, D0          ; Decrementa el contador de celdas
            BNE .CLNCLDS           ; Repite hasta que esten vacías
            
            
            MOVE.W  CBZPOSX, D1             ; VEMOS LA POSICION INICIAL DE LA CABEZA             
            MOVE.W  CBZPOSY, D2
            JSR     CINDMTRZ
            JSR     CBZOCPD                 ; MARCAMOS LA POSICIÓN COMO CABEZA
            
            MOVE.W  SGMPOSX, D1
            MOVE.W  SGMPOSY, D2             ; VEMOS LA POSICIÓN INICIAL DEL SEGMENTO
            JSR     CINDMTRZ
            JSR     SGMOCPD                 ; MARCAMOS LA POSICIÓN DEL SEGMENTO
            
            MOVE.W  COLPOSX, D1             ; VEMOS LA POSICIÓN INICIAL DE LA COLA
            MOVE.W  COLPOSY, D2
            JSR     CINDMTRZ
            JSR     COLOCPD                 ; MARCAMOS LA POSICIÓN DE LA COLA
            
            MOVE.W  MNZPOSX, D1             ; VEMOS LA POSICIÓN INICIAL DE LA MANZANA
            MOVE.W  MNZPOSY, D2
            JSR     CINDMTRZ
            JSR     MNZOCPD                 ; MARCAMOS LA POSICIÓN DE LA MANZANA
            
            
            MOVEM.W (A7)+,D0-D2/A0

            RTS



;-----------------------------------------------------------------------------
MTZPLOT
; DIBUJA LA MATRIZ CASILLA A CASILLA
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : Variable ESTCLDS que contiene el estado de las celdas
; ----------------------------------------------------------------------------
            MOVEM.L D0-D3/A0,-(A7)

            CLR.W   D0
            CLR.W   D3
            LEA     ESTDCLDS, A0            ; Apunta al inicio de ESTDCLDS
            MOVE.W  #TCELDAS, D0            ; Número total de celdas
            MOVE.W  #0,D3                   ; LO UTILIZAMOS PARA SABER EL INDICE EN EL QUE NOS ENCONTRAMOS
            CLR.W   D1
            CLR.W   D2
            

PLOTCLDS:
            MOVE.B  (A0)+,D1                ; MOVEMOS EL VALOR DE LA CELDA A D1
            CMP.B   #0,D1
            BEQ     PLOTVAC                 ; SALTA A DIBUJAR POSICIÓN VACÍA
            CMP.B   #1,D1 
            BEQ     PLOTCOL                 ; SALTA A DIBUJAR COLA
            CMP.B   #2,D1
            BEQ     PLOTSEG                 ; SALTA A DIBUJAR SEGMENTO
            CMP.B   TRZPLOT,D1
            BEQ     PLOTCBZ                 ; SALTA A DIBUJAR CABEZA
            CMP.B   #4,D1                 
            BEQ     PLOTAPPLE               ; SALTA A DIBUJAR MANZANA
  
DONEPLOT            
            ADDQ    #1,D3                   ; AUMENTAMOS EL INDICE DE CELDA PARA LA SIGUIENTE
            SUBI.W  #1, D0                  ; Decrementa el contador de celdas
            BNE     PLOTCLDS                ; Repite hasta que esten vacías
            MOVEM.L (A7)+,D0-D3/A0
            RTS
PLOTCBZ:
            JSR     HEADPLOT
            BRA     DONEPLOT

PLOTVAC:    
            JSR     FONPLOT
            BRA     DONEPLOT                ; DIBUJADO HECHO 

PLOTCOL:   
            JSR     TAILPLOT 
            BRA     DONEPLOT                ; DIBUJADO HECHO 
            
PLOTSEG:    
            JSR     SEGPLOT
            BRA     DONEPLOT                ; DIBUJADO HECHO    

PLOTAPPLE:
            JSR     APPLEPLOT
            BRA     DONEPLOT            













*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~0~
*~Tab size~4~
