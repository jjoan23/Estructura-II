*-----------------------------------------------------------------------------
* MANEJO DE LA CABEZA DE LA SERPIENTE
*-----------------------------------------------------------------------------

; ----------------------------------------------------------------------------
HEADINIT
; Inicializa la cabeza
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : ESTDCBZ
; ----------------------------------------------------------------------------
            MOVE.W  #PANWIDTH/2,(CBZPOSX)
            MOVE.W  #PANHEIGH/2,(CBZPOSY)
            CLR.W   (ESTDCBZ)            ; Inicializar la cabeza en el centro
            MOVE.W  #0,(ESTDCBZ)
            RTS
            
; ----------------------------------------------------------------------------
HEADUPD
; Actualiza la cabeza
; INPUT    : NONE 
; OUTPUT   : Sonidos de comer y game over
; MODIFIES : Posiciones de la cabeza, posición de la manzana, STANEXT,
;            fichero de puntuaciones
; ----------------------------------------------------------------------------

            MOVEM.L D0-D3/D7/A0-A1,-(A7)

            ; Marca la celda actual como vacía
            MOVE.W  (CBZPOSX),D1
            MOVE.W  (CBZPOSY),D2
            JSR     CINDMTRZ
            JSR     MCLDVCIA
            
            ; Actualiza la posición de la cabeza según ESTDCBZ
            MOVE.W  (ESTDCBZ),D0
            CMP.W   #0,D0
            BEQ     SIGDER
            CMP.W   #1,D0
            BEQ     SIGARR
            CMP.W   #2,D0
            BEQ     SIGIZQ
            CMP.W   #3,D0
            BEQ     SIGABA

            ; Si no hay dirección válida, sale
            BRA     FIN

            ; Mueve la cabeza
SIGDER:
            ADD.W   #CBZVEL,(CBZPOSX)
            BRA     CHKBORDE

SIGARR:
            SUB.W   #CBZVEL,(CBZPOSY)
            BRA     CHKBORDE

SIGIZQ:
            SUB.W   #CBZVEL,(CBZPOSX)
            BRA     CHKBORDE

SIGABA:
            ADD.W   #CBZVEL,(CBZPOSY)
            
CHKBORDE:
            ; Verifica las colisiones con los bordes
            MOVE.W  (CBZPOSX),D1
            CMP.W   #PANWIDTH,D1	; Si CBZPOSX < 0
            BGT     GAMEOVER
            CMP.W   #0,D1          	; Si CBZPOSX >= PANWIDTH
            BLT     GAMEOVER

            MOVE.W  (CBZPOSY),D1
            CMP.W   #0,D1                 	; Si CBZPOSY < 0
            BLT     GAMEOVER
            CMP.W   #PANHEIGH,D1          	; Si CBZPOSY >= PANHEIGH
            BGT     GAMEOVER

                        
CHKCOL:
            ; Verifica la colisión con la manzana
            MOVE.W  (CBZPOSX),D1
            MOVE.W  (CBZPOSY),D2
            CMP.W   (MNZPOSX),D1
            BNE     NOCOL
            CMP.W   (MNZPOSY),D2
            BNE     NOCOL
            
            ; Colisión detectada
            JSR     APPLEUPD
            JSR     SCOUPD
            MOVE.B  #SNDEAT,D7
            TRAP    #SNDPLTN

NOCOL:
            ; Convierte la posición nueva a índice
            MOVE.W  (CBZPOSX),D1
            MOVE.W  (CBZPOSY),D2
            JSR     CINDMTRZ
            JSR     CBZOCPD                 ; Marca la celda como ocupada
            
            BRA     FIN


GAMEOVER:
            MOVE.B  #SNDGMOV,D7             ; Pone el sonido game over
            TRAP    #SNDPLTN
            MOVE.W  #3,(STANEXT)
            
            CLR.L   D0                      ; Borramos los registros que vamos 
            CLR.L   D1	; a utilizar para escribir en el fichero
            CLR.L   D2
            CLR.L	D3
            CLR.L	(BFFLEC)
            
            ; Escribie la puntuación
            MOVE.B  #50,D0                  ; Cerramos todos los archivos
            TRAP    #15

             ; Verifica si el archivo existe
            LEA     FILE,A1                 ; Dirección del nombre del archivo
            MOVE.B  #59,D0
            TRAP    #15
            CMP.W   #0,D0
            BEQ     .ABRIR_ARCHIVO          ; Si existe, abrir archivo
            BRA     .CREAR_ARCHIVO          ; Si no existe, crear archivo

