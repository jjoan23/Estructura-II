*-----------------------------------------------------------
* MANEJO DEL SEGMENTO DE LA SERPIENTE
*-----------------------------------------------------------

; ------------------------------------------------------------------------------
SEGINIT
; INICIALIZAR SEGMENTO.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            MOVE.W  #(PANWIDTH/2)-CBZWIDTH,(SGMPOSX)
            MOVE.W  #PANHEIGH/2,(SGMPOSY)
            RTS
            
; ------------------------------------------------------------------------------
SEGUPD
; ACTUALIZAR SEGMENTO.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------

            MOVEM.W D1-D2,-(A7)
            
            ; Marcar posición anterior del segmento como vacía
            MOVE.W  (SGMPOSX),D1             ; Cargar posición X actual del segmento
            MOVE.W  (SGMPOSY),D2             ; Cargar posición Y actual del segmento
            JSR     CINDMTRZ                ; Obtener índice de celda en D0
            JSR     MCLDVCIA                ; Marcar celda como vacía
            
            ; Actualizar posición del segmento para seguir a la cabeza
            MOVE.W  (CBZPOSX),(SGMPOSX)        ; Actualizar X del segmento con la X de la cabeza
            MOVE.W  (CBZPOSY),(SGMPOSY)        ; Actualizar Y del segmento con la Y de la cabeza

            ; Marcar nueva posición del segmento como ocupada
            MOVE.W  (SGMPOSX),D1             ; Cargar nueva posición X
            MOVE.W  (SGMPOSY),D2             ; Cargar nueva posición Y
            JSR     CINDMTRZ                ; Obtener índice de celda en D0
            JSR     SGMOCPD                 ; Marcar celda como ocupada por segmento
            
            MOVEM.W (A7)+,D1-D2            
            RTS

 ;INTENTO DE AUMENTO SERPIENTE
*            MOVEM.L D0-D2/A0,-(A7)
*
*            MOVE.W  #MAXSEGMENTS-1,D0   ; Número máximo de segmentos - 1
*            LEA     SEGMENTS,A0         ; Apunta al inicio del array de segmentos
*
*
*UPD_LOOP:
*            ; Mover posición del segmento N-1 al segmento N
*            MOVE.W  (A0),D1             ; Carga X del segmento actual
*            MOVE.W  2(A0),D2            ; Carga Y del segmento actual
*            MOVE.W  D1,4(A0)            ; Copia X al siguiente segmento
*            MOVE.W  D2,6(A0)            ; Copia Y al siguiente segmento
*
*            ; Avanza al siguiente segmento
*            ADDQ.L  #4,A0               ; Mueve el puntero al siguiente par X,Y
*            SUBQ.W  #1,D0               ; Decrementa contador de segmentos
*            BPL     UPD_LOOP             ; Si D0 >= 0, sigue iterando
*
*            ; Actualizar la cabeza con la posición actual
*            MOVE.W  CBZPOSX,(SEGMENTS)  ; Actualiza X de la cabeza
*            MOVE.W  CBZPOSY,2(SEGMENTS) ; Actualiza Y de la cabeza
*
*            MOVEM.L (A7)+,D0-D2/A0
*            RTS


*            
;CODIGO ANTIGUO
*            MOVE.W  SGMPOSX,D1
*            MOVE.W  D1,COLPOSX
*            MOVE.W  SGMPOSY,D2
*            MOVE.W  D2,COLPOSY
*            JSR     CINDMTRZ
*            JSR     RSTCLD
            
            
            
; ------------------------------------------------------------------------------
SEGPLOT
; DIBUJAR SEGMENTO.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            MOVE.W  D0,-(A7)
            MOVE.W  D3,D0
            JSR     CNVICOOR
            MOVE.L  D1,-(A7)
            
            MOVE.B  #80,D0
            MOVE.L  #SGMPCOL,D1            ; PONEMOS EL COLOR DE DIBUJADO AL COLOR DEL CONTORNO DEL SEGMENTO
            TRAP    #15
            
            MOVE.B  #81,D0
            MOVE.L  #SGMFCOL,D1            ; PONEMOS EL COLOR DE DIBUJADO AL COLOR DEL RELLENO DEL SEGMENTO
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

            RTS
            
*; ------------------------------------------------------------------------------
*SEADD
*; DIBUJAR SEGMENTO.
*; INPUT    : NONE 
*; OUTPUT   : NONE
*; MODIFIES : NONE
*; ------------------------------------------------------------------------------            
*            
*            MOVEM.L D0-D2/A0,-(A7)
*
*            ; Asegurar que no se exceda el tamaño máximo
*            MOVE.W  (SEGCOUNT),D0
*            CMP.W   #MAXSEG,D0
*            BGE     FINSEGADD
*
*            ; Obtener posición actual de la cola
*            LEA     SEGMENTS,A0
*            MOVE.W  (COLPOSX),(A0,D0*4)    ; Guardar X
*            MOVE.W  (COLPOSY),2(A0,D0*4)  ; Guardar Y
*
*            ; Incrementar contador de segmentos
*            ADDQ.W  #1,(SEGCOUNT)
*
*FINSEGADD:
*            MOVEM.L (A7)+,D0-D2/A0
*            RTS












*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
