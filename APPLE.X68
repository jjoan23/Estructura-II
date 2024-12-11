*-----------------------------------------------------------
* MANEJO DE LA MANZANA
*-----------------------------------------------------------
   
; ------------------------------------------------------------------------------
APPLEINIT
; Inicializa la manzana en una posición aleatoria
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : MNZPOSX, MNZPOSY, ESTDCLDS
; ------------------------------------------------------------------------------

            ; Llama a la función para generar la posición aleatoria
            JSR     GENPOSMNZ

            ; Convierte las coordenadas de la manzana a índice de la matriz
            JSR     CINDMTRZ

            ; Verifica si la celda está ocupada o libre
CHECK:
            JSR     CHECKCLD
            BEQ     MARKMNZ                  ; Si está libre

            ; Si la celda está ocupada
            JSR     GENPOSMNZ                ; Genera una nueva posición
            JSR     CINDMTRZ                 ; Convierte las nuevas coordenadas
            BRA     CHECK                    ; Repite la comprobación

MARKMNZ:
            ; Marca la celda como ocupada con la manzana (estado 4)
            JSR     MNZOCPD

            ; Dibuja la manzana en la pantalla
            JSR     APPLEPLOT

            RTS
            
            ;MOVE.W  #30,(MNZPOSX)   ;DE MOMENTO PONGO X E Y ELEGIDAS MANUALMENTE, EN TEORÍA DEBE SER ALEATORIO
            ;MOVE.W  #30,(MNZPOSY)

; ------------------------------------------------------------------------------
APPLEUPD
; Actualiza la posición de la manzana cuando la serpiente come
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : MNZPOSX, MNZPOSY, ESTDCLDS
; ------------------------------------------------------------------------------

            ; Convierte las coordenadas actuales de la manzana a índice de la matriz
            JSR     CINDMTRZ

            ; Marca la celda anterior como vacía
            JSR     MCLDVCIA

            ; Llama a la función para generar una nueva posición aleatoria
            JSR     GENPOSMNZ

            ; Convierte las nuevas coordenadas de la manzana a índice de la matriz
            JSR     CINDMTRZ

CHCKUPDT:
            JSR     CHECKCLD             ; Verifica si la celda está libre
            BEQ     NEWMNZ               ; Si está libre

            ; Si la celda está ocupada
            JSR     GENPOSMNZ            ; Genera una nueva posición
            JSR     CINDMTRZ             ; Convierte las nuevas coordenadas
            BRA     CHCKUPDT             ; Repite la comprobación

NEWMNZ:
            ; Marca la celda como ocupada con la manzana (estado 4)
            JSR     MNZOCPD

            ; Dibuja la nueva manzana en la pantalla
            JSR     APPLEPLOT

            RTS
            
; ------------------------------------------------------------------------------
APPLEPLOT
; Dibuja la manzana
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
           MOVE.W  D0,-(A7)
            MOVE.W  D3,D0
            JSR     CNVICOOR
            MOVE.L  D1,-(A7)                ; PRIMERO DEBEMOS DIBUJAR EL FONDO Y LUEGO LA MANZANA
            
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

            MOVE.W  D0,-(A7)
            MOVE.W  D3,D0
            JSR     CNVICOOR
            MOVE.L  D1,-(A7)
            
            MOVE.B  #80,D0
            MOVE.L  #MNZPCOL,D1            ; PONEMOS EL COLOR DE DIBUJADO AL COLOR DEL CONTORNO DE LA MANZANA
            TRAP    #15
            
            MOVE.B  #81,D0
            MOVE.L  #MNZFCOL,D1            ; PONEMOS EL COLOR DE DIBUJADO AL COLOR DEL RELLENO DE LA MANZANA
            TRAP    #15
            
            MOVE.B  #88,D0
            MOVE.L  (A7)+,D1
            MOVE.W  D3,-(A7)
            MOVE.W  D1,D3
            ADD.W   #SIZECLDA,D3
            MOVE.W  D2,D4                    ; DIBUJAMOS EL CIRCULO
            ADD.W   #SIZECLDA,D4
            TRAP    #15                     
                        
            MOVE.W  (A7)+,D3  
            MOVE.W  (A7)+,D0


            RTS

; ----------------------------------------------------------------------------
GENPOSMNZ
; Genera una posición aleatoria para la manzana
; INPUT: NONE
; OUTPUT: D1 = MNZPOSX , D2 = MNZPOSY
; MODIFIES: MNZPOSX, MNZPOSY
; ----------------------------------------------------------------------------

            MOVE.L D0, -(A7)

            ; Genera una coordenada X aleatoria
            MOVE.W  #NUMCLMNS, D0          ; Número total de columnas
            LEA     COUNTER, A1            ; Carga la dirección de la "semilla" (contador)
            ADD.W   (A1),D1                ; Incrementa el valor de la semilla
            MOVE.W  D1, (A1)               ; Guarda el nuevo valor de la semilla
            AND.W   #$FFFF, D1             ; Asegura que D1 esté dentro del rango
            LSR.W   #4, D1                 ; Desplaza a la derecha para obtener un valor dentro del rango
            AND.W   #$1F, D1               ; Máscara que asegura que el número esté dentro de 0-31
            MOVE.W  D1, MNZPOSX            ; Almacena la coordenada X de la manzana

            ; Genera una coordenada Y aleatoria
            MOVE.W  #NUMFILAS, D0          ; Número total de filas
            LEA     COUNTER, A1            ; Reutiliza la dirección de la semilla
            ADD.W   (A1),D2                ; Incrementa el valor de la semilla
            MOVE.W  D2, (A1)               ; Guarda el nuevo valor de la semilla
            AND.W   #$FFFF, D2             ; Asegura que D1 esté dentro del rango
            LSR.W   #4, D2                 ; Desplaza a la derecha para obtener un valor dentro del rango
            AND.W   #$1F, D2               ; Máscara que asegura que el número esté dentro de 0-31
            MOVE.W  D2, MNZPOSY            ; Almacena la coordenada Y de la manzana

            MOVE.L (A7)+, D0
            RTS 

; Semilla para el generador de números aleatorios (contador)
COUNTER     DS.W    1

*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