.ABRIR_ARCHIVO
            ; Abre el archivo existente
            MOVE.B  #51,D0
            TRAP    #15
            CMP.W   #0,D0                   ; Verifica si ha funcionado
            BNE     ERROR                   ; Si falla, ir a ERROR
            MOVE.L  D1,FILEID               ; Guarda el File-ID

            ; Lee hasta encontrar el marcador `#`
            MOVE.L  FILEID,D1               ; File-ID del archivo abierto
            MOVE.L  #0,D2                   ; Se pone al inicio del archivo
            MOVE.B  #55,D0                  ; Pone el archivo
            TRAP    #15

.BUSCAR_FINAL
            LEA     BFFLEC,A1               ; Buffer para leer datos
            MOVE.L  FILEID,D1               ; File-ID del archivo abierto
            MOVE.L  #1,D2                   ; Leer 1 byte
            MOVE.B  #53,D0                  ; Tarea 53: Leer archivo
            TRAP    #15
            CMP.W   #1,D0                   ; Verifica si alcanzamos EOF
            BEQ     .ESCRIBIR               ; Si alcanza EOF, escribe al final
            CMP.B   #'#',(BFFLEC)           ; Compara con el marcador `#`
            BEQ     .POSICIONAR             ; Si encuentra el marcador
            ADDQ.L  #1,D3                   ; Incrementa el contador de bytes
            BRA     .BUSCAR_FINAL           ; Continua buscando el marcador

.POSICIONAR
            ; Posicionarse en el marcador para sobrescribir
            MOVE.L  D3,D2                   ; Carga la posición del marcador
            MOVE.L  FILEID,D1               ; File-ID del archivo abierto
            MOVE.B  #55,D0                  ; Tarea 55: Posicionar archivo
            TRAP    #15
            BRA     .ESCRIBIR

.CREAR_ARCHIVO
            ; Crea un archivo nuevo
            MOVE.B  #52,D0                  ; Abrir o crear archivo
            TRAP    #15
            CMP.W   #0,D0                   ; Verifica si ha funcionado
            BNE     ERROR                   ; Si falla, ir a ERROR
            MOVE.L  D1,FILEID               ; Guarda el File-ID
            BRA     .ESCRIBIR               ; Va directamente a escribir datos

.ESCRIBIR
            ; Convierte el número en caracteres ASCI y los escribe uno por uno
            LEA     JGOPNTS,A0              ; Dirección del número
            MOVE.W  (A0),D0                 ; Carga el número en D0
            JSR     CONVERTIR_NUMERO        ; Lo convierte a ASCII en el buffer

            ; Escribe los caracteres del buffer
            LEA     ASCBFF,A0         	; Dirección del buffer
            

.ESCRIBIR_BUCLE:
            MOVE.B  (A0),D0                	; Lee el carácter del buffer
            BEQ     .ESCRIBIR_FIN_BLOQUE    ; Si terminador NULL
            MOVE.L  D3,D2                   ; Carga la posición actual
            MOVE.L  FILEID,D1               ; File-ID del archivo abierto
            MOVE.B  #55,D0                  ; Tarea 55: Posicionar archivo
            TRAP    #15                     ; Posiciona antes de escribir
            MOVE.B  #54,D0                  ; Tarea 54: Escribir archivo
	LEA	(A0),A1
	MOVE.L	#1,D2
            TRAP    #15                     ; Escribe el carácter
            CMP.W   #0,D0                   ; Verifica si ha funcionado
            BNE     ERROR                   ; Si falla, ir a ERROR
            ADDQ.L  #1,D3                   ; Incrementa la posición
	MOVE.B  (A0)+,D0                ; Restaura el carácter actual
            BRA     .ESCRIBIR_BUCLE         ; Continua con el siguiente

.ESCRIBIR_FIN_BLOQUE
            ; Escribir delimitador `?`
	LEA	TXT1,A1
            JSR     ESCRIBIR_CARACTER
            ; Escribir marcador `#`
	LEA	TXT2,A1
            JSR     ESCRIBIR_CARACTER
            BRA     FINESC

