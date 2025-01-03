; ==============================================================================
; TABLE SCREEN
; ==============================================================================

; ------------------------------------------------------------------------------
TABINIT
; TABLE SCREEN INIT
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------

           
            RTS

; ------------------------------------------------------------------------------
TABUPD
; TABLE SCREEN UPDATE
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            MOVE.B  #19,D0                  ; Detectar teclas
            MOVE.L  #'S',D1                 ; C�digo ASCII de la tecla S
            TRAP    #15
            BTST.L  #0,D1                   ; Verificar si la tecla S est� presionada
            BEQ     END                     ; Si no est� presionada, continuar

            CLR.W (STANEXT)                 ; Cambiar STANEXT a 4 si la tecla P est� presionada


END:
           
            RTS

; ------------------------------------------------------------------------------
TABPLOT
; TABLE SCREEN PLOT
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------

            
            MOVEM.L D0-D3/A0-A1,-(A7)

            CLR.W   D3                        ; Inicializar contador de partidas
            ; Cerrar todos los archivos abiertos al inicio

            MOVE.B  #50,D0                    ; Cerrar todos los archivos
            TRAP    #15

            ; Abrir archivo existente
            LEA     .FILE,A1                  ; Direcci�n del nombre del archivo
            MOVE.B  #51,D0                    ; Abrir archivo existente
            TRAP    #15
            CMP.W   #0,D0                     ; Verificar si la operaci�n fue exitosa
            BNE     ERROR                     ; Saltar a error si D0 != 0
            MOVE.L  D1,FILEID                 ; Guardar el File-ID para operaciones posteriores

            CLR.L   D1                        ; Limpiar acumulador para n�mero actual
            LEA     ASCBFF,A0           ; Puntero al buffer donde acumularemos el n�mero

.LEC
            ; Leer un byte del archivo
            LEA     BFFLEC,A1                 ; Direcci�n del buffer temporal para lectura
            MOVE.L  FILEID,D1                 ; File-ID del archivo abierto
            MOVE.L  #1,D2                     ; Leer 1 byte
            MOVE.B  #53,D0                    ; Tarea 53: Leer archivo
            TRAP    #15
            CMP.W   #1,D0                     ; Verificar si alcanzamos EOF
            BEQ     .EOF                      ; Si D0 = 1, finalizar lectura

            MOVE.B  (A1),D0                   ; Mover el byte le�do a D0 para procesarlo

            ; Verificar si es marcador de fin de fichero `#`
            CMP.B   #'#',D0                   ; Comparar el byte le�do con `#`
            BEQ     .EOF                      ; Si es `#`, finalizar lectura

            ; Verificar si es delimitador de bloque `?`
            CMP.B   #'?',D0                   ; Comparar el byte le�do con `?`
            BEQ     .MOSTRAR_PARTIDA          ; Si es `?`, procesar el n�mero acumulado

            ; Si es un n�mero ASCII, acumular en el buffer
            CMP.B   #'0',D0                   ; Verificar si es un n�mero (>= '0')
            BLT     .LEC                      ; Si es menor, ignorar y leer el siguiente
            CMP.B   #'9',D0                   ; Verificar si es un n�mero (<= '9')
            BGT     .LEC                      ; Si es mayor, ignorar y leer el siguiente
            MOVE.B  D0,(A0)+                  ; Acumular car�cter en el buffer
            BRA     .LEC                      ; Continuar leyendo

.MOSTRAR_PARTIDA
            ; Terminar la cadena acumulada con un NULL
            MOVE.B  #0,(A0)                   ; A�adir NULL al final del buffer

            ; Mostrar "PARTIDA : " antes del n�mero
            LEA     .TXT1,A1                  ; Direcci�n del texto base
            MOVE.B  #14,D0                    ; Tarea 14: Mostrar texto sin CR, LF
            TRAP    #15

            ; Convertir n�mero del buffer de ASCII a decimal
            CLR.L   D1                        ; Acumulador para el n�mero convertido
            LEA     ASCBFF,A0           ; Direcci�n del buffer
.CONVERTIR
            MOVE.B  (A0)+,D0                  ; Leer car�cter del buffer
            CMP.B   #0,D0                     ; Verificar si es NULL (fin de cadena)
            BEQ     .MOSTRAR_NUMERO           ; Si es NULL, ir a mostrar el n�mero
            SUB.B   #48,D0                    ; Convertir de ASCII a decimal
            MULU    #10,D1                    ; Multiplicar acumulador por 10
            ADD.W   D0,D1                     ; Sumar el d�gito convertido
            BRA     .CONVERTIR                ; Continuar con el siguiente car�cter

.MOSTRAR_NUMERO
            ; Mostrar el n�mero convertido en D1
            MOVE.L  D1,D0                     ; Mover n�mero convertido a D0
            MOVE.B  #15,D0                    ; Tarea 15: Mostrar n�mero en base 10
            MOVE.B  #10,D2                    ; Base 10
            TRAP    #15

            ; Separar l�neas
	LEA	.TXT2,A1
            MOVE.B  #13,D0                    ; Carriage return
            TRAP    #15
            MOVE.B  #10,D0                    ; Line feed
            TRAP    #15

            ; Reiniciar el buffer para el siguiente n�mero
            LEA     ASCBFF,A0           ; Reiniciar puntero del buffer
            ADDQ.W  #1,D3                     ; Incrementar n�mero de partida
            BRA     .LEC                      ; Continuar lectura

.EOF
            ; Cerrar archivo
            MOVE.L  FILEID,D1                 ; File-ID del archivo
            MOVE.B  #56,D0                    ; Tarea 56: Cerrar archivo
            TRAP    #15

	CLR.L   D1
            MOVE.B  #81,D0
            TRAP    #15
            
            LEA     .TXT3,A0
            MOVE.B  #20,D0
            JSR     UTLPRINT


            MOVEM.L (A7)+,D0-D3/A0-A1
            RTS                               ; Retornar

.ERROR
            MOVE.B  #9,D0                     ; Terminar el programa
            TRAP    #15
.FILE       DC.B    'PUNTOS.TXT',0 ; Nombre del archivo, null-terminated
.TXT1       DC.B    'PARTIDA : ',0
.TXT2	DC.B	'',0
.TXT3	DC.B	'PRESS S TO RETURN',0
            DS.W    0

*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
