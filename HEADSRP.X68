*-----------------------------------------------------------
* MANEJO DE LA CABEZA DE LA SERPIENTE
*-----------------------------------------------------------

; ------------------------------------------------------------------------------
HEADINIT
; INICIALIZAR CABEZA.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            MOVE.W  #PANWIDTH/2,(CBZPOSX)
            MOVE.W  #PANHEIGH/2,(CBZPOSY)
            CLR.W   (ESTDCBZ)
            MOVE.W  #0,(ESTDCBZ)
            RTS
            
; ------------------------------------------------------------------------------
HEADUPD
; ACTUALIZAR CABEZA.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------

            MOVEM.L D0-D3/D7/A0-A1,-(A7)

            ; Marcar celda actual como vacía
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
            ; Verificar colisiones con los bordes
            MOVE.W  (CBZPOSX),D1
            CMP.W   #PANWIDTH,D1                 ; Si CBZPOSX < 0
            BGT     GAMEOVER
            CMP.W   #0,D1          ; Si CBZPOSX >= PANWIDTH
            BLT     GAMEOVER

            MOVE.W  (CBZPOSY),D1
            CMP.W   #0,D1                 ; Si CBZPOSY < 0
            BLT     GAMEOVER
            CMP.W   #PANHEIGH,D1          ; Si CBZPOSY >= PANHEIGH
            BGT     GAMEOVER

            ;BRA     FIN
            
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

*            ; Verificar colisiones
*            JSR     CHECKCLD
*            CMP.W   #0,D0                 ; Si celda está libre
*            BEQ     MARKCLD
*            BRA     GAMEOVER              ; Colisión consigo misma

*
*MARKCLD:
*            ; Marcar nueva posición como ocupada por la cabeza
*            JSR     CBZOCPD
*            BRA     FIN
*
GAMEOVER:
            MOVE.B  #SNDGMOV,D7             ;PONER SONIDO GAME OVER
            TRAP    #SNDPLTN
            MOVE.W  #3,(STANEXT)
            
            CLR.L   D0                      ; BORRAMOS LOS REGISTROS QUE VAMOS A UTILIZAR
            CLR.L   D1
            CLR.L   D2
            CLR.L	D3
            CLR.L	(BFFLEC)
            
            ; ESCRIBIR PUNTUACIÓN
            MOVE.B  #50,D0                  ; CERRAMOS TODOS LOS ARCHIVOS
            TRAP    #15

             ; Verificar si el archivo existe
            LEA     FILE,A1                 ; Dirección del nombre del archivo
            MOVE.B  #59,D0                  ; Tarea 59: Verificar existencia del archivo
            TRAP    #15
            CMP.W   #0,D0                   ; Verificar si el archivo existe
            BEQ     .ABRIR_ARCHIVO          ; Si existe, abrir archivo
            BRA     .CREAR_ARCHIVO          ; Si no existe, crear archivo

.ABRIR_ARCHIVO
            ; Abrir archivo existente
            MOVE.B  #51,D0                  ; Abrir archivo existente
            TRAP    #15
            CMP.W   #0,D0                   ; Verificar si la operación fue exitosa
            BNE     ERROR                   ; Si falla, ir a ERROR
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
            BEQ     .POSICIONAR             ; Si encontramos el marcador, posicionarnos ahí
            ADDQ.L  #1,D3                   ; Incrementar contador de bytes leídos
            BRA     .BUSCAR_FINAL           ; Continuar buscando el marcador

.POSICIONAR
            ; Posicionarse al marcador para sobrescribir
            MOVE.L  D3,D2                   ; Cargar la posición del marcador desde el contador
            MOVE.L  FILEID,D1               ; File-ID del archivo abierto
            MOVE.B  #55,D0                  ; Tarea 55: Posicionar archivo
            TRAP    #15
            BRA     .ESCRIBIR               ; Ir a escribir datos

.CREAR_ARCHIVO
            ; Crear archivo nuevo
            MOVE.B  #52,D0                  ; Tarea 52: Abrir o crear archivo
            TRAP    #15
            CMP.W   #0,D0                   ; Verificar si la operación fue exitosa
            BNE     ERROR                   ; Si falla, ir a ERROR
            MOVE.L  D1,FILEID               ; Guardar el File-ID para operaciones posteriores
            BRA     .ESCRIBIR               ; Ir directamente a escribir datos

.ESCRIBIR
            ; Convertir el número en caracteres ASCII y escribirlos uno por uno
            LEA     JGOPNTS,A0              ; Dirección del número
            MOVE.W  (A0),D0                 ; Cargar el número en D0
            JSR     CONVERTIR_NUMERO        ; Convertir número a ASCII en el buffer

            ; Escribir los caracteres del buffer
            LEA     ASCBFF,A0         	; Dirección del buffer de caracteres ASCII
            

