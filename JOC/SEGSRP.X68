*-----------------------------------------------------------------------------
* MANEJO DEL SEGMENTO DE LA SERPIENTE
*-----------------------------------------------------------------------------

; ----------------------------------------------------------------------------
SEGINIT
; Inicializa los dos segmentos
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ----------------------------------------------------------------------------
            MOVE.W  #(PANWIDTH/2)-CBZWIDTH,(SGMPOSX)
            MOVE.W  #PANHEIGH/2,(SGMPOSY)
            MOVE.W  (SGMPOSX),(SGMPOSX2)
            MOVE.W  (SGMPOSY),(SGMPOSY2)
            SUB.W   #SGMWIDTH,(SGMPOSX2)
            RTS
            
; ----------------------------------------------------------------------------
SEGUPD
; ACTUALIZAR SEGMENTO.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : Posiciones de los segmentos
; ----------------------------------------------------------------------------

            MOVEM.W D1-D2,-(A7)
            
            ; Marca la posici�n anterior del segmento como vac�a
            MOVE.W  (SGMPOSX),D1	; Posici�n X actual del segmento2
            MOVE.W  (SGMPOSY),D2            ; Posici�n Y actual del segmento2
            JSR     CINDMTRZ                ; Obtiene el �ndice de celda en D0
            JSR     MCLDVCIA                ; Marca celda como vac�a
            
            ; Marca la posici�n anterior del segmento2 como vac�a
            MOVE.W  (SGMPOSX2),D1           ; Posici�n X actual del segmento2
            MOVE.W  (SGMPOSY2),D2           ; Posici�n Y actual del segmento2
            JSR     CINDMTRZ                ; Obtiene el �ndice de celda en D0
            JSR     MCLDVCIA                ; Marca celda como vac�a
            
            ; Actualiza la posici�n del segmento para seguir a la cabeza
            MOVE.W  (SGMPOSX),(SGMPOSX2)
            MOVE.W  (SGMPOSY),(SGMPOSY2)
            MOVE.W  (CBZPOSX),(SGMPOSX)
            MOVE.W  (CBZPOSY),(SGMPOSY)

            ; Marca la nueva posici�n del segmento como ocupada
            MOVE.W  (SGMPOSX),D1            ; Carga nueva posici�n X
            MOVE.W  (SGMPOSY),D2            ; Carga nueva posici�n Y
            JSR     CINDMTRZ                ; Obtiene el �ndice de celda en D0
            JSR     SGMOCPD
            
            MOVE.W  (SGMPOSX2),D1	; Carga nueva posici�n X del segm2
            MOVE.W  (SGMPOSY2),D2           ; Carga nueva posici�n Y del segm2
            JSR     CINDMTRZ                ; Obtiene �ndice de celda en D0
            JSR     SGMOCPD
            
            MOVEM.W (A7)+,D1-D2            
            RTS
         
            
; ----------------------------------------------------------------------------
SEGPLOT
; Dibuja los segmentos
; INPUT    : NONE 
; OUTPUT   : Segmentos de la serpiente
; MODIFIES : NONE
; ----------------------------------------------------------------------------
            MOVE.W  D0,-(A7)
            MOVE.W  D3,D0
            JSR     CNVICOOR
            MOVE.L  D1,-(A7)
            
            MOVE.B  #80,D0
            MOVE.L  #SGMPCOL,D1            ; Ponemos el color de dibujado
            TRAP    #15
            
            MOVE.B  #81,D0
            MOVE.L  #SGMFCOL,D1            ; Ponemos el color de dibujado
            TRAP    #15
            
            MOVE.B  #87,D0
            MOVE.L  (A7)+,D1
            MOVE.W  D3,-(A7)
            MOVE.W  D1,D3
            ADD.W   #SIZECLDA,D3
            MOVE.W  D2,D4                   ; Dibujamos el cuadrado
            ADD.W   #SIZECLDA,D4
            TRAP    #15                     
                        
            MOVE.W  (A7)+,D3  
            MOVE.W  (A7)+,D0

            RTS



*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
