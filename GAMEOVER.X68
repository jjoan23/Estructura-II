; ==============================================================================
; GAME OVER SCREEN
; ==============================================================================

; ------------------------------------------------------------------------------
GOVINIT
; GAME OVER SCREEN INIT
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------

            CLR.W  (GOVTIMER)
            RTS

; ------------------------------------------------------------------------------
GOVUPD
; GAME OVER SCREEN UPDATE
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            MOVEM.L D0-D2/A1,-(A7)
            
            MOVE.B  #19,D0                  ; Detectar teclas
            MOVE.L  #'S',D1                 ; Código ASCII de la tecla S
            TRAP    #15
            BTST.L  #0,D1                   ; Verificar si la tecla S está presionada
            BEQ     CONT                    ; Si no está presionada, continuar

            CLR.W (STANEXT)                 ; Cambiar STANEXT a 4 si la tecla P está presionada


CONT

            
            
            ADDQ.W  #1,(GOVTIMER)
            CMP.W   #500,(GOVTIMER)
            BLT     .DONE
            CLR.W   (STANEXT)
.DONE


            
            CLR.L   D0                      ; BORRAMOS LOS REGISTROS QUE VAMOS A UTILIZAR
            CLR.L   D1
            CLR.L   D2
            
            MOVE.B  #50,D0                  ; CERRAMOS TODOS LOS ARCHIVOS
            TRAP    #15

            ; ABRIR/CREAR ARCHIVO
            LEA     FILE,A1
            MOVE.B  #52,D0
            TRAP    #15
            TST.L   D1                      ; Verificar si File-ID es válido

            BMI     ERROR                   ; Salta a la rutina de error si fallo

            MOVE.L  D1,FILEID               ; Guardar el File-ID para operaciones posteriores
            
           ; Buscar y sobrescribir marcador existente
            MOVE.L  FILEID,D1              ; File-ID del archivo abierto
            MOVE.L  #0,D2                  ; Posicionarse al inicio del archivo
            MOVE.B  #55,D0                 ; Tarea 55: Posicionar archivo
            TRAP    #15

.BUSCAR_MARCADOR
            LEA     BFFLEC,A1              ; Buffer para leer datos
            MOVE.L  FILEID,D1              ; File-ID del archivo abierto
            MOVE.L  #1,D2                  ; Leer 1 byte
            MOVE.B  #53,D0                 ; Tarea 53: Leer archivo
            TRAP    #15
            CMP.W   #1,D0                  ; Verificar si alcanzamos EOF
            BEQ     .ESCRIBIR              ; Si alcanzamos EOF, escribir al final
            CMP.B   #'#',(BFFLEC)          ; Comparar con el marcador `#`
            BEQ     .SOBRESCRIBIR          ; Si encontramos `#`, sobrescribirlo
            BRA     .BUSCAR_MARCADOR       ; Continuar buscando el marcador

.SOBRESCRIBIR
            ; Sobrescribir el marcador existente con los nuevos datos
            LEA     JGOPNTS,A1       	; Dirección de los datos a escribir
            MOVE.L  FILEID,D1              	; File-ID del archivo abierto
            MOVE.L  #2,D2    	; Tamaño de los datos a escribir
            MOVE.B  #54,D0                 	; Tarea 54: Escribir archivo
            TRAP    #15
            CMP.W   #0,D0                  	; Verificar si la operación fue exitosa
            BNE     ERROR                  	; Saltar a error si D0 != 0
            BRA     .MARCADOR              	; Escribir el nuevo marcador

.ESCRIBIR
            ; Posicionarse al final del archivo y escribir datos
            MOVE.L  FILEID,D1              	; File-ID del archivo abierto
            MOVE.L  #-1,D2                 	; Posicionarse al final del archivo
            MOVE.B  #55,D0                 	; Tarea 55: Posicionar archivo
            TRAP    #15
            LEA     JGOPNTS,A1       	; Dirección de los datos a escribir
            MOVE.L  FILEID,D1              	; File-ID del archivo abierto
            MOVE.L  #2,D2          	; Tamaño de los datos a escribir
            MOVE.B  #54,D0                 	; Tarea 54: Escribir archivo
            TRAP    #15	
            CMP.W   #0,D0                  	; Verificar si la operación fue exitosa
            BNE     ERROR                  	; Saltar a error si D0 != 0

.MARCADOR
            ; Escribir el nuevo marcador `#` al final del archivo
            LEA     MARKER,A1              ; Dirección del marcador
            MOVE.L  FILEID,D1              ; File-ID del archivo abierto
            MOVE.L  #1,D2                  ; Tamaño del marcador (1 byte)
            MOVE.B  #54,D0                 ; Tarea 54: Escribir archivo
            TRAP    #15
            CMP.W   #0,D0                  ; Verificar si la operación fue exitosa
            BNE     ERROR                  ; Saltar a error si D0 != 0
            ; CERRAR ARCHIVO

            MOVE.L  FILEID,D1   ; File-ID del archivo
            MOVE.B  #56,D0      ; Tarea 56: Cerrar archivo
            TRAP    #15    
            
                        
            MOVEM.L  (A7)+,D0-D2/A1
            
            RTS
            
ERROR
            MOVE.B  #9,D0       ; Terminar el programa
            TRAP    #15        
            
            
FILE        DC.B    'PUNTOS.TXT',0   
MARKER	DC.B	'#',0	; CENTINELA DE EOF #
            DS.W    0        
            
; ------------------------------------------------------------------------------
GOVPLOT
; GAME OVER SCREEN PLOT
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            MOVEM.L D0-D1/A0,-(A7)
            
            ;JSR     FONPLOT
            
            CLR.L   D1
            MOVE.B  #81,D0
            TRAP    #15
            
            LEA     .TXT1,A0
            MOVE.B  #10,D0
            JSR     UTLPRINT
            
            LEA     .TXT2,A0
            MOVE.B  #20,D0
            JSR     UTLPRINT
            
.DONE       MOVEM.L (A7)+,D0-D1/A0

            RTS
.TXT1       DC.B    'GAME OVER',0
.TXT2       DC.B    'WAIT TO RETURN TO MAIN PAGE OR PRESS KEY S',0
            DS.W    0


















*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~0~
*~Tab size~4~
