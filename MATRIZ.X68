; ----------------------------------------------------------------------------
; MATRIZ
; ----------------------------------------------------------------------------

;-----------------------------------------------------------------------------
MTZINIT
; INICIALIZA LA MATRIZ, AL PRINCIPIO EST� VAC�A
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : Variable ESTCLDS que contiene el estado de las celdas
; ----------------------------------------------------------------------------
            
            MOVEM.W D0-D2/A0,-(A7)
            
            LEA ESTDCLDS,A0       ; Apunta al inicio de ESTDCLDS
            MOVE.W #TCELDAS,D0    ; N�mero total de celdas

CLNCLDS:
            CLR.B (A0)+            ; Coloca 0 en cada celda
            SUBI.W #1, D0          ; Decrementa el contador de celdas
            BNE CLNCLDS            ; Repite hasta que esten vac�as
            
            
            MOVE.W  (CBZPOSX),D1             ; VEMOS LA POSICION INICIAL DE LA CABEZA             
            MOVE.W  (CBZPOSY),D2
            JSR     CINDMTRZ
            JSR     CBZOCPD                 ; MARCAMOS LA POSICI�N COMO CABEZA
            
            MOVE.W  (SGMPOSX),D1
            MOVE.W  (SGMPOSY),D2             ; VEMOS LA POSICI�N DEL SEGMENTO
            JSR     CINDMTRZ
            JSR     SGMOCPD                 ; MARCAMOS LA POSICI�N DEL SEGMENTO
            
            MOVE.W  (SGMPOSX2),D1
            MOVE.W  (SGMPOSY2),D2            ; VEMOS LA POSICI�N DEL SEGMENTO 2
            JSR     CINDMTRZ
            JSR     SGMOCPD                 ; MARCAMOS LA POSICION DEL SEGMENTO 2
            
            MOVE.W  (COLPOSX),D1             ; VEMOS LA POSICI�N DE LA COLA
            MOVE.W  (COLPOSY),D2
            JSR     CINDMTRZ
            JSR     COLOCPD                 ; MARCAMOS LA POSICI�N DE LA COLA
            
            MOVE.W  (MNZPOSX),D1             ; VEMOS LA POSICI�N INICIAL DE LA MANZANA
            MOVE.W  (MNZPOSY),D2
            JSR     CINDMTRZ
            JSR     MNZOCPD                 ; MARCAMOS LA POSICI�N DE LA MANZANA
            
            
            MOVEM.W (A7)+,D0-D2/A0

            RTS

;-----------------------------------------------------------------------------
CINDMTRZ
; CALCULA EL �NDICE DE UNA CELDA
; INPUT    : D1 = coordenada X pantalla, D2 = coordenada Y pantalla
; OUTPUT   : D0 = �ndice de la celda en ESTDCLDS
; MODIFIES : NONE
; ----------------------------------------------------------------------------

             MOVEM.W D1-D3,-(A7)     ; Guarda los registros D1-D3 en la pila

            ; Divide X por SIZECLDA
            MOVE.W  D1,D3          ; Copia X a D3
            CLR.W   D1              ; Inicializa el cociente de X

DIVX:       CMP.W   #SIZECLDA,D3    ; Compara D3 con SIZECLDA
            BLT     ENDDIVX         ; Si D3 < SIZECLDA, salta a ENDDIVX
            SUB.W   #SIZECLDA,D3   ; Resta SIZECLDA de D3
            ADDQ.W  #1,D1          ; Incrementa el cociente de X
            BRA     DIVX            ; Repite el bucle

ENDDIVX:

            ; Divide Y por SIZECLDA
            MOVE.W  D2,D3          ; Copia Y a D3
            CLR.W   D2              ; Inicializa el cociente de Y

