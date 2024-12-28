*-----------------------------------------------------------
* MANEJO DE LA COLA DE LA SERPIENTE
*-----------------------------------------------------------
   
; ------------------------------------------------------------------------------
TAILINIT
; INICIALIZAR COLA.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------

            MOVE.W  #(PANWIDTH/2)-CBZWIDTH-SGMWIDTH+(COLWIDTH/2),(COLPOSX)
            MOVE.W  #(PANHEIGH/2),(COLPOSY)
            
            RTS
            
            
; ------------------------------------------------------------------------------
TAILUPD
; ACTUALIZAR COLA.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            MOVEM.W D1-D2,-(A7)
            
            ; Marca la posición actual de la cola como vacía
            MOVE.W  (COLPOSX),D1
            MOVE.W  (COLPOSY),D2
            JSR     CINDMTRZ
            JSR     MCLDVCIA
*
            ; Actualiza la posición de la cola para seguir al último segmento
            MOVE.W  (SGMPOSX2),(COLPOSX)
            MOVE.W  (SGMPOSY2),(COLPOSY)    ; MARCAMOS LA COOORDENADA DE LA COLA COMO COORDENADA DEL SEGMENTO 2

*            ; Guarda la última posición de la cola
*            MOVE.W  (COLPOSX),(LASTCOLX)
*            MOVE.W  (COLPOSY),(LASTCOLY)
*
*            ; Marca la nueva posición de la cola como ocupada
*            MOVE.W  (COLPOSX),D1             ; Nueva posición X
*            MOVE.W  (COLPOSY),D2             ; Nueva posición Y
*            JSR     CINDMTRZ
*            JSR     COLOCPD
*            
*            ; Verifica si se debe crecer
*            MOVE.W  NUMSGMS, D0
*            CMP.W   #0, D0
*            BEQ     FINUPD
*            
*            ; Incrementa el tamaño de la cola
*            SUBQ.W  #1, NUMSGMS
*            MOVE.W  (LASTCOLX),(COLPOSX)     ; Restaura la posición anterior
*            MOVE.W  (LASTCOLY),(COLPOSY)
*            
            ; Marca la nueva posición como cola
            MOVE.W  (COLPOSX),D1
            MOVE.W  (COLPOSY),D2
            JSR     CINDMTRZ
            JSR     COLOCPD

; CRECER SEGMENTOS
*            ; Actualizar segmentos de la cola
*            MOVE.W  (COLSIZE),D0           ; Número actual de segmentos
*            CMP.W   #0,D0
*            BEQ     NO_SEGS               ; Si no hay segmentos, salir
*
*            ; Desplazar los segmentos hacia atrás
*            LEA     COLSEGSX,A0
*            LEA     COLSEGSY,A1
*            MOVE.W  (COLPOSX), (A0,D0.W)  ; Guardar posición de la cola
*            MOVE.W  (COLPOSY), (A1,D0.W)
*
*NO_SEGS:
*            ; Crecer si es necesario
*            MOVE.W  (NUMSGMS),D1
*            CMP.W   #0,D1
*            BEQ     FINUPD               ; Si no hay crecimiento pendiente, salir
*
*            SUBQ.W  #1,(NUMSGMS)           ; Reducir el contador de crecimiento
*            ADDQ.W  #1,(COLSIZE)           ; Incrementar el tamaño de la cola
            
*            MOVE.W  COLPOSX,D1
*            MOVE.W  COLPOSY,D2
*            JSR     CINDMTRZ
*            JSR     RSTCLD 

FINUPD
            MOVEM.W (A7)+,D1-D2
            RTS
            
; ------------------------------------------------------------------------------
TAILPLOT
; DIBUJAR COLA
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------

            MOVE.W  D0,-(A7)
            MOVE.W  D3,D0
            JSR     CNVICOOR
            MOVE.L  D1,-(A7)
            
            MOVE.B  #80,D0
            MOVE.L  #COLPCOL,D1            ; PONEMOS EL COLOR DE DIBUJADO AL COLOR DEL CONTORNO DE LA COLA
            TRAP    #15
            
            MOVE.B  #81,D0
            MOVE.L  #COLFCOL,D1            ; PONEMOS EL COLOR DE DIBUJADO AL COLOR DEL RELLENO DE LA COLA
            TRAP    #15
            
            MOVE.B  #87,D0
            MOVE.L  (A7)+,D1
            MOVE.W  D3,-(A7)
            MOVE.W  D1,D3
            ADD.W   #SIZECLDA,D3
            MOVE.W  D2,D4                    
            ADD.W   #SIZECLDA,D4
            TRAP    #15                    ; DIBUJAMOS EL CUADRADO 
                        
            MOVE.W  (A7)+,D3  
            MOVE.W  (A7)+,D0

            RTS


*            MOVEM.L D0-D5,-(A7)
*
*; CODIGO SEGMENTOS
            ; Itera sobre cada segmento de la cola y lo dibuja
*DRAW_LOOP:
            ; Convierte la posición de segmento actual a coordenadas
*            MOVE.W  (COLPOSX),D1
*            MOVE.W  (COLPOSY),D2
*            JSR     CNVICOOR

            ; Dibuja segmento actual
*            MOVE.B  #80, D0
*            MOVE.L  #COLPCOL, D1
*            TRAP    #15
*            MOVE.B  #81, D0
*            MOVE.L  #COLFCOL, D1
*            TRAP    #15
*            MOVE.B  #87, D0
*            TRAP    #15

            ; Ir al siguiente segmento
            ; (Lógica de iteración según cómo estén almacenados los segmentos)

*            BRA     DRAW_LOOP  ; Repetir para cada segmento para cada segmento


*            ; Inicializar contador de segmentos
*            MOVE.W  (COLSIZE),D5           ; Número de segmentos en la cola
*            CMP.W   #0,D5                ; Si no hay segmentos, salir
*            BEQ     FIN_PLOT
*
*            ; Configurar colores
*            MOVE.B  #80,D0
*            MOVE.L  #COLPCOL,D1          ; Color del contorno
*            TRAP    #15
*
*            MOVE.B  #81,D0
*            MOVE.L  #COLFCOL,D1          ; Color de relleno
*            TRAP    #15
*
*            ; Iterar sobre los segmentos de la cola
*            LEA     COLSEGSX,A0          ; Apuntar al inicio de las coordenadas X
*            LEA     COLSEGSY,A1          ; Apuntar al inicio de las coordenadas Y
*
*PLOT_LOOP:  
*            MOVE.W  (A0)+,D1             ; Leer coordenada X del segmento actual
*            MOVE.W  (A1)+,D2             ; Leer coordenada Y del segmento actual
*
*            ; Convertir posición de la celda a coordenadas de pantalla
*            JSR     CNVICOOR
*
*            ; Dibujar el segmento actual
*            MOVE.B  #87,D0
*            MOVE.W  D1,D3
*            ADD.W   #SIZECLDA,D3
*            MOVE.W  D2,D4
*            ADD.W   #SIZECLDA,D4
*            TRAP    #15
*
*            ; Decrementar el contador y continuar
*            SUBQ.W  #1, D5
*            BNE     PLOT_LOOP


*
*FIN_PLOT:
*            MOVEM.L (A7)+,D0-D5
*            RTS

















*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
