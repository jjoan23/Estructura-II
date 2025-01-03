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
            MOVE.W  (SGMPOSX),(SGMPOSX2)
            MOVE.W  (SGMPOSY),(SGMPOSY2)
            SUB.W   #SGMWIDTH,(SGMPOSX2)
            RTS
            
; ------------------------------------------------------------------------------
SEGUPD
; ACTUALIZAR SEGMENTO.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------

            MOVEM.W D1-D2,-(A7)
            
            ; Marcar posici�n anterior del segmento como vac�a
            MOVE.W  (SGMPOSX),D1             ; Cargar posici�n X actual del segmento2
            MOVE.W  (SGMPOSY),D2             ; Cargar posici�n Y actual del segmento2
            JSR     CINDMTRZ                ; Obtener �ndice de celda en D0
            JSR     MCLDVCIA                ; Marcar celda como vac�a
            
            ; Marcar posici�n anterior del segmento como vac�a
            MOVE.W  (SGMPOSX2),D1             ; Cargar posici�n X actual del segmento2
            MOVE.W  (SGMPOSY2),D2             ; Cargar posici�n Y actual del segmento2
            JSR     CINDMTRZ                ; Obtener �ndice de celda en D0
            JSR     MCLDVCIA                ; Marcar celda como vac�a
            
            ; Actualizar posici�n del segmento para seguir a la cabeza
            MOVE.W  (SGMPOSX),(SGMPOSX2)    ; MARCAMOS LOS SEGMENTOS COMO SEGUNDA COORDENADA X
            MOVE.W  (SGMPOSY),(SGMPOSY2)    ; MARCAMOS LOS SEGMENTOS COMO SEGUNDA COORDENADA Y
            MOVE.W  (CBZPOSX),(SGMPOSX)        ; Actualizar X del segmento con la X de la cabeza
            MOVE.W  (CBZPOSY),(SGMPOSY)        ; Actualizar Y del segmento con la Y de la cabeza

            ; Marcar nueva posici�n del segmento como ocupada
            MOVE.W  (SGMPOSX),D1             ; Cargar nueva posici�n X
            MOVE.W  (SGMPOSY),D2             ; Cargar nueva posici�n Y
            JSR     CINDMTRZ                ; Obtener �ndice de celda en D0
            JSR     SGMOCPD                 ; Marcar celda como ocupada por segmento
            
            MOVE.W  (SGMPOSX2),D1             ; Cargar nueva posici�n X DEL SEGMENTO 2
            MOVE.W  (SGMPOSY2),D2             ; Cargar nueva posici�n Y DEL SEGMENTO 2
            JSR     CINDMTRZ                ; Obtener �ndice de celda en D0
            JSR     SGMOCPD                 ; Marcar celda como ocupada por segmento
            
            MOVEM.W (A7)+,D1-D2            
            RTS
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

*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