DIVY:       CMP.W   #SIZECLDA,D3    ; Compara D3 con SIZECLDA
            BLT     ENDDIVY         ; Si D3 < SIZECLDA, salta a ENDDIVY
            SUB.W   #SIZECLDA,D3   ; Resta SIZECLDA de D3
            ADDQ.W  #1, D2          ; Incrementa el cociente de Y
            BRA     DIVY            ; Repite el bucle

ENDDIVY:

            ; Calcula el �ndice
            CLR.W   D0
            MOVE.W  D2, D0          ; D0 = Y_CELDA
            ASL.W   #5, D0          ; D0 = Y_CELDA * NUMCLMNS (32 = 2^5)
            ADD.W   D1, D0          ; D0 = Y_CELDA * NUMCLMNS + X_CELDA

            MOVEM.W (A7)+,D1-D3     ; Restaura los registros D1-D3 desde la pila

            RTS  
            
;-----------------------------------------------------------------------------
CBZOCPD
; MARCA UNA CELDA COMO OCUPADA POR LA CABEZA
; INPUT    : D0 = �ndice de la celda en ESTDCLDS
; OUTPUT   : NONE
; MODIFIES : Estado de la celda en la variable ESTDCLDS
; ----------------------------------------------------------------------------

            MOVEM.W A0,-(A7)

            LEA     ESTDCLDS,A0                ; Direcci�n de la matriz en A0
            MOVE.B  #3,(A0, D0.W)           ; Marca la celda como ocupada
            
            MOVEM.W (A7)+,A0
            
            RTS
            
            
            
*;-----------------------------------------------------------------------------
*RSTCLD
*; RESTA 1 A LA CELDA PASADA POR PAR�METRO
*; INPUT    : D0 = �ndice de la celda en ESTDCLDS
*; OUTPUT   : NONE
*; MODIFIES : Estado de la celda en la variable ESTDCLDS
*; ----------------------------------------------------------------------------
*
*            MOVEM.W A0,-(A7)
*
*            LEA     ESTDCLDS, A0              ; Direcci�n de la matriz en A0
*            SUBQ.B   #1, (A0, D0.W)           ; Marca la celda como ocupada
*            
*            MOVEM.W (A7)+,A0
*            
*            RTS
           
;-----------------------------------------------------------------------------
MCLDVCIA
; MARCA UNA CELDA COMO VAC�A
; INPUT    : D0 = �ndice de la celda en ESTDCLDS
; OUTPUT   : NONE
; MODIFIES : Estado de la celda en la variable ESTDCLDS
; ----------------------------------------------------------------------------

            MOVEM.W A0,-(A7)

            LEA     ESTDCLDS,A0                ; Direccion de la matriz en A0
            MOVE.B  #0,(A0,D0.W)           ; Marca la celda como vac�a
            
            MOVEM.W (A7)+,A0
            
            RTS

;-----------------------------------------------------------------------------
SGMOCPD
; MARCA UNA CELDA COMO OCUPADA POR EL SEGMENTO
; INPUT    : D0 = �ndice de la celda en ESTDCLDS
; OUTPUT   : NONE
; MODIFIES : Estado de la celda en la variable ESTDCLDS
; ----------------------------------------------------------------------------

            MOVEM.W A0,-(A7)

            LEA ESTDCLDS,A0                ; Direcci�n de la matriz en A0
            MOVE.B #2,(A0,D0.W)           ; Marca la celda como ocupada
            
            MOVEM.W (A7)+,A0
            
            RTS
            
;-----------------------------------------------------------------------------
COLOCPD
; MARCA UNA CELDA COMO OCUPADA POR LA COLA
; INPUT    : D0 = �ndice de la celda en ESTDCLDS
; OUTPUT   : NONE
; MODIFIES : Estado de la celda en la variable ESTDCLDS
; ----------------------------------------------------------------------------

            MOVEM.W A0,-(A7)

            LEA ESTDCLDS,A0                ; Direcci�n de la matriz en A0
            MOVE.B #1,(A0,D0.W)           ; Marca la celda como ocupada
            
            MOVEM.W (A7)+,A0
            
            RTS


