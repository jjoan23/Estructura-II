*-----------------------------------------------------------
* MANEJO DE LA CABEZA DE LA SERPIENTE
*-----------------------------------------------------------

; ------------------------------------------------------------------------------
HEADINIT
; INICIALIZAR CABEZA.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            MOVE.W  #PANWIDTH/2,(CBZPOSX)
            MOVE.W  #PANHEIGH/2,(CBZPOSY)
            CLR     (TRZPLOT)
            MOVE.B  #3,(TRZPLOT)
            CLR.W   (ESTDCBZ)
            MOVE.W  #0,(ESTDCBZ)
            RTS
            
; ------------------------------------------------------------------------------
HEADUPD
; ACTUALIZAR CABEZA.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------

            MOVEM.W D0-D2,-(A7)            ; Guardar registros

*            ; Limpiar registros
*            CLR.W   D0
*            CLR.W   D1
*            CLR.W   D2

            ; Marcar celda actual como vacía
            MOVE.W  (CBZPOSX),D1
            MOVE.W  (CBZPOSY),D2
            JSR     CINDMTRZ
            JSR     RSTCLD               ; RESTAMOS 1 A LA CELDA ACTUAL
            
*            MOVE.W  CBZPOSX,D1
*            MOVE.W  D1,SGMPOSX
*            MOVE.W  CBZPOSY,D2
*            MOVE.W  D2,SGMPOSY
*            JSR     CINDMTRZ
*            JSR     RSTCLD
            
            ;CLR.W   D0
            MOVE.W  (ESTDCBZ),D0
            CMP.W   #0,D0
            BEQ     SIGDER
            CMP.W   #1,D0
            BEQ     SIGARR
            CMP.W   #2,D0
            BEQ     SIGIZQ
            CMP.W   #3,D0
            BEQ     SIGABA

*            ; Marcar celda actual de la cabeza como vacía
*
*            MOVE.W  CBZPOSX, D1
*            MOVE.W  CBZPOSY, D2
*            JSR     CINDMTRZ               ; Obtener índice en D0
*            JSR     MCLDVCIA               ; Marcar celda como vacía

*            ; Leer estado de KBDEDGE y determinar dirección
*            MOVE.B  (KBDEDGE),D0
*            CMP.L   #$FF000000, D0         ; Abajo
*            BEQ     MOVE_DOWN
*            CMP.L   #$00FF0000, D0         ; Izquierda
*            BEQ     MOVE_LEFT
*            CMP.L   #$0000FF00, D0         ; Arriba
*            BEQ     MOVE_UP
*            CMP.L   #$000000FF, D0         ; Derecha
*            BEQ     MOVE_RIGHT

            ; Si no hay dirección válida, salir
            BRA     FIN

SIGDER:
            ADD.W   #CBZVEL, (CBZPOSX)
            BRA     UPDMTRZ

SIGARR:
            SUB.W   #CBZVEL, (CBZPOSY)
            BRA     UPDMTRZ

SIGIZQ:
            SUB.W   #CBZVEL, (CBZPOSX)
            BRA     UPDMTRZ

SIGABA:
            ADD.W   #CBZVEL, (CBZPOSY)

UPDMTRZ:
            ; Convertir posición nueva a índice
            MOVE.W  (CBZPOSX),D1
            MOVE.W  (CBZPOSY),D2
            JSR     CINDMTRZ

            ; Verificar colisiones
            JSR     CHECKCLD
            CMP.W   #0,D0                 ; Si celda está libre
            BEQ     MARKCLD
            BRA     GAMEOVER              ; Colisión consigo misma

MARKCLD:
            ; Marcar nueva posición como ocupada por la cabeza
            JSR     CBZOCPD
            BRA     FIN

GAMEOVER:
            ; Implementar lógica de fin de juego
            ; Por ahora, simplemente retornar
            BRA     FIN

FIN:
            MOVEM.W (A7)+,D0-D2            ; Restaurar registros

    RTS
            
; ------------------------------------------------------------------------------
HEADPLOT
; DIBUJAR CABEZA.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
                       
            MOVE.W  D0,-(A7)               ; GUARDAMOS D0
            MOVE.W  D3,D0                  ; PONEMOS EL INDICE DE LA CELDA EN D0 PARA CALCULAR SUS COORDENADAS
            JSR     CNVICOOR
            MOVE.L  D1,-(A7)
            
            ; SET COLOR DEL CONTORNO CABEZA
            MOVE.B  #80,D0
            MOVE.L  #CBZPCOL,D1
            TRAP    #15
            
            ; SET COLOR DEL RELLENO CABEZA
            MOVE.B  #81,D0
            MOVE.L  #CBZFCOL,D1
            TRAP    #15
            
            ; DIBUJAR CABEZA
            MOVE.B  #87,D0
            MOVE.L  (A7)+,D1
            MOVE.W  D3,-(A7)
            MOVE.W  D1,D3
            ADD.W   #CBZWIDTH,D3
            MOVE.W  D2,D4
            ADD.W   #CBZHEIGH,D4
            TRAP    #15
            
            MOVE.L  D1,-(A7)
            
            ; SET COLOR DEL CONTORNO OJO
            MOVE.B  #80,D0
            MOVE.L  #OJOPCOL,D1
            TRAP    #15
            
            ; SET COLOR DEL RELLENO OJO
            MOVE.B  #81,D0
            MOVE.L  #OJOFCOL,D1
            TRAP    #15
            
            ; DIBUJAR OJO
            MOVE.B  #88,D0
            MOVE.L  (A7)+,D1
            MOVE.L  D1,-(A7)
            MOVE.L  D2,-(A7)
            ADD.W   #OJOWIDTH,D1            
            MOVE.W  D1,D3
            ADD.W   #OJOWIDTH/2,D3
            ADD.W   #OJOHEIGH/4,D2
            MOVE.W  D2,D4
            ADD.W   #OJOHEIGH/2,D4
            TRAP    #15                     ; DIBUJAMOS EL PRIMER OJO
            ADD.W   #OJOHEIGH,D2
            MOVE.W  D2,D4
            ADD.W   #OJOHEIGH/2,D4
            TRAP    #15                     ; Y EL SEGUNDO

            

            ; DEFINIR COORDENADAS IRIS
            MOVE.L  (A7)+,D2
            MOVE.L  (A7)+,D1
            ADD.W   #OJOWIDTH,D1
            ADD.W   #OJOWIDTH/3,D1
            ADD.W   #OJOHEIGH/4,D2
            ADD.W   #OJOHEIGH/4,D2
            MOVE.B  #82,D0
            TRAP    #15                     ; DIBUJAMOS EL PRIMER IRIS
            
           
            ADD.W   #OJOHEIGH,D2
            ADD.W   #1,D2
            TRAP    #15                     ; DIBUJAMOS EL SEGUNDO IRIS
            
            
            MOVE.W  (A7)+,D3
            MOVE.W  (A7)+,D0


            RTS


























*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
