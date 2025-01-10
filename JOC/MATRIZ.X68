; ----------------------------------------------------------------------------
; MATRIZ
; ----------------------------------------------------------------------------

;-----------------------------------------------------------------------------
MTZINIT
; Inicializa la matriz, al principio vacía
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : Variable ESTCLDS que contiene el estado de las celdas
; ----------------------------------------------------------------------------
            
            MOVEM.W D0-D2/A0,-(A7)
            
            LEA ESTDCLDS,A0       	; Apunta al inicio de ESTDCLDS
            MOVE.W #TCELDAS,D0    	; Número total de celdas

CLNCLDS:
            CLR.B (A0)+            	; Coloca 0 en cada celda
            SUBI.W #1, D0	; Decrementa el contador de celdas
            BNE CLNCLDS            	; Repite hasta que esten vacías
            
            
            MOVE.W  (CBZPOSX),D1            ; Vemos la posición de la cabeza             
            MOVE.W  (CBZPOSY),D2
            JSR     CINDMTRZ
            JSR     CBZOCPD                 ; Marca la posición de la cabeza
            
            MOVE.W  (SGMPOSX),D1
            MOVE.W  (SGMPOSY),D2            ; Vemos la posición del segmento
            JSR     CINDMTRZ
            JSR     SGMOCPD                 ; Marca la posición del segmento
            
            MOVE.W  (SGMPOSX2),D1
            MOVE.W  (SGMPOSY2),D2           ; Ve la posición del segmento 2
            JSR     CINDMTRZ
            JSR     SGMOCPD                 ; Marca la posición del segmento 2
            
            MOVE.W  (COLPOSX),D1            ; Vemos la posición de la cola
            MOVE.W  (COLPOSY),D2
            JSR     CINDMTRZ
            JSR     COLOCPD                 ; Marcamos la posición de la cola
            
            MOVE.W  (MNZPOSX),D1            ; Vemos la posicion de la manzana
            MOVE.W  (MNZPOSY),D2
            JSR     CINDMTRZ
            JSR     MNZOCPD                 ; Marca la posición de la manzana
            
            
            MOVEM.W (A7)+,D0-D2/A0

            RTS

;-----------------------------------------------------------------------------
CINDMTRZ
; Calcula el índice de una celda
; INPUT    : D1 = coordenada X pantalla, D2 = coordenada Y pantalla
; OUTPUT   : D0 = índice de la celda en ESTDCLDS
; MODIFIES : NONE
; ----------------------------------------------------------------------------

             MOVEM.W D1-D3,-(A7)

            ; Divide X por SIZECLDA
            MOVE.W  D1,D3          	; Copia X a D3
            CLR.W   D1              	; Inicializa el cociente de X

DIVX:       CMP.W   #SIZECLDA,D3    	; Compara D3 con SIZECLDA
            BLT     ENDDIVX         	; Si D3 < SIZECLDA,salta a ENDDIVX
            SUB.W   #SIZECLDA,D3   	; Resta SIZECLDA de D3
            ADDQ.W  #1,D1          	; Incrementa el cociente de X
            BRA     DIVX            	; Repite el bucle

ENDDIVX:

            ; Divide Y por SIZECLDA
            MOVE.W  D2,D3          	; Copia Y a D3
            CLR.W   D2              	; Inicializa el cociente de Y

DIVY:       CMP.W   #SIZECLDA,D3    	; Compara D3 con SIZECLDA
            BLT     ENDDIVY         	; Si D3 < SIZECLDA,salta a ENDDIVY
            SUB.W   #SIZECLDA,D3   	; Resta SIZECLDA de D3
            ADDQ.W  #1, D2          	; Incrementa el cociente de Y
            BRA     DIVY            	; Repite el bucle

ENDDIVY:

            ; Calcula el índice
            CLR.W   D0
            MOVE.W  D2, D0          	; D0 = Y_CELDA
            ASL.W   #5, D0          	; D0 = Y_CELDA * NUMCLMNS (32 = 2^5)
            ADD.W   D1, D0          	; D0 = Y_CELDA * NUMCLMNS + X_CELDA

            MOVEM.W (A7)+,D1-D3

            RTS  
            