;-----------------------------------------------------------------------------
MNZOCPD
; MARCA UNA CELDA COMO OCUPADA POR LA MANZANA
; INPUT    : D0 = �ndice de la celda en ESTDCLDS
; OUTPUT   : NONE
; MODIFIES : Estado de la celda en la variable ESTDCLDS
; ----------------------------------------------------------------------------

            MOVEM.W A0,-(A7)

            LEA ESTDCLDS,A0                ; Direcci�n de la matriz en A0
            MOVE.B #4,(A0,D0.W)           ; Marca la celda como ocupada
            
            MOVEM.W (A7)+,A0
            
            RTS

            
;-----------------------------------------------------------------------------
CNVICOOR
; Convierte un �ndice de celda a coordenadas de pantalla (X, Y)
; INPUT    : D0 = �ndice de la celda en ESTADO_CELDAS
; OUTPUT   : D1 = coordenada X, D2 = coordenada Y
; MODIFIES : NONE
; ----------------------------------------------------------------------------

            MOVEM.W D0/D3-D4,-(A7)

            MOVE.W  D0,D2         ; Copia �ndice a D2 para calcular la fila
            LSR.W   #5,D2         ; D2 = �ndice / NUM_COLUMNAS (32 = 2^5)
            MOVE.W  D0,D1         ; Copia �ndice a D1 para calcular la columna
            AND.W   #$1F,D1       ; D1 = �ndice % NUM_COLUMNAS (31 = 0x1F) (CREO)

            ; Multiplica por TAMA�O_CELDA = 10
            MOVE.W  #SIZECLDA, D3
            MOVE.W  D1,D4         ; Copia D1 para multiplicar por 10
            CLR.W   D1            ; Inicializa resultado


MULTLOOPX: 
            CMP.W   #0,D4        ; �Quedan iteraciones?
            BEQ     ENDMULTX
            ADD.W   D3,D1         ; Suma TAMANO_CELDA (10) repetidamente

            SUBQ.W  #1,D4         ; Cuenta las iteraciones restantes
            BRA     MULTLOOPX     ; Repite mientras no sea 0
ENDMULTX: 
            MOVE.W  D2,D4         ; Copia D2 para multiplicar por 10
            CLR.W   D2            ; Inicializa resultado

MULTLOOPY: 
            CMP.W   #0,D4        ; �Quedan iteraciones?
            BEQ     ENDMULTY
            ADD.W   D3,D2         ; Suma TAMANO_CELDA (10) repetidamente
            SUBQ.W  #1,D4         ; Cuenta las iteraciones restantes
            BRA     MULTLOOPY     ; Repite mientras no sea 0
ENDMULTY:
            MOVEM.W (A7)+,D0/D3-D4

            RTS

; ----------------------------------------------------------------------------
CHECKCLD
; INPUT: D0 = �ndice de la celda
; OUTPUT: D0 = 0 si est� vac�a, 1 si est� ocupada
; MODIFIES: Ninguno
; ----------------------------------------------------------------------------

            LEA     ESTDCLDS,A0    ; Carga la direcci�n de la matriz ESTDCLDS
            MOVE.B  (A0,D0.W),D1   ; Carga el estado de la celda en D1
            CMP.B   #0,D1          ; Compara si est� vac�a (0)
            BEQ     CLDFREE         ; Si est� vac�a
            MOVE.W  #1,D0          ; Si est� ocupada, devuelve 1 (ocupada)

            RTS

CLDFREE:
            MOVE.W  #0,D0                 ; Devuelve 0 (libre)

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


            MOVEM.L D0-D3/D7/A0-A1,-(A7)
            
            LEA ESTDCLDS,A0       ; Apunta al inicio de ESTDCLDS
            MOVE.W #TCELDAS,D0    ; N�mero total de celdas