.ESCRIBIR_BUCLE:
            MOVE.B  (A0),D0                ; Leer carácter del buffer
            BEQ     .ESCRIBIR_FIN_BLOQUE    ; Si terminador NULL, ir al delimitador
            MOVE.L  D3,D2                   ; Cargar posición actual
            MOVE.L  FILEID,D1               ; File-ID del archivo abierto
            MOVE.B  #55,D0                  ; Tarea 55: Posicionar archivo
            TRAP    #15                     ; Posicionar antes de escribir
            MOVE.B  #54,D0                  ; Tarea 54: Escribir archivo
	LEA	(A0),A1
	MOVE.L	#1,D2
            TRAP    #15                     ; Escribir carácter
            CMP.W   #0,D0                   ; Verificar si la operación fue exitosa
            BNE     ERROR                   ; Si falla, ir a ERROR
            ADDQ.L  #1,D3                   ; Incrementar posición
	MOVE.B  (A0)+,D0                ; Restaurar carácter actual
            BRA     .ESCRIBIR_BUCLE         ; Continuar con el siguiente carácter

.ESCRIBIR_FIN_BLOQUE
            ; Escribir delimitador `?`
	LEA	TXT1,A1
            JSR     ESCRIBIR_CARACTER
            ; Escribir marcador `#`
	LEA	TXT2,A1
            JSR     ESCRIBIR_CARACTER
            BRA     FINESC

ESCRIBIR_CARACTER:
            MOVE.L  D3,D2                   ; Cargar posición actual
            MOVE.L  FILEID,D1               ; File-ID del archivo
            MOVE.B  #55,D0                  ; Tarea 55: Posicionar archivo
            TRAP    #15                     ; Posicionar antes de escribir
            MOVE.B  #54,D0                  ; Tarea 54: Escribir archivo
	MOVE.L	#1,D2
            TRAP    #15                     ; Escribir carácter
            ADDQ.L  #1,D3                   ; Incrementar posición
            RTS                             ; Retornar

FINESC
            ; Cerrar archivo
            MOVE.L  FILEID,D1               ; File-ID del archivo
            MOVE.B  #56,D0                  ; Tarea 56: Cerrar archivo
            TRAP    #15
FIN
            MOVEM.L (A7)+,D0-D3/D7/A0-A1          ; Restaurar registros
            RTS                             ; Retornar

CONVERTIR_NUMERO
	 MOVEM.L D0-D3/A1,-(A7)         ; Guardar registros usados en la pila

    ; Inicialización
    LEA     ASCBFF,A1              ; Dirección del buffer
    MOVEQ   #10,D2                 ; Base decimal (10)

    ; Convertir número hexadecimal a decimal y guardar dígitos
.CONVERTDELO:
    DIVU    D2,D0                  ; Dividir D0 por 10: cociente en D0, residuo en bits bajos
    MOVE.W	D0,D3
    AND.L   #$000F,D0              ; Asegurarnos de trabajar con el residuo (0-9)
    ADD.B   #48,D0                 ; Convertir residuo a carácter ASCII ('0'-'9')
    MOVE.B  D0,(A1)+               ; Almacenar carácter en el buffer
    MOVE.W	D3,D0
    TST.W   D3                     ; Verificar si el cociente es 0
    BNE     .CONVERTDELO           ; Si no es 0, continuar con el próximo dígito

 		
    ; Añadir terminador NULL al final
    MOVE.B  #0,(A1)+               ; Finalizar cadena con NULL

    MOVEM.L (A7)+,D0-D3/A1         ; Restaurar registros usados
            RTS                         ; Retornar              	
ERROR
            MOVE.B  #9,D0                   ; Tarea 9: Terminar el programa
            TRAP    #15
   
            
            
FILE        DC.B    'PUNTOS.TXT',0 
TXT1	DC.B	'?',0
TXT2	DC.B	'#',0  
            DS.W    0        


            
            
; ------------------------------------------------------------------------------
HEADPLOT
; DIBUJAR CABEZA.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
                       
            MOVE.W  D0,-(A7)               ; GUARDAMOS D0
            MOVE.W  D3,D0                  ; PONEMOS EL INDICE DE LA CELDA EN D0 PARA CALCULAR SUS COORDENADAS
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
            TRAP    #15                     ; DIBUJAMOS EL PRIMER OJO
            

            ; DEFINIR COORDENADAS IRIS
            MOVE.L  (A7)+,D2
            MOVE.L  (A7)+,D1
            ADD.W   #OJOWIDTH,D1
            ADD.W   #OJOHEIGH,D2
            MOVE.B  #82,D0
            TRAP    #15                     ; DIBUJAMOS EL PRIMER IRIS
            
            MOVE.W  (A7)+,D3
            MOVE.W  (A7)+,D0

            RTS






*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
