; ----------------------------------------------------------------------------
; PANTALLA DE TABLA
; ----------------------------------------------------------------------------

; ----------------------------------------------------------------------------
TABUPD
; Actualiza la pantalla de tabla
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : STANEXT
; ----------------------------------------------------------------------------
            MOVE.B  #19,D0                  ; Detecta las teclas
            MOVE.L  #'S',D1                 ; Código ASCII de la tecla S
            TRAP    #15
            BTST.L  #0,D1                   ; Verificar si se pulsa S
            BEQ     END                     ; Si no está presionada, continua

            CLR.W (STANEXT)
END:
            RTS

; ----------------------------------------------------------------------------
TABPLOT
; Dibuja la pantalla de tabla
; INPUT    : NONE
; OUTPUT   : Tabla
; MODIFIES : NONE
; ----------------------------------------------------------------------------
            
            MOVEM.L D0-D3/A0-A1,-(A7)

            CLR.W   D3                	; Inicializa contador de partidas

            MOVE.B  #50,D0                  ; Cierra todos los archivos
            TRAP    #15

            		; Abre el archivo existente
            LEA     .FILE,A1                ; Dirección del nombre del archivo
            MOVE.B  #51,D0                  ; Abre el archivo existente
            TRAP    #15
            CMP.W   #0,D0                   ; Verifica si ha funcionado
            BNE     ERROR                   ; Salta a error si D0 != 0
            MOVE.L  D1,FILEID               ; Guarda el File-ID

            CLR.L   D1                      ; Limpia el acumulador
            LEA     ASCBFF,A0               ; Puntero al buffer

.LEC
            ; Lee un byte del archivo
            LEA     BFFLEC,A1               ; Dirección del buffer temporal
            MOVE.L  FILEID,D1               ; File-ID del archivo abierto
            MOVE.L  #1,D2                   ; Lee 1 byte
            MOVE.B  #53,D0                  ; Lee el archivo
            TRAP    #15
            CMP.W   #1,D0                   ; Verifica si alcanzamos EOF
            BEQ     .EOF                    ; Si D0 = 1, finaliza la lectura

            MOVE.B  (A1),D0                 ; Mueve el byte leído a D0

            CMP.B   #'#',D0                 ; Comparar el byte leído con `#`
            BEQ     .EOF                    ; Si es `#`, finaliza la lectura

            CMP.B   #'?',D0                 ; Compara el byte leído con `?`
            BEQ     .MOSTRAR_PARTIDA        ; Si es `?`

            		; Si es un número ASCII
            CMP.B   #'0',D0                 ; Verifica si es un número(>= '0')
            BLT     .LEC                    ; Si es menor
            CMP.B   #'9',D0                 ; Verifica si es un número(<= '9')
            BGT     .LEC                    ; Si es mayor
            MOVE.B  D0,(A0)+                ; Acumula el carácter en el buffer
            BRA     .LEC                    ; Continua leyendo

.MOSTRAR_PARTIDA
            ; Termina la cadena acumulada con un NULL
            MOVE.B  #0,(A0)                 ; Añade NULL al final del buffer

            		; Muestra "PARTIDA : "
            LEA     .TXT1,A1                ; Dirección del texto base
            MOVE.B  #14,D0                  ; Muestra texto sin CR, LF
            TRAP    #15

            ; Convierte número del buffer de ASCII a decimal
            CLR.L   D1                      ; Acumulador para el número
            LEA     ASCBFF,A0               ; Dirección del buffer
.CONVERTIR
            MOVE.B  (A0)+,D0                ; Lee el carácter del buffer
            CMP.B   #0,D0                   ; Verifica si es NULL 
            BEQ     .MOSTRAR_NUMERO         ; Si es NULL
            SUB.B   #48,D0                  ; Convierte de ASCII a decimal
            MULU    #10,D1                  ; Multiplica el acumulador por 10
            ADD.W   D0,D1                   ; Suma el dígito convertido
            BRA     .CONVERTIR              ; Continua con el siguiente

.MOSTRAR_NUMERO
            ; Muestra el número convertido en D1
            MOVE.L  D1,D0                   ; Mueve el número convertido a D0
            MOVE.B  #15,D0                  ; Muestra l número en base 10
            MOVE.B  #10,D2                  ; Base 10
            TRAP    #15

            		; Separa las líneas
	LEA	.TXT2,A1
            MOVE.B  #13,D0                  ; Carriage return
            TRAP    #15
            MOVE.B  #10,D0                  ; Line feed
            TRAP    #15

            		; Reinicia el buffer para el siguiente
            LEA     ASCBFF,A0           	; Reinicia puntero del buffer
            ADDQ.W  #1,D3                   ; Incrementa número de partida
            BRA     .LEC                    ; Continuar lectura

.EOF
            ; Cierra el archivo
            MOVE.L  FILEID,D1               ; File-ID del archivo
            MOVE.B  #56,D0                  ; Tarea 56: Cerrar archivo
            TRAP    #15

	CLR.L   D1
            MOVE.B  #81,D0
            TRAP    #15
            
            LEA     .TXT3,A0
            MOVE.B  #20,D0
            JSR     UTLPRINT


            MOVEM.L (A7)+,D0-D3/A0-A1
            RTS

.ERROR
            MOVE.B  #9,D0
            TRAP    #15
            
.FILE       DC.B    'PUNTOS.TXT',0 	; Nombre del archivo, null-terminated
.TXT1       DC.B    'PARTIDA : ',0
.TXT2	DC.B	'',0
.TXT3	DC.B	'PRESS S TO RETURN',0
            DS.W    0




*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