.CLNCLDS:
            CLR.B (A0)+            ; Coloca 0 en cada celda
            SUBI.W #1,D0          ; Decrementa el contador de celdas
            BNE .CLNCLDS           ; Repite hasta que esten vac�as
            
            
            MOVE.W  (CBZPOSX),D1             ; VEMOS LA POSICION INICIAL DE LA CABEZA             
            MOVE.W  (CBZPOSY),D2
            JSR     CINDMTRZ
            JSR     CBZOCPD                 ; MARCAMOS LA POSICI�N COMO CABEZA
            
            MOVE.W  (SGMPOSX),D1
            MOVE.W  (SGMPOSY),D2             ; VEMOS LA POSICI�N INICIAL DEL SEGMENTO
            JSR     CINDMTRZ
            JSR     SGMOCPD                 ; MARCAMOS LA POSICI�N DEL SEGMENTO
            
            MOVE.W  (SGMPOSX2),D1
            MOVE.W  (SGMPOSY2),D2             ; VEMOS LA POSICI�N INICIAL DEL SEGMENTO
            JSR     CINDMTRZ
            JSR     SGMOCPD                 ; MARCAMOS LA POSICI�N DEL SEGMENTO
            
            MOVE.W  (COLPOSX),D1             ; VEMOS LA POSICI�N INICIAL DE LA COLA
            MOVE.W  (COLPOSY),D2
            JSR     CINDMTRZ
            JSR     COLOCPD                 ; MARCAMOS LA POSICI�N DE LA COLA
            
            MOVE.W  (MNZPOSX),D1             ; VEMOS LA POSICI�N INICIAL DE LA MANZANA
            MOVE.W  (MNZPOSY),D2
            JSR     CINDMTRZ
            JSR     MNZOCPD                 ; MARCAMOS LA POSICI�N DE LA MANZANA
            
            
            
            SUBQ.W  #1,(JGOTIM)             ; RESTAMOS 1 AL TIMER
            CMP     #0,(JGOTIM)             ; VEMOS SI HA ACABADO EL TIEMPO
            BEQ     .GAMEOVER
            BRA     .FIN                     ; SALTAMOS DEPENDIENDO DEL VALOR
            
.GAMEOVER    MOVE.W  #3,(STANEXT)
 	CLR.L   D0                      ; BORRAMOS LOS REGISTROS QUE VAMOS A UTILIZAR
            CLR.L   D1
            CLR.L   D2
            CLR.L	D3
            CLR.L	(BFFLEC)
            
            ; ESCRIBIR PUNTUACI�N
            MOVE.B  #50,D0                  ; CERRAMOS TODOS LOS ARCHIVOS
            TRAP    #15

             ; Verificar si el archivo existe
            LEA     .FILE,A1                 ; Direcci�n del nombre del archivo
            MOVE.B  #59,D0                  ; Tarea 59: Verificar existencia del archivo
            TRAP    #15
            CMP.W   #0,D0                   ; Verificar si el archivo existe
            BEQ     .ABRIR_ARCHIVO          ; Si existe, abrir archivo
            BRA     .CREAR_ARCHIVO          ; Si no existe, crear archivo

.ABRIR_ARCHIVO
            ; Abrir archivo existente
            MOVE.B  #51,D0                  ; Abrir archivo existente
            TRAP    #15
            CMP.W   #0,D0                   ; Verificar si la operaci�n fue exitosa
            BNE     .ERROR                   ; Si falla, ir a ERROR
            MOVE.L  D1,FILEID               ; Guardar el File-ID para operaciones posteriores

            ; Leer hasta encontrar el marcador `#`
            MOVE.L  FILEID,D1               ; File-ID del archivo abierto
            MOVE.L  #0,D2                   ; Posicionarse al inicio del archivo
            MOVE.B  #55,D0                  ; Tarea 55: Posicionar archivo
            TRAP    #15

