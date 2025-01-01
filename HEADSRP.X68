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

            MOVEM.W D0-D2/D7,-(A7)

            ; Marcar celda actual como vacía
            MOVE.W  (CBZPOSX),D1
            MOVE.W  (CBZPOSY),D2
            JSR     CINDMTRZ
            JSR     MCLDVCIA
            
            ; Actualiza la posición de la cabeza según ESTDCBZ
            MOVE.W  (ESTDCBZ),D0
            CMP.W   #0,D0
            BEQ     SIGDER
            CMP.W   #1,D0
            BEQ     SIGARR
            CMP.W   #2,D0
            BEQ     SIGIZQ
            CMP.W   #3,D0
            BEQ     SIGABA

            ; Si no hay dirección válida, sale
            BRA     FIN

SIGDER:
            ADD.W   #CBZVEL,(CBZPOSX)
            BRA     CHKBORDE

SIGARR:
            SUB.W   #CBZVEL,(CBZPOSY)
            BRA     CHKBORDE

SIGIZQ:
            SUB.W   #CBZVEL,(CBZPOSX)
            BRA     CHKBORDE

SIGABA:
            ADD.W   #CBZVEL,(CBZPOSY)
            
CHKBORDE:
            ; Verificar colisiones con los bordes
            MOVE.W  (CBZPOSX),D1
            CMP.W   #PANWIDTH,D1                 ; Si CBZPOSX < 0
            BGT     GAMEOVER
            CMP.W   #0,D1          ; Si CBZPOSX >= PANWIDTH
            BLT     GAMEOVER

            MOVE.W  (CBZPOSY),D1
            CMP.W   #0,D1                 ; Si CBZPOSY < 0
            BLT     GAMEOVER
            CMP.W   #PANHEIGH,D1          ; Si CBZPOSY >= PANHEIGH
            BGT     GAMEOVER

            ;BRA     FIN
            
CHKCOL:
            ; Verifica la colisión con la manzana
            MOVE.W  (CBZPOSX),D1
            MOVE.W  (CBZPOSY),D2
            CMP.W   (MNZPOSX),D1
            BNE     NOCOL
            CMP.W   (MNZPOSY),D2
            BNE     NOCOL
            
            ; Colisión detectada
            JSR     APPLEUPD
            JSR     SCOUPD
            MOVE.B  #SNDEAT,D7
            TRAP    #SNDPLTN

NOCOL:
            ; Convierte la posición nueva a índice
            MOVE.W  (CBZPOSX),D1
            MOVE.W  (CBZPOSY),D2
            JSR     CINDMTRZ
            JSR     CBZOCPD                 ; Marca la celda como ocupada
            
            BRA     FIN

*            ; Verificar colisiones
*            JSR     CHECKCLD
*            CMP.W   #0,D0                 ; Si celda está libre
*            BEQ     MARKCLD
*            BRA     GAMEOVER              ; Colisión consigo misma

*
*MARKCLD:
*            ; Marcar nueva posición como ocupada por la cabeza
*            JSR     CBZOCPD
*            BRA     FIN
*
GAMEOVER:
            MOVE.B  #SNDGMOV,D7             ;PONER SONIDO GAME OVER
            TRAP    #SNDPLTN
            MOVE.W  #3,(STANEXT)

FIN:
            MOVEM.W (A7)+,D0-D2/D7

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
            ADD.W   #OJOWIDTH/2,D1            
            MOVE.W  D1,D3
            ADD.W   #OJOWIDTH,D3
            ADD.W   #OJOHEIGH/2,D2
            MOVE.W  D2,D4
            ADD.W   #OJOHEIGH,D4
            TRAP    #15                     ; DIBUJAMOS EL PRIMER OJO
            

            ; DEFINIR COORDENADAS IRIS
            MOVE.L  (A7)+,D2
            MOVE.L  (A7)+,D1
            ADD.W   #OJOWIDTH,D1
            ADD.W   #OJOHEIGH,D2
            MOVE.B  #82,D0
            TRAP    #15                     ; DIBUJAMOS EL PRIMER IRIS
            
            MOVE.W  (A7)+,D3
            MOVE.W  (A7)+,D0

            RTS





*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