;-----------------------------------------------------------------------------
CBZOCPD
; Marca una celda ocupada por la cabeza
; INPUT    : D0 = índice de la celda en ESTDCLDS
; OUTPUT   : NONE
; MODIFIES : Estado de la celda en la variable ESTDCLDS
; ----------------------------------------------------------------------------

            MOVEM.W A0,-(A7)

            LEA     ESTDCLDS,A0          	; Dirección de la matriz en A0
            MOVE.B  #3,(A0, D0.W)           ; Marca la celda como ocupada
            
            MOVEM.W (A7)+,A0
            
            RTS
            
            
                       
;-----------------------------------------------------------------------------
MCLDVCIA
; Marca una celda como vacía
; INPUT    : D0 = índice de la celda en ESTDCLDS
; OUTPUT   : NONE
; MODIFIES : Estado de la celda en la variable ESTDCLDS
; ----------------------------------------------------------------------------

            MOVEM.W A0,-(A7)

            LEA     ESTDCLDS,A0       	; Direccion de la matriz en A0
            MOVE.B  #0,(A0,D0.W)           	; Marca la celda como vacía
            
            MOVEM.W (A7)+,A0
            
            RTS

;-----------------------------------------------------------------------------
SGMOCPD
; Marca una celda ocupada por el segmento
; INPUT    : D0 = índice de la celda en ESTDCLDS
; OUTPUT   : NONE
; MODIFIES : Estado de la celda en la variable ESTDCLDS
; ----------------------------------------------------------------------------

            MOVEM.W A0,-(A7)

            LEA ESTDCLDS,A0                	; Dirección de la matriz en A0
            MOVE.B #2,(A0,D0.W)           	; Marca la celda como ocupada
            
            MOVEM.W (A7)+,A0
            
            RTS
            
;-----------------------------------------------------------------------------
COLOCPD
; Marca una celda ocupada por la cola
; INPUT    : D0 = índice de la celda en ESTDCLDS
; OUTPUT   : NONE
; MODIFIES : Estado de la celda en la variable ESTDCLDS
; ----------------------------------------------------------------------------

            MOVEM.W A0,-(A7)

            LEA ESTDCLDS,A0                	; Dirección de la matriz en A0
            MOVE.B #1,(A0,D0.W)           	; Marca la celda como ocupada
            
            MOVEM.W (A7)+,A0
            
            RTS


;-----------------------------------------------------------------------------
MNZOCPD
; Marca una celda ocupada por la manzana
; INPUT    : D0 = índice de la celda en ESTDCLDS
; OUTPUT   : NONE
; MODIFIES : Estado de la celda en la variable ESTDCLDS
; ----------------------------------------------------------------------------

            MOVEM.W A0,-(A7)

            LEA ESTDCLDS,A0                	; Dirección de la matriz en A0
            MOVE.B #4,(A0,D0.W)           	; Marca la celda como ocupada
            
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

            MOVE.W  D0,D2         	; Copia índice a D2
            LSR.W   #5,D2         	; D2 = índice/NUMCLMNS(32 = 2^5)
            MOVE.W  D0,D1         	; Copia índice a D1
            AND.W   #$1F,D1       	; D1 = índice%NUMCLMNS(31 = 0x1F)

            ; Multiplica por TAMAÑO_CELDA = 10
            MOVE.W  #SIZECLDA, D3
            MOVE.W  D1,D4         	; Copia D1 para multiplicar por 10
            CLR.W   D1            	; Inicializa resultado


MULTLOOPX: 
            CMP.W   #0,D4        	; ¿Quedan iteraciones?
            BEQ     ENDMULTX
            ADD.W   D3,D1         	; Suma TAMANO_CELDA repetidamente

            SUBQ.W  #1,D4         	; Cuenta las iteraciones restantes
            BRA     MULTLOOPX     	; Repite mientras no sea 0
ENDMULTX: 
            MOVE.W  D2,D4         	; Copia D2 para multiplicar por 10
            CLR.W   D2            	; Inicializa resultado

MULTLOOPY: 
            CMP.W   #0,D4        	; ¿Quedan iteraciones?
            BEQ     ENDMULTY
            ADD.W   D3,D2         	; Suma TAMANO_CELDA repetidamente
            SUBQ.W  #1,D4         	; Cuenta las iteraciones restantes
            BRA     MULTLOOPY     	; Repite mientras no sea 0
ENDMULTY:
            MOVEM.W (A7)+,D0/D3-D4

            RTS