ESCRIBIR_CARACTER:
            MOVE.L  D3,D2                   ; Carga la posición actual
            MOVE.L  FILEID,D1               ; File-ID del archivo
            MOVE.B  #55,D0                  ; Tarea 55: Posicionar archivo
            TRAP    #15                     ; Posiciona antes de escribir
            MOVE.B  #54,D0                  ; Tarea 54: Escribir archivo
	MOVE.L	#1,D2
            TRAP    #15                     ; Escribe el carácter
            ADDQ.L  #1,D3                   ; Incrementa la posición
            RTS

FINESC
            ; Cierra el archivo
            MOVE.L  FILEID,D1               ; File-ID del archivo
            MOVE.B  #56,D0                  ; Tarea 56: Cerrar archivo
            TRAP    #15
FIN
            MOVEM.L (A7)+,D0-D3/D7/A0-A1
            RTS

CONVERTIR_NUMERO
	 MOVEM.L D0-D3/A1,-(A7)

            ; Inicialización
            LEA     ASCBFF,A1              	; Dirección del buffer
            MOVEQ   #10,D2                 	; Base decimal (10)

            ; Convierte el número hexadecimal a decimal y guarda los dígitos
.CONVERTDELO:
            DIVU    D2,D0          ; Dividie D0 por 10: cociente en D0,
            MOVE.W	D0,D3          ; residuo en bits bajos
            AND.L   #$000F,D0      ; Asegura de trabajar con el residuo (0-9)
            ADD.B   #48,D0         ; Convierte el residuo a carácter ASCII
            MOVE.B  D0,(A1)+       ; Almacena el carácter en el buffer
            MOVE.W	D3,D0
            TST.W   D3             ; Verifica si el cociente es 0
            BNE     .CONVERTDELO   ; Si no es 0, continua con el próximo dígito
            
 		
            ; Añade el terminador NULL al final
            MOVE.B  #0,(A1)+               	; Finaliza la cadena con NULL
            
            MOVEM.L (A7)+,D0-D3/A1
            RTS          	
ERROR
            MOVE.B  #9,D0                   ; Tarea 9: Terminar el programa
            TRAP    #15
   
            
            
FILE        DC.B    'PUNTOS.TXT',0 
TXT1	DC.B	'?',0
TXT2	DC.B	'#',0  
            DS.W    0        


            
            
; ----------------------------------------------------------------------------
HEADPLOT
; Dibuja la cabeza
; INPUT    : NONE 
; OUTPUT   : NONE aparte de la salida del buffer
; MODIFIES : NONE
; ----------------------------------------------------------------------------
                       
            MOVE.W  D0,-(A7)               ; Guardamos D0
            MOVE.W  D3,D0                  ; Calculamos las coordenadas
            JSR     CNVICOOR
            MOVE.L  D1,-(A7)
            
            ; Ponemos el color de la cabeza
            MOVE.B  #80,D0
            MOVE.L  #CBZPCOL,D1
            TRAP    #15
            
            ; Ponemos el color de la cabeza
            MOVE.B  #81,D0
            MOVE.L  #CBZFCOL,D1
            TRAP    #15
            
            ; Dibujamos la cabeza
            MOVE.B  #87,D0
            MOVE.L  (A7)+,D1
            MOVE.W  D3,-(A7)
            MOVE.W  D1,D3
            ADD.W   #CBZWIDTH,D3
            MOVE.W  D2,D4
            ADD.W   #CBZHEIGH,D4
            TRAP    #15
            
            MOVE.L  D1,-(A7)
            
            ; Ponemos color del ojo
            MOVE.B  #80,D0
            MOVE.L  #OJOPCOL,D1
            TRAP    #15
            
            ; Ponemos el color del ojo
            MOVE.B  #81,D0
            MOVE.L  #OJOFCOL,D1
            TRAP    #15
            
            ; Dibujamos el ojo
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

            ; Define y dibuja el iris
            MOVE.L  (A7)+,D2
            MOVE.L  (A7)+,D1
            ADD.W   #OJOWIDTH,D1
            ADD.W   #OJOHEIGH,D2
            MOVE.B  #82,D0
            TRAP    #15                     
            
            MOVE.W  (A7)+,D3
            MOVE.W  (A7)+,D0

            RTS








*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
