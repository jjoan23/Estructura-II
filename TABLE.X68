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
            MOVE.L  #'S',D1                 ; Código ASCII de la tecla S
            TRAP    #15
            BTST.L  #0,D1                   ; Verificar si la tecla S está presionada
            BEQ     END                     ; Si no está presionada, continuar

            CLR.W (STANEXT)                 ; Cambiar STANEXT a 4 si la tecla P está presionada


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
            
            CLR.W   D3
            ; Cerrar todos los archivos abiertos al inicio

            MOVE.B  #50,D0                  ; Cerrar todos los archivos
            TRAP    #15

            ; Abrir o crear archivo

            LEA     .FILE,A1                ; Dirección del nombre del archivo
            MOVE.B  #51,D0                  ; Abrir o crear archivo
            TRAP    #15
            MOVE.L  D1,FILEID               ; Guardar el File-ID para operaciones posteriores
            CMP.W   #0,D0                    ; Verificar si la operación fue exitosa
            BNE     ERROR                    ; Saltar a error si D0 != 0


            ; Leer datos en el archivo
.LEC
            LEA     BFFLEC,A1             ; Dirección del buffer para guardar los datos a leer
            MOVE.L  FILEID,D1               ; File-ID del archivo abierto

            MOVE.L  #2,D2                   ; Número de bytes a leer (2 en este caso)
            MOVE.B  #53,D0                  ; Leer archivo
            TRAP    #15
            CMP.W   #1,D0                    ; Verificar si alcanzamos EOF
            BEQ     .EOF                     ; Si D0 = 1, finalizar lectura
            CMP.W   #2,D0                    ; Verificar si se leyeron los 2 bytes
            BEQ     ERROR                    ; Saltar a error si no se leyeron 2 bytes
            
            
            ; Verificar si el centinela está en los datos leídos
            LEA     BFFLEC,A0
            CMP.B   #'#',(A0)	; Comparar primer byte con el centinela
            BEQ     .EOF                   	; Si es '#', finalizar lectura
            CMP.B   #'#',1(A0)            	; Comparar segundo byte con el centinela
            BEQ     .EOF                   	; Si es '#', finalizar lectura
            
            ; Convertir ASCII a número binario
            LEA     BFFLEC,A0       ; Dirección del buffer en A0
            MOVE.B  (A0),D1         ; Leer el primer byte del buffer (carácter ASCII)
            SUB.B   #48,D1          ; Convertir de ASCII a dígito
            MOVE.B  1(A0),D2        ; Leer el segundo byte del buffer (carácter ASCII)
            SUB.B   #48,D2          ; Convertir de ASCII a dígito
            MULU    #10,D1          ; Multiplicar primer dígito por 10
            ADD     D2,D1           ; Sumar el segundo dígito

            ; Mostrar "PARTIDA : " + número
            LEA     .TXT1,A1                 ; Dirección del texto base
            MOVE.B  #14,D0                   ; Tarea 14: Mostrar texto sin CR, LF
            TRAP    #15

            MOVE.L  D1,D1                    ; Número convertido
            MOVE.B  #15,D0                   ; Tarea 15: Mostrar número en base 10
            MOVE.B  #10,D2                   ; Base 10
            TRAP    #15

            ; Separar líneas
            MOVE.B  #13,D0                   ; Carriage return
            TRAP    #15
            MOVE.B  #10,D0                   ; Line feed
            TRAP    #15

            ; Incrementar contador y continuar
            ADDQ.W  #1,D3                    ; Incrementar número de partida
            BRA     .LEC                     ; Repetir lectura


            

.EOF

            ; Cerrar archivo

            MOVE.L  FILEID,D1   ; File-ID del archivo
            MOVE.B  #56,D0      ; Tarea 56: Cerrar archivo
            TRAP    #15



            

            MOVEM.L (A7)+,D0-D3/A0-A1

            RTS

.ERROR
            MOVE.B  #9,D0       ; Terminar el programa
            TRAP    #15
           
            
.FILE       DC.B    'PUNTOS.TXT',0 ; Nombre del archivo, null-terminated
.TXT1       DC.B    'PARTIDA : ',0
            DS.W    0
*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