; ----------------------------------------------------------------------------
CHECKCLD
; Verifica si una celda está ocupada o no
; INPUT     : D0 = índice de la celda
; OUTPUT    : D0 = 0 si está vacía, 1 si está ocupada
; MODIFIES  : NONE
; ----------------------------------------------------------------------------

            LEA     ESTDCLDS,A0
            MOVE.B  (A0,D0.W),D1
            CMP.B   #0,D1          	; Compara si está vacía (0)
            BEQ     CLDFREE         	; Si está vacía
            MOVE.W  #1,D0          	; Si está ocupada, devuelve 1

            RTS

CLDFREE:
            MOVE.W  #0,D0                 	; Devuelve 0 (libre)

            RTS


;-----------------------------------------------------------------------------
FONPLOT
; Dibujado del fondo
; INPUT    : NONE
; OUTPUT   : Fondo verde
; MODIFIES : NONE
; ----------------------------------------------------------------------------

            MOVE.W  D0,-(A7)
            MOVE.W  D3,D0
            JSR     CNVICOOR
            MOVE.L  D1,-(A7)
            
            MOVE.B  #80,D0
            MOVE.L  #COLFND,D1            	; Ponemos el color de dibujado
            TRAP    #15
            
            MOVE.B  #81,D0
            MOVE.L  #COLFND,D1            	; Ponemos el color del relleno
            TRAP    #15
            
            MOVE.B  #87,D0
            MOVE.L  (A7)+,D1
            MOVE.W  D3,-(A7)
            MOVE.W  D1,D3
            ADD.W   #SIZECLDA,D3
            MOVE.W  D2,D4                   ; Dibujamos el cuadrado
            ADD.W   #SIZECLDA,D4
            TRAP    #15                     
                        
            MOVE.W  (A7)+,D3  
            MOVE.W  (A7)+,D0
            RTS         



;-----------------------------------------------------------------------------
MTZUPD
; Actualiza la matriz casilla a casilla
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : Variable ESTCLDS que contiene el estado de las celdas
; ----------------------------------------------------------------------------


            MOVEM.L D0-D3/D7/A0-A1,-(A7)
            
            LEA ESTDCLDS,A0       	; Apunta al inicio de ESTDCLDS
            MOVE.W #TCELDAS,D0    	; Número total de celdas

.CLNCLDS:
            CLR.B (A0)+            	; Coloca 0 en cada celda
            SUBI.W #1,D0          	; Decrementa el contador
            BNE .CLNCLDS           	; Repite hasta que esten vacías
            
            
            MOVE.W  (CBZPOSX),D1            ; Vemos la posición de la cabexa             
            MOVE.W  (CBZPOSY),D2
            JSR     CINDMTRZ
            JSR     CBZOCPD                 ; Marca la posición de la cabeza
            
            MOVE.W  (SGMPOSX),D1
            MOVE.W  (SGMPOSY),D2            ; Vemos la posición del segmento
            JSR     CINDMTRZ
            JSR     SGMOCPD                 ; Marca la posición del segmento
            
            MOVE.W  (SGMPOSX2),D1
            MOVE.W  (SGMPOSY2),D2           ; Vemos la posición del segmento 2
            JSR     CINDMTRZ
            JSR     SGMOCPD                 ; Marca la posición del segmento 2
            
            MOVE.W  (COLPOSX),D1            ; Vemos la posicion de la cola
            MOVE.W  (COLPOSY),D2
            JSR     CINDMTRZ
            JSR     COLOCPD                 ; Marcamos la posicion de la cola
            
            MOVE.W  (MNZPOSX),D1            ; Vemos la posición de la manzana
            MOVE.W  (MNZPOSY),D2
            JSR     CINDMTRZ
            JSR     MNZOCPD                 ; Marca la posición de la manzana
            
            SUBQ.W  #1,(JGOTIM)             ; Restamos 1 al timer
            CMP     #0,(JGOTIM)             ; Mira si ha terminado el tiempo
            BEQ     .GAMEOVER
            BRA     .FIN                    ; Saltamos si no ha acabado
            
