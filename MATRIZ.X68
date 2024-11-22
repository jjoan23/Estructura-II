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
            
            MOVE.W  CBZPOSX, D1             ; VEMOS LA POSICION DE LA CABEZA             
            MOVE.W  CBZPOSY, D2
            JSR     CINDMTRZ
            JSR     CBZOCPD
            
            
            
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

            MOVEM.W D0/D3-D4,-(A7)

            MOVE.W  D0,D2          ; Copia índice a D2 para calcular la fila
            LSR.W   #5,D2         ; D2 = índice / NUM_COLUMNAS (32 = 2^5)
            MOVE.W  D0,D1          ; Copia índice a D1 para calcular la columna
            AND.W   #$1F,D1       ; D1 = índice % NUM_COLUMNAS (31 = 0x1F) (CREO)

            ; Multiplica por TAMAÑO_CELDA = 10
            MOVE.W  #SIZECLDA, D3
            MOVE.W  D1,D4                   ; Copia D1 para multiplicar por 10
            CLR.W   D1                        ; Inicializa resultado


MULTLOOPX: 
            CMP.W   #0, D4        ; ¿Quedan iteraciones?
            BEQ     ENDMULTX
            ADD.W   D3,D1           ; Suma TAMANO_CELDA (10) repetidamente

            SUBQ.W  #1,D4          ; Cuenta las iteraciones restantes
            BRA     MULTLOOPX          ; Repite mientras no sea 0
ENDMULTX: 
            MOVE.W  D2,D4          ; Copia D2 para multiplicar por 10
            CLR.W   D2               ; Inicializa resultado

MULTLOOPY: 
            CMP.W   #0, D4        ; ¿Quedan iteraciones?
            BEQ     ENDMULTY
            ADD.W   D3,D2           ; Suma TAMANO_CELDA (10) repetidamente
            SUBQ.W  #1,D4          ; Cuenta las iteraciones restantes
            BRA     MULTLOOPY          ; Repite mientras no sea 0
ENDMULTY:
            MOVEM.W (A7)+,D0/D3-D4

            RTS


;-----------------------------------------------------------------------------
MTZPLOT
; INICIALIZA LA MATRIZ, AL PRINCIPIO ESTÁ VACÍA
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : Variable ESTCLDS que contiene el estado de las celdas
; ----------------------------------------------------------------------------


            LEA     ESTDCLDS, A0            ; Apunta al inicio de ESTDCLDS
            MOVE.W  #TCELDAS, D0            ; Número total de celdas
            MOVE.W  #0,D3                   ; LO UTILIZAMOS PARA SABER EL INDICE EN EL QUE NOS ENCONTRAMOS

PLOTCLDS:
            MOVE.B  (A0)+,D1                ; MOVEMOS EL VALOR DE LA CELDA A D1
            CMP.B   #0,D1
            BEQ     PLOTVAC                 ; SALTA A DIBUJAR POSICIÓN VACÍA
            CMP.B   #1,D1 
            BEQ     PLOTCBZ                 ; SALTA A DIBUJAR CABEZA
            CMP.B   #2,D1
            BEQ     PLOTCOL                 ; SALTA A DIBUJAR COLA
            CMP.B   #3,D1
            BEQ     PLOTSEG                 ; SALTA A DIBUJAR SEGMENTO
            CMP.B   #4,D1                 
            BEQ     PLOTMNZ                 ; SALTA A DIBUJAR MANZANA
  
DONEPLOT            
            ADDQ    #1,D3                   ; AUMENTAMOS EL INDICE DE CELDA PARA LA SIGUIENTE
            SUBI.W  #1, D0                  ; Decrementa el contador de celdas
            BNE     PLOTCLDS                ; Repite hasta que esten vacías
            RTS


PLOTVAC:    
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
            BRA     DONEPLOT                ; DIBUJADO HECHO 

PLOTCBZ:    
            MOVE.W  D0,-(A7)                ; GUARDAMOS D0
            MOVE.W  D3,D0                   ; PONEMOS EL INDICE DE LA CELDA EN D0 PARA CALCULAR SUS COORDENADAS
            JSR     CNVICOOR
            MOVE.L  D1,-(A7)
            
            ; SET COLOR DEL CONTORNO CABEZA
            MOVE.B  #80,D0
            MOVE.L  #CBZPCOL,D1
            TRAP    #15
            
            ; SET COLOR DEL RELLENO CABEZA
            MOVE.B  #81,D0
            MOVE.L  #CBZFCOL,D1
            TRAP    #15
            ; DIBUJAR CABEZA
            MOVE.B  #87,D0
            MOVE.L  (A7)+,D1
            MOVE.W  D3,-(A7)
            MOVE.W  D1,D3
            ADD.W   #CBZWIDTH,D3
            MOVE.W  D2,D4
            ADD.W   #CBZHEIGH,D4
            TRAP    #15
            
            MOVE.L  D1,-(A7)
            ; SET COLOR DEL CONTORNO OJO
            MOVE.B  #80,D0
            MOVE.L  #OJOPCOL,D1
            TRAP    #15
            
            ; SET COLOR DEL RELLENO OJO
            MOVE.B  #81,D0
            MOVE.L  #OJOFCOL,D1
            TRAP    #15
            ; DIBUJAR OJO
            MOVE.B  #88,D0
            MOVE.L  (A7)+,D1
            MOVE.L  D1,-(A7)
            MOVE.L  D2,-(A7)
            ADD.W   #OJOWIDTH/2,D1            
            MOVE.W  D1,D3
            ADD.W   #OJOWIDTH,D3
            ADD.W   #OJOHEIGH/2,D2
            MOVE.W  D2,D4
            ADD.W   #OJOHEIGH,D4
            TRAP    #15

            ; DEFINIR COORDENADAS IRIS
            MOVE.L  (A7)+,D2
            MOVE.L  (A7)+,D1
            ADD.W   #OJOWIDTH,D1
            ADD.W   #OJOHEIGH,D2
            MOVE.B  #82,D0
            TRAP    #15
            
            
            MOVE.W  (A7)+,D3
            MOVE.W  (A7)+,D0
            BRA     DONEPLOT                ; DIBUJADO HECHO 
            
PLOTCOL:    
            BRA     DONEPLOT                ; DIBUJADO HECHO 
            
PLOTSEG:    
            BRA     DONEPLOT                ; DIBUJADO HECHO    

PLOTMNZ:    
            BRA     DONEPLOT                ; DIBUJADO HECHO          





*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~0~
*~Tab size~4~