.BUSCAR_FINAL
            LEA     BFFLEC,A1               ; Buffer para leer datos
            MOVE.L  FILEID,D1               ; File-ID del archivo abierto
            MOVE.L  #1,D2                   ; Leer 1 byte
            MOVE.B  #53,D0                  ; Tarea 53: Leer archivo
            TRAP    #15
            CMP.W   #1,D0                   ; Verificar si alcanzamos EOF
            BEQ     .ESCRIBIR               ; Si alcanzamos EOF, escribir al final
            CMP.B   #'#',(BFFLEC)           ; Comparar con el marcador `#`
            BEQ     .POSICIONAR             ; Si encontramos el marcador, posicionarnos ah�
            ADDQ.L  #1,D3                   ; Incrementar contador de bytes le�dos
            BRA     .BUSCAR_FINAL           ; Continuar buscando el marcador

.POSICIONAR
            ; Posicionarse al marcador para sobrescribir
            MOVE.L  D3,D2                   ; Cargar la posici�n del marcador desde el contador
            MOVE.L  FILEID,D1               ; File-ID del archivo abierto
            MOVE.B  #55,D0                  ; Tarea 55: Posicionar archivo
            TRAP    #15
            BRA     .ESCRIBIR               ; Ir a escribir datos

.CREAR_ARCHIVO
            ; Crear archivo nuevo
            MOVE.B  #52,D0                  ; Tarea 52: Abrir o crear archivo
            TRAP    #15
            CMP.W   #0,D0                   ; Verificar si la operaci�n fue exitosa
            BNE     .ERROR                   ; Si falla, ir a ERROR
            MOVE.L  D1,FILEID               ; Guardar el File-ID para operaciones posteriores
            BRA     .ESCRIBIR               ; Ir directamente a escribir datos

.ESCRIBIR
            ; Convertir el n�mero en caracteres ASCII y escribirlos uno por uno
            LEA     JGOPNTS,A0              ; Direcci�n del n�mero
            MOVE.W  (A0),D0                 ; Cargar el n�mero en D0
            JSR     .CONVERTIR_NUMERO        ; Convertir n�mero a ASCII en el buffer

            ; Escribir los caracteres del buffer
            LEA     ASCBFF,A0         	; Direcci�n del buffer de caracteres ASCII
            

.ESCRIBIR_BUCLE:
            MOVE.B  (A0),D0                ; Leer car�cter del buffer
            BEQ     .ESCRIBIR_FIN_BLOQUE    ; Si terminador NULL, ir al delimitador
            MOVE.L  D3,D2                   ; Cargar posici�n actual
            MOVE.L  FILEID,D1               ; File-ID del archivo abierto
            MOVE.B  #55,D0                  ; Tarea 55: Posicionar archivo
            TRAP    #15                     ; Posicionar antes de escribir
            MOVE.B  #54,D0                  ; Tarea 54: Escribir archivo
	LEA	(A0),A1
	MOVE.L	#1,D2
            TRAP    #15                     ; Escribir car�cter
            CMP.W   #0,D0                   ; Verificar si la operaci�n fue exitosa
            BNE     .ERROR                   ; Si falla, ir a ERROR
            ADDQ.L  #1,D3                   ; Incrementar posici�n
	MOVE.B  (A0)+,D0                ; Restaurar car�cter actual
            BRA     .ESCRIBIR_BUCLE         ; Continuar con el siguiente car�cter

.ESCRIBIR_FIN_BLOQUE
            ; Escribir delimitador `?`
	LEA	.TXT1,A1
            JSR     .ESCRIBIR_CARACTER
            ; Escribir marcador `#`
	LEA	.TXT2,A1
            JSR     .ESCRIBIR_CARACTER
            BRA     .FINESC