.GAMEOVER   
            MOVE.B  #SNDGMOV,D7             ; Pone el sonido game over
            TRAP    #SNDPLTN
            MOVE.W  #3,(STANEXT)
            

 	CLR.L   D0                      ; Borra los registros
            CLR.L   D1
            CLR.L   D2
            CLR.L	D3
            CLR.L	(BFFLEC)
            
            ; Escribe la puntuación
            MOVE.B  #50,D0                  ; Cerramos todos los archivos
            TRAP    #15

             ; Verifica si el archivo existe
            LEA     .FILE,A1                ; Dirección del nombre del archivo
            MOVE.B  #59,D0                  ; Verifica si existe el archivo
            TRAP    #15
            CMP.W   #0,D0                   ; Verifica si el archivo existe
            BEQ     .ABRIR_ARCHIVO          ; Si existe, abrir archivo
            BRA     .CREAR_ARCHIVO          ; Si no existe, crear archivo

.ABRIR_ARCHIVO
            ; Abre el archivo existente
            MOVE.B  #51,D0                  ; Abre el archivo existente
            TRAP    #15
            CMP.W   #0,D0                   ; Verifica si ha funcionado
            BNE     .ERROR                  ; Si falla, ir a ERROR
            MOVE.L  D1,FILEID               ; Guardar el File-ID

            ; Lee hasta encontrar el marcador `#`
            MOVE.L  FILEID,D1               ; File-ID del archivo abierto
            MOVE.L  #0,D2                   ; Posiciona al inicio del archivo
            MOVE.B  #55,D0                  ; Tarea 55: Posicionar archivo
            TRAP    #15

.BUSCAR_FINAL
            LEA     BFFLEC,A1               ; Buffer para leer datos
            MOVE.L  FILEID,D1               ; File-ID del archivo abierto
            MOVE.L  #1,D2                   ; Leer 1 byte
            MOVE.B  #53,D0                  ; Leer archivo
            TRAP    #15
            CMP.W   #1,D0                   ; Verificar si alcanzamos EOF
            BEQ     .ESCRIBIR               ; Si alcanzamos EOF
            CMP.B   #'#',(BFFLEC)           ; Comparar con el marcador `#`
            BEQ     .POSICIONAR             ; Si encontramos el marcador
            ADDQ.L  #1,D3                   ; Incrementar contador de bytes
            BRA     .BUSCAR_FINAL           ; Continuar buscando el marcador

.POSICIONAR
            ; Posicionarse al marcador para sobrescribir
            MOVE.L  D3,D2                   ; Cargar la posición del marcador
            MOVE.L  FILEID,D1               ; File-ID del archivo abierto
            MOVE.B  #55,D0                  ; Tarea 55: Posicionar archivo
            TRAP    #15
            BRA     .ESCRIBIR               ; Ir a escribir datos

.CREAR_ARCHIVO
            ; Crea un archivo nuevo
            MOVE.B  #52,D0                  ; Abrir o crear archivo
            TRAP    #15
            CMP.W   #0,D0                   ; Verifica si ha funcionado
            BNE     .ERROR                  ; Si falla, ir a ERROR
            MOVE.L  D1,FILEID               ; Guardar el File-ID
            BRA     .ESCRIBIR               ; Ir directamente a escribir datos

.ESCRIBIR
            ; Convierte el número en caracteres ASCI y los escribe uno por uno
            LEA     JGOPNTS,A0              ; Dirección del número
            MOVE.W  (A0),D0                 ; Carga el número en D0
            JSR     .CONVERTIR_NUMERO       ; Convierte el número a ASCII

            ; Escribe los caracteres del buffer
            LEA     ASCBFF,A0         	; Dirección del buffer
            

.ESCRIBIR_BUCLE:
            MOVE.B  (A0),D0                	; Lee el carácter del buffer
            BEQ     .ESCRIBIR_FIN_BLOQUE    ; Si terminador NULL
            MOVE.L  D3,D2                   ; Carga la posición actual
            MOVE.L  FILEID,D1               ; File-ID del archivo abierto
            MOVE.B  #55,D0                  ; Tarea 55: Posicionar archivo
            TRAP    #15                     ; Posicionar antes de escribir
            MOVE.B  #54,D0                  ; Tarea 54: Escribir archivo
	LEA	(A0),A1
	MOVE.L	#1,D2
            TRAP    #15                     ; Escribe el carácter
            CMP.W   #0,D0                   ; Verifica si ha funcionado
            BNE     .ERROR                  ; Si falla, ir a ERROR
            ADDQ.L  #1,D3                   ; Incrementa la posición
	MOVE.B  (A0)+,D0                ; Restaura el carácter actual
            BRA     .ESCRIBIR_BUCLE         ; Continua con el siguiente

