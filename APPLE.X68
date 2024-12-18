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
; OUTPUT:
; MODIFIES: MNZPOSX, MNZPOSY
; ----------------------------------------------------------------------------

            MOVEM.L D0,-(A7)

            ; Genera la coordenada X aleatoria
            JSR     UTLRAND
            ANDI.W  #NUMCLMNS-1, D0       ; Asegura que esté en [0, NUMCLMNS-1]
            MULU    #SIZECLDA, D0         ; Escala al tamaño real de las celdas
            MOVE.W  D0,D1
            MOVE.W  D0, MNZPOSX           ; Guarda la coordenada X generada
            
            ; Generar coordenada Y aleatoria
            JSR     UTLRAND
            ANDI.W  #NUMFILAS-1, D0       ; Asegura que esté en el rango [0, NUMFILAS-1]
            MULU    #SIZECLDA, D0         ; Escala al tamaño real de las celdas
            MOVE.W  D0,D2
            MOVE.W  D0, MNZPOSY           ; Guarda la coordenada Y generada
            
            MOVEM.L (A7)+,D0
            RTS 



*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