.ESCRIBIR_CARACTER:
            MOVE.L  D3,D2                   ; Cargar posici�n actual
            MOVE.L  FILEID,D1               ; File-ID del archivo
            MOVE.B  #55,D0                  ; Tarea 55: Posicionar archivo
            TRAP    #15                     ; Posicionar antes de escribir
            MOVE.B  #54,D0                  ; Tarea 54: Escribir archivo
	MOVE.L	#1,D2
            TRAP    #15                     ; Escribir car�cter
            ADDQ.L  #1,D3                   ; Incrementar posici�n
            RTS                             ; Retornar

.FINESC
            ; Cerrar archivo
            MOVE.L  FILEID,D1               ; File-ID del archivo
            MOVE.B  #56,D0                  ; Tarea 56: Cerrar archivo
            TRAP    #15
.FIN
            MOVEM.L (A7)+,D0-D3/D7/A0-A1          ; Restaurar registros
            RTS                             ; Retornar

.CONVERTIR_NUMERO
	 MOVEM.L D0-D3/A1,-(A7)         ; Guardar registros usados en la pila

    ; Inicializaci�n
    LEA     ASCBFF,A1              ; Direcci�n del buffer
    MOVEQ   #10,D2                 ; Base decimal (10)

    ; Convertir n�mero hexadecimal a decimal y guardar d�gitos
.CONVERTDELO:
    DIVU    D2,D0                  ; Dividir D0 por 10: cociente en D0, residuo en bits bajos
    MOVE.W	D0,D3
    AND.L   #$000F,D0              ; Asegurarnos de trabajar con el residuo (0-9)
    ADD.B   #48,D0                 ; Convertir residuo a car�cter ASCII ('0'-'9')
    MOVE.B  D0,(A1)+               ; Almacenar car�cter en el buffer
    MOVE.W	D3,D0
    TST.W   D3                     ; Verificar si el cociente es 0
    BNE     .CONVERTDELO           ; Si no es 0, continuar con el pr�ximo d�gito

 		
    ; A�adir terminador NULL al final
    MOVE.B  #0,(A1)+               ; Finalizar cadena con NULL

    MOVEM.L (A7)+,D0-D3/A1         ; Restaurar registros usados
            RTS                         ; Retornar              	
.ERROR
            MOVE.B  #9,D0                   ; Tarea 9: Terminar el programa
            TRAP    #15
   
            
            
.FILE        DC.B    'PUNTOS.TXT',0 
.TXT1	DC.B	'?',0
.TXT2	DC.B	'#',0  
            DS.W    0        





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
            LEA     ESTDCLDS,A0            ; Apunta al inicio de ESTDCLDS
            MOVE.W  #TCELDAS,D0            ; N�mero total de celdas
            MOVE.W  #0,D3                   ; LO UTILIZAMOS PARA SABER EL INDICE EN EL QUE NOS ENCONTRAMOS
            CLR.W   D1
            CLR.W   D2
            

PLOTCLDS:
            MOVE.B  (A0)+,D1                ; MOVEMOS EL VALOR DE LA CELDA A D1
            CMP.B   #0,D1
            BEQ     PLOTVAC                 ; SALTA A DIBUJAR POSICI�N VAC�A
            CMP.B   #1,D1 
            BEQ     PLOTCOL                 ; SALTA A DIBUJAR COLA
            CMP.B   #2,D1
            BEQ     PLOTSEG                 ; SALTA A DIBUJAR SEGMENTO
            CMP.B   #3,D1
            BEQ     PLOTCBZ                 ; SALTA A DIBUJAR CABEZA
            CMP.B   #4,D1                 
            BEQ     PLOTAPPLE               ; SALTA A DIBUJAR MANZANA
  
DONEPLOT            
            ADDQ    #1,D3                   ; AUMENTAMOS EL INDICE DE CELDA PARA LA SIGUIENTE
            SUBI.W  #1,D0                  ; Decrementa el contador de celdas
            BNE     PLOTCLDS                ; Repite hasta que esten vac�as
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