.ESCRIBIR_FIN_BLOQUE
            ; Escribe delimitador `?`
	LEA	.TXT1,A1
            JSR     .ESCRIBIR_CARACTER
            ; Escribe marcador `#`
	LEA	.TXT2,A1
            JSR     .ESCRIBIR_CARACTER
            BRA     .FINESC

.ESCRIBIR_CARACTER:
            MOVE.L  D3,D2                   ; Carga la posición actual
            MOVE.L  FILEID,D1               ; File-ID del archivo
            MOVE.B  #55,D0                  ; Tarea 55: Posicionar archivo
            TRAP    #15                     ; Posicionar antes de escribir
            MOVE.B  #54,D0                  ; Tarea 54: Escribir archivo
	MOVE.L	#1,D2
            TRAP    #15                     ; Escribe el carácter
            ADDQ.L  #1,D3                   ; Incrementa la posición
            RTS

.FINESC
            ; Cierra el archivo
            MOVE.L  FILEID,D1               ; File-ID del archivo
            MOVE.B  #56,D0                  ; Cerrar archivo
            TRAP    #15
.FIN
            MOVEM.L (A7)+,D0-D3/D7/A0-A1
            RTS

.CONVERTIR_NUMERO
	 MOVEM.L D0-D3/A1,-(A7)

            ; Inicialización
            LEA     ASCBFF,A1              ; Dirección del buffer
            MOVEQ   #10,D2                 ; Base decimal (10)
            
            ; Convierte el número hexadecimal a decimal y guarda dígitos
.CONVERTDELO:
            DIVU    D2,D0             ; Divide D0 por 10: cociente en D0,
            MOVE.W	D0,D3             ; residuo en bits bajos
            AND.L   #$000F,D0         ; Trabaja con el residuo (0-9)
            ADD.B   #48,D0            ; Convertir residuo a carácter ASCII
            MOVE.B  D0,(A1)+          ; Almacena el carácter en el buffer
            MOVE.W	D3,D0
            TST.W   D3                ; Verifica si el cociente es 0
            BNE     .CONVERTDELO      ; Si no es 0, continuar con el próximo
            	
            ; Añade terminador NULL al final
            MOVE.B  #0,(A1)+               ; Finalizar cadena con NULL
            
            MOVEM.L (A7)+,D0-D3/A1
            RTS           	
.ERROR
            MOVE.B  #9,D0          ; Terminar el programa
            TRAP    #15
   
            
            
.FILE       DC.B    'PUNTOS.TXT',0 
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
            MOVE.W  #TCELDAS,D0            ; Número total de celdas
            MOVE.W  #0,D3                  ; Lo utilizamos para saber en el indice que nos encontramos
            CLR.W   D1
            CLR.W   D2
            

PLOTCLDS:
            MOVE.B  (A0)+,D1                ; Movemos el valor de la celda a D1
            CMP.B   #0,D1
            BEQ     PLOTVAC                 ; Salta a dibujar posición vacía
            CMP.B   #1,D1 
            BEQ     PLOTCOL                 ; Salta a dibujar cola
            CMP.B   #2,D1
            BEQ     PLOTSEG                 ; Salta a dibujar segmento
            CMP.B   #3,D1
            BEQ     PLOTCBZ                 ; Salta a dibujar cabeza
            CMP.B   #4,D1                 
            BEQ     PLOTAPPLE               ; Salta a dibujar manzana
  
DONEPLOT            
            ADDQ    #1,D3                   ; Aumentamos el indice de celda
            SUBI.W  #1,D0                  	; Decrementa el contador de celdas
            BNE     PLOTCLDS                ; Repite hasta que esten vacías
            MOVEM.L (A7)+,D0-D3/A0
            RTS
PLOTCBZ:
            JSR     HEADPLOT
            BRA     DONEPLOT

PLOTVAC:    
            JSR     FONPLOT
            BRA     DONEPLOT                ; Dibujado hecho 

PLOTCOL:   
            JSR     TAILPLOT 
            BRA     DONEPLOT                ; Dibujado hecho 
            
PLOTSEG:    
            JSR     SEGPLOT
            BRA     DONEPLOT                ; Dibujado hecho   

PLOTAPPLE:
            JSR     APPLEPLOT
            BRA     DONEPLOT            


























*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~0~
*~Tab size~4~
